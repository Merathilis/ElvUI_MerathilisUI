local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables


-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function CreateStatusFrame()
	local StatusFrame = _G["ElvUIStatusReport"]

	-- Style
	StatusFrame.backdrop:Styling()
end
hooksecurefunc(E, "CreateStatusFrame", CreateStatusFrame)
