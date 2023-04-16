local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("taxi", "taxi") then
		return
	end

	local FlightMapFrame = _G.FlightMapFrame
	FlightMapFrame:Styling()
	module:CreateShadow(FlightMapFrame)
end

S:AddCallbackForAddon("Blizzard_FlightMap", LoadSkin)
