local E, _, V, P, G = unpack(ElvUI)
local EP = LibStub('LibElvUIPlugin-1.0')
local addon, Engine = ...

local MER = E.Libs.AceAddon:NewAddon(addon, 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
local locale = (E.global.general.locale and E.global.general.locale ~= "auto") and E.global.general.locale or GetLocale()
local L = E.Libs.ACL:GetLocale('ElvUI', locale)

local _G = _G
local pcall, pairs, print, ipairs, select, tonumber = pcall, pairs, print, ipairs, select,tonumber
local format = string.format

local GetAddOnMetadata = GetAddOnMetadata
local GetBuildInfo = GetBuildInfo
local hooksecurefunc = hooksecurefunc

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

MER.Config = {}
MER.RegisteredModules = {}

MER.dummy = function() return end
MER.Title = format("|cffffffff%s|r|cffff7d0a%s|r ", "Merathilis", "UI")
MER.Version = GetAddOnMetadata("ElvUI_MerathilisUI", "Version")
MER.ElvUIV = tonumber(E.version)
MER.ElvUIX = tonumber(GetAddOnMetadata("ElvUI_MerathilisUI", "X-ElvVersion"))
MER.WoWPatch, MER.WoWBuild, MER.WoWPatchReleaseDate, MER.TocVersion = GetBuildInfo()
MER.WoWBuild = select(2, GetBuildInfo()) MER.WoWBuild = tonumber(MER.WoWBuild)

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
MER.Modules.Compatibility = MER:NewModule('MER_Compatibility')
MER.Modules.CombatText = MER:NewModule('MER_CombatText', 'AceEvent-3.0', 'AceTimer-3.0')
MER.Modules.Cursor = MER:NewModule('MER_Cursor')
MER.Modules.CVars = MER:NewModule('MER_CVars')
MER.Modules.DashBoard = MER:NewModule('MER_DashBoard', 'AceEvent-3.0', 'AceHook-3.0')
MER.Modules.DataBars = MER:NewModule('MER_DataBars')
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
MER.Modules.Media = MER:NewModule('MER_Media', 'AceHook-3.0')
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

function MER:Initialize()
	MER.initialized = true

	MER:InitializeModules()
	EP:RegisterPlugin(addon, MER.AddOptions)
	MER:SecureHook(E, 'UpdateAll', 'UpdateModules')

	self:DBConvert()
	self:RegisterMedia()
	self:LoadCommands()
	self:AddMoverCategories()
	self:LoadDataTexts()

	-- ElvUI versions check
	if MER.ElvUIV < MER.ElvUIX then
		E:StaticPopup_Show("VERSION_MISMATCH")
		return -- If ElvUI Version is outdated stop right here. So things don't get broken.
	end

	-- Create empty saved vars if they doesn't exist
	if not MERData then
		MERData = {}
	end

	if not MERDataPerChar then
		MERDataPerChar = {}
	end

	hooksecurefunc(E, "PLAYER_ENTERING_WORLD", function(self, _, initLogin)
		if initLogin or not ElvDB.MERErrorDisabledAddOns then
			ElvDB.MERErrorDisabledAddOns = {}
		end
	end)

	E:Delay(6, function() MER:CheckVersion() end)

	-- run the setup when ElvUI install is finished and again when a profile gets deleted.
	local profileKey = ElvDB.profileKeys[E.myname.." - "..E.myrealm]
	if (E.private.install_complete == E.version and E.db.mui.installed == nil) or (ElvDB.profileKeys and profileKey == nil) then
		E:GetModule("PluginInstaller"):Queue(MER.installTable)
	end

	local icon = MER:GetIconString(MER.Media.Textures.pepeSmall, 14)
	if E.db.mui.installed and E.db.mui.general.LoginMsg then
		print(icon..''..MER.Title..format("v|cff00c0fa%s|r", MER.Version)..L[" is loaded. For any issues or suggestions, please visit "]..MER:PrintURL("https://github.com/Merathilis/ElvUI_MerathilisUI/issues"))
	end
end

EP:HookInitialize(MER, MER.Initialize)
