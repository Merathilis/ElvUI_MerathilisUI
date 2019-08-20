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
	-- Artifact
	local artifact = _G["ElvUI_ArtifactBar"]
	if artifact then
		artifact:Styling()
	end

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
C_Timer_After(1, module.StyleBackdrops)

local function UpdateBar(bar)
	local rest = bar.restBar
	if rest then rest:Hide() end

	if UnitLevel('player') < _G.MAX_PLAYER_LEVEL then
		local xp, mxp, rxp = UnitXP('player'), UnitXPMax('player'), GetXPExhaustion()
		bar:SetStatusBarColor(79/250, 167/250, 74/250)
		bar:SetMinMaxValues(0, mxp)
		bar:SetValue(xp)
		bar:Show()
		if rxp then
			rest:SetMinMaxValues(0, mxp)
			rest:SetValue(min(xp + rxp, mxp))
			rest:Show()
		end
		if IsXPUserDisabled() then bar:SetStatusBarColor(.7, 0, 0) end
	elseif C_AzeriteItem_HasActiveAzeriteItem() then
		local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()
		local xp, totalLevelXP = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)
		bar:SetStatusBarColor(.9, .8, .6)
		bar:SetMinMaxValues(0, totalLevelXP)
		bar:SetValue(xp)
		bar:Show()
	else
		bar:Hide()
	end
end

local function UpdateTooltip(bar)
	GameTooltip:SetOwner(_G.Minimap, 'ANCHOR_NONE')
	GameTooltip:SetPoint('TOPRIGHT', _G.Minimap, 'TOPLEFT', -4, -(E.db.general.minimap.size/8*E.mult)-6)
	GameTooltip:AddLine(MER.Title..L["Progress Bar"], 1, 1, 1)
	GameTooltip:AddLine(' ')

	local r, g, b = unpack(E["media"].rgbvaluecolor)

	if UnitLevel('player') < _G.MAX_PLAYER_LEVEL then
		GameTooltip:AddLine(LEVEL..' '..UnitLevel('player'), r, g, b)

		local xp, mxp, rxp = UnitXP('player'), UnitXPMax('player'), GetXPExhaustion()
		GameTooltip:AddDoubleLine(XP, xp..' / '..mxp..' ('..floor(xp/mxp*100)..'%)', 1, 1, 1, 1, 1, 1)
		if rxp then
			GameTooltip:AddDoubleLine(TUTORIAL_TITLE26, '+'..rxp..' ('..floor(rxp/mxp*100)..'%)', 1, 1, 1, 1, 1, 1)
		end
		if IsXPUserDisabled() then GameTooltip:AddLine('|cffff0000'..XP..LOCKED) end
	end

	if C_AzeriteItem_HasActiveAzeriteItem() then
		local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()
		local azeriteItem = Item:CreateFromItemLocation(azeriteItemLocation)
		local xp, totalLevelXP = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)
		local currentLevel = C_AzeriteItem_GetPowerLevel(azeriteItemLocation)

		azeriteItem:ContinueWithCancelOnItemLoad(function()
			local azeriteItemName = azeriteItem:GetItemName()
			if UnitLevel('player') < _G.MAX_PLAYER_LEVEL then
				GameTooltip:AddLine(' ')
			end
			GameTooltip:AddLine(azeriteItemName..' ('..format(SPELLBOOK_AVAILABLE_AT, currentLevel)..')', 247/255, 225/255, 171/255)
			GameTooltip:AddDoubleLine(ARTIFACT_POWER, BreakUpLargeNumbers(xp)..' / '..BreakUpLargeNumbers(totalLevelXP)..' ('..floor(xp/totalLevelXP*100)..'%)', 1, 1, 1, 1, 1, 1)
		end)
	end

	if GetWatchedFactionInfo() then
		local name, standing, barMin, barMax, value, factionID = GetWatchedFactionInfo()
		local friendID, _, _, _, _, _, friendTextLevel, _, nextFriendThreshold = GetFriendshipReputation(factionID)
		local currentRank, maxRank = GetFriendshipReputationRanks(friendID)
		local standingtext
		if friendID then
			if maxRank > 0 then
				name = name..' ('..currentRank..' / '..maxRank..')'
			end
			if not nextFriendThreshold then
				value = barMax - 1
			end
			standingtext = friendTextLevel
		else
			if standing == _G.MAX_REPUTATION_REACTION then
				barMax = barMin + 1e3
				value = barMax - 1
			end
			standingtext = GetText('FACTION_STANDING_LABEL'..standing, UnitSex('player'))
		end
		GameTooltip:AddLine(' ')
		GameTooltip:AddLine(name, 62/250, 175/250, 227/250)

		if C_Reputation_IsFactionParagon(factionID) then
			local currentValue, threshold = C_Reputation_GetFactionParagonInfo(factionID)
			local paraCount = floor(currentValue/threshold)
			currentValue = mod(currentValue, threshold)
			GameTooltip:AddDoubleLine(L["MISC_PARAGON"]..' ('..paraCount..')', currentValue..' / '..threshold..' ('..floor(currentValue/threshold*100)..'%)', 1, 1, 1, 1, 1, 1)
		else
			GameTooltip:AddDoubleLine(standingtext, value - barMin..' / '..barMax - barMin..' ('..floor((value - barMin)/(barMax - barMin)*100)..'%)', 1, 1, 1, 1, 1, 1)
		end
	end

	if IsWatchingHonorAsXP() then
		local current, barMax, level = UnitHonor('player'), UnitHonorMax('player'), UnitHonorLevel('player')
		GameTooltip:AddLine(' ')
		GameTooltip:AddLine(HONOR, 177/250, 19/250, 0)
		GameTooltip:AddDoubleLine(LEVEL..' ('..level..')', current..' / '..barMax..' ('..floor(current/barMax*100)..'%)', 1, 1, 1, 1, 1, 1)
	end

	GameTooltip:Show()
