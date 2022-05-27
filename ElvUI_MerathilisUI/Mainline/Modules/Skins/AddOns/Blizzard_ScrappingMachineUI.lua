local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_ScrappingMachineUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.scrapping ~= true or E.private.mui.skins.blizzard.Scrapping ~= true then return end

	local MachineFrame = _G.ScrappingMachineFrame
	MachineFrame:Styling()
	MER:CreateBackdropShadow(MachineFrame)
end

module:AddCallbackForAddon('Blizzard_ScrappingMachineUI')
