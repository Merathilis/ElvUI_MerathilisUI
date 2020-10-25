local MER, E, L, V, P, G = unpack(select(2, ...))

----------------------------------------------------------------------------------------
--	Core options
----------------------------------------------------------------------------------------
P.mui = {}
local MP = P.mui

MP.core = {
	installed = false,
}

MP.general = {
	LoginMsg = true,
	GameMenu = true,
	splashScreen = true,
	AFK = true,
	FlightPoint = true,
	style = true,
	shadowOverlay = true,
}

MP.bags = {
	equipOverlay = true,
}

MP.merchant = {
	enable = true,
	style = "Default",
	subpages = 2,
}

MP.CombatAlert = {
	enable = true,
	style = {
		font = E.db.general.font,
		fontSize = 28,
		fontOutline = "THICKOUTLINE",
		backdrop = false,
		font_color_enter = {
			r = 0.91,
			g = 0.3,
			b = 0.24,
			a = 1.0,
		},
		font_color_leave = {
			r = 0.18,
			g = 0.8,
			b = 0.44,
			a = 1.0,
		},
		stay_duration = 1.5,
		animation_duration = 1,
		scale = 0.8,
	},
	custom_text = {
		enabled = false,
		custom_enter_text = L["Enter Combat"],
		custom_leave_text = L["Leave Combat"],
	},
}

MP.cvars = {
	general = {
		alwaysCompareItems = false,
		breakUpLargeNumbers = true,
		scriptErrors = true,
		trackQuestSorting = "top",
		autoLootDefault = false,
		autoDismountFlying = true,
		removeChatDelay = true,
		screenshotQuality = 10,
		showTutorials = false,
	},
	combatText = {
		worldTextScale = 0.75,
		targetCombatText = {
			floatingCombatTextCombatDamage = false,
			floatingCombatTextCombatLogPeriodicSpells = false,
			floatingCombatTextPetMeleeDamage = true,
			floatingCombatTextPetSpellDamage = true,
			floatingCombatTextCombatDamageDirectionalScale = 1,
			floatingCombatTextCombatHealing = false,
			floatingCombatTextCombatHealingAbsorbTarget = false,
			floatingCombatTextSpellMechanics = false,
			floatingCombatTextSpellMechanicsOther = false
		},
		playerCombatText = {
			enableFloatingCombatText = false,
			floatingCombatTextFloatMode = 1,
			floatingCombatTextDodgeParryMiss = false,
			floatingCombatTextCombatHealingAbsorbSelf = true,
			floatingCombatTextDamageReduction = false,
			floatingCombatTextLowManaHealth = true,
			floatingCombatTextRepChanges = false,
			floatingCombatTextEnergyGains = false,
			floatingCombatTextComboPoints = false,
			floatingCombatTextReactives = true,
			floatingCombatTextPeriodicEnergyGains = false,
			floatingCombatTextFriendlyHealers = false,
			floatingCombatTextHonorGains = false,
			floatingCombatTextCombatState = false,
			floatingCombatTextAuras = false
		},
	},
}

MP.chat = {
	chatButton = true,
	hidePlayerBrackets = true,
	hideChat = false,
	emotes = true,
	itemLevelLink = true,
	filter = {
		enable = true,
		keywords = "",
		blockAddOnAlerts = true,
		damagemeter = true,
	},
	chatFade = {
		enable = true,
		minAlpha = 0.33,
		timeout = 8,
		fadeOutTime = 0.65
	},
	seperators = {
		enable = true,
		visibility = "SHOWBOTH",
	},
	chatBar = {
		enable = false,
		style = "BLOCK",
		blockShadow = true,
		autoHide = false,
		mouseOver = false,
		backdrop = false,
		backdropSpacing = 2,
		buttonWidth = 40,
		buttonHeight = 5,
		spacing = 5,
		orientation = "HORIZONTAL",
		tex = "MerathilisMelli",
		font = {
			name = E.db.general.font,
			size = 12,
			style = "OUTLINE"
		},
		color = true,
		channels = {
			["SAY"] = {
				enable = true,
				cmd = "s",
				color = {r = 1, g = 1, b = 1, a = 1},
				abbr = _G.SAY
			},
			["YELL"] = {
				enable = true,
				cmd = "y",
				color = {r = 1, g = 0.25, b = 0.25, a = 1},
				abbr = _G.YELL
			},
			["EMOTE"] = {
				enable = false,
				cmd = "e",
				color = {r = 1, g = 0.5, b = 0.25, a = 1},
				abbr = _G.EMOTE
			},
			["PARTY"] = {
				enable = true,
				cmd = "p",
				color = {r = 0.67, g = 0.67, b = 1, a = 1},
				abbr = _G.PARTY
			},
			["INSTANCE"] = {
				enable = true,
				cmd = "i",
				color = {r = 1, g = 0.73, b = 0.2, a = 1},
				abbr = _G.INSTANCE
			},
			["RAID"] = {
				enable = true,
				cmd = "raid",
				color = {r = 1, g = 0.5, b = 0, a = 1},
				abbr = _G.RAID
			},
			["RAID_WARNING"] = {
				enable = false,
				cmd = "rw",
				color = {r = 1, g = 0.28, b = 0, a = 1},
				abbr = _G.RAID_WARNING
			},
			["GUILD"] = {
				enable = true,
				cmd = "g",
				color = {r = 0.25, g = 1, b = 0.25, a = 1},
				abbr = _G.GUILD
			},
			["OFFICER"] = {
				enable = false,
				cmd = "o",
				color = {r = 0.25, g = 0.75, b = 0.25, a = 1},
				abbr = _G.OFFICER
			},
			world = {
				enable = false,
				autoJoin = true,
				name = "",
				color = {r = 0.2, g = 0.6, b = 0.86, a = 1},
				abbr = L["World"]
			},
			community = {
				enable = false,
				name = "",
				color = {r = 0.72, g = 0.27, b = 0.86, a = 1},
				abbr = L["Community"]
			},
			emote = {
				enable = true,
				icon = true,
				color = {r = 1, g = 0.33, b = 0.52, a = 1},
				abbr = L["Wind Emote"]
			},
			roll = {
				enable = true,
				icon = true,
				color = {r = 0.56, g = 0.56, b = 0.56, a = 1},
				abbr = _G.ROLL
			},
		},
	},
}

