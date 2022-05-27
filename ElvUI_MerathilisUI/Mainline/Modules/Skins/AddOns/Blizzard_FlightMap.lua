local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_FlightMap()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.taxi ~= true or E.private.mui.skins.blizzard.taxi ~= true then return end

	_G.FlightMapFrame:Styling()
	MER:CreateBackdropShadow(_G.FlightMapFrame)
end

module:AddCallbackForAddon("Blizzard_FlightMap")
