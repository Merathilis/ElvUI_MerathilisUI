local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("itemInteraction", "itemInteraction") then
		return
	end

	local ItemInteractionFrame = _G.ItemInteractionFrame
	ItemInteractionFrame:Styling()
	module:CreateShadow(ItemInteractionFrame)
	ItemInteractionFrame.Background:SetAlpha(0.75)
end

S:AddCallbackForAddon("Blizzard_ItemInteractionUI", LoadSkin)
