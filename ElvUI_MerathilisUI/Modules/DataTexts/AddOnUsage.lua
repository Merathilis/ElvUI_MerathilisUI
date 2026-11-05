local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local DT = E:GetModule("DataTexts")

local _G = _G
local format = format
local ipairs = ipairs

local GetCVarNumberOrDefault = GetCVarNumberOrDefault
local InCombatLockdown = InCombatLockdown
local C_AddOnProfiler = C_AddOnProfiler

local Metric = Enum.AddOnProfilerMetric

local UPDATE_INTERVAL = 2
local NUM_TOP_ADDONS = 10
local WARNING_COLOR = "|cffff3333"

local mText = L["AddOn Usage"]
local hexColor = "|cffffffff"
local hoveredPanel

---Share of the whole client's frame time spent in all addons
---@param metric number
---@return number
local function GetOverallShare(metric)
	local appValue = C_AddOnProfiler.GetApplicationMetric(metric)
	if appValue <= 0 then
		return 0
	end

	return C_AddOnProfiler.GetOverallMetric(metric) / appValue
end

---Same formula as Blizzard's AddOn list: the addon against the client without the other addons
---@param value number
---@param metric number
---@return number
local function GetAddOnShare(value, metric)
	local total = C_AddOnProfiler.GetApplicationMetric(metric) - C_AddOnProfiler.GetOverallMetric(metric) + value
	if total <= 0 then
		return 0
	end

	return value / total
end

---@param share number
---@return string
local function FormatShare(share)
	local text = format("%." .. E.db.general.decimalLength .. "f%%", share * 100)
	local warning = GetCVarNumberOrDefault("addonPerformanceMsgWarning")
	if warning > 0 and warning < 1 and share > warning then
		return WARNING_COLOR .. text .. "|r"
	end

	return hexColor .. text .. "|r"
end

local function OnEnter(self)
	hoveredPanel = self
	DT.tooltip:ClearLines()

	if not C_AddOnProfiler.IsEnabled() then
		DT.tooltip:AddLine(_G.ADDON_LIST_PERFORMANCE_HEADER)
		DT.tooltip:AddLine(L["Blizzard's AddOn profiler is not available."], 1, 1, 1)
		DT.tooltip:Show()
		return
	end

	local _, _, _, _, _, title, tip = F.mColorDatatext()
	DT.tooltip:AddLine(title .. _G.ADDON_LIST_PERFORMANCE_HEADER .. "|r")
	DT.tooltip:AddLine(
		format(_G.ADDON_LIST_PERFORMANCE_CURRENT_CPU, FormatShare(GetOverallShare(Metric.RecentAverageTime))),
		1,
		1,
		1
	)
	DT.tooltip:AddLine(
		format(_G.ADDON_LIST_PERFORMANCE_AVERAGE_CPU, FormatShare(GetOverallShare(Metric.SessionAverageTime))),
		1,
		1,
		1
	)
	DT.tooltip:AddLine(
		format(_G.ADDON_LIST_PERFORMANCE_PEAK_CPU, FormatShare(GetOverallShare(Metric.PeakTime))),
		1,
		1,
		1
	)
	DT.tooltip:AddLine(" ")

	for _, result in ipairs(C_AddOnProfiler.GetTopKAddOnsForMetric(Metric.RecentAverageTime, NUM_TOP_ADDONS)) do
		local share = GetAddOnShare(result.metricValue, Metric.RecentAverageTime)
		DT.tooltip:AddDoubleLine(
			result.addOnName,
			format("%s  %.2f ms", FormatShare(share), result.metricValue),
			1,
			1,
			1,
			1,
			1,
			1
		)
	end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(tip .. L["Left Click: Open the AddOn list"] .. "|r")
	DT.tooltip:Show()
end

local function OnLeave()
	hoveredPanel = nil
	DT.tooltip:Hide()
end

local function OnEvent(self)
	if C_AddOnProfiler.IsEnabled() then
		self.text:SetFormattedText("%s: %s", L["Addons"], FormatShare(GetOverallShare(Metric.RecentAverageTime)))
	else
		self.text:SetText(hexColor .. L["Addons"] .. "|r")
	end
end

-- Kept per panel, one shared timer would only ever update the same panel when several show this
local function OnUpdate(self, elapsed)
	self.addOnUsageElapsed = (self.addOnUsageElapsed or 0) + elapsed
	if self.addOnUsageElapsed < UPDATE_INTERVAL then
		return
	end

	self.addOnUsageElapsed = 0
	OnEvent(self)
	if hoveredPanel == self then
		OnEnter(self)
	end
end

local function OnClick(_, button)
	if button ~= "LeftButton" then
		return
	end

	if InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
	else
		_G.ShowUIPanel(_G.AddonList)
	end
end

-- ElvUI calls this whenever the value color changes and runs OnEvent right after
local function ApplySettings(_, hex)
	hexColor = hex
end

DT:RegisterDatatext(
	"MER_AddOnUsage",
	MER.DatatextString,
	nil,
	OnEvent,
	OnUpdate,
	OnClick,
	OnEnter,
	OnLeave,
	mText,
	nil,
	ApplySettings
)
