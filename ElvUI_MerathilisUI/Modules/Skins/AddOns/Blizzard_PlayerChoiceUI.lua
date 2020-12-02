local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local select = select

local hooksecurefunc = hooksecurefunc

local function WhiteProgressText(self)
	if self.IsSkinned then return end

	self:SetTextColor(1, 1, 1)
	self.SetTextColor = E.noop
	self.IsSkinned = true
end

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.playerChoice) or E.private.muiSkins.blizzard.playerChoice ~= true then return end

	local frame = _G.PlayerChoiceFrame

	hooksecurefunc(frame, "Update", function(self)
		if frame.backdrop then
			frame.backdrop:Styling()
		end

		if not frame.IsSkinned then
			frame:StripTextures()
			self.BlackBackground:SetAlpha(0)
			self.Background:SetAlpha(0)
			self.NineSlice:SetAlpha(0)
			self.Title:DisableDrawLayer("BACKGROUND")
			self.Title:CreateBackdrop('Transparent')
			self.Title.Text:SetTextColor(1, .8, 0)
			self.Title.Text:SetFontObject(SystemFont_Huge1)
			self.Title.Text:SetShadowOffset(1, 1)
			self.BorderFrame.Header:SetAlpha(0)
		end

		for i = 1, self:GetNumOptions() do
			local option = self.Options[i]
			option.Background:SetAlpha(0)
			if not option.Background.backdrop then
				option.Background:CreateBackdrop('Transparent')
				option.Background.backdrop:Point('TOPLEFT', option.Background, 'TOPLEFT', 2, 2)
				option.Background.backdrop:Point('BOTTOMRIGHT', option.Background, 'BOTTOMRIGHT', -2, -2)
				MERS:CreateGradient(option.Background.backdrop)
			end
			option.Header.Ribbon:SetAlpha(0)

			option.Header.Text:SetTextColor(1, .8, 0)
			option.OptionText:SetTextColor(1, 1, 1)

			for i = 1, option.WidgetContainer:GetNumChildren() do
				local child = select(i, option.WidgetContainer:GetChildren())
				if child.Text then
					child.Text:SetTextColor(1, 1, 1)
				end

				if child.Spell then
					child.Spell.Text:SetTextColor(1, 1, 1)
				end

				for j = 1, child:GetNumChildren() do
					local child2 = select(j, child:GetChildren())
					if child2 then
						if child2.Text then
							WhiteProgressText(child2.Text)
						end
						if child2.LeadingText then
							WhiteProgressText(child2.LeadingText)
						end
					end
				end
			end
		end
	end)

	hooksecurefunc(frame, "SetupRewards", function(self)
		for i = 1, self.numActiveOptions do
			local optionFrameRewards = self.Options[i].RewardsFrame.Rewards
			for button in optionFrameRewards.ItemRewardsPool:EnumerateActive() do
				if not button.IsSkinned then
					button.Name:SetTextColor(.9, .8, .5)
					button.IconBorder:SetAlpha(0)

					button.IsSkinned = true
				end
			end
		end
		--[[
			optionFrameRewards.CurrencyRewardsPool
			optionFrameRewards.ReputationRewardsPool
		]]
	end)
end

S:AddCallbackForAddon("Blizzard_PlayerChoiceUI", "mUIPlayerChoice", LoadSkin)
