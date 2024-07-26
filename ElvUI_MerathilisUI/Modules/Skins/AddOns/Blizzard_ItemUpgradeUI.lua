local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_ItemUpgradeUI()
	if not module:CheckDB("itemUpgrade", "itemUpgrade") then
		return
	end

	local ItemUpgradeFrame = _G.ItemUpgradeFrame
	ItemUpgradeFrame.TopBG:Hide()

	module:CreateBackdropShadow(ItemUpgradeFrame)

	ItemUpgradeFrame.BottomBGShadow:Hide()
	ItemUpgradeFrame.BottomBG:Hide()
	ItemUpgradeFrame.TopBG:Hide()
end

module:AddCallbackForAddon("Blizzard_ItemUpgradeUI")
