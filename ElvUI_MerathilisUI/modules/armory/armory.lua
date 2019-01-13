local MER, E, L, V, P, G = unpack(select(2, ...))
local MERAY = MER:NewModule('MERArmory', 'AceEvent-3.0', 'AceTimer-3.0', 'AceHook-3.0')
local LCG = LibStub('LibCustomGlow-1.0')
local LSM = E.LSM or E.Libs.LSM
MERAY.modName = L["Armory"]

-- Cache global variables
-- Lua functions
local _G = _G
local select, tonumber, unpack = select, tonumber, unpack
local type = type
local gsub = gsub
local strmatch, strsplit = strmatch, strsplit
local find = string.find
local pairs = pairs
local max = math.max
-- WoW API / Variables
local CreateFrame = CreateFrame
local GetAverageItemLevel = GetAverageItemLevel
local GetInventoryItemLink = GetInventoryItemLink
local GetInventoryItemDurability = GetInventoryItemDurability
local GetInventorySlotInfo = GetInventorySlotInfo
local GetInventoryItemQuality = GetInventoryItemQuality
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local GetItemGem = GetItemGem
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local hooksecurefunc = hooksecurefunc
local UnitLevel = UnitLevel
--GLOBALS:

local HasAnyUnselectedPowers = C_AzeriteEmpoweredItem.HasAnyUnselectedPowers

local initialized = false
local updateTimer

local socketsTable = { -- These bonusIDs should be sockets
	-- /dump string.split(":", GetInventoryItemLink("player", i))
	-- /dump string.split(":", GetInventoryItemLink("target", 17))
	[3] = true,
	-- WoD ?
	[497] = true,
	[523] = true,
	[563] = true,
	[564] = true,
	[565] = true,
	[572] = true,
	[608] = true,
	[715] = true,
	[716] = true,
	[717] = true,
	[718] = true,
	[719] = true,
	[721] = true,
	[722] = true,
	[723] = true,
	[724] = true,
	[725] = true,
	[726] = true,
	[727] = true,
	[728] = true,
	[729] = true,
	[730] = true,
	[731] = true,
	[732] = true,
	[733] = true,
	[734] = true,
	[735] = true,
	[736] = true,
	[737] = true,
	[738] = true,
	[739] = true,
	[740] = true,
	[741] = true,
	[742] = true,
	[743] = true,
	[744] = true,
	[745] = true,
	[746] = true,
	[747] = true,
	[748] = true,
	[749] = true,
	[750] = true,
	[751] = true,
	[752] = true,
	-- Legion ?
	[1808] = true,
	[3475] = true,
	[3522] = true,
	[4231] = true,
	[4802] = true,

	[3386] = true, -- Vendor stuff?
	[3458] = true, -- Legendary
	[3459] = true, -- 132410
	[3630] = true, -- 152626
	-- BfA ?
	[3364] = true, -- ???
	[3366] = true, -- ???
	[3372] = true,
	--[4926] = true,
	--[4927] = true,
	--[4928] = true,
}

local slots = {
	["HeadSlot"] = { true, true },
	["NeckSlot"] = { true, false },
	["ShoulderSlot"] = { true, true },
	["BackSlot"] = { true, false },
	["ChestSlot"] = { true, true },
	["WristSlot"] = { true, true },
	["MainHandSlot"] = { true, true },
	["SecondaryHandSlot"] = { true, true },
	["HandsSlot"] = { true, true },
	["WaistSlot"] = { true, true },
	["LegsSlot"] = { true, true },
	["FeetSlot"] = { true, true },
	["Finger0Slot"] = { true, false },
	["Finger1Slot"] = { true, false },
	["Trinket0Slot"] = { true, false },
	["Trinket1Slot"] = { true, false },
}

local slotIDs = {
	[1] = "HeadSlot",
	[2] = "NeckSlot",
	[3] = "ShoulderSlot",
	[5] = "ChestSlot",
	[6] = "WaistSlot",
	[7] = "LegsSlot",
	[8] = "FeetSlot",
	[9] = "WristSlot",
	[10] = "HandsSlot",
	[11] = "Finger0Slot",
	[12] = "Finger1Slot",
	[13] = "Trinket0Slot",
	[14] = "Trinket1Slot",
	[15] = "BackSlot",
	[16] = "MainHandSlot",
	[17] = "SecondaryHandSlot"
}

