local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
local _G = _G
-- Lua functions
local format, gsub = string.format, string.gsub
-- WoW API
local BNGetFriendInfo = BNGetFriendInfo
local BNGetGameAccountInfo = BNGetGameAccountInfo
local GetFriendInfo = GetFriendInfo
local GetQuestDifficultyColor = GetQuestDifficultyColor
local GetRealZoneText = GetRealZoneText

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleFriends()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.friends ~= true or E.private.muiSkins.blizzard.friends ~= true then return end

	MERS:CreateGradient(FriendsListFrame)
	if not FriendsListFrame.stripes then
		MERS:CreateStripes(FriendsListFrame)
	end
	MERS:CreateGradient(QuickJoinFrame)
	if not QuickJoinFrame.stripes then
		MERS:CreateStripes(QuickJoinFrame)
	end
	MERS:CreateGradient(IgnoreListFrame)
	if not IgnoreListFrame.stripes then
		MERS:CreateStripes(IgnoreListFrame)
	end
	MERS:CreateGradient(WhoFrame)
	if not WhoFrame.stripes then
		MERS:CreateStripes(WhoFrame)
	end
	MERS:CreateGradient(ChannelFrame)
	if not ChannelFrame.stripes then
		MERS:CreateStripes(ChannelFrame)
	end
	MERS:CreateGradient(RaidFrame)
	if not RaidFrame.stripes then
		MERS:CreateStripes(RaidFrame)
	end

	-- GuildTab in FriendsFrame
	local n = FriendsFrame.numTabs + 1
	local gtframe = CreateFrame("Button", "FriendsFrameTab"..n, FriendsFrame, "FriendsFrameTabTemplate")
	gtframe:SetText(GUILD)
	gtframe:SetPoint("LEFT", _G["FriendsFrameTab"..n - 1], "RIGHT", -15, 0)
	PanelTemplates_DeselectTab(gtframe)
	gtframe:SetScript("OnClick", function() ToggleGuildFrame() end)
	S:HandleTab(FriendsFrameTab5)
end

S:AddCallback("mUIFriends", styleFriends)