local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Armory')
local M = E:GetModule('Misc')
local LSM = E.LSM or E.Libs.LSM

local pairs, type, unpack = pairs, type, unpack

local GetInventoryItemDurability = GetInventoryItemDurability
local GetInventorySlotInfo = GetInventorySlotInfo
local GetItemQualityColor = GetItemQualityColor

local CharacterStatsPane = _G.CharacterStatsPane
local CreateFrame = CreateFrame
local CreateColor = CreateColor
local C_Transmog_GetSlotInfo = C_Transmog and C_Transmog.GetSlotInfo
local C_Transmog_GetSlotVisualInfo = C_Transmog and C_Transmog.GetSlotVisualInfo
local C_TransmogCollection_GetAppearanceSourceInfo = C_TransmogCollection and C_TransmogCollection.GetAppearanceSourceInfo
local C_TransmogCollection_GetIllusionStrings = C_TransmogCollection and C_TransmogCollection.GetIllusionStrings

local PANEL_DEFAULT_WIDTH = PANEL_DEFAULT_WIDTH
local ClassSymbolFrame
local CharacterText --check character text

local InCombatLockdown = InCombatLockdown
local EquipmentManager_UnequipItemInSlot = EquipmentManager_UnequipItemInSlot
local EquipmentManager_RunAction = EquipmentManager_RunAction

local function UnequipItemInSlot(i)
	if InCombatLockdown() then return end
	local action = EquipmentManager_UnequipItemInSlot(i)
	EquipmentManager_RunAction(action)
end

function module:UpdatePaperDoll()
	module.db = E.db.mui.armory
	if not module.db.character.enable then return end

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
			frame.Gradiation:Hide()
			frame.Transmog:Hide()
			frame.Transmog.Link = nil
			frame.Illusion:Hide()
			frame.Illusion.Link = nil

			itemLink = GetInventoryItemLink(unit, slot)
			if (itemLink and itemLink ~= nil) then
				if type(itemLink) ~= "string" then return end

				local _, _, itemRarity, _, _, _, _, _, _, _, _, _, _, _, _, setID = GetItemInfo(itemLink)

				-- Durability
				if module.db.character.durability.enable then
					frame.DurabilityInfo:SetText()
					current, maximum = GetInventoryItemDurability(slot)
					if current and maximum and (not module.db.character.durability.onlydamaged or current < maximum) then
						r, g, b = E:ColorGradient((current / maximum), 1, 0, 0, 1, 1, 0, 0, 1, 0)
						frame.DurabilityInfo:SetFormattedText("%s%.0f%%|r", E:RGBToHex(r, g, b), (current / maximum) * 100)
					end
				end

				-- Gradiation
				if module.db.character.gradient.enable then
					frame.Gradiation:Show()
					if module.db.character.gradient.setArmor and setID then
						frame.Gradiation.Texture:SetVertexColor(F.unpackColor(module.db.character.gradient.setArmorColor))
					elseif itemRarity and module.db.character.gradient.colorStyle == "RARITY" then
						r, g, b = GetItemQualityColor(itemRarity)
						frame.Gradiation.Texture:SetVertexColor(r, g, b)
					elseif module.db.character.gradient.colorStyle == "VALUE" then
						frame.Gradiation.Texture:SetVertexColor(unpack(E.media.rgbvaluecolor))
					else
						frame.Gradiation.Texture:SetVertexColor(F.unpackColor(module.db.character.gradient.color))
					end
				end

				-- Transmog
				if module.db.character.transmog.enable then
					local transmogLocation = TransmogUtil.GetTransmogLocation((frame.ID), Enum.TransmogType.Appearance, Enum.TransmogModification.Main)

					if not (slot == 2 or slot == 11 or slot == 12 or slot == 13 or slot == 14 or slot == 18) and C_Transmog_GetSlotInfo(transmogLocation) then
						frame.Transmog:Show()
						frame.Transmog.Link = select(6, C_TransmogCollection_GetAppearanceSourceInfo(select(3, C_Transmog_GetSlotVisualInfo(transmogLocation))))
					end
				end

				-- Illussion
				if module.db.character.illusion.enable then
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
	self:BuildCharacter()

	-- update player info
	self:ScheduleTimer("UpdatePaperDoll", 5)

	initialized = true
end

