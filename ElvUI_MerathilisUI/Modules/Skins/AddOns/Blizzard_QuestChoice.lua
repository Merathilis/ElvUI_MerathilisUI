local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G
local unpack, select = unpack, select

function module:Blizzard_QuestChoice()
	if not module:CheckDB("questChoice", "questChoice") then
		return
	end

	local QuestChoiceFrame = _G.QuestChoiceFrame
	QuestChoiceFrame:StripTextures()

	if QuestChoiceFrame.backdrop then
		QuestChoiceFrame.backdrop:Hide()
	end

	QuestChoiceFrame:CreateBackdrop("Transparent")
	module:CreateBackdropShadow(QuestChoiceFrame)

	for i = 1, 15 do
		select(i, QuestChoiceFrame:GetRegions()):Hide()
	end

	for i = 17, 19 do
		select(i, QuestChoiceFrame:GetRegions()):Hide()
	end

	for i = 1, #QuestChoiceFrame.Options do
		local option = QuestChoiceFrame["Option" .. i]
		local rewards = option.Rewards
		local item = rewards.Item
		local currencies = rewards.Currencies

		option.Header.Background:Hide()
		option.Header.Text:SetTextColor(0.9, 0.9, 0.9)

		option.Artwork:SetTexCoord(0.140625, 0.84375, 0.2265625, 0.78125)
		option.Artwork:SetSize(180, 71)
		option.Artwork:SetPoint("TOP", 0, -20)
		option.OptionText:SetTextColor(0.9, 0.9, 0.9)

		item.Name:SetTextColor(1, 1, 1)
		item.Icon:SetTexCoord(unpack(E.TexCoords))
		item.bg = module:CreateBG(item.Icon)

		for j = 1, 3 do
			local cu = currencies["Currency" .. j]

			cu.Icon:SetTexCoord(unpack(E.TexCoords))
			module:CreateBG(cu.Icon)
		end
	end
end

module:AddCallbackForAddon("Blizzard_QuestChoice")
