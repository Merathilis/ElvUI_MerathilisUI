local E, _, V, P, G = unpack(ElvUI)
local addon, Engine = ...
local EP = E.Libs.EP
local AceAddon = E.Libs.AceAddon

local locale = (E.global.general.locale and E.global.general.locale ~= "auto") and E.global.general.locale or GetLocale()
local L = E.Libs.ACL:GetLocale('ElvUI', locale)

local _G = _G
local next = next

local collectgarbage = collectgarbage
local GetAddOnMetadata = GetAddOnMetadata

local MER = AceAddon:NewAddon(addon, 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')

--Setting up table to unpack.
V.mui = {}
P.mui = {}
G.mui = {}

Engine[1] = MER
Engine[2] = {} -- Functions F
Engine[3] = E
Engine[4] = L
Engine[5] = V.mui
Engine[6] = P.mui
Engine[7] = G.mui
_G[addon] = Engine

MER.Version = GetAddOnMetadata(addon, "Version")

-- Modules
MER.Modules = {}
MER.Modules.ActionBars = MER:NewModule('MER_Actionbars', 'AceEvent-3.0', 'AceHook-3.0')
MER.Modules.Armory = MER:NewModule('MER_Armory', 'AceEvent-3.0', 'AceConsole-3.0', 'AceHook-3.0', 'AceTimer-3.0')
MER.Modules.AutoButtons = MER:NewModule('MER_AutoButtons', 'AceEvent-3.0')
MER.Modules.Auras = MER:NewModule('MER_Auras', 'AceHook-3.0')
MER.Modules.Bags = MER:NewModule('MER_Bags', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
MER.Modules.BagInfo = MER:NewModule("MER_BagInfo", 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
MER.Modules.Chat = MER:NewModule('MER_Chat', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
MER.Modules.ChatBar = MER:NewModule('MER_ChatBar', 'AceEvent-3.0', 'AceHook-3.0')
MER.Modules.ChatLink = MER:NewModule('MER_ChatLink', 'AceEvent-3.0')
MER.Modules.Cooldown =  MER:NewModule('MER_Cooldown', 'AceHook-3.0')
MER.Modules.CombatText = MER:NewModule('MER_CombatText', 'AceEvent-3.0', 'AceTimer-3.0')
MER.Modules.Cursor = MER:NewModule('MER_Cursor')
MER.Modules.CVars = MER:NewModule('MER_CVars')
MER.Modules.DashBoard = MER:NewModule('MER_DashBoard', 'AceEvent-3.0', 'AceHook-3.0')
MER.Modules.DataBars = MER:NewModule('MER_DataBars')
MER.Modules.DataTexts = MER:NewModule('MER_DataTexts', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
MER.Modules.DropDown = MER:NewModule('MER_DropDown', 'AceEvent-3.0')
MER.Modules.Emotes = MER:NewModule('MER_Emotes')
MER.Modules.ExtendedVendor = MER:NewModule('MER_ExtendedVendor', 'AceHook-3.0')
MER.Modules.FlightMode = MER:NewModule('MER_FlightMode', 'AceHook-3.0', 'AceTimer-3.0', 'AceEvent-3.0')
MER.Modules.FlightModeBUI = MER:NewModule('MER_BUIFlightMode')
MER.Modules.GameMenu = MER:NewModule('MER_GameMenu')
MER.Modules.HealPrediction = MER:NewModule('MER_HealPrediction', 'AceHook-3.0', 'AceEvent-3.0')
MER.Modules.InstanceDifficulty = MER:NewModule('MER_InstanceDifficulty', 'AceEvent-3.0')
MER.Modules.Layout = MER:NewModule('MER_Layout', 'AceHook-3.0', 'AceEvent-3.0')
MER.Modules.LFGInfo = MER:NewModule('MER_LFGInfo', 'AceHook-3.0')
MER.Modules.LocPanel = MER:NewModule('MER_LocPanel', 'AceTimer-3.0', 'AceEvent-3.0')
MER.Modules.Loot = MER:NewModule('MER_Loot', 'AceEvent-3.0', 'AceHook-3.0')
MER.Modules.Mail = MER:NewModule('MER_Mail', 'AceHook-3.0')
MER.Modules.MicroBar = MER:NewModule('MER_MicroBar', 'AceEvent-3.0', 'AceHook-3.0')
MER.Modules.MiniMap = MER:NewModule('MER_Minimap', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
MER.Modules.RectangleMinimap = MER:NewModule('MER_RectangleMinimap', 'AceHook-3.0', 'AceEvent-3.0')
MER.Modules.MiniMapButtons = MER:NewModule('MER_MiniMapButtons', 'AceTimer-3.0')
MER.Modules.Misc = MER:NewModule('MER_Misc', 'AceEvent-3.0', 'AceHook-3.0')
MER.Modules.NamePlates = MER:NewModule('MER_NamePlates', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
MER.Modules.NamePlateAuras = MER:NewModule('MER_NameplateAuras', 'AceEvent-3.0')
MER.Modules.Notification = MER:NewModule('MER_Notification', 'AceEvent-3.0')
MER.Modules.Objective = MER:NewModule('MER_ObjectiveTracker', 'AceHook-3.0', 'AceEvent-3.0')
MER.Modules.Panels =  MER:NewModule('MER_Panels')
MER.Modules.Progress = MER:NewModule('MER_Progress')
MER.Modules.PVP =  MER:NewModule('MER_PVP', 'AceEvent-3.0')
MER.Modules.RaidBuffs = MER:NewModule('MER_RaidBuffs')
MER.Modules.RaidCD = MER:NewModule('MER_RaidCD', 'AceEvent-3.0', 'AceTimer-3.0')
MER.Modules.RaidManager = MER:NewModule('MER_RaidManager', 'AceEvent-3.0', 'AceTimer-3.0')
MER.Modules.RaidMarkers = MER:NewModule('MER_RaidMarkers', 'AceHook-3.0')
MER.Modules.RandomToy = MER:NewModule('MER_RandomToy', 'AceEvent-3.0')
MER.Modules.Reminder = MER:NewModule('MER_Reminder', 'AceEvent-3.0', 'AceTimer-3.0')
MER.Modules.Skins = MER:NewModule('MER_Skins', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
MER.Modules.SuperTracker = MER:NewModule('MER_SuperTracker', 'AceHook-3.0', 'AceEvent-3.0')
MER.Modules.Tooltip = MER:NewModule('MER_Tooltip', 'AceTimer-3.0', 'AceHook-3.0', 'AceEvent-3.0')
MER.Modules.UnitFrames = MER:NewModule('MER_UnitFrames', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
MER.Modules.VehicleBar = MER:NewModule('MER_VehicleBar', 'AceEvent-3.0', 'AceTimer-3.0', 'AceHook-3.0')
MER.Modules.WorldMap = MER:NewModule('MER_WorldMap', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
MER.Modules.ZoneText = MER:NewModule('MER_ZoneText', 'AceHook-3.0')

function MER:Initialize()
	self.initialized = true

	-- ElvUI -> MerathilisUI -> MerathilisUI Modules
	if not self:CheckElvUIVersion() then
		return
	end

	self:UpdateScripts() -- Database need update first
	self:InitializeModules()

	self:AddMoverCategories()

	EP:RegisterPlugin(addon, MER.OptionsCallback)
	self:SecureHook(E, 'UpdateAll', 'UpdateModules')
	self:RegisterEvent('PLAYER_ENTERING_WORLD')

	-- run the setup when ElvUI install is finished and again when a profile gets deleted.
	local profileKey = ElvDB.profileKeys[E.myname.." - "..E.myrealm]
	if (E.private.install_complete == E.version and E.db.mui.installed == nil) or (ElvDB.profileKeys and profileKey == nil) then
		E:GetModule("PluginInstaller"):Queue(MER.installTable)
	end
end

do
	local checked = false
	function MER:PLAYER_ENTERING_WORLD(_, isInitialLogin, isReloadingUi)
		if isInitialLogin then
			E:Delay(7, self.CheckVersion, self)
		end

		if not (checked or _G.ElvUIInstallFrame) then
			self:CheckCompatibility()
			checked = true
		end

		if _G.ElvDB then
			if isInitialLogin or not _G.ElvDB.MER then
				_G.ElvDB.MER = {
					DisabledAddOns = {}
				}
			end

			if next(_G.ElvDB.MER.DisabledAddOns) then
				E:Delay(4, self.PrintDebugEnviromentTip)
			end
		end

		E:Delay(1, collectgarbage, "collect")
	end
end

EP:HookInitialize(MER, MER.Initialize)
