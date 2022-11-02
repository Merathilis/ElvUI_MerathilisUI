local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local _G = _G

function module:ElvUI_ChatPanels()
	if not E.private.mui.skins.shadow.enable or not E.db.mui.chat or not E.private.chat.enable then
		return
	end

	if _G.LeftChatPanel.backdrop then
		_G.LeftChatPanel.backdrop:Styling()
		module:CreateGradient(_G.LeftChatPanel.backdrop)
	end
	if _G.RightChatPanel.backdrop then
		_G.RightChatPanel.backdrop:Styling()
		module:CreateGradient(_G.RightChatPanel.backdrop)
	end

	module:CreateBackdropShadow(_G.LeftChatPanel, true)
	module:CreateBackdropShadow(_G.RightChatPanel, true)

	if _G.ElvUIChatVoicePanel then
		_G.ElvUIChatVoicePanel:Styling()
		module:CreateShadow(_G.ElvUIChatVoicePanel)
	end
end

module:AddCallback('ElvUI_ChatPanels')

