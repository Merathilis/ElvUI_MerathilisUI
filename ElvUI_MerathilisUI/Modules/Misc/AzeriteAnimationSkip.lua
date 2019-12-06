local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("AzeriteSkip", "AceHook-3.0", "AceEvent-3.0")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local C_AzeriteEmpoweredItem_HasBeenViewed = C_AzeriteEmpoweredItem.HasBeenViewed
local C_AzeriteEmpoweredItem_SetHasBeenViewed = C_AzeriteEmpoweredItem.SetHasBeenViewed
local C_Timer_After = C_Timer.After
local GetItemInfoFromHyperlink = GetItemInfoFromHyperlink
local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemID = GetContainerItemID
local IsAddOnLoaded = IsAddOnLoaded
local UIParentLoadAddOn = UIParentLoadAddOn
-- Credits: Permok - Skip Azerite Animations: https://wago.io/HkUtqi7QQ

function module.OnItemSet(self)
	local itemLocation = self.azeriteItemDataSource:GetItemLocation()
	if self:IsAnyTierRevealing() then
		C_Timer_After(0.7, function()
			OpenAzeriteEmpoweredItemUIFromItemLocation(itemLocation)
		end)
	end
end

function module:ADDON_LOADED(event, name)
	if name == "Blizzard_AzeriteUI" then
		self:SecureHook(AzeriteEmpoweredItemUI, "OnItemSet", module.OnItemSet)
		self:UnregisterEvent("ADDON_LOADED")
	end
end

function module:AZERITE_EMPOWERED_ITEM_LOOTED(event, item)
	local itemId = GetItemInfoFromHyperlink(item)
	local bag, slot

	C_Timer_After(0.4, function()
		for i = 0, _G.NUM_BAG_SLOTS do
			for j = 1, GetContainerNumSlots(i) do
				local id = GetContainerItemID(i, j)
				if id and id == itemId then
					slot = j
					bag = i
				end
			end
		end

		if slot then
			local location = ItemLocation:CreateFromBagAndSlot(bag, slot)

			C_AzeriteEmpoweredItem_SetHasBeenViewed(location)
			C_AzeriteEmpoweredItem_HasBeenViewed(location)
		end
	end)
end

function module:AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED(event, itemLocation)
	OpenAzeriteEmpoweredItemUIFromItemLocation(itemLocation)
end

function module:Initialize()
	if E.db.mui.misc.skipAzerite ~= true then return end

	if not IsAddOnLoaded("Blizzard_AzeriteUI") then
		self:RegisterEvent("ADDON_LOADED")
		UIParentLoadAddOn("Blizzard_AzeriteUI")
	else
		self:SecureHook(AzeriteEmpoweredItemUI, "OnItemSet", module.OnItemSet)
	end

	self:RegisterEvent("AZERITE_EMPOWERED_ITEM_LOOTED")
	self:RegisterEvent("AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED")
end

MER:RegisterModule(module:GetName())
