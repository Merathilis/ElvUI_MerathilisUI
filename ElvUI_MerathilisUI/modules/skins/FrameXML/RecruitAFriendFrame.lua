local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local unpack = unpack
-- WoW API / Variables
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true then return; end

	local Reward = _G.RecruitAFriendRewardsFrame
	Reward:Styling()

	local Recruit = _G.RecruitAFriendRecruitmentFrame
	Recruit:Styling()
end

S:AddCallback("mUIRecruitAFriend", LoadSkin)
