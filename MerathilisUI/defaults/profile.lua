local E, L, V, P, G = unpack(ElvUI);

----------------------------------------------------------------------------------------
--	Core options
----------------------------------------------------------------------------------------
P['mui'] = {
	['installed'] = nil,
}

----------------------------------------------------------------------------------------
--	General options
----------------------------------------------------------------------------------------
P['muiGeneral'] = {
	['LoginMsg'] = true, -- Enable welcome message in chat
	['GameMenu'] = true, -- Enable the Styles GameMenu
	['Bags'] = true, -- Enable the forcing of the Bag/Bank Position to the Datatext
	['SplashScreen'] = true, -- Enable the SplashScreen on LogIn
	['AFK'] = true, -- Enable the pimped AFK Screen
}

----------------------------------------------------------------------------------------
--	Loot options
----------------------------------------------------------------------------------------
P['muiLoot'] = {
	['lootIcon'] = {
		['enable'] = false, -- Add a Icon to looted/crafted Items in Chat
		['position'] = 'RIGHT', -- Set position ('LEFT', 'RIGHT')
		['size'] = 12, -- Icon size
		["channels"] = { -- Channels to show the Icon
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

----------------------------------------------------------------------------------------
--	Misc options
----------------------------------------------------------------------------------------
P['muiMisc'] = {
	['HideAlertFrame'] = true, -- Hide the Garison AlertFrame in Combat
	['MailInputbox'] = true, -- Resize the MailInputbox
	['TooltipIcon'] = true, -- Add Icon for Spells/Items/Achievement to the Tooltip
	['FriendAlert'] = false, -- Show a chat notification if a friend switches Games
	['moveBlizz'] = true, -- Make Blizzards Frame movable
	['enchantScroll'] = false, -- Place a button at the Enchant Trade Window
	['minimapblip'] = true, -- Custom Textures for the Minimap blibs
}

----------------------------------------------------------------------------------------
--	PVP options
----------------------------------------------------------------------------------------
P['muiPVP'] = { -- Cancel Duel requests
	['duels'] = {
		['regular'] = false,
		['pet'] = false,
		['announce'] = false,
	},
}

----------------------------------------------------------------------------------------
--	Skins options
----------------------------------------------------------------------------------------
P['muiSkins'] = {
	['blizzard'] = {
		['encounterjournal'] = true,
		['spellbook'] = true, -- Remove the Background of the Spellbook
		['objectivetracker'] = true,
	},
	['addons'] = {
		['MasterPlan'] = true, -- Skins the additional MasterPlan Tabs
	},
}

----------------------------------------------------------------------------------------
--	System Datatext options
----------------------------------------------------------------------------------------
P['muiSystemDT'] = {
	['maxAddons'] = 25, -- Sets how many Addons to show
	['showFPS'] = true, -- Show Frames per seconds
	['showMS'] = true, -- Show Ping
	['latency'] = "home", -- Set the latency type ("home", "world")
	['showMemory'] = false, -- Show Memory usage
	['announceFreed'] = true -- Enable the Garbage Message in Chat
}

----------------------------------------------------------------------------------------
--	Unitframes options
----------------------------------------------------------------------------------------
P['muiUnitframes'] = {
	['roleIcons'] = false,
	['setRole'] = true
}