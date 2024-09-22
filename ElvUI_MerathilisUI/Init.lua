local E, _, V, P, G = unpack(ElvUI)
local addon, Engine = ...

local EP = E.Libs.EP
local PI = E:GetModule("PluginInstaller")
local AceAddon = E.Libs.AceAddon
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)

local _G = _G
local next, type = next, type
local print = print
local strfind, strmatch = strfind, strmatch
local collectgarbage = collectgarbage

local GetAddOnMetadata = C_AddOns.GetAddOnMetadata

local MER = AceAddon:NewAddon(addon, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

--Setting up table to unpack.
V.mui = {}
P.mui = {}
G.mui = {}

local F = {}
local I = {}

Engine[1] = MER
Engine[2] = F
Engine[3] = E
Engine[4] = I
Engine[5] = V.mui
Engine[6] = P.mui
Engine[7] = G.mui
Engine[8] = L
_G[addon] = Engine

local versionString = GetAddOnMetadata(addon, "Version")
local xVersionString = GetAddOnMetadata(addon, "X-Version")

local function getVersion()
	local version, variant, subversion

	-- Git
	if strfind(versionString, "project%-version") then
		return xVersionString, "git", nil
	end

	version, variant = strmatch(versionString, "^(%d+%.%d+)(.*)$")

	if not version then
		return xVersionString, nil, nil
	end

	if not variant or variant == "" then
		return version, nil, nil
	end

	local variantName, subversionNum = strmatch(variant, "^%-([%w]+)%-?(%d*)$")
	if variantName and subversionNum then
		variant = variantName
		subversion = subversionNum ~= "" and subversionNum or nil
	end

	return version, variant, subversion
end

MER.Version, MER.Variant, MER.SubVersion = getVersion()

MER.DisplayVersion = MER.Version
if MER.Variant then
	MER.DisplayVersion = format("%s-%s", MER.DisplayVersion, MER.Variant)
	if MER.SubVersion then
		MER.DisplayVersion = format("%s-%s", MER.DisplayVersion, MER.SubVersion)
	end
end

do
	-- when packager packages a new version for release
	-- "@project-version@" is replaced with the version number
	-- which is the latest tag
	Engine.version = "@project-version@"

	MER.IsDevelop = MER.Version == "development"
	MER.AddOnName = addon
	MER.Title = format("|cffffffff%s|r|cffff7d0a%s|r ", "Merathilis", "UI")
	MER.PlainTitle = gsub(MER.Title, "|c........([^|]+)|r", "%1")
end

-- Modules
MER.Modules = {}
MER.Modules.ActionBars = MER:NewModule("MER_Actionbars", "AceEvent-3.0", "AceHook-3.0")
MER.Modules.AlreadyKnown = MER:NewModule("MER_AlreadyKnown", "AceEvent-3.0", "AceHook-3.0")
MER.Modules.Announcement = MER:NewModule("MER_Announcement", "AceEvent-3.0")
MER.Modules.Armory = MER:NewModule("MER_Armory", "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
MER.Modules.AutoButtons = MER:NewModule("MER_AutoButtons", "AceEvent-3.0")
MER.Modules.Automation = MER:NewModule("MER_Automation", "AceEvent-3.0")
MER.Modules.Auras = MER:NewModule("MER_Auras", "AceHook-3.0")
MER.Modules.Bags = MER:NewModule("MER_Bags")
MER.Modules.BagInfo = MER:NewModule("MER_BagInfo", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.Changelog = MER:NewModule("MER_Changelog", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.Chat = MER:NewModule("MER_Chat", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
MER.Modules.ChatBar = MER:NewModule("MER_ChatBar", "AceEvent-3.0", "AceHook-3.0")
MER.Modules.ChatFade = MER:NewModule("MER_ChatFade", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
MER.Modules.ChatLink = MER:NewModule("MER_ChatLink", "AceEvent-3.0")
MER.Modules.ChatText = MER:NewModule("MER_ChatText", "AceEvent-3.0")
MER.Modules.ContextMenu = MER:NewModule("MER_ContextMenu", "AceHook-3.0")
MER.Modules.Cooldown = MER:NewModule("MER_Cooldown", "AceHook-3.0")
MER.Modules.CombatText = MER:NewModule("MER_CombatText", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.CVars = MER:NewModule("MER_CVars")
MER.Modules.DashBoard = MER:NewModule("MER_DashBoard", "AceEvent-3.0", "AceHook-3.0")
MER.Modules.DataBars = MER:NewModule("MER_DataBars")
MER.Modules.DataTexts = MER:NewModule("MER_DataTexts", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.DeleteItem = MER:NewModule("MER_DeleteItem", "AceEvent-3.0")
MER.Modules.DropDown = MER:NewModule("MER_DropDown", "AceEvent-3.0", "AceHook-3.0")
MER.Modules.Emotes = MER:NewModule("MER_Emotes")
MER.Modules.EventTracker = MER:NewModule("MER_EventTracker", "AceEvent-3.0", "AceHook-3.0")
MER.Modules.ExtendedVendor = MER:NewModule("MER_ExtendedVendor", "AceHook-3.0")
MER.Modules.Filter = MER:NewModule("MER_Filter", "AceEvent-3.0")
MER.Modules.FriendsList = MER:NewModule("MER_FriendsList", "AceHook-3.0")
MER.Modules.HealPrediction = MER:NewModule("MER_HealPrediction", "AceHook-3.0", "AceEvent-3.0")
MER.Modules.InstanceDifficulty = MER:NewModule("MER_InstanceDifficulty", "AceEvent-3.0", "AceHook-3.0")
MER.Modules.ItemLevel = MER:NewModule("MER_ItemLevel", "AceHook-3.0", "AceEvent-3.0")
MER.Modules.Layout = MER:NewModule("MER_Layout", "AceHook-3.0", "AceEvent-3.0")
MER.Modules.LFGInfo = MER:NewModule("MER_LFGInfo", "AceHook-3.0", "AceEvent-3.0")
MER.Modules.Mail = MER:NewModule("MER_Mail", "AceHook-3.0")
MER.Modules.MicroBar = MER:NewModule("MER_MicroBar", "AceEvent-3.0", "AceHook-3.0")
MER.Modules.MiniMap = MER:NewModule("MER_Minimap", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.MiniMapButtons = MER:NewModule("MER_MiniMapButtons", "AceHook-3.0", "AceEvent-3.0")
MER.Modules.MiniMapCoords = MER:NewModule("MER_MiniMapCoords", "AceHook-3.0")
MER.Modules.MiniMapPing = MER:NewModule("MER_MiniMapPing", "AceEvent-3.0")
MER.Modules.Misc = MER:NewModule("MER_Misc", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
MER.Modules.NamePlates = MER:NewModule("MER_NamePlates", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.NamePlateAuras = MER:NewModule("MER_NameplateAuras", "AceEvent-3.0")
MER.Modules.Notification = MER:NewModule("MER_Notification", "AceEvent-3.0")
MER.Modules.Objective = MER:NewModule("MER_ObjectiveTracker", "AceHook-3.0", "AceEvent-3.0")
MER.Modules.Panels = MER:NewModule("MER_Panels")
MER.Modules.Profiles = MER:NewModule("MER_Profiles", "AceHook-3.0", "AceTimer-3.0")
MER.Modules.Progress = MER:NewModule("MER_Progress")
MER.Modules.PVP = MER:NewModule("MER_PVP", "AceEvent-3.0")
MER.Modules.RaidBuffs = MER:NewModule("MER_RaidBuffs")
MER.Modules.RaidCD = MER:NewModule("MER_RaidCD", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.RaidMarkers = MER:NewModule("MER_RaidMarkers", "AceEvent-3.0")
MER.Modules.RandomToy = MER:NewModule("MER_RandomToy", "AceEvent-3.0")
MER.Modules.Rectangle = MER:NewModule("MER_RectangleMinimap", "AceEvent-3.0", "AceHook-3.0")
MER.Modules.Reminder = MER:NewModule("MER_Reminder", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.Skins = MER:NewModule("MER_Skins", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.SpellAlert = MER:NewModule("MER_SpellAlert", "AceEvent-3.0")
MER.Modules.SplashScreen = MER:NewModule("MER_SplashScreen", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.Style = MER:NewModule("MER_Style", "AceHook-3.0")
MER.Modules.SuperTracker = MER:NewModule("MER_SuperTracker", "AceHook-3.0", "AceEvent-3.0")
MER.Modules.SwitchButtons = MER:NewModule("MER_SwitchButtons", "AceHook-3.0", "AceEvent-3.0")
MER.Modules.Talent = MER:NewModule("MER_Talent", "AceTimer-3.0", "AceHook-3.0", "AceEvent-3.0")
MER.Modules.Tooltip = MER:NewModule("MER_Tooltip", "AceHook-3.0", "AceEvent-3.0")
MER.Modules.TurnIn = MER:NewModule("MER_TurnIn", "AceEvent-3.0")
MER.Modules.UnitFrames = MER:NewModule("MER_UnitFrames", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.VehicleBar = MER:NewModule("MER_VehicleBar", "AceHook-3.0")
MER.Modules.WidgetSkin = MER:NewModule("MER_WidgetSkin", "AceHook-3.0", "AceEvent-3.0")
MER.Modules.WorldMap = MER:NewModule("MER_WorldMap", "AceHook-3.0", "AceEvent-3.0")
MER.Modules.ZoneText = MER:NewModule("MER_ZoneText", "AceHook-3.0")

-- Utilities namespace
MER.Utilities = {}

-- Libraries
do
	MER.Libs = {}
	MER.LibsMinor = {}

	function MER:AddLib(name, major, minor)
		if not name then
			return
		end

		-- in this case: `major` is the lib table and `minor` is the minor version
		if type(major) == "table" and type(minor) == "number" then
			MER.Libs[name], MER.LibsMinor[name] = major, minor
		else -- in this case: `major` is the lib name and `minor` is the silent switch
			MER.Libs[name], MER.LibsMinor[name] = _G.LibStub(major, minor)
		end
	end

	MER:AddLib("LDD", "LibDropDown")
end

_G.MerathilisUI_OnAddonCompartmentClick = function()
	E:ToggleOptions()
	E.Libs["AceConfigDialog"]:SelectGroup("ElvUI", "mui")
end

function MER:Initialize()
	if not self:CheckElvUIVersion() then
		return
	end

	if MER.IsDevelop then
		Engine[2].DebugPrint(
			"You are using an alpha build! Expect things not to work correctly or not finished. Do not come into my support and ask for help",
			"warning"
		)
	end

	for _, module in self:IterateModules() do
		Engine[2].Developer.InjectLogger(module)
	end

	hooksecurefunc(MER, "NewModule", function(_, name)
		Engine[2].Developer.InjectLogger(name)
	end)

	-- No need to do the ElvUI install, so hide it
	local ElvUIInstallFrame = _G.ElvUIInstallFrame
	if ElvUIInstallFrame and ElvUIInstallFrame:IsShown() then
		ElvUIInstallFrame:Hide()
	end

	-- Set the db key to the actual ElvUI Version
	if E.private.install_complete == nil then
		E.private.install_complete = E.version
	end

	-- My stuff not yet installed? Here we go...
	if E.db.mui.core.installed == nil then
		PI:Queue(MER.installTable)
	end

	self.initialized = true

	self:UpdateScripts() -- Database need update first
	self:InitializeModules()

	self:AddMoverCategories()
	self:InitializeMetadata()

	EP:RegisterPlugin(addon, MER.OptionsCallback, false, xVersionString)
	self:SecureHook(E, "UpdateAll", "UpdateModules")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	E.data.RegisterCallback(self, "OnProfileChanged", "UpdateProfiles")
	E.data.RegisterCallback(self, "OnProfileCopied", "UpdateProfiles")
	E.data.RegisterCallback(self, "OnProfileReset", "UpdateProfiles")
end

do
	local checked = false
	function MER:PLAYER_ENTERING_WORLD(_, isInitialLogin, isReloadingUi)
		if isInitialLogin then
			E:Delay(6, self.CheckInstalledVersion, self)
			local icon = Engine[2].GetIconString([[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\pepeSmall]], 14)
			if E.db.mui.core.installed and E.global.mui.core.loginMsg then
				print(
					icon
						.. ""
						.. self.Title
						.. format("|cff00c0fa%s|r", self.Version)
						.. L[" is loaded. For any issues or suggestions join my discord: "]
						.. Engine[2].PrintURL("https://discord.gg/28We6esE9v")
				)
			end

			self:SplashScreen()
		end

		if not (checked or _G.ElvUIInstallFrame) then
			self:CheckCompatibility()
			checked = true
		end

		if _G.ElvDB then
			if isInitialLogin or not _G.ElvDB.MER then
				_G.ElvDB.MER = {
					DisabledAddOns = {},
				}
			end

			if next(_G.ElvDB.MER.DisabledAddOns) then
				E:Delay(4, self.PrintDebugEnviromentTip)
			end
		end

		self:FixGame()

		Engine[2]:GradientColorUpdate()

		E:Delay(1, collectgarbage, "collect")
	end
end

EP:HookInitialize(MER, MER.Initialize)
