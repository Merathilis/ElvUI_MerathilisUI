local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

local CreateFrame = CreateFrame

function module:RecruitAFriendFrame()
	if not module:CheckDB("friends", "friends") then
		return
	end

	local RecruitAFriendFrame = _G.RecruitAFriendFrame
	local SplashFrame = RecruitAFriendFrame.SplashFrame

	SplashFrame.Background:Hide()
	SplashFrame.PictureFrame:Hide()

	SplashFrame:CreateBackdrop()
	SplashFrame.backdrop:SetPoint("TOPLEFT", 2, -2)
	SplashFrame.backdrop:SetPoint("BOTTOMRIGHT", -1, -1)

	SplashFrame.Description:SetTextColor(1, 1, 1)

	SplashFrame.Picture.b = CreateFrame("Frame", nil, SplashFrame, "BackdropTemplate")
	SplashFrame.Picture.b:SetTemplate()
	SplashFrame.Picture.b:SetPoint("TOPLEFT", SplashFrame.Picture, "TOPLEFT", -2, 2)
	SplashFrame.Picture.b:SetPoint("BOTTOMRIGHT", SplashFrame.Picture, "BOTTOMRIGHT", 2, -2)
	SplashFrame.Picture:SetParent(SplashFrame.Picture.b)

	SplashFrame.PictureFrame:Hide()
	SplashFrame.Bracket_TopLeft:Hide()
	SplashFrame.Bracket_TopRight:Hide()
	SplashFrame.Bracket_BottomRight:Hide()
	SplashFrame.Bracket_BottomLeft:Hide()
	SplashFrame.PictureFrame_Bracket_TopLeft:Hide()
	SplashFrame.PictureFrame_Bracket_TopRight:Hide()
	SplashFrame.PictureFrame_Bracket_BottomRight:Hide()
	SplashFrame.PictureFrame_Bracket_BottomLeft:Hide()

	local Reward = _G.RecruitAFriendRewardsFrame
	module:CreateBackdropShadow(Reward)

	local Recruit = _G.RecruitAFriendRecruitmentFrame
	module:CreateBackdropShadow(Recruit)
end

module:AddCallback("RecruitAFriendFrame")
