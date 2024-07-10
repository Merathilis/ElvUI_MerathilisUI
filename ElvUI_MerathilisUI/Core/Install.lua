local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local PI = E:GetModule("PluginInstaller")
local CH = E:GetModule("Chat")
local PF = MER:GetModule("MER_Profiles")

local _G = _G
local ipairs, next = ipairs, next
local format, checkTable = string.format, next
local tinsert, twipe, tsort, tconcat = table.insert, table.wipe, table.sort, table.concat

local ADDONS = ADDONS
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local FCF_SetWindowName = FCF_SetWindowName
local FCF_ResetChatWindows = FCF_ResetChatWindows
local FCF_ResetChatWindow = FCF_ResetChatWindow
local FCF_DockFrame = FCF_DockFrame
local FCF_OpenNewWindow = FCF_OpenNewWindow
local FCF_SavePositionAndDimensions = FCF_SavePositionAndDimensions
local FCF_StopDragging = FCF_StopDragging
local ChatFrame_AddChannel = ChatFrame_AddChannel
local ChatFrame_AddMessageGroup = ChatFrame_AddMessageGroup
local ChatFrame_RemoveMessageGroup = ChatFrame_RemoveMessageGroup
local ChatFrame_RemoveChannel = ChatFrame_RemoveChannel
local ToggleChatColorNamesByClassGroup = ToggleChatColorNamesByClassGroup
local VoiceTranscriptionFrame_UpdateEditBox = VoiceTranscriptionFrame_UpdateEditBox
local VoiceTranscriptionFrame_UpdateVisibility = VoiceTranscriptionFrame_UpdateVisibility
local VoiceTranscriptionFrame_UpdateVoiceTab = VoiceTranscriptionFrame_UpdateVoiceTab
local LOOT = LOOT
local VOICE = VOICE

local Reload = C_UI and C_UI.Reload
local SetCVar = C_CVar and C_CVar.SetCVar

local MAX_WOW_CHAT_CHANNELS = MAX_WOW_CHAT_CHANNELS or 20

local IsInstalled = false
local function InstallComplete(fishished)
	E.private.install_complete = E.version
	E.db.mui.core.installed = true
	E.private.mui.general.install_complete = MER.Version

	MERDataPerChar = MER.Version

	if fishished then
		E.db.mui.core.lastLayoutVersion = MER.Version

		IsInstalled = true
	end

	Reload()
end

local function SetupCVars()
	-- Setup CVars
	SetCVar("autoQuestProgress", 1)
	SetCVar("alwaysShowActionBars", 1)
	SetCVar("guildMemberNotify", 1)
	SetCVar("TargetNearestUseNew", 1)
	SetCVar("cameraSmoothStyle", 0)
	SetCVar("cameraDistanceMaxZoomFactor", 2.6)
	SetCVar("UberTooltips", 1)
	SetCVar("lockActionBars", 1)
	SetCVar("chatMouseScroll", 1)
	SetCVar("countdownForCooldowns", 1)
	SetCVar("showQuestTrackingTooltips", 1)
	SetCVar("ffxGlow", 0)
	SetCVar("floatingCombatTextCombatState", "1")
	SetCVar("minimapTrackingShowAll", 1)
	SetCVar("fstack_preferParentKeys", 0)

	-- Nameplates
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("nameplateLargerScale", 1)
	SetCVar("nameplateLargeTopInset", -1)
	SetCVar("nameplateMinAlpha", 1)
	SetCVar("nameplateMinScale", 1)
	SetCVar("nameplateMotion", 1)
	SetCVar("nameplateOccludedAlphaMult", 1)
	SetCVar("nameplateOtherBottomInset", -1)
	SetCVar("nameplateOtherTopInset", -1)
	SetCVar("nameplateOverlapH", 1.1)
	SetCVar("nameplateOverlapV", 1.8)
	SetCVar("nameplateSelectedScale", 1)
	SetCVar("nameplateSelfAlpha", 1)
	SetCVar("nameplateSelfTopInset", -1)

	SetCVar("UnitNameEnemyGuardianName", 1)
	SetCVar("UnitNameEnemyMinionName", 1)
	SetCVar("UnitNameEnemyPetName", 1)
	SetCVar("UnitNameEnemyPlayerName", 1)
	SetCVar("profanityFilter", 0)

	-- CVars General
	SetCVar("chatStyle", "classic")
	SetCVar("whisperMode", "inline")
	SetCVar("colorChatNamesByClass", 1)
	SetCVar("chatClassColorOverride", 0)

	SetCVar("speechToText", 0)
	SetCVar("textToSpeech", 0)

	SetCVar("taintLog", 0)

	PluginInstallStepComplete.message = MER.Title .. L["CVars Set"]
	PluginInstallStepComplete:Show()
end

