local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G
local unpack = unpack

function module:Blizzard_IslandsPartyPoseUISkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.islandsPartyPose ~= true or E.private.mui.skins.blizzard.IslandsPartyPose ~= true then return end

	local IslandsPartyPoseFrame = _G.IslandsPartyPoseFrame
	IslandsPartyPoseFrame:Styling()
	MER:CreateBackdropShadow(IslandsPartyPoseFrame)

	IslandsPartyPoseFrame.ModelScene:StripTextures()
	module:CreateBDFrame(IslandsPartyPoseFrame.ModelScene, .25)

	IslandsPartyPoseFrame.Background:Hide()

	local rewardFrame = IslandsPartyPoseFrame.RewardAnimations.RewardFrame
	local bg = module:CreateBDFrame(rewardFrame)
	bg:SetPoint("TOPLEFT", -5, 5)
	bg:SetPoint("BOTTOMRIGHT", rewardFrame.NameFrame, 0, -5)

	rewardFrame.NameFrame:SetAlpha(0)
	rewardFrame.IconBorder:SetAlpha(0)
	rewardFrame.Icon:SetTexCoord(unpack(E.TexCoords))
	module:CreateBDFrame(rewardFrame.Icon)
end

module:AddCallbackForAddon("Blizzard_IslandsPartyPoseUI")
