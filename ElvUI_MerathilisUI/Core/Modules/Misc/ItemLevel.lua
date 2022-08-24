local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_ItemLevel')
local S = MER:GetModule('MER_Skins')
local B = E:GetModule("Bags")
local ES = E:GetModule("Skins")
local LSM = E.Libs.LSM

local _G = _G
local format = format
local pairs, select, type = pairs, select, type

local EquipmentManager_UnpackLocation = EquipmentManager_UnpackLocation
local Item = Item
local ItemLocation = ItemLocation
local IsAddOnLoaded = IsAddOnLoaded

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
	"Ranged",
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

function module:GetSlotAnchor(index)
	if not index then return end

	if index <= 5 or index == 9 or index == 15 then
		return "BOTTOMLEFT", 40, 20
	elseif index == 16 then
		return "BOTTOMRIGHT", -40, 2
	elseif index == 17 then
		return "BOTTOMLEFT", 40, 2
	else
		return "BOTTOMRIGHT", -40, 20
	end
end

function module:CreateItemTexture(slot, relF, x, y)
	local icon = slot:CreateTexture()
	icon:SetPoint(relF, x, y)
	icon:SetSize(14, 14)

	ES:HandleIcon(icon, true)
	icon.backdrop:SetFrameLevel(3)
	icon.backdrop:Hide()
	icon.bg = icon.backdrop

	return icon
end

function module:CreateItemString(frame, strType)
	if frame.fontCreated then return end

	for index, slot in pairs(inspectSlots) do
		--if index ~= 4 then	-- need color border for some shirts
			local slotFrame = _G[strType..slot.."Slot"]
			slotFrame.iLvlText = F.CreateText(slotFrame, "OVERLAY", 10)
			slotFrame.iLvlText:ClearAllPoints()
			slotFrame.iLvlText:SetPoint("BOTTOMRIGHT", slotFrame, "BOTTOMRIGHT", 0, -7)

			local relF, x = module:GetSlotAnchor(index)
			for i = 1, 5 do
				local offset = (i-1)*18 + 5
				local iconX = x > 0 and x+offset or x-offset
				local iconY = index > 15 and 20 or 2
				slotFrame["textureIcon"..i] = module:CreateItemTexture(slotFrame, relF, iconX, iconY)
			end
		--end
	end

	frame.fontCreated = true
end

local pending = {}

local gemSlotBlackList = {
	[16]=true, [17]=true, [18]=true,	-- ignore weapons, until I find a better way
}
function module:ItemLevel_UpdateGemInfo(link, unit, index, slotFrame)
	if not gemSlotBlackList[index] then
		local info = F.GetItemLevel(link, unit, index, true)
		if info then
			local gemStep = 1
			for i = 1, 5 do
				local texture = slotFrame["textureIcon" .. i]
				local bg = texture.bg
				local gem = info.gems and info.gems[gemStep]
				if gem then
					texture:SetTexture(gem)
					bg:SetBackdropBorderColor(0, 0, 0)
					bg:Show()

					gemStep = gemStep + 1
				end
			end
		end
	end
end

function module:RefreshButtonInfo()
	local unit = _G.InspectFrame and _G.InspectFrame.unit
	if unit then
		for index, slotFrame in pairs(pending) do
			local link = GetInventoryItemLink(unit, index)
			if link then
				local quality, level = select(3, GetItemInfo(link))
				if quality then
					local color = E.QualityColors[quality]
					if level and level > 1 and quality > 1 then
						slotFrame.iLvlText:SetText(level)
						slotFrame.iLvlText:SetTextColor(color.r, color.g, color.b)
					end
					module:ItemLevel_UpdateGemInfo(link, unit, index, slotFrame)
					module:UpdateInspectILvl()

					pending[index] = nil
				end
			end
		end

		if not next(pending) then
			self:Hide()
			return
		end
	else
		wipe(pending)
		self:Hide()
	end
end

function module:ItemLevel_SetupLevel(frame, strType, unit)
	if not UnitExists(unit) then return end

	module:CreateItemString(frame, strType)

	for index, slot in pairs(inspectSlots) do
		--if index ~= 4 then
			local slotFrame = _G[strType..slot.."Slot"]
			slotFrame.iLvlText:SetText("")
			for i = 1, 5 do
				local texture = slotFrame["textureIcon"..i]
				texture:SetTexture(nil)
				texture.backdrop:Hide()
			end

			local itemTexture = GetInventoryItemTexture(unit, index)
			if itemTexture then
				local link = GetInventoryItemLink(unit, index)
				if link then
					local quality, level = select(3, GetItemInfo(link))
					if quality then
						local color = E.QualityColors[quality]
						if level and level > 1 and quality > 1 then
							slotFrame.iLvlText:SetText(level)
							slotFrame.iLvlText:SetTextColor(color.r, color.g, color.b)
						end

						module:ItemLevel_UpdateGemInfo(link, unit, index, slotFrame)
					else
						pending[index] = slotFrame
						module.QualityUpdater:Show()
					end
				else
					pending[index] = slotFrame
					module.QualityUpdater:Show()
				end
			end
		--end
	end
