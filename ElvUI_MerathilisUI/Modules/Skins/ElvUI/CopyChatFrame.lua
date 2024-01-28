local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')

local _G = _G

function module:ElvUICopyChatFrame()
	if not E.private.mui.skins.enable or not E.private.mui.skins.shadow.enable then
		return
	end

	self:CreateShadow(_G.CopyChatFrame)
	F.SetFontOutline(_G.CopyChatFrameEditBox)
end

module:AddCallback("ElvUICopyChatFrame")
