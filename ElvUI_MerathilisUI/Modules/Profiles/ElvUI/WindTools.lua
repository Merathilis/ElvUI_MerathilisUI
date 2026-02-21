local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

if not IsAddOnLoaded("ElvUI_WindTools") then
	return
end

function module:LoadWindToolsProfile()
	local db = E and E.db and E.db.WT
	local private = E and E.private and E.private.WT

	if not db or not private then
		return
	end

	db["combat"]["combatAlert"]["animation"] = false
	db["combat"]["combatAlert"]["enable"] = true
	db["combat"]["combatAlert"]["text"] = true
	db["combat"]["raidMarkers"]["enable"] = false
	db["item"]["alreadyKnown"]["enable"] = true
	db["item"]["extraItemsBar"]["bar1"]["backdropSpacing"] = 1
	db["item"]["extraItemsBar"]["bar1"]["buttonHeight"] = 26
	db["item"]["extraItemsBar"]["bar1"]["buttonWidth"] = 30
	db["item"]["extraItemsBar"]["bar1"]["buttonsPerRow"] = 10
	db["item"]["extraItemsBar"]["bar1"]["numButtons"] = 10
	db["item"]["extraItemsBar"]["bar2"]["backdropSpacing"] = 1
	db["item"]["extraItemsBar"]["bar2"]["buttonHeight"] = 26
	db["item"]["extraItemsBar"]["bar2"]["buttonWidth"] = 30
	db["item"]["extraItemsBar"]["bar2"]["buttonsPerRow"] = 10
	db["item"]["extraItemsBar"]["bar2"]["numButtons"] = 10
	db["item"]["extraItemsBar"]["bar3"]["backdropSpacing"] = 1
	db["item"]["extraItemsBar"]["bar3"]["buttonHeight"] = 26
	db["item"]["extraItemsBar"]["bar3"]["buttonWidth"] = 30
	db["item"]["extraItemsBar"]["bar3"]["buttonsPerRow"] = 10
	db["item"]["extraItemsBar"]["bar3"]["numButtons"] = 10
	db["item"]["fastLoot"]["enable"] = false
	db["maps"]["rectangleMinimap"]["enable"] = true
	db["maps"]["rectangleMinimap"]["heightPercentage"] = 0.7
	db["misc"]["automation"]["enable"] = true
	db["misc"]["automation"]["hideBagAfterEnteringCombat"] = true
	db["misc"]["automation"]["hideWorldMapAfterEnteringCombat"] = true
	db["misc"]["gameBar"]["enable"] = true
	db["misc"]["gameBar"]["hearthstone"]["left"] = "RANDOM"
	db["misc"]["spellActivationAlert"]["enable"] = true
	db["quest"]["turnIn"]["enable"] = false
	db["social"]["chatText"]["removeBrackets"] = true
	db["social"]["chatText"]["roleIconStyle"] = "LYNUI"
	db["tooltips"]["groupInfo"]["enable"] = false
	db["unitFrames"]["absorb"]["enable"] = true

	private["item"]["extendMerchantPages"]["enable"] = true
	private["maps"]["instanceDifficulty"]["difficulty"]["custom"] = true
	private["maps"]["instanceDifficulty"]["enable"] = true
	private["maps"]["instanceDifficulty"]["font"]["style"] = "SHADOWOUTLINE"
	private["maps"]["minimapButtons"]["buttonsPerRow"] = 7
	private["maps"]["minimapButtons"]["mouseOver"] = true
	private["maps"]["superTracker"]["enable"] = true
	private["misc"]["autoToggleChatBubble"] = true
	private["quest"]["objectiveTracker"]["enable"] = true
	private["quest"]["objectiveTracker"]["info"]["size"] = 11
	private["quest"]["objectiveTracker"]["info"]["style"] = "SHADOWOUTLINE"
	private["skins"]["widgets"]["button"]["enable"] = true
	private["skins"]["widgets"]["checkBox"]["enable"] = true
	private["skins"]["widgets"]["tab"]["enable"] = true
	private["skins"]["widgets"]["treeGroupButton"]["enable"] = true
	private["unitFrames"]["roleIcon"]["roleIconStyle"] = "LYNUI"

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
end

function module:ApplyWindToolsProfile()
	module:Wrap("Applying WindTools Profile ...", function()
		-- Apply Fonts
		self:LoadWindToolsProfile()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			module:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "ElvUI_WindTools")
end
