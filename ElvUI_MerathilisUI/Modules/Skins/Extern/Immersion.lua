local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local select, unpack = select, unpack

local GetQuestItemInfo = GetQuestItemInfo
local hooksecurefunc = hooksecurefunc

local C_QuestInfoSystem_GetQuestRewardSpells = C_QuestInfoSystem.GetQuestRewardSpells

local function updateItemBorder(self)
	if not self.bg then
		return
	end

	if self.objectType == "item" then
		local quality = select(4, GetQuestItemInfo(self.type, self:GetID()))
		local color = E.QualityColors[quality or 1]
		self.bg:SetBackdropBorderColor(color.r, color.g, color.b)
	elseif self.objectType == "currency" and self.currencyInfo then
		local _, _, _, quality = CurrencyContainerUtil.GetCurrencyContainerInfo(
			self.currencyInfo.currencyID,
			self.currencyInfo.displayedAmount,
			self.currencyInfo.name,
			self.currencyInfo.texture,
			self.currencyInfo.quality
		)
		local color = E.QualityColors[quality or 1]
		self.bg:SetBackdropBorderColor(color.r, color.g, color.b)
	else
		self.bg:SetBackdropBorderColor(0, 0, 0)
	end
end

local function reskinItemButton(self)
	if not self.textBg then
		self.Border:Hide()
		self.Mask:Hide()
		self.NameFrame:Hide()
		self.NameFrame:CreateBackdrop("Transparent")
		self.NameFrame.backdrop:ClearAllPoints()
		self.NameFrame.backdrop:SetOutside(self.NameFrame, -50, -15)
		S:HandleIcon(self.Icon, true)
		module:CreateBackdropShadow(self.NameFrame)

		if self.ItemHighlight then
			self.ItemHighlight:SetOutside(self.NameFrame, -50, -15)
		end
	end
end

local function reskinItemButtons(buttons)
	for i = 1, #buttons do
		local button = buttons[i]
		reskinItemButton(button)
		updateItemBorder(button)
	end
end

