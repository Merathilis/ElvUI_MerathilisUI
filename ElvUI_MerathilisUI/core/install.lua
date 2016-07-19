local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
-- Lua functions
local _G = _G
local print, tonumber, unpack = print, tonumber, unpack
local format = format
local ceil = ceil
-- WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
local factionGroup = UnitFactionGroup("player")

function E:GetColor(r, b, g, a)
	return { r = r, b = b, g = g, a = a }
end

local function SetupMERLayout(layout)
	if not IsAddOnLoaded('ElvUI_BenikUI') then
		E:StaticPopup_Show('BENIKUI')
	end
	
	if E.db["movers"] == nil then E.db["movers"] = {} end
	
	-- General
	E.private["general"]["pixelPerfect"] = true
	E.global["general"]["autoScale"] = true
	E.private["general"]["chatBubbles"] = "nobackdrop"
	E.private["general"]["chatBubbleFont"] = "Merathilis Prototype"
	E.private["general"]["chatBubbleFontSize"] = 11
	E.db["general"]["valuecolor"] = {r = classColor.r, g = classColor.g, b = classColor.b}
	E.db["general"]["totems"]["size"] = 36
	E.db["general"]["font"] = "Merathilis Prototype"
	E.db["general"]["fontSize"] = 10
	E.db["general"]["interruptAnnounce"] = "RAID"
	E.db["general"]["minimap"]["size"] = 130
	E.db["general"]["minimap"]["locationText"] = "HIDE"
	E.db["general"]["minimap"]["icons"]["classHall"]["position"] = "TOPRIGHT"
	E.db["general"]["minimap"]["icons"]["classHall"]["hide"] = true
	E.db["general"]["loginmessage"] = false
	E.db["general"]["stickyFrames"] = false
	E.db["general"]["loot"] = true
	E.db["general"]["lootRoll"] = true
	E.db["general"]["backdropcolor"]["r"] = 0.101
	E.db["general"]["backdropcolor"]["g"] = 0.101
	E.db["general"]["backdropcolor"]["b"] = 0.101
	E.db["general"]["bottomPanel"] = false
	E.db["general"]["topPanel"] = false
	E.db["general"]["bonusObjectivePosition"] = "AUTO"
	E.global["general"]["smallerWorldMap"] = false
	E.db["general"]["backdropfadecolor"]["r"] = 0.0549
	E.db["general"]["backdropfadecolor"]["g"] = 0.0549
	E.db["general"]["backdropfadecolor"]["b"] = 0.0549
	E.private["general"]["namefont"] = "Merathilis PrototypeRU"
	E.private["general"]["dmgfont"] = "Merathilis Prototype"
	E.private["general"]["normTex"] = "MerathilisFlat"
	E.private["general"]["glossTex"] = "MerathilisFlat"
	E.db["databars"]["experience"]["enable"] = true
	E.db["databars"]["experience"]["mouseover"] = false
	E.db["databars"]["experience"]["height"] = 155
	E.db["databars"]["experience"]["textSize"] = 10
	E.db["databars"]["experience"]["width"] = 10
	E.db["databars"]["experience"]["textFormat"] = "NONE"
	E.db["databars"]["experience"]["orientation"] = "VERTICAL"
	E.db["databars"]["experience"]["hideAtMaxLevel"] = true
	E.db["databars"]["experience"]["hideInVehicle"] = true
	E.db["databars"]["reputation"]["enable"] = true
	E.db["databars"]["reputation"]["mouseover"] = false
	E.db["databars"]["reputation"]["height"] = 155
	E.db["databars"]["reputation"]["textSize"] = 10
	E.db["databars"]["reputation"]["width"] = 10
	E.db["databars"]["reputation"]["textFormat"] = "NONE"
	E.db["databars"]["reputation"]["orientation"] = "VERTICAL"
	E.db["databars"]["reputation"]["hideInVehicle"] = true
	E.db["databars"]["artifact"]["enable"] = true
	E.db["databars"]["artifact"]["height"] = 155
	E.db["databars"]["artifact"]["textSize"] = 11
	E.db["databars"]["artifact"]["width"] = 10
	E.db["databars"]["honor"]['enable'] = true
	E.db["databars"]["honor"]["height"] = 155
	E.db["databars"]["honor"]["textSize"] = 11
	E.db["databars"]["honor"]["mouseover"] = true
	E.db["movers"]["AltPowerBarMover"] = "TOP,ElvUIParent,TOP,1,-272"
	E.db["movers"]["MinimapMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-2,-6"
	E.db["movers"]["GMMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,329,0"
	E.db["movers"]["BNETMover"] = "TOP,ElvUIParent,TOP,0,-38"
	E.db["movers"]["LootFrameMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-495,-457"
	E.db["movers"]["AlertFrameMover"] = "TOP,ElvUIParent,TOP,0,-140"
	E.db["movers"]["TotemBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,446,2"
	E.db["movers"]["LossControlMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,465"
	E.db["movers"]["ExperienceBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,413,23"
	E.db["movers"]["ReputationBarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-413,23"
	E.db["movers"]["ObjectiveFrameMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-200,-281"
	E.db["movers"]["VehicleSeatMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,2,-84"
	E.db["movers"]["ProfessionsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-3,-184"
	E.db["movers"]["ArtifactBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,424,23"
	E.db["movers"]["HonorBarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-424,23"
	E.db["movers"]["TalkingHeadFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,230"
	
	-- Auras
	if IsAddOnLoaded("Masque") then
		E.private["auras"]["masque"]["buffs"] = true
		E.private["auras"]["masque"]["debuffs"] = true
	end
	E.db["auras"]["debuffs"]["size"] = 30
	E.db["auras"]["fadeThreshold"] = 10
	E.db["auras"]["font"] = "Merathilis Prototype"
	E.db["auras"]["fontOutline"] = "OUTLINE"
	E.db["auras"]["buffs"]["fontSize"] = 12
	E.db["auras"]["buffs"]["horizontalSpacing"] = 10
	E.db["auras"]["buffs"]["verticalSpacing"] = 15
	E.db["auras"]["buffs"]["size"] = 24
	E.db["auras"]["buffs"]["wrapAfter"] = 10
	E.db["auras"]["debuffs"]["horizontalSpacing"] = 5
	E.db["auras"]["debuffs"]["size"] = 30
	E.db["movers"]["BuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-140,-5"
	E.db["movers"]["DebuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-140,-131"
	
	-- Bags
	E.db["bags"]["itemLevelFont"] = "Merathilis Prototype"
	E.db["bags"]["itemLevelFontSize"] = 9
	E.db["bags"]["itemLevelFontOutline"] = 'OUTLINE'
	E.db["bags"]["countFont"] = "Merathilis Prototype"
	E.db["bags"]["countFontSize"] = 10
	E.db["bags"]["countFontOutline"] = "OUTLINE"
	E.db["bags"]["yOffsetBank"] = -3
	E.db["bags"]["xOffsetBank"] = -3
	E.db["bags"]["xOffset"] = 3
	E.db["bags"]["yOffset"] = -3
	E.db["bags"]["bagSize"] = 23
	E.db["bags"]["alignToChat"] = false
	E.db["bags"]["bagWidth"] = 350
	E.db["bags"]["bankSize"] = 23
	E.db["bags"]["bankWidth"] = 350
	E.db["bags"]["moneyFormat"] = "BLIZZARD"
	E.db["bags"]["itemLevelThreshold"] = 650
	E.db["bags"]["junkIcon"] = true

	-- Nameplates
	E.db["nameplates"]["statusbar"] = "MerathilisFlat"
	E.db["nameplates"]["font"] = "Merathilis Expressway"
	E.db["nameplates"]["fontSize"] = 10
	E.db["nameplates"]["fontOutline"] = 'OUTLINE'
	E.db["nameplates"]['targetScale'] = 1.05
	E.db["nameplates"]["units"]["PLAYER"]["enable"] = false
	E.db["nameplates"]["units"]["HEALER"]["healthbar"]["enable"] = false
	
	-- Tooltip
	E.db["tooltip"]["itemCount"] = "NONE"
	E.db["tooltip"]["healthBar"]["height"] = 5
	E.db["tooltip"]["healthBar"]["font"] = "Merathilis Prototype"
	E.db["tooltip"]["healthBar"]["fontOutline"] = "OUTLINE"
	E.db["tooltip"]["visibility"]["combat"] = true
	E.db["tooltip"]["font"] = "Merathilis Expressway"
	E.db["tooltip"]["style"] = "inset"
	E.db["tooltip"]["fontOutline"] = "OUTLINE"
	E.db["tooltip"]["headerFontSize"] = 12
	E.db["tooltip"]["textFontSize"] = 11
	E.db["tooltip"]["smallTextFontSize"] = 11
	E.db["movers"]["TooltipMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-3,278"

	if InstallStepComplete then
		InstallStepComplete.message = MER.Title..L['MerathilisUI Set']
		InstallStepComplete:Show()
		titleText[2].check:Show()
	end
	E:UpdateAll(true)
end

local function SetupMERChat(layout)
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format('ChatFrame%s', i)]
		local chatFrameId = frame:GetID()
		local chatName = FCF_GetChatWindowInfo(chatFrameId)
		
		FCF_SetChatWindowFontSize(nil, frame, 12)
		
		-- move ElvUI default loot frame to the left chat, so that Recount/Skada can go to the right chat.
		if i == 3 and chatName == LOOT..' / '..TRADE then
			FCF_UnDockFrame(frame)
			frame:ClearAllPoints()
			frame:Point('BOTTOMLEFT', LeftChatToggleButton, 'TOPLEFT', 1, 3)
			FCF_SetWindowName(frame, LOOT)
			FCF_DockFrame(frame)
			FCF_SetLocked(frame, 1)
			frame:Show()
		end
		FCF_SavePositionAndDimensions(frame)
		FCF_StopDragging(frame)
	end
	ChatFrame_RemoveChannel(ChatFrame3, L["Trade"])
	ChatFrame_AddChannel(ChatFrame1, L["Trade"])
	ChatFrame_AddMessageGroup(ChatFrame1, "TARGETICONS")
	
	-- Chat
	E.db["chat"]["keywordSound"] = "Whisper Alert"
	E.db["chat"]["tabFont"] = "Merathilis Prototype"
	E.db["chat"]["tabFontOutline"] = "OUTLINE"
	E.db["chat"]["tabFontSize"] = 10
	E.db["chat"]["panelTabTransparency"] = true
	E.db["chat"]["fontOutline"] = "OUTLINE"
	E.db["chat"]["chatHistory"] = false
	E.db["chat"]["font"] = "Merathilis Expressway"
	E.db["chat"]["panelWidth"] = 350
	E.db["chat"]["panelHeight"] = 155
	E.db["chat"]["editBoxPosition"] = "ABOVE_CHAT"
	E.db["chat"]["panelBackdrop"] = "SHOWBOTH"
	if E.myname == "Merathilis" or "Damará" or "Melisendra" or "Asragoth" or "Róhal" or "Jústice" or "Jazira" or "Brítt" or "Jahzzy" then
		E.db["chat"]["keywords"] = "%MYNAME%, ElvUI, MerathilisUI, Andy"
	else
		E.db["chat"]["keywords"] = "%MYNAME%, ElvUI, MerathilisUI"
	end
	E.db["chat"]["timeStampFormat"] = "%H:%M "
	if E.myclass == "DRUID" and E.myname == "Merathilis" then
		E.db["chat"]["panelBackdropNameRight"] = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\chat.tga"
	else
		E.db["chat"]["panelBackdropNameRight"] = ""
	end
	E.db["movers"]["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-2,23"
	E.db["movers"]["LeftChatMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,23"
	
	if InstallStepComplete then
		InstallStepComplete.message = MER.Title..L['Chat Set']
		InstallStepComplete:Show()
		titleText[3].check:Show()
	end
	E:UpdateAll(true)
end

local function SetupMERActionbars(layout)
	-- Actionbars
	if layout == 'small' then
		E.db["actionbar"]["font"] = "Merathilis Prototype"
		E.db["actionbar"]["fontOutline"] = "OUTLINE"
		E.db["actionbar"]["macrotext"] = true
		E.db["actionbar"]["showGrid"] = false
		E.db["actionbar"]["lockActionBars"] = true
		
		if IsAddOnLoaded("Masque") then
			E.private["actionbar"]["masque"]["stanceBar"] = true
			E.private["actionbar"]["masque"]["petBar"] = true
			E.private["actionbar"]["masque"]["actionbars"] = true
		end
		
		if IsAddOnLoaded("ElvUI_BenikUI") then
			E.db['benikui']['actionbars']['transparent'] = true
			E.db['benikui']['actionbars']['toggleButtons']['enable'] = true
			E.db['benikui']['actionbars']['toggleButtons']['chooseAb'] = "BAR1"
			E.db['benikui']['actionbars']['requestStop'] = true
		end
		
		E.db["actionbar"]["bar1"]["buttonspacing"] = 4
		E.db["actionbar"]["bar1"]["backdrop"] = true
		E.db["actionbar"]["bar1"]["heightMult"] = 2
		E.db["actionbar"]["bar1"]["buttonsize"] = 30
		E.db["actionbar"]["bar1"]["buttons"] = 12
		E.db["actionbar"]["bar1"]["backdropSpacing"] = 3
		
		E.db["actionbar"]["bar2"]["enabled"] = true
		E.db["actionbar"]["bar2"]["buttonspacing"] = 4
		E.db["actionbar"]["bar2"]["buttons"] = 12
		E.db["actionbar"]["bar2"]["buttonsize"] = 30
		E.db["actionbar"]["bar2"]["backdrop"] = false
		E.db["actionbar"]["bar2"]["visibility"] = "[vehicleui][overridebar][petbattle][possessbar] hide; show"
		E.db["actionbar"]["bar2"]["mouseover"] = false
		E.db["actionbar"]["bar2"]["backdropSpacing"] = 4
		
		E.db["actionbar"]["bar3"]["backdrop"] = true
		E.db["actionbar"]["bar3"]["buttonsPerRow"] = 2
		E.db["actionbar"]["bar3"]["buttonsize"] = 24
		E.db["actionbar"]["bar3"]["buttonspacing"] = 5
		E.db["actionbar"]["bar3"]["buttons"] = 12
		E.db["actionbar"]["bar3"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar3"]["backdropSpacing"] = 2
		
		E.db["actionbar"]["bar4"]["enabled"] = true
		E.db["actionbar"]["bar4"]["buttonspacing"] = 4
		E.db["actionbar"]["bar4"]["mouseover"] = true
		E.db["actionbar"]["bar4"]["buttonsize"] = 24
		E.db["actionbar"]["bar4"]["backdropSpacing"] = 2
		
		E.db["actionbar"]["bar5"]["backdrop"] = true
		E.db["actionbar"]["bar5"]["buttonsPerRow"] = 2
		E.db["actionbar"]["bar5"]["buttonsize"] = 24
		E.db["actionbar"]["bar5"]["buttonspacing"] = 5
		E.db["actionbar"]["bar5"]["buttons"] = 12
		E.db["actionbar"]["bar5"]["point"] = "BOTTOMLEFT"
		E.db["actionbar"]["bar5"]["backdropSpacing"] = 2
		
		E.db["actionbar"]["bar6"]["enabled"] = false
		
		E.db["actionbar"]["barPet"]["point"] = "BOTTOMLEFT"
		E.db["actionbar"]["barPet"]["buttons"] = 8
		E.db["actionbar"]["barPet"]["buttonspacing"] = 1
		E.db["actionbar"]["barPet"]["buttonsPerRow"] = 1
		E.db["actionbar"]["barPet"]["buttonsize"] = 19
		E.db["actionbar"]["barPet"]["mouseover"] = true
		
		E.db["actionbar"]["stanceBar"]["point"] = "BOTTOMLEFT"
		E.db["actionbar"]["stanceBar"]["backdrop"] = true
		E.db["actionbar"]["stanceBar"]["buttonsPerRow"] = 6
		E.db["actionbar"]["stanceBar"]["buttonsize"] = 18
		if E.myclass == "DRUID" then
			E.db["actionbar"]["stanceBar"]["mouseover"] = true
		else
			E.db["actionbar"]["stanceBar"]["mouseover"] = false
		end
		E.db["actionbar"]["extraActionButton"]["scale"] = 0.75
		E.db["movers"]["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,0,26"
		E.db["movers"]["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,0,60"
		E.db["movers"]["ElvAB_3"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-353,3"
		E.db["movers"]["ElvAB_4"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,0,367"
		E.db["movers"]["ElvAB_5"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,353,3"
		E.db["movers"]["ShiftAB"] = "BOTTOM,ElvUIParent,BOTTOM,0,98"
		E.db["movers"]["PetAB"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,423,2"
		E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,-233,29"
		E.db["movers"]["MicrobarMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-4"

	elseif layout == 'big' then
		E.db["actionbar"]["font"] = "Merathilis Prototype"
		E.db["actionbar"]["fontOutline"] = "OUTLINE"
		E.db["actionbar"]["macrotext"] = true
		E.db["actionbar"]["showGrid"] = false
		E.db["actionbar"]["lockActionBars"] = true
		
		if IsAddOnLoaded("Masque") then
			E.private["actionbar"]["masque"]["stanceBar"] = true
			E.private["actionbar"]["masque"]["petBar"] = true
			E.private["actionbar"]["masque"]["actionbars"] = true
		end
		
		if IsAddOnLoaded("ElvUI_BenikUI") then
			E.db['benikui']['actionbars']['transparent'] = true
			E.db['benikui']['actionbars']['toggleButtons']['enable'] = true
			E.db['benikui']['actionbars']['toggleButtons']['chooseAb'] = "BAR1"
			E.db['benikui']['actionbars']['requestStop'] = true
		end
		
		E.db["actionbar"]["bar1"]["buttonspacing"] = 4
		E.db["actionbar"]["bar1"]["backdrop"] = true
		E.db["actionbar"]["bar1"]["heightMult"] = 3
		E.db["actionbar"]["bar1"]["buttonsize"] = 28
		E.db["actionbar"]["bar1"]["buttons"] = 12
		E.db["actionbar"]["bar1"]["backdropSpacing"] = 3
		
		E.db["actionbar"]["bar2"]["enabled"] = true
		E.db["actionbar"]["bar2"]["buttonspacing"] = 4
		E.db["actionbar"]["bar2"]["buttons"] = 12
		E.db["actionbar"]["bar2"]["buttonsize"] = 28
		E.db["actionbar"]["bar2"]["backdrop"] = false
		E.db["actionbar"]["bar2"]["visibility"] = "[vehicleui][overridebar][petbattle][possessbar] hide; show"
		E.db["actionbar"]["bar2"]["mouseover"] = false
		E.db["actionbar"]["bar2"]["backdropSpacing"] = 4
		E.db["actionbar"]["bar2"]["heightMult"] = 1
		
		E.db["actionbar"]["bar3"]["backdrop"] = true
		E.db["actionbar"]["bar3"]["buttonsPerRow"] = 2
		E.db["actionbar"]["bar3"]["buttonsize"] = 24
		E.db["actionbar"]["bar3"]["buttonspacing"] = 5
		E.db["actionbar"]["bar3"]["buttons"] = 12
		E.db["actionbar"]["bar3"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar3"]["backdropSpacing"] = 2
		
		E.db["actionbar"]["bar4"]["enabled"] = true
		E.db["actionbar"]["bar4"]["buttonspacing"] = 4
		E.db["actionbar"]["bar4"]["mouseover"] = true
		E.db["actionbar"]["bar4"]["buttonsize"] = 24
		E.db["actionbar"]["bar4"]["backdropSpacing"] = 2
		
		E.db["actionbar"]["bar5"]["backdrop"] = true
		E.db["actionbar"]["bar5"]["buttonsPerRow"] = 2
		E.db["actionbar"]["bar5"]["buttonsize"] = 24
		E.db["actionbar"]["bar5"]["buttonspacing"] = 5
		E.db["actionbar"]["bar5"]["buttons"] = 12
		E.db["actionbar"]["bar5"]["point"] = "BOTTOMLEFT"
		E.db["actionbar"]["bar5"]["backdropSpacing"] = 2
		
		E.db["actionbar"]["bar6"]["enabled"] = true
		E.db["actionbar"]["bar6"]["enabled"] = true
		E.db["actionbar"]["bar6"]["buttonspacing"] = 4
		E.db["actionbar"]["bar6"]["buttons"] = 12
		E.db["actionbar"]["bar6"]["buttonsize"] = 28
		E.db["actionbar"]["bar6"]["backdrop"] = false
		E.db["actionbar"]["bar6"]["mouseover"] = false
		E.db["actionbar"]["bar6"]["backdropSpacing"] = 4
		
		E.db["actionbar"]["barPet"]["point"] = "BOTTOMLEFT"
		E.db["actionbar"]["barPet"]["buttons"] = 8
		E.db["actionbar"]["barPet"]["buttonspacing"] = 1
		E.db["actionbar"]["barPet"]["buttonsPerRow"] = 1
		E.db["actionbar"]["barPet"]["buttonsize"] = 19
		E.db["actionbar"]["barPet"]["mouseover"] = true
		
		E.db["actionbar"]["stanceBar"]["point"] = "BOTTOMLEFT"
		E.db["actionbar"]["stanceBar"]["backdrop"] = true
		E.db["actionbar"]["stanceBar"]["buttonsPerRow"] = 6
		E.db["actionbar"]["stanceBar"]["buttonsize"] = 18
		if E.myclass == "DRUID" then
			E.db["actionbar"]["stanceBar"]["mouseover"] = true
		else
			E.db["actionbar"]["stanceBar"]["mouseover"] = false
		end
		E.db["actionbar"]["extraActionButton"]["scale"] = 0.75
		E.db["movers"]["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,0,26"
		E.db["movers"]["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,0,59"
		E.db["movers"]["ElvAB_3"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-353,3"
		E.db["movers"]["ElvAB_4"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,0,367"
		E.db["movers"]["ElvAB_5"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,353,3"
		E.db["movers"]["ElvAB_6"] = "BOTTOM,ElvUIParent,BOTTOM,0,91"
		E.db["movers"]["ShiftAB"] = "BOTTOM,ElvUIParent,BOTTOM,0,130"
		E.db["movers"]["PetAB"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,423,2"
		E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,-233,29"
		E.db["movers"]["MicrobarMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-4"
	end

	if InstallStepComplete then
		InstallStepComplete.message = MER.Title..L['Actionbars Set']
		InstallStepComplete:Show()
		titleText[5].check:Show()
	end
	E:UpdateAll(true)
end

local function SetupUnitframes(layout)
	-- Unitframes
	E.db["unitframe"]["font"] = "Merathilis Tukui"
	E.db["unitframe"]["fontSize"] = 12
	E.db["unitframe"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["smoothbars"] = true
	E.db["unitframe"]["statusbar"] = "MerathilisFlat"
	E.db["unitframe"]["colors"]["powerclass"] = true
	E.db["unitframe"]["colors"]["castColor"]["r"] = 0.1
	E.db["unitframe"]["colors"]["castColor"]["g"] = 0.1
	E.db["unitframe"]["colors"]["castColor"]["b"] = 0.1
	E.db["unitframe"]["colors"]["transparentHealth"] = true
	E.db["unitframe"]["colors"]["transparentAurabars"] = true
	E.db["unitframe"]["colors"]["transparentPower"] = false
	E.db["unitframe"]["colors"]["transparentCastbar"] = true
	E.db["unitframe"]["colors"]["castClassColor"] = false
	E.db["unitframe"]["colors"]["health"]["r"] = 0.23
	E.db["unitframe"]["colors"]["health"]["g"] = 0.23
	E.db["unitframe"]["colors"]["health"]["b"] = 0.23
	E.db["unitframe"]["colors"]["power"]["MANA"] = E:GetColor(classColor.r, classColor.b, classColor.g)
	E.db["unitframe"]["colors"]["power"]["RAGE"] = E:GetColor(classColor.r, classColor.b, classColor.g)
	E.db["unitframe"]["colors"]["power"]["FOCUS"] = E:GetColor(classColor.r, classColor.b, classColor.g)
	E.db["unitframe"]["colors"]["power"]["ENERGY"] = E:GetColor(classColor.r, classColor.b, classColor.g)
	E.db["unitframe"]["colors"]["power"]["RUNIC_POWER"] = E:GetColor(classColor.r, classColor.b, classColor.g)
	E.db["unitframe"]["colors"]["castClassColor"] = false
	E.db["unitframe"]["colors"]["castReactionColor"] = false
	
	-- Player
	E.db["unitframe"]["units"]["player"]["width"] = 180
	E.db["unitframe"]["units"]["player"]["height"] = 26
	E.db["unitframe"]["units"]["player"]['orientation'] = "RIGHT"
	E.db["unitframe"]["units"]["player"]["debuffs"]["fontSize"] = 12
	E.db["unitframe"]["units"]["player"]["debuffs"]["attachTo"] = "POWER"
	E.db["unitframe"]["units"]["player"]["debuffs"]["sizeOverride"] = 30
	E.db["unitframe"]["units"]["player"]["debuffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["player"]["debuffs"]["yOffset"] = 1
	E.db["unitframe"]["units"]["player"]["debuffs"]["perrow"] = 6
	E.db["unitframe"]["units"]["player"]["debuffs"]["anchorPoint"] = "TOPLEFT"
	E.db["unitframe"]["units"]["player"]["smartAuraPosition"] = "DISABLED"
	E.db["unitframe"]["units"]["player"]["portrait"]["enable"] = true
	E.db["unitframe"]["units"]["player"]["portrait"]["overlay"] = false
	E.db["unitframe"]["units"]["player"]["portrait"]["camDistanceScale"] = 1
	E.db["unitframe"]["units"]["player"]["classbar"]["enable"] = true
	E.db["unitframe"]["units"]["player"]["classbar"]["detachFromFrame"] = false
	E.db["unitframe"]["units"]["player"]["classbar"]["height"] = 5
	E.db["unitframe"]["units"]["player"]["classbar"]["autoHide"] = true
	E.db["unitframe"]["units"]["player"]["classbar"]["fill"] = "filled"
	E.db["unitframe"]["units"]["player"]["aurabar"]["enable"] = false
	E.db["unitframe"]["units"]["player"]["threatStyle"] = "INFOPANELBORDER"
	E.db["unitframe"]["units"]["player"]["castbar"]["icon"] = true
	E.db["unitframe"]["units"]["player"]["castbar"]["latency"] = true
	E.db["unitframe"]["units"]["player"]["castbar"]["insideInfoPanel"] = true
	if not E.db["unitframe"]["units"]["player"]["customTexts"] then E.db["unitframe"]["units"]["player"]["customTexts"] = {} end
	E.db["unitframe"]["units"]["player"]["customTexts"] = {}
	E.db["unitframe"]["units"]["player"]["customTexts"]["BigName"] = {}
	E.db["unitframe"]["units"]["player"]["customTexts"]["BigName"]["font"] = "Merathilis Tukui"
	E.db["unitframe"]["units"]["player"]["customTexts"]["BigName"]["justifyH"] = "LEFT"
	E.db["unitframe"]["units"]["player"]["customTexts"]["BigName"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["units"]["player"]["customTexts"]["BigName"]["text_format"] = "[name:medium] [difficultycolor][smartlevel] [shortclassification]"
	E.db["unitframe"]["units"]["player"]["customTexts"]["BigName"]["size"] = 20
	E.db["unitframe"]["units"]["player"]["customTexts"]["BigName"]["attachTextTo"] = 'Health'
	E.db["unitframe"]["units"]["player"]["customTexts"]["Percent"] = {}
	E.db["unitframe"]["units"]["player"]["customTexts"]["Percent"]["font"] = "Merathilis Tukui"
	E.db["unitframe"]["units"]["player"]["customTexts"]["Percent"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["units"]["player"]["customTexts"]["Percent"]["size"] = 20
	E.db["unitframe"]["units"]["player"]["customTexts"]["Percent"]["justifyH"] = "RIGHT"
	E.db["unitframe"]["units"]["player"]["customTexts"]["Percent"]["text_format"] = "[classcolor:player][health:percent:hidefull:hidezero]"
	E.db["unitframe"]["units"]["player"]["customTexts"]["Percent"]["attachTextTo"] = "Health"
	E.db["unitframe"]["units"]["player"]["health"]["xOffset"] = 0
	E.db["unitframe"]["units"]["player"]["health"]["yOffset"] = 0
	E.db["unitframe"]["units"]["player"]["health"]["text_format"] = "[healthcolor][health:current] - [classcolor:player][power:current]"
	E.db["unitframe"]["units"]["player"]["health"]["attachTextTo"] = "InfoPanel"
	E.db["unitframe"]["units"]["player"]["power"]["height"] = 5
	E.db["unitframe"]["units"]["player"]["power"]["hideonnpc"] = true
	E.db["unitframe"]["units"]["player"]["power"]["detachFromFrame"] = true
	E.db["unitframe"]["units"]["player"]["power"]["detachedWidth"] = 180
	E.db["unitframe"]["units"]["player"]["power"]["druidMana"] = false
	E.db["unitframe"]["units"]["player"]["power"]["text_format"] = ""
	E.db["unitframe"]["units"]["player"]["buffs"]["enable"] = false
	E.db["unitframe"]["units"]["player"]["raidicon"]["enable"] = true
	E.db["unitframe"]["units"]["player"]["raidicon"]["position"] = "TOP"
	E.db["unitframe"]["units"]["player"]["raidicon"]["size"] = 18
	E.db["unitframe"]["units"]["player"]["raidicon"]["xOffset"] = 0
	E.db["unitframe"]["units"]["player"]["raidicon"]["yOffset"] = 15
	E.db["unitframe"]["units"]["player"]["infoPanel"]["enable"] = true
	E.db["unitframe"]["units"]["player"]["infoPanel"]["height"] = 13
	E.db["unitframe"]["units"]["player"]["infoPanel"]["transparent"] = true
	if IsAddOnLoaded("ElvUI_BenikUI") then
		-- Detach portrait 
		E.db['benikui']['unitframes']['player']['detachPortrait'] = true
		E.db['benikui']['unitframes']['player']['portraitWidth'] = 92
		E.db['benikui']['unitframes']['player']['portraitHeight'] = 39
		E.db['benikui']['unitframes']['player']['portraitShadow'] = false
		E.db['benikui']['unitframes']['player']['portraitTransparent'] = true
		E.db['benikui']['unitframes']['player']['portraitStyle'] = true
		E.db['benikui']['unitframes']['player']['portraitStyleHeight'] = 4
		-- Castbar
		E.db['benikui']['unitframes']['castbar']['text']['yOffset'] = 0
		E.db['benikui']['unitframes']['castbar']['text']['ShowInfoText'] = false
		E.db['benikui']['unitframes']['castbar']['text']['castText'] = true
		E.db['benikui']['unitframes']['castbar']['text']['texture'] = "MerathilisEmpty"
		E.db['benikui']['unitframes']['castbar']['text']['textColor'] = {r = classColor.r, g = classColor.g, b = classColor.b}
	end
	E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-176,141"
	E.db["movers"]["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-176,179"
	E.db["movers"]["PlayerPortraitMover"] = "BOTTOM,ElvUIParent,BOTTOM,-313,141"
	E.db["movers"]["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,185"
	
	-- Target
	E.db["unitframe"]["units"]["target"]["width"] = 180
	E.db["unitframe"]["units"]["target"]["height"] = 26
	E.db["unitframe"]["units"]["target"]['orientation'] = "LEFT"
	E.db["unitframe"]["units"]["target"]["castbar"]["icon"] = true
	E.db["unitframe"]["units"]["target"]["castbar"]["latency"] = true
	E.db["unitframe"]["units"]["target"]["castbar"]["insideInfoPanel"] = true
	E.db["unitframe"]["units"]["target"]["debuffs"]["fontSize"] = 12
	E.db["unitframe"]["units"]["target"]["debuffs"]["sizeOverride"] = 28
	E.db["unitframe"]["units"]["target"]["debuffs"]["yOffset"] = 7
	E.db["unitframe"]["units"]["target"]["debuffs"]["xOffset"] = 94
	E.db["unitframe"]["units"]["target"]["debuffs"]["anchorPoint"] = "RIGHT"
	E.db["unitframe"]["units"]["target"]["debuffs"]["perrow"] = 4
	E.db["unitframe"]["units"]["target"]["debuffs"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["target"]["smartAuraPosition"] = "DISABLED"
	E.db["unitframe"]["units"]["target"]["aurabar"]["enable"] = false
	E.db["unitframe"]["units"]["target"]["aurabar"]["attachTo"] = "BUFFS"
	E.db["unitframe"]["units"]["target"]["name"]["xOffset"] = 8
	E.db["unitframe"]["units"]["target"]["name"]["yOffset"] = -32
	E.db["unitframe"]["units"]["target"]["name"]["position"] = "RIGHT"
	E.db["unitframe"]["units"]["target"]["name"]["text_format"] = ""
	E.db["unitframe"]["units"]["target"]["threatStyle"] = "INFOPANELBORDER"
	E.db["unitframe"]["units"]["target"]["power"]["detachFromFrame"] = true
	E.db["unitframe"]["units"]["target"]["power"]["detachedWidth"] = 180
	E.db["unitframe"]["units"]["target"]["power"]["hideonnpc"] = false
	E.db["unitframe"]["units"]["target"]["power"]["height"] = 5
	E.db["unitframe"]["units"]["target"]["power"]["text_format"] = ""
	if not E.db["unitframe"]["units"]["target"]["customTexts"] then E.db["unitframe"]["units"]["target"]["customTexts"] = {} end
	E.db["unitframe"]["units"]["target"]["customTexts"] = {}
	E.db["unitframe"]["units"]["target"]["customTexts"]["BigName"] = {}
	E.db["unitframe"]["units"]["target"]["customTexts"]["BigName"]["font"] = "Merathilis Tukui"
	E.db["unitframe"]["units"]["target"]["customTexts"]["BigName"]["justifyH"] = "RIGHT"
	E.db["unitframe"]["units"]["target"]["customTexts"]["BigName"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["units"]["target"]["customTexts"]["BigName"]["xOffset"] = 4
	E.db["unitframe"]["units"]["target"]["customTexts"]["BigName"]["yOffset"] = 0
	E.db["unitframe"]["units"]["target"]["customTexts"]["BigName"]["size"] = 20
	E.db["unitframe"]["units"]["target"]["customTexts"]["BigName"]["text_format"] = "[name:short] [difficultycolor][shortclassification]"
	E.db["unitframe"]["units"]["target"]["customTexts"]["BigName"]["attachTextTo"] = "Health"
	E.db["unitframe"]["units"]["target"]["customTexts"]["Class"] = {}
	E.db["unitframe"]["units"]["target"]["customTexts"]["Class"]["font"] = "Merathilis Tukui"
	E.db["unitframe"]["units"]["target"]["customTexts"]["Class"]["justifyH"] = "LEFT"
	E.db["unitframe"]["units"]["target"]["customTexts"]["Class"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["units"]["target"]["customTexts"]["Class"]["xOffset"] = 1
	E.db["unitframe"]["units"]["target"]["customTexts"]["Class"]["size"] = 12
	E.db["unitframe"]["units"]["target"]["customTexts"]["Class"]["text_format"] = "[namecolor][smartclass] [difficultycolor][level]"
	E.db["unitframe"]["units"]["target"]["customTexts"]["Class"]["yOffset"] = 0
	E.db["unitframe"]["units"]["target"]["customTexts"]["Class"]["attachTextTo"] = "InfoPanel"
	E.db["unitframe"]["units"]["target"]["customTexts"]["Percent"] = {}
	E.db["unitframe"]["units"]["target"]["customTexts"]["Percent"]["font"] = "Merathilis Tukui"
	E.db["unitframe"]["units"]["target"]["customTexts"]["Percent"]["size"] = 20
	E.db["unitframe"]["units"]["target"]["customTexts"]["Percent"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["units"]["target"]["customTexts"]["Percent"]["justifyH"] = "LEFT"
	E.db["unitframe"]["units"]["target"]["customTexts"]["Percent"]["text_format"] = "[namecolor][health:percent:hidefull:hidezero]"
	E.db["unitframe"]["units"]["target"]["customTexts"]["Percent"]["attachTextTo"] = "Health"
	E.db["unitframe"]["units"]["target"]["health"]["xOffset"] = 0
	E.db["unitframe"]["units"]["target"]["health"]["yOffset"] = 0
	E.db["unitframe"]["units"]["target"]["health"]["text_format"] = "[namecolor][power:current][healthcolor] - [health:current]"
	E.db["unitframe"]["units"]["target"]["health"]["attachTextTo"] = "InfoPanel"
	E.db["unitframe"]["units"]["target"]["portrait"]["enable"] = true
	E.db["unitframe"]["units"]["target"]["portrait"]["overlay"] = false
	E.db["unitframe"]["units"]["target"]["portrait"]["camDistanceScale"] = 1
	E.db["unitframe"]["units"]["target"]["buffs"]["enable"] = true
	E.db["unitframe"]["units"]["target"]["buffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["target"]["buffs"]["yOffset"] = 1
	E.db["unitframe"]["units"]["target"]["buffs"]["attachTo"] = "POWER"
	E.db["unitframe"]["units"]["target"]["buffs"]["sizeOverride"] = 20
	E.db["unitframe"]["units"]["target"]["buffs"]["perrow"] = 9
	E.db["unitframe"]["units"]["target"]["buffs"]["fontSize"] = 12
	E.db["unitframe"]["units"]["target"]["raidicon"]["enable"] = true
	E.db["unitframe"]["units"]["target"]["raidicon"]["position"] = "TOP"
	E.db["unitframe"]["units"]["target"]["raidicon"]["size"] = 18
	E.db["unitframe"]["units"]["target"]["raidicon"]["xOffset"] = 0
	E.db["unitframe"]["units"]["target"]["raidicon"]["yOffset"] = 15
	E.db["unitframe"]["units"]["target"]["infoPanel"]["enable"] = true
	E.db["unitframe"]["units"]["target"]["infoPanel"]["height"] = 13
	E.db["unitframe"]["units"]["target"]["infoPanel"]["transparent"] = true
	
	if IsAddOnLoaded ("ElvUI_BenikUI") then
		E.db['benikui']['unitframes']['target']['detachPortrait'] = true
		E.db['benikui']['unitframes']['target']['portraitWidth'] = 92
		E.db['benikui']['unitframes']['target']['portraitHeight'] = 39
		E.db['benikui']['unitframes']['target']['portraitShadow'] = false
		E.db['benikui']['unitframes']['target']['portraitTransparent'] = true
		E.db['benikui']['unitframes']['target']['portraitStyle'] = true
		E.db['benikui']['unitframes']['target']['portraitStyleHeight'] = 4
	end
	E.db["movers"]["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,176,141"
	E.db["movers"]["TargetPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,176,179"
	E.db["movers"]["TargetPortraitMover"] = "BOTTOM,ElvUIParent,BOTTOM,313,141"
	
	-- TargetTarget
	E.db["unitframe"]["units"]["targettarget"]["debuffs"]["enable"] = true
	E.db["unitframe"]["units"]["targettarget"]["power"]["enable"] = true
	E.db["unitframe"]["units"]["targettarget"]["power"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["targettarget"]["power"]["height"] = 4
	E.db["unitframe"]["units"]["targettarget"]["width"] = 100
	E.db["unitframe"]["units"]["targettarget"]["name"]["yOffset"] = -1
	E.db["unitframe"]["units"]["targettarget"]["height"] = 20
	E.db["unitframe"]["units"]["targettarget"]["health"]["text_format"] = ""
	E.db["unitframe"]["units"]["targettarget"]["raidicon"]["enable"] = true
	E.db["unitframe"]["units"]["targettarget"]["raidicon"]["position"] = "TOP"
	E.db["unitframe"]["units"]["targettarget"]["raidicon"]["size"] = 18
	E.db["unitframe"]["units"]["targettarget"]["raidicon"]["xOffset"] = 0
	E.db["unitframe"]["units"]["targettarget"]["raidicon"]["yOffset"] = 15
	E.db["unitframe"]["units"]["targettarget"]["portrait"]["enable"] = false
	E.db["unitframe"]["units"]["targettarget"]["infoPanel"]["enable"] = false
	E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,163"
	
	-- Focus
	E.db["unitframe"]["units"]["focus"]["width"] = 122
	E.db["unitframe"]["units"]["focus"]["height"] = 30
	E.db["unitframe"]["units"]["focus"]["health"]["position"] = "LEFT"
	E.db["unitframe"]["units"]["focus"]["health"]["text_format"] = "[healthcolor][health:current]"
	E.db["unitframe"]["units"]["focus"]["health"]["xOffset"] = 0
	E.db["unitframe"]["units"]["focus"]["health"]["yOffset"] = 0
	E.db["unitframe"]["units"]["focus"]["health"]["attachTextTo"] = "InfoPanel"
	E.db["unitframe"]["units"]["focus"]["power"]["position"] = "RIGHT"
	E.db["unitframe"]["units"]["focus"]["power"]["height"] = 4
	E.db["unitframe"]["units"]["focus"]["power"]["text_format"] = "[powercolor][power:current]"
	E.db["unitframe"]["units"]["focus"]["power"]["xOffset"] = 0
	E.db["unitframe"]["units"]["focus"]["power"]["yOffset"] = 0
	E.db["unitframe"]["units"]["focus"]["power"]["attachTextTo"] = "InfoPanel"
	E.db["unitframe"]["units"]["focus"]["castbar"]["enable"] = true
	E.db["unitframe"]["units"]["focus"]["castbar"]["latency"] = true
	E.db["unitframe"]["units"]["focus"]["castbar"]["insideInfoPanel"] = true
	E.db["unitframe"]["units"]["focus"]["castbar"]["iconSize"] = 20
	E.db["unitframe"]["units"]["focus"]["debuffs"]["anchorPoint"] = "BOTTOMRIGHT"
	E.db["unitframe"]["units"]["focus"]["portrait"]["enable"] = false
	E.db["unitframe"]["units"]["focus"]["infoPanel"]["enable"] = true
	E.db["unitframe"]["units"]["focus"]["infoPanel"]["height"] = 13
	E.db["unitframe"]["units"]["focus"]["infoPanel"]["transparent"] = true
	E.db["movers"]["ElvUF_FocusMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-452,199"
	E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-452,220"
	
	-- FocusTarget
	E.db["unitframe"]["units"]["focustarget"]["enable"] = true
	E.db["unitframe"]["units"]["focustarget"]["debuffs"]["enable"] = true
	E.db["unitframe"]["units"]["focustarget"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
	E.db["unitframe"]["units"]["focustarget"]["threatStyle"] = "GLOW"
	E.db["unitframe"]["units"]["focustarget"]["power"]["enable"] = true
	E.db["unitframe"]["units"]["focustarget"]["power"]["height"] = 4
	E.db["unitframe"]["units"]["focustarget"]["width"] = 122
	E.db["unitframe"]["units"]["focustarget"]["height"] = 20
	E.db["unitframe"]["units"]["focustarget"]["portrait"]["enable"] = false
	E.db["unitframe"]["units"]["focustarget"]["infoPanel"]["enable"] = false
	E.db["movers"]["ElvUF_FocusTargetMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-452,234"
	
	-- Raid
	E.db["unitframe"]["units"]["raid"]["height"] = 35
	E.db["unitframe"]["units"]["raid"]["width"] = 69
	E.db["unitframe"]["units"]["raid"]["threatStyle"] = "GLOW"
	E.db["unitframe"]["units"]["raid"]["orientation"] = "MIDDLE"
	E.db["unitframe"]["units"]["raid"]["horizontalSpacing"] = 1
	E.db["unitframe"]["units"]["raid"]["verticalSpacing"] = 10
	E.db["unitframe"]["units"]["raid"]["debuffs"]["fontSize"] = 12
	E.db["unitframe"]["units"]["raid"]["debuffs"]["enable"] = true
	E.db["unitframe"]["units"]["raid"]["debuffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid"]["debuffs"]["yOffset"] = -10
	E.db["unitframe"]["units"]["raid"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
	E.db["unitframe"]["units"]["raid"]["debuffs"]["sizeOverride"] = 20
	E.db["unitframe"]["units"]["raid"]["rdebuffs"]["enable"] = false
	E.db["unitframe"]["units"]["raid"]["rdebuffs"]["font"] = "Merathilis Prototype"
	E.db["unitframe"]["units"]["raid"]["rdebuffs"]["fontSize"] = 10
	E.db["unitframe"]["units"]["raid"]["rdebuffs"]["size"] = 20
	E.db["unitframe"]["units"]["raid"]["numGroups"] = 4
	E.db["unitframe"]["units"]["raid"]["growthDirection"] = "RIGHT_UP"
	E.db["unitframe"]["units"]["raid"]["colorOverride"] = "USE_DEFAULT"
	E.db["unitframe"]["units"]["raid"]["portrait"]["enable"] = false
	E.db["unitframe"]["units"]["raid"]["name"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid"]["name"]["yOffset"] = 0
	E.db["unitframe"]["units"]["raid"]["name"]["text_format"] = "[namecolor][name:short]"
	E.db["unitframe"]["units"]["raid"]["name"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["raid"]["name"]["attachTextTo"] = "InfoPanel"
	E.db["unitframe"]["units"]["raid"]["buffIndicator"]["fontSize"] = 11
	E.db["unitframe"]["units"]["raid"]["buffIndicator"]["size"] = 10
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["size"] = 10
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["position"] = "BOTTOMRIGHT"
	E.db["unitframe"]["units"]["raid"]["power"]["enable"] = true
	E.db["unitframe"]["units"]["raid"]["power"]["height"] = 4
	E.db["unitframe"]["units"]["raid"]["healPrediction"] = true
	E.db["unitframe"]["units"]["raid"]["groupBy"] = "ROLE"
	E.db["unitframe"]["units"]["raid"]["health"]["frequentUpdates"] = true
	E.db["unitframe"]["units"]["raid"]["health"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["raid"]["health"]["text_format"] = "[healthcolor][health:deficit]"
	E.db["unitframe"]["units"]["raid"]["health"]["attachTextTo"] = "Health"
	E.db["unitframe"]["units"]["raid"]["buffs"]["enable"] = true
	E.db["unitframe"]["units"]["raid"]["buffs"]["yOffset"] = 5
	E.db["unitframe"]["units"]["raid"]["buffs"]["anchorPoint"] = "CENTER"
	E.db["unitframe"]["units"]["raid"]["buffs"]["clickTrough"] = false
	E.db["unitframe"]["units"]["raid"]["buffs"]["useBlacklist"] = false
	E.db["unitframe"]["units"]["raid"]["buffs"]["noDuration"] = false
	E.db["unitframe"]["units"]["raid"]["buffs"]["playerOnly"] = false
	E.db["unitframe"]["units"]["raid"]["buffs"]["perrow"] = 1
	E.db["unitframe"]["units"]["raid"]["buffs"]["useFilter"] = "TurtleBuffs"
	E.db["unitframe"]["units"]["raid"]["buffs"]["noConsolidated"] = false
	E.db["unitframe"]["units"]["raid"]["buffs"]["sizeOverride"] = 20
	E.db["unitframe"]["units"]["raid"]["buffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid"]["raidicon"]["attachTo"] = "CENTER"
	E.db["unitframe"]["units"]["raid"]["raidicon"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid"]["raidicon"]["yOffset"] = 5
	E.db["unitframe"]["units"]["raid"]["raidicon"]["size"] = 15
	E.db["unitframe"]["units"]["raid"]["raidicon"]["yOffset"] = 0
	if not E.db["unitframe"]["units"]["raid"]["customTexts"] then E.db["unitframe"]["units"]["raid"]["customTexts"] = {} end
	E.db["unitframe"]["units"]["raid"]["customTexts"] = {}
	E.db["unitframe"]["units"]["raid"]["customTexts"]["Status"] = {}
	E.db["unitframe"]["units"]["raid"]["customTexts"]["Status"]["font"] = "Merathilis Tukui"
	E.db["unitframe"]["units"]["raid"]["customTexts"]["Status"]["justifyH"] = "CENTER"
	E.db["unitframe"]["units"]["raid"]["customTexts"]["Status"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["units"]["raid"]["customTexts"]["Status"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid"]["customTexts"]["Status"]["yOffset"] = 0
	E.db["unitframe"]["units"]["raid"]["customTexts"]["Status"]["size"] = 12
	E.db["unitframe"]["units"]["raid"]["customTexts"]["Status"]["attachTextTo"] = "Health"
	E.db["unitframe"]["units"]["raid"]["customTexts"]["Status"]["text_format"] = "[namecolor][statustimer]"
	E.db["unitframe"]["units"]["raid"]["infoPanel"]["enable"] = true
	E.db["unitframe"]["units"]["raid"]["infoPanel"]["height"] = 13
	E.db["unitframe"]["units"]["raid"]["infoPanel"]["transparent"] = true
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["enable"] = true
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["damager"] = true
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["tank"] = true
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["heal"] = true
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["attachTo"] = "InfoPanel"
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["yOffset"] = 0
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["size"] = 10
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["position"] = "RIGHT"
	if IsAddOnLoaded("ElvUI_BenikUI") then
		E.db["unitframe"]["units"]["raid"]["classHover"] = true
	end
	E.db["movers"]["ElvUF_RaidMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,185"
	
	-- Raid40
	E.db["unitframe"]["units"]["raid40"]["horizontalSpacing"] = 1
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["sizeOverride"] = 21
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["useBlacklist"] = false
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["enable"] = true
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["yOffset"] = -9
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["clickTrough"] = true
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["useFilter"] = "Whitlist (Strict)"
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["xOffset"] = -4
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["perrow"] = 2
	E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["font"] = "Merathilis Prototype"
	E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["size"] = 26
	E.db["unitframe"]["units"]["raid40"]["growthDirection"] = "RIGHT_UP"
	E.db["unitframe"]["units"]["raid40"]["groupBy"] = "ROLE"
	E.db["unitframe"]["units"]["raid40"]["classHover"] = true
	E.db["unitframe"]["units"]["raid40"]["orientation"] = "MIDDLE"
	E.db["unitframe"]["units"]["raid40"]["roleIcon"]["enable"] = true
	E.db["unitframe"]["units"]["raid40"]["roleIcon"]["position"] = "RIGHT"
	E.db["unitframe"]["units"]["raid40"]["roleIcon"]["attachTo"] = "InfoPanel"
	E.db["unitframe"]["units"]["raid40"]["roleIcon"]["damager"] = true
	E.db["unitframe"]["units"]["raid40"]["roleIcon"]["tank"] = true
	E.db["unitframe"]["units"]["raid40"]["roleIcon"]["heal"] = true
	E.db["unitframe"]["units"]["raid40"]["roleIcon"]["size"] = 9
	E.db["unitframe"]["units"]["raid40"]["roleIcon"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid40"]["roleIcon"]["yOffset"] = 0
	E.db["unitframe"]["units"]["raid40"]["raidWideSorting"] = false
	E.db["unitframe"]["units"]["raid40"]["healPrediction"] = true
	E.db["unitframe"]["units"]["raid40"]["health"]["frequentUpdates"] = true
	E.db["unitframe"]["units"]["raid40"]["width"] = 69
	E.db["unitframe"]["units"]["raid40"]["infoPanel"]["enable"] = true
	E.db["unitframe"]["units"]["raid40"]["infoPanel"]["transparent"] = true
	E.db["unitframe"]["units"]["raid40"]["verticalSpacing"] = 1
	E.db["unitframe"]["units"]["raid40"]["name"]["attachTextTo"] = "InfoPanel"
	E.db["unitframe"]["units"]["raid40"]["positionOverride"] = "BOTTOMRIGHT"
	E.db["unitframe"]["units"]["raid40"]["height"] = 35
	E.db["unitframe"]["units"]["raid40"]["buffs"]["noConsolidated"] = false
	E.db["unitframe"]["units"]["raid40"]["buffs"]["sizeOverride"] = 17
	E.db["unitframe"]["units"]["raid40"]["buffs"]["useBlacklist"] = false
	E.db["unitframe"]["units"]["raid40"]["buffs"]["noDuration"] = false
	E.db["unitframe"]["units"]["raid40"]["buffs"]["playerOnly"] = false
	E.db["unitframe"]["units"]["raid40"]["buffs"]["perrow"] = 1
	E.db["unitframe"]["units"]["raid40"]["buffs"]["anchorPoint"] = "CENTER"
	E.db["unitframe"]["units"]["raid40"]["buffs"]["clickTrough"] = true
	E.db["unitframe"]["units"]["raid40"]["buffs"]["useFilter"] = "TurtleBuffs"
	E.db["unitframe"]["units"]["raid40"]["buffs"]["enable"] = true
	E.db["unitframe"]["units"]["raid40"]["power"]["attachTextTo"] = "Health"
	E.db["unitframe"]["units"]["raid40"]["power"]["height"] = 3
	E.db["unitframe"]["units"]["raid40"]["power"]["enable"] = true
	E.db["unitframe"]["units"]["raid40"]["power"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["raid40"]["raidicon"]["attachTo"] = "LEFT"
	E.db["unitframe"]["units"]["raid40"]["raidicon"]["yOffset"] = 0
	E.db["unitframe"]["units"]["raid40"]["raidicon"]["xOffset"] = 9
	E.db["unitframe"]["units"]["raid40"]["raidicon"]["size"] = 13
	E.db["movers"]["ElvUF_Raid40Mover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,185"
	
	-- Party
	E.db["unitframe"]["units"]["party"]["height"] = 26
	E.db["unitframe"]["units"]["party"]["width"] = 180
	E.db["unitframe"]["units"]["party"]["growthDirection"] = "UP_RIGHT"
	E.db["unitframe"]["units"]["party"]["healPrediction"] = true
	E.db["unitframe"]["units"]["party"]["colorOverride"] = "USE_DEFAULT"
	E.db["unitframe"]["units"]["party"]["debuffs"]["anchorPoint"] = "RIGHT"
	E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] = 24
	E.db["unitframe"]["units"]["party"]["debuffs"]["xOffset"] = 1
	E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = 8
	E.db["unitframe"]["units"]["party"]["debuffs"]["numrows"] = 2
	E.db["unitframe"]["units"]["party"]["debuffs"]["perrow"] = 5
	E.db["unitframe"]["units"]["party"]["debuffs"]["fontSize"] = 12
	E.db["unitframe"]["units"]["party"]["showPlayer"] = true
	E.db["unitframe"]["units"]["party"]["GPSArrow"]["size"] = 40
	E.db["unitframe"]["units"]["party"]["health"]["position"] = "RIGHT"
	E.db["unitframe"]["units"]["party"]["health"]["text_format"] = "[healthcolor][health:current] - [namecolor][power:current]"
	E.db["unitframe"]["units"]["party"]["health"]["xOffset"] = 2
	E.db["unitframe"]["units"]["party"]["health"]["yOffset"] = 0
	E.db["unitframe"]["units"]["party"]["health"]["attachTextTo"] = "InfoPanel"
	E.db["unitframe"]["units"]["party"]["name"]["text_format"] = ""
	E.db["unitframe"]["units"]["party"]["roleIcon"]["enable"] = true
	E.db["unitframe"]["units"]["party"]["roleIcon"]["tank"] = true
	E.db["unitframe"]["units"]["party"]["roleIcon"]["healer"] = true
	E.db["unitframe"]["units"]["party"]["roleIcon"]["damager"] = true
	E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "TOPRIGHT"
	E.db["unitframe"]["units"]["party"]["roleIcon"]["attachTo"] = "Frame"
	E.db["unitframe"]["units"]["party"]["roleIcon"]["size"] = 12
	E.db["unitframe"]["units"]["party"]["roleIcon"]["xOffset"] = 0
	E.db["unitframe"]["units"]["party"]["roleIcon"]["yOffset"] = -2
	E.db["unitframe"]["units"]["party"]["raidRoleIcons"]["position"] = "TOPRIGHT"
	if not E.db["unitframe"]["units"]["party"]["customTexts"] then E.db["unitframe"]["units"]["party"]["customTexts"] = {} end
	E.db["unitframe"]["units"]["party"]["customTexts"] = {}
	E.db["unitframe"]["units"]["party"]["customTexts"]["HealthText"] = {}
	E.db["unitframe"]["units"]["party"]["customTexts"]["HealthText"]["font"] = "Merathilis Tukui"
	E.db["unitframe"]["units"]["party"]["customTexts"]["HealthText"]["justifyH"] = "CENTER"
	E.db["unitframe"]["units"]["party"]["customTexts"]["HealthText"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["units"]["party"]["customTexts"]["HealthText"]["xOffset"] = 0
	E.db["unitframe"]["units"]["party"]["customTexts"]["HealthText"]["yOffset"] = 0
	E.db["unitframe"]["units"]["party"]["customTexts"]["HealthText"]["text_format"] = "[healthcolor][health:deficit]"
	E.db["unitframe"]["units"]["party"]["customTexts"]["HealthText"]["size"] = 10
	E.db["unitframe"]["units"]["party"]["customTexts"]["HealthText"]["attachTextTo"] = "InfoPanel"
	E.db["unitframe"]["units"]["party"]["customTexts"]["LevelClass"] = {}
	E.db["unitframe"]["units"]["party"]["customTexts"]["LevelClass"]["font"] = "Merathilis Tukui"
	E.db["unitframe"]["units"]["party"]["customTexts"]["LevelClass"]["justifyH"] = "LEFT"
	E.db["unitframe"]["units"]["party"]["customTexts"]["LevelClass"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["units"]["party"]["customTexts"]["LevelClass"]["xOffset"] = 0
	E.db["unitframe"]["units"]["party"]["customTexts"]["LevelClass"]["yOffset"] = 0
	E.db["unitframe"]["units"]["party"]["customTexts"]["LevelClass"]["text_format"] = "[namecolor][smartclass] [difficultycolor][level]"
	E.db["unitframe"]["units"]["party"]["customTexts"]["LevelClass"]["size"] = 12
	E.db["unitframe"]["units"]["party"]["customTexts"]["LevelClass"]["attachTextTo"] = "InfoPanel"
	E.db["unitframe"]["units"]["party"]["customTexts"]["BigName"] = {}
	E.db["unitframe"]["units"]["party"]["customTexts"]["BigName"]["font"] = 'Merathilis Tukui'
	E.db["unitframe"]["units"]["party"]["customTexts"]["BigName"]["justifyH"] = "LEFT"
	E.db["unitframe"]["units"]["party"]["customTexts"]["BigName"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["units"]["party"]["customTexts"]["BigName"]["xOffset"] = 0
	E.db["unitframe"]["units"]["party"]["customTexts"]["BigName"]["yOffset"] = 0
	E.db["unitframe"]["units"]["party"]["customTexts"]["BigName"]["text_format"] = "[name:medium] [difficultycolor][smartlevel] [shortclassification]"
	E.db["unitframe"]["units"]["party"]["customTexts"]["BigName"]["size"] = 20
	E.db["unitframe"]["units"]["party"]["customTexts"]["BigName"]["attachTextTo"] = "Health"
	E.db["unitframe"]["units"]["party"]["threatStyle"] = "INFOPANELBORDER"
	E.db["unitframe"]["units"]["party"]["verticalSpacing"] = 15
	E.db["unitframe"]["units"]["party"]["horizontalSpacing"] = 0
	E.db["unitframe"]["units"]["party"]["raidicon"]["attachTo"] = "TOP"
	E.db["unitframe"]["units"]["party"]["raidicon"]["attachToObject"] = "Health"
	E.db["unitframe"]["units"]["party"]["raidicon"]["xOffset"] = 0
	E.db["unitframe"]["units"]["party"]["raidicon"]["size"] = 15
	E.db["unitframe"]["units"]["party"]["raidicon"]["yOffset"] = 0
	E.db["unitframe"]["units"]["party"]["power"]["text_format"] = ""
	E.db["unitframe"]["units"]["party"]["power"]["height"] = 4
	E.db["unitframe"]["units"]["party"]["power"]["position"] = "LEFT"
	E.db["unitframe"]["units"]["party"]["power"]["yOffset"] = 0
	E.db["unitframe"]["units"]["party"]["buffs"]["enable"] = true
	E.db["unitframe"]["units"]["party"]["buffs"]["yOffset"] = 6
	E.db["unitframe"]["units"]["party"]["buffs"]["xOffset"] = 25
	E.db["unitframe"]["units"]["party"]["buffs"]["anchorPoint"] = "CENTER"
	E.db["unitframe"]["units"]["party"]["buffs"]["attachTo"] = "Frame"
	E.db["unitframe"]["units"]["party"]["buffs"]["clickTrough"] = false
	E.db["unitframe"]["units"]["party"]["buffs"]["useBlacklist"] = false
	E.db["unitframe"]["units"]["party"]["buffs"]["noDuration"] = false
	E.db["unitframe"]["units"]["party"]["buffs"]["playerOnly"] = false
	E.db["unitframe"]["units"]["party"]["buffs"]["perrow"] = 1
	E.db["unitframe"]["units"]["party"]["buffs"]["useFilter"] = "TurtleBuffs"
	E.db["unitframe"]["units"]["party"]["buffs"]["noConsolidated"] = false
	E.db["unitframe"]["units"]["party"]["buffs"]["sizeOverride"] = 22
	E.db["unitframe"]["units"]["party"]["portrait"]["enable"] = true
	E.db["unitframe"]["units"]["party"]["portrait"]["overlay"] = false
	E.db["unitframe"]["units"]["party"]["portrait"]["width"] = 40
	E.db["unitframe"]["units"]["party"]["portrait"]["height"] = 0
	E.db["unitframe"]["units"]["party"]["portrait"]["camDistanceScale"] = 1.2
	E.db["unitframe"]["units"]["party"]["portrait"]["style"] = "3D"
	E.db["unitframe"]["units"]["party"]["portrait"]["transparent"] = true
	E.db["unitframe"]["units"]["party"]["rdebuffs"]["enable"] = false
	E.db["unitframe"]["units"]["party"]["infoPanel"]["enable"] = true
	E.db["unitframe"]["units"]["party"]["infoPanel"]["height"] = 13
	E.db["unitframe"]["units"]["party"]["infoPanel"]["transparent"] = true
	E.db["movers"]["ElvUF_PartyMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,200"
	
	-- Assist
	E.db["unitframe"]["units"]["assist"]["enable"] = false
	E.db["movers"]["ElvUF_AssistMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,2,571"
	
	-- Tank
	E.db["unitframe"]["units"]["tank"]["enable"] = false
	E.db["movers"]["ElvUF_TankMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,2,626"
	
	-- Pet
	E.db["unitframe"]["units"]["pet"]["castbar"]["enable"] = true
	E.db["unitframe"]["units"]["pet"]["castbar"]["latency"] = true
	E.db["unitframe"]["units"]["pet"]["castbar"]["insideInfoPanel"] = true
	E.db["unitframe"]["units"]["pet"]["debuffs"]["fontSize"] = 10
	E.db["unitframe"]["units"]["pet"]["debuffs"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["pet"]["debuffs"]["sizeOverride"] = 0
	E.db["unitframe"]["units"]["pet"]["debuffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["debuffs"]["yOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["debuffs"]["perrow"] = 5
	E.db["unitframe"]["units"]["pet"]["debuffs"]["anchorPoint"] = "TOPLEFT"
	E.db["unitframe"]["units"]["pet"]["health"]["position"] = "LEFT"
	E.db["unitframe"]["units"]["pet"]["health"]["text_format"] = "[healthcolor][health:current]"
	E.db["unitframe"]["units"]["pet"]["health"]["xOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["health"]["yOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["health"]["attachTextTo"] = "InfoPanel"
	E.db["unitframe"]["units"]["pet"]["power"]["position"] = "RIGHT"
	E.db["unitframe"]["units"]["pet"]["power"]["height"] = 4
	E.db["unitframe"]["units"]["pet"]["power"]["text_format"] = "[namecolor][power:current]"
	E.db["unitframe"]["units"]["pet"]["power"]["xOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["power"]["yOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["power"]["attachTextTo"] = "InfoPanel"
	E.db["unitframe"]["units"]["pet"]["width"] = 90
	E.db["unitframe"]["units"]["pet"]["height"] = 40
	E.db["unitframe"]["units"]["pet"]["power"]["height"] = 4
	E.db["unitframe"]["units"]["pet"]["portrait"]["enable"] = true
	E.db["unitframe"]["units"]["pet"]["portrait"]["overlay"] = true
	E.db["unitframe"]["units"]["pet"]["orientation"] = "MIDDLE"
	E.db["unitframe"]["units"]["pet"]["infoPanel"]["enable"] = true
	E.db["unitframe"]["units"]["pet"]["infoPanel"]["height"] = 13
	E.db["unitframe"]["units"]["pet"]["infoPanel"]["transparent"] = true
	E.db["movers"]["ElvUF_PetMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,498,141"
	
	-- Arena
	E.db["unitframe"]["units"]["arena"]["power"]["width"] = "inset"
	E.db["movers"]["ArenaHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-150,-305"
	
	-- Boss
	E.db["unitframe"]["units"]["boss"]["castbar"]["latency"] = true
	E.db["unitframe"]["units"]["boss"]["castbar"]["width"] = 155
	E.db["unitframe"]["units"]["boss"]["castbar"]["height"] = 16
	E.db["unitframe"]["units"]["boss"]["castbar"]["insideInfoPanel"] = true
	E.db["unitframe"]["units"]["boss"]["castbar"]["iconSize"] = 26
	E.db["unitframe"]["units"]["boss"]["buffs"]["sizeOverride"] = 26
	E.db["unitframe"]["units"]["boss"]["buffs"]["yOffset"] = 7
	E.db["unitframe"]["units"]["boss"]["buffs"]["xOffset"] = -2
	E.db["unitframe"]["units"]["boss"]["buffs"]["anchorPoint"] = "LEFT"
	E.db["unitframe"]["units"]["boss"]["buffs"]["attachTo"] = "Frame"
	E.db["unitframe"]["units"]["boss"]["debuffs"]["anchorPoint"] = "RIGHT"
	E.db["unitframe"]["units"]["boss"]["debuffs"]["yOffset"] = 10
	E.db["unitframe"]["units"]["boss"]["debuffs"]["xOffset"] = 2
	E.db["unitframe"]["units"]["boss"]["debuffs"]["perrow"] = 5
	E.db["unitframe"]["units"]["boss"]["debuffs"]["attachTo"] = "Frame"
	E.db["unitframe"]["units"]["boss"]["portrait"]["enable"] = true
	E.db["unitframe"]["units"]["boss"]["portrait"]["overlay"] = false
	E.db["unitframe"]["units"]["boss"]["power"]["enable"] = true
	E.db["unitframe"]["units"]["boss"]["power"]["height"] = 4
	E.db["unitframe"]["units"]["boss"]["power"]["position"] = "LEFT"
	E.db["unitframe"]["units"]["boss"]["name"]["xOffset"] = 6
	E.db["unitframe"]["units"]["boss"]["name"]["yOffset"] = 16
	E.db["unitframe"]["units"]["boss"]["name"]["position"] = "RIGHT"
	E.db["unitframe"]["units"]["boss"]["name"]["text_format"] = ""
	E.db["unitframe"]["units"]["boss"]["width"] = 156
	E.db["unitframe"]["units"]["boss"]["height"] = 40
	E.db["unitframe"]["units"]["boss"]["spacing"] = 27
	E.db["unitframe"]["units"]["boss"]["growthDirection"] = "UP"
	E.db["unitframe"]["units"]["boss"]["threatStyle"] = "HEALTHBORDER"
	E.db["unitframe"]["units"]["boss"]["infoPanel"]["enable"] = true
	E.db["unitframe"]["units"]["boss"]["infoPanel"]["height"] = 13
	E.db["unitframe"]["units"]["boss"]["infoPanel"]["transparent"] = true
	E.db["unitframe"]["units"]["boss"]["health"]["position"] = "RIGHT"
	E.db["unitframe"]["units"]["boss"]["health"]["text_format"] = "[healthcolor][health:current] - [namecolor][power:current]"
	E.db["unitframe"]["units"]["boss"]["health"]["attachTextTo"] = "InfoPanel"
	if not E.db["unitframe"]["units"]["boss"]["customTexts"] then E.db["unitframe"]["units"]["boss"]["customTexts"] = {} end
	E.db["unitframe"]["units"]["boss"]["customTexts"]["BigName"] = {}
	E.db["unitframe"]["units"]["boss"]["customTexts"]["BigName"]["font"] = "Merathilis Tukui"
	E.db["unitframe"]["units"]["boss"]["customTexts"]["BigName"]["justifyH"] = "LEFT"
	E.db["unitframe"]["units"]["boss"]["customTexts"]["BigName"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["units"]["boss"]["customTexts"]["BigName"]["xOffset"] = 0
	E.db["unitframe"]["units"]["boss"]["customTexts"]["BigName"]["yOffset"] = 0
	E.db["unitframe"]["units"]["boss"]["customTexts"]["BigName"]["text_format"] = "[name:medium] [difficultycolor][smartlevel] [shortclassification]"
	E.db["unitframe"]["units"]["boss"]["customTexts"]["BigName"]["size"] = 16
	E.db["unitframe"]["units"]["boss"]["customTexts"]["BigName"]["attachTextTo"] = "Health"
	E.db["unitframe"]["units"]["boss"]["customTexts"]["Class"] = {}
	E.db["unitframe"]["units"]["boss"]["customTexts"]["Class"]["font"] = "Merathilis Tukui"
	E.db["unitframe"]["units"]["boss"]["customTexts"]["Class"]["size"] = 12
	E.db["unitframe"]["units"]["boss"]["customTexts"]["Class"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["units"]["boss"]["customTexts"]["Class"]["justifyH"] = "LEFT"
	E.db["unitframe"]["units"]["boss"]["customTexts"]["Class"]["text_format"] = "[namecolor][smartclass] [difficultycolor][level]"
	E.db["unitframe"]["units"]["boss"]["customTexts"]["Class"]["attachTextTo"] = "InfoPanel"
	E.db["unitframe"]["units"]["boss"]["customTexts"]["Percent"] = {}
	E.db["unitframe"]["units"]["boss"]["customTexts"]["Percent"]["font"] = "Merathilis Tukui"
	E.db["unitframe"]["units"]["boss"]["customTexts"]["Percent"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["units"]["boss"]["customTexts"]["Percent"]["size"] = 16
	E.db["unitframe"]["units"]["boss"]["customTexts"]["Percent"]["justifyH"] = "RIGHT"
	E.db["unitframe"]["units"]["boss"]["customTexts"]["Percent"]["text_format"] = "[namecolor][health:percent:hidefull:hidezero]"
	E.db["unitframe"]["units"]["boss"]["customTexts"]["Percent"]["attachTextTo"] = "Health"
	E.db["movers"]["BossHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-230,-404"
	
	-- Bodyguard
	E.db["movers"]["ElvUF_BodyGuardMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-452,167"
	
	-- PetTarget
	E.db["unitframe"]["units"]["pettarget"]["enable"] = false
	
	-- RaidPet
	E.db["unitframe"]["units"]["raidpet"]["enable"] = false
	E.db["movers"]["ElvUF_RaidpetMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,0,808"

	if InstallStepComplete then
		InstallStepComplete.message = MER.Title..L['Unitframes Set']
		InstallStepComplete:Show()
		titleText[6].check:Show()
	end
	E:UpdateAll(true)
end

function MER:SetupDts(role)
	-- Data Texts
	E.db["datatexts"]["font"] = "Merathilis Roadway"
	E.db["datatexts"]["fontSize"] = 13
	E.db["datatexts"]["fontOutline"] = "OUTLINE"
	E.db["datatexts"]["time24"] = true
	E.db["datatexts"]["goldCoins"] = true
	E.db["datatexts"]["noCombatHover"] = true
	E.db["datatexts"]["panelTransparency"] = true
	E.db["datatexts"]["wordWrap"] = false

	if IsAddOnLoaded('ElvUI_BenikUI') then
		E.db["datatexts"]["leftChatPanel"] = false
		E.db["datatexts"]["rightChatPanel"] = false
		E.db["datatexts"]["minimapPanels"] = true
		E.db["datatexts"]["actionbar3"] = false
		E.db["datatexts"]["actionbar5"] = false
	else
		E.db["datatexts"]["leftChatPanel"] = true
		E.db["datatexts"]["rightChatPanel"] = true
		E.db["datatexts"]["minimapPanels"] = true
		E.db["datatexts"]["actionbar3"] = true
		E.db["datatexts"]["actionbar5"] = true
	end

	if IsAddOnLoaded('ElvUI_SLE') then
		E.db["datatexts"]["panels"]["LeftMiniPanel"] = "S&L Guild"
		E.db["datatexts"]["panels"]["RightMiniPanel"] = "S&L Friends"
	else
		E.db["datatexts"]["panels"]["LeftMiniPanel"] = "Guild"
		E.db["datatexts"]["panels"]["RightMiniPanel"] = "Friends"
	end

	if IsAddOnLoaded('ElvUI_BenikUI') then
		-- define BenikUI Datetexts
		if role == 'tank' then
			E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"]["right"] = "Attack Power"
		elseif role == 'dpsMelee' then
			E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"]["right"] = "Attack Power"
		elseif role == 'healer' or 'dpsCaster' then
			E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"]["right"] = "Spell/Heal Power"
		end
		E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"]["left"] = "MUI Talent/Loot Specialization"
		E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"]["middle"] = "Durability"
		E.db["datatexts"]["panels"]["BuiRightChatDTPanel"]["middle"] = "Orderhall"
		E.db["datatexts"]["panels"]["BuiRightChatDTPanel"]["right"] = "BuiMail"
		
		if IsAddOnLoaded('Skada') then
			E.db["datatexts"]["panels"]["BuiRightChatDTPanel"]["left"] = "Skada"
		else
			E.db["datatexts"]["panels"]["BuiRightChatDTPanel"]["left"] = "Bags"
		end
		
		if IsAddOnLoaded('ElvUI_SLE') then
			E.db["datatexts"]["panels"]["BuiMiddleDTPanel"]["right"] = "S&L Currency"
		else
			E.db["datatexts"]["panels"]["BuiMiddleDTPanel"]["right"] = "Gold"
		end
		
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"]["left"] = "MUI System"
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"]["middle"] = "Time"
		
		E.db["datatexts"]["panels"]["RightChatDataPanel"]["middle"] = ""
		E.db["datatexts"]["panels"]["RightChatDataPanel"]["right"] = ""
		E.db["datatexts"]["panels"]["RightChatDataPanel"]["left"] = ""
		
		E.db["datatexts"]["panels"]["LeftChatDataPanel"]["left"] = ""
		E.db["datatexts"]["panels"]["LeftChatDataPanel"]["middle"] = ""
		E.db["datatexts"]["panels"]["LeftChatDataPanel"]["right"] = ""
	else
		-- define the default ElvUI datatexts
		if role == 'tank' then
			E.db["datatexts"]["panels"]["LeftChatDataPanel"]["right"] = "Attack Power"
		elseif role == 'dpsMelee' then
			E.db["datatexts"]["panels"]["LeftChatDataPanel"]["right"] = "Attack Power"
		elseif role == 'healer' or 'dpsCaster' then
			E.db["datatexts"]["panels"]["LeftChatDataPanel"]["right"] = "Spell/Heal Power"
		end
		E.db["datatexts"]["panels"]["LeftChatDataPanel"]["left"] = "MUI Talent/Loot Specialization"
		E.db["datatexts"]["panels"]["LeftChatDataPanel"]["middle"] = "Durability"
		
		if IsAddOnLoaded('Skada') then
			E.db["datatexts"]["panels"]["RightChatDataPanel"]["left"] = "Skada"
		else
			E.db["datatexts"]["panels"]["RightChatDataPanel"]["left"] = "MUI System"
		end
		E.db["datatexts"]["panels"]["RightChatDataPanel"]["middle"] = "Time"
		E.db["datatexts"]["panels"]["RightChatDataPanel"]["right"] = "Gold"
	end

	if InstallStepComplete then
		InstallStepComplete.message = MER.Title..L['DataTexts Set']
		InstallStepComplete:Show()
		titleText[4].check:Show()
	end
	E:UpdateAll(true)
end

local function SetupMERAddons()
	if InstallStepComplete then
		InstallStepComplete.message = MER.Title..L['Addons Set']
		InstallStepComplete:Show()
		titleText[7].check:Show()
	end
	E:UpdateAll(true)
end

local function InstallComplete()
	E.private.install_complete = E.version
	E.db.mui.installed = true
	
	ReloadUI()
end

MER.installTable = {
	["Name"] = "|cffff7d0aMerathilisUI|r",
	["Title"] = L["|cffff7d0aMerathilisUI|r Installation"],
 	["tutorialImage"] = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\merathilis_logo.tga]],
 	["Pages"] = {
		[1] = function()
			PluginInstallFrame.SubTitle:SetFormattedText(L['Welcome to MerathilisUI |cff00c0faVersion|r %s, for ElvUI %s.'], MER.Version, E.version)
			PluginInstallFrame.Desc1:SetFormattedText("%s", L["By pressing the Continue button, MerathilisUI will be applied in your current ElvUI installation.\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"])
			PluginInstallFrame.Desc2:SetFormattedText("%s", L['Please press the continue button to go onto the next step.'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', InstallComplete)
			PluginInstallFrame.Option1:SetText(L['Skip Process'])
		end,
		[2] = function()
			PluginInstallFrame.SubTitle:SetText(L['Layout'])
			PluginInstallFrame.Desc1:SetFormattedText("%s", L['This part of the installation changes the default ElvUI look.'])
			PluginInstallFrame.Desc2:SetFormattedText("%s", L['Please click the button below to apply the new layout.'])
			PluginInstallFrame.Desc3:SetFormattedText("%s", L['Importance: |cff07D400High|r'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', function() SetupMERLayout('Layout') end)
			PluginInstallFrame.Option1:SetFormattedText("%s", L['Layout'])
		end,
		[3] = function()
			PluginInstallFrame.SubTitle:SetFormattedText("%s", L['Chat'])
			PluginInstallFrame.Desc1:SetFormattedText("%s", L['This part of the installation process sets up your chat fonts and colors.'])
			PluginInstallFrame.Desc2:SetFormattedText("%s", L['Please click the button below to setup your chat windows.'])
			PluginInstallFrame.Desc3:SetFormattedText("%s", L['Importance: |cffD3CF00Medium|r'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', SetupMERChat)
			PluginInstallFrame.Option1:SetFormattedText("%s", L['Setup Chat'])
		end,
		[4] = function()
			PluginInstallFrame.SubTitle:SetFormattedText("%s", L['DataTexts'])
			PluginInstallFrame.Desc1:SetFormattedText("%s", L["This part of the installation process will fill MerathilisUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"])
			PluginInstallFrame.Desc2:SetFormattedText("%s", L['Please click the button below to setup your datatexts.'])
			PluginInstallFrame.Desc3:SetFormattedText("%s", L['Importance: |cffD3CF00Medium|r'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', function() MER:SetupDts('tank') end)
			PluginInstallFrame.Option1:SetFormattedText("%s", _G["TANK"])
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript('OnClick', function() MER:SetupDts('healer') end)
			PluginInstallFrame.Option2:SetFormattedText("%s", _G["HEALER"])
			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript('OnClick', function() MER:SetupDts('dpsMelee') end)
			PluginInstallFrame.Option3:SetFormattedText("%s", L['Physical DPS'])
			PluginInstallFrame.Option4:Show()
			PluginInstallFrame.Option4:SetScript('OnClick', function() MER:SetupDts('dpsCaster') end)
			PluginInstallFrame.Option4:SetFormattedText("%s", L['Caster DPS'])
		end,
		[5] = function()
			PluginInstallFrame.SubTitle:SetText(L['ActionBars'])
			PluginInstallFrame.Desc1:SetFormattedText("%s", L['This part of the installation process will reposition your Actionbars and will enable backdrops'])
			PluginInstallFrame.Desc2:SetFormattedText("%s", L['Please click the button below to setup your actionbars.'])
			PluginInstallFrame.Desc3:SetFormattedText("%s", L['Importance: |cff07D400High|r'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', function() SetupMERActionbars('small') end)
			PluginInstallFrame.Option1:SetFormattedText("%s", L['Setup ActionBars'].." - 1")
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript('OnClick', function() SetupMERActionbars('big') end)
			PluginInstallFrame.Option2:SetFormattedText("%s", L['Setup ActionBars'].." - 2")
		end,
		[6] = function()
			PluginInstallFrame.SubTitle:SetFormattedText("%s", L['UnitFrames'])
			PluginInstallFrame.Desc1:SetFormattedText("%s", L['This part of the installation process will reposition your Unitframes.'])
			PluginInstallFrame.Desc2:SetFormattedText("%s", L['Please click the button below to setup your Unitframes.'])
			PluginInstallFrame.Desc3:SetFormattedText("%s", L['Importance: |cff07D400High|r'])
			-- PluginInstallFrame.Desc4:SetFormattedText("%s", L['Buttons must be clicked twice'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', function() SetupUnitframes() end)
			PluginInstallFrame.Option1:SetFormattedText("%s", L['Setup Unitframes'])
		end,
		[7] = function()
			PluginInstallFrame.SubTitle:SetFormattedText("%s", ADDONS)
			PluginInstallFrame.Desc1:SetFormattedText("%s", L['This part of the installation process will apply changes to Skada and ElvUI plugins'])
			PluginInstallFrame.Desc2:SetFormattedText("%s", L['Please click the button below to setup your addons.'])
			PluginInstallFrame.Desc3:SetFormattedText("%s", L['Importance: |cffD3CF00Medium|r'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', function() MER:SetupMERAddons(); SetupMERAddons(); end)
			PluginInstallFrame.Option1:SetFormattedText("%s", L['Setup Addons'])
		end,
		[8] = function()
			PluginInstallFrame.SubTitle:SetFormattedText("%s", L['Installation Complete'])
			PluginInstallFrame.Desc1:SetFormattedText("%s", L['You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org.'])
			PluginInstallFrame.Desc2:SetFormattedText("%s", L['Please click the button below so you can setup variables and ReloadUI.'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', InstallComplete)
			PluginInstallFrame.Option1:SetFormattedText("%s", L['Finished'])
			if InstallStepComplete then
				InstallStepComplete.message = MER.Title..L['Installed']
				InstallStepComplete:Show()
			end
		end,
	},

	["StepTitles"] = {
		[1] = START,
		[2] = L['Layout'],
		[3] = L['Chat'],
		[4] = L['DataTexts'],
		[5] = L['ActionBars'],
		[6] = L['UnitFrames'],
		[7] = ADDONS,
		[8] = L['Installation Complete'],
	},
	["StepTitlesColorSelected"] = RAID_CLASS_COLORS[E.myclass],
}
