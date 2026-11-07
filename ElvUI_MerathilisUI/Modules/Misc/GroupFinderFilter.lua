local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_GroupFinder")

if E.Forever then
	return
end

local pairs, pcall, tonumber, tostring, type = pairs, pcall, tonumber, tostring, type
local strfind, strlower, strsub = strfind, strlower, strsub

-------------------------------------------------------------------------------
--  Filter expressions for the Premade Groups list, for example
--      healer = 0 and score >= 2500 and (hasbl or myclass = 0)
--  Groups that do not match are dimmed, the list itself stays untouched.
--
--  Our own small language, compiled into closures: nothing typed in ever runs
--  as Lua. Every value is a number, true is 1 and false is 0.
--    or  and  not            logic (also || && !)
--    = == != ~= < <= > >=    comparisons
--    + - * /  ( )            arithmetic
-------------------------------------------------------------------------------

-- Word -> field of the values table (module:FilterValues)
local WORDS = {
	tanks = "tanks",
	tank = "tanks",
	healers = "healers",
	healer = "healers",
	dps = "dps",
	members = "members",
	tankopen = "tankopen",
	healeropen = "healeropen",
	dpsopen = "dpsopen",
	score = "score",
	ilvl = "ilvl",
	age = "age",
	friends = "friends",
	voice = "voice",
	hasbl = "hasbl",
	hasbr = "hasbr",
	myclass = "myclass",
}

local CLASS_WORDS = {
	warrior = "WARRIOR",
	paladin = "PALADIN",
	hunter = "HUNTER",
	rogue = "ROGUE",
	priest = "PRIEST",
	deathknight = "DEATHKNIGHT",
	dk = "DEATHKNIGHT",
	shaman = "SHAMAN",
	mage = "MAGE",
	warlock = "WARLOCK",
	monk = "MONK",
	druid = "DRUID",
	demonhunter = "DEMONHUNTER",
	dh = "DEMONHUNTER",
	evoker = "EVOKER",
}
for word, class in pairs(CLASS_WORDS) do
	WORDS[word] = class
end
module.FilterWords = WORDS

local TWO_CHAR = {
	["<="] = "<=",
	[">="] = ">=",
	["=="] = "==",
	["~="] = "!=",
	["!="] = "!=",
	["&&"] = "and",
	["||"] = "or",
}
local ONE_CHAR = {
	["+"] = "+",
	["-"] = "-",
	["*"] = "*",
	["/"] = "/",
	["("] = "(",
	[")"] = ")",
	["<"] = "<",
	[">"] = ">",
	["="] = "==",
	["!"] = "not",
}
local KEYWORDS = { ["and"] = "and", ["or"] = "or", ["not"] = "not" }