MP.colors = {
	styleAlpha = 1,
}

MP.mail = {
	enable = true,
}

MP.misc = {
	gmotd = true,
	quest = {
		selectQuestReward =	true,
	},
	cursor = false,
	lfgInfo = {
		enable = true,
		title = true,
		mode = "NORMAL",
	},
	spellAlert = 0.65,
	alerts = {
		lfg = false,
		announce = true,
		itemAlert = true,
	},
	paragon = {
		enable = true,
		textStyle = "PARAGON",
		paragonColor = {r = 0.9, g = 0.8, b = 0.6},
	},
	funstuff = true,
	wowheadlinks = true,
	respec = true,
}

MP.nameHover = {
	enable = true,
	fontSize = 7,
	fontOutline = "OUTLINE",
}

MP.notification = {
	enable = true,
	noSound = false,
	mail = true,
	vignette = true,
	invites = true,
	guildEvents = true,
	paragon = true,
}

MP.databars = {}

MP.datatexts = {}

MP.actionbars = {
	customGlow = true,
	specBar = {
		enable = true,
		mouseover = false,
		size = 20,
	},
	equipBar = {
		enable = true,
		mouseover = false,
		size = 28,
	},
	randomToy = {
		enable = true,
		toyList = {
			[1973] = true,
			[118937] = true,
			[98552] = true,
			[128462] = true,
			[130158] = true,
			[111476] = true,
			[113375] = true,
			[166779] = true,
			[108743] = true,
			[119215] = true,
			[129149] = true,
			[118938] = true,
			[108739] = true,
			[127864] = true,
			[163750] = true,
			[140325] = true,
			[119092] = true,
			[119134] = true,
			[127670] = true,
			[35275] = true,
			[138878] = true,
			[118244] = true,
			[151271] = true,
			[151270] = true,
			[128471] = true,
			[129093] = true,
			[153180] = true,
			[128807] = true,
		},
	},
}

MP.autoButtons = {
	enable = true,
	customList = {},
	blackList = {},
	bar1 = {
		enable = true,
		mouseOver = false,
		fadeTime = 0.3,
		alphaMin = 0,
		alphaMax = 1,
		numButtons = 12,
		backdrop = true,
		backdropSpacing = 1,
		buttonWidth = 35,
		buttonHeight = 30,
		buttonsPerRow = 12,
		anchor = "TOPLEFT",
		spacing = 3,
		inheritGlobalFade = true,
		countFont = {
			name = "Expressway",
			size = 12,
			style = "OUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1
			},
		},
		bindFont = {
			name = "Expressway",
			size = 12,
			style = "OUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1
			},
		},
		include = "QUEST,BANNER,EQUIP"
	},
	bar2 = {
		enable = true,
		mouseOver = false,
		fadeTime = 0.3,
		alphaMin = 0,
		alphaMax = 1,
		numButtons = 12,
		backdrop = true,
		backdropSpacing = 1,
		buttonWidth = 35,
		buttonHeight = 30,
		buttonsPerRow = 12,
		anchor = "TOPLEFT",
		spacing = 3,
		inheritGlobalFade = true,
		countFont = {
			name = "Expressway",
			size = 12,
			style = "OUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1
			},
		},
		bindFont = {
			name = "Expressway",
			size = 12,
			style = "OUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1
			},
		},
		include = "POTION,FLASK,UTILITY"
	},
	bar3 = {
		enable = false,
		mouseOver = false,
		fadeTime = 0.3,
		alphaMin = 0,
		alphaMax = 1,
		numButtons = 12,
		backdrop = true,
		backdropSpacing = 1,
		buttonWidth = 35,
		buttonHeight = 30,
		buttonsPerRow = 12,
		anchor = "TOPLEFT",
		spacing = 3,
		inheritGlobalFade = true,
		countFont = {
			name = "Expressway",
			size = 12,
			style = "OUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1
			},
		},
		bindFont = {
			name = "Expressway",
			size = 12,
			style = "OUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1
			},
		},
		include = "CUSTOM"
	},
}

