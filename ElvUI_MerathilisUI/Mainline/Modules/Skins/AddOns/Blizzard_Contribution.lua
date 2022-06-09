local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not module:CheckDB("contribution", "contribution") then
		return
	end

	--Main Frame
	_G.ContributionCollectionFrame:StripTextures()
	module:CreateBD(_G.ContributionCollectionFrame, .25)
	_G.ContributionCollectionFrame:Styling()
	MER:CreateBackdropShadow(_G.ContributionCollectionFrame)

	local function styleText(self)
		self.Description:SetVertexColor(1, 1, 1)
	end
	hooksecurefunc(_G.ContributionMixin, "Setup", styleText)

	local function styleRewardText(self)
		self.RewardName:SetTextColor(1, 1, 1)
	end
	hooksecurefunc(_G.ContributionRewardMixin, "Setup", styleRewardText)
end

S:AddCallbackForAddon("Blizzard_Contribution", LoadSkin)
