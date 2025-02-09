local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")

local _G = _G

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local Menu = _G.Menu

-- Get localised Wowhead URL
local linkQuest, linkAchievement, linkMonthlyActivities
if E.locale == "deDE" then
	linkQuest = "http://de.wowhead.com/quest=%d#english-comments"
	linkAchievement = "http://de.wowhead.com/achievement=%d#english-comments"
	linkMonthlyActivities = "http://de.wowhead.com/trading-post-activity/%d#english-comments"
elseif E.locale == "esMX" then
	linkQuest = "http://es.wowhead.com/quest=%d#english-comments"
	linkAchievement = "http://es.wowhead.com/achievement=%d#english-comments"
	linkMonthlyActivities = "http://es.wowhead.com/trading-post-activity/%d#english-comments"
elseif E.locale == "esES" then
	linkQuest = "http://es.wowhead.com/quest=%d#english-comments"
	linkAchievement = "http://es.wowhead.com/achievement=%d#english-comments"
	linkMonthlyActivities = "http://es.wowhead.com/trading-post-activity/%d#english-comments"
elseif E.locale == "frFR" then
	linkQuest = "http://fr.wowhead.com/quest=%d#english-comments"
	linkAchievement = "http://fr.wowhead.com/achievement=%d#english-comments"
	linkMonthlyActivities = "http://fr.wowhead.com/trading-post-activity/%d#english-comments"
elseif E.locale == "itIT" then
	linkQuest = "http://it.wowhead.com/quest=%d#english-comments"
	linkAchievement = "http://it.wowhead.com/achievement=%d#english-comments"
	linkMonthlyActivities = "http://it.wowhead.com/trading-post-activity/%d#english-comments"
elseif E.locale == "ptBR" then
	linkQuest = "http://pt.wowhead.com/quest=%d#english-comments"
	linkAchievement = "http://pt.wowhead.com/achievement=%d#english-comments"
	linkMonthlyActivities = "http://pt.wowhead.com/trading-post-activity/%d#english-comments"
elseif E.locale == "ruRU" then
	linkQuest = "http://ru.wowhead.com/quest=%d#english-comments"
	linkAchievement = "http://ru.wowhead.com/achievement=%d#english-comments"
	linkMonthlyActivities = "http://ru.wowhead.com/trading-post-activity/%d#english-comments"
elseif E.locale == "koKR" then
	linkQuest = "http://ko.wowhead.com/quest=%d#english-comments"
	linkAchievement = "http://ko.wowhead.com/achievement=%d#english-comments"
	linkMonthlyActivities = "http://ko.wowhead.com/trading-post-activity/%d#english-comments"
elseif E.locale == "zhCN" then
	linkQuest = "http://cn.wowhead.com/quest=%d#english-comments"
	linkAchievement = "http://cn.wowhead.com/achievement=%d#english-comments"
	linkMonthlyActivities = "http://cn.wowhead.com/trading-post-activity/%d#english-comments"
elseif E.locale == "zhTW" then
	linkQuest = "http://cn.wowhead.com/quest=%d#english-comments"
	linkAchievement = "http://cn.wowhead.com/achievement=%d#english-comments"
	linkMonthlyActivities = "http://cn.wowhead.com/trading-post-activity/%d#english-comments"
else
	linkQuest = "http://www.wowhead.com/quest=%d#english-commentss"
	linkAchievement = "http://www.wowhead.com/achievement=%d#english-comments"
	linkMonthlyActivities = "http://wowhead.com/trading-post-activity/%d#english-comments"
end

local selfText
StaticPopupDialogs.WATCHFRAME_URL = {
	text = MER.Title .. F.String.ColorFirstLetter(L["Wowhead Links"]),
	button1 = OKAY,
	timeout = 0,
	whileDead = true,
	hasEditBox = true,
	editBoxWidth = 350,
	OnShow = function(self, text)
		self.editBox:SetMaxLetters(0)
		self.editBox:SetText(text)
		self.editBox:HighlightText()
		selfText = text
	end,
	EditBoxOnEnterPressed = function(self)
		self:GetParent():Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	EditBoxOnTextChanged = function(self)
		if self:GetText():len() < 1 then
			self:GetParent():Hide()
		else
			self:SetText(selfText)
			self:HighlightText()
		end
	end,
	preferredIndex = 5,
}

function module:WowheadLinks()
	if not E.db.mui.misc.wowheadlinks then
		return
	end

	local ID
	local headers = {
		_G.ScenarioObjectiveTracker,
		_G.UIWidgetObjectiveTracker,
		_G.CampaignQuestObjectiveTracker,
		_G.QuestObjectiveTracker,
		_G.AdventureObjectiveTracker,
		_G.AchievementObjectiveTracker,
		_G.MonthlyActivitiesObjectiveTracker,
		_G.ProfessionsRecipeTracker,
		_G.BonusObjectiveTracker,
		_G.WorldQuestObjectiveTracker,
	}

	for i = 1, #headers do
		local tracker = headers[i]
		if tracker then
			hooksecurefunc(tracker, "OnBlockHeaderClick", function(_, block)
				ID = block.id
			end)
		end
	end

	Menu.ModifyMenu("MENU_QUEST_OBJECTIVE_TRACKER", function(_, rootDescription)
		rootDescription:CreateButton(F.String.ColorFirstLetter(L["Wowhead Links"]), function()
			local text = linkQuest:format(ID)
			StaticPopup_Show("WATCHFRAME_URL", _, _, text)
		end)
	end)

	Menu.ModifyMenu("MENU_BONUS_OBJECTIVE_TRACKER", function(_, rootDescription)
		rootDescription:CreateButton(F.String.ColorFirstLetter(L["Wowhead Links"]), function()
			local text = linkQuest:format(ID)
			StaticPopup_Show("WATCHFRAME_URL", _, _, text)
		end)
	end)

	Menu.ModifyMenu("MENU_MONTHLY_ACTVITIES_TRACKER", function(_, rootDescription)
		rootDescription:CreateButton(F.String.ColorFirstLetter(L["Wowhead Links"]), function()
			local text = linkMonthlyActivities:format(ID)
			StaticPopup_Show("WATCHFRAME_URL", _, _, text)
		end)
	end)

	Menu.ModifyMenu("MENU_ACHIEVEMENT_TRACKER", function(_, rootDescription)
		rootDescription:CreateButton(F.String.ColorFirstLetter(L["Wowhead Links"]), function()
			local text = linkAchievement:format(ID)
			StaticPopup_Show("WATCHFRAME_URL", _, _, text)
		end)
	end)

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("ADDON_LOADED")
	frame:SetScript("OnEvent", function(_, _, addon)
		if addon == "Blizzard_AchievementUI" then
			hooksecurefunc(AchievementTemplateMixin, "OnClick", function(self)
				local elementData = self:GetElementData()
				if elementData and elementData.id and IsControlKeyDown() then
					local text = linkAchievement:format(elementData.id)
					StaticPopup_Show("WATCHFRAME_URL", _, _, text)
				end
			end)
		end
	end)
end

module:AddCallback("WowheadLinks")
