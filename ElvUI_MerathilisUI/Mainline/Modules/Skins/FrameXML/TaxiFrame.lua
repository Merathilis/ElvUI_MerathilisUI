local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.taxi ~= true or not E.private.mui.skins.blizzard.taxi then return end

	_G.TaxiFrame:Styling()
	_G.TaxiRouteMap:Styling()
end

S:AddCallback("TaxiFrame", LoadSkin)
