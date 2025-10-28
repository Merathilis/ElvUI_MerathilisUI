local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

if not IsAddOnLoaded("ElvUI_WindTools") then
	return
end

function module:LoadWindToolsProfile()
	local db = E.db.WT
	local private = E.private.WT

	if not db or not private then
		return
	end

	db["announcement"]["combatResurrection"]["enable"] = false
	db["announcement"]["dispel"]["onlyInstance"] = false
	db["announcement"]["dispel"]["player"]["enable"] = false
	db["announcement"]["interrupt"]["enable"] = false
	db["announcement"]["interrupt"]["onlyInstance"] = false
	db["announcement"]["interrupt"]["player"]["enable"] = false
	db["announcement"]["taunt"]["others"]["pet"]["enable"] = false
	db["announcement"]["taunt"]["others"]["player"]["enable"] = false
	db["announcement"]["taunt"]["player"]["pet"]["enable"] = false
	db["announcement"]["taunt"]["player"]["player"]["enable"] = false
	db["announcement"]["threatTransfer"]["enable"] = false
	db["announcement"]["threatTransfer"]["onlyNotTank"] = false
	db["combat"]["classHelper"]["deathStrikeEstimator"]["enable"] = true
	db["combat"]["classHelper"]["deathStrikeEstimator"]["hideIfTheBarOutside"] = true
	db["combat"]["classHelper"]["deathStrikeEstimator"]["onlyInCombat"] = true
	db["combat"]["classHelper"]["deathStrikeEstimator"]["sparkTexture"] = true
	db["combat"]["combatAlert"]["animation"] = false
	db["combat"]["combatAlert"]["enable"] = false
	db["combat"]["combatAlert"]["text"] = false
	db["combat"]["raidMarkers"]["enable"] = false
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
	db["maps"]["whoClicked"]["addRealm"] = true
	db["misc"]["automation"]["enable"] = true
	db["misc"]["automation"]["hideBagAfterEnteringCombat"] = true
	db["misc"]["automation"]["hideWorldMapAfterEnteringCombat"] = true
	db["misc"]["cooldownTextOffset"]["enable"] = true
	db["misc"]["gameBar"]["home"]["left"] = "RANDOM"
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
	private["maps"]["superTracker"]["enable"] = false
	private["misc"]["autoToggleChatBubble"] = true
	private["quest"]["objectiveTracker"]["enable"] = true
	private["skins"]["widgets"]["button"]["enable"] = false
	private["skins"]["widgets"]["checkBox"]["enable"] = false
	private["skins"]["widgets"]["tab"]["enable"] = false
	private["skins"]["widgets"]["treeGroupButton"]["enable"] = false
	private["unitFrames"]["roleIcon"]["roleIconStyle"] = "LYNUI"

	if not E.db.movers then
		E.db.movers = {}
	end

	E.db.movers["WTExtraItemsBar1Mover"] = "BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-12,214"
	E.db.movers["WTExtraItemsBar2Mover"] = "BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-12,247"
	E.db.movers["WTExtraItemsBar3Mover"] = "BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-12,279"
	E.db.movers["WTExtraItemsBar4Mover"] = "BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-263,321"
	E.db.movers["WTExtraItemsBar5Mover"] = "BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-260,363"
end

function module:ApplyWindToolsProfile()
	module:Wrap("Applying WindTools Profile ...", function()
		-- Apply Fonts
		self:LoadWindToolsProfile()

		FCT:UpdateUnitFrames()
		FCT:UpdateNamePlates()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			module:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "ElvUI_WindTools")
end
