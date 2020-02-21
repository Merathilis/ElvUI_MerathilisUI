local MER, E, L, V, P, G = unpack(select(2, ...))
local ElvUF = ElvUI.oUF
assert(ElvUF, "ElvUI was unable to locate oUF.")
local Translit = E.Libs.Translit
local translitMark = "!"

-- Credits Blazeflack (CustomTags)

-- Cache global variables
local abs, ceil = math.abs, ceil
local format, match, sub, gsub = string.format, string.match, string.sub, string.gsub
local strfind, strlower, strmatch, strsub, strsplit, utf8lower, utf8sub, utf8len = strfind, strlower, strmatch, strsub, strsplit, string.utf8lower, string.utf8sub, string.utf8len
local assert, tonumber, type = assert, tonumber, type
local gmatch, gsub = gmatch, gsub
-- WoW API / Variables
local UnitIsDead = UnitIsDead
local UnitClass = UnitClass
local UnitIsGhost = UnitIsGhost
local UnitIsConnected = UnitIsConnected
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax
local UnitName = UnitName
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

local function shortenNumber(number)
	if type(number) ~= "number" then
		number = tonumber(number)
	end

	if not number then
		return
	end

	local affixes = {"", "k", "m", "B",}

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

ElvUF.Tags.Events['mUI-name:health:abbrev'] = 'UNIT_NAME_UPDATE UNIT_FACTION UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH'
ElvUF.Tags.Methods['mUI-name:health:abbrev'] = function(unit, _, args)
	local name = UnitName(unit)
	if not name then return '' else
		name = E.TagFunctions.Abbrev(name)
	end

	local min, max, bco, fco = UnitHealth(unit), UnitHealthMax(unit), strsplit(':', args or '')
	local to = ceil(utf8len(name) * (min / max))

	local fill = E.TagFunctions.NameHealthColor(_TAGS, fco, unit, '|cFFff3333')
	local base = E.TagFunctions.NameHealthColor(_TAGS, bco, unit, '|cFFffffff')

	return to > 0 and (base..utf8sub(name, 0, to)..fill..utf8sub(name, to+1, -1)) or fill..name
end

-- Displays current power and 0 when no power instead of hiding when at 0, Also formats it like HP tag
ElvUF.Tags.Events["power:current-mUI"] = "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER"
ElvUF.Tags.Methods["power:current-mUI"] = function(unit)
	local CurrentPower = UnitPower(unit)
	local String

	if CurrentPower	> 0 then
		String = shortenNumber(CurrentPower)
	else
		return nil
	end
	return String
end

ElvUF.Tags.Events["mUI-resting"] = "PLAYER_UPDATE_RESTING"
ElvUF.Tags.Methods["mUI-resting"] = function(unit)
	if(unit == "player" and IsResting()) then
		return "zZz"
	else
		return nil
	end
end

local function abbrev(name)
	local letters, lastWord = '', strmatch(name, '.+%s(.+)$')
	if lastWord then
		for word in gmatch(name, '.-%s') do
			local firstLetter = utf8sub(gsub(word, '^[%s%p]*', ''), 1, 1)
			if firstLetter ~= utf8lower(firstLetter) then
				letters = format('%s%s. ', letters, firstLetter)
			end
		end
		name = format('%s%s', letters, lastWord)
	end
	return name
end

ElvUF.Tags.Events['name:abbrev-translit'] = 'UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT'
ElvUF.Tags.Methods['name:abbrev-translit'] = function(unit)
	local name = Translit:Transliterate(UnitName(unit), translitMark)

	if name and strfind(name, '%s') then
		name = abbrev(name)
	end

	return name ~= nil and E:ShortenString(name, 20) or '' --The value 20 controls how many characters are allowed in the name before it gets truncated. Change it to fit your needs.
end

E:AddTagInfo("health:current-mUI", "MerathilisUI", "Displays current HP (2.04B, 2.04M, 204k, 204)")
E:AddTagInfo("power:current-mUI", "MerathilisUI", "Displays current power and 0 when no power instead of hiding when at 0, Also formats it like HP tag")
E:AddTagInfo("mUI-resting", "MerathilisUI", "Displays a text if the player is in a resting area = zZz")
E:AddTagInfo("name:abbrev-translit", "MerathilisUI", "Displays a shorten name and will convert cyrillics. Игорь = !Igor")
