local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local hooksecurefunc = hooksecurefunc

local function ReskinOptionText(text, r, g, b)
	if text then
		text:SetTextColor(r, g, b)
	end
end

local function handleItemButton(item)
	if not item then
		return
	end

	if item then
		item:SetTemplate()
		item:SetHeight(41)
		item:OffsetFrameLevel(2)
	end

	if item.Icon then
		item.Icon:Size(E.PixelMode and 35 or 32)
		item.Icon:SetDrawLayer("ARTWORK")
		item.Icon:Point("TOPLEFT", E.PixelMode and 2 or 4, -(E.PixelMode and 2 or 4))
		S:HandleIcon(item.Icon)
	end

	if item.IconBorder then
		S:HandleIconBorder(item.IconBorder)
	end

	if item.Count then
		item.Count:SetDrawLayer("OVERLAY")
		item.Count:ClearAllPoints()
		item.Count:SetPoint("BOTTOMRIGHT", item.Icon, "BOTTOMRIGHT", 0, 0)
	end

	if item.NameFrame then
		item.NameFrame:SetAlpha(0)
		item.NameFrame:Hide()
	end

	if item.IconOverlay then
		item.IconOverlay:SetAlpha(0)
	end

	if item.Name then
		item.Name:FontTemplate()
	end

	if item.CircleBackground then
		item.CircleBackground:SetAlpha(0)
		item.CircleBackgroundGlow:SetAlpha(0)
	end

	for _, Region in next, { item:GetRegions() } do
		if Region:IsObjectType("Texture") and Region:GetTexture() == [[Interface\Spellbook\Spellbook-Parts]] then
			Region:SetTexture(E.ClearTexture)
		end
	end
end

local function SetupOptions(frame)
	if not frame.__MERSkin then
		module:CreateShadow(frame)

		if frame.shadow then
			frame.shadow:SetShown(frame.template and frame.template == "Transparent")
			hooksecurefunc(frame, "SetTemplate", function(_, template)
				frame.shadow:SetShown(template and template == "Transparent")
			end)
		end
	end

	if frame.optionFrameTemplate and frame.optionPools then
		for option in frame.optionPools:EnumerateActiveByTemplate(frame.optionFrameTemplate) do
			if option.WidgetContainer then
				for _, widget in pairs(option.WidgetContainer.widgetFrames) do
					if widget.Text then
						F.SetFontOutline(widget.Text)
					end
					if widget.Item then
						handleItemButton(widget.Item)
					end
				end
			end
		end
	end
end

function module:Blizzard_PlayerChoice()
	if not module:CheckDB("playerChoice", "playerChoice") then
		return
	end

	if not E.private.skins.parchmentRemoverEnable then
		return
	end

	hooksecurefunc(_G.PlayerChoiceFrame, "TryShow", function(self)
		if not self.optionFrameTemplate then
			return
		end

		for optionFrame in self.optionPools:EnumerateActiveByTemplate(self.optionFrameTemplate) do
			local header = optionFrame.Header
			if header then
				ReskinOptionText(header.Text, 1, 0.8, 0)
				if header.Contents then
					ReskinOptionText(header.Contents.Text, 1, 0.8, 0)
				end
			end
			ReskinOptionText(optionFrame.OptionText, 1, 1, 1)
			F.ReplaceIconString(optionFrame.OptionText.String)

			local rewards = optionFrame.Rewards
			if rewards then
				for rewardFrame in
					rewards.rewardsPool:EnumerateActiveByTemplate("PlayerChoiceBaseOptionItemRewardTemplate")
				do
					ReskinOptionText(rewardFrame.Name, 0.9, 0.8, 0.5)
				end

				for rewardFrame in rewards.rewardsPool:EnumerateActive() do
					local text = rewardFrame.Name or rewardFrame.Text
					if text then
						ReskinOptionText(text, 0.9, 0.8, 0.5)
					end
				end
			end
		end
	end)

	hooksecurefunc(_G.PlayerChoiceFrame, "SetupOptions", SetupOptions)
end

module:AddCallbackForAddon("Blizzard_PlayerChoice")
