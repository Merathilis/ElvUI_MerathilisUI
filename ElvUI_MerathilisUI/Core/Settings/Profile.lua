local MER, F, E, L, V, P, G = unpack(select(2, ...))

local _G = _G

P.core = {
	installed = false,
}

P.general = {
	GameMenu = true,
	splashScreen = true,
	AFK = true,
	FlightPoint = true,
}

P.bags = {
	Enable = true,
	IconSize = 34,
	IconSpacing = 3,
	FontSize = 11,
	BagsWidth = 12,
	BankWidth = 12,
	BagsiLvl = true,
	BindType = true,
	CenterText = true,
	BagSortMode = 2,
	ItemFilter = true,
	CustomItems = {},
	CustomNames = {},
	GatherEmpty = false,
	ShowNewItem = true,
	SplitCount = 1,
	SpecialBagsColor = false,
	iLvlToShow = 1,
	AutoDeposit = false,
	PetTrash = true,
	BagsPerRow = 6,
	BankPerRow = 10,
	HideWidgets = true,

	FilterJunk = true,
	FilterAmmo = true,
	FilterConsumable = true,
	FilterAzerite = false,
	FilterEquipment = true,
	FilterLegendary = true,
	FilterCollection = true,
	FilterFavourite = true,
	FilterGoods = false,
	FilterQuest = false,
	FilterEquipSet = false,
	FilterAnima = false,
	FilterRelic = false,

	equipOverlay = true,
}

P.merchant = {
	enable = true,
	numberOfPages = 2,
}

P.blizzard = {
	objectiveTracker = {
		enable = true,
		noDash = true,
		colorfulProgress = true,
		percentage = false,
		colorfulPercentage = false,
		backdrop = {
			enable = false,
			transparent = true,
			topLeftOffsetX = 0,
			topLeftOffsetY = 0,
			bottomRightOffsetX = 0,
			bottomRightOffsetY = 0,
		},
		header = {
			name = E.db.general.font,
			size = E.db.general.fontSize + 2,
			style = "OUTLINE",
			classColor = false,
			color = {r = 1, g = 1, b = 1},
			shortHeader = true
		},
		cosmeticBar = {
			enable = true,
			texture = "Asphyxia",
			widthMode = "ABSOLUTE",
			heightMode = "ABSOLUTE",
			width = 212,
			height = 2,
			offsetX = 0,
			offsetY = -13,
			border = "SHADOW",
			borderAlpha = 1,
			color = {
				mode = "GRADIENT",
				normalColor = {r = 0, g = 0.659, b = 1.000, a = 1},
				gradientColor1 = {r = 0.32941, g = 0.52157, b = 0.93333, a = 1},
				gradientColor2 = {r = 0, g = 0.752, b = 0.980, a = 1}
			}
		},
		title = {
			name = E.db.general.font,
			size = E.db.general.fontSize + 1,
			style = "OUTLINE"
		},
		info = {
			name = E.db.general.font,
			size = E.db.general.fontSize,
			style = "OUTLINE"
		},
		titleColor = {
			enable = true,
			classColor = false,
			customColorNormal = {r = 0, g = 0.752, b = 0.980},
			customColorHighlight = {r = 0.282, g = 0.859, b = 0.984}
		},
		menuTitle = {
			enable = true,
			classColor = false,
			color = { r = 0.000, g = 0.659, b = 1.000 },
			font = {
				name = E.db.general.font,
				size = E.db.general.fontSize,
				style = "OUTLINE",
			},
		},
	},
	filter = {
		enable = true,
		unblockProfanityFilter = true,
	},
	friendsList = {
		enable = true,
		level = true,
		hideMaxLevel = true,
		useGameColor = true,
		useClientColor = true,
		useNoteAsName = false,
		textures = {
			client = "modern",
			status = "square",
			factionIcon = false
		},
		areaColor = {
			r = 1,
			g = 1,
			b = 1
		},
		nameFont = {
			name = E.db.general.font,
			size = 13,
			style = "OUTLINE"
		},
		infoFont = {
			name = E.db.general.font,
			size = 12,
			style = "OUTLINE"
		},
	},
}

