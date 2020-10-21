local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

-- Cache global variables
-- Lua functions
local _G = _G
local format = string.format
local next, pairs, select = next, pairs, select
local tinsert = table.insert
-- WoW API / Variables
local InCombatLockdown = InCombatLockdown
local GetQuestLink = GetQuestLink
local GetQuestLogTitle = GetQuestLogTitle
local GetAutoQuestPopUp = GetAutoQuestPopUp
local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local GetNumAutoQuestPopUps = GetNumAutoQuestPopUps
local GetQuestLogIndexByID = GetQuestLogIndexByID
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

local function QuestNumString()
	local questNum = 0
	local q, o
	local block = _G.ObjectiveTrackerBlocksFrame
	local frame = _G.ObjectiveTrackerFrame

	if not InCombatLockdown() then
		for questLogIndex = 1, C_QuestLog_GetNumQuestLogEntries() do
			local info = C_QuestLog_GetInfo(questLogIndex)
			if not info.isHeader and not info.isHidden then
				questNum = questNum + 1
			end
		end

		if questNum >= (_G.MAX_QUESTS - 5) then -- go red
			q = format("|cffff0000%d/%d|r %s", questNum, _G.MAX_QUESTS, _G.TRACKER_HEADER_QUESTS)
			o = format("|cffff0000%d/%d|r %s", questNum, _G.MAX_QUESTS, _G.OBJECTIVES_TRACKER_LABEL)
		else
			q = format("%d/%d %s", questNum, _G.MAX_QUESTS, _G.TRACKER_HEADER_QUESTS)
			o = format("%d/%d %s", questNum, _G.MAX_QUESTS, _G.OBJECTIVES_TRACKER_LABEL)
		end
		block.QuestHeader.Text:SetText(q)
		frame.HeaderMenu.Title:SetText(o)
	end
end

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.private.muiSkins.blizzard.objectiveTracker ~= true then return end

	-- Add Panels
	hooksecurefunc("ObjectiveTracker_Update", function()
		local Frame = _G.ObjectiveTrackerFrame.MODULES

		if Frame then
			for i = 1, #Frame do

				local Modules = Frame[i]
				if Modules then
					local Header = Modules.Header
					Header:SetFrameStrata("LOW")

					if not Modules.IsSkinned then
						local HeaderPanel = CreateFrame("Frame", nil, Modules.Header)
						HeaderPanel:SetFrameLevel(Modules.Header:GetFrameLevel() - 1)
						HeaderPanel:SetFrameStrata("LOW")
						HeaderPanel:SetPoint("BOTTOMLEFT", 0, 3)
						HeaderPanel:SetSize(210, 2)
						MERS:SkinPanel(HeaderPanel)

						Modules.IsSkinned = true
					end
				end
			end
		end

		QuestNumString()
	end)

	_G.ObjectiveTrackerFrame:SetSize(235, 140)
	_G.ObjectiveTrackerFrame.HeaderMenu:SetSize(10, 10)
end

S:AddCallback("mUIObjectiveTracker", LoadSkin)
