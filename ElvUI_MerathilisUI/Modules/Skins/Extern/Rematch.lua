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

	S:HandleButton(self)
	self:DisableDrawLayer("BACKGROUND")
	self:DisableDrawLayer("BORDER")

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

function module:RematchXP(bar) -- Fix me
	if not bar or bar.isSkinned then
		return
	end

	bar:StripTextures()
	bar:CreateBackdrop("Transparent")
	bar:SetTexture(E.media.normTex)
	E:RegisterStatusBar(bar)

	bar.isSkinned = true
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
	self.Bottom.backdrop:Point("TOPLEFT", -E.mult, -3)
end

function module:RematchInset()
	self:StripTextures()
	self:CreateBackdrop("Transparent")
	local bg = self.backdrop
	bg:Point("TOPLEFT", 3, 0)
	bg:Point("BOTTOMRIGHT", -3, 0)
end

function module:RematchLockButton(button)
	button:StripTextures()
	button:CreateBackdrop("Transparent")
	local bg = button.backdrop
	bg:SetInside(7, 7)
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
	toolbar.TotalsButton:StripTextures()
	toolbar.TotalsButton:CreateBackdrop("Transparent")

	for _, name in pairs({ "SummonButton", "SaveButton", "SaveAsButton", "FindBattleButton" }) do
		local button = _G.Rematch.bottombar[name]
		if button then
			S:HandleButton(button)
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

	-- Teams
	local team = _G.Rematch.teamsPanel
	team.Top:StripTextures()
	module.RematchInput(team.Top.SearchBox)
	module.RematchFilter(team.Top.TeamsButton)
	module.RematchScroll(team.List)
	module.RematchCollapse(team.Top.AllButton)
	module.RematchHeaders(team.List)

	local function skinList(...)
		local _, element
		if _G.select("#", ...) == 2 then
			element, _ = ...
		else
			_, element, _ = ...
		end
		if element.teamID then
			element.Back:SetTexture(nil)
			element.Back:CreateBackdrop("Transparent")
			element.Back.backdrop:SetAllPoints()

			element.Border:SetTexture(nil)
		end
	end
	_G.ScrollUtil.AddInitializedFrameCallback(team.List.ScrollBox, skinList)

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
	local petCard = RematchPetCard
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
		local button = RematchPetCard.Front.Bottom.Abilities[i]
		button.IconBorder:Hide()
		select(8, button:GetRegions()):SetTexture(nil)
		S:HandleIcon(button.Icon)
	end

	-- RematchAbilityCard
	local abilityCard = RematchAbilityCard
	abilityCard:StripTextures()
	abilityCard:CreateBackdrop("Transparent")
	abilityCard.Hints.HintsBG:Hide()

	-- RematchWinRecordCard
	local card = RematchWinRecordCard
	card:StripTextures()
	S:HandleClose(card.CloseButton)
	card.Content:StripTextures()
	card.Content:CreateBackdrop("Transparent")
	bg = card.Content.backdrop
	bg:SetPoint("TOPLEFT", 2, -2)
	bg:SetPoint("BOTTOMRIGHT", -2, 2)

	for _, result in pairs({ "Wins", "Losses", "Draws" }) do
		module.RematchInput(card.Content[result].EditBox)
		card.Content[result].Add.IconBorder:Hide()
	end
	S:HandleButton(card.Controls.ResetButton)
	S:HandleButton(card.Controls.SaveButton)
	S:HandleButton(card.Controls.CancelButton)

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

