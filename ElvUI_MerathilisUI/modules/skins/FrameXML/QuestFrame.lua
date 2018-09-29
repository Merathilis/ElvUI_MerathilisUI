local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G

-- WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleQuestFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true or E.private.muiSkins.blizzard.quest ~= true then return end

	_G["QuestFont"]:SetTextColor(1, 1, 1)
	------------------------
	--- QuestDetailFrame ---
	------------------------
	_G["QuestDetailScrollFrame"]:StripTextures(true)
	_G["QuestDetailScrollFrame"]:HookScript("OnUpdate", function(self)
		self.spellTex:SetTexture("")
	end)

	if _G["QuestDetailScrollFrame"].spellTex then
		_G["QuestDetailScrollFrame"].spellTex:SetTexture("")
	end

	------------------------
	--- QuestFrameReward ---
	------------------------
	_G["QuestRewardScrollFrame"]:HookScript("OnShow", function(self)
		self.backdrop:Hide()
		self:SetTemplate("Transparent")
		self.spellTex:SetTexture("")
		self:Height(self:GetHeight() - 2)
	end)

	--------------------------
	--- QuestFrameProgress ---
	--------------------------
	_G["QuestFrame"]:Styling()

	_G["QuestProgressScrollFrame"]:HookScript("OnShow", function(self)
		self:SetTemplate("Transparent")
		self.spellTex:SetTexture("")
		self:Height(self:GetHeight() - 2)
	end)

	hooksecurefunc("QuestFrameProgressItems_Update", function()
		_G["QuestProgressTitleText"]:SetTextColor(1, 1, 1)
		_G["QuestProgressText"]:SetTextColor(1, 1, 1)
		_G["QuestProgressRequiredItemsText"]:SetTextColor(1, 1, 1)
		_G["QuestProgressRequiredMoneyText"]:SetTextColor(1, 1, 1)
	end)

	--------------------------
	--- QuestGreetingFrame ---
	--------------------------
	_G["QuestGreetingScrollFrame"]:HookScript("OnShow", function(self)
		self:SetTemplate("Transparent")
		self.spellTex:SetTexture("")
		self:Height(self:GetHeight() - 2)
	end)

	hooksecurefunc("QuestFrame_SetMaterial", function(frame)
		_G[frame:GetName().."MaterialTopLeft"]:Hide()
		_G[frame:GetName().."MaterialTopRight"]:Hide()
		_G[frame:GetName().."MaterialBotLeft"]:Hide()
		_G[frame:GetName().."MaterialBotRight"]:Hide()
	end)

	for i = 1, 16 do
		local button = _G['QuestTitleButton'..i]
		if button then
			hooksecurefunc(button, 'SetFormattedText', function(self)
				if self:GetFontString() then
					local Text = self:GetFontString():GetText()
					if Text and strfind(Text, '|cff000000') then
						button:GetFontString():SetText(string.gsub(Text, '|cff000000', '|cffFFFF00'))
					end
				end
			end)
		end
	end

	local line = QuestFrameGreetingPanel:CreateTexture()
	line:SetColorTexture(1, 1, 1, .2)
	line:SetSize(256, 1)
	line:SetPoint("CENTER", QuestGreetingFrameHorizontalBreak)

	QuestGreetingFrameHorizontalBreak:SetTexture("")

	QuestFrameGreetingPanel:HookScript("OnShow", function()
		line:SetShown(QuestGreetingFrameHorizontalBreak:IsShown())
	end)

	for i = 1, MAX_REQUIRED_ITEMS do
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

	QuestDetailScrollFrame:SetWidth(302) -- else these buttons get cut off

	hooksecurefunc(QuestProgressRequiredMoneyText, "SetTextColor", function(self, r)
		if r == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif r == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	-- Quest NPC model
	QuestNPCModelShadowOverlay:Hide()
	QuestNPCModelBg:Hide()
	QuestNPCModel:DisableDrawLayer("OVERLAY")
	QuestNPCModelNameText:SetDrawLayer("ARTWORK")
	QuestNPCModelTextFrameBg:Hide()
	QuestNPCModelTextFrame:DisableDrawLayer("OVERLAY")

	-- Hide ElvUI's backdrop
	if QuestNPCModel.backdrop then QuestNPCModel.backdrop:Hide() end
	if QuestNPCModelTextFrame.backdrop then QuestNPCModelTextFrame.backdrop:Hide() end

	local npcbd = CreateFrame("Frame", nil, QuestNPCModel)
	npcbd:SetPoint("TOPLEFT", -1, 1)
	npcbd:SetPoint("RIGHT", 2, 0)
	npcbd:SetPoint("BOTTOM", QuestNPCModelTextScrollFrame)
	npcbd:SetFrameLevel(0)
	MERS:CreateBD(npcbd)
	npcbd:Styling()

	local npcLine = CreateFrame("Frame", nil, QuestNPCModel)
	npcLine:SetPoint("BOTTOMLEFT", 0, -1)
	npcLine:SetPoint("BOTTOMRIGHT", 1, -1)
	npcLine:SetHeight(1)
	npcLine:SetFrameLevel(0)
	MERS:CreateBD(npcLine, 0)

	-- Text Color
	QuestNPCModelNameText:SetTextColor(1, 1, 1)
	QuestNPCModelText:SetTextColor(1, 1, 1)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, _, x, y)
		if parentFrame == QuestLogPopupDetailFrame or parentFrame == QuestFrame then
			x = x + 3
		end

		QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, y)
	end)

	-- Text Color
	QuestProgressRequiredItemsText:SetTextColor(1, 1, 1)
	QuestProgressRequiredItemsText:SetShadowColor(0, 0, 0)
	QuestProgressTitleText:SetTextColor(1, 1, 1)
	QuestProgressTitleText:SetShadowColor(0, 0, 0)
	QuestProgressTitleText.SetTextColor = MER.dummy
	QuestProgressText:SetTextColor(1, 1, 1)
	QuestProgressText.SetTextColor = MER.dummy
	GreetingText:SetTextColor(1, 1, 1)
	GreetingText.SetTextColor = MER.dummy
	AvailableQuestsText:SetTextColor(1, 1, 1)
	AvailableQuestsText.SetTextColor = MER.dummy
	AvailableQuestsText:SetShadowColor(0, 0, 0)
	CurrentQuestsText:SetTextColor(1, 1, 1)
	CurrentQuestsText.SetTextColor = MER.dummy
	CurrentQuestsText:SetShadowColor(0, 0, 0)
end

S:AddCallback("mUIQuestFrame", styleQuestFrame)