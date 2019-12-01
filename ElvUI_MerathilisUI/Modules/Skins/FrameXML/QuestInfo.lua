local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local next, pairs, select, unpack = next, pairs, select, unpack
-- WoW API / Variables
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local BAG_ITEM_QUALITY_COLORS = BAG_ITEM_QUALITY_COLORS
local GetNumQuestLeaderBoards = GetNumQuestLeaderBoards
local GetQuestLogLeaderBoard = GetQuestLogLeaderBoard
local GetNumQuestLogRewardSpells = GetNumQuestLogRewardSpells
local GetNumRewardSpells = GetNumRewardSpells
local C_QuestLog_GetNextWaypointText = C_QuestLog.GetNextWaypointText
local GetQuestLogSelection = GetQuestLogSelection
local GetQuestLogTitle = GetQuestLogTitle
local GetQuestID = GetQuestID
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function RestyleSpellButton(bu)
	local name = bu:GetName()
	local icon = bu.Icon

	_G[name.."NameFrame"]:Hide()
	_G[name.."SpellBorder"]:Hide()

	icon:SetPoint("TOPLEFT", 3, -2)
	icon:SetDrawLayer("ARTWORK")
	icon:SetTexCoord(unpack(E.TexCoords))
	MERS:CreateBG(icon)

	local bg = CreateFrame("Frame", nil, bu)
	bg:SetPoint("TOPLEFT", 2, -1)
	bg:SetPoint("BOTTOMRIGHT", 0, 14)
	bg:SetFrameLevel(0)
	MERS:CreateBD(bg, .25)
end

local function QuestInfo_GetQuestID()
	if _G.QuestInfoFrame.questLog then
		return select(8, GetQuestLogTitle(GetQuestLogSelection()))
	else
		return GetQuestID()
	end
end

local function ColorObjectivesText()
	if not _G.QuestInfoFrame.questLog then return end

	local questID = QuestInfo_GetQuestID()
	local objectivesTable = _G.QuestInfoObjectivesFrame.Objectives
	local numVisibleObjectives = 0

	local waypointText = C_QuestLog_GetNextWaypointText(questID)
	if waypointText then
		numVisibleObjectives = numVisibleObjectives + 1
		local objective = _G['QuestInfoObjective'..numVisibleObjectives]
		objective:SetTextColor(1, .8, .1)
	end

	for i = 1, GetNumQuestLeaderBoards() do
		local _, type, finished = GetQuestLogLeaderBoard(i)

		if (type ~= "spell" and type ~= "log" and numVisibleObjectives < _G.MAX_OBJECTIVES) then
			numVisibleObjectives = numVisibleObjectives + 1
			local objective = _G['QuestInfoObjective'..numVisibleObjectives]
			if objective then
				if finished then
					objective:SetTextColor(34/255, 255/255, 0/255)
				else
					objective:SetTextColor(1, 1, 1)
				end
			end
		end
	end
end

local function RestyleRewardButton(bu, isMapQuestInfo)
	bu.Icon:SetTexCoord(unpack(E.TexCoords))
	bu.Icon:SetDrawLayer("OVERLAY")
	bu.NameFrame:SetAlpha(0)
	bu.Count:ClearAllPoints()
	bu.Count:SetPoint("BOTTOMRIGHT", bu.Icon, "BOTTOMRIGHT", 2, 0)
	bu.Count:SetDrawLayer("OVERLAY")

	local bg = MERS:CreateBDFrame(bu, .25)
	bg:SetFrameStrata("BACKGROUND")

	if isMapQuestInfo then
		bg:SetPoint("TOPLEFT", bu.NameFrame, 1, 1)
		bg:SetPoint("BOTTOMRIGHT", bu.NameFrame, -3, 0)
	else
		bg:SetPoint("TOPLEFT", bu, 1, 1)
		bg:SetPoint("BOTTOMRIGHT", bu, -3, 1)
	end

	if bu.CircleBackground then
		bu.CircleBackground:SetAlpha(0)
		bu.CircleBackgroundGlow:SetAlpha(0)
	end

	bu.bg = bg
end

local function HookTextColor_Yellow(self)
	if self.isSetting then return end
	self.isSetting = true
	self:SetTextColor(1, .8, 0)
	self.isSetting = nil
end

local function SetTextColor_Yellow(font)
	font:SetShadowColor(0, 0, 0)
	font:SetTextColor(1, .8, 0)
	hooksecurefunc(font, "SetTextColor", HookTextColor_Yellow)
end

local function HookTextColor_White(self)
	if self.isSetting then return end
	self.isSetting = true
	self:SetTextColor(1, 1, 1)
	self.isSetting = nil
end

local function SetTextColor_White(font)
	font:SetShadowColor(0, 0, 0)
	font:SetTextColor(1, 1, 1)
	hooksecurefunc(font, "SetTextColor", HookTextColor_White)
