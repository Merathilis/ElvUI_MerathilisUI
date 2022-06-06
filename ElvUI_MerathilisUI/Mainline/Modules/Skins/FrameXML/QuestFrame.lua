local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local unpack = unpack
local strfind = strfind
local gsub = string.gsub

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

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

local function LoadSkin()
	if not module:CheckDB("quest", "quest") then
		return
	end

	local QuestFrame = _G.QuestFrame
	_G.QuestFrameDetailPanelBg:SetAlpha(0)

	-- Stop here if parchment reomover is enabled.
	if E.private.skins.parchmentRemoverEnable then return end

	------------------------
	--- QuestDetailFrame ---
	------------------------
	_G.QuestDetailScrollFrame:StripTextures(true)
	_G.QuestDetailScrollFrame:HookScript("OnUpdate", function(self)
		self:DisableDrawLayer("BACKGROUND")
		if self.backdrop then
			self.backdrop:Hide()
		end
	end)

	if _G.QuestDetailScrollFrame.spellTex then
		if not E.private.skins.parchmentRemoverEnable then
			_G.QuestDetailScrollFrame.spellTex:SetTexture("")
		end
	end

	------------------------
	--- QuestFrameReward ---
	------------------------
	hooksecurefunc(S, "QuestInfo_StyleScrollFrame", function(S, scrollFrame, widthOverride, heightOverride, inset)
		if scrollFrame.spellTex then
			scrollFrame.spellTex:SetTexture(nil)
		end

		if scrollFrame.backdrop then
			scrollFrame.backdrop:Hide()
		end
	end)

	--------------------------
	--- QuestFrameProgress ---
	--------------------------
	_G.QuestFrame:Styling()
	MER:CreateBackdropShadow(_G.QuestFrame)

	_G.QuestProgressScrollFrame:HookScript("OnShow", function(self)
		if self.backdrop then
			self.backdrop:Hide()
		end
		if not E.private.skins.parchmentRemoverEnable then
			self.spellTex:SetTexture("")
			self:Height(self:GetHeight() - 2)
		end
	end)

	--------------------------
	--- QuestGreetingFrame ---
	--------------------------
	_G.QuestFrameGreetingPanel:HookScript('OnShow', UpdateGreetingFrame)
	hooksecurefunc("QuestFrameGreetingPanel_OnShow", UpdateGreetingFrame)

	hooksecurefunc('QuestFrameProgressItems_Update', function()
		_G.QuestProgressRequiredItemsText:SetTextColor(1, .8, .1)
		_G.QuestProgressRequiredMoneyText:SetTextColor(1, 1, 1)
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
		if self.backdrop then
			self.backdrop:Hide()
		end
		if not E.private.skins.parchmentRemoverEnable then
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

		module:CreateBD(bu, .25)

		na:Hide()
		co:SetDrawLayer("OVERLAY")

		local line = CreateFrame("Frame", nil, bu)
		line:SetSize(1, 40)
		line:SetPoint("RIGHT", ic, 1, 0)
		module:CreateBD(line)
	end

	_G.QuestDetailScrollFrame:SetWidth(302) -- else these buttons get cut off

	MER.NPC:Register(QuestFrame)
end

S:AddCallback("QuestFrame", LoadSkin)
