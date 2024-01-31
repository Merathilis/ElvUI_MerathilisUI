local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
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

function module:ScenarioStage_CustomizeBlock(stageBlock, scenarioType, widgetSetID, textureKitID)
	stageBlock.NormalBG:SetTexture("")
	stageBlock.FinalBG:SetTexture("")

	if not stageBlock.backdrop then
		stageBlock:CreateBackdrop("Transparent")
		stageBlock.backdrop:ClearAllPoints()
		stageBlock.backdrop:SetInside(stageBlock.GlowTexture, 4, 2)
		module:CreateShadow(stageBlock.backdrop)
		module:CreateGradient(stageBlock.backdrop)
	end
end

function module:Scenario_ChallengeMode_ShowBlock()
	local block = _G.ScenarioChallengeModeBlock

	if not block then
		return
	end

	-- Affix icon
	for _, child in pairs { block:GetChildren() } do
		if not child.MERStyle and child.affixID then
			child.Border:SetAlpha(0)
			local texPath = select(3, C_ChallengeMode_GetAffixInfo(child.affixID))
			child:CreateBackdrop("Transparent")
			child.backdrop:ClearAllPoints()
			child.backdrop:SetOutside(child.Portrait)
			child.Portrait:SetTexture(texPath)
			child.Portrait:SetTexCoord(unpack(E.TexCoords))
			child.MERStyle = true
		end
	end

	if block.MERStyle then
		return
	end

	-- Block background
	block.TimerBG:Hide()
	block.TimerBGBack:Hide()

	block:CreateBackdrop("Transparent")
	block.backdrop:ClearAllPoints()
	block.backdrop:SetInside(block, 6, 2)
	module:CreateBackdropShadow(block)

	-- Time bar
	block.StatusBar:CreateBackdrop()
	block.StatusBar.backdrop:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.6)
	block.StatusBar:SetStatusBarTexture(E.media.normTex)
	block.StatusBar:SetStatusBarColor(unpack(E.media.rgbvaluecolor))
	block.StatusBar:SetHeight(10)

	select(3, block:GetRegions()):Hide()

	block.MERStyle = true
end

function module:ScenarioStageWidgetContainer()
	local contianer = _G.ScenarioStageBlock.WidgetContainer
	if not contianer or not contianer.widgetFrames then
		return
	end

	for _, widgetFrame in pairs(contianer.widgetFrames) do
		if widgetFrame.Frame then
			widgetFrame.Frame:SetAlpha(0)
		end

		local bar = widgetFrame.TimerBar

		if bar and not bar.__MERSkin then
			bar.__MERSetStatusBarTexture = bar.SetStatusBarTexture
			hooksecurefunc(bar, "SetStatusBarTexture", function(frame)
				if frame.__MERSetStatusBarTexture then
					frame:__MERSetStatusBarTexture(E.media.normTex)
					frame:SetStatusBarColor(unpack(E.media.rgbvaluecolor))
				end
			end)

			bar:CreateBackdrop("Transparent")
			bar.__MERSkin = true
		end

		if widgetFrame.CurrencyContainer then
			for currencyFrame in widgetFrame.currencyPool:EnumerateActive() do
				if not currencyFrame.__MERSkin then
					currencyFrame.Icon:SetTexCoord(unpack(E.TexCoords))
					currencyFrame.__MERSkin = true
				end
			end
		end
	end
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

	module:SecureHook("ScenarioStage_CustomizeBlock")
	module:SecureHook("Scenario_ChallengeMode_ShowBlock")
	module:SecureHook(_G.SCENARIO_CONTENT_TRACKER_MODULE, "Update", "ScenarioStageWidgetContainer")
end

S:AddCallback("ObjectiveTracker", LoadSkin)
