local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')

function module:Ace3_Frame(Constructor)
	if not (E.private.mui.skins.enable and E.private.mui.skins.addonSkins.ace3 and E.private.mui.skins.shadow.enable) then
		return Constructor
	end

	local function SkinedConstructor()
		local widget = Constructor()

		module:CreateShadow(widget.frame)
		module:CreateGradient(widget.frame)
		widget.frame:Styling()
		return widget
	end

	return SkinedConstructor
end

function module:Ace3_DropdownPullout(Constructor)
	if not (E.private.mui.skins.enable and E.private.mui.skins.addonSkins.ace3 and E.private.mui.skins.shadow.enable) then
		return Constructor
	end

	local function SkinedConstructor()
		local widget = Constructor()

		if E.private.mui.skins.addonSkins.ace3DropdownBackdrop then
			widget.frame:SetTemplate("Transparent")
		end
		module:CreateShadow(widget.frame)
		widget.frame:Styling()
		return widget
	end

	return SkinedConstructor
end

function module:Ace3_Window(Constructor)
	if not (E.private.mui.skins.enable and E.private.mui.skins.addonSkins.ace3 and E.private.mui.skins.shadow.enable) then
		return Constructor
	end

	local function SkinedConstructor()
		local widget = Constructor()
		module:CreateShadow(widget.frame)
		widget.frame:Styling()
		return widget
	end

	return SkinedConstructor
end

function module:AceConfigDialog()
	if not (E.private.mui.skins.enable and E.private.mui.skins.addonSkins.ace3 and E.private.mui.skins.shadow.enable) then
		return
	end

	local lib = _G.LibStub("AceConfigDialog-3.0")
	self:CreateShadow(lib.popup)
	lib.popup:Styling()
end

module:AddCallbackForAceGUIWidget("Frame", module.Ace3_Frame)
module:AddCallbackForAceGUIWidget("Dropdown-Pullout", module.Ace3_DropdownPullout)
module:AddCallbackForAceGUIWidget("Window", module.Ace3_Window)