end

local function OnLeave()
	GameTooltip:Hide()
end

function module:SetupScript(bar)
	bar.eventList = {
		'PLAYER_XP_UPDATE',
		'PLAYER_LEVEL_UP',
		'UPDATE_EXHAUSTION',
		'PLAYER_ENTERING_WORLD',
		'UPDATE_FACTION',
		'ARTIFACT_XP_UPDATE',
		'UNIT_INVENTORY_CHANGED',
		'ENABLE_XP_GAIN',
		'DISABLE_XP_GAIN',
		'AZERITE_ITEM_EXPERIENCE_CHANGED',
		'HONOR_XP_UPDATE',
	}
	for _, event in pairs(bar.eventList) do
		bar:RegisterEvent(event)
	end
	bar:SetScript('OnEvent', UpdateBar)
	bar:SetScript('OnEnter', UpdateTooltip)
	bar:SetScript('OnLeave', OnLeave)
end

function module:Initialize()
	module.db = E.db.mui.databars
	MER:RegisterDB(self, "databars")

	if module.db.progressbar ~= true or E.private.general.minimap.enable ~= true then return end

	local bar = CreateFrame('StatusBar', nil, _G.Minimap)
	bar:SetPoint('BOTTOM', _G.Minimap, 'TOP', 0, 1)
	bar:SetSize(E.db.general.minimap.size*E.mult, 3)
	bar:SetStatusBarTexture(E.media.normTex)
	bar:CreateBackdrop(nil, true)
	bar:SetHitRectInsets(0, 0, -10, -10)
	E:RegisterStatusBar(bar)

	local resting = CreateFrame('StatusBar', nil, bar)
	resting:SetAllPoints()
	resting:SetStatusBarTexture(E.media.normTex)
	resting:SetStatusBarColor(105/250, 194/250, 221/250, .9)
	resting:SetFrameLevel(bar:GetFrameLevel() - 1)
	bar.restBar = resting

	self:SetupScript(bar)
end

MER:RegisterModule(module:GetName())
