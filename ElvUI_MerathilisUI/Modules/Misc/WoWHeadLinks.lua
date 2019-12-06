local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule("mUIMisc")

-- Credits Leatrix Plus

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GetAchievementLink = GetAchievementLink
local GetQuestLink = GetQuestLink
local GetSuperTrackedQuestID = GetSuperTrackedQuestID
local IsAddOnLoaded = IsAddOnLoaded
local QuestMapFrame_GetDetailQuestID = QuestMapFrame_GetDetailQuestID
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

-- Get localised Wowhead URL
local GameLocale = GetLocale()
local wowheadLoc
if GameLocale == "deDE" then wowheadLoc = "de.wowhead.com"
elseif GameLocale == "esMX" then wowheadLoc = "es.wowhead.com"
elseif GameLocale == "esES" then wowheadLoc = "es.wowhead.com"
elseif GameLocale == "frFR" then wowheadLoc = "fr.wowhead.com"
elseif GameLocale == "itIT" then wowheadLoc = "it.wowhead.com"
elseif GameLocale == "ptBR" then wowheadLoc = "pt.wowhead.com"
elseif GameLocale == "ruRU" then wowheadLoc = "ru.wowhead.com"
elseif GameLocale == "koKR" then wowheadLoc = "ko.wowhead.com"
elseif GameLocale == "zhCN" then wowheadLoc = "cn.wowhead.com"
elseif GameLocale == "zhTW" then wowheadLoc = "cn.wowhead.com"
else
	wowheadLoc = "wowhead.com"
end

function MI:WorldMapLinks()
	-- Create editbox
	local EditBox = CreateFrame("EditBox", nil, _G.WorldMapFrame.BorderFrame)
	EditBox:ClearAllPoints()
	EditBox:SetPoint("TOPLEFT", 20, -4)
	EditBox:SetHeight(16)
	EditBox:FontTemplate()
	EditBox:SetTextColor(0, 191/255, 250/255)
	EditBox:SetJustifyH("LEFT")
	EditBox:SetBlinkSpeed(0)
	EditBox:SetAutoFocus(false)
	EditBox:EnableKeyboard(false)
	EditBox:SetHitRectInsets(0, 90, 0, 0)
	EditBox:SetScript("OnKeyDown", function() end)
	EditBox:SetScript("OnMouseUp", function()
		if EditBox:IsMouseOver() then
			EditBox:HighlightText()
		else
			EditBox:HighlightText(0, 0)
		end
	end)

	-- Create hidden font string (used for setting width of editbox)
	EditBox.t = EditBox:CreateFontString(nil, 'ARTWORK')
	EditBox.t:FontTemplate()
	EditBox.t:Hide()

	-- Function to set editbox value
	local function SetQuestInBox()
		local questID
		if _G.QuestMapFrame.DetailsFrame:IsShown() then
			-- Get quest ID from currently showing quest in details panel
			questID = QuestMapFrame_GetDetailQuestID()
		else
			-- Get quest ID from currently selected quest on world map
			questID = GetSuperTrackedQuestID()
		end

		if questID then
			-- Hide editbox if quest ID is invalid
			if questID == 0 then EditBox:Hide() else EditBox:Show() end
			-- Set editbox text
			EditBox:SetText("https://" .. wowheadLoc .. "/quest=" .. questID)
			-- Set hidden fontstring then resize editbox to match
			EditBox.t:SetText(EditBox:GetText())
			EditBox:SetWidth(EditBox.t:GetStringWidth() + 90)

			-- Get quest title for tooltip
			local questLink = GetQuestLink(questID) or nil
			if questLink then
				EditBox.tiptext = questLink:match("%[(.-)%]") .. "|n" .. L["Press CTRL + C to copy."]
			else
				EditBox.tiptext = ""
				if EditBox:IsMouseOver() and GameTooltip:IsShown() then GameTooltip:Hide() end
			end
		end
	end

	-- Set URL when super tracked quest changes and on startup
	EditBox:RegisterEvent("SUPER_TRACKED_QUEST_CHANGED")
	EditBox:SetScript("OnEvent", SetQuestInBox)
	SetQuestInBox()

	-- Set URL when quest details frame is shown or hidden
	hooksecurefunc("QuestMapFrame_ShowQuestDetails", SetQuestInBox)
	hooksecurefunc("QuestMapFrame_CloseQuestDetails", SetQuestInBox)

	-- Create tooltip
	EditBox:HookScript("OnEnter", function()
		EditBox:HighlightText()
		EditBox:SetFocus()
		GameTooltip:SetOwner(EditBox, "ANCHOR_BOTTOM", 0, -10)
		GameTooltip:SetText(EditBox.tiptext, nil, nil, nil, nil, true)
		GameTooltip:Show()
	end)

	EditBox:HookScript("OnLeave", function()
		EditBox:HighlightText(0, 0)
		EditBox:ClearFocus()
		GameTooltip:Hide()
		SetQuestInBox()
	end)