local gearList = {
	-- Used for Slot Gradient
	-- Dont add Weapon slots here.
	'HeadSlot',
	'HandsSlot',
	'NeckSlot',
	'WaistSlot',
	'ShoulderSlot',
	'LegsSlot',
	'BackSlot',
	'FeetSlot',
	'ChestSlot',
	'Finger0Slot',
	'ShirtSlot',
	'Finger1Slot',
	'TabardSlot',
	'Trinket0Slot',
	'WristSlot',
	'Trinket1Slot',
	}

local AZSlots = {
	"Head", "Shoulder", "Chest",
}

local levelColors = {
	[0] = "|cffff0000",
	[1] = "|cff00ff00",
	[2] = "|cffffff88",
}

-- From http://www.wowhead.com/items?filter=qu=7;sl=16:18:5:8:11:10:1:23:7:21:2:22:13:24:15:28:14:4:3:19:25:12:17:6:9;minle=1;maxle=1;cr=166;crs=3;crv=0
local heirlooms = {
	[80] = {
		44102,42944,44096,42943,42950,48677,42946,42948,42947,42992,
		50255,44103,44107,44095,44098,44097,44105,42951,48683,48685,
		42949,48687,42984,44100,44101,44092,48718,44091,42952,48689,
		44099,42991,42985,48691,44094,44093,42945,48716
	},
	["90h"] = {105689,105683,105686,105687,105688,105685,105690,105691,105684,105692,105693},
	["90n"] = {104399,104400,104401,104402,104403,104404,104405,104406,104407,104408,104409},
	["90f"] = {105675,105670,105672,105671,105674,105673,105676,105677,105678,105679,105680},
}

function MERAY:OnEnter()
	if self.Link and self.Link ~= '' then
		_G["GameTooltip"]:SetOwner(self, 'ANCHOR_RIGHT')

		self:SetScript('OnUpdate', function()
			_G["GameTooltip"]:ClearLines()
			_G["GameTooltip"]:SetHyperlink(self.Link)

			_G["GameTooltip"]:Show()
		end)
	end
end

function MERAY:OnLeave()
	self:SetScript('OnUpdate', nil)
	_G["GameTooltip"]:Hide()
end

