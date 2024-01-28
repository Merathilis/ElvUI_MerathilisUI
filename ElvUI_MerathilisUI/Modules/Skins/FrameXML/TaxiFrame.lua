local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:TaxiFrame()
	if not module:CheckDB("taxi", "taxi") then
		return
	end
end

module:AddCallback("TaxiFrame")
