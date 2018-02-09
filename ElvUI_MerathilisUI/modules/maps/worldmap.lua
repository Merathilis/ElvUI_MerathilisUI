local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS:

-- Change the default position
local WorldMapFrame = _G["WorldMapFrame"]
hooksecurefunc("WorldMap_ToggleSizeDown", function()
	WorldMapFrame:ClearAllPoints()
	WorldMapFrame:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, 320)
end)