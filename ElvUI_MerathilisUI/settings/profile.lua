local MER, E, L, V, P, G = unpack(select(2, ...))

----------------------------------------------------------------------------------------
--	Core options
----------------------------------------------------------------------------------------
P.mui = {}
local MP = P.mui

MP.core = {
	installed = nil,
}

MP.general = {
	LoginMsg = true,
	GameMenu = true,
	splashScreen = true,
	AFK = true,
	FlightMode = true,
	FlightPoint = true,
	CombatState = true,
	MerchantiLevel = true,
	Movertransparancy = .75,
	style = true,
	panels = true,
	shadowOverlay = true,
	filterErrors = true,
	hideErrorFrame = true,
}

MP.bags = {
	transparentSlots = true,
	equipOverlay = true,
}

MP.merchant = {
	enable = true,
	style = "Default",
	subpages = 2,
}

MP.chat = {
	chatButton = true,
	panelHeight = 146,
	hidePlayerBrackets = true,
	hideChat = false,
	chatBar = false,
	emotes = true,
	filter = {
		enable = true,
		itemLevel = true,
	},
}

MP.colors = {
	styleAlpha = 1,
}

MP.misc = {
	MailInputbox = true,
	gmotd = true,
	quest = false,
	announce = true,
	cursor = false,
	raidInfo = true,
	lfgInfo = true,
	alerts = {
		lfg = false,
	},
	paragon = {
		enable = true,
		textStyle = "PARAGON",
	},
	paragonColor = {r = 186 / 255, g = 183 / 255, b = 107 / 255, a = 1},
	progressbar = true,
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
}

MP.datatexts = {
	panels = {
		ChatTab_Datatext_Panel = {
			left = "Durability",
			middle = "Bags",
			right = "Coords",
		},
		mUIMiddleDTPanel = {
			left = "Guild",
			middle = "MUI System",
			right = "Friends",
		},
	},
	middle = {
		enable = true,
		transparent = true,
		backdrop = false,
		width = 495,
		height = 18,
	},
	rightChatTabDatatextPanel = {
		enable = true,
	},
	threatBar = {
		enable = true,
		textSize = 10,
		textOutline = "OUTLINE",
	},
}

MP.actionbars = {
	cleanButton = true,
	transparent = true,
	specBar = {
		enable = true,
		mouseover = false,
	},
	equipBar = {
		enable = true,
		mouseover = false,
	},
	autoButtons = {
		enable = true,
		bindFontSize = 12,
		countFontSize = 12,
		soltAutoButtons = {
			enable = true,
			slotBBColorByItem = true,
			slotBBColor = {r = 1, g = 1, b = 1, a = 1},
			slotNum = 5,
			slotPerRow = 5,
			slotSize = 40,
		},
		questAutoButtons = {
			enable = true,
			questBBColorByItem = true,
			questBBColor = {r = 1, g = 1, b = 1, a = 1},
			questNum = 5,
			questPerRow = 5,
			questSize = 40,
		},
	},
}

MP.microBar = {
	enable = true,
	scale = 1,
	hideInCombat = true,
	hideInOrderHall = false,
	tooltip = true,
	text = {
		position = "BOTTOM",
		friends = true,
		guild = true,
	},
}

MP.unitframes = {
	AuraIconSpacing = {
		spacing = 1,
		units = {
			player = true,
			target = true,
			targettarget = true,
			targettargettarget = true,
			focus = true,
			focustarget = true,
			pet = true,
			pettarget = true,
			arena = true,
			boss = true,
			party = true,
			raid = true,
			raid40 = true,
			raidpet = true,
			tank = true,
			assist = true,
		},
	},
	infoPanel = {
		style = true,
	},
	castbar = {
		text = {
			ShowInfoText = false,
			castText = true,
			forceTargetText = false,
			player = {
				yOffset = 0,
				textColor = {r = 1, g = 1, b = 1, a = 1},
			},
			target = {
				yOffset = 0,
				textColor = {r = 1, g = 1, b = 1, a = 1},
			},
		},
	},
	textures = {
		castbar = "MerathilisFlat",
	},
	units = {
		player = {
			gcd = {
				enable = true,
			},
		},
	},
}

MP.maps = {
	minimap = {
		flash = true,
		coords = {
			enable = true,
			position = "BOTTOM",
		},
		ping = {
			enable = true,
			position = "TOP",
			xOffset = 0,
			yOffset = -20,
		},
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
		editbox = {
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

MP.smb = {
	enable = true,
	barMouseOver = true,
	backdrop = true,
	iconSize = 22,
	buttonsPerRow = 6,
	buttonSpacing = 2,
	moveTracker = false,
	moveQueue = false,
	reverseDirection = false,
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
		hsPrio = "54452,64488,93672,142542,162973,163045,165669,165670,165802,166746,166747",
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

MP.tooltip = {
	tooltip = true,
	achievement = true,
	petIcon = true,
	factionIcon = true,
	keystone = true,
	azerite = true,
	titleColor = true,
	progressInfo = {
		enable = true,
		raid = {
			enable = true,
			Uldir = false,
			BattleOfDazaralor = false,
			CrucibleOfStorms = true,
			EternalPalace = true,
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
	size = 24,
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
	enablePet = false,
	showSpellName = false,
	x = UIParent:GetWidth()/2,
	y = UIParent:GetHeight()/2,
}

MP.raidCD = {
	enable = true,
	width = 200,
	height = 16,
	upwards = false,
	expiration = false,
	show_self = true,
	show_icon = true,
	show_inparty = false,
	show_inraid = true,
	show_inarena = false,
	text = {
		font = "Expressway",
		fontSize = 10,
		fontOutline = "OUTLINE",
	},
}

MP.armory = {
	enable = true,
	azeritebtn = true,
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