function module:BuildCharacter()
	module.db = E.db.mui.armory

	for id, slotName in pairs(module.Constants.slotIDs) do
		if not id then return end
		local frame = _G["Character"..module.Constants.slotIDs[id]]
		local slotHeight = frame:GetHeight()

		if not frame.DurabilityInfo then
			-- Durability
			frame.DurabilityInfo = frame:CreateFontString(nil, "OVERLAY")
			frame.DurabilityInfo:Point("TOP", frame, "TOP", 0, -2)
			frame.DurabilityInfo:FontTemplate(LSM:Fetch("font", module.db.character.durability.font), module.db.character.durability.textSize, module.db.character.durability.fontOutline)
		end

		if not frame.Gradiation then
			-- Gradiation
			frame.Gradiation = CreateFrame('Frame', nil, frame)
			frame.Gradiation:Size(120, slotHeight + 4)
			frame.Gradiation:SetFrameLevel(_G["CharacterModelScene"]:GetFrameLevel() - 1)

			frame.Gradiation.Texture = frame.Gradiation:CreateTexture(nil, "OVERLAY")
			frame.Gradiation.Texture:SetInside()
			frame.Gradiation.Texture:SetTexture(module.Constants.Gradiation)

			if id <= 7 or id == 17 or id == 11 then -- Left Size
				frame.Gradiation:Point("LEFT", _G["Character"..slotName], "RIGHT", - _G["Character"..slotName]:GetWidth()-4, 0)
				frame.Gradiation.Texture:SetTexCoord(0, 1, 0, 1)
			elseif id <= 16 then -- Right Side
				frame.Gradiation:Point("RIGHT", _G["Character"..slotName], "LEFT", _G["Character"..slotName]:GetWidth()+4, 0)
				frame.Gradiation.Texture:SetTexCoord(1, 0, 0, 1)
			end

			if module.db.character.expandSize then
				frame.Gradiation:Size(160, slotHeight + 4)
				if id == 18 then
					frame.Gradiation:Point("RIGHT", _G["Character"..slotName], "LEFT", _G["Character"..slotName]:GetWidth()+4, 0)
					frame.Gradiation.Texture:SetTexCoord(1, 0, 0, 1)
				elseif id == 19 then
					frame.Gradiation:Point("LEFT", _G["Character"..slotName], "RIGHT", - _G["Character"..slotName]:GetWidth()-4, 0)
					frame.Gradiation.Texture:SetTexCoord(0, 1, 0, 1)
				end
			end
		end

		if not frame.Warning then
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
			frame.Warning.Texture:SetTexture(module.Constants.WarningTexture)
			frame.Warning.Texture:SetVertexColor(1, 0, 0)

			frame.Warning:SetScript("OnEnter", self.Warning_OnEnter)
			frame.Warning:SetScript("OnLeave", self.Tooltip_OnLeave)
			frame.Warning:Hide()
		end

		if not frame.Transmog then
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
		end

		if not frame.Illusion then
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
	end

	for _, SlotName in pairs(module.Constants.gearList) do
		local Slot = _G["Character"..SlotName]
		Slot.ID = GetInventorySlotInfo(SlotName)

		-- Gems
		for t = 1, module.Constants.maxGemSlots do
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
		if E.db.mui.armory.character.enable and E.db.mui.armory.character.expandSize and _G["PaperDollFrame"]:IsShown() then
			_G["CharacterFrame"]:SetWidth(448)
		end
	end)
	hooksecurefunc("CharacterFrame_Expand", function()
		if E.db.mui.armory.character.enable and E.db.mui.armory.character.expandSize and _G["PaperDollFrame"]:IsShown() then
			_G["CharacterFrame"]:SetWidth(650)
		end
	end)
	hooksecurefunc("CharacterFrame_ShowSubFrame", function(frameName)
		if not E.db.mui.armory.character.enable and not E.db.mui.armory.character.expandSize then return end
		if frameName == "PaperDollFrame" or frameName == "PetPaperDollFrame" then return end
		if _G["CharacterFrame"]:GetWidth() > PANEL_DEFAULT_WIDTH + 1 then
			_G["CharacterFrame"]:SetWidth(PANEL_DEFAULT_WIDTH)
		end
	end)

	-- Adjust a bit the Model Size
	if _G["CharacterModelScene"]:GetHeight() == 320 then
		_G["CharacterModelScene"]:ClearAllPoints()
		_G["CharacterModelScene"]:Point('TOPLEFT', _G["CharacterHeadSlot"])
		_G["CharacterModelScene"]:Point('RIGHT', _G["CharacterHandsSlot"])
		_G["CharacterModelScene"]:Point('BOTTOM', _G["CharacterMainHandSlot"])
	end
end

