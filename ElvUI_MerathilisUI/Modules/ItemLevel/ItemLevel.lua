local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_ItemLevel")
local C = W.Utilities.Color ---@type ColorUtility

local _G = _G
local select, tonumber = select, tonumber
local strmatch, gsub = strmatch, gsub

local hooksecurefunc = hooksecurefunc
local GetItemInfo = C_Item.GetItemInfo
local GetItemQuality = C_Item.GetItemQuality
local C_Item_GetDetailedItemLevelInfo = C_Item.GetDetailedItemLevelInfo
local GetContainerItemLink = C_Container.GetContainerItemLink
local GetInventoryItemLink = GetInventoryItemLink
local GetTradePlayerItemLink = GetTradePlayerItemLink
local GetTradeTargetItemLink = GetTradeTargetItemLink
local EquipmentManager_GetLocationData = EquipmentManager_GetLocationData
local EquipmentManager_GetItemInfoByLocation = EquipmentManager_GetItemInfoByLocation
local UnitExists = UnitExists

local EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION = EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION

local function EnsureItemLevelFont(button, size)
	if button.iLvl then
		return button.iLvl
	end

	local iLvl = button:CreateFontString(nil, "OVERLAY")
	iLvl:FontTemplate(nil, size or 11)
	iLvl:ClearAllPoints()
	iLvl:SetPoint("BOTTOMRIGHT", 0, 0)
	button.iLvl = iLvl
	return iLvl
end

local function ClearItemLevelFont(button)
	if button.iLvl then
		button.iLvl:SetText("")
	end
end

function module:ItemLevel_FlyoutUpdate(bag, slot, quality)
	-- Low / missing quality: clear and exit (do not leave stale text)
	if not quality or quality <= 1 then
		ClearItemLevelFont(self)
		return
	end

	local iLvl = EnsureItemLevelFont(self, 11)

	local link, level
	if bag then
		link = GetContainerItemLink(bag, slot)
		level = F.GetItemLevel(link, bag, slot)
	else
		link = GetInventoryItemLink("player", slot)
		level = F.GetItemLevel(link, "player", slot)
	end

	local color = E:GetQualityColor(quality)
	iLvl:SetText(level)
	iLvl:SetTextColor(color.r, color.g, color.b)
end

function module:ItemLevel_FlyoutSetup()
	ClearItemLevelFont(self)

	local location = self.location
	if not location then
		return
	end

	if tonumber(location) then
		if location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION then
			return
		end

		local locationData = EquipmentManager_GetLocationData(location)
		local quality = select(13, EquipmentManager_GetItemInfoByLocation(location))

		if locationData.isBags then
			module.ItemLevel_FlyoutUpdate(self, locationData.bag, locationData.slot, quality)
		else
			module.ItemLevel_FlyoutUpdate(self, nil, locationData.slot, quality)
		end
	else
		local itemLocation = self:GetItemLocation()
		if not itemLocation then
			return
		end

		local quality = GetItemQuality(itemLocation)
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
	if not self.itemLink then
		ClearItemLevelFont(self)
		return
	end

	local quality = 1
	if self.itemLocation and self.item and not self.item:IsItemEmpty() and self.item:GetItemName() then
		quality = self.item:GetItemQuality()
	end

	if quality <= 1 then
		ClearItemLevelFont(self)
		return
	end

	local iLvl = EnsureItemLevelFont(self, 11)
	local level = F.GetItemLevel(self.itemLink)
	local r, g, b = E:GetItemQualityColor(quality)
	iLvl:SetText(level)
	iLvl:SetTextColor(r, g, b)
end

function module:ItemLevel_ScrappingSetup()
	for button in self.ItemSlots.scrapButtons:EnumerateActive() do
		-- Hook once per button (flag, not dependent on iLvl existing)
		if button and not button._MERIlvlHooked then
			button._MERIlvlHooked = true
			hooksecurefunc(button, "RefreshIcon", module.ItemLevel_ScrappingUpdate)
		end
	end
end

function module.ItemLevel_ScrappingShow(event, addon)
	if addon == "Blizzard_ScrappingMachineUI" then
		hooksecurefunc(_G.ScrappingMachineFrame, "UpdateScrapButtonState", module.ItemLevel_ScrappingSetup)
		MER:UnregisterEvent(event, module.ItemLevel_ScrappingShow)
	end
end

function module:ItemLevel_UpdateMerchant(link)
	if not link then
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
		iLvl = EnsureItemLevelFont(itemButton, 11)
		-- Merchant uses font on ItemButton but stores on row frame for API compat
		self.iLvl = iLvl
	end

	local level = F.GetItemLevel(link)
	local color = E:GetQualityColor(quality)
	iLvl:SetText(level)
	iLvl:SetTextColor(color.r, color.g, color.b)
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

local guildNewsCache = {}

local function ItemLevel_ReplaceGuildNews(button, _, text, name, link, ...)
	local db = E.db.mui.itemLevel
	if not db or not db.guildNews or not db.guildNews.enable then
		return
	end

	local communities = _G.CommunitiesFrame
	if not communities or not communities:IsShown() then
		return
	end

	if not link or not strmatch(link, "|Hitem:") then
		return
	end

	local itemLevel = guildNewsCache[link]
	if not itemLevel then
		itemLevel = C_Item_GetDetailedItemLevelInfo(link)
		if itemLevel then
			guildNewsCache[link] = itemLevel
		end
	end

	if itemLevel then
		local coloredItemLevel = C.StringByTemplate(itemLevel, "yellow-400")
		link = gsub(link, "|h%[(.-)%]|h", "|h[" .. coloredItemLevel .. ":%1]|h")
		button.text:SetFormattedText(text, name, link, ...)
	end
end

function module:Initialize()
	local db = F.GetDBFromPath("mui.itemLevel") or E.db.mui.itemLevel
	self.db = db

	if not db or not db.enable then
		return
	end

	if self.initialized then
		return
	end

	-- FlyoutButtons
	hooksecurefunc("EquipmentFlyout_UpdateItems", function()
		local buttons = _G.EquipmentFlyoutFrame.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button:IsShown() then
				module.ItemLevel_FlyoutSetup(button)
			end
		end
	end)

	-- ScrappingMachine (lazy load)
	MER:RegisterEvent("ADDON_LOADED", module.ItemLevel_ScrappingShow)

	-- MerchantFrame + TradeFrame
	if db.merchantFrame and db.merchantFrame.enable then
		hooksecurefunc("MerchantFrameItem_UpdateQuality", module.ItemLevel_UpdateMerchant)
		hooksecurefunc("TradeFrame_UpdatePlayerItem", module.ItemLevel_UpdateTradePlayer)
		hooksecurefunc("TradeFrame_UpdateTargetItem", module.ItemLevel_UpdateTradeTarget)
	end

	-- GuildNews
	hooksecurefunc("GuildNewsButton_SetText", ItemLevel_ReplaceGuildNews)

	self.initialized = true
end

MER:RegisterModule(module:GetName())
