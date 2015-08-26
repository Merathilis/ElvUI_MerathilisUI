local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:NewModule('MerathilisUI', "AceConsole-3.0");

local LSM = LibStub('LibSharedMedia-3.0')
local EP = LibStub('LibElvUIPlugin-1.0')
local addon, ns = ...

-- Profile (if this gets big, move it to a seperate file but load before your core.lua. Put it in the .toc file)
-- In case you create options, also add them here
P['Merathilis'] = {
	['installed'] = nil,
}

-- local means that this function is used in this file only and cannot be accessed from other files/addons.
-- A local function must be above the global ones (e.g. MER:SetupUI()). Globals can be accessed from other files/addons
-- Also local functions take less memory
local function SetMoverPosition(mover, point, anchor, secondaryPoint, x, y)
	if not _G[mover] then return end
	local frame = _G[mover]

	frame:ClearAllPoints()
	frame:SetPoint(point, anchor, secondaryPoint, x, y)
	E:SaveMoverPosition(mover)
end

-- local functions must go up
local function SetupUI() -- this cannot be local when using the module name (MER)
	-- Here you put ElvUI settings that you want enabled or not.
	-- Opening ElvUI.lua file from the WTF folder will show you your current profile settings.
	do
		-- General
		E.db.general.totems.size = 36
		E.db.general.font = 'Andy Prototype'
		E.db.general.fontSize = 11
		E.db.general.interruptAnnounce = "RAID"
		E.db.general.autoRepair = "GUILD"
		E.db.general.minimap.garrisonPos = "TOPRIGHT"
		E.db.general.minimap.icons.garrison.scale = 0.9
		E.db.general.minimap.icons.garrison.position = "TOPRIGHT"
		E.db.general.minimap.icons.garrison.yOffset = 10
		E.db.general.minimap.size = 150
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
		E.private.general.namefont = 'Andy Prototype'
		E.private.general.dmgfont = 'ElvUI Combat'
		E.private.general.normTex = 'AndyFlat'
		E.private.general.glossTex = 'AndyFlat'
		E.private.skins.blizzard.alertframes = true
		E.private.skins.blizzard.questChoice = true
	end
	
	do
		-- Actionbars
		E.db.actionbar.font = 'Andy Prototype'
		E.db.actionbar.fontOutline = 'OUTLINE'
		E.db.actionbar.macrotext = true
		
		E.db.actionbar.bar1.buttonspacing = 4
		E.db.actionbar.bar1.backdrop = true
		E.db.actionbar.bar1.heightMult = 2
		E.db.actionbar.bar1.buttonsize = 30
		E.db.actionbar.bar2.enable = true
		E.db.actionbar.bar2.buttonspacing = 4
		E.db.actionbar.bar2.buttonsize = 30
		E.db.actionbar.bar3.backdrop = true
		E.db.actionbar.bar3.buttonPerRow = 3
		E.db.actionbar.bar3.buttonsize = 30
		E.db.actionbar.bar4.buttonspacing = 4
		E.db.actionbar.bar4.mousover = true
		E.db.actionbar.bar4.buttonsize = 26
		E.db.actionbar.bar5.backdrop = true
		E.db.actionbar.bar5.buttonPerRow = 3
		E.db.actionbar.bar5.buttonsize = 30
		E.db.actionbar.bar6.backdrop = true
		E.db.actionbar.bar6.buttonsPerRow = 1
		E.db.actionbar.bar6.mousover = true
		E.db.actionbar.bar6.buttons = 4
		-- ExtraActionButtons
		--E.db.actionbar.bar8.buttons = 6
		--E.db.actionbar.bar8.mousover = true
		--E.db.actionbar.bar8.buttonsPerRow = 1
		--E.db.actionbar.bar8.buttonsize = 24
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
		E.db.auras.font = 'Andy Prototype'
		E.db.auras.fontOutline = 'OUTLINE'
		E.db.auras.consolidatedBuffs.fontSize = 11
		E.db.auras.consolidatedBuffs.font = 'Andy Prototype'
		E.db.auras.consolidatedBuffs.fontOutline = 'OUTLINE'
		E.db.auras.consolidatedBuffs.filter = false
		E.db.auras.buffs.fontSize = 12
		E.db.auras.buffs.horizontalSpacing = 15
		E.db.auras.buffs.verticalSpacing = 15
		E.db.auras.buffs.size = 28
	end
	
	do
		-- Bags
		E.db.bags.itemLevelFont = 'Andy Prototype'
		E.db.bags.itemLevelFontSize = 8
		E.db.bags.itemLevelFontOutline = 'OUTLINE'
		E.db.bags.countFont = 'Andy Prototype'
		E.db.bags.countFontSize = 11
		E.db.bags.countFontOutline = 'OUTLINE'
		E.db.bags.yOffsetBank = 235
		E.db.bags.bagSize = 25
		E.db.bags.alignToChat = false
		E.db.bags.bagWidth = 450
		E.db.bags.bankSize = 25
		E.db.bags.bankWidth = 450
		E.db.bags.moneyFormat = 'BLIZZARD'
		E.db.bags.itemLevelThreshold = 650
	end
	
	do
		-- Chat
		E.db.chat.tabFontOutline = 'OUTLINE'
		E.db.chat.keywordSound = 'Whisper Alert'
		E.db.chat.tabFont = 'Andy Prototype'
		E.db.chat.panelTabTransparency = true
		E.db.chat.fontOutline = 'OUTLINE'
		E.db.chat.chatHistory = false
		E.db.chat.font = 'Andy Prototype'
		E.db.chat.panelWidth = 400
		E.db.chat.editBoxPosition = 'ABOVE_CHAT'
		E.db.chat.panelBackdrop = 'HIDEBOTH'
		E.db.chat.keywords = '%MYNAME%, ElvUI, Andy'
		E.db.chat.timeStampFormat = '%H:%M '
		E.db.chat.panelHeigth = 150
	end
	
	do
		-- Datatexts
		E.db.datatexts.font = 'Andy Roadway'
		E.db.datatexts.fontSize = 14
		E.db.datatexts.fontOutline = 'OUTLINE'
		E.db.datatexts.leftChatPanel = false
		E.db.datatexts.rightChatPanel = false
		E.db.datatexts.time24 = true
		E.db.datatexts.minimapPanels = false
		E.db.datatexts.panelTransparency = false
		E.db.datatexts.actionbar3 = false
		E.db.datatexts.actionbar5 = false
		E.db.datatexts.goldCoins = true
		E.db.datatexts.noCombatHover = true
		
		E.db.datatexts.panels.RightChatDataPanel.right = ''
		E.db.datatexts.panels.RightChatDataPanel.left = ''
		E.db.datatexts.panels.RightChatDataPanel.middle = ''
		E.db.datatexts.panels.LeftChatDataPanel.right = ''
		E.db.datatexts.panels.LeftChatDataPanel.left = ''
		E.db.datatexts.panels.LeftChatDataPanel.middle = ''
		E.db.datatexts.panels.RightMiniPanel = ''
		E.db.datatexts.panels.Actionbar3DataPanel = ''
		E.db.datatexts.panels.Top_Center = ''
		E.db.datatexts.panels.LeftMiniPanel = ''
		E.db.datatexts.panels.Actionbar5DataPanel = ''
	end
	
	do
		-- Nameplates
		E.db.nameplate.font = 'Andy Roadway'
		E.db.nameplate.fontSize = 11
		E.db.nameplate.fontOutline = 'OUTLINE'
		E.db.nameplate.debuffs.font = 'Andy Prototype'
		E.db.nameplate.debuffs.fontSize = 9
		E.db.nameplate.debuffs.fontOutline = 'OUTLINE'
		E.db.nameplate.auraFontOutline = 'OUTLINE'
		E.db.nameplate.maxAuras = 5
		E.db.nameplate.comboPoints = true
		E.db.nameplate.sortDirection = 1
		E.db.nameplate.colorByTime = true
		E.db.nameplate.buffs.font = 'Andy Prototype'
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
		E.db.nameplate.buffs.font = 'Andy Prototype'
	end
	
	do
		-- Tooltip
		E.db.tooltip.font = 'Andy Prototype'
		E.db.tooltip.fontOutline = 'OUTLINE'
		E.db.tooltip.combathide = true
		E.db.tooltip.style = 'inset'
		E.db.tooltip.itemCount = 'NONE'
		E.db.tooltip.headerFontSize = 14
		E.db.tooltip.textFontSize = 11
		E.db.tooltip.smallTextFontSize = 11
		E.db.tooltip.healthBar.font = 'Andy Prototype'
		E.db.tooltip.healthBar.fontSize = 10
		E.db.tooltip.healthBar.fontOutline = 'OUTLINE'
		E.db.tooltip.healthBar.height = 5
	end
	
	do
		-- Unitframes
		E.db.unitframe.font = 'Andy Tukui'
		E.db.unitframe.fontSize = 14
		E.db.unitframe.fontOutline = 'OUTLINE'
		E.db.unitframe.smoothbars = true
		E.db.unitframe.statusbar = 'AndyFlat'
		E.db.unitframes.color.powerclass = true
		E.db.unitframes.color.castColor.r = 0.1
		E.db.unitframes.color.castColor.g = 0.1
		E.db.unitframes.color.castColor.b = 0.1
		E.db.unitframes.color.transparentAurabars = true
		E.db.unitframes.color.transparentPower = true
		E.db.unitframes.color.transparentCastbar = true
		E.db.unitframes.color.health.r = 0.235294117647059
		E.db.unitframes.color.health.g = 0.235294117647059
		E.db.unitframes.color.health.b = 0.235294117647059
		-- Player
		E.db.unitframe.units.player.width = 240
		E.db.unitframe.units.player.height = 45
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
		E.db.unitframe.units.player.castbar.width = 240
		E.db.unitframe.units.player.castbar.height = 183
		E.db.unitframe.units.player.customTexts = {}
		E.db.unitframe.units.player.customTexts.Gesundheit = {}
		E.db.unitframe.units.player.customTexts.Gesundheit.font = 'Andy Tukui'
		E.db.unitframe.units.player.customTexts.Gesundheit.justifyH = 'LEFT'
		E.db.unitframe.units.player.customTexts.Gesundheit.fontOutline = 'OUTLINE'
		E.db.unitframe.units.player.customTexts.Gesundheit.xOffset = 0
		E.db.unitframe.units.player.customTexts.Gesundheit.yOffset = 9
		E.db.unitframe.units.player.customTexts.Gesundheit.text_format = '[name:medium] [difficultycolor][smartlevel] [shortclassification]'
		E.db.unitframe.units.player.customTexts.Gesundheit.size = 24
		E.db.unitframe.units.player.customTexts.LevelClass = {}
		E.db.unitframe.units.player.customTexts.LevelClass.font = 'Andy Tukui'
		E.db.unitframe.units.player.customTexts.LevelClass.justifyH = 'LEFT'
		E.db.unitframe.units.player.customTexts.LevelClass.fontOutline = 'OUTLINE'
		E.db.unitframe.units.player.customTexts.LevelClass.xOffset = 0
		E.db.unitframe.units.player.customTexts.LevelClass.yOffset = -7
		E.db.unitframe.units.player.customTexts.LevelClass.size = 12
		E.db.unitframe.units.player.health.xOffset = 5
		E.db.unitframe.units.player.health.yOffset = -33
		E.db.unitframe.units.player.health.text_format = '[healthcolor][health:percent] - [health:current]'
		E.db.unitframe.units.player.power.xOffset = 5
		E.db.unitframe.units.player.power.yOffset = -32
		E.db.unitframe.units.player.power.height = 5
		E.db.unitframe.units.player.power.hideonnpc = true
		E.db.unitframe.units.player.power.detachedWidth = 298
		E.db.unitframe.units.player.buffs.sizeOverride = 30
		E.db.unitframe.units.player.buffs.yOffset = 2
		E.db.unitframe.units.player.buffs.noDuration = false
		E.db.unitframe.units.player.buffs.attachTo = 'FRAME'
		-- Target
		E.db.unitframe.units.target.width = 240
		E.db.unitframe.units.target.height = 45
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
		E.db.unitframe.units.target.power.yOffset = -32
		E.db.unitframe.units.target.power.detachedWidth = 298
		E.db.unitframe.units.target.power.hideonnpc = false
		E.db.unitframe.units.target.power.height = 5
		E.db.unitframe.units.target.customTexts = {}
		E.db.unitframe.units.target.customTexts.Gesundheit = {}
		E.db.unitframe.units.target.customTexts.Gesundheit.font = 'Andy Tukui'
		E.db.unitframe.units.target.customTexts.Gesundheit.justifyH = 'RIGHT'
		E.db.unitframe.units.target.customTexts.Gesundheit.fontOutline = 'OUTLINE'
		E.db.unitframe.units.target.customTexts.Gesundheit.xOffset = 8
		E.db.unitframe.units.target.customTexts.Gesundheit.size = 24
		E.db.unitframe.units.target.customTexts.Gesundheit.text_format = '[name:medium] [difficultycolor]'
		E.db.unitframe.units.target.customTexts.Gesundheit.yOffset = 9
		E.db.unitframe.units.target.customTexts.Name1 = {}
		E.db.unitframe.units.target.customTexts.Name1.font = 'Andy Tukui'
		E.db.unitframe.units.target.customTexts.Name1.justifyH = 'RIGHT'
		E.db.unitframe.units.target.customTexts.Name1.fontOutline = 'OUTLINE'
		E.db.unitframe.units.target.customTexts.Name1.xOffset = 1
		E.db.unitframe.units.target.customTexts.Name1.size = 12
		E.db.unitframe.units.target.customTexts.Name1.text_format = '[difficultycolor][level] [namecolor][smartclass]'
		E.db.unitframe.units.target.customTexts.Name1.yOffset = -7
		E.db.unitframe.units.target.health.xOffset = 8
		E.db.unitframe.units.target.health.text_format = '[healthcolor][health:percent] - [health:current]'
		E.db.unitframe.units.target.health.yOffset = -33
		E.db.unitframe.units.target.portrait.rotation = 307
		E.db.unitframe.units.target.portrait.overlay = true
		E.db.unitframe.units.target.portrait.xOffset = 0.07
		E.db.unitframe.units.target.portrait.enable = true
		E.db.unitframe.units.target.portrait.camDistanceScale = 1.35
		E.db.unitframe.units.target.buffs.sizeOverride = 21
		E.db.unitframe.units.target.buffs.perrow = 11
		E.db.unitframe.units.target.buffs.fontSize = 12
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
		E.db.unitframes.units.focustarget.debuffs.enable = true
		E.db.unitframes.units.focustarget.debuffs.anchorPoint = 'TOPRIGHT'
		E.db.unitframes.units.focustarget.threatStyle = 'GLOW'
		E.db.unitframes.units.focustarget.power.enable = true
		E.db.unitframes.units.focustarget.power.height = 10
		E.db.unitframes.units.focustarget.width = 122
		E.db.unitframes.units.focustarget.enable = true
		E.db.unitframes.units.focustarget.height = 20
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
		E.db.unitframe.units.raid.name.yOffset = -23
		E.db.unitframe.units.raid.name.text_format = '[namecolor][name:short] [difficultycolor][smartlevel]'
		E.db.unitframe.units.raid.name.position = 'CENTER'
		E.db.unitframe.units.raid.buffIndicator.fontSize = 11
		E.db.unitframe.units.raid.buffIndicator.size = 10
		E.db.unitframe.units.raid.roleIcon.size = 12
		E.db.unitframe.units.raid.power.position = 'CENTER'
		E.db.unitframe.units.raid.power.height = 15
		E.db.unitframe.units.raid.healthPrediction = true
		E.db.unitframe.units.raid.width = 75
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
		E.db.unitframe.units.raid.height = 45
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
		E.db.unitframe.units.raid40.customTexts.HealthText.font = 'Andy Tukui'
		E.db.unitframe.units.raid40.customTexts.HealthText.justifyH = 'CENTER'
		E.db.unitframe.units.raid40.customTexts.HealthText.fontOutline = 'OUTLINE'
		E.db.unitframe.units.raid40.customTexts.HealthText.xOffset = 0
		E.db.unitframe.units.raid40.customTexts.HealthText.yOffset = -7
		E.db.unitframe.units.raid40.customTexts.HealthText.text_format = '[healthcolor][health:deficit]'
		E.db.unitframe.units.raid40.customTexts.HealthText.size = 10
		E.db.unitframe.units.raid40.healPrediction = true
		E.db.unitframe.units.raid40.width = 75
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
		E.db.unitframe.units.raid40.height = 43
		E.db.unitframe.units.raid40.verticalSpacing = 1
		E.db.unitframe.units.raid40.raidicon.attachTo = 'LEFT'
		E.db.unitframe.units.raid40.raidicon.xOffset = 9
		E.db.unitframe.units.raid40.raidicon.size = 13
		E.db.unitframe.units.raid40.raidicon.yOffset = 0
		-- Party
		E.db.unitframe.units.party.debuffs.sizeOverride = 21
		E.db.unitframe.units.party.debuffs.yOffset = -7
		E.db.unitframe.units.party.debuffs.anchorPoint = 'TOPRIGHT'
		E.db.unitframe.units.party.debuffs.xOffset = -4
		E.db.unitframe.units.party.targetsGroup.anchorPoint = 'BOTTOM'
		E.db.unitframe.units.party.GPSArrow.size = 40
		E.db.unitframe.units.party.customTexts = {}
		E.db.unitframe.units.party.customTexts.HealthText = {}
		E.db.unitframe.units.party.customTexts.HealthText.font = 'Andy Tukui'
		E.db.unitframe.units.party.customTexts.HealthText.justifyH = 'CENTER'
		E.db.unitframe.units.party.customTexts.HealthText.fontOutline = 'OUTLINE'
		E.db.unitframe.units.party.customTexts.HealthText.xOffset = 0
		E.db.unitframe.units.party.customTexts.HealthText.yOffset = -7
		E.db.unitframe.units.party.customTexts.HealthText.text_format = '[healthcolor][health:deficit]'
		E.db.unitframe.units.party.customTexts.HealthText.size = 10
		E.db.unitframe.units.party.healPrediction = true
		E.db.unitframe.units.party.name.text_format = '[namecolor][name:short] [difficultycolor][smartlevel]'
		E.db.unitframe.units.party.name.position = 'TOP'
		E.db.unitframe.units.party.height = 45
		E.db.unitframe.units.party.verticalSpacing = 4
		E.db.unitframe.units.party.raidicon.attachTo = 'LEFT'
		E.db.unitframe.units.party.raidicon.xOffset = 9
		E.db.unitframe.units.party.raidicon.size = 13
		E.db.unitframe.units.party.raidicon.yOffset = 0
		E.db.unitframe.units.party.horizontalSpacing = 1
		E.db.unitframe.units.party.growthDirection = 'RIGHT_UP'
		E.db.unitframe.units.party.buffIndicator.size = 10
		E.db.unitframe.units.party.power.text_format = ''
		E.db.unitframe.units.party.power.height = 5
		E.db.unitframe.units.party.positionOverride = 'BOTTOM'
		E.db.unitframe.units.party.width = 75
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
		SetMoverPosition('MinimapMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -5, -6)
		SetMoverPosition('DebuffsMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -183, -134)
		SetMoverPosition('AlertFrameMover', 'TOP', E.UIParent, 'TOPRIGHT', 0, -140)
		SetMoverPosition('ElvUF_PartyMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 61, 213)
		SetMoverPosition('ElvAB_9', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 334)
		SetMoverPosition('WatchFrameMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -122, -292)
		SetMoverPosition('BossHeaderMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -56, -397)
		SetMoverPosition('Top_Center_Mover', 'BOTTOM', E.UIParent, 'BOTTOM', -262, 0)
		SetMoverPosition('ElvAB_10', 'BOTTOM', E.UIParent, 'BOTTOM', -2, 288)
		SetMoverPosition('ElvAB_6', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -462, 62)
		SetMoverPosition('PetAB', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 22)
		SetMoverPosition('TargetPowerBarMover', 'BOTTOM', E.UIParent, 'BOTTOM', 203, 429)
		SetMoverPosition('VehicleSeatMover', 'TOPLEFT', E.UIParent, 'TOPLEFT', 325, -195)
		SetMoverPosition('TotemBarMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 462, 43)
		SetMoverPosition('ElvAB_8', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -519, 57)
		SetMoverPosition('TempEnchantMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -5, -299)
		SetMoverPosition('ElvAB_5', 'BOTTOM', E.UIParent, 'BOTTOM', -257, 61)
		SetMoverPosition('ElvAB_3', 'BOTTOM', E.UIParent, 'BOTTOM', 257, 61)
		SetMoverPosition('ElvAB_7', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 520, 375)
		SetMoverPosition('ReputationBarMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 88, 17)
		SetMoverPosition('ElvAB_2', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 97)
		SetMoverPosition('ElvAB_1', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 61)
		SetMoverPosition('ArenaHeaderMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -150, -305)
		SetMoverPosition('ElvUF_Raid40Mover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 50, 214)
		SetMoverPosition('ElvUF_TargetMover', 'BOTTOM', E.UIParent, 'BOTTOM', 189, 201)
		SetMoverPosition('ElvUF_Raid25Mover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 2, 200)
		SetMoverPosition('ExperienceBarMover', 'TOP', E.UIParent, 'TOP', 307, -290)
		SetMoverPosition('ShiftAB', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 905, 136)
		SetMoverPosition('MicrobarMover', 'TOPLEFT', E.UIParent, 'TOPLEFT', 4, -4)
		SetMoverPosition('ClassBarMover', 'BOTTOM', E.UIParent, 'BOTTOM', -1, 349)
		SetMoverPosition('ElvUF_FocusMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -432, 407)
		SetMoverPosition('DigSiteProgressBarMover', 'TOP', E.UIParent, 'TOP', -2, 0)
		SetMoverPosition('FlareMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 253)
		SetMoverPosition('LocationMover', 'TOP', E.UIParent, 'TOP', 0, -7)
		SetMoverPosition('GMMover', 'TOPLEFT', E.UIParent, 'TOPLEFT', 329, 0)
		SetMoverPosition('LeftChatMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 61, 56)
		SetMoverPosition('ElvUF_RaidMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 51, 214)
		SetMoverPosition('ElvUF_PlayerCastbarMover', 'BOTTOM', E.UIParent, 'BOTTOM', -189, 162)
		SetMoverPosition('ElvUF_AssistMover', 'TOPLEFT', E.UIParent, 'BOTTOMLEFT', 25, 725)
		SetMoverPosition('RightChatMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -61, 56)
		SetMoverPosition('ElvUF_PlayerMover', 'BOTTOM', E.UIParent, 'BOTTOM', -189, 201)
		SetMoverPosition('tokenHolderMover', 'TOPLEFT', E.UIParent, 'TOPLEFT', 4, -119)
		SetMoverPosition('ElvUF_TargetCastbarMover', 'BOTTOM', E.UIParent, 'BOTTOM', 189, 162)
		SetMoverPosition('UIBFrameMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -44, -161)
		SetMoverPosition('BNETMover', 'TOP', E.UIParent, 'TOP', 8, -29)
		SetMoverPosition('ObjectiveFrameMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -200, -281)
		SetMoverPosition('AltPowerBarMover', 'TOP', E.UIParent, 'TOP', 1, -272)
		SetMoverPosition('ElvAB_4', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', 0, 367)
		SetMoverPosition('Bottom_Panel_Mover', 'BOTTOM', E.UIParent, 'BOTTOM', 260, 1)
		SetMoverPosition('LossControlMover', 'BOTTOM', E.UIParent, 'BOTTOM', 12, 526)
		SetMoverPosition('ElvUF_TargetTargetMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 221)
		SetMoverPosition('ElvUF_PetCastbarMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 169)
		SetMoverPosition('MarkMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 167)
		SetMoverPosition('PlayerPortraitMover', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 584, 177)
		SetMoverPosition('ElvUF_RaidpetMover', 'TOPLEFT', E.UIParent, 'BOTTOMLEFT', 242, 810)
		SetMoverPosition('LootFrameMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -495, -457)
		SetMoverPosition('BossButton', 'BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', 535, 252)
		SetMoverPosition('ElvUF_Raid10Mover', 'BOTTOM', E.UIParent, 'BOTTOM', 1, 282)
		SetMoverPosition('NemoMover', 'TOP', E.UIParent, 'TOP', -277, -540)
		SetMoverPosition('BuffsMover', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -183, -3)
		SetMoverPosition('ElvUF_FocusTargetMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -432, 473)
		SetMoverPosition('MinimapButtonAnchor', 'TOPRIGHT', E.UIParent, 'TOPRIGHT', -5, -231)
		SetMoverPosition('ElvUF_FocusCastbarMover', 'BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', -432, 394)
	end
	
	-- Addons
	-- LocationPlus
	if E.db.locplus == nil then E.db.locplus = {} end
	if IsAddOnLoaded('ElvUI_LocPlus') then
		do
			E.db.locplus.lpfont = 'Andy Roadway'
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
			E.db.locplus.custom.CoordsColor = 1
			E.db.locplus.dig = false
			E.db.locplus.showicon = false
			E.db.locplus.ttlvl = false
		end
	end
	
	-- BenikUI
	if E.db.bui == nil then E.db.bui = {} end
	if IsAddOnLoaded('ElvUI_BenikUI') then
		do
			E.db.bui.gameMenuColor = 1
			E.db.bui.styledChatDts = true
			E.db.bui.garrisonCurrency = true
			E.db.bui.middleDatatext.styled = true
			E.db.bui.middleDatatext.backdrop = true
			E.db.bui.middleDatatext.width = 416
			E.db.bui.transparentDts = true
			E.db.bui.garrisonCurrencyOil = true
			E.db.bui.LoginMsg = false
			E.db.bui.StyleColor = 1
			E.db.bui.abStyleColor = 4
			E.db.bui.datatexts.BuiRightChatDTPanel.right = 'BuiMail'
			if IsAddOnLoaded('Skada') then
				E.db.bui.datatexts.BuiRightChatDTPanel.left = 'Skada'
			end
			E.db.bui.datatexts.BuiRightChatDTPanel.middle = 'Garrison+ (BenikUI)'
			E.db.bui.datatexts.BuiLeftChatDTPanel.right = 'Spell/Heal Power'
			E.db.bui.datatexts.BuiLeftChatDTPanel.left = 'Talent/Loot Specialization'
			E.db.bui.datatexts.BuiLeftChatDTPanel.middle = 'Durability'
			if IsAddOnLoaded('ElvUI_SLE') then
				E.db.bui.datatexts.BuiMiddleDTPanel.right = 'S&L Currency'
			end
			E.db.bui.datatexts.BuiMiddleDTPanel.left = 'Improved System'
			E.db.bui.datatexts.BuiMiddleDTPanel.middle = 'Time'
		end
	end
	
	-- AddOnSkins
	if IsAddOnLoaded('AddOnSkins') then
		do
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
		end
	end
	
	-- Skada
	if IsAddOnLoaded('Skada') then
		do
			SkadaDB['profiles']['Merathilis'] = {
				["windows"] = {
					{
						["titleset"] = false,
						["barslocked"] = true,
						["y"] = 56.2857055664063,
						["x"] = 1459.28596496582,
						["title"] = {
							["color"] = {
								["a"] = 0,
								["r"] = 0.101960784313725,
								["g"] = 0.101960784313725,
								["b"] = 0.301960784313726,
							},
							["font"] = "Andy Prototype",
							["fontsize"] = 10,
							["borderthickness"] = 0,
							["fontflags"] = "OUTLINE",
							["height"] = 10,
							["texture"] = "AndyMelliDark",
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
						["bartexture"] = "AndyOnePixel",
						["barwidth"] = 180.999923706055,
						["barspacing"] = 1,
						["enabletitle"] = false,
						["classcolortext"] = true,
						["reversegrowth"] = true,
						["background"] = {
							["height"] = 140.42854309082,
						},
						["barfont"] = "Andy Prototype",
						["name"] = "DPS",
					}, -- [1]
					{
						["barheight"] = 15,
						["classicons"] = true,
						["barslocked"] = true,
						["enabletitle"] = false,
						["wipemode"] = "",
						["set"] = "current",
						["hidden"] = false,
						["y"] = 56.2857055664063,
						["barfont"] = "Andy Prototype",
						["name"] = "HPS",
						["display"] = "bar",
						["barfontflags"] = "OUTLINE",
						["classcolortext"] = true,
						["scale"] = 1,
						["reversegrowth"] = true,
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
							["font"] = "Andy Prototype",
							["borderthickness"] = 0,
							["fontsize"] = 10,
							["fontflags"] = "OUTLINE",
							["height"] = 10,
							["margin"] = 0,
							["texture"] = "AndyMelliDark",
						},
						["buttons"] = {
							["segment"] = true,
							["menu"] = true,
							["stop"] = true,
							["mode"] = true,
							["report"] = true,
							["reset"] = true,
						},
						["spark"] = false,
						["bartexture"] = "AndyOnePixel",
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
						["x"] = 1645.28596496582,
					}, -- [2]
				},		
			}
		end
	end
	
	do
		SetMoverPosition('LocationLiteMover', 'TOP', E.UIParent, 'TOP', 0, -7)
		SetMoverPosition('BuiMiddleDtMover', 'BOTTOM', E.UIParent, 'BOTTOM', 0, 33)
	end
	
	print('MerathilisUI Setup is done. Please Reload')
	-- Setup is done so set our option to true, so the Setup won't run again on this player.
	-- Enable it when you are done with the settings
	
	--E.db.mer.installed = true

end

function MER:Initialize()
	-- if ElvUI installed and if in your profile the install is nil then run the SetupUI() function.
	-- This is a check so that your setup won't run everytime you login
	-- Enable it when you are done
	--if E.private.install_complete == E.version and E.db.mer.installed == nil then SetupUI() end
	
	-- run your setup on load for testing purposes. When you are done with the options, disable it.
	--SetupUI()
	if E.private.install_complete == E.version and E.db.Merathilis.installed == nil then -- pop the message only if ElvUI install is complete on this char and your ui hasn't been applied yet
		StaticPopup_Show("merathilis")
	end
end

local version = GetAddOnMetadata("MerathilisUI", "Version") -- with this we get the addon version from toc file

E:RegisterModule(MER:GetName())

StaticPopupDialogs["merathilis"] = {
	text = L[".:: Welcome to MerathilisUI v"]..version..L[" ::.\nPress OK if you want to apply my settings."],
	button1 = L['OK'],
	button2 = L['No thanks'],
	-- Use the folling line when done with your settings
	--OnAccept = function() E.db.Merathilis.installed = true; SetupUI(); PlaySoundFile([[Sound\Interface\LevelUp.ogg]]) end, -- we set the default value to true, so it won't popup again and then run the Setup function plus I added the lvl sound :P
	
	-- Following line is for testing purposes. Doesn't set the option to true, so the message will pop everytime
	OnAccept = function() SetupUI(); PlaySoundFile([[Sound\Interface\LevelUp.ogg]]) end, -- we set the default value to true, so it won't popup again and then run the Setup function plus I added the lvl sound :P
	
	OnCancel = function() end, -- do nothing
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
	preferredIndex = 3,
}
