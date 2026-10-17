local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles") ---@class Profiles
local Splash = MER:GetModule("MER_SplashScreen") ---@class SplashScreen

local ipairs, type = ipairs, type

-- Every WindTools font table, so all modules share our primary font instead of WT's mixed defaults
local profileFonts = {
	"combat.combatAlert.font",
	"item.extraItemsBar.bar1.countFont",
	"item.extraItemsBar.bar1.bindFont",
	"item.extraItemsBar.bar2.countFont",
	"item.extraItemsBar.bar2.bindFont",
	"item.extraItemsBar.bar3.countFont",
	"item.extraItemsBar.bar3.bindFont",
	"item.extraItemsBar.bar4.countFont",
	"item.extraItemsBar.bar4.bindFont",
	"item.extraItemsBar.bar5.countFont",
	"item.extraItemsBar.bar5.bindFont",
	"item.inspect.gemIcon.craftingTier",
	"item.inspect.enchantIcon.craftingTier",
	"item.inspect.slotText",
	"item.inspect.levelText",
	"item.inspect.itemNameText",
	"item.inspect.statistics.text",
	"item.itemLevel.flyout.font",
	"item.itemLevel.scrappingMachine.font",
	"maps.eventTracker.font",
	"misc.gameBar.time.font",
	"misc.gameBar.time.systemInfoFont",
	"misc.gameBar.additionalText.font",
	"quest.switchButtons.font",
	"quest.preyHunt.progressWidget.stageText",
	"quest.preyHunt.progressWidget.vignetteText",
	"social.chatBar.font",
	"social.friendList.nameFont",
	"social.friendList.infoFont",
}

local privateFonts = {
	"maps.instanceDifficulty.font",
	"maps.superTracker.distanceText",
	"misc.lfgList.partyKeystone.font",
	"quest.objectiveTracker.header",
	"quest.objectiveTracker.title",
	"quest.objectiveTracker.info",
	"quest.objectiveTracker.menuTitle.font",
	"skins.bigWigsSkin.queueTimer.countDown",
	"skins.ime.label",
	"skins.ime.candidate",
	"skins.actionStatus",
	"skins.widgets.button.text.font",
	"skins.widgets.tab.text.font",
	"skins.widgets.treeGroupButton.text.font",
	"skins.cooldownViewer.essential.chargeCountText",
	"skins.cooldownViewer.utility.chargeCountText",
	"skins.cooldownViewer.buffIcon.chargeCountText",
	"skins.lossOfControl.abilityName.font",
	"skins.lossOfControl.timeLeft.font",
	"skins.damageMeter.bar.font.name",
	"skins.damageMeter.bar.font.value",
}

-- Skips paths the installed WindTools version doesn't have (older builds, Forever)
local function setFonts(dbRef, paths, font)
	for _, path in ipairs(paths) do
		local fontDB = F.GetDBFromPath(path, dbRef)
		if type(fontDB) == "table" then
			fontDB.name = font
		end
	end
end

