local MER, F, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')
if not IsAddOnLoaded("XIV_Databar") then return end

local _G = _G

local function LoadAddOnSkin()
	if E.private.MER_Skins.addonSkins.xiv ~= true then return end

	local XIV_Databar = _G.XIV_Databar

	XIV_Databar:StripTextures()
	MERS:CreateBD(XIV_Databar, .5)
	XIV_Databar:Styling()
	XIV_Databar:SetParent(E.UIParent)

	_G.SpecPopup:SetTemplate("Transparent")
	_G.LootPopup:SetTemplate("Transparent")
	_G.portPopup:SetTemplate("Transparent")
end

S:AddCallbackForAddon("XIV_Databar", "mUIXIV_Databar", LoadAddOnSkin)
