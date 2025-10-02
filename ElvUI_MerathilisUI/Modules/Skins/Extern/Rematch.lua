local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local MF = MER:GetModule("MER_MoveFrames") ---@type MoveFrames
local S = E:GetModule("Skins")
local LSM = E.Libs.LSM
local C = MER.Utilities.Color

local _G = _G
local next, pairs, select, unpack = next, pairs, select, unpack

local hooksecurefunc = hooksecurefunc

local function ReskinIconButton(button)
	if not button or button.__MERSkin then
		return
	end
	button:StyleButton(nil, true)

	if button.Back then
		button.Back:Kill()
	end

	if button.Border then
		button.Border:SetAlpha(0)
	end

	if button.Status then
		button.Status:SetTexture(E.media.blankTex)
		button.Status:SetVertexColor(1, 0, 0, 0.3)
	end

	if button.Texture then
		button.Texture:SetTexCoord(unpack(E.TexCoords))
	end

	if button.Icon then
		button.Icon:CreateBackdrop()
	end

	if button.IconBorder then
		button.IconBorder:Hide()
	end

	if button.Selected then
		button.Selected:SetTexture(E.media.blankTex)
		button.Selected:SetVertexColor(1, 1, 1, 0.3)
	end

	if button.hover and button.Icon then
		button.hover:ClearAllPoints()
		button.hover:SetAllPoints(button.Icon)
	end

	if button.Cooldown then
		E:RegisterCooldown(button.Cooldown)
	end

	button.__MERSkin = true
end

local function ReskinCloseButton(button)
	if not button then
		return
	end

	S:HandleCloseButton(button)
	button.Icon = E.noop
	button.SetNormalTexture = E.noop
	button.SetPushedTexture = E.noop
	button.SetHighlightTexture = E.noop
end

local function ClearTextureButton(button, icon)
	if not button then
		return
	end
	if icon then
		icon = button.Icon:GetTexture()
	else
		button.Icon = E.noop
	end

	button:StripTextures()
	button.SetNormalTexture = E.noop
	button.SetPushedTexture = E.noop
	button.SetHighlightTexture = E.noop
	button.Icon:SetTexture(icon)
end

---Reskin the Rematch button
---@param button Button
local function ReskinButton(button)
	if button.Back then
		if button.Back.IsObjectType and button.Back:IsObjectType("Texture") then
			button.Back:Kill()
		elseif type(button.Back) == "table" then
			for _, tex in pairs(button.Back) do
				tex:Kill()
			end
		end
	end

	if button.Highlight then
		if button.Highlight.IsObjectType and button.Highlight:IsObjectType("Texture") then
			button.Highlight:Kill()
		elseif type(button.Highlight) == "table" then
			for _, tex in pairs(button.Highlight) do
				tex:Kill()
			end
		end
	end

	module:Proxy("HandleButton", button)
end

local function ReskinToggleButton(button)
	if not button or button.__MERSkin then
		return
	end

	ReskinButton(button)
	F.InternalizeMethod(button.Text, "SetPoint", true)
	button.MERExpandIcon = button:CreateTexture(nil, "OVERLAY")
	button.MERExpandIcon:Point("LEFT", button, "LEFT", 7, 0)
	button.MERExpandIcon:Size(12, 12)
	hooksecurefunc(button.Back, "SetTexCoord", function(_, ...)
		if F.IsAlmost({ 0, 1, 0, 0.1875 }, { ... }) then
			button.MERExpandIcon:SetTexture(I.Media.Icons.Plus)
		elseif F.IsAlmost({ 0, 1, 0.375, 0.5625 }, { ... }) then
			button.MERExpandIcon:SetTexture(I.Media.Icons.Minus)
		end
	end)

	button.__MERSkin = true
end

local function ReskinFilterButton(button)
	if not button then
		return
	end
	ReskinButton(button)
	button.Arrow:OldSetTexture(E.Media.Textures.ArrowUp)
	button.Arrow:SetRotation(ES.ArrowRotation.right)
end

local function ReskinEditBox(editBox)
	local searchIconTex
	if editBox.SearchIcon and editBox.SearchIcon.GetTexture then
		searchIconTex = editBox.SearchIcon:GetTexture()
	end
	editBox:StripTextures()
	if searchIconTex then
		editBox.SearchIcon:SetTexture(searchIconTex)
	end

	S:HandleEditBox(editBox)
	editBox.backdrop:SetOutside(0, 0)
end

local function ReskinDropdown(dropdown) -- modified from NDui
	dropdown:SetBackdrop(nil)
	dropdown:StripTextures()
	dropdown:CreateBackdrop()
	dropdown.backdrop:SetInside(dropdown, 2, 2)
	if dropdown.Icon then
		dropdown.Icon:SetAlpha(1)
		dropdown.Icon:CreateBackdrop()
	end
	local arrow = dropdown:GetChildren()
	S:HandleNextPrevButton(arrow, "down")
end

local function ReskinScrollBar(scrollBar)
	S:HandleScrollBar(scrollBar)
	scrollBar.Thumb.backdrop:ClearAllPoints()
	scrollBar.Thumb.backdrop:Point("TOPLEFT", scrollBar.Thumb, "TOPLEFT", 3, -3)
	scrollBar.Thumb.backdrop:Point("BOTTOMRIGHT", scrollBar.Thumb, "BOTTOMRIGHT", -1, 3)

	ReskinButton(scrollBar.BottomButton)
	local tex = scrollBar.BottomButton:GetNormalTexture()
	tex:SetTexture(E.media.blankTex)
	tex:SetVertexColor(1, 1, 1, 0)

	tex = scrollBar.BottomButton:GetPushedTexture()
	tex:SetTexture(E.media.blankTex)
	tex:SetVertexColor(1, 1, 1, 0.3)

	ReskinButton(scrollBar.TopButton)
	tex = scrollBar.TopButton:GetNormalTexture()
	tex:SetTexture(E.media.blankTex)
	tex:SetVertexColor(1, 1, 1, 0)

	tex = scrollBar.TopButton:GetPushedTexture()
	tex:SetTexture(E.media.blankTex)
	tex:SetVertexColor(1, 1, 1, 0.3)
end

local function ReskinXPBar(bar)
	if not bar then
		return
	end
	local iconTex = bar.Icon and bar.Icon:GetTexture()
	bar:StripTextures()
	if iconTex then
		bar.Icon:SetTexture(iconTex)
	end
	bar:SetStatusBarTexture(E.media.normTex)
	bar:CreateBackdrop("Transparent")
end

local function ReskinCard(card)
	if not card then
		return
	end

	card:SetBackdrop(nil)
	card:CreateBackdrop("Transparent")
	module:CreateBackdropShadow(card)

	if card.Source then
		card.Source:StripTextures()
	end

	card.Middle:StripTextures()

	if card.Middle.XP then
		ReskinXPBar(card.Middle.XP)
		card.Middle.XP:Height(15)
	end

	if card.Middle.Lore then
		F.SetFontOutline(card.Middle.Lore, E.db.general.font)
		card.Middle.Lore:SetTextColor(1, 1, 1, 1)
	end

	if card.Bottom.AbilitiesBG then
		card.Bottom.AbilitiesBG:Hide()
	end

	if card.Bottom.BottomBG then
		card.Bottom.BottomBG:Hide()
	end
