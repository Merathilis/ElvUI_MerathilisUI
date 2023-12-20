local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_ItemLevel')
local S = MER:GetModule('MER_Skins')
local B = E:GetModule("Bags")
local LSM = E.Libs.LSM

local _G = _G
local pairs, select, type = pairs, select, type

local EquipmentManager_UnpackLocation = EquipmentManager_UnpackLocation
local Item = Item
local ItemLocation = ItemLocation
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local C_Item_DoesItemExist = C_Item.DoesItemExist

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

local function UpdateFlyoutItemLevelTextStyle(text, db)
	if db.useBagsFontSetting then
		text:FontTemplate(LSM:Fetch("font", B.db.itemLevelFont), B.db.itemLevelFontSize, B.db.itemLevelFontOutline)
		text:ClearAllPoints()
		text:Point(B.db.itemLevelPosition, B.db.itemLevelxOffset, B.db.itemLevelyOffset)
	else
		F.SetFontDB(text, db.font)
		text:ClearAllPoints()
		text:Point("BOTTOMRIGHT", db.font.xOffset, db.font.yOffset)
	end
end

local function RefreshItemLevel(text, db, location)
	if not text or not C_Item_DoesItemExist(location) then
		return
	end

	UpdateFlyoutItemLevelTextStyle(text, db)

	local item = Item:CreateFromItemLocation(location)
	item:ContinueOnItemLoad(function()
		text:SetText(item:GetCurrentItemLevel())
		F.SetFontColorDB(text, db.qualityColor and item:GetItemQualityColor() or db.font.color)
	end)
end

function module:FlyoutButton(button)
	local flyout = _G.EquipmentFlyoutFrame
	local buttons = flyout.buttons
	local flyoutSettings = flyout.button:GetParent().flyoutSettings

	if not self.db.enable or not self.db.flyout.enable then
		if buttons then
			for _, button in pairs(buttons) do
				if button.itemLevel then
					button.itemLevel:SetText("")
				end
			end
		end
		return
	end

	for _, button in pairs(buttons) do
		if not button.itemLevel then
			button.itemLevel = button:CreateFontString(nil, "ARTWORK", nil, 1)
			UpdateFlyoutItemLevelTextStyle(button.itemLevel, self.db.flyout)
		end

		local itemLocation

		if flyoutSettings.useItemLocation then
			itemLocation = button.itemLocation
		elseif
			button.location and type(button.location) == "number" and
			not (button.location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION)
		then
			local bags, voidStorage, slot, bag = select(3, EquipmentManager_UnpackLocation(button.location))
			if not voidStorage then
				if bags then
					itemLocation = ItemLocation:CreateFromBagAndSlot(bag, slot)
				else
					itemLocation = ItemLocation:CreateFromEquipmentSlot(slot)
				end
			end
		end

		if itemLocation then
			RefreshItemLevel(button.itemLevel, self.db.flyout, itemLocation)
		else
			button.itemLevel:SetText("")
		end
	end
end

function module:ScrappingMachineButton(button)
	if not self.db.enable or not self.db.scrappingMachine.enable or not button.itemLocation then
		if button.itemLevel then
			button.itemLevel:SetText("")
		end
		return
	end

	if not button.itemLevel then
		button.itemLevel = button:CreateFontString(nil, "ARTWORK", nil, 1)
	end

	RefreshItemLevel(button.itemLevel, self.db.scrappingMachine, button.itemLocation)
end

function module:ADDON_LOADED(_, addon)
	if addon == "Blizzard_ScrappingMachineUI" then
		self:UnregisterEvent("ADDON_LOADED")
		self:HookScrappingMachine()
	end
end

function module:HookScrappingMachine()
	if _G.ScrappingMachineFrame then
		for button in pairs(_G.ScrappingMachineFrame.ItemSlots.scrapButtons.activeObjects) do
			self:SecureHook(button, "RefreshIcon", "ScrappingMachineButton")
		end
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
	if frame.fontCreated then return end

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
	if not UnitExists(unit) then return end

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
		self.iLvl:FontTemplate(nil, 10)
		self.iLvl:ClearAllPoints()
		self.iLvl:SetPoint("BOTTOMRIGHT", 0, 0)
	end

	local quality = link and select(3, GetItemInfo(link)) or nil
	if quality and quality > 1 then
		local level = F.GetItemLevel(link)
		local color = E.QualityColors[quality]
		self.iLvl:SetText(level)
		self.iLvl:SetTextColor(color.r, color.g, color.b)
	else
		self.iLvl:SetText("")
	end
end

function module.ItemLevel_UpdateTradePlayer(index)
	local button = _G["TradePlayerItem"..index]
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
	self:SecureHook("EquipmentFlyout_UpdateItems", "FlyoutButton")

	-- ScrappingMachine
	if not IsAddOnLoaded("Blizzard_ScrappingMachineUI") then
		self:RegisterEvent("ADDON_LOADED")
	else
		self:HookScrappingMachine()
	end

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
