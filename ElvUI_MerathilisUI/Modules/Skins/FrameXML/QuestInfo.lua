local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local next, pairs, select, unpack = next, pairs, select, unpack

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local GetNumQuestLeaderBoards = GetNumQuestLeaderBoards
local GetQuestLogLeaderBoard = GetQuestLogLeaderBoard
local GetNextWaypointText = C_QuestLog.GetNextWaypointText
local GetSelectedQuest = C_QuestLog.GetSelectedQuest
local GetQuestID = GetQuestID

local function QuestInfo_GetQuestID()
	if _G.QuestInfoFrame.questLog then
		return GetSelectedQuest()
	else
		return GetQuestID()
	end
end

local function ColorObjectivesText()
	if not _G.QuestInfoFrame.questLog then
		return
	end

	local questID = QuestInfo_GetQuestID()
	local numVisibleObjectives = 0

	local waypointText = GetNextWaypointText(questID)
	if waypointText then
		numVisibleObjectives = numVisibleObjectives + 1
		local objective = _G["QuestInfoObjective" .. numVisibleObjectives]
		objective:SetTextColor(0.4, 1, 1)
	end

	for i = 1, GetNumQuestLeaderBoards() do
		local _, objectiveType, isCompleted = GetQuestLogLeaderBoard(i)

		if objectiveType ~= "spell" and objectiveType ~= "log" and numVisibleObjectives < _G.MAX_OBJECTIVES then
			numVisibleObjectives = numVisibleObjectives + 1
			local objective = _G["QuestInfoObjective" .. numVisibleObjectives]
			if objective then
				if isCompleted then
					objective:SetTextColor(0.2, 1, 0.2)
				else
					objective:SetTextColor(1, 1, 1)
				end
			end
		end
	end
end

local defaultColor = GetMaterialTextColors("Default")
local completedColor = QUEST_OBJECTIVE_COMPLETED_FONT_COLOR:GetRGB()
local function ReplaceTextColor(object, r)
	if r == 0 or r == defaultColor[1] then
		object:SetTextColor(1, 1, 1)
	elseif r == completedColor then
		object:SetTextColor(0.7, 0.7, 0.7)
	end
end

local function RestyleSpellButton(bu)
	local name = bu:GetName()
	local icon = bu.Icon

	_G[name .. "NameFrame"]:Hide()
	_G[name .. "SpellBorder"]:Hide()

	icon:SetPoint("TOPLEFT", 3, -2)
	icon:SetDrawLayer("ARTWORK")
	icon:SetTexCoord(unpack(E.TexCoords))
	module:CreateBG(icon)

	local bg = CreateFrame("Frame", nil, bu)
	bg:SetPoint("TOPLEFT", 2, -1)
	bg:SetPoint("BOTTOMRIGHT", 0, 14)
	bg:SetFrameLevel(0)
	bg:CreateBackdrop("Transparent")
end

local function ReskinRewardButton(bu)
	bu.NameFrame:Hide()
	S:HandleIcon(bu.Icon, true)

	bu:CreateBackdrop("Transparent")
	bu.backdrop:Point("TOPLEFT", bu.Icon.backdrop, "TOPRIGHT", 2, 0)
	bu.backdrop:Point("BOTTOMRIGHT", bu.Icon.backdrop, 100, 0)
	bu.textBG = bu.backdrop
end

local function ReskinRewardButtonWithSize(bu, isMapQuestInfo)
	ReskinRewardButton(bu)

	if isMapQuestInfo then
		bu.Icon:SetSize(29, 29)
	else
		bu.Icon:SetSize(34, 34)
	end
end

local function HookTextColor_Yellow(self, r, g, b)
	if r ~= 1 or g ~= 0.8 or b ~= 0 then
		self:SetTextColor(1, 0.8, 0)
	end
end

local function SetTextColor_Yellow(font)
	font:SetTextColor(1, 0.8, 0)
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