end

local function ReskinOptions(list)
	local buttons = list.ScrollFrame.Buttons
	if not buttons then
		return
	end
	for i = 1, #buttons do
		local button = buttons[i]
		if not button.__MERSkin then
			S:HandleButton(button)
			button.backdrop:SetInside(button, 1, 1)
			button.HeaderBack:StripTextures()
			button.HeaderBack = button.backdrop
			button.__MERSkin = true
		end
	end
end

local function ReskinTeamList(panel)
	if panel then
		for i = 1, 3 do
			local loadout = panel.Loadouts[i]
			if loadout and not loadout.__MERSkin then
				loadout:StripTextures()
				S:HandleButton(loadout)
				loadout.backdrop:SetInside(loadout, 2, 2)
				ReskinIconButton(loadout.Pet.Pet)
				if loadout.Pet.Pet.Level then
					loadout.Pet.Pet.Level.Text:SetTextColor(1, 1, 1)
					loadout.Pet.Pet.Level.Text:FontTemplate()
					loadout.Pet.Pet.Level.BG:SetTexture(nil)
				end
				ReskinXPBar(loadout.HP)
				ReskinXPBar(loadout.XP)
				loadout.XP:SetSize(255, 7)
				loadout.HP.MiniHP:SetText("HP")
				for j = 1, 3 do
					ReskinIconButton(loadout.Abilities[j])
				end

				loadout.__MERSkin = true
			end
		end
	end
end

local function ReskinFlyout(frame)
	if not frame or frame.__MERSkin then
		return
	end

	frame:SetBackdrop(nil)
	frame:CreateBackdrop()
	frame.backdrop:SetInside(frame, 2, 2)
	module:CreateBackdropShadow(frame)
	hooksecurefunc(frame, "Show", function(self)
		local abilities = self.Abilities
		if abilities then
			for i = 1, #abilities do
				local ability = abilities[i]
				ReskinIconButton(ability)
			end
		end
	end)
	frame.__MERSkin = true
end

function module:Rematch_LeftBottom()
	if not _G.RematchPetPanel.List then
		return
	end

	local list = _G.RematchPetPanel.List

	list.Background:Kill()
	list:CreateBackdrop()
	list.backdrop:SetInside(list, 1, 2)
	ReskinScrollBar(list.ScrollFrame.ScrollBar)

	hooksecurefunc(_G.RematchPetPanel.List, "Update", reskinPetList)
	hooksecurefunc(_G.RematchQueuePanel.List, "Update", reskinPetList)
end

function module:Rematch_Middle() -- Modified from NDui
	local panel = _G.RematchLoadoutPanel and _G.RematchLoadoutPanel.Target
	if panel then
		panel:StripTextures()
		panel:CreateBackdrop()
		ReskinButton(panel.TargetButton)
		panel.ModelBorder:SetBackdrop(nil)
		panel.ModelBorder:DisableDrawLayer("BACKGROUND")
		panel.ModelBorder:CreateBackdrop("Transparent")
		panel.ModelBorder.backdrop:SetInside(panel.ModelBorder, 4, 3)
		ReskinButton(panel.LoadSaveButton)
		for i = 1, 3 do
			local button = panel["Pet" .. i]
			if button then
				button:StripTextures()
				ReskinIconButton(button)
			end
		end
	end

	ReskinTeamList(_G.RematchLoadoutPanel)
	ReskinFlyout(_G.RematchLoadoutPanel.Flyout)
	hooksecurefunc(_G.RematchLoadoutPanel, "UpdateLoadouts", ReskinTeamList)

	-- Target Panel
	panel = _G.RematchLoadoutPanel and _G.RematchLoadoutPanel.TargetPanel
	if panel then
		panel.Top:StripTextures()
		ReskinButton(panel.Top.BackButton)
		ReskinEditBox(panel.Top.SearchBox)
		panel.Top.SearchBox:ClearAllPoints()
		panel.Top.SearchBox:Point("TOPLEFT", panel.Top, "TOPLEFT", 3, -3)
		panel.Top.SearchBox:Point("RIGHT", panel.Top.BackButton, "LEFT", -2, 0)
		panel.List.Background:Kill()
		panel.List:CreateBackdrop()
		panel.List.backdrop:SetInside(panel.List, 2, 2)
		ReskinScrollBar(panel.List.ScrollFrame.ScrollBar)
		hooksecurefunc(panel.List, "Update", reskinPetList)
	end
end

function module:Rematch_Right()
	-- Team Panel
	local panel = _G.RematchTeamPanel
	if panel then
		panel.Top:StripTextures()
		ReskinEditBox(panel.Top.SearchBox)
		panel.Top.SearchBox:ClearAllPoints()
		panel.Top.SearchBox:Point("TOPLEFT", panel.Top, "TOPLEFT", 3, -3)
		panel.Top.SearchBox:Point("RIGHT", panel.Top.Teams, "LEFT", -2, 0)
		ReskinFilterButton(panel.Top.Teams)
		panel.List.Background:Kill()
		panel.List:CreateBackdrop()
		panel.List.backdrop:SetInside(panel.List, 0, 2)
		ReskinScrollBar(panel.List.ScrollFrame.ScrollBar)
		hooksecurefunc(panel.List, "Update", reskinPetList)
	end

	-- Queue Panel
	panel = _G.RematchQueuePanel
	if panel then
		panel.Top:StripTextures()
		ReskinFilterButton(panel.Top.QueueButton)
		panel.List.Background:Kill()
		panel.List:CreateBackdrop()
		panel.List.backdrop:SetInside(panel.List, 2, 2)
		ReskinScrollBar(panel.List.ScrollFrame.ScrollBar)
		hooksecurefunc(panel.List, "Update", reskinPetList)
	end

	-- Option Panel
	panel = _G.RematchOptionPanel
	if panel then
		panel.Top:StripTextures()
		ReskinEditBox(panel.Top.SearchBox)
		for i = 1, 4 do
			ReskinIconButton(panel.Growth.Corners[i])
		end
		panel.List.Background:Kill()
		panel.List:CreateBackdrop()
		panel.List.backdrop:SetInside(panel.List, 2, 2)
		ReskinScrollBar(panel.List.ScrollFrame.ScrollBar)
		hooksecurefunc(panel.List, "Update", ReskinOptions)
	end
end

function module:Rematch_Footer()
	-- Tabs
	for _, tab in pairs({ _G.RematchJournal.PanelTabs:GetChildren() }) do
		tab:StripTextures()
		tab:CreateBackdrop("Transparent")
		tab.backdrop:Point("TOPLEFT", 10, E.PixelMode and -1 or -3)
		tab.backdrop:Point("BOTTOMRIGHT", -10, 3)
		F.SetFontOutline(tab.Text)
		self:CreateBackdropShadow(tab)
	end

	-- Buttons
	ReskinButton(_G.RematchBottomPanel.SummonButton)
	ReskinButton(_G.RematchBottomPanel.SaveButton)
	ReskinButton(_G.RematchBottomPanel.SaveAsButton)
	ReskinButton(_G.RematchBottomPanel.FindBattleButton)
	S:HandleCheckBox(_G.RematchBottomPanel.UseDefault)

	hooksecurefunc(_G.RematchJournal, "SetupUseRematchButton", function()
		if _G.UseRematchButton then
			S:HandleCheckBox(_G.UseRematchButton)
		end
	end)