function MERAY:UpdatePaperDoll()
	if not E.db.mui.armory.enable then return end

	local unit = "player"
	if not unit then return end

	local frame, slot, current, maximum, r, g, b
	local itemLink, itemLevel, itemLevelMax, enchantInfo
	local _, numBonuses, affixes
	local avgItemLevel, avgEquipItemLevel = GetAverageItemLevel()

	for k, _ in pairs(slots) do
		frame = _G[("Character")..k]

		slot = GetInventorySlotInfo(k)
		if slot and slot ~= '' then
			-- Reset Data first
			frame.ItemLevel:SetText("")
			frame.EnchantInfo:SetText("")
			frame.SocketHolder:Hide()
			frame.SocketHolder.Link = nil

			itemLink = GetInventoryItemLink(unit, slot)
			if (itemLink and itemLink ~= nil) then
				if type(itemLink) ~= "string" then return end
				_, _, _, _, _, _, _, _, _, _, _, _, _, numBonuses, affixes = strsplit(":", itemLink, 15)
				numBonuses = tonumber(numBonuses) or 0

				local _, _, itemRarity, _, _, _, _, _, itemEquipLoc = GetItemInfo(itemLink)
				if MERAY.db.ilvl.enable then
					-- Item Level
					if ((slot == 16 or slot == 17) and GetInventoryItemQuality(unit, slot) == LE_ITEM_QUALITY_ARTIFACT) then
						local itemLevelMainHand = 0
						local itemLevelOffHand = 0
						local itemLinkMainHand = GetInventoryItemLink(unit, 16)
						local itemLinkOffhand = GetInventoryItemLink(unit, 17)
						if itemLinkMainHand then itemLevelMainHand = self:GetItemLevel(unit, itemLinkMainHand or 0) end
						if itemLinkOffhand then itemLevelOffHand = self:GetItemLevel(unit, itemLinkOffhand or 0) end
						itemLevel = max(itemLevelMainHand or 0, itemLevelOffHand or 0)
					else
						itemLevel = self:GetItemLevel(unit, itemLink)
					end
					if itemLevel and avgEquipItemLevel then
						frame.ItemLevel:SetText(itemLevel)
					end
					if itemRarity and MERAY.db.ilvl.colorStyle == "RARITY" then
						local r, g, b = GetItemQualityColor(itemRarity)
						frame.ItemLevel:SetTextColor(r, g, b)
					elseif MERAY.db.ilvl.colorStyle == "LEVEL" then
						frame.ItemLevel:SetFormattedText("%s%d|r", levelColors[(itemLevel < avgEquipItemLevel-10 and 0 or (itemLevel > avgEquipItemLevel + 10 and 1 or (2)))], itemLevel)
					else
						frame.ItemLevel:SetTextColor(MER:unpackColor(MERAY.db.ilvl.color))
					end
				end

				-- Enchants
				if MERAY.db.enchantInfo then
					enchantInfo = self:GetEnchants(itemLink)
					if enchantInfo then
						if (slot == 11 or slot == 12 or slot == 16 or (slot == 17 and itemEquipLoc ~= 'INVTYPE_SHIELD' and itemEquipLoc ~= 'INVTYPE_HOLDABLE')) then
							frame.EnchantInfo:SetText(enchantInfo)
						end
					end
				end

				-- Gems
				if MERAY.db.socketInfo then
					if numBonuses and numBonuses > 0 then
						for b = 1, numBonuses do
							local bonusID = select(b, strsplit(":", affixes))
							if socketsTable[tonumber(bonusID)] then
								local _, gemLink = GetItemGem(itemLink, 1)
								if gemLink and gemLink ~= "" then
									local _, _, _, _, _, _, _, _, _, t = GetItemInfo(gemLink)
									if t and t > 0 then -- has a socket in the item
										frame.SocketHolder:Show()
										frame.SocketHolder.Texture:SetTexture(t)
										frame.SocketHolder.Link = gemLink
									end
								else -- has an empty socket
									frame.SocketHolder:Show()
									frame.SocketHolder:SetBackdropColor(255, 0, 0, 1)
								end
							end
						end
					end
				end

				-- Durability
				if MERAY.db.durability.enable then
					frame.DurabilityInfo:SetText()
					current, maximum = GetInventoryItemDurability(slot)
					if current and maximum and (not MERAY.db.durability.onlydamaged or current < maximum) then
						r, g, b = E:ColorGradient((current / maximum), 1, 0, 0, 1, 1, 0, 0, 1, 0)
						frame.DurabilityInfo:SetFormattedText("%s%.0f%%|r", E:RGBToHex(r, g, b), (current / maximum) * 100)
					end
				end
			end
		end
	end
end

-- from http://www.wowinterface.com/forums/showthread.php?p=284771 by PhanX
-- Construct your search pattern based on the existing global string:
-- local S_UPGRADE_LEVEL   = "^" .. gsub(ITEM_UPGRADE_TOOLTIP_FORMAT, "%%d", "(%%d+)")
local S_ITEM_LEVEL      = "^" .. gsub(ITEM_LEVEL, "%%d", "(%%d+)")

-- Create the tooltip:
local scantip = CreateFrame("GameTooltip", "MyScanningTooltip", nil, "GameTooltipTemplate")
scantip:SetOwner(UIParent, "ANCHOR_NONE")
scantip:ClearLines()

local function GetRealItemLevel(itemLink)
	-- Pass the item link to the tooltip
	scantip:SetHyperlink(itemLink)

	-- Scan the tooltip:
	for i = 2, scantip:NumLines() do -- Line 1 is always the name so you can skip it.
		local text = _G["MyScanningTooltipTextLeft"..i]:GetText()
		if text and text ~= "" then
			local currentLevel = strmatch(text, S_ITEM_LEVEL)
			if currentLevel then
				return currentLevel
			end
		end
	end
