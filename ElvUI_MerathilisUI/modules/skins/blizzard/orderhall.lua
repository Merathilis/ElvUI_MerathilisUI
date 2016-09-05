local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule('Skins');

-- Cache global variables
-- Lua functions
-- WoW API / Variables
-- GLOBALS: 

local function styleOrderhall()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true or E.private.muiSkins.blizzard.orderhall ~= true then return end

end
hooksecurefunc(S, "Initialize", styleOrderhall)