end

function module:Rematch_Dialog()
	if not _G.RematchDialog then
		return
	end

	-- Background
	local dialog = _G.RematchDialog
	dialog:StripTextures()
	dialog.Prompt:StripTextures()
	dialog:CreateBackdrop("Transparent")
	self:CreateBackdropShadow(dialog)

	-- Buttons
	ReskinCloseButton(dialog.CloseButton)
	ReskinButton(dialog.Accept)
	ReskinButton(dialog.Cancel)

	-- Icon selector
	ReskinIconButton(dialog.Slot)
	ReskinEditBox(dialog.EditBox)
	dialog.TeamTabIconPicker:StripTextures()
	dialog.TeamTabIconPicker:CreateBackdrop()
	S:HandleScrollBar(dialog.TeamTabIconPicker.ScrollFrame.ScrollBar)
	hooksecurefunc(_G.RematchTeamTabs, "UpdateTabIconPickerList", function()
		local buttons = dialog.TeamTabIconPicker.ScrollFrame.buttons
		for i = 1, #buttons do
			local line = buttons[i]
			for j = 1, 10 do
				local button = line.Icons[j]
				if button and not button.__MERSkin then
					button:Size(26, 26)
					button.Icon = button.Texture
					reskinIconButton(button)
					button.__MERSkin = true
				end
			end
		end
	end)

	-- Checkbox
	S:HandleCheckBox(dialog.CheckButton)

	-- Dropdown
	ReskinDropdown(dialog.SaveAs.Target)
	ReskinDropdown(dialog.TabPicker)

	-- Save as [team]
	hooksecurefunc(_G.Rematch, "UpdateSaveAsDialog", function()
		for i = 1, 3 do
			local button = _G.RematchDialog.SaveAs.Team.Pets[i]
			ReskinIconButton(button)
			button.Icon.backdrop:SetBackdropBorderColor(button.IconBorder:GetVertexColor())
			local abilities = button.Abilities
			if abilities then
				for j = 1, #abilities do
					ReskinIconButton(abilities[j])
				end
			end
		end
	end)

	-- Collection
	local collection = dialog.CollectionReport
	hooksecurefunc(_G.Rematch, "ShowCollectionReport", function()
		for i = 1, 4 do
			local bar = collection.RarityBar[i]
			bar:SetTexture(E.media.normTex)
		end
		if not collection.RarityBarBorder.backdrop then
			collection.RarityBarBorder:StripTextures()
			collection.RarityBarBorder:CreateBackdrop("Transparent")
			collection.RarityBarBorder.backdrop:SetInside(collection.RarityBarBorder, 6, 5)
		end
	end)

	hooksecurefunc(collection, "UpdateChart", function()
		for i = 1, 10 do
			local col = collection.Chart.Columns[i]
			col.Bar:SetTexture(E.media.blankTex)
			col.IconBorder:Hide()
		end
	end)
	ReskinDropdown(collection.ChartTypeComboBox)
	collection.Chart:StripTextures()
	collection.Chart:CreateBackdrop("Transparent")
	collection.Chart.backdrop:SetInside(collection.Chart, 2, 2)
	S:HandleRadioButton(collection.ChartTypesRadioButton)
	S:HandleRadioButton(collection.ChartSourcesRadioButton)
end

function module:Rematch_AbilityCard()
	if not _G.RematchAbilityCard then
		return
	end

	local card = _G.RematchAbilityCard
	card:SetBackdrop(nil)
	card.TitleBG:SetAlpha(0)
	card.Hints.HintsBG:SetAlpha(0)
	card:CreateBackdrop("Transparent")
	self:CreateBackdropShadow(card)
end

function module:Rematch_PetCard()
	if not _G.RematchPetCard then
		return
	end

	local card = _G.RematchPetCard
	card:StripTextures()
	card.Title:StripTextures()
	card:CreateBackdrop("Transparent")
	self:CreateBackdropShadow(card)
	ReskinCloseButton(card.CloseButton)
	S:HandleNextPrevButton(card.PinButton, "up")
	card.PinButton:ClearAllPoints()
	card.PinButton:Point("TOPLEFT", 3, -3)
	ReskinCard(card.Front)
	ReskinCard(card.Back)

	for i = 1, 6 do
		local button = card.Front.Bottom.Abilities[i]
		button.IconBorder:Kill()
		select(8, button:GetRegions()):SetTexture(nil)
		ReskinIconButton(button.Icon)
	end
end

function module:Rematch_RightTabs()
	hooksecurefunc(_G.RematchTeamTabs, "Update", function(tabs)
		for _, tab in next, tabs.Tabs do
			if tab and not tab.__MERSkin then
				tab.Background:Kill()
				reskinIconButton(tab)
				self:CreateBackdropShadow(tab.Icon)
				tab:Size(40)
				tab.__MERSkin = true
			end
		end
	end)
end

function module:Rematch_Standalone()
	if not _G.RematchFrame then
		return
	end

	local frame = _G.RematchFrame
	frame:StripTextures()
	frame:CreateBackdrop()
	self:CreateBackdropShadow(frame)

	frame.TitleBar:StripTextures()
	ReskinCloseButton(frame.TitleBar.CloseButton)
	ClearTextureButton(frame.TitleBar.MinimizeButton, true)
	ClearTextureButton(frame.TitleBar.SinglePanelButton, true)
	ClearTextureButton(frame.TitleBar.LockButton, true)

	for _, tab in pairs({ frame.PanelTabs:GetChildren() }) do
		tab:StripTextures()
		tab:CreateBackdrop("Transparent")
		tab.backdrop:Point("TOPLEFT", 10, E.PixelMode and -1 or -3)
		tab.backdrop:Point("BOTTOMRIGHT", -10, 3)
		F.SetFontOutline(tab.Text)
		self:CreateBackdropShadow(tab)
	end

	-- Mini Panel
	local mini = _G.RematchMiniPanel
	if mini then
		ReskinFlyout(mini.Flyout)
		hooksecurefunc(mini, "Update", function(panel)
			panel.Background:Kill()
			local pets = panel.Pets
			for i = 1, 3 do
				local button = panel.Pets[i]
				ReskinIconButton(button)
				button.Icon.backdrop:SetBackdropBorderColor(button.IconBorder:GetVertexColor())
				local abilities = button.Abilities
				if abilities then
					for j = 1, #abilities do
						ReskinIconButton(abilities[j])
					end
				end
				ReskinXPBar(button.HP)
				ReskinXPBar(button.XP)
			end
		end)
	end
end

