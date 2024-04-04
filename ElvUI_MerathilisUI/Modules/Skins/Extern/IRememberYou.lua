local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G

function module:IRememberYou()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.iry then
		return
	end

	local MyListAddonFrame = _G.MyListAddonFrame -- /memory
	S:HandleFrame(MyListAddonFrame, true)
	module:CreateBackdropShadow(MyListAddonFrame)

	local MyListAddonScrollFrameScrollBar = _G.MyListAddonScrollFrameScrollBar
	S:HandleScrollBar(MyListAddonScrollFrameScrollBar)

	local toolsEditBox = _G.toolsEditBox
	S:HandleEditBox(toolsEditBox)
end

module:AddCallbackForAddon("IRememberYou")
