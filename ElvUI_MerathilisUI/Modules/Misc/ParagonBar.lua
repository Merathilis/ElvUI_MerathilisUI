local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc

local _G = _G
local floor = math.floor
local format = string.format

local BreakUpLargeNumbers = BreakUpLargeNumbers
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local IsFactionParagonForCurrentPlayer = C_Reputation.IsFactionParagonForCurrentPlayer

---Blizzard fills every row with a full bar on max standing, so nothing here has to be reset:
---a recycled row gets its own values and color from the Initialize that runs before this
---@param _ any Unused owner
---@param entry Frame
---@param elementData table
local function OnEntryInitialized(_, entry, elementData)
	local bar = entry.Content and entry.Content.ReputationBar
	local factionID = elementData and elementData.factionID
	if not bar or not factionID or not IsFactionParagonForCurrentPlayer(factionID) then
		return
	end

	local current, threshold, _, hasRewardPending, tooLowLevel = GetFactionParagonInfo(factionID)
	if tooLowLevel or not threshold or threshold <= 0 then
		return
	end

	-- A waiting reward keeps the bar full, the text goes on counting past the threshold
	local value = current % threshold
	local completed = floor(current / threshold)
	if hasRewardPending then
		value = value + threshold
		completed = completed - 1
	end

	local color = E:ClassColor(E.myclass, true)
	bar:UpdateBarValues(0, threshold, value)
	bar:SetStatusBarColor(color.r, color.g, color.b)
	bar:UpdateBarProgressText(
		_G.HIGHLIGHT_FONT_COLOR:WrapTextInColorCode(
			_G.REPUTATION_PROGRESS_FORMAT:format(BreakUpLargeNumbers(value), BreakUpLargeNumbers(threshold))
		)
	)
	bar:UpdateReputationStandingText(
		completed > 0 and format("%s x%d", L["MISC_PARAGON"], completed) or L["MISC_PARAGON"]
	)
	bar:TryShowReputationStandingText()
end

function module:ParagonBar()
	if not E.db.mui.misc.paragonBar or IsAddOnLoaded("ParagonReputation") then
		return
	end

	local frame = _G.ReputationFrame
	if frame then
		_G.ScrollUtil.AddInitializedFrameCallback(frame.ScrollBox, OnEntryInitialized, self)
	end
end

module:AddCallback("ParagonBar")
