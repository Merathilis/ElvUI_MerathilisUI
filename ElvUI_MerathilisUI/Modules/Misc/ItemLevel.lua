local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule("mUIMisc")

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, select = pairs, select
-- WoW API / Variables
local hooksecurefunc = hooksecurefunc
local GetContainerItemLink = GetContainerItemLink
local GetInventoryItemLink = GetInventoryItemLink
local ITEM_QUALITY_COLORS = ITEM_QUALITY_COLORS
-- GLOBALS: BAG_ITEM_QUALITY_COLORS

-- ItemLevel on Flyoutbuttons
local function UpdateFlyoutLevel(button, bag, slot, quality)
	if not button.iLvl then
		button.iLvl = MER:CreateText(button, "OVERLAY", E.db.general.fontSize or 11, E.db.general.fontStyle or "OUTLINE")
		button.iLvl:SetPoint("BOTTOMRIGHT", 0, 2)
	end

	local link, level
	if bag then
		link = GetContainerItemLink(bag, slot)
		level = MER:GetItemLevel(link, bag, slot)
	else
		link = GetInventoryItemLink("player", slot)
		level = MER:GetItemLevel(link, "player", slot)
	end

	local color = ITEM_QUALITY_COLORS[quality or 1]
	button.iLvl:SetText(level)
	if color then
		button.iLvl:SetTextColor(color.r, color.g, color.b)
	end
end

local function SetupFlyoutLevel(self)
	local location = self.location
	if not location or location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION then
		if self.iLvl then self.iLvl:SetText("") end
		return
	end

	local _, _, bags, voidStorage, slot, bag = EquipmentManager_UnpackLocation(location)
	if voidStorage then return end
	local quality = select(13, EquipmentManager_GetItemInfoByLocation(location))
	if bags then
		UpdateFlyoutLevel(self, bag, slot, quality)
	else
		UpdateFlyoutLevel(self, nil, slot, quality)
	end
end

local function ScrappingMachineUpdate(self)
	if not self.iLvl then
		self.iLvl = MER:CreateText(self, "OVERLAY", E.db.general.fontSize or 11, E.db.general.fontStyle or "OUTLINE")
		self.iLvl:SetPoint("BOTTOMRIGHT", 0, 2)
	end

	if not self.itemLink then self.iLvl:SetText("") return end

	local quality = 1
	if self.itemLocation and not self.item:IsItemEmpty() and self.item:GetItemName() then
		quality = self.item:GetItemQuality()
	end

	local level = MER:GetItemLevel(self.itemLink)
	local color = ITEM_QUALITY_COLORS[quality or 1]
	self.iLvl:SetText(level)
	if color then
		self.iLvl:SetTextColor(color.r, color.g, color.b)
	end
end

local function ScrappingiLvL(event, addon)
	if addon == "Blizzard_ScrappingMachineUI" then
		for button in pairs(_G["ScrappingMachineFrame"].ItemSlots.scrapButtons.activeObjects) do
			hooksecurefunc(button, "RefreshIcon", ScrappingMachineUpdate)
		end

		MER:UnregisterEvent(event, ScrappingiLvL)
	end
end

function MI:ItemLevel()
	-- iLvl on FlyoutButtons
	hooksecurefunc("EquipmentFlyout_DisplayButton", SetupFlyoutLevel)

	--ItemLevel on Scrapping Machine
	MER:RegisterEvent("ADDON_LOADED", ScrappingiLvL)
end
