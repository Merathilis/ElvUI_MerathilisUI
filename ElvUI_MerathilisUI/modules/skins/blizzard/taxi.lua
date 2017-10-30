local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables

local function styleTaxi()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.taxi ~= true or E.private.muiSkins.blizzard.taxi ~= true then return end

	_G["TaxiFrame"]:Styling(true, true)
	_G["TaxiRouteMap"]:Styling(true, true)
end

S:AddCallback("mUITaxi", styleTaxi)