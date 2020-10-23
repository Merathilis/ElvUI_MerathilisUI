local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local pairs = pairs
local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if E.private.chat.enable ~= true then return; end

	local VoiceChatPromptActivateChannel = _G["VoiceChatPromptActivateChannel"]
	MERS:CreateBD(VoiceChatPromptActivateChannel)
	VoiceChatPromptActivateChannel:Styling()
	MERS:CreateBD(_G.VoiceChatChannelActivatedNotification)
	_G.VoiceChatChannelActivatedNotification:Styling()

	--ElvUI ChatButtonHolder
	if _G.ChatButtonHolder then
		_G.ChatButtonHolder:Styling()
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

S:AddCallback("mUIChat", LoadSkin)
