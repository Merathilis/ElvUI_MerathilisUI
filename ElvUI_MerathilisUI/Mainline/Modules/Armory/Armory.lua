local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Armory')
local M = E:GetModule('Misc')
local LSM = E.LSM or E.Libs.LSM

local _G = _G
local select, unpack = select, unpack
local strlower = strlower
local type = type
local gsub = gsub
local pairs = pairs

local CreateFrame = CreateFrame
local GetItemGem = GetItemGem
local GetInventoryItemLink = GetInventoryItemLink
local GetInventoryItemDurability = GetInventoryItemDurability
local GetInventorySlotInfo = GetInventorySlotInfo
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local hooksecurefunc = hooksecurefunc
local UnitSex = UnitSex

local initialized = false
local maxGemSlots = 5

local gearList = {
	'HeadSlot', 'HandsSlot', 'NeckSlot', 'WaistSlot', 'ShoulderSlot', 'LegsSlot', 'BackSlot', 'FeetSlot', 'ChestSlot', 'Finger0Slot',
	'ShirtSlot', 'Finger1Slot', 'TabardSlot', 'Trinket0Slot', 'WristSlot', 'Trinket1Slot', 'SecondaryHandSlot', 'MainHandSlot'
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

local enchantSlots = {
	['HeadSlot'] = false,
	['NeckSlot'] = false,
	['ShoulderSlot'] = false,
	['WaistSlot'] = false,
	['LegsSlot'] = false,
	['Finger0Slot'] = true,
	['Finger1Slot'] = true,
	['MainHandSlot'] = true,
	['SecondaryHandSlot'] = false,
	['ChestSlot'] = true,
	['BackSlot'] = true,
	['FeetSlot'] = 2,
	['WristSlot'] = 4,
	['HandsSlot'] = 1,
	['Trinket0Slot'] = false,
	['Trinket1Slot'] = false,
}

function module:Transmog_OnEnter()
	if self.Link and self.Link ~= '' then
		self.Texture:SetVertexColor(1, .8, 1)
		_G["GameTooltip"]:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')

		self:SetScript('OnUpdate', function()
			_G["GameTooltip"]:ClearLines()
			_G["GameTooltip"]:SetHyperlink(self.Link)

			_G["GameTooltip"]:Show()
		end)
	end
end

function module:Transmog_OnLeave()
	self.Texture:SetVertexColor(1, .5, 1)

	self:SetScript('OnUpdate', nil)
	_G["GameTooltip"]:Hide()
end

function module:Illusion_OnEnter()
	_G["GameTooltip"]:SetOwner(self, 'ANCHOR_BOTTOM')
	_G["GameTooltip"]:AddLine(self.Link, 1, 1, 1)
	_G["GameTooltip"]:Show()
end

function module:Tooltip_OnLeave()
	_G["GameTooltip"]:Hide()
end

function module:Warning_OnEnter()
	if module.db.enable and self.Reason then
		_G['GameTooltip']:SetOwner(self, 'ANCHOR_RIGHT')
		_G['GameTooltip']:AddLine(self.Reason, 1, 1, 1)
		_G['GameTooltip']:Show()
	end
end

function module:Gem_OnEnter()
	if module.db.enable and self.Link then
		_G['GameTooltip']:SetOwner(self, 'ANCHOR_RIGHT')
		_G['GameTooltip']:SetHyperlink(self.Link)
		_G['GameTooltip']:Show()
	end
end

function module:CheckForMissing(which, Slot, iLvl, gems, essences, enchant, primaryStat)
	if not Slot.Warning then return end
	Slot.Warning.Reason = nil
	local window = strlower(which)
	local SlotName = gsub(Slot:GetName(), which, '')
	if not SlotName then return end --No slot?
	local noChant, noGem = false, false

	if iLvl and (enchantSlots[SlotName] == true or enchantSlots[SlotName] == primaryStat) and not enchant then --Item should be enchanted, but no string actually sent. This bastard is slacking
		local classID, subclassID = select(12, GetItemInfo(Slot.itemLink))
		if (classID == 4 and subclassID == 6) or (classID == 4 and subclassID == 0 and Slot.ID == 17) then --Shields are special
			noChant = false
		else
			noChant = true
		end
	end

	if gems and Slot.ID ~= 2 then --If gems found and not neck
		for i = 1, maxGemSlots do
			local texture = Slot['textureSlot'..i]
			if (texture and texture:GetTexture()) and (Slot['MER_Gem'..i] and not Slot['MER_Gem'..i].Link) then noGem = true; break end --If there is a texture (e.g. actual slot), but no link = no gem installed
		end
	end

	if (noChant or noGem) then --If anything us missing
		local message = ''
		if noGem then message = message..'|cffff0000'..L["Empty Socket"]..'|r\n' end
		if noChant then message = message..'|cffff0000'..L["Not Enchanted"]..'|r\n' end
		Slot.Warning.Reason = message or nil
		Slot.Warning:Show()
	else
		Slot.Warning:Hide()
	end
end

function module:UpdateGemInfo(Slot, which)
	local unit = which == 'Character' and 'player' or (_G['InspectFrame'] and _G['InspectFrame'].unit)
	if not unit then return end
	module.db = E.db.mui.armory

	for i = 1, maxGemSlots do
		local GemLink
		if not Slot['MER_Gem'..i] then return end
		if Slot.itemLink then
			if Slot.ID == 2 then
				local window = strlower(which)
				if module.db.warning.enable then
					if which == 'Character' and Slot['textureSlotEssenceType'..i] then
						Slot['textureSlotEssenceType'..i]:Hide()
					elseif which == 'Inspect' and Slot['textureSlotBackdrop'..i] then
						Slot['textureSlotBackdrop'..i]:Hide()
					end
				end
			else
				GemLink = select(2, GetItemGem(Slot.itemLink, i))
			end
		end
		Slot['MER_Gem'..i].Link = GemLink
	end
end

function module:UpdatePageInfo(frame, which, guid, event)
	if not (frame and which) then return end
	if not module:CheckOptions(which) then return end
	local window = strlower(which)
	local unit = (which == 'Character' and 'player') or frame.unit
	if which == 'Character' then
		module.CharacterPrimaryStat = select(6, GetSpecializationInfo(GetSpecialization(), nil, nil, nil, UnitSex('player')))
	end
end

function module:UpdatePageStrings(i, iLevelDB, Slot, slotInfo, which)
	if not module:CheckOptions(which) then return end
	Slot.itemLink = GetInventoryItemLink((which == 'Character' and 'player') or _G['InspectFrame'].unit, Slot.ID)

	module:UpdateGemInfo(Slot, which)
	module:CheckForMissing(which, Slot, slotInfo.iLvl, slotInfo.gems, slotInfo.essences, slotInfo.enchantTextShort, module[which.."PrimaryStat"])
end

function module:UpdateCharacterInfo(event)
	if event == 'CRITERIA_UPDATE' and InCombatLockdown() then return end

	M:UpdatePageInfo(_G['CharacterFrame'], 'Character')

	if not E.db.general.itemLevel.displayCharacterInfo then
		M:ClearPageInfo(_G['CharacterFrame'], 'Character')
	end
end

function module:UpdatePaperDoll()
	module.db = E.db.mui.armory
	if not module.db.enable then return end

	local unit = "player"
	if not unit then return end

	local frame, slot, current, maximum, r, g, b
	local itemLink

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

				local _, _, itemRarity, _, _, _, _, _, _ = GetItemInfo(itemLink)

				-- Durability
				if module.db.durability.enable then
					frame.DurabilityInfo:SetText()
					current, maximum = GetInventoryItemDurability(slot)
					if current and maximum and (not module.db.durability.onlydamaged or current < maximum) then
						r, g, b = E:ColorGradient((current / maximum), 1, 0, 0, 1, 1, 0, 0, 1, 0)
						frame.DurabilityInfo:SetFormattedText("%s%.0f%%|r", E:RGBToHex(r, g, b), (current / maximum) * 100)
					end
				end

				-- Gradiation
				if module.db.gradient.enable then
					frame.Gradiation.Texture:Show()
					if itemRarity and module.db.gradient.colorStyle == "RARITY" then
						local r, g, b = GetItemQualityColor(itemRarity)
						frame.Gradiation.Texture:SetVertexColor(r, g, b)
					elseif module.db.gradient.colorStyle == "VALUE" then
						frame.Gradiation.Texture:SetVertexColor(unpack(E.media.rgbvaluecolor))
					else
						frame.Gradiation.Texture:SetVertexColor(F.unpackColor(module.db.gradient.color))
					end
				end
			end
		end
	end
end

function module:InitialUpdatePaperDoll()
	module:UnregisterEvent("PLAYER_ENTERING_WORLD")

	self:BuildInformation()

	-- update player info
	self:ScheduleTimer("UpdatePaperDoll", 5)

	initialized = true
end

function module:BuildInformation()
	module.db = E.db.mui.armory

	for id, slotName in pairs(slotIDs) do
		if not id then return end
		local frame = _G["Character"..slotIDs[id]]

		-- Durability
		frame.DurabilityInfo = frame:CreateFontString(nil, "OVERLAY")
		frame.DurabilityInfo:Point("TOP", frame, "TOP", 0, -2)
		frame.DurabilityInfo:FontTemplate(LSM:Fetch("font", module.db.durability.font), module.db.durability.textSize, module.db.durability.fontOutline)

		-- Gradiation
		frame.Gradiation = CreateFrame('Frame', nil, frame)
		frame.Gradiation:Size(110, _G["Character"..slotName]:GetHeight()+4)
		frame.Gradiation:SetFrameLevel(_G["CharacterModelFrame"]:GetFrameLevel() - 1)

		frame.Gradiation.Texture = frame.Gradiation:CreateTexture(nil, "OVERLAY")
		frame.Gradiation.Texture:SetInside()
		frame.Gradiation.Texture:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\Core\\Media\\textures\\Gradation')

		if id <= 7 or id == 17 or id == 11 then -- Left Size
			frame.Gradiation:Point("LEFT", _G["Character"..slotName], "RIGHT")
			frame.Gradiation.Texture:SetTexCoord(0, 1, 0, 1)
		elseif id <= 16 then -- Right Side
			frame.Gradiation:Point("RIGHT", _G["Character"..slotName], "LEFT")
			frame.Gradiation.Texture:SetTexCoord(1, 0, 0, 1)
		end

		-- Missing Enchants/Gems Warning
		frame.Warning = CreateFrame('Frame', nil, frame)
		if id <= 7 or id == 17 or id == 11 then -- Left Size
			frame.Warning:Size(7, 41)
			frame.Warning:SetPoint("RIGHT", _G["Character"..slotName], "LEFT", 0, 0)
		elseif id <= 16 then -- Right Side
			frame.Warning:Size(7, 41)
			frame.Warning:SetPoint("LEFT", _G["Character"..slotName], "RIGHT", 0, 0)
		elseif id == 18 or id == 19 then -- Main Hand/ OffHand
			frame.Warning:Size(41, 7)
			frame.Warning:SetPoint("TOP", _G["Character"..slotName], "BOTTOM", 0, 0)
		end

		frame.Warning.Texture = frame.Warning:CreateTexture(nil, "BACKGROUND")
		frame.Warning.Texture:SetInside()
		frame.Warning.Texture:SetTexture("Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\Minimalist")
		frame.Warning.Texture:SetVertexColor(1, 0, 0)

		frame.Warning:SetScript("OnEnter", self.Warning_OnEnter)
		frame.Warning:SetScript("OnLeave", self.Tooltip_OnLeave)
		frame.Warning:Hide()
	end

	for i, SlotName in pairs(gearList) do
		local Slot = _G["Character"..SlotName]
		Slot.ID = GetInventorySlotInfo(SlotName)

		-- Gems
		for t = 1, maxGemSlots do
			if Slot["textureSlot"..t] then
				Slot["MER_Gem"..t] = CreateFrame("Frame", nil, Slot)
				Slot["MER_Gem"..t]:SetPoint("TOPLEFT", Slot["textureSlot"..t])
				Slot["MER_Gem"..t]:SetPoint("BOTTOMRIGHT", Slot["textureSlot"..t])
				Slot["MER_Gem"..t]:SetScript("OnEnter", module.Gem_OnEnter)
				Slot["MER_Gem"..t]:SetScript("OnLeave", module.Tooltip_OnLeave)
				Slot["MER_Gem"..t].frame = "character"
			end
		end
	end
end

function module:firstGarrisonToast()
	module:UnregisterEvent("GARRISON_MISSION_FINISHED")
	self:ScheduleTimer("UpdatePaperDoll", 7)
end

function module:CheckOptions(which)
	if not E.private.skins.blizzard.enable then return false end
	if (which == 'Character' and not E.private.skins.blizzard.character) then return false end
	return true
end

function module:Initialize()
	module.db = E.db.mui.armory

	if not module.db.enable or E.private.skins.blizzard.character ~= true then return end
	if not E.db.general.itemLevel.displayCharacterInfo then return end

	module:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "UpdatePaperDoll", false)
	module:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "UpdatePaperDoll", false)
	module:RegisterEvent("SOCKET_INFO_UPDATE", "UpdatePaperDoll", false)
	module:RegisterEvent("COMBAT_RATING_UPDATE", "UpdatePaperDoll", false)
	module:RegisterEvent("MASTERY_UPDATE", "UpdatePaperDoll", false)

	module:RegisterEvent("GARRISON_MISSION_FINISHED", "firstGarrisonToast", false)
	module:RegisterEvent("PLAYER_ENTERING_WORLD", "InitialUpdatePaperDoll")

	hooksecurefunc(M, 'UpdatePageInfo', module.UpdatePageInfo)
	hooksecurefunc(M, 'UpdatePageStrings', module.UpdatePageStrings)

	if module:CheckOptions('Character') then
		hooksecurefunc(M, 'UpdateCharacterInfo', module.UpdateCharacterInfo)
		module:UpdateCharacterInfo()
	end

	-- Adjust a bit the Model Size
	if _G["CharacterModelFrame"]:GetHeight() == 320 then
		_G["CharacterModelFrame"]:ClearAllPoints()
		_G["CharacterModelFrame"]:Point('TOPLEFT', _G["CharacterHeadSlot"])
		_G["CharacterModelFrame"]:Point('RIGHT', _G["CharacterHandsSlot"])
		_G["CharacterModelFrame"]:Point('BOTTOM', _G["CharacterMainHandSlot"])
	end

	function module:ForUpdateAll()
		module.db = E.db.mui.armory
	end

	self:ForUpdateAll()

	-- Stats
	if not IsAddOnLoaded("DejaCharacterStats") then
		hooksecurefunc("PaperDollFrame_UpdateStats", module.PaperDollFrame_UpdateStats)
		module:ToggleStats()
	end
end

MER:RegisterModule(module:GetName())
