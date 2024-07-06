local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")

-- Credits Leatrix Plus
local _G = _G

local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GetQuestLink = GetQuestLink
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local QuestMapFrame_GetDetailQuestID = QuestMapFrame_GetDetailQuestID
local hooksecurefunc = hooksecurefunc

-- Get localised Wowhead URL
local wowheadLoc
if E.locale == "deDE" then
	wowheadLoc = "de.wowhead.com"
elseif E.locale == "esMX" then
	wowheadLoc = "es.wowhead.com"
elseif E.locale == "esES" then
	wowheadLoc = "es.wowhead.com"
elseif E.locale == "frFR" then
	wowheadLoc = "fr.wowhead.com"
elseif E.locale == "itIT" then
	wowheadLoc = "it.wowhead.com"
elseif E.locale == "ptBR" then
	wowheadLoc = "pt.wowhead.com"
elseif E.locale == "ruRU" then
	wowheadLoc = "ru.wowhead.com"
elseif E.locale == "koKR" then
	wowheadLoc = "ko.wowhead.com"
elseif E.locale == "zhCN" then
	wowheadLoc = "cn.wowhead.com"
elseif E.locale == "zhTW" then
	wowheadLoc = "cn.wowhead.com"
else
	wowheadLoc = "wowhead.com"
end

-- Function to set editbox value
local function SetQuestInBox()
	local questID
	if _G.QuestMapFrame.DetailsFrame:IsShown() then
		-- Get quest ID from currently showing quest in details panel
		questID = QuestMapFrame_GetDetailQuestID()
	else
		-- Get quest ID from currently selected quest on world map
		questID = C_SuperTrack.GetSuperTrackedQuestID()
	end

	if questID then
		-- Hide editbox if quest ID is invalid
		if questID == 0 then
			_G.MER_EditBox:Hide()
		else
			_G.MER_EditBox:Show()
		end
		-- Set editbox text
		_G.MER_EditBox:SetText("https://" .. wowheadLoc .. "/quest=" .. questID)
		-- Set hidden fontstring then resize editbox to match
		_G.MER_EditBox.t:SetText(_G.MER_EditBox:GetText())
		_G.MER_EditBox:SetWidth(_G.MER_EditBox.t:GetStringWidth() + 90)

		-- Get quest title for tooltip
		local questLink = GetQuestLink(questID) or nil
		if questLink then
			_G.MER_EditBox.tiptext = questLink:match("%[(.-)%]") .. "|n" .. L["Press CTRL + C to copy."]
		else
			_G.MER_EditBox.tiptext = ""
			if _G.MER_EditBox:IsMouseOver() and GameTooltip:IsShown() then
				GameTooltip:Hide()
			end
		end
	end
end

function module:WorldMapLinks()
	-- Create editbox
	local EditBox = CreateFrame("EditBox", "MER_EditBox", _G.WorldMapFrame.BorderFrame, "BackdropTemplate")
	EditBox:ClearAllPoints()
	EditBox:SetPoint("TOP", _G.WorldMapFrameTitleText, "BOTTOM", 50, -3)
	EditBox:SetHeight(16)
	EditBox:FontTemplate()
	EditBox:SetTextColor(0, 191 / 255, 250 / 255)
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
	EditBox.t = EditBox:CreateFontString(nil, "ARTWORK")
	EditBox.t:FontTemplate()
	EditBox.t:Hide()

	-- Set URL when super tracked quest changes and on startup
	EditBox:RegisterEvent("SUPER_TRACKING_CHANGED")
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

function module:AchievemntsLinks()
	local EditBox = CreateFrame("EditBox", nil, _G.AchievementFrame)
	EditBox:ClearAllPoints()
	EditBox:SetPoint("BOTTOMRIGHT", -50, 1)
	EditBox:SetHeight(16)
	EditBox:FontTemplate()
	EditBox:SetTextColor(0, 191 / 255, 250 / 255)
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
	EditBox.z = EditBox:CreateFontString(nil, "ARTWORK")
	EditBox.z:FontTemplate()
	EditBox.z:Hide()

	local lastAchievementLink
	local function SetAchievementFunc(self, achievementID)
		if achievementID then
			EditBox:SetText("https://" .. wowheadLoc .. "/achievement=" .. achievementID)
			lastAchievementLink = EditBox:GetText()

			EditBox.z:SetText(EditBox:GetText())
			EditBox:SetWidth(EditBox.z:GetStringWidth() + 90)

			local achievementLink = GetAchievementLink(achievementID)
			if achievementLink then
				EditBox.tiptext = achievementLink:match("%[(.-)%]") .. "|n" .. L["Press CTRL/C to copy."]
			end
			-- Show the editbox
			EditBox:Show()
		end
	end
	hooksecurefunc(AchievementTemplateMixin, "DisplayObjectives", SetAchievementFunc)
	hooksecurefunc("AchievementFrameComparisonTab_OnClick", function(self)
		EditBox:Hide()
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
		if EditBox:GetText() ~= lastAchievementLink then
			EditBox:SetText(lastAchievementLink)
		end
		EditBox:HighlightText(0, 0)
		EditBox:ClearFocus()
		GameTooltip:Hide()
	end)
end

function module:WowHeadLinks()
	if E.db.mui.misc.wowheadlinks ~= true then
		return
	end

	module:WorldMapLinks()

	-- Run function when achievement UI is loaded
	if IsAddOnLoaded("Blizzard_AchievementUI") then
		module:AchievemntsLinks()
	else
		local waitAchievementsFrame = CreateFrame("FRAME")
		waitAchievementsFrame:RegisterEvent("ADDON_LOADED")
		waitAchievementsFrame:SetScript("OnEvent", function(self, event, arg1)
			if arg1 == "Blizzard_AchievementUI" then
				module:AchievemntsLinks()
				waitAchievementsFrame:UnregisterAllEvents()
			end
		end)
	end
end

module:AddCallback("WowHeadLinks")
