local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("mUI_databars")

--Cache global variables
--Lua functions
local _G = _G
local format, pairs, unpack = string.format, pairs, unpack
local min, mod, floor = math.min, mod, math.floor
--WoW API / Variables
local C_Timer_After = C_Timer.After
local BreakUpLargeNumbers = BreakUpLargeNumbers
local C_AzeriteItem_FindActiveAzeriteItem = C_AzeriteItem.FindActiveAzeriteItem
local C_AzeriteItem_GetAzeriteItemXPInfo = C_AzeriteItem.GetAzeriteItemXPInfo
local C_AzeriteItem_HasActiveAzeriteItem = C_AzeriteItem.HasActiveAzeriteItem
local C_AzeriteItem_GetPowerLevel = C_AzeriteItem.GetPowerLevel
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local GameTooltip = GameTooltip
local GetFriendshipReputation = GetFriendshipReputation
local GetFriendshipReputationRanks = GetFriendshipReputationRanks
local GetWatchedFactionInfo = GetWatchedFactionInfo
local GetText = GetText
local GetXPExhaustion = GetXPExhaustion
local IsWatchingHonorAsXP = IsWatchingHonorAsXP
local IsXPUserDisabled = IsXPUserDisabled
local UnitHonor = UnitHonor
local UnitHonorMax = UnitHonorMax
local UnitHonorLevel = UnitHonorLevel
local UnitLevel = UnitLevel
local UnitSex = UnitSex
local UnitXP = UnitXP
local UnitXPMax = UnitXPMax
local ARTIFACT_POWER, HONOR, LEVEL, XP, LOCKED = ARTIFACT_POWER, HONOR, LEVEL, XP, LOCKED
local TUTORIAL_TITLE26 = TUTORIAL_TITLE26
local SPELLBOOK_AVAILABLE_AT = SPELLBOOK_AVAILABLE_AT
local CreateFrame = CreateFrame
-- GLOBALS:

function module:StyleBackdrops()
	--Azerite
	local azerite = _G["ElvUI_AzeriteBar"]
	if azerite then
		azerite:Styling()
	end

	-- Experience
	local experience = _G["ElvUI_ExperienceBar"]
	if experience then
		experience:Styling()
	end

	-- Honor
	local honor = _G["ElvUI_HonorBar"]
	if honor then
		honor:Styling()
	end

	-- Reputation
	local reputation = _G["ElvUI_ReputationBar"]
	if reputation then
		reputation:Styling()
	end
end


function module:Initialize()
	module.db = E.db.mui.databars
	MER:RegisterDB(self, "databars")

	C_Timer_After(1, module.StyleBackdrops)
end

MER:RegisterModule(module:GetName())
