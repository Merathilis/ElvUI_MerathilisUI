local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');

-- Cache global variables
local _G = _G
-- Lua functions
-- WoW API / Variables
-- GLOBALS: hooksecurefunc

--[[local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

local function styleworldMap()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.worldmap ~= true or E.private.muiSkins.blizzard.worldmap ~= true then return end
end
hooksecurefunc(S, "Initialize", styleworldMap)]]