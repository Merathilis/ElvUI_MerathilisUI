local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")
if not IsAddOnLoaded("ElvUI_BenikUI") then return; end

-- Cache global variables
-- Lua functions
local _G = _G
local pairs = pairs
-- WoW API / Variables
-- GLOBALS: 

local function styleBenikUI()
	if E.private.muiSkins.addonSkins.bui ~= true then return; end

	if _G["BuiLeftChatDTPanel"] then
		MERS:CreateStripes(_G["BuiLeftChatDTPanel"])
		MERS:CreateGradient(_G["BuiLeftChatDTPanel"])
	end

	if _G["BuiMiddleDTPanel"] then
		MERS:CreateStripes(_G["BuiMiddleDTPanel"])
		MERS:CreateGradient(_G["BuiMiddleDTPanel"])
	end

	if _G["BuiRightChatDTPanel"] then
		MERS:CreateStripes(_G["BuiRightChatDTPanel"])
		MERS:CreateGradient(_G["BuiRightChatDTPanel"])
	end
end

S:AddCallbackForAddon("ElvUI_BenikUI", "mUIBenikUI", styleBenikUI)