function module:QuestInfo()
	if not module:CheckDB("quest", "quest") then
		return
	end

	-- Item reward highlight
	_G.QuestInfoItemHighlight:Kill()

	RestyleSpellButton(_G.QuestInfoSpellObjectiveFrame)

	hooksecurefunc("QuestMapFrame_ShowQuestDetails", ColorObjectivesText)
	ColorObjectivesText()

	-- [[ Quest rewards ]]
	hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, index)
		local bu = rewardsFrame.RewardButtons[index]

		if bu and not bu.restyled then
			ReskinRewardButtonWithSize(bu, rewardsFrame == _G.MapQuestInfoRewardsFrame)
			bu.restyled = true
		end
	end)

	_G.MapQuestInfoRewardsFrame.XPFrame.Name:SetShadowOffset(0, 0)
	for _, name in
		next,
		{
			"HonorFrame",
			"MoneyFrame",
			"SkillPointFrame",
			"XPFrame",
			"ArtifactXPFrame",
			"TitleFrame",
			"WarModeBonusFrame",
		}
	do
		ReskinRewardButtonWithSize(_G.MapQuestInfoRewardsFrame[name], true)
	end

	for _, name in next, { "HonorFrame", "SkillPointFrame", "ArtifactXPFrame", "WarModeBonusFrame" } do
		ReskinRewardButtonWithSize(_G.QuestInfoRewardsFrame[name])
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

		nameFrame:CreateBackdrop("Transparent")
		nameFrame.backdrop:SetPoint("TOPLEFT", icon, "TOPRIGHT", 0, 2)
		nameFrame.backdrop:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 101, -1)
	end

	-- Title Reward
	do
		local frame = _G.QuestInfoPlayerTitleFrame
		local icon = frame.Icon

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:CreateBackdrop("Transparent")
		for i = 2, 4 do
			select(i, frame:GetRegions()):Hide()
		end

		frame:CreateBackdrop("Transparent")
		frame.backdrop:SetPoint("TOPLEFT", icon, "TOPRIGHT", 0, 2)
		frame.backdrop:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 220, -1)
	end

	hooksecurefunc(_G.QuestInfoRequiredMoneyText, "SetTextColor", function(self, r)
		if r == 0 then
			self:SetTextColor(0.8, 0.8, 0.8, 1)
		elseif r == 0.2 then
			self:SetTextColor(1, 1, 1, 1)
		end
	end)

	local yellowish = {
		_G.QuestInfoTitleHeader,
		_G.QuestInfoDescriptionHeader,
		_G.QuestInfoObjectivesHeader,
		_G.QuestInfoRewardsFrame.Header,
		_G.QuestInfoAccountCompletedNotice,
	}

	for _, font in pairs(yellowish) do
		SetTextColor_Yellow(font)
	end

	local whitish = {
		_G.QuestInfoDescriptionText,
		_G.QuestInfoObjectivesText,
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

	-- Replace seal signature string
	local replacedSealColor = {
		["480404"] = "c20606",
		["042c54"] = "1c86ee",
	}
	hooksecurefunc(QuestInfoSealFrame.Text, "SetText", function(self, text)
		if text and text ~= "" then
			local colorStr, rawText = strmatch(text, "|c[fF][fF](%x%x%x%x%x%x)(.-)|r")
			if colorStr and rawText then
				colorStr = replacedSealColor[colorStr] or "99ccff"
				self:SetFormattedText("|cff%s%s|r", colorStr, rawText)
			end
		end
	end)

	-- Others
	hooksecurefunc("QuestInfo_Display", function()
		local objectivesTable = QuestInfoObjectivesFrame.Objectives
		for i = #objectivesTable, 1, -1 do
			local object = objectivesTable[i]
			if object.hooked then
				break
			end
			hooksecurefunc(object, "SetTextColor", ReplaceTextColor)
			local r, g, b = object:GetTextColor()
			object:SetTextColor(r, g, b)

			object.hooked = true
		end

		local rewardsFrame = QuestInfoFrame.rewardsFrame
		local isQuestLog = QuestInfoFrame.questLog ~= nil
		local questID = isQuestLog and C_QuestLog.GetSelectedQuest() or GetQuestID()
		local spellRewards = C_QuestInfoSystem.GetQuestRewardSpells(questID) or {}

		if #spellRewards > 0 then
			-- Spell Headers
			for spellHeader in rewardsFrame.spellHeaderPool:EnumerateActive() do
				spellHeader:SetVertexColor(1, 1, 1)
			end

			-- Follower Rewards
			for reward in rewardsFrame.followerRewardPool:EnumerateActive() do
				local portrait = reward.PortraitFrame
				if portrait then
					local color = E.QualityColors[portrait.quality or 1]
					portrait.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
				end
			end
			-- Spell Rewards
			for spellReward in rewardsFrame.spellRewardPool:EnumerateActive() do
				if not spellReward.styled then
					ReskinRewardButton(spellReward)

					spellReward.styled = true
				end
			end
		end

		-- Reputation Rewards
		for repReward in rewardsFrame.reputationRewardPool:EnumerateActive() do
			if not repReward.styled then
				ReskinRewardButton(repReward)

				repReward.styled = true
			end
		end
	end)

	hooksecurefunc(QuestInfoQuestType, "SetTextColor", function(text, r, g, b)
		if not (r == 1 and g == 1 and b == 1) then
			text:SetTextColor(1, 1, 1)
		end
	end)

	-- Change text colors
	hooksecurefunc(QuestInfoRequiredMoneyText, "SetTextColor", ReplaceTextColor)
	hooksecurefunc(QuestInfoSpellObjectiveLearnLabel, "SetTextColor", ReplaceTextColor)
end

module:AddCallback("QuestInfo")
