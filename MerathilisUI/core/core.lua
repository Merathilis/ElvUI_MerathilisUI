local E, L, V, P, G = unpack(ElvUI);
local MER = E:NewModule('MerathilisUI', "AceConsole-3.0");
local LSM = LibStub('LibSharedMedia-3.0');
local EP = LibStub('LibElvUIPlugin-1.0');
local addon, ns = ...

-- Cache global variables
local _G = _G
local format = string.format
local print, pairs, tonumber = print, pairs, tonumber
local CreateFrame = CreateFrame
local GetAddOnMetadata = GetAddOnMetadata
local IsAddOnLoaded = IsAddOnLoaded

MER.TexCoords = {.08, 0.92, -.04, 0.92}
MER.Title = format('|cffff7d0a%s |r', 'MerathilisUI')
MER.Version = GetAddOnMetadata('MerathilisUI', 'Version')
MER.ElvUIV = tonumber(E.version)
MER.ElvUIX = tonumber(GetAddOnMetadata("MerathilisUI", "X-ElvVersion"))

function MER:cOption(name)
	local MER_COLOR = '|cffff7d0a%s |r'
	return (MER_COLOR):format(name)
end

function MER:StyleFrame(frame)
	if not IsAddOnLoaded("ElvUI_BenikUI") then return end
	if frame and not frame.style then
		frame:Style("Outside")
	end
end

function MER:RegisterMerMedia()
	--Fonts
	E['media'].muiFont = LSM:Fetch('font', 'Merathilis Prototype')
	E['media'].muiVisitor = LSM:Fetch('font', 'Merathilis Visitor1')
	E['media'].muiVisitor2 = LSM:Fetch('font', 'Merathilis Visitor2')
	E['media'].muiTuk = LSM:Fetch('font', 'Merathilis Tukui')
	
	--Textures
	E['media'].MuiEmpty = LSM:Fetch('statusbar', 'MerathilisEmpty')
	E['media'].MuiFlat = LSM:Fetch('statusbar', 'MerathilisFlat')
	E['media'].MuiMelli = LSM:Fetch('statusbar', 'MerathilisMelli')
	E['media'].MuiMelliDark = LSM:Fetch('statusbar', 'MerathilisMelliDark')
	E['media'].MuiOnePixel = LSM:Fetch('statusbar', 'MerathilisOnePixel')
end

E.MerConfig = {}

function MER:AddOptions()
	for _, func in pairs(E.MerConfig) do
		func()
	end	
end

function MER:DasOptions()
	E:ToggleConfig(); LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "mui")
end

function MER:LoadCommands()
	self:RegisterChatCommand("mui", "DasOptions")
	self:RegisterChatCommand("muisetup", "SetupUI")
end

function MER:MismatchText()
	local text = format(L["MSG_MER_ELV_OUTDATED"], MER.ElvUIV, MER.ElvUIX)
	return text
end

function MER:Print(msg)
	print(E["media"].hexvaluecolor..'MUI:|r', msg)
end

-- Splash Screen like BenikUI
local function CreateSplashScreen()
	local f = CreateFrame('Frame', 'SplashScreen', E.UIParent)
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
	f.logo:SetTexture('Interface\\AddOns\\MerathilisUI\\media\\textures\\merathilis_logo.tga')
	f.logo:Point('CENTER', f, 'CENTER')
	
	f.version = f:CreateFontString(nil, 'OVERLAY')
	f.version:FontTemplate(nil, 12, nil)
	f.version:Point('TOP', f.logo, 'BOTTOM', 0, 30)
	f.version:SetFormattedText("v%s", MER.Version)
	f.version:SetTextColor(1, 0.5, 0.25, 1)
end

local function HideSplashScreen()
	_G["SplashScreen"]:Hide()
end

local function FadeSplashScreen()
	E:Delay(2, function()
		E:UIFrameFadeOut(_G["SplashScreen"], 2, 1, 0)
		_G["SplashScreen"].fadeInfo.finishedFunc = HideSplashScreen
	end)
end

local function ShowSplashScreen()
	E:UIFrameFadeIn(_G["SplashScreen"], 4, 0, 1)
	_G["SplashScreen"].fadeInfo.finishedFunc = FadeSplashScreen
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
	if E.db.muiGeneral.SplashScreen then
		CreateSplashScreen()
	end
	
	-- Show only Splash Screen if the install is completed
	if (E.db.mui.installed == true and E.db.muiGeneral.SplashScreen) then C_Timer.After(6, ShowSplashScreen) end
	
	-- run the setup again when a profile gets deleted.
	local profileKey = ElvDB.profileKeys[E.myname..' - '..E.myrealm]
	if ElvDB.profileKeys and profileKey == nil then self:SetupUI() end
	
	if E.db.muiGeneral.LoginMsg then
		print(MER.Title..format('v|cff00c0fa%s|r',MER.Version)..L[' is loaded.'])
	end
	EP:RegisterPlugin(addon, self.AddOptions)
	
	if IsAddOnLoaded("ElvUI_BenikUI") and E.db.bui.installed == nil then return end 
	if E.private.install_complete == E.version and E.db.mui.installed == nil then self:SetupUI() end
end

E:RegisterModule(MER:GetName())
