local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:BagFrame()
	if E.private.bags.enable then
		return
	end

	for bagID = 1, _G.NUM_CONTAINER_FRAMES do
		local container = _G["ContainerFrame" .. bagID]
		if container and container.template then
			module:CreateShadow(container)
		end
	end

	module:CreateShadow(_G.ContainerFrameCombinedBags)
end

module:AddCallback("BagFrame")
