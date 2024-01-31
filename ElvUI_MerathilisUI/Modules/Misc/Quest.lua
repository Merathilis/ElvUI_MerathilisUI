local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Misc')

local _G = _G
local select = select

local GetItemInfo = GetItemInfo
local GetQuestItemLink = GetQuestItemLink
local GetNumQuestChoices = GetNumQuestChoices

local function SelectQuestReward(index)
	local rewardsFrame = _G["QuestInfoFrame"].rewardsFrame

	local btn = QuestInfo_GetRewardButton(rewardsFrame, index)
	if (btn.type == "choice") then
		_G.QuestInfoItemHighlight:ClearAllPoints()
		_G.QuestInfoItemHighlight:SetOutside(btn.Icon)

		if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true then
			_G.QuestInfoItemHighlight:SetPoint("TOPLEFT", btn, "TOPLEFT", -8, 7)
		else
			btn.Name:SetTextColor(1, 1, 0)
		end
		_G.QuestInfoItemHighlight:Show()

		-- set choice
		_G["QuestInfoFrame"].itemChoice = btn:GetID()
	end
end

function module:QUEST_COMPLETE()
	-- default first button when no item has a sell value.
	local choice, price = 1, 0
	local num = GetNumQuestChoices()

	if num <= 0 then
		return -- no choices, quick exit
	end

	for index = 1, num do
		local link = GetQuestItemLink("choice", index)
		if (link) then
			local vsp = select(11, GetItemInfo(link))
			if vsp and vsp > price then
				price = vsp
				choice = index
			end
		end
	end
	SelectQuestReward(choice)
end

function module:Quest()
	-- Make sure the table exist
	if not E.db.mui.misc.quest then
		E.db.mui.misc.quest = {}
	end

	if E.db.mui.misc.quest.selectQuestReward then
		self:RegisterEvent("QUEST_COMPLETE")
	end
end

module:AddCallback("Quest")