function module:Rematch_SkinLoad()
	if _G.RematchJournal.skinLoaded then
		return
	end

	module:Rematch_Middle()

	-- Mini frame target
	if _G.RematchMiniPanel.Target then
		local panel = _G.RematchMiniPanel.Target
		local greenCheckTex = panel.GreenCheck and panel.GreenCheck:GetTexture()
		panel:StripTextures()
		if greenCheckTex then
			panel.GreenCheck:SetTexture(greenCheckTex)
		end
		panel:CreateBackdrop()
		panel.ModelBorder:SetBackdrop(nil)
		panel.ModelBorder:DisableDrawLayer("BACKGROUND")
		panel.ModelBorder:CreateBackdrop("Transparent")
		panel.ModelBorder.backdrop:SetInside(panel.ModelBorder, 4, 3)
		ReskinButton(panel.LoadButton)
		for i = 1, 3 do
			local button = panel.Pets[i]
			if button then
				ReskinIconButton(button)
			end
		end
	end

	-- Tooltip

	_G.RematchJournal.skinLoaded = true
end

local function ReskinCardStatusBar(parent, key)
	if not parent or not key or not parent[key] or parent[key].__MERSkin then
		return
	end

	local back = parent[key .. "Back"] or parent["Back"]
	local border = parent[key .. "Border"] or parent["Border"]
	local text = parent[key .. "Text"] or parent["Text"]

	parent[key]:SetTexture(E.media.normTex)
	parent[key .. "Frame"] = CreateFrame("Frame", nil, parent)
	parent[key .. "Frame"]:SetTemplate("Transparent")
	parent[key .. "Frame"]:SetAllPoints(parent[key .. "Back"])
	back:SetAlpha(0)
	border:SetAlpha(0)
	parent[key]:SetParent(parent[key .. "Frame"])
	if text then
		text:SetParent(parent[key .. "Frame"])
		F.Move(text, 0, 1)
	end

	parent[key].__MERSkin = true
end

local function ReskinPet(frame)
	if not frame or frame.__MERSkin then
		return
	end

	frame.Border:SetAlpha(0)
	frame.MERIconBorder = CreateFrame("Frame", nil, frame)
	frame.MERIconBorder:SetOutside(frame.Icon)
	frame.MERIconBorder:SetTemplate()
	hooksecurefunc(frame.Border, "SetVertexColor", function(_, r, g, b)
		frame.MERIconBorder:SetBackdropBorderColor(r, g, b)
	end)
	frame.Border:SetVertexColor(frame.Border:GetVertexColor())
	frame.MERIconBorder:SetFrameLevel(max(0, frame:GetFrameLevel() - 1))

	frame.LevelBubble:Kill()
	F.SetFontOutline(frame.LevelText, E.db.general.font)
	frame.LevelText:SetJustifyH("RIGHT")
	frame.LevelText:ClearAllPoints()
	frame.LevelText:Point("BOTTOMRIGHT", frame.Icon, "BOTTOMRIGHT", 2, 0)

	frame.Status:SetAllPoints(frame.Icon)
	hooksecurefunc(frame.Status, "SetTexCoord", function(self, ...)
		if F.IsAlmost({ 0.3125, 0.625, 0, 0.625 }, { ... }) then
			self:SetTexCoord(0.325, 0.6125, 0.025, 0.6)
		elseif F.IsAlmost({ 0, 0.3125, 0, 0.625 }, { ... }) then
			self:SetTexCoord(0.0125, 0.3, 0.025, 0.6)
		end
	end)

	local ULx, ULy, _, _, _, _, LRx, LRy = frame.Status:GetTexCoord()
	frame.Status:SetTexCoord(ULx, LRx, ULy, LRy)

	frame.__MERSkin = true
end

local function ReskinList(frame)
	if not frame then
		return
	end

	frame:StripTextures()
	module:Proxy("HandleFrame", frame)
	module:Proxy("HandleTrimScrollBar", frame.ScrollBar)
	frame.ScrollBar:ClearAllPoints()
	frame.ScrollBar:Point("TOPRIGHT", frame, "TOPRIGHT", -7, -18)
	frame.ScrollBar:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -7, 18)
	module:ReskinIconButton(frame.ScrollToTopButton, I.Media.Icons.End, 20, 1.571)
	F.Move(frame.ScrollToTopButton, -3, -1)
	module:ReskinIconButton(frame.ScrollToBottomButton, I.Media.Icons.End, 20, -1.571)
	F.Move(frame.ScrollToBottomButton, -2, 4)
end

local function ReskinMainFrame(frame)
	frame:StripTextures()
	frame:SetTemplate()
	module:CreateShadow(frame)
	if not E.private.mui.skins.shadow and not E.private.mui.skins.shadow.enable then
		return
	end
	hooksecurefunc(frame, "Show", function()
		if _G.CollectionsJournal and _G.CollectionsJournal.MERshadow then
			_G.CollectionsJournal.MERshadow:Hide()
		end
	end)

	hooksecurefunc(frame, "Hide", function()
		if _G.CollectionsJournal and _G.CollectionsJournal.MERshadow then
			_G.CollectionsJournal.MERshadow:Show()
		end
	end)
end

local function ReskinTitleBar(frame)
	if not frame then
		return
	end

	frame.Portrait:Kill()
	F.SetFontOutline(frame.Title)
	S:HandleCloseButton(frame.CloseButton)
end

local function ReskinToolBar(frame)
	frame:StripTextures()

	if frame.TotalsButton then
		frame.TotalsButton:StripTextures()
		frame.TotalsButton:CreateBackdrop("Transparent")
		frame.TotalsButton.backdrop:Point("TOPLEFT", 0, 0)
	end

	for _, button in pairs({
		frame.BandageButton,
		frame.ExportTeamButton,
		frame.FindBattleButton,
		frame.HealButton,
		frame.ImportTeamButton,
		frame.LesserPetTreatButton,
		frame.LevelingStoneButton,
		frame.PetSatchelButton,
		frame.PetTreatButton,
		frame.RandomTeamButton,
		frame.RarityStoneButton,
		frame.SafariHatButton,
		frame.SaveAsButton,
		frame.SummonPetButton,
	}) do
		ReskinIconButton(button)
		F.InternalizeMethod(button, "SetPoint")
		hooksecurefunc(button, "SetPoint", function()
			F.Move(button, 2, 0)
		end)
		F.Move(button, 2, 0)
	end
end

local function ReskinPetListButton(frame)
	if not frame then
		return
	end

	for _, child in pairs({ frame:GetChildren() }) do
		if not child.__MERSkin and child.data and child.parentKey and child.Top then
			child:CreateBackdrop()
			child.backdrop:SetInside(child, 1, 1)
			child.backdrop.Center:Kill()
			hooksecurefunc(child.Top, "SetVertexColor", function(t, r, g, b, a)
				child.backdrop:SetBackdropBorderColor(r, g, b)
			end)
			child.Top:SetVertexColor(child.Top:GetVertexColor())

			module:Proxy("HandleBlizzardRegions", child)
			child.Top:Kill()
			child.Bottom:Kill()

			child.__MERSkin = true
		end
	end

	if frame.__MERSkin then
		return
	end

	ReskinPet(frame)
	frame.Back:Kill()
	frame.MERHighlight = frame:CreateTexture(nil, "OVERLAY")
	frame.MERHighlight:SetTexture(E.media.blankTex)
	frame.MERHighlight:SetAllPoints(frame.Back)
	frame.MERHighlight:SetVertexColor(1, 1, 1, 0.2)
	frame.MERHighlight:Hide()
	frame:HookScript("OnEnter", function()
		frame.MERHighlight:Show()
	end)
	frame:HookScript("OnLeave", function()
		frame.MERHighlight:Hide()
	end)
