local E, L, V, P, G = unpack(ElvUI);
local MER = E:NewModule('MerathilisUI', "AceConsole-3.0");
local LSM = LibStub('LibSharedMedia-3.0');
local EP = LibStub('LibElvUIPlugin-1.0');
local addon, ns = ...

-- Cache global variables
local format = string.format
local pairs = pairs
local tonumber = tonumber
local GetAddOnMetadata = GetAddOnMetadata
local IsAddOnLoaded = IsAddOnLoaded

MER.TexCoords = {.08, 0.92, -.04, 0.92}
MER.Title = format('|cffff7d0a%s |r', 'MerathilisUI')
MER.Version = GetAddOnMetadata('MerathilisUI', 'Version') -- with this we get the addon version from toc file
MER.ElvUIV = tonumber(E.version)
MER.ElvUIB = tonumber(GetAddOnMetadata("MerathilisUI", "X-ElvVersion"))

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
	local text = format(L["MSG_MER_ELV_OUTDATED"], MER.ElvUIV, MER.ElvUIB)
	return text
end

function MER:Initialize()
	-- ElvUI versions check
	if MER.ElvUIV < MER.ElvUIB then
		E:StaticPopup_Show("VERSION_MISMATCH")
		return -- If ElvUI Version is outdated stop right here. So things don't get broken.
	end
	self:RegisterMerMedia()
	self:LoadCommands()
	self:LoadGameMenu()
	
	-- run the setup again when a profile gets deleted.
	local profileKey = ElvDB.profileKeys[E.myname..' - '..E.myrealm]
	if ElvDB.profileKeys and profileKey == nil then self:SetupUI() end
	
	if E.db.muiGeneral.LoginMsg then
		print(MER.Title..format('v|cff00c0fa%s|r',MER.Version)..L[' is loaded.'])
	end
	EP:RegisterPlugin(addon, self.AddOptions)
	
	-- if ElvUI installed and if in your profile the install is nil then run the SetupUI() function.
	-- This is a check so that your setup won't run everytime you login
	-- Enable it when you are done
	if IsAddOnLoaded("ElvUI_BenikUI") and E.db.bui.installed == nil then return end 
	if E.private.install_complete == E.version and E.db.mui.installed == nil then self:SetupUI() end
end

E:RegisterModule(MER:GetName())
