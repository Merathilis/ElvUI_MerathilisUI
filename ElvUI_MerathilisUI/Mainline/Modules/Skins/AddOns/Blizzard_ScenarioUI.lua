
local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local hooksecurefunc = hooksecurefunc
local pairs = pairs
local select = select
local unpack = unpack

local C_ChallengeMode_GetAffixInfo = C_ChallengeMode.GetAffixInfo

function module:ScenarioStage_CustomizeBlock(stageBlock, scenarioType, widgetSetID, textureKitID)
	stageBlock.NormalBG:SetTexture("")
	stageBlock.FinalBG:SetTexture("")

	if not stageBlock.backdrop then
		stageBlock:CreateBackdrop("Transparent")
		stageBlock.backdrop:ClearAllPoints()
		stageBlock.backdrop:SetInside(stageBlock.GlowTexture, 4, 2)
		stageBlock.backdrop:Styling()
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
	for _, child in pairs {block:GetChildren()} do
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
	block.backdrop:Styling()
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

local function LoadSkin()
	if not module:CheckDB("objectiveTracker", "objectiveTracker") then
		return
	end

	module:SecureHook("ScenarioStage_CustomizeBlock")
	module:SecureHook("Scenario_ChallengeMode_ShowBlock")
	module:SecureHook(_G.SCENARIO_CONTENT_TRACKER_MODULE, "Update", "ScenarioStageWidgetContainer")
end

S:AddCallback("ScenarioUI", LoadSkin)
