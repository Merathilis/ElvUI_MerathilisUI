local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local select = select
-- WoW API / Variables
local ObjectiveTrackerFrame = _G["ObjectiveTrackerFrame"]
local SCENARIO_CONTENT_TRACKER_MODULE = _G["SCENARIO_CONTENT_TRACKER_MODULE"]
local QUEST_TRACKER_MODULE = _G["QUEST_TRACKER_MODULE"]
local WORLD_QUEST_TRACKER_MODULE = _G["WORLD_QUEST_TRACKER_MODULE"]
local DEFAULT_OBJECTIVE_TRACKER_MODULE = _G["DEFAULT_OBJECTIVE_TRACKER_MODULE"]
local BONUS_OBJECTIVE_TRACKER_MODULE = _G["BONUS_OBJECTIVE_TRACKER_MODULE"]
local SCENARIO_TRACKER_MODULE = _G["SCENARIO_TRACKER_MODULE"]

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
		-- w = MAP_AND_QUEST_LOG.." ("..n.."/"..MAX_QUESTS..")"
		_G["ObjectiveTrackerBlocksFrame"].QuestHeader.Text:SetText(q)
		_G["ObjectiveTrackerFrame"].HeaderMenu.Title:SetText(o)
		_G["WorldMapFrame"].BorderFrame.TitleText:SetText(w)
	end
end

