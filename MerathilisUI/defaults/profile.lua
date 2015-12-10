local E, L, V, P, G = unpack(ElvUI);

-- Core
P['mui'] = {
	['installed'] = nil,
}

P['muiGeneral'] = {
	['LoginMsg'] = true,
	['GameMenu'] = true,
	['Bags'] = true,
}

P['muiMisc'] = {
	['HideAlertFrame'] = true,
	['MailInputbox'] = true,
	['Screenshot'] = true,
	['TooltipIcon'] = true,
	['noDuel'] = false,
	['FriendAlert'] = false,
}

P['muiSkins'] = {
	['MasterPlan'] = true,
}

P['muiSystemDT'] = {
	['maxAddons'] = 25,
	['showFPS'] = true,
	['showMS'] = true,
	['latency'] = "home",
	['showMemory'] = false,
	['announceFreed'] = true
}

P['muiLoot'] = {
	['lootIcon'] = {
		['enable'] = false,
		['position'] = 'RIGHT',
		['size'] = 12,
		["channels"] = {
			["CHAT_MSG_BN_WHISPER"] = false,
			["CHAT_MSG_BN_WHISPER_INFORM"] = false,
			["CHAT_MSG_BN_CONVERSATION"] = false,
			["CHAT_MSG_CHANNEL"] = false,
			["CHAT_MSG_EMOTE"] = false,
			["CHAT_MSG_GUILD"] = false,
			["CHAT_MSG_INSTANCE_CHAT"] = false,
			["CHAT_MSG_INSTANCE_CHAT_LEADER"] = false,
			["CHAT_MSG_LOOT"] = true,
			["CHAT_MSG_OFFICER"] = false,
			["CHAT_MSG_PARTY"] = false,
			["CHAT_MSG_PARTY_LEADER"] = false,
			["CHAT_MSG_RAID"] = false,
			["CHAT_MSG_RAID_LEADER"] = false,
			["CHAT_MSG_RAID_WARNING"] = false,
			["CHAT_MSG_SAY"] = false,
			["CHAT_MSG_SYSTEM"] = true,
			["CHAT_MSG_WHISPER"] = false,
			["CHAT_MSG_WHISPER_INFORM"] = false,
			["CHAT_MSG_YELL"] = false,
		},
	},
}
