local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

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
	module:CreateShadow(item)
end

function module:SkinFindGroupButton(block)
	if block.hasGroupFinderButton and block.groupFinderButton then
		if block.groupFinderButton and not block.groupFinderButton.MERStyle then
			module:CreateShadow(block.groupFinderButton)
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
	module:CreateBackdropShadow(bar)

	-- Adjust the font position
	if icon then
		module:CreateBackdropShadow(progressBar)
		icon:Point("LEFT", bar, "RIGHT", E.PixelMode and 7 or 11, 0)
	end

	-- Fix font position
	if label then
		label:ClearAllPoints()
		label:Point("CENTER", bar, 0, 0)
		F.SetFontOutline(label)
	end

	-- Change the Font
	if not E.db.mui.blizzard.objectiveTracker.menuTitle.enable then
		F.SetFontOutline(_G.ObjectiveTrackerFrame.HeaderMenu.Title)
	end

	progressBar.MERStyle = true
end

function module:SkinTimerBars(_, _, line)
	local timerBar = line and line.TimerBar
	local bar = timerBar and timerBar.Bar
	if bar.MERStyle then
		return
	end
	module:CreateBackdropShadow(bar)
end

local function LoadSkin()
	if not module:CheckDB("objectiveTracker", "objectiveTracker") then
		return
	end

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

S:AddCallback("ObjectiveTracker", LoadSkin)
