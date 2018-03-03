local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local next, select = next, select
local gsub = string.gsub
-- WoW API / Variables
local CreateFrame = CreateFrame
local GetMoney = GetMoney
local GetNumQuestLeaderBoards = GetNumQuestLeaderBoards
local GetQuestLogLeaderBoard = GetQuestLogLeaderBoard
local GetQuestLogRequiredMoney = GetQuestLogRequiredMoney

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, MAX_NUM_QUESTS

local function styleQuestFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true or E.private.muiSkins.blizzard.quest ~= true then return; end

	-- ParchmentRemover
	_G["QuestScrollFrame"]:HookScript("OnUpdate", function(self)
		if self.spellTex and self.spellTex2 then
			self.spellTex:SetTexture("")
			self.spellTex:SetTexture("")
		end
	end)
	_G["QuestDetailScrollFrame"]:StripTextures(true)
	_G["QuestDetailScrollFrame"]:HookScript("OnUpdate", function(self)
		self.spellTex:SetTexture("")
	end)

	if _G["QuestDetailScrollFrame"].spellTex then
		_G["QuestDetailScrollFrame"].spellTex:SetTexture("")
	end

	_G["QuestFrameDetailPanel"]:DisableDrawLayer("BACKGROUND")
	_G["QuestFrameDetailPanel"]:DisableDrawLayer("BORDER")

	_G["QuestDetailScrollFrame"]:SetWidth(302) -- else these buttons get cut off
	_G["QuestDetailScrollFrameTop"]:Hide()
	_G["QuestDetailScrollFrameBottom"]:Hide()
	_G["QuestDetailScrollFrameMiddle"]:Hide()

	local DetailsFrame = _G["QuestMapFrame"].DetailsFrame
	local RewardsFrame = DetailsFrame.RewardsFrame
	local CompleteQuestFrame = DetailsFrame.CompleteQuestFrame

	_G["WorldMapFrame"].BorderFrame.Inset:Hide()
	DetailsFrame:GetRegions():Hide()
	select(2, DetailsFrame:GetRegions()):Hide()
	select(4, DetailsFrame:GetRegions()):Hide()
	select(6, DetailsFrame.ShareButton:GetRegions()):Hide()
	select(7, DetailsFrame.ShareButton:GetRegions()):Hide()

	RewardsFrame.Background:Hide()
	select(2, RewardsFrame:GetRegions()):Hide()

	_G["QuestLogPopupDetailFrameScrollFrame"]:HookScript("OnUpdate", function(self)
		_G["QuestLogPopupDetailFrameScrollFrame"].backdrop:Hide()
		_G["QuestLogPopupDetailFrameInset"]:Hide()
		_G["QuestLogPopupDetailFrameBg"]:Hide()
		self:SetTemplate("Transparent")
		self.spellTex:SetTexture("")
	end)
	select(18, _G["QuestLogPopupDetailFrame"]:GetRegions()):Hide()
	_G["QuestLogPopupDetailFrame"]:Styling()

	_G["QuestGreetingScrollFrame"]:StripTextures(true)
	_G["QuestFrameInset"]:StripTextures(true)

	hooksecurefunc("QuestFrame_SetMaterial", function(frame, material)
		if material ~= "Parchment" then
			local name = frame:GetName()
			_G[name.."MaterialTopLeft"]:Hide()
			_G[name.."MaterialTopRight"]:Hide()
			_G[name.."MaterialBotLeft"]:Hide()
			_G[name.."MaterialBotRight"]:Hide()
		end
	end)

	_G["QuestMapFrame"].DetailsFrame:StripTextures()

	_G["QuestProgressScrollFrame"]:HookScript("OnShow", function(self)
		self:SetTemplate("Transparent")
		self.spellTex:SetTexture("")
		self:Height(self:GetHeight() - 2)
	end)

	_G["QuestRewardScrollFrame"]:HookScript("OnShow", function(self)
		self.backdrop:Hide()
		self:SetTemplate("Transparent")
		self.spellTex:SetTexture("")
		self:Height(self:GetHeight() - 2)
	end)

	if _G["QuestGreetingScrollFrame"].spellTex then
		_G["QuestGreetingScrollFrame"].spellTex:SetTexture("")
	end

	hooksecurefunc("QuestInfoItem_OnClick", function(self)
		_G["QuestInfoItemHighlight"]:SetOutside(self.Icon)

		self.Name:SetTextColor(1, 1, 0)
		local parent = self:GetParent()
		for i = 1, #parent.RewardButtons do
			local questItem = _G["QuestInfoRewardsFrame"].RewardButtons[i]
			if(questItem ~= self) then
				questItem.Name:SetTextColor(1, 1, 1)
			end
		end
	end)

	hooksecurefunc("QuestFrameProgressItems_Update", function()
		_G["QuestProgressTitleText"]:SetTextColor(1, 1, 0)
		_G["QuestProgressText"]:SetTextColor(1, 1, 1)
		_G["QuestProgressRequiredItemsText"]:SetTextColor(1, 1, 0)
		_G["QuestProgressRequiredMoneyText"]:SetTextColor(1, 1, 0)
	end)

	_G["QuestFrameGreetingPanel"]:StripTextures()
	_G["QuestGreetingScrollFrame"]:StripTextures()
	_G["QuestGreetingFrameHorizontalBreak"]:Kill()
	_G["GreetingText"]:SetTextColor(1, 1, 1)
	_G["GreetingText"].SetTextColor = MER.dummy
	_G["CurrentQuestsText"]:SetTextColor(1, 1, 0)
	_G["CurrentQuestsText"].SetTextColor = MER.dummy
	_G["AvailableQuestsText"]:SetTextColor(1, 1, 0)
	_G["AvailableQuestsText"].SetTextColor = MER.dummy
	for i = 1, MAX_NUM_QUESTS do
		local button = _G["QuestTitleButton"..i]
		if button then
			hooksecurefunc(button, "SetFormattedText", function()
				if button:GetFontString() then
					if button:GetFontString():GetText() and button:GetFontString():GetText():find("|cff000000") then
						button:GetFontString():SetText(gsub(button:GetFontString():GetText(), "|cff000000", "|cffFFFF00"))
					end
				end
			end)
		end
	end

	hooksecurefunc(QuestInfoRequiredMoneyText, "SetTextColor", function(self, red, green, blue)
		if red == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif red == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	-- Quest Skin
	_G["QuestInfoItemHighlight"]:StripTextures()
	_G["QuestFrame"]:SetHeight(500)
	_G["QuestFrame"]:Styling()

	_G["QuestInfoRewardsFrame"].SkillPointFrame.Icon:SetSize(_G["QuestInfoRewardsFrame"].SkillPointFrame.Icon:GetSize() - 4, _G["QuestInfoRewardsFrame"].SkillPointFrame.Icon:GetSize() - 4)

	_G["GreetingText"]:SetTextColor(1, 1, 1)
	_G["GreetingText"].SetTextColor = MER.dummy
	_G["CurrentQuestsText"]:SetTextColor(1, 1, 0)
	_G["CurrentQuestsText"].SetTextColor = MER.dummy
	_G["AvailableQuestsText"]:SetTextColor(1, 1, 0)
	_G["AvailableQuestsText"].SetTextColor = MER.dummy

	local function colorObjectivesText()
		if not QuestInfoFrame.questLog then return end

		local objectivesTable = QuestInfoObjectivesFrame.Objectives
		local numVisibleObjectives = 0

		for i = 1, GetNumQuestLeaderBoards() do
			local _, objectiveType, isCompleted = GetQuestLogLeaderBoard(i)

			if (objectiveType ~= "spell" and objectiveType ~= "log" and numVisibleObjectives < MAX_OBJECTIVES) then
				numVisibleObjectives = numVisibleObjectives + 1
				local objective = objectivesTable[numVisibleObjectives]

				if isCompleted then
					objective:SetTextColor(.9, .9, .9)
				else
					objective:SetTextColor(1, 1, 1)
				end
			end
		end
	end

	local SkinQuestText do
		local function SetTextColor(self, red, green, blue)
			if self.settingFont then return end
			self.settingFont = true
			self:SetTextColor(1, 1, 1)
			self.settingFont = nil
		end

		function SkinQuestText(font, hasShadow)
			if hasShadow then
				font:SetShadowColor(0.3, 0.3, 0.3)
			end
			font:SetTextColor(1, 1, 1)
			hooksecurefunc(font, "SetTextColor", SetTextColor)
		end
	end

	hooksecurefunc("QuestMapFrame_ShowQuestDetails", colorObjectivesText)
	hooksecurefunc("QuestInfo_Display", function(template, parentFrame, acceptButton, material, mapView)
		local rewardsFrame = _G["QuestInfoFrame"].rewardsFrame
		local isQuestLog = _G["QuestInfoFrame"].questLog ~= nil
		local isMapQuest = rewardsFrame == _G["MapQuestInfoRewardsFrame"]

		colorObjectivesText()

		if ( template.canHaveSealMaterial ) then
			local questFrame = parentFrame:GetParent():GetParent()
			questFrame.SealMaterialBG:Hide()
		end

		local numSpellRewards = isQuestLog and GetNumQuestLogRewardSpells() or GetNumRewardSpells()
		if numSpellRewards > 0 then
			-- Spell Headers
			for spellHeader in rewardsFrame.spellHeaderPool:EnumerateActive() do
				spellHeader:SetVertexColor(1, 1, 1)
			end

			-- Follower Rewards
			for followerReward in rewardsFrame.followerRewardPool:EnumerateActive() do
				if not followerReward.isSkinned then
					followerReward.PortraitFrame:SetScale(1)
					followerReward.PortraitFrame:ClearAllPoints()
					followerReward.PortraitFrame:SetPoint("TOPLEFT")
					if isMapQuest then
						followerReward.PortraitFrame.Portrait:SetSize(29, 29)
					end
					S:HandleGarrisonPortrait(followerReward.PortraitFrame)

					followerReward.BG:Hide()
					followerReward.BG:SetPoint("TOPLEFT", followerReward.PortraitFrame, "TOPRIGHT")
					followerReward.BG:SetPoint("BOTTOMRIGHT")
					MERS:CreateBD(followerReward, .25)
					followerReward:SetHeight(followerReward.PortraitFrame:GetHeight())

					if not isMapQuest then
						followerReward.Class:SetWidth(45)
					end

					followerReward.isSkinned = true
				end
				followerReward.PortraitFrame:SetBackdropBorderColor(followerReward.PortraitFrame.PortraitRingQuality:GetVertexColor())
			end

			-- Spell Rewards
			for spellReward in rewardsFrame.spellRewardPool:EnumerateActive() do
				if not spellReward.isSkinned then
					if isMapQuest then
						MERS:SmallItemButtonTemplate(spellReward)
					else
						MERS:LargeItemButtonTemplate(spellReward)
						select(3, spellReward:GetRegions()):Hide() --border
						spellReward.Icon:SetPoint("TOPLEFT", 0, 0)
						spellReward:SetHitRectInsets(0, 0, 0, 0)
						spellReward:SetSize(147, 41)
					end
					spellReward.isSkinned = true
				end
			end
		end
	end)
	if _G["QuestInfoSkillPointFrame"].backdrop then
		_G["QuestInfoSkillPointFrame"].backdrop:Hide()
	end
	MERS:CreateBD(_G["QuestInfoSkillPointFrame"], .25)

	hooksecurefunc("QuestFrameProgressItems_Update", function()
		_G["QuestProgressTitleText"]:SetTextColor(1, 1, 0)
		_G["QuestProgressText"]:SetTextColor(1, 1, 1)
		_G["QuestProgressRequiredItemsText"]:SetTextColor(1, 1, 0)
		_G["QuestProgressRequiredMoneyText"]:SetTextColor(1, 1, 0)
	end)

	hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, index)
		local button = rewardsFrame.RewardButtons[index]

		if not button.restyled then
			if rewardsFrame == _G["MapQuestInfoRewardsFrame"] then
				MERS:SmallItemButtonTemplate(button)
			else
				MERS:LargeItemButtonTemplate(button)
			end
			button.restyled = true
		end
	end)

	SkinQuestText(QuestInfoSpellObjectiveLearnLabel)
	-- QuestInfoRewardsFrame
	local QuestInfoRewardsFrame = _G.QuestInfoRewardsFrame
	SkinQuestText(QuestInfoRewardsFrame.Header, true)
	SkinQuestText(QuestInfoRewardsFrame.ItemChooseText)
	SkinQuestText(QuestInfoRewardsFrame.ItemReceiveText)
	SkinQuestText(QuestInfoRewardsFrame.PlayerTitleText)

	for i, name in next, {"HonorFrame", "MoneyFrame", "SkillPointFrame", "XPFrame", "ArtifactXPFrame", "TitleFrame"} do
		MERS:SmallItemButtonTemplate(_G["MapQuestInfoRewardsFrame"][name])
	end
	SkinQuestText(QuestInfoRewardsFrame.XPFrame.ReceiveText)

	_G["MapQuestInfoRewardsFrame"].XPFrame.Name:SetShadowOffset(0, 0)

	SkinQuestText(QuestInfoTitleHeader, true)
	SkinQuestText(QuestInfoObjectivesText)
	SkinQuestText(QuestInfoRewardText)
	SkinQuestText(QuestInfoGroupSize)
	SkinQuestText(QuestInfoDescriptionHeader, true)
	SkinQuestText(QuestInfoObjectivesHeader, true)
	SkinQuestText(QuestInfoDescriptionText)

	local QuestMapFrame = _G["QuestMapFrame"]
	local QuestScrollFrame = _G["QuestScrollFrame"]
	local StoryHeader = QuestScrollFrame.Contents.StoryHeader

	QuestMapFrame.VerticalSeparator:Hide()
	QuestScrollFrame.Background:Hide()

	MERS:CreateBD(QuestScrollFrame.StoryTooltip)

	StoryHeader.Background:Hide()
	StoryHeader.Shadow:Hide()

	local bg = MERS:CreateBDFrame(StoryHeader, .25)
	bg:SetPoint("TOPLEFT", 0, -1)
	bg:SetPoint("BOTTOMRIGHT", -4, 0)

	local hl = StoryHeader.HighlightTexture

	hl:SetTexture(E["media"].muiGradient)
	hl:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .2)
	hl:SetPoint("TOPLEFT", 1, -2)
	hl:SetPoint("BOTTOMRIGHT", -5, 1)
	hl:SetDrawLayer("BACKGROUND")
	hl:Hide()

	StoryHeader:HookScript("OnEnter", function()
		hl:Show()
	end)

	StoryHeader:HookScript("OnLeave", function()
		hl:Hide()
	end)

	--NPC Model Frame
	local QuestNPCModel = _G["QuestNPCModel"]

	local modelBackground = CreateFrame("Frame", nil, QuestNPCModel)
	modelBackground:SetPoint("TOPLEFT", -1, 1)
	modelBackground:SetPoint("BOTTOMRIGHT", 1, -2)
	modelBackground:SetFrameLevel(0)

	_G["QuestNPCModelBg"]:Hide()
	_G["QuestNPCModelTopBg"]:Hide()
	_G["QuestNPCModelShadowOverlay"]:Hide()

	_G["QuestNPCModel"].BorderBottomLeft:Hide()
	_G["QuestNPCModel"].BorderBottomRight:Hide()
	_G["QuestNPCModel"].BorderTop:Hide()
	_G["QuestNPCModel"].BorderBottom:Hide()
	_G["QuestNPCModel"].BorderLeft:Hide()
	_G["QuestNPCModel"].BorderRight:Hide()

	_G["QuestNPCCornerTopLeft"]:Hide()
	_G["QuestNPCCornerTopRight"]:Hide()
	_G["QuestNPCCornerBottomLeft"]:Hide()
	_G["QuestNPCCornerBottomRight"]:Hide()

	_G["QuestNPCModelNameplate"]:SetAlpha(0)

	_G["QuestNPCModelNameText"]:SetPoint("TOPLEFT", modelBackground, "BOTTOMLEFT")
	_G["QuestNPCModelNameText"]:SetPoint("BOTTOMRIGHT", _G["QuestNPCModelTextFrame"], "TOPRIGHT")

	_G["QuestNPCModelNameTooltipFrame"]:SetPoint("TOPLEFT", _G["QuestNPCModelNameText"], 0, 1)
	_G["QuestNPCModelNameTooltipFrame"]:SetPoint("BOTTOMRIGHT", _G["QuestNPCModelNameText"], 0, -1)
	_G["QuestNPCModelNameTooltipFrame"]:SetFrameLevel(0)

	local QuestNPCModelTextFrame = _G["QuestNPCModelTextFrame"]
	if QuestNPCModelTextFrame.backdrop then
		QuestNPCModelTextFrame.backdrop:Hide()
		MERS:CreateBD(QuestNPCModelTextFrame, .25)
	end
	_G["QuestNPCModelTextFrame"]:SetPoint("TOPLEFT", _G["QuestNPCModelNameplate"], "BOTTOMLEFT", -1, 12)
	_G["QuestNPCModelTextFrame"]:SetWidth(200)
	_G["QuestNPCModelTextFrameBg"]:Hide()

	QuestNPCModelTextFrame.BorderBottomLeft:Hide()
	QuestNPCModelTextFrame.BorderBottomRight:Hide()
	QuestNPCModelTextFrame.BorderBottom:Hide()
	QuestNPCModelTextFrame.BorderLeft:Hide()
	QuestNPCModelTextFrame.BorderRight:Hide()

	-- QuestInfoSealFrame
	QuestInfoSealFrame.Text:SetShadowColor(0.2, 0.2, 0.2)
	QuestInfoSealFrame.Text:SetShadowOffset(0.6, -0.6)
end

S:AddCallback("mUIQuestFrame", styleQuestFrame)