local MER, E, L, V, P, G = unpack(select(2, ...))
local ElvUF = ElvUI.oUF
assert(ElvUF, "ElvUI was unable to locate oUF.")

-- Credits Blazeflack (CustomTags)

-- Cache global variables
local abs = math.abs
local format, match, sub, gsub = string.format, string.match, string.sub, string.gsub
local strfind, strlower, strmatch, strsub = strfind, strlower, strmatch, strsub
local assert, tonumber, type = assert, tonumber, type
local gmatch, gsub = gmatch, gsub
-- WoW API / Variables
local UnitIsDead = UnitIsDead
local UnitClass = UnitClass
local UnitIsGhost = UnitIsGhost
local UnitIsConnected = UnitIsConnected
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax
local UnitName = UnitName
local UnitFactionGroup = UnitFactionGroup
local UnitPower = UnitPower
local IsResting = IsResting

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
			return nil
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

local function shortenNumber(number)
	if type(number) ~= "number" then
		number = tonumber(number)
	end
	if not number then
		return
	end

	local affixes = {
		"",
		"k",
		"m",
		"B",
	}

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

	return format("%."..dec.."f"..affixes[affix], num1)
end

-- Displays current HP --(2.04B, 2.04M, 204k, 204)--
ElvUF.Tags.Events["health:current-mUI"] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
ElvUF.Tags.Methods["health:current-mUI"] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
	if (status) then
		return status
	else
		local currentHealth = UnitHealth(unit)
		return shortenNumber(currentHealth)
	end
end

-- Displays current power and 0 when no power instead of hiding when at 0, Also formats it like HP tag
ElvUF.Tags.Events["power:current-mUI"] = "UNIT_DISPLAYPOWER UNIT_POWER_UPDATE UNIT_POWER_FREQUENT"
ElvUF.Tags.Methods["power:current-mUI"] = function(unit)
	local CurrentPower = UnitPower(unit)
	return shortenNumber(CurrentPower)
end

ElvUF.Tags.Events["mUI-resting"] = "PLAYER_UPDATE_RESTING"
ElvUF.Tags.Methods["mUI-resting"] = function(unit)
	if(unit == "player" and IsResting()) then
		return "zZz"
	else
		return nil
	end
end

ElvUF.Tags.Events["faction:icon"] = "UNIT_NAME_UPDATE"
ElvUF.Tags.Methods["faction:icon"] = function(unit)
	local faction = UnitFactionGroup(unit)
	local str = ""

	if faction == "Alliance" then
		str = "|TInterface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\GameIcons\\Flat\\Alliance:16:16:0:-1|t"
	elseif faction == "Horde" then
		str = "|TInterface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\GameIcons\\Flat\\Horde:16:16:0:-1|t"
	end

	return str
end
