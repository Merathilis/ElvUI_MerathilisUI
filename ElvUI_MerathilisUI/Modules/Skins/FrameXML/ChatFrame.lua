local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:ChatFrame()
	if E.private.chat.enable ~= true then
		return
	end

	local VoiceChatPromptActivateChannel = _G["VoiceChatPromptActivateChannel"]
	_G.VoiceChatChannelActivatedNotification:CreateBackdrop("Transparent")

	-- Revert my Styling function on these buttons
	if E.db.chat.pinVoiceButtons and not E.db.chat.hideVoiceButtons then
		if _G.ChatFrameChannelButton then
			_G.ChatFrameChannelButton:DisableDrawLayer("BORDER")
		end

		if _G.ChatFrameToggleVoiceDeafenButton then
			_G.ChatFrameToggleVoiceDeafenButton:DisableDrawLayer("BORDER")
		end

		if _G.ChatFrameToggleVoiceMuteButton then
			_G.ChatFrameToggleVoiceMuteButton:DisableDrawLayer("BORDER")
		end
	end
end

module:AddCallback("ChatFrame")