MP.microBar = {
	enable = true,
	mouseOver = false,
	backdrop = true,
	backdropSpacing = 2,
	timeAreaWidth = 80,
	timeAreaHeight = 35,
	buttonSize = 20,
	spacing = 3,
	fadeTime = 0.618,
	normalColor = "NONE",
	hoverColor = "CLASS",
	customNormalColor = {r = 1, g = 1, b = 1},
	customHoverColor = {r = 0, g = 0.659, b = 1},
	visibility = "[petbattle][combat] hide; show",
	tooltipPosition = "ANCHOR_BOTTOM",
	time = {
		localTime = true,
		twentyFour = true,
		flash = true,
		interval = 10,
		font = {
			name = E.db.general.font,
			size = 25,
			style = "OUTLINE"
		}
	},
	home = {
		left = "6948",
		right = "141605"
	},
	additionalText = {
		enable = true,
		slowMode = true,
		anchor = "BOTTOMRIGHT",
		x = 3,
		y = -3,
		font = {
			name = E.db.general.font,
			size = 12,
			style = "OUTLINE"
		}
	},
	left = {
		[1] = "CHARACTER",
		[2] = "SPELLBOOK",
		[3] = "TALENTS",
		[4] = "FRIENDS",
		[5] = "GUILD",
		[6] = "GROUP_FINDER",
		[7] = "SCREENSHOT"
	},
	right = {
		[1] = "HOME",
		[2] = "ACHIEVEMENTS",
		[3] = "MISSION_REPORTS",
		[4] = "ENCOUNTER_JOURNAL",
		[5] = "TOY_BOX",
		[6] = "PET_JOURNAL",
		[7] = "BAGS"
	}
}

MP.unitframes = {
	healPrediction = false,
	swing = {
		enable = false,
		mcolor = { r = .8, g = .8, b = .8 },
		tcolor = { r = .65, g = .63, b = .35 },
		ocolor = { r = 0, g = .5, b = 1 },
	},
	gcd = {
		enable = false,
		color = { r = .8, g = .8, b = .8 },
	},
	counterBar = {
		enable = true,
	},
	style = true,
	raidIcons = true,
	roleIcons = true,
	highlight = true,
}

MP.maps = {
	minimap = {
		flash = true,
		difficulty = true,
		coords = {
			enable = true,
			position = "BOTTOM",
		},
		ping = {
			enable = true,
			xOffset = 0,
			yOffset = 0,
			fadeInTime = 0.5,
			stayTime = 3,
			fadeOutTime = 0.5,
			addRealm = false,
			onlyInCombat = false,
			classColor = true,
			customColor = {r = 1, g = 1, b = 1},
			font = {
				name = E.db.general.font,
				size = 12,
				style = "OUTLINE"
			},
		},
		rectangle = false,
	},
}

MP.media = {
	zoneText = {
		enable = true,
		zone = {
			font = "Expressway",
			size = 32,
			outline = "OUTLINE",
			width = 512,
		},
		subzone = {
			font = "Expressway",
			size = 25,
			outline = "OUTLINE",
			width = 512,
		},
		pvp = {
			font = "Expressway",
			size = 22,
			outline = "OUTLINE",
			width = 512,
		},
	},
	miscText = {
		mail = {
			enable = true,
			font = "Expressway",
			size = 12,
			outline = "NONE",
		},
		gossip = {
			enable = true,
			font = "Expressway",
			size = 12,
			outline = "NONE",
		},
		objective = {
			enable = true,
			font = "Expressway",
			size = 11,
			outline = "NONE",
		},
		objectiveHeader = {
			enable = true,
			font = "Expressway",
			size = 14,
			outline = "OUTLINE",
		},
		questFontSuperHuge = {
			enable = true,
			font = "Expressway",
			size = 24,
			outline = "NONE",
		},
	},
}

