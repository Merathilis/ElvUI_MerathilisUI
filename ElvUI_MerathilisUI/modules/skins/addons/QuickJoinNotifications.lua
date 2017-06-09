local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")
local MERS = E:GetModule("muiSkins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS:

local function styleQuickJoinNotifications()
	if not IsAddOnLoaded("QuickJoinNotifications") then return end

	for i = 1, 3 do
		_G["quickJoinToastFrame"..i]:StripTextures()
		_G["quickJoinToastFrame"..i.."JoinButton"]:SetSize(70, 16)
		MERS:CreateBD(_G["quickJoinToastFrame"..i], .5)
		MERS:CreateGradient(_G["quickJoinToastFrame"..i])
		if not _G["quickJoinToastFrame"..i].stripes then
			MERS:CreateStripes(_G["quickJoinToastFrame"..i])
		end
	end
end

S:AddCallbackForAddon("QuickJoinNotifications", "mUIQuickJoinNotifications", styleQuickJoinNotifications)