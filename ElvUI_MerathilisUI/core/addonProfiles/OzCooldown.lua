local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: OzCooldownsDB, LibStub

local playerName = UnitName("player")
local profileName = playerName.."-mUI"

function MER:LoadOCDProfile()
	--[[----------------------------------
	--	AddOnSkins - Settings
	--]]----------------------------------

	-- defaults
	OzCooldownsDB.profiles[profileName] = {
		["StatusBarTexture"] = "MerathilisGradient",
		["StackFont"] = "Expressway",
		["StackFontFlag"] = "OUTLINE",
		["StackFontSize"] = 12,
		["Tooltips"] = false,
		["Size"] = 30,
		["FadeMode"] = "GreenToRed",
		["Announce"] = false,
		["CooldownText"] = {
			["Font"] = "Expressway",
			["FontFlag"] = "OUTLINE",
			["FontSize"] = 14,
		},
	}

	E.db["movers"]["OzCooldownsMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,320"

	-- Profile creation
	local db = LibStub("AceDB-3.0"):New(OzCooldownsDB)
	db:SetProfile(profileName)
end