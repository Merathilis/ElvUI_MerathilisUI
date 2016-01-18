local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
-- GLOBALS: SkadaDB, xCTSavedDB
local _G = _G
local unpack = unpack
local print = print
local format = format
local ceil = ceil

local IsAddOnLoaded = IsAddOnLoaded
local PlaySoundFile = PlaySoundFile
local UIFrameFadeOut = UIFrameFadeOut
local ReloadUI = ReloadUI
local CreateFrame = CreateFrame
local ChangeChatColor = ChangeChatColor
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local FCF_GetChatWindowInfo = FCF_GetChatWindowInfo
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local FCF_DockFrame, FCF_UnDockFrame = FCF_DockFrame, FCF_UnDockFrame
local FCF_SetLocked = FCF_SetLocked
local FCF_SavePositionAndDimensions = FCF_SavePositionAndDimensions
local FCF_StopDragging = FCF_StopDragging
local CONTINUE, PREVIOUS, ADDONS = CONTINUE, PREVIOUS, ADDONS
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
local LOOT, TRADE = LOOT, TRADE
local ToggleChatColorNamesByClassGroup = ToggleChatColorNamesByClassGroup
local LeftChatToggleButton = LeftChatToggleButton

local CURRENT_PAGE = 0
local MAX_PAGE = 5
local titleText = {}

local _, class = UnitClass("player")
local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
local factionGroup = UnitFactionGroup("player")

local function SetMoverPosition(mover, point, anchor, secondaryPoint, x, y)
	if not _G[mover] then return end
	local frame = _G[mover]
	
	frame:ClearAllPoints()
	frame:SetPoint(point, anchor, secondaryPoint, x, y)
	E:SaveMoverPosition(mover)
end

function E:GetColor(r, b, g, a)	
	return { r = r, b = b, g = g, a = a }
end

