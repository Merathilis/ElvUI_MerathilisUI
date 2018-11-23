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
-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: BAG_ITEM_QUALITY_COLORS

function MI:ItemLevel()
	--ItemLevel on Scrapping Machine
	local function ScrappingMachineUpdate(self)
		if not self.iLvl then
			self.iLvl = MER:CreateText(self, "OVERLAY", 10)
			self.iLvl:SetPoint("BOTTOMRIGHT", 0, 2)
		end

		if not self.itemLink then self.iLvl:SetText("") return end

		local quality = 1
		if self.itemLocation and not self.item:IsItemEmpty() and self.item:GetItemName() then
			quality = self.item:GetItemQuality()
		end
		local level = MER:GetItemLevel(self.itemLink)
		local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
		self.iLvl:SetText(level)
		self.iLvl:SetTextColor(color.r, color.g, color.b)
	end

	local function ScrappingiLvL(event, addon)
		if addon == "Blizzard_ScrappingMachineUI" then
			for button in pairs(_G["ScrappingMachineFrame"].ItemSlots.scrapButtons.activeObjects) do
				hooksecurefunc(button, "RefreshIcon", ScrappingMachineUpdate)
			end

			MER:UnregisterEvent(event, ScrappingiLvL)
		end
	end
	MER:RegisterEvent("ADDON_LOADED", ScrappingiLvL)

	-- ItemLevel on Flyoutbuttons
	local function SetupFlyoutLevel(button, bag, slot, quality)
		if not button.iLvl then
			button.iLvl = MER:CreateText(button, "OVERLAY", 10)
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

		local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
		button.iLvl:SetText(level)
		button.iLvl:SetTextColor(color.r, color.g, color.b)
	end

	hooksecurefunc("EquipmentFlyout_DisplayButton", function(button)
		local location = button.location
		if not location or location < 0 then return end

		if location == EQUIPMENTFLYOUT_PLACEINBAGS_LOCATION then
			if button.iLvl then button.iLvl:SetText("") end
			return
		end

		local _, _, bags, voidStorage, slot, bag = EquipmentManager_UnpackLocation(location)
		if voidStorage then return end

		local quality = select(13, EquipmentManager_GetItemInfoByLocation(location))
		if bags then
			SetupFlyoutLevel(button, bag, slot, quality)
		else
			SetupFlyoutLevel(button, nil, slot, quality)
		end
	end)
end
