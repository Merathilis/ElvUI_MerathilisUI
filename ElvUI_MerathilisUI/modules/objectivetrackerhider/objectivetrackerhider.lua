local MER, E, L, V, P, G = unpack(select(2, ...))
local OTH = E:NewModule("ObjectiveTrackerHider", "AceEvent-3.0")
OTH.modName = L["ObjectiveTrackerHider"]

-- Cache global variables
-- Lua functions
local _G = _G
local type = type
-- WoW API / Variables

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: TradeSkillFrame

-- Hide Quest Tracker based on zone
function OTH:UpdateHideState()
	local OT = _G["ObjectiveTrackerFrame"]

	if UnitAffectingCombat("player") then self:RegisterEvent("PLAYER_REGEN_ENABLED", "HandleEvent") return end
	local Inst, InstType = IsInInstance()
	local Hide = false
	if Inst then
		if (InstType == "pvp" and E.db.mui.objectivetrackerhider.hidePvP) then			-- Battlegrounds
			Hide = true
		elseif (InstType == "arena" and E.db.mui.objectivetrackerhider.hideArena) then	-- Arena
			Hide = true
		elseif (InstType == "party" and E.db.mui.objectivetrackerhider.hideParty) then	-- 5 Man Dungeons
			Hide = true
		elseif (InstType == "raid" and E.db.mui.objectivetrackerhider.hideRaid) then	-- Raid Dungeons
			Hide = true
		end
	end
	if Hide then OT:Hide() else OT:Show() end
end

-- Collapse Quest Tracker based on zone
function OTH:UpdateCollapseState()
	local WF = _G["ObjectiveTrackerFrame"]

	if UnitAffectingCombat("player") then self:RegisterEvent("PLAYER_REGEN_ENABLED", "HandleEvent") return end
	local Inst, InstType = IsInInstance()
	local Collapsed = false
	if Inst then
		if (InstType == "pvp" and E.db.mui.objectivetrackerhider.collasePvP) then			-- Battlegrounds
			Collapsed = true
		elseif (InstType == "arena" and E.db.mui.objectivetrackerhider.collapseArena) then	-- Arena
			Collapsed = true
		elseif (InstType == "party" and E.db.mui.objectivetrackerhider.collapseParty) then	-- 5 Man Dungeons
			Collapsed = true
		elseif (InstType == "raid" and E.db.mui.objectivetrackerhider.collapseRaid) then	-- Raid Dungeons
			Collapsed = true
		end
	end

	if Collapsed then
		WF.userCollapsed = true
		ObjectiveTracker_Collapse(WF)
	else
		WF.userCollapsed = false;
		ObjectiveTracker_Expand(WF)
	end
end

function OTH:HandleEvent(event)
	self:UpdateHideState()
	self:UpdateCollapseState()
	if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
end

function OTH:Enable()
	if(UnitAffectingCombat("player")) then self:RegisterEvent("PLAYER_REGEN_ENABLED", "Enable") return end
	if E.db.mui.objectivetrackerhider.enabled then
		self:RegisterEvent("PLAYER_ENTERING_WORLD", "HandleEvent")
	else
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

function OTH:Initialize()
	OTH:Enable()
end

local function InitializeCallback()
	OTH:Initialize()
end

E:RegisterModule(OTH:GetName(), InitializeCallback)