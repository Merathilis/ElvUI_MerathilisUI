local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.itemUpgrade ~= true or E.private.mui.skins.blizzard.itemUpgrade ~= true then return end

	local ItemUpgradeFrame = _G.ItemUpgradeFrame
	ItemUpgradeFrame.TopBG:Hide()

	ItemUpgradeFrame:Styling()
	MER:CreateBackdropShadow(ItemUpgradeFrame)

	ItemUpgradeFrame.BottomBGShadow:Hide()
	ItemUpgradeFrame.BottomBG:Hide()
	ItemUpgradeFrame.TopBG:Hide()
end

S:AddCallbackForAddon("Blizzard_ItemUpgradeUI", LoadSkin)
