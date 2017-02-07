local E, L, V, P, G = unpack(ElvUI);

----------------------------------------------------------------------------------------
--	Core options
----------------------------------------------------------------------------------------
P["mui"] = {
	["installed"] = nil,
	
	["general"] = {
		["LoginMsg"] = true, -- Enable welcome message in chat
		["GameMenu"] = true, -- Enable the Styles GameMenu
		["SplashScreen"] = true, -- Enable the SplashScreen on LogIn
		["AFK"] = true, -- Enable the pimped AFK Screen
		["FlightMode"] = true, -- Enable the FlightMode
		["CombatState"] = true, -- Enable the +/- Combat Message
	},

	["misc"] = {
		["MailInputbox"] = true, -- Resize the MailInputbox
		["Tooltip"] = true, -- Add Icon for Spells/Items/Achievement to the Tooltip and show the Achievement Progress
		["moveBlizz"] = true, -- Make Blizzards Frame movable
		["tradeTabs"] = true, -- Add tabs for Professions on the Tradeskillframe
		["gmotd"] = true, -- Show a GMOTD frame
		["vignette"] = true, -- Shows Rars/Treasures
	},

	["datatexts"] = {
		["rightChatTabDatatextPanel"] = true,
		["panels"] = {
			["ChatTab_Datatext_Panel"] = {
				["left"] = "Call to Arms",
				["middle"] = "Coords",
				["right"] = "Bags",
			},
		},
		["threatBar"] = {
			["enable"] = true,
			["textSize"] = 10,
		},
	},

	["systemDT"] = {
		["maxAddons"] = 25, -- Sets how many Addons to show
		["showFPS"] = true, -- Show Frames per seconds
		["showMS"] = true, -- Show Ping
		["latency"] = "home", -- Set the latency type ("home", "world")
		["showMemory"] = false, -- Show Memory usage
		["announceFreed"] = true -- Enable the Garbage Message in Chat
	},

	["unitframes"] = {
		["groupinfo"] = true,
		["unit"] = {
			["player"] = {
				["rested"] = {
					["xoffset"] = 0,
					["yoffset"] = 0,
					["size"] = 16,
					["texture"] = "DEFAULT",
				},
			},
		},
	},

	["locPanel"] = {
		["enable"] = false,
		["autowidth"] = false,
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
		["colorType_Coords"] = "DEFAULT",
		["customColor"] = {r = 1, g = 1, b = 1 },
		["customColor_Coords"] = {r = 1, g = 1, b = 1 },
		["combathide"] = false,
		["portals"] = {
			["enable"] = true,
			["HSplace"] = true,
			["customWidth"] = false,
			["customWidthValue"] = 200,
			["justify"] = "LEFT",
			["cdFormat"] = "DEFAULT",
		},
	},

	["raidmarkers"] = {
		["enable"] = true,
		["visibility"] = "INPARTY",
		["customVisibility"] = "[noexists, nogroup] hide; show",
		["backdrop"] = false,
		["buttonSize"] = 18,
		["spacing"] = 2,
		["orientation"] = "HORIZONTAL",
		["modifier"] = "shift-",
		["reverse"] = false,
	},

	["quests"] = {
		["visibility"] = {
			["enable"] = false,
			["bg"] = "COLLAPSED",
			["arena"] = "COLLAPSED",
			["dungeon"] = "FULL",
			["raid"] = "COLLAPSED",
			["scenario"] = "FULL",
			["rested"] = "FULL",
			["garrison"] = "FULL",
			["orderhall"] = "FULL",
		},
	},

	["error"] = {
		["black"] = true,
		["combat"] = false,
		["white"] = false,
	},

	-- db
	["dbCleaned"] = false
}