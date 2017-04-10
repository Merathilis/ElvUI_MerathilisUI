local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI");
local S = E:GetModule("Skins");

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, select = pairs, select
local gsub = string.gsub
-- WoW API / Variables
local GetNumQuestLeaderBoards = GetNumQuestLeaderBoards
local GetMoney = GetMoney
local GetQuestLogLeaderBoard = GetQuestLogLeaderBoard
local GetQuestLogRequiredMoney = GetQuestLogRequiredMoney
-- GLOBALS: hooksecurefunc, MAX_NUM_QUESTS, SetMoneyFrameColor

local function StyleScrollFrame(scrollFrame, widthOverride, heightOverride, inset)
	scrollFrame:SetTemplate()
	if inset then
		scrollFrame.spellTex:Point("TOPLEFT", 2, -2)
	else
		scrollFrame.spellTex:Point("TOPLEFT")
	end
	scrollFrame.spellTex:Size(widthOverride or 506, heightOverride or 615)
	scrollFrame.spellTex:SetTexCoord(0, 1, 0.02, 1)
end

local function styleQuest()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true or E.private.muiSkins.blizzard.quest ~= true then return; end

	_G["QuestScrollFrame"]:HookScript("OnUpdate", function(self)
		if self.spellTex and self.spellTex2 then
			self.spellTex:SetTexture("")
			self.spellTex:SetTexture("")
		end
	end)
	_G["QuestScrollFrame"]:HookScript("OnShow", function(self)
		self.Contents.StoryHeader:StripTextures()
		self.Contents.StoryHeader:SetTemplate("Transparent")
		self.Contents.StoryHeader.AchIcon:ClearAllPoints()
		self.Contents.StoryHeader.AchIcon:Point("LEFT", self.Contents.StoryHeader.Progress, "RIGHT", 0, 10)
		self.Contents.StoryHeader.AchIcon:SetTexture([[Interface\ACHIEVEMENTFRAME\UI-Achievement-Shield]])
		self.Contents.StoryHeader.AchIcon:SetSize(80, 80)
	end)
	_G["QuestDetailScrollFrame"]:HookScript("OnUpdate", function(self)
		self:SetTemplate("Transparent")
		self.spellTex:SetTexture("")
	end)
	_G["QuestRewardScrollFrame"]:HookScript("OnShow", function(self)
		self:SetTemplate("Transparent")
		self.spellTex:SetTexture("")
		StyleScrollFrame(self, 509, 630, false)
		self:Height(self:GetHeight() - 2)
	end)
	_G["QuestLogPopupDetailFrameScrollFrame"]:HookScript("OnUpdate", function(self)
		self:SetTemplate("Transparent")
		self.spellTex:SetTexture("")
	end)

	_G["QuestGreetingScrollFrame"]:StripTextures(true)
	_G["QuestFrameInset"]:StripTextures(true)
	_G["GreetingText"]:SetTextColor(1, 1, 1)
	_G["GreetingText"].SetTextColor = MER.dummy

	_G["AvailableQuestsText"]:SetTextColor(1, 1, 1)
	_G["AvailableQuestsText"].SetTextColor = MER.dummy
	_G["AvailableQuestsText"]:SetShadowColor(0, 0, 0)

	_G["CurrentQuestsText"]:SetTextColor(1, 1, 1)
	_G["CurrentQuestsText"].SetTextColor = MER.dummy
	_G["CurrentQuestsText"]:SetShadowColor(0, 0, 0)

	-- Taken from Aurora
	-- Quest details
	local DetailsFrame = _G["QuestMapFrame"].DetailsFrame
	local RewardsFrame = DetailsFrame.RewardsFrame

	DetailsFrame:GetRegions():Hide()
	select(2, DetailsFrame:GetRegions()):Hide()
	select(4, DetailsFrame:GetRegions()):Hide()
	select(6, DetailsFrame.ShareButton:GetRegions()):Hide()
	select(7, DetailsFrame.ShareButton:GetRegions()):Hide()
	S:HandleScrollBar(_G["QuestMapDetailsScrollFrameScrollBar"])

	DetailsFrame.AbandonButton:ClearAllPoints()
	DetailsFrame.AbandonButton:SetPoint("BOTTOMLEFT", DetailsFrame, -1, 0)
	DetailsFrame.AbandonButton:SetWidth(95)

	DetailsFrame.ShareButton:ClearAllPoints()
	DetailsFrame.ShareButton:SetPoint("LEFT", DetailsFrame.AbandonButton, "RIGHT", 1, 0)
	DetailsFrame.ShareButton:SetWidth(94)

	DetailsFrame.TrackButton:ClearAllPoints()
	DetailsFrame.TrackButton:SetPoint("LEFT", DetailsFrame.ShareButton, "RIGHT", 1, 0)
	DetailsFrame.TrackButton:SetWidth(96)

	-- Rewards frame
	RewardsFrame.Background:Hide()
	select(2, RewardsFrame:GetRegions()):Hide()

	if _G["QuestProgressScrollFrame"].spellTex then
		_G["QuestProgressScrollFrame"].spellTex:SetTexture("")
	end

	hooksecurefunc("QuestInfoItem_OnClick", function(self)
		_G["QuestInfoItemHighlight"]:ClearAllPoints()
		_G["QuestInfoItemHighlight"]:SetOutside(self.Icon)

		self.Name:SetTextColor(1, 1, 0)
		local parent = self:GetParent()
		for i=1, #parent.RewardButtons do
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

	if (_G["QuestInfoRewardsFrame"].spellHeaderPool) then
		for _, pool in pairs({"followerRewardPool", "spellRewardPool"}) do
			_G["QuestInfoRewardsFrame"][pool]._acquire = _G["QuestInfoRewardsFrame"][pool].Acquire;
			_G["QuestInfoRewardsFrame"][pool].Acquire = function()
				local frame = _G["QuestInfoRewardsFrame"][pool]:_acquire();
				frame.Name:SetTextColor(1, 1, 1);
				return frame;
			end
		end
		_G["QuestInfoRewardsFrame"].spellHeaderPool._acquire = _G["QuestInfoRewardsFrame"].spellHeaderPool.Acquire;
		_G["QuestInfoRewardsFrame"].spellHeaderPool.Acquire = function(self)
			local frame = self:_acquire();
			frame:SetTextColor(1, 1, 1);
			return frame;
		end
	end

	hooksecurefunc("QuestInfo_Display", function()
		_G["QuestInfoTitleHeader"]:SetTextColor(1, 1, 0)
		_G["QuestInfoDescriptionHeader"]:SetTextColor(1, 1, 0)
		_G["QuestInfoObjectivesHeader"]:SetTextColor(1, 1, 0)
		_G["QuestInfoRewardsFrame"].Header:SetTextColor(1, 1, 0)
		_G["QuestInfoRequiredMoneyText"]:SetTextColor(1, 1, 1)
		_G["QuestInfoDescriptionText"]:SetTextColor(1, 1, 1)
		_G["QuestInfoObjectivesText"]:SetTextColor(1, 1, 1)
		_G["QuestInfoGroupSize"]:SetTextColor(1, 1, 1)
		_G["QuestInfoRewardText"]:SetTextColor(1, 1, 1)
		_G["QuestInfoRewardsFrame"].ItemChooseText:SetTextColor(1, 1, 1);
		_G["QuestInfoRewardsFrame"].ItemReceiveText:SetTextColor(1, 1, 1);
		if (_G["QuestInfoRewardsFrame"].SpellLearnText) then
			_G["QuestInfoRewardsFrame"].SpellLearnText:SetTextColor(1, 1, 1);
		end
		_G["QuestInfoRewardsFrame"].PlayerTitleText:SetTextColor(1, 1, 1);
		_G["QuestInfoRewardsFrame"].XPFrame.ReceiveText:SetTextColor(1, 1, 1);
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
	end)

	hooksecurefunc("QuestInfo_ShowRequiredMoney", function()
		local requiredMoney = GetQuestLogRequiredMoney()
		if requiredMoney > 0 then
			if requiredMoney > GetMoney() then
				_G["QuestInfoRequiredMoneyText"]:SetTextColor(0, 0, 0);
				SetMoneyFrameColor("QuestInfoRequiredMoneyDisplay", "red");
			else
				_G["QuestInfoRequiredMoneyText"]:SetTextColor(0.2, 0.2, 0.2);
				SetMoneyFrameColor("QuestInfoRequiredMoneyDisplay", "white");
			end
		end
	end)
end

S:AddCallback("mUIQuest", styleQuest)