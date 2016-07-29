local E, L, V, P, G = unpack(ElvUI);
local MER = E:NewModule('MerathilisUI', "AceConsole-3.0");
local LSM = LibStub('LibSharedMedia-3.0');
local EP = LibStub('LibElvUIPlugin-1.0');
local addon, ns = ...

-- Cache global variables
-- Lua functions
local _G = _G
local format = string.format
local print, pairs, tonumber = print, pairs, tonumber
-- WoW API / Variables
local CreateFrame = CreateFrame
local GetAddOnEnableState = GetAddOnEnableState
local GetAddOnMetadata = GetAddOnMetadata
local IsAddOnLoaded = IsAddOnLoaded
local C_TimerAfter = C_Timer.After

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: LibStub, ElvDB, MUISplashScreen, ElvUI_SLE, hooksecurefunc

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

MER.Config = {}
MER.TexCoords = {.08, 0.92, -.04, 0.92}
MER.Title = format('|cffff7d0a%s |r', 'MerathilisUI')
MER.Version = GetAddOnMetadata('ElvUI_MerathilisUI', 'Version')
MER.ElvUIV = tonumber(E.version)
MER.ElvUIX = tonumber(GetAddOnMetadata("ElvUI_MerathilisUI", "X-ElvVersion"))

function MER:cOption(name)
	local color = '|cffff7d0a%s |r'
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

function MER:LoadCommands()
	self:RegisterChatCommand("mui", "DasOptions")
end

function MER:RegisterMerMedia()
	--Fonts
	E['media'].muiFont = LSM:Fetch('font', 'Merathilis Prototype')
	E['media'].muiVisitor = LSM:Fetch('font', 'Merathilis Visitor1')
	E['media'].muiVisitor2 = LSM:Fetch('font', 'Merathilis Visitor2')
	E['media'].muiTuk = LSM:Fetch('font', 'Merathilis Tukui')
	E['media'].muiExpressway = LSM:Fetch('font', 'Merathilis Expressway')
	E['media'].muiRoboto = LSM:Fetch('font', 'Merathilis Roboto-Black')

	--Textures
	E['media'].MuiEmpty = LSM:Fetch('statusbar', 'MerathilisEmpty')
	E['media'].MuiFlat = LSM:Fetch('statusbar', 'MerathilisFlat')
	E['media'].MuiMelli = LSM:Fetch('statusbar', 'MerathilisMelli')
	E['media'].MuiMelliDark = LSM:Fetch('statusbar', 'MerathilisMelliDark')
	E['media'].MuiOnePixel = LSM:Fetch('statusbar', 'MerathilisOnePixel')

	-- Icons
	E['media']["app"] = ([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\gameIcons\battlenet]])
	E['media']["alliance"] = ([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\gameIcons\alliance]])
	E['media']["d3"] = ([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\gameIcons\d3]])
	E['media']["heroes"] = ([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\gameIcons\heroes]])
	E['media']["horde"] = ([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\gameIcons\horde]])
	E['media']["pro"] = ([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\gameIcons\overwatch]])
	E['media']["sc2"] = ([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\gameIcons\sc2]])
	E['media']["wtcg"] = ([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\gameIcons\hearthstone]])
end

-- Splash Screen
local function CreateSplashScreen()
	local f = CreateFrame('Frame', 'MUISplashScreen', E.UIParent)
	f:Size(300, 150)
	f:SetPoint('CENTER', 0, 100)
	f:SetFrameStrata('TOOLTIP')
	f:SetAlpha(0)

	f.bg = f:CreateTexture(nil, 'BACKGROUND')
	f.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	f.bg:SetPoint('BOTTOM')
	f.bg:Size(400, 240)
	f.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	f.bg:SetVertexColor(1, 1, 1, 0.7)

	f.lineTop = f:CreateTexture(nil, 'BACKGROUND')
	f.lineTop:SetDrawLayer('BACKGROUND', 2)
	f.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
	f.lineTop:SetPoint("TOP")
	f.lineTop:Size(418, 7)
	f.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	f.lineBottom = f:CreateTexture(nil, 'BACKGROUND')
	f.lineBottom:SetDrawLayer('BACKGROUND', 2)
	f.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	f.lineBottom:SetPoint("BOTTOM")
	f.lineBottom:Size(418, 7)
	f.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	f.logo = f:CreateTexture(nil, 'OVERLAY')
	f.logo:Size(256, 128)
	f.logo:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\merathilis_logo.tga')
	f.logo:Point('CENTER', f, 'CENTER')

	f.version = f:CreateFontString(nil, 'OVERLAY')
	f.version:FontTemplate(nil, 12, nil)
	f.version:Point('TOP', f.logo, 'BOTTOM', 0, 30)
	f.version:SetFormattedText("v%s", MER.Version)
	f.version:SetTextColor(1, 0.5, 0.25, 1)
