local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local unpack, select = unpack, select
-- WoW API / Variables
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.questChoice ~= true or E.private.muiSkins.blizzard.questChoice ~= true then return; end

	local QuestChoiceFrame = _G.QuestChoiceFrame

	QuestChoiceFrame:StripTextures()

	if QuestChoiceFrame.backdrop then
		QuestChoiceFrame.backdrop:Hide()
	end

	MERS:CreateBD(QuestChoiceFrame, .5)
	QuestChoiceFrame:Styling()

	for i = 1, 15 do
		select(i, QuestChoiceFrame:GetRegions()):Hide()
	end

	for i = 17, 19 do
		select(i, QuestChoiceFrame:GetRegions()):Hide()
	end

	for i = 1, #QuestChoiceFrame.Options do
		local option = QuestChoiceFrame["Option"..i]
		local rewards = option.Rewards
		local item = rewards.Item
		local currencies = rewards.Currencies

		option.Header.Background:Hide()
		option.Header.Text:SetTextColor(.9, .9, .9)

		option.Artwork:SetTexCoord(0.140625, 0.84375, 0.2265625, 0.78125)
		option.Artwork:SetSize(180, 71)
		option.Artwork:SetPoint("TOP", 0, -20)
		option.OptionText:SetTextColor(.9, .9, .9)

		item.Name:SetTextColor(1, 1, 1)
		item.Icon:SetTexCoord(unpack(E.TexCoords))
		item.bg = MERS:CreateBG(item.Icon)

		for j = 1, 3 do
			local cu = currencies["Currency"..j]

			cu.Icon:SetTexCoord(unpack(E.TexCoords))
			MERS:CreateBG(cu.Icon)
		end
	end
end

S:AddCallbackForAddon("Blizzard_QuestChoice", "mUIQuestChoice", LoadSkin)
