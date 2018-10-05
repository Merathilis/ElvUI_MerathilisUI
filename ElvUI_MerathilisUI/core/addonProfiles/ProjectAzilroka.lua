local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MER:LoadPAProfile()
	--[[----------------------------------
	--	ProjectAzilroka - Settings
	--]]----------------------------------

	-- ProjectAzilrokaDB
	_G.ProjectAzilroka.db.BB = false
	_G.ProjectAzilroka.db.SMB = false
	_G.ProjectAzilroka.db.DO = false
	_G.ProjectAzilroka.db.MF = false
	_G.ProjectAzilroka.db.QS = false
	_G.ProjectAzilroka.db.EFL = false

	--stAddonManagerProfilesDB
	if stAddonManagerDB.profiles["MerathilisUI"] == nil then stAddonManagerDB.profiles["MerathilisUI"] = {} end

	stAddonManagerDB.profiles["MerathilisUI"] = {
		["NumAddOns"] = 15,
		["ButtonHeight"] = 20,
		["ButtonWidth"] = 20,
		["Font"] = "Expressway",
		["ClassColor"] = true,
		["CheckTexture"] = "Duffed",
	},

	-- Profile creation
	_G.stAddonManager.data:SetProfile("MerathilisUI")
end