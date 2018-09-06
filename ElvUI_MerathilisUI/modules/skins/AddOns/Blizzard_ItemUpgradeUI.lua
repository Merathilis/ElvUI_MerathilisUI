local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G

-- WoW API

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleItemUpgrade()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.itemUpgrade ~= true or E.private.muiSkins.blizzard.itemUpgrade ~= true then return end

	local ItemUpgradeFrame = _G["ItemUpgradeFrame"]
	local ItemButton = ItemUpgradeFrame.ItemButton

	ItemUpgradeFrame:Styling()

	ItemUpgradeFrame:DisableDrawLayer("BACKGROUND")
	ItemUpgradeFrame:DisableDrawLayer("BORDER")
	ItemUpgradeFrameMoneyFrameLeft:Hide()
	ItemUpgradeFrameMoneyFrameMiddle:Hide()
	ItemUpgradeFrameMoneyFrameRight:Hide()
	ItemUpgradeFrame.ButtonFrame:GetRegions():Hide()
	ItemUpgradeFrame.ButtonFrame.ButtonBorder:Hide()
	ItemUpgradeFrame.ButtonFrame.ButtonBottomBorder:Hide()
	ItemButton.Frame:Hide()
	ItemButton.Grabber:Hide()
	ItemButton.TextFrame:Hide()
	ItemButton.TextGrabber:Hide()

	MERS:CreateBD(ItemButton, .25)
	ItemButton:SetHighlightTexture("")
	ItemButton:SetPushedTexture("")
	ItemButton.IconTexture:SetPoint("TOPLEFT", 1, -1)
	ItemButton.IconTexture:SetPoint("BOTTOMRIGHT", -1, 1)

	local bg = CreateFrame("Frame", nil, ItemButton)
	bg:SetSize(341, 50)
	bg:SetPoint("LEFT", ItemButton, "RIGHT", -1, 0)
	bg:SetFrameLevel(ItemButton:GetFrameLevel()-1)
	MERS:CreateBD(bg, .25)

	ItemButton:HookScript("OnEnter", function(self)
		self:SetBackdropBorderColor(1, .56, .85)
	end)
	ItemButton:HookScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0, 0, 0)
	end)

	ItemButton.Cost.Icon:SetTexCoord(unpack(E.TexCoords))
	ItemButton.Cost.Icon.bg = MERS:CreateBG(ItemButton.Cost.Icon)

	hooksecurefunc("ItemUpgradeFrame_Update", function()
		if GetItemUpgradeItemInfo() then
			ItemButton.IconTexture:SetTexCoord(unpack(E.TexCoords))
			ItemButton.Cost.Icon.bg:Show()
		else
			ItemButton.IconTexture:SetTexture("")
			ItemButton.Cost.Icon.bg:Hide()
		end
	end)

	local currency = ItemUpgradeFrameMoneyFrame.Currency
	currency.icon:SetPoint("LEFT", currency.count, "RIGHT", 1, 0)
	currency.icon:SetTexCoord(unpack(E.TexCoords))
	MERS:CreateBG(currency.icon)

	local bg = CreateFrame("Frame", nil, ItemUpgradeFrame)
	bg:SetAllPoints(ItemUpgradeFrame)
	bg:SetFrameLevel(ItemUpgradeFrame:GetFrameLevel()-1)
	MERS:CreateBD(bg)
end

S:AddCallbackForAddon("Blizzard_ItemUpgradeUI", "mUIItemUpgrade", styleItemUpgrade)