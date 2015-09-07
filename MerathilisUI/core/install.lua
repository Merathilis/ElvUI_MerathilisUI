local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

local CURRENT_PAGE = 0
local MAX_PAGE = 5

local function SetMoverPosition(mover, point, anchor, secondaryPoint, x, y)
	if not _G[mover] then return end
	local frame = _G[mover]

	frame:ClearAllPoints()
	frame:SetPoint(point, anchor, secondaryPoint, x, y)
	E:SaveMoverPosition(mover)
end

-- local functions must go up
local function SetupMERLayout()
	do
	-- General
		E.private.general.pixelPerfect = true
	-- to fit my UI Settings, you must adjust the Scaling Settings in the System Options
		E.global.general.autoScale = true
		E.db.general.totems.size = 36
		E.db.general.font = 'Merathilis Prototype'
		E.db.general.fontSize = 10
		E.db.general.interruptAnnounce = "RAID"
		E.db.general.autoRepair = "GUILD"
		E.db.general.minimap.size = 130
		E.db.general.loginmessage = false
		E.db.general.stickyFrames = false
		E.db.general.backdropcolor.r = 0.101960784313726
		E.db.general.backdropcolor.g = 0.101960784313726
		E.db.general.backdropcolor.b = 0.101960784313726
		E.db.general.vendorGrays = true
		E.db.general.bottompanel = false
		E.global.general.smallerWorldMap = false
		E.db.general.backdropfadecolor.r = 0.0549
		E.db.general.backdropfadecolor.g = 0.0549
		E.db.general.backdropfadecolor.b = 0.0549
		E.private.general.namefont = 'Merathilis Prototype'
		E.private.general.dmgfont = 'ElvUI Combat'
		E.private.general.normTex = 'MerathilisFlat'
		E.private.general.glossTex = 'MerathilisFlat'
		E.db.general.experience.height = 140
		E.db.general.experience.textSize = 10
		E.db.general.experience.width = 12
		E.db.general.reputation.height = 140
		E.db.general.reputation.textSize = 10
		E.db.general.reputation.width = 12
		E.db.datatexts.leftChatPanel = false
		E.db.datatexts.rightChatPanel = false
		E.db.datatexts.time24 = true
		E.db.datatexts.minimapPanels = false
		E.db.datatexts.actionbar3 = false
		E.db.datatexts.actionbar5 = false
		E.db.datatexts.goldCoins = true
		E.db.datatexts.noCombatHover = true
		E.private.skins.blizzard.alertframes = true
		E.private.skins.blizzard.questChoice = true
	end
	
	do
	-- Actionbars
		E.db.actionbar.font = 'Merathilis Prototype'
		E.db.actionbar.fontOutline = 'OUTLINE'
		E.db.actionbar.macrotext = true
		
		E.db.actionbar.bar1.buttonspacing = 4
		E.db.actionbar.bar1.backdrop = true
		E.db.actionbar.bar1.heightMult = 2
		E.db.actionbar.bar1.buttonsize = 28
		E.db.actionbar.bar1.buttons = 12
		E.db.actionbar.bar2.enable = true
		E.db.actionbar.bar2.buttonspacing = 4
		E.db.actionbar.bar2.buttons = 12
		E.db.actionbar.bar2.buttonsize = 28
		E.db.actionbar.bar2.backdrop = false
		E.db.actionbar.bar3.backdrop = true
		E.db.actionbar.bar3.buttonsPerRow = 3
		E.db.actionbar.bar3.buttonsize = 28
		E.db.actionbar.bar3.buttonspacing = 2
		E.db.actionbar.bar3.buttons = 6
		E.db.actionbar.bar4.buttonspacing = 4
		E.db.actionbar.bar4.mouseover = true
		E.db.actionbar.bar4.buttonsize = 24
		E.db.actionbar.bar5.backdrop = true
		E.db.actionbar.bar5.buttonsPerRow = 3
		E.db.actionbar.bar5.buttonsize = 28
		E.db.actionbar.bar5.buttonspacing = 2
		E.db.actionbar.bar5.buttons = 6
		E.db.actionbar.bar6.backdrop = true
		E.db.actionbar.bar6.buttonsPerRow = 1
		E.db.actionbar.bar6.mouseover = true
		E.db.actionbar.bar6.buttons = 4
		E.db.actionbar.bar6.point = 'TOPLEFT'
		E.db.actionbar.barPet.point = 'RIGHT'
		E.db.actionbar.barPet.buttonspacing = 4
		E.db.actionbar.stanceBar.point = 'BOTTOMLEFT'
		E.db.actionbar.stanceBar.backdrop = true
		E.db.actionbar.stanceBar.buttonsPerRow = 6
		E.db.actionbar.stanceBar.buttonsize = 20
	end
	
	do
	-- Auras
		E.db.auras.debuffs.size = 30
		E.db.auras.fadeThreshold = 10
		E.db.auras.font = 'Merathilis Prototype'
		E.db.auras.fontOutline = 'OUTLINE'
		E.db.auras.consolidatedBuffs.fontSize = 11
		E.db.auras.consolidatedBuffs.font = 'Merathilis Visitor1'
		E.db.auras.consolidatedBuffs.fontOutline = 'OUTLINE'
		E.db.auras.consolidatedBuffs.filter = false
		E.db.auras.buffs.fontSize = 12
		E.db.auras.buffs.horizontalSpacing = 5
		E.db.auras.buffs.verticalSpacing = 10
		E.db.auras.buffs.size = 24
		E.db.auras.debuffs.horizontalSpacing = 5
		E.db.auras.debuffs.size = 30
	end
	
	do
	-- Bags
		E.db.bags.itemLevelFont = 'Merathilis Prototype'
		E.db.bags.itemLevelFontSize = 8
		E.db.bags.itemLevelFontOutline = 'OUTLINE'
		E.db.bags.countFont = 'Merathilis Prototype'
		E.db.bags.countFontSize = 11
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
		E.db.chat.font = 'Merathilis Prototype'
		E.db.chat.panelWidth = 350
		E.db.chat.panelHeigth = 150
		E.db.chat.editBoxPosition = 'ABOVE_CHAT'
		E.db.chat.panelBackdrop = 'SHOWBOTH'
		E.db.chat.keywords = '%MYNAME%, ElvUI, Andy'
		E.db.chat.timeStampFormat = '%H:%M '
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
		E.db.tooltip.font = 'Merathilis Prototype'
		E.db.tooltip.fontOutline = 'OUTLINE'
		E.db.tooltip.combathide = true
		E.db.tooltip.style = 'inset'
		E.db.tooltip.itemCount = 'NONE'
		E.db.tooltip.headerFontSize = 11
		E.db.tooltip.textFontSize = 10
		E.db.tooltip.smallTextFontSize = 10
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
		E.db.unitframe.colors.transparentAurabars = true
		E.db.unitframe.colors.transparentPower = true
		E.db.unitframe.colors.transparentCastbar = true
		E.db.unitframe.colors.health.r = 0.235294117647059
		E.db.unitframe.colors.health.g = 0.235294117647059
		E.db.unitframe.colors.health.b = 0.235294117647059
	-- Player
		E.db.unitframe.units.player.width = 220
		E.db.unitframe.units.player.height = 40
		E.db.unitframe.units.player.debuffs.fontSize = 11
		E.db.unitframe.units.player.debuffs.attachTo = 'FRAME'
		E.db.unitframe.units.player.debuffs.sizeOverride = 32
		E.db.unitframe.units.player.debuffs.xOffset = -3
		E.db.unitframe.units.player.debuffs.yOffset = 5
		E.db.unitframe.units.player.debuffs.anchorPoint = 'LEFT'
		E.db.unitframe.units.player.portrait.enable = true
		E.db.unitframe.units.player.portrait.overlay = true
		E.db.unitframe.units.player.portrait.camDistanceScale = 1.35
		E.db.unitframe.units.player.portrait.width = 43
		E.db.unitframe.units.player.classbar.enable = false
		E.db.unitframe.units.player.aurabar.enable = false
		E.db.unitframe.units.player.threatStyle = 'ICONTOPRIGHT'
		E.db.unitframe.units.player.castbar.icon = true
		E.db.unitframe.units.player.castbar.width = 220
		E.db.unitframe.units.player.castbar.height = 18
		E.db.unitframe.units.player.customTexts = {}
		E.db.unitframe.units.player.customTexts.Gesundheit = {}
		E.db.unitframe.units.player.customTexts.Gesundheit.font = 'Merathilis Tukui'
		E.db.unitframe.units.player.customTexts.Gesundheit.justifyH = 'LEFT'
		E.db.unitframe.units.player.customTexts.Gesundheit.fontOutline = 'OUTLINE'
		E.db.unitframe.units.player.customTexts.Gesundheit.xOffset = 0
		E.db.unitframe.units.player.customTexts.Gesundheit.yOffset = 9
		E.db.unitframe.units.player.customTexts.Gesundheit.text_format = '[name:medium] [difficultycolor][smartlevel] [shortclassification]'
		E.db.unitframe.units.player.customTexts.Gesundheit.size = 24
		E.db.unitframe.units.player.customTexts.LevelClass = {}
		E.db.unitframe.units.player.customTexts.LevelClass.font = 'Merathilis Tukui'
		E.db.unitframe.units.player.customTexts.LevelClass.justifyH = 'LEFT'
		E.db.unitframe.units.player.customTexts.LevelClass.fontOutline = 'OUTLINE'
		E.db.unitframe.units.player.customTexts.LevelClass.xOffset = 0
		E.db.unitframe.units.player.customTexts.LevelClass.yOffset = -7
		E.db.unitframe.units.player.customTexts.LevelClass.size = 12
		E.db.unitframe.units.player.customTexts.LevelClass.text_format = '[difficultycolor][level] [race] [namecolor][class]'
		E.db.unitframe.units.player.health.xOffset = -3
		E.db.unitframe.units.player.health.yOffset = -29
		E.db.unitframe.units.player.health.text_format = '[healthcolor][health:percent] - [health:current]'
		E.db.unitframe.units.player.power.xOffset = 5
		E.db.unitframe.units.player.power.yOffset = -29
		E.db.unitframe.units.player.power.height = 5
		E.db.unitframe.units.player.power.hideonnpc = true
		E.db.unitframe.units.player.power.detachedWidth = 298
		E.db.unitframe.units.player.buffs.sizeOverride = 30
		E.db.unitframe.units.player.buffs.yOffset = 2
		E.db.unitframe.units.player.buffs.noDuration = false
		E.db.unitframe.units.player.buffs.attachTo = 'FRAME'
	-- Target
		E.db.unitframe.units.target.width = 220
		E.db.unitframe.units.target.height = 40
		E.db.unitframe.units.target.castbar.latency = true
		E.db.unitframe.units.target.castbar.width = 239.999954223633
		E.db.unitframe.units.target.debuffs.sizeOverride = 32
		E.db.unitframe.units.target.debuffs.yOffset = 5
		E.db.unitframe.units.target.debuffs.xOffset = 3
		E.db.unitframe.units.target.debuffs.anchorPoint = 'RIGHT'
		E.db.unitframe.units.target.debuffs.numrows = 2
		E.db.unitframe.units.target.debuffs.perrow = 3
		E.db.unitframe.units.target.debuffs.attachTo = 'FRAME'
		E.db.unitframe.units.target.aurabar.enable = false
		E.db.unitframe.units.target.aurabar.attachTo = 'BUFFS'
		E.db.unitframe.units.target.name.xOffset = 8
		E.db.unitframe.units.target.name.yOffset = -32
		E.db.unitframe.units.target.name.position = 'RIGHT'
		E.db.unitframe.units.target.name.text_format = ''
		E.db.unitframe.units.target.threatStyle = 'ICONTOPLEFT'
		E.db.unitframe.units.target.power.xOffset = -2
		E.db.unitframe.units.target.power.yOffset = -29
		E.db.unitframe.units.target.power.detachedWidth = 298
		E.db.unitframe.units.target.power.hideonnpc = false
		E.db.unitframe.units.target.power.height = 5
		E.db.unitframe.units.target.customTexts = {}
		E.db.unitframe.units.target.customTexts.Gesundheit = {}
		E.db.unitframe.units.target.customTexts.Gesundheit.font = 'Merathilis Tukui'
		E.db.unitframe.units.target.customTexts.Gesundheit.justifyH = 'RIGHT'
		E.db.unitframe.units.target.customTexts.Gesundheit.fontOutline = 'OUTLINE'
		E.db.unitframe.units.target.customTexts.Gesundheit.xOffset = 8
		E.db.unitframe.units.target.customTexts.Gesundheit.size = 24
		E.db.unitframe.units.target.customTexts.Gesundheit.text_format = '[name:medium] [difficultycolor]'
		E.db.unitframe.units.target.customTexts.Gesundheit.yOffset = 9
		E.db.unitframe.units.target.customTexts.Name1 = {}
		E.db.unitframe.units.target.customTexts.Name1.font = 'Merathilis Tukui'
		E.db.unitframe.units.target.customTexts.Name1.justifyH = 'RIGHT'
		E.db.unitframe.units.target.customTexts.Name1.fontOutline = 'OUTLINE'
		E.db.unitframe.units.target.customTexts.Name1.xOffset = 1
		E.db.unitframe.units.target.customTexts.Name1.size = 12
		E.db.unitframe.units.target.customTexts.Name1.text_format = '[difficultycolor][level] [namecolor][smartclass]'
		E.db.unitframe.units.target.customTexts.Name1.yOffset = -7
		E.db.unitframe.units.target.health.xOffset = 8
		E.db.unitframe.units.target.health.text_format = '[healthcolor][health:percent] - [health:current]'
		E.db.unitframe.units.target.health.yOffset = -29
		E.db.unitframe.units.target.portrait.rotation = 307
		E.db.unitframe.units.target.portrait.overlay = true
		E.db.unitframe.units.target.portrait.xOffset = 0.07
		E.db.unitframe.units.target.portrait.enable = true
		E.db.unitframe.units.target.portrait.camDistanceScale = 1.35
		E.db.unitframe.units.target.buffs.sizeOverride = 21
		E.db.unitframe.units.target.buffs.perrow = 11
		E.db.unitframe.units.target.buffs.fontSize = 12
		E.db.unitframe.units.target.castbar.width = 220
		E.db.unitframe.units.target.castbar.height = 18
	-- TargetTarget
		E.db.unitframe.units.targettarget.debuffs.enable = true
		E.db.unitframe.units.targettarget.power.position = 'CENTER'
		E.db.unitframe.units.targettarget.power.height = 5
		E.db.unitframe.units.targettarget.width = 100
		E.db.unitframe.units.targettarget.name.yOffset = -1
		E.db.unitframe.units.targettarget.health.position = 'CENTER'
		E.db.unitframe.units.targettarget.height = 25
	-- Focus
		E.db.unitframe.units.focus.power.height = 5
		E.db.unitframe.units.focus.width = 122
		E.db.unitframe.units.focus.height = 20
		E.db.unitframe.units.focus.castbar.height = 6
		E.db.unitframe.units.focus.castbar.width = 122
	-- FocusTarget
		E.db.unitframe.units.focustarget.debuffs.enable = true
		E.db.unitframe.units.focustarget.debuffs.anchorPoint = 'TOPRIGHT'
		E.db.unitframe.units.focustarget.threatStyle = 'GLOW'
		E.db.unitframe.units.focustarget.power.enable = true
		E.db.unitframe.units.focustarget.power.height = 5
		E.db.unitframe.units.focustarget.width = 122
		E.db.unitframe.units.focustarget.enable = true
		E.db.unitframe.units.focustarget.height = 20
	-- Raid
		E.db.unitframe.units.raid.horizontalSpacing = 1
		E.db.unitframe.units.raid.debuffs.fontSize = 12
		E.db.unitframe.units.raid.debuffs.enable = true
		E.db.unitframe.units.raid.debuffs.yOffset = -5
		E.db.unitframe.units.raid.debuffs.anchorPoint = 'TOPRIGHT'
		E.db.unitframe.units.raid.debuffs.sizeOverride = 21
		E.db.unitframe.units.raid.rdebuffs.fontSize = 12
		E.db.unitframe.units.raid.numGroups = 4
		E.db.unitframe.units.raid.growDirection = 'RIGHT_UP'
		E.db.unitframe.units.raid.name.xOffset = 2
		E.db.unitframe.units.raid.name.yOffset = -19
		E.db.unitframe.units.raid.name.text_format = '[namecolor][name:short] [difficultycolor][smartlevel]'
		E.db.unitframe.units.raid.name.position = 'CENTER'
		E.db.unitframe.units.raid.buffIndicator.fontSize = 11
		E.db.unitframe.units.raid.buffIndicator.size = 10
		E.db.unitframe.units.raid.roleIcon.size = 12
		E.db.unitframe.units.raid.power.position = 'CENTER'
		E.db.unitframe.units.raid.power.height = 15
		E.db.unitframe.units.raid.healthPrediction = true
		E.db.unitframe.units.raid.width = 69
		E.db.unitframe.units.raid.groupBy = 'ROLE'
		E.db.unitframe.units.raid.health.frequentUpdates = true
		E.db.unitframe.units.raid.health.position = 'CENTER'
		E.db.unitframe.units.raid.health.text_format = '[health:deficit]'
		E.db.unitframe.units.raid.buffs.enable = true
		E.db.unitframe.units.raid.buffs.yOffset = 42
		E.db.unitframe.units.raid.buffs.anchorPoint = 'BOTTOMLEFT'
		E.db.unitframe.units.raid.buffs.clickTrough = true
		E.db.unitframe.units.raid.buffs.useBlacklist = false
		E.db.unitframe.units.raid.buffs.noDuration = false
		E.db.unitframe.units.raid.buffs.playerOnly = false
		E.db.unitframe.units.raid.buffs.perrow = 1
		E.db.unitframe.units.raid.buffs.useFilter = 'TurtleBuffs'
		E.db.unitframe.units.raid.buffs.noConsolidated = false
		E.db.unitframe.units.raid.buffs.sizeOverride = 22
		E.db.unitframe.units.raid.buffs.xOffset = 30
		E.db.unitframe.units.raid.height = 40
		E.db.unitframe.units.raid.verticalSpacing = 10
		E.db.unitframe.units.raid.raidicon.attachTo = 'LEFT'
		E.db.unitframe.units.raid.raidicon.xOffset = 9
		E.db.unitframe.units.raid.raidicon.size = 13
		E.db.unitframe.units.raid.raidicon.yOffset = 0
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
		E.db.unitframe.units.raid40.roleIcon.position = 'TOPRIGHT'
		E.db.unitframe.units.raid40.roleIcon.enable = true
		E.db.unitframe.units.raid40.raidWideSorting = false
		E.db.unitframe.units.raid40.power.enable = true
		E.db.unitframe.units.raid40.power.position = 'CENTER'
		E.db.unitframe.units.raid40.power.height = 5
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
	-- Party
		E.db.unitframe.units.party.debuffs.fontSize = 12
		E.db.unitframe.units.party.debuffs.sizeOverride = 21
		E.db.unitframe.units.party.debuffs.yOffset = -7
		E.db.unitframe.units.party.debuffs.anchorPoint = 'TOPRIGHT'
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
		E.db.unitframe.units.party.power.height = 15
		E.db.unitframe.units.party.positionOverride = 'BOTTOM'
		E.db.unitframe.units.party.width = 69
		E.db.unitframe.units.party.groupBy = 'ROLE'
		E.db.unitframe.units.party.health.frequentUpdates = true
		E.db.unitframe.units.party.health.position = 'BOTTOM'
		E.db.unitframe.units.party.health.text_format = ''
		E.db.unitframe.units.party.petsGroup.anchorPoint = 'BOTTOM'
		E.db.unitframe.units.party.buffs.enable = true
		E.db.unitframe.units.party.buffs.yOffset = 28
		E.db.unitframe.units.party.buffs.anchorPoint = 'BOTTOMLEFT'
		E.db.unitframe.units.party.buffs.clickTrough = true
		E.db.unitframe.units.party.buffs.useBlacklist = false
		E.db.unitframe.units.party.buffs.noDuration = false
		E.db.unitframe.units.party.buffs.playerOnly = false
		E.db.unitframe.units.party.buffs.perrow = 1
		E.db.unitframe.units.party.buffs.useFilter = 'TurtleBuffs'
		E.db.unitframe.units.party.buffs.noConsolidated = false
		E.db.unitframe.units.party.buffs.sizeOverride = 22
		E.db.unitframe.units.party.buffs.xOffset = 30
	-- Assist
		E.db.unitframe.units.assist.targetsGroup.enable = false
	-- Pet
		E.db.unitframe.units.pet.castbar.latency = true
		E.db.unitframe.units.pet.castbar.width = 102
		E.db.unitframe.units.pet.width = 102
		E.db.unitframe.units.pet.height = 24
		E.db.unitframe.units.pet.power.height = 5
	-- Arena
		E.db.unitframe.units.arena.power.width = 'inset'
	-- Boss
		E.db.unitframe.units.boss.castbar.latency = true
		E.db.unitframe.units.boss.portrait.enable = true
		E.db.unitframe.units.boss.power.height = 10
		E.db.unitframe.units.boss.width = 215
		E.db.unitframe.units.boss.height = 45
		E.db.unitframe.units.boss.threatStyle = 'BORDERS'
	-- PetTarget
		E.db.unitframe.units.pettarget.power.width = 'inset'
	end
	
	-- Movers
	if E.db.movers == nil then E.db.movers = {} end -- prevent a lua error when running the install after a profile gets deleted.
	do
	-- PlayerMover
		SetMoverPosition('ElvUF_PlayerMover', 'BOTTOM', E.UIParent, 'BOTTOM', -179, 147)
		SetMoverPosition('ElvUF_PlayerCastbarMover', 'BOTTOM', E.UIParent, 'BOTTOM', -179, 110)
	-- TargetMover
		SetMoverPosition('ElvUF_TargetMover', 'BOTTOM', E.UIParent, 'BOTTOM', 179, 147)
		SetMoverPosition('ElvUF_TargetCastbarMover', 'BOTTOM', E.UIParent, 'BOTTOM', 179, 110)
	-- ...
		SetMoverPosition('MinimapMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -5, -6)
		SetMoverPosition('DebuffsMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -158, -115)
	-- AlertFrame for Garrison etc.
		SetMoverPosition('AlertFrameMover', 'TOP', E.UIParent, 'TOP', 0, -140)
	-- ...
		SetMoverPosition('TooltipMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', 0, 340)
		SetMoverPosition('ElvUF_BodyGuardMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -413, 195)
		SetMoverPosition('ElvUF_PartyMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 2, 171)
		SetMoverPosition('WatchFrameMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -122, -292)
		SetMoverPosition('BossHeaderMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -38, -344)
		SetMoverPosition('Top_Center_Mover', 'BOTTOM', E.UIParent, 'BOTTOM', -250, 2)
		SetMoverPosition('ElvAB_6', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -367, 49)
		SetMoverPosition('PetAB', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 191)
		SetMoverPosition('TargetPowerBarMover', 'BOTTOM', E.UIParent, 'BOTTOM', 203, 429)
		SetMoverPosition('VehicleSeatMover', 'TOPLEFT', E.UIParent, 'TOPLEFT', 2, -84)
		SetMoverPosition('TotemBarMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 368, 3)
		SetMoverPosition('TempEnchantMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -5, -299)
		SetMoverPosition('ElvAB_5', 'BOTTOM', E.UIParent, 'BOTTOM', -241, 32)
		SetMoverPosition('ElvAB_3', 'BOTTOM', E.UIParent, 'BOTTOM', 241, 32)
		SetMoverPosition('ReputationBarMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -353, 23)
		SetMoverPosition('ExperienceBarMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 353, 23)
		SetMoverPosition('ElvAB_2', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 58)
		SetMoverPosition('ElvAB_1', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 26)
		SetMoverPosition('ArenaHeaderMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -150, -305)
		SetMoverPosition('ElvUF_Raid40Mover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 2, 171)
		SetMoverPosition('ElvUF_Raid25Mover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 2, 200)
		SetMoverPosition('ShiftAB', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 791, 97)
		SetMoverPosition('MicrobarMover', 'TOPLEFT', E.UIParent, 'TOPLEFT', 4, -4)
		SetMoverPosition('ClassBarMover', 'BOTTOM', E.UIParent, 'BOTTOM', -1, 349)
		SetMoverPosition('ElvUF_FocusMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -413, 239)
		SetMoverPosition('DigSiteProgressBarMover', 'TOP', E.UIParent, 'TOP', -2, 0)
		SetMoverPosition('FlareMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 253)
		SetMoverPosition('LocationMover', 'TOP', E.UIParent, 'TOP', 0, -7)
		SetMoverPosition('GMMover', 'TOPLEFT', E.UIParent, 'TOPLEFT', 329, 0)
		SetMoverPosition('LeftChatMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 2, 23)
		SetMoverPosition('ElvUF_RaidMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 2, 171)
		SetMoverPosition('ElvUF_AssistMover', 'TOPLEFT', E.UIParent, 'BOTTOMLEFT', 2, 571)
		SetMoverPosition('RightChatMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -2, 23)
		SetMoverPosition('UIBFrameMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -44, -161)
		SetMoverPosition('BNETMover', 'TOP', E.UIParent, 'TOP', 0, -38)
		SetMoverPosition('ObjectiveFrameMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -200, -281)
		SetMoverPosition('AltPowerBarMover', 'TOP', E.UIParent, 'TOP', 1, -272)
		SetMoverPosition('ElvAB_4', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', 0, 367)
		SetMoverPosition('Bottom_Panel_Mover', 'BOTTOM', E.UIParent, 'BOTTOM', 250, 2)
		SetMoverPosition('LossControlMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 432)
		SetMoverPosition('ElvUF_TargetTargetMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 162)
		SetMoverPosition('ElvUF_PetMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 135)
		SetMoverPosition('ElvUF_PetCastbarMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 114)
		SetMoverPosition('MarkMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 167)
		SetMoverPosition('PlayerPortraitMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 584, 177)
		SetMoverPosition('ElvUF_RaidpetMover', 'TOPLEFT', E.UIParent, 'BOTTOMLEFT', 0, 808)
		SetMoverPosition('LootFrameMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -495, -457)
		SetMoverPosition('BossButton', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 442, 125)
		SetMoverPosition('ElvUF_Raid10Mover', 'BOTTOM', E.UIParent, 'BOTTOM', 1, 282)
		SetMoverPosition('NemoMover', 'TOP', E.UIParent, 'TOP', -277, -540)
		SetMoverPosition('BuffsMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -158, -10)
		SetMoverPosition('ElvUF_FocusTargetMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -413, 273)
		SetMoverPosition('MinimapButtonAnchor', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -5, -231)
		SetMoverPosition('ElvUF_FocusCastbarMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -413, 228)
	end
	
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format('ChatFrame%s', i)]
		local chatFrameId = frame:GetID()
		local chatName = FCF_GetChatWindowInfo(chatFrameId)
		
		FCF_SetChatWindowFontSize(nil, frame, 10)
		
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
	end
	
	if InstallStepComplete then
		InstallStepComplete.message = MER.Title..L['MerathilisUI Set']
		InstallStepComplete:Show()		
	end
	E:UpdateAll(true)
end
	-- Addons
	-- AddOnSkins
local function SetupAddOnSkins()
	if IsAddOnLoaded('AddOnSkins') then
		-- reset the embeds in case of Skada/Recount swap
		E.private['addonskins']['EmbedSystem'] = nil
		E.private['addonskins']['EmbedSystemDual'] = nil
		E.private['addonskins']['EmbedBelowTop'] = nil
		E.private['addonskins']['TransparentEmbed'] = nil
		E.private['addonskins']['RecountBackdrop'] = false
		E.private['addonskins']['EmbedMain'] = nil
		E.private['addonskins']['EmbedLeft'] = nil
		E.private['addonskins']['EmbedRight'] = nil
		
		if IsAddOnLoaded('Skada') then
			E.private['addonskins']['EmbedSystem'] = false
			E.private['addonskins']['EmbedSystemDual'] = true
			E.private['addonskins']['EmbedBelowTop'] = false
			E.private['addonskins']['TransparentEmbed'] = true
			E.private['addonskins']['SkadaBackdrop'] = false
			E.private['addonskins']['EmbedMain'] = 'Skada'
			E.private['addonskins']['EmbedLeft'] = 'Skada'
			E.private['addonskins']['EmbedRight'] = 'Skada'
		end
		
		E.private.addonskins.Blizzard_WorldStateCaptureBar = true
		E.private.addonskins.WeakAuraBar = true
		E.private.addonskins.ParchmentRemover = true
		E.private.addonskins.DetailsBackdrop = true
		E.private.addonskins.BigWigsHalfBar = true
		E.private.addonskins.SkadaBackdrop = false
		E.private.addonskins.Blizzard_ExtraActionButton = true
		E.private.addonskins.SkinDebug = true
		E.private.addonskins.SkadaSkin = true
		E.private.addonskins.EmbedLeftWidth = 170
		E.private.addonskins.CliqueSkin = true
		E.private.addonskins.Blizzard_DeathRecap = true
		E.private.addonskins.Blizzard_Friends = true
		E.private.addonskins.Blizzard_DraenorAbilityButton = true
	end
end

local skadaName = GetAddOnMetadata('Skada', 'Title')
local bigwigsName = GetAddOnMetadata('BigWigs', 'Title')
local xctName = GetAddOnMetadata('xCT+', 'Title')

local function SetupMERAddons()
	-- Skada Profile
	if IsAddOnLoaded('Skada') then
		print(MER.Title..format(L[' - %s profile created!'], skadaName))
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
						["fontflags"] = "",
						["height"] = 17,
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
					["barfont"] = "Merathilis Prototype",
					["name"] = "DPS",
				}, -- [1]
				{
					["barheight"] = 16,
					["classicons"] = false,
					["barslocked"] = true,
					["enabletitle"] = true,
					["wipemode"] = "",
					["set"] = "current",
					["hidden"] = false,
					["y"] = 9,
					["barfont"] = "Merathilis Prototype",
					["name"] = "HPS",
					["display"] = "bar",
					["barfontflags"] = "",
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
						["fontsize"] = 17,
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
					["barwidth"] = 205.428512573242,
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
						["height"] = 140.42854309082,
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
			E.db.bui.StyleColor = 1
			E.db.bui.abStyleColor = 1
			E.db.dashboards.system.enableSystem = false
			E.db.dashboards.tokens.enableTokens = true
			E.db.dashboards.professions.enableProfessions = false
			SetMoverPosition('BuiMiddleDtMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 2)
			SetMoverPosition('tokenHolderMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -1, -146)
		end
	end
	
	do
	-- LocationPlus
		if E.db.locplus == nil then E.db.locplus = {} end
		if IsAddOnLoaded('ElvUI_LocPlus') then
			E.db.locplus.lpfont = 'Merathilis Roadway'
			E.db.locplus.dtheight = 17
			E.db.locplus.fish = false
			E.db.locplus.lpwidth = 220
			E.db.locplus.petlevel = false
			E.db.locplus.ttreczones = false
			E.db.locplus.ttinst = false
			E.db.locplus.lpfontsize = 15
			E.db.locplus.lpfontflags = 'OUTLINE'
			E.db.locplus.ttrecinst = false
			E.db.locplus.ht = true
			E.db.locplus.displayOther = 'NONE'
			E.db.locplus.profcap = true
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
			E.db.VAT.barHeight = 6
			E.db.VAT.spacing = 0
			E.db.VAT.staticColor.r = 1
			E.db.VAT.staticColor.g = 0.5
			E.db.VAT.staticColor.b = 0
			E.db.VAT.showText = false
			E.db.VAT.colors.minutesIndicator.r = 1
			E.db.VAT.colors.minutesIndicator.g = 0.5
			E.db.VAT.colors.minutesIndicator.b = 0
			E.db.VAT.colors.hourminutesIndicator.r = 1
			E.db.VAT.colors.hourminutesIndicator.g = 0.5
			E.db.VAT.colors.hourminutesIndicator.b = 0
			E.db.VAT.colors.expireIndicator.r = 1
			E.db.VAT.colors.expireIndicator.g = 0.5
			E.db.VAT.colors.expireIndicator.b = 0
			E.db.VAT.colors.secondsIndicator.r = 1
			E.db.VAT.colors.secondsIndicator.g = 0.5
			E.db.VAT.colors.secondsIndicator.b = 0
			E.db.VAT.colors.daysIndicator.r = 1
			E.db.VAT.colors.daysIndicator.g = 0.5
			E.db.VAT.colors.daysIndicator.b = 0
			E.db.VAT.colors.hoursIndicator.r = 1
			E.db.VAT.colors.hoursIndicator.r = 0.5
			E.db.VAT.colors.hoursIndicator.r = 0
			E.db.VAT.decimalThreshold = 5
			E.db.VAT.statusbarTexture = 'MerathilisFlat'
			E.db.VAT.position = 'TOP'
		end
	end
	
	if IsAddOnLoaded('BigWigs') then
		print(MER.Title..format(L['- %s profile created!'], bigwigsName))
		BigWigs3DB = {
			["namespaces"] = {
				["BigWigs_Plugins_Alt Power"] = {
					["profiles"] = {
						["MerathilisUI"] = {
							["posx"] = 810.718497504029,
							["fontSize"] = 10.9999990463257,
							["font"] = "Merathilis Prototype",
							["fontOutline"] = "",
							["lock"] = true,
							["posy"] = 202.206108761591,
						},
					},
				},
				["LibDualSpec-1.0"] = {
				},
				["BigWigs_Plugins_Victory"] = {
				},
				["BigWigs_Plugins_Statistics"] = {
				},
				["BigWigs_Plugins_Sounds"] = {
				},
				["BigWigs_Plugins_Messages"] = {
					["profiles"] = {
						["MerathilisUI"] = {
							["BWEmphasizeMessageAnchor_x"] = 548.018613931999,
							["BWEmphasizeCountdownMessageAnchor_x"] = 594.167263362324,
							["BWMessageAnchor_x"] = 547.937125897879,
							["chat"] = false,
							["BWEmphasizeCountdownMessageAnchor_y"] = 542.227131600485,
							["font"] = "Merathilis Prototype",
							["BWEmphasizeMessageAnchor_y"] = 634.599967567738,
							["BWMessageAnchor_y"] = 482.660092769766,
							["growUpwards"] = true,
							["fontSize"] = 20,
						},
					},
				},
				["BigWigs_Plugins_Proximity"] = {
					["profiles"] = {
						["MerathilisUI"] = {
							["fontSize"] = 20,
							["width"] = 140.000030517578,
							["posy"] = 139.937301559658,
							["lock"] = false,
							["posx"] = 316.168293714338,
							["sound"] = true,
							["font"] = "Merathilis Prototype",
						},
					},
				},
				["BigWigs_Plugins_BossBlock"] = {
				},
				["BigWigs_Plugins_HeroesVoices"] = {
				},
				["BigWigs_Plugins_Raid Icons"] = {
				},
				["BigWigs_Plugins_Bars"] = {
					["profiles"] = {
						["MerathilisUI"] = {
							["outline"] = "OUTLINE",
							["fontSize"] = 20,
							["scale"] = 0.9,
							["BigWigsAnchor_y"] = 143.539996791631,
							["emphasizeGrowup"] = true,
							["BigWigsAnchor_x"] = 951.685603728169,
							["texture"] = "MerathilisFlat",
							["emphasizeTime"] = 14,
							["barStyle"] = "AddOnSkins Half-Bar",
							["monochrome"] = false,
							["BigWigsEmphasizeAnchor_x"] = 445.301161921743,
							["font"] = "Merathilis Roadway",
							["BigWigsEmphasizeAnchor_y"] = 188.360327821069,
							["fill"] = false,
							["BigWigsAnchor_width"] = 363.885375976563,
							["BigWigsEmphasizeAnchor_width"] = 532.931091308594,
							["emphasizeScale"] = 1.1,
						},
					},
				},
				["BigWigs_Plugins_Super Emphasize"] = {
					["profiles"] = {
						["MerathilisUI"] = {
							["font"] = "Merathilis Prototype",
						},
					},
				},
				["BigWigs_Plugins_Colors"] = {
				},
				["BigWigs_Plugins_Respawn"] = {
				},
				["global"] = {
					["watchedMovies"] = {
						["993:2"] = true,
						["984:1"] = {
							true, -- [1]
							[3] = true,
						},
						["964:1"] = true,
						["969:2"] = true,
						[294] = true,
						[295] = true,
						["994:3"] = true,
						["993:4"] = true,
					},
				},
				["profiles"] = {
					["MerathilisUI"] = {
						["fakeDBMVersion"] = true,
					},
				},
			},
		}
	end
	
	-- xCT Profile
	if IsAddOnLoaded('xCT+') then
		print(MER.Title..format(L['- %s profile created!'], xctName))
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
		}
	end
	
	if InstallStepComplete then
		InstallStepComplete.message = MER.Title..L['Addons Set']
		InstallStepComplete:Show()		
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
			
			if IsAddOnLoaded('ElvUI_SystemDT') then
				E.db.datatexts.panels.BuiMiddleDTPanel.left = 'Improved System'
			else
				E.db.datatexts.panels.BuiMiddleDTPanel.left = 'System'
			end
			E.db.datatexts.panels.BuiMiddleDTPanel.middle = 'Time'
		else
			-- define the default ElvUI datatexts
			if role == 'tank' then
				E.db.datatext.panels.LeftChatDataPanel.right = 'Attack Power'
			elseif role == 'dpsMelee' then
				E.db.datatext.panels.LeftChatDataPanel.right = 'Attack Power'
			elseif role == 'healer' or 'dpsCaster' then
				E.db.datatext.panels.LeftChatDataPanel.right = 'Spell/Heal Power'
			end
			E.db.datatext.panels.LeftChatDataPanel.left = 'Talent/Loot Specialization'
			E.db.datatext.panels.LeftChatDataPanel.middle = 'Durability'
			
			if IsAddOnLoaded('Skada') then
				E.db.datatext.panels.RightChatDataPanel.left = 'Skada'
			else
				E.db.datatext.panels.RightChatDataPanel.left = 'System'
			end
			E.db.datatext.panels.RightChatDataPanel.middle = 'Time'
			E.db.datatext.panels.RightChatDataPanel.right = 'Gold'
		end
	
	if InstallStepComplete then
		InstallStepComplete.message = MER.Title..L['DataTexts Set']
		InstallStepComplete:Show()		
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
	MERInstallFrame.SubTitle:SetText('')
	MERInstallFrame.Desc1:SetText('')
	MERInstallFrame.Desc2:SetText('')
	MERInstallFrame.Desc3:SetText('')
	MERInstallFrame.Desc4:SetText('')
	MERInstallFrame:Size(550, 400)
end

local function InstallComplete()
	E.private.install_complete = E.version
	E.db.Merathilis.installed = true
	
	ReloadUI()
end

local function SetPage(PageNum)
	CURRENT_PAGE = PageNum
	ResetAll()
	InstallStatus:SetValue(PageNum)
	
	local f = MERInstallFrame
	
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
		f.SubTitle:SetText(format(L['Welcome to MerathilisUI version %s, for ElvUI %s.'], MER.Version, E.version))
		f.Desc1:SetText(L["By pressing the Continue button, MerathilisUI will be applied in your current ElvUI installation.\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"])
		f.Desc2:SetText(L['Please press the continue button to go onto the next step.'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', InstallComplete)
		InstallOption1Button:SetText(L['Skip Process'])			
	elseif PageNum == 2 then
		f.SubTitle:SetText(L['Layout'])
		f.Desc1:SetText(L['This part of the installation changes the default ElvUI look.'])
		f.Desc2:SetText(L['Please click the button below to apply the new layout.'])
		f.Desc3:SetText(L['Importance: |cff07D400High|r'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', SetupMERLayout)
		InstallOption1Button:SetText(L['Setup Layout'])
	elseif PageNum == 3 then
		f.SubTitle:SetText(L['DataTexts'])
		f.Desc1:SetText(L["This part of the installation process will fill MerathilisUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"])
		f.Desc2:SetText(L['Please click the button below to setup your datatexts.'])
		f.Desc3:SetText(L['Importance: |cffD3CF00Medium|r'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() MER:SetupDts('tank') end)
		InstallOption1Button:SetText(TANK)
		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() MER:SetupDts('healer') end)
		InstallOption2Button:SetText(HEALER)
		InstallOption3Button:Show()
		InstallOption3Button:SetScript('OnClick', function() MER:SetupDts('dpsMelee') end)
		InstallOption3Button:SetText(L['Physical DPS'])
		InstallOption4Button:Show()
		InstallOption4Button:SetScript('OnClick', function() MER:SetupDts('dpsCaster') end)
		InstallOption4Button:SetText(L['Caster DPS'])
	elseif PageNum == 4 then
		f.SubTitle:SetText(ADDONS)
		f.Desc1:SetText(L['This part of the installation process will apply changes to the addons like Skada, BigWigs and ElvUI plugins'])
		f.Desc2:SetText(L['Please click the button below to setup your addons.'])
		f.Desc3:SetText(L['Importance: |cffD3CF00Medium|r'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() SetupMERAddons(); SetupAddOnSkins(); end)
		InstallOption1Button:SetText(L['Setup Addons'])	
	elseif PageNum == 5 then
		f.SubTitle:SetText(L['Installation Complete'])
		f.Desc1:SetText(L['You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org.'])
		f.Desc2:SetText(L['Please click the button below so you can setup variables and ReloadUI.'])			
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', InstallComplete)
		InstallOption1Button:SetText(L['Finished'])				
		MERInstallFrame:Size(550, 350)
		if InstallStepComplete then
			InstallStepComplete.message = MER.Title..L['Installed']
			InstallStepComplete:Show()		
		end
	end
end

local function NextPage()	
	if CURRENT_PAGE ~= MAX_PAGE then
		CURRENT_PAGE = CURRENT_PAGE + 1
		SetPage(CURRENT_PAGE)
	end
end

local function PreviousPage()
	if CURRENT_PAGE ~= 1 then
		CURRENT_PAGE = CURRENT_PAGE - 1
		SetPage(CURRENT_PAGE)
	end
end

function MER:SetupUI()	
	if not InstallStepComplete then
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
	if not MERInstallFrame then
		local f = CreateFrame('Button', 'MERInstallFrame', E.UIParent)
		f.SetPage = SetPage
		f:Size(550, 400)
		f:SetTemplate('Transparent')
		f:SetPoint('CENTER')
		f:SetFrameStrata('TOOLTIP')
		--f:Style('Outside')
		
		f.Title = f:CreateFontString(nil, 'OVERLAY')
		f.Title:FontTemplate(nil, 17, nil)
		f.Title:Point('TOP', 0, -5)
		f.Title:SetText(MER.Title..L['Installation'])
		
		f.Next = CreateFrame('Button', 'InstallNextButton', f, 'UIPanelButtonTemplate')
		f.Next:StripTextures()
		f.Next:SetTemplate('Default', true)
		f.Next:Size(110, 25)
		f.Next:Point('BOTTOMRIGHT', -5, 5)
		f.Next:SetText(CONTINUE)
		f.Next:Disable()
		f.Next:SetScript('OnClick', NextPage)
		E.Skins:HandleButton(f.Next, true)
		
		f.Prev = CreateFrame('Button', 'InstallPrevButton', f, 'UIPanelButtonTemplate')
		f.Prev:StripTextures()
		f.Prev:SetTemplate('Default', true)
		f.Prev:Size(110, 25)
		f.Prev:Point('BOTTOMLEFT', 5, 5)
		f.Prev:SetText(PREVIOUS)	
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
		f.Status.text = f.Status:CreateFontString(nil, 'OVERLAY')
		f.Status.text:FontTemplate()
		f.Status.text:SetPoint('CENTER')
		f.Status.text:SetText(CURRENT_PAGE..' / '..MAX_PAGE)
		f.Status:SetScript('OnValueChanged', function(self)
			self.text:SetText(self:GetValue()..' / '..MAX_PAGE)
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
		f.Option3:SetScript('OnShow', function() f.Option1:SetWidth(100); f.Option1:ClearAllPoints(); f.Option1:Point('RIGHT', f.Option2, 'LEFT', -4, 0); f.Option2:SetWidth(100); f.Option2:ClearAllPoints(); f.Option2:Point('BOTTOM', f, 'BOTTOM', 0, 45)  end)
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
		f.Desc1:Point('TOPLEFT', 20, -75)	
		f.Desc1:Width(f:GetWidth() - 40)
		
		f.Desc2 = f:CreateFontString(nil, 'OVERLAY')
		f.Desc2:FontTemplate()	
		f.Desc2:Point('TOPLEFT', 20, -125)		
		f.Desc2:Width(f:GetWidth() - 40)
		
		f.Desc3 = f:CreateFontString(nil, 'OVERLAY')
		f.Desc3:FontTemplate()	
		f.Desc3:Point('TOPLEFT', 20, -175)	
		f.Desc3:Width(f:GetWidth() - 40)
		
		f.Desc4 = f:CreateFontString(nil, 'OVERLAY')
		f.Desc4:FontTemplate()	
		f.Desc4:Point('BOTTOMLEFT', 20, 75)	
		f.Desc4:Width(f:GetWidth() - 40)
	
		local close = CreateFrame('Button', 'InstallCloseButton', f, 'UIPanelCloseButton')
		close:SetPoint('TOPRIGHT', f, 'TOPRIGHT')
		close:SetScript('OnClick', function()
			f:Hide()
		end)		
		E.Skins:HandleCloseButton(close)
		
		f.tutorialImage = f:CreateTexture('InstallTutorialImage', 'OVERLAY')
		f.tutorialImage:Size(256, 128)
		f.tutorialImage:SetTexture('Interface\\AddOns\\MerathilisUI\\media\\textures\\merathilis_logo.tga')
		f.tutorialImage:Point('BOTTOM', 0, 70)

	end
	
	MERInstallFrame:Show()
	NextPage()
end
