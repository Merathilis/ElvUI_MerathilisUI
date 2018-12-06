local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MER:LoadPAProfile()
	--[[----------------------------------
	--	ProjectAzilroka - Settings
	--]]----------------------------------

	if ProjectAzilrokaDB.profiles["MerathilisUI"] == nil then ProjectAzilrokaDB.profiles["MerathilisUI"] = {} end
	ProjectAzilrokaDB.profiles["MerathilisUI"] = {
		-- Has to be before EFL
		['FriendGroups'] = {
			['Enable'] = false
		},

		["EnhancedFriendsList"] = {
			['Enable'] = true,
			["InfoFontSize"] = 10,
			["App"] = "Animated",
			["StatusIconPack"] = "Square",
			["NameFontSize"] = 11,
			["NameFont"] = "Expressway",
			["InfoFont"] = "Expressway",
		},

		['BigButtons'] = {
			['Enable'] = false
		},

		['BrokerLDB'] = {
			['Enable'] = false
		},

		['DragonOverlay'] = {
			['Enable'] = false
		},

		['EnhancedShadows'] = {
			['Enable'] = false
		},

		['FasterLoot'] = {
			['Enable'] = false
		},

		['MovableFrames'] = {
			['Enable'] = false
		},

		['SquareMinimapButtons'] = {
			['Enable'] = false
		},

		["stAddonManager"] = {
			['Enable'] = true,
			["NumAddOns"] = 15,
			["ButtonHeight"] = 20,
			["ButtonWidth"] = 20,
			["Font"] = "Expressway",
			["ClassColor"] = true,
			["CheckTexture"] = "Duffed",
		},

		['QuestSounds'] = {
			['Enable'] = false
		},

		['ReputationReward'] = {
			['Enable'] = true
		},
	}

	--Profile creation
	--ProjectAzilrokaDB.profiles:SetProfile("MerathilisUI")
end
