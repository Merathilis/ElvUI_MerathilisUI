local MER, E, L, V, P, G = unpack(select(2, ...))
local NA = MER:NewModule("NameplateAuras", "AceEvent-3.0")
local NP = E:GetModule("NamePlates")
NA.modName = L["NameplateAuras"]

-- Cache global variables
-- Lua functions

-- WoW API / Variables

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function NA:Initialize()
end

local function InitializeCallback()
	NA:Initialize()
end

MER:RegisterModule(NA:GetName(), InitializeCallback)