end

local function GetItemSlotLevel(unit, index)
	local level
	local itemLink = GetInventoryItemLink(unit, index)
	if itemLink then
		level = select(4, GetItemInfo(itemLink))
	end
	return tonumber(level) or 0
end

local function GetILvlTextColor(level)
	if level >= 150 then
		return 1, .5, 0
	elseif level >= 115 then
		return .63, .2, .93
	elseif level >= 80 then
		return 0, .43, .87
	elseif level >= 45 then
		return .12, 1, 0
	else
		return 1, 1, 1
	end
end

function module:ItemLevel_UpdatePlayer()
	module:ItemLevel_SetupLevel(_G.CharacterFrame, "Character", "player")
end

function module:UpdateUnitILvl(unit, text)
	if not text then return end

	local total, level = 0
	for index = 1, 15 do
		if index ~= 4 then
			level = GetItemSlotLevel(unit, index)
			if level > 0 then
				total = total + level
			end
		end
	end

	local mainhand = GetItemSlotLevel(unit, 16)
	local offhand = GetItemSlotLevel(unit, 17)
	local ranged = GetItemSlotLevel(unit, 18)

	--[[
 		Note: We have to unify iLvl with others who use MerInspect,
		 although it seems incorrect for Hunter with two melee weapons.
	]]
	if mainhand > 0 and offhand > 0 then
		total = total + mainhand + offhand
	elseif offhand > 0 and ranged > 0 then
		total = total + offhand + ranged
	else
		total = total + max(mainhand, offhand, ranged) * 2
	end

	local average = E:Round(total/16, 1)
	text:SetText(average)
	text:SetTextColor(GetILvlTextColor(average))
end

function module:UpdateInspectILvl()
	if not module.InspectILvl then return end

	module:UpdateUnitILvl(_G.InspectFrame.unit, module.InspectILvl)
	module.InspectILvl:SetFormattedText("iLvl %s", module.InspectILvl:GetText())
end

local anchored
local function AnchorInspectRotate()
	if anchored then return end

	InspectModelFrameRotateRightButton:ClearAllPoints()
	InspectModelFrameRotateRightButton:SetPoint("BOTTOMLEFT", _G.InspectFrameTab1, "TOPLEFT", 0, 2)

	InspectModelFrameRotateLeftButton:ClearAllPoints()
	InspectModelFrameRotateLeftButton:SetPoint("LEFT", InspectModelFrameRotateRightButton, "RIGHT", 4, 0)

	module.InspectILvl = F.CreateText(_G.InspectPaperDollFrame, "OVERLAY", 15)
	module.InspectILvl:ClearAllPoints()
	module.InspectILvl:SetPoint("TOP", _G.InspectLevelText, "BOTTOM", 0, -4)

	anchored = true
end

function module:ItemLevel_UpdateInspect(...)
	local guid = ...
	if _G.InspectFrame and _G.InspectFrame.unit and UnitGUID(_G.InspectFrame.unit) == guid then
		AnchorInspectRotate()
		module:ItemLevel_SetupLevel(_G.InspectFrame, "Inspect", _G.InspectFrame.unit)
		module:UpdateInspectILvl()
	end
end

function module:ShowItemLevel()
	if not E.Wrath then return end

	-- iLvl on CharacterFrame
	CharacterFrame:HookScript("OnShow", module.ItemLevel_UpdatePlayer)
	MER:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", module.ItemLevel_UpdatePlayer)

	CharacterModelFrameRotateRightButton:ClearAllPoints()
	CharacterModelFrameRotateRightButton:SetPoint("BOTTOMLEFT", _G.CharacterFrameTab1, "TOPLEFT", 0, 2)

	CharacterModelFrameRotateLeftButton:ClearAllPoints()
	CharacterModelFrameRotateLeftButton:SetPoint("LEFT", CharacterModelFrameRotateRightButton, "RIGHT", 4, 0)

	-- iLvl on InspectFrame
	MER:RegisterEvent("INSPECT_READY", module.ItemLevel_UpdateInspect)

	-- Update item quality
	module.QualityUpdater = CreateFrame("Frame")
	module.QualityUpdater:Hide()
	module.QualityUpdater:SetScript("OnUpdate", module.RefreshButtonInfo)
end

function module:ProfileUpdate()
	self.db = E.db.mui.itemLevel

	self:ShowItemLevel()

	if self.db.enable and not self.initialized then
		self:SecureHook("EquipmentFlyout_UpdateItems", "FlyoutButton")
		if not IsAddOnLoaded("Blizzard_ScrappingMachineUI") then
			self:RegisterEvent("ADDON_LOADED")
		else
			self:HookScrappingMachine()
		end
		self.initialized = true
	end
end

module.Initialize = module.ProfileUpdate

MER:RegisterModule(module:GetName())
