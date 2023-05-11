local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local ElvUF = E.oUF
assert(ElvUF, "ElvUI was unable to locate oUF.")
local Translit = E.Libs.Translit
local translitMark = "!"

local abs, ceil, type, tonumber = math.abs, ceil, type, tonumber
local format, gsub, gmatch, len = string.format, string.gsub, string.gmatch, string.len
local strfind, strmatch, strsplit, utf8lower, utf8sub, utf8len = strfind, strmatch, strsplit, string.utf8lower, string.utf8sub, string.utf8len

local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost
local UnitIsConnected = UnitIsConnected
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax
local UnitName = UnitName
local UnitPower = UnitPower
local IsResting = IsResting

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
E:AddTag("health:current-mUI", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED", function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
	if (status) then
		return status
	else
		local currentHealth = UnitHealth(unit)
		return shortenNumber(currentHealth)
	end
end)

-- Max Health shorted
E:AddTag("health:max-mUI", 'UNIT_MAXHEALTH', function(unit)
	local maxH = UnitHealthMax(unit)

	return shortenNumber(maxH)
end)

E:AddTag('mUI-name:health:abbrev', 'UNIT_NAME_UPDATE UNIT_FACTION UNIT_HEALTH UNIT_MAXHEALTH', function(unit, _, args)
	local name = UnitName(unit)
	if not name then
		return ''
	else
		name = E.TagFunctions.Abbrev(name)
	end

	local min, max, bco, fco = UnitHealth(unit), UnitHealthMax(unit), strsplit(':', args or '')
	local to = ceil(utf8len(name) * (min / max))

	local fill = E.TagFunctions.NameHealthColor(_TAGS, fco, unit, '|cFFff3333')
	local base = E.TagFunctions.NameHealthColor(_TAGS, bco, unit, '|cFFffffff')

	return to > 0 and (base..utf8sub(name, 0, to)..fill..utf8sub(name, to+1, -1)) or fill..name
end)

-- Displays current power and 0 when no power instead of hiding when at 0, Also formats it like HP tag
E:AddTag("power:current-mUI", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER", function(unit)
	local CurrentPower = UnitPower(unit)
	local String

	if CurrentPower	>= 0 then
		String = shortenNumber(CurrentPower)
	else
		return nil
	end

	return String
end)

E:AddTag("mUI-resting", "PLAYER_UPDATE_RESTING", function(unit)
	if(unit == "player" and IsResting()) then
		return "zZz"
	else
		return nil
	end
end)

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

E:AddTag('name:abbrev-translit', 'UNIT_NAME_UPDATE INSTANCE_ENCOUNTER_ENGAGE_UNIT', function(unit)
	local name = Translit:Transliterate(UnitName(unit), translitMark)

	if name and strfind(name, '%s') then
		name = abbrev(name)
	end

	return name ~= nil and E:ShortenString(name, 20) or '' --The value 20 controls how many characters are allowed in the name before it gets truncated. Change it to fit your needs.
end)

E:AddTag('name:gradient', 'UNIT_NAME_UPDATE', function(unit)
	local name = UnitName(unit)
	local _, unitClass = UnitClass(unit)
	local isTarget = UnitIsUnit(unit, "target") and not unit:match("nameplate") and not unit:match("party")
	if name and len(name) > 10 then
		name = name:gsub('(%S+) ', function(t) return t:utf8sub(1, 1) .. '. ' end)
	end

	if UnitIsPlayer(unit) then
		return F.GradientName(name, unitClass, isTarget)
	elseif not UnitIsPlayer(unit) then
		local reaction = UnitReaction(unit, 'player')
		if reaction then
			if reaction >= 5 then
				return F.GradientName(name, 'NPCFRIENDLY', isTarget)
			elseif reaction == 4 then
				return F.GradientName(name, 'NPCNEUTRAL', isTarget)
			elseif reaction == 3 then
				return F.GradientName(name, 'NPCUNFRIENDLY', isTarget)
			elseif reaction == 2 or reaction == 1 then
				return F.GradientName(name, 'NPCHOSTILE', isTarget)
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

E:AddTagInfo("health:current-mUI", MER.Title, "Displays current HP (2.04B, 2.04M, 204k, 204)")
E:AddTagInfo("power:current-mUI", MER.Title, "Displays current power and 0 when no power instead of hiding when at 0, Also formats it like HP tag")
E:AddTagInfo("mUI-resting", MER.Title, "Displays a text if the player is in a resting area = zZz")
E:AddTagInfo("name:abbrev-translit", MER.Title, "Displays a shorten name and will convert cyrillics. Игорь = !Igor")
E:AddTagInfo("name:gradient", MER.Title, "Displays a shorten name in classcolor or reaction color")
