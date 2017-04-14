local E, L, V, P, G = unpack(ElvUI);
local MI = E:GetModule("mUIMisc")

-- Cache global variables
-- Lua functions
local _G = _G
local select = select
local find = find
-- WoW API / Variables
local BuyMerchantItem = BuyMerchantItem
local IsAltKeyDown = IsAltKeyDown
local GetItemInfo = GetItemInfo
local GetMouseFocus = GetMouseFocus
local GetMerchantNumItems = GetMerchantNumItems
local GetMerchantItemInfo = GetMerchantItemInfo
local GetMerchantItemLink = GetMerchantItemLink
local GetMerchantItemMaxStack = GetMerchantItemMaxStack

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: MerchantFrame, GameTooltip, MERCHANT_ITEMS_PER_PAGE

----------------------------------------------------------------------------------------
--	Alt+Click to buy a stack
----------------------------------------------------------------------------------------

function MI:Merchant()
	local NEW_ITEM_VENDOR_STACK_BUY = ITEM_VENDOR_STACK_BUY
	ITEM_VENDOR_STACK_BUY = '|cffa9ff00'..NEW_ITEM_VENDOR_STACK_BUY..'|r'

	local origMerchantItemButton_OnModifiedClick = _G["MerchantItemButton_OnModifiedClick"]
	local function MerchantItemButton_OnModifiedClickHook(self, ...)
		origMerchantItemButton_OnModifiedClick(self, ...)

		if (IsAltKeyDown()) then
			local maxStack = select(8, GetItemInfo(GetMerchantItemLink(self:GetID())))

			local numAvailable = select(5, GetMerchantItemInfo(self:GetID()))

			-- -1 means an item has unlimited supply.
			if (numAvailable ~= -1) then
				BuyMerchantItem(self:GetID(), numAvailable)
			else
				BuyMerchantItem(self:GetID(), GetMerchantItemMaxStack(self:GetID()))
			end
		end
	end
	MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClickHook

	local function IsMerchantButtonOver()
		return GetMouseFocus():GetName() and GetMouseFocus():GetName():find('MerchantItem%d')
	end

	GameTooltip:HookScript('OnTooltipSetItem', function(self)
		if (MerchantFrame:IsShown() and IsMerchantButtonOver()) then
			for i = 2, GameTooltip:NumLines() do
				if (_G['GameTooltipTextLeft'..i]:GetText():find('<')) then	-- '<' horrible solution 
					GameTooltip:AddLine("|cff00ff00<"..L["Alt-click, to buy an stack"]..">|r")
				end
			end
		end
	end)
end

----------------------------------------------------------------------------------------
--	Show item level for weapons and armor in merchant
----------------------------------------------------------------------------------------
local function MerchantItemlevel()
	local numItems = GetMerchantNumItems()

	for i = 1, MERCHANT_ITEMS_PER_PAGE do
		local index = (MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE + i
		if index > numItems then return end

		local button = _G["MerchantItem"..i.."ItemButton"]
		if button and button:IsShown() then
			if not button.text then
				button.text = button:CreateFontString(nil, "OVERLAY", "SystemFont_Outline_Small")
				-- button.text:FontTemplate(E.LSM:Fetch("font", E.db.bags.itemLevelFont), E.db.bags.itemLevelFontSize, E.db.bags.itemLevelFontOutline)
				button.text:SetPoint("TOPLEFT", 1, -1)
				button.text:SetTextColor(r, g, b)
			else
				button.text:SetText("")
			end

			local itemLink = GetMerchantItemLink(index)
			if itemLink then
				local _, _, quality, itemlevel, _, _, _, _, _, _, _, itemClassID = GetItemInfo(itemLink)
				r, g, b = GetItemQualityColor(quality)
				if (itemlevel and itemlevel > 1) and (quality and quality > 1) and (itemClassID == LE_ITEM_CLASS_WEAPON or itemClassID == LE_ITEM_CLASS_ARMOR) then
					button.text:SetText(itemlevel)
				end
			end
		end
	end
end


function MI:LoadMerchant()
	if E.db.mui.general.MerchantiLevel ~= true or E.private.bags.enable ~= true then return end

	self:Merchant()
	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", MerchantItemlevel)
end