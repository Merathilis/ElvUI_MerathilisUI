local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local pairs, select, unpack = pairs, select, unpack

local hooksecurefunc = hooksecurefunc
local C_TransmogCollection_GetSourceInfo = C_TransmogCollection.GetSourceInfo

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function reskinFrameButton(self)
	for i = 1, self.ScrollTarget:GetNumChildren() do
		local child = select(i, self.ScrollTarget:GetChildren())
		if not child.MERSkin then
			if child then
				module:CreateGradient(child)
			end

			child.MERSkin = true
		end
	end
end

local function LoadSkin()
	if not module:CheckDB("collections", "collections") then
		return
	end

	local CollectionsJournal = _G.CollectionsJournal

	CollectionsJournal:Styling()
	module:CreateShadow(CollectionsJournal)

	for i = 1, 5 do
		module:ReskinTab(_G["CollectionsJournalTab" .. i])
	end

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

	MountJournal.MountCount:SetTemplate('Transparent')
	PetJournal.PetCount:SetTemplate('Transparent')
	MountJournal.MountDisplay.ModelScene:SetTemplate('Transparent')

	-- Mount list
	hooksecurefunc(MountJournal.ScrollBox, "Update", reskinFrameButton)

	-- Pet list
	hooksecurefunc(PetJournal.ScrollBox, "Update", reskinFrameButton)

	_G.PetJournalHealPetButtonBorder:Hide()
	_G.PetJournalHealPetButtonIconTexture:SetTexCoord(unpack(E.TexCoords))
	PetJournal.HealPetButton:SetPushedTexture("")
	PetJournal.HealPetButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

	do
		local ic = MountJournal.MountDisplay.InfoButton.Icon
		ic:SetTexCoord(unpack(E.TexCoords))
		module:CreateBG(ic)
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
	card.PetInfo.icon.bg = module:CreateBG(card.PetInfo.icon)

	card:SetTemplate('Transparent')

	for i = 2, 12 do
		select(i, card.xpBar:GetRegions()):Hide()
	end

	module:CreateBDFrame(card.xpBar, .25)

	for i = 1, 6 do
		local bu = card["spell" .. i]
		module:ReskinIcon(bu.icon)
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
		bu.icon.bg = module:CreateBDFrame(bu.icon, .25)

		bu.setButton:GetRegions():SetPoint("TOPLEFT", bu.icon, -5, 5)
		bu.setButton:GetRegions():SetPoint("BOTTOMRIGHT", bu.icon, 5, -5)

		bu:SetTemplate('Transparent')

		hooksecurefunc(bu.qualityBorder, "SetVertexColor", function(_, r, g, b)
			bu.name:SetTextColor(r, g, b)
		end)

		for i = 2, 12 do
			select(i, bu.xpBar:GetRegions()):Hide()
		end

		bu.xpBar:SetStatusBarTexture(E["media"].normTex)
		module:CreateBDFrame(bu.xpBar, .25)

		_G["PetJournalLoadoutPet" .. i .. "HealthFramehealthStatusBarLeft"]:Hide()
		_G["PetJournalLoadoutPet" .. i .. "HealthFramehealthStatusBarRight"]:Hide()
		_G["PetJournalLoadoutPet" .. i .. "HealthFramehealthStatusBarMiddle"]:Hide()
		_G["PetJournalLoadoutPet" .. i .. "HealthFramehealthStatusBarBGMiddle"]:Hide()

		bu.healthFrame.healthBar:SetStatusBarTexture(E["media"].normTex)
		module:CreateBDFrame(bu.healthFrame.healthBar, .25)

		for j = 1, 3 do
			local spell = bu["spell" .. j]

			spell:SetPushedTexture("")
			spell:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			spell:GetRegions():Hide()

			spell.icon:SetTexCoord(unpack(E.TexCoords))
			module:CreateBG(spell.icon)
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
		module:ReskinIcon(button.iconTexture)
		module:ReskinIcon(button.iconTextureUncollected)

		button.name:SetPoint("LEFT", button, "RIGHT", 9, 0)

		local bg = module:CreateBDFrame(button, .25)
		bg:SetPoint("TOPLEFT", button, "TOPRIGHT", 0, -2)
		bg:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT", 0, 2)
		bg:SetPoint("RIGHT", button.name, "RIGHT", 0, 0)
		module:CreateGradient(bg)
	end

	-- [[ Heirlooms ]]
	local HeirloomsJournal = _G.HeirloomsJournal

	-- Progress bar
	local progressBar = HeirloomsJournal.progressBar
	progressBar.text:SetPoint("CENTER", 0, 1)

	hooksecurefunc(HeirloomsJournal, "UpdateButton", function(_, button)
		if not button.__MERSkin then
			local bg = module:CreateBDFrame(button)
			bg:SetPoint("TOPLEFT", button, "TOPRIGHT", 0, -2)
			bg:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT", 0, 2)
			bg:SetPoint("RIGHT", button.name, "RIGHT", 2, 0)
			module:CreateGradient(bg)
			button.__MERSkin = true
		end
	end)

	-- Header
	hooksecurefunc(HeirloomsJournal, "LayoutCurrentPage", function()
		for i = 1, #HeirloomsJournal.heirloomHeaderFrames do
			local header = HeirloomsJournal.heirloomHeaderFrames[i]
			if not header.__MERSkin then
				header.text:SetTextColor(1, 1, 1)
				header.text:FontTemplate(E["media"].normFont, 16, "OUTLINE")

				header.__MERSkin = true
			end
		end
	end)

	-- [[ WardrobeCollectionFrame ]]
	local WardrobeCollectionFrame = _G.WardrobeCollectionFrame
	local ItemsCollectionFrame = WardrobeCollectionFrame.ItemsCollectionFrame

	-- Progress bar
	local progressBar = WardrobeCollectionFrame.progressBar
	progressBar.text:SetPoint("CENTER", 0, 1)

	-- ItemSetsCollection
	local SetsCollectionFrame = WardrobeCollectionFrame.SetsCollectionFrame
	module:CreateBDFrame(SetsCollectionFrame.Model, .25)

	local DetailsFrame = SetsCollectionFrame.DetailsFrame
	DetailsFrame.ModelFadeTexture:Hide()
	DetailsFrame.IconRowBackground:Hide()

	hooksecurefunc(SetsCollectionFrame, "SetItemFrameQuality", function(_, itemFrame)
		local ic = itemFrame.Icon
		if not ic.bg then
			ic:SetTexCoord(unpack(E.TexCoords))
			itemFrame.IconBorder:Hide()
			itemFrame.IconBorder.Show = MER.dummy
			ic.bg = module:CreateBDFrame(ic)
		end

		if itemFrame.collected then
			local quality = C_TransmogCollection_GetSourceInfo(itemFrame.sourceID).quality
			local color = _G.BAG_ITEM_QUALITY_COLORS[quality or 1]
			ic.bg:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			ic.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end)

	-- [[ Wardrobe ]]
	local WardrobeFrame = _G.WardrobeFrame
	local WardrobeTransmogFrame = _G.WardrobeTransmogFrame
	WardrobeFrame:Styling()

	module:CreateBDFrame(_G.WardrobeOutfitFrame, .25)

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
			module:ReskinIcon(slot.Icon)
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

	-- Change the Transmog Frame Size
	WardrobeFrame:SetWidth(1200)

	WardrobeTransmogFrame:SetWidth(530)
	WardrobeTransmogFrame:SetHeight(WardrobeFrame:GetHeight() -130)
	WardrobeTransmogFrame:SetPoint("TOP", WardrobeFrame, 0, 0)
	WardrobeTransmogFrame.ModelScene:ClearAllPoints()
	WardrobeTransmogFrame.ModelScene:SetPoint("TOP", WardrobeTransmogFrame, "TOP", 20, 10)
	WardrobeTransmogFrame.ModelScene:SetAllPoints(WardrobeTransmogFrame)

	_G.WardrobeOutfitDropDown:ClearAllPoints()
	_G.WardrobeOutfitDropDown:SetPoint("TOPLEFT", WardrobeTransmogFrame, "TOPLEFT", 0, 50)

	WardrobeTransmogFrame.HeadButton:ClearAllPoints()
	WardrobeTransmogFrame.HeadButton:SetPoint("TOPLEFT", WardrobeTransmogFrame, "TOPLEFT", 20, 0)

	WardrobeTransmogFrame.ShoulderButton:ClearAllPoints()
	WardrobeTransmogFrame.ShoulderButton:SetPoint("TOP", WardrobeTransmogFrame.HeadButton, "TOP", 0, -55)

	WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox:ClearAllPoints()
	WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox:SetPoint("BOTTOM", WardrobeCollectionFrame, "BOTTOM", -240, 40)

	WardrobeTransmogFrame.HandsButton:ClearAllPoints()
	WardrobeTransmogFrame.HandsButton:SetPoint("TOP", WardrobeTransmogFrame, "TOP", 240, -120)

	WardrobeTransmogFrame.MainHandButton:ClearAllPoints()
	WardrobeTransmogFrame.MainHandButton:SetPoint("TOP", WardrobeTransmogFrame, "BOTTOM", -50, 50)

	WardrobeTransmogFrame.SecondaryHandButton:ClearAllPoints()
	WardrobeTransmogFrame.SecondaryHandButton:SetPoint("TOP", WardrobeTransmogFrame, "BOTTOM", 50, 50)

	WardrobeTransmogFrame.MainHandEnchantButton:ClearAllPoints()
	WardrobeTransmogFrame.MainHandEnchantButton:SetPoint("BOTTOM", WardrobeTransmogFrame.MainHandButton, "BOTTOM", 0, -28)
	WardrobeTransmogFrame.SecondaryHandEnchantButton:ClearAllPoints()
	WardrobeTransmogFrame.SecondaryHandEnchantButton:SetPoint("BOTTOM", WardrobeTransmogFrame.SecondaryHandButton, "BOTTOM", 0, -28)

	WardrobeTransmogFrame.SpecButton:ClearAllPoints()
	WardrobeTransmogFrame.SpecButton:SetPoint("RIGHT", WardrobeTransmogFrame.ApplyButton, "LEFT", -3, 0)
end

S:AddCallbackForAddon("Blizzard_Collections", LoadSkin)
