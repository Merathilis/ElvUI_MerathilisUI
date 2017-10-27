local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
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

	MERS:CreateGradient(_G["FriendsListFrame"])
	MERS:CreateStripes(_G["FriendsListFrame"])

	MERS:CreateGradient(_G["QuickJoinFrame"])
	MERS:CreateStripes(_G["QuickJoinFrame"])

	MERS:CreateGradient(_G["IgnoreListFrame"])
	MERS:CreateStripes(_G["IgnoreListFrame"])

	MERS:CreateGradient(_G["WhoFrame"])
	MERS:CreateStripes(_G["WhoFrame"])

	MERS:CreateGradient(_G["ChannelFrame"])
	MERS:CreateStripes(_G["ChannelFrame"])

	MERS:CreateGradient(_G["RaidFrame"])
	MERS:CreateStripes(_G["RaidFrame"])

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