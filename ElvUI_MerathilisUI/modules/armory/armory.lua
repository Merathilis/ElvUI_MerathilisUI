local MER, E, L, V, P, G = unpack(select(2, ...))
local CA = MER:NewModule("CharacterArmory", "AceEvent-3.0", "AceTimer-3.0")
CA.modName = L["Armory"]

-- Cache global variables
-- Lua functions
local _G = _G

-- WoW API / Variables

--GLOBALS:

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

function CA:UpdatePaperDoll(inspect)
	if not E.db.mui.armory.enable then return end

	if InCombatLockdown() then
		CA:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdatePaperDoll", inspect)
		return
	else
		CA:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end

	local unit = (inspect and InspectFrame) and InspectFrame.unit or "player"
	if not unit then return end
	if unit and not CanInspect(unit, false) then return end

	local frame, slot, current, maximum, r, g, b
	local baseName = inspect and "Inspect" or "Character"
	local itemLink, itemLevel, itemLevelMax
	local avgItemLevel, avgEquipItemLevel = GetAverageItemLevel()

	for k, info in pairs(slots) do
		frame = _G[("%s%s"):format(baseName, k)]

		slot = GetInventorySlotInfo(k)
		if info[1] then
			frame.ItemLevel:SetText()
			if CA.db.ilvl.enable and info[1] then
				itemLink = GetInventoryItemLink(unit, slot)

				if (itemLink ~= nil) then
					local _, _, itemRarity = GetItemInfo(itemLink)
					if ((slot == 16 or slot == 17) and GetInventoryItemQuality(unit, slot) == LE_ITEM_QUALITY_ARTIFACT) then
						local itemLevelMainHand = 0
						local itemLevelOffHand = 0
						local itemLinkMainHand = GetInventoryItemLink(unit, 16)
						local itemLinkOffhand = GetInventoryItemLink(unit, 17)
						if itemLinkMainHand then itemLevelMainHand = self:GetItemLevel(unit, itemLinkMainHand or 0) end
						if itemLinkOffhand then itemLevelOffHand = self:GetItemLevel(unit, itemLinkOffhand or 0) end
						itemLevel = math.max(itemLevelMainHand or 0, itemLevelOffHand or 0)
					else
						itemLevel = self:GetItemLevel(unit, itemLink)
					end

					if itemLevel and avgEquipItemLevel then
						frame.ItemLevel:SetText(itemLevel)
					end

					if itemRarity and CA.db.ilvl.colorStyle == "RARITY" then
						local r, g, b = GetItemQualityColor(itemRarity)
						frame.ItemLevel:SetTextColor(r, g, b)
					else
						frame.ItemLevel:SetTextColor(MER:unpackColor(CA.db.ilvl.color))
					end
				end
			end
		end

		if not inspect and info[2] then
			frame.DurabilityInfo:SetText()
			if CA.db.durability.enable then
				current, maximum = GetInventoryItemDurability(slot)
				if current and maximum and (not CA.db.durability.onlydamaged or current < maximum) then
					r, g, b = E:ColorGradient((current / maximum), 1, 0, 0, 1, 1, 0, 0, 1, 0)
					frame.DurabilityInfo:SetFormattedText("%s%.0f%%|r", E:RGBToHex(r, g, b), (current / maximum) * 100)
				end
			end
		end
	end
end

function CA:DelayUpdateInfo(inspect)
	if (updateTimer == 0 or CA:TimeLeft(updateTimer) == 0) then
		updateTimer = CA:ScheduleTimer("UpdatePaperDoll", .2, inspect)
	end
end


-- from http://www.wowinterface.com/forums/showthread.php?p=284771 by PhanX
-- Construct your saarch pattern based on the existing global string:
--  local S_UPGRADE_LEVEL   = "^" .. gsub(ITEM_UPGRADE_TOOLTIP_FORMAT, "%%d", "(%%d+)")
local S_ITEM_LEVEL      = "^" .. gsub(ITEM_LEVEL, "%%d", "(%%d+)")

-- Create the tooltip:
local scantip = CreateFrame("GameTooltip", "MyScanningTooltip", nil, "GameTooltipTemplate")
scantip:SetOwner(UIParent, "ANCHOR_NONE")

--[[  -- Create a function for simplicity's sake:
local function GetItemUpgradeLevel(itemLink)
	-- Pass the item link to the tooltip:
	scantip:SetHyperlink(itemLink)

	-- Scan the tooltip:
	for i = 2, scantip:NumLines() do -- Line 1 is always the name so you can skip it.
		local text = _G["MyScanningTooltipTextLeft"..i]:GetText()
		if text and text ~= "" then
			local currentUpgradeLevel, maxUpgradeLevel = strmatch(text, S_UPGRADE_LEVEL)
			if currentUpgradeLevel then
				return currentUpgradeLevel, maxUpgradeLevel
			end
		end
	end
end
]]