function module:ExpandSize()
	if not module.db.character.expandSize then
		return
	end

	_G.CharacterFrame:SetHeight(470)
	_G.CharacterHandsSlot:SetPoint('TOPRIGHT', _G.CharacterFrameInsetRight, 'TOPLEFT', -4, -2)
	_G.CharacterMainHandSlot:SetPoint('BOTTOMLEFT', _G.PaperDollItemsFrame, 'BOTTOMLEFT', 185, 14)

	_G.CharacterModelScene:ClearAllPoints()
	_G.CharacterModelScene:SetPoint('TOPLEFT', _G.CharacterHeadSlot, 0, 5)
	_G.CharacterModelScene:SetPoint('RIGHT', _G.CharacterHandsSlot)
	_G.CharacterModelScene:SetPoint('BOTTOM', _G.CharacterMainHandSlot)

	if _G.PaperDollFrame:IsShown() then --Setting up width for the main frame
		_G.CharacterFrame:SetWidth(_G.CharacterFrame.Expanded and 650 or 444)
		_G.CharacterFrameInsetRight:SetPoint('TOPLEFT', _G.CharacterFrameInset, 'TOPRIGHT', 110, 0)
	end

	if _G.CharacterModelScene and _G.CharacterModelScene.BackgroundTopLeft and _G.CharacterModelScene.BackgroundTopLeft:IsShown() then
		_G.CharacterModelScene.BackgroundTopLeft:Hide()
		_G.CharacterModelScene.BackgroundTopRight:Hide()
		_G.CharacterModelScene.BackgroundBotLeft:Hide()
		_G.CharacterModelScene.BackgroundBotRight:Hide()

		if _G.CharacterModelScene.backdrop then
			_G.CharacterModelScene.backdrop:Hide()
		end
	end

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

local function StatsPane(type)
	_G.CharacterStatsPane[type]:StripTextures()

	if _G.CharacterStatsPane[type] and _G.CharacterStatsPane[type].backdrop then
		_G.CharacterStatsPane[type].backdrop:Hide()
	end
end

local function CharacterStatFrameCategoryTemplate(frame)
	module.db = E.db.mui.armory

	frame:StripTextures()

	local r, g, b
	if module.db.stats.classColorGradient then
		r, g, b = F.r, F.g, F.b
	else
		r, g, b = F.unpackColor(module.db.stats.color)
	end

	local bg = frame.Background
	bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
	bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
	bg:ClearAllPoints()
	bg:SetPoint("CENTER", 0, -5)
	bg:SetSize(210, 30)
	bg:SetVertexColor(r, g, b)
end

-- Copied from ElvUI
local function ColorizeStatPane(frame)
	module.db = E.db.mui.armory

	if frame.leftGrad then
		frame.leftGrad:StripTextures()
	end
	if frame.rightGrad then
		frame.rightGrad:StripTextures()
	end

	local r, g, b
	if module.db.stats.classColorGradient then
		r, g, b = F.r, F.g, F.b
	else
		r, g, b = F.unpackColor(module.db.stats.color)
	end

	frame.leftGrad = frame:CreateTexture(nil, "BORDER")
	frame.leftGrad:SetWidth(80)
	frame.leftGrad:SetHeight(frame:GetHeight())
	frame.leftGrad:SetPoint("LEFT", frame, "CENTER")
	frame.leftGrad:SetTexture(E.media.blankTex)
	frame.leftGrad:SetGradient("Horizontal", CreateColor(r, g, b, 0.75), CreateColor(r, g, b, 0))

	frame.rightGrad = frame:CreateTexture(nil, "BORDER")
	frame.rightGrad:SetWidth(80)
	frame.rightGrad:SetHeight(frame:GetHeight())
	frame.rightGrad:SetPoint("RIGHT", frame, "CENTER")
	frame.rightGrad:SetTexture(E.media.blankTex)
	frame.rightGrad:SetGradient("Horizontal", CreateColor(r, g, b, 0), CreateColor(r, g, b, 0.75))
end

local function SkinAdditionalStats()
	module.db = E.db.mui.armory

	if CharacterStatsPane.OffenseCategory then
		if module.db.stats.classColorGradient then
			CharacterStatsPane.OffenseCategory.Title:SetText(E:TextGradient(CharacterStatsPane.OffenseCategory.Title:GetText(), F.ClassGradient[E.myclass]["r1"], F.ClassGradient[E.myclass]["g1"], F.ClassGradient[E.myclass]["b1"], F.ClassGradient[E.myclass]["r2"], F.ClassGradient[E.myclass]["g2"], F.ClassGradient[E.myclass]["b2"]))
		else
			CharacterStatsPane.OffenseCategory.Title:SetTextColor(F.unpackColor(module.db.stats.color))
		end
		StatsPane("OffenseCategory")
		CharacterStatFrameCategoryTemplate(CharacterStatsPane.OffenseCategory)
	end

	if CharacterStatsPane.DefenseCategory then
		if module.db.stats.classColorGradient then
			CharacterStatsPane.DefenseCategory.Title:SetText(E:TextGradient(CharacterStatsPane.DefenseCategory.Title:GetText(), F.ClassGradient[E.myclass]["r1"], F.ClassGradient[E.myclass]["g1"], F.ClassGradient[E.myclass]["b1"], F.ClassGradient[E.myclass]["r2"], F.ClassGradient[E.myclass]["g2"], F.ClassGradient[E.myclass]["b2"]))
		else
			CharacterStatsPane.DefenseCategory.Title:SetTextColor(F.unpackColor(module.db.stats.color))
		end
		StatsPane("DefenseCategory")
		CharacterStatFrameCategoryTemplate(CharacterStatsPane.DefenseCategory)
	end
