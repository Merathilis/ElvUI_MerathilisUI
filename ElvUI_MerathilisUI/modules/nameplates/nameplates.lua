local MER, E, L, V, P, G = unpack(select(2, ...))
local MNP = MER:NewModule('mUINamePlates', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
local NP = E:GetModule('NamePlates')

--Cache global variables
--Lua functions
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

-- Copied from ElvUI and overwriting it

function MNP:Initialize()
	if E.private.nameplates.enable ~= true then return end

end

local function InitializeCallback()
	MNP:Initialize()
end

MER:RegisterModule(MNP:GetName(), InitializeCallback)