local function GetRealItemLevel(itemLink)
	-- Pass the item link to the tooltip:
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

function CA:GetItemLevel(unit, itemLink)
	local rarity, itemLevel = select(3, GetItemInfo(itemLink))
	if rarity == 7 then -- heirloom adjust
		itemLevel = self:HeirLoomLevel(unit, itemLink)
	end

	--[[
	local upgrade = itemLink:match(":(%d+)\124h%[")
	if itemLevel and upgrade and levelAdjust[upgrade] then
		itemLevel = itemLevel + levelAdjust[upgrade]
	end

	]]--
	-- Now you can just call the function to get the levels:

	--print(type(itemLevel))
	itemLevel = GetRealItemLevel(itemLink)
	itemLevel = tonumber(itemLevel)
	--print(type(itemLevel))
	return itemLevel
end

--[[heirloom ilvl equivalents

Vanilla: 1-60 = 60 / 60 = scales by 1 ilvl per player level

TBC rares: 85-115 = 30 / 10 = scales by 3 ilvl per player level

WLK rares: 130-190(200) = 60 / 10 = scales by 6 ilvl per player level

CAT rares: 272-333 = 61 / 5 = scales by 12.2 ilvl per player level

MOP rares: 364-450 = 86 / 5 = scales by 17.2 ilvl per player level (guesswork)

]]
function CA:HeirLoomLevel(unit, itemLink)
	local level = UnitLevel(unit)

	if level > 85 then
		local _, _, _, _, itemId = find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
		--print(itemId)
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
		--print(itemId)
		itemId = tonumber(itemId)

		for _, id in pairs(heirlooms[80]) do
			if id == itemId then
				level = 80
				break
			end
		end
	end

	if level > 85 then return level
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

function CA:InspectFrame_UpdateTabsComplete()
	originalInspectFrameUpdateTabs()
	CA:DelayUpdateInfo(true)
end

function CA:InitialUpdatePaperDoll()
	CA:UnregisterEvent("PLAYER_ENTERING_WORLD")

	LoadAddOn("Blizzard_InspectUI")

	self:BuildInfoText("Character")
	self:BuildInfoText("Inspect")

	-- hook to inspect frame update
	originalInspectFrameUpdateTabs = _G.InspectFrame_UpdateTabs
	_G.InspectFrame_UpdateTabs = CA.InspectFrame_UpdateTabsComplete

	-- update player info
	self:ScheduleTimer("UpdatePaperDoll", 10)

	initialized = true
end

function CA:BuildInfoText(name)
	for k, info in pairs(slots) do
		frame = _G[("%s%s"):format(name, k)]

		if info[1] then
			frame.ItemLevel = frame:CreateFontString(nil, "OVERLAY")
			frame.ItemLevel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 1, 1)
			frame.ItemLevel:FontTemplate(E.LSM:Fetch("font", CA.db.ilvl.font), CA.db.ilvl.textSize, CA.db.ilvl.fontOutline)
		end

		if name == "Character" and info[2] then
			frame.DurabilityInfo = frame:CreateFontString(nil, "OVERLAY")
			frame.DurabilityInfo:SetPoint("TOP", frame, "TOP", 0, -4)
			frame.DurabilityInfo:FontTemplate(E.LSM:Fetch("font", CA.db.durability.font), CA.db.durability.textSize, CA.db.durability.fontOutline)
		end
	end

	-- Azerite Neck
	_G["CharacterNeckSlot"].RankFrame:CreateFontString(nil, "OVERLAY")
	_G["CharacterNeckSlot"].RankFrame:SetPoint("TOP", _G["CharacterNeckSlot"], "TOP", 0, 0)
	_G["CharacterNeckSlot"].RankFrame.Label:FontTemplate(E["media"].normFont, 12, "THINOUTLINE")
end

function CA:firstGarrisonToast()
	CA:UnregisterEvent("GARRISON_MISSION_FINISHED")
	self:ScheduleTimer("UpdatePaperDoll", 7)
end

function CA:Initialize()
	if not E.db.mui.armory.enable or (IsAddOnLoaded('ElvUI_SLE') and E.db.sle.Armory.Character.Enable ~= false) then return end

	CA.db = E.db.mui.armory

	CA:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "UpdatePaperDoll", false)
	CA:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "UpdatePaperDoll", false)
	CA:RegisterEvent("SOCKET_INFO_UPDATE", "UpdatePaperDoll", false)
	CA:RegisterEvent("COMBAT_RATING_UPDATE", "UpdatePaperDoll", false)
	CA:RegisterEvent("MASTERY_UPDATE", "UpdatePaperDoll", false)

	CA:RegisterEvent("GARRISON_MISSION_FINISHED", "firstGarrisonToast", false)
	CA:RegisterEvent("PLAYER_ENTERING_WORLD", "InitialUpdatePaperDoll")
end


local function InitializeCallback()
	CA:Initialize()
end

MER:RegisterModule(CA:GetName(), InitializeCallback)
