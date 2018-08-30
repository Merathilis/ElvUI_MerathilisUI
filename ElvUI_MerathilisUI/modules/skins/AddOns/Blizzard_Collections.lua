local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local PlayerHasToy = PlayerHasToy

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function styleCollections()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.collections ~= true or E.private.muiSkins.blizzard.collections ~= true then return end

	local CollectionsJournal = _G["CollectionsJournal"]
	CollectionsJournal:Styling()

	-- [[ General ]]
	for i = 1, 14 do
		if i ~= 8 then
			select(i, CollectionsJournal:GetRegions()):Hide()
		end
	end

	CollectionsJournalTab2:SetPoint("LEFT", CollectionsJournalTab1, "RIGHT", -15, 0)
	CollectionsJournalTab3:SetPoint("LEFT", CollectionsJournalTab2, "RIGHT", -15, 0)
	CollectionsJournalTab4:SetPoint("LEFT", CollectionsJournalTab3, "RIGHT", -15, 0)
	CollectionsJournalTab5:SetPoint("LEFT", CollectionsJournalTab4, "RIGHT", -15, 0)

	-- [[ Mounts and pets ]]
	local PetJournal = _G["PetJournal"]
	local MountJournal = _G["MountJournal"]

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
	PetJournalTutorialButton.Ring:Hide()

	MERS:CreateBD(MountJournal.MountCount, .25)
	MERS:CreateBD(PetJournal.PetCount, .25)
	MERS:CreateBD(MountJournal.MountDisplay.ModelScene, .25)

	local scrollFrames = {MountJournal.ListScrollFrame.buttons, PetJournal.listScroll.buttons}
	for _, scrollFrame in pairs(scrollFrames) do
		for i = 1, #scrollFrame do
			local bu = scrollFrame[i]
			local ic = bu.icon

			bu:GetRegions():Hide()
			bu:SetHighlightTexture("")
			bu.iconBorder:SetTexture("")
			bu.selectedTexture:SetTexture("")

			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT", 0, -1)
			bg:SetPoint("BOTTOMRIGHT", 0, 1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			MERS:CreateBD(bg, .25)
			bu.bg = bg

			ic:SetTexCoord(unpack(E.TexCoords))
			ic.bg = MERS:CreateBG(ic)

			bu.name:SetParent(bg)

			if bu.DragButton then
				bu.DragButton.ActiveTexture:SetTexture(E["media"].normTex)
				bu.DragButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
				bu.DragButton:GetHighlightTexture():SetAllPoints(ic)
			else
				bu.dragButton.ActiveTexture:SetTexture(E["media"].normTex)
				bu.dragButton.levelBG:SetAlpha(0)
				bu.dragButton.level:SetFontObject(GameFontNormal)
				bu.dragButton.level:SetTextColor(1, 1, 1)
				bu.dragButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
				bu.dragButton:GetHighlightTexture():SetAllPoints(ic)
			end
		end
	end

	local function updateMountScroll()
		local buttons = MountJournal.ListScrollFrame.buttons
		for i = 1, #buttons do
			local bu = buttons[i]
			if bu.bg then
				if bu.index ~= nil then
					bu.bg:Show()
					bu.icon:Show()
					bu.icon.bg:Show()

					if bu.selectedTexture:IsShown() then
						bu.bg:SetBackdropColor(r, g, b, .25)
					else
						bu.bg:SetBackdropColor(0, 0, 0, .25)
					end
				else
					bu.bg:Hide()
					bu.icon:Hide()
					bu.icon.bg:Hide()
				end
			end
		end
	end

	hooksecurefunc("MountJournal_UpdateMountList", updateMountScroll)
	hooksecurefunc(MountJournalListScrollFrame, "update", updateMountScroll)

	local function updatePetScroll()
		local petButtons = PetJournal.listScroll.buttons
		if petButtons then
			for i = 1, #petButtons do
				local bu = petButtons[i]

				local index = bu.index
				if index then
					if bu.selectedTexture:IsShown() then
						bu.bg:SetBackdropColor(r, g, b, .25)
					else
						bu.bg:SetBackdropColor(0, 0, 0, .25)
					end
				end
			end
		end
	end

	hooksecurefunc("PetJournal_UpdatePetList", updatePetScroll)
	hooksecurefunc(PetJournalListScrollFrame, "update", updatePetScroll)

	PetJournalHealPetButtonBorder:Hide()
	PetJournalHealPetButtonIconTexture:SetTexCoord(unpack(E.TexCoords))
	PetJournal.HealPetButton:SetPushedTexture("")
	PetJournal.HealPetButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

	do
		local ic = MountJournal.MountDisplay.InfoButton.Icon
		ic:SetTexCoord(unpack(E.TexCoords))
		MERS:CreateBG(ic)
	end

	PetJournalLoadoutBorderSlotHeaderText:SetParent(PetJournal)
	PetJournalLoadoutBorderSlotHeaderText:SetPoint("CENTER", PetJournalLoadoutBorderTop, "TOP", 0, 4)

	PetJournalSummonRandomFavoritePetButtonBorder:Hide()
	PetJournalSummonRandomFavoritePetButtonIconTexture:SetTexCoord(unpack(E.TexCoords))
	PetJournalSummonRandomFavoritePetButton:SetPushedTexture("")
	PetJournalSummonRandomFavoritePetButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

	-- Favourite mount button
	MountJournalSummonRandomFavoriteButtonBorder:Hide()
	MountJournalSummonRandomFavoriteButtonIconTexture:SetTexCoord(unpack(E.TexCoords))
	MountJournalSummonRandomFavoriteButton:SetPushedTexture("")
	MountJournalSummonRandomFavoriteButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

	-- Pet card
	local card = PetJournalPetCard

	PetJournalPetCardBG:Hide()
	card.PetInfo.levelBG:SetAlpha(0)
	card.PetInfo.qualityBorder:SetAlpha(0)
	card.AbilitiesBG1:SetAlpha(0)
	card.AbilitiesBG2:SetAlpha(0)
	card.AbilitiesBG3:SetAlpha(0)

	card.PetInfo.level:SetFontObject(GameFontNormal)
	card.PetInfo.level:SetTextColor(1, 1, 1)

	card.PetInfo.icon:SetTexCoord(unpack(E.TexCoords))
	card.PetInfo.icon.bg = MERS:CreateBG(card.PetInfo.icon)

	MERS:CreateBD(card, .25)

	for i = 2, 12 do
		select(i, card.xpBar:GetRegions()):Hide()
	end

	MERS:CreateBDFrame(card.xpBar, .25)

	for i = 1, 6 do
		local bu = card["spell"..i]
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
		local bu = PetJournal.Loadout["Pet"..i]

		_G["PetJournalLoadoutPet"..i.."BG"]:Hide()

		bu.iconBorder:SetAlpha(0)
		bu.qualityBorder:SetTexture("")
		bu.levelBG:SetAlpha(0)
		bu.helpFrame:GetRegions():Hide()
		bu.dragButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

		bu.level:SetFontObject(GameFontNormal)
		bu.level:SetTextColor(1, 1, 1)

		bu.icon:SetTexCoord(unpack(E.TexCoords))
		bu.icon.bg = MERS:CreateBDFrame(bu.icon, .25)

		bu.setButton:GetRegions():SetPoint("TOPLEFT", bu.icon, -5, 5)
		bu.setButton:GetRegions():SetPoint("BOTTOMRIGHT", bu.icon, 5, -5)

		MERS:CreateBD(bu, .25)

		for i = 2, 12 do
			select(i, bu.xpBar:GetRegions()):Hide()
		end

		bu.xpBar:SetStatusBarTexture(E["media"].normTex)
		MERS:CreateBDFrame(bu.xpBar, .25)

		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarLeft"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarRight"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarMiddle"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarBGMiddle"]:Hide()

		bu.healthFrame.healthBar:SetStatusBarTexture(E["media"].normTex)
		MERS:CreateBDFrame(bu.healthFrame.healthBar, .25)

		for j = 1, 3 do
			local spell = bu["spell"..j]

			spell:SetPushedTexture("")
			spell:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			spell:GetRegions():Hide()

			spell.icon:SetTexCoord(unpack(E.TexCoords))
			MERS:CreateBG(spell.icon)
		end
	end

	hooksecurefunc("PetJournal_UpdatePetLoadOut", function()
		for i = 1, 3 do
			local bu = PetJournal.Loadout["Pet"..i]

			bu.icon.bg:SetShown(not bu.helpFrame:IsShown())
			bu.icon.bg:SetBackdropBorderColor(bu.qualityBorder:GetVertexColor())

			bu.dragButton:SetEnabled(not bu.helpFrame:IsShown())
		end
	end)

	PetJournal.SpellSelect.BgEnd:Hide()
	PetJournal.SpellSelect.BgTiled:Hide()

	-- [[ Toy box ]]
	local ToyBox = _G["ToyBox"]

	local icons = ToyBox.iconsFrame
	icons.Bg:Hide()
	icons.BackgroundTile:Hide()
	icons:DisableDrawLayer("BORDER")
	icons:DisableDrawLayer("ARTWORK")
	icons:DisableDrawLayer("OVERLAY")

	-- Progress bar
	local progressBar = ToyBox.progressBar
	progressBar.text:SetPoint("CENTER", 0, 1)

	-- Toys
	local shouldChangeTextColor = true

	local changeTextColor = function(toyString)
		if shouldChangeTextColor then
			shouldChangeTextColor = false

			local self = toyString:GetParent()

			if PlayerHasToy(self.itemID) then
				local _, _, quality = GetItemInfo(self.itemID)
				if quality then
					toyString:SetTextColor(GetItemQualityColor(quality))
				else
					toyString:SetTextColor(1, 1, 1)
				end
			else
				toyString:SetTextColor(.5, .5, .5)
			end

			shouldChangeTextColor = true
		end
	end

	local buttons = ToyBox.iconsFrame
	for i = 1, 18 do
		local bu = buttons["spellButton"..i]
		local ic = bu.iconTexture

		bu:SetPushedTexture("")
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		bu:GetHighlightTexture():SetAllPoints(ic)
		bu.cooldown:SetAllPoints(ic)
		bu.slotFrameCollected:SetTexture("")
		bu.slotFrameUncollected:SetTexture("")

		hooksecurefunc(bu.name, "SetTextColor", changeTextColor)
	end

	-- [[ Heirlooms ]]
	local HeirloomsJournal = _G["HeirloomsJournal"]
	local icons = HeirloomsJournal.iconsFrame
	icons.Bg:Hide()
	icons.BackgroundTile:Hide()
	icons:DisableDrawLayer("BORDER")
	icons:DisableDrawLayer("ARTWORK")
	icons:DisableDrawLayer("OVERLAY")

	hooksecurefunc(HeirloomsJournal, "UpdateButton", function(_, button)
		button.level:SetFontObject("GameFontWhiteSmall")
		button.special:SetTextColor(1, .8, 0)
	end)

	-- Progress bar
	local progressBar = HeirloomsJournal.progressBar
	progressBar.text:SetPoint("CENTER", 0, 1)

	-- Buttons
	hooksecurefunc("HeirloomsJournal_UpdateButton", function(button)
		if not button.styled then
			local ic = button.iconTexture

			button.slotFrameCollected:SetTexture("")
			button.slotFrameUncollected:SetTexture("")
			button.levelBackground:SetAlpha(0)
			button:SetPushedTexture("")
			button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			button:GetHighlightTexture():SetAllPoints(ic)

			button.iconTextureUncollected:SetTexCoord(unpack(E.TexCoords))

			button.level:ClearAllPoints()
			button.level:SetPoint("BOTTOM", 0, 1)

			local newLevelBg = button:CreateTexture(nil, "OVERLAY")
			newLevelBg:SetColorTexture(0, 0, 0, .5)
			newLevelBg:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 4, 5)
			newLevelBg:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -4, 5)
			newLevelBg:SetHeight(11)
			button.newLevelBg = newLevelBg

			button.styled = true
		end

		if button.iconTexture:IsShown() then
			button.name:SetTextColor(1, 1, 1)
			button.newLevelBg:Show()
		else
			button.name:SetTextColor(.5, .5, .5)
			button.newLevelBg:Hide()
		end
	end)

	hooksecurefunc(HeirloomsJournal, "LayoutCurrentPage", function()
		for i = 1, #HeirloomsJournal.heirloomHeaderFrames do
			local header = HeirloomsJournal.heirloomHeaderFrames[i]
			if not header.styled then
				header.text:SetTextColor(1, 1, 1)
				header.text:SetFont(E["media"].normFont, 16, "OUTLINE")

				header.styled = true
			end
		end

		for i = 1, #HeirloomsJournal.heirloomEntryFrames do
			local button = HeirloomsJournal.heirloomEntryFrames[i]

			if button.iconTexture:IsShown() then
				button.name:SetTextColor(1, 1, 1)
				button.newLevelBg:Show()
			else
				button.name:SetTextColor(.5, .5, .5)
				button.newLevelBg:Hide()
			end
		end
	end)

	-- [[ WardrobeCollectionFrame ]]
	local WardrobeCollectionFrame = _G["WardrobeCollectionFrame"]
	local ItemsCollectionFrame = WardrobeCollectionFrame.ItemsCollectionFrame

	for index = 1, 2 do
		local tab = _G["WardrobeCollectionFrameTab"..index]
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
			local tab = _G["WardrobeCollectionFrameTab"..index]
			if tabID == index then
				tab.bg:SetBackdropColor(r, g, b, .2)
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
			local quality = C_TransmogCollection.GetSourceInfo(itemFrame.sourceID).quality
			local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
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
	local WardrobeFrame = _G["WardrobeFrame"]
	local WardrobeTransmogFrame = WardrobeTransmogFrame

	WardrobeTransmogFrameBg:Hide()
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
		select(i, WardrobeOutfitFrame:GetRegions()):Hide()
	end
	MERS:CreateBDFrame(WardrobeOutfitFrame, .25)
	MERS:CreateSD(WardrobeOutfitFrame, .25)

	for i = 1, 10 do
		select(i, WardrobeTransmogFrame.Model.ClearAllPendingButton:GetRegions()):Hide()
	end
	WardrobeTransmogFrame.SpecButton:SetPoint("RIGHT", WardrobeTransmogFrame.ApplyButton, "LEFT", -3, 0)

	local slots = {"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "Back", "Shirt", "Tabard", "MainHand", "SecondaryHand"}

	for i = 1, #slots do
		local slot = WardrobeTransmogFrame.Model[slots[i].."Button"]
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
		select(i, WardrobeOutfitEditFrame:GetRegions()):Hide()
	end
	WardrobeOutfitEditFrame.Title:Show()

	for i = 2, 5 do
		select(i, WardrobeOutfitEditFrame.EditBox:GetRegions()):Hide()
	end
end

S:AddCallbackForAddon("Blizzard_Collections", "mUICollections", styleCollections)