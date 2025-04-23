local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_ItemLevel")
local S = MER:GetModule("MER_Skins")

local _G = _G
local pairs, select = pairs, select

local EquipmentManager_UnpackLocation = EquipmentManager_UnpackLocation
local GetItemInfo = C_Item.GetItemInfo
local GetContainerItemLink = C_Container.GetContainerItemLink
local GetInventoryItemLink = GetInventoryItemLink

local EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION = EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION

local inspectSlots = {
	"Head",
	"Neck",
	"Shoulder",
	"Shirt",
	"Chest",
	"Waist",
	"Legs",
	"Feet",
	"Wrist",
	"Hands",
	"Finger0",
	"Finger1",
	"Trinket0",
	"Trinket1",
	"Back",
	"MainHand",
	"SecondaryHand",
}

function module:ItemLevel_FlyoutUpdate(bag, slot, quality)
	if not self.iLvl then
		self.iLvl = self:CreateFontString(nil, "OVERLAY")
		self.iLvl:FontTemplate(nil, 11)
		self.iLvl:ClearAllPoints()
		self.iLvl:SetPoint("BOTTOMRIGHT", 0, 0)
	end

	if quality and quality <= 1 then
		return
	end

	local link, level
	if bag then
		link = GetContainerItemLink(bag, slot)
		level = F.GetItemLevel(link, bag, slot)
	else
		link = GetInventoryItemLink("player", slot)
		level = F.GetItemLevel(link, "player", slot)
	end

	local color = E:GetItemQualityColor(quality or 0)
	self.iLvl:SetText(level)
	self.iLvl:SetTextColor(color.r, color.g, color.b)
end

function module:ItemLevel_FlyoutSetup()
	if self.iLvl then
		self.iLvl:SetText("")
	end

	local location = self.location
	if not location then
		return
	end

	if tonumber(location) then
		if location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION then
			return
		end

		local _, _, bags, voidStorage, slot, bag = EquipmentManager_UnpackLocation(location)
		if voidStorage then
			return
		end
		local quality = select(13, EquipmentManager_GetItemInfoByLocation(location))
		if bags then
			module.ItemLevel_FlyoutUpdate(self, bag, slot, quality)
		else
			module.ItemLevel_FlyoutUpdate(self, nil, slot, quality)
		end
	else
		local itemLocation = self:GetItemLocation()
		local quality = itemLocation and C_Item.GetItemQuality(itemLocation)
		if itemLocation:IsBagAndSlot() then
			local bag, slot = itemLocation:GetBagAndSlot()
			module.ItemLevel_FlyoutUpdate(self, bag, slot, quality)
		elseif itemLocation:IsEquipmentSlot() then
			local slot = itemLocation:GetEquipmentSlot()
			module.ItemLevel_FlyoutUpdate(self, nil, slot, quality)
		end
	end
end

function module:ItemLevel_ScrappingUpdate()
	if not self.iLvl then
		self.iLvl = self:CreateFontString(nil, "OVERLAY")
		self.iLvl:FontTemplate(nil, 11)
		self.iLvl:ClearAllPoints()
		self.iLvl:SetPoint("BOTTOMRIGHT", 0, 0)
	end
	if not self.itemLink then
		self.iLvl:SetText("")
		return
	end

	local quality = 1
	if self.itemLocation and not self.item:IsItemEmpty() and self.item:GetItemName() then
		quality = self.item:GetItemQuality()
	end
	local level = F.GetItemLevel(self.itemLink)
	local color = E:GetItemQualityColor(quality)
	self.iLvl:SetText(level)
	self.iLvl:SetTextColor(color.r, color.g, color.b)
end

function module:ItemLevel_ScrappingSetup()
	for button in self.ItemSlots.scrapButtons:EnumerateActive() do
		if button and not button.iLvl then
			hooksecurefunc(button, "RefreshIcon", module.ItemLevel_ScrappingUpdate)
		end
	end
end

function module.ItemLevel_ScrappingShow(event, addon)
	if addon == "Blizzard_ScrappingMachineUI" then
		hooksecurefunc(ScrappingMachineFrame, "UpdateScrapButtonState", module.ItemLevel_ScrappingSetup)

		MER:UnregisterEvent(event, module.ItemLevel_ScrappingShow)
	end
end

function module:CreateItemTexture(slot, relF, x, y)
	local icon = slot:CreateTexture()
	icon:SetPoint(relF, x, y)
	icon:SetSize(14, 14)
	icon:SetTexCoord(unpack(E.TexCoords))

	icon.bg = S:CreateBDFrame(icon, 25)
	icon.bg:SetFrameLevel(3)
	icon.bg:Hide()
	return icon
