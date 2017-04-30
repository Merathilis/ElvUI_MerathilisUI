local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins");
if not IsAddOnLoaded("XIV_Databar") then return end

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
-- GLOBALS:

local function styleXIV_Databar()
	if E.private.muiSkins.addonSkins.xiv ~= true then return end

	_G["XIV_Databar"]:StripTextures()
	_G["XIV_Databar"]:SetTemplate("Transparent")
	_G["XIV_Databar"]:SetParent(E.UIParent)
	_G["SpecPopup"]:SetTemplate("Transparent")
	_G["LootPopup"]:SetTemplate("Transparent")
	_G["portPopup"]:SetTemplate("Transparent")
end

S:AddCallbackForAddon("XIV_Databar", "mUIXIV_Databar", styleXIV_Databar)