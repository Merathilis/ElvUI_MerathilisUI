local E, _, V, P, G = unpack(ElvUI) ---@type ElvUI
local addon, Engine = ...

local EP = E.Libs.EP
local PI = E:GetModule("PluginInstaller")
local AceAddon = E.Libs.AceAddon
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)

local _G = _G
local next = next
local print = print
local strfind, strmatch = strfind, strmatch
local collectgarbage = collectgarbage

local GetAddOnMetadata = C_AddOns.GetAddOnMetadata

---@class ElvUI_MerathilisUI : AceAddon, AceConsole-3.0, AceEvent-3.0, AceTimer-3.0, AceHook-3.0
local MER = AceAddon:NewAddon(addon, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local W, WF = unpack(WindTools or {})

V.mui = {}
P.mui = {}
G.mui = {}

local I = {}

Engine[1] = MER
Engine[2] = W
Engine[3] = WF
Engine[4] = {} ---@class Functions
Engine[5] = E
Engine[6] = I
Engine[7] = V.mui
Engine[8] = P.mui
Engine[9] = G.mui
Engine[10] = L
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

MER.MetaFlavor = GetAddOnMetadata("ElvUI_MerathilisUI", "X-Flavor")

MER.IsMOP = MER.MetaFlavor == "Mists"
MER.IsRetail = MER.MetaFlavor == "Mainline"

-- Modules
MER.Modules = {}
MER.Modules.ActionBars = MER:NewModule("MER_Actionbars", "AceEvent-3.0", "AceHook-3.0")
MER.Modules.Armory = MER:NewModule("MER_Armory", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.BagInfo = MER:NewModule("MER_BagInfo", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.Changelog = MER:NewModule("MER_Changelog", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.Cooldown = MER:NewModule("MER_Cooldown", "AceHook-3.0")
MER.Modules.CombatText = MER:NewModule("MER_CombatText", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.ItemLevel = MER:NewModule("MER_ItemLevel", "AceHook-3.0", "AceEvent-3.0")
MER.Modules.Layout = MER:NewModule("MER_Layout", "AceHook-3.0", "AceEvent-3.0")
MER.Modules.MiniMapCoords = MER:NewModule("MER_MiniMapCoords", "AceHook-3.0")
MER.Modules.Misc = MER:NewModule("MER_Misc", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
MER.Modules.NameHover = MER:NewModule("MER_NameHover")
MER.Modules.NamePlates = MER:NewModule("MER_NamePlates", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.Notification = MER:NewModule("MER_Notification", "AceEvent-3.0")
MER.Modules.Panels = MER:NewModule("MER_Panels")
MER.Modules.PetBattleScripts = MER:NewModule("MER_PetBattleScripts")
MER.Modules.Profiles = MER:NewModule("MER_Profiles", "AceHook-3.0", "AceTimer-3.0")
MER.Modules.PVP = MER:NewModule("MER_PVP", "AceEvent-3.0")
MER.Modules.RaidBuffs = MER:NewModule("MER_RaidBuffs")
MER.Modules.RaidInfoFrame = MER:NewModule("MER_RaidInfoFrame")
MER.Modules.Skins = MER:NewModule("MER_Skins", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.SplashScreen = MER:NewModule("MER_SplashScreen", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.Style = MER:NewModule("MER_Style", "AceHook-3.0")
MER.Modules.Tooltip = MER:NewModule("MER_Tooltip", "AceHook-3.0", "AceEvent-3.0")
MER.Modules.UnitFrames = MER:NewModule("MER_UnitFrames", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
MER.Modules.VehicleBar = MER:NewModule("MER_VehicleBar", "AceHook-3.0")

-- Pre register Portraits
MER.Portraits = {}

-- Pre register Datatexts
MER.DatatextString = "|CFF6559F1m|r|CFFA037E9M|r|CFFDD14E0T|r-Datatexts"

-- Pre-register libs into ElvUI
E:AddLib("LDD", "LibDropDown")
E:AddLib("OpenRaid", "LibOpenRaid-1.0")
E:AddLib("Keystone", "LibKeystone")

_G.MerathilisUI_OnAddonCompartmentClick = function()
	E:ToggleOptions()
	E.Libs["AceConfigDialog"]:SelectGroup("ElvUI", "mui")
end

function MER:Initialize()
	if self.initialized then
		return
	end

	if not self:CheckElvUIVersion() then
		return
	end

	local flavorMap = {
		["Mainline"] = I.Enum.Flavor.RETAIL,
		["MOP"] = I.Enum.Flavor.MOP,
	}
	self.Flavor = flavorMap[self.MetaFlavor] or I.Enum.Flavor.RETAIL

	if MER.IsDevelop then
		Engine[4].DebugPrint(
			"You are using an alpha build! Expect things not to work correctly or not finished. Do not come into my support and ask for help",
			"warning"
		)
	end

	for _, module in self:IterateModules() do
		WF.Developer.InjectLogger(module)
	end

	hooksecurefunc(MER, "NewModule", function(_, name)
		WF.Developer.InjectLogger(name)
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

	self:UpdateScripts()
	self:InitializeModules()

	self:AddMoverCategories()

	-- To avoid the update tips from ElvUI when alpha/beta versions are used
	EP:RegisterPlugin(addon, MER.OptionsCallback, false, xVersionString)

	-- Fix the bug that locale files loaded after option table is created
	local pluginTitle = L["Plugins"]
	MER:SecureHook(EP, "GetPluginOptions", function()
		E.Options.args.plugins.name = pluginTitle
	end)

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
			local icon = Engine[4].GetIconString([[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\pepeSmall]], 14)
			if E.db.mui.core.installed and E.global.mui.core.loginMsg then
				print(
					icon
						.. ""
						.. self.Title
						.. format("|cff00c0fa%s|r", self.Version)
						.. L[" is loaded. For any issues or suggestions join my discord: "]
						.. Engine[4].PrintURL("https://discord.gg/28We6esE9v")
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

		Engine[4]:GradientColorUpdate()

		E:Delay(1, collectgarbage, "collect")
	end
end

EP:HookInitialize(MER, MER.Initialize)
