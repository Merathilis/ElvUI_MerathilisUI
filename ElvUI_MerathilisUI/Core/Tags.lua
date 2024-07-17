local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local ElvUF = E.oUF
assert(ElvUF, "ElvUI was unable to locate oUF.")

local abs, type, tonumber = math.abs, type, tonumber
local format, len = string.format, string.len

local UnitName = UnitName
local UnitPower = UnitPower

local function shortenNumber(number)
	if type(number) ~= "number" then
		number = tonumber(number)
	end

	if not number then
		return
	end

	local affixes = { "", "k", "m", "B" }

	local affix = 1
	local dec = 0
	local num1 = abs(number)
	while num1 >= 1000 and affix < #affixes do
		num1 = num1 / 1000
		affix = affix + 1
	end
	if affix > 1 then
		dec = 2
		local num2 = num1
		while num2 >= 10 do
			num2 = num2 / 10
			dec = dec - 1
		end
	end
	if number < 0 then
		num1 = -num1
	end

	return format("%." .. dec .. "f" .. affixes[affix], num1)
end

-- Displays current power and 0 when no power instead of hiding when at 0, Also formats it like HP tag
E:AddTag("power:current-mUI", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER", function(unit)
	local CurrentPower = UnitPower(unit)
	local String

	if CurrentPower >= 0 then
		String = shortenNumber(CurrentPower)
	else
		return nil
	end

	return String
end)

E:AddTag("name:gradient", "UNIT_NAME_UPDATE", function(unit)
	local name = UnitName(unit)
	local _, unitClass = UnitClass(unit)
	local isTarget = UnitIsUnit(unit, "target") and not unit:match("nameplate") and not unit:match("party")
	if name and len(name) > 10 then
		name = name:gsub("(%S+) ", function(t)
			return t:utf8sub(1, 1) .. ". "
		end)
	end

	if UnitIsPlayer(unit) then
		return F.GradientName(name, unitClass, isTarget)
	elseif not UnitIsPlayer(unit) then
		local reaction = UnitReaction(unit, "player")
		if reaction then
			if reaction >= 5 then
				return F.GradientName(name, "NPCFRIENDLY", isTarget)
			elseif reaction == 4 then
				return F.GradientName(name, "NPCNEUTRAL", isTarget)
			elseif reaction == 3 then
				return F.GradientName(name, "NPCUNFRIENDLY", isTarget)
			elseif reaction == 2 or reaction == 1 then
				return F.GradientName(name, "NPCHOSTILE", isTarget)
			end
		end
	end
end)

E:AddTag("name:gradientcustom", "UNIT_NAME_UPDATE", function(unit)
	local name = UnitName(unit)
	local _, unitClass = UnitClass(unit)
	local isTarget = UnitIsUnit(unit, "target") and not unit:match("nameplate") and not unit:match("party")
	if name and len(name) > 10 then
		name = name:gsub("(%S+) ", function(t)
			return t:utf8sub(1, 1) .. ". "
		end)
	end

	if UnitIsPlayer(unit) then
		return F.GradientNameCustom(name, unitClass, isTarget)
	elseif not UnitIsPlayer(unit) then
		local reaction = UnitReaction(unit, "player")
		if reaction then
			if reaction >= 5 then
				return F.GradientNameCustom(name, "NPCFRIENDLY", isTarget)
			elseif reaction == 4 then
				return F.GradientNameCustom(name, "NPCNEUTRAL", isTarget)
			elseif reaction == 3 then
				return F.GradientNameCustom(name, "NPCUNFRIENDLY", isTarget)
			elseif reaction == 2 or reaction == 1 then
				return F.GradientNameCustom(name, "NPCHOSTILE", isTarget)
			end
		end
	end
end)

-- Class Icons
for index, style in pairs(F.GetClassIconStyleList()) do
	E:AddTag("classicon-" .. style, "UNIT_NAME_UPDATE", function(unit)
		local englishClass = select(2, UnitClass(unit))
		return englishClass and F.GetClassIconStringWithStyle(englishClass, style)
	end)
	for i = 1, GetNumClasses() do
		local englishClass = select(2, GetClassInfo(i))
		if englishClass then
			E:AddTag("classicon-" .. style .. ":" .. strlower(englishClass), "UNIT_NAME_UPDATE", function()
				return F.GetClassIconStringWithStyle(englishClass, style)
			end)
		end
	end
end

E:AddTagInfo(
	"power:current-mUI",
	MER.Title,
	"Displays current power and 0 when no power instead of hiding when at 0, Also formats it like HP tag"
)
E:AddTagInfo("name:gradient", MER.Title, "Displays a shorten name in gradient classcolor")
E:AddTagInfo("name:gradientcustom", MER.Title, "Displays a shorten name in custom gradient classcolor")
