local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")
local TT = E:GetModule("Tooltip")

local _G = _G
local select, pairs, unpack = select, pairs, unpack

function module:RematchFilter()
	self:StripTextures()
	S:HandleButton(self)
	module.SetupArrow(self.Arrow, "right")
	self.Arrow:ClearAllPoints()
	self.Arrow:SetPoint("RIGHT")
	self.Arrow.SetPoint = E.noop
	self.Arrow:SetSize(14, 14)
end

function module:RematchButton()
	if self.isSkinned then
		return
	end

	self:StripTextures()
	S:HandleButton(self)

	self.isSkinned = true
end

function module:RematchIcon()
	if self.isSkinned then
		return
	end

	if self.Border then
		self.Border:SetAlpha(0)
	end
	if self.Icon then
		S:HandleIcon(self.Icon, true)
		S:HandleIconBorder(self.Border, self.Icon.backdrop)
	end
	if self.Level then
		if self.Level.BG then
			self.Level.BG:Hide()
		end
		if self.Level.Text then
			self.Level.Text:SetTextColor(1, 1, 1)
		end
	end
	if self.GetCheckedTexture then
		self:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight")
	end

	self.isSkinned = true
end

function module:RematchInput()
	self:DisableDrawLayer("BACKGROUND")
	-- self:HideBackdrop()

	self:CreateBackdrop()
	self.backdrop:SetPoint("TOPLEFT", 2, 0)
	self.backdrop:SetPoint("BOTTOMRIGHT", -2, 0)
end

local function scrollEndOnLeave(self)
	self.__texture:SetVertexColor(1, 0.8, 0)
end

function module:ReskinScrollEnd(direction)
	module:ReskinArrow(self, direction)
	if self.Texture then
		self.Texture:SetAlpha(0)
	end
	self:SetSize(16, 12)
	self.__texture:SetVertexColor(1, 0.8, 0)
	self:HookScript("OnLeave", scrollEndOnLeave)
end

function module:RematchScroll()
	self:StripTextures()
	S:HandleTrimScrollBar(self.ScrollBar)
	module.ReskinScrollEnd(self.ScrollToTopButton, "up")
	module.ReskinScrollEnd(self.ScrollToBottomButton, "down")
end

function module:RematchDropdown()
	self:HideBackdrop()
	self:StripTextures()
	self:CreateBackdrop()
	if self.Icon then
		self.Icon:SetAlpha(1)
		S:HandleIcon(self.Icon)
	end
	local arrow = select(2, self:GetChildren())
	module:ReskinArrow(arrow, "down")
end

function module:RematchXP()
	self:StripTextures()
	self:SetTexture(E.media.normTex)
	self:CreateBackdrop("Transparent")
end

function module:RematchCard()
	self:HideBackdrop()
	if self.Source then
		self.Source:StripTextures()
	end
	self.Middle:StripTextures()
	self.Middle:CreateBackdrop("Transparent")
	if self.Middle.XP then
		module.RematchXP(self.Middle.XP)
	end
	if self.Bottom.AbilitiesBG then
		self.Bottom.AbilitiesBG:Hide()
	end
	if self.Bottom.BottomBG then
		self.Bottom.BottomBG:Hide()
	end
	self.Bottom:CreateBackdrop("Transparent")
	self.Bottom.backdrop:SetPoint("TOPLEFT", -E.mult, -3)
end

function module:RematchInset()
	self:StripTextures()
	self:CreateBackdrop("Transparent")
	local bg = self.backdrop
	bg:SetPoint("TOPLEFT", 3, 0)
	bg:SetPoint("BOTTOMRIGHT", -3, 0)
end

local function buttonOnEnter(self)
	self.bg:SetBackdropColor(F.r, F.g, F.b, 0.25)
end

local function buttonOnLeave(self)
	self.bg:SetBackdropColor(0, 0, 0, 0.25)
end

function module:RematchLockButton(button)
	button:StripTextures()
	button:CreateBackdrop("Transparent")
	local bg = self.backdrop
	bg:SetInside(7, 7)
	module:SetButtonIcon(button, "Locked")
end

