local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

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

function module:SkinOjectiveTrackerHeader(header)
	if not header or not header.Text then
		return
	end

	if E.db and E.db.mui and E.db.mui.blizzard.objectiveTracker.enable then
		return
	end

	F.SetFontOutline(header.Text)
end

function module:SkinQuestIcon(_, block)
	for _, button in pairs({ block.ItemButton, block.itemButton }) do
		if button then
			if button.backdrop then
				self:CreateBackdropShadow(button)
			else
				self:CreateShadow(button)
			end
		end
	end
end

function module:SkinFindGroupButton(block)
	if block.hasGroupFinderButton and block.groupFinderButton then
		if block.groupFinderButton and not block.groupFinderButton.__MERSkin then
			self:CreateShadow(block.groupFinderButton)
			block.groupFinderButton.__MERSkin = true
		end
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
	if not E.private.WT.quest.objectiveTracker.menuTitle.enable then
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

	local MainHeader = _G.ObjectiveTrackerFrame.Header
	self:SkinOjectiveTrackerHeader(MainHeader)

	for _, tracker in pairs(trackers) do
		if tracker then
			self:SkinOjectiveTrackerHeader(tracker.Header)

			self:SecureHook(tracker, "AddBlock", "SkinQuestIcon")
			self:SecureHook(tracker, "GetProgressBar", "SkinProgressBar")
			self:SecureHook(tracker, "GetTimerBar", "SkinTimerBar")
		end
	end
end

module:AddCallbackForAddon("Blizzard_ObjectiveTracker")
