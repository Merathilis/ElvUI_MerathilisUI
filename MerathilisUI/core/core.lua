local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:NewModule('MerathilisUI', "AceConsole-3.0");
local LSM = LibStub('LibSharedMedia-3.0');
local EP = LibStub('LibElvUIPlugin-1.0');
local addon, ns = ...

MER.Title = string.format('|cff00c0fa%s |r', 'MerathilisUI') -- maybe for the Future
MER.Version = GetAddOnMetadata('MerathilisUI', 'Version') -- with this we get the addon version from toc file

-- Profile (if this gets big, move it to a seperate file but load before your core.lua. Put it in the .toc file)
-- In case you create options, also add them here
P['Merathilis'] = {
	['installed'] = nil,
}

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

function MER:Initialize()
	self:RegisterMerMedia()
	--self:LoadCommands() -- Run the register commands function
	
	-- if ElvUI installed and if in your profile the install is nil then run the SetupUI() function.
	-- This is a check so that your setup won't run everytime you login
	-- Enable it when you are done
	--if E.private.install_complete == E.version and E.db.Merathilis.installed == nil then SetupUI() end
	
	-- run the setup again when a profile gets deleted.
	local profileKey = ElvDB.profileKeys[E.myname..' - '..E.myrealm]
	if ElvDB.profileKeys and profileKey == nil then SetupUI() end
	
	-- run your setup on load for testing purposes. When you are done with the options, disable it.
	--SetupUI()
	
	if E.private.install_complete == E.version and E.db.Merathilis.installed == nil then -- pop the message only if ElvUI install is complete on this char and your ui hasn't been applied yet
		StaticPopup_Show("merathilis")
	end
	print(MER.Title..format('v|cff00c0fa%s|r',MER.Version)..L[' is loaded.'])
end

SLASH_MERATHILISUI1 = '/muisetup' -- doesn't allow spaces... this way :P Ususally spaces are used if you want to add different commands like /mui setup and /mui datatexts but a function should be made to handle those
SlashCmdList["MERATHILISUI"] = function()
	StaticPopup_Show("merathilis")
end

E:RegisterModule(MER:GetName())
