local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_FlightMap()
	if not module:CheckDB("taxi", "taxi") then
		return
	end

	local FlightMapFrame = _G.FlightMapFrame
	module:CreateShadow(FlightMapFrame)
end

module:AddCallbackForAddon("Blizzard_FlightMap")
