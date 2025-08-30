local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_ScrappingMachineUI()
	if not module:CheckDB("scrapping", "Scrapping") then
		return
	end

	local MachineFrame = _G.ScrappingMachineFrame
	module:CreateShadow(MachineFrame)
end

module:AddCallbackForAddon("Blizzard_ScrappingMachineUI")
