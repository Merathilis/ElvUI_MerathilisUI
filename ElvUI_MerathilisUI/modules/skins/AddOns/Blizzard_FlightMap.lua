local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleFlightMap()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.taxi ~= true or E.private.muiSkins.blizzard.taxi ~= true then return end

	_G.FlightMapFrame:Styling()
end

S:AddCallbackForAddon("Blizzard_FlightMap", "mUIFlightMap", styleFlightMap)
