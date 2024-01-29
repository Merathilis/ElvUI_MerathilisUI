local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Misc')

-- Credits Leatrix Plus
local _G = _G

local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GetAchievementLink = GetAchievementLink
local GetQuestLink = GetQuestLink

local QuestMapFrame_GetDetailQuestID = QuestMapFrame_GetDetailQuestID
local hooksecurefunc = hooksecurefunc

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

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
		if questID == 0 then _G.MER_EditBox:Hide() else _G.MER_EditBox:Show() end
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
			if _G.MER_EditBox:IsMouseOver() and GameTooltip:IsShown() then GameTooltip:Hide() end
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
	EditBox.t = EditBox:CreateFontString(nil, 'ARTWORK')
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

function module:WowHeadLinks()
	if E.db.mui.misc.wowheadlinks ~= true then return end

	self:WorldMapLinks()
end

module:AddCallback("WowHeadLinks")