-- local functions must go up
local function SetupMERLayout(layout)
	local classColor = RAID_CLASS_COLORS[E.myclass]
	if not IsAddOnLoaded('ElvUI_BenikUI') then
		E:StaticPopup_Show('BENIKUI')
	end
	
	do
		-- General
		E.private.general.pixelPerfect = true
		E.global.general.autoScale = true
		E.private.general.chatBubbles = 'nobackdrop'
		E.private.general.chatBubbleFont = 'Merathilis Prototype'
		E.db.general.valuecolor = {r = color.r, g = color.g, b = color.b}
		E.db.general.totems.size = 36
		E.db.general.font = 'Merathilis Prototype'
		E.db.general.fontSize = 10
		E.db.general.interruptAnnounce = 'RAID'
		E.db.general.autoRepair = 'GUILD'
		E.db.general.minimap.size = 130
		E.db.general.loginmessage = false
		E.db.general.stickyFrames = false
		E.db.general.loot = true
		E.db.general.lootRoll = true
		E.db.general.backdropcolor.r = 0.101
		E.db.general.backdropcolor.g = 0.101
		E.db.general.backdropcolor.b = 0.101
		E.db.general.vendorGrays = true
		E.db.general.bottomPanel = false
		E.db.general.bonusObjectivePosition = 'AUTO'
		E.global.general.smallerWorldMap = false
		E.db.general.backdropfadecolor.r = 0.0549
		E.db.general.backdropfadecolor.g = 0.0549
		E.db.general.backdropfadecolor.b = 0.0549
		E.private.general.namefont = 'Merathilis Prototype'
		E.private.general.dmgfont = 'ElvUI Combat'
		E.private.general.normTex = 'MerathilisFlat'
		E.private.general.glossTex = 'MerathilisFlat'
		E.db.general.experience.enable = true
		E.db.general.experience.mouseover = false
		E.db.general.experience.height = 140
		E.db.general.experience.textSize = 10
		E.db.general.experience.width = 12
		E.db.general.experience.textFormat = 'NONE'
		E.db.general.experience.orientation = 'VERTICAL'
		E.db.general.reputation.enable = true
		E.db.general.reputation.mouseover = false
		E.db.general.reputation.height = 140
		E.db.general.reputation.textSize = 10
		E.db.general.reputation.width = 12
		E.db.general.reputation.textFormat = 'NONE'
		E.db.general.reputation.orientation = 'VERTICAL'
		if IsAddOnLoaded('ElvUI_BenikUI') then
			E.db.datatexts.leftChatPanel = false
			E.db.datatexts.rightChatPanel = false
			E.db.datatexts.minimapPanels = false
			E.db.datatexts.actionbar3 = false
			E.db.datatexts.actionbar5 = false
		else
			E.db.datatexts.leftChatPanel = true
			E.db.datatexts.rightChatPanel = true
			E.db.datatexts.minimapPanels = true
			E.db.datatexts.actionbar3 = true
			E.db.datatexts.actionbar5 = true
		end
		E.db.datatexts.time24 = true
		E.db.datatexts.goldCoins = true
		E.db.datatexts.noCombatHover = true
	end
	
	do
		-- Actionbars
		E.db.actionbar.font = 'Merathilis Prototype'
		E.db.actionbar.fontOutline = 'OUTLINE'
		E.db.actionbar.macrotext = true
		E.db.actionbar.showGrid = false
		if IsAddOnLoaded("Masque") then
			E.private.actionbar.masque.stanceBar = true
			E.private.actionbar.masque.petBar = true
			E.private.actionbar.masque.actionbars = true
		end
		
		E.db.actionbar.bar1.buttonspacing = 4
		E.db.actionbar.bar1.backdrop = true
		E.db.actionbar.bar1.heightMult = 2
		E.db.actionbar.bar1.buttonsize = 28
		E.db.actionbar.bar1.buttons = 12
		
		E.db.actionbar.bar2.enabled = true
		E.db.actionbar.bar2.buttonspacing = 4
		E.db.actionbar.bar2.buttons = 12
		E.db.actionbar.bar2.buttonsize = 28
		E.db.actionbar.bar2.backdrop = false
		E.db.actionbar.bar2.visibility = '[vehicleui][overridebar][petbattle][possessbar] hide; show'
		E.db.actionbar.bar2.mouseover = false
		
		E.db.actionbar.bar3.backdrop = true
		E.db.actionbar.bar3.buttonsPerRow = 2
		E.db.actionbar.bar3.buttonsize = 22
		E.db.actionbar.bar3.buttonspacing = 4
		E.db.actionbar.bar3.buttons = 12
		E.db.actionbar.bar3.point = 'TOPLEFT'
		
		E.db.actionbar.bar4.buttonspacing = 4
		E.db.actionbar.bar4.mouseover = true
		E.db.actionbar.bar4.buttonsize = 24
		
		E.db.actionbar.bar5.backdrop = true
		E.db.actionbar.bar5.buttonsPerRow = 2
		E.db.actionbar.bar5.buttonsize = 22
		E.db.actionbar.bar5.buttonspacing = 4
		E.db.actionbar.bar5.buttons = 12
		
		E.db.actionbar.bar6.enabled = true
		E.db.actionbar.bar6.backdrop = true
		E.db.actionbar.bar6.buttonsPerRow = 1
		E.db.actionbar.bar6.buttonspacing = 1
		E.db.actionbar.bar6.mouseover = true
		E.db.actionbar.bar6.buttons = 4
		E.db.actionbar.bar6.buttonsize = 28
		E.db.actionbar.bar6.point = 'TOPLEFT'
		
		E.db.actionbar.barPet.point = 'BOTTOMLEFT'
		E.db.actionbar.barPet.buttons = 8
		E.db.actionbar.barPet.buttonspacing = 1
		E.db.actionbar.barPet.buttonsPerRow = 1
		E.db.actionbar.barPet.buttonsize = 19
		
		E.db.actionbar.stanceBar.point = 'BOTTOMLEFT'
		E.db.actionbar.stanceBar.backdrop = true
		E.db.actionbar.stanceBar.buttonsPerRow = 6
		E.db.actionbar.stanceBar.buttonsize = 20
		
		E.db.actionbar.extraActionButton.scale = 0.75
	end
	
	do
		-- Auras
		if IsAddOnLoaded("Masque") then
			E.private.auras.masque.consolidatedBuffs = true
			E.private.auras.masque.buffs = true
			E.private.auras.masque.debuffs = true
		end
		E.db.auras.debuffs.size = 30
		E.db.auras.fadeThreshold = 10
		E.db.auras.font = 'Merathilis Prototype'
		E.db.auras.fontOutline = 'OUTLINE'
		E.db.auras.consolidatedBuffs.fontSize = 11
		E.db.auras.consolidatedBuffs.font = 'Merathilis Visitor1'
		E.db.auras.consolidatedBuffs.fontOutline = 'OUTLINE'
		E.db.auras.consolidatedBuffs.filter = false
		E.db.auras.buffs.fontSize = 12
		E.db.auras.buffs.horizontalSpacing = 10
		E.db.auras.buffs.verticalSpacing = 15
		E.db.auras.buffs.size = 24
		E.db.auras.buffs.wrapAfter = 10
		E.db.auras.debuffs.horizontalSpacing = 5
		E.db.auras.debuffs.size = 30
	end
	
	do
		-- Bags
		E.db.bags.itemLevelFont = 'Merathilis Prototype'
		E.db.bags.itemLevelFontSize = 8
		E.db.bags.itemLevelFontOutline = 'OUTLINE'
		E.db.bags.countFont = 'Merathilis Prototype'
		E.db.bags.countFontSize = 10
		E.db.bags.countFontOutline = 'OUTLINE'
		E.db.bags.yOffsetBank = 235
		E.db.bags.yOffsetBags = 235
		E.db.bags.bagSize = 23
		E.db.bags.alignToChat = false
		E.db.bags.bagWidth = 350
		E.db.bags.bankSize = 23
		E.db.bags.bankWidth = 350
		E.db.bags.moneyFormat = 'BLIZZARD'
		E.db.bags.itemLevelThreshold = 650
	end
	
	do
		-- Chat
		E.db.chat.keywordSound = 'Whisper Alert'
		E.db.chat.tabFont = 'Merathilis Roadway'
		E.db.chat.tabFontOutline = 'OUTLINE'
		E.db.chat.tabFontSize = 14
		E.db.chat.panelTabTransparency = true
		E.db.chat.fontOutline = 'OUTLINE'
		E.db.chat.chatHistory = false
		E.db.chat.font = 'Merathilis Expressway'
		E.db.chat.panelWidth = 350
		E.db.chat.panelHeight = 140
		E.db.chat.editBoxPosition = 'ABOVE_CHAT'
		E.db.chat.panelBackdrop = 'SHOWBOTH'
		E.db.chat.keywords = '%MYNAME%, ElvUI'
		E.db.chat.timeStampFormat = '%H:%M '
		if IsAddOnLoaded ("ElvUI_SLE") then
			E.db.chat.panelBackdropNameRight = 'Interface\\AddOns\\MerathilisUI\\media\\textures\\chatTextures\\nightsky.tga'
			E.db.sle.chat.textureAlpha.enable = true
			E.db.sle.chat.textureAlpha.alpha = 0.25
		else
			if factionGroup == "Alliance" then
				E.db.chat.panelBackdropNameRight = 'Interface\\AddOns\\MerathilisUI\\media\\textures\\chatTextures\\alliance.tga'
			else
				E.db.chat.panelBackdropNameRight = 'Interface\\AddOns\\MerathilisUI\\media\\textures\\chatTextures\\horde.tga'
			end
		end
	end
	
	do
		-- Nameplates
		E.db.nameplate.font = 'Merathilis Roadway'
		E.db.nameplate.fontSize = 11
		E.db.nameplate.fontOutline = 'OUTLINE'
		E.db.nameplate.debuffs.font = 'Merathilis Prototype'
		E.db.nameplate.debuffs.fontSize = 9
		E.db.nameplate.debuffs.fontOutline = 'OUTLINE'
		E.db.nameplate.auraFontOutline = 'OUTLINE'
		E.db.nameplate.maxAuras = 5
		E.db.nameplate.comboPoints = true
		E.db.nameplate.sortDirection = 1
		E.db.nameplate.colorByTime = true
		E.db.nameplate.buffs.font = 'Merathilis Prototype'
		E.db.nameplate.buffs.fontSize = 7
		E.db.nameplate.buffs.fontOutline = 'OUTLINE'
		E.db.nameplate.healthBar.text.enable = true
		E.db.nameplate.healthBar.text.format = 'CURRENT_PERCENT'
		E.db.nameplate.healthBar.height = 4
		E.db.nameplate.healthBar.colorByRaidIcon = true
		E.db.nameplate.healthBar.lowHPScale.enable = true
		E.db.nameplate.healthBar.width = 100
		E.db.nameplate.auraFont = 'ElvUI Font'
		E.db.nameplate.healthtext = 'CURRENT_PERCENT'
		E.db.nameplate.auraAnchor = 1
		E.db.nameplate.targetIndicator.color.g = 0
		E.db.nameplate.targetIndicator.color.b = 0
		E.db.nameplate.wrapName = true
		E.db.nameplate.buffs.fontOutline = 'OUTLINE'
		E.db.nameplate.buffs.font = 'Merathilis Prototype'
	end
	
	do
		-- Tooltip
		E.db.tooltip.font = 'Merathilis Expressway'
		E.db.tooltip.fontOutline = 'OUTLINE'
		E.db.tooltip.combathide = true
		E.db.tooltip.style = 'inset'
		E.db.tooltip.itemCount = 'NONE'
		E.db.tooltip.headerFontSize = 12
		E.db.tooltip.textFontSize = 11
		E.db.tooltip.smallTextFontSize = 11
		E.db.tooltip.healthBar.font = 'Merathilis Prototype'
		E.db.tooltip.healthBar.fontSize = 10
		E.db.tooltip.healthBar.fontOutline = 'OUTLINE'
		E.db.tooltip.healthBar.height = 5
	end
	
	do
		-- Unitframes
		E.db.unitframe.font = 'Merathilis Tukui'
		E.db.unitframe.fontSize = 12
		E.db.unitframe.fontOutline = 'OUTLINE'
		E.db.unitframe.smoothbars = true
		E.db.unitframe.statusbar = 'MerathilisFlat'
		E.db.unitframe.colors.powerclass = true
		E.db.unitframe.colors.castColor.r = 0.1
		E.db.unitframe.colors.castColor.g = 0.1
		E.db.unitframe.colors.castColor.b = 0.1
		E.db.unitframe.colors.transparentHealth = false
		E.db.unitframe.colors.transparentAurabars = true
		E.db.unitframe.colors.transparentPower = false
		E.db.unitframe.colors.transparentCastbar = true
		E.db.unitframe.colors.health.r = 0.23
		E.db.unitframe.colors.health.g = 0.23
		E.db.unitframe.colors.health.b = 0.23
		E.db.unitframe.colors.power.MANA = E:GetColor(classColor.r, classColor.b, classColor.g)
		E.db.unitframe.colors.power.RAGE = E:GetColor(classColor.r, classColor.b, classColor.g)
		E.db.unitframe.colors.power.FOCUS = E:GetColor(classColor.r, classColor.b, classColor.g)
		E.db.unitframe.colors.power.ENERGY = E:GetColor(classColor.r, classColor.b, classColor.g)
		E.db.unitframe.colors.power.RUNIC_POWER = E:GetColor(classColor.r, classColor.b, classColor.g)
		if IsAddOnLoaded("ElvUI_BenikUI") then
			E.db.ufb.detachPlayerPortrait = false
			E.db.ufb.detachTargetPortrait = false
		end
		-- Player
		E.db.unitframe.units.player.width = 180
		E.db.unitframe.units.player.height = 25
		E.db.unitframe.units.player.debuffs.fontSize = 11
		E.db.unitframe.units.player.debuffs.attachTo = 'FRAME'
		E.db.unitframe.units.player.debuffs.sizeOverride = 25
		E.db.unitframe.units.player.debuffs.xOffset = -3
		E.db.unitframe.units.player.debuffs.yOffset = 25
		E.db.unitframe.units.player.debuffs.perrow = 4
		E.db.unitframe.units.player.debuffs.anchorPoint = 'LEFT'
		E.db.unitframe.units.player.portrait.enable = true
		E.db.unitframe.units.player.portrait.overlay = false
		E.db.unitframe.units.player.portrait.camDistanceScale = 1
		E.db.unitframe.units.player.portrait.width = 0
		-- Use Classbar not for Druid, because of Balance PowerTracker
		if E.myclass == "PALADIN" or E.myclass == "DEATHKNIGHT" or E.myclass == "WARLOCK" or E.myclass == "PRIEST" or E.myclass == "MONK" then
			E.db.unitframe.units.player.classbar.enable = true
			E.db.unitframe.units.player.classbar.detachFromFrame = true
			E.db.unitframe.units.player.classbar.xOffset = 110
			E.db.unitframe.units.player.classbar.detachedWidth = 135
			E.db.unitframe.units.player.classbar.fill = 'spaced'
		else
			E.db.unitframe.units.player.classbar.enable = false
		end
		E.db.unitframe.units.player.aurabar.enable = false
		E.db.unitframe.units.player.threatStyle = 'ICONTOPRIGHT'
		E.db.unitframe.units.player.castbar.icon = true
		E.db.unitframe.units.player.castbar.width = 180
		E.db.unitframe.units.player.castbar.height = 15
		E.db.unitframe.units.player.customTexts = {}
		E.db.unitframe.units.player.customTexts.Gesundheit = {}
		E.db.unitframe.units.player.customTexts.Gesundheit.font = 'Merathilis Tukui'
		E.db.unitframe.units.player.customTexts.Gesundheit.justifyH = 'LEFT'
		E.db.unitframe.units.player.customTexts.Gesundheit.fontOutline = 'OUTLINE'
		E.db.unitframe.units.player.customTexts.Gesundheit.xOffset = 2
		E.db.unitframe.units.player.customTexts.Gesundheit.yOffset = 1
		E.db.unitframe.units.player.customTexts.Gesundheit.text_format = '[name:medium] [difficultycolor][smartlevel] [shortclassification]'
		E.db.unitframe.units.player.customTexts.Gesundheit.size = 20
		E.db.unitframe.units.player.health.xOffset = -2
		E.db.unitframe.units.player.health.yOffset = -21
		E.db.unitframe.units.player.health.text_format = '[healthcolor][health:percent_short] - [health:current]'
		E.db.unitframe.units.player.power.xOffset = 5
		E.db.unitframe.units.player.power.yOffset = -21
		E.db.unitframe.units.player.power.height = 2
		E.db.unitframe.units.player.power.hideonnpc = true
		E.db.unitframe.units.player.power.detachFromFrame = false
		E.db.unitframe.units.player.buffs.enable = false
		if IsAddOnLoaded("ElvUI_BenikUI") then
			E.db.ufb.detachPlayerPortrait = true
			E.db.ufb.getPlayerPortraitSize = false
			E.db.ufb.PlayerPortraitWidth = 92
			E.db.ufb.PlayerPortraitHeight = 39
			E.db.ufb.PlayerPortraitShadow = true
		end
		-- Target
		E.db.unitframe.units.target.width = 180
		E.db.unitframe.units.target.height = 25
		E.db.unitframe.units.target.castbar.latency = true
		E.db.unitframe.units.target.castbar.width = 180
		E.db.unitframe.units.target.castbar.height = 15
		E.db.unitframe.units.target.debuffs.sizeOverride = 25
		E.db.unitframe.units.target.debuffs.yOffset = 5
		E.db.unitframe.units.target.debuffs.xOffset = 0
		E.db.unitframe.units.target.debuffs.anchorPoint = 'LEFT'
		E.db.unitframe.units.target.debuffs.perrow = 4
		E.db.unitframe.units.target.debuffs.attachTo = 'FRAME'
		E.db.unitframe.units.target.aurabar.enable = false
		E.db.unitframe.units.target.aurabar.attachTo = 'BUFFS'
		E.db.unitframe.units.target.name.xOffset = 8
		E.db.unitframe.units.target.name.yOffset = -32
		E.db.unitframe.units.target.name.position = 'RIGHT'
		E.db.unitframe.units.target.name.text_format = ''
		E.db.unitframe.units.target.threatStyle = 'ICONTOPLEFT'
		E.db.unitframe.units.target.power.xOffset = -2
		E.db.unitframe.units.target.power.yOffset = -21
		E.db.unitframe.units.target.power.detachFromFrame = false
		E.db.unitframe.units.target.power.hideonnpc = false
		E.db.unitframe.units.target.power.height = 2
		E.db.unitframe.units.target.customTexts = {}
		E.db.unitframe.units.target.customTexts.Gesundheit = {}
		E.db.unitframe.units.target.customTexts.Gesundheit.font = 'Merathilis Tukui'
		E.db.unitframe.units.target.customTexts.Gesundheit.justifyH = 'RIGHT'
		E.db.unitframe.units.target.customTexts.Gesundheit.fontOutline = 'OUTLINE'
		E.db.unitframe.units.target.customTexts.Gesundheit.xOffset = 9
		E.db.unitframe.units.target.customTexts.Gesundheit.size = 20
		E.db.unitframe.units.target.customTexts.Gesundheit.text_format = '[name:short] [difficultycolor][smartlevel] [shortclassification]'
		E.db.unitframe.units.target.customTexts.Gesundheit.yOffset = 1
		E.db.unitframe.units.target.customTexts.Name1 = {}
		E.db.unitframe.units.target.customTexts.Name1.font = 'Merathilis Tukui'
		E.db.unitframe.units.target.customTexts.Name1.justifyH = 'LEFT'
		E.db.unitframe.units.target.customTexts.Name1.fontOutline = 'OUTLINE'
		E.db.unitframe.units.target.customTexts.Name1.xOffset = 1
		E.db.unitframe.units.target.customTexts.Name1.size = 14
		E.db.unitframe.units.target.customTexts.Name1.text_format = '[powercolor][smartclass] [difficultycolor][level]'
		E.db.unitframe.units.target.customTexts.Name1.yOffset = 0
		E.db.unitframe.units.target.health.xOffset = 5
		E.db.unitframe.units.target.health.text_format = '[healthcolor][health:current] - [health:percent_short]'
		E.db.unitframe.units.target.health.yOffset = -21
		E.db.unitframe.units.target.portrait.enable = true
		E.db.unitframe.units.target.portrait.width = 0
		E.db.unitframe.units.target.portrait.camDistanceScale = 1
		E.db.unitframe.units.target.buffs.enable = true
		E.db.unitframe.units.target.buffs.xOffset = 2
		E.db.unitframe.units.target.buffs.sizeOverride = 20
		E.db.unitframe.units.target.buffs.perrow = 11
		E.db.unitframe.units.target.buffs.fontSize = 12
		if IsAddOnLoaded ("ElvUI_BenikUI") then
			E.db.ufb.detachTargetPortrait = true
			E.db.ufb.TargetPortraitWidth = 92
			E.db.ufb.TargetPortraitHeight = 39
			E.db.ufb.TargetPortraitShadow = true
		end
		-- TargetTarget
		E.db.unitframe.units.targettarget.debuffs.enable = true
		E.db.unitframe.units.targettarget.power.position = 'CENTER'
		E.db.unitframe.units.targettarget.power.height = 3
		E.db.unitframe.units.targettarget.width = 100
		E.db.unitframe.units.targettarget.name.yOffset = -1
		E.db.unitframe.units.targettarget.height = 20
		E.db.unitframe.units.targettarget.health.text_format = ""
		-- Focus
		E.db.unitframe.units.focus.power.height = 2
		E.db.unitframe.units.focus.width = 122
		E.db.unitframe.units.focus.height = 20
		E.db.unitframe.units.focus.castbar.height = 6
		E.db.unitframe.units.focus.castbar.width = 122
		-- FocusTarget
		E.db.unitframe.units.focustarget.debuffs.enable = true
		E.db.unitframe.units.focustarget.debuffs.anchorPoint = 'TOPRIGHT'
		E.db.unitframe.units.focustarget.threatStyle = 'GLOW'
		E.db.unitframe.units.focustarget.power.enable = true
		E.db.unitframe.units.focustarget.power.height = 2
		E.db.unitframe.units.focustarget.width = 122
		E.db.unitframe.units.focustarget.enable = true
		E.db.unitframe.units.focustarget.height = 20
		-- Raid
		E.db.unitframe.units.raid.threatStyle = 'GLOW'
		E.db.unitframe.units.raid.horizontalSpacing = 1
		E.db.unitframe.units.raid.verticalSpacing = 25
		E.db.unitframe.units.raid.debuffs.fontSize = 12
		E.db.unitframe.units.raid.debuffs.enable = true
		E.db.unitframe.units.raid.debuffs.yOffset = -5
		E.db.unitframe.units.raid.debuffs.anchorPoint = 'TOPRIGHT'
		E.db.unitframe.units.raid.debuffs.sizeOverride = 20
		E.db.unitframe.units.raid.rdebuffs.fontSize = 12
		E.db.unitframe.units.raid.numGroups = 4
		E.db.unitframe.units.raid.growthDirection = 'RIGHT_UP'
		E.db.unitframe.units.raid.colorOverride = 'FORCE_ON'
		E.db.unitframe.units.raid.name.xOffset = 2
		E.db.unitframe.units.raid.name.yOffset = -20
		E.db.unitframe.units.raid.name.text_format = '[namecolor][name:medium]'
		E.db.unitframe.units.raid.name.position = 'BOTTOM'
		E.db.unitframe.units.raid.buffIndicator.fontSize = 11
		E.db.unitframe.units.raid.buffIndicator.size = 10
		E.db.unitframe.units.raid.roleIcon.size = 12
		E.db.unitframe.units.raid.roleIcon.position = 'BOTTOMRIGHT'
		E.db.unitframe.units.raid.power.enable = true
		E.db.unitframe.units.raid.power.position = 'CENTER'
		E.db.unitframe.units.raid.power.height = 2
		E.db.unitframe.units.raid.healthPrediction = true
		E.db.unitframe.units.raid.width = 69
		E.db.unitframe.units.raid.groupBy = 'ROLE'
		E.db.unitframe.units.raid.health.frequentUpdates = true
		E.db.unitframe.units.raid.health.position = 'CENTER'
		E.db.unitframe.units.raid.health.text_format = '[healthcolor][health:deficit]'
		E.db.unitframe.units.raid.buffs.enable = true
		E.db.unitframe.units.raid.buffs.yOffset = 0
		E.db.unitframe.units.raid.buffs.anchorPoint = 'CENTER'
		E.db.unitframe.units.raid.buffs.clickTrough = true
		E.db.unitframe.units.raid.buffs.useBlacklist = false
		E.db.unitframe.units.raid.buffs.noDuration = false
		E.db.unitframe.units.raid.buffs.playerOnly = false
		E.db.unitframe.units.raid.buffs.perrow = 1
		E.db.unitframe.units.raid.buffs.useFilter = 'TurtleBuffs'
		E.db.unitframe.units.raid.buffs.noConsolidated = false
		E.db.unitframe.units.raid.buffs.sizeOverride = 20
		E.db.unitframe.units.raid.buffs.xOffset = 0
		E.db.unitframe.units.raid.height = 25
		E.db.unitframe.units.raid.raidicon.attachTo = 'LEFT'
		E.db.unitframe.units.raid.raidicon.xOffset = 9
		E.db.unitframe.units.raid.raidicon.size = 13
		E.db.unitframe.units.raid.raidicon.yOffset = 0
		E.db.unitframe.units.raid.customTexts = {}
		E.db.unitframe.units.raid.customTexts.Status = {}
		E.db.unitframe.units.raid.customTexts.Status.font = 'Merathilis Tukui'
		E.db.unitframe.units.raid.customTexts.Status.justifyH = 'CENTER'
		E.db.unitframe.units.raid.customTexts.Status.fontOutline = 'OUTLINE'
		E.db.unitframe.units.raid.customTexts.Status.xOffset = 0
		E.db.unitframe.units.raid.customTexts.Status.yOffset = 0
		E.db.unitframe.units.raid.customTexts.Status.size = 10
		E.db.unitframe.units.raid.customTexts.Status.text_format = '[namecolor][statustimer]'
		if IsAddOnLoaded("ElvUI_BenikUI") then
			E.db.unitframe.units.raid.emptybar.enable = true
			E.db.unitframe.units.raid.emptybar.threat = true
			E.db.unitframe.units.raid.emptybar.height = 15
			E.db.unitframe.units.raid.emptybar.transparent = true
			E.db.unitframe.units.raid.classHover = true
		end
		-- Raid40
		E.db.unitframe.units.raid40.horizontalSpacing = 1
		E.db.unitframe.units.raid40.debuffs.enable = true
		E.db.unitframe.units.raid40.debuffs.yOffset = -9
		E.db.unitframe.units.raid40.debuffs.anchorPoint = 'TOPRIGHT'
		E.db.unitframe.units.raid40.debuffs.clickTrough = true
		E.db.unitframe.units.raid40.debuffs.useBlacklist = false
		E.db.unitframe.units.raid40.debuffs.perrow = 2
		E.db.unitframe.units.raid40.debuffs.useFilter = 'Whitlist (Strict)'
		E.db.unitframe.units.raid40.debuffs.sizeOverride = 21
		E.db.unitframe.units.raid40.debuffs.xOffset = -4
		E.db.unitframe.units.raid40.rdebuffs.size = 26
		E.db.unitframe.units.raid40.growthDirection = 'RIGHT_UP'
		E.db.unitframe.units.raid40.name.position = 'TOP'
		E.db.unitframe.units.raid40.groupBy = 'ROLE'
		E.db.unitframe.units.raid40.roleIcon.position = 'RIGHT'
		E.db.unitframe.units.raid40.roleIcon.enable = true
		E.db.unitframe.units.raid40.raidWideSorting = false
		E.db.unitframe.units.raid40.power.enable = true
		E.db.unitframe.units.raid40.power.position = 'CENTER'
		E.db.unitframe.units.raid40.power.height = 2
		E.db.unitframe.units.raid40.customTexts = {}
		E.db.unitframe.units.raid40.customTexts.HealthText = {}
		E.db.unitframe.units.raid40.customTexts.HealthText.font = 'Merathilis Tukui'
		E.db.unitframe.units.raid40.customTexts.HealthText.justifyH = 'CENTER'
		E.db.unitframe.units.raid40.customTexts.HealthText.fontOutline = 'OUTLINE'
		E.db.unitframe.units.raid40.customTexts.HealthText.xOffset = 0
		E.db.unitframe.units.raid40.customTexts.HealthText.yOffset = -7
		E.db.unitframe.units.raid40.customTexts.HealthText.text_format = '[healthcolor][health:deficit]'
		E.db.unitframe.units.raid40.customTexts.HealthText.size = 10
		E.db.unitframe.units.raid40.healPrediction = true
		E.db.unitframe.units.raid40.width = 69
		E.db.unitframe.units.raid40.positionOverride = 'BOTTOMRIGHT'
		E.db.unitframe.units.raid40.health.frequentUpdates = true
		E.db.unitframe.units.raid40.buffs.enable = true
		E.db.unitframe.units.raid40.buffs.yOffset = 25
		E.db.unitframe.units.raid40.buffs.anchorPoint = 'BOTTOMLEFT'
		E.db.unitframe.units.raid40.buffs.clickTrough = true
		E.db.unitframe.units.raid40.buffs.useBlacklist = false
		E.db.unitframe.units.raid40.buffs.noDuration = false
		E.db.unitframe.units.raid40.buffs.playerOnly = false
		E.db.unitframe.units.raid40.buffs.perrow = 1
		E.db.unitframe.units.raid40.buffs.useFilter = 'TurtleBuffs'
		E.db.unitframe.units.raid40.buffs.noConsolidated = false
		E.db.unitframe.units.raid40.buffs.sizeOverride = 17
		E.db.unitframe.units.raid40.buffs.xOffset = 21
		E.db.unitframe.units.raid40.height = 40
		E.db.unitframe.units.raid40.verticalSpacing = 1
		E.db.unitframe.units.raid40.raidicon.attachTo = 'LEFT'
		E.db.unitframe.units.raid40.raidicon.xOffset = 9
		E.db.unitframe.units.raid40.raidicon.size = 13
		E.db.unitframe.units.raid40.raidicon.yOffset = 0
		E.db.unitframe.units.party.portrait.enable = true
		E.db.unitframe.units.party.portrait.overlay = false
		E.db.unitframe.units.party.portrait.width = 40
		E.db.unitframe.units.party.portrait.height = 0
		E.db.unitframe.units.party.portrait.camDistanceScale = 1.2
		E.db.unitframe.units.party.portrait.style = '3D'
		E.db.unitframe.units.party.portrait.transparent = true
		-- Party
		if IsAddOnLoaded("ElvUI_BenikUI") then
			E.db.unitframe.units.party.height = 30
			E.db.unitframe.units.party.width = 200
			E.db.unitframe.units.party.growthDirection = 'UP_RIGHT'
			E.db.unitframe.units.party.debuffs.anchorPoint = 'RIGHT'
			E.db.unitframe.units.party.debuffs.sizeOverride = 24
			E.db.unitframe.units.party.debuffs.xOffset = 1
			E.db.unitframe.units.party.debuffs.yOffset = 3
			E.db.unitframe.units.party.debuffs.numrows = 2
			E.db.unitframe.units.party.debuffs.perrow = 5
			E.db.unitframe.units.party.debuffs.fontSize = 12
			E.db.unitframe.units.party.showPlayer = true
			E.db.unitframe.units.party.GPSArrow.size = 40
			E.db.unitframe.units.party.health.position = 'RIGHT'
			E.db.unitframe.units.party.health.text_format = '[healthcolor][health:percent] - [health:current]'
			E.db.unitframe.units.party.health.xOffset = 2
			E.db.unitframe.units.party.health.yOffset = -24
			E.db.unitframe.units.party.name.text_format = ''
			E.db.unitframe.units.party.name.position = 'BOTTOM'
			E.db.unitframe.units.party.roleIcon.enable = true
			E.db.unitframe.units.party.roleIcon.tank = true
			E.db.unitframe.units.party.roleIcon.healer = true
			E.db.unitframe.units.party.roleIcon.damager = true
			E.db.unitframe.units.party.roleIcon.size = 12
			E.db.unitframe.units.party.roleIcon.xOffset = 0
			E.db.unitframe.units.party.roleIcon.yOffset = 0
			E.db.unitframe.units.party.roleIcon.position = 'TOPRIGHT'
			E.db.unitframe.units.party.raidRoleIcons.position = 'TOPRIGHT'
			E.db.unitframe.units.party.customTexts = {}
			E.db.unitframe.units.party.customTexts.HealthText = {}
			E.db.unitframe.units.party.customTexts.HealthText.font = 'Merathilis Tukui'
			E.db.unitframe.units.party.customTexts.HealthText.justifyH = 'CENTER'
			E.db.unitframe.units.party.customTexts.HealthText.fontOutline = 'OUTLINE'
			E.db.unitframe.units.party.customTexts.HealthText.xOffset = 20
			E.db.unitframe.units.party.customTexts.HealthText.yOffset = 15
			E.db.unitframe.units.party.customTexts.HealthText.text_format = '[healthcolor][health:deficit]'
			E.db.unitframe.units.party.customTexts.HealthText.size = 10
			E.db.unitframe.units.party.customTexts.LevelClass = {}
			E.db.unitframe.units.party.customTexts.LevelClass.font = 'Merathilis Tukui'
			E.db.unitframe.units.party.customTexts.LevelClass.justifyH = 'LEFT'
			E.db.unitframe.units.party.customTexts.LevelClass.fontOutline = 'OUTLINE'
			E.db.unitframe.units.party.customTexts.LevelClass.xOffset = 40
			E.db.unitframe.units.party.customTexts.LevelClass.yOffset = -7
			E.db.unitframe.units.party.customTexts.LevelClass.text_format = '[difficultycolor][level] [race] [namecolor][class]'
			E.db.unitframe.units.party.customTexts.LevelClass.size = 11
			E.db.unitframe.units.party.customTexts.Gesundheit = {}
			E.db.unitframe.units.party.customTexts.Gesundheit.font = 'Merathilis Tukui'
			E.db.unitframe.units.party.customTexts.Gesundheit.justifyH = 'LEFT'
			E.db.unitframe.units.party.customTexts.Gesundheit.fontOutline = 'OUTLINE'
			E.db.unitframe.units.party.customTexts.Gesundheit.xOffset = 40
			E.db.unitframe.units.party.customTexts.Gesundheit.yOffset = 6
			E.db.unitframe.units.party.customTexts.Gesundheit.text_format = '[name:medium] [difficultycolor][smartlevel] [shortclassification]'
			E.db.unitframe.units.party.customTexts.Gesundheit.size = 19
			E.db.unitframe.units.party.verticalSpacing = 25
			E.db.unitframe.units.party.horizontalSpacing = 1
			E.db.unitframe.units.party.raidicon.attachTo = 'LEFT'
			E.db.unitframe.units.party.raidicon.xOffset = 9
			E.db.unitframe.units.party.raidicon.size = 13
			E.db.unitframe.units.party.raidicon.yOffset = 0
			E.db.unitframe.units.party.power.text_format = '[namecolor][power:current]'
			E.db.unitframe.units.party.power.height = 2
			E.db.unitframe.units.party.power.position = 'LEFT'
			E.db.unitframe.units.party.power.yOffset = -24
			E.db.unitframe.units.party.buffs.enable = true
			E.db.unitframe.units.party.buffs.yOffset = 0
			E.db.unitframe.units.party.buffs.anchorPoint = 'CENTER'
			E.db.unitframe.units.party.buffs.clickTrough = true
			E.db.unitframe.units.party.buffs.useBlacklist = false
			E.db.unitframe.units.party.buffs.noDuration = false
			E.db.unitframe.units.party.buffs.playerOnly = false
			E.db.unitframe.units.party.buffs.perrow = 1
			E.db.unitframe.units.party.buffs.useFilter = 'TurtleBuffs'
			E.db.unitframe.units.party.buffs.noConsolidated = false
			E.db.unitframe.units.party.buffs.sizeOverride = 22
			E.db.unitframe.units.party.emptybar.enable = true
			E.db.unitframe.units.party.emptybar.height = 15
			E.db.unitframe.units.party.emptybar.transparent = false
		else
			E.db.unitframe.units.party.debuffs.fontSize = 12
			E.db.unitframe.units.party.debuffs.sizeOverride = 21
			E.db.unitframe.units.party.debuffs.yOffset = -7
			E.db.unitframe.units.party.debuffs.anchorPoint = 'TOPRIGHT'
			E.db.unitframe.units.party.debuffs.perrow = 3
			E.db.unitframe.units.party.debuffs.numrows = 1
			E.db.unitframe.units.party.targetsGroup.anchorPoint = 'BOTTOM'
			E.db.unitframe.units.party.GPSArrow.size = 40
			E.db.unitframe.units.party.customTexts = {}
			E.db.unitframe.units.party.customTexts.HealthText = {}
			E.db.unitframe.units.party.customTexts.HealthText.font = 'Merathilis Tukui'
			E.db.unitframe.units.party.customTexts.HealthText.justifyH = 'CENTER'
			E.db.unitframe.units.party.customTexts.HealthText.fontOutline = 'OUTLINE'
			E.db.unitframe.units.party.customTexts.HealthText.xOffset = 0
			E.db.unitframe.units.party.customTexts.HealthText.yOffset = 5
			E.db.unitframe.units.party.customTexts.HealthText.text_format = '[healthcolor][health:deficit]'
			E.db.unitframe.units.party.customTexts.HealthText.size = 10
			E.db.unitframe.units.party.healPrediction = true
			E.db.unitframe.units.party.name.xOffset = 2
			E.db.unitframe.units.party.name.yOffset = -20
			E.db.unitframe.units.party.name.text_format = '[namecolor][name:short] [difficultycolor][smartlevel]'
			E.db.unitframe.units.party.name.position = 'CENTER'
			E.db.unitframe.units.party.height = 40
			E.db.unitframe.units.party.verticalSpacing = 4
			E.db.unitframe.units.party.raidicon.attachTo = 'LEFT'
			E.db.unitframe.units.party.raidicon.xOffset = 9
			E.db.unitframe.units.party.raidicon.size = 13
			E.db.unitframe.units.party.raidicon.yOffset = 0
			E.db.unitframe.units.party.horizontalSpacing = 1
			E.db.unitframe.units.party.growthDirection = 'RIGHT_UP'
			E.db.unitframe.units.party.buffIndicator.size = 10
			E.db.unitframe.units.party.power.text_format = ''
			E.db.unitframe.units.party.power.height = 2
			E.db.unitframe.units.party.positionOverride = 'BOTTOM'
			E.db.unitframe.units.party.width = 69
			E.db.unitframe.units.party.groupBy = 'ROLE'
			E.db.unitframe.units.party.health.frequentUpdates = true
			E.db.unitframe.units.party.health.position = 'BOTTOM'
			E.db.unitframe.units.party.health.text_format = ''
			E.db.unitframe.units.party.petsGroup.anchorPoint = 'BOTTOM'
			E.db.unitframe.units.party.buffs.enable = true
			E.db.unitframe.units.party.buffs.yOffset = 0
			E.db.unitframe.units.party.buffs.xOffset = 0
			E.db.unitframe.units.party.buffs.anchorPoint = 'CENTER'
			E.db.unitframe.units.party.buffs.clickTrough = true
			E.db.unitframe.units.party.buffs.useBlacklist = false
			E.db.unitframe.units.party.buffs.noDuration = false
			E.db.unitframe.units.party.buffs.playerOnly = false
			E.db.unitframe.units.party.buffs.perrow = 1
			E.db.unitframe.units.party.buffs.useFilter = 'TurtleBuffs'
			E.db.unitframe.units.party.buffs.noConsolidated = false
			E.db.unitframe.units.party.buffs.sizeOverride = 22
			E.db.unitframe.units.party.portrait.enable = false
		end
		-- Assist
		E.db.unitframe.units.assist.targetsGroup.enable = false
		-- Pet
		E.db.unitframe.units.pet.castbar.latency = true
		E.db.unitframe.units.pet.castbar.width = 102
		E.db.unitframe.units.pet.width = 102
		E.db.unitframe.units.pet.height = 15
		E.db.unitframe.units.pet.power.height = 2
		-- Arena
		E.db.unitframe.units.arena.power.width = 'inset'
		-- Boss
		E.db.unitframe.units.boss.castbar.latency = true
		E.db.unitframe.units.boss.castbar.width = 156
		E.db.unitframe.units.boss.castbar.height = 12
		E.db.unitframe.units.boss.buffs.sizeOverride = 26
		E.db.unitframe.units.boss.buffs.yOffset = -1
		E.db.unitframe.units.boss.buffs.anchorPoint = 'LEFT'
		E.db.unitframe.units.boss.debuffs.anchorPoint = 'RIGHT'
		E.db.unitframe.units.boss.debuffs.yOffset = 2
		E.db.unitframe.units.boss.debuffs.perrow = 5
		E.db.unitframe.units.boss.portrait.enable = false
		E.db.unitframe.units.boss.power.height = 2
		E.db.unitframe.units.boss.power.position = 'LEFT'
		E.db.unitframe.units.boss.name.xOffset = 6
		E.db.unitframe.units.boss.name.yOffset = 16
		E.db.unitframe.units.boss.name.position = 'RIGHT'
		E.db.unitframe.units.boss.width = 156
		E.db.unitframe.units.boss.height = 26
		E.db.unitframe.units.boss.spacing = 27
		E.db.unitframe.units.boss.growthDirection = 'UP'
		E.db.unitframe.units.boss.threatStyle = 'HEALTHBORDER'
		E.db.unitframe.units.boss.health.position = 'RIGHT'
		E.db.unitframe.units.boss.health.text_format = '[healthcolor][health:current] - [health:percent]'
		-- PetTarget
		E.db.unitframe.units.pettarget.power.width = 'inset'
	end
	
	-- Movers
	if E.db.movers == nil then E.db.movers = {} end -- prevent a lua error when running the install after a profile gets deleted.
	do
		-- DPS Layout
		if layout == 'DPS' then
			-- PlayerMover
			SetMoverPosition('ElvUF_PlayerMover', 'BOTTOM', E.UIParent, 'BOTTOM', -176, 141)
			SetMoverPosition('ElvUF_PlayerCastbarMover', 'BOTTOM', E.UIParent, 'BOTTOM', -176, 108)
			SetMoverPosition('PlayerPortraitMover', 'BOTTOM', E.UIParent, 'BOTTOM', -313, 127)
			-- TargetMover
			SetMoverPosition('ElvUF_TargetMover', 'BOTTOM', E.UIParent, 'BOTTOM', 176, 141)
			SetMoverPosition('ElvUF_TargetCastbarMover', 'BOTTOM', E.UIParent, 'BOTTOM', 176, 108)
			SetMoverPosition('TargetPowerBarMover', 'BOTTOM', E.UIParent, 'BOTTOM', 203, 429)
			SetMoverPosition('TargetPortraitMover', 'BOTTOM', E.UIParent, 'BOTTOM', 313, 127)
			-- TargetTargetMover
			SetMoverPosition('ElvUF_TargetTargetMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 146)
			-- FocusMover
			SetMoverPosition('ElvUF_FocusMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -452, 199)
			SetMoverPosition('ElvUF_FocusCastbarMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -452, 222)
			-- FocusTargetMover
			SetMoverPosition('ElvUF_FocusTargetMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -452, 234)
			-- Raid/GroupMover
			if IsAddOnLoaded("ElvUI_BenikUI") then
				SetMoverPosition('ElvUF_PartyMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 2, 250)
			else
				SetMoverPosition('ElvUF_PartyMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 2, 171)
			end
			SetMoverPosition('ElvUF_RaidMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 2, 190)
			SetMoverPosition('ElvUF_Raid40Mover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 2, 171)
			SetMoverPosition('ElvUF_RaidpetMover', 'TOPLEFT', E.UIParent, 'BOTTOMLEFT', 0, 808)
			-- PetMover
			SetMoverPosition('ElvUF_PetMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 465, 199)
			SetMoverPosition('ElvUF_PetCastbarMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 114)
			-- AlertMover for Garrison etc.
			SetMoverPosition('AlertFrameMover', 'TOP', E.UIParent, 'TOP', 0, -140)
			-- ActionBarMover
			SetMoverPosition('ElvAB_1', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 27)
			SetMoverPosition('ElvAB_2', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 60)
			SetMoverPosition('ElvAB_3', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -353, 3)
			SetMoverPosition('ElvAB_4', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', 0, 367)
			SetMoverPosition('ElvAB_5', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 353, 3)
			SetMoverPosition('ElvAB_6', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', 0, 249)
			SetMoverPosition('PetAB', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 470, 4)
			SetMoverPosition('ShiftAB', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 917, 99)
			SetMoverPosition('BossButton', 'BOTTOM', E.UIParent, 'BOTTOM', -318, 32)
			-- XP/RepMover
			SetMoverPosition('ReputationBarMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -410, 23)
			SetMoverPosition('ExperienceBarMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 410, 23)
			-- TooltipMover
			SetMoverPosition('TooltipMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -34, 367)
			-- ChatMover
			SetMoverPosition('LeftChatMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 2, 23)
			SetMoverPosition('RightChatMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -2, 23)
			-- Buff/DebuffMover
			SetMoverPosition('BuffsMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -158, -6)
			SetMoverPosition('DebuffsMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -158, -115)
			-- Arena/BossMover
			SetMoverPosition('ArenaHeaderMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -150, -305)
			SetMoverPosition('BossHeaderMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 436, 260)
			-- Tank/AssistMover
			SetMoverPosition('ElvUF_TankMover', 'TOPLEFT', E.UIParent, 'BOTTOMLEFT', 2, 626)
			SetMoverPosition('ElvUF_AssistMover', 'TOPLEFT', E.UIParent, 'BOTTOMLEFT', 2, 571)
			-- MiscMover
			SetMoverPosition('ElvUF_BodyGuardMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -413, 195)
			SetMoverPosition('WatchFrameMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -122, -292)
			SetMoverPosition('Top_Center_Mover', 'BOTTOM', E.UIParent, 'BOTTOM', -250, 2)
			SetMoverPosition('VehicleSeatMover', 'TOPLEFT', E.UIParent, 'TOPLEFT', 2, -84)
			SetMoverPosition('TotemBarMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 424, 2)
			SetMoverPosition('TempEnchantMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -5, -299)
			SetMoverPosition('MicrobarMover', 'TOPLEFT', E.UIParent, 'TOPLEFT', 4, -4)
			SetMoverPosition('ClassBarMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 187)
			SetMoverPosition('DigSiteProgressBarMover', 'TOP', E.UIParent, 'TOP', -2, 0)
			SetMoverPosition('FlareMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 253)
			SetMoverPosition('LocationMover', 'TOP', E.UIParent, 'TOP', 0, -7)
			SetMoverPosition('GMMover', 'TOPLEFT', E.UIParent, 'TOPLEFT', 329, 0)
			SetMoverPosition('UIBFrameMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -44, -161)
			SetMoverPosition('BNETMover', 'TOP', E.UIParent, 'TOP', 0, -38)
			SetMoverPosition('ObjectiveFrameMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -200, -281)
			SetMoverPosition('AltPowerBarMover', 'TOP', E.UIParent, 'TOP', 1, -272)
			SetMoverPosition('Bottom_Panel_Mover', 'BOTTOM', E.UIParent, 'BOTTOM', 250, 2)
			SetMoverPosition('LossControlMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 432)
			SetMoverPosition('LootFrameMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -495, -457)
			SetMoverPosition('MinimapButtonAnchor', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -5, -231)
			SetMoverPosition('MinimapMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -5, -6)
			-- Heal Layout
		elseif layout == 'HEAL' then
			-- Raid
			E.db.unitframe.units.raid.height = 30
			E.db.unitframe.units.raid.width = 114
			E.db.unitframe.units.raid.debuffs.sizeOverride = 15
			E.db.unitframe.units.raid.debuffs.xOffset = 0
			E.db.unitframe.units.raid.name.xOffset = 2
			E.db.unitframe.units.raid.name.yOffset = -19
			E.db.unitframe.units.raid.name.text_format = '[namecolor][deficit:name]'
			E.db.unitframe.units.raid.power.height = 2
			E.db.unitframe.units.raid.roleIcon.position = 'BOTTOMRIGHT'
			E.db.unitframe.units.raid.roleIcon.size = 12
			E.db.unitframe.units.raid.roleIcon.yOffset = -18
			SetMoverPosition('ElvUF_RaidMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 674, 224)
			-- Party
			E.db.unitframe.units.party.growthDirection = 'RIGHT_UP'
			E.db.unitframe.units.party.height = 30
			E.db.unitframe.units.party.width = 114
			E.db.unitframe.units.party.showPlayer = true
			E.db.unitframe.units.party.debuffs.sizeOverride = 21
			E.db.unitframe.units.party.health.xOffset = 0
			E.db.unitframe.units.party.health.yOffset = 0
			E.db.unitframe.units.party.name.yOffset = -19
			E.db.unitframe.units.party.name.position = 'BOTTOM'
			E.db.unitframe.units.party.name.text_format = '[namecolor][deficit:name]'
			E.db.unitframe.units.party.power.height = 2
			E.db.unitframe.units.party.power.text_format = ''
			E.db.unitframe.units.party.buffs.yOffset = 0
			E.db.unitframe.units.party.buffs.xOffset = 0
			E.db.unitframe.units.party.buffs.anchorPoint = 'CENTER'
			E.db.unitframe.units.party.buffs.perrow = 1
			E.db.unitframe.units.party.debuffs.anchorPoint = 'TOPRIGHT'
			E.db.unitframe.units.party.debuffs.sizeOverride = 18
			E.db.unitframe.units.party.debuffs.yOffset = 0
			E.db.unitframe.units.party.debuffs.xOffset = 0
			E.db.unitframe.units.party.debuffs.numrows = 1
			E.db.unitframe.units.party.debuffs.perrow = 5
			E.db.unitframe.units.party.roleIcon.position = 'BOTTOMRIGHT'
			E.db.unitframe.units.party.roleIcon.size = 12
			E.db.unitframe.units.party.portrait.overlay = true
			E.db.unitframe.units.party.customTexts.LevelClass = ''
			E.db.unitframe.units.party.customTexts.Gesundheit = {}
			E.db.unitframe.units.party.customTexts.Gesundheit.text_format = ''
			E.db.unitframe.units.party.health.text_format = ''
			SetMoverPosition('ElvUF_PartyMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 674, 224)
			-- PlayerMover
			SetMoverPosition('ElvUF_PlayerMover', 'BOTTOM', E.UIParent, 'BOTTOM', -179, 147)
			SetMoverPosition('ElvUF_PlayerCastbarMover', 'BOTTOM', E.UIParent, 'BOTTOM', -179, 110)
			-- TargetMover
			SetMoverPosition('ElvUF_TargetMover', 'BOTTOM', E.UIParent, 'BOTTOM', 179, 147)
			SetMoverPosition('ElvUF_TargetCastbarMover', 'BOTTOM', E.UIParent, 'BOTTOM', 179, 110)
			SetMoverPosition('TargetPowerBarMover', 'BOTTOM', E.UIParent, 'BOTTOM', 203, 429)
			-- TargetTargetMover
			SetMoverPosition('ElvUF_TargetTargetMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 162)
			-- FocusMover
			SetMoverPosition('ElvUF_FocusMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -465, 199)
			SetMoverPosition('ElvUF_FocusCastbarMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -465, 220)
			-- FocusTargetMover
			SetMoverPosition('ElvUF_FocusTargetMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -465, 232)
			-- PetMover
			SetMoverPosition('ElvUF_PetMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 135)
			SetMoverPosition('ElvUF_PetCastbarMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 114)
			-- AlertMover for Garrison etc.
			SetMoverPosition('AlertFrameMover', 'TOP', E.UIParent, 'TOP', 0, -140)
			-- ActionBarMover
			SetMoverPosition('ElvAB_1', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 26)
			SetMoverPosition('ElvAB_2', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 58)
			SetMoverPosition('ElvAB_3', 'BOTTOM', E.UIParent, 'BOTTOM', 241, 32)
			SetMoverPosition('ElvAB_4', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', 0, 367)
			SetMoverPosition('ElvAB_5', 'BOTTOM', E.UIParent, 'BOTTOM', -241, 32)
			SetMoverPosition('ElvAB_6', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -367, 46)
			SetMoverPosition('PetAB', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 469, 3)
			SetMoverPosition('ShiftAB', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 791, 97)
			SetMoverPosition('BossButton', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 442, 125)
			-- XP/RepMover
			SetMoverPosition('ReputationBarMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -353, 23)
			SetMoverPosition('ExperienceBarMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 353, 23)
			-- TooltipMover
			SetMoverPosition('TooltipMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -34, 367)
			-- ChatMover
			SetMoverPosition('LeftChatMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 2, 23)
			SetMoverPosition('RightChatMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -2, 23)
			-- Buff/DebuffMover
			SetMoverPosition('BuffsMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -158, -9)
			SetMoverPosition('DebuffsMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -158, -115)
			-- Arena/BossMover
			SetMoverPosition('ArenaHeaderMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -150, -305)
			SetMoverPosition('BossHeaderMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -181, -408)
			-- Tank/AssistMover
			SetMoverPosition('ElvUF_TankMover', 'TOPLEFT', E.UIParent, 'BOTTOMLEFT', 2, 626)
			SetMoverPosition('ElvUF_AssistMover', 'TOPLEFT', E.UIParent, 'BOTTOMLEFT', 2, 571)
			-- MiscMover
			SetMoverPosition('ElvUF_BodyGuardMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -465, 152)
			SetMoverPosition('WatchFrameMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -122, -292)
			SetMoverPosition('Top_Center_Mover', 'BOTTOM', E.UIParent, 'BOTTOM', -250, 2)
			SetMoverPosition('VehicleSeatMover', 'TOPLEFT', E.UIParent, 'TOPLEFT', 2, -84)
			SetMoverPosition('TotemBarMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 368, 3)
			SetMoverPosition('TempEnchantMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -5, -299)
			SetMoverPosition('MicrobarMover', 'TOPLEFT', E.UIParent, 'TOPLEFT', 4, -4)
			SetMoverPosition('ClassBarMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 187)
			SetMoverPosition('DigSiteProgressBarMover', 'TOP', E.UIParent, 'TOP', -2, 0)
			SetMoverPosition('FlareMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 253)
			SetMoverPosition('LocationMover', 'TOP', E.UIParent, 'TOP', 0, -7)
			SetMoverPosition('GMMover', 'TOPLEFT', E.UIParent, 'TOPLEFT', 329, 0)
			SetMoverPosition('UIBFrameMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -44, -161)
			SetMoverPosition('BNETMover', 'TOP', E.UIParent, 'TOP', 0, -38)
			SetMoverPosition('ObjectiveFrameMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -200, -281)
			SetMoverPosition('AltPowerBarMover', 'TOP', E.UIParent, 'TOP', 1, -272)
			SetMoverPosition('Bottom_Panel_Mover', 'BOTTOM', E.UIParent, 'BOTTOM', 250, 2)
			SetMoverPosition('LossControlMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 432)
			SetMoverPosition('LootFrameMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -495, -457)
			SetMoverPosition('MinimapButtonAnchor', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -5, -231)
			SetMoverPosition('MinimapMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -5, -6)
		end
	end
	
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
			FCF_DockFrame(frame)
			FCF_SetLocked(frame, 1)
			frame:Show()
		end
		FCF_SavePositionAndDimensions(frame)
		FCF_StopDragging(frame)
		
		-- enable classcolor automatically on login and on each character without doing /configure each time.
		ToggleChatColorNamesByClassGroup(true, "SAY")
		ToggleChatColorNamesByClassGroup(true, "EMOTE")
		ToggleChatColorNamesByClassGroup(true, "YELL")
		ToggleChatColorNamesByClassGroup(true, "GUILD")
		ToggleChatColorNamesByClassGroup(true, "OFFICER")
		ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
		ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
		ToggleChatColorNamesByClassGroup(true, "WHISPER")
		ToggleChatColorNamesByClassGroup(true, "PARTY")
		ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
		ToggleChatColorNamesByClassGroup(true, "RAID")
		ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
		ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
		ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
		ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")	
		ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")	
		ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL6")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL7")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL8")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL9")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL10")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL11")
		
		--Adjust Chat Colors
		--General
		ChangeChatColor("CHANNEL1", 195/255, 230/255, 232/255)
		--Trade
		ChangeChatColor("CHANNEL2", 232/255, 158/255, 121/255)
		--Local Defense
		ChangeChatColor("CHANNEL3", 232/255, 228/255, 121/255)
	end
	
	if _G["InstallStepComplete"] then
		_G["InstallStepComplete"].message = MER.Title..L['MerathilisUI Set']
		_G["InstallStepComplete"]:Show()			
		titleText[2].check:Show()
	end
	E:UpdateAll(true)
end
-- Addons
local skadaName = GetAddOnMetadata('Skada', 'Title')
local xctName = GetAddOnMetadata('xCT+', 'Title')

local function SetupMERAddons()
	-- Skada Profile
	if IsAddOnLoaded('Skada') then
		MER:Print(format(L[' - %s profile created!'], skadaName))
		SkadaDB['profiles']['MerathilisUI'] = {
			["windows"] = {
				{
					["titleset"] = false,
					["barslocked"] = true,
					["classicons"] = false,
					["y"] = 9,
					["title"] = {
						["color"] = {
							["a"] = 0,
							["r"] = 0.101960784313725,
							["g"] = 0.101960784313725,
							["b"] = 0.301960784313726,
						},
						["font"] = "Merathilis Roadway",
						["fontsize"] = 14,
						["borderthickness"] = 0,
						["fontflags"] = "OUTLINE",
						["height"] = 15,
						["texture"] = "MerathilisFlat",
					},
					["barfontflags"] = "OUTLINE",
					["point"] = "TOPRIGHT",
					["barbgcolor"] = {
						["a"] = 0,
						["b"] = 0.301960784313726,
						["g"] = 0.301960784313726,
						["r"] = 0.301960784313726,
					},
					["barcolor"] = {
						["a"] = 0,
						["g"] = 0.301960784313726,
						["r"] = 0.301960784313726,
					},
					["barfontsize"] = 10,
					["mode"] = "Schaden",
					["spark"] = false,
					["bartexture"] = "MerathilisOnePixel",
					["barwidth"] = 166,
					["barspacing"] = 1,
					["enabletitle"] = true,
					["classcolortext"] = true,
					["reversegrowth"] = false,
					["background"] = {
						["height"] = 114.999984741211,
					},
					["barfont"] = "Merathilis Expressway",
					["name"] = "DPS",
				}, -- [1]
				{
					["barheight"] = 15,
					["classicons"] = false,
					["barslocked"] = true,
					["enabletitle"] = true,
					["wipemode"] = "",
					["set"] = "current",
					["hidden"] = false,
					["y"] = 9,
					["barfont"] = "Merathilis Expressway",
					["name"] = "HPS",
					["display"] = "bar",
					["barfontflags"] = "OUTLINE",
					["classcolortext"] = true,
					["scale"] = 1,
					["reversegrowth"] = false,
					["barfontsize"] = 10,
					["barorientation"] = 1,
					["snapto"] = true,
					["version"] = 1,
					["title"] = {
						["color"] = {
							["a"] = 0.800000011920929,
							["b"] = 0.301960784313726,
							["g"] = 0.101960784313725,
							["r"] = 0.101960784313725,
						},
						["bordertexture"] = "None",
						["font"] = "Merathilis Roadway",
						["borderthickness"] = 0,
						["fontsize"] = 14,
						["fontflags"] = "OUTLINE",
						["height"] = 15,
						["margin"] = 0,
						["texture"] = "MerathilisFlat",
					},
					["buttons"] = {
						["segment"] = true,
						["menu"] = true,
						["stop"] = false,
						["mode"] = true,
						["report"] = true,
						["reset"] = true,
					},
					["spark"] = false,
					["bartexture"] = "MerathilisOnePixel",
					["barwidth"] = 170,
					["barspacing"] = 1,
					["clickthrough"] = false,
					["point"] = "TOPRIGHT",
					["background"] = {
						["borderthickness"] = 0,
						["color"] = {
							["a"] = 0.2,
							["r"] = 0,
							["g"] = 0,
							["b"] = 0.5,
						},
						["height"] = 114.999984741211,
						["bordertexture"] = "None",
						["margin"] = 0,
						["texture"] = "Solid",
					},
					["barcolor"] = {
						["a"] = 0,
						["b"] = 0.8,
						["g"] = 0.301960784313726,
						["r"] = 0.301960784313726,
					},
					["barbgcolor"] = {
						["a"] = 0,
						["b"] = 0.301960784313726,
						["g"] = 0.301960784313726,
						["r"] = 0.301960784313726,
					},
					["classcolorbars"] = true,
					["modeincombat"] = "",
					["returnaftercombat"] = false,
					["mode"] = "Heilung",
					["x"] = 1500,
				}, -- [2]
			},		
			["icon"] = {
				["minimapPos"] = 216.201067430819,
				["hide"] = true,
			},
			["columns"] = {
				["Schaden_Damage"] = true,
				["Schaden_Percent"] = false,
				["Heilung_Percent"] = false,
				["Schaden_DPS"] = true,
			},
		}
	end
	
	do
		-- BenikUI
		if E.db.bui == nil then E.db.bui = {} end
		if IsAddOnLoaded('ElvUI_BenikUI') then
			E.db.bui.gameMenuColor = 1
			E.db.bui.styledChatDts = true
			E.db.bui.garrisonCurrency = true
			E.db.bui.middleDatatext.styled = true
			E.db.bui.middleDatatext.backdrop = true
			E.db.bui.middleDatatext.width = 388
			E.db.bui.transparentDts = true
			E.db.bui.garrisonCurrencyOil = true
			E.db.bui.LoginMsg = false
			E.db.bui.SplashScreen = false
			E.db.bui.StyleColor = 1
			E.db.bui.abStyleColor = 1
			E.db.dashboards.barColor = {r = color.r, g = color.g, b = color.b}
			E.db.dashboards.system.enableSystem = false
			E.db.dashboards.tokens.enableTokens = true
			E.db.dashboards.tokens.tooltip = false
			E.db.dashboards.tokens.flash = true
			E.db.dashboards.tokens.width = 148
			E.db.dashboards.professions.enableProfessions = false
			SetMoverPosition('BuiMiddleDtMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 2)
			SetMoverPosition('tokenHolderMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -3, -146)
		end
	end
	
	do
		-- LocationPlus
		if E.db.locplus == nil then E.db.locplus = {} end
		if IsAddOnLoaded('ElvUI_LocPlus') then
			E.db.locplus.LoginMsg = false
			E.db.locplus.lpfont = 'Merathilis Roadway'
			E.db.locplus.dtheight = 17
			E.db.locplus.dtwidth = 80
			E.db.locplus.fish = false
			E.db.locplus.lpwidth = 220
			E.db.locplus.petlevel = false
			E.db.locplus.ttreczones = false
			E.db.locplus.ttinst = false
			E.db.locplus.lpfontsize = 13
			E.db.locplus.lpfontflags = 'OUTLINE'
			E.db.locplus.ttrecinst = false
			E.db.locplus.ht = false
			E.db.locplus.displayOther = 'NONE'
			E.db.locplus.profcap = false
			E.db.locplus.shadow = true
			E.db.locplus.customCoordsColor = 1
			E.db.locplus.dig = false
			E.db.locplus.showicon = false
			E.db.locplus.ttlvl = false
			SetMoverPosition('LocationLiteMover', 'TOP', E.UIParent, 'TOP', 0, -7)
		end
	end
	
	do
		-- ElvUI_VisualAuraTimer
		if E.db.VAT == nil then E.db.VAT = {} end
		if IsAddOnLoaded('ElvUI_VisualAuraTimers') then
			E.db.VAT.enableStaticColor = true
			E.db.VAT.noDuration = true
			E.db.VAT.barHeight = 5
			E.db.VAT.spacing = -3
			E.db.VAT.staticColor = {r = color.r, g = color.g, b = color.b}
			E.db.VAT.showText = false
			E.db.VAT.decimalThreshold = 5
			E.db.VAT.statusbarTexture = 'MerathilisFlat'
			E.db.VAT.backdropTexture = 'MerathilisFlat'
			E.db.VAT.position = 'TOP'
		end
	end
	
	-- xCT Profile
	if IsAddOnLoaded('xCT+') then
		MER:Print(format(L[' - %s profile created!'], xctName))
		xCTSavedDB['profiles']["MerathilisUI"] = {
			["frames"] = {
				["general"] = {
					["fontOutline"] = "2OUTLINE",
					["font"] = "Merathilis Tukui",
					["colors"] = {
						["auras"] = {
							["colors"] = {
								["debuffsGained"] = {
									["color"] = {
										1, -- [1]
										0.1, -- [2]
										0.1, -- [3]
									},
								},
								["buffsGained"] = {
									["color"] = {
										1, -- [1]
										0.5, -- [2]
										0.5, -- [3]
									},
								},
								["buffsFaded"] = {
									["color"] = {
										0.5, -- [1]
										0.5, -- [2]
										0.5, -- [3]
									},
								},
								["debuffsFaded"] = {
									["color"] = {
										0.5, -- [1]
										0.5, -- [2]
										0.5, -- [3]
									},
								},
							},
						},
						["killingBlow"] = {
							["color"] = {
								0.2, -- [1]
								1, -- [2]
								0.2, -- [3]
							},
						},
						["combat"] = {
							["colors"] = {
								["combatLeaving"] = {
									["color"] = {
										0.1, -- [1]
										1, -- [2]
										0.1, -- [3]
									},
								},
								["combatEntering"] = {
									["color"] = {
										1, -- [1]
										0.1, -- [2]
										0.1, -- [3]
									},
								},
							},
						},
						["interrupts"] = {
							["color"] = {
								1, -- [1]
								0.5, -- [2]
								0, -- [3]
							},
						},
						["reputation"] = {
							["colors"] = {
								["reputationGain"] = {
									["color"] = {
										0.1, -- [1]
										0.1, -- [2]
										1, -- [3]
									},
								},
								["reputationLoss"] = {
									["color"] = {
										1, -- [1]
										0.1, -- [2]
										0.1, -- [3]
									},
								},
							},
						},
						["lowResources"] = {
							["colors"] = {
								["lowResourcesMana"] = {
									["color"] = {
										1, -- [1]
										0.1, -- [2]
										0.1, -- [3]
									},
								},
								["lowResourcesHealth"] = {
									["color"] = {
										1, -- [1]
										0.1, -- [2]
										0.1, -- [3]
									},
								},
							},
						},
						["honorGains"] = {
							["color"] = {
								0.1, -- [1]
								0.1, -- [2]
								1, -- [3]
							},
						},
						["dispells"] = {
							["colors"] = {
								["dispellBuffs"] = {
									["color"] = {
										0, -- [1]
										1, -- [2]
										0.5, -- [3]
									},
								},
								["dispellStolen"] = {
									["color"] = {
										0.31, -- [1]
										0.71, -- [2]
										1, -- [3]
									},
								},
								["dispellDebuffs"] = {
									["color"] = {
										1, -- [1]
										0, -- [2]
										0.5, -- [3]
									},
								},
							},
						},
					},
					["enabledFrame"] = false,
				},
				["power"] = {
					["enabledFrame"] = false,
					["font"] = "Merathilis Tukui",
					["colors"] = {
						["color_SOUL_SHARDS"] = {
							["color"] = {
								0.5, -- [1]
								0.32, -- [2]
								0.55, -- [3]
							},
						},
						["color_HOLY_POWER"] = {
							["color"] = {
								0.95, -- [1]
								0.9, -- [2]
								0.6, -- [3]
							},
						},
						["color_MANA"] = {
							["color"] = {
								0, -- [1]
								0, -- [2]
								1, -- [3]
							},
						},
						["color_FOCUS"] = {
							["color"] = {
								1, -- [1]
								0.5, -- [2]
								0.25, -- [3]
							},
						},
						["color_CHI"] = {
							["color"] = {
								0.71, -- [1]
								1, -- [2]
								0.92, -- [3]
							},
						},
						["color_RAGE"] = {
							["color"] = {
								1, -- [1]
								0, -- [2]
								0, -- [3]
							},
						},
						["color_ENERGY"] = {
							["color"] = {
								1, -- [1]
								1, -- [2]
								0, -- [3]
							},
						},
						["color_RUNIC_POWER"] = {
							["color"] = {
								0, -- [1]
								0.82, -- [2]
								1, -- [3]
							},
						},
						["color_ECLIPSE_positive"] = {
							["color"] = {
								0.8, -- [1]
								0.82, -- [2]
								0.6, -- [3]
							},
						},
						["color_RUNES"] = {
							["color"] = {
								0.5, -- [1]
								0.5, -- [2]
								0.5, -- [3]
							},
						},
						["color_ECLIPSE_negative"] = {
							["color"] = {
								0.3, -- [1]
								0.52, -- [2]
								0.9, -- [3]
							},
						},
					},
					["fontOutline"] = "2OUTLINE",
				},
				["healing"] = {
					["enableRealmNames"] = false,
					["fontSize"] = 12,
					["Width"] = 68,
					["showFriendlyHealers"] = false,
					["X"] = -109,
					["colors"] = {
						["healingTakenCritical"] = {
							["color"] = {
								0.1, -- [1]
								1, -- [2]
								0.1, -- [3]
							},
						},
						["healingTaken"] = {
							["color"] = {
								0.1, -- [1]
								0.75, -- [2]
								0.1, -- [3]
							},
						},
						["healingTakenPeriodic"] = {
							["color"] = {
								0.1, -- [1]
								0.5, -- [2]
								0.1, -- [3]
							},
						},
						["shieldTaken"] = {
							["color"] = {
								0.6, -- [1]
								0.65, -- [2]
								1, -- [3]
							},
						},
						["healingTakenPeriodicCritical"] = {
							["color"] = {
								0.1, -- [1]
								0.5, -- [2]
								0.1, -- [3]
							},
						},
					},
					["fontOutline"] = "2OUTLINE",
					["Height"] = 218,
					["font"] = "Merathilis Tukui",
					["Y"] = -18,
				},
				["outgoing"] = {
					["Y"] = 29,
					["fontSize"] = 12,
					["colors"] = {
						["genericDamage"] = {
							["color"] = {
								1, -- [1]
								0.82, -- [2]
								0, -- [3]
							},
						},
						["healingSpells"] = {
							["colors"] = {
								["healingOut"] = {
									["color"] = {
										0.1, -- [1]
										0.75, -- [2]
										0.1, -- [3]
									},
								},
								["shieldOut"] = {
									["color"] = {
										0.6, -- [1]
										0.65, -- [2]
										1, -- [3]
									},
								},
								["healingOutPeriodic"] = {
									["color"] = {
										0.1, -- [1]
										0.5, -- [2]
										0.1, -- [3]
									},
								},
							},
						},
						["spellSchools"] = {
							["colors"] = {
								["SpellSchool_Nature"] = {
									["color"] = {
										0.3, -- [1]
										1, -- [2]
										0.3, -- [3]
									},
								},
								["SpellSchool_Arcane"] = {
									["color"] = {
										1, -- [1]
										0.5, -- [2]
										1, -- [3]
									},
								},
								["SpellSchool_Frost"] = {
									["color"] = {
										0.5, -- [1]
										1, -- [2]
										1, -- [3]
									},
								},
								["SpellSchool_Physical"] = {
									["color"] = {
										1, -- [1]
										1, -- [2]
										0, -- [3]
									},
								},
								["SpellSchool_Shadow"] = {
									["color"] = {
										0.5, -- [1]
										0.5, -- [2]
										1, -- [3]
									},
								},
								["SpellSchool_Holy"] = {
									["color"] = {
										1, -- [1]
										0.9, -- [2]
										0.5, -- [3]
									},
								},
								["SpellSchool_Fire"] = {
									["color"] = {
										1, -- [1]
										0.5, -- [2]
										0, -- [3]
									},
								},
							},
						},
						["misstypesOut"] = {
							["color"] = {
								0.5, -- [1]
								0.5, -- [2]
								0.5, -- [3]
							},
						},
					},
					["fontOutline"] = "2OUTLINE",
					["Height"] = 317,
					["font"] = "Merathilis Tukui",
					["X"] = 231,
					["Width"] = 122,
				},
				["critical"] = {
					["Y"] = 29,
					["fontSize"] = 12,
					["colors"] = {
						["genericDamageCritical"] = {
							["color"] = {
								1, -- [1]
								1, -- [2]
								0, -- [3]
							},
						},
						["healingSpells"] = {
							["colors"] = {
								["healingOutCritical"] = {
									["color"] = {
										0.1, -- [1]
										1, -- [2]
										0.1, -- [3]
									},
								},
							},
						},
					},
					["fontOutline"] = "2OUTLINE",
					["Height"] = 317,
					["font"] = "Merathilis Tukui",
					["X"] = 150,
					["Width"] = 96,
				},
				["procs"] = {
					["fontOutline"] = "2OUTLINE",
					["font"] = "Merathilis Tukui",
					["colors"] = {
						["spellReactive"] = {
							["color"] = {
								1, -- [1]
								0.82, -- [2]
								0, -- [3]
							},
						},
						["spellProc"] = {
							["color"] = {
								1, -- [1]
								0.82, -- [2]
								0, -- [3]
							},
						},
					},
					["enabledFrame"] = false,
				},
				["loot"] = {
					["font"] = "Merathilis Tukui",
					["fontOutline"] = "2OUTLINE",
					["enabledFrame"] = false,
				},
				["class"] = {
					["enabledFrame"] = false,
					["font"] = "Merathilis Tukui",
					["colors"] = {
						["comboPoints"] = {
							["color"] = {
								1, -- [1]
								0.82, -- [2]
								0, -- [3]
							},
						},
						["comboPointsMax"] = {
							["color"] = {
								0, -- [1]
								0.82, -- [2]
								1, -- [3]
							},
						},
					},
					["fontOutline"] = "2OUTLINE",
				},
				["damage"] = {
					["fontSize"] = 12,
					["Width"] = 131,
					["Y"] = -18,
					["X"] = -210,
					["colors"] = {
						["missTypesTaken"] = {
							["colors"] = {
								["missTypeBlock"] = {
									["color"] = {
										0.5, -- [1]
										0.5, -- [2]
										0.5, -- [3]
									},
								},
								["missTypeMiss"] = {
									["color"] = {
										0.5, -- [1]
										0.5, -- [2]
										0.5, -- [3]
									},
								},
								["missTypeImmune"] = {
									["color"] = {
										0.5, -- [1]
										0.5, -- [2]
										0.5, -- [3]
									},
								},
								["missTypeDodge"] = {
									["color"] = {
										0.5, -- [1]
										0.5, -- [2]
										0.5, -- [3]
									},
								},
								["missTypeParry"] = {
									["color"] = {
										0.5, -- [1]
										0.5, -- [2]
										0.5, -- [3]
									},
								},
								["missTypeResist"] = {
									["color"] = {
										0.5, -- [1]
										0.5, -- [2]
										0.5, -- [3]
									},
								},
								["missTypeEvade"] = {
									["color"] = {
										0.5, -- [1]
										0.5, -- [2]
										0.5, -- [3]
									},
								},
								["missTypeAbsorb"] = {
									["color"] = {
										0.5, -- [1]
										0.5, -- [2]
										0.5, -- [3]
									},
								},
								["missTypeReflect"] = {
									["color"] = {
										0.5, -- [1]
										0.5, -- [2]
										0.5, -- [3]
									},
								},
								["missTypeDeflect"] = {
									["color"] = {
										0.5, -- [1]
										0.5, -- [2]
										0.5, -- [3]
									},
								},
							},
						},
						["damageTakenCritical"] = {
							["color"] = {
								1, -- [1]
								0.1, -- [2]
								0.1, -- [3]
							},
						},
						["spellDamageTaken"] = {
							["color"] = {
								0.75, -- [1]
								0.3, -- [2]
								0.85, -- [3]
							},
						},
						["spellDamageTakenCritical"] = {
							["color"] = {
								0.75, -- [1]
								0.3, -- [2]
								0.85, -- [3]
							},
						},
						["damageTaken"] = {
							["color"] = {
								0.75, -- [1]
								0.1, -- [2]
								0.1, -- [3]
							},
						},
						["missTypesTakenPartial"] = {
							["colors"] = {
								["missTypeBlockPartial"] = {
									["color"] = {
										0.75, -- [1]
										0.5, -- [2]
										0.5, -- [3]
									},
								},
								["missTypeResistPartial"] = {
									["color"] = {
										0.75, -- [1]
										0.5, -- [2]
										0.5, -- [3]
									},
								},
								["missTypeAbsorbPartial"] = {
									["color"] = {
										0.75, -- [1]
										0.5, -- [2]
										0.5, -- [3]
									},
								},
							},
						},
					},
					["fontOutline"] = "2OUTLINE",
					["Height"] = 218,
					["font"] = "Merathilis Tukui",
					["insertText"] = "bottom",
				},
			},
			["dbVersion"] = "4.1.6",
			["blizzardFCT"] = {
				["CombatLogPeriodicSpells"] = true,
				["CombatHealing"] = true,
				["CombatDamage"] = true,
				["PetMeleeDamage"] = true,
				["CombatHealingAbsorbTarget"] = true,
			},
		}
	end
	
	if _G["InstallStepComplete"] then
		_G["InstallStepComplete"].message = MER.Title..L['Addons Set']
		_G["InstallStepComplete"]:Show()		
		titleText[4].check:Show()
	end
	E:UpdateAll(true)
end

function MER:SetupDts(role)
	-- Data Texts
	E.db.datatexts.font = 'Merathilis Roadway'
	E.db.datatexts.fontSize = 13
	E.db.datatexts.fontOutline = 'OUTLINE'
	E.db.datatexts.panelTransparency = false
	if IsAddOnLoaded('ElvUI_LocPlus') then
		if IsAddOnLoaded('ElvUI_SLE') then
			E.db.datatexts.panels.LeftCoordDtPanel = 'S&L Guild'
			E.db.datatexts.panels.RightCoordDtPanel = 'S&L Friends'
		else
			E.db.datatexts.panels.LeftCoordDtPanel = 'Guild'
			E.db.datatexts.panels.RightCoordDtPanel = 'Friends'
		end
	end
	
	if IsAddOnLoaded('ElvUI_BenikUI') then
		-- define BenikUI Datetexts
		if role == 'tank' then
			E.db.datatexts.panels.BuiLeftChatDTPanel.right = 'Attack Power'
		elseif role == 'dpsMelee' then
			E.db.datatexts.panels.BuiLeftChatDTPanel.right = 'Attack Power'
		elseif role == 'healer' or 'dpsCaster' then
			E.db.datatexts.panels.BuiLeftChatDTPanel.right = 'Spell/Heal Power'
		end
		E.db.datatexts.panels.BuiLeftChatDTPanel.left = 'MUI Talent/Loot Specialization'
		E.db.datatexts.panels.BuiLeftChatDTPanel.middle = 'Durability'
		E.db.datatexts.panels.BuiRightChatDTPanel.middle = 'Garrison+ (BenikUI)'
		E.db.datatexts.panels.BuiRightChatDTPanel.right = 'BuiMail'
		
		if IsAddOnLoaded('Skada') then
			E.db.datatexts.panels.BuiRightChatDTPanel.left = 'Skada'
		else
			E.db.datatexts.panels.BuiRightChatDTPanel.left = 'Bags'
		end
		
		if IsAddOnLoaded('ElvUI_SLE') then
			E.db.datatexts.panels.BuiMiddleDTPanel.right = 'S&L Currency'
		else
			E.db.datatexts.panels.BuiMiddleDTPanel.right = 'Gold'
		end
		
		E.db.datatexts.panels.BuiMiddleDTPanel.left = 'MUI System'
		E.db.datatexts.panels.BuiMiddleDTPanel.middle = 'Time'
	else
		-- define the default ElvUI datatexts
		if role == 'tank' then
			E.db.datatexts.panels.LeftChatDataPanel.right = 'Attack Power'
		elseif role == 'dpsMelee' then
			E.db.datatexts.panels.LeftChatDataPanel.right = 'Attack Power'
		elseif role == 'healer' or 'dpsCaster' then
			E.db.datatexts.panels.LeftChatDataPanel.right = 'Spell/Heal Power'
		end
		E.db.datatexts.panels.LeftChatDataPanel.left = 'MUI Talent/Loot Specialization'
		E.db.datatexts.panels.LeftChatDataPanel.middle = 'Durability'
		
		if IsAddOnLoaded('Skada') then
			E.db.datatexts.panels.RightChatDataPanel.left = 'Skada'
		else
			E.db.datatexts.panels.RightChatDataPanel.left = 'MUI System'
		end
		E.db.datatexts.panels.RightChatDataPanel.middle = 'Time'
		E.db.datatexts.panels.RightChatDataPanel.right = 'Gold'
	end
	
	if _G["InstallStepComplete"] then
		_G["InstallStepComplete"].message = MER.Title..L['DataTexts Set']
		_G["InstallStepComplete"]:Show()
		titleText[3].check:Show()
	end
	E:UpdateAll(true)
end

local function ResetAll()
	InstallNextButton:Disable()
	InstallPrevButton:Disable()
	InstallOption1Button:Hide()
	InstallOption1Button:SetScript('OnClick', nil)
	InstallOption1Button:SetText('')
	InstallOption2Button:Hide()
	InstallOption2Button:SetScript('OnClick', nil)
	InstallOption2Button:SetText('')
	InstallOption3Button:Hide()
	InstallOption3Button:SetScript('OnClick', nil)
	InstallOption3Button:SetText('')
	InstallOption4Button:Hide()
	InstallOption4Button:SetScript('OnClick', nil)
	InstallOption4Button:SetText('')
	_G["MERInstallFrame"].SubTitle:SetText('')
	_G["MERInstallFrame"].Desc1:SetText('')
	_G["MERInstallFrame"].Desc2:SetText('')
	_G["MERInstallFrame"].Desc3:SetText('')
	_G["MERInstallFrame"].Desc4:SetText('')
	_G["MERInstallFrame"]:Size(500, 400)
	_G["MERTitleFrame"]:Size(180, 400)
end

local function InstallComplete()
	E.private.install_complete = E.version
	E.db.mui.installed = true
	
	ReloadUI()
end

local function SetPage(PageNum)
	CURRENT_PAGE = PageNum
	ResetAll()
	
	_G["InstallStatus"].anim.progress:SetChange(PageNum)
	_G["InstallStatus"].anim.progress:Play()
	
	local f = _G["MERInstallFrame"]
	
	if PageNum == MAX_PAGE then
		InstallNextButton:Disable()
	else
		InstallNextButton:Enable()
	end
	
	if PageNum == 1 then
		InstallPrevButton:Disable()
	else
		InstallPrevButton:Enable()
	end
	
	if PageNum == 1 then
		f.SubTitle:SetFormattedText(L['Welcome to MerathilisUI |cff00c0faVersion|r %s, for ElvUI %s.'], MER.Version, E.version)
		f.Desc1:SetFormattedText("%s", L["By pressing the Continue button, MerathilisUI will be applied in your current ElvUI installation.\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"])
		f.Desc2:SetFormattedText("%s", L['Please press the continue button to go onto the next step.'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', InstallComplete)
		InstallOption1Button:SetText(L['Skip Process'])
	elseif PageNum == 2 then
		f.SubTitle:SetText(L['Layout'])
		f.Desc1:SetFormattedText("%s", L['This part of the installation changes the default ElvUI look.'])
		f.Desc2:SetFormattedText("%s", L['Please click the button below to apply the new layout.'])
		f.Desc3:SetFormattedText("%s", L['Importance: |cff07D400High|r'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() SetupMERLayout('DPS') end)
		InstallOption1Button:SetFormattedText("%s", L['DPS Layout'])
		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() SetupMERLayout('HEAL') end)
		InstallOption2Button:SetFormattedText("%s", L['Heal Layout'])
	elseif PageNum == 3 then
		f.SubTitle:SetFormattedText("%s", L['DataTexts'])
		f.Desc1:SetFormattedText("%s", L["This part of the installation process will fill MerathilisUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"])
		f.Desc2:SetFormattedText("%s", L['Please click the button below to setup your datatexts.'])
		f.Desc3:SetFormattedText("%s", L['Importance: |cffD3CF00Medium|r'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() MER:SetupDts('tank') end)
		InstallOption1Button:SetFormattedText("%s", _G["TANK"])
		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() MER:SetupDts('healer') end)
		InstallOption2Button:SetFormattedText("%s", _G["HEALER"])
		InstallOption3Button:Show()
		InstallOption3Button:SetScript('OnClick', function() MER:SetupDts('dpsMelee') end)
		InstallOption3Button:SetFormattedText("%s", L['Physical DPS'])
		InstallOption4Button:Show()
		InstallOption4Button:SetScript('OnClick', function() MER:SetupDts('dpsCaster') end)
		InstallOption4Button:SetFormattedText("%s", L['Caster DPS'])
	elseif PageNum == 4 then
		f.SubTitle:SetFormattedText("%s", ADDONS)
		f.Desc1:SetFormattedText("%s", L['This part of the installation process will apply changes to the addons like Skada, xCT+ and ElvUI plugins'])
		f.Desc2:SetFormattedText("%s", L['Please click the button below to setup your addons.'])
		f.Desc3:SetFormattedText("%s", L['Importance: |cffD3CF00Medium|r'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() SetupMERAddons(); end)
		InstallOption1Button:SetFormattedText("%s", L['Setup Addons'])	
	elseif PageNum == 5 then
		f.SubTitle:SetFormattedText("%s", L['Installation Complete'])
		f.Desc1:SetFormattedText("%s", L['You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org.'])
		f.Desc2:SetFormattedText("%s", L['Please click the button below so you can setup variables and ReloadUI.'])			
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', InstallComplete)
		InstallOption1Button:SetFormattedText("%s", L['Finished'])
		_G["MERInstallFrame"]:Size(500, 400)
		_G["MERTitleFrame"]:Size(180, 400)
		if _G["InstallStepComplete"] then
			_G["InstallStepComplete"].message = MER.Title..L['Installed']
			_G["InstallStepComplete"]:Show()
		end
	end
end

local function NextPage()	
	if CURRENT_PAGE ~= MAX_PAGE then
		CURRENT_PAGE = CURRENT_PAGE + 1
		SetPage(CURRENT_PAGE)
		titleText[CURRENT_PAGE].text.anim.color:SetChange(1, 1, 0)
		titleText[CURRENT_PAGE].text.anim:Play()
		E:UIFrameFadeIn(titleText[CURRENT_PAGE].hoverTex, .3, 0, 1)
		if CURRENT_PAGE > 1 then
			E:UIFrameFadeIn(titleText[CURRENT_PAGE - 1].hoverTex, .3, 1, 0)
			titleText[CURRENT_PAGE - 1].text.anim.color:SetChange(unpack(E['media'].rgbvaluecolor))
			titleText[CURRENT_PAGE - 1].text.anim:Play()
		end
	end
end

local function PreviousPage()
	if CURRENT_PAGE ~= 1 then
		E:UIFrameFadeIn(titleText[CURRENT_PAGE].hoverTex, .3, 1, 0)
		titleText[CURRENT_PAGE].text.anim.color:SetChange(unpack(E['media'].rgbvaluecolor))
		titleText[CURRENT_PAGE].text.anim:Play()
		CURRENT_PAGE = CURRENT_PAGE - 1
		SetPage(CURRENT_PAGE)
		E:UIFrameFadeIn(titleText[CURRENT_PAGE].hoverTex, .3, 0, 1)
		titleText[CURRENT_PAGE].text.anim.color:SetChange(1, 1, 0)
		titleText[CURRENT_PAGE].text.anim:Play()
	end
end

function MER:SetupUI()	
	if not _G["InstallStepComplete"] then
		local imsg = CreateFrame('Frame', 'InstallStepComplete', E.UIParent)
		imsg:Size(418, 72)
		imsg:Point('TOP', 0, -190)
		imsg:Hide()
		imsg:SetScript('OnShow', function(self)
			if self.message then 
				PlaySoundFile([[Sound\Interface\LevelUp.ogg]])
				self.text:SetText(self.message)
				UIFrameFadeOut(self, 3.5, 1, 0)
				E:Delay(4, function() self:Hide() end)
				self.message = nil
			else
				self:Hide()
			end
		end)
		
		imsg.firstShow = false
		
		imsg.bg = imsg:CreateTexture(nil, 'BACKGROUND')
		imsg.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
		imsg.bg:SetPoint('BOTTOM')
		imsg.bg:Size(326, 103)
		imsg.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
		imsg.bg:SetVertexColor(1, 1, 1, 0.6)
		
		imsg.lineTop = imsg:CreateTexture(nil, 'BACKGROUND')
		imsg.lineTop:SetDrawLayer('BACKGROUND', 2)
		imsg.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
		imsg.lineTop:SetPoint('TOP')
		imsg.lineTop:Size(418, 7)
		imsg.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)
		
		imsg.lineBottom = imsg:CreateTexture(nil, 'BACKGROUND')
		imsg.lineBottom:SetDrawLayer('BACKGROUND', 2)
		imsg.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
		imsg.lineBottom:SetPoint('BOTTOM')
		imsg.lineBottom:Size(418, 7)
		imsg.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)
		
		imsg.text = imsg:CreateFontString(nil, 'ARTWORK')
		imsg.text:FontTemplate(nil, 32)
		imsg.text:Point('CENTER', 0, -4)
		imsg.text:SetTextColor(1, 0.82, 0)
		imsg.text:SetJustifyH('CENTER')
	end
	
	--Create Frame
	if not _G["MERInstallFrame"] then
		local f = CreateFrame('Button', 'MERInstallFrame', E.UIParent)
		f.SetPage = SetPage
		f:Size(500, 400)
		f:SetTemplate('Transparent')
		f:SetPoint('CENTER', 70, 0)
		f:SetFrameStrata('TOOLTIP')
		
		f.Title = f:CreateFontString(nil, 'OVERLAY')
		f.Title:FontTemplate(nil, 17, nil)
		f.Title:Point('TOP', 0, -5)
		f.Title:SetFormattedText("%s", MER.Title..L['Installation'])
		
		f.Next = CreateFrame('Button', 'InstallNextButton', f, 'UIPanelButtonTemplate')
		f.Next:StripTextures()
		f.Next:SetTemplate('Default', true)
		f.Next:Size(110, 25)
		f.Next:Point('BOTTOMRIGHT', -5, 5)
		f.Next:SetFormattedText("%s", CONTINUE)
		f.Next:Disable()
		f.Next:SetScript('OnClick', NextPage)
		E.Skins:HandleButton(f.Next, true)
		
		f.Prev = CreateFrame('Button', 'InstallPrevButton', f, 'UIPanelButtonTemplate')
		f.Prev:StripTextures()
		f.Prev:SetTemplate('Default', true)
		f.Prev:Size(110, 25)
		f.Prev:Point('BOTTOMLEFT', 5, 5)
		f.Prev:SetFormattedText("%s", PREVIOUS)	
		f.Prev:Disable()
		f.Prev:SetScript('OnClick', PreviousPage)
		E.Skins:HandleButton(f.Prev, true)
		
		f.Status = CreateFrame('StatusBar', 'InstallStatus', f)
		f.Status:SetFrameLevel(f.Status:GetFrameLevel() + 2)
		f.Status:CreateBackdrop('Default')
		f.Status:SetStatusBarTexture(E['media'].normTex)
		f.Status:SetStatusBarColor(unpack(E['media'].rgbvaluecolor))
		f.Status:SetMinMaxValues(0, MAX_PAGE)
		f.Status:Point('TOPLEFT', f.Prev, 'TOPRIGHT', 6, -2)
		f.Status:Point('BOTTOMRIGHT', f.Next, 'BOTTOMLEFT', -6, 2)
		-- Setup StatusBar Animation
		f.Status.anim = _G["CreateAnimationGroup"](f.Status)
		f.Status.anim.progress = f.Status.anim:CreateAnimation("Progress")
		f.Status.anim.progress:SetSmoothing("Out")
		f.Status.anim.progress:SetDuration(.3)
		
		f.Status.text = f.Status:CreateFontString(nil, 'OVERLAY')
		f.Status.text:FontTemplate()
		f.Status.text:SetPoint('CENTER')
		f.Status.text:SetFormattedText("%s / %s", CURRENT_PAGE, MAX_PAGE)
		f.Status:SetScript('OnValueChanged', function(self)
			self.text:SetText(ceil(self:GetValue())..' / '..MAX_PAGE)
		end)
		
		f.Option1 = CreateFrame('Button', 'InstallOption1Button', f, 'UIPanelButtonTemplate')
		f.Option1:StripTextures()
		f.Option1:Size(160, 30)
		f.Option1:Point('BOTTOM', 0, 45)
		f.Option1:SetText('')
		f.Option1:Hide()
		E.Skins:HandleButton(f.Option1, true)
		
		f.Option2 = CreateFrame('Button', 'InstallOption2Button', f, 'UIPanelButtonTemplate')
		f.Option2:StripTextures()
		f.Option2:Size(110, 30)
		f.Option2:Point('BOTTOMLEFT', f, 'BOTTOM', 4, 45)
		f.Option2:SetText('')
		f.Option2:Hide()
		f.Option2:SetScript('OnShow', function() f.Option1:SetWidth(110); f.Option1:ClearAllPoints(); f.Option1:Point('BOTTOMRIGHT', f, 'BOTTOM', -4, 45) end)
		f.Option2:SetScript('OnHide', function() f.Option1:SetWidth(160); f.Option1:ClearAllPoints(); f.Option1:Point('BOTTOM', 0, 45) end)
		E.Skins:HandleButton(f.Option2, true)
		
		f.Option3 = CreateFrame('Button', 'InstallOption3Button', f, 'UIPanelButtonTemplate')
		f.Option3:StripTextures()
		f.Option3:Size(100, 30)
		f.Option3:Point('LEFT', f.Option2, 'RIGHT', 4, 0)
		f.Option3:SetText('')
		f.Option3:Hide()
		f.Option3:SetScript('OnShow', function() f.Option1:SetWidth(100); f.Option1:ClearAllPoints(); f.Option1:Point('RIGHT', f.Option2, 'LEFT', -4, 0); f.Option2:SetWidth(100); f.Option2:ClearAllPoints(); f.Option2:Point('BOTTOM', f, 'BOTTOM', 0, 45) end)
		f.Option3:SetScript('OnHide', function() f.Option1:SetWidth(160); f.Option1:ClearAllPoints(); f.Option1:Point('BOTTOM', 0, 45); f.Option2:SetWidth(110); f.Option2:ClearAllPoints(); f.Option2:Point('BOTTOMLEFT', f, 'BOTTOM', 4, 45) end)
		E.Skins:HandleButton(f.Option3, true)
		
		f.Option4 = CreateFrame('Button', 'InstallOption4Button', f, 'UIPanelButtonTemplate')
		f.Option4:StripTextures()
		f.Option4:Size(100, 30)
		f.Option4:Point('LEFT', f.Option3, 'RIGHT', 4, 0)
		f.Option4:SetText('')
		f.Option4:Hide()
		f.Option4:SetScript('OnShow', function() 
			f.Option1:Width(100)
			f.Option2:Width(100)
			
			f.Option1:ClearAllPoints(); 
			f.Option1:Point('RIGHT', f.Option2, 'LEFT', -4, 0); 
			f.Option2:ClearAllPoints(); 
			f.Option2:Point('BOTTOMRIGHT', f, 'BOTTOM', -4, 45) 
		end)
		f.Option4:SetScript('OnHide', function() f.Option1:SetWidth(160); f.Option1:ClearAllPoints(); f.Option1:Point('BOTTOM', 0, 45); f.Option2:SetWidth(110); f.Option2:ClearAllPoints(); f.Option2:Point('BOTTOMLEFT', f, 'BOTTOM', 4, 45) end)
		E.Skins:HandleButton(f.Option4, true)
		
		f.SubTitle = f:CreateFontString(nil, 'OVERLAY')
		f.SubTitle:FontTemplate(nil, 15, nil)
		f.SubTitle:Point('TOP', 0, -40)
		
		f.Desc1 = f:CreateFontString(nil, 'OVERLAY')
		f.Desc1:FontTemplate()	
		f.Desc1:Point('TOP', 0, -75)
		f.Desc1:Width(f:GetWidth() - 40)
		
		f.Desc2 = f:CreateFontString(nil, 'OVERLAY')
		f.Desc2:FontTemplate()	
		f.Desc2:Point('TOP', 0, -125)
		f.Desc2:Width(f:GetWidth() - 40)
		
		f.Desc3 = f:CreateFontString(nil, 'OVERLAY')
		f.Desc3:FontTemplate()	
		f.Desc3:Point('TOP', 0, -175)
		f.Desc3:Width(f:GetWidth() - 40)
		
		f.Desc4 = f:CreateFontString(nil, 'OVERLAY')
		f.Desc4:FontTemplate()	
		f.Desc4:Point('BOTTOM', 0, 75)
		f.Desc4:Width(f:GetWidth() - 40)
		
		local close = CreateFrame('Button', nil, f, 'UIPanelCloseButton')
		close:SetPoint('TOPRIGHT', f, 'TOPRIGHT')
		close:SetScript('OnClick', function()
			f:Hide()
		end)		
		E.Skins:HandleCloseButton(close)
		
		f.tutorialImage = f:CreateTexture(nil, 'OVERLAY')
		f.tutorialImage:Size(256, 128)
		f.tutorialImage:SetTexture('Interface\\AddOns\\MerathilisUI\\media\\textures\\merathilis_logo.tga')
		f.tutorialImage:Point('BOTTOM', 0, 75)
		
		f.side = CreateFrame('Frame', 'MERTitleFrame', f)
		f.side:SetTemplate('Transparent')
		--f.side:Point('LEFT', f, 'LEFT', E.PixelMode and -1 or -3, 0)
		f.side:Size(180, 400)
		
		for i = 1, MAX_PAGE do
			titleText[i] = CreateFrame('Frame', nil, f.side)
			titleText[i]:Size(180, 20)
			titleText[i].text = titleText[i]:CreateFontString(nil, 'OVERLAY')
			titleText[i].text:SetPoint('LEFT', 27, 0)
			titleText[i].text:FontTemplate(nil, 12)
			titleText[i].text:SetTextColor(unpack(E['media'].rgbvaluecolor))
			
			-- Create Animation
			titleText[i].text.anim = _G["CreateAnimationGroup"](titleText[i].text)
			titleText[i].text.anim.color = titleText[i].text.anim:CreateAnimation("Color")
			titleText[i].text.anim.color:SetColorType("Text")
			
			titleText[i].hoverTex = titleText[i]:CreateTexture(nil, 'OVERLAY')
			titleText[i].hoverTex:SetTexture([[Interface\MONEYFRAME\Arrow-Right-Up]])
			titleText[i].hoverTex:Size(14)
			titleText[i].hoverTex:Point('RIGHT', titleText[i].text, 'LEFT', 4, -2)
			titleText[i].hoverTex:SetAlpha(0)
			titleText[i].check = titleText[i]:CreateTexture(nil, 'OVERLAY')
			titleText[i].check:Size(20)
			titleText[i].check:Point('LEFT', titleText[i].text, 'RIGHT', 0, -2)
			titleText[i].check:SetTexture([[Interface\BUTTONS\UI-CheckBox-Check]])
			titleText[i].check:Hide()
			
			if i == 1 then titleText[i].text:SetFormattedText("%s", L['Welcome'])
			elseif i == 2 then titleText[i].text:SetFormattedText("%s", L['MerathilisUI Set'])
			elseif i == 3 then titleText[i].text:SetFormattedText("%s", L['DataTexts Set'])
			elseif i == 4 then titleText[i].text:SetFormattedText("%s", L['Addons Set'])
			elseif i == 5 then titleText[i].text:SetFormattedText("%s", L['Finish'])
			end
			
			if(i == 1) then
				titleText[i]:Point('TOP', f.side, 'TOP', 0, -40)
			else
				titleText[i]:Point('TOP', titleText[i - 1], 'BOTTOM')
			end
		end
	end
	
	-- Animations
	_G["MERTitleFrame"]:Point('LEFT', 'MERInstallFrame', 'LEFT', E.PixelMode and -1 or -3, 0)
	local animGroup = _G["CreateAnimationGroup"](_G["MERTitleFrame"])
	local anim = animGroup:CreateAnimation("Move")
	anim:SetOffset(-180, 0)
	anim:SetDuration(1)
	anim:SetSmoothing("Bounce")
	anim:Play()
	
	_G["MERInstallFrame"]:Show()
	NextPage()
end
