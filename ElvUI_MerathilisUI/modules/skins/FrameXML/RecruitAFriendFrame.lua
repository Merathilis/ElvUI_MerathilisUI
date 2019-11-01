local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local unpack = unpack
-- WoW API / Variables
local CreateFrame = CreateFrame
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true then return; end

	local RecruitAFriendFrame = _G.RecruitAFriendFrame
	local SplashFrame = RecruitAFriendFrame.SplashFrame

	SplashFrame.Background:Hide()
	SplashFrame.PictureFrame:Hide()

	SplashFrame:CreateBackdrop()
	SplashFrame.backdrop:SetPoint("TOPLEFT", 2, -2)
	SplashFrame.backdrop:SetPoint("BOTTOMRIGHT", -1, -1)

	SplashFrame.Description:SetTextColor(1, 1, 1)

	SplashFrame.Picture.b = CreateFrame("Frame", nil, SplashFrame)
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
	Reward:Styling()

	local Recruit = _G.RecruitAFriendRecruitmentFrame
	Recruit:Styling()
end

S:AddCallback("mUIRecruitAFriend", LoadSkin)
