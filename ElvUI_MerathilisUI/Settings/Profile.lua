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
	Movertransparancy = .75,
	style = true,
	panels = true,
	stylePanels = true,
	shadowOverlay = true,
	filterErrors = true,
	hideErrorFrame = true,
}

MP.bags = {
	equipOverlay = true,
}

MP.merchant = {
	enable = true,
	style = "Default",
	subpages = 2,
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
	chatBar = false,
	emotes = true,
	filter = {
		enable = true,
		itemLevel = true,
		keywords = "",
		blockAddOnAlerts = true,
		damagemeter = true,
	},
	chatFade = {
		enable = true,
		minAlpha = 0.33,
		timeout = 8,
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
	lfgInfo = true,
	alerts = {
		lfg = false,
	},
	paragon = {
		enable = true,
		textStyle = "PARAGON",
		paragonColor = {r = 0.9, g = 0.8, b = 0.6},
	},
	skipAzerite = true,
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
	autoButtons = {
		enable = true,
		bindFontSize = 12,
		countFontSize = 12,
		slotAutoButtons = {
			enable = true,
			slotBBColorByItem = true,
			slotBBColor = {r = 1, g = 1, b = 1, a = 1},
			slotSpace = 1,
			slotDirection = "RIGHT",
			slotNum = 5,
			slotPerRow = 5,
			slotSize = 40,
			inheritGlobalFade = false,
		},
		questAutoButtons = {
			enable = true,
			questBBColorByItem = true,
			questBBColor = {r = 1, g = 1, b = 1, a = 1},
			questSpace = 1,
			questDirection = "RIGHT",
			questNum = 5,
			questPerRow = 5,
			questSize = 40,
			inheritGlobalFade = false,
		},
		usableAutoButtons = {
			enable = true,
			usableBBColorByItem = true,
			usableBBColor = {r = 1, g = 1, b = 1, a = 1},
			usableSpace = 1,
			usableDirection = "RIGHT",
			usableNum = 5,
			usablePerRow = 5,
			usableSize = 40,
			inheritGlobalFade = false,
		},
		whiteList = {
			[5512] = true, -- Healthstone
			[49040] = true, -- Jeeves
			[132514] = true, -- Auto-Hammer

			-- Professions (Bfa)
			[164733] = true, -- Synchronous Thread
			[164978] = true, -- Mallet of Thunderous Skins

			--Guild and Honor
			[63359] = true, -- Banner of Cooperation
			[64398] = true, -- Standard of Unity
			[64399] = true, -- Battle Standard of Coordination
			[18606] = true, -- Alliance Battle Standard
			[64400] = true, -- Banner of Cooperation
			[64401] = true, -- Standard of Unity
			[64402] = true, -- Battle Standard of Coordination
			[18607] = true, -- Horde Battle Standard

			--Legion
			[118330] = true, -- Pile of Weapons
			[122100] = true, -- Soul Gem
			[127030] = true, -- Granny"s Flare Grenades
			[127295] = true, -- Blazing Torch
			[128651] = true, -- Critter Hand Cannon
			[128772] = true, -- Branch of the Runewood
			[129161] = true, -- Stormforged Horn
			[129725] = true, -- Smoldering Torch
			[131931] = true, -- Khadgar"s Wand
			[133756] = true, -- Fresh Mound of Flesh
			[133882] = true, -- Trap Rune
			[133897] = true, -- Telemancy Beacon
			[133925] = true, -- Fel Lash
			[133999] = true, -- Inert Crystal
			[136605] = true, -- Solendra"s Compassion
			[137299] = true, -- Nightborne Spellblad
			[138146] = true, -- Rediant Ley Crystal
			[140916] = true, -- Satchel of Locklimb Powder
			[109076] = true, -- Goblin Glider Kit
			[147707] = true, -- Repurposed Fel Focuser
			[142117] = true, -- Potion of Prolonged Power
			[153023] = true, -- Lightforged Augment Rune

			--BFA
			[152494] = true, -- Coastal Healing Potion
			[152495] = true, -- Coastal Mana Potion
			[160053] = true, -- Battle-Scarred Augment Rune
			[163224] = true, -- Battle Potion of Strength
			[163223] = true, -- Battle Potion of Agility
			[163222] = true, -- Battle Potion of Intellect
			[163225] = true, -- Battle Potion of Stamina
			[168500] = true, -- Superior Battle Potion of Strength
			[168489] = true, -- Superior Battle Potion of Agility
			[168498] = true, -- Superior Battle Potion of Intellect
			[168499] = true, -- Superior Battle Potion of Stamina
			[169299] = true, -- Potion of Unbridled Fury
		},
		blackList = {},
		blackitemID = "",
		whiteItemID = "",
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
	auras = true,
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
	size = 34,
	perRow = 12,
	spacing = 2,
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
		hsPrio = "54452,64488,93672,142542,162973,163045,165669,165670,165802,166746,166747,172179",
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
	achievement = true,
	petIcon = true,
	factionIcon = true,
	keystone = true,
	azerite = {
		enable = true,
		onlyIcons = false,
	},
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

MP.dashboard = {
	dashfont = {
		useDTfont = true,
		dbfont = E.db.datatexts.font,
		dbfontsize = E.db.datatexts.fontSize,
		dbfontflags = E.db.datatexts.fontOutline,
	},

	barColor = 1,
	customBarColor = {r = 255/255,g = 128/255,b = 0/255},
	textColor = 2,
	customTextColor = {r = 255/255,g = 255/255,b = 255/255},

	system = {
		enableSystem = false,
		combat = false,
		width = 150,
		transparency = true,
		backdrop = true,
		chooseSystem = {
			FPS = true,
			MS = true,
			Volume = true,
		},
		latency = 2,
	},
}