end

local function ReskinPetsPanel(frame)
	if not frame then
		return
	end

	-- Top Filter
	frame.Top:StripTextures()
	frame.Top:CreateBackdrop("Transparent")
	module:Reposition(frame.Top.backdrop, frame.Top, 0, 0, 1, 0, 0)
	local toggleIconTex = frame.Top.ToggleButton.Icon:GetTexture()
	frame.Top.ToggleButton:StripTextures()
	frame.Top.ToggleButton.Icon:SetTexture(toggleIconTex)
	module:Proxy("HandleButton", frame.Top.ToggleButton)
	module:Proxy("HandleEditBox", frame.Top.SearchBox)
	for _, tex in pairs(frame.Top.SearchBox.Back) do
		tex:Kill()
	end
	frame.Top.SearchBox:ClearAllPoints()
	frame.Top.SearchBox:Point("TOPLEFT", frame.Top.ToggleButton, "TOPRIGHT", 5, 0)
	frame.Top.SearchBox:Point("BOTTOMRIGHT", frame.Top.FilterButton, "BOTTOMLEFT", -5, 0)
	frame.Top.FilterButton:StripTextures()
	module:Proxy(
		"HandleButton",
		frame.Top.FilterButton,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		true,
		"right"
	)

	-- Top Type Bar
	F.Move(frame.Top.TypeBar, 0, -4)
	frame.Top.TypeBar:CreateBackdrop()
	module:Reposition(frame.Top.TypeBar.backdrop, frame.Top.TypeBar, 2, -25, -4, -4, -4)
	frame.Top.TypeBar.Level25Button:StripTextures()
	frame.Top.TypeBar.Level25Button:CreateBackdrop()
	frame.Top.TypeBar.Level25Button:HookScript("OnEnter", function()
		frame.Top.TypeBar.Level25Button.backdrop:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
	end)
	frame.Top.TypeBar.Level25Button:HookScript("OnLeave", function()
		frame.Top.TypeBar.Level25Button.backdrop:SetBackdropBorderColor(0, 0, 0)
	end)
	frame.Top.TypeBar.Level25Button.Text = frame.Top.TypeBar.Level25Button.backdrop:CreateFontString(nil, "OVERLAY")
	frame.Top.TypeBar.Level25Button.Text:FontTemplate(nil, 10)
	frame.Top.TypeBar.Level25Button.Text:SetText("25")
	frame.Top.TypeBar.Level25Button.Text:Point("CENTER", 1, 0)

	local newHighlight = frame.Top.TypeBar.backdrop:CreateTexture(nil, "OVERLAY")
	newHighlight:SetAllPoints(frame.Top.TypeBar.Level25Button)
	newHighlight:SetTexture(E.media.blankTex)
	newHighlight:SetVertexColor(1, 0.875, 0.125, 0.3)
	newHighlight:SetShown(frame.Top.TypeBar.Level25Highlight:IsShown())
	frame.Top.TypeBar.Level25Highlight:Kill()
	frame.Top.TypeBar.Level25Highlight = newHighlight

	frame.Top.TypeBar.TabbedBorder:SetAlpha(0)

	if frame.Top.TypeBar.Tabs then
		for i = 1, #frame.Top.TypeBar.Tabs do
			local tab = frame.Top.TypeBar.Tabs[i]
			tab:Height(25)
			module:Proxy("HandleTab", tab)
			F.InternalizeMethod(tab.Text, "SetPoint")
			hooksecurefunc(tab.Text, "SetPoint", function(t)
				F.Move(t, 0, 2)
			end)
			F.Move(tab.Text, 0, 2)
			F.Move(tab, 0, 1)
		end
	end

	if frame.Top.TypeBar.Buttons then
		for i = 1, #frame.Top.TypeBar.Buttons do
			ReskinIconButton(frame.Top.TypeBar.Buttons[i])
		end
	end

	if frame.Top.TypeBar.Selecteds then
		for i = 1, #frame.Top.TypeBar.Selecteds do
			local texture = frame.Top.TypeBar.Selecteds[i]
			texture:SetTexture(E.media.blankTex)
			F.InternalizeMethod(texture, "SetVertexColor")
			texture.SetVertexColor = function(t, r, g, b, a)
				F.CallMethod(t, "SetVertexColor", r, g, b, (a or 0.4) / 3)
			end
			texture:SetVertexColor(texture:GetVertexColor())
		end
	end

	frame.ResultsBar:StripTextures()
	frame.ResultsBar:CreateBackdrop("Transparent")
	frame.ResultsBar.backdrop:SetInside(frame.ResultsBar)

	ReskinList(frame.List)
	hooksecurefunc(frame.List, "Refresh", function()
		frame.List.ScrollBox:ForEachFrame(ReskinPetListButton)
	end)
	frame.List.ScrollBox:ForEachFrame(ReskinPetListButton)
end

local function ReskinTooltipsAndMenus()
	_G.RematchTooltip:StripTextures()
	_G.RematchTooltip:CreateBackdrop("Transparent")
	module:CreateBackdropShadow(_G.RematchTooltip)

	_G.FloatingPetBattleAbilityTooltip:StripTextures()
	_G.FloatingPetBattleAbilityTooltip:CreateBackdrop("Transparent")
	module:CreateBackdropShadow(_G.FloatingPetBattleAbilityTooltip)

	module:TryPostHook("RematchMenuFrameMixin", "OnUpdate", function(self)
		if not self.__MERSkin then
			self.Title:StripTextures()
			self:StripTextures()
			self:CreateBackdrop("Transparent")
			module:CreateBackdropShadow(self)
			self.__MERSkin = true
		end
	end)
end

local function ReskinBottomBar(frame)
	if not frame then
		return
	end

	ReskinButton(frame.SummonButton)
	module:Proxy("HandleCheckBox", frame.UseRematchCheckButton)
	ReskinButton(frame.SaveButton)
	F.Move(frame.SaveButton, -2, 0)
	ReskinButton(frame.SaveAsButton)
	F.Move(frame.SaveAsButton, -2, 0)
	ReskinButton(frame.FindBattleButton)
end

local function ReskinPanelTabs(frame)
	if not frame or frame.__MERSkin then
		return
	end

	for _, tab in pairs({ frame:GetChildren() }) do
		module:Proxy("HandleTab", tab)
		module:ReskinTab(tab)
		F.InternalizeMethod(tab.Text, "SetPoint", true)
		F.CallMethod(tab.Text, "SetPoint", "CENTER", 0, 0)
	end

	F.InternalizeMethod(frame, "SetPoint")
	hooksecurefunc(frame, "SetPoint", function()
		F.Move(frame, 7, -2)
	end)
	F.Move(frame, 7, -2)

	frame.__MERSkin = true
end

