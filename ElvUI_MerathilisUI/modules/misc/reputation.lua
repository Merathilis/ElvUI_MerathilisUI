local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule("mUIMisc")

-- Cache global variables
-- Lua functions
local _G = _G
local mod, pairs, select = mod, pairs, select
local format = string.format
local floor = math.floor
-- WoW API / Variables
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter
local ChatTypeInfo = ChatTypeInfo
local CreateFrame = CreateFrame
local FauxScrollFrame_GetOffset = FauxScrollFrame_GetOffset
local GetFactionInfo = GetFactionInfo
local GetNumFactions = GetNumFactions
local hooksecurefunc = hooksecurefunc
local getglobal = getglobal
local NUM_FACTIONS_DISPLAYED = NUM_FACTIONS_DISPLAYED
local REPUTATION_PROGRESS_FORMAT = REPUTATION_PROGRESS_FORMAT
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS:

local SR_REP_MSG = '%s (%d/%d): %+d '..L["MISC_REPUTATION"]
local SR_REP_MSG2 = MER.GreenColor..'%s (%d/10000): %+d '..L["MISC_PARAGON_REPUTATION"]..'|r'
local SR_REP_MSG3 = MER.RedColor..'%s (%d/10000): %+d '..L["MISC_PARAGON_REPUTATION"]..' ('..L["MISC_PARAGON_NOTIFY"]..')|r'

local rep = {}
local extraRep = {}

local f = CreateFrame('Frame')

local function CreateMessage(msg)
	local info = ChatTypeInfo['COMBAT_FACTION_CHANGE']
	for j = 1, 4, 1 do
		local chatframe = getglobal('ChatFrame'..j)
		for k,v in pairs(chatframe.messageTypeList) do
			if v == 'COMBAT_FACTION_CHANGE' then
				chatframe:AddMessage(msg, info.r, info.g, info.b, info.id)
				break
			end
		end
	end
end

local function InitExtraRep(factionID, name)
	local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
	if not extraRep[name] then
		extraRep[name] = currentValue % threshold
		if hasRewardPending then
			extraRep[name] = extraRep[name] + threshold
		end
	end
	if extraRep[name] > threshold and (not hasRewardPending) then
		extraRep[name] = extraRep[name] - threshold
	end
end

local function RepUpdate(self)
	local numFactions = GetNumFactions(self)
	for i = 1, numFactions, 1 do
		local name, _, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID = GetFactionInfo(i)
		local value = 0;
		if barValue >= 42000 then
			local hasParagon = C_Reputation_IsFactionParagon(factionID)
			if hasParagon then
				InitExtraRep(factionID,name)
				local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
				value = currentValue % threshold
				if hasRewardPending then
					value = value + threshold
				end
				local extraChange = value - extraRep[name];
				if extraChange > 0 and value < 10000 then
					extraRep[name] = value
					local extra_msg = format(SR_REP_MSG2, name, value, extraChange)
					CreateMessage(extra_msg);
				end
				if extraChange ~= 0 and value > 10000 then
					extraRep[name] = value
					local extra_msg2 = format(SR_REP_MSG3, name, value, extraChange)
					CreateMessage(extra_msg2);
				end
			end
		elseif name and (not isHeader) or (hasRep) then
			if not rep[name] then
				rep[name] = barValue
			end
			local change = barValue - rep[name]
			if (change > 0) then
				rep[name] = barValue
				local msg = format(SR_REP_MSG, name, barValue - barMin, barMax - barMin, change)
				CreateMessage(msg)
			end
		end
	end
end

local function HookParagonRep()
	local db = E.db.mui.misc.paragon
	local numFactions = GetNumFactions()
	local factionOffset = FauxScrollFrame_GetOffset(_G.ReputationListScrollFrame)

	for i = 1, NUM_FACTIONS_DISPLAYED, 1 do
		local factionIndex = factionOffset + i
		local factionRow = _G['ReputationBar'..i]
		local factionBar = _G['ReputationBar'..i..'ReputationBar']
		local factionStanding = _G['ReputationBar'..i..'ReputationBarFactionStanding']

		if factionIndex <= numFactions then
			local name, _, _ , _, _, _, _, _, _, _, _, _, _, factionID = GetFactionInfo(factionIndex)
			local factionID = select(14, GetFactionInfo(factionIndex))
			if factionID and C_Reputation_IsFactionParagon(factionID) then
				local currentValue, threshold, rewardQuestID, hasRewardPending= C_Reputation_GetFactionParagonInfo(factionID)
				factionRow.questID = rewardQuestID
				local factionStandingtext = L["MISC_PARAGON"]..' ('..floor(currentValue/threshold)..')'
				local colorDB = E.db.mui.misc.paragonColor or 1, 1, 1, 1
				local r, g, b, a = colorDB.r, colorDB.g, colorDB.b, colorDB.a

				if currentValue then
					local barValue = mod(currentValue, threshold)
					if hasRewardPending then
						local paragonFrame = _G.ReputationFrame.paragonFramesPool:Acquire()
						paragonFrame.factionID = factionID
						paragonFrame:SetPoint("RIGHT", factionRow, 11, 0)
						paragonFrame.Glow:SetShown(true)
						paragonFrame.Check:SetShown(true)
						paragonFrame:Show()
						barValue = barValue+threshold
					end

					factionBar:SetMinMaxValues(0, threshold)
					factionBar:SetValue(barValue)
					factionBar:SetStatusBarColor(r, g, b, a)
					factionRow.rolloverText = MER.InfoColor..format(REPUTATION_PROGRESS_FORMAT, barValue, threshold)
					if db.textStyle == "PARAGON" then
						factionStanding:SetText(factionStandingtext)
						factionRow.standingText = factionStandingtext
					elseif db.textStyle == "CURRENT" then
						factionStanding:SetText(BreakUpLargeNumbers(barValue))
						factionRow.standingText = BreakUpLargeNumbers(barValue)
					elseif db.textStyle == "VALUE" then
						factionStanding:SetText(" "..BreakUpLargeNumbers(barValue).." / "..BreakUpLargeNumbers(threshold))
						factionRow.standingText = (" "..BreakUpLargeNumbers(barValue).." / "..BreakUpLargeNumbers(threshold))
						factionRow.rolloverText = nil
					elseif db.textStyle == "DEFICIT" then
						if hasRewardPending then
							barValue = barValue-threshold
							factionStanding:SetText("+"..BreakUpLargeNumbers(barValue))
							factionRow.standingText = "+"..BreakUpLargeNumbers(barValue)
						else
							barValue = threshold-barValue
							factionStanding:SetText(BreakUpLargeNumbers(barValue))
							factionRow.standingText = BreakUpLargeNumbers(barValue)
						end
						factionRow.rolloverText = nil
					end
					if factionIndex == GetSelectedFaction() and ReputationDetailFrame:IsShown() then
						local count = floor(currentValue/threshold)
						if hasRewardPending then count = count-1 end
						if count > 0 then
							ReputationDetailFactionName:SetText(name.." |cffffffffx"..count.."|r")
						end
					end
				end
			else
				factionRow.questID = nil
			end
		else
			factionRow:Hide()
		end
	end
end

function MI:ReputationInit()
	if E.db.mui.misc.paragon.enable ~= true then return end
	if IsAddOnLoaded("ParagonReputation") then return end

	f:RegisterEvent('UPDATE_FACTION')
	f:SetScript('OnEvent', RepUpdate)

	ChatFrame_AddMessageEventFilter('CHAT_MSG_COMBAT_FACTION_CHANGE', function()
		return true
	end)

	hooksecurefunc('ReputationFrame_Update', HookParagonRep)
end
