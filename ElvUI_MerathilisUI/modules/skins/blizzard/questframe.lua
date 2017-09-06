local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G

-- WoW API / Variables
local CreateFrame = CreateFrame
local GetActiveTitle = GetActiveTitle
local GetAvailableQuestInfo = GetAvailableQuestInfo
local GetAvailableTitle = GetAvailableTitle
local GetNumActiveQuests = GetNumActiveQuests
local GetNumAvailableQuests = GetNumAvailableQuests
local IsActiveQuestTrivial = IsActiveQuestTrivial

-- GLOBALS: hooksecurefunc, MAX_REQUIRED_ITEMS, MER_TRIVIAL_QUEST_DISPLAY, MER_NORMAL_QUEST_DISPLAY

local function styleQuestFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true or E.private.muiSkins.blizzard.quest ~= true then return; end

	-- ParchmentRemover
	QuestScrollFrame:HookScript("OnUpdate", function(self)
		if self.spellTex and self.spellTex2 then
			self.spellTex:SetTexture("")
			self.spellTex:SetTexture("")
		end
	end)
	QuestDetailScrollFrame:StripTextures(true)
	QuestDetailScrollFrame:HookScript("OnUpdate", function(self)
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

	local DetailsFrame = QuestMapFrame.DetailsFrame
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
	select(18, QuestLogPopupDetailFrame:GetRegions()):Hide()

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

	QuestMapFrame.DetailsFrame:StripTextures()

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

	if QuestGreetingScrollFrame.spellTex then
		QuestGreetingScrollFrame.spellTex:SetTexture("")
	end

	hooksecurefunc("QuestInfoItem_OnClick", function(self)
		QuestInfoItemHighlight:SetOutside(self.Icon)

		self.Name:SetTextColor(1, 1, 0)
		local parent = self:GetParent()
		for i = 1, #parent.RewardButtons do
			local questItem = QuestInfoRewardsFrame.RewardButtons[i]
			if(questItem ~= self) then
				questItem.Name:SetTextColor(1, 1, 1)
			end
		end
	end)

	hooksecurefunc("QuestFrameProgressItems_Update", function()
		QuestProgressTitleText:SetTextColor(1, 1, 0)
		QuestProgressText:SetTextColor(1, 1, 1)
		QuestProgressRequiredItemsText:SetTextColor(1, 1, 0)
		QuestProgressRequiredMoneyText:SetTextColor(1, 1, 0)
	end)

	QuestFrameGreetingPanel:StripTextures()
	QuestGreetingScrollFrame:StripTextures()
	QuestGreetingFrameHorizontalBreak:Kill()
	GreetingText:SetTextColor(1, 1, 1)
	GreetingText.SetTextColor = MER.dummy
	CurrentQuestsText:SetTextColor(1, 1, 0)
	CurrentQuestsText.SetTextColor = MER.dummy
	AvailableQuestsText:SetTextColor(1, 1, 0)
	AvailableQuestsText.SetTextColor = MER.dummy
	for i = 1, MAX_NUM_QUESTS do
		local button = _G["QuestTitleButton"..i]
		if button then
			hooksecurefunc(button, "SetFormattedText", function()
				if button:GetFontString() then
					if button:GetFontString():GetText() and button:GetFontString():GetText():find("|cff000000") then
						button:GetFontString():SetText(string.gsub(button:GetFontString():GetText(), "|cff000000", "|cffFFFF00"))
					end
				end
			end)
		end
	end

	hooksecurefunc("QuestInfo_ShowRequiredMoney", function()
		local requiredMoney = GetQuestLogRequiredMoney()
		if requiredMoney > 0 then
			if requiredMoney > GetMoney() then
				QuestInfoRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
			else
				QuestInfoRequiredMoneyText:SetTextColor(1, 1, 0)
			end
		end
	end)

	-- Quest Skin
	QuestInfoItemHighlight:StripTextures()
	QuestFrame:SetHeight(500)

	QuestInfoRewardsFrame.SkillPointFrame.Icon:SetSize(QuestInfoRewardsFrame.SkillPointFrame.Icon:GetSize() - 4, QuestInfoRewardsFrame.SkillPointFrame.Icon:GetSize() - 4)

	GreetingText:SetTextColor(1, 1, 1)
	GreetingText.SetTextColor = MER.dummy
	CurrentQuestsText:SetTextColor(1, 1, 0)
	CurrentQuestsText.SetTextColor = MER.dummy
	AvailableQuestsText:SetTextColor(1, 1, 0)
	AvailableQuestsText.SetTextColor = MER.dummy

	hooksecurefunc("QuestInfo_Display", function(template, parentFrame, acceptButton, material)
		local rewardsFrame = QuestInfoFrame.rewardsFrame
		local isQuestLog = QuestInfoFrame.questLog ~= nil
		local isMapQuest = rewardsFrame == MapQuestInfoRewardsFrame

		QuestInfoTitleHeader:SetTextColor(1, 1, 0)
		QuestInfoDescriptionHeader:SetTextColor(1, 1, 0)
		QuestInfoObjectivesHeader:SetTextColor(1, 1, 0)
		QuestInfoRewardsFrame.Header:SetTextColor(1, 1, 0)
		QuestInfoDescriptionText:SetTextColor(1, 1, 1)
		QuestInfoObjectivesText:SetTextColor(1, 1, 1)
		QuestInfoGroupSize:SetTextColor(1, 1, 1)
		QuestInfoRewardText:SetTextColor(1, 1, 1)
		QuestInfoRewardsFrame.ItemChooseText:SetTextColor(1, 1, 1);
		QuestInfoRewardsFrame.ItemReceiveText:SetTextColor(1, 1, 1);

		QuestInfoQuestType:SetTextColor(1, 1, 1)

		if QuestInfoRewardsFrame.SpellLearnText then
			QuestInfoRewardsFrame.SpellLearnText:SetTextColor(1, 1, 1);
		end

		QuestInfoRewardsFrame.spellHeaderPool.textR, QuestInfoRewardsFrame.spellHeaderPool.textG, QuestInfoRewardsFrame.spellHeaderPool.textB = 1, 1, 1

		QuestInfoRewardsFrame.PlayerTitleText:SetTextColor(1, 1, 1);
		QuestInfoRewardsFrame.XPFrame.ReceiveText:SetTextColor(1, 1, 1);
		local numObjectives = GetNumQuestLeaderBoards()
		local numVisibleObjectives = 0
		for i = 1, numObjectives do
			local _, type, finished = GetQuestLogLeaderBoard(i)
			if type ~= "spell" then
				numVisibleObjectives = numVisibleObjectives + 1
				local objective = _G["QuestInfoObjective"..numVisibleObjectives]
				if objective then
					if finished then
						objective:SetTextColor(1, 1, 0)
					else
						objective:SetTextColor(0.6, 0.6, 0.6)
					end
				end
			end
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
	end)

	hooksecurefunc("QuestInfo_ShowRequiredMoney", function()
		local requiredMoney = GetQuestLogRequiredMoney()
		if requiredMoney > 0 then
			if requiredMoney > GetMoney() then
				QuestInfoRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
			else
				QuestInfoRequiredMoneyText:SetTextColor(1, 1, 0)
			end
		end
	end)

	hooksecurefunc("QuestFrameProgressItems_Update", function()
		QuestProgressTitleText:SetTextColor(1, 1, 0)
		QuestProgressText:SetTextColor(1, 1, 1)
		QuestProgressRequiredItemsText:SetTextColor(1, 1, 0)
		QuestProgressRequiredMoneyText:SetTextColor(1, 1, 0)
	end)

	hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, index)
		local button = rewardsFrame.RewardButtons[index]

		if not button.restyled then
			if rewardsFrame == MapQuestInfoRewardsFrame then
				MERS:SmallItemButtonTemplate(button)
			else
				MERS:LargeItemButtonTemplate(button)
			end
			button.restyled = true
		end
	end)

	for i, name in next, {"HonorFrame", "MoneyFrame", "SkillPointFrame", "XPFrame", "ArtifactXPFrame", "TitleFrame"} do
		MERS:SmallItemButtonTemplate(MapQuestInfoRewardsFrame[name])
	end
	MapQuestInfoRewardsFrame.XPFrame.Name:SetShadowOffset(0, 0)

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
end

S:AddCallback("mUIQuestFrame", styleQuestFrame)