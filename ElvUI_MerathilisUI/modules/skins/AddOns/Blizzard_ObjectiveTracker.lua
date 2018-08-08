local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local select = select
local tinsert = table.insert
-- WoW API / Variables
local ObjectiveTrackerFrame = _G["ObjectiveTrackerFrame"]
local SCENARIO_CONTENT_TRACKER_MODULE = _G["SCENARIO_CONTENT_TRACKER_MODULE"]
local QUEST_TRACKER_MODULE = _G["QUEST_TRACKER_MODULE"]
local WORLD_QUEST_TRACKER_MODULE = _G["WORLD_QUEST_TRACKER_MODULE"]
local DEFAULT_OBJECTIVE_TRACKER_MODULE = _G["DEFAULT_OBJECTIVE_TRACKER_MODULE"]
local BONUS_OBJECTIVE_TRACKER_MODULE = _G["BONUS_OBJECTIVE_TRACKER_MODULE"]
local SCENARIO_TRACKER_MODULE = _G["SCENARIO_TRACKER_MODULE"]
local OBJECTIVE_TRACKER_COLOR = OBJECTIVE_TRACKER_COLOR
local InCombatLockdown = InCombatLockdown
local GetQuestLink = GetQuestLink
local GetQuestLogTitle = GetQuestLogTitle
local GetNumQuestLogEntries = GetNumQuestLogEntries

local OBJECTIVE_TRACKER_LINE_WIDTH
local OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT
local OBJECTIVE_TRACKER_DASH_WIDTH
local OBJECTIVE_TRACKER_TEXT_WIDTH

-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS:

local InCombat , a, f, _, id, cns, ncns, l, n, q, o, w = false, ...
local nQ = CreateFrame("Frame", a)
function f.PLAYER_LOGIN()
	_G["WorldMapTitleButton"]:HookScript('OnClick', function(_, b, d)
		if b == "LeftButton" and not d then
			local mainlist, tasks, other = {}, {}, {}
			for i = 1, 1000 do
				_, _, _, _, _, _, _, id, _, _, _, _, _, cns, _, ncns = GetQuestLogTitle(i)
				l = GetQuestLink(id)
				if l then
					if ncns then
						tinsert(other,l)
					elseif cns then
						tinsert(tasks,l)
					else
						tinsert(mainlist,l)
					end
				end
			end
		end
	end)
end

function f.PLAYER_REGEN_DISABLED()
	InCombat = true
end
function f.PLAYER_REGEN_ENABLED()
	InCombat = false
end
function f.QUEST_LOG_UPDATE()
	if not InCombat and not InCombatLockdown() then
		n = tostring(select(2, GetNumQuestLogEntries()))
		q = n.."/"..MAX_QUESTS.." "..TRACKER_HEADER_QUESTS
		o = n.."/"..MAX_QUESTS.." "..OBJECTIVES_TRACKER_LABEL
		_G["ObjectiveTrackerBlocksFrame"].QuestHeader.Text:SetText(q)
		_G["ObjectiveTrackerFrame"].HeaderMenu.Title:SetText(o)
	end
end

