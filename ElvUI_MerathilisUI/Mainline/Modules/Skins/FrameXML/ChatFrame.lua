local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local pairs = pairs

local function LoadSkin()
	if E.private.chat.enable ~= true then return; end

	local VoiceChatPromptActivateChannel = _G["VoiceChatPromptActivateChannel"]
	module:CreateBD(VoiceChatPromptActivateChannel)
	VoiceChatPromptActivateChannel:Styling()
	module:CreateBD(_G.VoiceChatChannelActivatedNotification)
	_G.VoiceChatChannelActivatedNotification:Styling()

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
	else
		--ElvUI ChatButtonHolder
		if _G.ChatButtonHolder then
			_G.ChatButtonHolder:Styling()
		end
	end


	do
		local ChatMenus = {
			_G.ChatMenu,
			_G.EmoteMenu,
			_G.LanguageMenu,
			_G.VoiceMacroMenu,
		}

		for _, menu in pairs(ChatMenus) do
			if menu then
				menu:Styling()
			end
		end
	end
end

S:AddCallback("ChatFrame", LoadSkin)