local function SetupChat()
	if not E.db.movers then
		E.db.movers = {}
	end

	local chats = _G.CHAT_FRAMES

	-- Reset chat to Blizzard defaults
	FCF_ResetChatWindows()

	-- Force initialize text-to-speech (it doesn't get shown)
	local voiceChat = _G[chats[3]]
	FCF_ResetChatWindow(voiceChat, VOICE)
	FCF_DockFrame(voiceChat, 3)

	-- Open one new channel for own Trade
	FCF_OpenNewWindow()

	for id, name in next, chats do
		local frame = _G[name]

		if E.private.chat.enable then
			CH:FCFTab_UpdateColors(CH:GetTab(frame))
		end

		-- Font size 11 for the Chat Frames
		FCF_SetChatWindowFontSize(nil, frame, 11)

		if id == 1 then
			FCF_SetWindowName(frame, _G.GENERAL)
		elseif id == 2 then
			FCF_SetWindowName(frame, _G.LOG)
		elseif id == 3 then
			VoiceTranscriptionFrame_UpdateVisibility(frame)
			VoiceTranscriptionFrame_UpdateVoiceTab(frame)
			VoiceTranscriptionFrame_UpdateEditBox(frame)
		elseif id == 4 then
			FCF_SetWindowName(frame, LOOT)
		end

		FCF_SavePositionAndDimensions(frame)
		FCF_StopDragging(frame)
	end

	ChatFrame_RemoveChannel(_G.ChatFrame4, L["Trade"])
	ChatFrame_AddChannel(_G.ChatFrame1, L["Trade"])

	ChatFrame_AddMessageGroup(_G.ChatFrame1, "TARGETICONS")
	ChatFrame_AddMessageGroup(_G.ChatFrame4, "COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(_G.ChatFrame4, "COMBAT_GUILD_XP_GAIN")
	ChatFrame_AddMessageGroup(_G.ChatFrame4, "COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(_G.ChatFrame4, "COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(_G.ChatFrame4, "CURRENCY")
	ChatFrame_AddMessageGroup(_G.ChatFrame4, "LOOT")
	ChatFrame_AddMessageGroup(_G.ChatFrame4, "MONEY")
	ChatFrame_AddMessageGroup(_G.ChatFrame4, "SKILL")

	ChatFrame_RemoveMessageGroup(_G.ChatFrame1, "COMBAT_FACTION_CHANGE")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame1, "COMBAT_GUILD_XP_GAIN")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame1, "COMBAT_HONOR_GAIN")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame1, "COMBAT_XP_GAIN")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame1, "CURRENCY")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame1, "LOOT")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame1, "MONEY")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame1, "SKILL")

	ChatFrame_RemoveMessageGroup(_G.ChatFrame4, "SAY")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame4, "YELL")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame4, "GUILD")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame4, "WHISPER")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame4, "BN_WHISPER")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame4, "PARTY")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame4, "PARTY_LEADER")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame4, "CHANNEL")

	local chatGroup = {
		"SAY",
		"EMOTE",
		"YELL",
		"WHISPER",
		"PARTY",
		"PARTY_LEADER",
		"RAID",
		"RAID_LEADER",
		"RAID_WARNING",
		"INSTANCE_CHAT",
		"INSTANCE_CHAT_LEADER",
		"GUILD",
		"OFFICER",
		"ACHIEVEMENT",
		"GUILD_ACHIEVEMENT",
		"COMMUNITIES_CHANNEL",
	}

	for i = 1, MAX_WOW_CHAT_CHANNELS do
		tinsert(chatGroup, "CHANNEL" .. i)
	end

	for _, v in ipairs(chatGroup) do
		ToggleChatColorNamesByClassGroup(true, v)
	end

	E.db["chat"]["keywordSound"] = "Whisper Alert"
	E.db["chat"]["panelTabTransparency"] = true
	E.db["chat"]["chatHistory"] = false
	E.db["chat"]["separateSizes"] = true
	E.db["chat"]["panelWidth"] = 427
	E.db["chat"]["panelHeight"] = 146
	E.db["chat"]["panelHeightRight"] = 146
	E.db["chat"]["panelWidthRight"] = 288
	E.db["chat"]["editBoxPosition"] = "ABOVE_CHAT_INSIDE"
	E.db["chat"]["panelBackdrop"] = "LEFT"
	E.db["chat"]["keywords"] = "%MYNAME%, ElvUI, MerathilisUI"
	E.db["chat"]["copyChatLines"] = true
	E.db["chat"]["panelColor"] = { r = 0.06, g = 0.06, b = 0.06, a = 0.45 }
	E.db["chat"]["useCustomTimeColor"] = true
	E.db["chat"]["customTimeColor"] = { r = 0, g = 0.75, b = 0.98 }
	E.db["chat"]["panelBackdropNameRight"] = ""
	E.db["chat"]["socialQueueMessages"] = false
	E.db["chat"]["hideChatToggles"] = true
	E.db["chat"]["tabSelector"] = "BOX"
	E.db["chat"]["tabSelectorColor"] = { r = F.r, g = F.g, b = F.b }

	E.db["chat"]["font"] = I.Fonts.Primary
	E.db["chat"]["fontOutline"] = "NONE"
	E.db["chat"]["tabFont"] = I.Fonts.Primary
	E.db["chat"]["tabFont"] = I.Fonts.Primary
	E.db["chat"]["tabFontOutline"] = "SHADOWOUTLINE"
	E.db["chat"]["tabFontSize"] = 10

	E.db["movers"]["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-149,47"
	E.db["movers"]["LeftChatMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,47"

	ChangeChatColor("CHANNEL1", 0.76, 0.90, 0.91) -- General
	ChangeChatColor("CHANNEL2", 0.91, 0.62, 0.47) -- Trade
	ChangeChatColor("CHANNEL3", 0.91, 0.89, 0.47) -- Local Defense

	if E.Chat then
		E.Chat:PositionChats()
	end

	E:StaggeredUpdateAll(nil, true)

	PluginInstallStepComplete.message = MER.Title .. L["Chat Set"]
	PluginInstallStepComplete:Show()
end

function MER:SetupLayout()
	if not E.db.movers then
		E.db.movers = {}
	end

	--[[----------------------------------
	--	PrivateDB - General
	--]]
	----------------------------------
	E.private["general"]["pixelPerfect"] = true
	E.private["general"]["chatBubbles"] = "backdrop_noborder"
	E.private["general"]["chatBubbleFont"] = I.Fonts.Primary
	E.private["general"]["chatBubbleFontSize"] = 9
	E.private["general"]["chatBubbleFontOutline"] = "SHADOWOUTLINE"
	E.private["general"]["chatBubbleName"] = true
	E.private["general"]["classColorMentionsSpeech"] = true
	E.private["general"]["namefont"] = I.Fonts.Primary
	E.private["general"]["dmgfont"] = I.Fonts.Primary
	E.private["general"]["normTex"] = "ElvUI Norm1"
	E.private["general"]["glossTex"] = "ElvUI Norm1"
	E.private["general"]["nameplateFont"] = I.Fonts.Primary
	E.private["general"]["nameplateLargeFont"] = I.Fonts.Primary
	E.private["general"]["loot"] = true
	E.private["general"]["lootRoll"] = true

	--[[----------------------------------
	--	GlobalDB - General
	--]]
	----------------------------------
	E.global["general"]["autoScale"] = true
	E.global["general"]["animateConfig"] = false
	E.global["general"]["smallerWorldMap"] = false
	E.global["general"]["WorldMapCoordinates"]["position"] = "BOTTOMRIGHT"
	E.global["general"]["commandBarSetting"] = "ENABLED"
	E.global["general"]["showMissingTalentAlert"] = true

	--[[----------------------------------
	--	ProfileDB - General
	--]]
	----------------------------------
	E.db["general"]["font"] = I.Fonts.Primary
	E.db["general"]["fontSize"] = 11
	E.db["general"]["fonts"]["worldzone"]["enable"] = true
	E.db["general"]["fonts"]["worldzone"]["size"] = 32
	E.db["general"]["fonts"]["worldzone"]["outline"] = "SHADOWOUTLINE"
	E.db["general"]["fonts"]["worldsubzone"]["enable"] = true
	E.db["general"]["fonts"]["worldsubzone"]["size"] = 28
	E.db["general"]["fonts"]["worldsubzone"]["outline"] = "SHADOWOUTLINE"
	E.db["general"]["fonts"]["talkingtitle"]["enable"] = true
	E.db["general"]["fonts"]["talkingtitle"]["size"] = 20
	E.db["general"]["fonts"]["talkingtitle"]["outline"] = "SHADOWOUTLINE"
	E.db["general"]["fonts"]["talkingtext"]["enable"] = true
	E.db["general"]["fonts"]["talkingtext"]["size"] = 14
	E.db["general"]["fonts"]["talkingtext"]["outline"] = "SHADOWOUTLINE"
	E.db["general"]["fonts"]["errortext"]["enable"] = true
	E.db["general"]["fonts"]["errortext"]["size"] = 16
	E.db["general"]["fonts"]["errortext"]["outline"] = "SHADOWOUTLINE"
	E.db["general"]["valuecolor"] = { r = F.r, g = F.g, b = F.b }
	E.db["general"]["bordercolor"] = { r = 0, g = 0, b = 0 }
	E.db["general"]["backdropfadecolor"] = { a = 0.45, r = 0, g = 0, b = 0 }
	E.db["general"]["interruptAnnounce"] = "RAID"
	E.db["general"]["minimap"]["clusterDisable"] = true
	E.db["general"]["minimap"]["locationText"] = "MOUSEOVER"
	E.db["general"]["minimap"]["icons"]["classHall"]["position"] = "TOPLEFT"
	E.db["general"]["minimap"]["icons"]["classHall"]["scale"] = 0.6
	E.db["general"]["minimap"]["icons"]["classHall"]["xOffset"] = 0
	E.db["general"]["minimap"]["icons"]["classHall"]["yOffset"] = 0
	E.db["general"]["minimap"]["icons"]["mail"]["texture"] = "Mail2"
	E.db["general"]["minimap"]["icons"]["mail"]["position"] = "BOTTOMLEFT"
	E.db["general"]["minimap"]["icons"]["mail"]["scale"] = 1
	E.db["general"]["minimap"]["icons"]["mail"]["xOffset"] = 5
	E.db["general"]["minimap"]["icons"]["mail"]["yOffset"] = 5
	E.db["general"]["minimap"]["icons"]["difficulty"]["position"] = "TOPLEFT"
	E.db["general"]["minimap"]["icons"]["difficulty"]["xOffset"] = 13
	E.db["general"]["minimap"]["icons"]["difficulty"]["yOffset"] = -5
	E.db["general"]["minimap"]["icons"]["difficulty"]["scale"] = 0.9
	E.private["general"]["minimap"]["hideTracking"] = true
	E.db["general"]["minimap"]["resetZoom"]["enable"] = true
	E.db["general"]["minimap"]["resetZoom"]["time"] = 5
	E.db["general"]["minimap"]["size"] = 180
	E.db["general"]["minimap"]["locationFontSize"] = 10
	E.db["general"]["minimap"]["locationFontOutline"] = "SHADOWOUTLINE"
	E.db["general"]["minimap"]["locationFont"] = I.Fonts.Primary
	E.db["general"]["loginmessage"] = false
	E.db["general"]["bottomPanel"] = false
	E.db["general"]["topPanel"] = false
	E.db["general"]["bonusObjectivePosition"] = "AUTO"
	E.db["general"]["numberPrefixStyle"] = "ENGLISH"
	E.db["general"]["talkingHeadFrameScale"] = 0.85
	E.db["general"]["talkingHeadFrameBackdrop"] = true
	E.db["general"]["altPowerBar"]["enable"] = true
	E.db["general"]["altPowerBar"]["font"] = I.Fonts.Primary
	E.db["general"]["altPowerBar"]["fontSize"] = 11
	E.db["general"]["altPowerBar"]["fontOutline"] = "SHADOWOUTLINE"
	E.db["general"]["altPowerBar"]["statusBar"] = "ElvUI Norm1"
	E.db["general"]["altPowerBar"]["textFormat"] = "NAMECURMAXPERC"
	E.db["general"]["altPowerBar"]["statusBarColorGradient"] = true
	E.db["general"]["altPowerBar"]["smoothbars"] = true
	E.db["general"]["vehicleSeatIndicatorSize"] = 76
	E.db["general"]["displayCharacterInfo"] = true
	E.db["general"]["displayInspectInfo"] = true
	E.db["general"]["resurrectSound"] = true
	E.db["general"]["decimalLength"] = 2
	E.db["general"]["customGlow"]["useColor"] = true
	E.db["general"]["customGlow"]["color"] = { r = F.r, g = F.g, b = F.b }
	E.db["general"]["lootRoll"]["qualityItemLevel"] = true
	E.db["general"]["lootRoll"]["nameFont"] = I.Fonts.Primary
	E.db["general"]["lootRoll"]["nameFontSize"] = 12
	E.db["general"]["lootRoll"]["nameFontOutline"] = "SHADOWOUTLINE"
	E.db["general"]["addonCompartment"]["font"] = I.Fonts.Primary
	E.db["general"]["addonCompartment"]["fontSize"] = 13
	E.db["general"]["addonCompartment"]["fontOutline"] = "SHADOWOUTLINE"
	E.db["general"]["guildBank"]["countFont"] = I.Fonts.Primary
	E.db["general"]["guildBank"]["countFontSize"] = 9
	E.db["general"]["guildBank"]["countFontOutline"] = "SHADOWOUTLINE"
	E.db["general"]["guildBank"]["itemLevelFont"] = I.Fonts.Primary
	E.db["general"]["guildBank"]["itemLevelFontSize"] = 10
	E.db["general"]["guildBank"]["itemLevelFontOutline"] = "SHADOWOUTLINE"
	E.db["general"]["queueStatus"]["enable"] = true
	E.db["general"]["queueStatus"]["font"] = I.Fonts.Primary

	--[[----------------------------------
	--	ProfileDB - Auras
	--]]
	----------------------------------
	E.db["auras"]["fadeThreshold"] = 10
	E.db["auras"]["buffs"]["timeFont"] = I.Fonts.GothamRaid
	E.db["auras"]["buffs"]["timeFontSize"] = 11
	E.db["auras"]["buffs"]["timeFontOutline"] = "SHADOWOUTLINE"
	E.db["auras"]["buffs"]["timeYOffset"] = 34
	E.db["auras"]["buffs"]["timeXOffset"] = 0
	E.db["auras"]["buffs"]["horizontalSpacing"] = 4
	E.db["auras"]["buffs"]["verticalSpacing"] = 10
	if E:IsAddOnEnabled("ElvUI_RatioMinimapAuras") then
		E.db["auras"]["buffs"]["keepSizeRatio"] = false
		E.db["auras"]["buffs"]["height"] = 28
		E.db["auras"]["buffs"]["size"] = 36
		E.db["movers"]["BuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-189,-18"
	else
		E.db["auras"]["buffs"]["size"] = 32
		E.db["movers"]["BuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-189,-18"
	end
	E.db["auras"]["buffs"]["countFont"] = I.Fonts.GothamRaid
	E.db["auras"]["buffs"]["countFontSize"] = 11
	E.db["auras"]["buffs"]["countFontOutline"] = "SHADOWOUTLINE"
	E.db["auras"]["buffs"]["wrapAfter"] = 10
	E.db["auras"]["debuffs"]["horizontalSpacing"] = 4
	E.db["auras"]["debuffs"]["verticalSpacing"] = 10
	if E:IsAddOnEnabled("ElvUI_RatioMinimapAuras") then
		E.db["auras"]["debuffs"]["keepSizeRatio"] = false
		E.db["auras"]["debuffs"]["height"] = 30
		E.db["auras"]["debuffs"]["size"] = 34
		E.db["movers"]["DebuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-189,-184"
	else
		E.db["auras"]["debuffs"]["size"] = 34
		E.db["movers"]["DebuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-189,-184"
	end
	E.db["auras"]["debuffs"]["countFont"] = I.Fonts.GothamRaid
	E.db["auras"]["debuffs"]["countFontSize"] = 12
	E.db["auras"]["debuffs"]["countFontOutline"] = "SHADOWOUTLINE"
	E.db["auras"]["debuffs"]["timeFont"] = I.Fonts.GothamRaid
	E.db["auras"]["debuffs"]["timeFontSize"] = 12
	E.db["auras"]["debuffs"]["timeFontOutline"] = "SHADOWOUTLINE"
	E.db["auras"]["cooldown"]["override"] = true
	E.db["auras"]["cooldown"]["useIndicatorColor"] = true
	E.db["auras"]["cooldown"]["hoursIndicator"]["r"] = 0.4
	E.db["auras"]["cooldown"]["minutesIndicator"]["b"] = 0.9176470588235294
	E.db["auras"]["cooldown"]["minutesIndicator"]["g"] = 0.7764705882352941
	E.db["auras"]["cooldown"]["minutesIndicator"]["r"] = 0.2470588235294118
	E.db["auras"]["cooldown"]["secondsIndicator"]["b"] = 0
	E.db["auras"]["cooldown"]["expireIndicator"]["g"] = 0
	E.db["auras"]["cooldown"]["expireIndicator"]["b"] = 0
	E.db["auras"]["cooldown"]["daysIndicator"]["g"] = 0.4
	E.db["auras"]["cooldown"]["daysIndicator"]["r"] = 0.4
	E.db["auras"]["cooldown"]["hhmmColor"]["r"] = 0.431372549019608
	E.db["auras"]["cooldown"]["hhmmColor"]["g"] = 0.431372549019608
	E.db["auras"]["cooldown"]["hhmmColor"]["b"] = 0.431372549019608
	E.db["auras"]["cooldown"]["mmssColor"]["r"] = 0.56078431372549
	E.db["auras"]["cooldown"]["mmssColor"]["g"] = 0.56078431372549
	E.db["auras"]["cooldown"]["mmssColor"]["b"] = 0.56078431372549
	E.db["auras"]["cooldown"]["secondsColor"]["r"] = 1
	E.db["auras"]["cooldown"]["secondsColor"]["g"] = 1
	E.db["auras"]["cooldown"]["secondsColor"]["b"] = 1
	E.db["auras"]["cooldown"]["minutesColor"]["r"] = 1
	E.db["auras"]["cooldown"]["minutesColor"]["g"] = 1
	E.db["auras"]["cooldown"]["hoursColor"]["b"] = 1
	E.db["auras"]["cooldown"]["hoursColor"]["r"] = 1
	E.db["auras"]["cooldown"]["hoursColor"]["g"] = 1
	E.db["auras"]["cooldown"]["hoursColor"]["b"] = 1

	--[[----------------------------------
	--	ProfileDB - Bags
	--]]
	----------------------------------
	E.db["bags"]["itemLevelFont"] = I.Fonts.Primary
	E.db["bags"]["itemLevelFontSize"] = 9
	E.db["bags"]["itemLevelFontOutline"] = "SHADOWOUTLINE"
	E.db["bags"]["itemInfoFont"] = I.Fonts.Primary
	E.db["bags"]["itemInfoFontSize"] = 9
	E.db["bags"]["itemInfoFontOutline"] = "SHADOWOUTLINE"
	E.db["bags"]["countFont"] = I.Fonts.Primary
	E.db["bags"]["countFontSize"] = 10
	E.db["bags"]["countFontOutline"] = "SHADOWOUTLINE"
	E.db["bags"]["bagSize"] = 34
	E.db["bags"]["bagWidth"] = 433
	E.db["bags"]["bankSize"] = 34
	E.db["bags"]["bankWidth"] = 427
	E.db["bags"]["moneyFormat"] = "CONDENSED"
	E.db["bags"]["itemLevelThreshold"] = 1
	E.db["bags"]["junkIcon"] = true
	E.db["bags"]["junkDesaturate"] = true
	E.db["bags"]["strata"] = "HIGH"
	E.db["bags"]["showBindType"] = true
	E.db["bags"]["scrapIcon"] = true
	E.db["bags"]["itemLevelCustomColorEnable"] = false
	E.db["bags"]["transparent"] = true
	E.db["bags"]["vendorGrays"]["enable"] = true
	E.db["bags"]["vendorGrays"]["details"] = false
	E.db["bags"]["spinner"]["color"] = I.Strings.Branding.ColorRGB

	-- Cooldown Settings
	E.db["bags"]["cooldown"]["override"] = true
	E.db["bags"]["cooldown"]["fonts"] = {
		["enable"] = true,
		["font"] = I.Fonts.Primary,
		["fontSize"] = 20,
	}
	E.db["bags"]["cooldown"]["hhmmColor"]["r"] = 0.431372549019608
	E.db["bags"]["cooldown"]["hhmmColor"]["g"] = 0.431372549019608
	E.db["bags"]["cooldown"]["hhmmColor"]["b"] = 0.431372549019608
	E.db["bags"]["cooldown"]["mmssColor"]["r"] = 0.56078431372549
	E.db["bags"]["cooldown"]["mmssColor"]["g"] = 0.56078431372549
	E.db["bags"]["cooldown"]["mmssColor"]["b"] = 0.56078431372549
	E.db["bags"]["cooldown"]["secondsColor"]["b"] = 0
	E.db["bags"]["cooldown"]["daysColor"]["r"] = 0.4
	E.db["bags"]["cooldown"]["daysColor"]["g"] = 0.4
	E.db["bags"]["cooldown"]["hoursColor"]["r"] = 0.4

	E.db["movers"]["ElvUIBagMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,194"
	E.db["movers"]["ElvUIBankMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,194"

	--[[----------------------------------
	--	ProfileDB - Tooltip
	--]]
	----------------------------------
	E.db["tooltip"]["itemCount"] = "NONE"
	E.db["tooltip"]["healthBar"]["height"] = 5
	E.db["tooltip"]["healthBar"]["fontOutline"] = "SHADOWOUTLINE"
	E.db["tooltip"]["visibility"]["combat"] = false
	E.db["tooltip"]["healthBar"]["font"] = I.Fonts.Primary
	E.db["tooltip"]["font"] = I.Fonts.Primary
	E.db["tooltip"]["fontOutline"] = "SHADOWOUTLINE"
	E.db["tooltip"]["headerFont"] = I.Fonts.Primary
	E.db["tooltip"]["headerFontOutline"] = "SHADOWOUTLINE"
	E.db["tooltip"]["headerFontSize"] = 12
	E.db["tooltip"]["textFontSize"] = 11
	E.db["tooltip"]["smallTextFontSize"] = 11
	E.db["tooltip"]["healthBar"]["font"] = I.Fonts.Primary
	E.db["tooltip"]["healthBar"]["fontOutline"] = "SHADOWOUTLINE"
	E.db["movers"]["TooltipMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-10,280"

	--[[----------------------------------
	--	Skins - Layout
	--]]
	----------------------------------
	E.private["skins"]["parchmentRemoverEnable"] = true

	if E:IsAddOnEnabled("ls_Toasts") then
		E.private["skins"]["blizzard"]["alertframes"] = false
	else
		E.private["skins"]["blizzard"]["alertframes"] = true
	end

	--[[----------------------------------
	--	ItemLevel - Layout
	--]]
	----------------------------------
	E.db["general"]["itemLevel"]["itemLevelFont"] = I.Fonts.Primary
	E.db["general"]["itemLevel"]["itemLevelFontSize"] = 12
	E.db["general"]["itemLevel"]["itemLevelFontOutline"] = "SHADOWOUTLINE"
	E.db["general"]["itemLevel"]["totalLevelFont"] = I.Fonts.Primary
	E.db["general"]["itemLevel"]["totalLevelFontSize"] = 13
	E.db["general"]["itemLevel"]["totalLevelFontOutline"] = "SHADOWOUTLINE"

	--[[----------------------------------
	--	ProfileDB - MER
	--]]
	----------------------------------
	E.private["mui"]["skins"]["embed"]["enable"] = true

	E.db["movers"]["MER_SpecializationBarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-2,14"
	E.db["movers"]["MER_EquipmentSetsBarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-75,14"
	E.db["movers"]["MER_MicroBarMover"] = "TOP,ElvUIParent,TOP,0,-19"
	E.db["movers"]["MER_OrderhallMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,2-2"
	E.db["movers"]["MER_RaidBuffReminderMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,2,-12"
	E.db["movers"]["MER_RaidManager"] = "TOPLEFT,ElvUIParent,TOPLEFT,268,-15"
	E.db["movers"]["MER_MinimapButtonsToggleButtonMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,0,184"
	E.db["movers"]["MER_NotificationMover"] = "TOP,ElvUIParent,TOP,0,-70"
	E.db["movers"]["MER_MinimapButtonBarAnchor"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-5,-222"

	--[[----------------------------------
	--	Movers - Layout
	--]]
	----------------------------------
	E.db["movers"]["AltPowerBarMover"] = "TOP,ElvUIParent,TOP,0,-201"
	E.db["movers"]["GMMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,229,-20"
	E.db["movers"]["BNETMover"] = "TOP,ElvUIParent,TOP,0,-70"
	E.db["movers"]["LootFrameMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-495,-457"
	E.db["movers"]["AlertFrameMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,205,-210"
	E.db["movers"]["VOICECHAT"] = "TOPLEFT,ElvUIParent,TOPLEFT,368,-210"
	E.db["movers"]["LossControlMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,465"
	E.db["movers"]["VehicleSeatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-474,120"
	E.db["movers"]["ProfessionsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-3,-184"
	E.db["movers"]["TotemTrackerMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,457,13"
	E.db["movers"]["TotemBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-297,45"
	E.db["movers"]["AddonCompartmentMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-213,-17"

	-- UIWidgets
	E.db["movers"]["TopCenterContainerMover"] = "TOP,ElvUIParent,TOP,0,-105"
	E.db["movers"]["BelowMinimapContainerMover"] = "TOP,ElvUIParent,TOP,0,-148"

	E.db["databars"]["customTexture"] = true
	E.db["databars"]["statusbar"] = "ElvUI Norm1"

	E.db["databars"]["experience"]["enable"] = true
	E.db["databars"]["experience"]["mouseover"] = false
	E.db["databars"]["experience"]["height"] = 9
	E.db["databars"]["experience"]["fontSize"] = 9
	E.db["databars"]["experience"]["font"] = I.Fonts.Primary
	E.db["databars"]["experience"]["width"] = 283
	E.db["databars"]["experience"]["textFormat"] = "CURPERCREM"
	E.db["databars"]["experience"]["orientation"] = "HORIZONTAL"
	E.db["databars"]["experience"]["hideAtMaxLevel"] = true
	E.db["databars"]["experience"]["hideInCombat"] = true
	E.db["databars"]["experience"]["showBubbles"] = true
	E.db["databars"]["experience"]["hideInVehicle"] = true

	E.db["databars"]["reputation"]["enable"] = true
	E.db["databars"]["reputation"]["mouseover"] = false
	E.db["databars"]["reputation"]["font"] = I.Fonts.Primary
	E.db["databars"]["reputation"]["fontSize"] = 9
	E.db["databars"]["reputation"]["height"] = 9
	E.db["databars"]["reputation"]["width"] = 283
	E.db["databars"]["reputation"]["textFormat"] = "CURPERCREM"
	E.db["databars"]["reputation"]["orientation"] = "HORIZONTAL"
	E.db["databars"]["reputation"]["hideInCombat"] = true
	E.db["databars"]["reputation"]["showBubbles"] = true
	E.db["databars"]["reputation"]["hideInVehicle"] = true

	E.db["databars"]["threat"]["enable"] = true
	E.db["databars"]["threat"]["width"] = 283
	E.db["databars"]["threat"]["height"] = 12
	E.db["databars"]["threat"]["fontSize"] = 9
	E.db["databars"]["threat"]["font"] = I.Fonts.Primary

	E.db["databars"]["honor"]["enable"] = true
	E.db["databars"]["honor"]["width"] = 283
	E.db["databars"]["honor"]["height"] = 9
	E.db["databars"]["honor"]["fontSize"] = 9
	E.db["databars"]["honor"]["font"] = I.Fonts.Primary
	E.db["databars"]["honor"]["hideBelowMaxLevel"] = true
	E.db["databars"]["honor"]["hideOutsidePvP"] = true
	E.db["databars"]["honor"]["hideInCombat"] = true
	E.db["databars"]["honor"]["hideInVehicle"] = true
	E.db["databars"]["honor"]["textFormat"] = "CURPERCREM"
	E.db["databars"]["honor"]["orientation"] = "HORIZONTAL"
	E.db["databars"]["honor"]["showBubbles"] = true

	E.db["databars"]["azerite"]["enable"] = true
	E.db["databars"]["azerite"]["height"] = 9
	E.db["databars"]["azerite"]["font"] = I.Fonts.Primary
	E.db["databars"]["azerite"]["fontSize"] = 9
	E.db["databars"]["azerite"]["width"] = 283
	E.db["databars"]["azerite"]["hideInVehicle"] = true
	E.db["databars"]["azerite"]["hideInCombat"] = true
	E.db["databars"]["azerite"]["mouseover"] = false
	E.db["databars"]["azerite"]["orientation"] = "HORIZONTAL"
	E.db["databars"]["azerite"]["textFormat"] = "CURPERCREM"
	E.db["databars"]["azerite"]["showBubbles"] = true

	E.db["movers"]["HonorBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,52"
	E.db["movers"]["AzeriteBarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-470,1"

	E.db["movers"]["ExperienceBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,1"
	E.db["movers"]["ReputationBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,470,1"
	E.db["movers"]["ThreatBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,62"
	E.db["movers"]["MinimapMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-17"
	E.db["movers"]["MinimapClusterMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-2,-16"
	E.db["movers"]["mUI_RaidMarkerBarAnchor"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,300,15"

	E:StaggeredUpdateAll(nil, true)

	PluginInstallStepComplete.message = MER.Title .. L["Layout Set"]
	PluginInstallStepComplete:Show()
end

function MER:SetupActionbars()
	if not E.db.movers then
		E.db.movers = {}
	end

	--[[----------------------------------
	--	ActionBars - General
	--]]
	----------------------------------
	E.db["actionbar"]["fontOutline"] = "SHADOWOUTLINE"
	E.db["actionbar"]["fontSize"] = 10
	E.db["actionbar"]["macrotext"] = true
	E.db["actionbar"]["showGrid"] = false
	E.db["actionbar"]["lockActionBars"] = true
	E.db["actionbar"]["transparent"] = true
	E.db["actionbar"]["globalFadeAlpha"] = 0.75
	E.db["actionbar"]["hideCooldownBling"] = false
	E.db["actionbar"]["equippedItem"] = true

	-- Cooldown options
	E.db["actionbar"]["cooldown"]["fonts"]["enable"] = true
	E.db["actionbar"]["cooldown"]["fonts"]["font"] = I.Fonts.Primary
	E.db["actionbar"]["cooldown"]["fonts"]["fontOutline"] = "SHADOWOUTLINE"
	E.db["actionbar"]["cooldown"]["fonts"]["fontSize"] = 20

	E.db["actionbar"]["microbar"]["enabled"] = false

	--[[----------------------------------
	--	ActionBars layout
	--]]
	----------------------------------
	E.db["actionbar"]["font"] = I.Fonts.Primary
	E.db["actionbar"]["desaturateOnCooldown"] = true

	-- Cooldowns
	E.db["actionbar"]["cooldown"]["override"] = true
	E.db["actionbar"]["cooldown"]["hhmmColor"]["r"] = 0.431372549019608
	E.db["actionbar"]["cooldown"]["hhmmColor"]["g"] = 0.431372549019608
	E.db["actionbar"]["cooldown"]["hhmmColor"]["b"] = 0.431372549019608
	E.db["actionbar"]["cooldown"]["mmssColor"]["r"] = 0.56078431372549
	E.db["actionbar"]["cooldown"]["mmssColor"]["g"] = 0.56078431372549
	E.db["actionbar"]["cooldown"]["mmssColor"]["b"] = 0.56078431372549
	E.db["actionbar"]["cooldown"]["secondsColor"]["b"] = 0
	E.db["actionbar"]["cooldown"]["daysColor"]["r"] = 0.4
	E.db["actionbar"]["cooldown"]["daysColor"]["g"] = 0.4
	E.db["actionbar"]["cooldown"]["fonts"]["enable"] = true
	E.db["actionbar"]["cooldown"]["fonts"]["font"] = I.Fonts.Primary
	E.db["actionbar"]["cooldown"]["fonts"]["fontSize"] = 20
	E.db["actionbar"]["cooldown"]["hoursColor"]["r"] = 0.4

	E.db["actionbar"]["bar1"]["buttonSpacing"] = 2
	E.db["actionbar"]["bar1"]["heightMult"] = 3
	E.db["actionbar"]["bar1"]["buttons"] = 8
	E.db["actionbar"]["bar1"]["backdropSpacing"] = 3
	E.db["actionbar"]["bar1"]["backdrop"] = true
	E.db["actionbar"]["bar1"]["inheritGlobalFade"] = false
	E.db["actionbar"]["bar1"]["counttext"] = true
	E.db["actionbar"]["bar1"]["countFont"] = I.Fonts.Primary
	E.db["actionbar"]["bar1"]["countFontOutline"] = "SHADOWOUTLINE"
	E.db["actionbar"]["bar1"]["hotkeytext"] = true
	E.db["actionbar"]["bar1"]["hotkeyFont"] = I.Fonts.Primary
	E.db["actionbar"]["bar1"]["hotkeyFontOutline"] = "SHADOWOUTLINE"
	E.db["actionbar"]["bar1"]["macrotext"] = true
	E.db["actionbar"]["bar1"]["macroFont"] = I.Fonts.Primary
	E.db["actionbar"]["bar1"]["macroFontOutline"] = "SHADOWOUTLINE"
	E.db["actionbar"]["bar1"]["macroTextPosition"] = "BOTTOM"
	E.db["actionbar"]["bar1"]["macroTextYOffset"] = 0
	E.db["actionbar"]["bar1"]["keepSizeRatio"] = false
	E.db["actionbar"]["bar1"]["buttonHeight"] = 26
	E.db["actionbar"]["bar1"]["buttonSize"] = 32
	E.db["actionbar"]["bar1"]["buttonSpacing"] = 3

	E.db["actionbar"]["bar2"]["enabled"] = true
	E.db["actionbar"]["bar2"]["buttons"] = 8
	E.db["actionbar"]["bar2"]["visibility"] = "[vehicleui][overridebar][petbattle][possessbar] hide; show"
	E.db["actionbar"]["bar2"]["mouseover"] = false
	E.db["actionbar"]["bar2"]["backdropSpacing"] = 1
	E.db["actionbar"]["bar2"]["showGrid"] = true
	E.db["actionbar"]["bar2"]["heightMult"] = 1
	E.db["actionbar"]["bar2"]["buttonsPerRow"] = 12
	E.db["actionbar"]["bar2"]["backdrop"] = false
	E.db["actionbar"]["bar2"]["inheritGlobalFade"] = false
	E.db["actionbar"]["bar2"]["counttext"] = true
	E.db["actionbar"]["bar2"]["countFont"] = I.Fonts.Primary
	E.db["actionbar"]["bar2"]["countFontOutline"] = "SHADOWOUTLINE"
	E.db["actionbar"]["bar2"]["hotkeytext"] = true
	E.db["actionbar"]["bar2"]["hotkeyFont"] = I.Fonts.Primary
	E.db["actionbar"]["bar2"]["hotkeyFontOutline"] = "SHADOWOUTLINE"
	E.db["actionbar"]["bar2"]["macrotext"] = true
	E.db["actionbar"]["bar2"]["macroFont"] = I.Fonts.Primary
	E.db["actionbar"]["bar2"]["macroFontOutline"] = "SHADOWOUTLINE"
	E.db["actionbar"]["bar2"]["macroTextPosition"] = "BOTTOM"
	E.db["actionbar"]["bar2"]["macroTextYOffset"] = 0
	E.db["actionbar"]["bar2"]["keepSizeRatio"] = false
	E.db["actionbar"]["bar2"]["buttonHeight"] = 26
	E.db["actionbar"]["bar2"]["buttonSize"] = 32
	E.db["actionbar"]["bar2"]["buttonSpacing"] = 3

	E.db["actionbar"]["bar3"]["enabled"] = true
	E.db["actionbar"]["bar3"]["backdrop"] = false
	E.db["actionbar"]["bar3"]["buttonsPerRow"] = 12
	E.db["actionbar"]["bar3"]["buttonSize"] = 32
	E.db["actionbar"]["bar3"]["keepSizeRatio"] = false
	E.db["actionbar"]["bar3"]["buttonHeight"] = 26
	E.db["actionbar"]["bar3"]["buttonSpacing"] = 3
	E.db["actionbar"]["bar3"]["buttons"] = 8
	E.db["actionbar"]["bar3"]["point"] = "BOTTOMLEFT"
	E.db["actionbar"]["bar3"]["backdropSpacing"] = 2
	E.db["actionbar"]["bar3"]["mouseover"] = false
	E.db["actionbar"]["bar3"]["showGrid"] = true
	E.db["actionbar"]["bar3"]["inheritGlobalFade"] = false
	E.db["actionbar"]["bar3"]["counttext"] = true
	E.db["actionbar"]["bar3"]["countFont"] = I.Fonts.Primary
	E.db["actionbar"]["bar3"]["countFontOutline"] = "SHADOWOUTLINE"
	E.db["actionbar"]["bar3"]["hotkeytext"] = true
	E.db["actionbar"]["bar3"]["hotkeyFont"] = I.Fonts.Primary
	E.db["actionbar"]["bar3"]["hotkeyFontOutline"] = "SHADOWOUTLINE"
	E.db["actionbar"]["bar3"]["macrotext"] = true
	E.db["actionbar"]["bar3"]["macroFont"] = I.Fonts.Primary
	E.db["actionbar"]["bar3"]["macroFontOutline"] = "SHADOWOUTLINE"
	E.db["actionbar"]["bar3"]["macroTextPosition"] = "BOTTOM"
	E.db["actionbar"]["bar3"]["macroTextYOffset"] = 0

	E.db["actionbar"]["bar4"]["enabled"] = true
	E.db["actionbar"]["bar4"]["buttonSpacing"] = 4
	E.db["actionbar"]["bar4"]["mouseover"] = true
	E.db["actionbar"]["bar4"]["backdrop"] = true
	E.db["actionbar"]["bar4"]["buttonSize"] = 24
	E.db["actionbar"]["bar4"]["backdropSpacing"] = 2
	E.db["actionbar"]["bar4"]["showGrid"] = true
	E.db["actionbar"]["bar4"]["buttonsPerRow"] = 1
	E.db["actionbar"]["bar4"]["inheritGlobalFade"] = false
	E.db["actionbar"]["bar4"]["counttext"] = true
	E.db["actionbar"]["bar4"]["countFont"] = I.Fonts.Primary
	E.db["actionbar"]["bar4"]["countFontOutline"] = "SHADOWOUTLINE"
	E.db["actionbar"]["bar4"]["hotkeytext"] = true
	E.db["actionbar"]["bar4"]["hotkeyFont"] = I.Fonts.Primary
	E.db["actionbar"]["bar4"]["hotkeyFontOutline"] = "SHADOWOUTLINE"
	E.db["actionbar"]["bar4"]["macrotext"] = true
	E.db["actionbar"]["bar4"]["macroFont"] = I.Fonts.Primary
	E.db["actionbar"]["bar4"]["macroFontOutline"] = "SHADOWOUTLINE"
	E.db["actionbar"]["bar4"]["macroTextPosition"] = "BOTTOM"
	E.db["actionbar"]["bar4"]["macroTextYOffset"] = 0

	E.db["actionbar"]["bar5"]["enabled"] = false

	E.db["actionbar"]["bar6"]["enabled"] = true
	E.db["actionbar"]["bar6"]["backdropSpacing"] = 3
	E.db["actionbar"]["bar6"]["buttons"] = 8
	E.db["actionbar"]["bar6"]["visibility"] = "[vehicleui][overridebar][petbattle][possessbar] hide; show"
	E.db["actionbar"]["bar6"]["showGrid"] = true
	E.db["actionbar"]["bar6"]["mouseover"] = false
	E.db["actionbar"]["bar6"]["buttonsPerRow"] = 8
	E.db["actionbar"]["bar6"]["heightMult"] = 1
	E.db["actionbar"]["bar6"]["backdrop"] = true
	E.db["actionbar"]["bar6"]["inheritGlobalFade"] = false
	E.db["actionbar"]["bar6"]["counttext"] = true
	E.db["actionbar"]["bar6"]["countFont"] = I.Fonts.Primary
	E.db["actionbar"]["bar6"]["countFontOutline"] = "SHADOWOUTLINE"
	E.db["actionbar"]["bar6"]["hotkeytext"] = true
	E.db["actionbar"]["bar6"]["hotkeyFont"] = I.Fonts.Primary
	E.db["actionbar"]["bar6"]["hotkeyFontOutline"] = "SHADOWOUTLINE"
	E.db["actionbar"]["bar6"]["macrotext"] = true
	E.db["actionbar"]["bar6"]["macroFont"] = I.Fonts.Primary
	E.db["actionbar"]["bar6"]["macroFontOutline"] = "SHADOWOUTLINE"
	E.db["actionbar"]["bar6"]["macroTextPosition"] = "BOTTOM"
	E.db["actionbar"]["bar6"]["macroTextYOffset"] = 0
	E.db["actionbar"]["bar6"]["keepSizeRatio"] = false
	E.db["actionbar"]["bar6"]["buttonHeight"] = 26
	E.db["actionbar"]["bar6"]["buttonSize"] = 32
	E.db["actionbar"]["bar6"]["buttonSpacing"] = 3

	E.db["actionbar"]["bar7"]["enabled"] = false

	E.db["actionbar"]["barPet"]["point"] = "BOTTOMLEFT"
	E.db["actionbar"]["barPet"]["backdrop"] = true
	E.db["actionbar"]["barPet"]["buttons"] = 9
	E.db["actionbar"]["barPet"]["buttonSpacing"] = 3
	E.db["actionbar"]["barPet"]["buttonsPerRow"] = 9
	E.db["actionbar"]["barPet"]["buttonSize"] = 24
	E.db["actionbar"]["barPet"]["mouseover"] = false
	E.db["actionbar"]["barPet"]["inheritGlobalFade"] = false
	E.db["actionbar"]["barPet"]["hotkeyFont"] = I.Fonts.Primary
	E.db["actionbar"]["barPet"]["hotkeyFontOutline"] = "SHADOWOUTLINE"

	E.db["actionbar"]["stanceBar"]["point"] = "BOTTOMLEFT"
	E.db["actionbar"]["stanceBar"]["backdrop"] = true
	E.db["actionbar"]["stanceBar"]["buttonSpacing"] = 3
	E.db["actionbar"]["stanceBar"]["buttonsPerRow"] = 6
	E.db["actionbar"]["stanceBar"]["buttonSize"] = 22
	E.db["actionbar"]["stanceBar"]["inheritGlobalFade"] = false
	E.db["actionbar"]["stanceBar"]["hotkeyFont"] = I.Fonts.Primary
	E.db["actionbar"]["stanceBar"]["hotkeyFontOutline"] = "SHADOWOUTLINE"

	E.db["actionbar"]["zoneActionButton"]["clean"] = true
	E.db["actionbar"]["zoneActionButton"]["scale"] = 0.75
	E.db["actionbar"]["zoneActionButton"]["inheritGlobalFade"] = false

	E.db["actionbar"]["extraActionButton"]["clean"] = true
	E.db["actionbar"]["extraActionButton"]["scale"] = 0.75
	E.db["actionbar"]["extraActionButton"]["inheritGlobalFade"] = false
	E.db["actionbar"]["extraActionButton"]["hotkeytext"] = true
	E.db["actionbar"]["extraActionButton"]["hotkeyFont"] = I.Fonts.Primary
	E.db["actionbar"]["extraActionButton"]["hotkeyFontOutline"] = "SHADOWOUTLINE"

	E.db["movers"]["ElvAB_1"] = "BOTTOM,UIParent,BOTTOM,0,115"
	E.db["movers"]["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,0,146"
	E.db["movers"]["ElvAB_3"] = "BOTTOM,ElvUIParent,BOTTOM,0,175"
	E.db["movers"]["ElvAB_4"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,0,367"
	E.db["movers"]["ElvAB_5"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,430,47"
	E.db["movers"]["ElvAB_6"] = "BOTTOM,ElvUIParent,BOTTOM,0,13"
	E.db["movers"]["ElvAB_7"] = "BOTTOM,ElvUIParent,BOTTOM,0,177"
	E.db["movers"]["ShiftAB"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,10,14"
	E.db["movers"]["PetAB"] = "BOTTOM,ElvUIParent,BOTTOM,-289,15"
	E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,305,50"
	E.db["movers"]["ZoneAbility"] = "BOTTOM,UIParent,BOTTOM,305,92"
	E.db["movers"]["MicrobarMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-4"
	E.db["movers"]["VehicleLeaveButton"] = "BOTTOM,ElvUIParent,BOTTOM,304,140"
	E.db["movers"]["AutoButtonBar1Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-28,216"
	E.db["movers"]["AutoButtonBar2Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-28,247"
	E.db["movers"]["AutoButtonBar3Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-28,279"

	E:StaggeredUpdateAll(nil, true)

	PluginInstallStepComplete.message = MER.Title .. L["ActionBars Set"]
	PluginInstallStepComplete:Show()
end

function MER:SetupNamePlates()
	--[[----------------------------------
	--	ProfileDB - NamePlate
	--]]
	----------------------------------

	-- General
	E.db["nameplates"]["threat"]["enable"] = false
	E.db["nameplates"]["threat"]["useThreatColor"] = false
	E.db["nameplates"]["clampToScreen"] = true
	E.db["nameplates"]["colors"]["glowColor"] = { r = 0, g = 191 / 255, b = 250 / 255, a = 1 }
	E.db["nameplates"]["font"] = I.Fonts.Primary
	E.db["nameplates"]["fontSize"] = 12
	E.db["nameplates"]["stackFont"] = I.Fonts.Primary
	E.db["nameplates"]["stackFontSize"] = 9
	E.db["nameplates"]["smoothbars"] = true
	E.db["nameplates"]["statusbar"] = "ElvUI Norm1"
	E.db["nameplates"]["cutaway"]["health"]["enabled"] = true

	-- Cooldowns
	E.db["nameplates"]["cooldown"]["override"] = true
	E.db["nameplates"]["cooldown"]["hhmmColor"]["r"] = 0.431372549019608
	E.db["nameplates"]["cooldown"]["hhmmColor"]["g"] = 0.431372549019608
	E.db["nameplates"]["cooldown"]["hhmmColor"]["b"] = 0.431372549019608
	E.db["nameplates"]["cooldown"]["mmssColor"]["r"] = 0.56078431372549
	E.db["nameplates"]["cooldown"]["mmssColor"]["g"] = 0.56078431372549
	E.db["nameplates"]["cooldown"]["mmssColor"]["b"] = 0.56078431372549
	E.db["nameplates"]["cooldown"]["secondsColor"]["b"] = 0
	E.db["nameplates"]["cooldown"]["fonts"]["enable"] = true
	E.db["nameplates"]["cooldown"]["fonts"]["font"] = I.Fonts.Primary
	E.db["nameplates"]["cooldown"]["daysColor"]["g"] = 0.4
	E.db["nameplates"]["cooldown"]["daysColor"]["r"] = 0.4
	E.db["nameplates"]["cooldown"]["hoursColor"]["r"] = 0.4

	-- Player
	E.db["nameplates"]["units"]["PLAYER"]["enable"] = false
	E.db["nameplates"]["units"]["PLAYER"]["health"]["text"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["PLAYER"]["health"]["text"]["fontSize"] = 9
	E.db["nameplates"]["units"]["PLAYER"]["health"]["text"]["format"] = "[perhp<%]"
	E.db["nameplates"]["units"]["PLAYER"]["name"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["PLAYER"]["name"]["fontSize"] = 10
	E.db["nameplates"]["units"]["PLAYER"]["name"]["format"] = "[name:abbrev:long]"
	E.db["nameplates"]["units"]["PLAYER"]["power"]["text"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["PLAYER"]["power"]["text"]["fontSize"] = 9
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["yOffset"] = 2
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["fontSize"] = 10
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["countFont"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["countFontOutline"] = "OUTLINE"
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["countFontSize"] = 8
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["durationPosition"] = "CENTER"
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["fontSize"] = 10
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["countFont"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["countFontOutline"] = "OUTLINE"
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["countFontSize"] = 8
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["durationPosition"] = "CENTER"
	E.db["nameplates"]["units"]["PLAYER"]["level"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["PLAYER"]["level"]["fontSize"] = 10
	E.db["nameplates"]["units"]["PLAYER"]["castbar"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["PLAYER"]["castbar"]["fontSize"] = 9
	E.db["nameplates"]["units"]["PLAYER"]["castbar"]["sourceInterrupt"] = true
	E.db["nameplates"]["units"]["PLAYER"]["castbar"]["sourceInterruptClassColor"] = true
	E.db["nameplates"]["units"]["PLAYER"]["castbar"]["iconPosition"] = "LEFT"

	-- Friendly Player
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["text"]["enable"] = true
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["text"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["text"]["fontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["text"]["format"] = "[perhp<%]"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["enable"] = true
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["format"] = "[name:abbrev:long]"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["yOffset"] = -9
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["power"]["enable"] = false
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["power"]["text"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["power"]["text"]["fontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["yOffset"] = 13
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["countFont"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["countFontOutline"] = "OUTLINE"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["countFontSize"] = 8
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["durationPosition"] = "CENTER"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["countFont"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["countFontOutline"] = "OUTLINE"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["countFontSize"] = 8
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["durationPosition"] = "CENTER"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["level"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["level"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["level"]["yOffset"] = -9
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["fontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["sourceInterrupt"] = true
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["sourceInterruptClassColor"] = true
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["iconPosition"] = "LEFT"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["iconSize"] = 21
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["iconOffsetX"] = -2
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["iconOffsetY"] = -1
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["title"]["enable"] = false
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["title"]["font"] = I.Fonts.Primary
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["title"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["title"]["fontOutline"] = "SHADOWOUTLINE"

	-- Enemy Player
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["enable"] = true
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["fontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["format"] = "[perhp<%]"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["healPrediction"] = true
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["enable"] = true
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["format"] = "[name:abbrev:long]"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["yOffset"] = -9
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["enable"] = false
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["text"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["text"]["fontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["yOffset"] = 2
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["font"] = I.Fonts.Primary
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["countFont"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["countFontOutline"] = "OUTLINE"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["countFontSize"] = 8
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["durationPosition"] = "CENTER"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["countFont"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["countFontOutline"] = "OUTLINE"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["countFontSize"] = 8
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["durationPosition"] = "CENTER"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["level"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["level"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["fontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["sourceInterrupt"] = true
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["sourceInterruptClassColor"] = true
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["iconPosition"] = "LEFT"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["iconSize"] = 21
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["iconOffsetX"] = -2
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["iconOffsetY"] = -1
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["title"]["enable"] = false
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["title"]["font"] = I.Fonts.Primary
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["title"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["title"]["fontOutline"] = "SHADOWOUTLINE"

	-- Friendly NPC
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["health"]["text"]["enable"] = true
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["health"]["text"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["health"]["text"]["fontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["health"]["text"]["format"] = "[perhp<%]"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["enable"] = true
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["format"] = "[name:abbrev:long]"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["yOffset"] = -9
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["power"]["enable"] = false
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["power"]["text"]["font"] = I.Fonts.Primary
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["power"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["yOffset"] = 13
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["font"] = I.Fonts.Primary
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["countFont"] = I.Fonts.Primary
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["countFontOutline"] = "OUTLINE"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["durationPosition"] = "CENTER"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["font"] = I.Fonts.Primary
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["countFont"] = I.Fonts.Primary
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["countFontOutline"] = "OUTLINE"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["durationPosition"] = "CENTER"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["yOffset"] = -9
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["format"] = "[difficultycolor][level]"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["fontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["sourceInterrupt"] = true
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["sourceInterruptClassColor"] = true
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["yOffset"] = -10
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["iconPosition"] = "LEFT"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["iconSize"] = 21
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["iconOffsetX"] = -2
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["iconOffsetY"] = -1
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["timeToHold"] = 0.8
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["questIcon"]["enable"] = true
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["questIcon"]["position"] = "BOTTOMRIGHT"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["questIcon"]["xOffset"] = 20
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["questIcon"]["yOffset"] = 25
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["questIcon"]["spacing"] = 5
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["questIcon"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["questIcon"]["fontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["questIcon"]["textXOffset"] = -5
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["questIcon"]["textYOffset"] = 0
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["title"]["enable"] = false
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["title"]["font"] = I.Fonts.Primary
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["title"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["title"]["fontOutline"] = "SHADOWOUTLINE"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["eliteIcon"]["enable"] = true
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["eliteIcon"]["position"] = "RIGHT"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["eliteIcon"]["xOffset"] = 1
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["eliteIcon"]["yOffset"] = 0

	-- Enemy NPC
	E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["enable"] = true
	E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["fontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["format"] = "[perhp<%]"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["healPrediction"] = true
	E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["enable"] = true
	E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["format"] = "[namecolor][name:abbrev:long]"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["yOffset"] = -9
	E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["enable"] = false
	E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["text"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["text"]["fontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["yOffset"] = 13
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["font"] = I.Fonts.Primary
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["countFont"] = I.Fonts.Primary
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["countFontOutline"] = "OUTLINE"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["durationPosition"] = "CENTER"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["priority"] =
		"Blacklist,RaidBuffsElvUI,PlayerBuffs,TurtleBuffs,CastByUnit"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["size"] = 26
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["spacing"] = 2
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["yOffset"] = 33
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["countFont"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["countFontOutline"] = "OUTLINE"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["countFontSize"] = 8
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["durationPosition"] = "CENTER"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["keepSizeRatio"] = false
	E.db["nameplates"]["units"]["ENEMY_NPC"]["level"]["enable"] = true
	E.db["nameplates"]["units"]["ENEMY_NPC"]["level"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["ENEMY_NPC"]["level"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_NPC"]["level"]["format"] = "[difficultycolor][level]"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["level"]["yOffset"] = -9
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["fontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["sourceInterrupt"] = true
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["sourceInterruptClassColor"] = true
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["iconPosition"] = "LEFT"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["iconSize"] = 21
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["iconOffsetX"] = -2
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["iconOffsetY"] = -1
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["timeToHold"] = 0.8
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["yOffset"] = -10
	E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["enable"] = true
	E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["position"] = "RIGHT"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["xOffset"] = 1
	E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["yOffset"] = 0
	E.db["nameplates"]["units"]["ENEMY_NPC"]["questIcon"]["enable"] = true
	E.db["nameplates"]["units"]["ENEMY_NPC"]["questIcon"]["position"] = "BOTTOMRIGHT"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["questIcon"]["xOffset"] = 20
	E.db["nameplates"]["units"]["ENEMY_NPC"]["questIcon"]["yOffset"] = 25
	E.db["nameplates"]["units"]["ENEMY_NPC"]["questIcon"]["spacing"] = 5
	E.db["nameplates"]["units"]["ENEMY_NPC"]["questIcon"]["font"] = I.Fonts.GothamRaid
	E.db["nameplates"]["units"]["ENEMY_NPC"]["questIcon"]["fontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_NPC"]["questIcon"]["textXOffset"] = -5
	E.db["nameplates"]["units"]["ENEMY_NPC"]["questIcon"]["textYOffset"] = 0
	E.db["nameplates"]["units"]["ENEMY_NPC"]["title"]["enable"] = false
	E.db["nameplates"]["units"]["ENEMY_NPC"]["title"]["font"] = I.Fonts.Primary
	E.db["nameplates"]["units"]["ENEMY_NPC"]["title"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_NPC"]["title"]["fontOutline"] = "SHADOWOUTLINE"

	-- TARGETED
	E.db["nameplates"]["units"]["TARGET"]["scale"] = 1.06 -- 106% scale
	E.db["nameplates"]["units"]["TARGET"]["glowStyle"] = "style8"
	E.db["nameplates"]["units"]["TARGET"]["arrow"] = "ArrowRed"
	E.db["nameplates"]["units"]["TARGET"]["classpower"]["enable"] = true
	E.db["nameplates"]["units"]["TARGET"]["classpower"]["width"] = 144
	E.db["nameplates"]["units"]["TARGET"]["classpower"]["yOffset"] = 23

	--[[----------------------------------
	--	ProfileDB - Style Filter
	--]]
	----------------------------------
	for _, filterName in pairs({ "MerathilisUI_Neutral" }) do
		E.global["nameplates"]["filters"][filterName] = {}
		E.NamePlates:StyleFilterCopyDefaults(E.global["nameplates"]["filters"][filterName])
		E.db["nameplates"]["filters"][filterName] = { triggers = { enable = true } }
	end

	E.global["nameplates"]["filters"]["MerathilisUI_Neutral"]["actions"]["nameOnly"] = true
	E.global["nameplates"]["filters"]["MerathilisUI_Neutral"]["triggers"]["notTarget"] = true
	E.global["nameplates"]["filters"]["MerathilisUI_Neutral"]["triggers"]["outOfCombat"] = true
	E.global["nameplates"]["filters"]["MerathilisUI_Neutral"]["triggers"]["outOfVehicle"] = true
	E.global["nameplates"]["filters"]["MerathilisUI_Neutral"]["triggers"]["reactionType"]["enable"] = true
	E.global["nameplates"]["filters"]["MerathilisUI_Neutral"]["triggers"]["reactionType"]["neutral"] = true
	E.global["nameplates"]["filters"]["MerathilisUI_Neutral"]["triggers"]["reactionType"]["reputation"] = true

	E:StaggeredUpdateAll(nil, true)

	PluginInstallStepComplete.message = MER.Title .. L["NamePlates Set"]
	PluginInstallStepComplete:Show()
end

function MER:SetupUnitframes(layout)
	if not E.db.movers then
		E.db.movers = {}
	end

	--[[----------------------------------
	--	UnitFrames - General
	--]]
	----------------------------------
	E.db["unitframe"]["font"] = I.Fonts.GothamRaid
	E.db["unitframe"]["fontSize"] = 10
	E.db["unitframe"]["fontOutline"] = "SHADOWOUTLINE"
	E.db["unitframe"]["smoothbars"] = true
	E.db["unitframe"]["statusbar"] = "ElvUI Norm1"

	E.db["unitframe"]["colors"]["castColor"] = {
		["r"] = 0.1,
		["g"] = 0.1,
		["b"] = 0.1,
	}
	E.db["unitframe"]["colors"]["transparentAurabars"] = true
	E.db["unitframe"]["colors"]["transparentPower"] = false
	E.db["unitframe"]["colors"]["transparentCastbar"] = false

	if layout == "gradient" then
		E.db["unitframe"]["colors"]["transparentHealth"] = false
		E.db["unitframe"]["colors"]["healthclass"] = true
		E.db["unitframe"]["colors"]["customhealthbackdrop"] = true
		E.db["unitframe"]["colors"]["classbackdrop"] = false
	elseif layout == "dark" then
		E.db["unitframe"]["colors"]["transparentHealth"] = true
		E.db["unitframe"]["colors"]["healthclass"] = false
		E.db["unitframe"]["colors"]["customhealthbackdrop"] = false
		E.db["unitframe"]["colors"]["classbackdrop"] = true
	end
	E.db["unitframe"]["colors"]["castClassColor"] = false
	E.db["unitframe"]["colors"]["castReactionColor"] = false
	E.db["unitframe"]["colors"]["powerclass"] = false
	E.db["unitframe"]["colors"]["power"]["MANA"] = { r = 0, g = 0.66, b = 1 }
	E.db["unitframe"]["colors"]["power"]["RAGE"] = { r = 0.780, g = 0.125, b = 0.184 }
	E.db["unitframe"]["colors"]["power"]["FOCUS"] = { r = 1, g = 0.50, b = 0.25 }
	E.db["unitframe"]["colors"]["power"]["ENERGY"] = { r = 1, g = 0.96, b = 0.41 }
	E.db["unitframe"]["colors"]["power"]["PAIN"] = { r = 1, g = 0.51, b = 0, atlas = "_DemonHunter-DemonicPainBar" }
	E.db["unitframe"]["colors"]["power"]["FURY"] = { r = 0.298, g = 1, b = 0, atlas = "_DemonHunter-DemonicFuryBar" }
	E.db["unitframe"]["colors"]["power"]["ALT_POWER"] = { r = 0.2, g = 0.54, b = 0.8 }
	E.db["unitframe"]["colors"]["power"]["RUNIC_POWER"] = { r = 0, g = 0.89, b = 1 }
	E.db["unitframe"]["colors"]["power"]["MAELSTROM"] = { r = 0, g = 0.5, b = 1, atlas = "_Shaman-MaelstromBar" }
	E.db["unitframe"]["colors"]["power"]["LUNAR_POWER"] = { r = 0, g = 0.619, b = 0.972, atlas = "_Druid-LunarBar" }
	E.db["unitframe"]["colors"]["invertPower"] = true
	E.db["unitframe"]["colors"]["colorhealthbyvalue"] = false
	E.db["unitframe"]["colors"]["useDeadBackdrop"] = false
	E.db["unitframe"]["colors"]["healthMultiplier"] = 0.75
	E.db["unitframe"]["debuffHighlighting"] = "FILL"

	-- Frame Glow
	E.db["unitframe"]["colors"]["frameGlow"]["targetGlow"]["enable"] = false
	E.db["unitframe"]["colors"]["frameGlow"]["mainGlow"]["enable"] = false
	E.db["unitframe"]["colors"]["frameGlow"]["mainGlow"]["class"] = true
	E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["color"]["a"] = 0.5
	E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["color"]["b"] = 0
	E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["color"]["g"] = 0
	E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["color"]["r"] = 0
	E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["class"] = true
	E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["texture"] = I.Media.Textures.MER_Stripes

	--Cooldowns
	E.db["unitframe"]["cooldown"]["override"] = true
	E.db["unitframe"]["cooldown"]["useIndicatorColor"] = true
	E.db["unitframe"]["cooldown"]["hhmmColor"]["b"] = 0.431372549019608
	E.db["unitframe"]["cooldown"]["hhmmColor"]["g"] = 0.431372549019608
	E.db["unitframe"]["cooldown"]["hhmmColor"]["r"] = 0.431372549019608
	E.db["unitframe"]["cooldown"]["mmssColor"]["b"] = 0.56078431372549
	E.db["unitframe"]["cooldown"]["mmssColor"]["g"] = 0.56078431372549
	E.db["unitframe"]["cooldown"]["mmssColor"]["r"] = 0.56078431372549
	E.db["unitframe"]["cooldown"]["secondsColor"]["b"] = 0
	E.db["unitframe"]["cooldown"]["fonts"]["enable"] = true
	E.db["unitframe"]["cooldown"]["fonts"]["font"] = I.Fonts.GothamRaid
	E.db["unitframe"]["cooldown"]["fonts"]["fontSize"] = 16
	E.db["unitframe"]["cooldown"]["hoursColor"]["r"] = 0.4
	E.db["unitframe"]["cooldown"]["daysColor"]["g"] = 0.4
	E.db["unitframe"]["cooldown"]["daysColor"]["r"] = 0.4
	E.db["unitframe"]["cooldown"]["hoursIndicator"]["r"] = 0.4
	E.db["unitframe"]["cooldown"]["minutesIndicator"]["r"] = 0.2470588235294118
	E.db["unitframe"]["cooldown"]["minutesIndicator"]["g"] = 0.7764705882352941
	E.db["unitframe"]["cooldown"]["minutesIndicator"]["b"] = 0.9176470588235294
	E.db["unitframe"]["cooldown"]["secondsIndicator"]["b"] = 0
	E.db["unitframe"]["cooldown"]["expireIndicator"]["g"] = 0
	E.db["unitframe"]["cooldown"]["expireIndicator"]["b"] = 0
	E.db["unitframe"]["cooldown"]["daysIndicator"]["r"] = 0.4
	E.db["unitframe"]["cooldown"]["daysIndicator"]["g"] = 0.4

	-- Player
	E.db["unitframe"]["units"]["player"]["width"] = 200
	E.db["unitframe"]["units"]["player"]["height"] = 20
	E.db["unitframe"]["units"]["player"]["orientation"] = "RIGHT"
	E.db["unitframe"]["units"]["player"]["RestIcon"]["enable"] = true
	if E.db.mui.unitframes.restingIndicator then
		E.db["unitframe"]["units"]["player"]["RestIcon"]["xOffset"] = 0
		E.db["unitframe"]["units"]["player"]["RestIcon"]["yOffset"] = 30
	else
		E.db["unitframe"]["units"]["player"]["RestIcon"]["xOffset"] = -3
		E.db["unitframe"]["units"]["player"]["RestIcon"]["yOffset"] = 6
	end
	E.db["unitframe"]["units"]["player"]["threatStyle"] = "ICONTOPRIGHT"
	E.db["unitframe"]["units"]["player"]["disableMouseoverGlow"] = false
	E.db["unitframe"]["units"]["player"]["debuffs"]["enable"] = true
	E.db["unitframe"]["units"]["player"]["debuffs"]["fontSize"] = 12
	E.db["unitframe"]["units"]["player"]["debuffs"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["player"]["debuffs"]["keepSizeRatio"] = false
	E.db["unitframe"]["units"]["player"]["debuffs"]["sizeOverride"] = 28
	E.db["unitframe"]["units"]["player"]["debuffs"]["height"] = 20
	E.db["unitframe"]["units"]["player"]["debuffs"]["xOffset"] = 2
	E.db["unitframe"]["units"]["player"]["debuffs"]["yOffset"] = 35
	E.db["unitframe"]["units"]["player"]["debuffs"]["perrow"] = 3
	E.db["unitframe"]["units"]["player"]["debuffs"]["numrows"] = 1
	E.db["unitframe"]["units"]["player"]["debuffs"]["anchorPoint"] = "TOPLEFT"
	E.db["unitframe"]["units"]["player"]["debuffs"]["countFont"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["player"]["debuffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["player"]["debuffs"]["spacing"] = 1
	E.db["unitframe"]["units"]["player"]["debuffs"]["durationPosition"] = "TOP"
	E.db["unitframe"]["units"]["player"]["smartAuraPosition"] = "DISABLED"
	E.db["unitframe"]["units"]["player"]["portrait"]["enable"] = false
	E.db["unitframe"]["units"]["player"]["classbar"]["enable"] = true
	E.db["unitframe"]["units"]["player"]["classbar"]["detachedWidth"] = 285
	E.db["unitframe"]["units"]["player"]["classbar"]["detachFromFrame"] = true
	E.db["unitframe"]["units"]["player"]["classbar"]["height"] = 15
	E.db["unitframe"]["units"]["player"]["classbar"]["autoHide"] = false
	E.db["unitframe"]["units"]["player"]["classbar"]["fill"] = "filled"
	E.db["unitframe"]["units"]["player"]["classbar"]["additionalPowerText"] = true
	E.db["unitframe"]["units"]["player"]["aurabar"]["enable"] = false
	E.db["unitframe"]["units"]["player"]["castbar"]["icon"] = true
	E.db["unitframe"]["units"]["player"]["castbar"]["latency"] = true
	E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 285
	E.db["unitframe"]["units"]["player"]["castbar"]["height"] = 18
	E.db["unitframe"]["units"]["player"]["castbar"]["insideInfoPanel"] = false
	E.db["unitframe"]["units"]["player"]["castbar"]["hidetext"] = false
	E.db["unitframe"]["units"]["player"]["castbar"]["overlayOnFrame"] = "None"
	E.db["unitframe"]["units"]["player"]["castbar"]["textColor"]["r"] = 1
	E.db["unitframe"]["units"]["player"]["castbar"]["textColor"]["g"] = 1
	E.db["unitframe"]["units"]["player"]["castbar"]["textColor"]["b"] = 1
	E.db["unitframe"]["units"]["player"]["castbar"]["showIcon"] = true
	E.db["unitframe"]["units"]["player"]["castbar"]["iconSize"] = 28
	E.db["unitframe"]["units"]["player"]["castbar"]["iconPosition"] = "LEFT"
	E.db["unitframe"]["units"]["player"]["castbar"]["iconXOffset"] = -2
	E.db["unitframe"]["units"]["player"]["castbar"]["iconYOffset"] = 5
	E.db["unitframe"]["units"]["player"]["castbar"]["iconAttached"] = false
	E.db["unitframe"]["units"]["player"]["castbar"]["iconAttachedTo"] = "Castbar"
	E.db["unitframe"]["units"]["player"]["castbar"]["timeToHold"] = 0.8

	if not E.db["unitframe"]["units"]["player"]["customTexts"] then
		E.db["unitframe"]["units"]["player"]["customTexts"] = {}
	end

	E.db["unitframe"]["units"]["player"]["customTexts"]["BigName"] = {
		["font"] = I.Fonts.GothamRaid,
		["justifyH"] = "LEFT",
		["fontOutline"] = "SHADOWOUTLINE",
		["xOffset"] = 0,
		["yOffset"] = 16,
		["size"] = 11,
		["text_format"] = "[classicon-flatborder][name:gradient]",
		["attachTextTo"] = "Frame",
	}

	E.db["unitframe"]["units"]["player"]["customTexts"]["Percent"] = {
		["font"] = I.Fonts.GothamRaid,
		["fontOutline"] = "SHADOWOUTLINE",
		["size"] = 11,
		["justifyH"] = "LEFT",
		["text_format"] = "[perhp<%]",
		["attachTextTo"] = "Frame",
		["xOffset"] = 0,
		["yOffset"] = 0,
	}
	E.db["unitframe"]["units"]["player"]["customTexts"]["Life"] = {
		["font"] = I.Fonts.GothamRaid,
		["fontOutline"] = "SHADOWOUTLINE",
		["size"] = 11,
		["justifyH"] = "RIGHT",
		["text_format"] = "[health:current:shortvalue]",
		["attachTextTo"] = "Frame",
		["xOffset"] = 0,
		["yOffset"] = 0,
	}
	E.db["unitframe"]["units"]["player"]["customTexts"]["Resting"] = nil
	E.db["unitframe"]["units"]["player"]["customTexts"]["MERPower"] = {
		["font"] = I.Fonts.GothamRaid,
		["fontOutline"] = "SHADOWOUTLINE",
		["size"] = 12,
		["justifyH"] = "CENTER",
		["text_format"] = "[power:current-mUI]",
		["attachTextTo"] = "Power",
		["xOffset"] = 0,
		["yOffset"] = 0,
	}
	E.db["unitframe"]["units"]["player"]["customTexts"]["MERMana"] = {
		["font"] = I.Fonts.GothamRaid,
		["fontOutline"] = "SHADOWOUTLINE",
		["size"] = 12,
		["justifyH"] = "CENTER",
		["text_format"] = "[additionalmana:current:shortvalue]",
		["attachTextTo"] = "AdditionalPower",
		["xOffset"] = 0,
		["yOffset"] = 0,
	}

	E.db["unitframe"]["units"]["player"]["customTexts"]["Group"] = {
		["font"] = I.Fonts.GothamRaid,
		["fontOutline"] = "SHADOWOUTLINE",
		["size"] = 11,
		["justifyH"] = "LEFT",
		["text_format"] = "[group]",
		["attachTextTo"] = "Frame",
		["xOffset"] = 0,
		["yOffset"] = -16,
	}
	E.db["unitframe"]["units"]["player"]["health"]["xOffset"] = 0
	E.db["unitframe"]["units"]["player"]["health"]["yOffset"] = 0
	E.db["unitframe"]["units"]["player"]["health"]["text_format"] = ""
	E.db["unitframe"]["units"]["player"]["health"]["attachTextTo"] = "Health"
	E.db["unitframe"]["units"]["player"]["health"]["position"] = "LEFT"
	E.db["unitframe"]["units"]["player"]["health"]["bgUseBarTexture"] = true

	if layout == "gradient" then
		E.db["unitframe"]["units"]["player"]["colorOverride"] = "USE_DEFAULT"
	elseif layout == "dark" then
		E.db["unitframe"]["units"]["player"]["colorOverride"] = "FORCE_OFF"
	end
	E.db["unitframe"]["units"]["player"]["name"]["text_format"] = ""
	E.db["unitframe"]["units"]["player"]["power"]["powerPrediction"] = true
	E.db["unitframe"]["units"]["player"]["power"]["height"] = 20
	E.db["unitframe"]["units"]["player"]["power"]["detachFromFrame"] = true
	E.db["unitframe"]["units"]["player"]["power"]["detachedWidth"] = 285
	E.db["unitframe"]["units"]["player"]["power"]["text_format"] = ""
	E.db["unitframe"]["units"]["player"]["power"]["attachTextTo"] = "Power"
	E.db["unitframe"]["units"]["player"]["power"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["player"]["power"]["xOffset"] = 0
	E.db["unitframe"]["units"]["player"]["power"]["yOffset"] = 0
	E.db["unitframe"]["units"]["player"]["buffs"]["enable"] = true
	E.db["unitframe"]["units"]["player"]["buffs"]["fontSize"] = 12
	E.db["unitframe"]["units"]["player"]["buffs"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["player"]["buffs"]["sizeOverride"] = 26
	E.db["unitframe"]["units"]["player"]["buffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["player"]["buffs"]["yOffset"] = 1
	E.db["unitframe"]["units"]["player"]["buffs"]["perrow"] = 4
	E.db["unitframe"]["units"]["player"]["buffs"]["numrows"] = 1
	E.db["unitframe"]["units"]["player"]["buffs"]["anchorPoint"] = "TOPRIGHT"
	E.db["unitframe"]["units"]["player"]["buffs"]["priority"] = "Blacklist,TurtleBuffs"
	E.db["unitframe"]["units"]["player"]["buffs"]["countFont"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["player"]["buffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["player"]["buffs"]["durationPosition"] = "TOP"
	E.db["unitframe"]["units"]["player"]["buffs"]["keepSizeRatio"] = false
	E.db["unitframe"]["units"]["player"]["buffs"]["height"] = 18
	E.db["unitframe"]["units"]["player"]["buffs"]["spacing"] = 1
	E.db["unitframe"]["units"]["player"]["buffs"]["growthX"] = "LEFT"
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
	E.db["unitframe"]["units"]["player"]["healPrediction"]["absorbStyle"] = "NORMAL"
	E.db["unitframe"]["units"]["player"]["healPrediction"]["anchorPoint"] = "BOTTOM"
	E.db["unitframe"]["units"]["player"]["healPrediction"]["height"] = -1
	E.db["unitframe"]["units"]["player"]["fader"]["enable"] = false
	E.db["unitframe"]["units"]["player"]["fader"]["combat"] = true
	E.db["unitframe"]["units"]["player"]["fader"]["casting"] = true
	E.db["unitframe"]["units"]["player"]["fader"]["health"] = true
	E.db["unitframe"]["units"]["player"]["fader"]["hover"] = true
	E.db["unitframe"]["units"]["player"]["fader"]["playertarget"] = true
	E.db["unitframe"]["units"]["player"]["fader"]["power"] = true
	E.db["unitframe"]["units"]["player"]["fader"]["vehicle"] = true
	E.db["unitframe"]["units"]["player"]["fader"]["minAlpha"] = 0.35
	E.db["unitframe"]["units"]["player"]["fader"]["maxAlpha"] = 1
	E.db["unitframe"]["units"]["player"]["fader"]["smooth"] = 0.33
	E.db["unitframe"]["units"]["player"]["cutaway"]["health"]["enabled"] = true
	E.db["unitframe"]["units"]["player"]["cutaway"]["power"]["enabled"] = true

	-- Target
	E.db["unitframe"]["units"]["target"]["width"] = 200
	E.db["unitframe"]["units"]["target"]["height"] = 20
	E.db["unitframe"]["units"]["target"]["orientation"] = "LEFT"
	E.db["unitframe"]["units"]["target"]["threatStyle"] = "ICONTOPLEFT"
	E.db["unitframe"]["units"]["target"]["disableMouseoverGlow"] = false
	E.db["unitframe"]["units"]["target"]["castbar"]["icon"] = true
	E.db["unitframe"]["units"]["target"]["castbar"]["latency"] = true
	E.db["unitframe"]["units"]["target"]["castbar"]["insideInfoPanel"] = false
	E.db["unitframe"]["units"]["target"]["castbar"]["width"] = 200
	E.db["unitframe"]["units"]["target"]["castbar"]["height"] = 18
	E.db["unitframe"]["units"]["target"]["castbar"]["hidetext"] = false
	E.db["unitframe"]["units"]["target"]["castbar"]["overlayOnFrame"] = "None"
	E.db["unitframe"]["units"]["target"]["castbar"]["textColor"]["r"] = 1
	E.db["unitframe"]["units"]["target"]["castbar"]["textColor"]["g"] = 1
	E.db["unitframe"]["units"]["target"]["castbar"]["textColor"]["b"] = 1
	E.db["unitframe"]["units"]["target"]["castbar"]["timeToHold"] = 0.8
	E.db["unitframe"]["units"]["target"]["debuffs"]["fontSize"] = 12
	E.db["unitframe"]["units"]["target"]["debuffs"]["sizeOverride"] = 28
	E.db["unitframe"]["units"]["target"]["debuffs"]["yOffset"] = 2
	E.db["unitframe"]["units"]["target"]["debuffs"]["xOffset"] = -2
	E.db["unitframe"]["units"]["target"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
	E.db["unitframe"]["units"]["target"]["debuffs"]["perrow"] = 7
	E.db["unitframe"]["units"]["target"]["debuffs"]["attachTo"] = "BUFFS"
	E.db["unitframe"]["units"]["target"]["debuffs"]["priority"] =
		"Blacklist,Personal,RaidDebuffs,CCDebuffs,Friendly:Dispellable"
	E.db["unitframe"]["units"]["target"]["debuffs"]["countFont"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["target"]["debuffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["target"]["debuffs"]["spacing"] = 3
	E.db["unitframe"]["units"]["target"]["debuffs"]["durationPosition"] = "TOP"
	E.db["unitframe"]["units"]["target"]["debuffs"]["keepSizeRatio"] = false
	E.db["unitframe"]["units"]["target"]["debuffs"]["height"] = 20
	E.db["unitframe"]["units"]["target"]["debuffs"]["spacing"] = 2
	E.db["unitframe"]["units"]["target"]["smartAuraPosition"] = "DISABLED"
	E.db["unitframe"]["units"]["target"]["aurabar"]["enable"] = false
	E.db["unitframe"]["units"]["target"]["aurabar"]["attachTo"] = "BUFFS"
	E.db["unitframe"]["units"]["target"]["name"]["xOffset"] = 8
	E.db["unitframe"]["units"]["target"]["name"]["yOffset"] = -32
	E.db["unitframe"]["units"]["target"]["name"]["position"] = "RIGHT"
	E.db["unitframe"]["units"]["target"]["name"]["text_format"] = ""
	E.db["unitframe"]["units"]["target"]["power"]["powerPrediction"] = true
	E.db["unitframe"]["units"]["target"]["power"]["detachFromFrame"] = false
	E.db["unitframe"]["units"]["target"]["power"]["hideonnpc"] = true
	E.db["unitframe"]["units"]["target"]["power"]["height"] = 6
	E.db["unitframe"]["units"]["target"]["power"]["text_format"] = ""
	if not E.db["unitframe"]["units"]["target"]["customTexts"] then
		E.db["unitframe"]["units"]["target"]["customTexts"] = {}
	end
	-- Delete old customTexts/ Create empty table
	E.db["unitframe"]["units"]["target"]["customTexts"] = {}
	E.db["unitframe"]["units"]["target"]["customTexts"]["BigName"] = {
		["font"] = I.Fonts.GothamRaid,
		["justifyH"] = "RIGHT",
		["fontOutline"] = "SHADOWOUTLINE",
		["xOffset"] = 2,
		["yOffset"] = 16,
		["size"] = 11,
		["text_format"] = "[classification:icon][name:gradient][classicon-flatborder]",
		["attachTextTo"] = "Frame",
	}
	E.db["unitframe"]["units"]["target"]["customTexts"]["Percent"] = {
		["font"] = I.Fonts.GothamRaid,
		["size"] = 11,
		["fontOutline"] = "SHADOWOUTLINE",
		["justifyH"] = "RIGHT",
		["text_format"] = "[perhp<%]",
		["attachTextTo"] = "Health",
		["yOffset"] = -1,
		["xOffset"] = 0,
	}
	E.db["unitframe"]["units"]["target"]["customTexts"]["Life"] = {
		["font"] = I.Fonts.GothamRaid,
		["size"] = 11,
		["fontOutline"] = "SHADOWOUTLINE",
		["justifyH"] = "LEFT",
		["text_format"] = "[health:current:shortvalue]",
		["attachTextTo"] = "Health",
		["yOffset"] = -1,
		["xOffset"] = 0,
	}
	E.db["unitframe"]["units"]["target"]["customTexts"]["MERPower"] = {
		["font"] = I.Fonts.GothamRaid,
		["size"] = 11,
		["fontOutline"] = "SHADOWOUTLINE",
		["justifyH"] = "RIGHT",
		["text_format"] = "[power:current:shortvalue]",
		["attachTextTo"] = "Health",
		["yOffset"] = -19,
		["xOffset"] = 3,
	}
	E.db["unitframe"]["units"]["target"]["health"]["xOffset"] = 0
	E.db["unitframe"]["units"]["target"]["health"]["yOffset"] = 0
	E.db["unitframe"]["units"]["target"]["health"]["text_format"] = ""
	E.db["unitframe"]["units"]["target"]["health"]["attachTextTo"] = "Frame"
	E.db["unitframe"]["units"]["target"]["health"]["position"] = "RIGHT"
	E.db["unitframe"]["units"]["target"]["health"]["bgUseBarTexture"] = true

	if layout == "gradient" then
		E.db["unitframe"]["units"]["target"]["colorOverride"] = "USE_DEFAULT"
	elseif layout == "dark" then
		E.db["unitframe"]["units"]["target"]["colorOverride"] = "FORCE_OFF"
	end
	E.db["unitframe"]["units"]["target"]["portrait"]["enable"] = false
	E.db["unitframe"]["units"]["target"]["buffs"]["enable"] = true
	E.db["unitframe"]["units"]["target"]["buffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["target"]["buffs"]["yOffset"] = 15
	E.db["unitframe"]["units"]["target"]["buffs"]["attachTo"] = "Health"
	E.db["unitframe"]["units"]["target"]["buffs"]["sizeOverride"] = 26
	E.db["unitframe"]["units"]["target"]["buffs"]["perrow"] = 7
	E.db["unitframe"]["units"]["target"]["buffs"]["fontSize"] = 10
	E.db["unitframe"]["units"]["target"]["buffs"]["anchorPoint"] = "TOPRIGHT"
	E.db["unitframe"]["units"]["target"]["buffs"]["minDuration"] = 0
	E.db["unitframe"]["units"]["target"]["buffs"]["maxDuration"] = 0
	E.db["unitframe"]["units"]["target"]["buffs"]["priority"] =
		"Blacklist,Personal,Boss,Whitelist,PlayerBuffs,nonPersonal"
	E.db["unitframe"]["units"]["target"]["buffs"]["countFont"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["target"]["buffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["target"]["buffs"]["durationPosition"] = "TOP"
	E.db["unitframe"]["units"]["target"]["buffs"]["keepSizeRatio"] = false
	E.db["unitframe"]["units"]["target"]["buffs"]["height"] = 18
	E.db["unitframe"]["units"]["target"]["buffs"]["spacing"] = 1
	E.db["unitframe"]["units"]["target"]["buffs"]["growthX"] = "LEFT"
	E.db["unitframe"]["units"]["target"]["buffs"]["attachTo"] = "FRAME"
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
	E.db["unitframe"]["units"]["target"]["healPrediction"]["absorbStyle"] = "NORMAL"
	E.db["unitframe"]["units"]["target"]["healPrediction"]["anchorPoint"] = "BOTTOM"
	E.db["unitframe"]["units"]["target"]["healPrediction"]["height"] = -1
	E.db["unitframe"]["units"]["target"]["CombatIcon"]["size"] = 11
	E.db["unitframe"]["units"]["target"]["CombatIcon"]["texture"] = "COMBAT"
	E.db["unitframe"]["units"]["target"]["CombatIcon"]["customTexture"] = ""
	E.db["unitframe"]["units"]["target"]["CombatIcon"]["anchorPoint"] = "CENTER"
	E.db["unitframe"]["units"]["target"]["CombatIcon"]["xOffset"] = 0
	E.db["unitframe"]["units"]["target"]["CombatIcon"]["yOffset"] = 0
	E.db["unitframe"]["units"]["target"]["cutaway"]["health"]["enabled"] = true

	-- TargetTarget
	E.db["unitframe"]["units"]["targettarget"]["disableMouseoverGlow"] = false
	E.db["unitframe"]["units"]["targettarget"]["debuffs"]["enable"] = true
	E.db["unitframe"]["units"]["targettarget"]["power"]["enable"] = true
	E.db["unitframe"]["units"]["targettarget"]["power"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["targettarget"]["power"]["height"] = 6
	E.db["unitframe"]["units"]["targettarget"]["power"]["text_format"] = ""
	E.db["unitframe"]["units"]["targettarget"]["width"] = 75
	E.db["unitframe"]["units"]["targettarget"]["name"]["yOffset"] = 0
	E.db["unitframe"]["units"]["targettarget"]["name"]["text_format"] = "[name:gradient]"
	E.db["unitframe"]["units"]["targettarget"]["height"] = 20
	E.db["unitframe"]["units"]["targettarget"]["health"]["text_format"] = ""
	E.db["unitframe"]["units"]["targettarget"]["health"]["bgUseBarTexture"] = true
	E.db["unitframe"]["units"]["targettarget"]["raidicon"]["enable"] = true
	E.db["unitframe"]["units"]["targettarget"]["raidicon"]["position"] = "TOP"
	E.db["unitframe"]["units"]["targettarget"]["raidicon"]["size"] = 18
	E.db["unitframe"]["units"]["targettarget"]["raidicon"]["xOffset"] = 0
	E.db["unitframe"]["units"]["targettarget"]["raidicon"]["yOffset"] = 15
	E.db["unitframe"]["units"]["targettarget"]["portrait"]["enable"] = false
	E.db["unitframe"]["units"]["targettarget"]["infoPanel"]["enable"] = false
	if not E.db["unitframe"]["units"]["targettarget"]["customTexts"] then
		E.db["unitframe"]["units"]["targettarget"]["customTexts"] = {}
	end
	-- Delete old customTexts/ Create empty table
	E.db["unitframe"]["units"]["targettarget"]["customTexts"] = {}
	E.db["unitframe"]["units"]["targettarget"]["cutaway"]["health"]["enabled"] = true

	-- Focus
	E.db["unitframe"]["units"]["focus"]["width"] = 100
	E.db["unitframe"]["units"]["focus"]["height"] = 32
	E.db["unitframe"]["units"]["focus"]["disableMouseoverGlow"] = false
	E.db["unitframe"]["units"]["focus"]["name"]["attachTextTo"] = "Health"
	E.db["unitframe"]["units"]["focus"]["name"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["focus"]["name"]["text_format"] = "[namecolor][name:medium]"
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
	E.db["unitframe"]["units"]["focus"]["cutaway"]["health"]["enabled"] = true

	-- FocusTarget
	E.db["unitframe"]["units"]["focustarget"]["enable"] = false

	-- Raid1
	E.db["unitframe"]["units"]["raid1"]["enable"] = true
	E.db["unitframe"]["units"]["raid1"]["height"] = 35
	E.db["unitframe"]["units"]["raid1"]["width"] = 83
	E.db["unitframe"]["units"]["raid1"]["threatStyle"] = "GLOW"
	E.db["unitframe"]["units"]["raid1"]["orientation"] = "MIDDLE"
	E.db["unitframe"]["units"]["raid1"]["horizontalSpacing"] = 3
	E.db["unitframe"]["units"]["raid1"]["verticalSpacing"] = 2
	E.db["unitframe"]["units"]["raid1"]["disableMouseoverGlow"] = false
	E.db["unitframe"]["units"]["raid1"]["debuffs"]["countFontSize"] = 12
	E.db["unitframe"]["units"]["raid1"]["debuffs"]["enable"] = true
	E.db["unitframe"]["units"]["raid1"]["debuffs"]["clickThrough"] = true
	E.db["unitframe"]["units"]["raid1"]["debuffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid1"]["debuffs"]["yOffset"] = -8
	E.db["unitframe"]["units"]["raid1"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
	E.db["unitframe"]["units"]["raid1"]["debuffs"]["sizeOverride"] = 15
	E.db["unitframe"]["units"]["raid1"]["debuffs"]["maxDuration"] = 0
	E.db["unitframe"]["units"]["raid1"]["debuffs"]["priority"] =
		"Blacklist,Boss,RaidDebuffs,nonPersonal,CastByUnit,CCDebuffs,CastByNPC,Dispellable"
	E.db["unitframe"]["units"]["raid1"]["debuffs"]["countFont"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["raid1"]["debuffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["raid1"]["debuffs"]["growthX"] = "LEFT"
	E.db["unitframe"]["units"]["raid1"]["debuffs"]["perrow"] = 5
	E.db["unitframe"]["units"]["raid1"]["rdebuffs"]["enable"] = false
	E.db["unitframe"]["units"]["raid1"]["rdebuffs"]["font"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["raid1"]["rdebuffs"]["fontSize"] = 10
	E.db["unitframe"]["units"]["raid1"]["rdebuffs"]["size"] = 20
	E.db["unitframe"]["units"]["raid1"]["numGroups"] = 5
	E.db["unitframe"]["units"]["raid1"]["growthDirection"] = "RIGHT_UP"
	E.db["unitframe"]["units"]["raid1"]["portrait"]["enable"] = false
	E.db["unitframe"]["units"]["raid1"]["name"]["text_format"] = ""
	E.db["unitframe"]["units"]["raid1"]["buffIndicator"]["fontSize"] = 11
	E.db["unitframe"]["units"]["raid1"]["buffIndicator"]["size"] = 10
	E.db["unitframe"]["units"]["raid1"]["roleIcon"]["size"] = 10
	E.db["unitframe"]["units"]["raid1"]["roleIcon"]["position"] = "TOPLEFT"
	E.db["unitframe"]["units"]["raid1"]["roleIcon"]["xOffset"] = 1
	E.db["unitframe"]["units"]["raid1"]["roleIcon"]["yOffset"] = -1
	E.db["unitframe"]["units"]["raid1"]["power"]["enable"] = true
	E.db["unitframe"]["units"]["raid1"]["power"]["height"] = 4
	E.db["unitframe"]["units"]["raid1"]["power"]["hideonnpc"] = true
	E.db["unitframe"]["units"]["raid1"]["power"]["powerPrediction"] = true
	E.db["unitframe"]["units"]["raid1"]["power"]["onlyHealer"] = true
	E.db["unitframe"]["units"]["raid1"]["groupBy"] = "ROLE"
	E.db["unitframe"]["units"]["raid1"]["health"]["frequentUpdates"] = true
	E.db["unitframe"]["units"]["raid1"]["health"]["position"] = "BOTTOM"
	E.db["unitframe"]["units"]["raid1"]["health"]["text_format"] = ""
	E.db["unitframe"]["units"]["raid1"]["health"]["attachTextTo"] = "Health"
	E.db["unitframe"]["units"]["raid1"]["health"]["bgUseBarTexture"] = true
	E.db["unitframe"]["units"]["raid1"]["buffs"]["enable"] = true
	E.db["unitframe"]["units"]["raid1"]["buffs"]["yOffset"] = 5
	E.db["unitframe"]["units"]["raid1"]["buffs"]["anchorPoint"] = "CENTER"
	E.db["unitframe"]["units"]["raid1"]["buffs"]["clickThrough"] = true
	E.db["unitframe"]["units"]["raid1"]["buffs"]["useBlacklist"] = false
	E.db["unitframe"]["units"]["raid1"]["buffs"]["useWhitelist"] = true
	E.db["unitframe"]["units"]["raid1"]["buffs"]["noDuration"] = false
	E.db["unitframe"]["units"]["raid1"]["buffs"]["playerOnly"] = false
	E.db["unitframe"]["units"]["raid1"]["buffs"]["perrow"] = 1
	E.db["unitframe"]["units"]["raid1"]["buffs"]["useFilter"] = "TurtleBuffs"
	E.db["unitframe"]["units"]["raid1"]["buffs"]["noConsolidated"] = false
	E.db["unitframe"]["units"]["raid1"]["buffs"]["sizeOverride"] = 20
	E.db["unitframe"]["units"]["raid1"]["buffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid1"]["buffs"]["yOffset"] = 0
	E.db["unitframe"]["units"]["raid1"]["buffs"]["countFont"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["raid1"]["buffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["raid1"]["buffs"]["useFilter"] = "TurtleBuffs"
	E.db["unitframe"]["units"]["raid1"]["buffs"]["priority"] = "TurtleBuffs"
	E.db["unitframe"]["units"]["raid1"]["raidicon"]["attachTo"] = "CENTER"
	E.db["unitframe"]["units"]["raid1"]["raidicon"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid1"]["raidicon"]["yOffset"] = 5
	E.db["unitframe"]["units"]["raid1"]["raidicon"]["size"] = 15
	E.db["unitframe"]["units"]["raid1"]["raidicon"]["yOffset"] = 0
	if not E.db["unitframe"]["units"]["raid1"]["customTexts"] then
		E.db["unitframe"]["units"]["raid1"]["customTexts"] = {}
	end
	-- Delete old customTexts/ Create empty table
	E.db["unitframe"]["units"]["raid1"]["customTexts"] = {}
	-- Create own customTexts
	E.db["unitframe"]["units"]["raid1"]["customTexts"]["Status"] = {
		["font"] = I.Fonts.GothamRaid,
		["justifyH"] = "CENTER",
		["fontOutline"] = "SHADOWOUTLINE",
		["xOffset"] = 0,
		["yOffset"] = -12,
		["size"] = 9,
		["attachTextTo"] = "Health",
		["text_format"] = "[statustimer]",
	}
	E.db["unitframe"]["units"]["raid1"]["customTexts"]["name1"] = {
		["font"] = I.Fonts.GothamRaid,
		["size"] = 9,
		["fontOutline"] = "SHADOWOUTLINE",
		["justifyH"] = "CENTER",
		["yOffset"] = 0,
		["xOffset"] = 0,
		["attachTextTo"] = "Health",
		["text_format"] = "[name:gradient]",
	}
	E.db["unitframe"]["units"]["raid1"]["infoPanel"]["enable"] = false
	E.db["unitframe"]["units"]["raid1"]["infoPanel"]["height"] = 13
	E.db["unitframe"]["units"]["raid1"]["infoPanel"]["transparent"] = true
	E.db["unitframe"]["units"]["raid1"]["roleIcon"]["enable"] = true
	E.db["unitframe"]["units"]["raid1"]["roleIcon"]["damager"] = true
	E.db["unitframe"]["units"]["raid1"]["roleIcon"]["tank"] = true
	E.db["unitframe"]["units"]["raid1"]["roleIcon"]["heal"] = true
	E.db["unitframe"]["units"]["raid1"]["roleIcon"]["attachTo"] = "Health"
	E.db["unitframe"]["units"]["raid1"]["roleIcon"]["yOffset"] = -1
	E.db["unitframe"]["units"]["raid1"]["roleIcon"]["xOffset"] = 1
	E.db["unitframe"]["units"]["raid1"]["roleIcon"]["size"] = 10
	E.db["unitframe"]["units"]["raid1"]["roleIcon"]["position"] = "TOPLEFT"

	if layout == "gradient" then
		E.db["unitframe"]["units"]["raid1"]["colorOverride"] = "USE_DEFAULT"
	elseif layout == "dark" then
		E.db["unitframe"]["units"]["raid1"]["colorOverride"] = "FORCE_OFF"
	end
	E.db["unitframe"]["units"]["raid1"]["readycheckIcon"]["size"] = 20
	E.db["unitframe"]["units"]["raid1"]["healPrediction"]["enable"] = true
	E.db["unitframe"]["units"]["raid1"]["healPrediction"]["absorbStyle"] = "NORMAL"
	E.db["unitframe"]["units"]["raid1"]["healPrediction"]["anchorPoint"] = "BOTTOM"
	E.db["unitframe"]["units"]["raid1"]["healPrediction"]["height"] = -1
	E.db["unitframe"]["units"]["raid1"]["cutaway"]["health"]["enabled"] = true

	-- Raid2
	E.db["unitframe"]["units"]["raid2"]["enable"] = true
	E.db["unitframe"]["units"]["raid2"]["height"] = 35
	E.db["unitframe"]["units"]["raid2"]["width"] = 83
	E.db["unitframe"]["units"]["raid2"]["threatStyle"] = "GLOW"
	E.db["unitframe"]["units"]["raid2"]["orientation"] = "MIDDLE"
	E.db["unitframe"]["units"]["raid2"]["horizontalSpacing"] = 3
	E.db["unitframe"]["units"]["raid2"]["verticalSpacing"] = 2
	E.db["unitframe"]["units"]["raid2"]["disableMouseoverGlow"] = false
	E.db["unitframe"]["units"]["raid2"]["debuffs"]["countFontSize"] = 12
	E.db["unitframe"]["units"]["raid2"]["debuffs"]["enable"] = true
	E.db["unitframe"]["units"]["raid2"]["debuffs"]["clickThrough"] = true
	E.db["unitframe"]["units"]["raid2"]["debuffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid2"]["debuffs"]["yOffset"] = -8
	E.db["unitframe"]["units"]["raid2"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
	E.db["unitframe"]["units"]["raid2"]["debuffs"]["sizeOverride"] = 15
	E.db["unitframe"]["units"]["raid2"]["debuffs"]["maxDuration"] = 0
	E.db["unitframe"]["units"]["raid2"]["debuffs"]["priority"] =
		"Blacklist,Boss,RaidDebuffs,nonPersonal,CastByUnit,CCDebuffs,CastByNPC,Dispellable"
	E.db["unitframe"]["units"]["raid2"]["debuffs"]["countFont"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["raid2"]["debuffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["raid2"]["debuffs"]["growthX"] = "LEFT"
	E.db["unitframe"]["units"]["raid2"]["debuffs"]["perrow"] = 5
	E.db["unitframe"]["units"]["raid2"]["rdebuffs"]["enable"] = false
	E.db["unitframe"]["units"]["raid2"]["rdebuffs"]["font"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["raid2"]["rdebuffs"]["fontSize"] = 10
	E.db["unitframe"]["units"]["raid2"]["rdebuffs"]["size"] = 20
	E.db["unitframe"]["units"]["raid2"]["numGroups"] = 5
	E.db["unitframe"]["units"]["raid2"]["growthDirection"] = "RIGHT_UP"
	E.db["unitframe"]["units"]["raid2"]["portrait"]["enable"] = false
	E.db["unitframe"]["units"]["raid2"]["name"]["text_format"] = ""
	E.db["unitframe"]["units"]["raid2"]["buffIndicator"]["fontSize"] = 11
	E.db["unitframe"]["units"]["raid2"]["buffIndicator"]["size"] = 10
	E.db["unitframe"]["units"]["raid2"]["roleIcon"]["size"] = 10
	E.db["unitframe"]["units"]["raid2"]["roleIcon"]["position"] = "TOPLEFT"
	E.db["unitframe"]["units"]["raid2"]["roleIcon"]["xOffset"] = 1
	E.db["unitframe"]["units"]["raid2"]["roleIcon"]["yOffset"] = -1
	E.db["unitframe"]["units"]["raid2"]["power"]["enable"] = true
	E.db["unitframe"]["units"]["raid2"]["power"]["height"] = 4
	E.db["unitframe"]["units"]["raid2"]["power"]["hideonnpc"] = true
	E.db["unitframe"]["units"]["raid2"]["power"]["powerPrediction"] = true
	E.db["unitframe"]["units"]["raid2"]["power"]["onlyHealer"] = true
	E.db["unitframe"]["units"]["raid2"]["groupBy"] = "ROLE"
	E.db["unitframe"]["units"]["raid2"]["health"]["frequentUpdates"] = true
	E.db["unitframe"]["units"]["raid2"]["health"]["position"] = "BOTTOM"
	E.db["unitframe"]["units"]["raid2"]["health"]["text_format"] = ""
	E.db["unitframe"]["units"]["raid2"]["health"]["attachTextTo"] = "Health"
	E.db["unitframe"]["units"]["raid2"]["health"]["bgUseBarTexture"] = true
	E.db["unitframe"]["units"]["raid2"]["buffs"]["enable"] = true
	E.db["unitframe"]["units"]["raid2"]["buffs"]["yOffset"] = 5
	E.db["unitframe"]["units"]["raid2"]["buffs"]["anchorPoint"] = "CENTER"
	E.db["unitframe"]["units"]["raid2"]["buffs"]["clickThrough"] = true
	E.db["unitframe"]["units"]["raid2"]["buffs"]["useBlacklist"] = false
	E.db["unitframe"]["units"]["raid2"]["buffs"]["useWhitelist"] = true
	E.db["unitframe"]["units"]["raid2"]["buffs"]["noDuration"] = false
	E.db["unitframe"]["units"]["raid2"]["buffs"]["playerOnly"] = false
	E.db["unitframe"]["units"]["raid2"]["buffs"]["perrow"] = 1
	E.db["unitframe"]["units"]["raid2"]["buffs"]["useFilter"] = "TurtleBuffs"
	E.db["unitframe"]["units"]["raid2"]["buffs"]["noConsolidated"] = false
	E.db["unitframe"]["units"]["raid2"]["buffs"]["sizeOverride"] = 20
	E.db["unitframe"]["units"]["raid2"]["buffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid2"]["buffs"]["yOffset"] = 0
	E.db["unitframe"]["units"]["raid2"]["buffs"]["countFont"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["raid2"]["buffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["raid2"]["buffs"]["useFilter"] = "TurtleBuffs"
	E.db["unitframe"]["units"]["raid2"]["buffs"]["priority"] = "TurtleBuffs"
	E.db["unitframe"]["units"]["raid2"]["raidicon"]["attachTo"] = "CENTER"
	E.db["unitframe"]["units"]["raid2"]["raidicon"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid2"]["raidicon"]["yOffset"] = 5
	E.db["unitframe"]["units"]["raid2"]["raidicon"]["size"] = 15
	E.db["unitframe"]["units"]["raid2"]["raidicon"]["yOffset"] = 0
	if not E.db["unitframe"]["units"]["raid2"]["customTexts"] then
		E.db["unitframe"]["units"]["raid2"]["customTexts"] = {}
	end
	-- Delete old customTexts/ Create empty table
	E.db["unitframe"]["units"]["raid2"]["customTexts"] = {}
	-- Create own customTexts
	E.db["unitframe"]["units"]["raid2"]["customTexts"]["Status"] = {
		["font"] = I.Fonts.GothamRaid,
		["justifyH"] = "CENTER",
		["fontOutline"] = "SHADOWOUTLINE",
		["xOffset"] = 0,
		["yOffset"] = -12,
		["size"] = 9,
		["attachTextTo"] = "Health",
		["text_format"] = "[statustimer]",
	}
	E.db["unitframe"]["units"]["raid2"]["customTexts"]["name1"] = {
		["font"] = I.Fonts.GothamRaid,
		["size"] = 9,
		["fontOutline"] = "SHADOWOUTLINE",
		["justifyH"] = "CENTER",
		["yOffset"] = 0,
		["xOffset"] = 0,
		["attachTextTo"] = "Health",
		["text_format"] = "[name:gradient]",
	}
	E.db["unitframe"]["units"]["raid2"]["infoPanel"]["enable"] = false
	E.db["unitframe"]["units"]["raid2"]["infoPanel"]["height"] = 13
	E.db["unitframe"]["units"]["raid2"]["infoPanel"]["transparent"] = true
	E.db["unitframe"]["units"]["raid2"]["roleIcon"]["enable"] = true
	E.db["unitframe"]["units"]["raid2"]["roleIcon"]["damager"] = true
	E.db["unitframe"]["units"]["raid2"]["roleIcon"]["tank"] = true
	E.db["unitframe"]["units"]["raid2"]["roleIcon"]["heal"] = true
	E.db["unitframe"]["units"]["raid2"]["roleIcon"]["attachTo"] = "Health"
	E.db["unitframe"]["units"]["raid2"]["roleIcon"]["yOffset"] = -1
	E.db["unitframe"]["units"]["raid2"]["roleIcon"]["xOffset"] = 1
	E.db["unitframe"]["units"]["raid2"]["roleIcon"]["size"] = 10
	E.db["unitframe"]["units"]["raid2"]["roleIcon"]["position"] = "TOPLEFT"

	if layout == "gradient" then
		E.db["unitframe"]["units"]["raid2"]["colorOverride"] = "USE_DEFAULT"
	elseif layout == "dark" then
		E.db["unitframe"]["units"]["raid2"]["colorOverride"] = "FORCE_OFF"
	end
	E.db["unitframe"]["units"]["raid2"]["readycheckIcon"]["size"] = 20
	E.db["unitframe"]["units"]["raid2"]["healPrediction"]["enable"] = true
	E.db["unitframe"]["units"]["raid2"]["healPrediction"]["absorbStyle"] = "NORMAL"
	E.db["unitframe"]["units"]["raid2"]["healPrediction"]["anchorPoint"] = "BOTTOM"
	E.db["unitframe"]["units"]["raid2"]["healPrediction"]["height"] = -1
	E.db["unitframe"]["units"]["raid2"]["cutaway"]["health"]["enabled"] = true

	-- Raid3
	E.db["unitframe"]["units"]["raid3"]["enable"] = true
	E.db["unitframe"]["units"]["raid3"]["height"] = 35
	E.db["unitframe"]["units"]["raid3"]["width"] = 83
	E.db["unitframe"]["units"]["raid3"]["threatStyle"] = "GLOW"
	E.db["unitframe"]["units"]["raid3"]["orientation"] = "MIDDLE"
	E.db["unitframe"]["units"]["raid3"]["horizontalSpacing"] = 3
	E.db["unitframe"]["units"]["raid3"]["verticalSpacing"] = 2
	E.db["unitframe"]["units"]["raid3"]["disableMouseoverGlow"] = false
	E.db["unitframe"]["units"]["raid3"]["debuffs"]["countFontSize"] = 12
	E.db["unitframe"]["units"]["raid3"]["debuffs"]["enable"] = true
	E.db["unitframe"]["units"]["raid3"]["debuffs"]["clickThrough"] = true
	E.db["unitframe"]["units"]["raid3"]["debuffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid3"]["debuffs"]["yOffset"] = -8
	E.db["unitframe"]["units"]["raid3"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
	E.db["unitframe"]["units"]["raid3"]["debuffs"]["sizeOverride"] = 15
	E.db["unitframe"]["units"]["raid3"]["debuffs"]["maxDuration"] = 0
	E.db["unitframe"]["units"]["raid3"]["debuffs"]["priority"] =
		"Blacklist,Boss,RaidDebuffs,nonPersonal,CastByUnit,CCDebuffs,CastByNPC,Dispellable"
	E.db["unitframe"]["units"]["raid3"]["debuffs"]["countFont"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["raid3"]["debuffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["raid3"]["debuffs"]["growthX"] = "LEFT"
	E.db["unitframe"]["units"]["raid3"]["debuffs"]["perrow"] = 5
	E.db["unitframe"]["units"]["raid3"]["rdebuffs"]["enable"] = false
	E.db["unitframe"]["units"]["raid3"]["rdebuffs"]["font"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["raid3"]["rdebuffs"]["fontSize"] = 10
	E.db["unitframe"]["units"]["raid3"]["rdebuffs"]["size"] = 20
	E.db["unitframe"]["units"]["raid3"]["numGroups"] = 8
	E.db["unitframe"]["units"]["raid3"]["growthDirection"] = "RIGHT_UP"
	E.db["unitframe"]["units"]["raid3"]["portrait"]["enable"] = false
	E.db["unitframe"]["units"]["raid3"]["name"]["text_format"] = ""
	E.db["unitframe"]["units"]["raid3"]["buffIndicator"]["fontSize"] = 11
	E.db["unitframe"]["units"]["raid3"]["buffIndicator"]["size"] = 10
	E.db["unitframe"]["units"]["raid3"]["roleIcon"]["size"] = 10
	E.db["unitframe"]["units"]["raid3"]["roleIcon"]["position"] = "TOPLEFT"
	E.db["unitframe"]["units"]["raid3"]["roleIcon"]["xOffset"] = 1
	E.db["unitframe"]["units"]["raid3"]["roleIcon"]["yOffset"] = -1
	E.db["unitframe"]["units"]["raid3"]["power"]["enable"] = true
	E.db["unitframe"]["units"]["raid3"]["power"]["height"] = 4
	E.db["unitframe"]["units"]["raid3"]["power"]["hideonnpc"] = true
	E.db["unitframe"]["units"]["raid3"]["power"]["powerPrediction"] = true
	E.db["unitframe"]["units"]["raid3"]["power"]["onlyHealer"] = true
	E.db["unitframe"]["units"]["raid3"]["groupBy"] = "ROLE"
	E.db["unitframe"]["units"]["raid3"]["health"]["frequentUpdates"] = true
	E.db["unitframe"]["units"]["raid3"]["health"]["position"] = "BOTTOM"
	E.db["unitframe"]["units"]["raid3"]["health"]["text_format"] = ""
	E.db["unitframe"]["units"]["raid3"]["health"]["attachTextTo"] = "Health"
	E.db["unitframe"]["units"]["raid3"]["health"]["bgUseBarTexture"] = true
	E.db["unitframe"]["units"]["raid3"]["buffs"]["enable"] = true
	E.db["unitframe"]["units"]["raid3"]["buffs"]["yOffset"] = 5
	E.db["unitframe"]["units"]["raid3"]["buffs"]["anchorPoint"] = "CENTER"
	E.db["unitframe"]["units"]["raid3"]["buffs"]["clickThrough"] = true
	E.db["unitframe"]["units"]["raid3"]["buffs"]["useBlacklist"] = false
	E.db["unitframe"]["units"]["raid3"]["buffs"]["useWhitelist"] = true
	E.db["unitframe"]["units"]["raid3"]["buffs"]["noDuration"] = false
	E.db["unitframe"]["units"]["raid3"]["buffs"]["playerOnly"] = false
	E.db["unitframe"]["units"]["raid3"]["buffs"]["perrow"] = 1
	E.db["unitframe"]["units"]["raid3"]["buffs"]["useFilter"] = "TurtleBuffs"
	E.db["unitframe"]["units"]["raid3"]["buffs"]["noConsolidated"] = false
	E.db["unitframe"]["units"]["raid3"]["buffs"]["sizeOverride"] = 20
	E.db["unitframe"]["units"]["raid3"]["buffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid3"]["buffs"]["yOffset"] = 0
	E.db["unitframe"]["units"]["raid3"]["buffs"]["countFont"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["raid3"]["buffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["raid3"]["buffs"]["useFilter"] = "TurtleBuffs"
	E.db["unitframe"]["units"]["raid3"]["buffs"]["priority"] = "TurtleBuffs"
	E.db["unitframe"]["units"]["raid3"]["raidicon"]["attachTo"] = "CENTER"
	E.db["unitframe"]["units"]["raid3"]["raidicon"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid3"]["raidicon"]["yOffset"] = 5
	E.db["unitframe"]["units"]["raid3"]["raidicon"]["size"] = 15
	E.db["unitframe"]["units"]["raid3"]["raidicon"]["yOffset"] = 0
	if not E.db["unitframe"]["units"]["raid3"]["customTexts"] then
		E.db["unitframe"]["units"]["raid3"]["customTexts"] = {}
	end
	-- Delete old customTexts/ Create empty table
	E.db["unitframe"]["units"]["raid3"]["customTexts"] = {}
	-- Create own customTexts
	E.db["unitframe"]["units"]["raid3"]["customTexts"]["Status"] = {
		["font"] = I.Fonts.GothamRaid,
		["justifyH"] = "CENTER",
		["fontOutline"] = "SHADOWOUTLINE",
		["xOffset"] = 0,
		["yOffset"] = -12,
		["size"] = 9,
		["attachTextTo"] = "Health",
		["text_format"] = "[statustimer]",
	}
	E.db["unitframe"]["units"]["raid3"]["customTexts"]["name1"] = {
		["font"] = I.Fonts.GothamRaid,
		["size"] = 9,
		["fontOutline"] = "SHADOWOUTLINE",
		["justifyH"] = "CENTER",
		["yOffset"] = 0,
		["xOffset"] = 0,
		["attachTextTo"] = "Health",
		["text_format"] = "[name:gradient]",
	}
	E.db["unitframe"]["units"]["raid3"]["infoPanel"]["enable"] = false
	E.db["unitframe"]["units"]["raid3"]["infoPanel"]["height"] = 13
	E.db["unitframe"]["units"]["raid3"]["infoPanel"]["transparent"] = true
	E.db["unitframe"]["units"]["raid3"]["roleIcon"]["enable"] = true
	E.db["unitframe"]["units"]["raid3"]["roleIcon"]["damager"] = true
	E.db["unitframe"]["units"]["raid3"]["roleIcon"]["tank"] = true
	E.db["unitframe"]["units"]["raid3"]["roleIcon"]["heal"] = true
	E.db["unitframe"]["units"]["raid3"]["roleIcon"]["attachTo"] = "Health"
	E.db["unitframe"]["units"]["raid3"]["roleIcon"]["yOffset"] = -1
	E.db["unitframe"]["units"]["raid3"]["roleIcon"]["xOffset"] = 1
	E.db["unitframe"]["units"]["raid3"]["roleIcon"]["size"] = 10
	E.db["unitframe"]["units"]["raid3"]["roleIcon"]["position"] = "TOPLEFT"

	if layout == "gradient" then
		E.db["unitframe"]["units"]["raid3"]["colorOverride"] = "USE_DEFAULT"
	elseif layout == "dark" then
		E.db["unitframe"]["units"]["raid3"]["colorOverride"] = "FORCE_OFF"
	end
	E.db["unitframe"]["units"]["raid3"]["readycheckIcon"]["size"] = 20
	E.db["unitframe"]["units"]["raid3"]["healPrediction"]["enable"] = true
	E.db["unitframe"]["units"]["raid3"]["healPrediction"]["absorbStyle"] = "NORMAL"
	E.db["unitframe"]["units"]["raid3"]["healPrediction"]["anchorPoint"] = "BOTTOM"
	E.db["unitframe"]["units"]["raid3"]["healPrediction"]["height"] = -1
	E.db["unitframe"]["units"]["raid3"]["cutaway"]["health"]["enabled"] = true

	-- Party
	E.db["unitframe"]["units"]["party"]["enable"] = true
	E.db["unitframe"]["units"]["party"]["growthDirection"] = "UP_RIGHT"
	E.db["unitframe"]["units"]["party"]["horizontalSpacing"] = 1
	E.db["unitframe"]["units"]["party"]["disableMouseoverGlow"] = false
	E.db["unitframe"]["units"]["party"]["showPlayer"] = false
	E.db["unitframe"]["units"]["party"]["debuffs"]["countFontSize"] = 12
	E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] = 32
	E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = 0
	E.db["unitframe"]["units"]["party"]["debuffs"]["xOffset"] = -2
	E.db["unitframe"]["units"]["party"]["debuffs"]["maxDuration"] = 0
	E.db["unitframe"]["units"]["party"]["debuffs"]["clickThrough"] = true
	E.db["unitframe"]["units"]["party"]["debuffs"]["spacing"] = 1
	E.db["unitframe"]["units"]["party"]["debuffs"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["party"]["debuffs"]["priority"] =
		"Blacklist,Boss,RaidDebuffs,nonPersonal,CastByUnit,CCDebuffs,CastByNPC,Dispellable"
	E.db["unitframe"]["units"]["party"]["debuffs"]["anchorPoint"] = "LEFT"
	E.db["unitframe"]["units"]["party"]["debuffs"]["perrow"] = 2
	E.db["unitframe"]["units"]["party"]["debuffs"]["countFont"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["party"]["debuffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["party"]["rdebuffs"]["font"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["party"]["rdebuffs"]["fontOutline"] = "SHADOWOUTLINE"
	E.db["unitframe"]["units"]["party"]["rdebuffs"]["size"] = 20
	E.db["unitframe"]["units"]["party"]["rdebuffs"]["yOffset"] = 12
	E.db["unitframe"]["units"]["party"]["buffIndicator"]["size"] = 10
	E.db["unitframe"]["units"]["party"]["buffIndicator"]["fontSize"] = 11
	E.db["unitframe"]["units"]["party"]["orientation"] = "MIDDLE"
	E.db["unitframe"]["units"]["party"]["verticalSpacing"] = 1
	E.db["unitframe"]["units"]["party"]["roleIcon"]["enable"] = true
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
	E.db["unitframe"]["units"]["party"]["power"]["enable"] = true
	E.db["unitframe"]["units"]["party"]["power"]["height"] = 4
	E.db["unitframe"]["units"]["party"]["power"]["position"] = "BOTTOMRIGHT"
	E.db["unitframe"]["units"]["party"]["power"]["text_format"] = ""
	E.db["unitframe"]["units"]["party"]["power"]["yOffset"] = 2
	E.db["unitframe"]["units"]["party"]["power"]["hideonnpc"] = true
	E.db["unitframe"]["units"]["party"]["power"]["powerPrediction"] = true
	E.db["unitframe"]["units"]["party"]["power"]["onlyHealer"] = true

	if layout == "gradient" then
		E.db["unitframe"]["units"]["party"]["colorOverride"] = "USE_DEFAULT"
	elseif layout == "dark" then
		E.db["unitframe"]["units"]["party"]["colorOverride"] = "FOCE_OFF"
	end
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
	E.db["unitframe"]["units"]["party"]["buffs"]["perrow"] = 3
	E.db["unitframe"]["units"]["party"]["buffs"]["anchorPoint"] = "TOPLEFT"
	E.db["unitframe"]["units"]["party"]["buffs"]["clickThrough"] = true
	E.db["unitframe"]["units"]["party"]["buffs"]["useFilter"] = "TurtleBuffs"
	E.db["unitframe"]["units"]["party"]["buffs"]["priority"] = "TurtleBuffs"
	E.db["unitframe"]["units"]["party"]["buffs"]["noConsolidated"] = false
	E.db["unitframe"]["units"]["party"]["buffs"]["noDuration"] = false
	E.db["unitframe"]["units"]["party"]["buffs"]["yOffset"] = -15
	E.db["unitframe"]["units"]["party"]["buffs"]["xOffset"] = 2
	E.db["unitframe"]["units"]["party"]["buffs"]["countFont"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["party"]["buffs"]["countFontSize"] = 9
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
	E.db["unitframe"]["units"]["party"]["healPrediction"]["absorbStyle"] = "NORMAL"
	E.db["unitframe"]["units"]["party"]["healPrediction"]["anchorPoint"] = "BOTTOM"
	E.db["unitframe"]["units"]["party"]["healPrediction"]["height"] = -1
	E.db["unitframe"]["units"]["party"]["cutaway"]["health"]["enabled"] = true
	E.db["unitframe"]["units"]["party"]["CombatIcon"]["size"] = 12
	E.db["unitframe"]["units"]["party"]["CombatIcon"]["texture"] = "COMBAT"
	E.db["unitframe"]["units"]["party"]["CombatIcon"]["customTexture"] = ""
	E.db["unitframe"]["units"]["party"]["CombatIcon"]["anchorPoint"] = "LEFT"
	E.db["unitframe"]["units"]["party"]["CombatIcon"]["xOffset"] = 0
	E.db["unitframe"]["units"]["party"]["CombatIcon"]["yOffset"] = 10
	if E.db["unitframe"]["units"]["party"]["customTexts"] then
		E.db["unitframe"]["units"]["party"]["customTexts"] = nil
	end
	-- Delete old customTexts/ Create empty table
	E.db["unitframe"]["units"]["party"]["customTexts"] = {}
	-- Create own customTexts
	E.db["unitframe"]["units"]["party"]["customTexts"]["name1"] = {
		["font"] = I.Fonts.GothamRaid,
		["size"] = 11,
		["fontOutline"] = "SHADOWOUTLINE",
		["justifyH"] = "CENTER",
		["yOffset"] = 0,
		["xOffset"] = 0,
		["attachTextTo"] = "Frame",
		["text_format"] = "[name:gradient]",
	}
	E.db["unitframe"]["units"]["party"]["customTexts"]["Status"] = {
		["font"] = I.Fonts.GothamRaid,
		["justifyH"] = "CENTER",
		["fontOutline"] = "SHADOWOUTLINE",
		["xOffset"] = 0,
		["yOffset"] = -12,
		["size"] = 9,
		["attachTextTo"] = "Frame",
		["text_format"] = "[statustimer]",
	}

	E.db["unitframe"]["units"]["party"]["power"]["displayAltPower"] = true

	-- Assist
	E.db["unitframe"]["units"]["assist"]["enable"] = false

	-- Tank
	E.db["unitframe"]["units"]["tank"]["enable"] = false

	-- Pet
	E.db["unitframe"]["units"]["pet"]["aurabar"]["enable"] = false
	E.db["unitframe"]["units"]["pet"]["castbar"]["enable"] = true
	E.db["unitframe"]["units"]["pet"]["castbar"]["latency"] = true
	E.db["unitframe"]["units"]["pet"]["castbar"]["width"] = 75
	E.db["unitframe"]["units"]["pet"]["castbar"]["height"] = 10
	E.db["unitframe"]["units"]["pet"]["castbar"]["insideInfoPanel"] = true
	E.db["unitframe"]["units"]["pet"]["buffs"]["enable"] = true
	E.db["unitframe"]["units"]["pet"]["buffs"]["countFont"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["pet"]["buffs"]["countFontSize"] = 8
	E.db["unitframe"]["units"]["pet"]["debuffs"]["fontSize"] = 10
	E.db["unitframe"]["units"]["pet"]["debuffs"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["pet"]["debuffs"]["sizeOverride"] = 0
	E.db["unitframe"]["units"]["pet"]["debuffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["debuffs"]["yOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["debuffs"]["perrow"] = 5
	E.db["unitframe"]["units"]["pet"]["debuffs"]["anchorPoint"] = "TOPLEFT"
	E.db["unitframe"]["units"]["pet"]["debuffs"]["countFont"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["pet"]["debuffs"]["countFontSize"] = 8
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
	E.db["unitframe"]["units"]["pet"]["name"]["text_format"] = "[namecolor][name:short]"
	E.db["unitframe"]["units"]["pet"]["name"]["xOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["name"]["yOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["width"] = 75
	E.db["unitframe"]["units"]["pet"]["height"] = 20
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
	E.db["unitframe"]["units"]["boss"]["debuffs"]["enable"] = true
	E.db["unitframe"]["units"]["boss"]["debuffs"]["sizeOverride"] = 32
	E.db["unitframe"]["units"]["boss"]["debuffs"]["yOffset"] = 0
	E.db["unitframe"]["units"]["boss"]["debuffs"]["anchorPoint"] = "RIGHT"
	E.db["unitframe"]["units"]["boss"]["debuffs"]["xOffset"] = 2
	E.db["unitframe"]["units"]["boss"]["debuffs"]["perrow"] = 4
	E.db["unitframe"]["units"]["boss"]["debuffs"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["boss"]["debuffs"]["countFont"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["boss"]["debuffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["boss"]["threatStyle"] = "HEALTHBORDER"
	E.db["unitframe"]["units"]["boss"]["castbar"]["enable"] = true
	E.db["unitframe"]["units"]["boss"]["castbar"]["insideInfoPanel"] = false
	E.db["unitframe"]["units"]["boss"]["castbar"]["width"] = 156
	E.db["unitframe"]["units"]["boss"]["castbar"]["height"] = 18
	E.db["unitframe"]["units"]["boss"]["castbar"]["timeToHold"] = 0.8
	E.db["unitframe"]["units"]["boss"]["infoPanel"]["enable"] = true
	E.db["unitframe"]["units"]["boss"]["infoPanel"]["height"] = 15
	E.db["unitframe"]["units"]["boss"]["infoPanel"]["transparent"] = true
	if not E.db["unitframe"]["units"]["boss"]["customTexts"] then
		E.db["unitframe"]["units"]["boss"]["customTexts"] = {}
	end
	-- Delete old customTexts/ Create empty table
	E.db["unitframe"]["units"]["boss"]["customTexts"] = {}
	if E.db["unitframe"]["units"]["boss"]["customTexts"]["Class"] then
		E.db["unitframe"]["units"]["boss"]["customTexts"]["Class"] = nil
	end

	-- Create own customTexts
	E.db["unitframe"]["units"]["boss"]["customTexts"]["BigName"] = {
		["attachTextTo"] = "Frame",
		["font"] = I.Fonts.Primary,
		["justifyH"] = "LEFT",
		["fontOutline"] = "SHADOWOUTLINE",
		["xOffset"] = 0,
		["size"] = 11,
		["text_format"] = "[name:gradient]",
		["yOffset"] = 18,
	}
	E.db["unitframe"]["units"]["boss"]["customTexts"]["Life"] = {
		["attachTextTo"] = "Health",
		["font"] = I.Fonts.Primary,
		["justifyH"] = "LEFT",
		["fontOutline"] = "SHADOWOUTLINE",
		["xOffset"] = 0,
		["size"] = 14,
		["text_format"] = "[health:current:shortvalue]",
		["yOffset"] = 0,
	}
	E.db["unitframe"]["units"]["boss"]["customTexts"]["Percent"] = {
		["attachTextTo"] = "Health",
		["font"] = I.Fonts.Primary,
		["justifyH"] = "RIGHT",
		["fontOutline"] = "SHADOWOUTLINE",
		["xOffset"] = 0,
		["size"] = 14,
		["text_format"] = "[perhp<%]",
		["yOffset"] = 0,
	}
	E.db["unitframe"]["units"]["boss"]["power"]["xOffset"] = 0
	E.db["unitframe"]["units"]["boss"]["power"]["attachTextTo"] = "Power"
	E.db["unitframe"]["units"]["boss"]["power"]["height"] = 9
	E.db["unitframe"]["units"]["boss"]["power"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["boss"]["power"]["text_format"] = "[power:current:shortvalue]"
	E.db["unitframe"]["units"]["boss"]["power"]["hideonnpc"] = true
	E.db["unitframe"]["units"]["boss"]["power"]["powerPrediction"] = true
	E.db["unitframe"]["units"]["boss"]["power"]["onlyHealer"] = true
	E.db["unitframe"]["units"]["boss"]["growthDirection"] = "DOWN"
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
	E.db["unitframe"]["units"]["boss"]["buffs"]["enable"] = true
	E.db["unitframe"]["units"]["boss"]["buffs"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["boss"]["buffs"]["xOffset"] = -2
	E.db["unitframe"]["units"]["boss"]["buffs"]["yOffset"] = 0
	E.db["unitframe"]["units"]["boss"]["buffs"]["sizeOverride"] = 32
	E.db["unitframe"]["units"]["boss"]["buffs"]["anchorPoint"] = "LEFT"
	E.db["unitframe"]["units"]["boss"]["buffs"]["countFont"] = I.Fonts.Primary
	E.db["unitframe"]["units"]["boss"]["buffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["boss"]["buffs"]["perrow"] = 4
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
	E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-244,209"
	E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,89"
	E.db["movers"]["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,209"
	E.db["movers"]["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,230"
	E.db["movers"]["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,244,209"
	E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,244,188"
	E.db["movers"]["ElvUF_FocusMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-518,293"
	E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-518,273"
	E.db["movers"]["ElvUF_FocusTargetMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-513,277"
	E.db["movers"]["ElvUF_Raid1Mover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,215"
	E.db["movers"]["ElvUF_Raid2Mover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,215"
	E.db["movers"]["ElvUF_Raid3Mover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,215"
	E.db["movers"]["ElvUF_PartyMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,268,326"
	E.db["movers"]["ElvUF_AssistMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,2,571"
	E.db["movers"]["ElvUF_TankMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,2,626"
	E.db["movers"]["ArenaHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-305,-305"
	E.db["movers"]["BossHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-305,-305"
	E.db["movers"]["ElvUF_RaidpetMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,0,808"

	if E:IsAddOnEnabled("ElvUI_mMediaTag") then
		E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-510,188"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,510,188"
		E.db["movers"]["ElvUF_PetCastbarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,510,177"
	else
		E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-540,209"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,540,209"
		E.db["movers"]["ElvUF_PetCastbarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,540,200"
	end

	E:StaggeredUpdateAll(nil, true)

	PluginInstallStepComplete.message = MER.Title .. L["UnitFrames Set"]
	PluginInstallStepComplete:Show()
end

function MER:SetupDts()
	--[[----------------------------------
	--	ProfileDB - Datatexts
	--]]
	----------------------------------
	E.db["datatexts"]["font"] = I.Fonts.Primary
	E.db["datatexts"]["fontSize"] = 10
	E.db["datatexts"]["fontOutline"] = "SHADOWOUTLINE"
	E.global["datatexts"]["settings"]["Gold"]["goldCoins"] = false

	E.db["chat"]["RightChatDataPanelAnchor"] = "ABOVE_CHAT"
	E.db["chat"]["LeftChatDataPanelAnchor"] = "ABOVE_CHAT"

	E.db["datatexts"]["panels"]["MinimapPanel"] = {
		enable = true,
		backdrop = true,
		border = true,
		panelTransparency = true,
		numPoints = 2,
		"DurabilityItemLevel",
		"Gold",
	}
	if E:IsAddOnEnabled("ElvUI_mMediaTag") then
		E.db["datatexts"]["panels"]["MER_TopPanel"] = {
			[1] = "mTeleports",
			[2] = "",
			[3] = "",
			["battleground"] = false,
			["enable"] = true,
		}
		E.db["movers"]["DTPanelMER_TopPanelMover"] = "TOP,ElvUIParent,TOP,0,0"

		E.global["datatexts"]["customPanels"]["MER_TopPanel"] = {
			["fonts"] = {
				["enable"] = true,
				["font"] = "- Expressway",
				["fontSize"] = 10,
				["fontOutline"] = "SHADOWOUTLINE",
			},
			["height"] = 20,
			["numPoints"] = 1,
			["backdrop"] = false,
			["name"] = "MER_TopPanel",
		}
	end

	E.db["datatexts"]["panels"]["RightChatDataPanel"]["enable"] = false
	E.db["datatexts"]["panels"]["LeftChatDataPanel"]["enable"] = false

	E:StaggeredUpdateAll(nil, true)

	PluginInstallStepComplete.message = MER.Title .. L["DataTexts Set"]
	PluginInstallStepComplete:Show()
end

local addonNames = {}
local profilesFailed =
	format("|cff00c0fa%s |r", L["MerathilisUI didn't find any supported addons for profile creation"])

function MER:DeveloperSettings()
	if not F.IsDeveloper() then
		return
	end

	-- CVars
	SetCVar("taintLog", 1)
	SetCVar("LowLatencyMode", 3)
	SetCVar("maxFPS", 165)
	SetCVar("maxFPSBk", 60)
	SetCVar("maxFPSLoading", 30)
	SetCVar("violenceLevel", 5)
	SetCVar("blockTrades", 0)
	SetCVar("blockChannelInvites", 1)
	SetCVar("RAIDweatherDensity", 0)
	SetCVar("CameraReduceUnexpectedMovement", 1)
	SetCVar("DisableAdvancedFlyingVelocityVFX", 1)
	SetCVar("disableServerNagle", 0)
	SetCVar("displaySpellActivationOverlays", 0)
	SetCVar("empowerTapControls", 1)
	SetCVar("weatherDensity", 0)
	SetCVar("SpellQueueWindow", 180)
	SetCVar("floatingCombatTextCombatDamageDirectionalScale", 1)
	SetCVar("autoOpenLootHistory", 1)
	SetCVar("showTutorials", 0)
	SetCVar("showNPETutorials", 0)
	SetCVar("hideAdventureJournalAlerts", 1)
	SetCVar("uiScale", E:PixelBestSize())

	-- General
	E.global["general"]["UIScale"] = E:PixelBestSize()
	E.private["general"]["chatBubbles"] = "nobackdrop"
	E.db["general"]["cropIcon"] = 0
	E.db["general"]["autoRepair"] = "GUILD"
	E.db["tooltip"]["showElvUIUsers"] = true
	E.db["mui"]["blizzard"]["objectiveTracker"]["title"]["size"] = 12
	E.db["mui"]["blizzard"]["objectiveTracker"]["info"]["size"] = 11
	E.db["mui"]["misc"]["cursor"]["enable"] = true
	E.db["mui"]["misc"]["automation"]["enable"] = true
	E.db["mui"]["misc"]["automation"]["hideBagAfterEnteringCombat"] = true
	E.db["mui"]["maps"]["superTracker"]["noLimit"] = true
	E.db["mui"]["pvp"]["duels"]["regular"] = true
	E.db["mui"]["pvp"]["duels"]["pet"] = true
	E.db["mui"]["pvp"]["duels"]["announce"] = true
	E.private["mui"]["skins"]["shadowOverlay"] = true
	E.db["mui"]["unitframes"]["gcd"]["enable"] = true
	E.db["mui"]["unitframes"]["healPrediction"]["enable"] = true
	E.db["mui"]["tooltip"]["gradientName"] = true
	E.db["mui"]["nameHover"]["gradient"] = true
	E.db["mui"]["scale"]["enable"] = true
	E.db["mui"]["scale"]["talents"]["scale"] = 0.9
	E.db["mui"]["armory"]["stats"]["itemLevelFont"]["itemLevelFontColor"] = "GRADIENT"

	-- Rectangle Settings
	E.db["mui"]["maps"]["rectangleMinimap"]["enable"] = true
	E.db["mui"]["maps"]["rectangleMinimap"]["heightPercentage"] = 0.65
	E.db["general"]["minimap"]["clusterDisable"] = false
	E.db["general"]["minimap"]["size"] = 222
	E.db["mui"]["smb"]["buttonSize"] = 23
	E.db["mui"]["smb"]["buttonsPerRow"] = 9
	E.db["general"]["minimap"]["icons"]["classHall"]["scale"] = 0.5
	E.db["general"]["minimap"]["icons"]["classHall"]["xOffset"] = 0
	E.db["general"]["minimap"]["icons"]["classHall"]["yOffset"] = 85
	E.db["general"]["minimap"]["icons"]["classHall"]["position"] = "BOTTOMLEFT"
	E.db["movers"]["MinimapMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-25"
	E.db["movers"]["BuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-235,-17"
	E.db["movers"]["DebuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-229,-167"
	E.db["movers"]["MER_MinimapButtonBarAnchor"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-5,-210"

	-- Chat
	E.db["chat"]["timeStampFormat"] = "%H:%M "
	E.db["mui"]["chat"]["chatText"]["gradientName"] = true

	-- VehicleBar
	E.db["mui"]["vehicleBar"]["enable"] = true

	-- Unitframe Tags
	E.db["unitframe"]["units"]["raid1"]["customTexts"]["Elv"] = {
		["font"] = I.Fonts.Primary,
		["justifyH"] = "RIGHT",
		["fontOutline"] = "SHADOWOUTLINE",
		["xOffset"] = 0,
		["yOffset"] = 0,
		["size"] = 9,
		["attachTextTo"] = "Frame",
		["text_format"] = "[users:elvui]",
	}
	E.db["unitframe"]["units"]["raid2"]["customTexts"]["Elv"] = {
		["font"] = I.Fonts.Primary,
		["justifyH"] = "RIGHT",
		["fontOutline"] = "SHADOWOUTLINE",
		["xOffset"] = 0,
		["yOffset"] = 0,
		["size"] = 9,
		["attachTextTo"] = "Frame",
		["text_format"] = "[users:elvui]",
	}
	E.db["unitframe"]["units"]["raid3"]["customTexts"]["Elv"] = {
		["font"] = I.Fonts.Primary,
		["justifyH"] = "RIGHT",
		["fontOutline"] = "SHADOWOUTLINE",
		["xOffset"] = 0,
		["yOffset"] = 0,
		["size"] = 9,
		["attachTextTo"] = "Frame",
		["text_format"] = "[users:elvui]",
	}
	E.db["unitframe"]["units"]["party"]["customTexts"]["Elv"] = {
		["font"] = I.Fonts.Primary,
		["justifyH"] = "RIGHT",
		["fontOutline"] = "SHADOWOUTLINE",
		["xOffset"] = 0,
		["yOffset"] = 0,
		["size"] = 9,
		["attachTextTo"] = "Frame",
		["text_format"] = "[users:elvui]",
	}

	if E.myclass == "WARRIOR" then
		E.db["mui"]["unitframes"]["power"]["type"] = "CUSTOM"
		E.db["mui"]["unitframes"]["power"]["model"] = 840943
	end

	PluginInstallStepComplete.message = MER.Title .. L["Developer Settings Done"]
	PluginInstallStepComplete:Show()

	E:StaggeredUpdateAll(nil, true)
end

local function CreateNewProfile(name)
	if strtrim(name) == "" then
		return
	end

	if E.data:IsDualSpecEnabled() then
		E.data:SetDualSpecProfile(name)
	else
		E.data:SetProfile(name)
	end

	PluginInstallStepComplete.message = MER.Title .. L["Profile Created"]
	PluginInstallStepComplete:Show()
end

function MER:ProfileDialog()
	local textInfo = "Name for the new profile"
	local errorInfo = "Note: A profile with that name already exists"
	local dialogName = "MER_CreateNewProfile"

	E.PopupDialogs[dialogName] = {
		text = textInfo,
		timeout = 0,
		hasEditBox = 1,
		whileDead = 1,
		hideOnEscape = 1,
		editBoxWidth = 350,
		maxLetters = 127,
		OnShow = function(frame)
			frame.editBox:SetAutoFocus(false)
			frame.editBox:SetText(I.ProfileNames.Default)
			frame.editBox:HighlightText()
		end,
		button1 = OKAY,
		button2 = CANCEL,
		OnAccept = function(frame)
			CreateNewProfile(frame.editBox:GetText())
		end,
		EditBoxOnEnterPressed = function(editBox)
			CreateNewProfile(editBox:GetText())
			editBox:GetParent():Hide()
		end,
		EditBoxOnEscapePressed = function(editBox)
			editBox:GetParent():Hide()
		end,
		EditBoxOnTextChanged = function(editBox)
			if strtrim(editBox:GetText()) == "" then
				editBox:GetParent().button1:Disable()
			else
				editBox:GetParent().button1:Enable()

				local parent = editBox:GetParent()
				local textObj = _G[parent:GetName() .. "Text"]

				local profs = E.data:GetProfiles()
				for _, name in ipairs(profs) do
					if name == editBox:GetText() then
						textObj:SetText(textInfo .. "\n\n" .. F.String.Warning(errorInfo))

						parent.maxHeightSoFar = 0
						E:StaticPopup_Resize(parent, dialogName)
						return
					end
				end

				textObj:SetText(textInfo)

				parent.maxHeightSoFar = 0
				E:StaticPopup_Resize(parent, dialogName)
			end
		end,
		OnEditFocusGained = function(editBox)
			editBox:HighlightText()
		end,
	}

	E:StaticPopup_Show(dialogName)
end

function MER:InstallAdditions(installType, mode, null)
	if not PluginInstallFrame.installpreview then
		PluginInstallFrame.installpreview = PluginInstallFrame:CreateTexture(nil, "OVERLAY")
	end
	PluginInstallFrame.installpreview:SetInside(PluginInstallFrame, 5, 28)

	if null then
		PluginInstallFrame.Option1:SetScript("OnEnter", nil)
		PluginInstallFrame.Option1:SetScript("OnLeave", nil)
		PluginInstallFrame.Option2:SetScript("OnEnter", nil)
		PluginInstallFrame.Option2:SetScript("OnLeave", nil)
		PluginInstallFrame.Option3:SetScript("OnEnter", nil)
		PluginInstallFrame.Option3:SetScript("OnLeave", nil)
		PluginInstallFrame.Option4:SetScript("OnEnter", nil)
		PluginInstallFrame.Option4:SetScript("OnLeave", nil)
	end

	if mode == "ENTERING" then
		UIFrameFadeIn(PluginInstallFrame.installpreview, 0.5, 0, 1)
		UIFrameFadeOut(PluginInstallTutorialImage, 0.5, 1, 0)
		UIFrameFadeOut(PluginInstallFrame.Desc1, 0.5, 1, 0)
		UIFrameFadeOut(PluginInstallFrame.Desc2, 0.5, 1, 0)
		UIFrameFadeOut(PluginInstallFrame.Desc3, 0.5, 1, 0)
		UIFrameFadeOut(PluginInstallFrame.Desc4, 0.5, 1, 0)
		UIFrameFadeOut(PluginInstallFrame.SubTitle, 0.5, 1, 0)
	elseif mode == "LEAVING" then
		UIFrameFadeOut(PluginInstallFrame.installpreview, 0.5, 1, 0)
		UIFrameFadeIn(PluginInstallTutorialImage, 0.5, 0, 1)
		UIFrameFadeIn(PluginInstallFrame.Desc1, 0.5, 0, 1)
		UIFrameFadeIn(PluginInstallFrame.Desc2, 0.5, 0, 1)
		UIFrameFadeIn(PluginInstallFrame.Desc3, 0.5, 0, 1)
		UIFrameFadeIn(PluginInstallFrame.Desc4, 0.5, 0, 1)
		UIFrameFadeIn(PluginInstallFrame.SubTitle, 0.5, 0, 1)
	end

	if installType == "dark" then
		PluginInstallFrame.installpreview:SetTexture(I.General.MediaPath .. "Textures\\Install\\Dark.tga")
	elseif installType == "gradient" then
		PluginInstallFrame.installpreview:SetTexture(I.General.MediaPath .. "Textures\\Install\\Gradient.tga")
	end
end

function MER:Resize(firstPage, lastPage)
	PluginInstallFrame:SetSize(860, 512)
	if E.db.mui.core and E.db.mui.core.installed == nil then
		PluginInstallFrame:SetScale(1.25)
	end
	PluginInstallFrame.Desc1:ClearAllPoints()
	PluginInstallFrame.Desc1:SetPoint("TOP", PluginInstallFrame.SubTitle, "BOTTOM", 0, -30)

	if not PluginInstallFrame.peepo then
		PluginInstallFrame.peepo = PluginInstallFrame:CreateTexture(nil, "OVERLAY")
	end
	PluginInstallFrame.peepo:SetPoint("BOTTOM", PluginInstallTutorialImage, "TOP", 0, -20)

	if firstPage then
		PluginInstallFrame.peepo:SetTexture(I.Media.Textures.PepoOkaygeL)
	elseif lastPage then
		PluginInstallFrame.peepo:SetTexture(I.Media.Textures.PepoStrongge)
	else
		PluginInstallFrame.peepo:SetTexture()
	end
end

-- ElvUI PlugIn installer
MER.installTable = {
	["Name"] = MER.Title,
	["Title"] = L["|cffff7d0aMerathilisUI|r Installation"],
	["tutorialImage"] = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\merathilis_logo.tga]],
	["tutorialImageSize"] = { 256, 128 },
	["tutorialImagePoint"] = { 0, 30 },
	["Pages"] = {
		[1] = function()
			MER:Resize(true)
			-- MER:InstallAdditions()

			if PluginInstallFrame then
				PluginInstallFrame:HookScript("OnShow", function()
					if PluginInstallFrame.Title then
						if PluginInstallFrame.Title:GetText() ~= "|cffff7d0aMerathilisUI|r Installation" then
							MER:InstallAdditions()(nil, nil, true) -- Don't use the addition on other Plugins
						end
					end
				end)
			end

			PluginInstallFrame.SubTitle:SetFormattedText(
				L["Welcome to MerathilisUI |cff00c0faVersion|r %s, for ElvUI %s."],
				MER.Version,
				E.version
			)
			PluginInstallFrame.Desc1:SetText(
				L["By pressing the Continue button, MerathilisUI will be applied in your current ElvUI installation.\r\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"]
			)
			PluginInstallFrame.Desc2:SetText(L["Please press the continue button to go onto the next step."])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				InstallComplete()
			end)
			PluginInstallFrame.Option1:SetScript("OnEnter", nil)
			PluginInstallFrame.Option1:SetScript("OnLeave", nil)
			PluginInstallFrame.Option1:SetText(L["Skip Process"])
		end,
		[2] = function()
			MER:Resize(nil)

			PluginInstallFrame.SubTitle:SetText(L["Profile Settings Setup"])
			PluginInstallFrame.Desc1:SetText(L["Please click the button below to setup your Profile Settings."])
			PluginInstallFrame.Desc2:SetText(L["New Profile will create a fresh profile for this character."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cff07D400High|r"])
			PluginInstallFrame.Desc4:SetText(
				L["Your current Profile is: "] .. F.String.Warning(E.data:GetCurrentProfile())
			)
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				MER:ProfileDialog()
			end)
			PluginInstallFrame.Option1:SetScript("OnEnter", nil)
			PluginInstallFrame.Option1:SetScript("OnLeave", nil)
			PluginInstallFrame.Option1:SetText(L["New Profile"])

			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", PI.NextPage)

			PluginInstallFrame.Option2:SetScript("OnEnter", nil)
			PluginInstallFrame.Option2:SetScript("OnLeave", nil)
			PluginInstallFrame.Option2:SetText(L["Keep Current"])
		end,
		[3] = function()
			MER:Resize(nil)

			PluginInstallFrame.SubTitle:SetText(L["Layout"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation changes the default ElvUI look."])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to apply the new layout."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cff07D400High|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				MER:SetupLayout()
			end)
			PluginInstallFrame.Option1:SetScript("OnEnter", nil)
			PluginInstallFrame.Option1:SetScript("OnLeave", nil)
			PluginInstallFrame.Option1:SetText(L["General Layout"])
		end,
		[4] = function()
			MER:Resize(nil)

			PluginInstallFrame.SubTitle:SetText(L["CVars"])
			PluginInstallFrame.Desc1:SetFormattedText(
				L["This step changes a few World of Warcraft default options. These options are tailored to the needs of the author of %s and are not necessary for this edit to function."],
				MER.Title
			)
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to setup your CVars."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cffFF0000Low|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				SetupCVars()
			end)
			PluginInstallFrame.Option1:SetScript("OnEnter", nil)
			PluginInstallFrame.Option1:SetScript("OnLeave", nil)
			PluginInstallFrame.Option1:SetText(L["CVars"])
		end,
		[5] = function()
			MER:Resize(nil)

			PluginInstallFrame.SubTitle:SetText(L["Chat"])
			PluginInstallFrame.Desc1:SetText(
				L["This part of the installation process sets up your chat fonts and colors."]
			)
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to setup your chat windows."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				SetupChat()
			end)
			PluginInstallFrame.Option1:SetScript("OnEnter", nil)
			PluginInstallFrame.Option1:SetScript("OnLeave", nil)
			PluginInstallFrame.Option1:SetText(L["Setup Chat"])
		end,
		[6] = function()
			MER:Resize(nil)

			PluginInstallFrame.SubTitle:SetText(L["DataTexts"])
			PluginInstallFrame.Desc1:SetText(
				L["This part of the installation process will fill MerathilisUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"]
			)
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to setup your datatexts."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				MER:SetupDts()
			end)
			PluginInstallFrame.Option1:SetScript("OnEnter", nil)
			PluginInstallFrame.Option1:SetScript("OnLeave", nil)
			PluginInstallFrame.Option1:SetText(L["Setup Datatexts"])
		end,
		[7] = function()
			MER:Resize(nil)

			PluginInstallFrame.SubTitle:SetText(L["ActionBars"])
			PluginInstallFrame.Desc1:SetText(
				L["This part of the installation process will reposition your Actionbars and will enable backdrops"]
			)
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to setup your actionbars."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cff07D400High|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				MER:SetupActionbars()
			end)
			PluginInstallFrame.Option1:SetScript("OnEnter", nil)
			PluginInstallFrame.Option1:SetScript("OnLeave", nil)
			PluginInstallFrame.Option1:SetText(L["Setup ActionBars"])
		end,
		[8] = function()
			MER:Resize(nil)

			PluginInstallFrame.SubTitle:SetText(L["NamePlates"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process will change your NamePlates."])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to setup your NamePlates."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cff07D400High|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				MER:SetupNamePlates()
			end)
			PluginInstallFrame.Option1:SetScript("OnEnter", nil)
			PluginInstallFrame.Option1:SetScript("OnLeave", nil)
			PluginInstallFrame.Option1:SetText(L["Setup NamePlates"])
		end,
		[9] = function()
			MER:Resize(nil)

			PluginInstallFrame.SubTitle:SetText(L["UnitFrames"])
			PluginInstallFrame.Desc1:SetText(
				L["This part of the installation process will reposition your Unitframes."]
			)
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to setup your Unitframes."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cff07D400High|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				MER:SetupUnitframes("gradient")
			end)
			PluginInstallFrame.Option1:SetScript("OnEnter", function()
				MER:InstallAdditions("gradient", "ENTERING")
			end)
			PluginInstallFrame.Option1:SetScript("OnLeave", function()
				MER:InstallAdditions(nil, "LEAVING")
			end)
			PluginInstallFrame.Option1:SetText(L["Gradient Layout"])

			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function()
				MER:SetupUnitframes("dark")
			end)
			PluginInstallFrame.Option2:SetScript("OnEnter", function()
				MER:InstallAdditions("dark", "ENTERING")
			end)
			PluginInstallFrame.Option2:SetScript("OnLeave", function()
				MER:InstallAdditions(nil, "LEAVING")
			end)
			PluginInstallFrame.Option2:SetText(L["Dark Layout"])
		end,
		[10] = function()
			MER:Resize(nil)

			PluginInstallFrame.SubTitle:SetText(L["Plugins"])
			PluginInstallFrame.Desc1:SetText(
				L["This part of the installation process will apply changes to ElvUI Plugins"]
			)
			PluginInstallFrame.Desc2:SetText(
				"Currently supported AddOns: "
					.. F.String.FCT()
					.. ", "
					.. F.String.AS()
					.. ", "
					.. "|CFF6559F1m|r|CFFA037E9M|r|CFFDD14E0T|r - |CFF6559F1m|r|CFF7A4DEFM|r|CFF8845ECe|r|CFFA037E9d|r|CFFA435E8i|r|CFFB32DE6a|r|CFFBC26E5T|r|CFFCB1EE3a|r|CFFDD14E0g|r |CFFFF006C&|r |CFFFF4C00T|r|CFFFF7300o|r|CFFFF9300o|r|CFFFFA800l|r|CFFFFC900s|r"
			)
			if
				not E:IsAddOnEnabled("ElvUI_mMediaTag")
				and not E:IsAddOnEnabled("AddonSkins")
				and not E:IsAddOnEnabled("ElvUI_FCT")
			then
				PluginInstallFrame.Desc3:SetText(
					F.String.Warning("Warning: ")
						.. "Looks like you don't have any of the extra AddOns installed. Don't worry, you can still fully experience "
						.. MER.Title
						.. "!"
				)
			else
				PluginInstallFrame.Option1:Show()
				PluginInstallFrame.Option1:SetScript("OnClick", function()
					PF:ApplyFCTProfile()
				end)
				PluginInstallFrame.Option1:SetScript("OnEnter", nil)
				PluginInstallFrame.Option1:SetScript("OnLeave", nil)
				PluginInstallFrame.Option1:SetText(F.String.FCT())

				PluginInstallFrame.Option2:Show()
				PluginInstallFrame.Option2:SetScript("OnClick", function()
					PF:ApplyAddOnSkinsProfile()
				end)
				PluginInstallFrame.Option2:SetScript("OnEnter", nil)
				PluginInstallFrame.Option2:SetScript("OnLeave", nil)
				PluginInstallFrame.Option2:SetText(F.String.AS())

				PluginInstallFrame.Option3:Show()
				PluginInstallFrame.Option3:SetScript("OnClick", function()
					PF:ApplymMediaTagProfile()
				end)
				PluginInstallFrame.Option3:SetScript("OnEnter", nil)
				PluginInstallFrame.Option3:SetScript("OnLeave", nil)
				PluginInstallFrame.Option3:SetText(
					"|CFF6559F1m|r|CFF7A4DEFM|r|CFF8845ECe|r|CFFA037E9d|r|CFFA435E8i|r|CFFB32DE6a|r|CFFBC26E5T|r|CFFCB1EE3a|r|CFFDD14E0g|r"
				)
			end
		end,
		[11] = function()
			MER:Resize(nil)

			if E:IsAddOnEnabled("BigWigs") then
				PluginInstallFrame.SubTitle:SetText(F.String.BigWigs(L["BigWigs"]))
				PluginInstallFrame.Desc1:SetText(
					"BigWigs is a boss encounter AddOn. It consists of many individual encounter scripts, or boss modules; mini AddOns that are designed to trigger alert messages, timer bars, sounds, and so forth, for one specific raid encounter."
				)
				PluginInstallFrame.Desc2:SetText("Importance: " .. F.String.Good("Low"))

				PluginInstallFrame.Option1:Show()
				PluginInstallFrame.Option1:SetScript("OnClick", function()
					PF:ApplyBigWigsProfile()
				end)
				PluginInstallFrame.Option1:SetScript("OnEnter", nil)
				PluginInstallFrame.Option1:SetScript("OnLeave", nil)
				PluginInstallFrame.Option1:SetText("BigWigs")
			else
				PluginInstallFrame.SubTitle:SetText(F.String.BigWigs("BigWigs"))

				PluginInstallFrame.Desc1:SetText(
					F.String.Warning("Oops, looks like you don't have " .. F.String.BigWigs("BigWigs") .. " installed!")
				)
				PluginInstallFrame.Desc2:SetText(
					"If you're a new player, we recommend installing " .. F.String.BigWigs("BigWigs") .. "!"
				)
			end
		end,
		[12] = function()
			MER:Resize(nil)

			if E:IsAddOnEnabled("Details") then
				PluginInstallFrame.SubTitle:SetText(F.String.Details(L["Details"]))
				PluginInstallFrame.Desc1:SetText(
					"Details is a versatile AddOn that offers a wide array of data, encompassing metrics for damage, healing, and various other performance indicators."
				)
				PluginInstallFrame.Desc2:SetText(
					"This is an optional AddOn requirement, but we highly recommend you install it."
				)
				PluginInstallFrame.Desc3:SetText("Importance: " .. F.String.Error("High"))

				PluginInstallFrame.Option1:Show()
				PluginInstallFrame.Option1:SetScript("OnClick", function()
					PF:ApplyDetailsProfile()
				end)
				PluginInstallFrame.Option1:SetScript("OnEnter", nil)
				PluginInstallFrame.Option1:SetScript("OnLeave", nil)
				PluginInstallFrame.Option1:SetText(L["Details"])
			else
				PluginInstallFrame.Desc1:SetText(
					F.String.Warning("Oops, looks like you don't have " .. F.String.Details() .. " installed!")
				)
				PluginInstallFrame.Desc2:SetText("Please install Details and restart the installer!")
			end
		end,
		[13] = function()
			MER:Resize(nil)

			if E:IsAddOnEnabled("OmniCD") then
				PluginInstallFrame.SubTitle:SetText(F.String.OmniCD(L["OmniCD"]))
				PluginInstallFrame.Desc1:SetText("OmnicCD lightweight addon to track party cooldowns.")

				PluginInstallFrame.Option1:Show()
				PluginInstallFrame.Option1:SetScript("OnClick", function()
					PF:ApplyOmniCDProfile()
				end)
				PluginInstallFrame.Option1:SetScript("OnEnter", nil)
				PluginInstallFrame.Option1:SetScript("OnLeave", nil)
				PluginInstallFrame.Option1:SetText(L["OmniCD"])
			else
				PluginInstallFrame.Desc1:SetText(
					F.String.Warning("Oops, looks like you don't have " .. F.String.OmniCD() .. " installed!")
				)
				PluginInstallFrame.Desc2:SetText("Please install OmniCD and restart the installer!")
			end
		end,
		[14] = function()
			MER:Resize(nil, true)

			PluginInstallFrame.SubTitle:SetText(L["Installation Complete"])
			PluginInstallFrame.Desc1:SetText(
				L["You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org."]
			)
			PluginInstallFrame.Desc2:SetText(
				L["Please click the button below so you can setup variables and ReloadUI."]
			)
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://discord.gg/28We6esE9v")
			end)
			PluginInstallFrame.Option1:SetScript("OnEnter", nil)
			PluginInstallFrame.Option1:SetScript("OnLeave", nil)
			PluginInstallFrame.Option1:SetText(
				L["|TInterface\\Addons\\ElvUI_MerathilisUI\\Media\\Icons\\Discord.tga:18:18:0:0:64:64|t |cffff7d0aMerathilisUI|r Discord"]
			)

			if F.IsDeveloper() then
				PluginInstallFrame.Option2:Hide()
			else
				PluginInstallFrame.Option2:Show()
				PluginInstallFrame.Option2:SetScript("OnClick", function()
					InstallComplete(true)
				end)
				PluginInstallFrame.Option2:SetScript("OnEnter", nil)
				PluginInstallFrame.Option2:SetScript("OnLeave", nil)
				PluginInstallFrame.Option2:SetText(L["Finished"])
			end

			if InstallStepComplete then
				InstallStepComplete.message = MER.Title .. L["Installed"]
				InstallStepComplete:Show()
			end
		end,
		[F.IsDeveloper() and 15] = function()
			MER:Resize(nil)

			PluginInstallFrame.SubTitle:SetText(L["Developer Settings"])
			PluginInstallFrame.Desc1:SetText(L["Importance: |cffD3CF00Medium|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				MER:DeveloperSettings()
			end)
			PluginInstallFrame.Option1:SetScript("OnEnter", nil)
			PluginInstallFrame.Option1:SetScript("OnLeave", nil)
			PluginInstallFrame.Option1:SetText(L["Setup Developer Settings"])

			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function()
				InstallComplete(true)
			end)
			PluginInstallFrame.Option2:SetScript("OnEnter", nil)
			PluginInstallFrame.Option2:SetScript("OnLeave", nil)
			PluginInstallFrame.Option2:SetText(L["Finished"])
		end,
	},

	["StepTitles"] = {
		[1] = START,
		[2] = L["Profile"],
		[3] = L["Layout"],
		[4] = L["CVars"],
		[5] = L["Chat"],
		[6] = L["DataTexts"],
		[7] = L["ActionBars"],
		[8] = L["NamePlates"],
		[9] = L["UnitFrames"],
		[10] = L["Plugins"],
		[11] = L["BigWigs"],
		[12] = L["Details"],
		[13] = L["OmniCD"],
		[14] = L["Installation Complete"],
		[F.IsDeveloper() and 15] = L["Developer Settings"],
	},
	StepTitlesColor = { 1, 1, 1 },
	StepTitlesColorSelected = E.myclass == "PRIEST" and E.PriestColors or RAID_CLASS_COLORS[E.myclass],
	StepTitleWidth = 200,
	StepTitleButtonWidth = 180,
	StepTitleTextJustification = "CENTER",
}