local function ReskinLoadedTargetPanel(frame, petsPanel, targetsPanel)
	if not frame then
		return
	end

	frame:StripTextures()
	frame:SetTemplate("Transparent")
	frame:ClearAllPoints()
	frame:Point("TOPLEFT", petsPanel, "TOPRIGHT", 3, -1)
	frame:Point("BOTTOMRIGHT", targetsPanel, "BOTTOMLEFT", -3, -75)
	ReskinButton(frame.BigLoadSaveButton)

	frame.titleBackdrop = frame:CreateTexture(nil, "ARTWORK")
	frame.titleBackdrop:Point("TOPLEFT", frame, "TOPLEFT", 1, -1)
	frame.titleBackdrop:Point("BOTTOMRIGHT", frame, "TOPRIGHT", -1, -25)
	frame.titleBackdrop:SetTexture(E.media.blankTex)
	frame.titleBackdrop:SetVertexColor(C.ExtractRGBAFromTemplate("gray-400"))
	frame.titleBackdrop:SetAlpha(0.1)

	local EnemyTeam = frame.EnemyTeam
	if EnemyTeam then
		EnemyTeam.Border:Kill()
	end

	ReskinIconButton(frame.SmallRandomButton)
	F.InternalizeMethod(frame.SmallRandomButton, "SetPoint")
	hooksecurefunc(frame.SmallRandomButton, "SetPoint", function()
		F.Move(frame.SmallRandomButton, 1, 2)
	end)
	F.Move(frame.SmallRandomButton, 1, 2)
	ReskinIconButton(frame.SmallSaveButton)
	ReskinIconButton(frame.SmallTeamsButton)
end

local function ReskinLoadedTeamPanel(frame)
	if not frame then
		return
	end

	frame:StripTextures()

	frame.NotesFrame:StripTextures()
	local NotesButton = frame.NotesFrame.NotesButton
	ReskinIconButton(NotesButton)
	NotesButton.Icon.backdrop:SetOutside(NotesButton, 1, 1)
	NotesButton.hover:SetOutside(NotesButton)

	frame.PreferencesFrame:StripTextures()
	local PreferencesButton = frame.PreferencesFrame.PreferencesButton
	ReskinIconButton(PreferencesButton)
	PreferencesButton.Icon.backdrop:SetOutside(PreferencesButton, 1, 1)
	PreferencesButton.hover:SetOutside(PreferencesButton)

	frame.TeamButton:StripTextures()
	ReskinButton(frame.TeamButton)
end

local function ReskinLoadout(frame)
	if not frame or frame.__MERSkin then
		return
	end

	module:Proxy("HandleBlizzardRegions", frame)
	frame.Top:Kill()
	frame.Bottom:Kill()
	frame.Back:Kill()
	frame.Highlight:SetTexture(E.media.blankTex)
	frame.Highlight:SetVertexColor(1, 1, 1, 0.1)
	frame:SetTemplate()

	ReskinPet(frame.Pet)

	local AbilityBar = frame.AbilityBar
	if AbilityBar then
		AbilityBar.AbilitiesBorder:Kill()
		for _, child in pairs({ AbilityBar:GetChildren() }) do
			if child ~= AbilityBar.AbilitiesBorder then
				child:CreateBackdrop()
			end
		end
	end

	ReskinCardStatusBar(frame, "HpBar")
	ReskinCardStatusBar(frame, "XpBar")

	frame.__MERSkin = true
end

local function ReskinLoadoutPanel(frame)
	if not frame then
		return
	end

	hooksecurefunc(frame, "Update", function()
		for _, loadout in pairs(frame.Loadouts) do
			ReskinLoadout(loadout)
		end
	end)

	for _, loadout in pairs(frame.Loadouts) do
		ReskinLoadout(loadout)
	end

	local AbilityFlyout = frame.AbilityFlyout
	if AbilityFlyout then
		AbilityFlyout:CreateBackdrop()
		AbilityFlyout.backdrop:SetInside(AbilityFlyout, 1, 1)
		AbilityFlyout.backdrop:SetFrameLevel(AbilityFlyout:GetFrameLevel())
		module:CreateBackdropShadow(AbilityFlyout)
		AbilityFlyout.Border:Kill()

		for _, button in pairs({ AbilityFlyout:GetChildren() }) do
			if button ~= AbilityFlyout.Border and button ~= AbilityFlyout.anchoredTo then
				ReskinIconButton(button)
			end
		end

		hooksecurefunc(AbilityFlyout, "FillAbilityFlyout", function(self)
			if self.__MERSkin then
				return
			end
			AbilityFlyout.AbilitySelecteds[1]:SetTexture(E.media.blankTex)
			AbilityFlyout.AbilitySelecteds[1]:SetVertexColor(C.ExtractRGBAFromTemplate("yellow-300"))
			AbilityFlyout.AbilitySelecteds[1]:SetAlpha(0.4)
			AbilityFlyout.AbilitySelecteds[2]:SetTexture(E.media.blankTex)
			AbilityFlyout.AbilitySelecteds[2]:SetVertexColor(C.ExtractRGBAFromTemplate("green-300"))
			AbilityFlyout.AbilitySelecteds[2]:SetAlpha(0.4)
			self.__MERSkin = true
		end)
	end
end

local function ReskinListElement(frame)
	if not frame then
		return
	end

	if frame.ExpandIcon and not frame.ExpandIcon.__windSkin then
		ReskinButton(frame)
		if frame.Border then
			frame.Border:Kill()
		end

		frame.ExpandIcon:Size(12, 12)
		F.Move(frame.ExpandIcon, 6, 0)
		F.InternalizeMethod(frame.ExpandIcon, "SetTexCoord")
		F.CallMethod(frame.ExpandIcon, "SetTexCoord", 0, 1, 0, 1)
		frame.ExpandIcon.SetTexCoord = function(_, ...)
			local isPlus = F.IsAlmost({ 0.75, 0.80078125, 0, 0.40625 }, { ... })
			frame.ExpandIcon:SetTexture(isPlus and I.Media.Icons.Plus or I.Media.Icons.Minus)
		end
		local ULx, ULy, _, _, _, _, LRx, LRy = frame.ExpandIcon:GetTexCoord()
		frame.ExpandIcon:SetTexCoord(ULx, LRx, ULy, LRy)

		frame.ExpandIcon.__MERSkin = true
	end

	local function ReskinCheck(frame)
		if not frame.Check or frame.Check.__MERSkin then
			return
		end

		frame.CheckFrame = CreateFrame("Frame", nil, frame)
		frame.CheckFrame:SetTemplate()
		frame.CheckFrame:Size(14, 14)
		frame.CheckFrame:Point("LEFT", frame.Check, "LEFT", 6, 0)
		frame.CheckFrame:SetShown(frame.Check:IsShown())
		frame.CheckFrame.Checked = frame.CheckFrame:CreateTexture(nil, "OVERLAY")
		frame.CheckFrame.Checked:SetInside(frame.CheckFrame)
		if E.private.mui.skins.widgets.checkBox.enable then
			local db = E.private.mui.skins.widgets.checkBox
			frame.CheckFrame.Checked:SetTexture(LSM:Fetch("statusbar", db.texture) or E.media.normTex)
			F.SetVertexColorDB(frame.CheckFrame.Checked, db.classColor and E.myClassColor or db.color)
		else
			frame.CheckFrame.Checked:SetTexture(E.Media.Textures.Melli)
			frame.CheckFrame.Checked:SetVertexColor(1, 0.82, 0, 0.8)
		end

		hooksecurefunc(frame.Check, "SetTexCoord", function(_, ...)
			local hidden = F.IsAlmost({ 0, 0.25, 0.5, 0.75 }, { ... })
			frame.CheckFrame.Checked:SetShown(not hidden)
		end)
		local ULx, ULy, _, _, _, _, LRx, LRy = frame.Check:GetTexCoord()
		frame.Check:SetTexCoord(ULx, LRx, ULy, LRy)

		frame.Check:Kill()
		hooksecurefunc(frame.Check, "Show", function()
			frame.CheckFrame:SetShown(true)
		end)
		hooksecurefunc(frame.Check, "Hide", function()
			frame.CheckFrame:SetShown(false)
		end)
		hooksecurefunc(frame.Check, "SetShown", function(_, shown)
			frame.CheckFrame:SetShown(shown)
		end)

		frame.Check.__MERSkin = true
	end

	ReskinCheck(frame)

	if frame.widget then
		for _, child in pairs({ frame.widget:GetChildren() }) do
			if child:IsObjectType("Button") and not child.__MERSkin then
				ReskinButton(child)
				if child.DropDownButton then
					child.DropDownTex = child:CreateTexture(nil, "OVERLAY")
					child.DropDownTex:SetInside(child.DropDownButton, 1, 1)
					child.DropDownTex:SetTexture(E.Media.Textures.ArrowUp)
					child.DropDownTex:SetRotation(S.ArrowRotation.down)
					child.DropDownButton:Kill()
				end
				child.__MERSkin = true
			end
		end

		ReskinCheck(frame.widget)
	end
