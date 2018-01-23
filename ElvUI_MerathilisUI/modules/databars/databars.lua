local MER, E, L, V, P, G = unpack(select(2, ...))
local MDB = E:NewModule("mUI_databars")
MDB.modName = L["DataBars"]

--Cache global variables

--WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MDB:Initialize()

end

local function InitializeCallback()
	MDB:Initialize()
end

-- E:RegisterModule(MDB:GetName(), InitializeCallback)