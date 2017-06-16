local E, L, V, P, G = unpack(ElvUI);
local LSM = LibStub("LibSharedMedia-3.0");
local EP = LibStub("LibElvUIPlugin-1.0");
local addon, Engine = ...

local MER = LibStub("AceAddon-3.0"):NewAddon(addon, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")
MER.callbacks = MER.callbacks or LibStub("CallbackHandler-1.0"):New(MER)

-- Cache global variables
-- Lua functions
local _G = _G
local format = string.format
local print, pairs, tonumber = print, pairs, tonumber
-- WoW API / Variables
local CreateFrame = CreateFrame
local GetAddOnMetadata = GetAddOnMetadata
local IsAddOnLoaded = IsAddOnLoaded
local C_TimerAfter = C_Timer.After

-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: LibStub, ElvDB, MUISplashScreen, ElvUI_SLE, hooksecurefunc

--Setting up table to unpack. Why? no idea
Engine[1] = MER
Engine[2] = E
Engine[3] = L
Engine[4] = V
Engine[5] = P
Engine[6] = G
_G[addon] = Engine;

MER.Config = {}
MER.Logo = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\mUI.tga]]
MER.LogoSmall = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\mUI1.tga]]
BINDING_HEADER_MER = "|cffff7d0aMerathilisUI|r"

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
	E["media"].muiExpressway = LSM:Fetch("font", "Merathilis Expressway")
	E["media"].muiRoboto = LSM:Fetch("font", "Merathilis Roboto-Black")

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

	E:UpdateMedia()
end

-- Splash Screen
local function CreateSplashScreen()
	local f = CreateFrame("Frame", "MUISplashScreen", E.UIParent)
	f:Size(300, 150)
	f:SetPoint("CENTER", 0, 100)
	f:SetFrameStrata("TOOLTIP")
	f:SetAlpha(0)

	f.bg = f:CreateTexture(nil, "BACKGROUND")
	f.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	f.bg:SetPoint("BOTTOM")
	f.bg:Size(400, 240)
	f.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	f.bg:SetVertexColor(1, 1, 1, 0.7)

	f.lineTop = f:CreateTexture(nil, "BACKGROUND")
	f.lineTop:SetDrawLayer("BACKGROUND", 2)
	f.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
	f.lineTop:SetPoint("TOP")
	f.lineTop:Size(418, 7)
	f.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	f.lineBottom = f:CreateTexture(nil, "BACKGROUND")
	f.lineBottom:SetDrawLayer("BACKGROUND", 2)
	f.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	f.lineBottom:SetPoint("BOTTOM")
	f.lineBottom:Size(418, 7)
	f.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	f.logo = f:CreateTexture(nil, "OVERLAY")
	f.logo:Size(200, 100)
	f.logo:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\mUI.tga")
	f.logo:Point("CENTER", f, "CENTER")

	f.version = f:CreateFontString(nil, "OVERLAY")
	f.version:FontTemplate(nil, 14, nil)
	f.version:Point("TOP", f.logo, "BOTTOM", 0, 10)
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

	E.db.mui.dbCleaned = true
end


local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	MER:Initialize()
end)

function MER:Initialize()
	-- ElvUI versions check
	if MER.ElvUIV < MER.ElvUIX then
		E:StaticPopup_Show("VERSION_MISMATCH")
		return -- If ElvUI Version is outdated stop right here. So things don't get broken.
	end

	-- BenikUI versions check
	if MER.BenikUIV < MER.BenikUIX then
		E:StaticPopup_Show("BENIKUI_VERSION_MISMATCH")
		return -- If BenikUI Version is outdated stop right here. So things don't get broken.
	end

	self:RegisterMedia()
	self:LoadCommands()

	-- Create empty saved vars if they doesn't exist
	if not MERData then 
		MERData = {};
	end
	if not MERDataPerChar then
		MERDataPerChar = {};
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
	local profileKey = ElvDB.profileKeys[E.myname.." - "..E.myrealm]
	if ElvDB.profileKeys and profileKey == nil then 
		E:GetModule("PluginInstaller"):Queue(MER.installTable)
	end

	if E.db.mui.general.LoginMsg then
		print(MER.Title..format("v|cff00c0fa%s|r", MER.Version)..L[" is loaded."])
	end

	if IsAddOnLoaded("ElvUI_BenikUI") and E.db.benikui.installed == nil then
		return
	end

	if E.private.install_complete == E.version and E.db.mui.installed == nil then 
		E:GetModule("PluginInstaller"):Queue(MER.installTable) 
	end

	EP:RegisterPlugin(addon, self.AddOptions)
end