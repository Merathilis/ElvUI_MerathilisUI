local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:NewModule('MerathilisUI', "AceConsole-3.0");

local LSM = LibStub('LibSharedMedia-3.0')
local EP = LibStub('LibElvUIPlugin-1.0')
local addon, ns = ...

-- Profile (if this gets big, move it to a seperate file but load before your core.lua. Put it in the .toc file)
-- In case you create options, also add them here
P['Merathilis Eule'] = {
	['installed'] = nil,
}
-- local functions must go up
local function SetupUI()
	-- Here you put ElvUI settings that you want enabled or not.
	-- Opening ElvUI.lua file from the WTF folder will show you your current profile settings.
	do
		--General
		E.db.general.totems.size = 36
		E.db.general.fontSize = 11
		E.db.general.interruptAnnounce = "RAID"
		E.db.general.autoRepair = "GUILD"
		E.db.general.minimap.garrisonPos = "TOPRIGHT"
		E.db.general.minimap.icons.garrison.scale = 0.9
		E.db.general.minimap.icons.garrison.position = "TOPRIGHT"
		E.db.general.minimap.icons.garrison.yOffset = 10
		E.db.general.minimap.size = 150
		E.db.general.bottompanel = false
		E.db.general.backdropfadecolor.r = 0.0549019607843137
		E.db.general.backdropfadecolor.g = 0.0549019607843137
		E.db.general.backdropfadecolor.b = 0.0549019607843137
	end
	
	do
		-- Datatexts
		E.db.datatexts.font = 'Andy Roadway'
		E.db.datatexts.fontSize = 10
		E.db.datatexts.fontOutline = 'OUTLINE'
		
	end
	
	-- Movers
	if E.db.movers == nil then E.db.movers = {} end -- prevent a lua error when running the install after a profile gets deleted.
	do
		E.db.movers.MinimapMover = -- here we fucked it up
	end

	print('MerathilisUI Setup is done. Please Reload')
	-- Setup is done so set our option to true, so the Setup won't run again on this player.
	-- Enable it when you are done with the settings
	
	--E.db.mer.installed = true

end

function MER:Initialize()
	-- if ElvUI installed and if in your profile the install is nil then run the SetupUI() function.
	-- This is a check so that your setup won't run everytime you login
	-- Enable it when you are done
	--if E.private.install_complete == E.version and E.db.mer.installed == nil then SetupUI() end
	
	-- run your setup on load for testing purposes. When you are done with the options, disable it.
	SetupUI()
end

E:RegisterModule(MER:GetName())