local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_NameHover")

local function IsPlayer(unittype)
	return UnitIsPlayer(unittype or "mouseover")
end

function module:GetUnitNameColor(unittype)
	local reaction = UnitReaction(unittype, "player") or 5

	if UnitIsPlayer(unittype) then
		local _, class = UnitClass(unittype)
		return RAID_CLASS_COLORS[class]
	elseif UnitCanAttack("player", unittype) then
		if UnitIsDead(unittype) then
			return module.COLOR_DEAD
		else
			if reaction < 4 then
				return module.COLOR_HOSTILE
			elseif reaction == 4 then
				return module.COLOR_NEUTRAL
			end
		end
	else
		if reaction < 4 then
			return module.COLOR_HOSTILE_UNATTACKABLE
		else
			return module.COLOR_DEFAULT
		end
	end
end

function module:GetLevelText()
	local isPlayer = IsPlayer()
	if isPlayer and not E.db.mui.nameHover.level then
		return ""
	end
	if not isPlayer and not E.db.mui.nameHover.level then
		return ""
	end

	local level = UnitLevel("mouseover")
	if level and level > 1 then
		local levelString = tostring(level)
		return module:GetTextWithColor(levelString, GetQuestDifficultyColor(level))
	else
		return ""
	end
end

function module:GetTargetText()
	local isPlayer = IsPlayer()
	if isPlayer and not E.db.mui.nameHover.targettarget then
		return ""
	end
	if not isPlayer and not E.db.mui.nameHover.targettarget then
		return ""
	end
	local target = UnitName("mouseovertarget")
	if target then
		return module:GetTextWithColor(">", module.COLOR_DEFAULT)
			.. module:GetTextWithColor(target, module:GetUnitNameColor("mouseovertarget"))
	else
		return ""
	end
end

function module:GetStatusText(fakeAfk, fakeDnd, fakePvp)
	if not IsPlayer() or not E.db.mui.nameHover.status then
		return nil
	end

	local afkText = nil
	local dndText = nil
	local pvpText = nil

	if UnitIsAFK("mouseover") or fakeAfk then
		afkText = module:GetTextWithColor("<AFK>", module.COLOR_DEAD)
	end
	if UnitIsDND("mouseover") or fakeDnd then
		dndText = module:GetTextWithColor("<DND>", module.COLOR_HOSTILE)
	end
	if (UnitIsPVP("mouseover") and UnitIsPlayer("mouseover")) or fakePvp then
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
	else
		return nil
	end
end

function module:GetGuildText()
	if not IsPlayer() then
		return nil
	end
	if not E.db.mui.nameHover.guildName and not E.db.mui.nameHover.guildRank then
		return nil
	end

	local guildName, guildRank = GetGuildInfo("mouseover")
	if not guildName then
		return nil
	end

	local text = ""
	if E.db.mui.nameHover.guildName then
		text = text .. "<" .. module:GetTextWithColor(guildName, module.COLOR_GUILD) .. ">"
	end
	if E.db.mui.nameHover.guildRank and guildRank and guildRank ~= "" then
		if text ~= "" then
			text = text .. " "
		end
		text = text .. "[" .. module:GetTextWithColor(guildRank, module.COLOR_GUILD) .. "]"
	end

	if text == "" then
		return nil
	end
	return text
end

function module:GetFactionText()
	local isPlayer = IsPlayer()
	if isPlayer and not E.db.mui.nameHover.faction then
		return nil
	end
	if not isPlayer and not E.db.mui.nameHover.faction then
		return nil
	end

	local factionLabel, faction = UnitFactionGroup("mouseover")
	if factionLabel then
		if faction == "Horde" then
			return module:GetTextWithColor(factionLabel, module.COLOR_HORDE)
		elseif faction == "Alliance" then
			return module:GetTextWithColor(factionLabel, module.COLOR_ALLIANCE)
		else
			return module:GetTextWithColor(factionLabel, module.COLOR_NEUTRAL)
		end
	else
		return nil
	end
end

function module:GetRaceText()
	if not IsPlayer() or not E.db.mui.nameHover.race then
		return nil
	end

	local race = UnitRace("mouseover")
	if race then
		return module:GetTextWithColor(race, module.COLOR_DEFAULT)
	else
		return nil
	end
end

function module:GetCreatureType()
	if IsPlayer() or not E.db.mui.nameHover.classification then
		return nil
	end

	local t = UnitCreatureType("mouseover")
	if t and not issecretvalue(t) and t ~= "Not specified" then
		return module:GetTextWithColor(t, module.COLOR_DEFAULT)
	else
		return nil
	end
end