end

function MERAY:GetItemLevel(unit, itemLink)
	local rarity, itemLevel = select(3, GetItemInfo(itemLink))
	if rarity == 7 then -- heirloom adjust
		itemLevel = self:HeirLoomLevel(unit, itemLink)
	end

	itemLevel = GetRealItemLevel(itemLink)
	itemLevel = tonumber(itemLevel)
	return itemLevel
end

-- Check missing enchants
local function CheckEnchants(itemLink)
	-- Pass the item link to the tooltip
	scantip:SetHyperlink(itemLink)

	for i = 1, scantip:NumLines() do
		local enchant = _G["MyScanningTooltipTextLeft"..i]:GetText():match(ENCHANTED_TOOLTIP_LINE:gsub("%%s", "(.+)"))
		if enchant then
			return enchant
		end
	end
end

function MERAY:GetEnchants(itemLink)
	local enchantInfo = CheckEnchants(itemLink)

	if enchantInfo then
		enchantInfo = "|cff00ff00E|r"
	else
		enchantInfo = "|cffff0000E|r"
	end

	return enchantInfo
end

--[[heirloom ilvl equivalents
Vanilla: 1-60 = 60 / 60 = scales by 1 ilvl per player level
TBC rares: 85-115 = 30 / 10 = scales by 3 ilvl per player level
WLK rares: 130-190(200) = 60 / 10 = scales by 6 ilvl per player level
CAT rares: 272-333 = 61 / 5 = scales by 12.2 ilvl per player level
MOP rares: 364-450 = 86 / 5 = scales by 17.2 ilvl per player level (guesswork)
]]

function MERAY:HeirLoomLevel(unit, itemLink)
	local level = UnitLevel(unit)

	if level > 85 then
		local _, _, _, _, itemId = find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
		itemId = tonumber(itemId)

		for _, id in pairs(heirlooms["90h"]) do
			if id == itemId then
				level = 582
				break
			end
		end

		for _, id in pairs(heirlooms["90n"]) do
			if id == itemId then
				level = 569
				break
			end
		end

		for _, id in pairs(heirlooms["90f"]) do
			if id == itemId then
				level = 548
				break
			end
		end
	elseif level > 80 then
		local _, _, _, _, itemId = find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
		itemId = tonumber(itemId)

		for _, id in pairs(heirlooms[80]) do
			if id == itemId then
				level = 80
				break
			end
		end
	end

	if level > 85 then
		return level
	elseif level > 80 then -- CAT heirloom scaling kicks in at 81
		return (( level - 81) * 12.2) + 272;
	elseif level > 67 then -- WLK heirloom scaling kicks in at 68
		return (( level - 68) * 6) + 130;
	elseif level > 59 then -- TBC heirloom scaling kicks in at 60
		return (( level - 60) * 3) + 85;
	else
		return level
	end
end

function MERAY:InitialUpdatePaperDoll()
	MERAY:UnregisterEvent("PLAYER_ENTERING_WORLD")

	self:BuildInformation()
	self:SlotGradiation()

	-- update player info
	self:ScheduleTimer("UpdatePaperDoll", 10)

	initialized = true
end

local function UpdateiLvLPoints(id)
	if id <= 5 or id == 15 or id == 9 then 			-- Left side
		return "BOTTOMLEFT", "BOTTOMLEFT", 1, 1
	elseif id <= 14 then 							-- Right side
		return "BOTTOMRIGHT", "BOTTOMRIGHT", 2, 1
	else											-- Weapon slots
		return "BOTTOM", "BOTTOM", 2, 1
	end
end

local function UpdateGemPoints(id)
	if id <= 5 or id == 15 or id == 9 then 		-- Left side
		return "LEFT", "RIGHT", 4, 0
	elseif id <= 14 then 						-- Right side
		return "RIGHT", "LEFT", -4, 0
	else										-- Weapon slots
		return "TOP", "TOP", 0, 16
	end