local function styleObjectiveTracker()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.private.muiSkins.blizzard.objectiveTracker ~= true then return end

	--[[ AddOns\Blizzard_ObjectiveTracker.lua ]]

	----====####$$$$$$$####====----
	-- Blizzard_ObjectiveTracker --
	----====####$$$$$$$####====----

	local function SetStringText(fontString, text, useFullHeight, colorStyle, useHighlight)
		fontString:SetHeight(0)
		fontString:SetText(text)
		local stringHeight = fontString:GetStringHeight()
		if ( stringHeight > OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT and not useFullHeight ) then
			stringHeight = OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT
		end
		return stringHeight
	end

	function MERS.DEFAULT_OBJECTIVE_TRACKER_MODULE_AddObjective(self, block, objectiveKey, text, lineType, useFullHeight, dashStyle, colorStyle, adjustForNoText)
		local line = block.lines[objectiveKey]

		-- set the text
		local height = SetStringText(line.Text, text, useFullHeight, colorStyle, block.isHighlighted)
		line:SetHeight(height)

		if height == 0 then
			-- Not sure why this happens, but it messes up the position of progress bar lines
			return
		end
	end

	function MERS.DEFAULT_OBJECTIVE_TRACKER_MODULE_SetBlockHeader(self, block, text)
		block._mUIHeight = SetStringText(block.HeaderText, text, nil, OBJECTIVE_TRACKER_COLOR["Header"], block.isHighlighted)
	end

	function MERS.ObjectiveTracker_Update()
		local Frame = ObjectiveTrackerFrame.MODULES

		-- Add Panels
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
	end

	function MERS.QuestPOI_GetButton(parent, questID, style, index)
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
	end

	function MERS.QuestPOI_SelectButton(poiButton)
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
	end

	function MERS.ObjectiveTracker_Initialize(self)
		hooksecurefunc("ObjectiveTracker_Update", MERS.ObjectiveTracker_Update)
		hooksecurefunc("QuestPOI_GetButton", MERS.QuestPOI_GetButton)
		hooksecurefunc("QuestPOI_SelectButton", MERS.QuestPOI_SelectButton)
		hooksecurefunc("QuestPOI_SelectButtonByQuestID", MERS.QuestPOI_SelectButton)
		hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddObjective", MERS.DEFAULT_OBJECTIVE_TRACKER_MODULE_AddObjective)
		hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "SetBlockHeader", MERS.DEFAULT_OBJECTIVE_TRACKER_MODULE_SetBlockHeader)

		hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", MERS.QUEST_TRACKER_MODULE_SetBlockHeader)
		hooksecurefunc(SCENARIO_TRACKER_MODULE, "GetBlock", MERS.SCENARIO_TRACKER_MODULE_GetBlock)

		hooksecurefunc(AUTO_QUEST_POPUP_TRACKER_MODULE, "Update", MERS.AUTO_QUEST_POPUP_TRACKER_MODULE_Update)
		hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, "Update", MERS.SCENARIO_CONTENT_TRACKER_MODULE_Update)
	end

	----====####$$$$%%%%$$$$####====----
	-- Blizzard_QuestObjectiveTracker --
	----====####$$$$%%%%$$$$####====----
	local QUEST_ICONS_FILE = "Interface\\QuestFrame\\QuestTypeIcons"
	local QUEST_ICONS_FILE_WIDTH = 128
	local QUEST_ICONS_FILE_HEIGHT = 64

	local coords = QUEST_TAG_TCOORDS[UnitFactionGroup("player"):upper()]
	local factionIcon  = CreateTextureMarkup(QUEST_ICONS_FILE, QUEST_ICONS_FILE_WIDTH, QUEST_ICONS_FILE_HEIGHT, 16, 16
		, coords[1]
		, coords[2] - 0.02 -- Offset to stop bleeding from next image
		, coords[3]
		, coords[4], 0, 2)
	function MERS.QUEST_TRACKER_MODULE_SetBlockHeader(self, block, text, questLogIndex, isQuestComplete, questID)
		if C_CampaignInfo.IsCampaignQuest(questID) then
			text = text..factionIcon
		end

		block._mUIHeight = SetStringText(block.HeaderText, text, nil, OBJECTIVE_TRACKER_COLOR["Header"], block.isHighlighted)
	end

	----====####$$$$%%%%$$$$####====----
	-- Blizzard_AutoQuestPopUpTracker --
	----====####$$$$%%%%$$$$####====----
	function MERS.AUTO_QUEST_POPUP_TRACKER_MODULE_Update(self)
		for _, block in next, self.usedBlocks do
			if not block.IsSkinned then
				MERS:AutoQuestPopUpBlockTemplate(block)
				block.IsSkinned = true
			end
		end
	end

	----====####$$$$%%%%%%%$$$$####====----
	-- Blizzard_ScenarioObjectiveTracker --
	----====####$$$$%%%%%%%$$$$####====----
	function MERS.SCENARIO_TRACKER_MODULE_GetBlock(self)
		ScenarioObjectiveBlock._mUIHeight = 0
	end

	function MERS.SCENARIO_CONTENT_TRACKER_MODULE_Update(self)
		local _, _, _, _, _, _, _, _, _, scenarioType = _G.C_Scenario.GetInfo()
		local stageBlock
		if scenarioType == _G.LE_SCENARIO_TYPE_CHALLENGE_MODE and _G.ScenarioChallengeModeBlock.timerID then
			stageBlock = _G.ScenarioChallengeModeBlock
		elseif _G.ScenarioProvingGroundsBlock.timerID then
			stageBlock = _G.ScenarioProvingGroundsBlock
		else
			stageBlock = _G.ScenarioStageBlock
		end
	end

	--[[ AddOns\Blizzard_ObjectiveTracker.xml ]]

	----====####$$$$$$$####====----
	-- Blizzard_ObjectiveTracker --
	----====####$$$$$$$####====----
	--function MERS:ObjectiveTrackerBlockTemplate(Frame)
		--Frame:SetSize(232, 10)
		--Frame.HeaderText:SetSize(192, 0)
	--end

	function MERS:ObjectiveTrackerHeaderTemplate(Frame)
		Frame.Background:Hide()

		local bg = Frame:CreateTexture(nil, "ARTWORK")
		bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
		bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
		bg:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
		bg:SetPoint("BOTTOMLEFT", -30, -4)
		bg:SetSize(210, 30)

		Frame:SetSize(235, 25)
		Frame.Text:SetPoint("LEFT", 4, -1)
	end

	--function MERS:ObjectiveTrackerLineTemplate(Frame)
		--Frame:SetSize(232, 16)
		--Frame.Dash:SetPoint("TOPLEFT", 0, 1)
	--end

	function MERS:ObjectiveTrackerCheckLineTemplate(Frame)
		Frame:SetSize(232, 16)
		Frame.Text:SetPoint("TOPLEFT", 20, 0)
		Frame.IconAnchor:SetSize(16, 16)
		Frame.IconAnchor:SetPoint("TOPLEFT", 1, 2)
	end

	----====####$$$$%%%%$$$$####====----
	-- Blizzard_QuestObjectiveTracker --
	----====####$$$$%%%%$$$$####====----
	function MERS:QuestObjectiveAnimLineTemplate(Frame)
		--MERS:ObjectiveTrackerLineTemplate(Frame)
		Frame.Check:SetAtlas("worldquest-tracker-checkmark")
		Frame.Check:SetSize(18, 16)

		Frame.Check:SetPoint("TOPLEFT", -10, 2)
	end

	----====####$$$$%%%%$$$$####====----
	-- Blizzard_AutoQuestPopUpTracker --
	----====####$$$$%%%%$$$$####====----
	function MERS:AutoQuestPopUpBlockTemplate()
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

	----====####$$$$%%%%$$$$####====----
	-- Blizzard_BonusObjectiveTracker --
	----====####$$$$%%%%$$$$####====----
	function MERS:BonusObjectiveTrackerLineTemplate(Frame)
		MERS:ObjectiveTrackerCheckLineTemplate(Frame)

		--[[ Scale ]]--
		Frame.Dash:SetPoint("TOPLEFT", 20, 1)

		Frame.Text:ClearAllPoints()
		Frame.Text:SetPoint("TOP")
		Frame.Text:SetPoint("LEFT", Frame.Dash, "RIGHT")

		Frame.Glow:SetPoint("LEFT", Frame.Dash, -2, 0)
	end

	function MERS:BonusObjectiveTrackerHeaderTemplate(Frame)
		MERS:ObjectiveTrackerHeaderTemplate(Frame)
	end

	----====####$$$$$$$####====----
	-- Blizzard_ObjectiveTracker --
	----====####$$$$$$$####====----
	hooksecurefunc("ObjectiveTracker_Initialize", MERS.ObjectiveTracker_Initialize)

	--OBJECTIVE_TRACKER_ITEM_WIDTH = 33
	--OBJECTIVE_TRACKER_HEADER_HEIGHT = 25
	OBJECTIVE_TRACKER_LINE_WIDTH = 248
	--OBJECTIVE_TRACKER_HEADER_OFFSET_X = -10

	OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT = _G["OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT"]
	OBJECTIVE_TRACKER_DASH_WIDTH = _G["OBJECTIVE_TRACKER_DASH_WIDTH"]
	OBJECTIVE_TRACKER_TEXT_WIDTH = OBJECTIVE_TRACKER_LINE_WIDTH - OBJECTIVE_TRACKER_DASH_WIDTH - 12

	ObjectiveTrackerFrame:SetSize(235, 140)
	ObjectiveTrackerFrame.HeaderMenu:SetSize(10, 10)

	----====####$$$$%%%%$$$$####====----
	-- Blizzard_BonusObjectiveTracker --
	----====####$$$$%%%%$$$$####====----
	local _, _, _, bonusObj, worldQuests = ObjectiveTrackerFrame.BlocksFrame:GetChildren()
	MERS:BonusObjectiveTrackerHeaderTemplate(bonusObj)
	MERS:BonusObjectiveTrackerHeaderTemplate(worldQuests)

	----====####$$$$%%%%%%%$$$$####====----
	-- Blizzard_ScenarioObjectiveTracker --
	----====####$$$$%%%%%%%$$$$####====----
	ScenarioObjectiveBlock._mUIHeight = 0

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