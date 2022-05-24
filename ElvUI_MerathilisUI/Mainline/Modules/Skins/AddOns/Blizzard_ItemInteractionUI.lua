local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_ItemInteractionUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.itemInteraction ~= true or E.private.mui.skins.blizzard.ItemInteraction ~= true then return end

	local ItemInteractionFrame = _G.ItemInteractionFrame
	if ItemInteractionFrame.backdrop then
		ItemInteractionFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(ItemInteractionFrame)
end

module:AddCallbackForAddon("Blizzard_ItemInteractionUI")
