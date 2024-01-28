local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_ScrappingMachineUI()
	if not module:CheckDB("scrapping", "Scrapping") then
		return
	end

	local MachineFrame = _G.ScrappingMachineFrame
	module:CreateBackdropShadow(MachineFrame)
end

module:AddCallbackForAddon('Blizzard_ScrappingMachineUI')
