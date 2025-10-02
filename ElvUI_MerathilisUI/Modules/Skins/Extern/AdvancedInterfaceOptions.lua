local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local S = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G
local pairs = pairs

local CVAR_BROWSER_CONFIG_DIALOG_KEY = "AdvancedInterfaceOptions_cVar"

local function ReskinBrowser(frame)
	frame:StripTextures()
	frame:CreateBackdrop("Transparent")

	S:Proxy("HandleScrollBar", frame.scrollbar)
	F.Move(frame, 6, 0)
	frame:Width(frame:GetWidth() - 12)
end

function S:AdvancedInterfaceOptions()
	if not E.private.mui.skins.enable or not E.private.mui.skins.addonSkins.aio then
		return
	end

	local dialog = _G.LibStub("AceConfigDialog-3.0", true)
	if not dialog then
		return
	end

	local frame = dialog.BlizOptions and dialog.BlizOptions[CVAR_BROWSER_CONFIG_DIALOG_KEY]
	frame = frame[CVAR_BROWSER_CONFIG_DIALOG_KEY] and frame[CVAR_BROWSER_CONFIG_DIALOG_KEY].frame
	if frame and not frame.__MERSkin then
		for _, child in pairs({ frame:GetChildren() }) do
			if child:IsObjectType("EditBox") then
				self:Proxy("HandleEditBox", child)
			elseif child:IsObjectType("Frame") then
				if child.scrollbar then
					ReskinBrowser(child)
				end
			end
		end

		frame.__MERSkin = true
	end
end

S:AddCallbackForAddon("AdvancedInterfaceOptions")
