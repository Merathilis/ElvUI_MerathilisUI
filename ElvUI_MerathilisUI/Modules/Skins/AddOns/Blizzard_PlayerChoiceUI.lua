local MER, E, L, V, P, G = unpack(select(2, ...))
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

		for i = 1, self:GetNumOptions() do
			local option = self.Options[i]
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
end

S:AddCallbackForAddon("Blizzard_PlayerChoiceUI", "mUIPlayerChoice", LoadSkin)
