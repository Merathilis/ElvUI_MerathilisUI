local MER, E, L, V, P, G = unpack(select(2, ...))
local ElvUF = ElvUI.oUF
assert(ElvUF, "ElvUI was unable to locate oUF.")

-- Credits Blazeflack (CustomTags)

-- Cache global variables
local format, gmatch, match, sub = string.format, string.gmatch, string.match, string.sub
local assert = assert
-- WoW API / Variables
local UnitClass = UnitClass
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax
local UnitName = UnitName

-- GLOBALS: Hex, _COLORS

local textFormatStyles = {
	["CURRENT"] = "%.1f",
	["CURRENT_MAX"] = "%.1f - %.1f",
	["CURRENT_PERCENT"] =  "%.1f - %.1f%%",
	["CURRENT_MAX_PERCENT"] = "%.1f - %.1f | %.1f%%",
	["PERCENT"] = "%.1f%%",
	["DEFICIT"] = "-%.1f"
}

local textFormatStylesNoDecimal = {
	["CURRENT"] = "%s",
	["CURRENT_MAX"] = "%s - %s",
	["CURRENT_PERCENT"] =  "%s - %.0f%%",
	["CURRENT_MAX_PERCENT"] = "%s - %s | %.0f%%",
	["PERCENT"] = "%.0f%%",
	["DEFICIT"] = "-%s"
}

function MER:GetFormattedText(min, max, style, noDecimal)
	assert(textFormatStyles[style] or textFormatStylesNoDecimal[style], "CustomTags Invalid format style: "..style)
	assert(min, "CustomTags - You need to provide a current value. Usage: GetFormattedText(min, max, style, noDecimal)")
	assert(max, "CustomTags - You need to provide a maximum value. Usage: GetFormattedText(min, max, style, noDecimal)")

	if max == 0 then max = 1 end

	local chosenFormat
	if noDecimal then
		chosenFormat = textFormatStylesNoDecimal[style]
	else
		chosenFormat = textFormatStyles[style]
	end

	if style == "DEFICIT" then
		local deficit = max - min
		if deficit <= 0 then
			return ""
		else
			return format(chosenFormat, E:ShortValue(deficit))
		end
	elseif style == "PERCENT" then
		return format(chosenFormat, min / max * 100)
	elseif style == "CURRENT" or ((style == "CURRENT_MAX" or style == "CURRENT_MAX_PERCENT" or style == "CURRENT_PERCENT") and min == max) then
		if noDecimal then
			return format(textFormatStylesNoDecimal["CURRENT"],  E:ShortValue(min))
		else
			return format(textFormatStyles["CURRENT"],  E:ShortValue(min))
		end
	elseif style == "CURRENT_MAX" then
		return format(chosenFormat,  E:ShortValue(min), E:ShortValue(max))
	elseif style == "CURRENT_PERCENT" then
		return format(chosenFormat, E:ShortValue(min), min / max * 100)
	elseif style == "CURRENT_MAX_PERCENT" then
		return format(chosenFormat, E:ShortValue(min), E:ShortValue(max), min / max * 100)
	end
end

ElvUF.Tags.Methods["classcolor:player"] = function()
	local _, unitClass = UnitClass("player")
	local String

	if unitClass then
		String = Hex(_COLORS.class[unitClass])
	else
		String = "|cFFC2C2C2"
	end

	return String
end

ElvUF.Tags.Methods["classcolor:hunter"] = function()
	return Hex(_COLORS.class["HUNTER"])
end

ElvUF.Tags.Methods["classcolor:warrior"] = function()
	return Hex(_COLORS.class["WARRIOR"])
end

ElvUF.Tags.Methods["classcolor:paladin"] = function()
	return Hex(_COLORS.class["PALADIN"])
end

ElvUF.Tags.Methods["classcolor:mage"] = function()
	return Hex(_COLORS.class["MAGE"])
end

ElvUF.Tags.Methods["classcolor:priest"] = function()
	return Hex(_COLORS.class["PRIEST"])
end

ElvUF.Tags.Methods["classcolor:warlock"] = function()
	return Hex(_COLORS.class["WARLOCK"])
end

ElvUF.Tags.Methods["classcolor:shaman"] = function()
	return Hex(_COLORS.class["SHAMAN"])
end

ElvUF.Tags.Methods["classcolor:deathknight"] = function()
	return Hex(_COLORS.class["DEATHKNIGHT"])
end

ElvUF.Tags.Methods["classcolor:druid"] = function()
	return Hex(_COLORS.class["DRUID"])
end

ElvUF.Tags.Methods["classcolor:monk"] = function()
	return Hex(_COLORS.class["MONK"])
end

ElvUF.Tags.Methods["classcolor:rogue"] = function()
	return Hex(_COLORS.class["ROGUE"])
end

ElvUF.Tags.Events["health:percent:hidefull:hidezero"] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION"
ElvUF.Tags.Methods["health:percent:hidefull:hidezero"] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local deficit = max - min
	local String

	if (deficit <= 0) or (min == 0) then
		String = ""
	else
		String = MER:GetFormattedText(min, max, "PERCENT", true)
	end

	return String
end

ElvUF.Tags.Events["health:current:hidefull:hidezero"] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH"
ElvUF.Tags.Methods["health:current:hidefull:hidezero"] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local deficit = max - min
	local String

	if (deficit <= 0) or (min == 0) then
		String = ""
	else
		String = MER:GetFormattedText(min, max, "CURRENT", true)
	end

	return String
end

ElvUF.Tags.Events["health:current-percent:hidefull:hidezero"] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH"
ElvUF.Tags.Methods["health:current-percent:hidefull:hidezero"] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local deficit = max - min
	local String

	if (deficit <= 0) or (min == 0) then
		String = ""
	else
		String = MER:GetFormattedText(min, max, "CURRENT_PERCENT", true)
	end

	return String
end

-- Credits goes to Simpy 
local function abbrev(text)
	local endname = match(text, ".+%s(.+)$")
	if endname then
		local newname = ""
		for k, v in gmatch(text, "%S-%s") do
			newname = newname .. sub(k,1,1) .. ". "
		end
		text = newname .. endname
	end
	return text
end

ElvUF.Tags.Events["name:abbrev"] = "UNIT_NAME_UPDATE"
ElvUF.Tags.Methods["name:abbrev"] = function(unit)
	local name = UnitName(unit)
	name = abbrev(name)

	if name and name:find(" ") then
		name = abbrev(name)
	end

	return name ~= nil and E:ShortenString(name, 20) or "" --The value 20 controls how many characters are allowed in the name before it gets truncated. Change it to fit your needs.
end