end

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true or E.private.muiSkins.blizzard.quest ~= true then return; end

	-- Stop here if parchment reomover is enabled.
	if E.private.skins.parchmentRemover.enable then return end

	-- [[ Objectives ]]
	RestyleSpellButton(_G.QuestInfoSpellObjectiveFrame)

	hooksecurefunc("QuestMapFrame_ShowQuestDetails", ColorObjectivesText)
	hooksecurefunc("QuestInfo_Display", ColorObjectivesText)

	-- [[ Quest rewards ]]
	hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, index)
		local bu = rewardsFrame.RewardButtons[index]

		if (bu and not bu.restyled) then
			RestyleRewardButton(bu, rewardsFrame == _G.MapQuestInfoRewardsFrame)

			bu.Icon:SetTexCoord(unpack(E.TexCoords))
			bu.IconBorder:SetAlpha(0)
			bu.Icon:SetDrawLayer("OVERLAY")
			bu.Count:SetDrawLayer("OVERLAY")

			bu.restyled = true
		end
	end)

	_G.MapQuestInfoRewardsFrame.XPFrame.Name:SetShadowOffset(0, 0)
	for _, name in next, {"HonorFrame", "MoneyFrame", "SkillPointFrame", "XPFrame", "ArtifactXPFrame", "TitleFrame"} do
		RestyleRewardButton(_G.MapQuestInfoRewardsFrame[name], true)
	end

	for _, name in next, {"HonorFrame", "SkillPointFrame", "ArtifactXPFrame"} do
		RestyleRewardButton(_G.QuestInfoRewardsFrame[name])
	end

	--Spell Rewards
	local spellRewards = { _G["QuestInfoRewardsFrame"], _G["MapQuestInfoRewardsFrame"] }
	for _, rewardFrame in pairs(spellRewards) do
		local spellRewardFrame = rewardFrame.spellRewardPool:Acquire()
		local icon = spellRewardFrame.Icon
		local nameFrame = spellRewardFrame.NameFrame

		spellRewardFrame:StripTextures()
		icon:SetTexCoord(unpack(E.TexCoords))
		MERS:CreateBDFrame(icon)
		nameFrame:Hide()

		local bg = MERS:CreateBDFrame(nameFrame, .25)
		bg:SetPoint("TOPLEFT", icon, "TOPRIGHT", 0, 2)
		bg:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 101, -1)
	end

	-- Title Reward
	do
		local frame = _G.QuestInfoPlayerTitleFrame
		local icon = frame.Icon

		icon:SetTexCoord(unpack(E.TexCoords))
		MERS:CreateBDFrame(icon)
		for i = 2, 4 do
			select(i, frame:GetRegions()):Hide()
		end
		local bg = MERS:CreateBDFrame(frame, .25)
		bg:SetPoint("TOPLEFT", icon, "TOPRIGHT", 0, 2)
		bg:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 220, -1)
	end

	-- Follower Rewards
	hooksecurefunc("QuestInfo_Display", function(template, parentFrame, acceptButton, material, mapView)
		local rewardsFrame = _G.QuestInfoFrame.rewardsFrame
		local isQuestLog = _G.QuestInfoFrame.questLog ~= nil
		local isMapQuest = rewardsFrame == _G.MapQuestInfoRewardsFrame
		local numSpellRewards = isQuestLog and GetNumQuestLogRewardSpells() or GetNumRewardSpells()

		if (template.canHaveSealMaterial) then
			local questFrame = parentFrame:GetParent():GetParent()
			questFrame.SealMaterialBG:Hide()
		end

		if numSpellRewards > 0 then
			for spellHeader in rewardsFrame.spellHeaderPool:EnumerateActive() do
				spellHeader:SetVertexColor(1, 1, 1)
			end
		end
	end)

	-- [[ Change text colors ]]
	hooksecurefunc(_G.QuestInfoRequiredMoneyText, "SetTextColor", function(self, r)
		if r == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif r == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	local yellowish = {
		_G.QuestInfoTitleHeader,
		_G.QuestInfoDescriptionHeader,
		_G.QuestInfoObjectivesHeader,
		_G.QuestInfoRewardsFrame.Header,
	}
	for _, font in pairs(yellowish) do
		SetTextColor_Yellow(font)
	end

	local whitish = {
		_G.QuestInfoDescriptionText,
		_G.QuestInfoObjectivesText,
		_G.QuestInfoQuestType,
		_G.QuestInfoGroupSize,
		_G.QuestInfoRewardText,
		_G.QuestInfoSpellObjectiveLearnLabel,
		_G.QuestInfoRewardsFrame.ItemChooseText,
		_G.QuestInfoRewardsFrame.ItemReceiveText,
		_G.QuestInfoRewardsFrame.PlayerTitleText,
		_G.QuestInfoRewardsFrame.XPFrame.ReceiveText,
	}
	for _, font in pairs(whitish) do
		SetTextColor_White(font)
	end
end

S:AddCallback("mUIQuestInfo", LoadSkin)
