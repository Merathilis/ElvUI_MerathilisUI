local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_NameHover")

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
	return math.floor(x * 255 + 0.5)
end

function module:GetTextWithColor(text, color)
	local r = clamp255(color and color.r or 1)
	local g = clamp255(color and color.g or 1)
	local b = clamp255(color and color.b or 1)

	return string.format("|cFF%02x%02x%02x%s |r", r, g, b, text)
end

function module:CombineTables(table1, table2)
	if not table1 or type(table1) ~= "table" then
		table1 = {}
	end
	if not table2 or type(table2) ~= "table" then
		return table1
	end
	for _, value in ipairs(table2) do
		table.insert(table1, value)
	end
	return table1
end

function module:GetNpcID(unit)
	local guid = UnitGUID(unit or "npc")
	return tonumber(E:NotSecretValue(guid) and guid or "") and select(6, strsplit("-", guid))
end

function module:GetTooltipData()
	local tooltipLines = {}
	if not UnitIsPlayer("mouseover") then
		for i = 1, GameTooltip:NumLines() do
			local fs = _G["GameTooltipTextLeft" .. i]
			if fs and fs.GetText then
				local line = fs:GetText()
				if line then
					table.insert(tooltipLines, line)
				end
			end
		end
	end
	return tooltipLines
end

function module:GetTopMouseFocusName()
	if type(GetMouseFoci) == "function" then
		local foci = GetMouseFoci()
		if foci and foci[1] and foci[1].GetName then
			return foci[1]:GetName()
		end
	end
	return nil
end

function module:IsInTooltip(tooltipLines, query)
	if not tooltipLines or type(tooltipLines) ~= "table" then
		return false
	end
	if not query or type(query) ~= "string" or query == "" then
		return false
	end
	local q = string.lower(query)
	for _, line in ipairs(tooltipLines) do
		if string.find(string.lower(line or ""), q, 1, true) then
			return true
		end
	end
	return false
end
