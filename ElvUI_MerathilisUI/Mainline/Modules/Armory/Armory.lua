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

local C_TransmogCollection_GetAppearanceSourceInfo = C_TransmogCollection.GetAppearanceSourceInfo
local C_Transmog_GetSlotInfo = C_Transmog.GetSlotInfo
local C_TransmogCollection_GetIllusionStrings = C_TransmogCollection.GetIllusionStrings
local C_Transmog_GetSlotVisualInfo = C_Transmog.GetSlotVisualInfo

local PANEL_DEFAULT_WIDTH = PANEL_DEFAULT_WIDTH

local initialized = false
local maxGemSlots = 5

local ClassSymbolFrame
local CharacterText --check character text

module.Constants = {}

module.Constants.gearList = {
	'HeadSlot', 'HandsSlot', 'NeckSlot', 'WaistSlot', 'ShoulderSlot', 'LegsSlot', 'BackSlot', 'FeetSlot', 'ChestSlot', 'Finger0Slot',
	'ShirtSlot', 'Finger1Slot', 'TabardSlot', 'Trinket0Slot', 'WristSlot', 'Trinket1Slot', 'SecondaryHandSlot', 'MainHandSlot'
}

module.Constants.slots = {
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

module.Constants.slotIDs = { -- Not the actual Char Frame IDs
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

module.Constants.enchantSlots = {
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

	if iLvl and (module.Constants.enchantSlots[SlotName] == true or module.Constants.enchantSlots[SlotName] == primaryStat) and not enchant then --Item should be enchanted, but no string actually sent. This bastard is slacking
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
		Slot.Gradiation.Texture:SetVertexColor(F.unpackColor(module.db.gradient.warningColor))
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

	for k, _ in pairs(module.Constants.slots) do
		frame = _G[("Character")..k]

		slot = GetInventorySlotInfo(k)
		if slot and slot ~= '' then
			-- Reset Data first
			frame.DurabilityInfo:SetText("")
			frame.Gradiation.Texture:Hide()
			frame.Transmog.Texture:Hide()
			frame.Transmog.Link = nil
			frame.Illusion:Hide()
			frame.Illusion.Link = nil

			itemLink = GetInventoryItemLink(unit, slot)
			if (itemLink and itemLink ~= nil) then
				if type(itemLink) ~= "string" then return end

				local _, _, itemRarity, _, _, _, _, _, _, _, _, _, _, _, _, setID = GetItemInfo(itemLink)

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
					if module.db.gradient.setArmor and setID then
						frame.Gradiation.Texture:SetVertexColor(F.unpackColor(module.db.gradient.setArmorColor))
					elseif itemRarity and module.db.gradient.colorStyle == "RARITY" then
						local r, g, b = GetItemQualityColor(itemRarity)
						frame.Gradiation.Texture:SetVertexColor(r, g, b)
					elseif module.db.gradient.colorStyle == "VALUE" then
						frame.Gradiation.Texture:SetVertexColor(unpack(E.media.rgbvaluecolor))
					else
						frame.Gradiation.Texture:SetVertexColor(F.unpackColor(module.db.gradient.color))
					end
				end

				-- Transmog
				if module.db.transmog.enable then
					local transmogLocation = TransmogUtil.GetTransmogLocation((frame.ID), Enum.TransmogType.Appearance, Enum.TransmogModification.Main)

					if not (slot == 2 or slot == 11 or slot == 12 or slot == 13 or slot == 14 or slot == 18) and C_Transmog_GetSlotInfo(transmogLocation) then
						frame.Transmog.Texture:Show()
						frame.Transmog.Link = select(6, C_TransmogCollection_GetAppearanceSourceInfo(select(3, C_Transmog_GetSlotVisualInfo(transmogLocation))))
					end
				end

				-- Illussion
				if module.db.illusion.enable then
					if (slot == 16 or slot == 17) then
						local transmogLocation = TransmogUtil.GetTransmogLocation((frame.ID), Enum.TransmogType.Appearance, Enum.TransmogModification.Main)
						local _, _, _, _, _, _, _, ItemTexture = C_Transmog_GetSlotInfo(transmogLocation)

						if ItemTexture then
							frame.Illusion.Texture:SetTexture(ItemTexture)
							frame.Illusion:Show()
							_, _, frame.Illusion.Link = C_TransmogCollection_GetIllusionStrings(select(3, C_Transmog_GetSlotVisualInfo(transmogLocation)))
						end
					else
						frame.Illusion:Hide()
					end
				end
			end
		end
	end

	M:UpdatePageInfo(_G['CharacterFrame'], 'Character')
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

	for id, slotName in pairs(module.Constants.slotIDs) do
		if not id then return end
		local frame = _G["Character"..module.Constants.slotIDs[id]]
		local slotHeight = frame:GetHeight()

		-- Durability
		frame.DurabilityInfo = frame:CreateFontString(nil, "OVERLAY")
		frame.DurabilityInfo:Point("TOP", frame, "TOP", 0, -2)
		frame.DurabilityInfo:FontTemplate(LSM:Fetch("font", module.db.durability.font), module.db.durability.textSize, module.db.durability.fontOutline)

		-- Gradiation
		frame.Gradiation = CreateFrame('Frame', nil, frame)
		frame.Gradiation:Size(120, slotHeight + 4)
		frame.Gradiation:SetFrameLevel(_G["CharacterModelFrame"]:GetFrameLevel() - 1)

		frame.Gradiation.Texture = frame.Gradiation:CreateTexture(nil, "OVERLAY")
		frame.Gradiation.Texture:SetInside()
		frame.Gradiation.Texture:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\Core\\Media\\textures\\Gradation')

		if id <= 7 or id == 17 or id == 11 then -- Left Size
			frame.Gradiation:Point("LEFT", _G["Character"..slotName], "RIGHT", - _G["Character"..slotName]:GetWidth()-4, 0)
			frame.Gradiation.Texture:SetTexCoord(0, 1, 0, 1)
		elseif id <= 16 then -- Right Side
			frame.Gradiation:Point("RIGHT", _G["Character"..slotName], "LEFT", _G["Character"..slotName]:GetWidth()+4, 0)
			frame.Gradiation.Texture:SetTexCoord(1, 0, 0, 1)
		end

		if module.db.expandSize then
			frame.Gradiation:Size(140, slotHeight + 4)
			if id == 18 then
				frame.Gradiation:Point("RIGHT", _G["Character"..slotName], "LEFT", _G["Character"..slotName]:GetWidth()+4, 0)
				frame.Gradiation.Texture:SetTexCoord(1, 0, 0, 1)
			elseif id == 19 then
				frame.Gradiation:Point("LEFT", _G["Character"..slotName], "RIGHT", - _G["Character"..slotName]:GetWidth()-4, 0)
				frame.Gradiation.Texture:SetTexCoord(0, 1, 0, 1)
			end
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

		-- Transmog Info
		frame.Transmog = CreateFrame('Button', nil, frame)
		frame.Transmog:Size(12)
		frame.Transmog:SetScript('OnEnter', self.Transmog_OnEnter)
		frame.Transmog:SetScript('OnLeave', self.Transmog_OnLeave)

		frame.Transmog.Texture = frame.Transmog:CreateTexture(nil, 'OVERLAY')
		frame.Transmog.Texture:SetInside()
		frame.Transmog.Texture:SetTexture(MER.Media.Textures.anchor)
		frame.Transmog.Texture:SetVertexColor(1, .5, 1)

		if id <= 7 or id == 17 or id == 11 then -- Left Size
			frame.Transmog:Point("TOPLEFT", _G["Character"..slotName], "TOPLEFT", -2, 2)
			frame.Transmog.Texture:SetTexCoord(0, 1, 1, 0)
		elseif id <= 16 then -- Right Side
			frame.Transmog:Point("TOPRIGHT", _G["Character"..slotName], "TOPRIGHT", 2, 2)
			frame.Transmog.Texture:SetTexCoord(1, 0, 1, 0)
		elseif id == 18 then -- Main Hand
			frame.Transmog:Point("BOTTOMRIGHT", _G["Character"..slotName], "BOTTOMRIGHT", 2, -2)
			frame.Transmog.Texture:SetTexCoord(1, 0, 0, 1)
		elseif id == 19 then -- Off Hand
			frame.Transmog:Point("BOTTOMLEFT", _G["Character"..slotName], "BOTTOMLEFT", -2, -2)
			frame.Transmog.Texture:SetTexCoord(0, 1, 0, 1)
		end

		-- Illusion Info
		frame.Illusion = CreateFrame('Button', nil, frame)
		frame.Illusion:Size(14)
		frame.Illusion:SetPoint('CENTER', _G["Character"..slotName], 'BOTTOM', 0, -2)
		frame.Illusion:SetScript('OnEnter', self.Illusion_OnEnter)
		frame.Illusion:SetScript('OnLeave', self.Tooltip_OnLeave)
		frame.Illusion:CreateBackdrop()
		frame.Illusion.backdrop:SetBackdropBorderColor(1, .5, 1)

		frame.Illusion.Texture = frame.Illusion:CreateTexture(nil, 'OVERLAY')
		frame.Illusion.Texture:SetInside()
		frame.Illusion.Texture:SetTexCoord(.1, .9, .1, .9)
	end

	for _, SlotName in pairs(module.Constants.gearList) do
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

	hooksecurefunc("CharacterFrame_Collapse", function()
		if E.db.mui.armory.enable and E.db.mui.armory.expandSize and _G["PaperDollFrame"]:IsShown() then
			_G["CharacterFrame"]:SetWidth(448)
		end
	end)
	hooksecurefunc("CharacterFrame_Expand", function()
		if E.db.mui.armory.enable and E.db.mui.armory.expandSize and _G["PaperDollFrame"]:IsShown() then
			_G["CharacterFrame"]:SetWidth(650)
		end
	end)
	hooksecurefunc("CharacterFrame_ShowSubFrame", function(frameName)
		if not E.db.mui.armory.enable and not E.db.mui.armory.expandSize then return end
		if frameName == "PaperDollFrame" or frameName == "PetPaperDollFrame" then return end
		if _G["CharacterFrame"]:GetWidth() > PANEL_DEFAULT_WIDTH + 1 then
			_G["CharacterFrame"]:SetWidth(PANEL_DEFAULT_WIDTH)
		end
	end)
end

function module:ExpandSize()
	if not module.db.expandSize then
		return
	end

	_G.CharacterFrame:SetHeight(470)

	_G.CharacterHandsSlot:SetPoint('TOPRIGHT', _G.CharacterFrameInsetRight, 'TOPLEFT', -4, -2)

	_G.CharacterMainHandSlot:SetPoint('BOTTOMLEFT', _G.PaperDollItemsFrame, 'BOTTOMLEFT', 185, 14)

	_G.CharacterModelFrame:ClearAllPoints()
	_G.CharacterModelFrame:SetPoint('TOPLEFT', _G.CharacterHeadSlot, 0, 5)
	_G.CharacterModelFrame:SetPoint('RIGHT', _G.CharacterHandsSlot)
	_G.CharacterModelFrame:SetPoint('BOTTOM', _G.CharacterMainHandSlot)

	if _G.PaperDollFrame:IsShown() then --Setting up width for the main frame
		_G.CharacterFrame:SetWidth(_G.CharacterFrame.Expanded and 650 or 444)
		_G.CharacterFrameInsetRight:SetPoint('TOPLEFT', _G.CharacterFrameInset, 'TOPRIGHT', 110, 0)
	end

	if _G.CharacterModelFrame and _G.CharacterModelFrame.BackgroundTopLeft and _G.CharacterModelFrame.BackgroundTopLeft:IsShown() then
		_G.CharacterModelFrame.BackgroundTopLeft:Hide()
		_G.CharacterModelFrame.BackgroundTopRight:Hide()
		_G.CharacterModelFrame.BackgroundBotLeft:Hide()
		_G.CharacterModelFrame.BackgroundBotRight:Hide()

		if _G.CharacterModelFrame.backdrop then
			_G.CharacterModelFrame.backdrop:Hide()
		end
	end

	-- Overlay resize to match new width
	_G.CharacterModelFrameBackgroundOverlay:SetPoint('TOPLEFT', _G.CharacterModelFrame, -4, 0)
	_G.CharacterModelFrameBackgroundOverlay:SetPoint('BOTTOMRIGHT', _G.CharacterModelFrame, 4, 0)

	_G.PaperDollEquipmentManagerPane:ClearAllPoints()
	_G.PaperDollEquipmentManagerPane:SetPoint("RIGHT", _G.CharacterFrame, "RIGHT", -30, -20)

	_G.PaperDollTitlesPane:ClearAllPoints()
	_G.PaperDollTitlesPane:SetPoint("RIGHT", _G.CharacterFrame, "RIGHT", -30, -20)

	if E.db.general.itemLevel.displayCharacterInfo then
		M:UpdatePageInfo(_G.CharacterFrame, "Character")
	end

	--Pawn Button sucks A$$
	if IsAddOnLoaded('Pawn') then
		if _G.PawnUI_InventoryPawnButton then
			_G.PawnUI_InventoryPawnButton:SetFrameStrata('DIALOG')
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

local function StatsPane(type)
	_G.CharacterStatsPane[type]:StripTextures()

	if _G.CharacterStatsPane[type] and _G.CharacterStatsPane[type].backdrop then
		_G.CharacterStatsPane[type].backdrop:Hide()
	end
end

local function CharacterStatFrameCategoryTemplate(frame)
	frame:StripTextures()

	local bg = frame.Background
	bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
	bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
	bg:ClearAllPoints()
	bg:SetPoint("CENTER", 0, -5)
	bg:SetSize(210, 30)
	bg:SetVertexColor(F.unpackColor(module.db.stats.color))
end

-- Copied from ElvUI
local function ColorizeStatPane(frame)
	if frame.leftGrad then
		frame.leftGrad:StripTextures()
	end
	if frame.rightGrad then
		frame.rightGrad:StripTextures()
	end

	local r, g, b = F.unpackColor(module.db.stats.color)

	frame.leftGrad = frame:CreateTexture(nil, "BORDER")
	frame.leftGrad:SetWidth(80)
	frame.leftGrad:SetHeight(frame:GetHeight())
	frame.leftGrad:SetPoint("LEFT", frame, "CENTER")
	frame.leftGrad:SetTexture(E.media.blankTex)
	frame.leftGrad:SetGradientAlpha("Horizontal", r, g, b, 0.75, r, g, b, 0)

	frame.rightGrad = frame:CreateTexture(nil, "BORDER")
	frame.rightGrad:SetWidth(80)
	frame.rightGrad:SetHeight(frame:GetHeight())
	frame.rightGrad:SetPoint("RIGHT", frame, "CENTER")
	frame.rightGrad:SetTexture(E.media.blankTex)
	frame.rightGrad:SetGradientAlpha("Horizontal", r, g, b, 0, r, g, b, 0.75)
end

local function SkinAdditionalStats()
	if CharacterStatsPane.OffenseCategory then
		if module.db.stats.classColorGradient then
			CharacterStatsPane.OffenseCategory.Title:SetText(E:TextGradient(CharacterStatsPane.OffenseCategory.Title:GetText(), F.ClassGradient[E.myclass]["r1"], F.ClassGradient[E.myclass]["g1"], F.ClassGradient[E.myclass]["b1"], F.ClassGradient[E.myclass]["r2"], F.ClassGradient[E.myclass]["g2"], F.ClassGradient[E.myclass]["b2"]))
		else
			CharacterStatsPane.OffenseCategory.Title:SetTextColor(F.unpackColor(module.db.stats.color))
		end
		StatsPane("OffenseCategory")
		CharacterStatFrameCategoryTemplate(CharacterStatsPane.OffenseCategory)
	end

	if CharacterStatsPane.DefenceCategory then
		if module.db.stats.classColorGradient then
			CharacterStatsPane.DefenceCategory.Title:SetText(E:TextGradient(CharacterStatsPane.DefenceCategory.Title:GetText(), F.ClassGradient[E.myclass]["r1"], F.ClassGradient[E.myclass]["g1"], F.ClassGradient[E.myclass]["b1"], F.ClassGradient[E.myclass]["r2"], F.ClassGradient[E.myclass]["g2"], F.ClassGradient[E.myclass]["b2"]))
		else
			CharacterStatsPane.DefenceCategory.Title:SetTextColor(F.unpackColor(module.db.stats.color))
		end
		StatsPane("DefenceCategory")
		CharacterStatFrameCategoryTemplate(CharacterStatsPane.DefenceCategory)
	end
end

function module:SkinCharacterStatsPane()
	local CharacterStatsPane = _G.CharacterStatsPane

	_G.CharacterModelFrame:DisableDrawLayer("BACKGROUND")
	_G.CharacterModelFrame:DisableDrawLayer("BORDER")
	_G.CharacterModelFrame:DisableDrawLayer("OVERLAY")

	if not IsAddOnLoaded("DejaCharacterStats") then
		if module.db.stats.classColorGradient then
			CharacterStatsPane.ItemLevelCategory.Title:SetText(E:TextGradient(CharacterStatsPane.ItemLevelCategory.Title:GetText(), F.ClassGradient[E.myclass]["r1"], F.ClassGradient[E.myclass]["g1"], F.ClassGradient[E.myclass]["b1"], F.ClassGradient[E.myclass]["r2"], F.ClassGradient[E.myclass]["g2"], F.ClassGradient[E.myclass]["b2"]))
			CharacterStatsPane.AttributesCategory.Title:SetText(E:TextGradient(CharacterStatsPane.AttributesCategory.Title:GetText(), F.ClassGradient[E.myclass]["r1"], F.ClassGradient[E.myclass]["g1"], F.ClassGradient[E.myclass]["b1"], F.ClassGradient[E.myclass]["r2"], F.ClassGradient[E.myclass]["g2"], F.ClassGradient[E.myclass]["b2"]))
			CharacterStatsPane.EnhancementsCategory.Title:SetText(E:TextGradient(CharacterStatsPane.EnhancementsCategory.Title:GetText(), F.ClassGradient[E.myclass]["r1"], F.ClassGradient[E.myclass]["g1"], F.ClassGradient[E.myclass]["b1"], F.ClassGradient[E.myclass]["r2"], F.ClassGradient[E.myclass]["g2"], F.ClassGradient[E.myclass]["b2"]))
		else
			CharacterStatsPane.ItemLevelCategory.Title:SetTextColor(F.unpackColor(module.db.stats.color))
			CharacterStatsPane.AttributesCategory.Title:SetTextColor(F.unpackColor(module.db.stats.color))
			CharacterStatsPane.EnhancementsCategory.Title:SetTextColor(F.unpackColor(module.db.stats.color))
		end

		StatsPane("EnhancementsCategory")
		StatsPane("ItemLevelCategory")
		StatsPane("AttributesCategory")

		CharacterStatFrameCategoryTemplate(CharacterStatsPane.ItemLevelCategory)
		CharacterStatFrameCategoryTemplate(CharacterStatsPane.AttributesCategory)
		CharacterStatFrameCategoryTemplate(CharacterStatsPane.EnhancementsCategory)

		CharacterStatsPane.ItemLevelFrame.Background:SetAlpha(0)
		ColorizeStatPane(CharacterStatsPane.ItemLevelFrame)

		E:Delay(0.2, SkinAdditionalStats)

		hooksecurefunc("PaperDollFrame_UpdateStats", function()
			for _, Table in ipairs({_G.CharacterStatsPane.statsFramePool:EnumerateActive()}) do
				if type(Table) == "table" then
					for statFrame in pairs(Table) do
						ColorizeStatPane(statFrame)
						if statFrame.Background:IsShown() then
							statFrame.leftGrad:Show()
							statFrame.rightGrad:Show()
						else
							statFrame.leftGrad:Hide()
							statFrame.rightGrad:Hide()
						end
					end
				end
			end
		end)
	end

	-- CharacterFrame Class Texture
	local ClassTexture = _G.ClassTexture
	if not ClassTexture then
		ClassTexture = _G.CharacterFrameInsetRight:CreateTexture(nil, "BORDER")
		ClassTexture:SetPoint("BOTTOM", _G.CharacterFrameInsetRight, "BOTTOM", 0, 40)
		ClassTexture:SetSize(126, 120)
		ClassTexture:SetAlpha(.25)
		ClassTexture:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\Core\\Media\\Textures\\ClassIcons\\CLASS-" .. E.myclass)
		ClassTexture:SetDesaturated(true)
	end
end

function module:AddCharacterIcon()
	if not module.db.classIcon then
		return
	end

	local CharacterFrameTitleText = _G.CharacterFrameTitleText
	local CharacterLevelText = _G.CharacterLevelText

	-- Class Icon Holder
	local ClassIconHolder = CreateFrame("Frame", "MER_ClassIcon", E.UIParent)
	ClassIconHolder:SetSize(20, 20)
	ClassIconHolder:SetParent("PaperDollFrame")

	local ClassIconTexture = ClassIconHolder:CreateTexture()
	ClassIconTexture:SetAllPoints(ClassIconHolder)

	CharacterLevelText:SetWidth(300)

	ClassSymbolFrame = ("|T"..(MER.ClassIcons[E.myclass]..".tga:0:0:0:0|t"))

	hooksecurefunc('PaperDollFrame_SetLevel', function()
		CharacterFrameTitleText:ClearAllPoints()
		CharacterFrameTitleText:SetPoint('TOP', _G.CharacterModelFrame, 0, 50)
		CharacterFrameTitleText:SetParent(_G.CharacterFrame)
		CharacterFrameTitleText:SetFont(E.LSM:Fetch('font', E.db.general.font), E.db.general.fontSize+2, E.db.general.fontStyle)
		CharacterFrameTitleText:SetTextColor(F.r, F.g, F.b)
		CharacterFrameTitleText:SetShadowColor(0, 0, 0, 0.8)
		CharacterFrameTitleText:SetShadowOffset(2, -1)

		CharacterLevelText:ClearAllPoints()
		CharacterLevelText:SetPoint('TOP', CharacterFrameTitleText, 'BOTTOM', 0, 0)
		CharacterLevelText:SetDrawLayer("OVERLAY")
	end)

	local titleText, coloredTitleText

	local function colorTitleText()
		CharacterText = CharacterFrameTitleText:GetText()
		coloredTitleText = E:TextGradient(CharacterText, 0.99,0.24,0.26, 0.99,0.59,0.28, 1,0.87,0.29, 0.42,0.99,0.39, 0.32,0.76,0.98, 0.63,0.36,0.98, 0.77,0.47,0.98)
		if not CharacterText:match("|T") then
			titleText = ClassSymbolFrame.." "..coloredTitleText
		end
		CharacterFrameTitleText:SetText(titleText)
	end

	hooksecurefunc("CharacterFrame_Collapse", function()
		if PaperDollFrame:IsShown() then
			colorTitleText()
		end
	end)

	hooksecurefunc("CharacterFrame_Expand", function()
		if PaperDollFrame:IsShown() then
			colorTitleText()
		end
	end)

	hooksecurefunc("ReputationFrame_Update", function()
		if ReputationFrame:IsShown() then
			colorTitleText()
		end
	end)

	hooksecurefunc("TokenFrame_Update", function()
		if TokenFrame:IsShown() then
			colorTitleText()
		end
	end)

	hooksecurefunc(CharacterFrame, 'SetTitle', function()
		colorTitleText()
	end)

	if E.db.general.itemLevel.displayCharacterInfo then
		M:UpdatePageInfo(_G.CharacterFrame, "Character")
	end
end

function module:Initialize()
	module.db = E.db.mui.armory

	if not module.db.enable or not E.private.skins.blizzard.character then return end
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

	self:SkinCharacterStatsPane()
	self:BuildScrollBar()
	self:ExpandSize()
	self:AddCharacterIcon()

	-- Stats
	if not IsAddOnLoaded("DejaCharacterStats") then
		module:ToggleStats()
		hooksecurefunc("PaperDollFrame_UpdateStats", module.PaperDollFrame_UpdateStats)
		hooksecurefunc(M, 'UpdateCharacterItemLevel', module.UpdateCharacterItemLevel)
		hooksecurefunc(M, 'ToggleItemLevelInfo', module.UpdateCharacterItemLevel)
		hooksecurefunc(M, 'UpdateAverageString', module.UpdateCharacterItemLevel)
	end
end

MER:RegisterModule(module:GetName())
