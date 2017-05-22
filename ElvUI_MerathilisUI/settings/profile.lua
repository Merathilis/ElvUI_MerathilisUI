local E, L, V, P, G = unpack(ElvUI)

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
		["HideOrderhallBar"] = false, -- Hide the OrderHallCommandBar
		["MerchantiLevel"] = true, -- Displays the itemlevel on the Merchant Frame
		["Movertransparancy"] = .75,
		["Notification"] = {
			["enable"] = true,
			["mail"] = true,
			["vignette"] = true,
			["invites"] = true,
			["guildEvents"] = true,
		},
		["ItemLevelLink"] = true, -- Displays the itemlevel in the itemlink
	},

	["misc"] = {
		["MailInputbox"] = true, -- Resize the MailInputbox
		["moveBlizz"] = true, -- Make Blizzards Frame movable
		["tradeTabs"] = true, -- Add tabs for Professions on the Tradeskillframe
		["gmotd"] = true, -- Show a GMOTD frame
		["quest"] = false,
		["announce"] = false, -- CombatText, Skill gains
		["cooldowns"] = {
			["enable"] = false,
			["size"] = 25,
			["growthx"] = "LEFT",
			["growthy"] = "UP",
			["showbags"] = true,
			["showequip"] = true,
			["showpets"] = true,
		},
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

	["tooltip"] = {
		["achievement"] = true,
		["petIcon"] = true,		-- Add an Icon for battle pets on the tooltip
		["factionIcon"] = true, -- Add a faction icon on the tooltip
		["roleIcon"] = true,	-- Add a role icon on the tooltip?
	},

	["error"] = {
		["black"] = true,
		["combat"] = false,
		["white"] = false,
	},

	-- ["cooldownFlash"] = {
		-- ["enable"] = true,
		-- ["fadeInTime"] = 0.3,
		-- ["fadeOutTime"] = 0.6,
		-- ["maxAlpha"] = 0.8,
		-- ["animScale"] = 1.5,
		-- ["iconSize"] = 40,
		-- ["holdTime"] = 0.3,
		-- ["enablePet"] = false,
		-- ["showSpellName"] = false,
	-- },

	--UI Buttons
	["uiButtons"] = {
		["enabled"] = true,
		["style"] = "classic",
		["strata"] = "MEDIUM",
		["level"] = 5,
		["transparent"] = "Default",
		["size"] = 17,
		["mouse"] = false,
		["menuBackdrop"] = false,
		["dropdownBackdrop"] = false,
		["orientation"] = "vertical",
		["spacing"] = 3,
		["point"] = "TOPLEFT",
		["anchor"] = "TOPRIGHT",
		["xoffset"] = 0,
		["yoffset"] = 0,
		["visibility"] = "show",
		["customroll"] = {
			["min"] = "1",
			["max"] = "50",
		},
		["Config"] = {
			["enabled"] = false,
			["called"] = "Reload",
		},
		["Addon"] = {
			["enabled"] = false,
			["called"] = "Manager",
		},
		["Status"] = {
			["enabled"] = false,
			["called"] = "AFK",
		},
		["Roll"] = {
			["enabled"] = false,
			["called"] = "Hundred",
		},
	},

	-- db
	["dbCleaned"] = false
}