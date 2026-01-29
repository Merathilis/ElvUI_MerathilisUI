local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_NameHover")

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
	local level = UnitLevel("mouseover")
	if level and level > 1 then
		return module:GetTextWithColor(tostring(level), GetQuestDifficultyColor(level))
	else
		return ""
	end
end

function module:GetTargetText()
	local target = UnitName("mouseovertarget")
	if E.db.mui.nameHover.targettarget and target then
		return module:GetTextWithColor(">", module.COLOR_DEFAULT)
			.. module:GetTextWithColor(target, module:GetUnitNameColor("mouseovertarget"))
	else
		return ""
	end
end

function module:GetStatusText(fakeAfk, fakeDnd, fakePvp)
	local afkText = ""
	local dndText = ""
	local pvpText = ""

	if UnitIsAFK("mouseover") or fakeAfk then
		afkText = module:GetTextWithColor("<AFK>", module.COLOR_DEAD)
	end
	if UnitIsDND("mouseover") or fakeDnd then
		dndText = module:GetTextWithColor("<DND>", module.COLOR_HOSTILE)
	end
	if (UnitIsPVP("mouseover") and UnitIsPlayer("mouseover")) or fakePvp then
		pvpText = module:GetTextWithColor("<PVP>", module.COLOR_HOSTILE)
	end

	return (afkText .. dndText .. pvpText)
end

function module:GetClassificationText()
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
		return ""
	end
end