function module:LoadWindToolsProfile()
	local db = E.db.WT
	local private = E.private.WT
	local global = E.global.WT

	if not db or not private or not global then
		return
	end

	db.combat.combatAlert.animation = false
	db.combat.combatAlert.enable = true
	db.combat.combatAlert.text = true
	db.combat.raidMarkers.enable = false
	db.combat.damageMeterLayout.enable = false
	db.combat.damageMeterLayout.width = 338
	db.combat.damageMeterLayout.height = 160
	db.combat.damageMeterLayout.layouts[1].outerPadding = 1
	db.item.alreadyKnown.enable = true
	db.item.extraItemsBar.bar1.backdropSpacing = 1
	db.item.extraItemsBar.bar1.buttonHeight = 26
	db.item.extraItemsBar.bar1.buttonWidth = 30
	db.item.extraItemsBar.bar1.buttonsPerRow = 10
	db.item.extraItemsBar.bar1.numButtons = 10
	db.item.extraItemsBar.bar2.backdropSpacing = 1
	db.item.extraItemsBar.bar2.buttonHeight = 26
	db.item.extraItemsBar.bar2.buttonWidth = 30
	db.item.extraItemsBar.bar2.buttonsPerRow = 10
	db.item.extraItemsBar.bar2.numButtons = 10
	db.item.extraItemsBar.bar3.backdropSpacing = 1
	db.item.extraItemsBar.bar3.buttonHeight = 26
	db.item.extraItemsBar.bar3.buttonWidth = 30
	db.item.extraItemsBar.bar3.buttonsPerRow = 10
	db.item.extraItemsBar.bar3.numButtons = 10
	db.item.fastLoot.enable = false
	db.maps.rectangleMinimap.enable = true
	db.maps.rectangleMinimap.heightPercentage = 0.7
	db.misc.automation.enable = true
	db.misc.automation.hideBagAfterEnteringCombat = true
	db.misc.automation.hideWorldMapAfterEnteringCombat = true
	db.misc.gameBar.enable = true
	db.misc.gameBar.hearthstone.left = "RANDOM"
	db.misc.gameBar.timeAreaWidth = 95
	db.misc.gameBar.timeAreaHeight = 40
	db.misc.gameBar.buttonSize = 22
	db.misc.spellActivationAlert.enable = true
	db.quest.turnIn.enable = false
	db.social.chatText.removeBrackets = true
	db.social.chatText.roleIconStyle = "LYNUI"
	db.tooltips.groupInfo.enable = false
	db.unitFrames.absorb.enable = true

	private.item.extendMerchantPages.enable = true
	private.maps.instanceDifficulty.difficulty.custom = true
	private.maps.instanceDifficulty.enable = true
	private.maps.instanceDifficulty.font.style = "SHADOWOUTLINE"
	-- MerathilisUI collects the addon buttons itself (Minimap Buttons > Addon Buttons).
	private.maps.minimapButtons.enable = false
	private.maps.superTracker.enable = true
	private.misc.autoToggleChatBubble = false
	private.quest.objectiveTracker.enable = true
	private.quest.objectiveTracker.header.uppercase = true
	private.quest.objectiveTracker.info.size = 11
	private.quest.objectiveTracker.info.style = "SHADOWOUTLINE"
	private.quest.objectiveTracker.poiButton.enable = true
	private.skins.widgets.button.enable = true
	private.skins.widgets.checkBox.enable = true
	private.skins.widgets.tab.enable = true
	private.skins.widgets.treeGroupButton.enable = true
	private.skins.lossOfControl.backdrop.useCustomColor = true
	private.skins.lossOfControl.backdrop.r = F.r
	private.skins.lossOfControl.backdrop.b = F.b
	private.skins.lossOfControl.backdrop.g = F.g
	private.unitFrames.roleIcon.roleIconStyle = "LYNUI"

	global.core.loginMessage = false

	local font = F.FontOverride(I.Fonts.Primary)
	setFonts(db, profileFonts, font)
	setFonts(private, privateFonts, font)

	if not E.db.movers then
		E.db.movers = {}
	end

	E.db.movers["WTExtraItemsBar1Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-12,214"
	E.db.movers["WTExtraItemsBar2Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-12,247"
	E.db.movers["WTExtraItemsBar3Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-12,279"
	E.db.movers["WTExtraItemsBar4Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-263,321"
	E.db.movers["WTExtraItemsBar5Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-260,363"
	E.db.movers["WTInstanceDifficultyFrameMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-197,-43"
	E.db.movers["WTCombatAlertFrameMover"] = "TOP,ElvUIParent,TOP,0,-300"
	E.db.movers["WTDamageMeterLayoutMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,47"
	E.db.movers["WTChatBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,40,196"
end

function module:ApplyWindToolsProfile()
	Splash:Wrap("Applying WindTools Profile ...", function()
		self:LoadWindToolsProfile()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			Splash:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "ElvUI_WindTools")
end
