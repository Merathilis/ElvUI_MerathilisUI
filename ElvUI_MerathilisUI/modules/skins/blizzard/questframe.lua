local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G

-- WoW API / Variables
local CreateFrame = CreateFrame
local GetActiveTitle = GetActiveTitle
local GetAvailableQuestInfo = GetAvailableQuestInfo
local GetAvailableTitle = GetAvailableTitle
local GetNumActiveQuests = GetNumActiveQuests
local GetNumAvailableQuests = GetNumAvailableQuests
local IsActiveQuestTrivial = IsActiveQuestTrivial

-- GLOBALS: hooksecurefunc, MAX_REQUIRED_ITEMS, MER_TRIVIAL_QUEST_DISPLAY, MER_NORMAL_QUEST_DISPLAY

local function styleQuestFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true or E.private.muiSkins.blizzard.quest ~= true then return; end

	--[[Taken from Aurora]]--
	hooksecurefunc("QuestFrame_SetMaterial", function(frame, material)
		if material ~= "Parchment" then
			local name = frame:GetName()
			_G[name.."MaterialTopLeft"]:Hide()
			_G[name.."MaterialTopRight"]:Hide()
			_G[name.."MaterialBotLeft"]:Hide()
			_G[name.."MaterialBotRight"]:Hide()
		end
	end)

	--[[ Reward Panel ]]
	_G["QuestFrameRewardPanel"]:DisableDrawLayer("BACKGROUND")
	_G["QuestFrameRewardPanel"]:DisableDrawLayer("BORDER")

	_G["QuestRewardScrollFrameTop"]:Hide()
	_G["QuestRewardScrollFrameBottom"]:Hide()
	_G["QuestRewardScrollFrameMiddle"]:Hide()
	_G["QuestRewardScrollFrame"]:HookScript("OnShow", function(self)
		self.backdrop:Hide()
		self:SetTemplate("Transparent")
		self.spellTex:SetTexture("")
		self:Height(self:GetHeight() - 2)
	end)

	_G["QuestGreetingScrollFrame"]:StripTextures(true)
	_G["QuestFrameInset"]:StripTextures(true)

	--[[ Progress Panel ]]
	_G["QuestFrameProgressPanel"]:DisableDrawLayer("BACKGROUND")
	_G["QuestFrameProgressPanel"]:DisableDrawLayer("BORDER")

	_G["QuestProgressScrollFrame"]:HookScript("OnShow", function(self)
		self:SetTemplate("Transparent")
		self.spellTex:SetTexture("")
		self:Height(self:GetHeight() - 2)
	end)

	_G["QuestProgressScrollFrameTop"]:Hide()
	_G["QuestProgressScrollFrameBottom"]:Hide()
	_G["QuestProgressScrollFrameMiddle"]:Hide()

	_G["QuestProgressTitleText"]:SetTextColor(1, 1, 1)
	_G["QuestProgressTitleText"]:SetShadowColor(0, 0, 0)
	_G["QuestProgressTitleText"].SetTextColor = MER.dummy
	_G["QuestProgressText"]:SetTextColor(1, 1, 1)
	_G["QuestProgressText"].SetTextColor = MER.dummy
	_G["QuestProgressRequiredItemsText"]:SetTextColor(1, 1, 1)
	_G["QuestProgressRequiredItemsText"]:SetShadowColor(0, 0, 0)

	hooksecurefunc(_G["QuestProgressRequiredMoneyText"], "SetTextColor", function(self, r, g, b)
		if r == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif r == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	for i = 1, MAX_REQUIRED_ITEMS do
		local bu = _G["QuestProgressItem"..i]
		MERS:CreateBD(bu, .25)

		bu.Icon:SetPoint("TOPLEFT", 1, -1)
		bu.Icon:SetDrawLayer("OVERLAY")

		bu.NameFrame:Hide()
		bu.Count:SetDrawLayer("OVERLAY")
	end

	--[[ Detail Panel ]]
	_G["QuestFrameDetailPanel"]:DisableDrawLayer("BACKGROUND")
	_G["QuestFrameDetailPanel"]:DisableDrawLayer("BORDER")

	_G["QuestDetailScrollFrame"]:SetWidth(302) -- else these buttons get cut off
	_G["QuestDetailScrollFrameTop"]:Hide()
	_G["QuestDetailScrollFrameBottom"]:Hide()
	_G["QuestDetailScrollFrameMiddle"]:Hide()

	_G["QuestDetailScrollFrame"]:HookScript("OnUpdate", function(self)
		self:SetTemplate("Transparent")
		self.spellTex:SetTexture("")
	end)

	_G["QuestLogPopupDetailFrameScrollFrame"]:HookScript("OnUpdate", function(self)
		_G["QuestLogPopupDetailFrameScrollFrame"].backdrop:Hide()
		_G["QuestLogPopupDetailFrameInset"]:Hide()
		_G["QuestLogPopupDetailFrameBg"]:Hide()
		self:SetTemplate("Transparent")
		self.spellTex:SetTexture("")
	end)

	--[[ Greeting Panel ]]
	_G["QuestFrameGreetingPanel"]:DisableDrawLayer("BACKGROUND")

	_G["QuestGreetingScrollFrameTop"]:Hide()
	_G["QuestGreetingScrollFrameBottom"]:Hide()
	_G["QuestGreetingScrollFrameMiddle"]:Hide()

	_G["GreetingText"]:SetTextColor(1, 1, 1)
	_G["GreetingText"].SetTextColor = MER.dummy
	_G["CurrentQuestsText"]:SetTextColor(1, 1, 1)
	_G["CurrentQuestsText"].SetTextColor = MER.dummy
	_G["CurrentQuestsText"]:SetShadowColor(0, 0, 0)
	_G["AvailableQuestsText"]:SetTextColor(1, 1, 1)
	_G["AvailableQuestsText"].SetTextColor = MER.dummy
	_G["AvailableQuestsText"]:SetShadowColor(0, 0, 0)

	local hRule = _G["QuestFrameGreetingPanel"]:CreateTexture()
	hRule:SetColorTexture(1, 1, 1, .2)
	hRule:SetSize(256, 1)
	hRule:SetPoint("CENTER", _G["QuestGreetingFrameHorizontalBreak"])

	_G["QuestGreetingFrameHorizontalBreak"]:SetTexture("")

	local function UpdateGreetingPanel()
		hRule:SetShown(_G["QuestGreetingFrameHorizontalBreak"]:IsShown())
		local numActiveQuests = GetNumActiveQuests()
		if numActiveQuests > 0 then
			for i = 1, numActiveQuests do
				local questTitleButton = _G["QuestTitleButton"..i]
				local title = GetActiveTitle(i)
				if ( IsActiveQuestTrivial(i) ) then
					questTitleButton:SetFormattedText(MER_TRIVIAL_QUEST_DISPLAY, title)
				else
					questTitleButton:SetFormattedText(MER_NORMAL_QUEST_DISPLAY, title)
				end
			end
		end

		local numAvailableQuests = GetNumAvailableQuests()
		if numAvailableQuests > 0 then
			for i = numActiveQuests + 1, numActiveQuests + numAvailableQuests do
				local questTitleButton = _G["QuestTitleButton"..i]
				local title = GetAvailableTitle(i - numActiveQuests)
				if GetAvailableQuestInfo(i - numActiveQuests) then
					questTitleButton:SetFormattedText(MER_TRIVIAL_QUEST_DISPLAY, title);
				else
					questTitleButton:SetFormattedText(MER_NORMAL_QUEST_DISPLAY, title);
				end
			end
		end
	end
	_G["QuestFrameGreetingPanel"]:HookScript("OnShow", UpdateGreetingPanel)
	hooksecurefunc("QuestFrameGreetingPanel_OnShow", UpdateGreetingPanel)
end

S:AddCallback("mUIQuestFrame", styleQuestFrame)