end

function MERAY:BuildInformation()
	for id, _ in pairs(slotIDs) do
		local frame = _G["Character"..slotIDs[id]]
		local iLvLPoint, iLvLParentPoint, x1, y1 = UpdateiLvLPoints(id)
		local GemPoint, GemparentPoint, x2, y2 = UpdateGemPoints(id)

		frame.ItemLevel = frame:CreateFontString(nil, "OVERLAY")
		frame.ItemLevel:SetPoint(iLvLPoint, frame, iLvLParentPoint, x1 or 0, y1 or 0)
		frame.ItemLevel:FontTemplate(LSM:Fetch("font", MERAY.db.ilvl.font), MERAY.db.ilvl.textSize, MERAY.db.ilvl.fontOutline)

		frame.DurabilityInfo = frame:CreateFontString(nil, "OVERLAY")
		frame.DurabilityInfo:SetPoint("TOP", frame, "TOP", 0, -2)
		frame.DurabilityInfo:FontTemplate(LSM:Fetch("font", MERAY.db.durability.font), MERAY.db.durability.textSize, MERAY.db.durability.fontOutline)

		frame.EnchantInfo = frame:CreateFontString(nil, "OVERLAY")
		frame.EnchantInfo:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 1, -1)
		frame.EnchantInfo:FontTemplate(LSM:Fetch("font", MERAY.db.durability.font), MERAY.db.durability.textSize, MERAY.db.durability.fontOutline)

		frame.SocketHolder = CreateFrame('Frame', nil, frame)
		frame.SocketHolder:Size(12)
		frame.SocketHolder:SetBackdrop({
			bgFile = E.media.blankTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = E.mult, right = E.mult, top = E.mult, bottom = E.mult }
		})
		frame.SocketHolder:SetBackdropBorderColor(0, 0, 0, 1)
		frame.SocketHolder:SetPoint(GemPoint, frame, GemparentPoint, x2 or 0, y2 or 0)
		frame.SocketHolder:SetScript('OnEnter', self.OnEnter)
		frame.SocketHolder:SetScript('OnLeave', self.OnLeave)

		frame.SocketHolder.Texture = frame.SocketHolder:CreateTexture(nil, 'OVERLAY')
		frame.SocketHolder.Texture:SetTexCoord(unpack(E.TexCoords))
		frame.SocketHolder.Texture:SetInside()
	end

	-- Azerite Neck
	_G["CharacterNeckSlot"].RankFrame:CreateFontString(nil, "OVERLAY")
	_G["CharacterNeckSlot"].RankFrame:SetPoint("TOP", _G["CharacterNeckSlot"], "TOP", 0, 0)
	_G["CharacterNeckSlot"].RankFrame.Label:FontTemplate(LSM:Fetch("font", MERAY.db.ilvl.font), MERAY.db.ilvl.textSize, MERAY.db.ilvl.fontOutline)
end

function MERAY:SlotGradiation()
	if MERAY.db.gradient ~= true then return end

	for i, SlotName in pairs(gearList) do
		local Slot = _G["Character"..gearList[i]]

		Slot = CreateFrame('Frame', nil, Slot)
		Slot:Size(130, 41)
		Slot:SetFrameLevel(_G["CharacterModelFrame"]:GetFrameLevel() - 1)
		Slot.Direction = i%2 == 1 and 'LEFT' or 'RIGHT'
		Slot:Point(Slot.Direction, _G["Character"..SlotName], 0, 0)

		Slot.Texture = Slot:CreateTexture(nil, "OVERLAY")
		Slot.Texture:SetInside()
		Slot.Texture:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\Gradation')
		Slot.Texture:SetVertexColor(unpack(E.media.rgbvaluecolor))
		if Slot.Direction == "LEFT" then
			Slot.Texture:SetTexCoord(0, 1, 0, 1)
		else
			Slot.Texture:SetTexCoord(1, 0, 0, 1)
		end
	end
end

