local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G
local unpack = unpack

function module:Blizzard_WarfrontsPartyPoseUI()
	if not module:CheckDB("IslandsPartyPose", "islandsPartyPose") then
		return
	end

	local WarfrontsPartyPoseFrame = _G.WarfrontsPartyPoseFrame
	module:CreateShadow(WarfrontsPartyPoseFrame)

	WarfrontsPartyPoseFrame.ModelScene:SetAlpha(0.8)
	WarfrontsPartyPoseFrame.OverlayElements.Topper:Hide()
	WarfrontsPartyPoseFrame.Background:Hide()
	WarfrontsPartyPoseFrame.Border:Hide()

	local rewardFrame = WarfrontsPartyPoseFrame.RewardAnimations.RewardFrame
	-- Hide ElvUI's backdrop
	if rewardFrame.backdrop then
		rewardFrame.backdrop:Hide()
	end

	local bg = module:CreateBDFrame(rewardFrame)
	bg:SetPoint("TOPLEFT", -5, 5)
	bg:SetPoint("BOTTOMRIGHT", rewardFrame.NameFrame, 0, -5)

	rewardFrame.NameFrame:SetAlpha(0)
	rewardFrame.IconBorder:SetAlpha(0)
	rewardFrame.Icon:SetTexCoord(unpack(E.TexCoords))

	module:CreateBDFrame(rewardFrame.Icon)
end

module:AddCallbackForAddon("Blizzard_WarfrontsPartyPoseUI")
