local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local CF = MER:GetModule("MER_Cooldown")
local options = MER.options.modules.args

local C_VoiceChat_GetTtsVoices = C_VoiceChat and C_VoiceChat.GetTtsVoices
local C_VoiceChat_SpeakText = C_VoiceChat and C_VoiceChat.SpeakText

options.cooldowns = {
	type = "group",
	name = L["Cooldowns"],
	args = {},
}
