local MER, E, L, V, P, G = unpack(select(2, ...))
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
		_G["BuiLeftChatDTPanel"]:Styling()
	end

	if _G["BuiMiddleDTPanel"] then
		_G["BuiMiddleDTPanel"]:Styling()
	end

	if _G["BuiRightChatDTPanel"] then
		_G["BuiRightChatDTPanel"]:Styling()
	end

	if _G["BuiTaxiButton"] then
		_G["BuiTaxiButton"]:Styling()
	end
end

S:AddCallbackForAddon("ElvUI_BenikUI", "mUIBenikUI", styleBenikUI)