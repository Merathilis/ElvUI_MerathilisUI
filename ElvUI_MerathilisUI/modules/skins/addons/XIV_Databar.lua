local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule("MerathilisUI")
local MERS = E:GetModule("muiSkins");
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
	MERS:StyleUnder(_G["XIV_Databar"])
end

S:AddCallbackForAddon("XIV_Databar", "mUIXIV_Databar", styleXIV_Databar)