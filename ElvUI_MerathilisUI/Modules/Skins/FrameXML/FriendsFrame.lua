local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API
local AnimateTexCoords = AnimateTexCoords
local CreateFrame = CreateFrame
local PanelTemplates_DeselectTab = PanelTemplates_DeselectTab
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.friends ~= true or E.private.muiSkins.blizzard.friends ~= true then return end

	local FriendsFrame = _G.FriendsFrame
	FriendsFrame:Styling()

	-- Animated Icon
	_G.FriendsFrameIcon:SetPoint("TOPLEFT", FriendsFrame, "TOPLEFT", 0, 0)
	_G.FriendsFrameIcon:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Bnet]])
	_G.FriendsFrameIcon:SetSize(36, 36)

	hooksecurefunc(_G.FriendsFrameIcon, "SetTexture", function(self, texture)
		if texture ~= [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Bnet]] then
			self:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Bnet]])
		end
	end)
	_G.FriendsListFrame:HookScript("OnShow", function()
		_G.FriendsFrameIcon:SetAlpha(1)
	end)
	_G.FriendsListFrame:HookScript("OnHide", function()
		_G.FriendsFrameIcon:SetAlpha(0)
	end)
	FriendsFrame:HookScript("OnUpdate", function(self, elapsed)
		AnimateTexCoords(_G.FriendsFrameIcon, 512, 256, 64, 64, 25, elapsed, 0.01)
	end)

	local FriendsFriendsFrame = _G.FriendsFriendsFrame
	FriendsFriendsFrame:Styling()

	if _G.FriendsFrameBattlenetFrame.BroadcastFrame.backdrop then
		_G.FriendsFrameBattlenetFrame.BroadcastFrame.backdrop:Styling()
	end
end

S:AddCallback("mUIFriends", LoadSkin)
