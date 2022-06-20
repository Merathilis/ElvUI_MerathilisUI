local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local AnimateTexCoords = AnimateTexCoords
local hooksecurefunc = hooksecurefunc

function FriendsCount_OnLoad(self)
	self:RegisterEvent("BN_FRIEND_LIST_SIZE_CHANGED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function FriendsCount_OnEvent(event, ...)
	local bnetCount = BNGetNumFriends();
	_G.MER_FriendsCounter:SetText(bnetCount.."|cff416380/200|r")
end

local function LoadSkin()
	if not module:CheckDB("friends", "friends") then
		return
	end

	local FriendsFrame = _G.FriendsFrame
	if FriendsFrame.backdrop then
		FriendsFrame.backdrop:Styling()
	end
	module:CreateBackdropShadow(FriendsFrame)

	-- Animated Icon
	_G.FriendsFrameIcon:SetPoint("TOPLEFT", FriendsFrame, "TOPLEFT", 0, 0)
	_G.FriendsFrameIcon:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\Bnet]])
	_G.FriendsFrameIcon:SetSize(36, 36)

	hooksecurefunc(_G.FriendsFrameIcon, "SetTexture", function(self, texture)
		if texture ~= [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\Bnet]] then
			self:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\Bnet]])
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
	FriendsFriendsFrame.backdrop:Styling()
end

S:AddCallback("FriendsFrame", LoadSkin)
