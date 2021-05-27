local E, _, V, P, G = unpack(ElvUI)
local EP = LibStub('LibElvUIPlugin-1.0')
local addon, Engine = ...

local MER = E.Libs.AceAddon:NewAddon(addon, 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
local locale = (E.global.general.locale and E.global.general.locale ~= "auto") and E.global.general.locale or GetLocale()
local L = E.Libs.ACL:GetLocale('ElvUI', locale)

-- Cache global variables
-- Lua functions
local _G = _G
local pcall, pairs, ipairs = pcall, pairs, ipairs
-- WoW API / Variables
-- GLOBALS:

--Setting up table to unpack.
Engine[1] = MER
Engine[2] = E
Engine[3] = L
Engine[4] = V
Engine[5] = P
Engine[6] = G
_G[addon] = Engine

MER.Config = {}
MER.RegisteredModules = {}

-- Modules
MER.ActionBars = MER:NewModule('MER_Actionbars', 'AceEvent-3.0', 'AceHook-3.0')
MER.Armory = MER:NewModule('MER_Armory', 'AceEvent-3.0', 'AceConsole-3.0', 'AceHook-3.0', 'AceTimer-3.0')
MER.AutoButtons = MER:NewModule('MER_AutoButtons', 'AceEvent-3.0')
MER.Auras = MER:NewModule('MER_Auras', 'AceHook-3.0')
MER.Bags = MER:NewModule('MER_Bags', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
MER.BagInfo = MER:NewModule("MER_BagInfo", 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
MER.Chat = MER:NewModule('MER_Chat', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
MER.ChatBar = MER:NewModule('MER_ChatBar', 'AceEvent-3.0', 'AceHook-3.0')
MER.ChatLink = MER:NewModule('MER_ChatLink', 'AceEvent-3.0')
MER.Cooldown =  MER:NewModule('MER_Cooldown', 'AceHook-3.0')
MER.Compatibility = MER:NewModule('MER_Compatibility')
MER.CombatText = MER:NewModule('MER_CombatText', 'AceEvent-3.0', 'AceTimer-3.0')
MER.Cursor = MER:NewModule('MER_Cursor')
MER.CVars = MER:NewModule('MER_CVars')
MER.DashBoard = MER:NewModule('MER_DashBoard', 'AceEvent-3.0', 'AceHook-3.0')
MER.DataBars = MER:NewModule('MER_DataBars')
MER.Emotes = MER:NewModule('MER_Emotes')
MER.FlightMode = MER:NewModule('MER_FlightMode', 'AceHook-3.0', 'AceTimer-3.0', 'AceEvent-3.0')
MER.FlightModeBUI = MER:NewModule('MER_BUIFlightMode')
MER.GameMenu = MER:NewModule('MER_GameMenu')
MER.InstanceDifficulty = MER:NewModule('MER_InstanceDifficulty', 'AceEvent-3.0')
MER.Layout = MER:NewModule('MER_Layout', 'AceHook-3.0', 'AceEvent-3.0')
MER.LFGInfo = MER:NewModule('MER_LFGInfo', 'AceHook-3.0')
MER.LocPanel = MER:NewModule('MER_LocPanel', 'AceTimer-3.0', 'AceEvent-3.0')
MER.Loot = MER:NewModule('MER_Loot', 'AceEvent-3.0', 'AceHook-3.0')
MER.Mail = MER:NewModule('MER_Mail', 'AceHook-3.0')
MER.Media = MER:NewModule('MER_Media', 'AceHook-3.0')
MER.MicroBar = MER:NewModule('MER_MicroBar', 'AceEvent-3.0', 'AceHook-3.0')
MER.MiniMap = MER:NewModule('MER_Minimap', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
MER.RectangleMinimap = MER:NewModule('MER_RectangleMinimap', 'AceHook-3.0', 'AceEvent-3.0')
MER.MiniMapButtons = MER:NewModule('MER_MiniMapButtons', 'AceTimer-3.0')
MER.Misc = MER:NewModule('MER_Misc', 'AceEvent-3.0', 'AceHook-3.0')
MER.NamePlates = MER:NewModule('MER_NamePlates', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
MER.NamePlateAuras = MER:NewModule('MER_NameplateAuras', 'AceEvent-3.0')
MER.Notification = MER:NewModule('MER_Notification', 'AceEvent-3.0')
MER.Panels =  MER:NewModule('MER_Panels')
MER.Progress = MER:NewModule('MER_Progress')
MER.PVP =  MER:NewModule('MER_PVP', 'AceEvent-3.0')
MER.RaidBuffs = MER:NewModule('MER_RaidBuffs')
MER.RaidCD = MER:NewModule('MER_RaidCD', 'AceEvent-3.0', 'AceTimer-3.0')
MER.RaidManager = MER:NewModule('MER_RaidManager', 'AceEvent-3.0', 'AceTimer-3.0')
MER.RaidMarkers = MER:NewModule('MER_RaidMarkers')
MER.RandomToy = MER:NewModule('MER_RandomToy', 'AceEvent-3.0')
MER.Reminder = MER:NewModule('MER_Reminder', 'AceEvent-3.0', 'AceTimer-3.0')
MER.Skins = MER:NewModule('MER_Skins', 'AceHook-3.0', 'AceEvent-3.0')
MER.SuperTracker = MER:NewModule('MER_SuperTracker', 'AceHook-3.0', 'AceEvent-3.0')
MER.TalentManager = MER:NewModule('MER_TalentManager', 'AceEvent-3.0', 'AceHook-3.0')
MER.Tooltip = MER:NewModule('MER_Tooltip', 'AceTimer-3.0', 'AceHook-3.0', 'AceEvent-3.0')
MER.UnitFrames = MER:NewModule('MER_UnitFrames', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
MER.WorldMap = MER:NewModule('MER_WorldMap', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')

-- Register own Modules
function MER:RegisterModule(name)
	if self.initialized then
		local module = self:GetModule(name)
		if (module and module.Initialize) then
			module:Initialize()
		end
	else
		MER.RegisteredModules[#MER.RegisteredModules + 1] = name
	end
end

function MER:GetRegisteredModules()
	return MER.RegisteredModules
end

function MER:InitializeModules()
	for _, moduleName in pairs(MER.RegisteredModules) do
		local module = MER:GetModule(moduleName)
		if module.Initialize then
			pcall(module:Initialize(), module)
		end
	end
end

function MER:UpdateModules()
	for _, moduleName in pairs(MER.RegisteredModules) do
		local module = MER:GetModule(moduleName)
		if module.ProfileUpdate then
			pcall(module.ProfileUpdate, module)
		end
	end
end

function MER:AddOptions()
	for _, func in ipairs(MER.Config) do
		func()
	end
end

function MER:Init()
	MER.initialized = true

	MER:Initialize()
	MER:InitializeModules()
	EP:RegisterPlugin(addon, MER.AddOptions)
	MER:SecureHook(E, 'UpdateAll', 'UpdateModules')
end

E.Libs.EP:HookInitialize(MER, MER.Init)
