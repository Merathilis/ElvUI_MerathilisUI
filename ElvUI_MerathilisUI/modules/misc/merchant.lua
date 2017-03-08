local E, L, V, P, G = unpack(ElvUI);

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
local GetMerchantItemInfo = GetMerchantItemInfo
local GetMerchantItemLink = GetMerchantItemLink
local GetMerchantItemMaxStack = GetMerchantItemMaxStack

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: MerchantFrame, GameTooltip

----------------------------------------------------------------------------------------
--	Alt+Click to buy a stack
----------------------------------------------------------------------------------------
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