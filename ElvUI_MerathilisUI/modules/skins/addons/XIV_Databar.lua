local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule('MerathilisUI')
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
	MER:StyleUnder(XIV_Databar)
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, _, addon)
	if addon == "ElvUI_MerathilisUI" then
		E:Delay(.5, styleXIV_Databar)
		self:UnregisterEvent("ADDON_LOADED")
	end
end)