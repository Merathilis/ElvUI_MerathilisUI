local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.bags.enable then
		return
	end

	for bagID = 1, _G.NUM_CONTAINER_FRAMES do
		local container = _G["ContainerFrame" .. bagID]
		if container and container.template then
			container:Styling()
			module:CreateShadow(container)
		end
	end

	_G.ContainerFrameCombinedBags:Styling()
	module:CreateShadow(_G.ContainerFrameCombinedBags)
end

S:AddCallback("BagFrame", LoadSkin)