end

local function HideSplashScreen()
	MUISplashScreen:Hide()
end

local function FadeSplashScreen()
	E:Delay(2, function()
		E:UIFrameFadeOut(MUISplashScreen, 2, 1, 0)
		MUISplashScreen.fadeInfo.finishedFunc = HideSplashScreen
	end)
end

local function ShowSplashScreen()
	E:UIFrameFadeIn(MUISplashScreen, 4, 0, 1)
	MUISplashScreen.fadeInfo.finishedFunc = FadeSplashScreen
end

 -- Clean ElvUI.lua in WTF folder from outdated settings
local function dbCleaning()
	-- Clear the old db
	if E.db.benikui.general.gameMenuButton then E.db.benikui.general.gameMenuButton = nil end

	E.db.mui.dbCleaned = true
end

function MER:IncompatibleAddOn(addon, module, optiontable, value)
	E.PopupDialogs["MER_INCOMPATIBLE_ADDON"].button1 = addon
	E.PopupDialogs["MER_INCOMPATIBLE_ADDON"].button2 = 'MER: '..module
	E.PopupDialogs["MER_INCOMPATIBLE_ADDON"].addon = addon
	E.PopupDialogs["MER_INCOMPATIBLE_ADDON"].module = module
	E.PopupDialogs["MER_INCOMPATIBLE_ADDON"].optiontable = optiontable
	E.PopupDialogs["MER_INCOMPATIBLE_ADDON"].value = value
	E.PopupDialogs["MER_INCOMPATIBLE_ADDON"].showAlert = true
	E:StaticPopup_Show('MER_INCOMPATIBLE_ADDON', addon, module)
end

function MER:CheckIncompatible()
	if GetAddOnEnableState('ElvUI_SLE', 1) then
		if IsAddOnLoaded('ElvUI_LocPlus') and E.db.sle.minimap.locPanel.enable then
			E:StaticPopup_Show('LOCATION_PLUS_INCOMPATIBLE')
			return true
		end
	end
	return false
end

function MER:Initialize()
	-- ElvUI versions check
	if MER.ElvUIV < MER.ElvUIX then
		E:StaticPopup_Show("VERSION_MISMATCH")
		return -- If ElvUI Version is outdated stop right here. So things don't get broken.
	end

	self:RegisterMerMedia()
	self:LoadCommands()
	self:LoadGameMenu()
	self:CheckIncompatible()

	if MerathilisUIData == nil then
		MerathilisUIData = {}
	end

	if E.db.mui.dbCleaned ~= true then
		dbCleaning()
	end

	if E.db.mui.general.SplashScreen then
		CreateSplashScreen()
	end

	-- Show only Splash Screen if the install is completed
	if (E.db.mui.installed == true and E.db.mui.general.SplashScreen) then
		C_TimerAfter(6, ShowSplashScreen)
	end

	-- run the setup again when a profile gets deleted.
	local profileKey = ElvDB.profileKeys[E.myname..' - '..E.myrealm]
	if ElvDB.profileKeys and profileKey == nil then 
		self:SetupUI()
	end

	if E.db.mui.general.LoginMsg then
		print(MER.Title..format('v|cff00c0fa%s|r', MER.Version)..L[' is loaded.'])
	end
	EP:RegisterPlugin(addon, self.AddOptions)

	if IsAddOnLoaded("ElvUI_BenikUI") and E.db.benikui.installed == nil then
		return
	end

	if E.private.install_complete == E.version and E.db.mui.installed == nil then 
		E:GetModule("PluginInstaller"):Queue(MER.installTable) 
	end
end

E:RegisterModule(MER:GetName())
