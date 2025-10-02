local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local A = MER:GetModule("MER_AchievementTracker") ---@class AchievementTracker
local MF = MER:GetModule("MER_MoveFrames") ---@type MoveFrames
local S = MER:GetModule("MER_Skins") ---@type Skins
local C = MER.Utilities.Color

local _G = _G
local pairs = pairs
local ipairs = ipairs
local max = max
local floor = floor
local format = format
local InCombatLockdown = InCombatLockdown

local C_ContentTracking_GetTrackedIDs = C_ContentTracking.GetTrackedIDs
local C_ContentTracking_IsTracking = C_ContentTracking.IsTracking
local C_ContentTracking_StartTracking = C_ContentTracking.StartTracking
local C_ContentTracking_StopTracking = C_ContentTracking.StopTracking
local Constants_ContentTrackingConsts = Constants.ContentTrackingConsts
local CreateFrame = CreateFrame
local Enum_ContentTrackingStopType = Enum.ContentTrackingStopType
local Enum_ContentTrackingType = Enum.ContentTrackingType
local GameTooltip = _G.GameTooltip
local PlaySound = PlaySound
local SOUNDKIT = SOUNDKIT
local UIErrorsFrame = _G.UIErrorsFrame

function A:CreateAchievementTrackerPanel()
	if self.MainFrame then
		return
	end

	---@class MER_AchievementTracker : Frame, BackdropTemplate
	local MainFrame = CreateFrame("Frame", "MER_AchievementTracker", _G.AchievementFrame, "BackdropTemplate")
	MainFrame:Size(self.db.panel.width, self.db.panel.height)
	MainFrame:Point("TOPLEFT", _G.AchievementFrame, "TOPRIGHT", 10, 0)
	MainFrame:SetTemplate("Transparent")
	S:CreateShadow(MainFrame)
	MF:InternalHandle(MainFrame, _G.AchievementFrame)
	self.MainFrame = MainFrame

	local SearchBox = CreateFrame("EditBox", nil, MainFrame, "SearchBoxTemplate")
	SearchBox:Size(self.db.panel.width - 28, 24)
	SearchBox:Point("TOP", MainFrame, "TOP", 0, -10)
	SearchBox:SetAutoFocus(false)
	SearchBox:SetMaxLetters(50)
	S:Proxy("HandleEditBox", SearchBox)
	SearchBox:SetScript("OnTextChanged", function(editBox)
		A.States.searchTerm = editBox:GetText()
		A:ApplyFiltersAndSort()
		A:UpdateAchievementList()
	end)
	SearchBox:SetScript("OnEscapePressed", function(editBox)
		editBox:ClearFocus()
	end)
	MainFrame.SearchBox = SearchBox

	local ControlFrame1 = CreateFrame("Frame", nil, MainFrame, "BackdropTemplate")
	ControlFrame1:Size(self.db.panel.width - 20, 40)
	ControlFrame1:Point("TOP", SearchBox, "BOTTOM", 0, -5)
	ControlFrame1:SetTemplate("Transparent")
	MainFrame.ControlFrame1 = ControlFrame1

	local ThresholdSlider = CreateFrame("Slider", nil, ControlFrame1, "OptionsSliderTemplate")
	ThresholdSlider:SetOrientation("HORIZONTAL")
	ThresholdSlider:Size(120, 14)
	ThresholdSlider:Point("LEFT", ControlFrame1, "LEFT", 15, 0)
	ThresholdSlider:SetMinMaxValues(self.db.threshold.min, self.db.threshold.max)
	ThresholdSlider:SetValueStep(1)
	ThresholdSlider:SetObeyStepOnDrag(true)
	ThresholdSlider:SetValue(A.States.currentThreshold)
	ThresholdSlider.Text:Point("BOTTOM", ThresholdSlider, "TOP", 0, 2)
	ThresholdSlider.Text:SetText(L["Threshold"] .. ": " .. A.States.currentThreshold .. "%")
	ThresholdSlider.Text:SetTextColor(0.9, 0.9, 0.9)
	F.SetFontOutline(ThresholdSlider.Text)
	S:Proxy("HandleSliderFrame", ThresholdSlider)
	ThresholdSlider:SetScript("OnValueChanged", function(slider, value)
		A.States.currentThreshold = floor(value)
		slider.Text:SetText(L["Threshold"] .. ": " .. A.States.currentThreshold .. "%")
	end)
	ControlFrame1.ThresholdSlider = ThresholdSlider

	local SortDropdown = CreateFrame("DropdownButton", nil, ControlFrame1, "WowStyle1DropdownTemplate")
	SortDropdown:Point("LEFT", ThresholdSlider, "RIGHT", 15, 0)

	local sortOptions = {
		{ text = L["Percentage"], value = "percent" },
		{ text = L["Name"], value = "name" },
		{ text = L["Category"], value = "category" },
	}
	local sortTexts = {}
	for _, option in ipairs(sortOptions) do
		sortTexts[#sortTexts + 1] = option.text
	end
	local dropdownWidth = 40 + max(40, F.GetAdaptiveTextWidth(E.media.normFont, 12, "OUTLINE", sortTexts))
	S:Proxy("HandleDropDownBox", SortDropdown, dropdownWidth)
	SortDropdown:SetupMenu(function(_, rootDescription)
		for _, option in ipairs(sortOptions) do
			rootDescription:CreateRadio(option.text, function()
				return self.States.sortBy == option.value
			end, function()
				self.States.sortBy = option.value
				self:ApplyFiltersAndSort()
				self:UpdateAchievementList()
			end, option.value)
		end
	end)

	local SortOrderButton = CreateFrame("Button", nil, ControlFrame1, "UIPanelButtonTemplate")
	SortOrderButton:Size(30, 22)
	SortOrderButton:Point("LEFT", SortDropdown, "RIGHT", 8, 0)
	S:Proxy("HandleButton", SortOrderButton)

	SortOrderButton.arrow = SortOrderButton:CreateTexture(nil, "OVERLAY")
	SortOrderButton.arrow:Size(16)
	SortOrderButton.arrow:Point("CENTER")
	SortOrderButton.arrow:SetTexture(I.Media.Textures.arrow)
	SortOrderButton.arrow:SetVertexColor(1, 1, 1)

	---@return nil
	local function UpdateArrow()
		SortOrderButton.arrow:SetRotation(self.States.sortOrder == "desc" and 0 or 3.14)
	end

	UpdateArrow()

	SortOrderButton:SetScript("OnClick", function()
		local newOrder = self.States.sortOrder == "desc" and "asc" or "desc"
		self.States.sortOrder = newOrder
		UpdateArrow()
		self:ApplyFiltersAndSort()
		self:UpdateAchievementList()
	end)

	local RefreshButton = CreateFrame("Button", nil, ControlFrame1, "UIPanelButtonTemplate")
	RefreshButton:Size(60, 22)
	RefreshButton:Point("RIGHT", ControlFrame1, "RIGHT", -15, 0)
	RefreshButton:SetText(L["Refresh"])
	RefreshButton.Text:SetTextColor(1, 0.8, 0)
	F.SetFontOutline(RefreshButton.Text)
	S:Proxy("HandleButton", RefreshButton)
	RefreshButton:SetScript("OnClick", function()
		self:StartAchievementScan()
	end)
	ControlFrame1.RefreshButton = RefreshButton

	local ControlFrame2 = CreateFrame("Frame", nil, MainFrame, "BackdropTemplate")
	ControlFrame2:Size(self.db.panel.width - 20, 32)
	ControlFrame2:Point("TOP", ControlFrame1, "BOTTOM", 0, -5)
	ControlFrame2:SetTemplate("Transparent")
	MainFrame.ControlFrame2 = ControlFrame2

	local CategoryDropdown = CreateFrame("DropdownButton", nil, ControlFrame2, "WowStyle1DropdownTemplate")
	CategoryDropdown:Point("LEFT", ControlFrame2, "LEFT", 10, 0)
	S:Proxy("HandleDropDownBox", CategoryDropdown, 150)
	CategoryDropdown:SetupMenu(function(_, rootDescription)
		rootDescription:CreateRadio(L["All Categories"] or "All Categories", function()
			return self.States.selectedCategory == nil
		end, function()
			self.States.selectedCategory = nil
			self:ApplyFiltersAndSort()
			self:UpdateAchievementList()
		end)

		rootDescription:CreateDivider()

		local categories = self:GetUniqueCategories()
		for _, categoryName in ipairs(categories) do
			rootDescription:CreateRadio(categoryName, function()
				return self.States.selectedCategory == categoryName
			end, function()
				self.States.selectedCategory = categoryName
				self:ApplyFiltersAndSort()
				self:UpdateAchievementList()
			end)
		end
	end)
	ControlFrame2.CategoryDropdown = CategoryDropdown

	local NearlyCompleteButton = CreateFrame("Button", nil, ControlFrame2, "UIPanelButtonTemplate")
	NearlyCompleteButton:Size(90, 22)
	NearlyCompleteButton:Point("LEFT", CategoryDropdown, "RIGHT", 8, 0)
	NearlyCompleteButton:SetText("95%+")
	NearlyCompleteButton.Text:SetTextColor(1, 1, 1)
	F.SetFontOutline(NearlyCompleteButton.Text)
	S:Proxy("HandleButton", NearlyCompleteButton)
	NearlyCompleteButton:SetScript("OnClick", function()
		self.States.currentThreshold = 95
		ThresholdSlider:SetValue(95)
		self:StartAchievementScan()
	end)
	ControlFrame2.NearlyCompleteButton = NearlyCompleteButton

	local RewardsFilterButton = CreateFrame("Button", nil, ControlFrame2, "UIPanelButtonTemplate")
	RewardsFilterButton:Size(70, 22)
	RewardsFilterButton:Point("LEFT", NearlyCompleteButton, "RIGHT", 5, 0)
	RewardsFilterButton:SetText(L["Rewards"] or "Rewards")
	RewardsFilterButton.Text:SetTextColor(1, 1, 1)
	F.SetFontOutline(RewardsFilterButton.Text)
	S:Proxy("HandleButton", RewardsFilterButton)
	local function UpdateRewardsButtonState()
		if self.States.showOnlyRewards then
			RewardsFilterButton:SetBackdropBorderColor(0, 1, 0, 1)
		else
			RewardsFilterButton:SetBackdropBorderColor(0, 0, 0, 1)
		end
	end
	RewardsFilterButton:SetScript("OnClick", function()
		local newState = not self.States.showOnlyRewards
		self.States.showOnlyRewards = newState
		UpdateRewardsButtonState()
		self:ApplyFiltersAndSort()
		self:UpdateAchievementList()
	end)
	UpdateRewardsButtonState()
	ControlFrame2.RewardsFilterButton = RewardsFilterButton

	local ShowAllButton = CreateFrame("Button", nil, ControlFrame2, "UIPanelButtonTemplate")
	ShowAllButton:Size(60, 22)
	ShowAllButton:Point("RIGHT", ControlFrame2, "RIGHT", -10, 0)
	ShowAllButton:SetText(L["Show All"] or "All")
	ShowAllButton.Text:SetTextColor(1, 0.8, 0)
	F.SetFontOutline(ShowAllButton.Text)
	S:Proxy("HandleButton", ShowAllButton)
	ShowAllButton:SetScript("OnClick", function()
		self.States.searchTerm = ""
		self.States.selectedCategory = nil
		self.States.showOnlyRewards = false
		self.States.currentThreshold = self.db.threshold.min
		ThresholdSlider:SetValue(self.db.threshold.min)
		SearchBox:SetText("")
		UpdateRewardsButtonState()
		self:StartAchievementScan()
	end)
	ControlFrame2.ShowAllButton = ShowAllButton

	local ScrollFrame = CreateFrame("ScrollFrame", nil, MainFrame, "UIPanelScrollFrameTemplate")
	ScrollFrame:Size(self.db.panel.width - 20, self.db.panel.height - 140)
	ScrollFrame:Point("TOP", ControlFrame2, "BOTTOM", 0, -5)
	ScrollFrame.ScrollBar:Point("TOPRIGHT", ScrollFrame, "TOPRIGHT", -2, -2)
	ScrollFrame.ScrollBar:Point("BOTTOMRIGHT", ScrollFrame, "BOTTOMRIGHT", -2, 2)
	S:Proxy("HandleScrollBar", ScrollFrame.ScrollBar)
	MainFrame.ScrollFrame = ScrollFrame

	local ScrollContent = CreateFrame("Frame", nil, ScrollFrame)
	ScrollContent:Size(self.db.panel.width - 20, 100)
	ScrollFrame:SetScrollChild(ScrollContent)
	ScrollFrame.Content = ScrollContent

	local ProgressFrame = CreateFrame("Frame", nil, MainFrame)
	ProgressFrame:SetFrameStrata("DIALOG")
	ProgressFrame:SetAllPoints(MainFrame)
	MainFrame.ProgressFrame = ProgressFrame

	local ProgressBar = CreateFrame("StatusBar", nil, ProgressFrame)
	ProgressBar:Size(self.db.panel.width - 50, 26)
	ProgressBar:Point("CENTER", ProgressFrame, "CENTER")
	ProgressBar:SetStatusBarTexture(E.media.normTex)
	ProgressBar:SetMinMaxValues(0, 100)
	ProgressBar:SetValue(0)
	ProgressBar:GetStatusBarTexture():SetVertexColor(1, 1, 1)
	ProgressBar:GetStatusBarTexture():SetGradient(
		"HORIZONTAL",
		C.CreateColorFromTable({ r = 0.32941, g = 0.52157, b = 0.93333, a = 1 }),
		C.CreateColorFromTable({ r = 0.25882, g = 0.84314, b = 0.86667, a = 1 })
	)
	ProgressBar:CreateBackdrop("Transparent")
	ProgressFrame.Bar = ProgressBar

	local ProgressLabel = ProgressFrame:CreateFontString(nil, "OVERLAY")
	F.SetFontOutline(ProgressLabel, E.db.general.font, E.db.general.fontSize + 12)
	ProgressLabel:Point("BOTTOM", ProgressBar, "TOP", 0, 20)
	ProgressLabel:SetText(L["Scanning"])
	ProgressLabel:SetTextColor(C.ExtractRGBAFromTemplate("amber-400"))
	ProgressFrame.Label = ProgressLabel

	local ProgressBarProgressText = ProgressBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	F.SetFontOutline(ProgressBarProgressText, E.db.general.font, 14)
	ProgressBarProgressText:SetTextColor(C.ExtractRGBAFromTemplate("neutral-50"))
	ProgressBarProgressText:Point("CENTER", ProgressBar, "CENTER", 0, -1)
	ProgressBar.ProgressText = ProgressBarProgressText
	self:Hook(ProgressFrame, "Show", function()
		SearchBox:ClearFocus()
		SearchBox:Hide()
		ControlFrame1:Hide()
		ControlFrame2:Hide()
		ScrollFrame:Hide()
	end, true)
	self:SecureHook(ProgressFrame, "Hide", function()
		SearchBox:Show()
		ControlFrame1:Show()
		ControlFrame2:Show()
		ScrollFrame:Show()
	end)

	MainFrame.UpdateDropdowns = function()
		SortDropdown:GenerateMenu()
		CategoryDropdown:GenerateMenu()
	end

	MainFrame.ProgressFrame:Hide()
end

---Update the achievement list display
---@return nil
function A:UpdateAchievementList()
	if not self.MainFrame or InCombatLockdown() then
		return
	end

	local Content = self.MainFrame.ScrollFrame.Content

	for _, child in pairs({ Content:GetChildren() }) do
		child:Hide()
		child:SetParent(nil)
	end

	local yOffset = -8
	for _, achievement in ipairs(self.States.filteredResults) do
		local isExpanded = self.States.expandedAchievements[achievement.id] or false
		local buttonHeight = self.db.button.height

		if isExpanded and achievement.criteria then
			local criteriaCount = #achievement.criteria
			buttonHeight = buttonHeight + (criteriaCount * 18) + 12
		end

		local Button = CreateFrame("Button", nil, Content, "UIPanelButtonTemplate")
		Button:Size(self.db.panel.width - 40, buttonHeight)
		Button:Point("TOPLEFT", Content, "TOPLEFT", 10, yOffset)

		S:Proxy("HandleButton", Button)

		local ExpandArrow = Button:CreateTexture(nil, "OVERLAY")
		ExpandArrow:Size(12)
		ExpandArrow:Point("LEFT", Button, "LEFT", 4, 0)
		ExpandArrow:SetTexture(I.Media.Textures.arrow)
		ExpandArrow:SetVertexColor(0.8, 0.8, 0.8)
		ExpandArrow:SetRotation(isExpanded and 0 or -1.57)

		local IconFrame = CreateFrame("Frame", nil, Button)
		IconFrame:Size(A.Config.ICON_SIZE, A.Config.ICON_SIZE)
		IconFrame:Point("TOPLEFT", Button, "TOPLEFT", 20, -10)
		IconFrame:SetTemplate("Transparent")

		local Icon = IconFrame:CreateTexture(nil, "ARTWORK")
		Icon:Size(A.Config.ICON_SIZE - 4, A.Config.ICON_SIZE - 4)
		Icon:Point("CENTER", IconFrame, "CENTER", 0, 0)
		Icon:SetTexture(achievement.icon)
		Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

		local ProgressBar = CreateFrame("StatusBar", nil, Button)
		ProgressBar:Size(self.db.button.progressWidth, 12)
		ProgressBar:Point("TOPRIGHT", Button, "TOPRIGHT", -10, -18)
		ProgressBar:SetStatusBarTexture(E.media.normTex)
		ProgressBar:SetMinMaxValues(0, 100)
		ProgressBar:SetValue(achievement.percent)

		local color
		if achievement.percent >= 90 then
			color = C.GetRGBFromTemplate("emerald-500")
		elseif achievement.percent >= 75 then
			color = C.GetRGBFromTemplate("green-500")
		elseif achievement.percent >= 60 then
			color = C.GetRGBFromTemplate("yellow-500")
		else
			color = C.GetRGBFromTemplate("orange-500")
		end
		ProgressBar:SetStatusBarColor(color.r, color.g, color.b)
		ProgressBar:CreateBackdrop("Transparent")

		local ProgressText = ProgressBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		ProgressText:Point("CENTER", ProgressBar, "CENTER", 0, 0)
		ProgressText:SetText(format("%.0f%%", achievement.percent))
		ProgressText:SetTextColor(1, 1, 1)
		F.SetFontOutline(ProgressText)

		local NameText = Button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		NameText:Point("LEFT", IconFrame, "RIGHT", 10, 6)
		NameText:Point("RIGHT", ProgressBar, "LEFT", -10, 6)
		NameText:SetText(achievement.name)
		NameText:SetTextColor(1, 1, 1)
		NameText:SetJustifyH("LEFT")
		F.SetFontOutline(NameText)

		local CategoryText = Button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		CategoryText:Point("LEFT", IconFrame, "RIGHT", 10, -6)
		CategoryText:Point("RIGHT", ProgressBar, "LEFT", -10, -6)
		CategoryText:SetText(achievement.categoryName)
		CategoryText:SetTextColor(0.7, 0.7, 0.7)
		CategoryText:SetJustifyH("LEFT")
		F.SetFontOutline(CategoryText)

		local CriteriaText = Button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		CriteriaText:Point("LEFT", IconFrame, "RIGHT", 10, -18)
		CriteriaText:Point("RIGHT", ProgressBar, "LEFT", -10, -18)
		CriteriaText:SetText(format(L["%d/%d criteria"], achievement.completedCriteria, achievement.totalCriteria))
		CriteriaText:SetTextColor(0.6, 0.6, 0.6)
		CriteriaText:SetJustifyH("LEFT")
		F.SetFontOutline(CriteriaText)

		local RewardIcon
		if achievement.rewardItemID then
			RewardIcon = Button:CreateTexture(nil, "OVERLAY")
			RewardIcon:Size(16, 16)
			RewardIcon:Point("RIGHT", ProgressBar, "LEFT", -5, 0)
			RewardIcon:SetTexture("Interface\\Icons\\INV_Misc_Gift_01")
			RewardIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		end

		local TrackButton = CreateFrame("CheckButton", nil, Button, "UICheckButtonTemplate")
		TrackButton:Size(20, 20)
		if RewardIcon then
			TrackButton:Point("TOPRIGHT", RewardIcon, "TOPLEFT", -4, 2)
		else
			TrackButton:Point("TOPRIGHT", ProgressBar, "TOPLEFT", -8, 2)
		end
		TrackButton:SetFrameLevel(Button:GetFrameLevel() + 2)
		S:Proxy("HandleCheckBox", TrackButton)

		local isTracked = C_ContentTracking_IsTracking(Enum_ContentTrackingType.Achievement, achievement.id)
		TrackButton:SetChecked(isTracked)
		TrackButton:SetShown(achievement.percent < 100)
		TrackButton:SetScript("OnClick", function(btn)
			local checked = btn:GetChecked()

			if checked then
				local trackedCount = #C_ContentTracking_GetTrackedIDs(Enum_ContentTrackingType.Achievement)
				if trackedCount >= Constants_ContentTrackingConsts.MaxTrackedAchievements then
					UIErrorsFrame:AddMessage(
						format(
							L["Cannot track more than %d achievements"],
							Constants_ContentTrackingConsts.MaxTrackedAchievements
						),
						1.0,
						0.1,
						0.1,
						1.0
					)
					btn:SetChecked(false)
					return
				end

				local trackingError =
					C_ContentTracking_StartTracking(Enum_ContentTrackingType.Achievement, achievement.id)
				if trackingError then
					btn:SetChecked(false)
				else
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
				end
			else
				C_ContentTracking_StopTracking(
					Enum_ContentTrackingType.Achievement,
					achievement.id,
					Enum_ContentTrackingStopType.Manual
				)
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
			end
		end)

		TrackButton:SetScript("OnEnter", function(btn)
			GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
			if btn:GetChecked() then
				GameTooltip:SetText(L["Untrack Achievement"] or "Untrack Achievement", nil, nil, nil, nil, true)
			else
				GameTooltip:SetText(L["Track Achievement"] or "Track Achievement", nil, nil, nil, nil, true)
			end
			GameTooltip:Show()
		end)

		TrackButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)

		if isExpanded and achievement.criteria then
			local criteriaYOffset = -50
			for i, criteria in ipairs(achievement.criteria) do
				local statusIcon = Button:CreateTexture(nil, "OVERLAY")
				statusIcon:Size(14, 14)
				statusIcon:Point("TOPLEFT", Button, "TOPLEFT", 20, criteriaYOffset)

				if criteria.done then
					statusIcon:SetTexture("Interface/AchievementFrame/UI-Achievement-Criteria-Check")
					statusIcon:SetVertexColor(0, 1, 0)
				else
					statusIcon:SetTexture("Interface/Buttons/UI-CheckBox-Check-Disabled")
					statusIcon:SetVertexColor(0.5, 0.5, 0.5)
				end

				local criteriaLine = Button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
				criteriaLine:Point("LEFT", statusIcon, "RIGHT", 4, 0)
				criteriaLine:Point("RIGHT", Button, "RIGHT", -15, 0)
				criteriaLine:SetJustifyH("LEFT")

				local progressInfo = ""
				if criteria.required and criteria.required > 1 then
					progressInfo = format(" (%d/%d)", criteria.quantity or 0, criteria.required)
				end

				criteriaLine:SetText(format("%s%s", criteria.text or "Unknown", progressInfo))
				criteriaLine:SetTextColor(
					criteria.done and 0.9 or 0.6,
					criteria.done and 0.9 or 0.6,
					criteria.done and 0.9 or 0.6
				)
				F.SetFontOutline(criteriaLine)

				criteriaYOffset = criteriaYOffset - 18
			end
		end

		Button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		Button:SetScript("OnClick", function(_, mouseButton)
			if mouseButton == "RightButton" then
				self.States.expandedAchievements[achievement.id] = not isExpanded
				A:UpdateAchievementList()
			else
				if _G.AchievementFrame then
					_G.AchievementFrame_SelectAchievement(achievement.id)
					if not _G.AchievementFrame:IsShown() then
						_G.AchievementFrame_ToggleAchievementFrame()
					end
				end
			end
		end)

		yOffset = yOffset - (buttonHeight + self.db.button.spacing)
	end

	local totalHeight = -yOffset + self.db.button.spacing
	Content:SetHeight(max(100, totalHeight))
end
