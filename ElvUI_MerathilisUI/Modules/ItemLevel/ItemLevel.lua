local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_ItemLevel")

-- Item level on the merchant and trade window items. The equipment flyout, the scrapping
-- machine and the guild news are covered by WindTools (Item > Item Level, Misc).

local _G = _G
local select = select

local hooksecurefunc = hooksecurefunc
local GetItemInfo = C_Item.GetItemInfo
local GetTradePlayerItemLink = GetTradePlayerItemLink
local GetTradeTargetItemLink = GetTradeTargetItemLink

-- Read on every call, a reference stored at load would go stale on a profile switch
local function IsEnabled()
	return E.db.mui.itemLevel.enable
end

local function ClearItemLevelFont(button)
	if button.iLvl then
		button.iLvl:SetText("")
	end
end

---Merchant row or trade slot; the text lives on the item button, the reference on the row
function module:ItemLevel_Update(link)
	if not IsEnabled() or not link then
		ClearItemLevelFont(self)
		return
	end

	local quality = select(3, GetItemInfo(link))
	if not quality or quality <= 1 then
		ClearItemLevelFont(self)
		return
	end

	local iLvl = self.iLvl
	if not iLvl then
		local itemButton = _G[self:GetName() .. "ItemButton"]
		if not itemButton then
			return
		end

		iLvl = itemButton:CreateFontString(nil, "OVERLAY")
		iLvl:FontTemplate(nil, 11)
		iLvl:SetPoint("BOTTOMRIGHT", 0, 0)
		self.iLvl = iLvl
	end

	local color = E:GetQualityColor(quality)
	iLvl:SetText(F.GetItemLevel(link))
	iLvl:SetTextColor(color.r, color.g, color.b)
end

function module.ItemLevel_UpdateTradePlayer(index)
	module.ItemLevel_Update(_G["TradePlayerItem" .. index], GetTradePlayerItemLink(index))
end

function module.ItemLevel_UpdateTradeTarget(index)
	module.ItemLevel_Update(_G["TradeRecipientItem" .. index], GetTradeTargetItemLink(index))
end

-- Installed on first enable; from then on they check the setting on every call, so turning
-- it off again (also by a profile switch) works without a reload
function module:UpdateHooks()
	if self.hooked or not IsEnabled() then
		return
	end

	hooksecurefunc("MerchantFrameItem_UpdateQuality", module.ItemLevel_Update)
	hooksecurefunc("TradeFrame_UpdatePlayerItem", module.ItemLevel_UpdateTradePlayer)
	hooksecurefunc("TradeFrame_UpdateTargetItem", module.ItemLevel_UpdateTradeTarget)

	self.hooked = true
end

function module:Initialize()
	self:UpdateHooks()
end

function module:ProfileUpdate()
	self:UpdateHooks()
end

MER:RegisterModule(module:GetName())
