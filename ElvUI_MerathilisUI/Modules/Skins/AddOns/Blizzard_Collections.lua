local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local pairs, select, unpack = pairs, select, unpack
--WoW API / Variables
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local PlayerHasToy = PlayerHasToy
local hooksecurefunc = hooksecurefunc
local C_TransmogCollection_GetSourceInfo = C_TransmogCollection.GetSourceInfo
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.collections ~= true or E.private.muiSkins.blizzard.collections ~= true then return end

	local CollectionsJournal = _G.CollectionsJournal
	CollectionsJournal:Styling()

	_G.CollectionsJournalTab2:SetPoint("LEFT", _G.CollectionsJournalTab1, "RIGHT", -15, 0)
	_G.CollectionsJournalTab3:SetPoint("LEFT", _G.CollectionsJournalTab2, "RIGHT", -15, 0)
	_G.CollectionsJournalTab4:SetPoint("LEFT", _G.CollectionsJournalTab3, "RIGHT", -15, 0)
	_G.CollectionsJournalTab5:SetPoint("LEFT", _G.CollectionsJournalTab4, "RIGHT", -15, 0)

	-- [[ Mounts and pets ]]
	local PetJournal = _G.PetJournal
	local MountJournal = _G.MountJournal

	for i = 1, 9 do
		select(i, MountJournal.MountCount:GetRegions()):Hide()
		select(i, PetJournal.PetCount:GetRegions()):Hide()
	end

	MountJournal.LeftInset:Hide()
	MountJournal.RightInset:Hide()
	PetJournal.LeftInset:Hide()
	PetJournal.RightInset:Hide()
	PetJournal.PetCardInset:Hide()
	PetJournal.loadoutBorder:Hide()
	MountJournal.MountDisplay.YesMountsTex:SetAlpha(0)
	MountJournal.MountDisplay.NoMountsTex:SetAlpha(0)
	MountJournal.MountDisplay.ShadowOverlay:Hide()
	_G.PetJournalTutorialButton.Ring:Hide()

	MERS:CreateBD(MountJournal.MountCount, .25)
	MERS:CreateBD(PetJournal.PetCount, .25)
	MERS:CreateBD(MountJournal.MountDisplay.ModelScene, .25)

	-- Mount list
	for _, bu in pairs(MountJournal.ListScrollFrame.buttons) do
		MERS:CreateGradient(bu.backdrop)

		bu.DragButton.ActiveTexture:SetAlpha(0)

		bu.pulseName = bu:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		bu.pulseName:SetJustifyH("LEFT")
		bu.pulseName:SetSize(147, 25)
		bu.pulseName:SetAllPoints(bu.name)
		bu.pulseName:Hide()

		bu.pulseName.anim = bu.pulseName:CreateAnimationGroup()
		bu.pulseName.anim:SetToFinalAlpha(true)

		bu.pulseName.anim.alphaout = bu.pulseName.anim:CreateAnimation("Alpha")
		bu.pulseName.anim.alphaout:SetOrder(1)
		bu.pulseName.anim.alphaout:SetFromAlpha(1)
		bu.pulseName.anim.alphaout:SetToAlpha(0)
		bu.pulseName.anim.alphaout:SetDuration(1)

		bu.pulseName.anim.alphain = bu.pulseName.anim:CreateAnimation("Alpha")
		bu.pulseName.anim.alphain:SetOrder(2)
		bu.pulseName.anim.alphain:SetFromAlpha(0)
		bu.pulseName.anim.alphain:SetToAlpha(1)
		bu.pulseName.anim.alphain:SetDuration(1)

		hooksecurefunc(bu.name, "SetText", function(self, text)
			bu.pulseName:SetText(text)
			bu.pulseName:SetTextColor(unpack(E["media"].rgbvaluecolor))
		end)

		bu:HookScript("OnUpdate", function(self)
			if self.active then
				bu.pulseName:Show()
				bu.pulseName.anim:Play()
			elseif bu.pulseName.anim:IsPlaying() then
				bu.pulseName:Hide()
				bu.pulseName.anim:Stop()
			end
		end)
	end

	-- Pet list
	for _, bu in pairs(PetJournal.listScroll.buttons) do
		MERS:CreateGradient(bu.backdrop)
	end

	_G.PetJournalHealPetButtonBorder:Hide()
	_G.PetJournalHealPetButtonIconTexture:SetTexCoord(unpack(E.TexCoords))
	PetJournal.HealPetButton:SetPushedTexture("")
	PetJournal.HealPetButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

	do
		local ic = MountJournal.MountDisplay.InfoButton.Icon
		ic:SetTexCoord(unpack(E.TexCoords))
		MERS:CreateBG(ic)
	end

	_G.PetJournalLoadoutBorderSlotHeaderText:SetParent(PetJournal)
	_G.PetJournalLoadoutBorderSlotHeaderText:SetPoint("CENTER", _G.PetJournalLoadoutBorderTop, "TOP", 0, 4)

	_G.PetJournalSummonRandomFavoritePetButtonBorder:Hide()
	_G.PetJournalSummonRandomFavoritePetButtonIconTexture:SetTexCoord(unpack(E.TexCoords))
	_G.PetJournalSummonRandomFavoritePetButton:SetPushedTexture("")
	_G.PetJournalSummonRandomFavoritePetButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

	-- Favourite mount button
	_G.MountJournalSummonRandomFavoriteButtonBorder:Hide()
	_G.MountJournalSummonRandomFavoriteButtonIconTexture:SetTexCoord(unpack(E.TexCoords))
	_G.MountJournalSummonRandomFavoriteButton:SetPushedTexture("")
	_G.MountJournalSummonRandomFavoriteButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

	-- Pet card
	local card = _G.PetJournalPetCard

	_G.PetJournalPetCardBG:Hide()
	card.PetInfo.levelBG:SetAlpha(0)
	card.PetInfo.qualityBorder:SetAlpha(0)
	card.AbilitiesBG1:SetAlpha(0)
	card.AbilitiesBG2:SetAlpha(0)
	card.AbilitiesBG3:SetAlpha(0)

	card.PetInfo.level:SetFontObject(_G.GameFontNormal)
	card.PetInfo.level:SetTextColor(1, 1, 1)

	card.PetInfo.icon:SetTexCoord(unpack(E.TexCoords))
	card.PetInfo.icon.bg = MERS:CreateBG(card.PetInfo.icon)

	MERS:CreateBD(card, .25)

	for i = 2, 12 do
		select(i, card.xpBar:GetRegions()):Hide()
	end

	MERS:CreateBDFrame(card.xpBar, .25)

	for i = 1, 6 do
		local bu = card["spell" .. i]
		MERS:ReskinIcon(bu.icon)
	end

	hooksecurefunc("PetJournal_UpdatePetCard", function(self)
		local border = self.PetInfo.qualityBorder
		local r, g, b

		if border:IsShown() then
			r, g, b = self.PetInfo.qualityBorder:GetVertexColor()
		else
			r, g, b = 0, 0, 0
		end

		self.PetInfo.icon.bg:SetVertexColor(r, g, b)
	end)

	-- Pet loadout
	for i = 1, 3 do
		local bu = _G["PetJournalLoadoutPet"..i]

		_G["PetJournalLoadoutPet" .. i .. "BG"]:Hide()

		bu.iconBorder:SetAlpha(0)
		bu.qualityBorder:SetTexture("")
		bu.levelBG:SetAlpha(0)
		bu.helpFrame:GetRegions():Hide()
		bu.dragButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

		bu.level:SetFontObject(_G.GameFontNormal)
		bu.level:SetTextColor(1, 1, 1)

		bu.icon:SetTexCoord(unpack(E.TexCoords))
		bu.icon.bg = MERS:CreateBDFrame(bu.icon, .25)

		bu.setButton:GetRegions():SetPoint("TOPLEFT", bu.icon, -5, 5)
		bu.setButton:GetRegions():SetPoint("BOTTOMRIGHT", bu.icon, 5, -5)

		MERS:CreateBD(bu, .25)

		hooksecurefunc(bu.qualityBorder, "SetVertexColor", function(_, r, g, b)
			bu.name:SetTextColor(r, g, b)
		end)

		for i = 2, 12 do
			select(i, bu.xpBar:GetRegions()):Hide()
		end

		bu.xpBar:SetStatusBarTexture(E["media"].normTex)
		MERS:CreateBDFrame(bu.xpBar, .25)

		_G["PetJournalLoadoutPet" .. i .. "HealthFramehealthStatusBarLeft"]:Hide()
		_G["PetJournalLoadoutPet" .. i .. "HealthFramehealthStatusBarRight"]:Hide()
		_G["PetJournalLoadoutPet" .. i .. "HealthFramehealthStatusBarMiddle"]:Hide()
		_G["PetJournalLoadoutPet" .. i .. "HealthFramehealthStatusBarBGMiddle"]:Hide()

		bu.healthFrame.healthBar:SetStatusBarTexture(E["media"].normTex)
		MERS:CreateBDFrame(bu.healthFrame.healthBar, .25)

		for j = 1, 3 do
			local spell = bu["spell" .. j]

			spell:SetPushedTexture("")
			spell:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			spell:GetRegions():Hide()

			spell.icon:SetTexCoord(unpack(E.TexCoords))
			MERS:CreateBG(spell.icon)
		end
	end

	hooksecurefunc("PetJournal_UpdatePetLoadOut", function()
		for i = 1, 3 do
			local bu = PetJournal.Loadout["Pet" .. i]

			bu.icon.bg:SetShown(not bu.helpFrame:IsShown())
			bu.icon.bg:SetBackdropBorderColor(bu.qualityBorder:GetVertexColor())

			bu.dragButton:SetEnabled(not bu.helpFrame:IsShown())
		end
	end)

	PetJournal.SpellSelect.BgEnd:Hide()
	PetJournal.SpellSelect.BgTiled:Hide()

	-- [[ Toy box ]]
	local ToyBox = _G.ToyBox

	-- Progress bar
	local progressBar = ToyBox.progressBar
	progressBar.text:SetPoint("CENTER", 0, 1)

	-- Toys
	for i = 1, 18 do
		local button = ToyBox.iconsFrame["spellButton" .. i]
		MERS:StyleButton(button)
		MERS:ReskinIcon(button.iconTexture)
		MERS:ReskinIcon(button.iconTextureUncollected)

		button.name:SetPoint("LEFT", button, "RIGHT", 9, 0)

		local bg = MERS:CreateBDFrame(button)
		bg:SetPoint("TOPLEFT", button, "TOPRIGHT", 0, -2)
		bg:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT", 0, 2)
		bg:SetPoint("RIGHT", button.name, "RIGHT", 0, 0)
		MERS:CreateGradient(bg)
	end

	-- [[ Heirlooms ]]
	local HeirloomsJournal = _G.HeirloomsJournal

	-- Progress bar
	local progressBar = HeirloomsJournal.progressBar
	progressBar.text:SetPoint("CENTER", 0, 1)

	hooksecurefunc(HeirloomsJournal, "UpdateButton", function(_, button)
		if not button.IsStyled then
			local bg = MERS:CreateBDFrame(button)
			bg:SetPoint("TOPLEFT", button, "TOPRIGHT", 0, -2)
			bg:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT", 0, 2)
			bg:SetPoint("RIGHT", button.name, "RIGHT", 2, 0)
			MERS:CreateGradient(bg)
			button.IsStyled = true
		end
	end)

	-- Header
	hooksecurefunc(HeirloomsJournal, "LayoutCurrentPage", function()
		for i = 1, #HeirloomsJournal.heirloomHeaderFrames do
			local header = HeirloomsJournal.heirloomHeaderFrames[i]
			if not header.IsStyled then
				header.text:SetTextColor(1, 1, 1)
				header.text:FontTemplate(E["media"].normFont, 16, "OUTLINE")

				header.IsStyled = true
			end
		end
	end)

	-- [[ WardrobeCollectionFrame ]]
	local WardrobeCollectionFrame = _G.WardrobeCollectionFrame
	local ItemsCollectionFrame = WardrobeCollectionFrame.ItemsCollectionFrame

	for index = 1, 2 do
		local tab = _G["WardrobeCollectionFrameTab" .. index]
		for i = 1, 6 do
			select(i, tab:GetRegions()):SetAlpha(0)
		end

		if tab.backdrop then
			tab.backdrop:Hide()
		end

		tab:SetHighlightTexture("")
		tab.bg = MERS:CreateBDFrame(tab, .25)
		tab.bg:SetPoint("TOPLEFT", 3, -3)
		tab.bg:SetPoint("BOTTOMRIGHT", -3, -1)
	end

	hooksecurefunc("WardrobeCollectionFrame_SetTab", function(tabID)
		for index = 1, 2 do
			local tab = _G["WardrobeCollectionFrameTab" .. index]
			if tabID == index then
				tab.bg:SetBackdropColor(r, g, b, .45)
			else
				tab.bg:SetBackdropColor(0, 0, 0, .2)
			end
		end
	end)

	-- Progress bar
	local progressBar = WardrobeCollectionFrame.progressBar
	progressBar.text:SetPoint("CENTER", 0, 1)

	-- ItemSetsCollection
	local SetsCollectionFrame = WardrobeCollectionFrame.SetsCollectionFrame
	MERS:CreateBDFrame(SetsCollectionFrame.Model, .25)

	local ScrollFrame = SetsCollectionFrame.ScrollFrame
	for i = 1, #ScrollFrame.buttons do
		local bu = ScrollFrame.buttons[i]
		bu.Background:Hide()
		bu.HighlightTexture:SetTexture("")
		MERS:ReskinIcon(bu.Icon)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetColorTexture(r, g, b, .25)
		bu.SelectedTexture:ClearAllPoints()
		bu.SelectedTexture:SetPoint("TOPLEFT", 1, -2)
		bu.SelectedTexture:SetPoint("BOTTOMRIGHT", -1, 2)
		MERS:CreateBDFrame(bu.SelectedTexture, .25)
	end

	local DetailsFrame = SetsCollectionFrame.DetailsFrame
	DetailsFrame.ModelFadeTexture:Hide()
	DetailsFrame.IconRowBackground:Hide()

	hooksecurefunc(SetsCollectionFrame, "SetItemFrameQuality", function(_, itemFrame)
		local ic = itemFrame.Icon
		if not ic.bg then
			ic:SetTexCoord(unpack(E.TexCoords))
			itemFrame.IconBorder:Hide()
			itemFrame.IconBorder.Show = MER.dummy
			ic.bg = MERS:CreateBDFrame(ic)
		end

		if itemFrame.collected then
			local quality = C_TransmogCollection_GetSourceInfo(itemFrame.sourceID).quality
			local color = _G.BAG_ITEM_QUALITY_COLORS[quality or 1]
			ic.bg:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			ic.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end)

	local SetsTransmogFrame = WardrobeCollectionFrame.SetsTransmogFrame
	for i = 1, 34 do
		select(i, SetsTransmogFrame:GetRegions()):Hide()
	end

	-- [[ Wardrobe ]]
	local WardrobeFrame = _G.WardrobeFrame
	local WardrobeTransmogFrame = _G.WardrobeTransmogFrame

	_G.WardrobeTransmogFrameBg:Hide()
	WardrobeTransmogFrame.Inset.BG:Hide()
	WardrobeTransmogFrame.Inset:DisableDrawLayer("BORDER")
	WardrobeTransmogFrame.MoneyLeft:Hide()
	WardrobeTransmogFrame.MoneyMiddle:Hide()
	WardrobeTransmogFrame.MoneyRight:Hide()

	WardrobeFrame:Styling()

	for i = 1, 9 do
		select(i, WardrobeTransmogFrame.SpecButton:GetRegions()):Hide()
	end

	for i = 1, 9 do
		select(i, _G.WardrobeOutfitFrame:GetRegions()):Hide()
	end
	MERS:CreateBDFrame(_G.WardrobeOutfitFrame, .25)

	WardrobeTransmogFrame.SpecButton:SetPoint("RIGHT", WardrobeTransmogFrame.ApplyButton, "LEFT", -3, 0)

	local slots = {
		"Head",
		"Shoulder",
		"Chest",
		"Waist",
		"Legs",
		"Feet",
		"Wrist",
		"Hands",
		"Back",
		"Shirt",
		"Tabard",
		"MainHand",
		"SecondaryHand"
	}

	for i = 1, #slots do
		local slot = WardrobeTransmogFrame.ModelScene[slots[i] .. "Button"]
		if slot then
			slot.Border:Hide()
			slot.Icon:SetDrawLayer("BACKGROUND", 1)
			MERS:ReskinIcon(slot.Icon)
			slot:SetHighlightTexture(E["media"].normTex)

			local hl = slot:GetHighlightTexture()
			hl:SetVertexColor(1, 1, 1, .25)
			hl:SetPoint("TOPLEFT", 2, -2)
			hl:SetPoint("BOTTOMRIGHT", -2, 2)
		end
	end

	-- Edit Frame
	for i = 1, 11 do
		local region = select(i, _G.WardrobeOutfitEditFrame:GetRegions())
		if region then
			region:Hide()
		end
	end
	_G.WardrobeOutfitEditFrame.Title:Show()

	for i = 2, 5 do
		select(i, _G.WardrobeOutfitEditFrame.EditBox:GetRegions()):Hide()
	end
end

S:AddCallbackForAddon("Blizzard_Collections", "mUICollections", LoadSkin)