end

function module:CreateItemString(frame, strType)
	if frame.fontCreated then
		return
	end

	for index, slot in pairs(inspectSlots) do
		if index ~= 4 then
			local slotFrame = _G[strType .. slot .. "Slot"]
			slotFrame.iLvlText = slotFrame:CreateFontString(nil, "OVERLAY")
			slotFrame.iLvlText:FontTemplate(nil, 10)
			slotFrame.iLvlText:ClearAllPoints()
			slotFrame.iLvlText:SetPoint("BOTTOMRIGHT", slotFrame, "BOTTOMRIGHT", 0, 0)
		end
	end

	frame.fontCreated = true
end

function module:ItemLevel_SetupLevel(frame, strType, unit)
	if not UnitExists(unit) then
		return
	end

	module:CreateItemString(frame, strType)

	for index, slot in pairs(inspectSlots) do
		if index ~= 4 then
			local slotFrame = _G[strType .. slot .. "Slot"]
			slotFrame.iLvlText:SetText("")
		end
	end
end

function module:ItemLevel_UpdateMerchant(link)
	if not self.iLvl then
		self.iLvl = _G[self:GetName() .. "ItemButton"]:CreateFontString(nil, "OVERLAY")
		self.iLvl:FontTemplate(nil, 11)
		self.iLvl:ClearAllPoints()
		self.iLvl:SetPoint("BOTTOMRIGHT", 0, 0)
	end

	local quality = link and select(3, GetItemInfo(link)) or nil
	if quality and quality > 1 then
		local level = F.GetItemLevel(link)
		local color = E:GetQualityColor(quality)
		self.iLvl:SetText(level)
		self.iLvl:SetTextColor(color.r, color.g, color.b)
	else
		self.iLvl:SetText("")
	end
end

function module.ItemLevel_UpdateTradePlayer(index)
	local button = _G["TradePlayerItem" .. index]
	local link = GetTradePlayerItemLink(index)
	module.ItemLevel_UpdateMerchant(button, link)
end

function module.ItemLevel_UpdateTradeTarget(index)
	local button = _G["TradeRecipientItem" .. index]
	local link = GetTradeTargetItemLink(index)
	module.ItemLevel_UpdateMerchant(button, link)
end

local cache = {}
local function ItemLevel_ReplaceGuildNews(button, _, text, name, link, ...)
	if not E.db.mui.itemLevel.guildNews.enable then
		return
	end

	if not _G.CommunitiesFrame or not _G.CommunitiesFrame.IsShown or not _G.CommunitiesFrame:IsShown() then
		return
	end

	if not link or not strmatch(link, "|H(item:%d+:.-)|h.-|h") then
		return
	end

	if not cache[link] then
		cache[link] = F.GetRealItemLevelByLink(link)
	end

	if cache[link] then
		local coloredItemLevel = format("|cfff1c40f%s|r", cache[link])
		link = gsub(link, "|h%[(.-)%]|h", "|h[" .. coloredItemLevel .. ":%1]|h")
		button.text:SetFormattedText(text, name, link, ...)
	end
end

function module:Initialize()
	self.db = E.db.mui.itemLevel

	if not self.db.enable and not self.initialized then
		return
	end

	-- FlyoutButtons
	hooksecurefunc("EquipmentFlyout_UpdateItems", function()
		for _, button in pairs(_G.EquipmentFlyoutFrame.buttons) do
			if button:IsShown() then
				module.ItemLevel_FlyoutSetup(button)
			end
		end
	end)

	-- ScrappingMachine
	MER:RegisterEvent("ADDON_LOADED", module.ItemLevel_ScrappingShow)

	-- MerchantFrame
	if self.db.merchantFrame.enable then
		hooksecurefunc("MerchantFrameItem_UpdateQuality", module.ItemLevel_UpdateMerchant)

		-- TradeFrame
		hooksecurefunc("TradeFrame_UpdatePlayerItem", module.ItemLevel_UpdateTradePlayer)
		hooksecurefunc("TradeFrame_UpdateTargetItem", module.ItemLevel_UpdateTradeTarget)
	end

	-- GuildNews
	hooksecurefunc("GuildNewsButton_SetText", ItemLevel_ReplaceGuildNews)

	self.initialized = true
end

MER:RegisterModule(module:GetName())
