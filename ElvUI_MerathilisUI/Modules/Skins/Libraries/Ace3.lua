local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local pairs = pairs

function module:AceGUI(lib)
	self:SecureHook(lib, "RegisterWidgetType", "HandleAceGUIWidget")
	for name, constructor in pairs(lib.WidgetRegistry) do
		self:HandleAceGUIWidget(lib, name, constructor)
	end
end

function module:AceConfigDialog(lib)
	self:CreateShadow(lib.popup)
end

function module:Ace3_Frame(widget)
	self:CreateShadow(widget.frame)
end

function module:Ace3_DropdownPullout(widget)
	if self.db.libraries.ace3Dropdown then
		widget.frame:SetTemplate("Transparent")
	end
	self:CreateShadow(widget.frame)
end

module:AddCallbackForLibrary("AceGUI-3.0", "AceGUI")
module:AddCallbackForLibrary("AceConfigDialog-3.0", "AceConfigDialog")
module:AddCallbackForAceGUIWidget("Frame", "Ace3_Frame", function(db)
	return db.libraries.ace3 and db.shadow.enable
end)
module:AddCallbackForAceGUIWidget("Window", "Ace3_Frame", function(db)
	return db.libraries.ace3 and db.shadow.enable
end)
module:AddCallbackForAceGUIWidget("Dropdown-Pullout", "Ace3_DropdownPullout", function(db)
	return db.libraries.ace3 and (db.libraries.ace3Dropdown or db.shadows.enable)
end)
