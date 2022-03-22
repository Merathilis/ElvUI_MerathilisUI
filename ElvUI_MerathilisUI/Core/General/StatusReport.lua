local MER, F, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
-- GLOBALS:

local function CreateStatusFrame()
	local StatusFrame = _G["ElvUIStatusReport"]
	local PluginFrame = _G["ElvUIStatusPlugins"]

	-- Style
	StatusFrame.backdrop:Styling()
	PluginFrame.backdrop:Styling()
end
hooksecurefunc(E, "CreateStatusFrame", CreateStatusFrame)