MP.panels = {
	topPanel = true,
	bottomPanel = true,
	stylePanels = {
		topLeftPanel = true,
		topLeftExtraPanel = true,
		topRightPanel = true,
		topRightExtraPanel = true,
		bottomLeftPanel = true,
		bottomLeftExtraPanel = true,
		bottomRightPanel = true,
		bottomRightExtraPanel = true,
	},
	topPanelHeight = 15,
	bottomPanelHeight = 15,
	panelSize = 427,
}

MP.smb = {
	enable = true,
	size = 30,
	perRow = 6,
	spacing = 1,
}

MP.locPanel = {
	enable = true,
	autowidth = false,
	width = 336,
	height = 21,
	linkcoords = true,
	template = "Transparent",
	font = "Expressway",
	fontSize = 11,
	fontOutline = "OUTLINE",
	throttle = 0.2,
	format = "%.0f",
	zoneText = true,
	colorType = "REACTION",
	colorType_Coords = "DEFAULT",
	customColor = {r = 1, g = 1, b = 1 },
	customColor_Coords = {r = 1, g = 1, b = 1 },
	combathide = true,
	orderhallhide = false,
	coordshide = false,
	portals = {
		enable = true,
		HSplace = true,
		customWidth = false,
		customWidthValue = 200,
		justify = "LEFT",
		cdFormat = "DEFAULT",
		ignoreMissingInfo = false,
		showHearthstones = true,
		hsPrio = "54452,64488,93672,142542,162973,163045,165669,165670,165802,166746,166747,168907,172179,184353",
		showToys = true,
		showSpells = true,
		showEngineer = true,
	},
}

MP.raidmarkers = {
	enable = true,
	visibility = "INPARTY",
	customVisibility = "[noexists, nogroup] hide; show",
	backdrop = false,
	buttonSize = 18,
	spacing = 2,
	orientation = "HORIZONTAL",
	modifier = "shift-",
	reverse = false,
}

MP.raidmanager = {
	enable = true,
	unlockraidmarks = false,
	count = "10",
}

MP.pvp = {
	duels = {
		regular = false,
		pet = false,
		announce = false,
	},
	killingBlow = {
		enable = true,
		sound = true,
	},
}

MP.tooltip = {
	tooltipIcon = true,
	factionIcon = true,
	petIcon = true,
	keystone = true,
	titleColor = true,
	progressInfo = {
		enable = true,
		raid = {
			enable = true,
			Uldir = false,
			BattleOfDazaralor = false,
			CrucibleOfStorms = false,
			EternalPalace = true,
			Nyalotha = true,
			CastleNathria = true,
		}
	},
}

MP.errorFilters = {
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
}

MP.raidBuffs = {
	enable = true,
	visibility = "INPARTY",
	class = true,
	size = 30,
	alpha = 0.3,
	glow = true,
	customVisibility = "[noexists, nogroup] hide; show",
}

MP.reminder = {
	enable = true,
	size = 30,
}

MP.nameplates = {
	castbarShield = true,
	enhancedAuras = {
		enable = true,
		width = 26,
		height = 18,
	},
}

MP.cooldownFlash = {
	enable = true,
	fadeInTime = 0.3,
	fadeOutTime = 0.6,
	maxAlpha = 0.8,
	animScale = 1.5,
	iconSize = 40,
	holdTime = 0.3,
	petOverlay = {1, 1, 1},
	ignoredSpells = "",
	invertIgnored = false,
	enablePet = false,
	showSpellName = false,
	x = UIParent:GetWidth()*UIParent:GetEffectiveScale()/2,
	y = UIParent:GetHeight()*UIParent:GetEffectiveScale()/2,
}

MP.armory = {
	enable = true,
	undressButton = true,
	durability = {
		enable = true,
		onlydamaged = true,
		font = "Expressway",
		textSize = 11,
		fontOutline = "OUTLINE",
	},
	stats = {
		OnlyPrimary = true,
		statFonts = {
			font = "Expressway",
			size = 11,
			outline = "OUTLINE",
		},
		catFonts = {
			font = "Expressway",
			size = 12,
			outline = "OUTLINE",
		},
		List = {
			HEALTH = false,
			POWER = false,
			ALTERNATEMANA = false,
			ATTACK_DAMAGE = false,
			ATTACK_AP = false,
			ATTACK_ATTACKSPEED = false,
			SPELLPOWER = false,
			ENERGY_REGEN = false,
			RUNE_REGEN = false,
			FOCUS_REGEN = false,
			MOVESPEED = false,
		},
	},
	gradient = {
		enable = true,
		colorStyle = "VALUE",
		color = {r = 1, g = 1, b = 0},
	},
	transmog = {
		enable = true,
	},
	illusion = {
		enable = true,
	},
}

MP.flightMode = {
	enable = true,
	BenikFlightMode = true,
}
