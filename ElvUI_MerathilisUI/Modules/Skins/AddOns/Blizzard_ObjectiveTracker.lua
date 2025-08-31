local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

local _G = _G
local pairs = pairs
local tcontains = tcontains

local trackers = {
	_G.ScenarioObjectiveTracker,
	_G.UIWidgetObjectiveTracker,
	_G.CampaignQuestObjectiveTracker,
	_G.QuestObjectiveTracker,
	_G.AdventureObjectiveTracker,
	_G.AchievementObjectiveTracker,
	_G.MonthlyActivitiesObjectiveTracker,
	_G.ProfessionsRecipeTracker,
	_G.BonusObjectiveTracker,
	_G.WorldQuestObjectiveTracker,
}

function module:ReskinObjectiveTrackerHeader(header)
	if not header or not header.Text then
		return
	end

	if E.private and E.private.mui and E.private.mui.quest.objectiveTracker.enable then
		return
	end

	F.SetFontOutline(header.Text)
end

-- Copied from ElvUI ObjectiveTracker skin
local function ReskinQuestIcon(button)
	if not button then
		return
	end

	if not button.IsSkinned then
		button:SetSize(24, 24)
		button:SetNormalTexture(E.ClearTexture)
		button:SetPushedTexture(E.ClearTexture)
		button:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)

		local icon = button.icon or button.Icon
		if icon then
			S:HandleIcon(icon, true)
			icon:SetInside()
		end

		button.IsSkinned = true
	end

	if button.backdrop then
		button.backdrop:SetFrameLevel(0)
	end
end

function module:ReskinObjectiveTrackerBlockRightEdgeButton(_, block)
	local frame = block.rightEdgeFrame
	if not frame then
		return
	end

	if frame.template == "QuestObjectiveFindGroupButtonTemplate" and not frame.__MERSkin then
		frame:GetNormalTexture():SetAlpha(0)
		frame:GetPushedTexture():SetAlpha(0)
		frame:GetHighlightTexture():SetAlpha(0)
		S:HandleButton(frame, nil, nil, nil, true)
		frame.backdrop:SetInside(frame, 4, 4)
		self:CreateBackdropShadow(frame)
		frame.__MERSkin = true
	end

	if frame.template == "QuestObjectiveItemButtonTemplate" and not frame.__MERSkin then
		ReskinQuestIcon(frame)
		self:CreateShadow(frame)
		frame.__MERSkin = true
	end
end

function module:ReskinObjectiveTrackerBlock(_, block)
	for _, button in pairs({ block.ItemButton, block.itemButton }) do
		self:CreateShadow(button)
	end

	self:ReskinObjectiveTrackerBlockRightEdgeButton(_, block)

	if block.AddRightEdgeFrame and not self:IsHooked(block, "AddRightEdgeFrame") then
		self:SecureHook(block, "AddRightEdgeFrame", "ReskinObjectiveTrackerBlockRightEdgeButton")
	end
end

function module:SkinProgressBar(tracker, key)
	local progressBar = tracker.usedProgressBars[key]
	if not progressBar or not progressBar.Bar or progressBar.__MERSkin then
		return
	end

	self:CreateBackdropShadow(progressBar.Bar)

	if progressBar.Bar.Icon and progressBar.Bar.Icon.backdrop then
		self:CreateBackdropShadow(progressBar.Bar.Icon)
	end

	if progressBar.Bar.Label then
		progressBar.Bar.Label:ClearAllPoints()
		progressBar.Bar.Label:Point("CENTER", progressBar.Bar, 0, 0)
		F.SetFontOutline(progressBar.Bar.Label)
	end

	if _G.ObjectiveTrackerFrame and _G.ObjectiveTrackerFrame.HeaderMenu then
		F.SetFontOutline(_G.ObjectiveTrackerFrame.HeaderMenu.Title)
	end

	progressBar.__MERSkin = true
end

function module:SkinTimerBar(tracker, key)
	local timerBar = tracker.usedTimerBars[key]
	self:CreateBackdropShadow(timerBar and timerBar.Bar)
end

function module:Blizzard_ObjectiveTracker()
	if not module:CheckDB("objectiveTracker", "objectiveTracker") then
		return
	end

	self.questItemButtons = {}

	local MainHeader = _G.ObjectiveTrackerFrame.Header
	self:ReskinObjectiveTrackerHeader(MainHeader)

	for _, tracker in pairs(trackers) do
		self:ReskinObjectiveTrackerHeader(tracker.Header)

		for _, block in pairs(tracker.usedBlocks or {}) do
			self:ReskinObjectiveTrackerBlock(tracker, block)
		end

		self:SecureHook(tracker, "AddBlock", "ReskinObjectiveTrackerBlock")
		self:SecureHook(tracker, "GetProgressBar", "SkinProgressBar")
		self:SecureHook(tracker, "GetTimerBar", "SkinTimerBar")
	end
end

module:AddCallbackForAddon("Blizzard_ObjectiveTracker")
