local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API
local CreateFrame = CreateFrame
-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: GUILD, PanelTemplates_DeselectTab

local function styleFriends()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.friends ~= true or E.private.muiSkins.blizzard.friends ~= true then return end

	_G["FriendsListFrame"]:Styling(true, true)
	_G["QuickJoinFrame"]:Styling(true, true)
	_G["IgnoreListFrame"]:Styling(true, true)
	_G["WhoFrame"]:Styling(true, true)
	_G["ChannelFrame"]:Styling(true, true)
	_G["RaidFrame"]:Styling(true, true)
	_G["RaidInfoFrame"]:Styling(true, true)

	_G["RecruitAFriendFrame"]:Styling(true, true)

	-- GuildTab in FriendsFrame
	local n = _G["FriendsFrame"].numTabs + 1
	local gtframe = CreateFrame("Button", "FriendsFrameTab"..n, _G["FriendsFrame"], "FriendsFrameTabTemplate")
	gtframe:SetText(GUILD)
	gtframe:SetPoint("LEFT", _G["FriendsFrameTab"..n - 1], "RIGHT", -15, 0)
	PanelTemplates_DeselectTab(gtframe)
	gtframe:SetScript("OnClick", function() _G["ToggleGuildFrame"]() end)
	S:HandleTab(_G["FriendsFrameTab5"])
end

S:AddCallback("mUIFriends", styleFriends)