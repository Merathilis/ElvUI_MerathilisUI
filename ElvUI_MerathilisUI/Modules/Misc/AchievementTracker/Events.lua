local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_AchievementTracker") ---@class AchievementTracker

local _G = _G
local C_Timer_After = C_Timer.After
local ipairs = ipairs
local tremove = tremove

-- Track event registration state.
local eventsRegistered = false

---Handle ACHIEVEMENT_EARNED event
---@param achievementID number
---@param alreadyEarned boolean
---@return nil
function module:ACHIEVEMENT_EARNED(achievementID, alreadyEarned)
	if _G.MER_AchievementTracker and not alreadyEarned then
		local scanState = module:GetScanState()
		for i, achievement in ipairs(scanState.results) do
			if achievement.id == achievementID then
				tremove(scanState.results, i)
				module:ApplyFiltersAndSort()
				module:UpdateAchievementList()
				break
			end
		end
	end
end

---Handle CRITERIA_UPDATE event
---@return nil
function module:CRITERIA_UPDATE()
	if _G.MER_AchievementTracker and module:GetScanState().scannedSinceInit then
		C_Timer_After(0.5, function()
			if _G.MER_AchievementTracker then
				module:UpdateAchievementList()
			end
		end)
	end
end

---Register events for achievement tracking
---@return nil
local function RegisterAchievementEvents()
	if not eventsRegistered then
		module:RegisterEvent("ACHIEVEMENT_EARNED")
		module:RegisterEvent("CRITERIA_UPDATE")
		eventsRegistered = true
	end
end

---Unregister events for achievement tracking
---@return nil
local function UnregisterAchievementEvents()
	if eventsRegistered then
		module:UnregisterEvent("ACHIEVEMENT_EARNED")
		module:UnregisterEvent("CRITERIA_UPDATE")
		eventsRegistered = false
	end
end

---Hide and cleanup the tracker panel
---@return nil
local function HideTrackerPanel()
	if _G.MER_AchievementTracker then
		-- Don't destroy the panel, just hide it to avoid recreation overhead.
		_G.MER_AchievementTracker:Hide()
	end

	-- Stop any ongoing scans when hiding
	if module:GetScanState().isScanning then
		module:SetScanState("isScanning", false)
	end
end

---Hook into Achievement frame events
---@return nil
function module:HookAchievementFrame()
	if _G.AchievementFrame and not _G.AchievementFrame._MERHooked then
		_G.AchievementFrame._MERHooked = true

		_G.AchievementFrame:HookScript("OnShow", function()
			-- Register events when UI is shown
			RegisterAchievementEvents()

			C_Timer_After(0.1, function()
				module:CreateAchievementTrackerPanel()
				if _G.MER_AchievementTracker then
					_G.MER_AchievementTracker:Show()
				end

				if not module:GetScanState().scannedSinceInit then
					module:SetScanState("scannedSinceInit", true)
					C_Timer_After(0.4, function()
						module:StartAchievementScan()
					end)
				end
			end)
		end)

		_G.AchievementFrame:HookScript("OnHide", function()
			-- Unregister events and hide tracker when UI is hidden
			UnregisterAchievementEvents()
			HideTrackerPanel()
		end)
	end
end
