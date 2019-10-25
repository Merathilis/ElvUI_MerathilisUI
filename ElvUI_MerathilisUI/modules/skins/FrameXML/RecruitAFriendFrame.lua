local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local unpack = unpack
-- WoW API / Variables
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true then return; end

	local SplashFrame = _G.RecruitAFriendFrame.SplashFrame
	SplashFrame.Background:SetColorTexture(unpack(E.media.bordercolor))

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
