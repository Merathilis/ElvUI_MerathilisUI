local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)

local _G = _G

local norm = format("|cff1eff00%s|r", L["[ABBR] Normal"])
local hero = format("|cff0070dd%s|r", L["[ABBR] Heroic"])
local myth = format("|cffa335ee%s|r", L["[ABBR] Mythic"])
local lfr = format("|cffff8000%s|r", L["[ABBR] Looking for Raid"])

P.core = {
	installed = nil,
}

P.general = {
	GameMenu = true,
	splashScreen = true,
	AFK = true,
	FlightPoint = true,
	fontScale = 0,
}

P.bags = {
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
			style = "SHADOWOUTLINE",
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
			style = "SHADOWOUTLINE"
		},
		info = {
			name = E.db.general.font,
			size = E.db.general.fontSize,
			style = "SHADOWOUTLINE"
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
				style = "SHADOWOUTLINE",
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
			style = "SHADOWOUTLINE"
		},
		infoFont = {
			name = E.db.general.font,
			size = 12,
			style = "SHADOWOUTLINE"
		},
	},
}

P.CombatAlert = {
	enable = true,
	font = {
		name = "Expressway",
		size = 28,
		style = "SHADOWOUTLINE",
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
	enable = true,
	chatButton = true,
	hideChat = false,
	emotes = true,
	chatText = {
		enable = true,
		abbreviation = "DEFAULT",
		removeBrackets = true,
		roleIconSize = 16,
		roleIconStyle = "SUNUI",
		removeRealm = true,
		customAbbreviation = {},
		classIcon = true,
		classIconStyle = "flatborder2",
		gradientName = false,
		guildMemberStatus = true,
		guildMemberStatusInviteLink = true,
		mergeAchievement = true,
		bnetFriendOnline = true,
		bnetFriendOffline = false,
		factionIcon = true
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
			style = "SHADOWOUTLINE"
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
	sameMessageInterval = 10,
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
		},
	},
	missingStats = true,
	blockRequest = false,
}

P.nameHover = {
	enable = true,
	fontSize = 7,
	fontOutline = "SHADOWOUTLINE",
	targettarget = false,
}

