local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local next, select = next, select

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local IsInJailersTower = IsInJailersTower

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.playerChoice) or E.private.muiSkins.blizzard.playerChoice ~= true then return end

	local frame = _G.PlayerChoiceFrame

	hooksecurefunc(frame, "Update", function(self)
		if frame.backdrop then
			frame.backdrop:Styling()
		end
		MER:CreateBackdropShadow(frame)

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
			local hasArtworkBorderArt = option.ArtworkBorder:IsShown() or option.ArtworkBorderDisabled:IsShown()
			option.Background:SetAlpha(0)

			if not option.Background.backdrop then
				option.Background:CreateBackdrop('Transparent')
				option.Background.backdrop:Point('TOPLEFT', option.Background, 'TOPLEFT', 2, 2)
				option.Background.backdrop:Point('BOTTOMRIGHT', option.Background, 'BOTTOMRIGHT', -2, -2)
				MERS:CreateGradient(option.Background.backdrop)
			end
			option.Background.backdrop:SetShown(IsInJailersTower() and not hasArtworkBorderArt)

			option.Header.Text:SetTextColor(1, .8, 0)
			option.OptionText:SetTextColor(1, 1, 1)
			option.Header.Ribbon:SetAlpha(0)
			option.ArtworkBorder:SetAlpha(0)
			option.ArtworkBorderDisabled:SetAlpha(0)

			if not option.ArtBackdrop then
				option.ArtBackdrop = CreateFrame("Frame", nil, option, 'BackdropTemplate')
				option.ArtBackdrop:SetFrameLevel(option:GetFrameLevel())
				option.ArtBackdrop:SetPoint("TOPLEFT", option.Artwork, -2, 2)
				option.ArtBackdrop:SetPoint("BOTTOMRIGHT", option.Artwork, 2, -2)
				option.ArtBackdrop:SetTemplate('Transparent')
			end
			option.ArtBackdrop:SetShown(not IsInJailersTower() and hasArtworkBorderArt)

			if option.WidgetContainer.widgetFrames then
				for _, widgetFrame in next, option.WidgetContainer.widgetFrames do
					if widgetFrame.widgetType == _G.Enum.UIWidgetVisualizationType.TextWithState then
						widgetFrame.Text:SetTextColor(1, 1, 1)

					elseif widgetFrame.widgetType == _G.Enum.UIWidgetVisualizationType.SpellDisplay then
						local _, g = widgetFrame.Spell.Text:GetTextColor()
						if g < 0.2 then
							widgetFrame.Spell.Text:SetTextColor(1, 1, 1)
						end

						widgetFrame.Spell.Border:Hide()
						widgetFrame.Spell.IconMask:Hide()

						if widgetFrame.Spell.Icon:GetWidth() < 25 then
							widgetFrame.Spell.Icon:SetSize(20, 20)
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
