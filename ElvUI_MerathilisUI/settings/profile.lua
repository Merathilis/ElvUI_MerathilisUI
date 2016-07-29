local E, L, V, P, G = unpack(ElvUI);

----------------------------------------------------------------------------------------
--	Core options
----------------------------------------------------------------------------------------
P['mui'] = {
	['installed'] = nil,
	
	['general'] = {
		['LoginMsg'] = true, -- Enable welcome message in chat
		['GameMenu'] = true, -- Enable the Styles GameMenu
		['SplashScreen'] = true, -- Enable the SplashScreen on LogIn
		['AFK'] = true, -- Enable the pimped AFK Screen
		['FlightMode'] = true, -- Enable the FlightMode
	},

	['misc'] = {
		['HideAlertFrame'] = true, -- Hide the Garison AlertFrame in Combat
		['MailInputbox'] = true, -- Resize the MailInputbox
		['TooltipIcon'] = true, -- Add Icon for Spells/Items/Achievement to the Tooltip
		['FriendAlert'] = false, -- Show a chat notification if a friend switches Games
		['moveBlizz'] = true, -- Make Blizzards Frame movable
	},

	['systemDT'] = {
		['maxAddons'] = 25, -- Sets how many Addons to show
		['showFPS'] = true, -- Show Frames per seconds
		['showMS'] = true, -- Show Ping
		['latency'] = "home", -- Set the latency type ("home", "world")
		['showMemory'] = false, -- Show Memory usage
		['announceFreed'] = true -- Enable the Garbage Message in Chat
	},

	['unitframes'] = {
		['unit'] = {
			['player'] = {
				["rested"] = {
					["xoffset"] = 0,
					["yoffset"] = 0,
					["size"] = 22,
					["texture"] = "DEFAULT",
				},
			},
		},
	},

	["locPanel"] = {
		["enable"] = false,
		["width"] = 245,
		["height"] = 21,
		["linkcoords"] = true,
		["template"] = "Transparent",
		["font"] = "Merathilis Roboto-Black",
		["fontSize"] = 11,
		["fontOutline"] = "OUTLINE",
		["throttle"] = 0.2,
		["format"] = "%.0f",
		["zoneText"] = true,
		["colorType"] = "REACTION",
		["customColor"] = {r = 1, g = 1, b = 1 },
		["portals"] = {
			["enable"] = true,
			["customWidth"] = false,
			["customWidthValue"] = 200,
			["justify"] = "LEFT",
			["cdFormat"] = "DEFAULT",
		},
	},

	-- db
	['dbCleaned'] = false
}
