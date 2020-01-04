local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("muiCVars")

-- Cache global variables
-- Lua functions
local _G = _G
local tonumber = tonumber
-- WoW API / Variable
local GetCVar = GetCVar
-- GLOBALS:

-- CREDITS: ElvUI_LIVVENUI

function module:LoadCVar()
	-- General
	if GetCVar("alwaysCompareItems") == "0" then
		E.db.mui.cvars.general.alwaysCompareItems = false
	else
		E.db.mui.cvars.general.alwaysCompareItems = true
	end

	if GetCVar("breakUpLargeNumbers") == "0" then
		E.db.mui.cvars.general.breakUpLargeNumbers = false
	else
		E.db.mui.cvars.general.breakUpLargeNumbers = true
	end

	if GetCVar("scriptErrors") == "0" then
		E.db.mui.cvars.general.scriptErrors = false
	else
		E.db.mui.cvars.general.scriptErrors = true
	end

	E.db.mui.cvars.general.trackQuestSorting = GetCVar("trackQuestSorting")

	--Combat Text
	E.db.mui.cvars.combatText.WorldTextScale = tonumber(GetCVar("WorldTextScale"))

	--targetCombatText
	if GetCVar("floatingCombatTextCombatDamage") == "0" then
		E.db.mui.cvars.combatText.targetCombatText.floatingCombatTextCombatDamage = false
	else
		E.db.mui.cvars.combatText.targetCombatText.floatingCombatTextCombatDamage = true
	end

	if GetCVar("floatingCombatTextCombatLogPeriodicSpells") == "0" then
		E.db.mui.cvars.combatText.targetCombatText.floatingCombatTextCombatLogPeriodicSpells = false
	else
		E.db.mui.cvars.combatText.targetCombatText.floatingCombatTextCombatLogPeriodicSpells = true
	end

	if GetCVar("floatingCombatTextPetMeleeDamage") == "0" then
		E.db.mui.cvars.combatText.targetCombatText.floatingCombatTextPetMeleeDamage = false
	else
		E.db.mui.cvars.combatText.targetCombatText.floatingCombatTextPetMeleeDamage = true
	end
	if GetCVar("floatingCombatTextPetSpellDamage") == "0" then
		E.db.mui.cvars.combatText.targetCombatText.floatingCombatTextPetSpellDamage = false
	else
		E.db.mui.cvars.combatText.targetCombatText.floatingCombatTextPetSpellDamage = true
	end

	E.db.mui.cvars.combatText.targetCombatText.floatingCombatTextCombatDamageDirectionalScale = tonumber(GetCVar("floatingCombatTextCombatDamageDirectionalScale"))

	if GetCVar("floatingCombatTextCombatHealing") == "0" then
		E.db.mui.cvars.combatText.targetCombatText.floatingCombatTextCombatHealing = false
	else
		E.db.mui.cvars.combatText.targetCombatText.floatingCombatTextCombatHealing = true
	end

	if GetCVar("floatingCombatTextCombatHealingAbsorbTarget") == "0" then
		E.db.mui.cvars.combatText.targetCombatText.floatingCombatTextCombatHealingAbsorbTarget = false
	else
		E.db.mui.cvars.combatText.targetCombatText.floatingCombatTextCombatHealingAbsorbTarget = true
	end

	if GetCVar("floatingCombatTextSpellMechanics") == "0" then
		E.db.mui.cvarscombatText.targetCombatText.floatingCombatTextSpellMechanics = false
	else
		E.db.mui.cvars.combatText.targetCombatText.floatingCombatTextSpellMechanics = true
	end

	if GetCVar("floatingCombatTextSpellMechanicsOther") == "0" then
		E.db.mui.cvars.combatText.targetCombatText.floatingCombatTextSpellMechanicsOther = false
	else
		E.db.mui.cvars.combatText.targetCombatText.floatingCombatTextSpellMechanicsOther = true
	end

	--playerCombatText
	if GetCVar("enableFloatingCombatText") == "0" then
		E.db.mui.cvars.combatText.playerCombatText.enableFloatingCombatText = false
	else
		E.db.mui.cvars.combatText.playerCombatText.enableFloatingCombatText = true
	end

	E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextFloatMode = tonumber(GetCVar("floatingCombatTextFloatMode"))

	if GetCVar("floatingCombatTextDodgeParryMiss") == "0" then
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextDodgeParryMiss = false
	else
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextDodgeParryMiss = true
	end

	if GetCVar("floatingCombatTextCombatHealingAbsorbSelf") == "0" then
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextCombatHealingAbsorbSelf = false
	else
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextCombatHealingAbsorbSelf = true
	end

	if GetCVar("floatingCombatTextDamageReduction") == "0" then
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextDamageReduction = false
	else
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextDamageReduction = true
	end

	if GetCVar("floatingCombatTextLowManaHealth") == "0" then
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextLowManaHealth = false
	else
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextLowManaHealth = true
	end

	if GetCVar("floatingCombatTextRepChanges") == "0" then
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextRepChanges = false
	else
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextRepChanges = true
	end

	if GetCVar("floatingCombatTextEnergyGains") == "0" then
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextEnergyGains = false
	else
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextEnergyGains = true
	end

	if GetCVar("floatingCombatTextComboPoints") == "0" then
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextComboPoints = false
	else
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextComboPoints = true
	end

	if GetCVar("floatingCombatTextReactives") == "0" then
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextReactives = false
	else
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextReactives = true
	end

	if GetCVar("floatingCombatTextPeriodicEnergyGains") == "0" then
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextPeriodicEnergyGains = false
	else
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextPeriodicEnergyGains = true
	end

	if GetCVar("floatingCombatTextFriendlyHealers") == "0" then
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextFriendlyHealers = false
	else
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextFriendlyHealers = true
	end

	if GetCVar("floatingCombatTextHonorGains") == "0" then
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextHonorGains = false
	else
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextHonorGains = true
	end

	if GetCVar("floatingCombatTextCombatState") == "0" then
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextCombatState = false
	else
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextCombatState = true
	end

	if GetCVar("floatingCombatTextAuras") == "0" then
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextAuras = false
	else
		E.db.mui.cvars.combatText.playerCombatText.floatingCombatTextAuras = true
	end
end

function module:Initialize()
	local db = E.db.mui.cvars
	MER:RegisterDB(self, "cvars")

	self:LoadCVar()
end

E:RegisterModule(module:GetName())