local function updateCollapseTexture(button, isExpanded)
	local atlas = isExpanded and "Soulbinds_Collection_CategoryHeader_Collapse"
		or "Soulbinds_Collection_CategoryHeader_Expand"
	button.__texture:SetAtlas(atlas, true)
end

local function headerEnter(header)
	header.backdrop:SetBackdropColor(F.r, F.g, F.b, 0.25)
end

local function headerLeave(header)
	header.backdrop:SetBackdropColor(0, 0, 0, 0.25)
end

function module:RematchCollapse()
	if self.Icon then
		self.Icon.isIgnored = true
		self.IconMask.isIgnored = true
	end
	self:StripTextures()
	self:CreateBackdrop("Transparent")
	local bg = self.backdrop
	bg:SetInside()

	self.__texture = self:CreateTexture(nil, "OVERLAY")
	self.__texture:SetPoint("LEFT", 2, 0)
	self.__texture:SetSize(12, 12)
	self:HookScript("OnEnter", headerEnter)
	self:HookScript("OnLeave", headerLeave)

	updateCollapseTexture(self, self.isExpanded or self:GetParent().IsHeaderExpanded)
	hooksecurefunc(self, "SetExpanded", updateCollapseTexture)
end

local function handleHeaders(box)
	box:ForEachFrame(function(button)
		if button.ExpandIcon and not button.isSkinned then
			module.RematchCollapse(button)
			button.isSkinned = true
		end
	end)
end

function module:RematchHeaders()
	hooksecurefunc(self.ScrollBox, "Update", handleHeaders)
end

local function buttonOnEnter(button)
	local r, g, b = unpack(E.media.rgbvaluecolor)
	button.backdrop:SetBackdropBorderColor(r, g, b)

	button.hovered = true
end

local function buttonOnLeave(button)
	if button.selected or (button.SelectedTexture and button.SelectedTexture:IsShown()) then
		button.backdrop:SetBackdropBorderColor(1, 0.8, 0.1)
	else
		local r, g, b = unpack(E.media.bordercolor)
		button.backdrop:SetBackdropBorderColor(r, g, b)
	end

	button.hovered = nil
end

local function handleList(self)
	self:ForEachFrame(function(button)
		if button and not button.isSkinned then
			button.Border:SetAlpha(0)

			local icon = button.icon or button.Icon
			local savedIconTexture = icon:GetTexture()
			icon:Size(39)
			icon:ClearAllPoints()
			icon:Point("LEFT", button, "LEFT", 4, 0)
			S:HandleIcon(icon, true)
			S:HandleIconBorder(button.Border, icon.backdrop)

			local savedPetTypeTexture = button.petTypeIcon and button.petTypeIcon:GetTexture()
			local savedFactionAtlas = button.factionIcon and button.factionIcon:GetAtlas()

			button:StripTextures()
			button:CreateBackdrop("Transparent", nil, nil, true)
			button.backdrop:ClearAllPoints()
			button.backdrop:Point("TOPLEFT", button, 47, -1)
			button.backdrop:Point("BOTTOMRIGHT", button, 0, 1)
			icon:SetTexture(savedIconTexture)

			button:HookScript("OnEnter", buttonOnEnter)
			button:HookScript("OnLeave", buttonOnLeave)

			button.isSkinned = true
		end
	end)
end

function module:RematchPetList()
	hooksecurefunc(self.ScrollBox, "Update", handleList)
end

