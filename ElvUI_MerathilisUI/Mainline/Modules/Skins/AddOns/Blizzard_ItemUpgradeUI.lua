local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("itemUpgrade", "itemUpgrade") then
		return
	end

	local ItemUpgradeFrame = _G.ItemUpgradeFrame
	ItemUpgradeFrame.TopBG:Hide()

	ItemUpgradeFrame:Styling()
	module:CreateBackdropShadow(ItemUpgradeFrame)

	ItemUpgradeFrame.BottomBGShadow:Hide()
	ItemUpgradeFrame.BottomBG:Hide()
	ItemUpgradeFrame.TopBG:Hide()
end

S:AddCallbackForAddon("Blizzard_ItemUpgradeUI", LoadSkin)
