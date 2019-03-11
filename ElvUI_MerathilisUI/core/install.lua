local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local _G = _G
local ceil, format, checkTable = ceil, format, next
local tinsert, twipe, tsort, tconcat = table.insert, table.wipe, table.sort, table.concat
-- WoW API / Variables
local ADDONS = ADDONS
local FCF_DockFrame = FCF_DockFrame
local FCF_GetChatWindowInfo = FCF_GetChatWindowInfo
local FCF_SavePositionAndDimensions = FCF_SavePositionAndDimensions
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local FCF_SetLocked = FCF_SetLocked
local FCF_SetWindowName = FCF_SetWindowName
local FCF_StopDragging = FCF_StopDragging
local FCF_UnDockFrame = FCF_UnDockFrame
local GetAddOnMetadata = GetAddOnMetadata
local IsAddOnLoaded = IsAddOnLoaded
local LOOT = LOOT
local ReloadUI = ReloadUI
local SetCVar = SetCVar
local TRADE = TRADE

-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: PluginInstallFrame, InstallStepComplete, PluginInstallStepComplete, NUM_CHAT_WINDOWS, LeftChatToggleButton
-- GLOBALS: ChatFrame1, ChatFrame3, ChatFrame_RemoveChannel, ChatFrame_AddChannel, ChatFrame_AddMessageGroup
-- GLOBALS: ToggleChatColorNamesByClassGroup, Skada, SkadaDB, BigWigs3DB

local function SetupCVars()
	-- Setup CVar
	SetCVar("autoQuestProgress", 1)
	SetCVar("autoDismountFlying", 1)
	SetCVar("guildMemberNotify", 1)
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("removeChatDelay", 1)
	SetCVar("TargetNearestUseNew", 1)
	SetCVar("screenshotQuality", 10)
	SetCVar("showTutorials", 0)
	SetCVar("cameraSmoothStyle", 0)
	SetCVar("cameraDistanceMaxZoomFactor", 2.6)
	SetCVar("UberTooltips", 1)
	SetCVar("lockActionBars", 1)
	SetCVar("chatMouseScroll", 1)
	SetCVar("chatStyle", "classic")
	SetCVar("whisperMode", "inline")
	SetCVar("violenceLevel", 5)
	SetCVar("blockTrades", 0)
	SetCVar("countdownForCooldowns", 1)
	SetCVar("showQuestTrackingTooltips", 1)
	SetCVar("ffxGlow", 0)
	SetCVar("WorldTextScale", 0.75)
	SetCVar("floatingCombatTextCombatState", "1")

	--nameplates
	SetCVar("nameplateMinAlpha", .6) -- Override Elv's

	-- Disable it because of NSCT
	SetCVar("floatingCombatTextCombatDamage", 0)
	SetCVar("floatingCombatTextCombatLogPeriodicSpells", 0)
	SetCVar("floatingCombatTextCombatHealing", 1)

	if MER:IsDeveloper() and MER:IsDeveloperRealm() then
		SetCVar("scriptErrors", 1)
		SetCVar("taintLog", 1)
	else
		SetCVar("scriptErrors", 0)
		SetCVar("taintLog", 0)
	end

	PluginInstallStepComplete.message = MER.Title..L["CVars Set"]
	PluginInstallStepComplete:Show()
end

