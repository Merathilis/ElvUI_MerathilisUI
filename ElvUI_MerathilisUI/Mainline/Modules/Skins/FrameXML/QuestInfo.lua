local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local next, pairs, select, unpack = next, pairs, select, unpack

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local GetNumQuestLeaderBoards = GetNumQuestLeaderBoards
local GetQuestLogLeaderBoard = GetQuestLogLeaderBoard
local GetNumQuestLogRewardSpells = GetNumQuestLogRewardSpells
local GetNumRewardSpells = GetNumRewardSpells
local C_QuestLog_GetNextWaypointText = C_QuestLog.GetNextWaypointText
local C_QuestLog_GetSelectedQuest = C_QuestLog.GetSelectedQuest
local GetQuestID = GetQuestID

local function QuestInfo_GetQuestID()
	if _G.QuestInfoFrame.questLog then
		return C_QuestLog_GetSelectedQuest()
	else
		return GetQuestID()
	end
end

local function ColorObjectivesText()
	if not _G.QuestInfoFrame.questLog then return end

	local questID = QuestInfo_GetQuestID()
	local numVisibleObjectives = 0

	local waypointText = C_QuestLog_GetNextWaypointText(questID)
	if waypointText then
		numVisibleObjectives = numVisibleObjectives + 1
		local objective = _G['QuestInfoObjective'..numVisibleObjectives]
		objective:SetTextColor(.4, 1, 1)
	end

	for i = 1, GetNumQuestLeaderBoards() do
		local _, objectiveType, isCompleted = GetQuestLogLeaderBoard(i)

		if objectiveType ~= "spell" and objectiveType ~= "log" and numVisibleObjectives < _G.MAX_OBJECTIVES then
			numVisibleObjectives = numVisibleObjectives + 1
			local objective = _G['QuestInfoObjective'..numVisibleObjectives]
			if objective then
				if isCompleted then
					objective:SetTextColor(.2, 1, .2)
				else
					objective:SetTextColor(1, 1, 1)
				end
			end
		end
	end
end

local function RestyleSpellButton(bu)
	local name = bu:GetName()
	local icon = bu.Icon

	_G[name.."NameFrame"]:Hide()
	_G[name.."SpellBorder"]:Hide()

	icon:SetPoint("TOPLEFT", 3, -2)
	icon:SetDrawLayer("ARTWORK")
	icon:SetTexCoord(unpack(E.TexCoords))
	module:CreateBG(icon)

	local bg = CreateFrame("Frame", nil, bu)
	bg:SetPoint("TOPLEFT", 2, -1)
	bg:SetPoint("BOTTOMRIGHT", 0, 14)
	bg:SetFrameLevel(0)
	bg:CreateBackdrop('Transparent')
end

local function RestyleRewardButton(bu, isMapQuestInfo)
	if bu.Icon then
		bu.Icon:SetTexCoord(unpack(E.TexCoords))
		bu.Icon:SetDrawLayer("OVERLAY")
	end

	if bu.NameFrame then
		bu.NameFrame:SetAlpha(0)
	end

	if bu.Count then
		bu.Count:ClearAllPoints()
		bu.Count:SetPoint("BOTTOMRIGHT", bu.Icon, "BOTTOMRIGHT", 2, 0)
		bu.Count:SetDrawLayer("OVERLAY")
    end

	if bu.RewardAmount then
		bu.RewardAmount:ClearAllPoints()
		bu.RewardAmount:SetPoint("BOTTOMRIGHT", bu.Icon, "BOTTOMRIGHT", 2, 0)
		bu.RewardAmount:SetDrawLayer("OVERLAY")
	end

	bu:CreateBackdrop('Transparent')
	bu.backdrop:SetFrameStrata("BACKGROUND")
	module:CreateGradient(bu.backdrop)

	if isMapQuestInfo then
		bu.backdrop:SetPoint("TOPLEFT", bu.NameFrame, 1, 1)
		bu.backdrop:SetPoint("BOTTOMRIGHT", bu.NameFrame, -3, 0)
	else
		bu.backdrop:SetPoint("TOPLEFT", bu, 1, 1)
		bu.backdrop:SetPoint("BOTTOMRIGHT", bu, -3, 1)
	end

	if bu.CircleBackground then
		bu.CircleBackground:SetAlpha(0)
		bu.CircleBackgroundGlow:SetAlpha(0)
	end

	bu.bg = bu.backdrop
end

local function HookTextColor_Yellow(self, r, g, b)
	if r ~= 1 or g ~= .8 or b ~= 0 then
		self:SetTextColor(1, .8, 0)
	end
end

local function SetTextColor_Yellow(font)
	font:SetTextColor(1, .8, 0)
	font:SetShadowColor(0, 0, 0, 0)
	hooksecurefunc(font, "SetTextColor", HookTextColor_Yellow)
end

local function HookTextColor_White(self, r, g, b)
	if r ~= 1 or g ~= 1 or b ~= 1 then
		self:SetTextColor(1, 1, 1)
	end
end

local function SetTextColor_White(font)
	font:SetTextColor(1, 1, 1)
	font:SetShadowColor(0, 0, 0, 0)
	hooksecurefunc(font, "SetTextColor", HookTextColor_White)
end

local function LoadSkin()
	if not module:CheckDB("quest", "quest") then
		return
	end

	-- Item reward highlight
	_G.QuestInfoItemHighlight:GetRegions():Hide()
	RestyleSpellButton(_G.QuestInfoSpellObjectiveFrame)

	hooksecurefunc("QuestMapFrame_ShowQuestDetails", ColorObjectivesText)
	ColorObjectivesText()

	-- [[ Quest rewards ]]
	hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, index)
		local bu = rewardsFrame.RewardButtons[index]

		if (bu and not bu.restyled) then
			RestyleRewardButton(bu, rewardsFrame == _G.MapQuestInfoRewardsFrame)
			bu.restyled = true
		end
	end)

	_G.MapQuestInfoRewardsFrame.XPFrame.Name:SetShadowOffset(0, 0)
	for _, name in next, {"HonorFrame", "MoneyFrame", "SkillPointFrame", "XPFrame", "ArtifactXPFrame", "TitleFrame", "WarModeBonusFrame"} do
		RestyleRewardButton(_G.MapQuestInfoRewardsFrame[name], true)
	end

	for _, name in next, {"HonorFrame", "SkillPointFrame", "ArtifactXPFrame", "WarModeBonusFrame"} do
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
		module:CreateBDFrame(icon)
		nameFrame:Hide()

		nameFrame:CreateBackdrop('Transparent')
		nameFrame.backdrop:SetPoint("TOPLEFT", icon, "TOPRIGHT", 0, 2)
		nameFrame.backdrop:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 101, -1)
	end

	-- Title Reward
	do
		local frame = _G.QuestInfoPlayerTitleFrame
		local icon = frame.Icon

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:CreateBackdrop('Transparent')
		for i = 2, 4 do
			select(i, frame:GetRegions()):Hide()
		end

		frame:CreateBackdrop('Transparent')
		frame.backdrop:SetPoint("TOPLEFT", icon, "TOPRIGHT", 0, 2)
		frame.backdrop:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 220, -1)
	end

	hooksecurefunc(_G.QuestInfoRequiredMoneyText, "SetTextColor", function(self, r)
		if r == 0 then
			self:SetTextColor(.8, .8, .8, 1)
		elseif r == .2 then
			self:SetTextColor(1, 1, 1, 1)
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
		_G.QuestInfoTimerText,
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

S:AddCallback("QuestInfo", LoadSkin)
