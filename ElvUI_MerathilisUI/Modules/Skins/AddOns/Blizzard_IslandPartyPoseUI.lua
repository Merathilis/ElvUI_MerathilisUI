local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G
local unpack = unpack

function module:Blizzard_IslandsPartyPoseUI()
	if not module:CheckDB("islandsPartyPose", "IslandsPartyPose") then
		return
	end

	local IslandsPartyPoseFrame = _G.IslandsPartyPoseFrame
	module:CreateBackdropShadow(IslandsPartyPoseFrame)

	IslandsPartyPoseFrame.ModelScene:StripTextures()
	module:CreateBDFrame(IslandsPartyPoseFrame.ModelScene, 0.25)

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
