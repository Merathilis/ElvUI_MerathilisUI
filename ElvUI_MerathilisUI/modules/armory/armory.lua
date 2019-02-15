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
	["ShirtSlot"] = { false, false },
	["Finger1Slot"] = { true, false },
	["TabardSlot"] = { false, false },
	["Trinket0Slot"] = { true, false },
	["Trinket1Slot"] = { true, false },
}

local slotIDs = {
	[1] = "HeadSlot",
	[2] = "NeckSlot",
	[3] = "ShoulderSlot",
	[5] = "ChestSlot",
	[6] = "ShirtSlot",
	[7] = "TabardSlot",
	[8] = "WaistSlot",
	[9] = "LegsSlot",
	[10] = "FeetSlot",
	[11] = "WristSlot",
	[12] = "HandsSlot",
	[13] = "Finger0Slot",
	[14] = "Finger1Slot",
	[15] = "Trinket0Slot",
	[16] = "Trinket1Slot",
	[17] = "BackSlot",
	[18] = "MainHandSlot",
	[19] = "SecondaryHandSlot",
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
			frame.DurabilityInfo:SetText("")
			frame.Gradiation.Texture:Hide()

			itemLink = GetInventoryItemLink(unit, slot)
			if (itemLink and itemLink ~= nil) then
				if type(itemLink) ~= "string" then return end
				_, _, _, _, _, _, _, _, _, _, _, _, _, numBonuses, affixes = strsplit(":", itemLink, 15)
				numBonuses = tonumber(numBonuses) or 0

				local _, _, itemRarity, _, _, _, _, _, itemEquipLoc = GetItemInfo(itemLink)
				-- Durability
				if MERAY.db.durability.enable then
					frame.DurabilityInfo:SetText()
					current, maximum = GetInventoryItemDurability(slot)
					if current and maximum and (not MERAY.db.durability.onlydamaged or current < maximum) then
						r, g, b = E:ColorGradient((current / maximum), 1, 0, 0, 1, 1, 0, 0, 1, 0)
						frame.DurabilityInfo:SetFormattedText("%s%.0f%%|r", E:RGBToHex(r, g, b), (current / maximum) * 100)
					end
				end
				-- Gradiation
				if MERAY.db.gradient.enable then
					frame.Gradiation.Texture:Show()
					if itemRarity and MERAY.db.gradient.colorStyle == "RARITY" then
						local r, g, b = GetItemQualityColor(itemRarity)
						frame.Gradiation.Texture:SetVertexColor(r, g, b)
					elseif MERAY.db.gradient.colorStyle == "VALUE" then
						frame.Gradiation.Texture:SetVertexColor(unpack(E.media.rgbvaluecolor))
					else
						frame.Gradiation.Texture:SetVertexColor(MER:unpackColor(MERAY.db.gradient.color))
					end
				end
			end
		end
	end
end

function MERAY:InitialUpdatePaperDoll()
	MERAY:UnregisterEvent("PLAYER_ENTERING_WORLD")

	self:BuildInformation()

	-- update player info
	self:ScheduleTimer("UpdatePaperDoll", 13)

	initialized = true
end

function MERAY:BuildInformation()
	for id, slotName in pairs(slotIDs) do
		if not id then return end

		local frame = _G["Character"..slotIDs[id]]

		-- Durability
		frame.DurabilityInfo = frame:CreateFontString(nil, "OVERLAY")
		frame.DurabilityInfo:SetPoint("TOP", frame, "TOP", 0, -2)
		frame.DurabilityInfo:FontTemplate(LSM:Fetch("font", MERAY.db.durability.font), MERAY.db.durability.textSize, MERAY.db.durability.fontOutline)

		-- Gradiation
		frame.Gradiation = CreateFrame('Frame', nil, frame)
		frame.Gradiation:Size(110, 41)
		frame.Gradiation:SetFrameLevel(_G["CharacterModelFrame"]:GetFrameLevel() - 1)

		frame.Gradiation.Texture = frame.Gradiation:CreateTexture(nil, "OVERLAY")
		frame.Gradiation.Texture:SetInside()
		frame.Gradiation.Texture:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\Gradation')

		if id <= 7 or id == 17 or id == 11 then -- Left Size
			frame.Gradiation:SetPoint("LEFT", _G["Character"..slotName], "RIGHT", -20, 0)
			frame.Gradiation.Texture:SetTexCoord(0, 1, 0, 1)
		elseif id <= 16 then -- Right Side
			frame.Gradiation:SetPoint("RIGHT", _G["Character"..slotName], "LEFT", 20, 0)
			frame.Gradiation.Texture:SetTexCoord(1, 0, 0, 1)
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

			if HasAnyUnselectedPowers(itemLocation) then
				LCG.PixelGlow_Start(self, {r, g, b, 1}, nil, -0.25, nil, 2)
			else
				LCG.PixelGlow_Stop(self)
			end
		end)
	end
end

--function MERAY:UpdateIlvlFont()
--	local db = E.db.mui.armory.stats.ItemLevel

--	_G["CharacterStatsPane"].ItemLevelFrame.Value:FontTemplate(LSM:Fetch('font', db.font), db.size or 12, db.outline)
--	_G["CharacterStatsPane"].ItemLevelFrame:SetHeight((db.size or 12) + 4)
--	_G["CharacterStatsPane"].ItemLevelFrame.Background:SetHeight((db.size or 12) + 4)
--	if _G["CharacterStatsPane"].ItemLevelFrame.leftGrad then
--		_G["CharacterStatsPane"].ItemLevelFrame.leftGrad:SetHeight((db.size or 12) + 4)
--		_G["CharacterStatsPane"].ItemLevelFrame.rightGrad:SetHeight((db.size or 12) + 4)
--	end
--end

function MERAY:firstGarrisonToast()
	MERAY:UnregisterEvent("GARRISON_MISSION_FINISHED")
	self:ScheduleTimer("UpdatePaperDoll", 7)
end

function MERAY:Initialize()
	if not E.db.mui.armory.enable or E.private.skins.blizzard.character ~= true then return end
	if (IsAddOnLoaded("ElvUI_SLE") and E.db.sle.Armory.Character.Enable) then return end
	if not E.db.general.displayCharacterInfo then return end

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

	MERAY:AzeriteGlow()

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
