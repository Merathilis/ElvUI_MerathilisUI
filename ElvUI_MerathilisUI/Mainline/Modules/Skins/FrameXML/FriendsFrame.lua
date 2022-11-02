local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local AnimateTexCoords = AnimateTexCoords
local hooksecurefunc = hooksecurefunc
local CreateColor = CreateColor

function FriendsCount_OnLoad(self)
	self:RegisterEvent("BN_FRIEND_LIST_SIZE_CHANGED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function FriendsCount_OnEvent(event, ...)
	local bnetCount = BNGetNumFriends();
	_G.MER_FriendsCounter:SetText(bnetCount.."|cff416380/200|r")
end

local function UpdateFriendsButton(button)
	if not button.right then
		button.right = button:CreateTexture(nil, "BACKGROUND")
		button.right:SetWidth(button:GetWidth() / 2)
		button.right:SetHeight(32)
		button.right:SetPoint("LEFT", button, "CENTER", 0)
		button.right:SetTexture(E.LSM:Fetch("statusbar", E.media.normTex))
		button.right:SetGradient("HORIZONTAL", CreateColor(.243, .57, 1, 0), CreateColor(.243, .57, 1, .25))

		if button.gameIcon then
			button.gameIcon:HookScript("OnShow", function()
				button.right:Show()
			end)

			button.gameIcon:HookScript("OnHide", function()
				button.right:Hide()
			end)

			if button.gameIcon:IsShown() then
				button.right:Show()
			else
				button.right:Hide()
			end
		end
	end
end

local function LoadSkin()
	if not module:CheckDB("friends", "friends") then
		return
	end

	local FriendsFrame = _G.FriendsFrame
	FriendsFrame:Styling()

	local frames = {
		_G.FriendsFrame,
		_G.FriendsFriendsFrame,
		_G.AddFriendFrame,
		_G.RecruitAFriendFrame.SplashFrame,
		_G.RecruitAFriendRewardsFrame,
		_G.RecruitAFriendRecruitmentFrame,
		_G.FriendsFrameBattlenetFrame.BroadcastFrame
	}

	for _, frame in pairs(frames) do
		module:CreateShadow(frame)
	end

	-- A check for german clients cause the font is sometimes tooo huge (tested with Expressway 11)
	if GetLocale() == 'deDE' then
		for i = 1, 4 do
			local tab = _G["FriendsFrameTab"..i]
			if tab then
				F.ResetTabAnchor(tab)
			end
		end
	end

	for i = 1, 4 do
		module:ReskinTab(_G["FriendsFrameTab" .. i])
	end

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
	FriendsFriendsFrame:Styling()

	if _G.FriendsFrameBattlenetFrame.BroadcastFrame.backdrop then
		_G.FriendsFrameBattlenetFrame.BroadcastFrame.backdrop:Styling()
	end
	module:SecureHook("FriendsFrame_UpdateFriendButton", UpdateFriendsButton)
end

S:AddCallback("FriendsFrame", LoadSkin)
