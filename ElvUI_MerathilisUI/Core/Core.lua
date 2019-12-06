local MER, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.LSM

-- Cache global variables
-- Lua functions
local _G = _G
local format = string.format
local print, pairs = print, pairs
local tinsert = table.insert
-- WoW API / Variables
local GetAddOnEnableState = GetAddOnEnableState

-- GLOBALS: ElvDB, hooksecurefunc, BINDING_HEADER_MER
-- GLOBALS: MERData, MERDataPerChar

MER["styling"] = {}
MER.Logo = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\mUI.tga]]
MER.LogoSmall = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\mUI1.tga]]
BINDING_HEADER_MER = "|cffff7d0aMerathilisUI|r"

-- Masque support
MER.MSQ = _G.LibStub('Masque', true)

local function PrintURL(url) -- Credit: Azilroka
	return format("|cFF00c0fa[|Hurl:%s|h%s|h]|r", url, url)
end

function MER:cOption(name)
	local color = "|cffff7d0a%s |r"
	return (color):format(name)
end

function MER:DasOptions()
	E:ToggleOptionsUI(); LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "mui")
end

function MER:LoadCommands()
	self:RegisterChatCommand("mui", "DasOptions")
end

function MER:RegisterMedia()
	--Fonts
	E.media.muiFont = LSM:Fetch("font", "Merathilis Prototype")
	E.media.muiVisitor = LSM:Fetch("font", "Merathilis Visitor1")
	E.media.muiVisitor2 = LSM:Fetch("font", "Merathilis Visitor2")
	E.media.muiTuk = LSM:Fetch("font", "Merathilis Tukui")
	E.media.muiRoboto = LSM:Fetch("font", "Merathilis Roboto-Black")
	E.media.muiGothic = LSM:Fetch("font", "Merathilis Gothic-Bold")

	-- Background
	-- Border

	--Textures
	E.media.muiBlank = LSM:Fetch("statusbar", "MerathilisBlank")
	E.media.muiBorder = LSM:Fetch("statusbar", "MerathilisBorder")
	E.media.muiEmpty = LSM:Fetch("statusbar", "MerathilisEmpty")
	E.media.muiMelli = LSM:Fetch("statusbar", "MerathilisMelli")
	E.media.muiMelliDark = LSM:Fetch("statusbar", "MerathilisMelliDark")
	E.media.muiOnePixel = LSM:Fetch("statusbar", "MerathilisOnePixel")
	E.media.muiNormTex = LSM:Fetch("statusbar", "MerathilisnormTex")
	E.media.muiGradient = LSM:Fetch("statusbar", "MerathilisGradient")

	-- Custom Textures
	E.media.roleIcons = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\UI-LFG-ICON-ROLES]]
	E.media.checked = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\checked]]

	E:UpdateMedia()
end

function MER:AddMoverCategories()
	tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts) + 1, "MERATHILISUI")
	E.ConfigModeLocalizedStrings["MERATHILISUI"] = format("|cffff7d0a%s |r", "MerathilisUI")
end

function MER:IsAddOnEnabled(addon) -- Credit: Azilroka
	return GetAddOnEnableState(E.myname, addon) == 2
end

function MER:Initialize()
	self:RegisterMedia()
	self:LoadCommands()
	self:SplashScreen()
	self:AddMoverCategories()

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

	self:SetupProfileCallbacks()

	E:Delay(6, function() MER:CheckVersion() end)

	-- run the setup again when a profile gets deleted.
	local profileKey = ElvDB.profileKeys[E.myname.." - "..E.myrealm]
	if ElvDB.profileKeys and profileKey == nil then
		E:GetModule("PluginInstaller"):Queue(MER.installTable)
	end

	if E.db.mui.installed and E.db.mui.general.LoginMsg then
		print(MER.Title..format("v|cff00c0fa%s|r", MER.Version)..L[" is loaded. For any issues or suggestions, please visit "]..MER:PrintURL("https://git.tukui.org/Merathilis/ElvUI_MerathilisUI/issues"))
	end

	-- run install when ElvUI install finishes
	if E.private.install_complete == E.version and E.db.mui.installed == nil then
		E:GetModule("PluginInstaller"):Queue(MER.installTable)
	end
end