function MERAY:AzeriteGlow()
	for i = 1, #AZSlots do
		local azslot = _G["Character"..AZSlots[i].."Slot"]
		local r, g, b = unpack(E["media"].rgbvaluecolor)

		hooksecurefunc(azslot, "DisplayAsAzeriteEmpoweredItem", function(self, itemLocation)
			self.AzeriteTexture:Hide()
			self.AvailableTraitFrame:Hide()
			PaperDollItemsFrame.EvaluateHelpTip = function(self) self.UnspentAzeriteHelpBox:Hide() end
			if HasAnyUnselectedPowers(itemLocation) then
				LCG.PixelGlow_Start(self, {r,g,b,1}, nil, -0.25, nil, 3)
			else
				LCG.PixelGlow_Stop(self)
			end
		end)
	end
end

function MERAY:UpdateIlvlFont()
	local db = E.db.mui.armory.stats.ItemLevel
	_G["CharacterStatsPane"].ItemLevelFrame.Value:FontTemplate(LSM:Fetch('font', db.font), db.size or 12, db.outline)
	_G["CharacterStatsPane"].ItemLevelFrame:SetHeight((db.size or 12) + 4)
	_G["CharacterStatsPane"].ItemLevelFrame.Background:SetHeight((db.size or 12) + 4)
	if _G["CharacterStatsPane"].ItemLevelFrame.leftGrad then
		_G["CharacterStatsPane"].ItemLevelFrame.leftGrad:SetHeight((db.size or 12) + 4)
		_G["CharacterStatsPane"].ItemLevelFrame.rightGrad:SetHeight((db.size or 12) + 4)
	end
end

function MERAY:firstGarrisonToast()
	MERAY:UnregisterEvent("GARRISON_MISSION_FINISHED")
	self:ScheduleTimer("UpdatePaperDoll", 7)
end

function MERAY:Initialize()
	if not E.db.mui.armory.enable or E.private.skins.blizzard.character ~= true or IsAddOnLoaded('ElvUI_SLE') then return end

	MERAY.db = E.db.mui.armory

	MER:RegisterDB(self, "armory")

	MERAY:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "UpdatePaperDoll", false)
	MERAY:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "UpdatePaperDoll", false)
	MERAY:RegisterEvent("SOCKET_INFO_UPDATE", "UpdatePaperDoll", false)
	MERAY:RegisterEvent("COMBAT_RATING_UPDATE", "UpdatePaperDoll", false)
	MERAY:RegisterEvent("MASTERY_UPDATE", "UpdatePaperDoll", false)

	MERAY:RegisterEvent("GARRISON_MISSION_FINISHED", "firstGarrisonToast", false)
	MERAY:RegisterEvent("PLAYER_ENTERING_WORLD", "InitialUpdatePaperDoll")

	_G["CharacterStatsPane"].ItemLevelFrame:SetPoint("TOP", _G["CharacterStatsPane"].ItemLevelCategory, "BOTTOM", 0, 6)

	-- Adjust a bit the Model Size
	if _G["CharacterModelFrame"]:GetHeight() == 320 then
		_G["CharacterModelFrame"]:ClearAllPoints()
		_G["CharacterModelFrame"]:SetPoint('TOPLEFT', _G["CharacterHeadSlot"])
		_G["CharacterModelFrame"]:SetPoint('RIGHT', _G["CharacterHandsSlot"])
		_G["CharacterModelFrame"]:SetPoint('BOTTOM', _G["CharacterMainHandSlot"])
	end

	function MERAY:ForUpdateAll()
		MERAY.db = E.db.mui.armory
		MERAY:UpdateIlvlFont()
	end

	self:ForUpdateAll()

	MERAY:AzeriteGlow()
	MERAY:UpdateIlvlFont()

	-- Stats
	if not IsAddOnLoaded("DejaCharacterStats") then
		hooksecurefunc("PaperDollFrame_UpdateStats", MERAY.PaperDollFrame_UpdateStats)
		MERAY:ToggleStats()
	end
end

local function InitializeCallback()
	MERAY:Initialize()
end

MER:RegisterModule(MERAY:GetName(), InitializeCallback)
