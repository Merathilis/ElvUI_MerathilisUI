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
	_G.ProjectAzilroka.db.EFL = true

	--stAddonManagerProfilesDB
	if stAddonManagerDB.profiles["MerathilisUI"] == nil then stAddonManagerDB.profiles["MerathilisUI"] = {} end
	stAddonManagerDB.profiles["MerathilisUI"] = {
		["NumAddOns"] = 15,
		["ButtonHeight"] = 20,
		["ButtonWidth"] = 20,
		["Font"] = "Expressway",
		["ClassColor"] = true,
		["CheckTexture"] = "Duffed",
	}

	if EnhancedFriendsListDB.profiles["MerathilisUI"] == nil then EnhancedFriendsListDB.profiles["MerathilisUI"] = {} end
	EnhancedFriendsListDB.profiles["MerathilisUI"] = {
		["InfoFontSize"] = 10,
		["App"] = "Animated",
		["StatusIconPack"] = "Square",
		["NameFontSize"] = 11,
		["NameFont"] = "Expressway",
		["InfoFont"] = "Expressway",
	}

	-- Profile creation
	_G.stAddonManager.data:SetProfile("MerathilisUI")
	_G.EnhancedFriendsList.data:SetProfile("MerathilisUI")
end
