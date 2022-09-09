local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function HookTextColor_Yellow(self, r, g, b)
	if r ~= 1 or g ~= .8 or b ~= 0 then
		self:SetTextColor(1, .8, 0)
	end
end

local function SetTextColor_Yellow(font)
	font:SetShadowColor(0, 0, 0, 0)
	font:SetTextColor(1, .8, 0)
	hooksecurefunc(font, "SetTextColor", HookTextColor_Yellow)
end

local function HookTextColor_White(self, r, g, b)
	if r ~= 1 or g ~= 1 or b ~= 1 then
		self:SetTextColor(1, 1, 1)
	end
end

local function SetTextColor_White(font)
	font:SetShadowColor(0, 0, 0)
	font:SetTextColor(1, 1, 1)
	hooksecurefunc(font, "SetTextColor", HookTextColor_White)
end

local function LoadSkin()
	if not module:CheckDB("quest", "quest") then
		return
    end

	-- Change text colors
	hooksecurefunc(QuestInfoRequiredMoneyText, "SetTextColor", function(self, r)
		if r == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif r == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	local yellowish = {
		QuestInfoTitleHeader,
		QuestInfoDescriptionHeader,
		QuestInfoObjectivesHeader,
		QuestInfoRewardsFrame.Header,
	}
	for _, font in pairs(yellowish) do
		SetTextColor_Yellow(font)
	end

	local whitish = {
		QuestInfoDescriptionText,
		QuestInfoObjectivesText,
		QuestInfoGroupSize,
		QuestInfoRewardText,
		QuestInfoSpellObjectiveLearnLabel,
		QuestInfoRewardsFrame.ItemChooseText,
		QuestInfoRewardsFrame.ItemReceiveText,
		QuestInfoRewardsFrame.PlayerTitleText,
		QuestInfoRewardsFrame.XPFrame.ReceiveText,
		QuestInfoTalentFrame.ReceiveText,
	}
	for _, font in pairs(whitish) do
		SetTextColor_White(font)
	end
end

S:AddCallback("QuestInfo", LoadSkin)
