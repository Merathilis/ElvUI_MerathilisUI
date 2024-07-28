local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G
local unpack = unpack

local GetAffixInfo = C_ChallengeMode.GetAffixInfo

local function SkinMawBuffsContainer(container)
	container:StripTextures()
	container:GetHighlightTexture():Kill()
	container:GetPushedTexture():Kill()
	local pushed = container:CreateTexture()
	module:Reposition(pushed, container, 0, -11, -11, -17, -4)
	pushed:SetBlendMode("ADD")
	local vr, vg, vb = unpack(E.media.rgbvaluecolor)
	pushed:SetColorTexture(vr, vg, vb, 0.2)
	container:SetPushedTexture(pushed)
	container.SetHighlightAtlas = E.noop
	container.SetPushedAtlas = E.noop
	container.SetWidth = E.noop
	container.SetPushedTextOffset = E.noop

	container:CreateBackdrop("Transparent")
	module:Reposition(container.backdrop, container, 1, -10, -10, -16, -3)
	module:CreateBackdropShadow(container)

	local blockList = container.List
	blockList:StripTextures()
	blockList:CreateBackdrop("Transparent")
	module:Reposition(blockList.backdrop, blockList, 1, -11, -11, -6, -6)
	module:CreateBackdropShadow(blockList)
end

local function ScenarioObjectiveTrackerStage_UpdateStageBlock(block)
	block.NormalBG:SetTexture("")
	block.FinalBG:SetTexture("")

	if not block.backdrop then
		block:CreateBackdrop("Transparent")
		block.backdrop:ClearAllPoints()
		block.backdrop:SetInside(block.GlowTexture, 4, 2)
		module:CreateShadow(block.backdrop)
	end

	if block.UpdateFindGroupButton then
		hooksecurefunc(block, "UpdateFindGroupButton", function(self)
			if self.findGroupButton and not self.findGroupButton.__MERSkin then
				module:CreateShadow(self.findGroupButton)
				self.findGroupButton.__MERSkin = true
			end
		end)
	end
end

local function ScenarioObjectiveTrackerChallengeMode_SetUpAffixes(block)
	for frame in block.affixPool:EnumerateActive() do
		if not frame.__MERSkin and frame.affixID then
			frame.Border:SetAlpha(0)
			local texPath = select(3, GetAffixInfo(frame.affixID))
			frame:CreateBackdrop("Transparent")
			frame.backdrop:ClearAllPoints()
			frame.backdrop:SetOutside(frame.Portrait)
			frame.Portrait:SetTexture(texPath)
			frame.Portrait:SetTexCoord(unpack(E.TexCoords))
			frame.__MERSkin = true
		end
	end
end

local function ScenarioObjectiveTrackerChallengeMode_Activate(block)
	if block.__MERSkin then
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
	block.StatusBar:SetHeight(12)

	select(3, block:GetRegions()):Hide()

	block.__MERSkin = true
end

local function UpdateHooksOfBlock(block)
	-- Stage block
	if block.Stage and block.WidgetContainer and not block.__MERStageHooked then
		block.__MERStageHooked = true
		hooksecurefunc(block, "UpdateStageBlock", ScenarioObjectiveTrackerStage_UpdateStageBlock)
		ScenarioObjectiveTrackerStage_UpdateStageBlock(block)
	end

	-- Challenge mode block
	if block.DeathCount and not block.__MERChallengeModeHooked then
		block.__MERChallengeModeHooked = true
		hooksecurefunc(block, "Activate", ScenarioObjectiveTrackerChallengeMode_Activate)
		hooksecurefunc(block, "SetUpAffixes", ScenarioObjectiveTrackerChallengeMode_SetUpAffixes)
		ScenarioObjectiveTrackerChallengeMode_Activate(block)
		ScenarioObjectiveTrackerChallengeMode_SetUpAffixes(block)
	end
end

local function UpdateBlock(block)
	if block.__MERStageHooked and block.WidgetContainer and block.WidgetContainer.widgetFrames then
		for _, widgetFrame in pairs(block.WidgetContainer.widgetFrames) do
			if widgetFrame.Frame then
				widgetFrame.Frame:SetAlpha(0)
			end

			local bar = widgetFrame.TimerBar
			if bar and not bar.__MERSkin then
				bar.__SetStatusBarTexture = bar.SetStatusBarTexture
				hooksecurefunc(bar, "SetStatusBarTexture", function(frame)
					if frame.__SetStatusBarTexture then
						frame:__SetStatusBarTexture(E.media.normTex)
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

	if block.__MERChallengeModeHooked then
		if block:IsActive() then
			ScenarioObjectiveTrackerChallengeMode_Activate(block)
			ScenarioObjectiveTrackerChallengeMode_SetUpAffixes(block)
		end
	end
end

local function ScenarioObjectiveTracker_AddBlock(_, block)
	if not block then
		return
	end

	UpdateHooksOfBlock(block)
	UpdateBlock(block)
end

local function ScenarioObjectiveTracker_Update(tracker, block)
	for _, block in pairs(tracker.usedBlocks or {}) do
		UpdateHooksOfBlock(block)
		UpdateBlock(block)
	end
end

function module:ScenarioObjectieTracker()
	if not module:CheckDB("objectiveTracker", "objectiveTracker") then
		return
	end

	hooksecurefunc(_G.ScenarioObjectiveTracker, "Update", ScenarioObjectiveTracker_Update)
	hooksecurefunc(_G.ScenarioObjectiveTracker, "AddBlock", ScenarioObjectiveTracker_AddBlock)
	SkinMawBuffsContainer(_G.ScenarioObjectiveTracker.MawBuffsBlock.Container)
end

module:AddCallback("ScenarioObjectieTracker")
