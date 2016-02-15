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
	['SplashScreen'] = true, -- Enable the SplashScreen on LogIn
	['AFK'] = true, -- Enable the pimped AFK Screen
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