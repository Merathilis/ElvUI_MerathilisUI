local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
--WoW API / Variables

local function styleContribution()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Contribution ~= true or E.private.muiSkins.blizzard.contribution ~= true then return end

	--Main Frame
	ContributionCollectionFrame:StripTextures()

	local function styleText(self)
		self.Description:SetVertexColor(1, 1, 1)
	end
	hooksecurefunc(ContributionMixin, "Setup", styleText)

	local function styleRewardText(self)
		self.RewardName:SetTextColor(1, 1, 1)
	end
	hooksecurefunc(ContributionRewardMixin, "Setup", styleRewardText)
end

S:AddCallbackForAddon("Blizzard_Contribution", "mUIContribution", styleContribution)