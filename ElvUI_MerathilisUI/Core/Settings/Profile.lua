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
	equipOverlay = true,
}

P.merchant = {
	enable = true,
	numberOfPages = 2,
}

P.blizzard = {
	talents = {
		enable = true,
	},
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
			texture = "RenAscensionL",
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
			size = E.db.general.fontSize - 1,
			style = "OUTLINE"
		},
		titleColor = {
			enable = true,
			classColor = false,
			customColorNormal = {r = 0, g = 0.752, b = 0.980},
			customColorHighlight = {r = 0.282, g = 0.859, b = 0.984}
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
		useClassColor = true,
		useNoteAsName = false,
		textures = {
			game = "Modern",
			status = "Square",
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
	minimapAlert = true,
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
		visibility = "SHOWBOTH",
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
		tex = "RenAscensionL",
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
	defaultPage = "ALTS"
}

P.misc = {
	gmotd = true,
	quest = {
		selectQuestReward =	true,
	},
	cursor = false,
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
	spellAlert = 0.65,
	alerts = {
		announce = true,
		itemAlert = true,
		feasts = true,
		portals = true,
		toys = true,
	},
	paragon = {
		enable = true,
		textStyle = "PARAGON",
		paragonColor = {r = 0.9, g = 0.8, b = 0.6},
	},
	funstuff = true,
	wowheadlinks = true,
	respec = true,
	mawThreatBar = {
		enable = true,
		width = 250,
		height = 16,
		font = {
			name = "Expressway",
			size = 10,
			style = "OUTLINE",
		}
	}
}

P.nameHover = {
	enable = true,
	fontSize = 7,
	fontOutline = "OUTLINE",
}

P.notification = {
	enable = true,
	noSound = false,
	mail = true,
	vignette = true,
	rarePrint = true,
	invites = true,
	guildEvents = true,
	paragon = true,
	quickJoin = true,
	callToArms = false,
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
	keyfeedback = true,
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
}

local function Potions()
	if E.Classic then
		return "POTION,FLASK,UTILITY"
	elseif E.TBC then
		return "POTIONTBC,FLASKTBC,CAULDRONTBC,ELIXIRTBC,ORETBC,UTILITY"
	elseif E.Retail then
		return "POTIONSL,FLASKSL,UTILITY"
	end
end

P.autoButtons = {
	enable = true,
	customList = {},
	blackList = {
		[183040] = true
	},
	bar1 = {
		enable = true,
		mouseOver = false,
		globalFade = false,
		fadeTime = 0.3,
		alphaMin = 1,
		alphaMax = 1,
		numButtons = 12,
		backdrop = true,
		backdropSpacing = 1,
		buttonWidth = 35,
		buttonHeight = 30,
		buttonsPerRow = 12,
		anchor = "TOPLEFT",
		spacing = 3,
		tooltip = true,
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
		include = "QUEST,BANNER,EQUIP,TORGHAST,OPENABLE"
	},
	bar2 = {
		enable = true,
		mouseOver = false,
		globalFade = false,
		fadeTime = 0.3,
		alphaMin = 1,
		alphaMax = 1,
		numButtons = 12,
		backdrop = true,
		backdropSpacing = 1,
		buttonWidth = 35,
		buttonHeight = 30,
		buttonsPerRow = 12,
		anchor = "TOPLEFT",
		spacing = 3,
		tooltip = true,
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
		include = Potions()
	},
	bar3 = {
		enable = true,
		mouseOver = false,
		globalFade = false,
		fadeTime = 0.3,
		alphaMin = 1,
		alphaMax = 1,
		numButtons = 12,
		backdrop = true,
		backdropSpacing = 1,
		buttonWidth = 35,
		buttonHeight = 30,
		buttonsPerRow = 12,
		anchor = "TOPLEFT",
		spacing = 3,
		tooltip = true,
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
		include = "MAGEFOOD,FOODVENDOR,FOODSL,CUSTOM"
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
	shadow = true,
	timeAreaWidth = 80,
	timeAreaHeight = 35,
	buttonSize = 20,
	spacing = 3,
	fadeTime = 0.618,
	normalColor = "NONE",
	hoverColor = "CLASS",
	customNormalColor = {r = 1, g = 1, b = 1},
	customHoverColor = {r = 0, g = 0.659, b = 1},
	notification = true,
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
		[6] = E.Retail and "GROUP_FINDER" or "NONE",
		[7] = E.Retail and "SCREENSHOT" or "NONE",
	},
	right = {
		[1] = "HOME",
		[2] = E.Retail and "ACHIEVEMENTS" or "SCREENSHOT",
		[3] = E.Retail and "MISSION_REPORTS" or "VOLUME",
		[4] = E.Retail and "ENCOUNTER_JOURNAL" or "GAMEMENU",
		[5] = E.Retail and "TOY_BOX" or "BAGS",
		[6] = E.Retail and "PET_JOURNAL" or "NONE",
		[7] = E.Retail and "BAGS" or "NONE",
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
	auras = true,
}

P.maps = {
	minimap = {
		flash = true,
		queueStatus = true,
		instanceDifficulty = {
			enable = true,
			hideBlizzard = true,
			font = {
				name = E.db.general.font,
				size = E.db.general.fontSize,
				style = "OUTLINE",
			},
		},
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
		rectangleMinimap = {
			enable = false,
			heightPercentage = 0.8
		},
	},
	superTracker = {
		enable = true,
		noLimit = false,
		autoTrackWaypoint = true,
		rightClickToClear = true,
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
			commandKeys = {
				["wtgo"] = true,
				["goto"] = true,
			},
		},
	},
	worldMap = {
		scale = {
			enable = true,
			size = 1.15
		},
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
			outline = "NONE",
		},
		gossip = {
			enable = true,
			font = "Expressway",
			size = 12,
			outline = "NONE",
		},
		questFontSuperHuge = {
			enable = true,
			font = "Expressway",
			size = 24,
			outline = "NONE",
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
	buttonsPerRow = 8,
	buttonSize = 24,
	backdrop = true,
	backdropSpacing = 2,
	spacing = 2,
	inverseDirection = false,
	orientation = "HORIZONTAL",
	calendar = false,
	garrison = false
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
		hsPrio = "190237,54452,64488,93672,142542,162973,163045,165669,165670,165802,166746,166747,168907,172179,180290,182773,184353,183716,188952",
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
}

P.tooltip = {
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
	dominationRank = true,
	covenant = {
		enable = true,
		showNotInGroup = false,
	}
}

P.errorFilters = {
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
	petOverlay = {1, 1, 1},
	ignoredSpells = "",
	invertIgnored = false,
	enablePet = false,
	showSpellName = false,
	x = UIParent:GetWidth()*UIParent:GetEffectiveScale()/2,
	y = UIParent:GetHeight()*UIParent:GetEffectiveScale()/2,
}

P.armory = {
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
	warning = {
		enable = true,
	},
}

P.flightMode = {
	enable = true,
	BenikFlightMode = true,
}
