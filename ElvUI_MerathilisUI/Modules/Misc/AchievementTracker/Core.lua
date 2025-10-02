local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_AchievementTracker") ---@class AchievementTracker : AceModule, AceEvent-3.0

local _G = _G
local UIParentLoadAddOn = UIParentLoadAddOn

---@class AchievementConfig
---@field PANEL_WIDTH number
---@field PANEL_HEIGHT number
---@field MIN_THRESHOLD number
---@field MAX_THRESHOLD number
---@field DEFAULT_THRESHOLD number
---@field BATCH_SIZE number
---@field SCAN_DELAY number
---@field BUTTON_HEIGHT number
---@field BUTTON_SPACING number
---@field ICON_SIZE number
---@field PROGRESS_BAR_WIDTH number
module.Config = {
	PANEL_WIDTH = 450,
	PANEL_HEIGHT = 500,
	MIN_THRESHOLD = 50,
	MAX_THRESHOLD = 99,
	DEFAULT_THRESHOLD = 80,
	BATCH_SIZE = 20,
	SCAN_DELAY = 0.01,
	BUTTON_HEIGHT = 48,
	BUTTON_SPACING = 4,
	ICON_SIZE = 28,
	PROGRESS_BAR_WIDTH = 90,
}

---@class AchievementScanState
---@field isScanning boolean
---@field scannedSinceInit boolean
---@field currentThreshold number
---@field results table
---@field filteredResults table
---@field sortBy "percent"|"name"|"category"
---@field sortOrder "asc"|"desc"
---@field searchTerm string
---@field selectedCategory string|nil
---@field showOnlyRewards boolean
---@field expandedAchievements table<number, boolean>
module.scanState = {
	isScanning = false,
	scannedSinceInit = false,
	currentThreshold = module.Config.DEFAULT_THRESHOLD,
	results = {},
	filteredResults = {},
	sortBy = "percent",
	sortOrder = "desc",
	searchTerm = "",
	selectedCategory = nil,
	showOnlyRewards = false,
	expandedAchievements = {},
}

---Handle ADDON_LOADED event
---@param _ any
---@param addonName string
---@return nil
function module:ADDON_LOADED(_, addonName)
	if addonName == "Blizzard_AchievementUI" then
		self:CreateAchievementTrackerPanel()
		self:HookAchievementFrame()
	end
end

---Handle PLAYER_ENTERING_WORLD event
---@return nil
function module:PLAYER_ENTERING_WORLD()
	self:HookAchievementFrame()
end

MER:AddCommand("AchievementTracker", { "/merat", "/merachievements" }, function()
	if not _G.MER_AchievementTracker then
		module1:CreateAchievementTrackerPanel()
	end
	_G.MER_AchievementTracker:Show()
	module:StartAchievementScan()
end)

---Initialize the achievements module
---@return nil
function module:Initialize()
	if not E.initialized or not E.private or not E.private.mui or not E.private.mui.misc then
		return
	end

	if not E.private.mui.misc.achievementTracker or self.initialized then
		return
	end

	UIParentLoadAddOn("Blizzard_AchievementUI")
	self.initialized = true
end

---Stop scan due to combat and cleanup UI
---@return boolean # If scan was stopped due to combat
function module:StopScanDueToCombat()
	local panel = _G.MER_AchievementTracker --[[@as MER_AchievementTracker]]
	if InCombatLockdown() then
		module.scanState.isScanning = false
		if panel then
			if panel.progressContainer then
				panel.progressContainer:Hide()
			end
		end
		return true
	end

	return false
end

---Handle profile updates
---@return nil
function module:ProfileUpdate()
	self.initialized = false
	self:Initialize()

	if not E.private.mui.misc.achievements then
		module:UnregisterEvent("ADDON_LOADED")
		module:UnregisterEvent("PLAYER_ENTERING_WORLD")
		module:UnregisterEvent("ACHIEVEMENT_EARNED")
		module:UnregisterEvent("CRITERIA_UPDATE")
		self.initialized = false
	end
end

module:RegisterEvent("ADDON_LOADED")
module:RegisterEvent("PLAYER_ENTERING_WORLD")

MER:RegisterModule(module:GetName())
