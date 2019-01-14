local MER, E, L, V, P, G = unpack(select(2, ...))

----------------------------------------------------------------------------------------
--	Core options
----------------------------------------------------------------------------------------
P["mui"] = {
	["installed"] = nil,

	["general"] = {
		["LoginMsg"] = true, -- Enable welcome message in chat
		["GameMenu"] = true, -- Enable the Styles GameMenu
		["splashScreen"] = true, -- Enable the SplashScreen on LogIn

		["AFK"] = true, -- Enable the pimped AFK Screen
		["FlightMode"] = true, -- Enable the FlightMode
		["FlightPoint"] = true, -- Enable the FlightPoints
		["CombatState"] = true, -- Enable the +/- Combat Message
		["MerchantiLevel"] = true, -- Displays the itemlevel on the Merchant Frame
		["Movertransparancy"] = .75,
		["style"] = true, -- Styling function (stripes/gradient)
		["panels"] = true,
		["shadowOverlay"] = true,
		["filterErrors"] = true,
		["hideErrorFrame"] = true,
	},

	["bags"] = {
		["transparentSlots"] = true,
	},

	["chat"] = {
		["chatButton"] = true,
		["panelHeight"] = 146,
		["iLevelLink"] = true,
		["hidePlayerBrackets"] = true,
		["sidePanel"] = false,
		["chatBar"] = true,
	},

	["colors"] = {
		["styleAlpha"] = 1,
	},

	["misc"] = {
		["MailInputbox"] = true, -- Resize the MailInputbox
		["gmotd"] = true, -- Show a GMOTD frame
		["quest"] = false,
		["announce"] = true, -- CombatText, Skill gains

		["cursor"] = false,
		["raidInfo"] = true,
	},

	["nameHover"] = {
		["enable"] = true,
		["fontSize"] = 7,
		["fontOutline"] = "OUTLINE",
	},

	["notification"] = {
		["enable"] = true,
		["noSound"] = false,
		["mail"] = true,
		["vignette"] = true,
		["invites"] = true,
		["guildEvents"] = true,
	},

	["datatexts"] = {
		["panels"] = {
			["ChatTab_Datatext_Panel"] = {
				["left"] = "Durability",
				["middle"] = "Bags",
				["right"] = "Coords",
			},
			["mUIMiddleDTPanel"] = {
				["left"] = "Guild",
				["middle"] = "MUI System",
				["right"] = "Friends",
			},
		},
		["middle"] = {
			["enable"] = true,
			["transparent"] = true,
			["backdrop"] = false,
			["width"] = 495,
			["height"] = 18,
		},
		["rightChatTabDatatextPanel"] = {
			["enable"] = true,
		},

		["threatBar"] = {
			["enable"] = true,
			["textSize"] = 10,
			["textOutline"] = "OUTLINE",
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

	["profdt"] = {
		["prof"] = "prof1",
		["hint"] = true,
	},

	["actionbars"] = {
		["cleanButton"] = true,
		["transparent"] = true,
		["specBar"] = {
			["enable"] = true,
			["mouseover"] = false,
		},
		["equipBar"] = {
			["enable"] = true,
			["mouseover"] = false,
		},
	},

	["microBar"] = {
		["enable"] = true,
		["scale"] = 1,
		["hideInCombat"] = true,
		["hideInOrderHall"] = false,
		["text"] = {
			["position"] = "BOTTOM",
			["friends"] = true,
			["guild"] = true,
		},
	},

	["unitframes"] = {
		["AuraIconText"] = {
			["durationTextPos"] = "CENTER",
			["durationTextOffsetX"] = 1,
			["durationTextOffsetY"] = 0,
			["stackTextPos"] = "BOTTOMRIGHT",
			["stackTextOffsetX"] = 1,
			["stackTextOffsetY"] = 2,
			["hideDurationText"] = false,
			["hideStackText"] = false,
			["durationFilterOwner"] = false,
			["durationThreshold"] = -1,
			["stackFilterOwner"] = false,
		},
		["AuraIconSpacing"] = {
			["spacing"] = 1,
			["units"] = {
				["player"] = true,
				["target"] = true,
				["targettarget"] = true,
				["targettargettarget"] = true,
				["focus"] = true,
				["focustarget"] = true,
				["pet"] = true,
				["pettarget"] = true,
				["arena"] = true,
				["boss"] = true,
				["party"] = true,
				["raid"] = true,
				["raid40"] = true,
				["raidpet"] = true,
				["tank"] = true,
				["assist"] = true,
			},
		},
		["infoPanel"] = {
			["style"] = true,
		},
		["castbar"] = {
			["text"] = {
				["ShowInfoText"] = false,
				["castText"] = true,
				["forceTargetText"] = false,
				["player"] = {
					["yOffset"] = 0,
					["textColor"] = {r = 1, g = 1, b = 1, a = 1},
				},
				["target"] = {
					["yOffset"] = 0,
					["textColor"] = {r = 1, g = 1, b = 1, a = 1},
				},
			},
		},
		["textures"] = {
			["castbar"] = "MerathilisFlat",
		},
	},

	["maps"] = {
		["minimap"] = {
			["flash"] = true,
			["coords"] = {
				["enable"] = true,
				["position"] = "BOTTOM",
			},
			["ping"] = {
				["enable"] = true,
				["position"] = "TOP",
				["xOffset"] = 0,
				["yOffset"] = -20,
			},
		},
	},

	["media"] = {
		["fonts"] = {
			["zone"] = {
				["font"] = "Expressway",
				["size"] = 32,
				["outline"] = "OUTLINE",
				["width"] = 512,
			},
			["subzone"] = {
				["font"] = "Expressway",
				["size"] = 25,
				["outline"] = "OUTLINE",
				["offset"] = 0,
				["width"] = 512,
			},
			["pvp"] = {
				["font"] = "Expressway",
				["size"] = 22,
				["outline"] = "OUTLINE",
				["width"] = 512,
			},
			["mail"] = {
				["font"] = "Expressway",
				["size"] = 12,
				["outline"] = "NONE",
			},
			["editbox"] = {
				["font"] = "Expressway",
				["size"] = 12,
				["outline"] = "NONE",
			},
			["gossip"] = {
				["font"] = "Expressway",
				["size"] = 12,
				["outline"] = "NONE",
			},
			["objective"] = {
				["font"] = "Expressway",
				["size"] = 11,
				["outline"] = "NONE",
			},
			["objectiveHeader"] = {
				["font"] = "Expressway",
				["size"] = 14,
				["outline"] = "OUTLINE",
			},
			["questFontSuperHuge"] = {
				["font"] = "Expressway",
				["size"] = 24,
				["outline"] = "NONE",
			},
		},
	},

	["smb"] = {
		["enable"] = true,
		["barMouseOver"] = true,
		["backdrop"] = true,
		["iconSize"] = 22,
		["buttonsPerRow"] = 6,
		["buttonSpacing"] = 2,
		["moveTracker"] = false,
		["moveQueue"] = false,
	},

	["locPanel"] = {
		["enable"] = true,
		["autowidth"] = false,
		["width"] = 336,
		["height"] = 21,
		["linkcoords"] = true,
		["template"] = "Transparent",
		["font"] = "Expressway",
		["fontSize"] = 11,
		["fontOutline"] = "OUTLINE",
		["throttle"] = 0.2,
		["format"] = "%.0f",
		["zoneText"] = true,
		["colorType"] = "REACTION",
		["colorType_Coords"] = "DEFAULT",
		["customColor"] = {r = 1, g = 1, b = 1 },
		["customColor_Coords"] = {r = 1, g = 1, b = 1 },
		["combathide"] = true,
		["orderhallhide"] = false,
		["coordshide"] = false,
		["portals"] = {
			["enable"] = true,
			["HSplace"] = true,
			["customWidth"] = false,
			["customWidthValue"] = 200,
			["justify"] = "LEFT",
			["cdFormat"] = "DEFAULT",
			["ignoreMissingInfo"] = false,
			["showHearthstones"] = true,
			["hsPrio"] = "54452,64488,93672,142542,162973,163045",
			["showToys"] = true,
			["showSpells"] = true,
			["showEngineer"] = true,
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
		["tooltip"] = true,
		["achievement"] = true, -- Adds information to the tooltip, on which char you earned an achievement
		["petIcon"] = true,		-- Add an Icon for battle pets on the tooltip
		["factionIcon"] = true, -- Add a faction icon on the tooltip
		["modelIcon"] = false, -- Add a model on the Tooltip
		["keystone"] = true, -- Adds descriptions for mythic keystone properties
	},

	["errorFilters"] = {
		[INTERRUPTED] = false,
		[ERR_ABILITY_COOLDOWN] = true,
		[ERR_ATTACK_CHANNEL] = false,
		[ERR_ATTACK_CHARMED] = false,
		[ERR_ATTACK_CONFUSED] = false,
		[ERR_ATTACK_DEAD] = false,
		[ERR_ATTACK_FLEEING] = false,
		[ERR_ATTACK_MOUNTED] = true,
		[ERR_ATTACK_PACIFIED] = false,
		[ERR_ATTACK_STUNNED] = false,
		[ERR_ATTACK_NO_ACTIONS] = false,
		[ERR_AUTOFOLLOW_TOO_FAR] = false,
		[ERR_BADATTACKFACING] = false,
		[ERR_BADATTACKPOS] = false,
		[ERR_CLIENT_LOCKED_OUT] = false,
		[ERR_GENERIC_NO_TARGET] = true,
		[ERR_GENERIC_NO_VALID_TARGETS] = true,
		[ERR_GENERIC_STUNNED] = false,
		[ERR_INVALID_ATTACK_TARGET] = true,
		[ERR_ITEM_COOLDOWN] = true,
		[ERR_NOEMOTEWHILERUNNING] = false,
		[ERR_NOT_IN_COMBAT] = false,
		[ERR_NOT_WHILE_DISARMED] = false,
		[ERR_NOT_WHILE_FALLING] = false,
		[ERR_NOT_WHILE_MOUNTED] = true,
		[ERR_NO_ATTACK_TARGET] = true,
		[ERR_OUT_OF_ENERGY] = true,
		[ERR_OUT_OF_FOCUS] = true,
		[ERR_OUT_OF_MANA] = true,
		[ERR_OUT_OF_RAGE] = true,
		[ERR_OUT_OF_RANGE] = true,
		[ERR_OUT_OF_RUNES] = true,
		[ERR_OUT_OF_RUNIC_POWER] = true,
		[ERR_SPELL_COOLDOWN] = true,
		[ERR_SPELL_OUT_OF_RANGE] = false,
		[ERR_TOO_FAR_TO_INTERACT] = false,
		[ERR_USE_BAD_ANGLE] = false,
		[ERR_USE_CANT_IMMUNE] = false,
		[ERR_USE_TOO_FAR] = false,
		[SPELL_FAILED_BAD_IMPLICIT_TARGETS] = true,
		[SPELL_FAILED_BAD_TARGETS] = true,
		[SPELL_FAILED_CASTER_AURASTATE] = true,
		[SPELL_FAILED_NO_COMBO_POINTS] = true,
		[SPELL_FAILED_SPELL_IN_PROGRESS] = true,
		[SPELL_FAILED_TARGET_AURASTATE] = true,
		[SPELL_FAILED_TOO_CLOSE] = false,
		[SPELL_FAILED_UNIT_NOT_INFRONT] = false,
		[SPELL_FAILED_NOT_ON_MOUNTED] = true,
		[SPELL_FAILED_NOT_MOUNTED] = true,
	},

	["raidBuffs"] = {
		["enable"] = true,
		["visibility"] = "INPARTY",
		["class"] = true,
		["size"] = 24,
		["alpha"] = 0.3,
		["glow"] = true,
		["customVisibility"] = "[noexists, nogroup] hide; show",
	},

	["reminder"] = {
		["enable"] = true,
		["size"] = 30,
	},

	["NameplateAuras"] = {
		["enable"] = true,
		["width"] = 28,
		["height"] = 14,
	},

	["cooldownFlash"] = {
		["enable"] = true,
		["fadeInTime"] = 0.3,
		["fadeOutTime"] = 0.6,
		["maxAlpha"] = 0.8,
		["animScale"] = 1.5,
		["iconSize"] = 40,
		["holdTime"] = 0.3,
		["enablePet"] = false,
		["showSpellName"] = false,
		["x"] = UIParent:GetWidth()/2,
		["y"] = UIParent:GetHeight()/2,
	},

	-- Armory
	["armory"] = {
		["enable"] = true,
		["azeritebtn"] = true,
		["undressButton"] = true,
		["enchantInfo"] = true,
		["socketInfo"] = true,
		["durability"] = {
			["enable"] = true,
			["onlydamaged"] = true,
			["font"] = "Expressway",
			["textSize"] = 11,
			["fontOutline"] = "OUTLINE",
		},
		["ilvl"] = {
			["enable"] = true,
			["font"] = "Expressway",
			["textSize"] = 11,
			["fontOutline"] = "OUTLINE",
			["colorStyle"] = "RARITY",
			["color"] = {r = 1, g = 1, b = 0},
		},
		["stats"] = {
			["IlvlFull"] = false,
			["IlvlColor"] = false,
			["AverageColor"] = {r = 0, g = 1, b = .59},
			["OnlyPrimary"] = true,
			["ItemLevel"] = {
				["font"] = "Expressway",
				["size"] = 20,
				["outline"] = "OUTLINE",
			},
			["statFonts"] = {
				["font"] = "Expressway",
				["size"] = 11,
				["outline"] = "OUTLINE",
			},
			["catFonts"] = {
				["font"] = "Expressway",
				["size"] = 12,
				["outline"] = "OUTLINE",
			},
			["List"] = {
				["HEALTH"] = false,
				["POWER"] = false,
				["ALTERNATEMANA"] = false,
				["ATTACK_DAMAGE"] = false,
				["ATTACK_AP"] = false,
				["ATTACK_ATTACKSPEED"] = false,
				["SPELLPOWER"] = false,
				["ENERGY_REGEN"] = false,
				["RUNE_REGEN"] = false,
				["FOCUS_REGEN"] = false,
				["MOVESPEED"] = false,
			},
		},
		["gradient"] = {
			["enable"] = true,
			["colorStyle"] = "VALUE",
			["color"] = {r = 1, g = 1, b = 0},
		},
	},
}