P.CombatAlert = {
	enable = true,
	font = {
		name = "Expressway",
		size = 28,
		style = "THICKOUTLINE",
	},
	style = {
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

P.cvars = {
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
		cameraFov = 90,
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

P.chat = {
	chatButton = true,
	hidePlayerBrackets = true,
	hideChat = false,
	customOnlineMessage = true,
	emotes = true,
	roleIcons = {
		enable = true,
		roleIconSize = 16,
		roleIconStyle = "SUNUI",
	},
	filter = {
		enable = true,
		keywords = "",
		blockAddOnAlerts = true,
		damagemeter = false,
	},
	chatFade = {
		enable = false,
		minAlpha = 0.33,
		timeout = 8,
		fadeOutTime = 0.65
	},
	seperators = {
		enable = true,
		visibility = "LEFT",
	},
	chatBar = {
		enable = true,
		style = "BLOCK",
		blockShadow = true,
		autoHide = false,
		mouseOver = false,
		backdrop = false,
		backdropSpacing = 2,
		buttonWidth = 54,
		buttonHeight = 5,
		spacing = 5,
		orientation = "HORIZONTAL",
		tex = "Asphyxia",
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
			roll = {
				enable = true,
				icon = true,
				color = {r = 0.56, g = 0.56, b = 0.56, a = 1},
				abbr = _G.ROLL
			},
		},
	},
	chatLink = {
		enable = true,
		numbericalQualityTier = false,
		translateItem = true,
		level = true,
		icon = true,
		armorCategory = true,
		weaponCategory = true,
		compatibile = true
	},
}

P.colors = {
	styleAlpha = 1,
}

P.mail = {
	enable = true,
	defaultPage = "ALTS",
	saveRecipient = true,
}

P.announcement = {
	enable = true,
	emoteFormat = ": %s",
	quest = {
		enable = false,
		paused = true,
		disableBlizzard = true,
		includeDetails = true,
		channel = {
			party = "PARTY",
			instance = "INSTANCE_CHAT",
			raid = "RAID"
		},
		tag = {
			enable = true,
			color = { r = 0.490, g = 0.373, b = 1.000 }
		},
		suggestedGroup = {
			enable = true,
			color = { r = 1.000, g = 0.220, b = 0.220 }
		},
		level = {
			enable = true,
			color = { r = 0.773, g = 0.424, b = 0.941 },
			hideOnMax = true
		},
		daily = {
			enable = true,
			color = { r = 1.000, g = 0.980, b = 0.396 }
		},
		weekly = {
			enable = true,
			color = { r = 0.196, g = 1.000, b = 0.494 }
		},
	},
	resetInstance = {
		enable = true,
		prefix = true,
		channel = {
			party = "PARTY",
			instance = "INSTANCE_CHAT",
			raid = "RAID"
		}
	},
	utility = {
		enable = true,
		channel = {
			solo = "NONE",
			party = "PARTY",
			instance = "INSTANCE_CHAT",
			raid = "RAID"
		},
		spells = {
			["698"] = {
				-- Ritual of Summoning
				enable = true,
				includePlayer = true,
				raidWarning = true,
				text = L["{rt1} %player% is casting %spell%, please assist! {rt1}"]
			},
			["29893"] = {
				-- Create Soulwell
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% is handing out %spell%, go and get one! {rt1}"]
			},
			["54710"] = {
				-- MOLL-E
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% puts %spell% {rt1}"]
			},
			["261602"] = {
				-- Stampwhistle
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% used %spell% {rt1}"]
			},
			["376664"] = {
				-- Ohuna Perch
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["%player% used %spell%"]
			},
			["195782"] = {
				-- Summon Moonfeather Statue
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% used %spell% {rt1}"]
			},
			["190336"] = {
				-- Conjure Refreshment
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% cast %spell%, today's special is Anchovy Pie! {rt1}"]
			},
			feasts = {
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% puts down %spell%! {rt1}"]
			},
			bots = {
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% puts %spell% {rt1}"]
			},
			toys = {
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% puts %spell% {rt1}"]
			},
			portals = {
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% opened %spell%! {rt1}"]
			},
			hero = {
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% used %spell% {rt1}"]
			}
		}
	},
	keystone = {
		enable = true,
		text = L["{rt1} My new keystone is %keystone%. {rt1}"],
		channel = {
			party = "PARTY"
		},
		command = true,
	}
}

P.misc = {
	gmotd = true,
	quest = {
		selectQuestReward =	true,
	},
	cursor = {
		enable = false,
		colorType = "CLASS",
		customColor = {r = 0, g = .75, b = .98}
	},
	lfgInfo = {
		enable = true,
		title = true,
		mode = "NORMAL",
		icon = {
			reskin = true,
			pack = "SQUARE",
			size = 16,
			border = true,
			alpha = 1
		},
		line = {
			enable = true,
			tex = "ElvUI Norm",
			width = 16,
			height = 3,
			offsetX = 0,
			offsetY = -1,
			alpha = 1
		},
	},
	spellAlert = {
		enable = true,
		scale = 0.65,
	},
	funstuff = true,
	wowheadlinks = true,
	respec = true,
	hideBossBanner = false,
	quickDelete = true,
	quickMenu = true,
	tradeTabs = true,
	alreadyKnown = {
		enable = true,
		mode = "COLOR",
		color = {
			r = 0,
			g = 1,
			b = 0
		},
	},
	mute = {
		enable = true,
		mount = {
			[63796] = false,
			[229385] = false,
			[339588] = false,
			[312762] = false
		},
		other = {
			["Crying"] = false,
			["Tortollan"] = false,
			["Smolderheart"] = false,
			["Elegy of the Eternals"] = false,
			["Dragonriding"] = true,
			["Jewelcrafting"] = false
		}
	}
}

P.nameHover = {
	enable = true,
	fontSize = 7,
	fontOutline = "OUTLINE",
	targettarget = false,
}

P.notification = {
	enable = true,
	noSound = false,
	mail = true,
	invites = true,
	guildEvents = true,
	paragon = true,
	quickJoin = true,
	callToArms = false,
	vignette = {
		enable = true,
		print = true,
		debugPrint = false,
		blacklist = {
			[5485] = true,
		},
	},
	titleFont = {
		name = "Expressway",
		size = 12,
		style = "OUTLINE",
	},
	textFont = {
		name = "Expressway",
		size = 11,
		style = "OUTLINE",
	},
}

P.databars = {}

P.datatexts = {
	RightChatDataText = true,
}

P.actionbars = {
	specBar = {
		enable = true,
		mouseover = false,
		frameStrata = "BACKGROUND",
		frameLevel = 1,
		size = 20,
	},
	equipBar = {
		enable = true,
		mouseover = false,
		frameStrata = "BACKGROUND",
		frameLevel = 1,
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
	keyfeedback = {
		enable = false,
		point = 'CENTER',
		x = 0,
		y = 0,
		enableCastLine = true,
		enableCooldown = true,
		enablePushEffect = true,
		enableCast = true,
		enableCastFlash = true,
		lineIconSize = 28,
		mirrorSize = 32,
		lineDirection = 'RIGHT',
		forceUseActionHook = true, -- Probably ElvUI needs this
	},
}

local function Filter()
	if E.Classic then
		return "POTION,FLASK,UTILITY"
	elseif E.TBC then
		return "POTIONTBC,FLASKTBC,CAULDRONTBC,ELIXIRTBC,ORETBC,UTILITY"
	elseif E.Wrath then
		return "POTIONSWRATH,FLASKWRATH,UTILITY"
	elseif E.Retail then
		return "POTIONDF,FLASKDF,RUNE,UTILITY"
	end
end

P.autoButtons = {
	enable = true,
	customList = {},
	blackList = {
		[183040] = true,
		[193757] = true,
		[200563] = true,
	},
	bar1 = {
		enable = true,
		mouseOver = false,
		globalFade = false,
		fadeTime = 0.3,
		alphaMin = 0,
		alphaMax = 1,
		numButtons = 10,
		backdrop = true,
		backdropSpacing = 1,
		buttonWidth = 30,
		buttonHeight = 26,
		buttonsPerRow = 10,
		anchor = "TOPLEFT",
		spacing = 3,
		tooltip = false,
		qualityTier = {
			size = 16,
			xOffset = 0,
			yOffset = 0,
		},
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
		include = "QUEST,BANNER,EQUIP,PROF,OPENABLE"
	},
	bar2 = {
		enable = true,
		mouseOver = false,
		globalFade = false,
		fadeTime = 0.3,
		alphaMin = 0,
		alphaMax = 1,
		numButtons = 10,
		backdrop = true,
		backdropSpacing = 1,
		buttonWidth = 30,
		buttonHeight = 26,
		buttonsPerRow = 10,
		anchor = "TOPLEFT",
		spacing = 3,
		tooltip = true,
		qualityTier = {
			size = 16,
			xOffset = 0,
			yOffset = 0,
		},
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
		--include = "POTIONSL,FLASKSL,UTILITY"
		include = Filter()
	},
	bar3 = {
		enable = true,
		mouseOver = false,
		globalFade = false,
		fadeTime = 0.3,
		alphaMin = 0,
		alphaMax = 1,
		numButtons = 10,
		backdrop = true,
		backdropSpacing = 1,
		buttonWidth = 30,
		buttonHeight = 26,
		buttonsPerRow = 10,
		anchor = "TOPLEFT",
		spacing = 3,
		tooltip = true,
		qualityTier = {
			size = 16,
			xOffset = 0,
			yOffset = 0,
		},
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
		include = "MAGEFOOD,FOODVENDOR,FOODDF,CUSTOM"
	},
	bar4 = {
		enable = false,
		mouseOver = false,
		globalFade = false,
		fadeTime = 0.3,
		alphaMin = 1,
		alphaMax = 1,
		numButtons = 12,
		backdrop = true,
		backdropSpacing = 3,
		buttonWidth = 35,
		buttonHeight = 30,
		buttonsPerRow = 12,
		anchor = "TOPLEFT",
		spacing = 3,
		tooltip = true,
		qualityTier = {
			size = 16,
			xOffset = 0,
			yOffset = 0,
		},
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
			}
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
			}
		},
		include = "CUSTOM"
	},
	bar5 = {
		enable = false,
		mouseOver = false,
		globalFade = false,
		fadeTime = 0.3,
		alphaMin = 1,
		alphaMax = 1,
		numButtons = 12,
		backdrop = true,
		backdropSpacing = 3,
		buttonWidth = 35,
		buttonHeight = 30,
		buttonsPerRow = 12,
		anchor = "TOPLEFT",
		spacing = 3,
		tooltip = true,
		qualityTier = {
			size = 16,
			xOffset = 0,
			yOffset = 0,
		},
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
			}
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
			}
		},
		include = "CUSTOM"
	}
}

