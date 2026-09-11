local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_NameHover")

local select, tonumber, tostring, type = select, tonumber, tostring, type
local strsplit = strsplit
local find, format, lower = string.find, string.format, string.lower
local floor = math.floor
local tinsert, tconcat = table.insert, table.concat

local GetMouseFoci = GetMouseFoci
local UnitIsPlayer = UnitIsPlayer
local UnitGUID = UnitGUID
local C_StringUtil_WrapString = C_StringUtil.WrapString

local _combineBuf = {}

local function clamp255(x)
	if type(x) ~= "number" then
		return 255
	end
	if x < 0 then
		return 0
	end
	if x > 1 then
		x = 1
	end
	return floor(x * 255 + 0.5)
end

function module:IsNotEmpty(val)
	return val ~= nil and E:NotSecretValue(val) and val ~= ""
end

function module:GetTextWithColor(text, color)
	local r = clamp255(color and color.r or 1)
	local g = clamp255(color and color.g or 1)
	local b = clamp255(color and color.b or 1)

	if E:IsSecretValue(text) then
		-- text can't be read/formatted (e.g. anonymized in Mythic+); wrap it with the
		-- color codes via the secret-safe string API instead of string.format
		return C_StringUtil_WrapString(text, format("|cFF%02x%02x%02x", r, g, b), " |r")
	end

	return format("|cFF%02x%02x%02x%s |r", r, g, b, text)
end

function module:CombineText(...)
	local combined = nil
	for i = 1, select("#", ...) do
		local v = select(i, ...)
		if self:IsNotEmpty(v) then
			local s = tostring(v)
			if combined then
				combined = combined .. " " .. s
			else
				combined = s
			end
		end
	end
	return combined
end

function module:CombineTables(table1, table2)
	if not table1 or type(table1) ~= "table" then
		table1 = {}
	end
	if not table2 or type(table2) ~= "table" then
		return table1
	end
	for i = 1, #table2 do
		tinsert(table1, table2[i])
	end
	return table1
end

function module:GetNpcID(unit)
	local guid = UnitGUID(unit or "npc")
	if not (E:NotSecretValue(guid) and guid) then
		return nil
	end
	return tonumber((select(6, strsplit("-", guid))))
end

function module:GetTooltipData()
	local tooltipLines = {}
	local isPlayer = UnitIsPlayer("mouseover")
	if E:NotSecretValue(isPlayer) and isPlayer then
		return tooltipLines
	end

	local num = GameTooltip:NumLines()
	for i = 1, num do
		local fs = _G["GameTooltipTextLeft" .. i]
		if fs and fs.GetText then
			local line = fs:GetText()
			if line then
				tooltipLines[#tooltipLines + 1] = line
			end
		end
	end
	return tooltipLines
end

function module:GetTopMouseFocus()
	if type(GetMouseFoci) ~= "function" then
		return nil
	end
	local foci = GetMouseFoci()
	return foci and foci[1] or nil
end

function module:GetTopMouseFocusName()
	local focus = self:GetTopMouseFocus()
	if focus and focus.GetName then
		return focus:GetName()
	end
	return nil
end

function module:IsInTooltip(tooltipLines, query)
	if not tooltipLines or type(tooltipLines) ~= "table" or #tooltipLines == 0 then
		return false
	end
	if not query or type(query) ~= "string" or query == "" then
		return false
	end

	local q = lower(query)
	for i = 1, #tooltipLines do
		local line = tooltipLines[i]
		local toFind = line
		if E:NotSecretValue(line) and line then
			toFind = lower(line)
		end
		if find(toFind or "", q, 1, true) then
			return true
		end
	end
	return false
end