function module:RematchDialog_OnShow()
	if self.isSkinned then
		return
	end

	self:StripTextures()
	self.Prompt:DisableDrawLayer("BACKGROUND")
	self.Prompt:DisableDrawLayer("BORDER")
	self:CreateBackdrop("Transparent")
	self.backdrop:SetAllPoints()
	S:HandleCloseButton(self.CloseButton)

	self.Prompt:StripTextures()
	if self.AcceptButton then
		S:HandleButton(self.AcceptButton)
	end
	if self.CancelButton then
		S:HandleButton(self.CancelButton)
	end
	if self.OtherButton then
		S:HandleButton(self.OtherButton)
	end

	self.Canvas.TeamPicker.Lister.Top.Back:SetTexture(nil)

	if self.Canvas.TeamPicker.Lister.Top.AddButton then
		S:HandleButton(self.Canvas.TeamPicker.Lister.Top.AddButton)
	end
	if self.Canvas.TeamPicker.Lister.Top.DeleteButton then
		S:HandleButton(self.Canvas.TeamPicker.Lister.Top.DeleteButton)
	end
	if self.Canvas.TeamPicker.Lister.Top.UpButton then
		S:HandleButton(self.Canvas.TeamPicker.Lister.Top.UpButton)
	end
	if self.Canvas.TeamPicker.Lister.Top.DownButton then
		S:HandleButton(self.Canvas.TeamPicker.Lister.Top.DownButton)
	end

	if self.Canvas.TeamPicker.Picker.Top.AllButton then
		S:HandleButton(self.Canvas.TeamPicker.Picker.Top.AllButton)
	end

	self.isSkinned = true
end

function module:RematchLoadoutPanel_OnShow()
	if self.isSkinned then
		return
	end

	self.InsetBack:SetTexture(nil)
	self:StripTextures()
	self:CreateBackdrop("Transparent")
	S:HandleButton(self.AllyTeam.PrevTeamButton)
	S:HandleButton(self.AllyTeam.NextTeamButton)
	S:HandleButton(self.SmallSaveButton)
	S:HandleButton(self.SmallTeamsButton)
	S:HandleButton(self.SmallRandomButton)
	S:HandleButton(self.MediumLoadButton)
	S:HandleButton(self.BigLoadSaveButton)

	self.isSkinned = true
end

function module:RematchLoadedTeamPanel_OnShow()
	if self.isSkinned then
		return
	end

	-- RematchLoadedTeamPanel
	self:StripTextures()
	self:CreateBackdrop("Transparent")
	self.backdrop:SetBackdropColor(1, 0.8, 0, 0.1)
	self.backdrop:SetPoint("TOPLEFT", -E.mult, -E.mult)
	self.backdrop:SetPoint("BOTTOMRIGHT", E.mult, E.mult)

	module.RematchButton(self.TeamButton)
	self.NotesFrame:StripTextures()
	module.RematchButton(self.NotesFrame.NotesButton)
end

function module:Rematch_Initialize()
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

	self:SecureHookScript(_G.RematchDialog, "OnShow", module.RematchDialog_OnShow)
	self:SecureHookScript(_G.Rematch.loadedTargetPanel, "OnShow", module.RematchLoadoutPanel_OnShow)
	self:SecureHookScript(_G.Rematch.loadedTeamPanel, "OnShow", module.RematchLoadedTeamPanel_OnShow)

	local journal = _G.Rematch.journal
	hooksecurefunc(journal, "PetJournalOnShow", function()
		if journal.isSkinned then
			return
		end
		S:HandleCheckBox(journal.UseRematchCheckButton)

		journal.isSkinned = true
	end)

	hooksecurefunc(_G.RematchNotesCard, "Update", function(card)
		if not card or card.isSkinned then
			return
		end

		card:StripTextures()
		card:CreateBackdrop("Transparent")
		S:HandleCloseButton(card.CloseButton)
		module:RematchLockButton(card.LockButton)
		card.LockButton:SetPoint("TOPLEFT")

		local content = card.Content
		S:HandleScrollBar(content.ScrollFrame.ScrollBar)
		content.ScrollFrame:CreateBackdrop("Transparent")
		local bg = content.ScrollFrame.backdrop
		bg:SetPoint("TOPLEFT", 0, 5)
		bg:SetPoint("BOTTOMRIGHT", 0, -2)

		if card.Content.Bottom.DeleteButton then
			S:HandleButton(card.Content.Bottom.DeleteButton)
		end
		if card.Content.Bottom.UndoButton then
			S:HandleButton(card.Content.Bottom.UndoButton)
		end
		if card.Content.Bottom.SaveButton then
			S:HandleButton(card.Content.Bottom.SaveButton)
		end

		card.isSkinned = true
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

function module:Rematch()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.rem then
		return
	end

	E:Delay(0.3, function()
		self:Rematch_Initialize()
	end)
end

module:AddCallbackForAddon("Rematch")
module:AddCallbackForUpdate("Rematch")
