local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleBNet()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.misc ~= true then return end

	-- BNet ToastFrame
	_G["BNToastFrameGlowFrame"].glow:SetColorTexture(1, 1, 1, 0.5)
	_G["BNToastFrameGlowFrame"].glow:SetAllPoints()

	_G["BNToastFrameCloseButton"]:SetPushedTexture("")
	_G["BNToastFrameCloseButton"]:SetHighlightTexture([[Interface\FriendsFrame\ClearBroadcastIcon]])
	_G["BNToastFrameCloseButton"]:SetNormalTexture([[Interface\FriendsFrame\ClearBroadcastIcon]])
	_G["BNToastFrameCloseButton"]:GetNormalTexture():SetAlpha(0.5)

	_G["BNToastFrame"]:Styling(true, true)
end

S:AddCallback("mUIBNet", styleBNet)