P.microBar = {
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
	customNormalColor = { r = 1, g = 1, b = 1 },
	customHoverColor = { r = 0, g = 0.659, b = 1 },
	notification = true,
	visibility = "[petbattle] hide; show",
	tooltipsAnchor = "ANCHOR_BOTTOM",
	friends = {
		showAllFriends = false
	},
	time = {
		localTime = true,
		twentyFour = true,
		flash = true,
		interval = 10,
		alwaysSystemInfo = false,
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

P.unitframes = {
	healPrediction = {
		enable = false,
		texture = {
			enable = true,
			custom = E.db.unitframe.statusbar,
			blizzardStyle = false,
		},
		blizzardOverAbsorbGlow = true,
		blizzardAbsorbOverlay = true,
	},
	power = {
		enable = true,
		type = "DEFAULT",
		model = 1715069,
		texture = E.db.unitframe.statusbar,
	},
	castbar = {
		enable = true,
		texture = "Gradient",
		spark = {
			enable = true,
			texture = "Gradient",
			width = 3,
			color = { r = 0, g = .75, b = .98 , a = 1},
		},
	},
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
	roleIcons = {
		enable = true,
		roleIconStyle = "SUNUI",
	},
	highlight = true,
	auras = true,
}

P.maps = {
	minimap = {
		flash = true,
		ping = {
			enable = true,
			xOffset = 0,
			yOffset = 2,
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
	},
	instanceDifficulty = {
		enable = true,
		hideBlizzard = true,
		align = "LEFT",
		font = {
			name = E.db.general.font,
			size = E.db.general.fontSize,
			style = "OUTLINE"
		},
	},
	rectangleMinimap = {
		enable = false,
		heightPercentage = 0.8
	},
	superTracker = {
		enable = true,
		noLimit = false,
		autoTrackWaypoint = true,
		middleClickToClear = true,
		distanceText = {
			enable = true,
			name = E.db.general.font,
			size = E.db.general.fontSize + 2,
			style = "OUTLINE",
			color = {r = 1, g = 1, b = 1},
		},
		waypointParse = {
			enable = true,
			worldMapInput = true,
			command = true,
			virtualTomTom = true,
			commandKeys = {
				["wtgo"] = true,
				["goto"] = true,
			},
		},
	},
	worldMap = {
		enable = true,
		reveal = {
			enable = true,
			useColor = true,
			color = {r = 0, g = 0, b = 0, a = 0.50}
		},
		scale = {
			enable = true,
			size = 1.24
		},
	},
	eventTracker = {
		enable = true,
		desaturate = true,
		spacing = 10,
		height = 38,
		yOffset = -3,
		backdrop = true,
		font = {
			name = E.db.general.font,
			scale = 1,
			outline = "OUTLINE"
		},
		communityFeast = {
			enable = true,
			desaturate = false,
			alert = true,
			sound = true,
			soundFile = "OnePlus Light",
			second = 600,
			stopAlertIfCompleted = true,
			stopAlertIfPlayerNotEnteredDragonlands = true
		},
		siegeOnDragonbaneKeep = {
			enable = true,
			desaturate = false,
			alert = true,
			sound = true,
			soundFile = "OnePlus Light",
			second = 600,
			stopAlertIfCompleted = true,
			stopAlertIfPlayerNotEnteredDragonlands = true
		},
		iskaaranFishingNet = {
			enable = true,
			alert = true,
			sound = true,
			soundFile = "OnePlus Surprise",
			disableAlertAfterHours = 48,
		}
	},
}

P.media = {
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
			outline = "OUTLINE",
		},
		gossip = {
			enable = true,
			font = "Expressway",
			size = 12,
			outline = "OUTLINE",
		},
		questFontSuperHuge = {
			enable = true,
			font = "Expressway",
			size = 24,
			outline = "OUTLINE",
		},
	},
}

P.panels = {
	colorType = "CLASS",
	customColor = {r = 1, g = 1, b = 1 },
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

P.smb = {
	enable = true,
	mouseOver = true,
	buttonsPerRow = 7,
	buttonSize = 24,
	backdrop = true,
	backdropSpacing = 3,
	spacing = 1,
	inverseDirection = false,
	orientation = "HORIZONTAL",
	-- calendar = false,
	expansionLandingPage = false
}

P.locPanel = {
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
		hsPrio = "200630,193588,190237,54452,64488,93672,142542,162973,163045,165669,165670,165802,166746,166747,168907,172179,180290,182773,184353,183716,188952",
		showToys = true,
		showSpells = true,
		showEngineer = true,
	},
}

P.raidmarkers = {
	enable = true,
	mouseOver = false,
	tooltip = true,
	visibility = "DEFAULT",
	backdrop = true,
	backdropSpacing = 3,
	buttonSize = 20,
	buttonBackdrop = true,
	buttonAnimation = true,
	buttonAnimationDuration = 0.2,
	buttonAnimationScale = 1.33,
	spacing = 4,
	orientation = "HORIZONTAL",
	modifier = "shift",
	readyCheck = true,
	countDown = true,
	countDownTime = 5,
	inverse = false
}

P.raidmanager = {
	enable = true,
	unlockraidmarks = false,
	count = "10",
}

P.pvp = {
	duels = {
		regular = false,
		pet = false,
		announce = false,
	},
	killingBlow = {
		enable = true,
		sound = true,
	},
	rebirth = true,
	autorelease = false,
}

P.tooltip = {
	modifier = "SHIFT",
	icon = true,
	factionIcon = true,
	petIcon = true,
	petId = true,
	titleColor = true,
}

P.itemLevel = {
	enable = true,
	flyout = {
		enable = true,
		useBagsFontSetting = false,
		qualityColor = true,
		font = {
			name = "Expressway",
			size = 11,
			style = "OUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1
			},
		},
	},
	scrappingMachine = {
		enable = true,
		useBagsFontSetting = false,
		qualityColor = true,
		font = {
			name = "Expressway",
			size = 13,
			style = "OUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1
			},
		},
	},
}