local isSkinned
function module:ReskinRematchElements()
	if isSkinned then
		return
	end

	local bg
	TT:SetStyle(_G.RematchTooltip)

	local toolbar = _G.Rematch.toolbar

	local buttonName = {
		"HealButton",
		"BandageButton",
		"SafariHatButton",
		"LesserPetTreatButton",
		"PetTreatButton",
		"LevelingStoneButton",
		"RarityStoneButton",
		"ImportTeamButton",
		"ExportTeamButton",
		"RandomTeamButton",
		"SummonPetButton",
	}
	for _, name in pairs(buttonName) do
		local button = toolbar[name]
		if button then
			module.RematchIcon(button)
		end
	end

	toolbar:StripTextures()
	module.RematchButton(toolbar.TotalsButton)

	for _, name in pairs({ "SummonButton", "SaveButton", "SaveAsButton", "FindBattleButton" }) do
		local button = _G.Rematch.bottombar[name]
		if button then
			module.RematchButton(button)
		end
	end

	-- RematchPetPanel
	local petsPanel = _G.Rematch.petsPanel
	petsPanel.Top:StripTextures()
	module.RematchButton(petsPanel.Top.ToggleButton)
	petsPanel.Top.ToggleButton.Back:Hide()
	petsPanel.Top.TypeBar.TabbedBorder:SetAlpha(0)
	for i = 1, 10 do
		module.RematchIcon(petsPanel.Top.TypeBar.Buttons[i])
	end

	module.RematchInset(petsPanel.ResultsBar)
	module.RematchInput(petsPanel.Top.SearchBox)
	module.RematchFilter(petsPanel.Top.FilterButton)
	module.RematchScroll(petsPanel.List)
	module.RematchPetList(petsPanel.List)

	-- RematchLoadedTeamPanel
	local loadoutPanel = _G.Rematch.loadoutPanel
	loadoutPanel:StripTextures()
	loadoutPanel:CreateBackdrop("Transparent")
	bg = loadoutPanel.backdrop
	bg:SetBackdropColor(1, 0.8, 0, 0.1)
	bg:SetPoint("TOPLEFT", -E.mult, -E.mult)
	bg:SetPoint("BOTTOMRIGHT", E.mult, E.mult)

	module.RematchButton(_G.Rematch.loadedTeamPanel.TeamButton)
	_G.Rematch.loadedTeamPanel.NotesFrame:StripTextures()
	module.RematchButton(_G.Rematch.loadedTeamPanel.NotesFrame.NotesButton)

	-- RematchLoadoutPanel
	local target = _G.Rematch.loadedTargetPanel
	target:StripTextures()
	target:CreateBackdrop("Transparent")
	module.RematchButton(target.BigLoadSaveButton)

	-- Teams
	local team = _G.Rematch.teamsPanel
	team.Top:StripTextures()
	module.RematchInput(team.Top.SearchBox)
	module.RematchFilter(team.Top.TeamsButton)
	module.RematchScroll(team.List)
	module.RematchCollapse(team.Top.AllButton)
	module.RematchHeaders(team.List)

	-- Targets
	local targets = _G.Rematch.targetsPanel
	targets.Top:StripTextures()
	module.RematchInput(targets.Top.SearchBox)
	module.RematchScroll(targets.List)
	module.RematchCollapse(targets.Top.AllButton)
	module.RematchHeaders(targets.List)

	-- Queue
	local queue = _G.Rematch.queuePanel
	queue.Top:StripTextures()
	module.RematchFilter(queue.Top.QueueButton)
	module.RematchScroll(queue.List)
	queue.PreferencesFrame:StripTextures()
	S:HandleButton(queue.PreferencesFrame.PreferencesButton)
	module.RematchPetList(queue.List)

	-- Options
	local options = _G.Rematch.optionsPanel
	options.Top:StripTextures()
	module.RematchInput(options.Top.SearchBox)
	module.RematchScroll(options.List)
	module.RematchCollapse(options.Top.AllButton)
	module.RematchHeaders(options.List)

	-- side tabs
	hooksecurefunc(_G.Rematch.teamTabs, "Configure", function(self)
		for i = 1, #self.Tabs do
			local tab = self.Tabs[i]
			if tab and not tab.MERSkin then
				tab:StripTextures()
				tab.IconMask:Hide()
				S:HandleIcon(tab.Icon)

				tab.MERSkin = true
			end
		end
	end)

	if true then
		return
	end

	-- RematchPetCard
	local petCard = _G.RematchPetCard
	petCard:StripTextures()
	S:HandleCloseButton(petCard.CloseButton)
	petCard.Title:StripTextures()
	petCard.PinButton:StripTextures()
	module.ReskinArrow(petCard.PinButton, "up")
	petCard.PinButton:SetPoint("TOPLEFT", 5, -5)
	petCard.Title:CreateBackdrop("Transparent")
	bg = petCard.Title.backdrop
	bg:SetAllPoints(petCard)
	module.RematchCard(petCard.Front)
	module.RematchCard(petCard.Back)

	for i = 1, 6 do
		local button = _G.RematchPetCard.Front.Bottom.Abilities[i]
		button.IconBorder:Hide()
		select(8, button:GetRegions()):SetTexture(nil)
		S:HandleIcon(button.Icon)
	end

	-- RematchAbilityCard
	local abilityCard = _G.RematchAbilityCard
	abilityCard:StripTextures()
	abilityCard:CreateBackdrop("Transparent")
	abilityCard.Hints.HintsBG:Hide()

	-- RematchWinRecordCard
	local card = _G.RematchWinRecordCard
	card:StripTextures()
	S:HandleClose(card.CloseButton)
	card.Content:StripTextures()
	card.Content:CreateBackdrop("Transparent")
	bg = card.Content.backdrop
	bg:SetPoint("TOPLEFT", 2, -2)
	bg:SetPoint("BOTTOMRIGHT", -2, 2)
	-- local bg = B.SetBD(card.Content)
	-- bg:SetAllPoints(card)
	for _, result in pairs({ "Wins", "Losses", "Draws" }) do
		module.RematchInput(card.Content[result].EditBox)
		card.Content[result].Add.IconBorder:Hide()
	end
	S:HandleButton(card.Controls.ResetButton)
	S:HandleButton(card.Controls.SaveButton)
	S:HandleButton(card.Controls.CancelButton)

	-- RematchDialog
	local dialog = _G.RematchDialog
	dialog:StripTextures()
	dialog:CreateBackdrop("Transparent")
	S:HandleCloseButton(dialog.CloseButton)

	module.RematchIcon(dialog.Slot)
	module.RematchInput(dialog.EditBox)
	dialog.Prompt:StripTextures()
	S:HandleButton(dialog.Accept)
	S:HandleButton(dialog.Cancel)
	S:HandleButton(dialog.Other)
	S:HandleCheckBox(dialog.CheckButton)
	module.RematchInput(dialog.SaveAs.Name)
	module.RematchInput(dialog.Send.EditBox)
	module.RematchDropdown(dialog.SaveAs.Target)
	module.RematchDropdown(dialog.TabPicker)
	module.RematchIcon(dialog.Pet.Pet)
	S:HandleRadioButton(dialog.ConflictRadios.MakeUnique)
	S:HandleRadioButton(dialog.ConflictRadios.Overwrite)

	local preferences = dialog.Preferences
	module.RematchInput(preferences.MinHP)
	S:HandleCheckBox(preferences.AllowMM)
	module.RematchInput(preferences.MaxHP)
	module.RematchInput(preferences.MinXP)
	module.RematchInput(preferences.MaxXP)

	local iconPicker = dialog.TeamTabIconPicker
	S:HandleScrollBar(iconPicker.ScrollFrame.ScrollBar)
	iconPicker:StripTextures()
	iconPicker:CreateBackdrop("Transparent")
	module.RematchInput(iconPicker.SearchBox)

	S:HandleScrollBar(dialog.MultiLine.ScrollBar)
	select(2, dialog.MultiLine:GetChildren()):HideBackdrop()
	dialog.MultiLine:CreateBackdrop("Transparent")
	bg = dialog.MultiLine.backdrop
	bg:SetPoint("TOPLEFT", -5, 5)
	bg:SetPoint("BOTTOMRIGHT", 5, -5)
	S:HandleCheckBox(dialog.ShareIncludes.IncludePreferences)
	S:HandleCheckBox(dialog.ShareIncludes.IncludeNotes)

	local report = dialog.CollectionReport
	module.RematchDropdown(report.ChartTypeComboBox)
	report.Chart:StripTextures()
	report.Chart:CreateBackdrop("Transparent")
	bg = report.Chart.backdrop
	bg:SetPoint("TOPLEFT", -E.mult, -3)
	bg:SetPoint("BOTTOMRIGHT", E.mult, 2)
	S:HandleRadioButton(report.ChartTypesRadioButton)
	S:HandleRadioButton(report.ChartSourcesRadioButton)

	local border = report.RarityBarBorder
	border:Hide()
	border:CreateBackdrop("Transparent")
	bg = border.backdrop
	bg:SetPoint("TOPLEFT", border, 6, -5)
	bg:SetPoint("BOTTOMRIGHT", border, -6, 5)

	isSkinned = true