function module:Immersion()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.imm then
		return
	end

	module:DisableAddOnSkins("Immersion", false)

	local ImmersionFrame = _G.ImmersionFrame
	if not ImmersionFrame then
		return
	end

	local frame = _G.ImmersionFrame

	-- TalkBox
	local TalkBox = frame.TalkBox

	-- Backdrop
	TalkBox.BackgroundFrame:StripTextures()
	TalkBox:CreateBackdrop("Transparent")
	TalkBox.backdrop:ClearAllPoints()
	TalkBox.backdrop:Point("TOPLEFT", TalkBox, "TOPLEFT", 10, -10)
	TalkBox.backdrop:Point("BOTTOMRIGHT", TalkBox, "BOTTOMRIGHT", -10, 10)
	self:CreateBackdropShadow(TalkBox)

	-- Use colored backdrop edge as highlight
	TalkBox.Hilite:StripTextures()
	TalkBox:HookScript("OnEnter", function(box)
		S.SetModifiedBackdrop(box)

		if box.backdrop.shadow then
			box.backdrop.shadow:SetBackdropBorderColor(box.backdrop:GetBackdropBorderColor())
		end
	end)

	TalkBox:HookScript("OnLeave", function(box)
		S.SetOriginalBackdrop(box)

		if box.backdrop.shadow then
			box.backdrop.shadow:SetBackdropBorderColor(box.backdrop:GetBackdropBorderColor())
		end
	end)

	-- Remove background of model
	TalkBox.PortraitFrame:StripTextures()
	TalkBox.MainFrame.Model.ModelShadow:StripTextures()
	TalkBox.MainFrame.Model.PortraitBG:StripTextures()

	-- No Sheen
	TalkBox.MainFrame.Sheen:StripTextures()
	TalkBox.MainFrame.TextSheen:StripTextures()
	TalkBox.MainFrame.Overlay:StripTextures()

	local ProgressionBar = TalkBox.ProgressionBar
	ProgressionBar:StripTextures()
	ProgressionBar:SetStatusBarTexture(E.media.normTex)
	module:CreateBDFrame(ProgressionBar, 0.25)

	local ReputationBar = TalkBox.ReputationBar
	ReputationBar.icon:SetPoint("TOPLEFT", -30, 6)
	ReputationBar:StripTextures()
	ReputationBar:SetStatusBarTexture(E.media.normTex)
	module:CreateBDFrame(ReputationBar, 0.25)

	-- Backdrop of elements (bottom window)
	local elements = TalkBox.Elements
	elements:SetBackdrop(nil)
	elements:CreateBackdrop("Transparent")
	elements.backdrop:ClearAllPoints()
	elements.backdrop:Point("TOPLEFT", elements, "TOPLEFT", 10, -5)
	elements.backdrop:Point("BOTTOMRIGHT", elements, "BOTTOMRIGHT", -10, 5)
	F.SetFontOutline(elements.Progress.ReqText)
	module:CreateBackdropShadow(elements)

	elements.Content.RewardsFrame.ItemHighlight.Icon:Hide()
	elements.Content.RewardsFrame.ItemHighlight.Icon.Show = function() end

	for i = 1, 4 do
		local notch = ReputationBar["Notch" .. i]
		if notch then
			notch:SetColorTexture(0, 0, 0)
			notch:SetSize(E.mult, 16)
		end
	end

	local Indicator = TalkBox.MainFrame.Indicator
	Indicator:SetScale(1.25)
	Indicator:ClearAllPoints()
	Indicator:Point("RIGHT", TalkBox.MainFrame.CloseButton, "LEFT", -2, 0)

	local TitleButtons = ImmersionFrame.TitleButtons
	hooksecurefunc(TitleButtons, "GetButton", function(self, index)
		local button = self.Buttons[index]
		if button and not button.isSkinned then
			button:StripTextures()
			button.Hilite:StripTextures()
			local HL = module:CreateBDFrame(button.Hilite, 0)
			HL:SetAllPoints(button)
			HL:SetBackdropColor(F.r, F.g, F.b, 0.25)
			HL:SetBackdropBorderColor(F.r, F.g, F.b, 1)
			local bg = module:SetBD(button)
			bg:SetAllPoints()
			button.Overlay:Hide()

			if index > 1 then
				button:ClearAllPoints()
				button:Point("TOP", self.Buttons[index - 1], "BOTTOM", 0, -3)
			end

			button.isSkinned = true
		end
	end)

	hooksecurefunc(ImmersionFrame, "AddQuestInfo", function(self)
		local rewardsFrame = self.TalkBox.Elements.Content.RewardsFrame

		-- Item Rewards
		reskinItemButtons(rewardsFrame.Buttons)

		-- Honor Rewards
		local honorFrame = rewardsFrame.HonorFrame
		if honorFrame then
			reskinItemButton(honorFrame)
		end

		-- Title Rewards
		local titleFrame = rewardsFrame.TitleFrame
		if titleFrame and not titleFrame.textBg then
			local icon = titleFrame.Icon
			titleFrame:StripTextures()
			icon:SetAlpha(1)
			S:HandleIcon(icon)
			titleFrame.textBg = module:CreateBDFrame(titleFrame, 0.25)
			titleFrame.textBg:Point("TOPLEFT", icon, "TOPRIGHT", 2, E.mult)
			titleFrame.textBg:Point("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 216, -E.mult)
		end

		-- ArtifactXP Rewards
		local artifactXPFrame = rewardsFrame.ArtifactXPFrame
		if artifactXPFrame then
			reskinItemButton(artifactXPFrame)
			artifactXPFrame.Overlay:SetAlpha(0)
		end

		-- Skill Point Rewards
		local skillPointFrame = rewardsFrame.SkillPointFrame
		if skillPointFrame then
			reskinItemButton(skillPointFrame)
		end

		local spellRewards = C_QuestInfoSystem_GetQuestRewardSpells(GetQuestID()) or {}
		if #spellRewards > 0 then
			-- Follower Rewards
			for reward in rewardsFrame.followerRewardPool:EnumerateActive() do
				local portrait = reward.PortraitFrame
				if not reward.isSkinned then
					module:ReskinGarrisonPortrait(portrait)
					reward.BG:Hide()
					portrait:Point("TOPLEFT", 2, -5)
					reward.textBg = module:CreateBDFrame(reward, 0.25)
					reward.textBg:Point("TOPLEFT", 0, -3)
					reward.textBg:Point("BOTTOMRIGHT", 2, 7)
					reward.Class:Point("TOPRIGHT", reward.textBg, "TOPRIGHT", -E.mult, -E.mult)
					reward.Class:Point("BOTTOMRIGHT", reward.textBg, "BOTTOMRIGHT", -E.mult, E.mult)

					reward.isSkinned = true
				end

				local color = E.QualityColors[portrait.quality or 1]
				portrait.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
				reward.Class:SetTexCoord(unpack(E.TexCoords))
			end
			-- Spell Rewards
			for spellReward in rewardsFrame.spellRewardPool:EnumerateActive() do
				if not spellReward.textBg then
					local icon = spellReward.Icon
					local nameFrame = spellReward.NameFrame
					S:HandleIcon(icon)
					nameFrame:Hide()
					spellReward.textBg = module:CreateBDFrame(nameFrame, 0.25)
					spellReward.textBg:Point("TOPLEFT", icon, "TOPRIGHT", 2, E.mult)
					spellReward.textBg:Point("BOTTOMRIGHT", nameFrame, "BOTTOMRIGHT", -24, 15)
				end
			end
		end
	end)

	hooksecurefunc(ImmersionFrame, "QUEST_PROGRESS", function(self)
		reskinItemButtons(self.TalkBox.Elements.Progress.Buttons)
	end)

	hooksecurefunc(ImmersionFrame, "ShowItems", function(self)
		for tooltip in self.Inspector.tooltipFramePool:EnumerateActive() do
			if not tooltip.isSkinned then
				-- tooltip:HideBackdrop()
				local bg = module:SetBD(tooltip)
				bg:SetPoint("TOPLEFT", 0, 0)
				bg:SetPoint("BOTTOMRIGHT", 6, 0)
				tooltip.Icon.Border:SetAlpha(0)
				S:HandleIcon(tooltip.Icon.Texture)
				tooltip.Hilite:SetOutside(bg, 2, 2)
				tooltip.isSkinned = true
			end
		end
	end)
end

module:AddCallbackForAddon("Immersion")