end

function MI:AchievementLinks()
	local function DoWowheadAchievementFunc()
		-- Create editbox
		local EditBox = CreateFrame("EditBox", nil, _G.AchievementFrame)
		EditBox:ClearAllPoints()
		EditBox:SetPoint("BOTTOMRIGHT", -50, 1)
		EditBox:SetHeight(16)
		EditBox:FontTemplate()
		EditBox:SetTextColor(0, 191/255, 250/255)
		EditBox:SetBlinkSpeed(0)
		EditBox:SetJustifyH("RIGHT")
		EditBox:SetAutoFocus(false)
		EditBox:EnableKeyboard(false)
		EditBox:SetHitRectInsets(90, 0, 0, 0)
		EditBox:SetScript("OnKeyDown", function() end)
		EditBox:SetScript("OnMouseUp", function()
			if EditBox:IsMouseOver() then
				EditBox:HighlightText()
			else
				EditBox:HighlightText(0, 0)
			end
		end)

		-- Create hidden font string (used for setting width of editbox)
		EditBox.t = EditBox:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
		EditBox.t:Hide()

		-- Store last link in case editbox is cleared
		local lastAchievementLink

		-- Function to set editbox value
		hooksecurefunc("AchievementFrameAchievements_SelectButton", function(self)
			local achievementID = self.id or nil
			if achievementID then
				-- Set editbox text
				EditBox:SetText("https://" .. wowheadLoc .. "/achievement=" .. achievementID)
				lastAchievementLink = EditBox:GetText()
				-- Set hidden fontstring then resize editbox to match
				EditBox.t:SetText(EditBox:GetText())
				EditBox:SetWidth(EditBox.t:GetStringWidth() + 90)
				-- Get achievement title for tooltip
				local achievementLink = GetAchievementLink(self.id)
				if achievementLink then
					EditBox.tiptext = achievementLink:match("%[(.-)%]") .. "|n" .. L["Press CTRL/C to copy."]
				end
				-- Show the editbox
				EditBox:Show()
			end
		end)

		-- Create tooltip
		EditBox:HookScript("OnEnter", function()
			EditBox:HighlightText()
			EditBox:SetFocus()
			GameTooltip:SetOwner(EditBox, "ANCHOR_TOP", 0, 10)
			GameTooltip:SetText(EditBox.tiptext, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end)

		EditBox:HookScript("OnLeave", function()
			-- Set link text again if it's changed since it was set
			if EditBox:GetText() ~= lastAchievementLink then EditBox:SetText(lastAchievementLink) end
			EditBox:HighlightText(0, 0)
			EditBox:ClearFocus()
			GameTooltip:Hide()
		end)

		-- Hide editbox when achievement is deselected
		hooksecurefunc("AchievementFrameAchievements_ClearSelection", function(self) EditBox:Hide()	end)
		hooksecurefunc("AchievementCategoryButton_OnClick", function(self) EditBox:Hide() end)
	end

	-- Run function when achievement UI is loaded
	if IsAddOnLoaded("Blizzard_AchievementUI") then
		DoWowheadAchievementFunc()
	else
		local waitAchievementsFrame = CreateFrame("FRAME")
		waitAchievementsFrame:RegisterEvent("ADDON_LOADED")
		waitAchievementsFrame:SetScript("OnEvent", function(self, event, arg1)
			if arg1 == "Blizzard_AchievementUI" then
				DoWowheadAchievementFunc()
				waitAchievementsFrame:UnregisterAllEvents()
			end
		end)
	end
end

function MI:WowHeadLinks()
	if E.db.mui.misc.wowheadlinks ~= true then return end

	self:WorldMapLinks()
	self:AchievementLinks()
end