end

local function resizeJournal()
	local frame = _G.Rematch and _G.Rematch.frame
	if not frame then
		return
	end

	local isShown = frame:IsShown() and frame
	CollectionsJournal.backdrop:SetPoint("BOTTOMRIGHT", isShown or CollectionsJournal, E.mult, -E.mult)
	CollectionsJournal.CloseButton:SetAlpha(isShown and 0 or 1)
end

function module:OnShow()
	local frame = _G.Rematch and _G.Rematch.frame
	if not frame or frame.isSkinned then
		return
	end

	resizeJournal()

	hooksecurefunc("PetJournal_UpdatePetLoadOut", resizeJournal)
	hooksecurefunc("CollectionsJournal_UpdateSelectedTab", resizeJournal)

	frame:StripTextures()
	frame.TitleBar.Portrait:SetAlpha(0)
	S:HandleCloseButton(frame.TitleBar.CloseButton)

	local tabs = frame.PanelTabs
	for i = 1, tabs:GetNumChildren() do
		local tab = select(i, tabs:GetChildren())
		tab.Highlight:SetAlpha(0)
		S:HandleTab(tab)
	end

	S:HandleCheckBox(frame.BottomBar.UseRematchCheckButton)

	frame.isSkinned = true
end
function module:Rematch()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.rem then
		return
	end

	local frame = _G.Rematch and _G.Rematch.frame
	if not frame then
		return
	end

	if _G.RematchSettings then
		_G.RematchSettings.ColorPetNames = true
		_G.RematchSettings.FixedPetCard = true
	end

	frame:HookScript("OnShow", module.OnShow)
	module:ReskinRematchElements()

	local journal = _G.Rematch.journal
	hooksecurefunc(journal, "PetJournalOnShow", function()
		if journal.isSkinned then
			return
		end
		S:HandleCheckBox(journal.UseRematchCheckButton)

		journal.isSkinned = true
	end)

	hooksecurefunc(_G.RematchNotesCard, "Update", function(self)
		if self.isSkinned then
			return
		end

		self:StripTextures()
		S:HandleCloseButton(self.CloseButton)
		module:RematchLockButton(self.LockButton)
		self.LockButton:SetPoint("TOPLEFT")

		local content = self.Content
		S:HandleScrollBar(content.ScrollFrame.ScrollBar)
		content.ScrollFrame:CreateBafkdrop("Transparent")
		local bg = content.ScrollFrame.backdrop
		bg:SetPoint("TOPLEFT", 0, 5)
		bg:SetPoint("BOTTOMRIGHT", 0, -2)

		module.RematchButton(self.Content.Bottom.DeleteButton)
		module.RematchButton(self.Content.Bottom.UndoButton)
		module.RematchButton(self.Content.Bottom.SaveButton)

		self.isSkinned = true
	end)

	local loadoutBG
	hooksecurefunc(_G.Rematch.loadoutPanel, "Update", function(self)
		if not self then
			return
		end

		for i = 1, 3 do
			local loadout = self.Loadouts[i]
			if not loadout.isSkinned then
				for i = 1, 9 do
					select(i, loadout:GetRegions()):Hide()
				end
				loadout.Pet.Border:SetAlpha(0)
				loadout:CreateBackdrop("Transparent")
				loadoutBG = loadout.backdrop
				loadoutBG:SetPoint("BOTTOMRIGHT", E.mult, E.mult)
				module.RematchIcon(loadout.Pet)
				module.RematchXP(loadout.HpBar)
				module.RematchXP(loadout.XpBar)

				loadout.isSkinned = true
			end

			local icon = loadout.Pet.Icon
			local iconBorder = loadout.Pet.Border
			if icon.bg then
				local r, g, b = iconBorder:GetVertexColor()
				icon.bg:SetBackdropBorderColor(r, g, b)
			end
		end
	end)
end

module:AddCallbackForAddon("Rematch")
