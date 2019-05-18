local E, _, V, P, G = unpack(ElvUI)
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS')
local LSM = E.LSM
local EP = LibStub("LibElvUIPlugin-1.0")
local addon, Engine = ...

local MER = LibStub("AceAddon-3.0"):NewAddon(addon, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")
MER.callbacks = MER.callbacks or LibStub("CallbackHandler-1.0"):New(MER)

-- Cache global variables
-- Lua functions
local _G = _G
local format = string.format
local print, pairs = print, pairs
local pcall = pcall
local tinsert = table.insert
-- WoW API / Variables
local CreateFrame = CreateFrame
local GetAddOnEnableState = GetAddOnEnableState
local IsAddOnLoaded = IsAddOnLoaded
local SetCVar = SetCVar

-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: LibStub, ElvDB, ElvUI_SLE, hooksecurefunc, BINDING_HEADER_MER
-- GLOBALS: MERData, MERDataPerChar

--Setting up table to unpack.
Engine[1] = MER
Engine[2] = E
Engine[3] = L
Engine[4] = V
Engine[5] = P
Engine[6] = G
_G[addon] = Engine;

MER.Config = {}
MER["styling"] = {}
MER.Logo = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\mUI.tga]]
MER.LogoSmall = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\mUI1.tga]]
BINDING_HEADER_MER = "|cffff7d0aMerathilisUI|r"

MER.MSQ = _G.LibStub('Masque', true)

local function PrintURL(url) -- Credit: Azilroka
	return format("|cFF00c0fa[|Hurl:%s|h%s|h]|r", url, url)
end

function MER:cOption(name)
	local color = "|cffff7d0a%s |r"
	return (color):format(name)
end

function MER:AddOptions()
	for _, func in pairs(MER.Config) do
		func()
	end
end

function MER:DasOptions()
	E:ToggleConfig(); LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "mui")
end

function MER:SetMoverPosition(mover, point, anchor, secondaryPoint, x, y)
	if not _G[mover] then return end
	local frame = _G[mover]

	frame:ClearAllPoints()
	frame:SetPoint(point, anchor, secondaryPoint, x, y)
	E:SaveMoverPosition(mover)
end

function MER:LoadCommands()
	self:RegisterChatCommand("mui", "DasOptions")
end

function MER:RegisterMedia()
	--Fonts
	E["media"].muiFont = LSM:Fetch("font", "Merathilis Prototype")
	E["media"].muiVisitor = LSM:Fetch("font", "Merathilis Visitor1")
	E["media"].muiVisitor2 = LSM:Fetch("font", "Merathilis Visitor2")
	E["media"].muiTuk = LSM:Fetch("font", "Merathilis Tukui")
	E["media"].muiRoboto = LSM:Fetch("font", "Merathilis Roboto-Black")
	E["media"].muiGothic = LSM:Fetch("font", "Merathilis Gothic-Bold")

	-- Background
	E["media"].muiBrushedMetal = LSM:Fetch("background", "Merathilis BrushedMetal")
	E["media"].muiSmoke = LSM:Fetch("background", "Merathilis Smoke")

	-- Border
	E["media"].muiglowTex = LSM:Fetch("border", "MerathilisGlow")

	--Textures
	E["media"].muiBlank = LSM:Fetch("statusbar", "MerathilisBlank")
	E["media"].muiBorder = LSM:Fetch("statusbar", "MerathilisBorder")
	E["media"].muiEmpty = LSM:Fetch("statusbar", "MerathilisEmpty")
	E["media"].muiFlat = LSM:Fetch("statusbar", "MerathilisFlat")
	E["media"].muiMelli = LSM:Fetch("statusbar", "MerathilisMelli")
	E["media"].muiMelliDark = LSM:Fetch("statusbar", "MerathilisMelliDark")
	E["media"].muiOnePixel = LSM:Fetch("statusbar", "MerathilisOnePixel")
	E["media"].muiNormTex = LSM:Fetch("statusbar", "MerathilisnormTex")
	E["media"].muiGradient = LSM:Fetch("statusbar", "MerathilisGradient")

	-- Custom Textures
	E["media"].roleIcons = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\UI-LFG-ICON-ROLES]]
	E["media"].checked = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\checked]]

	E:UpdateMedia()
end

function MER:AddMoverCategories()
	tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts) + 1, "MERATHILISUI")
	E.ConfigModeLocalizedStrings["MERATHILISUI"] = format("|cffff7d0a%s |r", "MerathilisUI")
end

function MER:IsAddOnEnabled(addon) -- Credit: Azilroka
	return GetAddOnEnableState(E.myname, addon) == 2
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	SetCVar("blockTrades", 0) -- Lets set this on every login
	MER:Initialize()
end)

-- Register own Modules
MER["RegisteredModules"] = {}
function MER:RegisterModule(name)
	if self.initialized then
		local module = self:GetModule(name)
		if (module and module.Initialize) then
			module:Initialize()
		end
	else
		self["RegisteredModules"][#self["RegisteredModules"] + 1] = name
	end
end

function MER:InitializeModules()
	for _, moduleName in pairs(MER["RegisteredModules"]) do
		local module = self:GetModule(moduleName)
		if module.Initialize then
			module:Initialize()
		else
			MER:Print("Module <"..moduleName.."> does not loaded.")
		end
	end
end

function MER:Initialize()
	self.initialized = true

	-- ElvUI versions check
	if MER.ElvUIV < MER.ElvUIX then
		E:StaticPopup_Show("VERSION_MISMATCH")
		return -- If ElvUI Version is outdated stop right here. So things don't get broken.
	end

	self:RegisterMedia()
	self:LoadCommands()
	self:SplashScreen()

	self:AddMoverCategories()

	self:InitializeModules()
	self:SetupProfileCallbacks()

	-- Create empty saved vars if they doesn't exist
	if not MERData then
		MERData = {}
	end

	if not MERDataPerChar then
		MERDataPerChar = {}
	end

	E:Delay(6, function() MER:CheckVersion() end)

	-- run the setup again when a profile gets deleted.
	local profileKey = ElvDB.profileKeys[E.myname.." - "..E.myrealm]
	if ElvDB.profileKeys and profileKey == nil then
		E:GetModule("PluginInstaller"):Queue(MER.installTable)
	end

	if E.db.mui.general.LoginMsg then
		print(MER.Title..format("v|cff00c0fa%s|r", MER.Version)..L[" is loaded. For any issues or suggestions, please visit "]..MER:PrintURL("https://git.tukui.org/Merathilis/ElvUI_MerathilisUI/issues"))
	end

	-- run install when ElvUI install finishes
	if E.private.install_complete == E.version and E.db.mui.installed == nil then
		E:GetModule("PluginInstaller"):Queue(MER.installTable)
	end

	if MER.MSQ then
		MER.MSQ:Register(addon)
	end

	EP:RegisterPlugin(addon, self.AddOptions)
end