local function styleObjectiveTracker()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.private.muiSkins.blizzard.objectiveTracker ~= true then return end

	-- Height
	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "SetStringText", function(_, fontString, _, useFullHeight)
		local _, fontHeight = SystemFont_Shadow_Med1:GetFont()
		local stringHeight = fontString:GetHeight()
		if stringHeight > OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT * 2 - (fontHeight * 2) and not useFullHeight then
			fontString:SetHeight(fontHeight * 2)
		end
	end)

	-- Add Panels
	hooksecurefunc("ObjectiveTracker_Update", function()
		local Frame = ObjectiveTrackerFrame.MODULES

		if (Frame) then
			for i = 1, #Frame do

				local Modules = Frame[i]
				if (Modules) then
					local Header = Modules.Header
					Header:SetFrameStrata("HIGH")
					Header:SetFrameLevel(10)

					if not (Modules.IsSkinned) then
						local HeaderPanel = CreateFrame("Frame", nil, Modules.Header)
						HeaderPanel:SetFrameLevel(Modules.Header:GetFrameLevel() - 1)
						HeaderPanel:SetFrameStrata("HIGH")
						HeaderPanel:SetPoint("BOTTOMLEFT", 0, 3)
						HeaderPanel:SetSize(210, 2)
						MERS:SkinPanel(HeaderPanel)

						Modules.IsSkinned = true
					end
				end
			end
		end
	end)

	-- Skin POI Buttons
	hooksecurefunc("QuestPOI_GetButton", function(parent, questID, style, index)
		local Incomplete = ObjectiveTrackerBlocksFrame.poiTable["numeric"]
		local Complete = ObjectiveTrackerBlocksFrame.poiTable["completed"]

		for i = 1, #Incomplete do
			local Button = ObjectiveTrackerBlocksFrame.poiTable["numeric"][i]

			if Button and not Button.IsSkinned then
				Button.NormalTexture:SetTexture("")
				Button.PushedTexture:SetTexture("")
				Button.HighlightTexture:SetTexture("")
				Button.Glow:SetAlpha(0)
				Button:CreateBackdrop("Default")
				S:HandleButton(Button)

				Button.IsSkinned = true
			end
		end

		for i = 1, #Complete do
			local Button = ObjectiveTrackerBlocksFrame.poiTable["completed"][i]

			if Button and not Button.IsSkinned then
				Button.NormalTexture:SetTexture("")
				Button.PushedTexture:SetTexture("")
				Button.FullHighlightTexture:SetTexture("")
				Button.Glow:SetAlpha(0)
				Button:CreateBackdrop("Default")
				S:HandleButton(Button)

				Button.IsSkinned = true
			end
		end
	end)

	hooksecurefunc("QuestPOI_SelectButton", function(poiButton)
		local Backdrop = poiButton.backdrop

		if Backdrop then
			local ID = GetQuestLogIndexByID(poiButton.questID)
			local Level = select(2, GetQuestLogTitle(ID))
			local Color = GetQuestDifficultyColor(Level) or {r = 1, g = 1, b = 0, a = 1}
			local Number = poiButton.Number

			if PreviousPOI then
				PreviousPOI:SetBackdropColor(unpack(E["media"].backdropcolor))
				PreviousPOI.backdrop:SetBackdropBorderColor(unpack(E["media"].bordercolor))
			end

			poiButton.backdrop:SetBackdropBorderColor(Color.r, Color.g, Color.b)
			poiButton:SetBackdropColor(0/255, 152/255, 34/255, 1)

			PreviousPOI = poiButton
		end
	end)

	local function SkinAutoQuestPopUpBlock()
		for i = 1, GetNumAutoQuestPopUps() do
			local ID, type = GetAutoQuestPopUp(i)
			local Title = GetQuestLogTitle(GetQuestLogIndexByID(ID))

			if Title and Title ~= "" then
				local Block = AUTO_QUEST_POPUP_TRACKER_MODULE:GetBlock(ID)

				if Block then
					local Frame = Block.ScrollChild

					if not Frame.IsSkinned then
						Frame:SetSize(227, 68)
						Frame:CreateBackdrop("Transparent")
						Frame.backdrop:SetPoint("TOPLEFT", Frame, 40, -4)
						Frame.backdrop:SetPoint("BOTTOMRIGHT", Frame, 0, 4)
						Frame.backdrop:SetFrameLevel(0)
						Frame.backdrop:SetTemplate("Transparent")

						Frame.FlashFrame.IconFlash:Hide()

						Frame.QuestName:SetPoint("LEFT", Frame.QuestIconBg, "RIGHT", -6, 0)
						Frame.QuestName:SetPoint("RIGHT", -8, 0)
						Frame.TopText:SetPoint("LEFT", Frame.QuestIconBg, "RIGHT", -6, 0)
						Frame.TopText:SetPoint("RIGHT", -8, 0)
						Frame.BottomText:SetPoint("BOTTOM", 0, 8)
						Frame.BottomText:SetPoint("LEFT", Frame.QuestIconBg, "RIGHT", -6, 0)
						Frame.BottomText:SetPoint("RIGHT", -8, 0)

						Frame.IsSkinned = true
					end

					if type == "COMPLETE" then
						Frame.QuestIconBg:SetAlpha(0)
						Frame.QuestIconBadgeBorder:SetAlpha(0)
						Frame.QuestionMark:ClearAllPoints()
						Frame.QuestionMark:SetPoint("CENTER", Frame.backdrop, "LEFT", 10, 0)
						Frame.QuestionMark:SetParent(Frame.backdrop)
						Frame.QuestionMark:SetDrawLayer("OVERLAY", 7)
						Frame.IconShine:Hide()
					elseif type == "OFFER" then
						Frame.QuestIconBg:SetAlpha(0)
						Frame.QuestIconBadgeBorder:SetAlpha(0)
						Frame.Exclamation:ClearAllPoints()
						Frame.Exclamation:SetPoint("CENTER", Frame.backdrop, "LEFT", 10, 0)
						Frame.Exclamation:SetParent(Frame.backdrop)
						Frame.Exclamation:SetDrawLayer("OVERLAY", 7)
					end

					Frame.FlashFrame:Hide()
					Frame.Bg:Hide()

					for _, v in pairs({Frame.BorderTopLeft, Frame.BorderTopRight, Frame.BorderBotLeft, Frame.BorderBotRight, Frame.BorderLeft, Frame.BorderRight, Frame.BorderTop, Frame.BorderBottom}) do
						v:Hide()
					end
				end
			end
		end
	end

	hooksecurefunc(AUTO_QUEST_POPUP_TRACKER_MODULE, "Update", function(self)
		for _, block in next, self.usedBlocks do
			if not block.IsSkinned then
				SkinAutoQuestPopUpBlock(block)
				block.IsSkinned = true
			end
		end
	end)

	OBJECTIVE_TRACKER_LINE_WIDTH = 248

	OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT = _G["OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT"]
	OBJECTIVE_TRACKER_DASH_WIDTH = _G["OBJECTIVE_TRACKER_DASH_WIDTH"]
	OBJECTIVE_TRACKER_TEXT_WIDTH = OBJECTIVE_TRACKER_LINE_WIDTH - OBJECTIVE_TRACKER_DASH_WIDTH - 12

	ObjectiveTrackerFrame:SetSize(235, 140)
	ObjectiveTrackerFrame.HeaderMenu:SetSize(10, 10)

	local ScenarioChallengeModeBlock = _G["ScenarioChallengeModeBlock"]
	local bg = select(3, ScenarioChallengeModeBlock:GetRegions())
	bg:Hide()
	ScenarioChallengeModeBlock:CreateBackdrop("Transparent")

	ScenarioChallengeModeBlock.TimerBGBack:Hide()
	ScenarioChallengeModeBlock.TimerBG:Hide()

	ScenarioStageBlock:SetSize(201, 83)

	S:HandleButton(_G["ObjectiveTrackerFrame"].HeaderMenu.MinimizeButton)

	nQ:RegisterEvent("PLAYER_LOGIN")
	nQ:RegisterEvent("PLAYER_REGEN_DISABLED")
	nQ:RegisterEvent("PLAYER_REGEN_ENABLED")
	nQ:RegisterEvent("QUEST_LOG_UPDATE")
	nQ:SetScript("OnEvent", function(_,event,...)
		f[event](...)
	end)
end

S:AddCallback("mUIObjectiveTracker", styleObjectiveTracker)