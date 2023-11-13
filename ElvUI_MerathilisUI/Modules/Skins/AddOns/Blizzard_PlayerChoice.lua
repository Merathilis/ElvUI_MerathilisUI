local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc

local function ReskinOptionText(text, r, g, b)
	if text then
		text:SetTextColor(r, g, b)
	end
end

local function SetupOptions(frame)
	if frame.__MERSkin then
		return
	end

	module:CreateShadow(frame)
	if frame.MERshadow then
		frame.MERshadow:SetShown(frame.template and frame.template == "Transparent")

		hooksecurefunc(frame, "SetTemplate", function(_, template)
			frame.MERshadow:SetShown(template and template == "Transparent")
		end)
	end

	frame.__MERSkin = true
end

function module:Blizzard_PlayerChoice()
	if not module:CheckDB('playerChoice', 'playerChoice') then
		return
	end

	hooksecurefunc(_G.PlayerChoiceFrame, "TryShow", function(self)
		if not self.optionFrameTemplate then return end

		for optionFrame in self.optionPools:EnumerateActiveByTemplate(self.optionFrameTemplate) do
			local header = optionFrame.Header
			if header then
				ReskinOptionText(header.Text, 1, .8, 0)
				if header.Contents then
					ReskinOptionText(header.Contents.Text, 1, .8, 0)
				end
			end
			ReskinOptionText(optionFrame.OptionText, 1, 1, 1)
			F.ReplaceIconString(optionFrame.OptionText.String)

			local rewards = optionFrame.Rewards
			if rewards then
				for rewardFrame in rewards.rewardsPool:EnumerateActiveByTemplate("PlayerChoiceBaseOptionItemRewardTemplate") do
					ReskinOptionText(rewardFrame.Name, .9, .8, .5)
				end

				for rewardFrame in rewards.rewardsPool:EnumerateActive() do
					local text = rewardFrame.Name or rewardFrame.Text
					if text then
						ReskinOptionText(text, .9, .8, .5)
					end
				end
			end
		end
	end)

	hooksecurefunc(_G.PlayerChoiceFrame, "SetupOptions", SetupOptions)
end

module:AddCallbackForAddon("Blizzard_PlayerChoice")
