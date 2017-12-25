local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MER:LoadPAProfile()
	--[[----------------------------------
	--	ProjectAzilroka - Settings
	--]]----------------------------------

	--stAddonManagerDB
	if stAddonManagerDB["profiles"]["MerathilisUI"] == nil then stAddonManagerDB["profiles"]["MerathilisUI"] = {} end

	stAddonManagerDB.profiles["MerathilisUI"] = {
		["ButtonHeight"] = 20,
		["ButtonWidth"] = 20,
		["Font"] = "Expressway",
		["CheckColor"] = {
			1, -- [1]
			0.490196078431373, -- [2]
			0.0392156862745098, -- [3]
			1, -- [4]
		},
		["CheckTexture"] = "MerathilisGradient",
	}

	-- Profile creation
	local db = LibStub("AceDB-3.0"):New(stAddonManagerDB)
	db:SetProfile("MerathilisUI")
end