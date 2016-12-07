local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
-- Lua functions
-- WoW API / Variables
-- GLOBALS: hooksecurefunc

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

	QuestScrollFrame:HookScript('OnUpdate', function(self)
		if self.spellTex and self.spellTex2 then
			self.spellTex:SetTexture("")
			self.spellTex:SetTexture("")
		end
	end)
	QuestScrollFrame:HookScript('OnShow', function(self)
		self.Contents.StoryHeader:StripTextures()
		self.Contents.StoryHeader:SetTemplate('Transparent')
		self.Contents.StoryHeader.AchIcon:ClearAllPoints()
		self.Contents.StoryHeader.AchIcon:Point("LEFT", self.Contents.StoryHeader.Progress, "RIGHT", 0, 10)
		self.Contents.StoryHeader.AchIcon:SetTexture([[Interface\ACHIEVEMENTFRAME\UI-Achievement-Shield]])
		self.Contents.StoryHeader.AchIcon:SetSize(80, 80)
	end)
	QuestDetailScrollFrame:HookScript('OnUpdate', function(self)
		self:SetTemplate("Transparent")
		self.spellTex:SetTexture("")
	end)
	QuestRewardScrollFrame:HookScript('OnShow', function(self)
		self:SetTemplate("Transparent")
		self.spellTex:SetTexture("")
		StyleScrollFrame(self, 509, 630, false)
		self:Height(self:GetHeight() - 2)
	end)
	QuestLogPopupDetailFrameScrollFrame:HookScript('OnUpdate', function(self)
		self:SetTemplate("Transparent")
		self.spellTex:SetTexture("")
	end)

	QuestGreetingScrollFrame:StripTextures(true)
	QuestFrameInset:StripTextures(true)
	GreetingText:SetTextColor(1, 1, 1)
	GreetingText.SetTextColor = MER.dummy

	AvailableQuestsText:SetTextColor(1, 1, 1)
	AvailableQuestsText.SetTextColor = MER.dummy
	AvailableQuestsText:SetShadowColor(0, 0, 0)

	CurrentQuestsText:SetTextColor(1, 1, 1)
	CurrentQuestsText.SetTextColor = MER.dummy
	CurrentQuestsText:SetShadowColor(0, 0, 0)

	QuestMapFrame.DetailsFrame:StripTextures(true)

	if QuestProgressScrollFrame.spellTex then
		QuestProgressScrollFrame.spellTex:SetTexture("")
	end

	hooksecurefunc('QuestInfoItem_OnClick', function(self)
		QuestInfoItemHighlight:ClearAllPoints()
		QuestInfoItemHighlight:SetOutside(self.Icon)

		self.Name:SetTextColor(1, 1, 0)
		local parent = self:GetParent()
		for i=1, #parent.RewardButtons do
			local questItem = QuestInfoRewardsFrame.RewardButtons[i]
			if(questItem ~= self) then
				questItem.Name:SetTextColor(1, 1, 1)
			end
		end
	end)

	hooksecurefunc('QuestFrameProgressItems_Update', function()
		QuestProgressTitleText:SetTextColor(1, 1, 0)
		QuestProgressText:SetTextColor(1, 1, 1)
		QuestProgressRequiredItemsText:SetTextColor(1, 1, 0)
		QuestProgressRequiredMoneyText:SetTextColor(1, 1, 0)
	end)

	for i = 1, MAX_NUM_QUESTS do
		local button = _G['QuestTitleButton'..i]
		if button then
			hooksecurefunc(button, 'SetFormattedText', function()
				if button:GetFontString() then
					if button:GetFontString():GetText() and button:GetFontString():GetText():find('|cff000000') then
						button:GetFontString():SetText(string.gsub(button:GetFontString():GetText(), '|cff000000', '|cffFFFF00'))
					end
				end
			end)
		end
	end

	if (QuestInfoRewardsFrame.spellHeaderPool) then
		for _, pool in pairs({"followerRewardPool", "spellRewardPool"}) do
			QuestInfoRewardsFrame[pool]._acquire = QuestInfoRewardsFrame[pool].Acquire;
			QuestInfoRewardsFrame[pool].Acquire = function()
				local frame = QuestInfoRewardsFrame[pool]:_acquire();
				frame.Name:SetTextColor(1, 1, 1);
				return frame;
			end
		end
		QuestInfoRewardsFrame.spellHeaderPool._acquire = QuestInfoRewardsFrame.spellHeaderPool.Acquire;
		QuestInfoRewardsFrame.spellHeaderPool.Acquire = function(self)
			local frame = self:_acquire();
			frame:SetTextColor(1, 1, 1);
			return frame;
		end
	end

	hooksecurefunc('QuestInfo_Display', function()
		QuestInfoTitleHeader:SetTextColor(1, 1, 0)
		QuestInfoDescriptionHeader:SetTextColor(1, 1, 0)
		QuestInfoObjectivesHeader:SetTextColor(1, 1, 0)
		QuestInfoRewardsFrame.Header:SetTextColor(1, 1, 0)
		QuestInfoRequiredMoneyText:SetTextColor(1, 1, 1)
		QuestInfoDescriptionText:SetTextColor(1, 1, 1)
		QuestInfoObjectivesText:SetTextColor(1, 1, 1)
		QuestInfoGroupSize:SetTextColor(1, 1, 1)
		QuestInfoRewardText:SetTextColor(1, 1, 1)
		QuestInfoRewardsFrame.ItemChooseText:SetTextColor(1, 1, 1);
		QuestInfoRewardsFrame.ItemReceiveText:SetTextColor(1, 1, 1);
		if (QuestInfoRewardsFrame.SpellLearnText) then
			QuestInfoRewardsFrame.SpellLearnText:SetTextColor(1, 1, 1);
		end
		QuestInfoRewardsFrame.PlayerTitleText:SetTextColor(1, 1, 1);
		QuestInfoRewardsFrame.XPFrame.ReceiveText:SetTextColor(1, 1, 1);
		local numObjectives = GetNumQuestLeaderBoards()
		local numVisibleObjectives = 0
		for i = 1, numObjectives do
			local _, type, finished = GetQuestLogLeaderBoard(i)
			if type ~= 'spell' then
				numVisibleObjectives = numVisibleObjectives + 1
				local objective = _G['QuestInfoObjective'..numVisibleObjectives]
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

	hooksecurefunc('QuestInfo_ShowRequiredMoney', function()
		local requiredMoney = GetQuestLogRequiredMoney()
		if requiredMoney > 0 then
			if requiredMoney > GetMoney() then
				QuestInfoRequiredMoneyText:SetTextColor(0, 0, 0);
				SetMoneyFrameColor("QuestInfoRequiredMoneyDisplay", "red");
			else
				QuestInfoRequiredMoneyText:SetTextColor(0.2, 0.2, 0.2);
				SetMoneyFrameColor("QuestInfoRequiredMoneyDisplay", "white");
			end
		end
	end)
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, _, addon)
	if addon == "ElvUI_MerathilisUI" then
		E:Delay(1, styleQuest)
		self:UnregisterEvent("ADDON_LOADED")
	end
end)