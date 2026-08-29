local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_NameHover")

local tostring = tostring

local GetQuestDifficultyColor = GetQuestDifficultyColor
local GetGuildInfo = GetGuildInfo
local UnitCanAttack = UnitCanAttack
local UnitClass = UnitClass
local UnitClassification = UnitClassification
local UnitIsDead = UnitIsDead
local UnitIsPlayer = UnitIsPlayer
local UnitLevel = UnitLevel
local UnitReaction = UnitReaction
local UnitIsAFK = UnitIsAFK
local UnitIsDND = UnitIsDND
local UnitIsPVP = UnitIsPVP
local UnitFactionGroup = UnitFactionGroup
local UnitRace = UnitRace
local UnitCreatureType = UnitCreatureType
local UnitName = UnitName
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local function IsPlayer(unit)
	return UnitIsPlayer(unit or "mouseover")
end

function module:GetUnitNameColor(unittype)
	local reaction = UnitReaction(unittype, "player") or 5

	if UnitIsPlayer(unittype) then
		local _, class = UnitClass(unittype)
		if E:NotSecretValue(class) and class then
			return RAID_CLASS_COLORS[class]
		end
	elseif UnitCanAttack("player", unittype) then
		if UnitIsDead(unittype) then
			return module.COLOR_DEAD
		elseif reaction < 4 then
			return module.COLOR_HOSTILE
		elseif reaction == 4 then
			return module.COLOR_NEUTRAL
		end
	else
		if reaction < 4 then
			return module.COLOR_HOSTILE_UNATTACKABLE
		end
		return module.COLOR_DEFAULT
	end
end

function module:GetLevelText()
	local db = E.db.mui.nameHover
	if not db.level then
		return ""
	end

	local level = UnitLevel("mouseover")
	if level and level > 1 then
		return module:GetTextWithColor(tostring(level), GetQuestDifficultyColor(level))
	end
	return ""
end

function module:GetTargetText()
	if not E.db.mui.nameHover.targettarget then
		return ""
	end

	local target = UnitName("mouseovertarget")
	if not target then
		return ""
	end

	return module:GetTextWithColor(">", module.COLOR_DEFAULT)
		.. module:GetTextWithColor(target, module:GetUnitNameColor("mouseovertarget"))
end

function module:GetStatusText()
	if not IsPlayer() or not E.db.mui.nameHover.status then
		return nil
	end

	local afkText, dndText, pvpText
	local afk = UnitIsAFK("mouseover")
	local dnd = UnitIsDND("mouseover")
	local isPvp = UnitIsPVP("mouseover")

	if E:NotSecretValue(afk) and afk then
		afkText = module:GetTextWithColor("<AFK>", module.COLOR_DEAD)
	end
	if E:NotSecretValue(dnd) and dnd then
		dndText = module:GetTextWithColor("<DND>", module.COLOR_HOSTILE)
	end
	if E:NotSecretValue(isPvp) and isPvp then
		pvpText = module:GetTextWithColor("<PVP>", module.COLOR_HOSTILE)
	end

	return module:CombineText(afkText, dndText, pvpText)
end

function module:GetClassificationText()
	if IsPlayer() then
		return nil
	end

	local classification = UnitClassification("mouseover")
	if classification == "worldboss" then
		return module:GetTextWithColor("World Boss", module.COLOR_ELITE)
	elseif classification == "elite" then
		return module:GetTextWithColor("Elite", module.COLOR_ELITE)
	elseif classification == "rareelite" then
		return module:GetTextWithColor("Rare Elite", module.COLOR_RARE)
	elseif classification == "rare" then
		return module:GetTextWithColor("Rare", module.COLOR_RARE)
	end
	return nil
end

function module:GetGuildText()
	local db = E.db.mui.nameHover
	if not IsPlayer() or (not db.guildName and not db.guildRank) then
		return nil
	end

	local guildName, guildRank = GetGuildInfo("mouseover")
	if not guildName then
		return nil
	end

	local text = ""
	if db.guildName then
		text = text .. "<" .. module:GetTextWithColor(guildName, module.COLOR_GUILD) .. ">"
	end
	if db.guildRank and guildRank and guildRank ~= "" then
		if text ~= "" then
			text = text .. " "
		end
		text = text .. "[" .. module:GetTextWithColor(guildRank, module.COLOR_GUILD) .. "]"
	end

	return text ~= "" and text or nil
end

function module:GetFactionText()
	if not E.db.mui.nameHover.faction then
		return nil
	end

	local factionLabel, faction = UnitFactionGroup("mouseover")
	if not factionLabel then
		return nil
	end

	if faction == "Horde" then
		return module:GetTextWithColor(factionLabel, module.COLOR_HORDE)
	elseif faction == "Alliance" then
		return module:GetTextWithColor(factionLabel, module.COLOR_ALLIANCE)
	end
	return module:GetTextWithColor(factionLabel, module.COLOR_NEUTRAL)
end

function module:GetRaceText()
	if not IsPlayer() or not E.db.mui.nameHover.race then
		return nil
	end

	local race = UnitRace("mouseover")
	if race then
		return module:GetTextWithColor(race, module.COLOR_DEFAULT)
	end
	return nil
end

function module:GetCreatureType()
	if IsPlayer() or not E.db.mui.nameHover.classification then
		return nil
	end

	local t = UnitCreatureType("mouseover")
	if t and not issecretvalue(t) and t ~= "Not specified" then
		return module:GetTextWithColor(t, module.COLOR_DEFAULT)
	end
	return nil
end