P.armory = {
	character = {
		enable = true,
	},
	inspect = {
		enable = true,
	},
	StatOrder = "12345",
	StatExpand = true,
	PetHappiness = true,
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
		style = "SHADOWOUTLINE",
	},
	textFont = {
		name = "Expressway",
		size = 11,
		style = "SHADOWOUTLINE",
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
	return "POTIONDF,FLASKDF,RUNE,UTILITY"
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
			style = "SHADOWOUTLINE",
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
			style = "SHADOWOUTLINE",
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
			style = "SHADOWOUTLINE",
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
			style = "SHADOWOUTLINE",
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
			style = "SHADOWOUTLINE",
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
			style = "SHADOWOUTLINE",
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
			style = "SHADOWOUTLINE",
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
			style = "SHADOWOUTLINE",
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
			style = "SHADOWOUTLINE",
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
			style = "SHADOWOUTLINE",
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
	backdropSpacing = 5,
	timeAreaWidth = 80,
	timeAreaHeight = 45,
	buttonSize = 22,
	spacing = 5,
	fadeTime = 0.618,
	normalColor = "NONE",
	hoverColor = "CLASS",
	customNormalColor = { r = 1, g = 1, b = 1 },
	customHoverColor = { r = 0, g = 0.659, b = 1 },
	notification = true,
	visibility = "[petbattle][combat] hide; show",
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
			style = "SHADOWOUTLINE"
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
			style = "SHADOWOUTLINE"
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

P.gradient = {
	enable = true,

	customColor = {
		enableClass = false,
		enableNP = false,
		enableUF = false,
		enablePower = false,

		druidcolorR1 = 1,
		druidcolorR2 = 1,
		druidcolorG1 = 0.23921568627451,
		druidcolorG2 = 0.48627450980392,
		druidcolorB1 = 0.007843137254902,
		druidcolorB2 = 0.03921568627451,

		huntercolorR1 = 0.40392156862745,
		huntercolorR2 = 0.67058823529412,
		huntercolorG1 = 0.53725490196078,
		huntercolorG2 = 0.92941176470588,
		huntercolorB1 = 0.22352941176471,
		huntercolorB2 = 0.30980392156863,

		paladincolorR1 = 1,
		paladincolorR2 = 0.95686274509804,
		paladincolorG1 = 0.26666666666667,
		paladincolorG2 = 0.54901960784314,
		paladincolorB1 = 0.53725490196078,
		paladincolorB2 = 0.72941176470588,

		magecolorR1 = 0,
		magecolorR2 = 0.49019607843137,
		magecolorG1 = 0.33333333333333,
		magecolorG2 = 0.87058823529412,
		magecolorB1 = 0.53725490196078,
		magecolorB2 = 1,

		roguecolorR1 = 1,
		roguecolorR2 = 1,
		roguecolorG1 = 0.68627450980392,
		roguecolorG2 = 0.83137254901961,
		roguecolorB1 = 0,
		roguecolorB2 = 0.25490196078431,

		priestcolorR1 = 0.3568627450980392,
		priestcolorR2 = 0.98823529411765,
		priestcolorG1 = 0.3568627450980392,
		priestcolorG2 = 0.98823529411765,
		priestcolorB1 = 0.3568627450980392,
		priestcolorB2 = 0.98823529411765,

		deathknightcolorR1 = 0.49803921568627,
		deathknightcolorR2 = 1,
		deathknightcolorG1 = 0.074509803921569,
		deathknightcolorG2 = 0.1843137254902,
		deathknightcolorB1 = 0.14901960784314,
		deathknightcolorB2 = 0.23921568627451,

		demonhuntercolorR1 = 0.36470588235294,
		demonhuntercolorR2 = 0.74509803921569,
		demonhuntercolorG1 = 0.13725490196078,
		demonhuntercolorG2 = 0.1921568627451,
		demonhuntercolorB1 = 0.57254901960784,
		demonhuntercolorB2 = 1,

		shamancolorR1 = 0,
		shamancolorR2 = 0,
		shamancolorG1 = 0.25882352941176,
		shamancolorG2 = 0.43921568627451,
		shamancolorB1 = 0.50980392156863,
		shamancolorB2 = 0.87058823529412,

		warlockcolorR1 = 0.26274509803922,
		warlockcolorR2 = 0.66274509803922,
		warlockcolorG1 = 0.26666666666667,
		warlockcolorG2 = 0.3921568627451,
		warlockcolorB1 = 0.46666666666667,
		warlockcolorB2 = 0.7843137254902,

		warriorcolorR1 = 0.42745098039216,
		warriorcolorR2 = 0.56470588235294,
		warriorcolorG1 = 0.13725490196078,
		warriorcolorG2 = 0.43137254901961,
		warriorcolorB1 = 0.090196078431373,
		warriorcolorB2 = 0.24705882352941,

		monkcolorR1 = 0.015686274509804,
		monkcolorR2 = 0,
		monkcolorG1 = 0.6078431372549,
		monkcolorG2 = 1,
		monkcolorB1 = 0.36862745098039,
		monkcolorB2 = 0.58823529411765,

		evokercolorR1 = 0.19607843137255,
		evokercolorR2 = 0.2,
		evokercolorG1 = 0.46666666666667,
		evokercolorG2 = 0.57647058823529,
		evokercolorB1 = 0.53725490196078,
		evokercolorB2 = 0.49803921568627,

		npcfriendlyR1 = 0.30980392156863,
		npcfriendlyR2 = 0.34117647058824,
		npcfriendlyG1 = 0.85098039215686,
		npcfriendlyG2 = 0.62745098039216,
		npcfriendlyB1 = 0.2,
		npcfriendlyB2 = 0.4078431372549,

		npcneutralR1 = 0.8156862745098,
		npcneutralG1 = 1,
		npcneutralB1 = 0,
		npcneutralR2 = 1,
		npcneutralG2 = 0.85882352941176,
		npcneutralB2 = 0.2078431372549,

		npcunfriendlyR1 = 0.84313725490196,
		npcunfriendlyG1 = 0.30196078431373,
		npcunfriendlyB1 = 0,
		npcunfriendlyR2 = 0.83137254901961,
		npcunfriendlyG2 = 0.45882352941176,
		npcunfriendlyB2 = 0,

		npchostileR1 = 1,
		npchostileR2 = 1,
		npchostileG1 = 0.090196078431373,
		npchostileG2 = 0,
		npchostileB1 = 0,
		npchostileB2 = 0.54901960784314,

		goodthreatR1 = 0.27843075990677,
		goodthreatR2 = 0.95294117647059,
		goodthreatG1 = 1,
		goodthreatG2 = 0.99999779462814,
		goodthreatB1 = 0,
		goodthreatB2 = 0,

		badthreatR1 = 1,
		badthreatR2 = 0.82352941176471,
		badthreatG1 = 0.17647058823529,
		badthreatG2 = 0,
		badthreatB1 = 0.17647058823529,
		badthreatB2 = 0.34901960784314,

		goodthreattransitionR1 = 1,
		goodthreattransitionR2 = 1,
		goodthreattransitionG1 = 0.99607843137255,
		goodthreattransitionG2 = 0.73333333333333,
		goodthreattransitionB1 = 0.2,
		goodthreattransitionB2 = 0,

		badthreattransitionR1 = 1,
		badthreattransitionR2 = 1,
		badthreattransitionG1 = 0.3921568627451,
		badthreattransitionG2 = 0.9843137254902,
		badthreattransitionB1 = 0.2,
		badthreattransitionB2 = 0,

		offtankR1 = 0.72941176470588,
		offtankR2 = 0.34117647058824,
		offtankG1 = 0.2,
		offtankG2 = 0,
		offtankB1 = 1,
		offtankB2 = 1,

		badthreattransitionofftankR1 = 0.70980392156863,
		badthreattransitionofftankG1 = 0.43137254901961,
		badthreattransitionofftankB1 = 0.27058823529412,
		badthreattransitionofftankR2 = 0.90196078431373,
		badthreattransitionofftankG2 = 0.15294117647059,
		badthreattransitionofftankB2 = 0,

		goodthreattransitionofftankR1 = 0.30980392156863,
		goodthreattransitionofftankR2 = 0,
		goodthreattransitionofftankG1 = 0.45098039215686,
		goodthreattransitionofftankG2 = 1,
		goodthreattransitionofftankB1 = 0.63137254901961,
		goodthreattransitionofftankB2 = 0.70980392156863,

		tappedR1 = 1,
		tappedG1 = 1,
		tappedB1 = 1,
		tappedR2 = 0,
		tappedG2 = 0,
		tappedB2 = 0,

		manaR1 = 0.49,
		manaG1 = 0.71,
		manaB1 = 1,
		manaR2 = 0.29,
		manaG2 = 0.26,
		manaB2 = 1,

		rageR1 = 1,
		rageG1 = 0.32,
		rageB1 = 0.32,
		rageR2 = 1,
		rageG2 = 0,
		rageB2 = 0.13,

		focusR1 = 1,
		focusG1 = 0.50,
		focusB1 = 0.25,
		focusR2 = 0.71,
		focusG2 = 0.22,
		focusB2 = 0.07,

		energyR1 = 1,
		energyG1 = 0.97,
		energyB1 = 0.54,
		energyR2 = 1,
		energyG2 = 0.70,
		energyB2 = 0.07,

		runicpowerR1 = 0,
		runicpowerG1 = 0.82,
		runicpowerB1 = 1,
		runicpowerR2 = 0,
		runicpowerG2 = 0.40,
		runicpowerB2 = 1,

		lunarpowerR1 = 0.30,
		lunarpowerG1 = 0.52,
		lunarpowerB1 = 0.90,
		lunarpowerR2 = 0.12,
		lunarpowerG2 = 0.36,
		lunarpowerB2 = 0.90,

		altpowerR1 = 0.20,
		altpowerG1 = 0.40,
		altpowerB1 = 0.8,
		altpowerR2 = 0.25,
		altpowerG2 = 0.51,
		altpowerB2 = 1,

		maelstromR1 = 0,
		maelstromG1 = 0.50,
		maelstromB1 = 1,
		maelstromR2 = 0,
		maelstromG2 = 0.11,
		maelstromB2 = 1,

		insanityR1 = 0.50,
		insanityG1 = 0.25,
		insanityB1 = 1,
		insanityR2 = 0.70,
		insanityG2 = 0,
		insanityB2 = 1,

		furyR1 = 0.79,
		furyG1 = 0.26,
		furyB1 = 1,
		furyR2 = 1,
		furyG2 = 0,
		furyB2 = 0.95,

		painR1 = 1,
		painG1 = 0.61,
		painB1 = 0,
		painR2 = 1,
		painG2 = 0.30,
		painB2 = 0,
	},
	bgfade = 0.6,
	backdropalpha = 1
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
		texture = "ElvUI Blank",
		spark = {
			enable = true,
			texture = "ElvUI Blank",
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
	offlineIndicator = {
		enable = true,
		size = 36,
		anchorPoint = 'RIGHT',
		xOffset = 20,
		yOffset = 0,
		texture = 'MATERIAL',
		custom = '',
	},
	deathIndicator = {
		enable = true,
		size = 36,
		anchorPoint = 'CENTER',
		xOffset = 0,
		yOffset = 0,
		texture = 'MATERIAL',
		custom = '',
	},
}

P.nameplates = {
	castbarShield = true,
	gradient = true,
	enhancedAuras = {
		enable = true,
	},
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
				style = "SHADOWOUTLINE"
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
			style = "SHADOWOUTLINE"
		},
		custom = false,
		customStrings = {
			["PvP"] = format("|cffFFFF00%s|r", "PvP"),
			["5-player Normal"] = "5" .. norm,
			["5-player Heroic"] = "5" .. hero,
			["10-player Normal"] = "10" .. norm,
			["25-player Normal"] = "25" .. norm,
			["10-player Heroic"] = "10" .. hero,
			["25-player Heroic"] = "25" .. hero,
			["Looking for Raid"] = lfr,
			["Mythic Keystone"] = format("|cffff3860%s|r", L["[ABBR] Mythic Keystone"]) .. "%mplus%",
			["40-player"] = "40",
			["Heroic Scenario"] = format("%s %s", hero, L["[ABBR] Scenario"]),
			["Normal Scenario"] = format("%s %s", norm, L["[ABBR] Scenario"]),
			["Normal Raid"] = "%numPlayers% " .. norm,
			["Heroic Raid"] = "%numPlayers% " .. hero,
			["Mythic Raid"] = "%numPlayers% " .. myth,
			["Looking for Raid"] = "%numPlayers% " .. lfr,
			["Event Scenario"] = L["[ABBR] Event Scenario"],
			["Mythic Party"] = "5" .. myth,
			["Timewalking"] = L["[ABBR] Timewalking"],
			["World PvP Scenario"] = format("|cffFFFF00%s |r", "PvP"),
			["PvEvP Scenario"] = "PvEvP",
			["Timewalking Raid"] = L["[ABBR] Timewalking"],
			["PvP Heroic"] = format("|cffFFFF00%s |r", "PvP"),
			["Mythic Scenario"] = format("%s %s", myth, L["[ABBR] Scenario"]),
			["Warfronts Normal"] = L["[ABBR] Warfronts"],
			["Warfronts Heroic"] = format("|cffff7d0aH|r%s", L["[ABBR] Warfronts"])
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
			style = "SHADOWOUTLINE",
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
			outline = "SHADOWOUTLINE"
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
		researchersUnderFire = {
			enable = true,
			desaturate = false,
			alert = true,
			sound = true,
			soundFile = "OnePlus Light",
			second = 600,
			stopAlertIfCompleted = true,
			stopAlertIfPlayerNotEnteredDragonlands = true
		},
		timeRiftThaldraszus = {
			enable = true,
			desaturate = false,
			alert = true,
			sound = true,
			soundFile = "OnePlus Light",
			second = 600,
			stopAlertIfCompleted = false,
			stopAlertIfPlayerNotEnteredDragonlands = true
		},
		iskaaranFishingNet = {
			enable = false,
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
			outline = "SHADOWOUTLINE",
			width = 512,
		},
		subzone = {
			font = "Expressway",
			size = 25,
			outline = "SHADOWOUTLINE",
			width = 512,
		},
		pvp = {
			font = "Expressway",
			size = 22,
			outline = "SHADOWOUTLINE",
			width = 512,
		},
	},
	miscText = {
		mail = {
			enable = true,
			font = "Expressway",
			size = 12,
			outline = "SHADOWOUTLINE",
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
	fontOutline = "SHADOWOUTLINE",
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
		hsPrio =
		"54452,200630,193588,190237,64488,93672,142542,162973,163045,165669,165670,165802,166746,166747,168907,172179,180290,182773,184353,183716,188952,140192,110560",
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
			style = "SHADOWOUTLINE",
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
			style = "SHADOWOUTLINE",
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
	tts = false,
	ttsvoice = nil,
	ttsvolume = 100,
}
