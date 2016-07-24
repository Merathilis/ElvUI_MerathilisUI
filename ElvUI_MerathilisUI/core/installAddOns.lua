local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
-- Lua functions
local format = string.format
local tonumber = tonumber
-- WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded
local GetAddOnMetadata = GetAddOnMetadata

-- GLOBALS: SkadaDB, InstallStepComplete, titleText

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
local skadaName = GetAddOnMetadata('Skada', 'Title')

function MER:SetupMERAddons()
	-- Skada Profile
	if IsAddOnLoaded('Skada') then
		MER:Print(format(L[' - %s profile created!'], skadaName))
		SkadaDB['profiles']['MerathilisUI'] = {
			["windows"] = {
				{
					["titleset"] = false,
					["barheight"] = 16,
					["classicons"] = true,
					["roleicons"] = false,
					["barslocked"] = true,
					["background"] = {
						["height"] = 146,
					},
					["y"] = 23.0000915527344,
					["barfont"] = "Merathilis Tukui",
					["name"] = "DPS",
					["barfontflags"] = "OUTLINE",
					["point"] = "TOPRIGHT",
					["barbgcolor"] = {
						["a"] = 0,
						["r"] = 0.301960784313726,
						["g"] = 0.301960784313726,
						["b"] = 0.301960784313726,
					},
					["mode"] = "Schaden",
					["enabletitle"] = false,
					["spark"] = false,
					["bartexture"] = "MerathilisFlat",
					["barwidth"] = 165.999954223633,
					["barspacing"] = 2,
					["barcolor"] = {
						["a"] = 0,
						["g"] = 0.301960784313726,
						["r"] = 0.301960784313726,
					},
					["barfontsize"] = 12,
					["title"] = {
						["color"] = {
							["a"] = 0,
							["b"] = 0.301960784313726,
							["g"] = 0.101960784313725,
							["r"] = 0.101960784313725,
						},
						["font"] = "Merathilis Prototype",
						["borderthickness"] = 0,
						["fontsize"] = 10,
						["fontflags"] = "OUTLINE",
						["texture"] = "MerathilisFlat",
					},
					["x"] = 1567.99992370605,
				}, -- [1]
				{
					["barheight"] = 16,
					["classicons"] = true,
					["barslocked"] = true,
					["enabletitle"] = false,
					["wipemode"] = "",
					["set"] = "current",
					["hidden"] = false,
					["y"] = 23.0000915527344,
					["barfont"] = "Merathilis Tukui",
					["name"] = "HPS",
					["display"] = "bar",
					["barfontflags"] = "OUTLINE",
					["classcolortext"] = false,
					["scale"] = 1,
					["reversegrowth"] = false,
					["barfontsize"] = 12,
					["roleicons"] = false,
					["barorientation"] = 1,
					["snapto"] = true,
					["x"] = 1739.00001525879,
					["mode"] = "Heilung",
					["returnaftercombat"] = false,
					["spark"] = false,
					["buttons"] = {
						["segment"] = true,
						["menu"] = true,
						["stop"] = false,
						["mode"] = true,
						["report"] = true,
						["reset"] = true,
					},
					["barwidth"] = 170.999984741211,
					["barspacing"] = 2,
					["modeincombat"] = "",
					["point"] = "TOPRIGHT",
					["barbgcolor"] = {
						["a"] = 0,
						["r"] = 0.301960784313726,
						["g"] = 0.301960784313726,
						["b"] = 0.301960784313726,
					},
					["barcolor"] = {
						["a"] = 0,
						["r"] = 0.301960784313726,
						["g"] = 0.301960784313726,
						["b"] = 0.8,
					},
					["background"] = {
						["borderthickness"] = 0,
						["height"] = 146,
						["color"] = {
							["a"] = 0.2,
							["b"] = 0.5,
							["g"] = 0,
							["r"] = 0,
						},
						["bordertexture"] = "None",
						["margin"] = 0,
						["texture"] = "Solid",
					},
					["classcolorbars"] = true,
					["clickthrough"] = false,
					["bartexture"] = "MerathilisFlat",
					["title"] = {
						["color"] = {
							["a"] = 0.800000011920929,
							["r"] = 0.101960784313725,
							["g"] = 0.101960784313725,
							["b"] = 0.301960784313726,
						},
						["bordertexture"] = "None",
						["font"] = "Merathilis Prototype",
						["borderthickness"] = 0,
						["fontsize"] = 10,
						["fontflags"] = "OUTLINE",
						["height"] = 15,
						["margin"] = 0,
						["texture"] = "MerathilisFlat",
					},
					["version"] = 1,
				}, -- [2]
			},
			["icon"] = {
				["hide"] = true,
			},
			["columns"] = {
				["Heilung_Percent"] = false,
				["Schaden_Damage"] = true,
				["Schaden_DPS"] = true,
				["Schaden_Percent"] = false,
			},
		}
	end

	-- AddOnSkins
	if E.private['addonskins'] == nil then E.private['addonskins'] = {} end
	if IsAddOnLoaded('AddOnSkins') then
		E.private['addonskins']['LoginMsg'] = false
		E.private['addonskins']['EmbedSystemDual'] = true
		E.private['addonskins']['EmbedBelowTop'] = false
		E.private['addonskins']['TransparentEmbed'] = true
		E.private['addonskins']['EmbedRightChat'] = true
		E.private['addonskins']['SkadaBackdrop'] = false
		E.private['addonskins']['EmbedMain'] = 'Skada'
		E.private['addonskins']['EmbedLeft'] = 'Skada'
		E.private['addonskins']['EmbedRight'] = 'Skada'
		E.private['addonskins']['EmbedLeftWidth'] = 170
		E.private['addonskins']['ParchmentRemover'] = false
		E.private['addonskins']['WeakAuraBar'] = true
		E.private['addonskins']['WeakAuraIconCooldown'] = true
		E.private['addonskins']['BigWigsHalfBar'] = false
		E.private['addonskins']['CliqueSkin'] = true
		E.private['addonskins']['SkinTemplate'] = 'Transparent'
		E.private['addonskins']['SkinDebug'] = true
		E.private['addonskins']['Blizzard_ExtraActionButton'] = false
		E.private['addonskins']['Blizzard_DraenorAbilityButton'] = false
		E.private['addonskins']['Blizzard_WorldStateCaptureBar'] = true
	end

	-- BenikUI
	if E.db['benikui'] == nil then E.db['benikui'] = {} end
	if IsAddOnLoaded('ElvUI_BenikUI') then
		E.db['benikui']['general']['loginMessage'] = false
		E.db['benikui']['general']['splashScreen'] = false
		E.db['benikui']['colors']['gameMenuColor'] = 1
		E.db['benikui']['misc']['ilevel']['enable'] = false
		E.db['benikui']['datatexts']['chat']['enable'] = true
		E.db['benikui']['datatexts']['chat']['transparent'] = true
		E.db['benikui']['datatexts']['chat']['editBoxPosition'] = 'BELOW_CHAT'
		E.db['benikui']['datatexts']['chat']['styled'] = false
		E.db['benikui']['datatexts']['chat']['backdrop'] = true
		E.db['benikui']['datatexts']['middle']['enable'] = false
		E.db['benikui']['datatexts']['middle']['transparent'] = true
		E.db['benikui']['datatexts']['middle']['backdrop'] = true
		E.db['benikui']['datatexts']['middle']['width'] = 412
		E.db['benikui']['datatexts']['middle']['height'] = 19
		E.db['benikui']['datatexts']['middle']['styled'] = true
		E.db['benikui']['datatexts']['mail']['toggle'] = true
		E.db['benikui']['datatexts']['garrison']['currency'] = true
		E.db['benikui']['datatexts']['garrison']['oil'] = true
		E.db['benikuiDatabars']['experience']['notifiers']['enable'] = false
		E.db['benikuiDatabars']['reputation']['notifiers']['enable'] = false
		E.db['benikuiDatabars']['artifact']['notifiers']['enable'] = false
		E.db['benikui']['unitframes']['misc']['svui'] = true
		E.db['benikui']['unitframes']['textures']['power'] = "MerathilisFlat"
		E.db['benikui']['unitframes']['textures']['health'] = "MerathilisEmpty"
		E.db['benikui']['unitframes']['infoPanel']['fixInfoPanel'] = true
		E.db['benikui']['unitframes']['infoPanel']['texture'] = "MerathilisEmpty"
		E.db['dashboards']['barColor'] = {r = classColor.r, g = classColor.g, b = classColor.b}
		E.db['dashboards']['system']['enableSystem'] = false
		E.db['dashboards']['professions']['enableProfessions'] = false
		E.db['dashboards']['tokens']['enableTokens'] = false
		E.db['dashboards']['tokens']['tooltip'] = false
		E.db['dashboards']['tokens']['flash'] = false
		E.db['dashboards']['tokens']['width'] = 130
		E.db['dashboards']['tokens']['combat'] = true
		E.db["movers"]["BuiMiddleDtMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,2"
		E.db["movers"]["tokenHolderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-3,-164"
		E.db["movers"]["BuiDashboardMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-8"
	end

	-- ElvUI_SLE
	-- This needs to be redone!!
	if E.db.sle == nil then E.db.sle = {} end
	if IsAddOnLoaded("ElvUI_SLE") then
		if tonumber(GetAddOnMetadata("ElvUI_SLE", "Version")) >= 3.00 then
			E.db["sle"]["raidmarkers"]["enable"] = false
			E.db["sle"]["media"]["fonts"]["gossip"]["font"] = "Merathilis Roboto-Black"
			E.db["sle"]["media"]["fonts"]["gossip"]["size"] = 11
			E.db["sle"]["media"]["fonts"]["editbox"]["font"] = "Merathilis Roboto-Black"
			E.db["sle"]["media"]["fonts"]["objective"]["size"] = 10
			E.db["sle"]["media"]["fonts"]["objective"]["font"] = "Merathilis Roboto-Black"
			E.db["sle"]["media"]["fonts"]["zone"]["font"] = "Merathilis Roboto-Black"
			E.db["sle"]["media"]["fonts"]["mail"]["font"] = "Merathilis Roboto-Black"
			E.db["sle"]["media"]["fonts"]["subzone"]["font"] = "Merathilis Roboto-Black"
			E.db["sle"]["media"]["fonts"]["objectiveHeader"]["font"] = "Merathilis Roboto-Black"
			E.db["sle"]["media"]["fonts"]["pvp"]["font"] = "Merathilis Roboto-Black"
			E.db["sle"]["Armory"]["Character"]["Gem"]["SocketSize"] = 15
			E.db["sle"]["Armory"]["Character"]["Durability"]["Display"] = "DamagedOnly"
			E.db["sle"]["Armory"]["Character"]["Durability"]["Font"] = "Merathilis Roboto-Black"
			E.db["sle"]["Armory"]["Character"]["Durability"]["FontSize"] = 11
			E.db["sle"]["Armory"]["Character"]["Level"]["ShowUpgradeLevel"] = true
			E.db["sle"]["Armory"]["Character"]["Level"]["Font"] = "Merathilis Roboto-Black"
			E.db["sle"]["Armory"]["Character"]["Backdrop"]["SelectedBG"] = "HIDE"
			E.db["sle"]["Armory"]["Character"]["Enchant"]["Display"] = "MouseoverOnly"
			E.db["sle"]["Armory"]["Character"]["Enchant"]["FontSize"] = 9
			E.db["sle"]["Armory"]["Character"]["Enchant"]["Font"] = "Merathilis Roboto-Black"
			E.db["sle"]["Armory"]["Character"]["Enchant"]["WarningIconOnly"] = true
			E.db["sle"]["Armory"]["Inspect"]["Enable"] = false
			E.db["sle"]["auras"]["hideDebuffsTimer"] = true
			E.db["sle"]["auras"]["hideBuffsTimer"] = true
			E.db["sle"]["loot"]["autoroll"]["autogreed"] = true
			E.db["sle"]["loot"]["looticons"]["enable"] = true
			E.db["sle"]["loot"]["looticons"]["channels"]["CHAT_MSG_PARTY_LEADER"] = true
			E.db["sle"]["loot"]["looticons"]["channels"]["CHAT_MSG_INSTANCE_CHAT"] = true
			E.db["sle"]["loot"]["looticons"]["channels"]["CHAT_MSG_GUILD"] = true
			E.db["sle"]["loot"]["looticons"]["channels"]["CHAT_MSG_SAY"] = true
			E.db["sle"]["loot"]["looticons"]["channels"]["CHAT_MSG_BN_CONVERSATION"] = true
			E.db["sle"]["loot"]["looticons"]["channels"]["CHAT_MSG_WHISPER"] = true
			E.db["sle"]["loot"]["looticons"]["channels"]["CHAT_MSG_BN_WHISPER"] = true
			E.db["sle"]["loot"]["looticons"]["channels"]["CHAT_MSG_PARTY"] = true
			E.db["sle"]["loot"]["looticons"]["channels"]["CHAT_MSG_INSTANCE_CHAT_LEADER"] = true
			E.db["sle"]["loot"]["looticons"]["channels"]["CHAT_MSG_RAID"] = true
			E.db["sle"]["loot"]["looticons"]["channels"]["CHAT_MSG_OFFICER"] = true
			E.db["sle"]["loot"]["looticons"]["channels"]["CHAT_MSG_RAID_LEADER"] = true
			E.db["sle"]["loot"]["looticons"]["channels"]["CHAT_MSG_YELL"] = true
			E.db["sle"]["loot"]["looticons"]["channels"]["CHAT_MSG_CHANNEL"] = true
			E.db["sle"]["loot"]["looticons"]["channels"]["CHAT_MSG_BN_WHISPER_INFORM"] = true
			E.db["sle"]["loot"]["looticons"]["channels"]["CHAT_MSG_WHISPER_INFORM"] = true
			E.db["sle"]["loot"]["looticons"]["channels"]["CHAT_MSG_RAID_WARNING"] = true
			E.db["sle"]["loot"]["looticons"]["position"] = "RIGHT"
			E.db["sle"]["loot"]["announcer"]["enable"] = true
			E.db["sle"]["loot"]["enable"] = true
			E.db["sle"]["loot"]["history"]["autohide"] = true
			E.db["sle"]["legacy"]["garrison"]["toolbar"]["enable"] = true
			E.db["sle"]["legacy"]["garrison"]["toolbar"]["buttonsize"] = 20
			E.db["sle"]["pvp"]["duels"]["announce"] = true
			E.db["sle"]["pvp"]["duels"]["pet"] = true
			E.db["sle"]["pvp"]["duels"]["regular"] = true
			E.private["sle"]["pvp"]["KBbanner"]["enable"] = true
			E.private["sle"]["pvp"]["KBbanner"]["sound"] = true
			E.db["sle"]["tooltip"]["RaidProg"]["enable"] = true
			E.db["sle"]["tooltip"]["RaidProg"]["DifStyle"] = "LONG"
			E.db["sle"]["chat"]["tab"]["select"] = true
			E.db["sle"]["chat"]["tab"]["style"] = "DEFAULT"
			E.db["sle"]["chat"]["tab"]["color"] = {r = classColor.r, g = classColor.g, b = classColor.b}
			E.private["sle"]["chat"]["BubbleThrottle"] = 0.1
			E.private["sle"]["chat"]["BubbleClass"] = true
			E.db["sle"]["chat"]["textureAlpha"]["enable"] = true
			E.db["sle"]["chat"]["textureAlpha"]["alpha"] = 0.45
			E.db["sle"]["chat"]["dpsSpam"] = true
			E.db["sle"]["blizzard"]["rumouseover"] = true
			E.db["sle"]["misc"]["threat"]["enable"] = true
			E.db["sle"]["blizzard"]["errorframe"]["height"] = 60
			E.db["sle"]["blizzard"]["errorframe"]["width"] = 512
			E.db["sle"]["unitframes"]["roleicons"] = "SupervillainUI"
			E.db["sle"]["unitframes"]["unit"]["raid"]["offline"]["enable"] = true
			E.db["sle"]["unitframes"]["unit"]["raid"]["offline"]["size"] = 22
			E.db["sle"]["unitframes"]["unit"]["player"]["combatico"]["texture"] = "SVUI"
			E.db["sle"]["unitframes"]["unit"]["player"]["combatico"]["red"] = false
			E.db["sle"]["unitframes"]["unit"]["player"]["rested"]["texture"] = "SVUI"
			E.db["sle"]["minimap"]["instance"]["font"] = "Merathilis Roboto-Black"
			E.db["sle"]["minimap"]["coords"]["display"] = "MOUSEOVER"
			E.db["sle"]["minimap"]["coords"]["coordsenable"] = false
			E.db["sle"]["minimap"]["coords"]["decimals"] = false
			E.db["sle"]["minimap"]["coords"]["middle"] = "CENTER"
			E.private["sle"]["minimap"]["buttons"]["enable"] = true
			E.private["sle"]["minimap"]["mapicons"]["enable"] = true
			E.private["sle"]["minimap"]["mapicons"]["barenable"] = true
			E.db["sle"]["minimap"]["mapicons"]["iconsize"] = 20
			E.db["sle"]["minimap"]["mapicons"]["iconmouseover"] = true
			E.db["sle"]["minimap"]["mapicons"]["iconmousover"] = true
			E.db["sle"]["minimap"]["buttons"]["anchor"] = "HORIZONTAL"
			E.db["sle"]["minimap"]["buttons"]["mouseover"] = true
			E.db["sle"]["minimap"]["locPanel"]["enable"] = true
			E.db["sle"]["minimap"]["locPanel"]["display"] = "SHOW"
			E.db["sle"]["minimap"]["locPanel"]["format"] = "%.0f"
			E.db["sle"]["minimap"]["locPanel"]["font"] = "Merathilis Roboto-Black"
			E.db["sle"]["minimap"]["locPanel"]["fontSize"] = 12
			E.db["sle"]["minimap"]["locPanel"]["width"] = 300
			E.db["sle"]["minimap"]["locPanel"]["height"] = 18
			E.db["sle"]["minimap"]["locPanel"]["template"] = "Transparent"
			E.db["sle"]["minimap"]["locPanel"]["colorType"] = "CUSTOM"
			E.db["sle"]["minimap"]["locPanel"]["customColor"] = {r = classColor.r, g = classColor.g, b = classColor.b}
			E.db["sle"]["minimap"]["locPanel"]["portals"]["enable"] = true
			E.db["sle"]["minimap"]["locPanel"]["portals"]["customWidth"] = true
			E.db["sle"]["minimap"]["locPanel"]["portals"]["customWidthValue"] = 200
			E.db["sle"]["minimap"]["locPanel"]["portals"]["justify"] = "LEFT"
			E.db["sle"]["dt"]["durability"]["threshold"] = 49
			E.db["sle"]["dt"]["durability"]["gradient"] = true
			E.db["sle"]["dt"]["hide_guildname"] = false
			E.db["sle"]["dt"]["guild"]["minimize_gmotd"] = false
			E.db["sle"]["dt"]["guild"]["hide_gmotd"] = true
			E.db["sle"]["dt"]["guild"]["totals"] = false
			E.db["sle"]["dt"]["guild"]["hide_hintline"] = true
			E.db["sle"]["dt"]["friends"]["sortBN"] = "revREALID"
			E.db["sle"]["dt"]["friends"]["expandBNBroadcast"] = true
			E.db["sle"]["dt"]["friends"]["totals"] = false
			E.db["sle"]["dt"]["friends"]["hide_hintline"] = true
			E.db["sle"]["dt"]["currency"]["Unused"] = false
			E.db["sle"]["dt"]["currency"]["PvP"] = false
			E.db["sle"]["dt"]["currency"]["Archaeology"] = false
			E.db["sle"]["dt"]["currency"]["Faction"] = false
			E.db["sle"]["dt"]["currency"]["Jewelcrafting"] = false
			E.db["sle"]["dt"]["currency"]["Raid"] = false
			E.db["sle"]["dt"]["currency"]["Cooking"] = false
			E.db["sle"]["dt"]["currency"]["Miscellaneous"] = false
			E.db["sle"]["dt"]["expandBNBroadcast"] = true
			E.db["sle"]["dt"]["hide_hintline"] = true
			E.db["sle"]["dt"]["mail"]["icon"] = false
			E.db["sle"]["dt"]["hide_gmotd"] = false
			E.db["sle"]["dt"]["totals"] = true
			E.db["sle"]["dt"]["combat"] = false
			E.db["sle"]["uibuttons"]["enable"] = false
			E.db["sle"]["uibuttons"]["point"] = "TOP"
			E.db["sle"]["uibuttons"]["menuBackdrop"] = true
			E.db["sle"]["uibuttons"]["orientation"] = "vertical"
			E.db["sle"]["uibuttons"]["dropdownBackdrop"] = false
			E.db["sle"]["uibuttons"]["menuBackdrop"] = false
			E.db["sle"]["uibuttons"]["spacing"] = 0
			E.db["sle"]["uibuttons"]["anchor"] = "BOTTOM"
			E.db["sle"]["uibuttons"]["point"] = "TOPLEFT"
			E.db["sle"]["uibuttons"]["size"] = 19
			E.private["sle"]["uiButtonStyle"] = "dropdown"
			E.private["sle"]["bags"]["transparentSlots"] = true
			E.private["sle"]["skins"]["objectiveTracker"]["enable"] = false
			E.private["sle"]["skins"]["merchant"]["enable"] = true
			E.private["sle"]["skins"]["merchant"]["subpages"] = 2
			E.private["sle"]["vehicle"]["enable"] = true
			E.private["sle"]["equip"]["enable"] = true
			E.private["sle"]["equip"]["setoverlay"] = true
			E.private["sle"]["professions"]["fishing"]["EasyCast"] = true
			E.private["sle"]["professions"]["fishing"]["FromMount"] = true
			E.private["sle"]["professions"]["deconButton"]["enable"] = false
			E.db["movers"]["SalvageCrateMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,2,-483"
			E.db["movers"]["SquareMinimapBar"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-2,-185"
			E.db["movers"]["SLE_UIButtonsMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,0,-460"
			E.db["movers"]["UIErrorsFrameMover"] = "TOP,ElvUIParent,TOP,0,-195"
			E.db["movers"]["SLE_Location_Mover"] = "TOP,ElvUIParent,TOP,0,-6"
		end
	end

	-- ElvUI_VisualAuraTimer
	if E.db.VAT == nil then E.db.VAT = {} end
	if IsAddOnLoaded('ElvUI_VisualAuraTimers') then
		E.db.VAT.enableStaticColor = true
		E.db.VAT.noDuration = true
		E.db.VAT.barHeight = 5
		E.db.VAT.spacing = -3
		E.db.VAT.staticColor = {r = classColor.r, g = classColor.g, b = classColor.b}
		E.db.VAT.showText = false
		E.db.VAT.decimalThreshold = 5
		E.db.VAT.statusbarTexture = 'MerathilisFlat'
		E.db.VAT.backdropTexture = 'MerathilisFlat'
		E.db.VAT.position = 'TOP'
	end
end