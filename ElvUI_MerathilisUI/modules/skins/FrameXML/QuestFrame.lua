local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local unpack = unpack
local find, gsub = string.find, string.gsub
-- WoW API / Variables
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleQuestFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true or E.private.muiSkins.blizzard.quest ~= true then return end

	-- Stop here if parchment reomover is enabled.
	if E.private.skins.parchmentRemover.enable then return end

	------------------------
	--- QuestDetailFrame ---
	------------------------
	_G.QuestDetailScrollFrame:StripTextures(true)
	_G.QuestDetailScrollFrame:HookScript("OnUpdate", function(self)
		if not E.private.skins.parchmentRemover.enable then
			self.spellTex:SetTexture("")
		end
	end)

	if _G.QuestDetailScrollFrame.spellTex then
		if not E.private.skins.parchmentRemover.enable then
			_G.QuestDetailScrollFrame.spellTex:SetTexture("")
		end
	end

	------------------------
	--- QuestFrameReward ---
	------------------------
	_G.QuestRewardScrollFrame:HookScript("OnShow", function(self)
		self.backdrop:Hide()
		self:SetTemplate("Transparent")
		if not E.private.skins.parchmentRemover.enable then
			self.spellTex:SetTexture("")
			self:Height(self:GetHeight() - 2)
		end
	end)

	--------------------------
	--- QuestFrameProgress ---
	--------------------------
	_G.QuestFrame:Styling()

	_G.QuestProgressScrollFrame:HookScript("OnShow", function(self)
		self:SetTemplate("Transparent")
		if not E.private.skins.parchmentRemover.enable then
			self.spellTex:SetTexture("")
			self:Height(self:GetHeight() - 2)
		end
	end)

	--------------------------
	--- QuestGreetingFrame ---
	--------------------------
	-- Copied from ElvUI
	local function UpdateGreetingFrame()
		for Button in _G.QuestFrameGreetingPanel.titleButtonPool:EnumerateActive() do
			Button.Icon:SetDrawLayer("ARTWORK")
			local Text = Button:GetFontString():GetText()
			if Text and strfind(Text, '|cff000000') then
				Button:GetFontString():SetText(gsub(Text, '|cff000000', '|cffffe519'))
			end
		end
	end

	_G.QuestFrameGreetingPanel:HookScript('OnShow', UpdateGreetingFrame)
	hooksecurefunc("QuestFrameGreetingPanel_OnShow", UpdateGreetingFrame)

	hooksecurefunc('QuestFrameProgressItems_Update', function()
		_G.QuestProgressRequiredItemsText:SetTextColor(1, .8, .1)
	end)

	hooksecurefunc("QuestFrame_SetTitleTextColor", function(fontString)
		fontString:SetTextColor(1, .8, .1)
	end)

	hooksecurefunc("QuestFrame_SetTextColor", function(fontString)
		fontString:SetTextColor(1, 1, 1)
	end)

	hooksecurefunc('QuestInfo_ShowRequiredMoney', function()
		local requiredMoney = GetQuestLogRequiredMoney()
		if requiredMoney > 0 then
			if requiredMoney > GetMoney() then
				_G.QuestInfoRequiredMoneyText:SetTextColor(.63, .09, .09)
			else
				_G.QuestInfoRequiredMoneyText:SetTextColor(1, .8, .1)
			end
		end
	end)

	local QuestInfoRewardsFrame = _G.QuestInfoRewardsFrame
	if QuestInfoRewardsFrame.spellHeaderPool then
		for _, pool in ipairs({"followerRewardPool", "spellRewardPool"}) do
			QuestInfoRewardsFrame[pool]._acquire = QuestInfoRewardsFrame[pool].Acquire
			QuestInfoRewardsFrame[pool].Acquire = function()
				local frame = QuestInfoRewardsFrame[pool]:_acquire()
				if frame then
					frame.Name:SetTextColor(1, 1, 1)
				end
				return frame
			end
		end
		QuestInfoRewardsFrame.spellHeaderPool._acquire = QuestInfoRewardsFrame.spellHeaderPool.Acquire
		QuestInfoRewardsFrame.spellHeaderPool.Acquire = function(self)
			local frame = self:_acquire()
			if frame then
				frame:SetTextColor(1, 1, 1)
			end
			return frame
		end
	end

	_G.QuestGreetingScrollFrame:HookScript("OnShow", function(self)
		self:SetTemplate("Transparent")
		if not E.private.skins.parchmentRemover.enable then
			self.spellTex:SetTexture("")
			self:Height(self:GetHeight() - 2)
		end
	end)

	for i = 1, _G.MAX_REQUIRED_ITEMS do
		local bu = _G["QuestProgressItem"..i]
		local ic = _G["QuestProgressItem"..i.."IconTexture"]
		local na = _G["QuestProgressItem"..i.."NameFrame"]
		local co = _G["QuestProgressItem"..i.."Count"]

		ic:SetSize(40, 40)
		ic:SetTexCoord(unpack(E.TexCoords))
		ic:SetDrawLayer("OVERLAY")

		MERS:CreateBD(bu, .25)

		na:Hide()
		co:SetDrawLayer("OVERLAY")

		local line = CreateFrame("Frame", nil, bu)
		line:SetSize(1, 40)
		line:SetPoint("RIGHT", ic, 1, 0)
		MERS:CreateBD(line)
	end

	_G.QuestDetailScrollFrame:SetWidth(302) -- else these buttons get cut off

	-- Quest NPC model
	_G.QuestNPCModelShadowOverlay:Hide()
	_G.QuestNPCModelBg:Hide()
	_G.QuestNPCModel:DisableDrawLayer("OVERLAY")
	_G.QuestNPCModelNameText:SetDrawLayer("ARTWORK")
	_G.QuestNPCModelTextFrameBg:Hide()
	_G.QuestNPCModelTextFrame:DisableDrawLayer("OVERLAY")

	-- Hide ElvUI's backdrop
	if _G.QuestNPCModel.backdrop then _G.QuestNPCModel.backdrop:Hide() end
	if _G.QuestNPCModelTextFrame.backdrop then _G.QuestNPCModelTextFrame.backdrop:Hide() end

	local npcbd = CreateFrame("Frame", nil, _G.QuestNPCModel)
	npcbd:SetPoint("TOPLEFT", -1, 1)
	npcbd:SetPoint("RIGHT", 2, 0)
	npcbd:SetPoint("BOTTOM", _G.QuestNPCModelTextScrollFrame)
	npcbd:SetFrameLevel(0)
	MERS:CreateBD(npcbd)
	npcbd:Styling()

	local npcLine = CreateFrame("Frame", nil, _G.QuestNPCModel)
	npcLine:SetPoint("BOTTOMLEFT", 0, -1)
	npcLine:SetPoint("BOTTOMRIGHT", 1, -1)
	npcLine:SetHeight(1)
	npcLine:SetFrameLevel(0)
	MERS:CreateBD(npcLine, 0)

	-- Text Color
	_G.QuestNPCModelNameText:SetTextColor(1, 1, 1)
	_G.QuestNPCModelText:SetTextColor(1, 1, 1)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, _, x, y)
		if parentFrame == _G.QuestLogPopupDetailFrame or parentFrame == _G.QuestFrame then
			x = x + 3
		end

		_G.QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, y)
	end)
end

S:AddCallback("mUIQuestFrame", styleQuestFrame)
