local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:TomTom()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.tom then
		return
	end

	local MyFrameDropDownBackdrop = _G.MyFrameDropDownBackdrop
	if MyFrameDropDownBackdrop then
		MyFrameDropDownBackdrop:StripTextures()
		MyFrameDropDownBackdrop:SetTemplate("Transparent")
	end

	local TomTomWorldMapDropdownBackdrop = _G.TomTomWorldMapDropdownBackdrop
	if TomTomWorldMapDropdownBackdrop then
		TomTomWorldMapDropdownBackdrop:StripTextures()
		TomTomWorldMapDropdownBackdrop:SetTemplate("Transparent")
	end

	local TomTomDropdown = _G.TomTomDropdown
	if TomTomDropdown then --minimap dropdown
		_G.TomTomDropdownBackdrop:StripTextures()
		_G.TomTomDropdownBackdrop:SetTemplate("Transparent")
	end
end

module:AddCallbackForAddon("TomTom")
