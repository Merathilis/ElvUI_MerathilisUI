local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G

-- WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleQuestFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true or E.private.muiSkins.blizzard.quest ~= true then return; end

	--[[ FrameXML\QuestFrame.lua ]]
	function MERS.QuestFrameProgressItems_Update()
		local numRequiredItems = GetNumQuestItems()
		local numRequiredCurrencies = GetNumQuestCurrencies()
		local moneyToGet = GetQuestMoneyToGet()
		if numRequiredItems > 0 or moneyToGet > 0 or numRequiredCurrencies > 0 then
			-- If there's money required then anchor and display it
			if moneyToGet > 0 then
				if moneyToGet > GetMoney() then
					-- Not enough money
					QuestProgressRequiredMoneyText:SetTextColor(182/255, 182/255, 182/255)
				else
					QuestProgressRequiredMoneyText:SetTextColor(1, 1, 1)
				end
			end
		end
	end

	function MERS.QuestFrameGreetingPanel_OnShow()
		local numActiveQuests = GetNumActiveQuests()
		if numActiveQuests > 0 then
			for i = 1, numActiveQuests do
				local questTitleButton = _G["QuestTitleButton"..i]
				local title = GetActiveTitle(i)
				if IsActiveQuestTrivial(i) then
					questTitleButton:SetFormattedText(MER_TRIVIAL_QUEST_DISPLAY, title)
				else
					questTitleButton:SetFormattedText(MER_NORMAL_QUEST_DISPLAY, title)
				end
			end

		end

		local numAvailableQuests = GetNumAvailableQuests()
		if numAvailableQuests > 0 then
			if numActiveQuests > 0 then
				QuestGreetingFrameHorizontalBreak:SetPoint("TOPLEFT", "QuestTitleButton"..numActiveQuests, "BOTTOMLEFT",22,-10)
				AvailableQuestsText:SetPoint("TOPLEFT", "QuestGreetingFrameHorizontalBreak", "BOTTOMLEFT", -12, -10)
			end

			for i = numActiveQuests + 1, numActiveQuests + numAvailableQuests do
				local questTitleButton = _G["QuestTitleButton"..i]
				local title = GetAvailableTitle(i - numActiveQuests)
				if GetAvailableQuestInfo(i - numActiveQuests) then
					questTitleButton:SetFormattedText(MER_TRIVIAL_QUEST_DISPLAY, title)
				else
					questTitleButton:SetFormattedText(MER_NORMAL_QUEST_DISPLAY, title)
				end
			end
		end
	end

	function MERS.QuestFrame_UpdatePortraitText(text)
		if text and text ~= "" then
			QuestNPCModelText:SetWidth(191)
			local textHeight = QuestNPCModelText:GetHeight()
			local scrollHeight = QuestNPCModelTextScrollFrame:GetHeight()
			if textHeight > scrollHeight then
				QuestNPCModelTextScrollChildFrame:SetHeight(textHeight + 10)
				QuestNPCModelText:SetWidth(176)
			else
				QuestNPCModelTextScrollChildFrame:SetHeight(textHeight)
			end
		end
	end

	function MERS.QuestFrame_ShowQuestPortrait(parentFrame, portraitDisplayID, mountPortraitDisplayID, text, name, x, y)
		if parentFrame == _G.WorldMapFrame then
			x = x + 2
		else
			x = x + 5
		end

		QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, y)
	end

	-- TEXT COLOR
	function MERS.QuestFrame_SetTitleTextColor(fontString, material)
		fontString:SetTextColor(1, 1, 1)
	end

	function MERS.QuestFrame_SetTextColor(fontString, material)
		fontString:SetTextColor(1, 1, 1)
	end

	--[[ FrameXML\QuestFrameTemplates.xml ]]
	function MERS:QuestFramePanelTemplate(Frame)
		Frame:SetAllPoints()
		local name = Frame:GetName()
		_G[name.."Bg"]:Hide()

		_G[name.."MaterialTopLeft"]:SetAlpha(0)
		_G[name.."MaterialTopRight"]:SetAlpha(0)
		_G[name.."MaterialBotLeft"]:SetAlpha(0)
		_G[name.."MaterialBotRight"]:SetAlpha(0)
	end

	function MERS:QuestItemTemplate(Button)
		MERS:LargeItemButtonTemplate(Button)
	end
	function MERS:QuestSpellTemplate(Button)
	end
	function MERS:QuestTitleButtonTemplate(Button)
	end

	function MERS:QuestScrollFrameTemplate(ScrollFrame)
		--Skin.UIPanelScrollFrameTemplate(ScrollFrame)
		ScrollFrame:SetPoint("TOPLEFT", 5, -(23 + 2))
		ScrollFrame:SetPoint("BOTTOMRIGHT", -23, 32)

		local name = ScrollFrame:GetName()
		_G[name.."Top"]:Hide()
		_G[name.."Bottom"]:Hide()
		_G[name.."Middle"]:Hide()
	end

	-- HOOKS
	hooksecurefunc("QuestFrameProgressItems_Update", MERS.QuestFrameProgressItems_Update)
	hooksecurefunc("QuestFrameGreetingPanel_OnShow", MERS.QuestFrameGreetingPanel_OnShow)
	QuestFrameGreetingPanel:HookScript("OnShow", MERS.QuestFrameGreetingPanel_OnShow)
	hooksecurefunc("QuestFrame_UpdatePortraitText", MERS.QuestFrame_UpdatePortraitText)
	hooksecurefunc("QuestFrame_ShowQuestPortrait", MERS.QuestFrame_ShowQuestPortrait)
	hooksecurefunc("QuestFrame_SetTitleTextColor", MERS.QuestFrame_SetTitleTextColor)
	hooksecurefunc("QuestFrame_SetTextColor", MERS.QuestFrame_SetTextColor)

	----------------
	-- QuestFrame --
	----------------
	QuestFrameNpcNameText:SetAllPoints(QuestFrame.TitleText)

	-- Hide ElvUI Backdrop
	if QuestNPCModelTextFrame.backdrop then
		QuestNPCModelTextFrame.backdrop:Hide()
	end
	MERS:CreateBD(QuestNPCModelTextFrame, .5)
	QuestNPCModelTextFrame:Styling()

	MERS:QuestFramePanelTemplate(QuestFrameRewardPanel)
	MERS:QuestScrollFrameTemplate(QuestRewardScrollFrame)

	MERS:QuestFramePanelTemplate(QuestFrameProgressPanel)
	MERS:QuestFramePanelTemplate(QuestFrameDetailPanel)
	MERS:QuestFramePanelTemplate(QuestFrameGreetingPanel)

	QuestProgressScrollChildFrame:SetSize(300, 403)
	QuestProgressTitleText:SetSize(300, 0)
	QuestProgressTitleText:SetPoint("TOPLEFT", 5, -10)
	QuestProgressText:SetSize(300, 0)
	QuestProgressText:SetPoint("TOPLEFT", QuestProgressTitleText, "BOTTOMLEFT", 0, -5)
end

S:AddCallback("mUIQuestFrame", styleQuestFrame)