-- Text -> list of { kind = "num" | "word" | operator, value }
local function Tokenize(text)
	local tokens, pos, length = {}, 1, #text
	while pos <= length do
		local c = strsub(text, pos, pos)
		if strfind(c, "%s") then
			pos = pos + 1
		elseif strfind(c, "%d") or (c == "." and strfind(strsub(text, pos + 1, pos + 1), "%d")) then
			local _, last = strfind(text, "^[%d%.]+", pos)
			local number = tonumber(strsub(text, pos, last))
			if not number then
				return nil, strsub(text, pos, last)
			end
			tokens[#tokens + 1] = { kind = "num", value = number }
			pos = last + 1
		elseif strfind(c, "[%a_]") then
			local _, last = strfind(text, "^[%w_]+", pos)
			local word = strlower(strsub(text, pos, last))
			if KEYWORDS[word] then
				tokens[#tokens + 1] = { kind = KEYWORDS[word] }
			elseif WORDS[word] then
				tokens[#tokens + 1] = { kind = "word", value = WORDS[word] }
			else
				return nil, strsub(text, pos, last)
			end
			pos = last + 1
		else
			local two = TWO_CHAR[strsub(text, pos, pos + 1)]
			if two then
				tokens[#tokens + 1] = { kind = two }
				pos = pos + 2
			elseif ONE_CHAR[c] then
				tokens[#tokens + 1] = { kind = ONE_CHAR[c] }
				pos = pos + 1
			else
				return nil, c
			end
		end
	end
	return tokens
end

local function Bool(value)
	return value and 1 or 0
end

local COMPARE = {
	["=="] = function(a, b)
		return Bool(a == b)
	end,
	["!="] = function(a, b)
		return Bool(a ~= b)
	end,
	["<"] = function(a, b)
		return Bool(a < b)
	end,
	["<="] = function(a, b)
		return Bool(a <= b)
	end,
	[">"] = function(a, b)
		return Bool(a > b)
	end,
	[">="] = function(a, b)
		return Bool(a >= b)
	end,
}

local ARITHMETIC = {
	["+"] = function(a, b)
		return a + b
	end,
	["-"] = function(a, b)
		return a - b
	end,
	["*"] = function(a, b)
		return a * b
	end,
	["/"] = function(a, b)
		return b ~= 0 and a / b or 0
	end,
}

-- Recursive descent, one function per precedence level, low to high:
-- or, and, not, comparison, + -, * /, unary minus, number / word / ( )
local function Parse(tokens)
	local pos = 1

	local function Peek()
		local token = tokens[pos]
		return token and token.kind
	end

	local function Take()
		pos = pos + 1
		return tokens[pos - 1]
	end

	local Or

	local function Primary()
		local token = Take()
		if not token then
			error("end", 0)
		end
		if token.kind == "num" then
			local value = token.value
			return function()
				return value
			end
		elseif token.kind == "word" then
			local field = token.value
			return function(values)
				return values[field] or 0
			end
		elseif token.kind == "(" then
			local inner = Or()
			if Peek() ~= ")" then
				error(")", 0)
			end
			Take()
			return inner
		end
		error(token.kind, 0)
	end

	local function Unary()
		if Peek() == "-" then
			Take()
			local operand = Unary()
			return function(values)
				return -operand(values)
			end
		end
		return Primary()
	end

	local function Level(next, operators)
		return function()
			local left = next()
			while operators[Peek() or ""] do
				local apply = operators[Take().kind]
				local a, b = left, next()
				left = function(values)
					return apply(a(values), b(values))
				end
			end
			return left
		end
	end

	local Product = Level(Unary, { ["*"] = ARITHMETIC["*"], ["/"] = ARITHMETIC["/"] })
	local Sum = Level(Product, { ["+"] = ARITHMETIC["+"], ["-"] = ARITHMETIC["-"] })
	local Comparison = Level(Sum, COMPARE)

	local function Not()
		if Peek() == "not" then
			Take()
			local operand = Not()
			return function(values)
				return Bool(operand(values) == 0)
			end
		end
		return Comparison()
	end

	local function And()
		local left = Not()
		while Peek() == "and" do
			Take()
			local a, b = left, Not()
			left = function(values)
				return Bool(a(values) ~= 0 and b(values) ~= 0)
			end
		end
		return left
	end

	function Or()
		local left = And()
		while Peek() == "or" do
			Take()
			local a, b = left, And()
			left = function(values)
				return Bool(a(values) ~= 0 or b(values) ~= 0)
			end
		end
		return left
	end

	local root = Or()
	if pos <= #tokens then
		local extra = tokens[pos]
		error(extra.kind == "num" and tostring(extra.value) or extra.kind, 0)
	end
	return root
end

---Compiles a filter expression. Returns the test function (values -> true when
---the group matches), or nil and the text that could not be read.
---@param text string
function module:CompileFilter(text)
	if type(text) ~= "string" or not strfind(text, "%S") then
		return nil
	end

	local tokens, bad = Tokenize(text)
	if not tokens then
		return nil, bad
	end

	local ok, result = pcall(Parse, tokens)
	if not ok then
		return nil, result == "end" and L["end of the expression"] or result
	end
	return function(values)
		return result(values) ~= 0
	end
end
