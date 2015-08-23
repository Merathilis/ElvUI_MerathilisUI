local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:NewModule('MerathilisUI', "AceConsole-3.0");

local LSM = LibStub('LibSharedMedia-3.0')
local EP = LibStub('LibElvUIPlugin-1.0')
local addon, ns = ...

-- Profile (if this gets big, move it to a seperate file but load before your core.lua. Put it in the .toc file)
-- In case you create options, also add them here
P['mer'] = {
	['installed'] = nil,
}

-- local functions must go up
local function SetupUI()
	-- Here you put ElvUI settings that you want enabled or not.
	-- Opening ElvUI.lua file from the WTF folder will show you your current profile settings.
	do
		-- e.g. I want the datatexts to have the font 'Andy Roadway'
		E.db.datatexts.font = 'Andy Roadway'
		
		-- Size
		E.db.datatexts.fontSize = 10
		
		-- Outline
		E.db.datatexts.fontOutline = 'OUTLINE'
	end
	
	-- Also for moving stuff around you must grab the mover. It's in the same as above file.
	do
		-- e.g. minimap mover
		E.db.movers.MinimapMover = 'TOPRIGHTElvUIParentTOPRIGHT-4-5'
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