P.raidBuffs = {
	enable = true,
	visibility = "INPARTY",
	class = true,
	size = 30,
	alpha = 0.3,
	glow = true,
	customVisibility = "[noexists, nogroup] hide; show",
}

P.reminder = {
	enable = true,
	size = 30,
}

P.nameplates = {
	castbarShield = true,
	gradient = true,
	enhancedAuras = {
		enable = true,
	},
}

P.cooldownFlash = {
	enable = true,
	fadeInTime = 0.3,
	fadeOutTime = 0.6,
	maxAlpha = 0.8,
	animScale = 1.5,
	iconSize = 40,
	holdTime = 0.3,
	petOverlay = {1, 1, 1, 1},
	ignoredSpells = {},
	invertIgnored = false,
	enablePet = false,
	x = UIParent:GetWidth()*UIParent:GetEffectiveScale()/2,
	y = UIParent:GetHeight()*UIParent:GetEffectiveScale()/2,
}

P.armory = {
	character = {
		enable = true,
		undressButton = true,
		expandSize = true,
		classIcon = true,
		showWarning = true,
		durability = {
			enable = true,
			onlydamaged = true,
			font = "Expressway",
			textSize = 11,
			fontOutline = "OUTLINE",
		},
		gradient = {
			enable = true,
			colorStyle = "VALUE",
			color = {r = 1, g = 1, b = 0},
			setArmor = true,
			setArmorColor = {r = 0, g = 1, b = 0, a = 1},
			warningColor = {r = 1, g = 0, b = 0, a = 1}
		},
		transmog = {
			enable = true,
		},
		illusion = {
			enable = true,
		},
		warning = {
			enable = true,
		},
	},
	inspect = {
		enable = true,
		classIcon = true,
		gradient = {
			enable = true,
			colorStyle = "RARITY",
			color = {r = 1, g = 1, b = 0},
			setArmor = true,
			setArmorColor = {r = 0, g = 1, b = 0, a = 1},
			warningColor = {r = 1, g = 0, b = 0, a = 1}
		},
		warning = {
			enable = true,
		},
	},
	stats = {
		enable = true,
		OnlyPrimary = true,
		classColorGradient = true,
		color = {r = 1, g = 1, b = 0, a = 1},
		IlvlFull = false,
		IlvlColor = false,
		AverageColor = {r = 0, g = 1, b = .59},
		statFonts = {
			font = "Expressway",
			size = 11,
			outline = "OUTLINE",
		},
		catFonts = {
			font = "Expressway",
			size = 13,
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
	--Wrath Related
	StatOrder = "12345",
	StatExpand = true,
	PetHappiness = true,
}