end

local function ReskinTeamButton(frame)
	if frame.ExpandIcon then
		ReskinListElement(frame)
		return
	end

	for _, child in pairs({ frame:GetChildren() }) do
		if not child.__MERSkin and child.data and child.parentKey and child.Top then
			child:CreateBackdrop()
			child.backdrop:SetInside(child, 1, 1)
			child.backdrop.Center:Kill()
			hooksecurefunc(child.Top, "SetVertexColor", function(t, r, g, b, a)
				child.backdrop:SetBackdropBorderColor(r, g, b)
			end)
			child.Top:SetVertexColor(child.Top:GetVertexColor())

			module:Proxy("HandleBlizzardRegions", child)
			child.Top:Kill()
			child.Bottom:Kill()

			child.__MERSkin = true
		end
	end

	if frame.__MERSkin then
		return
	end

	frame.Border:Kill()
	frame.Back:Kill()
	frame.MERHighlight = frame:CreateTexture(nil, "OVERLAY")
	frame.MERHighlight:SetTexture(E.media.blankTex)
	frame.MERHighlight:SetAllPoints(frame.Back)
	frame.MERHighlight:SetVertexColor(1, 1, 1, 0.2)
	frame.MERHighlight:Hide()
	frame:HookScript("OnEnter", function()
		frame.MERHighlight:Show()
	end)
	frame:HookScript("OnLeave", function()
		frame.MERHighlight:Hide()
	end)

	frame.__MERSkin = true
end

local function ReskinTeamsPanel(frame)
	if not frame then
		return
	end

	-- Top
	frame.Top:StripTextures()
	frame.Top:CreateBackdrop("Transparent")
	module:Reposition(frame.Top.backdrop, frame.Top, 0, 0, 1, 0, 0)

	ReskinToggleButton(frame.Top.AllButton)
	module:Proxy("HandleEditBox", frame.Top.SearchBox)
	for _, tex in pairs(frame.Top.SearchBox.Back) do
		tex:Kill()
	end
	frame.Top.SearchBox:ClearAllPoints()
	frame.Top.SearchBox:Point("TOPLEFT", frame.Top.AllButton, "TOPRIGHT", 5, 0)
	frame.Top.SearchBox:Point("BOTTOMRIGHT", frame.Top.TeamsButton, "BOTTOMLEFT", -5, 0)
	frame.Top.TeamsButton:StripTextures()
	module:Proxy("HandleButton", frame.Top.TeamsButton, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, "right")

	-- List
	ReskinList(frame.List)
	hooksecurefunc(frame.List.ScrollBox, "Update", function()
		frame.List.ScrollBox:ForEachFrame(ReskinTeamButton)
	end)
	frame.List.ScrollBox:ForEachFrame(ReskinTeamButton)
end

local function ReskinTargetsButton(frame)
	if frame.ExpandIcon then
		ReskinListElement(frame)
		return
	end

	if frame.__MERSkin then
		return
	end

	if frame.Border then
		frame.Border:Kill()
		frame.Back:Kill()
		frame.MERHighlight = frame:CreateTexture(nil, "OVERLAY")
		frame.MERHighlight:SetTexture(E.media.blankTex)
		frame.MERHighlight:SetAllPoints(frame.Back)
		frame.MERHighlight:SetVertexColor(1, 1, 1, 0.2)
		frame.MERHighlight:Hide()
		frame:HookScript("OnEnter", function()
			frame.MERHighlight:Show()
		end)
		frame:HookScript("OnLeave", function()
			frame.MERHighlight:Hide()
		end)

		frame.__MERSkin = true
	end
end

local function ReskinTargetsPanel(frame)
	if not frame then
		return
	end

	-- Top
	frame.Top:StripTextures()
	frame.Top:CreateBackdrop("Transparent")
	module:Reposition(frame.Top.backdrop, frame.Top, 0, 0, 1, 0, 0)
	ReskinToggleButton(frame.Top.AllButton)
	module:Proxy("HandleEditBox", frame.Top.SearchBox)
	for _, tex in pairs(frame.Top.SearchBox.Back) do
		tex:Kill()
	end
	frame.Top.SearchBox:ClearAllPoints()
	frame.Top.SearchBox:Point("TOPLEFT", frame.Top.AllButton, "TOPRIGHT", 5, 0)
	frame.Top.SearchBox:Point("BOTTOMRIGHT", frame.Top, "BOTTOMRIGHT", -7, 2)

	-- List
	ReskinList(frame.List)
	hooksecurefunc(frame.List.ScrollBox, "Update", function()
		frame.List.ScrollBox:ForEachFrame(ReskinTargetsButton)
	end)
	frame.List.ScrollBox:ForEachFrame(ReskinTargetsButton)
end

local function ReskinQueuePanel(frame)
	if not frame then
		return
	end

	-- Top
	frame.PreferencesFrame:StripTextures()
	local PreferencesButton = frame.PreferencesFrame.PreferencesButton
	ReskinIconButton(PreferencesButton)
	PreferencesButton.Icon.backdrop:SetTemplate("Transparent")
	PreferencesButton.Icon.backdrop:SetOutside(PreferencesButton, 3, 3)
	F.Move(PreferencesButton, 0, -1)
	PreferencesButton.hover:ClearAllPoints()
	PreferencesButton.hover:SetOutside(PreferencesButton, 2, 2)

	frame.Top:StripTextures()
	frame.Top:CreateBackdrop("Transparent")
	module:Reposition(frame.Top.backdrop, frame.Top, 0, 0, 1, 0, 0)
	frame.Top.QueueButton:StripTextures()
	module:Proxy("HandleButton", frame.Top.QueueButton, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, "right")

	-- List
	ReskinList(frame.List)
	hooksecurefunc(frame.List.ScrollBox, "Update", function()
		frame.List.ScrollBox:ForEachFrame(ReskinListElement)
	end)
	frame.List.ScrollBox:ForEachFrame(ReskinListElement)
