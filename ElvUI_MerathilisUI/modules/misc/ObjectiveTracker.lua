local MER, E, L, V, P, G = unpack(select(2, ...))
local MEROT = E:NewModule("mUIObjectiveTracker")
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

-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS:

local MEROT = CreateFrame("Frame", "mUIObjectiveTracker", UIParent)

-- Show Quest Count on the ObjectiveTrackerFrame
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

function MEROT:SkinObjectiveTracker()
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

function MEROT:SkinScenario()
	local StageBlock = _G["ScenarioStageBlock"]

	StageBlock.NormalBG:SetTexture("")
	StageBlock.FinalBG:SetTexture("")
	StageBlock.Stage:SetFont(E["media"].normFont, 17)
	StageBlock.GlowTexture:SetTexture("")
end

function MEROT:UpdatePopup()
	for i = 1, GetNumAutoQuestPopUps() do
		local ID, type = GetAutoQuestPopUp(i)
		local Title = GetQuestLogTitle(GetQuestLogIndexByID(ID))

		if Title and Title ~= "" then
			local Block = AUTO_QUEST_POPUP_TRACKER_MODULE:GetBlock(ID)

			if Block then
				local Frame = Block.ScrollChild

				if not Frame.Backdrop then
					Frame:CreateBackdrop("Transparent")

					Frame.backdrop:SetPoint("TOPLEFT", Frame, 40, -4)
					Frame.backdrop:SetPoint("BOTTOMRIGHT", Frame, 0, 4)
					Frame.backdrop:SetFrameLevel(0)
					Frame.backdrop:SetTemplate("Transparent")
					Frame.backdrop:CreateShadow()

					Frame.FlashFrame.IconFlash:Hide()
				end

				if  type == "COMPLETE" then
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

function MEROT:SkinPOI(parent, questID, style, index)
	local Incomplete = self.poiTable["numeric"]
	local Complete = self.poiTable["completed"]

	for i = 1, #Incomplete do
		local Button = ObjectiveTrackerBlocksFrame.poiTable["numeric"][i]

		if Button and not Button.IsSkinned then
			Button.NormalTexture:SetTexture("")
			Button.PushedTexture:SetTexture("")
			Button.HighlightTexture:SetTexture("")
			Button.Glow:SetAlpha(0)
			Button:CreateBackdrop("Transparent")
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
			Button:CreateBackdrop("Transparent")
			S:HandleButton(Button)

			Button.IsSkinned = true
		end
	end
end

function MEROT:SelectPOI(color)
	local Backdrop = self.backdrop

	if Backdrop then
		local ID = GetQuestLogIndexByID(self.questID)
		local Level = select(2, GetQuestLogTitle(ID))
		local Color = GetQuestDifficultyColor(Level) or {r = 1, g = 1, b = 0, a = 1}
		local Number = self.Number

		if PreviousPOI then
			PreviousPOI:SetBackdropColor(unpack(E["media"].backdropcolor))
			PreviousPOI.backdrop:SetBackdropBorderColor(unpack(E["media"].bordercolor))
		end

		self:SetBackdropColor(Color.r, Color.g, Color.b)

		PreviousPOI = self
	end
end

function MEROT:ShowObjectiveTrackerLevel()
	for i = 1, GetNumQuestWatches() do
		local questID, title, questLogIndex = GetQuestWatchInfo(i)

		if ( not questID ) then
			break
		end

		local block = _G["QUEST_TRACKER_MODULE"]:GetExistingBlock(questID)

		if block then
			local title, level = GetQuestLogTitle(questLogIndex)
			local color = GetQuestDifficultyColor(level)
			local hex = E:RGBToHex(color.r, color.g, color.b) or OBJECTIVE_TRACKER_COLOR["Header"]
			local text = hex.."["..level.."]|r "..title

			block.HeaderText:SetText(text)
		end
	end
end

function MEROT:ShowQuestLogLevel()
	local numEntries, numQuests = GetNumQuestLogEntries()
	local titleIndex = 1

	for i = 1, numEntries do
		local title, level, _, isHeader, _, _, _, questID = GetQuestLogTitle(i)
		local titleButton = QuestLogQuests_GetTitleButton(titleIndex)
		if title and (not isHeader) and titleButton.questID == questID then
			local height = titleButton.Text:GetHeight()
			local text = "["..level.."] "..title
			titleButton.Text:SetText(text)
			titleButton.Text:SetPoint("TOPLEFT", 24, -5)
			titleButton:SetHeight(titleButton:GetHeight() - height + titleButton.Text:GetHeight())
			titleButton.Check:SetPoint("LEFT", titleButton.Text, titleButton.Text:GetWrappedWidth() + 2, 0)

			titleIndex = titleIndex + 1
		end
	end
end

function MEROT:AddHooks()
	hooksecurefunc("ObjectiveTracker_Update", self.SkinObjectiveTracker)
	hooksecurefunc("ScenarioBlocksFrame_OnLoad", self.SkinScenario)
	hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, "Update", self.SkinScenario)
	hooksecurefunc(AUTO_QUEST_POPUP_TRACKER_MODULE, "Update", self.UpdatePopup)
	hooksecurefunc("QuestPOI_GetButton", self.SkinPOI)
	hooksecurefunc("QuestPOI_SelectButton", self.SelectPOI)
	hooksecurefunc("QuestPOI_SelectButtonByQuestID", self.SelectPOI)
	hooksecurefunc(QUEST_TRACKER_MODULE, "Update", self.ShowObjectiveTrackerLevel)
	hooksecurefunc("QuestLogQuests_Update", self.ShowQuestLogLevel)

	-- Fix height
	local function fixBlockHeight(block)
		if block.shouldFix then
			local height = block:GetHeight()

			if block.lines then
				for _, line in pairs(block.lines) do
					if line:IsShown() then
						height = height + 4
					end
				end
			end

			block.shouldFix = false
			block:SetHeight(height + 5)
			block.shouldFix = true
		end
	end

	hooksecurefunc("ObjectiveTracker_AddBlock", function(block)
		if block.lines then
			for _, line in pairs(block.lines) do
				if not line.styled then
					line:SetHeight(line.Text:GetHeight())
					line.Text:SetSpacing(2)
					line.styled = true
				end
			end
		end

		if not block.styled then
			block.shouldFix = true
			hooksecurefunc(block, "SetHeight", fixBlockHeight)
			block.styled = true
		end
	end)
end

function MEROT:Initialize()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.private.muiSkins.blizzard.objectiveTracker ~= true then return end

	OBJECTIVE_TRACKER_COLOR["Complete"] = { r = 0, g = 1, b = 0 } -- green

	S:HandleButton(_G["ObjectiveTrackerFrame"].HeaderMenu.MinimizeButton)

	self:AddHooks()

	nQ:RegisterEvent("PLAYER_LOGIN")
	nQ:RegisterEvent("PLAYER_REGEN_DISABLED")
	nQ:RegisterEvent("PLAYER_REGEN_ENABLED")
	nQ:RegisterEvent("QUEST_LOG_UPDATE")
	nQ:SetScript("OnEvent", function(_,event,...)
		f[event](...)
	end)
end

local function InitializeCallback()
	MEROT:Initialize()
end

E:RegisterModule(MEROT:GetName(), InitializeCallback)