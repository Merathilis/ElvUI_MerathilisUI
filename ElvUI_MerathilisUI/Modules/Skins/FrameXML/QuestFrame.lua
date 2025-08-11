local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule("Skins")
local M = MER:GetModule("MER_Misc")

local _G = _G
local strfind = strfind
local gsub = string.gsub

local hooksecurefunc = hooksecurefunc
local GetQuestItemInfo = GetQuestItemInfo
local GetQuestRequiredCurrencyInfo = C_QuestOffer.GetQuestRequiredCurrencyInfo

-- Copied from ElvUI
local function UpdateGreetingFrame()
	for Button in _G.QuestFrameGreetingPanel.titleButtonPool:EnumerateActive() do
		Button.Icon:SetDrawLayer("ARTWORK")
		local Text = Button:GetFontString():GetText()
		if Text and strfind(Text, "|cff000000") then
			Button:GetFontString():SetText(gsub(Text, "|cff000000", "|cffffe519"))
		end
	end
end

local function UpdateProgressItemQuality(self)
	local button = self.__owner
	local index = button:GetID()
	local buttonType = button.type
	local objectType = button.objectType

	local quality
	if objectType == "item" then
		quality = select(4, GetQuestItemInfo(buttonType, index))
	elseif objectType == "currency" then
		local info = GetQuestRequiredCurrencyInfo(index)
		quality = info and info.quality
	end

	local color = E:GetItemQualityColor(quality or 1)
	button.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
end

function module:QuestFrame()
	if not module:CheckDB("quest", "quest") then
		return
	end

	local QuestFrame = _G.QuestFrame
	_G.QuestFrameDetailPanelBg:SetAlpha(0)

	module:CreateShadow(QuestFrame)

	-- Stop here if parchment reomover is enabled.
	if E.private.skins.parchmentRemoverEnable then
		return
	end

	--------------------------
	--- QuestGreetingFrame ---
	--------------------------
	_G.QuestFrameGreetingPanel:HookScript("OnShow", UpdateGreetingFrame)
	hooksecurefunc("QuestFrameGreetingPanel_OnShow", UpdateGreetingFrame)

	hooksecurefunc("QuestFrameProgressItems_Update", function()
		_G.QuestProgressRequiredItemsText:SetTextColor(1, 0.8, 0.1)
	end)

	hooksecurefunc(_G.QuestProgressRequiredMoneyText, "SetTextColor", function(self, r)
		if r == 0 then
			self:SetTextColor(0.8, 0.8, 0.8)
		elseif r == 0.2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	hooksecurefunc("QuestFrame_SetTitleTextColor", function(fontString)
		fontString:SetTextColor(1, 0.8, 0.1)
	end)

	hooksecurefunc("QuestFrame_SetTextColor", function(fontString)
		fontString:SetTextColor(1, 1, 1)
	end)

	local QuestInfoRewardsFrame = _G.QuestInfoRewardsFrame
	if QuestInfoRewardsFrame.spellHeaderPool then
		for _, pool in ipairs({ "followerRewardPool", "spellRewardPool" }) do
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
		if self.backdrop then
			self.backdrop:Hide()
		end
		if not E.private.skins.parchmentRemoverEnable then
			self.spellTex:SetTexture("")
			self:Height(self:GetHeight() - 2)
		end
	end)

	for i = 1, _G.MAX_REQUIRED_ITEMS do
		local button = _G["QuestProgressItem" .. i]
		button.NameFrame:Hide()

		S:HandleIcon(button.Icon, true)
		button.Icon.__owner = button
		hooksecurefunc(button.Icon, "SetTexture", UpdateProgressItemQuality)
	end

	_G.QuestDetailScrollFrame:SetWidth(302) -- else these buttons get cut off

	module:CreateShadow(_G.QuestModelScene)
	module:CreateShadow(_G.QuestNPCModelTextFrame)

	-- Friendship
	for i = 1, 4 do
		local notch = QuestFrame.FriendshipStatusBar["Notch" .. i]
		if notch then
			notch:SetColorTexture(0, 0, 0)
			notch:SetSize(E.mult, 16)
		end
	end
	QuestFrame.FriendshipStatusBar.BarBorder:Hide()

	M.NPC:Register(QuestFrame, _G.QuestFrameNpcNameText)
end

module:AddCallback("QuestFrame")