end

local function ReskinOptionsPanel(frame)
	if not frame then
		return
	end

	-- Top
	frame.Top:StripTextures()
	frame.Top:CreateBackdrop("Transparent")
	module:Reposition(frame.Top.backdrop, frame.Top, 0, 0, 1, 0, 0)
	ReskinToggleButton(frame.Top.AllButton)
	module:Proxy("HandleEditBox", frame.Top.SearchBox)
	for _, tex in pairs(frame.Top.SearchBox.Back) do
		tex:Kill()
	end
	frame.Top.SearchBox:ClearAllPoints()
	frame.Top.SearchBox:Point("TOPLEFT", frame.Top.AllButton, "TOPRIGHT", 5, 0)
	frame.Top.SearchBox:Point("BOTTOMRIGHT", frame.Top, "BOTTOMRIGHT", -7, 2)

	-- List
	ReskinList(frame.List)
	hooksecurefunc(frame.List.ScrollBox, "Update", function()
		frame.List.ScrollBox:ForEachFrame(ReskinListElement)
	end)
	frame.List.ScrollBox:ForEachFrame(ReskinListElement)
end

local texList = {
	close = { E.Media.Textures.Close, 0 },
	minimize = { E.Media.Textures.ArrowUp, S.ArrowRotation.up },
	maximize = { E.Media.Textures.ArrowUp, S.ArrowRotation.down },
	left = { E.Media.Textures.ArrowUp, S.ArrowRotation.left },
	right = { E.Media.Textures.ArrowUp, S.ArrowRotation.right },
	pin = { I.Media.Icons.Pin, 0 },
	lock = { I.Media.Icons.Lock, 0 },
	unlock = { I.Media.Icons.Unlock, 0 },
	flip = { I.Media.Icons.Undo, 0 },
}

local function ReskinTitlebarButton(frame, size)
	if not frame or frame.__MERSkin then
		return
	end

	local function UpdateTexture(tex, r, g, b)
		if not frame.icon or not texList[frame.icon] then
			return
		end

		tex:SetTexture(texList[frame.icon][1])
		tex:SetRotation(texList[frame.icon][2] or 0)
		tex:SetTexCoord(0, 1, 0, 1)
		tex:Size(size or 12, size or 12)
		tex:SetVertexColor(r or 1, g or 1, b or 1)
		tex:SetAlpha(1)
	end

	local hoverColor = E.media.rgbvaluecolor

	frame.Update = function(self)
		UpdateTexture(self:GetNormalTexture(), 1, 1, 1)
		UpdateTexture(self:GetDisabledTexture(), 0.5, 0.5, 0.5)
		UpdateTexture(self:GetPushedTexture(), hoverColor.r, hoverColor.g, hoverColor.b)
		UpdateTexture(self:GetHighlightTexture(), hoverColor.r, hoverColor.g, hoverColor.b)
	end

	frame:Update()

	frame:Size(size or 12, size or 12)

	frame.__MERSkin = true
end

local function ReskinRoundButton(frame)
	for _, tex in pairs({ frame:GetRegions() }) do
		if tex:IsObjectType("Texture") and tex:GetDrawLayer() == "ARTWORK" then
			tex:Kill()
		end
	end
end

local function ReskinPetCard(frame)
	if not frame or frame.__MERSkin then
		return
	end

	frame:StripTextures()
	frame:CreateBackdrop("Transparent")
	module:CreateBackdropShadow(frame)

	ReskinTitlebarButton(frame.CloseButton)
	F.Move(frame.CloseButton, -4, -4)
	ReskinTitlebarButton(frame.MinimizeButton, 16)
	F.Move(frame.MinimizeButton, -4, 2)
	ReskinTitlebarButton(frame.FlipButton, 14)
	F.InternalizeMethod(frame.FlipButton, "SetPoint")
	hooksecurefunc(frame.FlipButton, "SetPoint", function()
		F.Move(frame.FlipButton, 4, -4)
	end)
	ReskinTitlebarButton(frame.PinButton, 14)
	F.InternalizeMethod(frame.PinButton, "SetPoint")
	hooksecurefunc(frame.PinButton, "SetPoint", function()
		F.Move(frame.PinButton, 4, -4)
	end)

	frame.Content.NineSlice:SetTemplate("Transparent")
	frame.Content.Back.Source:StripTextures()

	ReskinRoundButton(frame.Content.Top.PetIcon)
	ReskinRoundButton(frame.Content.Top.TypeIcon)
	ReskinCardStatusBar(frame.Content.Front.Stats.XpBar, "Bar")
	ReskinCardStatusBar(frame.Content.Front.Stats.HpBar, "Bar")

	for _, button in pairs(frame.Content.Front.Abilities.Buttons) do
		if button.Border then
			button.Border:Kill()
		end
		button.IconFrame = CreateFrame("Frame", nil, button)
		button.IconFrame:SetTemplate()
		button.IconFrame:SetOutside(button.Icon)
		button.Icon:SetParent(button.IconFrame)
	end

	frame.__MERSkin = true
end

function module:RematchButton()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.rematch then
		return
	end

	if not _G.Rematch or not _G.Rematch.journal then
		return
	end

	RunNextFrame(function()
		self:Proxy("HandleCheckBox", _G.Rematch.journal.UseRematchCheckButton)
	end)
end

function module:Rematch()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.rematch then
		return
	end

	local frame = _G.Rematch and _G.Rematch.frame
	if not frame then
		return
	end

	self:SecureHook(frame, "Show", function()
		self:Unhook(frame, "Show")
		self:Proxy("HandleCheckBox", _G.Rematch.journal.UseRematchCheckButton)
		MF:InternalHandle(frame, "CollectionsJournal")
		MF:InternalHandle(frame.ToolBar, "CollectionsJournal")
		self:SecureHook(frame, "Show", function()
			frame:EnableMouse(true)
		end)
		ReskinPetsPanel(frame.PetsPanel)
		ReskinPanelTabs(frame.PanelTabs)
		ReskinLoadoutPanel(frame.LoadoutPanel)
		ReskinTeamsPanel(frame.TeamsPanel)
		ReskinTargetsPanel(frame.TargetsPanel)
		ReskinQueuePanel(frame.QueuePanel)
		ReskinOptionsPanel(frame.OptionsPanel)
		ReskinPetCard(_G.Rematch.petCard)
	end)

	F.InternalizeMethod(frame, "SetPoint")
	hooksecurefunc(frame, "SetPoint", function()
		F.Move(frame, 1, 0)
	end)
	F.Move(frame, 1, 0)

	ReskinTooltipsAndMenus()
	ReskinMainFrame(frame)
	ReskinTitleBar(frame.TitleBar)
	ReskinToolBar(frame.ToolBar)
	ReskinBottomBar(frame.BottomBar)
	ReskinLoadedTargetPanel(frame.LoadedTargetPanel, frame.PetsPanel, frame.TargetsPanel)
	ReskinLoadedTeamPanel(frame.LoadedTeamPanel)
end

module:AddCallbackForAddon("Rematch")
module:AddCallbackForAddon("Blizzard_Collections", "RematchButton")
