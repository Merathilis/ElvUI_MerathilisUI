local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.scrapping ~= true or E.private.mui.skins.blizzard.Scrapping ~= true then return end

	local MachineFrame = _G.ScrappingMachineFrame
	MachineFrame:Styling()
	MER:CreateBackdropShadow(MachineFrame)
end

S:AddCallbackForAddon('Blizzard_ScrappingMachineUI', LoadSkin)
