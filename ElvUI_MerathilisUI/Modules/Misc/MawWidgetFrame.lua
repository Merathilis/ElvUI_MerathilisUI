local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Misc')

local _G = _G
local unpack = unpack
local floor = math.floor

local CreateFrame = CreateFrame
local SplitTextIntoHeaderAndNonHeader = SplitTextIntoHeaderAndNonHeader
local C_UIWidgetManager_GetDiscreteProgressStepsVisualizationInfo = C_UIWidgetManager.GetDiscreteProgressStepsVisualizationInfo
local C_UIWidgetManager_GetTextureWithAnimationVisualizationInfo = C_UIWidgetManager.GetTextureWithAnimationVisualizationInfo
local GameTooltip = GameTooltip
local GARRISON_TIER = GARRISON_TIER

local maxValue = 1000
local function GetMawBarValue()
	local widgetInfo = C_UIWidgetManager_GetDiscreteProgressStepsVisualizationInfo(2885)
	if widgetInfo and widgetInfo.shownState == 1 then
		local value = widgetInfo.progressVal
		return floor(value / maxValue), value % maxValue
	end
end

local MawRankColor = {
	[0] = {.6, .8, 1},
	[1] = {0, .7, .3},
	[2] = {0, 1, 0},
	[3] = {1, .8, 0},
	[4] = {1, .5, 0},
	[5] = {1, 0, 0}
}

function module:UpdateMawBarLayout()
	local header, nonheader
	local bar = module.mawbar
	local rank, value = GetMawBarValue()
	local widgetInfo = rank and C_UIWidgetManager_GetTextureWithAnimationVisualizationInfo(2873 + rank)

	if widgetInfo and widgetInfo.tooltip then
		header, nonheader = SplitTextIntoHeaderAndNonHeader(widgetInfo.tooltip)
	end

	if rank then
		bar:SetStatusBarColor(unpack(MawRankColor[rank]))
		if rank == 5 then
			bar.text:SetText(header .. ' - ' .. GARRISON_TIER .. ' ' .. rank)
			bar:SetValue(maxValue)
		else
			bar.text:SetText(header .. ' - ' .. GARRISON_TIER .. ' ' .. rank .. ' - ' .. value .. '/' .. maxValue)
			bar:SetValue(value)
		end
		bar:Show()
		_G.UIWidgetTopCenterContainerFrame:Hide()
	else
		bar:Hide()
		_G.UIWidgetTopCenterContainerFrame:Show()
	end
end

function module:CreateMawWidgetFrame()
	if module.mawbar then return end

	if not E.db.mui.misc.mawThreatBar then return end

	local bar = CreateFrame("StatusBar", nil, E.UIParent)
	bar:SetPoint("TOP", 0, -175)
	bar:SetSize(250, 16)
	bar:SetMinMaxValues(0, 1000)
	bar:CreateBackdrop('Transparent')
	bar.backdrop:Styling()
	bar:SetStatusBarTexture(E.media.normTex)
	MER:SmoothBar(bar)
	E:RegisterStatusBar(bar)

	bar.text = bar:CreateFontString(nil, 'OVERLAY')
	bar.text:FontTemplate(nil, 10, 'OUTLINE')
	bar.text:Point('CENTER')

	module.mawbar = bar

	E:CreateMover(bar, "MER_MawThreatBar", L["MawThreatBar"], nil, nil, nil, 'ALL,SOLO,MERATHILISUI', nil, 'mui,modules,misc')

	bar:SetScript("OnEnter", function(self)
		local rank = GetMawBarValue()
		local widgetInfo = rank and C_UIWidgetManager_GetTextureWithAnimationVisualizationInfo(2873 + rank)
		if widgetInfo and widgetInfo.shownState == 1 then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -10)
			local header, nonHeader = SplitTextIntoHeaderAndNonHeader(widgetInfo.tooltip)
			if header then
				GameTooltip:AddLine(header, nil, nil, nil, 1)
			end
			if nonHeader then
				GameTooltip:AddLine(nonHeader, nil, nil, nil, 1)
			end
			GameTooltip:Show()
		end
	end)

	bar:SetScript("OnLeave", GameTooltip_Hide)

	module:UpdateMawBarLayout()
	MER:RegisterEvent("PLAYER_ENTERING_WORLD", module.UpdateMawBarLayout)
	MER:RegisterEvent("UPDATE_UI_WIDGET", module.UpdateMawBarLayout)
end
