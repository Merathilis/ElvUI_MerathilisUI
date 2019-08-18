local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API
local CreateFrame = CreateFrame
-- GLOBALS: GUILD, PanelTemplates_DeselectTab

local function styleFriends()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.friends ~= true or E.private.muiSkins.blizzard.friends ~= true then return end

	local FriendsFrame = _G.FriendsFrame

	FriendsFrame:Styling()
	_G.RecruitAFriendFrame:Styling()
	_G.RecruitAFriendSentFrame:Styling()
	_G.RecruitAFriendSentFrame.MoreDetails.Text:FontTemplate()

	-- Animated Icon
	FriendsFrameIcon:SetPoint("TOPLEFT", FriendsFrame, "TOPLEFT", 0, 0)
	FriendsFrameIcon:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\GameIcons\Bnet]])
	FriendsFrameIcon:SetSize(36, 36)

	hooksecurefunc(FriendsFrameIcon, "SetTexture", function(self, texture)
		if texture ~= [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\GameIcons\Bnet]] then
			self:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\GameIcons\Bnet]])
		end
	end)
	FriendsListFrame:HookScript("OnShow", function()
		FriendsFrameIcon:SetAlpha(1)
	end)
	FriendsListFrame:HookScript("OnHide", function()
		FriendsFrameIcon:SetAlpha(0)
	end)
	FriendsFrame:HookScript("OnUpdate", function(self, elapsed)
		AnimateTexCoords(FriendsFrameIcon, 512, 256, 64, 64, 25, elapsed, 0.01)
	end)

	-- GuildTab in FriendsFrame
	local n = FriendsFrame.numTabs + 1
	local gtframe = CreateFrame("Button", "FriendsFrameTab"..n, FriendsFrame, "FriendsFrameTabTemplate")
	gtframe:SetText(GUILD)
	gtframe:SetPoint("LEFT", _G["FriendsFrameTab"..n - 1], "RIGHT", -15, 0)
	PanelTemplates_DeselectTab(gtframe)
	gtframe:SetScript("OnClick", function() _G.ToggleGuildFrame() end)
	S:HandleTab(_G["FriendsFrameTab4"])
end

S:AddCallback("mUIFriends", styleFriends)
