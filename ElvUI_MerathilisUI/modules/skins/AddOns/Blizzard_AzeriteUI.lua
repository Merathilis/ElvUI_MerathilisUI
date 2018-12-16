local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G

--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleAzerite()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.AzeriteUI ~= true or E.private.muiSkins.blizzard.AzeriteUI ~= true then return end

	local AzeriteEmpoweredItemUI = _G.AzeriteEmpoweredItemUI
	AzeriteEmpoweredItemUI:Styling()
end

S:AddCallbackForAddon("Blizzard_AzeriteUI", "mUIAzerite", styleAzerite)
