local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local _G = _G

function module:ElvUI_ChatPanels()
	if not E.db.mui.chat or not E.private.chat.enable then
		return
	end

	if E.private.mui.skins.shadow.enable then
		module:CreateBackdropShadow(_G.LeftChatPanel, true)
		module:CreateBackdropShadow(_G.RightChatPanel, true)

		if _G.ElvUIChatVoicePanel then
			module:CreateShadow(_G.ElvUIChatVoicePanel)
		end
	end
end

module:AddCallback("ElvUI_ChatPanels")
