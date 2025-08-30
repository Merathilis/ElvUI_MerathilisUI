local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

local function styleText(self)
	self.Description:SetVertexColor(1, 1, 1, 1)
end

local function styleRewardText(self)
	self.RewardName:SetTextColor(1, 1, 1)
end

function module:Blizzard_Contribution()
	if not module:CheckDB("contribution", "contribution") then
		return
	end

	--Main Frame
	_G.ContributionCollectionFrame:StripTextures()
	_G.ContributionCollectionFrame:SetTemplate("Transparent")
	module:CreateBackdropShadow(_G.ContributionCollectionFrame)

	hooksecurefunc(_G.ContributionMixin, "Setup", styleText)
	hooksecurefunc(_G.ContributionRewardMixin, "Setup", styleRewardText)
end

module:AddCallbackForAddon("Blizzard_Contribution")
