local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G
local unpack = unpack

local GetAffixInfo = C_ChallengeMode.GetAffixInfo

local function ScenarioObjectiveTrackerStage_UpdateStageBlock(block)
	block.NormalBG:SetTexture("")
	block.FinalBG:SetTexture("")

	if not block.backdrop then
		block:CreateBackdrop("Transparent")
		block.backdrop:ClearAllPoints()
		block.backdrop:SetInside(block.GlowTexture, 4, 2)
		module:CreateShadow(block.backdrop)
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

local function ScenarioObjectiveTracker_AddBlock(_, block)
	if block then
		-- Stage block
		if block.Stage and block.WidgetContainer then
			scenarioStageBlock = block
			if not block.__MERHooked then
				hooksecurefunc(block, "UpdateStageBlock", ScenarioObjectiveTrackerStage_UpdateStageBlock)
				block.__MERHooked = true
			end
		end

		-- Challenge mode block
		if block.DeathCount and not block.__MERHooked then
			hooksecurefunc(block, "Activate", ScenarioObjectiveTrackerChallengeMode_Activate)
			hooksecurefunc(block, "SetUpAffixes", ScenarioObjectiveTrackerChallengeMode_SetUpAffixes)
			if block:IsActive() then
				ScenarioObjectiveTrackerChallengeMode_Activate(block)
				ScenarioObjectiveTrackerChallengeMode_SetUpAffixes(block)
			end
			block.__MERHooked = true
		end
	end
end

local function ScenarioObjectiveTracker_Update(_, block)
	local contianer = scenarioStageBlock and scenarioStageBlock.WidgetContainer
	if not contianer or not contianer.widgetFrames then
		return
	end

	for _, widgetFrame in pairs(contianer.widgetFrames) do
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

function module:ScenarioObjectieTracker()
	if not module:CheckDB("objectiveTracker", "objectiveTracker") then
		return
	end

	hooksecurefunc(_G.ScenarioObjectiveTracker, "Update", ScenarioObjectiveTracker_Update)
	hooksecurefunc(_G.ScenarioObjectiveTracker, "AddBlock", ScenarioObjectiveTracker_AddBlock)
end

module:AddCallback("ScenarioObjectieTracker")
