local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: 

local playerName = UnitName("player")
local profileName = playerName.."-mUI"

function MER:LoadOCDProfile()
	--[[----------------------------------
	--	AddOnSkins - Settings
	--]]----------------------------------

	-- defaults
	if(not OzCooldownsDB.profiles[profileName]) then
		OzCooldownsDB.profiles[profileName] = {
			["StatusBarTexture"] = "MerathilisGradient",
			["DurationFont"] = "Expressway",
			["Tooltips"] = false,
			["Size"] = 30,
			["FadeMode"] = "GreenToRed",
			["Announce"] = false,
		}
	end

	-- Profile creation
	local db = LibStub("AceDB-3.0"):New(OzCooldownsDB)
	db:SetProfile(profileName)
end