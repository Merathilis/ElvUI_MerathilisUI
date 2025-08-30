local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_ItemInteractionUI()
	if not module:CheckDB("itemInteraction", "itemInteraction") then
		return
	end

	local ItemInteractionFrame = _G.ItemInteractionFrame
	module:CreateShadow(ItemInteractionFrame)
end

module:AddCallbackForAddon("Blizzard_ItemInteractionUI")
