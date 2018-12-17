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
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function styleQuestInfo()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true or E.private.muiSkins.blizzard.quest ~= true then return; end

	-- [[ Shared ]]
	local function restyleSpellButton(bu)
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

	-- [[ Objectives ]]
	restyleSpellButton(_G.QuestInfoSpellObjectiveFrame)

	local function colorObjectivesText()
		if not _G.QuestInfoFrame.questLog then return end

		local objectivesTable = _G.QuestInfoObjectivesFrame.Objectives
		local numVisibleObjectives = 0

		for i = 1, GetNumQuestLeaderBoards() do
			local _, type, finished = GetQuestLogLeaderBoard(i)

			if (type ~= "spell" and type ~= "log" and numVisibleObjectives < _G.MAX_OBJECTIVES) then
				numVisibleObjectives = numVisibleObjectives + 1
				local objective = objectivesTable[numVisibleObjectives]

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

	hooksecurefunc("QuestMapFrame_ShowQuestDetails", colorObjectivesText)
	hooksecurefunc("QuestInfo_Display", colorObjectivesText)

	-- [[ Quest rewards ]]
	local function restyleRewardButton(bu, isMapQuestInfo)
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

	hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, index)
		local bu = rewardsFrame.RewardButtons[index]

		if (bu and not bu.restyled) then
			restyleRewardButton(bu, rewardsFrame == _G.MapQuestInfoRewardsFrame)

			bu.Icon:SetTexCoord(unpack(E.TexCoords))
			bu.IconBorder:SetAlpha(0)
			bu.Icon:SetDrawLayer("OVERLAY")
			bu.Count:SetDrawLayer("OVERLAY")

			bu.restyled = true
		end
	end)

	_G.MapQuestInfoRewardsFrame.XPFrame.Name:SetShadowOffset(0, 0)
	for _, name in next, {"HonorFrame", "MoneyFrame", "SkillPointFrame", "XPFrame", "ArtifactXPFrame", "TitleFrame"} do
		restyleRewardButton(_G.MapQuestInfoRewardsFrame[name], true)
	end

	for _, name in next, {"HonorFrame", "SkillPointFrame", "ArtifactXPFrame"} do
		restyleRewardButton(_G.QuestInfoRewardsFrame[name])
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
			for reward in rewardsFrame.followerRewardPool:EnumerateActive() do
				local portrait = reward.PortraitFrame
				if not reward.styled then
					portrait:ClearAllPoints()
					portrait:SetPoint("TOPLEFT", 2, -5)
					MERS:ReskinGarrisonPortrait(portrait)
					reward.BG:Hide()
					local bg = MERS:CreateBDFrame(reward, .25)
					bg:SetPoint("TOPLEFT", 0, -3)
					bg:SetPoint("BOTTOMRIGHT", 2, 7)
					reward.styled = true
				end
				if portrait then
					local color = BAG_ITEM_QUALITY_COLORS[portrait.quality or 1]
					portrait.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
				end
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

	_G.QuestInfoTitleHeader:SetTextColor(1, 1, 1)
	_G.QuestInfoTitleHeader.SetTextColor = MER.dummy
	_G.QuestInfoTitleHeader:SetShadowColor(0, 0, 0)

	_G.QuestInfoDescriptionHeader:SetTextColor(1, 1, 1)
	_G.QuestInfoDescriptionHeader.SetTextColor = MER.dummy
	_G.QuestInfoDescriptionHeader:SetShadowColor(0, 0, 0)

	_G.QuestInfoObjectivesHeader:SetTextColor(1, 1, 1)
	_G.QuestInfoObjectivesHeader.SetTextColor = MER.dummy
	_G.QuestInfoObjectivesHeader:SetShadowColor(0, 0, 0)

	_G.QuestInfoRewardsFrame.Header:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardsFrame.Header.SetTextColor = MER.dummy
	_G.QuestInfoRewardsFrame.Header:SetShadowColor(0, 0, 0)

	_G.QuestInfoDescriptionText:SetTextColor(1, 1, 1)
	_G.QuestInfoDescriptionText.SetTextColor = MER.dummy

	_G.QuestInfoObjectivesText:SetTextColor(1, 1, 1)
	_G.QuestInfoObjectivesText.SetTextColor = MER.dummy

	_G.QuestInfoGroupSize:SetTextColor(1, 1, 1)
	_G.QuestInfoGroupSize.SetTextColor = MER.dummy

	_G.QuestInfoRewardText:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardText.SetTextColor = MER.dummy

	_G.QuestInfoSpellObjectiveLearnLabel:SetTextColor(1, 1, 1)
	_G.QuestInfoSpellObjectiveLearnLabel.SetTextColor = MER.dummy

	_G.QuestInfoRewardsFrame.ItemChooseText:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardsFrame.ItemChooseText.SetTextColor = MER.dummy

	_G.QuestInfoRewardsFrame.ItemReceiveText:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardsFrame.ItemReceiveText.SetTextColor = MER.dummy

	_G.QuestInfoRewardsFrame.PlayerTitleText:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardsFrame.PlayerTitleText.SetTextColor = MER.dummy

	_G.QuestInfoRewardsFrame.XPFrame.ReceiveText:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardsFrame.XPFrame.ReceiveText.SetTextColor = MER.dummy

	_G.QuestInfoRewardsFrame.spellHeaderPool:Acquire():SetVertexColor(1, 1, 1)
	_G.QuestInfoRewardsFrame.spellHeaderPool:Acquire().SetVertexColor = MER.dummy
end

S:AddCallback("mUIQuestInfo", styleQuestInfo)
