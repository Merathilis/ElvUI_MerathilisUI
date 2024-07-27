local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local pairs = pairs

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

function module:ReskinOjectiveTrackerHeader(header)
	if not header or not header.Text then
		return
	end

	if E.db and E.db.mui and E.db.mui.blizzard.objectiveTracker.enable then
		return
	end

	F.SetFontOutline(header.Text)
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
end

function module:ReskinObjectiveTrackerBlock(_, block)
	for _, button in pairs({ block.ItemButton, block.itemButton }) do
		if button then
			if button.backdrop then
				self:CreateBackdropShadow(button)
			else
				self:CreateShadow(button)
			end
		end
	end

	self:ReskinObjectiveTrackerBlockRightEdgeButton(_, block)

	if block.AddRightEdgeFrame and not block.__MERRightEdgeHooked then
		self:SecureHook(block, "AddRightEdgeFrame", "ReskinObjectiveTrackerBlockRightEdgeButton")
		block.__MERRightEdgeHooked = true
	end
end

function module:SkinProgressBar(tracker, key)
	local progressBar = tracker.usedProgressBars[key]
	if not progressBar or not progressBar.Bar or progressBar.__MERSkin then
		return
	end

	self:CreateBackdropShadow(progressBar.Bar)

	if progressBar.Bar.Icon then
		self:CreateBackdropShadow(progressBar.Bar.Icon)
	end

	-- move text to center
	if progressBar.Bar.Label then
		progressBar.Bar.Label:ClearAllPoints()
		progressBar.Bar.Label:Point("CENTER", progressBar.Bar, 0, 0)
		F.SetFontOutline(progressBar.Bar.Label)
	end

	-- change font style of header
	F.SetFontOutline(_G.ObjectiveTrackerFrame.HeaderMenu.Title)

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

	local MainHeader = _G.ObjectiveTrackerFrame.Header
	self:ReskinOjectiveTrackerHeader(MainHeader)

	for _, tracker in pairs(trackers) do
		self:ReskinOjectiveTrackerHeader(tracker.Header)

		for _, block in pairs(tracker.usedBlocks or {}) do
			self:ReskinObjectiveTrackerBlock(tracker, block)
		end

		self:SecureHook(tracker, "AddBlock", "ReskinObjectiveTrackerBlock")
		self:SecureHook(tracker, "GetProgressBar", "SkinProgressBar")
		self:SecureHook(tracker, "GetTimerBar", "SkinTimerBar")
	end
end

module:AddCallbackForAddon("Blizzard_ObjectiveTracker")
