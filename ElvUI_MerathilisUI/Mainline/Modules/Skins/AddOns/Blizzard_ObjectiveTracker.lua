local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

function module:SkinOjectiveTrackerHeaders()
	local frame = _G.ObjectiveTrackerFrame.MODULES
	if frame then
		for i = 1, #frame do
			if frame[i] then
				F.SetFontOutline(frame[i].Header.Text)
			end
		end
	end
end

function module:SkinItemButton(block)
	if InCombatLockdown() then
		return
	end

	local item = block and block.itemButton
	if not item then
		return
	end
	MER:CreateShadow(item)
end

function module:SkinFindGroupButton(block)
	if block.hasGroupFinderButton and block.groupFinderButton then
		if block.groupFinderButton and not block.groupFinderButton.MERStyle then
			MER:CreateShadow(block.groupFinderButton)
			block.groupFinderButton.MERStyle = true
		end
	end
end

function module:SkinProgressBars(_, _, line)
	local progressBar = line and line.ProgressBar
	local bar = progressBar and progressBar.Bar
	if not bar or progressBar.MERStyle then
		return
	end
	local icon = bar.Icon
	local label = bar.Label

	-- Bar Shadow
	MER:CreateBackdropShadow(bar)

	-- Adjust the font position
	if icon then
		MER:CreateBackdropShadow(progressBar)
		icon:Point("LEFT", bar, "RIGHT", E.PixelMode and 7 or 11, 0)
	end

	-- Fix font position
	if label then
		label:ClearAllPoints()
		label:Point("CENTER", bar, 0, 0)
		F.SetFontOutline(label)
	end

	-- Change the Font
	F.SetFontOutline(_G.ObjectiveTrackerFrame.HeaderMenu.Title)

	progressBar.MERStyle = true
end

function module:SkinTimerBars(_, _, line)
	local timerBar = line and line.TimerBar
	local bar = timerBar and timerBar.Bar
	if bar.MER.Style then
		return
	end
	MER:CreateBackdropShadow(bar)
end

function module:ObjectiveTracker()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or not E.private.mui.skins.blizzard.objectiveTracker then return end

	module:SecureHook("ObjectiveTracker_Update", "SkinOjectiveTrackerHeaders")
	module:SecureHook("QuestObjectiveSetupBlockButton_FindGroup", "SkinFindGroupButton")
	module:SecureHook("QuestObjectiveSetupBlockButton_Item", "SkinItemButton")
	module:SecureHook(_G.BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", "SkinProgressBars")
	module:SecureHook(_G.WORLD_QUEST_TRACKER_MODULE, "AddProgressBar", "SkinProgressBars")
	module:SecureHook(_G.DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", "SkinProgressBars")
	module:SecureHook(_G.SCENARIO_TRACKER_MODULE, "AddProgressBar", "SkinProgressBars")
	module:SecureHook(_G.CAMPAIGN_QUEST_TRACKER_MODULE, "AddProgressBar", "SkinProgressBars")
	module:SecureHook(_G.QUEST_TRACKER_MODULE, "AddProgressBar", "SkinProgressBars")
	module:SecureHook(_G.QUEST_TRACKER_MODULE, "AddTimerBar", "SkinTimerBars")
	module:SecureHook(_G.SCENARIO_TRACKER_MODULE, "AddTimerBar", "SkinTimerBars")
	module:SecureHook(_G.ACHIEVEMENT_TRACKER_MODULE, "AddTimerBar", "SkinTimerBars")
end

module:AddCallback("ObjectiveTracker")
