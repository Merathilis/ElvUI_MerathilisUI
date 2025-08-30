local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G
local pairs = pairs

function module:AceGUI(lib)
	module:SecureHook(lib, "RegisterWidgetType", "HandleAceGUIWidget")
	for name, constructor in pairs(lib.WidgetRegistry) do
		module:HandleAceGUIWidget(lib, name, constructor)
	end
end

function module:AceConfigDialog(lib)
	self:CreateShadow(lib.popup)
end

function module:Ace3_Frame(Constructor)
	if
		not (E.private.mui.skins.enable and E.private.mui.skins.libraries.ace3 and E.private.mui.skins.shadow.enable)
	then
		return Constructor
	end

	local function SkinnedConstructor()
		local widget = Constructor()

		self:CreateShadow(widget.frame)
		return widget
	end

	return SkinnedConstructor
end

function module:Ace3_DropdownPullout(Constructor)
	if
		not (E.private.mui.skins.enable and E.private.mui.skins.libraries.ace3 and E.private.mui.skins.shadow.enable)
	then
		return Constructor
	end

	local function SkinnedConstructor()
		local widget = Constructor()

		if E.private.mui.skins.libraries.ace3Dropdown then
			widget.frame:SetTemplate("Transparent")
		end
		self:CreateShadow(widget.frame)
		return widget
	end

	return SkinnedConstructor
end

function module:Ace3_Window(Constructor)
	if
		not (E.private.mui.skins.enable and E.private.mui.skins.libraries.ace3 and E.private.mui.skins.shadow.enable)
	then
		return Constructor
	end

	local function SkinnedConstructor()
		local widget = Constructor()
		self:CreateShadow(widget.frame)
		return widget
	end

	return SkinnedConstructor
end

module:AddCallbackForLibrary("AceGUI-3.0", "AceGUI")
module:AddCallbackForLibrary("AceConfigDialog-3.0", "AceConfigDialog")
module:AddCallbackForAceGUIWidget("Frame", "Ace3_Frame")
module:AddCallbackForAceGUIWidget("Dropdown-Pullout", "Ace3_DropdownPullout")
module:AddCallbackForAceGUIWidget("Window", "Ace3_Window")
