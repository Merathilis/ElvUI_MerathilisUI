local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("scrapping", "Scrapping") then
		return
	end

	local MachineFrame = _G.ScrappingMachineFrame
	MachineFrame:Styling()
	module:CreateBackdropShadow(MachineFrame)
end

S:AddCallbackForAddon('Blizzard_ScrappingMachineUI', LoadSkin)
