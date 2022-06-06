local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local unpack = unpack

local function LoadSkin()
	if not module:CheckDB("IslandsPartyPose", "islandsPartyPose") then
		return
	end

	local WarfrontsPartyPoseFrame = _G.WarfrontsPartyPoseFrame
	WarfrontsPartyPoseFrame:Styling()
	MER:CreateShadow(WarfrontsPartyPoseFrame)

	WarfrontsPartyPoseFrame.ModelScene:SetAlpha(.8)
	WarfrontsPartyPoseFrame.OverlayElements.Topper:Hide()
	WarfrontsPartyPoseFrame.Background:Hide()
	WarfrontsPartyPoseFrame.Border:Hide()

	local rewardFrame = WarfrontsPartyPoseFrame.RewardAnimations.RewardFrame
	-- Hide ElvUI's backdrop
	if rewardFrame.backdrop then rewardFrame.backdrop:Hide() end

	local bg = module:CreateBDFrame(rewardFrame)
	bg:SetPoint("TOPLEFT", -5, 5)
	bg:SetPoint("BOTTOMRIGHT", rewardFrame.NameFrame, 0, -5)

	rewardFrame.NameFrame:SetAlpha(0)
	rewardFrame.IconBorder:SetAlpha(0)
	rewardFrame.Icon:SetTexCoord(unpack(E.TexCoords))

	module:CreateBDFrame(rewardFrame.Icon)
end

S:AddCallbackForAddon("Blizzard_WarfrontsPartyPoseUI", LoadSkin)
