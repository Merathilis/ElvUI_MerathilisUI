local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:NewModule('MerathilisUI', "AceConsole-3.0");

local LSM = LibStub('LibSharedMedia-3.0')
local EP = LibStub('LibElvUIPlugin-1.0')
local addon, ns = ...

-- Profile (if this gets big, move it to a seperate file but load before your core.lua. Put it in the .toc file)
-- In case you create options, also add them here
P['Merathilis Eule'] = {
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
		--General
		E.db.general.totems.size = 36
		E.db.general.fontSize = 11
		E.db.general.interruptAnnounce = "RAID"
		E.db.general.autoRepair = "GUILD"
		E.db.general.minimap.garrisonPos = "TOPRIGHT"
		E.db.general.minimap.icons.garrison.scale = 0.9
		E.db.general.minimap.icons.garrison.position = "TOPRIGHT"
		E.db.general.minimap.icons.garrison.yOffset = 10
		E.db.general.minimap.size = 150
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
		E.db.actionbar.bar3.buttonsize = 305
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
		E.db.actionbar.bar8.buttons = 6
		E.db.actionbar.bar8.mousover = true
		E.db.actionbar.bar8.buttonsPerRow = 1
		E.db.actionbar.bar8.buttonsize = 24
		E.db.actionbar.barPet.point = 'RIGHT'
		E.db.actionbar.barPet.buttonspacing = 4
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
		E.db.datatexts.LeftChatPanel = false
		E.db.datatexts.RightChatPanel = false
		E.db.datatexts.time24 = true
		E.db.datatext.minimapPanels = false
		E.db.datatext.panelTransparency = false
		E.db.datatext.actionbar3 = false
		E.db.datatext.actionbar5 = false
	end
	
	do
		-- Nameplates
		E.db.nameplate.font = 'Andy Roadway'
		E.db.nameplate.fontSize = 11
		E.db.nameplate.fontOutline = 'OUTLINE'
		E.db.nameplate.debuffs.font = 'Andy Prototype'
		E.db.nameplate.debuffs.fontSize = 9
		E.db.nameplate.debuffs.fontOutline = 'OUTLINE'
		E.db.nameplate.buffs.font = 'Andy Prototype'
		E.db.nameplate.buffs.fontSize = 7
		E.db.nameplate.buffs.fontOutline = 'OUTLINE'
	end
	
	do
		-- Tooltip
		E.db.tooltip.font = 'Andy Prototype'
		E.db.tooltip.fontOutline = 'OUTLINE'
		E.db.tooltip.headerFontSize = 14
		E.db.tooltip.textFontSize = 11
		E.db.tooltip.smallTextFontSize = 11
		E.db.tooltip.healthBar.font = 'Andy Prototype'
		E.db.tooltip.healthBar.fontSize = 10
		E.db.tooltip.healthBar.fontOutline = 'OUTLINE'
	end
	
	do
		-- Unitframes
		E.db.unitframe.font = 'Andy Tukui'
		E.db.unitframe.fontSize = 14
		E.db.unitframe.fontOutline = 'OUTLINE'
		E.db.unitframe.smoothbars = true
		E.db.unitframe.statusbar = 'AndyFlat'
		E.db.unitframes.colors.auraBarBuff.r = 0.309803921568628
		E.db.unitframes.colors.auraBarBuff.g = 0.0784313725490196
		E.db.unitframes.colors.auraBarBuff.b = 0.0941176470588235
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
		--Player
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
		E.db.unitframe.units.player.customTexts.Level-Class = {}
		E.db.unitframe.units.player.customTexts.Level-Class.font = 'Andy Tukui'
		E.db.unitframe.units.player.customTexts.Level-Class.justifyH = 'LEFT'
		E.db.unitframe.units.player.customTexts.Level-Class.fontOutline = 'OUTLINE'
		E.db.unitframe.units.player.customTexts.Level-Class.xOffset = 0
		E.db.unitframe.units.player.customTexts.Level-Class.yOffset = -7
		E.db.unitframe.units.player.customTexts.Level-Class.size = 12
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
	
	[[-- Addons
	do
		-- Addonsettings
	end
	--]]
	
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
	SetupUI()
end

E:RegisterModule(MER:GetName())