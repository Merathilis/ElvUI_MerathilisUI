local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
--WoW API / Variables
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or E.private.muiSkins.blizzard.character ~= true then return end

	local EquipmentFlyoutFrame = _G.EquipmentFlyoutFrame
	_G.EquipmentFlyoutFrameHighlight:Hide()

	local navFrame = EquipmentFlyoutFrame.NavigationFrame
	navFrame:SetWidth(204)
	navFrame:SetPoint("TOPLEFT", _G.EquipmentFlyoutFrameButtons, "BOTTOMLEFT", 1, 0)

	hooksecurefunc("EquipmentFlyout_CreateButton", function()
		local button = EquipmentFlyoutFrame.buttons[#EquipmentFlyoutFrame.buttons]

		if not button.Eye then
			button.Eye = button:CreateTexture()
			button.Eye:SetAtlas("Nzoth-inventory-icon")
			button.Eye:SetInside()
		end
	end)

	local function UpdateCorruption(button, location)
		local _, _, bags, voidStorage, slot, bag = EquipmentManager_UnpackLocation(location)
		if voidStorage then
			button.Eye:Hide()
			return
		end

		local itemLink
		if bags then
			itemLink = GetContainerItemLink(bag, slot)
		else
			itemLink = GetInventoryItemLink("player", slot)
		end
		button.Eye:SetShown(itemLink and IsCorruptedItem(itemLink))
	end

	hooksecurefunc("EquipmentFlyout_DisplayButton", function(button)
		local location = button.location
		local border = button.IconBorder
		if not location or not border then return end

		if location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION then
			border:Hide()
		else
			border:Show()
		end

		UpdateCorruption(button, location)
	end)
end

S:AddCallback("mUIEquipmentFlyout", LoadSkin)