local function SetupChat()
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format("ChatFrame%s", i)]
		local chatFrameId = frame:GetID()
		local chatName = FCF_GetChatWindowInfo(chatFrameId)

		FCF_SetChatWindowFontSize(nil, frame, 11)

		-- move ElvUI default loot frame to the left chat, so that Recount/Skada can go to the right chat.
		if i == 3 and chatName == LOOT.." / "..TRADE then
			FCF_UnDockFrame(frame)
			frame:ClearAllPoints()
			frame:Point("BOTTOMLEFT", LeftChatToggleButton, "TOPLEFT", 1, 3)
			FCF_SetWindowName(frame, LOOT)
			FCF_DockFrame(frame)
			if not frame.isLocked then
				FCF_SetLocked(frame, 1)
			end
			frame:Show()
		end
		FCF_SavePositionAndDimensions(frame)
		FCF_StopDragging(frame)
	end
	ChatFrame_RemoveChannel(ChatFrame3, L["Trade"])
	ChatFrame_AddChannel(ChatFrame1, L["Trade"])
	ChatFrame_AddMessageGroup(ChatFrame1, "TARGETICONS")
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_GUILD_XP_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame3, "CURRENCY")
	ChatFrame_AddMessageGroup(ChatFrame3, "LOOT")
	ChatFrame_AddMessageGroup(ChatFrame3, "MONEY")
	ChatFrame_AddMessageGroup(ChatFrame3, "SKILL")

	-- Enable classcolor automatically on login and on each character without doing /configure each time
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL10")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL11")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL6")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL7")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL8")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL9")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
	ToggleChatColorNamesByClassGroup(true, "OFFICER")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "YELL")

	E.db["chat"]["keywordSound"] = "Whisper Alert"
	E.db["chat"]["panelTabTransparency"] = true
	E.db["chat"]["chatHistory"] = false
	E.db["chat"]["separateSizes"] = true
	E.db["chat"]["panelWidth"] = 427
	E.db["chat"]["panelHeight"] = 146
	E.db["chat"]["panelHeightRight"] = 146
	E.db["chat"]["panelWidthRight"] = 263
	E.db["chat"]["editBoxPosition"] = "ABOVE_CHAT"
	E.db["chat"]["panelBackdrop"] = "SHOWBOTH"
	E.db["chat"]["keywords"] = "%MYNAME%, ElvUI, MerathilisUI"
	E.db["chat"]["copyChatLines"] = true
	E.db["chat"]["panelColor"] = {r = .06, g = .06, b = .06, a = .45}
	E.db["chat"]["useCustomTimeColor"] = true
	E.db["chat"]["customTimeColor"] = {r = 0, g = 0.75, b = 0.98}
	E.db["chat"]["panelBackdropNameRight"] = ""
	E.db["chat"]["socialQueueMessages"] = true

	if MER:IsDeveloper() and MER:IsDeveloperRealm() then
		E.db["chat"]["timeStampFormat"] = "%H:%M "
	end

	E.db["chat"]["font"] = "Expressway"
	E.db["chat"]["fontOutline"] = "NONE"
	E.db["chat"]["tabFont"] = "Expressway"
	E.db["chat"]["tabFont"] = "Expressway"
	E.db["chat"]["tabFontOutline"] = "OUTLINE"
	E.db["chat"]["tabFontSize"] = 10

	MER:SetMoverPosition("RightChatMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -175, 50)
	MER:SetMoverPosition("LeftChatMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 10, 50)

	E:UpdateAll(true)

	PluginInstallStepComplete.message = MER.Title..L["Chat Set"]
	PluginInstallStepComplete:Show()
end

function MER:SetupLayout()
	--[[----------------------------------
	--	PrivateDB - General
	--]]----------------------------------
	E.private["general"]["pixelPerfect"] = true
	E.private["general"]["chatBubbles"] = "backdrop_noborder"
	E.private["general"]["chatBubbleFontSize"] = 9
	E.private["general"]["chatBubbleFontOutline"] = "OUTLINE"
	E.private["general"]["chatBubbleName"] = true
	E.private["general"]["classColorMentionsSpeech"] = true
	E.private["general"]["normTex"] = "Duffed"
	E.private["general"]["glossTex"] = "Duffed"
	if IsAddOnLoaded("XLoot") then
		E.private["general"]["loot"] = false
		E.private["general"]["lootRoll"] = false
	else
		E.private["general"]["loot"] = true
		E.private["general"]["lootRoll"] = true
	end

	--[[----------------------------------
	--	GlobalDB - General
	--]]----------------------------------
	E.global["general"]["autoScale"] = true
	E.global["general"]["animateConfig"] = false
	E.global["general"]["smallerWorldMap"] = false
	E.global["general"]["commandBarSetting"] = "ENABLED"

	--[[----------------------------------
	--	ProfileDB - General
	--]]----------------------------------
	E.db["general"]["valuecolor"] = {r = MER.r, g = MER.g, b = MER.b}
	E.db["general"]["bordercolor"] = { r = 0, g = 0, b = 0 }
	E.db["general"]["backdropfadecolor"] = { a = 0.45, r = 0, g = 0, b = 0 }
	E.db["general"]["totems"]["size"] = 36
	E.db["general"]["interruptAnnounce"] = "RAID"
	E.db["general"]["minimap"]["locationText"] = "MOUSEOVER"
	E.db["general"]["minimap"]["icons"]["classHall"]["position"] = "TOPRIGHT"
	E.db["general"]["minimap"]["icons"]["classHall"]["scale"] = 0.6
	E.db["general"]["minimap"]["icons"]["classHall"]["xOffset"] = 0
	E.db["general"]["minimap"]["icons"]["classHall"]["yOffset"] = 0
	E.db["general"]["minimap"]["icons"]["lfgEye"]["scale"] = 1.1
	E.db["general"]["minimap"]["icons"]["lfgEye"]["xOffset"] = 0
	E.db["general"]["minimap"]["icons"]["mail"]["position"] = "BOTTOMLEFT"
	E.db["general"]["minimap"]["icons"]["mail"]["scale"] = 1
	E.db["general"]["minimap"]["icons"]["mail"]["xOffset"] = 0
	E.db["general"]["minimap"]["icons"]["mail"]["yOffset"] = -5
	E.db["general"]["minimap"]["icons"]["ticket"]["position"] = "TOP"
	E.db["general"]["minimap"]["icons"]["ticket"]["xOffset"] = 0
	E.db["general"]["minimap"]["icons"]["ticket"]["yOffset"] = 0
	E.db["general"]["minimap"]["icons"]["ticket"]["scale"] = 0.75
	E.db["general"]["minimap"]["resetZoom"]["enable"] = true
	E.db["general"]["minimap"]["resetZoom"]["time"] = 5
	E.db["general"]["minimap"]["size"] = 144
	E.db["general"]["minimap"]["locationFontSize"] = 10
	E.db["general"]["minimap"]["locationFontOutline"] = "OUTLINE"
	E.db["general"]["minimap"]["locationFont"] = "Expressway"
	E.db["general"]["loginmessage"] = false
	E.db["general"]["stickyFrames"] = false
	E.db["general"]["vendorGrays"] = true
	E.db["general"]["vendorGraysDetails"] = true
	E.db["general"]["backdropcolor"]["r"] = 0.101
	E.db["general"]["backdropcolor"]["g"] = 0.101
	E.db["general"]["backdropcolor"]["b"] = 0.101
	E.db["general"]["bottomPanel"] = false
	E.db["general"]["topPanel"] = false
	E.db["general"]["bonusObjectivePosition"] = "AUTO"
	E.db["general"]["backdropfadecolor"]["r"] = 0.0549
	E.db["general"]["backdropfadecolor"]["g"] = 0.0549
	E.db["general"]["backdropfadecolor"]["b"] = 0.0549
	E.db["general"]["threat"]["enable"] = false
	E.db["general"]["numberPrefixStyle"] = "ENGLISH"
	E.db["general"]["talkingHeadFrameScale"] = 0.7
	E.db["general"]["talkingHeadFrameBackdrop"] = true
	E.db["general"]["decimalLenght"] = 0
	E.db["general"]["altPowerBar"]["enable"] = true
	E.db["general"]["altPowerBar"]["font"] = "Expressway"
	E.db["general"]["altPowerBar"]["fontSize"] = 11
	E.db["general"]["altPowerBar"]["fontOutline"] = "OUTLINE"
	E.db["general"]["altPowerBar"]["statusBar"] = "Duffed"
	E.db["general"]["altPowerBar"]["textFormat"] = "NAMECURMAXPERC"
	E.db["general"]["altPowerBar"]["statusBarColorGradient"] = true
	E.db["general"]["vehicleSeatIndicatorSize"] = 76
	E.db["general"]["displayCharacterInfo"] = true
	E.db["general"]["displayInspectInfo"] = true

	--[[----------------------------------
	--	ProfileDB - Auras
	--]]----------------------------------
	if IsAddOnLoaded("Masque") then
		E.private["auras"]["masque"]["buffs"] = true
		E.private["auras"]["masque"]["debuffs"] = true
	end
	E.db["auras"]["fadeThreshold"] = 10
	E.db["auras"]["font"] = "Merathilis Gothom Narrow"
	E.db["auras"]["fontOutline"] = "OUTLINE"
	E.db["auras"]["timeYOffset"] = 0
	E.db["auras"]["timeXOffset"] = 0
	E.db["auras"]["buffs"]["horizontalSpacing"] = 10
	E.db["auras"]["buffs"]["verticalSpacing"] = 15
	E.db["auras"]["buffs"]["size"] = 32
	E.db["auras"]["buffs"]["countFontsize"] = 12
	E.db["auras"]["buffs"]["durationFontSize"] = 12
	E.db["auras"]["buffs"]["wrapAfter"] = 10
	E.db["auras"]["debuffs"]["horizontalSpacing"] = 5
	E.db["auras"]["debuffs"]["size"] = 42
	E.db["auras"]["debuffs"]["countFontsize"] = 16
	E.db["auras"]["debuffs"]["durationFontSize"] = 16

	if E.db.mui.general.panels then
		MER:SetMoverPosition("BuffsMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -10, -17)
		MER:SetMoverPosition("DebuffsMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -10, -155)
	else
		MER:SetMoverPosition("BuffsMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -2, -3)
		MER:SetMoverPosition("DebuffsMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -2, -120)
	end

	--[[----------------------------------
	--	ProfileDB - Bags
	--]]----------------------------------
	E.db["bags"]["itemLevelFont"] = "Expressway"
	E.db["bags"]["itemLevelFontSize"] = 9
	E.db["bags"]["itemLevelFontOutline"] = "OUTLINE"
	E.db["bags"]["countFont"] = "Expressway"
	E.db["bags"]["countFontSize"] = 10
	E.db["bags"]["countFontOutline"] = "OUTLINE"
	E.db["bags"]["bagSize"] = 34
	E.db["bags"]["bagWidth"] = 442
	E.db["bags"]["bankSize"] = 34
	E.db["bags"]["bankWidth"] = 426
	E.db["bags"]["alignToChat"] = false
	E.db["bags"]["moneyFormat"] = "CONDENSED"
	E.db["bags"]["itemLevelThreshold"] = 1
	E.db["bags"]["junkIcon"] = true
	E.db["bags"]["strata"] = 'HIGH'
	E.db["bags"]["showBindType"] = true
	E.db["bags"]["scrapIcon"] = true
	E.db["bags"]["itemLevelCustomColorEnable"] = false

	-- Cooldown Settings
	E.db["bags"]["cooldown"]["fonts"]["enable"] = true
	E.db["bags"]["cooldown"]["fonts"]["font"] = "Expressway"
	E.db["bags"]["cooldown"]["fonts"]["fontOutline"] = "OUTLINE"
	E.db["bags"]["cooldown"]["fonts"]["fontSize"] = 14

	MER:SetMoverPosition("ElvUIBagMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -28, 50)
	MER:SetMoverPosition("ElvUIBankMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 10, 50)

	--[[----------------------------------
	--	ProfileDB - NamePlate
	--]]----------------------------------
	-- General
	E.db["nameplates"]["threat"]["useThreatColor"] = false
	E.db["nameplates"]["clampToScreen"] = true
	E.db["nameplates"]["colors"]["glowColor"] = {r = 0, g = 191/255, b = 250/255, a = 1}
	E.db["nameplates"]["font"] = "Expressway"
	E.db["nameplates"]["fontSize"] = 12
	E.db["nameplates"]["stackFont"] = "Expressway"
	E.db["nameplates"]["stackFontSize"] = 9

	-- Player
	E.db["nameplates"]["units"]["PLAYER"]["enable"] = false
	E.db["nameplates"]["units"]["PLAYER"]["health"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["PLAYER"]["health"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["PLAYER"]["name"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["PLAYER"]["name"]["fontSize"] = 11
	E.db["nameplates"]["units"]["PLAYER"]["name"]["format"] = '[name:abbrev]'
	E.db["nameplates"]["units"]["PLAYER"]["power"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["PLAYER"]["power"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["yOffset"] = 2
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["PLAYER"]["level"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["PLAYER"]["level"]["fontSize"] = 11
	E.db["nameplates"]["units"]["PLAYER"]["castbar"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["PLAYER"]["castbar"]["fontSize"] = 10
	E.db["nameplates"]["units"]["PLAYER"]["castbar"]["sourceInterrupt"] = true
	E.db["nameplates"]["units"]["PLAYER"]["castbar"]["sourceInterruptClassColor"] = true

	-- Friendly Player
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["format"] = '[name:abbrev]'
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["power"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["power"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["yOffset"] = 2
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["level"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["level"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["sourceInterrupt"] = true
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["sourceInterruptClassColor"] = true

	-- Enemy Player
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["format"] = '[name:abbrev]'
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["yOffset"] = 2
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["level"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["level"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["sourceInterrupt"] = true
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["sourceInterruptClassColor"] = true

	-- Friendly NPC
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["health"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["health"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["format"] = '[name:abbrev]'
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["power"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["power"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["yOffset"] = 2
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["sourceInterrupt"] = true
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["sourceInterruptClassColor"] = true

	-- Enemy NPC
	E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["format"] = '[name:abbrev]'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["yOffset"] = 2
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["filters"]["priority"] = 'Blacklist,RaidBuffsElvUI,PlayerBuffs,TurtleBuffs,CastByUnit'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["yOffset"] = 24
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["level"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["level"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["sourceInterrupt"] = true
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["sourceInterruptClassColor"] = true

	--[[----------------------------------
	--	ProfileDB - Tooltip
	--]]----------------------------------
	E.db["tooltip"]["itemCount"] = "NONE"
	E.db["tooltip"]["healthBar"]["height"] = 5
	E.db["tooltip"]["healthBar"]["fontOutline"] = "OUTLINE"
	E.db["tooltip"]["visibility"]["combat"] = false
	E.db["tooltip"]["style"] = "inset"
	MER:SetMoverPosition("TooltipMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -10, 280)

	--[[----------------------------------
	--	Skins - Layout
	--]]----------------------------------
	if IsAddOnLoaded("ls_Toasts") then
		E.private["skins"]["blizzard"]["alertframes"] = false
	else
		E.private["skins"]["blizzard"]["alertframes"] = true
	end

	--[[----------------------------------
	--	ItemLevel - Layout
	--]]----------------------------------
	E.db["general"]["itemLevel"]["itemLevelFont"] = "Expressway"
	E.db["general"]["itemLevel"]["itemLevelFontSize"] = 12
	E.db["general"]["itemLevel"]["itemLevelFontOutline"] = "OUTLINE"

	--[[----------------------------------
	--	ProfileDB - mUI
	--]]----------------------------------
	E.db["mui"]["locPanel"]["enable"] = true
	E.db["mui"]["locPanel"]["combathide"] = true
	E.db["mui"]["locPanel"]["colorType"] = "CLASS"
	E.db["mui"]["locPanel"]["font"] = "Expressway"
	E.db["mui"]["locPanel"]["width"] = 330
	E.db["mui"]["locPanel"]["height"] = 20
	E.db["mui"]["locPanel"]["template"] = "NoBackdrop"
	E.db["mui"]["locPanel"]["colorType"] = "DEFAULT"
	E.db["mui"]["locPanel"]["colorType_Coords"] = "CLASS"
	E.db["mui"]["raidmarkers"]["enable"] = false
	E.db["mui"]["smb"]["enable"] = true
	E.db["mui"]["smb"]["backdrop"] = true
	E.db["mui"]["smb"]["iconSize"] = 22
	E.db["mui"]["smb"]["buttonsPerRow"] = 6
	E.db["mui"]["smb"]["buttonSpacing"] = 2
	E.db["mui"]["datatexts"]["middle"]["width"] = 330

	MER:SetMoverPosition("SpecializationBarMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -28, 17)
	MER:SetMoverPosition("MER_LocPanel_Mover", "TOP", E.UIParent, "TOP", 0, 0)
	MER:SetMoverPosition("MER_MicroBarMover", "TOP", E.UIParent, "TOP", 0, -19)
	MER:SetMoverPosition("MER_OrderhallMover", "TOPLEFT", E.UIParent, "TOPLEFT", 2 -2)
	MER:SetMoverPosition("MER_RaidBuffReminderMover", "TOPLEFT", E.UIParent, "TOPLEFT", 9, -18)
	MER:SetMoverPosition("MER_SquareMinimapButtonBarMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -28, 197)

	--[[----------------------------------
	--	Movers - Layout
	--]]----------------------------------
	MER:SetMoverPosition("AltPowerBarMover", "TOP", E.UIParent, "TOP" ,1, -272)
	MER:SetMoverPosition("GMMover", "TOPLEFT", E.UIParent, "TOPLEFT", 229, -20)
	MER:SetMoverPosition("BNETMover", "TOP", E.UIParent, "TOP", 0, -50)
	MER:SetMoverPosition("LootFrameMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -495, -457)
	MER:SetMoverPosition("AlertFrameMover", "TOP", E.UIParent, "TOP", 0, -140)
	MER:SetMoverPosition("LossControlMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 465)
	MER:SetMoverPosition("ObjectiveFrameMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -85, -300)
	MER:SetMoverPosition("VehicleSeatMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -474, 120)
	MER:SetMoverPosition("ProfessionsMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -3, -184)
	MER:SetMoverPosition("TalkingHeadFrameMover", "TOP", E.UIParent, "TOP", 0, -65)
	MER:SetMoverPosition("TopCenterContainerMover", "TOP", E.UIParent, "TOP", 0, -105)
	MER:SetMoverPosition("BelowMinimapContainerMover", "TOP", E.UIParent, "TOP", 0, -115)

	E.db["general"]["font"] = "Expressway"
	E.db["general"]["fontSize"] = 11
	E.private["general"]["chatBubbleFont"] = "Expressway"
	E.private["general"]["namefont"] = "Expressway"
	E.private["general"]["dmgfont"] = "Expressway"

	E.db["tooltip"]["healthBar"]["font"] = "Expressway"
	E.db["databars"]["experience"]["enable"] = true
	E.db["databars"]["experience"]["mouseover"] = false
	E.db["databars"]["experience"]["height"] = 146
	E.db["databars"]["experience"]["textSize"] = 10
	E.db["databars"]["experience"]["width"] = 8
	E.db["databars"]["experience"]["textFormat"] = "NONE"
	E.db["databars"]["experience"]["orientation"] = "VERTICAL"
	E.db["databars"]["experience"]["hideAtMaxLevel"] = true
	E.db["databars"]["experience"]["hideInVehicle"] = true
	E.db["databars"]["experience"]["hideInCombat"] = false
	E.db["databars"]["reputation"]["enable"] = true
	E.db["databars"]["reputation"]["mouseover"] = false
	E.db["databars"]["reputation"]["height"] = 146
	E.db["databars"]["reputation"]["textSize"] = 10
	E.db["databars"]["reputation"]["width"] = 8
	E.db["databars"]["reputation"]["textFormat"] = "NONE"
	E.db["databars"]["reputation"]["orientation"] = "VERTICAL"
	E.db["databars"]["reputation"]["hideInVehicle"] = true
	E.db["databars"]["reputation"]["hideInCombat"] = false
	E.db["databars"]["honor"]["enable"] = false
	E.db["databars"]["honor"]["height"] = 155
	E.db["databars"]["honor"]["textSize"] = 11
	E.db["databars"]["honor"]["hideOutsidePvP"] = true
	E.db["databars"]["honor"]["hideInCombat"] = false
	E.db["databars"]["azerite"]["enable"] = true
	E.db["databars"]["azerite"]["height"] = 146
	E.db["databars"]["azerite"]["textSize"] = 11
	E.db["databars"]["azerite"]["width"] = 8
	E.db["databars"]["azerite"]["hideInVehicle"] = true
	E.db["databars"]["azerite"]["hideInCombat"] = false
	E.db["databars"]["azerite"]["orientation"] = "VERTICAL"
	E.db["tooltip"]["font"] = "Expressway"
	E.db["tooltip"]["fontOutline"] = "NONE"
	E.db["tooltip"]["headerFontSize"] = 12
	E.db["tooltip"]["textFontSize"] = 11
	E.db["tooltip"]["smallTextFontSize"] = 11
	MER:SetMoverPosition("ArtifactBarMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -10, 50)
	MER:SetMoverPosition("AzeriteBarMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -10, 50)
	MER:SetMoverPosition("TotemBarMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 503, 12)
	MER:SetMoverPosition("HonorBarMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -531, 21)
	MER:SetMoverPosition("ExperienceBarMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 1, 50)
	MER:SetMoverPosition("ReputationBarMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -19, 50)
	MER:SetMoverPosition("MinimapMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -28, 51)
	MER:SetMoverPosition("mUI_RaidMarkerBarAnchor", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -277, 178)

	-- Masque
	if IsAddOnLoaded("Masque") then
		MER:LoadMasqueProfile()
	end

	E:UpdateAll(true)

	PluginInstallStepComplete.message = MER.Title..L["Layout Set"]
	PluginInstallStepComplete:Show()
end

function MER:SetupActionbars(layout)
	--[[----------------------------------
	--	ActionBars - General
	--]]----------------------------------
	E.db["actionbar"]["fontOutline"] = "OUTLINE"
	E.db["actionbar"]["fontSize"] = 10
	E.db["actionbar"]["macrotext"] = true
	E.db["actionbar"]["showGrid"] = false
	E.db["actionbar"]["lockActionBars"] = true

	-- Cooldown options
	E.db["actionbar"]["cooldown"]["fonts"]["enable"] = true
	E.db["actionbar"]["cooldown"]["fonts"]["font"] = "Expressway"
	E.db["actionbar"]["cooldown"]["fonts"]["fontOutline"] = "OUTLINE"
	E.db["actionbar"]["cooldown"]["fonts"]["fontSize"] = 18

	if IsAddOnLoaded("Masque") then
		E.private["actionbar"]["masque"]["stanceBar"] = true
		E.private["actionbar"]["masque"]["petBar"] = true
		E.private["actionbar"]["masque"]["actionbars"] = true
	end

	if IsAddOnLoaded("ElvUI_BenikUI") then
		E.db["benikui"]["actionbars"]["transparent"] = true
		E.db["benikui"]["actionbars"]["toggleButtons"]["enable"] = true
		E.db["benikui"]["actionbars"]["toggleButtons"]["chooseAb"] = "BAR1"
		E.db["benikui"]["actionbars"]["requestStop"] = true
	end

	E.db["actionbar"]["microbar"]["enabled"] = false
	E.db["actionbar"]["extraActionButton"]["scale"] = 0.75

	--[[----------------------------------
	--	ActionBars layout
	--]]----------------------------------
	E.db["actionbar"]["font"] = "Expressway"
	E.db["actionbar"]["desaturateOnCooldown"] = true

	E.db["actionbar"]["bar1"]["buttonspacing"] = 2
	E.db["actionbar"]["bar1"]["heightMult"] = 2
	E.db["actionbar"]["bar1"]["buttonsize"] = 32
	E.db["actionbar"]["bar1"]["buttons"] = 8
	E.db["actionbar"]["bar1"]["backdropSpacing"] = 3

	if layout == "dps" then
		E.db["actionbar"]["bar1"]["backdrop"] = false
		E.db["actionbar"]["bar1"]["buttonspacing"] = 3
	elseif layout == "healer" then
		E.db["actionbar"]["bar1"]["backdrop"] = true
		E.db["actionbar"]["bar1"]["buttonspacing"] = 2
	end

	E.db["actionbar"]["bar2"]["enabled"] = true
	E.db["actionbar"]["bar2"]["buttons"] = 8
	E.db["actionbar"]["bar2"]["buttonsize"] = 32
	E.db["actionbar"]["bar2"]["visibility"] = "[vehicleui][overridebar][petbattle][possessbar] hide; show"
	E.db["actionbar"]["bar2"]["mouseover"] = false
	E.db["actionbar"]["bar2"]["backdropSpacing"] = 3
	E.db["actionbar"]["bar2"]["showGrid"] = false
	E.db["actionbar"]["bar2"]["heightMult"] = 2
	E.db["actionbar"]["bar2"]["buttonsPerRow"] = 12

	if layout == "dps" then
		E.db["actionbar"]["bar2"]["backdrop"] = false
		E.db["actionbar"]["bar2"]["buttonspacing"] = 3
	elseif layout == "healer" then
		E.db["actionbar"]["bar2"]["backdrop"] = true
		E.db["actionbar"]["bar2"]["buttonspacing"] = 2
	end

	E.db["actionbar"]["bar3"]["enabled"] = true
	E.db["actionbar"]["bar3"]["backdrop"] = true
	E.db["actionbar"]["bar3"]["buttonsPerRow"] = 1
	E.db["actionbar"]["bar3"]["buttonsize"] = 26
	E.db["actionbar"]["bar3"]["buttonspacing"] = 3
	E.db["actionbar"]["bar3"]["buttons"] = 5
	E.db["actionbar"]["bar3"]["point"] = "TOPLEFT"
	E.db["actionbar"]["bar3"]["backdropSpacing"] = 1
	E.db["actionbar"]["bar3"]["mouseover"] = false

	E.db["actionbar"]["bar4"]["enabled"] = true
	E.db["actionbar"]["bar4"]["buttonspacing"] = 4
	E.db["actionbar"]["bar4"]["mouseover"] = true
	E.db["actionbar"]["bar4"]["buttonsize"] = 24
	E.db["actionbar"]["bar4"]["backdropSpacing"] = 2

	E.db["actionbar"]["bar5"]["enabled"] = true
	E.db["actionbar"]["bar5"]["backdrop"] = true
	E.db["actionbar"]["bar5"]["buttonsPerRow"] = 1
	E.db["actionbar"]["bar5"]["buttonsize"] = 26
	E.db["actionbar"]["bar5"]["buttonspacing"] = 3
	E.db["actionbar"]["bar5"]["buttons"] = 5
	E.db["actionbar"]["bar5"]["point"] = "BOTTOMLEFT"
	E.db["actionbar"]["bar5"]["backdropSpacing"] = 1
	E.db["actionbar"]["bar5"]["mouseover"] = false

	E.db["actionbar"]["bar6"]["enabled"] = true
	E.db["actionbar"]["bar6"]["backdropSpacing"] = 3
	E.db["actionbar"]["bar6"]["buttons"] = 8
	E.db["actionbar"]["bar6"]["visibility"] = "[vehicleui][overridebar][petbattle][possessbar] hide; show"
	E.db["actionbar"]["bar6"]["showGrid"] = false
	E.db["actionbar"]["bar6"]["mouseover"] = false
	E.db["actionbar"]["bar6"]["buttonsize"] = 32
	E.db["actionbar"]["bar6"]["buttonsPerRow"] = 8
	E.db["actionbar"]["bar6"]["heightMult"] = 1

	if layout == "dps" then
		E.db["actionbar"]["bar6"]["backdrop"] = false
		E.db["actionbar"]["bar6"]["buttonspacing"] = 3
	elseif layout == "healer" then
		E.db["actionbar"]["bar6"]["backdrop"] = true
		E.db["actionbar"]["bar6"]["buttonspacing"] = 2
	end

	E.db["actionbar"]["barPet"]["point"] = "BOTTOMLEFT"
	E.db["actionbar"]["barPet"]["buttons"] = 9
	E.db["actionbar"]["barPet"]["buttonspacing"] = 3
	E.db["actionbar"]["barPet"]["buttonsPerRow"] = 9
	E.db["actionbar"]["barPet"]["buttonsize"] = 24
	E.db["actionbar"]["barPet"]["mouseover"] = false

	E.db["actionbar"]["stanceBar"]["point"] = "BOTTOMLEFT"
	E.db["actionbar"]["stanceBar"]["backdrop"] = true
	E.db["actionbar"]["stanceBar"]["buttonspacing"] = 3
	E.db["actionbar"]["stanceBar"]["buttonsPerRow"] = 6
	E.db["actionbar"]["stanceBar"]["buttonsize"] = 24

	if layout == "dps" then
		MER:SetMoverPosition("ElvAB_1", "BOTTOM", E.UIParent, "BOTTOM", 0, 212)
		MER:SetMoverPosition("ElvAB_2", "BOTTOM", E.UIParent, "BOTTOM", 0, 247)
		MER:SetMoverPosition("ElvAB_3", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -439, 50)
		MER:SetMoverPosition("ElvAB_4", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", 0, 367)
		MER:SetMoverPosition("ElvAB_5", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 438, 50)
		MER:SetMoverPosition("ElvAB_6", "BOTTOM", E.UIParent, "BOTTOM", 0, 20)
		MER:SetMoverPosition("ShiftAB", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 10, 18)
		MER:SetMoverPosition("PetAB", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 193, 18)
		MER:SetMoverPosition("BossButton", "BOTTOM", E.UIParent, "BOTTOM", 305, 50)
		MER:SetMoverPosition("MicrobarMover", "TOPLEFT", E.UIParent, "TOPLEFT", 4, -4)
	elseif layout == "healer" then
		MER:SetMoverPosition("ElvAB_1", "BOTTOM", E.UIParent, "BOTTOM", 0, 123)
		MER:SetMoverPosition("ElvAB_2", "BOTTOM", E.UIParent, "BOTTOM", 0, 161)
		MER:SetMoverPosition("ElvAB_3", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -439, 50)
		MER:SetMoverPosition("ElvAB_4", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", 0, 367)
		MER:SetMoverPosition("ElvAB_5", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 438, 50)
		MER:SetMoverPosition("ElvAB_6", "BOTTOM", E.UIParent, "BOTTOM", 0, 20)
		MER:SetMoverPosition("ShiftAB", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 10, 18)
		MER:SetMoverPosition("PetAB", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 193, 18)
		MER:SetMoverPosition("BossButton", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -511, 50)
		MER:SetMoverPosition("MicrobarMover", "TOPLEFT", E.UIParent, "TOPLEFT", 4, -4)
	end

	E:UpdateAll(true)

	PluginInstallStepComplete.message = MER.Title..L["ActionBars Set"]
	PluginInstallStepComplete:Show()
end

function MER:SetupUnitframes(layout)
	--[[----------------------------------
	--	UnitFrames - General
	--]]----------------------------------
	E.db["unitframe"]["font"] = "Expressway"
	E.db["unitframe"]["fontSize"] = 10
	E.db["unitframe"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["smoothbars"] = true
	E.db["unitframe"]["statusbar"] = "Duffed"
	if IsAddOnLoaded("ElvUI_BenikUI") then
		E.db["benikui"]["unitframes"]["textures"]["power"] = E.db.unitframe.statusbar
		E.db["benikui"]["unitframes"]["textures"]["health"] = E.db.unitframe.statusbar
	end
	E.db["unitframe"]["colors"]["castColor"] = {
		["r"] = 0.1,
		["g"] = 0.1,
		["b"] = 0.1,
	}
	E.db["unitframe"]["colors"]["transparentAurabars"] = true
	E.db["unitframe"]["colors"]["transparentPower"] = false
	E.db["unitframe"]["colors"]["transparentCastbar"] = true
	E.db["unitframe"]["colors"]["castClassColor"] = false
	E.db["unitframe"]["colors"]["castReactionColor"] = false
	E.db["unitframe"]["colors"]["powerclass"] = false
	E.db["unitframe"]["colors"]["transparentHealth"] = false
	E.db["unitframe"]["colors"]["healthclass"] = true
	E.db["unitframe"]["colors"]["power"]["MANA"] = {r = 0.31, g = 0.45, b = 0.63}
	E.db["unitframe"]["colors"]["healthmultiplier"] = 0.4
	E.db["unitframe"]["colors"]["colorhealthbyvalue"] = false

	E.db["unitframe"]["smartRaidFilter"] = false

	-- Frame Glow
	E.db["unitframe"]["colors"]["frameGlow"]["targetGlow"]["enable"] = false
	E.db["unitframe"]["colors"]["frameGlow"]["mainGlow"]["enable"] = false
	E.db["unitframe"]["colors"]["frameGlow"]["mainGlow"]["class"] = true
	E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["color"]["a"] = 0.5
	E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["color"]["b"] = 0
	E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["color"]["g"] = 0
	E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["color"]["r"] = 0
	E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["class"] = true
	E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["texture"] = "MerathilisGradient"

	if layout == "dps" then
		-- Player
		E.db["unitframe"]["units"]["player"]["width"] = 200
		E.db["unitframe"]["units"]["player"]["height"] = 32
		E.db["unitframe"]["units"]["player"]["orientation"] = "RIGHT"
		E.db["unitframe"]["units"]["player"]["restIcon"] = false
		E.db["unitframe"]["units"]["player"]["threatStyle"] = "ICONTOPRIGHT"
		E.db["unitframe"]["units"]["player"]["debuffs"]["fontSize"] = 12
		E.db["unitframe"]["units"]["player"]["debuffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["player"]["debuffs"]["sizeOverride"] = 30
		E.db["unitframe"]["units"]["player"]["debuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["player"]["debuffs"]["yOffset"] = 15
		E.db["unitframe"]["units"]["player"]["debuffs"]["perrow"] = 3
		E.db["unitframe"]["units"]["player"]["debuffs"]["numrows"] = 1
		E.db["unitframe"]["units"]["player"]["debuffs"]["anchorPoint"] = "TOPLEFT"
		E.db["unitframe"]["units"]["player"]["smartAuraPosition"] = "DISABLED"
		E.db["unitframe"]["units"]["player"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["player"]["classbar"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["classbar"]["detachedWidth"] = 278
		E.db["unitframe"]["units"]["player"]["classbar"]["detachFromFrame"] = true
		E.db["unitframe"]["units"]["player"]["classbar"]["height"] = 15
		E.db["unitframe"]["units"]["player"]["classbar"]["autoHide"] = false
		E.db["unitframe"]["units"]["player"]["classbar"]["fill"] = "filled"
		E.db["unitframe"]["units"]["player"]["classbar"]["additionalPowerText"] = true
		E.db["unitframe"]["units"]["player"]["aurabar"]["enable"] = false
		E.db["unitframe"]["units"]["player"]["castbar"]["icon"] = true
		E.db["unitframe"]["units"]["player"]["castbar"]["latency"] = true
		E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 278
		E.db["unitframe"]["units"]["player"]["castbar"]["height"] = 22
		E.db["unitframe"]["units"]["player"]["castbar"]["insideInfoPanel"] = false
		if not E.db["unitframe"]["units"]["player"]["customTexts"] then E.db["unitframe"]["units"]["player"]["customTexts"] = {} end
		-- Delete old customTexts/ Create empty table
		E.db["unitframe"]["units"]["player"]["customTexts"] = {}

		-- Create own customText
		E.db["unitframe"]["units"]["player"]["customTexts"]["BigName"] = {
			["font"] = "Expressway",
			["fontOutline"] = "OUTLINE",
			["size"] = 12,
			["justifyH"] = "LEFT",
			["text_format"] = "[name:medium]",
			["attachTextTo"] = "Frame",
			["xOffset"] = -1,
			["yOffset"] = 22,
		}
		E.db["unitframe"]["units"]["player"]["customTexts"]["Percent"] = {
			["font"] = "Expressway",
			["fontOutline"] = "OUTLINE",
			["size"] = 14,
			["justifyH"] = "LEFT",
			["text_format"] = "[perhp<%]",
			["attachTextTo"] = "Frame",
			["xOffset"] = 0,
			["yOffset"] = 0,
		}
		E.db["unitframe"]["units"]["player"]["customTexts"]["Life"] = {
			["font"] = "Expressway",
			["fontOutline"] = "OUTLINE",
			["size"] = 14,
			["justifyH"] = "RIGHT",
			["text_format"] = "[health:current-mUI]",
			["attachTextTo"] = "Frame",
			["xOffset"] = 0,
			["yOffset"] = 0,
		}
		E.db["unitframe"]["units"]["player"]["customTexts"]["Resting"] = {
			["font"] = "Expressway",
			["fontOutline"] = "OUTLINE",
			["size"] = 12,
			["justifyH"] = "CENTER",
			["text_format"] = "[mUI-resting]",
			["attachTextTo"] = "Frame",
			["xOffset"] = 0,
			["yOffset"] = 0,
		}
		E.db["unitframe"]["units"]["player"]["customTexts"]["MERPower"] = {
			["font"] = "Expressway",
			["fontOutline"] = "OUTLINE",
			["size"] = 16,
			["justifyH"] = "CENTER",
			["text_format"] = "[power:current-mUI]",
			["attachTextTo"] = "Power",
			["xOffset"] = 0,
			["yOffset"] = 0,
		}
		E.db["unitframe"]["units"]["player"]["customTexts"]["Group"] = {
			["font"] = "Expressway",
			["fontOutline"] = "OUTLINE",
			["size"] = 12,
			["justifyH"] = "LEFT",
			["text_format"] = "[group]",
			["attachTextTo"] = "Frame",
			["xOffset"] = 0,
			["yOffset"] = -24,
		}
		E.db["unitframe"]["units"]["player"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["player"]["health"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["player"]["health"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["player"]["health"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["player"]["health"]["bgUseBarTexture"] = true
		E.db["unitframe"]["units"]["player"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["player"]["power"]["powerPrediction"] = true
		E.db["unitframe"]["units"]["player"]["power"]["height"] = 16
		E.db["unitframe"]["units"]["player"]["power"]["hideonnpc"] = true
		E.db["unitframe"]["units"]["player"]["power"]["detachFromFrame"] = true
		E.db["unitframe"]["units"]["player"]["power"]["detachedWidth"] = 278
		E.db["unitframe"]["units"]["player"]["power"]["text_format"] = ""
		E.db["unitframe"]["units"]["player"]["power"]["attachTextTo"] = "Power"
		E.db["unitframe"]["units"]["player"]["power"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["player"]["power"]["xOffset"] = 0
		E.db["unitframe"]["units"]["player"]["power"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["buffs"]["fontSize"] = 12
		E.db["unitframe"]["units"]["player"]["buffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["player"]["buffs"]["sizeOverride"] = 24
		E.db["unitframe"]["units"]["player"]["buffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["player"]["buffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["buffs"]["perrow"] = 4
		E.db["unitframe"]["units"]["player"]["buffs"]["numrows"] = 1
		E.db["unitframe"]["units"]["player"]["buffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["player"]["buffs"]["priority"] = "Blacklist,MER_RaidCDs"
		E.db["unitframe"]["units"]["player"]["raidicon"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["raidicon"]["position"] = "TOP"
		E.db["unitframe"]["units"]["player"]["raidicon"]["size"] = 18
		E.db["unitframe"]["units"]["player"]["raidicon"]["xOffset"] = 0
		E.db["unitframe"]["units"]["player"]["raidicon"]["yOffset"] = 15
		E.db["unitframe"]["units"]["player"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["player"]["infoPanel"]["height"] = 24
		E.db["unitframe"]["units"]["player"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["xOffset"] = 7
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["yOffset"] = 7
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["scale"] = 0.5
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["size"] = 12
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["texture"] = "COMBAT"
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["customTexture"] = ""
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["anchorPoint"] = "LEFT"
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["xOffset"] = 0
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["yOffset"] = 10
		E.db["unitframe"]["units"]["player"]["healPrediction"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["healPrediction"]["showOverAbsorbs"] = true
		E.db["unitframe"]["units"]["player"]["healPrediction"]["showAbsorbAmount"] = false

		-- Target
		E.db["unitframe"]["units"]["target"]["width"] = 200
		E.db["unitframe"]["units"]["target"]["height"] = 32
		E.db["unitframe"]["units"]["target"]["orientation"] = "LEFT"
		E.db["unitframe"]["units"]["target"]["threatStyle"] = "ICONTOPLEFT"
		E.db["unitframe"]["units"]["target"]["castbar"]["icon"] = true
		E.db["unitframe"]["units"]["target"]["castbar"]["latency"] = true
		E.db["unitframe"]["units"]["target"]["castbar"]["insideInfoPanel"] = false
		E.db["unitframe"]["units"]["target"]["castbar"]["width"] = 200
		E.db["unitframe"]["units"]["target"]["castbar"]["height"] = 18
		E.db["unitframe"]["units"]["target"]["debuffs"]["fontSize"] = 12
		E.db["unitframe"]["units"]["target"]["debuffs"]["sizeOverride"] = 28
		E.db["unitframe"]["units"]["target"]["debuffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["target"]["debuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["target"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["target"]["debuffs"]["perrow"] = 7
		E.db["unitframe"]["units"]["target"]["debuffs"]["attachTo"] = "BUFFS"
		E.db["unitframe"]["units"]["target"]["debuffs"]["priority"] = "Blacklist,Personal,RaidDebuffs,CCDebuffs,Friendly:Dispellable"
		E.db["unitframe"]["units"]["target"]["smartAuraPosition"] = "DISABLED"
		E.db["unitframe"]["units"]["target"]["aurabar"]["enable"] = false
		E.db["unitframe"]["units"]["target"]["aurabar"]["attachTo"] = "BUFFS"
		E.db["unitframe"]["units"]["target"]["name"]["xOffset"] = 8
		E.db["unitframe"]["units"]["target"]["name"]["yOffset"] = -32
		E.db["unitframe"]["units"]["target"]["name"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["target"]["power"]["powerPrediction"] = true
		E.db["unitframe"]["units"]["target"]["power"]["detachFromFrame"] = false
		E.db["unitframe"]["units"]["target"]["power"]["hideonnpc"] = false
		E.db["unitframe"]["units"]["target"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["target"]["power"]["text_format"] = ""
		if not E.db["unitframe"]["units"]["target"]["customTexts"] then E.db["unitframe"]["units"]["target"]["customTexts"] = {} end
		-- Delete old customTexts/ Create empty table
		E.db["unitframe"]["units"]["target"]["customTexts"] = {}
		if E.db["unitframe"]["units"]["target"]["customTexts"]["Class"] then E.db["unitframe"]["units"]["target"]["customTexts"]["Class"] = nil end
		if E.db["unitframe"]["units"]["target"]["customTexts"]["Faction"] then E.db["unitframe"]["units"]["target"]["customTexts"]["Faction"] = nil end

		-- Create own customText
		E.db["unitframe"]["units"]["target"]["customTexts"]["BigName"] = {
			["font"] = "Expressway",
			["justifyH"] = "RIGHT",
			["fontOutline"] = "OUTLINE",
			["xOffset"] = 3,
			["yOffset"] = 22,
			["size"] = 12,
			["text_format"] = "[name:abbrev]",
			["attachTextTo"] = "Frame",
		}
		E.db["unitframe"]["units"]["target"]["customTexts"]["Percent"] = {
			["font"] = "Expressway",
			["size"] = 14,
			["fontOutline"] = "OUTLINE",
			["justifyH"] = "RIGHT",
			["text_format"] = "[perhp<%]",
			["attachTextTo"] = "Health",
			["yOffset"] = 0,
			["xOffset"] = 0,
		}
		E.db["unitframe"]["units"]["target"]["customTexts"]["Life"] = {
			["font"] = "Expressway",
			["size"] = 14,
			["fontOutline"] = "OUTLINE",
			["justifyH"] = "LEFT",
			["text_format"] = "[health:current-mUI]",
			["attachTextTo"] = "Health",
			["yOffset"] = 0,
			["xOffset"] = 0,
		}
		E.db["unitframe"]["units"]["target"]["customTexts"]["MERPower"] = {
			["font"] = "Expressway",
			["size"] = 12,
			["fontOutline"] = "OUTLINE",
			["justifyH"] = "RIGHT",
			["text_format"] = "[power:current-mUI]",
			["attachTextTo"] = "Health",
			["yOffset"] = -24,
			["xOffset"] = 3,
		}
		E.db["unitframe"]["units"]["target"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["target"]["health"]["yOffset"] = 0
		E.db["unitframe"]["units"]["target"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["target"]["health"]["attachTextTo"] = "Frame"
		E.db["unitframe"]["units"]["target"]["health"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["health"]["bgUseBarTexture"] = true
		E.db["unitframe"]["units"]["target"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["target"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["buffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["target"]["buffs"]["yOffset"] = 15
		E.db["unitframe"]["units"]["target"]["buffs"]["attachTo"] = "Health"
		E.db["unitframe"]["units"]["target"]["buffs"]["sizeOverride"] = 22
		E.db["unitframe"]["units"]["target"]["buffs"]["perrow"] = 8
		E.db["unitframe"]["units"]["target"]["buffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["target"]["buffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["target"]["buffs"]["minDuration"] = 0
		E.db["unitframe"]["units"]["target"]["buffs"]["maxDuration"] = 0
		E.db["unitframe"]["units"]["target"]["buffs"]["priority"] = "Personal,Boss,Whitelist,Blacklist,PlayerBuffs,nonPersonal"
		E.db["unitframe"]["units"]["target"]["raidicon"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["raidicon"]["position"] = "TOP"
		E.db["unitframe"]["units"]["target"]["raidicon"]["size"] = 18
		E.db["unitframe"]["units"]["target"]["raidicon"]["xOffset"] = 0
		E.db["unitframe"]["units"]["target"]["raidicon"]["yOffset"] = 15
		E.db["unitframe"]["units"]["target"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["target"]["infoPanel"]["height"] = 24
		E.db["unitframe"]["units"]["target"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["anchorPoint"] = "TOPLEFT"
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["scale"] = 0.5
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["xOffset"] = -7
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["yOffset"] = 7
		E.db["unitframe"]["units"]["target"]["healPrediction"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["healPrediction"]["showOverAbsorbs"] = true
		E.db["unitframe"]["units"]["target"]["healPrediction"]["showAbsorbAmount"] = false

		-- TargetTarget
		E.db["unitframe"]["units"]["targettarget"]["debuffs"]["enable"] = true
		E.db["unitframe"]["units"]["targettarget"]["power"]["enable"] = true
		E.db["unitframe"]["units"]["targettarget"]["power"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["targettarget"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["targettarget"]["width"] = 75
		E.db["unitframe"]["units"]["targettarget"]["name"]["yOffset"] = 0
		E.db["unitframe"]["units"]["targettarget"]["name"]["text_format"] = "[name:short]"
		E.db["unitframe"]["units"]["targettarget"]["height"] = 32
		E.db["unitframe"]["units"]["targettarget"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["targettarget"]["health"]["bgUseBarTexture"] = true
		E.db["unitframe"]["units"]["targettarget"]["raidicon"]["enable"] = true
		E.db["unitframe"]["units"]["targettarget"]["raidicon"]["position"] = "TOP"
		E.db["unitframe"]["units"]["targettarget"]["raidicon"]["size"] = 18
		E.db["unitframe"]["units"]["targettarget"]["raidicon"]["xOffset"] = 0
		E.db["unitframe"]["units"]["targettarget"]["raidicon"]["yOffset"] = 15
		E.db["unitframe"]["units"]["targettarget"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["targettarget"]["infoPanel"]["enable"] = false
		if not E.db["unitframe"]["units"]["targettarget"]["customTexts"] then E.db["unitframe"]["units"]["targettarget"]["customTexts"] = {} end
		-- Delete old customTexts/ Create empty table
		E.db["unitframe"]["units"]["targettarget"]["customTexts"] = {}

		-- Focus
		E.db["unitframe"]["units"]["focus"]["width"] = 100
		E.db["unitframe"]["units"]["focus"]["height"] = 32
		E.db["unitframe"]["units"]["focus"]["name"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["focus"]["name"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["focus"]["name"]["text_format"] = "[name:medium]"
		E.db["unitframe"]["units"]["focus"]["health"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["focus"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["focus"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["focus"]["health"]["yOffset"] = 0
		E.db["unitframe"]["units"]["focus"]["health"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["focus"]["health"]["bgUseBarTexture"] = true
		E.db["unitframe"]["units"]["focus"]["power"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["focus"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["focus"]["power"]["text_format"] = ""
		E.db["unitframe"]["units"]["focus"]["power"]["xOffset"] = 0
		E.db["unitframe"]["units"]["focus"]["power"]["yOffset"] = 0
		E.db["unitframe"]["units"]["focus"]["power"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["focus"]["castbar"]["enable"] = true
		E.db["unitframe"]["units"]["focus"]["castbar"]["latency"] = true
		E.db["unitframe"]["units"]["focus"]["castbar"]["insideInfoPanel"] = false
		E.db["unitframe"]["units"]["focus"]["castbar"]["iconSize"] = 20
		E.db["unitframe"]["units"]["focus"]["castbar"]["height"] = 18
		E.db["unitframe"]["units"]["focus"]["castbar"]["width"] = 100
		E.db["unitframe"]["units"]["focus"]["debuffs"]["anchorPoint"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["focus"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["focus"]["infoPanel"]["enable"] = false

		-- FocusTarget
		E.db["unitframe"]["units"]["focustarget"]["enable"] = false

		-- Raid
		E.db["unitframe"]["units"]["raid"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["height"] = 35
		E.db["unitframe"]["units"]["raid"]["width"] = 83
		E.db["unitframe"]["units"]["raid"]["threatStyle"] = "GLOW"
		E.db["unitframe"]["units"]["raid"]["orientation"] = "MIDDLE"
		E.db["unitframe"]["units"]["raid"]["horizontalSpacing"] = 3
		E.db["unitframe"]["units"]["raid"]["verticalSpacing"] = 2
		E.db["unitframe"]["units"]["raid"]["visibility"] = "[@raid6,noexists][@raid21,exists] hide;show"
		E.db["unitframe"]["units"]["raid"]["debuffs"]["countFontSize"] = 12
		E.db["unitframe"]["units"]["raid"]["debuffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["debuffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["raid"]["debuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["debuffs"]["yOffset"] = -8
		E.db["unitframe"]["units"]["raid"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["raid"]["debuffs"]["sizeOverride"] = 15
		E.db["unitframe"]["units"]["raid"]["debuffs"]["maxDuration"] = 0
		E.db["unitframe"]["units"]["raid"]["debuffs"]["priority"] = "Blacklist,Boss,RaidDebuffs,nonPersonal,CastByUnit,CCDebuffs,CastByNPC,Dispellable"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["enable"] = false
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["font"] = "Expressway"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["size"] = 20
		E.db["unitframe"]["units"]["raid"]["numGroups"] = 4
		E.db["unitframe"]["units"]["raid"]["growthDirection"] = "RIGHT_UP"
		E.db["unitframe"]["units"]["raid"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["raid"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["raid"]["buffIndicator"]["fontSize"] = 11
		E.db["unitframe"]["units"]["raid"]["buffIndicator"]["size"] = 10
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["size"] = 10
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["xOffset"] = 1
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["yOffset"] = -1
		E.db["unitframe"]["units"]["raid"]["power"]["enable"] = false
		E.db["unitframe"]["units"]["raid"]["power"]["height"] = 4
		E.db["unitframe"]["units"]["raid"]["groupBy"] = "ROLE"
		E.db["unitframe"]["units"]["raid"]["health"]["frequentUpdates"] = true
		E.db["unitframe"]["units"]["raid"]["health"]["position"] = "BOTTOM"
		E.db["unitframe"]["units"]["raid"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["raid"]["health"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["raid"]["health"]["bgUseBarTexture"] = true
		E.db["unitframe"]["units"]["raid"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["buffs"]["yOffset"] = 5
		E.db["unitframe"]["units"]["raid"]["buffs"]["anchorPoint"] = "CENTER"
		E.db["unitframe"]["units"]["raid"]["buffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["raid"]["buffs"]["useBlacklist"] = false
		E.db["unitframe"]["units"]["raid"]["buffs"]["useWhitelist"] = true
		E.db["unitframe"]["units"]["raid"]["buffs"]["noDuration"] = false
		E.db["unitframe"]["units"]["raid"]["buffs"]["playerOnly"] = false
		E.db["unitframe"]["units"]["raid"]["buffs"]["perrow"] = 1
		E.db["unitframe"]["units"]["raid"]["buffs"]["useFilter"] = "MER_RaidCDs"
		E.db["unitframe"]["units"]["raid"]["buffs"]["noConsolidated"] = false
		E.db["unitframe"]["units"]["raid"]["buffs"]["sizeOverride"] = 20
		E.db["unitframe"]["units"]["raid"]["buffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["buffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["buffs"]["countFontSize"] = 12
		E.db["unitframe"]["units"]["raid"]["buffs"]["useFilter"] = "MER_RaidCDs"
		E.db["unitframe"]["units"]["raid"]["buffs"]["priority"] = "MER_RaidCDs"
		E.db["unitframe"]["units"]["raid"]["raidicon"]["attachTo"] = "CENTER"
		E.db["unitframe"]["units"]["raid"]["raidicon"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["raidicon"]["yOffset"] = 5
		E.db["unitframe"]["units"]["raid"]["raidicon"]["size"] = 15
		E.db["unitframe"]["units"]["raid"]["raidicon"]["yOffset"] = 0
		if not E.db["unitframe"]["units"]["raid"]["customTexts"] then E.db["unitframe"]["units"]["raid"]["customTexts"] = {} end
		-- Delete old customTexts/ Create empty table
		E.db["unitframe"]["units"]["raid"]["customTexts"] = {}
		-- Create own customTexts
		E.db["unitframe"]["units"]["raid"]["customTexts"]["Status"] = {
			["font"] = "Expressway",
			["justifyH"] = "CENTER",
			["fontOutline"] = "OUTLINE",
			["xOffset"] = 0,
			["yOffset"] = -12,
			["size"] = 9,
			["attachTextTo"] = "Health",
			["text_format"] = "[statustimer]",
		}
		E.db["unitframe"]["units"]["raid"]["customTexts"]["name1"] = {
			["font"] = "Expressway",
			["size"] = 10,
			["fontOutline"] = "OUTLINE",
			["justifyH"] = "CENTER",
			["yOffset"] = 0,
			["xOffset"] = 0,
			["attachTextTo"] = "Health",
			["text_format"] = "[name:medium]",
		}
		if MER:IsDeveloper() and MER:IsDeveloperRealm() then
			E.db["unitframe"]["units"]["raid"]["customTexts"]["Elv"] = {
				["font"] = "Expressway",
				["justifyH"] = "RIGHT",
				["fontOutline"] = "OUTLINE",
				["xOffset"] = 0,
				["yOffset"] = 0,
				["size"] = 9,
				["attachTextTo"] = "Frame",
				["text_format"] = "[users:elvui]",
			}
		end
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["height"] = 13
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["damager"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["tank"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["heal"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["attachTo"] = "Health"
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["yOffset"] = -1
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["xOffset"] = 1
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["size"] = 10
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["raid"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["raid"]["readycheckIcon"]["size"] = 20
		E.db["unitframe"]["units"]["raid"]["healPrediction"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["healPrediction"]["showOverAbsorbs"] = true
		E.db["unitframe"]["units"]["raid"]["healPrediction"]["showAbsorbAmount"] = false

		if IsAddOnLoaded("ElvUI_BenikUI") then
			E.db["unitframe"]["units"]["raid"]["classHover"] = true
		end

		-- Raid40
		E.db["unitframe"]["units"]["raid40"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["countFontSize"] = 12
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["sizeOverride"] = 15
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["useBlacklist"] = false
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["yOffset"] = -8
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["useFilter"] = "Whitlist (Strict)"
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["priority"] = "Blacklist,Boss,RaidDebuffs,nonPersonal,CastByUnit,CCDebuffs,CastByNPC,Dispellable"
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["maxDuration"] = 0
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["perrow"] = 5
		E.db["unitframe"]["units"]["raid40"]["portrait"]["camDistanceScale"] = 2
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["font"] = "Expressway"
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["size"] = 20
		E.db["unitframe"]["units"]["raid40"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["raid40"]["growthDirection"] = "RIGHT_UP"
		E.db["unitframe"]["units"]["raid40"]["groupBy"] = "ROLE"
		E.db["unitframe"]["units"]["raid40"]["classHover"] = true
		E.db["unitframe"]["units"]["raid40"]["health"]["frequentUpdates"] = true
		E.db["unitframe"]["units"]["raid40"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["raid40"]["health"]["bgUseBarTexture"] = true
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["heal"] = true
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["xOffset"] = 1
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["size"] = 10
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["yOffset"] = -1
		E.db["unitframe"]["units"]["raid40"]["raidWideSorting"] = false
		E.db["unitframe"]["units"]["raid40"]["readycheckIcon"]["size"] = 20
		E.db["unitframe"]["units"]["raid40"]["power"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["raid40"]["power"]["height"] = 4
		if not E.db["unitframe"]["units"]["raid40"]["customTexts"] then E.db["unitframe"]["units"]["raid40"]["customTexts"] = {} end
		-- Delete old customTexts/ Create empty table
		E.db["unitframe"]["units"]["raid40"]["customTexts"] = {}
		-- Create own customTexts
		E.db["unitframe"]["units"]["raid40"]["customTexts"]["Status"] = {
			["enable"] = true,
			["attachTextTo"] = "Health",
			["text_format"] = "[statustimer]",
			["yOffset"] = -12,
			["font"] = "Expressway",
			["justifyH"] = "CENTER",
			["fontOutline"] = "OUTLINE",
			["xOffset"] = 0,
			["size"] = 9,
		}
		E.db["unitframe"]["units"]["raid40"]["customTexts"]["name1"] = {
			["enable"] = true,
			["attachTextTo"] = "Health",
			["text_format"] = "[name:medium]",
			["yOffset"] = 0,
			["font"] = "Expressway",
			["justifyH"] = "CENTER",
			["fontOutline"] = "OUTLINE",
			["xOffset"] = 0,
			["size"] = 10,
		}
		if MER:IsDeveloper() and MER:IsDeveloperRealm() then
			E.db["unitframe"]["units"]["raid40"]["customTexts"]["Elv"] = {
				["font"] = "Expressway",
				["justifyH"] = "RIGHT",
				["fontOutline"] = "OUTLINE",
				["xOffset"] = 0,
				["yOffset"] = 0,
				["size"] = 9,
				["attachTextTo"] = "Frame",
				["text_format"] = "[users:elvui]",
			}
		end
		E.db["unitframe"]["units"]["raid40"]["buffIndicator"]["size"] = 10
		E.db["unitframe"]["units"]["raid40"]["buffIndicator"]["fontSize"] = 11
		E.db["unitframe"]["units"]["raid40"]["width"] = 83
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["height"] = 13
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["raid40"]["buffs"]["countFontSize"] = 12
		E.db["unitframe"]["units"]["raid40"]["buffs"]["sizeOverride"] = 20
		E.db["unitframe"]["units"]["raid40"]["buffs"]["useBlacklist"] = false
		E.db["unitframe"]["units"]["raid40"]["buffs"]["noDuration"] = false
		E.db["unitframe"]["units"]["raid40"]["buffs"]["playerOnly"] = false
		E.db["unitframe"]["units"]["raid40"]["buffs"]["perrow"] = 1
		E.db["unitframe"]["units"]["raid40"]["buffs"]["anchorPoint"] = "CENTER"
		E.db["unitframe"]["units"]["raid40"]["buffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["raid40"]["buffs"]["noConsolidated"] = false
		E.db["unitframe"]["units"]["raid40"]["buffs"]["priority"] = "MER_RaidCDs"
		E.db["unitframe"]["units"]["raid40"]["buffs"]["useFilter"] = "MER_RaidCDs"
		E.db["unitframe"]["units"]["raid40"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["raid40"]["positionOverride"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["raid40"]["height"] = 35
		E.db["unitframe"]["units"]["raid40"]["verticalSpacing"] = 2
		E.db["unitframe"]["units"]["raid40"]["visibility"] = "[@raid21,noexists] hide;show"
		E.db["unitframe"]["units"]["raid40"]["raidicon"]["attachTo"] = "CENTER"
		E.db["unitframe"]["units"]["raid40"]["raidicon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["raidicon"]["size"] = 15
		E.db["unitframe"]["units"]["raid40"]["healPrediction"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["healPrediction"]["showOverAbsorbs"] = true
		E.db["unitframe"]["units"]["raid40"]["healPrediction"]["showAbsorbAmount"] = false

		-- Party
		E.db["unitframe"]["units"]["party"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["growthDirection"] = "UP_RIGHT"
		E.db["unitframe"]["units"]["party"]["horizontalSpacing"] = 1
		E.db["unitframe"]["units"]["party"]["debuffs"]["countFontSize"] = 12
		E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] = 34
		E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["party"]["debuffs"]["xOffset"] = -2
		E.db["unitframe"]["units"]["party"]["debuffs"]["maxDuration"] = 0
		E.db["unitframe"]["units"]["party"]["debuffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["party"]["debuffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["party"]["debuffs"]["priority"] = "Blacklist,Boss,RaidDebuffs,nonPersonal,CastByUnit,CCDebuffs,CastByNPC,Dispellable"
		E.db["unitframe"]["units"]["party"]["debuffs"]["anchorPoint"] = "LEFT"
		E.db["unitframe"]["units"]["party"]["debuffs"]["perrow"] = 2
		E.db["unitframe"]["units"]["party"]["rdebuffs"]["font"] = "Expressway"
		E.db["unitframe"]["units"]["party"]["rdebuffs"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["party"]["rdebuffs"]["size"] = 20
		E.db["unitframe"]["units"]["party"]["rdebuffs"]["yOffset"] = 12
		E.db["unitframe"]["units"]["party"]["buffIndicator"]["size"] = 10
		E.db["unitframe"]["units"]["party"]["buffIndicator"]["fontSize"] = 11
		E.db["unitframe"]["units"]["party"]["orientation"] = "MIDDLE"
		E.db["unitframe"]["units"]["party"]["verticalSpacing"] = 1
		E.db["unitframe"]["units"]["party"]["roleIcon"]["xOffset"] = 1
		E.db["unitframe"]["units"]["party"]["roleIcon"]["size"] = 11
		E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["enable"] = false
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["anchorPoint"] = "BOTTOM"
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["name"]["text_format"] = "[name:short]"
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["height"] = 16
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["width"] = 79
		E.db["unitframe"]["units"]["party"]["readycheckIcon"]["size"] = 20
		E.db["unitframe"]["units"]["party"]["power"]["enable"] = false
		E.db["unitframe"]["units"]["party"]["power"]["height"] = 4
		E.db["unitframe"]["units"]["party"]["power"]["position"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["party"]["power"]["text_format"] = ""
		E.db["unitframe"]["units"]["party"]["power"]["yOffset"] = 2
		E.db["unitframe"]["units"]["party"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["party"]["width"] = 160
		E.db["unitframe"]["units"]["party"]["health"]["frequentUpdates"] = true
		E.db["unitframe"]["units"]["party"]["health"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["party"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["party"]["health"]["yOffset"] = 2
		E.db["unitframe"]["units"]["party"]["health"]["bgUseBarTexture"] = true
		E.db["unitframe"]["units"]["party"]["name"]["attachTextTo"] = "Frame"
		E.db["unitframe"]["units"]["party"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["party"]["name"]["position"] = "BOTTOMLEFT"
		E.db["unitframe"]["units"]["party"]["groupBy"] = "ROLE"
		E.db["unitframe"]["units"]["party"]["height"] = 36
		E.db["unitframe"]["units"]["party"]["buffs"]["countFontSize"] = 12
		E.db["unitframe"]["units"]["party"]["buffs"]["sizeOverride"] = 20
		E.db["unitframe"]["units"]["party"]["buffs"]["useBlacklist"] = false
		E.db["unitframe"]["units"]["party"]["buffs"]["useWhitelist"] = true
		E.db["unitframe"]["units"]["party"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["buffs"]["playerOnly"] = false
		E.db["unitframe"]["units"]["party"]["buffs"]["perrow"] = 2
		E.db["unitframe"]["units"]["party"]["buffs"]["anchorPoint"] = "TOPLEFT"
		E.db["unitframe"]["units"]["party"]["buffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["party"]["buffs"]["useFilter"] = "MER_RaidCDs"
		E.db["unitframe"]["units"]["party"]["buffs"]["priority"] = "MER_RaidCDs"
		E.db["unitframe"]["units"]["party"]["buffs"]["noConsolidated"] = false
		E.db["unitframe"]["units"]["party"]["buffs"]["noDuration"] = false
		E.db["unitframe"]["units"]["party"]["buffs"]["yOffset"] = -15
		E.db["unitframe"]["units"]["party"]["buffs"]["xOffset"] = 2
		E.db["unitframe"]["units"]["party"]["petsGroup"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["party"]["petsGroup"]["height"] = 16
		E.db["unitframe"]["units"]["party"]["petsGroup"]["yOffset"] = -1
		E.db["unitframe"]["units"]["party"]["petsGroup"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["petsGroup"]["width"] = 60
		E.db["unitframe"]["units"]["party"]["raidicon"]["attachToObject"] = "Frame"
		E.db["unitframe"]["units"]["party"]["raidicon"]["attachTo"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["raidicon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["party"]["raidicon"]["xOffset"] = -2
		E.db["unitframe"]["units"]["party"]["raidicon"]["size"] = 16
		E.db["unitframe"]["units"]["party"]["healPrediction"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["healPrediction"]["showOverAbsorbs"] = true
		E.db["unitframe"]["units"]["party"]["healPrediction"]["showAbsorbAmount"] = false
		if E.db["unitframe"]["units"]["party"]["customTexts"] then E.db["unitframe"]["units"]["party"]["customTexts"] = nil end
		-- Delete old customTexts/ Create empty table
		E.db["unitframe"]["units"]["party"]["customTexts"] = {}
		-- Create own customTexts
		E.db["unitframe"]["units"]["party"]["customTexts"]["name1"] = {
			["font"] = "Expressway",
			["size"] = 12,
			["fontOutline"] = "OUTLINE",
			["justifyH"] = "CENTER",
			["yOffset"] = 0,
			["xOffset"] = 0,
			["attachTextTo"] = "Frame",
			["text_format"] = "[name:medium]",
		}
		E.db["unitframe"]["units"]["party"]["customTexts"]["Status"] = {
			["font"] = "Expressway",
			["justifyH"] = "CENTER",
			["fontOutline"] = "OUTLINE",
			["xOffset"] = 0,
			["yOffset"] = -12,
			["size"] = 9,
			["attachTextTo"] = "Frame",
			["text_format"] = "[statustimer]",
		}
		if MER:IsDeveloper() and MER:IsDeveloperRealm() then
			E.db["unitframe"]["units"]["party"]["customTexts"]["Elv"] = {
				["font"] = "Expressway",
				["justifyH"] = "RIGHT",
				["fontOutline"] = "OUTLINE",
				["xOffset"] = 0,
				["yOffset"] = 0,
				["size"] = 9,
				["attachTextTo"] = "Frame",
				["text_format"] = "[users:elvui]",
			}
		end

		-- Assist
		E.db["unitframe"]["units"]["assist"]["enable"] = false

		-- Tank
		E.db["unitframe"]["units"]["tank"]["enable"] = false

		-- Pet
		E.db["unitframe"]["units"]["pet"]["castbar"]["enable"] = true
		E.db["unitframe"]["units"]["pet"]["castbar"]["latency"] = true
		E.db["unitframe"]["units"]["pet"]["castbar"]["width"] = 75
		E.db["unitframe"]["units"]["pet"]["castbar"]["height"] = 10
		E.db["unitframe"]["units"]["pet"]["castbar"]["insideInfoPanel"] = true
		E.db["unitframe"]["units"]["pet"]["debuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["pet"]["debuffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["pet"]["debuffs"]["sizeOverride"] = 0
		E.db["unitframe"]["units"]["pet"]["debuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["pet"]["debuffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["pet"]["debuffs"]["perrow"] = 5
		E.db["unitframe"]["units"]["pet"]["debuffs"]["anchorPoint"] = "TOPLEFT"
		E.db["unitframe"]["units"]["pet"]["health"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["pet"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["pet"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["pet"]["health"]["yOffset"] = 0
		E.db["unitframe"]["units"]["pet"]["health"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["pet"]["health"]["bgUseBarTexture"] = true
		E.db["unitframe"]["units"]["pet"]["power"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["pet"]["power"]["height"] = 4
		E.db["unitframe"]["units"]["pet"]["power"]["text_format"] = ""
		E.db["unitframe"]["units"]["pet"]["power"]["xOffset"] = 0
		E.db["unitframe"]["units"]["pet"]["power"]["yOffset"] = 0
		E.db["unitframe"]["units"]["pet"]["power"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["pet"]["name"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["pet"]["name"]["text_format"] = "[name:short]"
		E.db["unitframe"]["units"]["pet"]["name"]["xOffset"] = 0
		E.db["unitframe"]["units"]["pet"]["name"]["yOffset"] = 0
		E.db["unitframe"]["units"]["pet"]["width"] = 75
		E.db["unitframe"]["units"]["pet"]["height"] = 32
		E.db["unitframe"]["units"]["pet"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["pet"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["pet"]["orientation"] = "MIDDLE"
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["height"] = 14
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["transparent"] = true

		-- Arena
		E.db["unitframe"]["units"]["arena"]["power"]["width"] = "inset"

		-- Boss
		E.db["unitframe"]["units"]["boss"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["boss"]["debuffs"]["sizeOverride"] = 22
		E.db["unitframe"]["units"]["boss"]["debuffs"]["yOffset"] = 5
		E.db["unitframe"]["units"]["boss"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["boss"]["debuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["boss"]["debuffs"]["perrow"] = 6
		E.db["unitframe"]["units"]["boss"]["debuffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["boss"]["debuffs"]["countFontSize"] = 12
		E.db["unitframe"]["units"]["boss"]["threatStyle"] = "HEALTHBORDER"
		E.db["unitframe"]["units"]["boss"]["castbar"]["enable"] = true
		E.db["unitframe"]["units"]["boss"]["castbar"]["insideInfoPanel"] = false
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["height"] = 15
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["transparent"] = true
		if not E.db["unitframe"]["units"]["boss"]["customTexts"] then E.db["unitframe"]["units"]["boss"]["customTexts"] = {} end
		-- Delete old customTexts/ Create empty table
		E.db["unitframe"]["units"]["boss"]["customTexts"] = {}
		if E.db["unitframe"]["units"]["boss"]["customTexts"]["Class"] then E.db["unitframe"]["units"]["boss"]["customTexts"]["Class"] = nil end

		-- Create own customTexts
		E.db["unitframe"]["units"]["boss"]["customTexts"]["BigName"] = {
			["attachTextTo"] = "Frame",
			["font"] = "Expressway",
			["justifyH"] = "LEFT",
			["fontOutline"] = "OUTLINE",
			["xOffset"] = 0,
			["size"] = 11,
			["text_format"] = "[name:medium]",
			["yOffset"] = 18,
		}
		E.db["unitframe"]["units"]["boss"]["customTexts"]["Life"] = {
			["attachTextTo"] = "Health",
			["font"] = "Expressway",
			["justifyH"] = "LEFT",
			["fontOutline"] = "OUTLINE",
			["xOffset"] = 0,
			["size"] = 14,
			["text_format"] = "[health:current-mUI]",
			["yOffset"] = 0,
		}
		E.db["unitframe"]["units"]["boss"]["customTexts"]["Percent"] = {
			["attachTextTo"] = "Health",
			["font"] = "Expressway",
			["justifyH"] = "RIGHT",
			["fontOutline"] = "OUTLINE",
			["xOffset"] = 0,
			["size"] = 14,
			["text_format"] = "[perhp<%]",
			["yOffset"] = 0,
		}
		E.db["unitframe"]["units"]["boss"]["power"]["xOffset"] = 0
		E.db["unitframe"]["units"]["boss"]["power"]["attachTextTo"] = "Power"
		E.db["unitframe"]["units"]["boss"]["power"]["height"] = 9
		E.db["unitframe"]["units"]["boss"]["power"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["boss"]["power"]["text_format"] = "[power:current-mUI]"
		E.db["unitframe"]["units"]["boss"]["growthDirection"] = "UP"
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["height"] = 15
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["boss"]["width"] = 156
		E.db["unitframe"]["units"]["boss"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["boss"]["health"]["yOffset"] = 13
		E.db["unitframe"]["units"]["boss"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["boss"]["health"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["boss"]["health"]["bgUseBarTexture"] = true
		E.db["unitframe"]["units"]["boss"]["spacing"] = 45
		E.db["unitframe"]["units"]["boss"]["height"] = 35
		E.db["unitframe"]["units"]["boss"]["buffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["boss"]["buffs"]["xOffset"] = -2
		E.db["unitframe"]["units"]["boss"]["buffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["boss"]["buffs"]["sizeOverride"] = 32
		E.db["unitframe"]["units"]["boss"]["buffs"]["anchorPoint"] = "LEFT"
		E.db["unitframe"]["units"]["boss"]["buffs"]["countFontSize"] = 12
		E.db["unitframe"]["units"]["boss"]["name"]["attachTextTo"] = "Frame"
		E.db["unitframe"]["units"]["boss"]["name"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["boss"]["name"]["xOffset"] = 6
		E.db["unitframe"]["units"]["boss"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["boss"]["name"]["yOffset"] = 16

		-- PetTarget
		E.db["unitframe"]["units"]["pettarget"]["enable"] = false

		-- RaidPet
		E.db["unitframe"]["units"]["raidpet"]["enable"] = false

		-- Movers
		MER:SetMoverPosition("ElvUF_PlayerMover", "BOTTOM", E.UIParent, "BOTTOM", -241, 281)
		MER:SetMoverPosition("ElvUF_PlayerCastbarMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 183)
		MER:SetMoverPosition("PlayerPowerBarMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 281)
		MER:SetMoverPosition("ClassBarMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 298)
		MER:SetMoverPosition("ElvUF_TargetMover", "BOTTOM", E.UIParent, "BOTTOM", 241, 281)
		MER:SetMoverPosition("ElvUF_TargetCastbarMover", "BOTTOM", E.UIParent, "BOTTOM", 241, 261)
		MER:SetMoverPosition("ElvUF_TargetTargetMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -542, 281)
		MER:SetMoverPosition("ElvUF_FocusMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -518, 365)
		MER:SetMoverPosition("ElvUF_FocusCastbarMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -518, 346)
		MER:SetMoverPosition("ElvUF_FocusTargetMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -513, 277)
		MER:SetMoverPosition("ElvUF_RaidMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 10, 198)
		MER:SetMoverPosition("ElvUF_Raid40Mover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 10, 198)
		MER:SetMoverPosition("ElvUF_PartyMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 454, 359)
		MER:SetMoverPosition("ElvUF_AssistMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 2, 571)
		MER:SetMoverPosition("ElvUF_TankMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 2, 626)
		MER:SetMoverPosition("ElvUF_PetMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 542, 281)
		MER:SetMoverPosition("ElvUF_PetCastbarMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 542, 269)
		MER:SetMoverPosition("ArenaHeaderMover", "TOPRIGHT" , E.UIParent, "TOPRIGHT", -305, -305)
		MER:SetMoverPosition("BossHeaderMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -305, -305)
		MER:SetMoverPosition("ElvUF_RaidpetMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 0, 808)
	elseif layout == "healer" then
		-- Player
		E.db["unitframe"]["units"]["player"]["width"] = 200
		E.db["unitframe"]["units"]["player"]["height"] = 50
		E.db["unitframe"]["units"]["player"]["orientation"] = "RIGHT"
		E.db["unitframe"]["units"]["player"]["restIcon"] = false
		E.db["unitframe"]["units"]["player"]["debuffs"]["fontSize"] = 12
		E.db["unitframe"]["units"]["player"]["debuffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["player"]["debuffs"]["sizeOverride"] = 30
		E.db["unitframe"]["units"]["player"]["debuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["player"]["debuffs"]["yOffset"] = 1
		E.db["unitframe"]["units"]["player"]["debuffs"]["perrow"] = 3
		E.db["unitframe"]["units"]["player"]["debuffs"]["numrows"] = 1
		E.db["unitframe"]["units"]["player"]["debuffs"]["anchorPoint"] = "TOPLEFT"
		E.db["unitframe"]["units"]["player"]["smartAuraPosition"] = "DISABLED"
		E.db["unitframe"]["units"]["player"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["player"]["classbar"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["classbar"]["detachFromFrame"] = false
		E.db["unitframe"]["units"]["player"]["classbar"]["height"] = 5
		E.db["unitframe"]["units"]["player"]["classbar"]["autoHide"] = true
		E.db["unitframe"]["units"]["player"]["classbar"]["fill"] = "filled"
		E.db["unitframe"]["units"]["player"]["classbar"]["additionalPowerText"] = false
		E.db["unitframe"]["units"]["player"]["aurabar"]["enable"] = false
		E.db["unitframe"]["units"]["player"]["threatStyle"] = "INFOPANELBORDER"
		E.db["unitframe"]["units"]["player"]["castbar"]["icon"] = true
		E.db["unitframe"]["units"]["player"]["castbar"]["latency"] = true
		E.db["unitframe"]["units"]["player"]["castbar"]["insideInfoPanel"] = true
		if not E.db["unitframe"]["units"]["player"]["customTexts"] then E.db["unitframe"]["units"]["player"]["customTexts"] = {} end
		-- Delete old customTexts/ Create empty table
		E.db["unitframe"]["units"]["player"]["customTexts"] = {}
		-- Create own customText
		E.db["unitframe"]["units"]["player"]["customTexts"]["BigName"] = {
			["font"] = "Expressway",
			["justifyH"] = "RIGHT",
			["fontOutline"] = "OUTLINE",
			["text_format"] = "[name:medium]",
			["size"] = 12,
			["attachTextTo"] = "InfoPanel",
			["xOffset"] = 0,
			["yOffset"] = 0,
		}
		E.db["unitframe"]["units"]["player"]["customTexts"]["Percent"] = {
			["font"] = "Expressway",
			["fontOutline"] = "OUTLINE",
			["size"] = 16,
			["justifyH"] = "RIGHT",
			["text_format"] = "[perhp<%]",
			["attachTextTo"] = "Health",
			["xOffset"] = 0,
			["yOffset"] = 0,
		}
		E.db["unitframe"]["units"]["player"]["customTexts"]["Life"] = {
			["font"] = "Expressway",
			["fontOutline"] = "OUTLINE",
			["size"] = 16,
			["justifyH"] = "LEFT",
			["text_format"] = "[health:current-mUI]",
			["attachTextTo"] = "Health",
			["xOffset"] = 0,
			["yOffset"] = 0,
		}
		E.db["unitframe"]["units"]["player"]["customTexts"]["Resting"] = {
			["font"] = "Expressway",
			["fontOutline"] = "OUTLINE",
			["size"] = 12,
			["justifyH"] = "CENTER",
			["text_format"] = "[mUI-resting]",
			["attachTextTo"] = "InfoPanel",
			["xOffset"] = 0,
			["yOffset"] = 0,
		}
		E.db["unitframe"]["units"]["player"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["player"]["health"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["player"]["health"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["player"]["health"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["player"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["player"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["player"]["power"]["hideonnpc"] = true
		E.db["unitframe"]["units"]["player"]["power"]["detachFromFrame"] = false
		E.db["unitframe"]["units"]["player"]["power"]["text_format"] = "[perpp]"
		E.db["unitframe"]["units"]["player"]["power"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["player"]["power"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["player"]["power"]["xOffset"] = 0
		E.db["unitframe"]["units"]["player"]["power"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["buffs"]["enable"] = false
		E.db["unitframe"]["units"]["player"]["raidicon"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["raidicon"]["position"] = "TOP"
		E.db["unitframe"]["units"]["player"]["raidicon"]["size"] = 18
		E.db["unitframe"]["units"]["player"]["raidicon"]["xOffset"] = 0
		E.db["unitframe"]["units"]["player"]["raidicon"]["yOffset"] = 15
		E.db["unitframe"]["units"]["player"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["infoPanel"]["height"] = 24
		E.db["unitframe"]["units"]["player"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["xOffset"] = 7
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["yOffset"] = 7
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["scale"] = 0.5
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["texture"] = "COMBAT"
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["customTexture"] = ""

		-- Target
		E.db["unitframe"]["units"]["target"]["width"] = 200
		E.db["unitframe"]["units"]["target"]["height"] = 50
		E.db["unitframe"]["units"]["target"]["orientation"] = "LEFT"
		E.db["unitframe"]["units"]["target"]["castbar"]["icon"] = true
		E.db["unitframe"]["units"]["target"]["castbar"]["latency"] = true
		E.db["unitframe"]["units"]["target"]["castbar"]["insideInfoPanel"] = true
		E.db["unitframe"]["units"]["target"]["debuffs"]["fontSize"] = 12
		E.db["unitframe"]["units"]["target"]["debuffs"]["sizeOverride"] = 28
		E.db["unitframe"]["units"]["target"]["debuffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["target"]["debuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["target"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["target"]["debuffs"]["perrow"] = 4
		E.db["unitframe"]["units"]["target"]["debuffs"]["attachTo"] = "BUFFS"
		E.db["unitframe"]["units"]["target"]["debuffs"]["priority"] = "Blacklist,Personal,RaidDebuffs,CCDebuffs,Friendly:Dispellable"
		E.db["unitframe"]["units"]["target"]["smartAuraPosition"] = "DISABLED"
		E.db["unitframe"]["units"]["target"]["aurabar"]["enable"] = false
		E.db["unitframe"]["units"]["target"]["aurabar"]["attachTo"] = "BUFFS"
		E.db["unitframe"]["units"]["target"]["name"]["xOffset"] = 8
		E.db["unitframe"]["units"]["target"]["name"]["yOffset"] = -32
		E.db["unitframe"]["units"]["target"]["name"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["target"]["threatStyle"] = "INFOPANELBORDER"
		E.db["unitframe"]["units"]["target"]["power"]["detachFromFrame"] = false
		E.db["unitframe"]["units"]["target"]["power"]["hideonnpc"] = false
		E.db["unitframe"]["units"]["target"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["target"]["power"]["text_format"] = ""
		if not E.db["unitframe"]["units"]["target"]["customTexts"] then E.db["unitframe"]["units"]["target"]["customTexts"] = {} end
		-- Delete old customTexts/ Create empty table
		E.db["unitframe"]["units"]["target"]["customTexts"] = {}
		-- Create own customText
		E.db["unitframe"]["units"]["target"]["customTexts"]["BigName"] = {
			["font"] = "Expressway",
			["justifyH"] = "LEFT",
			["fontOutline"] = "OUTLINE",
			["xOffset"] = 0,
			["yOffset"] = 0,
			["size"] = 12,
			["text_format"] = "[name:abbrev]",
			["attachTextTo"] = "InfoPanel",
		}
		E.db["unitframe"]["units"]["target"]["customTexts"]["Class"] = {
			["font"] = "Expressway",
			["justifyH"] = "RIGHT",
			["fontOutline"] = "OUTLINE",
			["xOffset"] = 0,
			["size"] = 10,
			["text_format"] = "[faction:icon][namecolor][smartclass] [difficultycolor][level][shortclassification]",
			["yOffset"] = 0,
			["attachTextTo"] = "InfoPanel",
		}
		E.db["unitframe"]["units"]["target"]["customTexts"]["Percent"] = {
			["font"] = "Expressway",
			["size"] = 16,
			["fontOutline"] = "OUTLINE",
			["justifyH"] = "LEFT",
			["text_format"] = "[perhp<%]",
			["attachTextTo"] = "Health",
			["yOffset"] = 0,
			["xOffset"] = 0,
		}
		E.db["unitframe"]["units"]["target"]["customTexts"]["Life"] = {
			["font"] = "Expressway",
			["size"] = 16,
			["fontOutline"] = "OUTLINE",
			["justifyH"] = "RIGHT",
			["text_format"] = "[health:current-mUI] | [power:current-mUI]",
			["attachTextTo"] = "Health",
			["yOffset"] = 0,
			["xOffset"] = 0,
		}
		E.db["unitframe"]["units"]["target"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["target"]["health"]["yOffset"] = 0
		E.db["unitframe"]["units"]["target"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["target"]["health"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["target"]["health"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["target"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["buffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["target"]["buffs"]["yOffset"] = 1
		E.db["unitframe"]["units"]["target"]["buffs"]["attachTo"] = "Health"
		E.db["unitframe"]["units"]["target"]["buffs"]["sizeOverride"] = 22
		E.db["unitframe"]["units"]["target"]["buffs"]["perrow"] = 8
		E.db["unitframe"]["units"]["target"]["buffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["target"]["buffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["target"]["buffs"]["minDuration"] = 0
		E.db["unitframe"]["units"]["target"]["buffs"]["maxDuration"] = 0
		E.db["unitframe"]["units"]["target"]["buffs"]["priority"] = "Personal,Boss,Whitelist,Blacklist,PlayerBuffs,nonPersonal"
		E.db["unitframe"]["units"]["target"]["raidicon"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["raidicon"]["position"] = "TOP"
		E.db["unitframe"]["units"]["target"]["raidicon"]["size"] = 18
		E.db["unitframe"]["units"]["target"]["raidicon"]["xOffset"] = 0
		E.db["unitframe"]["units"]["target"]["raidicon"]["yOffset"] = 15
		E.db["unitframe"]["units"]["target"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["infoPanel"]["height"] = 24
		E.db["unitframe"]["units"]["target"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["anchorPoint"] = "TOPLEFT"
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["scale"] = 0.5
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["xOffset"] = -7
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["yOffset"] = 7

		-- TargetTarget
		E.db["unitframe"]["units"]["targettarget"]["debuffs"]["enable"] = true
		E.db["unitframe"]["units"]["targettarget"]["power"]["enable"] = true
		E.db["unitframe"]["units"]["targettarget"]["power"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["targettarget"]["power"]["height"] = 7
		E.db["unitframe"]["units"]["targettarget"]["width"] = 100
		E.db["unitframe"]["units"]["targettarget"]["name"]["yOffset"] = 0
		E.db["unitframe"]["units"]["targettarget"]["name"]["text_format"] = "[name:medium]"
		E.db["unitframe"]["units"]["targettarget"]["height"] = 32
		E.db["unitframe"]["units"]["targettarget"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["targettarget"]["raidicon"]["enable"] = true
		E.db["unitframe"]["units"]["targettarget"]["raidicon"]["position"] = "TOP"
		E.db["unitframe"]["units"]["targettarget"]["raidicon"]["size"] = 18
		E.db["unitframe"]["units"]["targettarget"]["raidicon"]["xOffset"] = 0
		E.db["unitframe"]["units"]["targettarget"]["raidicon"]["yOffset"] = 15
		E.db["unitframe"]["units"]["targettarget"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["targettarget"]["infoPanel"]["enable"] = false
		if not E.db["unitframe"]["units"]["targettarget"]["customTexts"] then E.db["unitframe"]["units"]["targettarget"]["customTexts"] = {} end
		-- Delete old customTexts/ Create empty table
		E.db["unitframe"]["units"]["targettarget"]["customTexts"] = {}

		-- Focus
		E.db["unitframe"]["units"]["focus"]["width"] = 100
		E.db["unitframe"]["units"]["focus"]["height"] = 32
		E.db["unitframe"]["units"]["focus"]["name"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["focus"]["name"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["focus"]["name"]["text_format"] = "[name:medium]"
		E.db["unitframe"]["units"]["focus"]["health"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["focus"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["focus"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["focus"]["health"]["yOffset"] = 0
		E.db["unitframe"]["units"]["focus"]["health"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["focus"]["power"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["focus"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["focus"]["power"]["text_format"] = ""
		E.db["unitframe"]["units"]["focus"]["power"]["xOffset"] = 0
		E.db["unitframe"]["units"]["focus"]["power"]["yOffset"] = 0
		E.db["unitframe"]["units"]["focus"]["power"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["focus"]["castbar"]["enable"] = true
		E.db["unitframe"]["units"]["focus"]["castbar"]["latency"] = true
		E.db["unitframe"]["units"]["focus"]["castbar"]["insideInfoPanel"] = false
		E.db["unitframe"]["units"]["focus"]["castbar"]["iconSize"] = 20
		E.db["unitframe"]["units"]["focus"]["castbar"]["height"] = 18
		E.db["unitframe"]["units"]["focus"]["castbar"]["width"] = 100
		E.db["unitframe"]["units"]["focus"]["debuffs"]["anchorPoint"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["focus"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["focus"]["infoPanel"]["enable"] = false

		-- FocusTarget
		E.db["unitframe"]["units"]["focustarget"]["enable"] = false

		-- Raid
		E.db["unitframe"]["units"]["raid"]["height"] = 35
		E.db["unitframe"]["units"]["raid"]["width"] = 135
		E.db["unitframe"]["units"]["raid"]["threatStyle"] = "GLOW"
		E.db["unitframe"]["units"]["raid"]["orientation"] = "MIDDLE"
		E.db["unitframe"]["units"]["raid"]["horizontalSpacing"] = 1
		E.db["unitframe"]["units"]["raid"]["verticalSpacing"] = 2
		E.db["unitframe"]["units"]["raid"]["debuffs"]["countFontSize"] = 12
		E.db["unitframe"]["units"]["raid"]["debuffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["debuffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["raid"]["debuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["debuffs"]["yOffset"] = -8
		E.db["unitframe"]["units"]["raid"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["raid"]["debuffs"]["sizeOverride"] = 15
		E.db["unitframe"]["units"]["raid"]["debuffs"]["maxDuration"] = 0
		E.db["unitframe"]["units"]["raid"]["debuffs"]["priority"] = "Blacklist,Boss,RaidDebuffs,nonPersonal,CastByUnit,CCDebuffs,CastByNPC,Dispellable"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["enable"] = false
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["font"] = "Expressway"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["size"] = 20
		E.db["unitframe"]["units"]["raid"]["numGroups"] = 4
		E.db["unitframe"]["units"]["raid"]["growthDirection"] = "RIGHT_UP"
		E.db["unitframe"]["units"]["raid"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["raid"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["raid"]["buffIndicator"]["fontSize"] = 11
		E.db["unitframe"]["units"]["raid"]["buffIndicator"]["size"] = 10
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["size"] = 10
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["xOffset"] = 1
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["yOffset"] = -1
		E.db["unitframe"]["units"]["raid"]["power"]["enable"] = false
		E.db["unitframe"]["units"]["raid"]["power"]["height"] = 4
		E.db["unitframe"]["units"]["raid"]["groupBy"] = "ROLE"
		E.db["unitframe"]["units"]["raid"]["health"]["frequentUpdates"] = true
		E.db["unitframe"]["units"]["raid"]["health"]["position"] = "BOTTOM"
		E.db["unitframe"]["units"]["raid"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["raid"]["health"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["raid"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["buffs"]["yOffset"] = 5
		E.db["unitframe"]["units"]["raid"]["buffs"]["anchorPoint"] = "CENTER"
		E.db["unitframe"]["units"]["raid"]["buffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["raid"]["buffs"]["useBlacklist"] = false
		E.db["unitframe"]["units"]["raid"]["buffs"]["useWhitelist"] = true
		E.db["unitframe"]["units"]["raid"]["buffs"]["noDuration"] = false
		E.db["unitframe"]["units"]["raid"]["buffs"]["playerOnly"] = false
		E.db["unitframe"]["units"]["raid"]["buffs"]["perrow"] = 1
		E.db["unitframe"]["units"]["raid"]["buffs"]["useFilter"] = "MER_RaidCDs"
		E.db["unitframe"]["units"]["raid"]["buffs"]["noConsolidated"] = false
		E.db["unitframe"]["units"]["raid"]["buffs"]["sizeOverride"] = 20
		E.db["unitframe"]["units"]["raid"]["buffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["buffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["buffs"]["countFontSize"] = 12
		E.db["unitframe"]["units"]["raid"]["buffs"]["useFilter"] = "MER_RaidCDs"
		E.db["unitframe"]["units"]["raid"]["buffs"]["priority"] = "MER_RaidCDs"
		E.db["unitframe"]["units"]["raid"]["raidicon"]["attachTo"] = "CENTER"
		E.db["unitframe"]["units"]["raid"]["raidicon"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["raidicon"]["yOffset"] = 5
		E.db["unitframe"]["units"]["raid"]["raidicon"]["size"] = 15
		E.db["unitframe"]["units"]["raid"]["raidicon"]["yOffset"] = 0
		if not E.db["unitframe"]["units"]["raid"]["customTexts"] then E.db["unitframe"]["units"]["raid"]["customTexts"] = {} end
		-- Delete old customTexts/ Create empty table
		E.db["unitframe"]["units"]["raid"]["customTexts"] = {}
		-- Create own customTexts
		E.db["unitframe"]["units"]["raid"]["customTexts"]["Status"] = {
			["font"] = "Expressway",
			["justifyH"] = "CENTER",
			["fontOutline"] = "OUTLINE",
			["xOffset"] = 0,
			["yOffset"] = -12,
			["size"] = 9,
			["attachTextTo"] = "Health",
			["text_format"] = "[statustimer]",
		}
		E.db["unitframe"]["units"]["raid"]["customTexts"]["name1"] = {
			["font"] = "Expressway",
			["size"] = 10,
			["fontOutline"] = "OUTLINE",
			["justifyH"] = "CENTER",
			["yOffset"] = 0,
			["xOffset"] = 0,
			["attachTextTo"] = "Health",
			["text_format"] = "[name:medium]",
		}
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["height"] = 13
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["damager"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["tank"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["heal"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["attachTo"] = "Health"
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["yOffset"] = -1
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["xOffset"] = 1
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["size"] = 10
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["raid"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["raid"]["readycheckIcon"]["size"] = 20
		if IsAddOnLoaded("ElvUI_BenikUI") then
			E.db["unitframe"]["units"]["raid"]["classHover"] = true
		end

		-- Raid40
		E.db["unitframe"]["units"]["raid40"]["horizontalSpacing"] = 1
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["sizeOverride"] = 21
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["useBlacklist"] = false
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["yOffset"] = -9
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["useFilter"] = "Whitlist (Strict)"
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["xOffset"] = -4
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["perrow"] = 2
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["maxDuration"] = 0
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["priority"] = "Blacklist,Boss,RaidDebuffs,nonPersonal,CastByUnit,CCDebuffs,CastByNPC,Dispellable"
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["font"] = "Expressway"
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
		E.db["unitframe"]["units"]["raid40"]["buffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["raid40"]["buffs"]["useFilter"] = "TurtleBuffs"
		E.db["unitframe"]["units"]["raid40"]["buffs"]["enable"] = false
		E.db["unitframe"]["units"]["raid40"]["power"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["raid40"]["power"]["height"] = 3
		E.db["unitframe"]["units"]["raid40"]["power"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["power"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["raid40"]["raidicon"]["attachTo"] = "LEFT"
		E.db["unitframe"]["units"]["raid40"]["raidicon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["raidicon"]["xOffset"] = 9
		E.db["unitframe"]["units"]["raid40"]["raidicon"]["size"] = 13
		E.db["unitframe"]["units"]["raid40"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["raid40"]["readycheckIcon"]["size"] = 20

		-- Party
		E.db["unitframe"]["units"]["party"]["growthDirection"] = "RIGHT_UP"
		E.db["unitframe"]["units"]["party"]["horizontalSpacing"] = 1
		E.db["unitframe"]["units"]["party"]["debuffs"]["countFontSize"] = 12
		E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] =15
		E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = -8
		E.db["unitframe"]["units"]["party"]["debuffs"]["maxDuration"] = 0
		E.db["unitframe"]["units"]["party"]["debuffs"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["debuffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["party"]["debuffs"]["attachTo"] = "HEALTH"
		E.db["unitframe"]["units"]["party"]["debuffs"]["priority"] = "Blacklist,Boss,RaidDebuffs,nonPersonal,CastByUnit,CCDebuffs,CastByNPC,Dispellable"
		E.db["unitframe"]["units"]["party"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["party"]["debuffs"]["perrow"] = 1
		E.db["unitframe"]["units"]["party"]["rdebuffs"]["font"] = "Expressway"
		E.db["unitframe"]["units"]["party"]["rdebuffs"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["party"]["rdebuffs"]["size"] = 20
		E.db["unitframe"]["units"]["party"]["rdebuffs"]["yOffset"] = 12
		E.db["unitframe"]["units"]["party"]["buffIndicator"]["size"] = 10
		E.db["unitframe"]["units"]["party"]["buffIndicator"]["fontSize"] = 11
		E.db["unitframe"]["units"]["party"]["orientation"] = "MIDDLE"
		E.db["unitframe"]["units"]["party"]["verticalSpacing"] = 5
		E.db["unitframe"]["units"]["party"]["roleIcon"]["xOffset"] = 1
		E.db["unitframe"]["units"]["party"]["roleIcon"]["size"] = 10
		E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["yOffset"] = -1
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["enable"] = false
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["anchorPoint"] = "BOTTOM"
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["name"]["text_format"] = "[name:short]"
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["height"] = 16
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["width"] = 79
		E.db["unitframe"]["units"]["party"]["readycheckIcon"]["size"] = 20
		E.db["unitframe"]["units"]["party"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["party"]["power"]["position"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["party"]["power"]["text_format"] = ""
		E.db["unitframe"]["units"]["party"]["power"]["yOffset"] = 2
		E.db["unitframe"]["units"]["party"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["party"]["width"] = 135
		E.db["unitframe"]["units"]["party"]["health"]["frequentUpdates"] = true
		E.db["unitframe"]["units"]["party"]["health"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["party"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["party"]["health"]["yOffset"] = 2
		E.db["unitframe"]["units"]["party"]["name"]["attachTextTo"] = "Frame"
		E.db["unitframe"]["units"]["party"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["party"]["name"]["position"] = "BOTTOMLEFT"
		E.db["unitframe"]["units"]["party"]["groupBy"] = "ROLE"
		E.db["unitframe"]["units"]["party"]["height"] = 45
		E.db["unitframe"]["units"]["party"]["buffs"]["countFontSize"] = 12
		E.db["unitframe"]["units"]["party"]["buffs"]["sizeOverride"] = 20
		E.db["unitframe"]["units"]["party"]["buffs"]["useBlacklist"] = false
		E.db["unitframe"]["units"]["party"]["buffs"]["useWhitelist"] = true
		E.db["unitframe"]["units"]["party"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["buffs"]["playerOnly"] = false
		E.db["unitframe"]["units"]["party"]["buffs"]["perrow"] = 1
		E.db["unitframe"]["units"]["party"]["buffs"]["anchorPoint"] = "CENTER"
		E.db["unitframe"]["units"]["party"]["buffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["party"]["buffs"]["useFilter"] = "MER_RaidCDs"
		E.db["unitframe"]["units"]["party"]["buffs"]["priority"] = "MER_RaidCDs"
		E.db["unitframe"]["units"]["party"]["buffs"]["noConsolidated"] = false
		E.db["unitframe"]["units"]["party"]["buffs"]["noDuration"] = false
		E.db["unitframe"]["units"]["party"]["petsGroup"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["party"]["petsGroup"]["height"] = 16
		E.db["unitframe"]["units"]["party"]["petsGroup"]["yOffset"] = -1
		E.db["unitframe"]["units"]["party"]["petsGroup"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["petsGroup"]["width"] = 60
		E.db["unitframe"]["units"]["party"]["raidicon"]["attachTo"] = "BOTTOMLEFT"
		E.db["unitframe"]["units"]["party"]["raidicon"]["yOffset"] = 6
		E.db["unitframe"]["units"]["party"]["raidicon"]["xOffset"] = 1
		E.db["unitframe"]["units"]["party"]["raidicon"]["size"] = 19
		if E.db["unitframe"]["units"]["party"]["customTexts"] then E.db["unitframe"]["units"]["party"]["customTexts"] = nil end
		-- Delete old customTexts/ Create empty table
		E.db["unitframe"]["units"]["party"]["customTexts"] = {}
		-- Create own customTexts
		E.db["unitframe"]["units"]["party"]["customTexts"]["name1"] = {
			["font"] = "Expressway",
			["size"] = 10,
			["fontOutline"] = "OUTLINE",
			["justifyH"] = "CENTER",
			["yOffset"] = 0,
			["xOffset"] = 0,
			["attachTextTo"] = "Health",
			["text_format"] = "[name:medium]",
		}
		E.db["unitframe"]["units"]["party"]["customTexts"]["Status"] = {
			["font"] = "Expressway",
			["justifyH"] = "CENTER",
			["fontOutline"] = "OUTLINE",
			["xOffset"] = 0,
			["yOffset"] = -10,
			["size"] = 12,
			["attachTextTo"] = "Health",
			["text_format"] = "[statustimer]",
		}

		-- Assist
		E.db["unitframe"]["units"]["assist"]["enable"] = false

		-- Tank
		E.db["unitframe"]["units"]["tank"]["enable"] = false

		-- Pet
		E.db["unitframe"]["units"]["pet"]["castbar"]["enable"] = true
		E.db["unitframe"]["units"]["pet"]["castbar"]["latency"] = true
		E.db["unitframe"]["units"]["pet"]["castbar"]["width"] = 100
		E.db["unitframe"]["units"]["pet"]["castbar"]["height"] = 10
		E.db["unitframe"]["units"]["pet"]["castbar"]["insideInfoPanel"] = true
		E.db["unitframe"]["units"]["pet"]["debuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["pet"]["debuffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["pet"]["debuffs"]["sizeOverride"] = 0
		E.db["unitframe"]["units"]["pet"]["debuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["pet"]["debuffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["pet"]["debuffs"]["perrow"] = 5
		E.db["unitframe"]["units"]["pet"]["debuffs"]["anchorPoint"] = "TOPLEFT"
		E.db["unitframe"]["units"]["pet"]["health"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["pet"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["pet"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["pet"]["health"]["yOffset"] = 0
		E.db["unitframe"]["units"]["pet"]["health"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["pet"]["power"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["pet"]["power"]["height"] = 4
		E.db["unitframe"]["units"]["pet"]["power"]["text_format"] = ""
		E.db["unitframe"]["units"]["pet"]["power"]["xOffset"] = 0
		E.db["unitframe"]["units"]["pet"]["power"]["yOffset"] = 0
		E.db["unitframe"]["units"]["pet"]["power"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["pet"]["name"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["pet"]["name"]["text_format"] = "[name:medium]"
		E.db["unitframe"]["units"]["pet"]["name"]["xOffset"] = 0
		E.db["unitframe"]["units"]["pet"]["name"]["yOffset"] = 0
		E.db["unitframe"]["units"]["pet"]["width"] = 100
		E.db["unitframe"]["units"]["pet"]["height"] = 29
		E.db["unitframe"]["units"]["pet"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["pet"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["pet"]["orientation"] = "MIDDLE"
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["height"] = 14
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["transparent"] = true

		-- Arena
		E.db["unitframe"]["units"]["arena"]["power"]["width"] = "inset"

		-- Boss
		E.db["unitframe"]["units"]["boss"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["boss"]["debuffs"]["sizeOverride"] = 22
		E.db["unitframe"]["units"]["boss"]["debuffs"]["yOffset"] = 1
		E.db["unitframe"]["units"]["boss"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["boss"]["debuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["boss"]["debuffs"]["perrow"] = 6
		E.db["unitframe"]["units"]["boss"]["debuffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["boss"]["debuffs"]["countFontSize"] = 12
		E.db["unitframe"]["units"]["boss"]["threatStyle"] = "HEALTHBORDER"
		E.db["unitframe"]["units"]["boss"]["castbar"]["enable"] = true
		E.db["unitframe"]["units"]["boss"]["castbar"]["insideInfoPanel"] = true
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["height"] = 15
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["transparent"] = true
		if not E.db["unitframe"]["units"]["boss"]["customTexts"] then E.db["unitframe"]["units"]["boss"]["customTexts"] = {} end
		-- Delete old customTexts/ Create empty table
		E.db["unitframe"]["units"]["boss"]["customTexts"] = {}
		-- Create own customTexts
		E.db["unitframe"]["units"]["boss"]["customTexts"]["BigName"] = {
			["attachTextTo"] = "InfoPanel",
			["font"] = "Expressway",
			["justifyH"] = "LEFT",
			["fontOutline"] = "OUTLINE",
			["xOffset"] = 0,
			["size"] = 11,
			["text_format"] = "[name:medium]",
			["yOffset"] = 1,
		}
		E.db["unitframe"]["units"]["boss"]["customTexts"]["Class"] = {
			["attachTextTo"] = "InfoPanel",
			["font"] = "Expressway",
			["justifyH"] = "RIGHT",
			["fontOutline"] = "OUTLINE",
			["xOffset"] = 0,
			["text_format"] = "[namecolor][smartclass][difficultycolor][level][shortclassification]",
			["yOffset"] = 1,
		}
		E.db["unitframe"]["units"]["boss"]["customTexts"]["Life"] = {
			["attachTextTo"] = "Health",
			["font"] = "Expressway",
			["justifyH"] = "LEFT",
			["fontOutline"] = "OUTLINE",
			["xOffset"] = 0,
			["size"] = 14,
			["text_format"] = "[health:current-mUI]",
			["yOffset"] = 0,
		}
		E.db["unitframe"]["units"]["boss"]["customTexts"]["Percent"] = {
			["attachTextTo"] = "Health",
			["font"] = "Expressway",
			["justifyH"] = "RIGHT",
			["fontOutline"] = "OUTLINE",
			["xOffset"] = 0,
			["size"] = 14,
			["text_format"] = "[perhp<%]",
			["yOffset"] = 0,
		}
		E.db["unitframe"]["units"]["boss"]["power"]["xOffset"] = 0
		E.db["unitframe"]["units"]["boss"]["power"]["attachTextTo"] = "Power"
		E.db["unitframe"]["units"]["boss"]["power"]["height"] = 9
		E.db["unitframe"]["units"]["boss"]["power"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["boss"]["power"]["text_format"] = "[powercolor][power:percent]"
		E.db["unitframe"]["units"]["boss"]["growthDirection"] = "UP"
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["height"] = 15
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["boss"]["width"] = 156
		E.db["unitframe"]["units"]["boss"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["boss"]["health"]["yOffset"] = 13
		E.db["unitframe"]["units"]["boss"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["boss"]["health"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["boss"]["spacing"] = 24
		E.db["unitframe"]["units"]["boss"]["height"] = 35
		E.db["unitframe"]["units"]["boss"]["buffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["boss"]["buffs"]["xOffset"] = -2
		E.db["unitframe"]["units"]["boss"]["buffs"]["yOffset"] = 10
		E.db["unitframe"]["units"]["boss"]["buffs"]["sizeOverride"] = 32
		E.db["unitframe"]["units"]["boss"]["buffs"]["anchorPoint"] = "LEFT"
		E.db["unitframe"]["units"]["boss"]["buffs"]["countFontSize"] = 12
		E.db["unitframe"]["units"]["boss"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["boss"]["name"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["boss"]["name"]["xOffset"] = 6
		E.db["unitframe"]["units"]["boss"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["boss"]["name"]["yOffset"] = 16

		-- PetTarget
		E.db["unitframe"]["units"]["pettarget"]["enable"] = false

		-- RaidPet
		E.db["unitframe"]["units"]["raidpet"]["enable"] = false

		-- Movers
		MER:SetMoverPosition("ElvUF_PlayerMover", "BOTTOM", E.UIParent, "BOTTOM", -240, 123)
		MER:SetMoverPosition("ElvUF_TargetMover", "BOTTOM", E.UIParent, "BOTTOM", 240, 123)
		MER:SetMoverPosition("ElvUF_TargetTargetMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -518, 165)
		MER:SetMoverPosition("ElvUF_FocusMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -518, 292)
		MER:SetMoverPosition("ElvUF_FocusCastbarMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -518, 325)
		MER:SetMoverPosition("ElvUF_FocusTargetMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -513, 277)
		MER:SetMoverPosition("ElvUF_RaidMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 250)
		MER:SetMoverPosition("ElvUF_Raid40Mover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 40, 198)
		MER:SetMoverPosition("ElvUF_PartyMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 250)
		MER:SetMoverPosition("ElvUF_AssistMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 2, 571)
		MER:SetMoverPosition("ElvUF_TankMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 2, 626)
		MER:SetMoverPosition("ElvUF_PetMover", "BOTTOM", E.UIParent, "BOTTOM", -290, 95)
		MER:SetMoverPosition("ElvUF_PetCastbarMover", "BOTTOM", E.UIParent, "BOTTOM", -290, 84)
		MER:SetMoverPosition("ArenaHeaderMover", "TOPRIGHT" , E.UIParent, "TOPRIGHT", -305,-305)
		MER:SetMoverPosition("BossHeaderMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -305, -305)
		MER:SetMoverPosition("ElvUF_RaidpetMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 0, 808)
	end

	E:UpdateAll(true)

	PluginInstallStepComplete.message = MER.Title..L["UnitFrames Set"]
	PluginInstallStepComplete:Show()
end

function MER:SetupDts()
	--[[----------------------------------
	--	ProfileDB - Datatexts
	--]]----------------------------------
	E.db["datatexts"]["font"] = "Expressway"
	E.db["datatexts"]["fontSize"] = 10
	E.db["datatexts"]["fontOutline"] = "OUTLINE"
	E.db["datatexts"]["time24"] = true
	E.db["datatexts"]["goldFormat"] = "CONDENSED"
	E.db["datatexts"]["goldCoins"] = true
	E.db["datatexts"]["noCombatHover"] = true
	E.db["datatexts"]["panelTransparency"] = true
	E.db["datatexts"]["wordWrap"] = true

	E.db["datatexts"]["leftChatPanel"] = false
	E.db["datatexts"]["rightChatPanel"] = false
	E.db["datatexts"]["minimapPanels"] = false
	E.db["datatexts"]["minimapBottom"] = false
	E.db["datatexts"]["actionbar3"] = false
	E.db["datatexts"]["actionbar5"] = false
	E.db["datatexts"]["minimapBottom"] = false

	E.db["mui"]["datatexts"]["panels"]["ChatTab_Datatext_Panel"].left = "BfA Missions"
	E.db["mui"]["datatexts"]["panels"]["ChatTab_Datatext_Panel"].middle = "Durability"

	E.db["mui"]["datatexts"]["panels"]["ChatTab_Datatext_Panel"].right = "Gold"

	E.db["mui"]["datatexts"]["panels"]["mUIMiddleDTPanel"]["left"] = "Guild"
	E.db["mui"]["datatexts"]["panels"]["mUIMiddleDTPanel"]["middle"] = "System"
	E.db["mui"]["datatexts"]["panels"]["mUIMiddleDTPanel"]["right"] = "Friends"

	-- define the default ElvUI datatexts
	E.db["datatexts"]["panels"]["LeftChatDataPanel"]["left"] = ""
	E.db["datatexts"]["panels"]["LeftChatDataPanel"]["middle"] = ""
	E.db["datatexts"]["panels"]["LeftChatDataPanel"]["right"] = ""

	E.db["datatexts"]["panels"]["RightChatDataPanel"]["left"] = ""
	E.db["datatexts"]["panels"]["RightChatDataPanel"]["middle"] = ""
	E.db["datatexts"]["panels"]["RightChatDataPanel"]["right"] = ""

	E.db["datatexts"]["panels"]["BottomMiniPanel"] = ""

	E:UpdateAll(true)

	PluginInstallStepComplete.message = MER.Title..L["DataTexts Set"]
	PluginInstallStepComplete:Show()
end

local addonNames = {}
local profilesFailed = format("|cff00c0fa%s |r", L["MerathilisUI didn't find any supported addons for profile creation"])

MER.isInstallerRunning = false

function MER:SetupAddOns()
	MER.isInstallerRunning = true -- don't print when applying profile that doesn't exist

	--AddOnSkins
	if MER:IsAddOnEnabled("AddOnSkins") then
		MER:LoadAddOnSkinsProfile()
		tinsert(addonNames, "AddOnSkins")
	end

	-- ProjectAzilroka
	if MER:IsAddOnEnabled("ProjectAzilroka") then
		MER:LoadPAProfile()
		tinsert(addonNames, "ProjectAzilroka")
	end

	-- BenikUI
	if MER:IsAddOnEnabled("ElvUI_BenikUI") then
		MER:LoadBenikUIProfile()
		tinsert(addonNames, "ElvUI_BenikUI")
	end

	if checkTable(addonNames) ~= nil then
		local profileString = format("|cfffff400%s |r", L["MerathilisUI successfully created and applied profile(s) for:"].."\n")

		tsort(addonNames, function(a, b) return a < b end)
		local names = tconcat(addonNames, ", ")
		profileString = profileString..names

		PluginInstallFrame.Desc4:SetText(profileString..'.')
	else
		PluginInstallFrame.Desc4:SetText(profilesFailed)
	end

	PluginInstallStepComplete.message = MER.Title..L['Addons Set']
	PluginInstallStepComplete:Show()
	twipe(addonNames)
	E:UpdateAll(true)

end

local function InstallComplete()
	E.private.install_complete = E.version
	E.db.mui.installed = true
	MERDataPerChar = MER.Version

	ReloadUI()
end

-- ElvUI PlugIn installer
MER.installTable = {
	["Name"] = "|cffff7d0aMerathilisUI|r",
	["Title"] = L["|cffff7d0aMerathilisUI|r Installation"],
	["tutorialImage"] = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\merathilis_logo.tga]],
	["Pages"] = {
		[1] = function()
			PluginInstallFrame.SubTitle:SetFormattedText(L["Welcome to MerathilisUI |cff00c0faVersion|r %s, for ElvUI %s."], MER.Version, E.version)
			PluginInstallFrame.Desc1:SetText(L["By pressing the Continue button, MerathilisUI will be applied in your current ElvUI installation.\r\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"])
			PluginInstallFrame.Desc2:SetText(L["Please press the continue button to go onto the next step."])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			PluginInstallFrame.Option1:SetText(L["Skip Process"])
		end,
		[2] = function()
			PluginInstallFrame.SubTitle:SetText(L["Profiles"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process let you create a new profile or install |cffff8000MerathilisUI|r settings to your current profile."])
			PluginInstallFrame.Desc2:SetFormattedText(L["|cffff8000Your currently active ElvUI profile is:|r %s."], "|cff00c0fa"..ElvUI[1].data:GetCurrentProfile().."|r")
			PluginInstallFrame.Desc3:SetText(L["Importance: |cffff0000Very High|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() MER:NewProfile(false) end)
			PluginInstallFrame.Option1:SetText(L["Current"])
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() MER:NewProfile(true, "MerathilisUI") end)
			PluginInstallFrame.Option2:SetText(NEW)
		end,
		[3] = function()
			PluginInstallFrame.SubTitle:SetText(L["Layout"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation changes the default ElvUI look."])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to apply the new layout."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cff07D400High|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() MER:SetupLayout() end)
			PluginInstallFrame.Option1:SetText(L["Layout"])
		end,
		[4] = function()
			PluginInstallFrame.SubTitle:SetText(L["CVars"])
			PluginInstallFrame.Desc1:SetFormattedText(L["This step changes a few World of Warcraft default options. These options are tailored to the needs of the author of %s and are not necessary for this edit to function."], MER.Title)
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to setup your CVars."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cffFF0000Low|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() SetupCVars() end)
			PluginInstallFrame.Option1:SetText(L["CVars"])
		end,
		[5] = function()
			PluginInstallFrame.SubTitle:SetText(L["Chat"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process sets up your chat fonts and colors."])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to setup your chat windows."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() SetupChat() end)
			PluginInstallFrame.Option1:SetText(L["Setup Chat"])
		end,
		[6] = function()
			PluginInstallFrame.SubTitle:SetText(L["DataTexts"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process will fill MerathilisUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to setup your datatexts."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() MER:SetupDts() end)
			PluginInstallFrame.Option1:SetText(L["Setup Datatexts"])
		end,
		[7] = function()
			PluginInstallFrame.SubTitle:SetText(L["ActionBars"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process will reposition your Actionbars and will enable backdrops"])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below |cff07D400twice|r to setup your actionbars."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cff07D400High|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() MER:SetupActionbars("dps") end)
			PluginInstallFrame.Option1:SetText(L["Tank/ DPS Layout"])
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() MER:SetupActionbars("healer") end)
			PluginInstallFrame.Option2:SetText(L["Heal Layout"])
		end,
		[8] = function()
			PluginInstallFrame.SubTitle:SetText(L["UnitFrames"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process will reposition your Unitframes."])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below |cff07D400twice|r to setup your Unitframes."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cff07D400High|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() MER:SetupUnitframes("dps") end)
			PluginInstallFrame.Option1:SetText(L["Tank/ DPS Layout"])
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() MER:SetupUnitframes("healer") end)
			PluginInstallFrame.Option2:SetText(L["Heal Layout"])
		end,
		[9] = function()
			PluginInstallFrame.SubTitle:SetFormattedText("%s", ADDONS)
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process will apply changes to ElvUI Plugins"])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to setup the ElvUI AddOns. For other Addon profiles please go in my Options - Skins/AddOns"])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() MER:SetupAddOns() end)
			PluginInstallFrame.Option1:SetText(L["Setup Addons"])
		end,
		[10] = function()
			PluginInstallFrame.SubTitle:SetText(L["Installation Complete"])
			PluginInstallFrame.Desc1:SetText(L["You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org."])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below so you can setup variables and ReloadUI."])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://discord.gg/ZhNqCu2") end)
			PluginInstallFrame.Option1:SetText(L["|cffff7d0aMerathilisUI|r Discord"])
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() InstallComplete() end)
			PluginInstallFrame.Option2:SetText(L["Finished"])

			if InstallStepComplete then
				InstallStepComplete.message = MER.Title..L["Installed"]
				InstallStepComplete:Show()
			end
		end,
	},

	["StepTitles"] = {
		[1] = START,
		[2] = L["Profiles"],
		[3] = L["Layout"],
		[4] = L["CVars"],
		[5] = L["Chat"],
		[6] = L["DataTexts"],
		[7] = L["ActionBars"],
		[8] = L["UnitFrames"],
		[9] = ADDONS,
		[10] = L["Installation Complete"],
	},
	StepTitlesColorSelected = E.myclass == "PRIEST" and E.PriestColors or RAID_CLASS_COLORS[E.myclass],
	StepTitleWidth = 200,
	StepTitleButtonWidth = 200,
	StepTitleTextJustification = "CENTER",
}
