local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local format = string.format
local next, pairs, select = next, pairs, select
local tinsert = table.insert
-- WoW API / Variables
local InCombatLockdown = InCombatLockdown
local GetQuestLink = GetQuestLink
local GetQuestLogTitle = GetQuestLogTitle
local GetAutoQuestPopUp = GetAutoQuestPopUp
local GetNumQuestLogEntries = GetNumQuestLogEntries
local GetNumAutoQuestPopUps = GetNumAutoQuestPopUps
local GetQuestLogIndexByID = GetQuestLogIndexByID
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
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
	local questNum, q, o
	local block = _G.ObjectiveTrackerBlocksFrame
	local frame = _G.ObjectiveTrackerFrame

	if not InCombat and not InCombatLockdown() then
		questNum = select(2, GetNumQuestLogEntries())

		if questNum >= (_G.MAX_QUESTS - 5) then -- go red
			q = format("|cffff0000%d/%d|r %s", questNum, _G.MAX_QUESTS, _G.TRACKER_HEADER_QUESTS)
			o = format("|cffff0000%d/%d|r %s", questNum, _G.MAX_QUESTS, _G.OBJECTIVES_TRACKER_LABEL)
		else
			q = format("%d/%d %s", questNum, _G.MAX_QUESTS, _G.TRACKER_HEADER_QUESTS)
			o = format("%d/%d %s", questNum, _G.MAX_QUESTS, _G.OBJECTIVES_TRACKER_LABEL)
		end

		block.QuestHeader.Text:SetText(q)
		frame.HeaderMenu.Title:SetText(o)
	end
end

local function styleObjectiveTracker()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.private.muiSkins.blizzard.objectiveTracker ~= true then return end

	-- Add Panels
	hooksecurefunc("ObjectiveTracker_Update", function()
		local Frame = _G.ObjectiveTrackerFrame.MODULES

		if (Frame) then
			for i = 1, #Frame do

				local Modules = Frame[i]
				if (Modules) then
					local Header = Modules.Header
					Header:SetFrameStrata("LOW")

					if not (Modules.IsSkinned) then
						local HeaderPanel = CreateFrame("Frame", nil, Modules.Header)
						HeaderPanel:SetFrameLevel(Modules.Header:GetFrameLevel() - 1)
						HeaderPanel:SetFrameStrata("LOW")
						HeaderPanel:SetPoint("BOTTOMLEFT", 0, 3)
						HeaderPanel:SetSize(210, 2)
						MERS:SkinPanel(HeaderPanel)

						Modules.IsSkinned = true
					end
				end
			end
		end
	end)

	local function SkinAutoQuestPopUpBlock()
		for i = 1, GetNumAutoQuestPopUps() do
			local ID, type = GetAutoQuestPopUp(i)
			local Title = GetQuestLogTitle(GetQuestLogIndexByID(ID))

			if Title and Title ~= "" then
				local Block = _G.AUTO_QUEST_POPUP_TRACKER_MODULE:GetBlock(ID)

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

	hooksecurefunc(_G.AUTO_QUEST_POPUP_TRACKER_MODULE, "Update", function(self)
		for _, block in next, self.usedBlocks do
			if not block.IsSkinned then
				SkinAutoQuestPopUpBlock(block)
				block.IsSkinned = true
			end
		end
	end)

	_G.ObjectiveTrackerFrame:SetSize(235, 140)
	_G.ObjectiveTrackerFrame.HeaderMenu:SetSize(10, 10)

	local ScenarioChallengeModeBlock = _G.ScenarioChallengeModeBlock
	local bg = select(3, ScenarioChallengeModeBlock:GetRegions())
	bg:Hide()
	ScenarioChallengeModeBlock:CreateBackdrop("Transparent")
	ScenarioChallengeModeBlock.backdrop:Styling()

	ScenarioChallengeModeBlock.TimerBGBack:Hide()
	ScenarioChallengeModeBlock.TimerBG:Hide()

	-- Mera trying stuff
	local ScenarioStageBlock = _G.ScenarioStageBlock
	ScenarioStageBlock:StripTextures()
	ScenarioStageBlock.NormalBG:Hide()
	ScenarioStageBlock.GlowTexture:Hide()

	local ssbBD = _G.CreateFrame("Frame", nil, ScenarioStageBlock)
	ssbBD:SetFrameLevel(ScenarioStageBlock:GetFrameLevel())
	ssbBD:SetAllPoints(ScenarioStageBlock.NormalBG)
	ssbBD:SetClipsChildren(true)
	ssbBD:SetPoint("TOPLEFT", ScenarioStageBlock.NormalBG, 3, -3)
	ssbBD:SetPoint("BOTTOMRIGHT", ScenarioStageBlock.NormalBG, -3, 3)
	ssbBD:CreateBackdrop("Transparent")
	ssbBD.backdrop:Styling()
	ScenarioStageBlock.bg = ssbBD

	local overlay = ssbBD:CreateTexture(nil, "OVERLAY")
	overlay:SetSize(120, 120)
	overlay:SetPoint("TOPRIGHT", 23, 20)
	overlay:SetAlpha(0.2)
	overlay:SetDesaturated(true)
	ScenarioStageBlock.overlay = overlay

	local uiTextureKits = {
		[0] = {color = 1, 1, 1, overlay = ""},
		[261] = {color = 0.29, 0.33, 0.91, overlay = [[Interface\Timer\Alliance-Logo]]},
		[5117] = {color = 0.90, 0.05, 0.07, overlay = [[Interface\Timer\Horde-Logo]]},
		["legion"] = {color = 255/19, 255/255, 255/41, overlay = ""},
	}

	function MERS.ScenarioStage_CustomizeBlock(stageBlock, scenarioType, widgetSetID, textureKitID)
		if widgetSetID then
			stageBlock.overlay:Hide()
		else
			stageBlock.overlay:Show()

			local kit
			if textureKitID then
				kit = uiTextureKits[textureKitID] or uiTextureKits[0]
			elseif scenarioType == _G.LE_SCENARIO_TYPE_LEGION_INVASION then
				kit = uiTextureKits["legion"]
			else
				kit = uiTextureKits[0]
			end

			stageBlock.bg:SetBackdropColor(kit.color, 0,75)
			stageBlock.overlay:SetTexture(kit.overlay)
		end
	end
	_G.hooksecurefunc("ScenarioStage_CustomizeBlock", MERS.ScenarioStage_CustomizeBlock)

	S:HandleButton(_G.ObjectiveTrackerFrame.HeaderMenu.MinimizeButton)

	nQ:RegisterEvent("PLAYER_LOGIN")
	nQ:RegisterEvent("PLAYER_REGEN_DISABLED")
	nQ:RegisterEvent("PLAYER_REGEN_ENABLED")
	nQ:RegisterEvent("QUEST_LOG_UPDATE")
	nQ:SetScript("OnEvent", function(_,event,...)
		f[event](...)
	end)
end

S:AddCallback("mUIObjectiveTracker", styleObjectiveTracker)