end

function module:SkinCharacterStatsPane()
	module.db = E.db.mui.armory
	if not module.db.character.enable then return end

	local CharacterStatsPane = _G.CharacterStatsPane

	_G.CharacterModelScene:DisableDrawLayer("BACKGROUND")
	_G.CharacterModelScene:DisableDrawLayer("BORDER")
	_G.CharacterModelScene:DisableDrawLayer("OVERLAY")

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
	if not module.db.character.classIcon then
		return
	end

	local CharacterFrameTitleText = _G.CharacterFrameTitleText
	local CharacterLevelText = _G.CharacterLevelText

	-- Class Icon Holder
	local ClassIconHolder = CreateFrame("Frame", "MER_ClassIcon", _G.PaperDollFrame)
	ClassIconHolder:SetSize(20, 20)

	local ClassIconTexture = ClassIconHolder:CreateTexture()
	ClassIconTexture:SetAllPoints(ClassIconHolder)

	CharacterLevelText:SetWidth(300)

	ClassSymbolFrame = ("|T"..(MER.ClassIcons[E.myclass]..".tga:0:0:0:0|t"))

	hooksecurefunc('PaperDollFrame_SetLevel', function()
		CharacterFrameTitleText:ClearAllPoints()
		CharacterFrameTitleText:SetPoint('TOP', _G.CharacterModelScene, 0, 50)
		CharacterFrameTitleText:SetParent(_G.CharacterFrame)
		CharacterFrameTitleText:SetFont(E.LSM:Fetch('font', E.db.general.font), E.db.general.fontSize+2, E.db.general.fontStyle)

		CharacterLevelText:ClearAllPoints()
		CharacterLevelText:SetPoint('TOP', CharacterFrameTitleText, 'BOTTOM', 0, 0)
		CharacterLevelText:SetDrawLayer("OVERLAY")
	end)

	local titleText, coloredTitleText

	local function colorTitleText()
		CharacterText = CharacterFrameTitleText:GetText()
		coloredTitleText = E:TextGradient(CharacterText, F.ClassGradient[E.myclass]["r1"], F.ClassGradient[E.myclass]["g1"], F.ClassGradient[E.myclass]["b1"], F.ClassGradient[E.myclass]["r2"], F.ClassGradient[E.myclass]["g2"], F.ClassGradient[E.myclass]["b2"])
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

	hooksecurefunc(_G.CharacterFrame, "SetTitle", function()
		colorTitleText()
	end)

	if E.db.general.itemLevel.displayCharacterInfo then
		M:UpdatePageInfo(_G.CharacterFrame, "Character")
	end
end

local function UnequipItemInSlot(i)
	local action = EquipmentManager_UnequipItemInSlot(i)
	EquipmentManager_RunAction(action)
end

function module:UndressButton()
	if not E.db.mui.armory.character.undressButton then return end

	local button = CreateFrame("Button", nil, _G.CharacterFrameInsetRight)
	button:SetSize(34, 38)
	button:SetPoint("RIGHT", _G.PaperDollSidebarTab1, "LEFT", -4, 0)
	F.PixelIcon(button, "Interface\\ICONS\\SPELL_SHADOW_TWISTEDFAITH", true)
	F.AddTooltip(button, "ANCHOR_TOPRIGHT", L["Double Click to Undress"], 'WHITE')

	button:SetScript("OnDoubleClick", function()
		for i = 1, 17 do
			local texture = GetInventoryItemTexture("player", i)
			if texture then
				UnequipItemInSlot(i)
			end
		end
	end)
end

function module:LoadAndSetupCharacter()
	if not E.db.mui.armory.character.enable or not E.db.general.itemLevel.displayCharacterInfo then
		return
	end

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "InitialUpdatePaperDoll")
	self:SkinCharacterStatsPane()
	self:ExpandSize()
	self:AddCharacterIcon()
	self:UndressButton()
end
