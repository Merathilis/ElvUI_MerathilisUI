local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)

V.general = {
	install_complete = nil,
}

V.skins = {
	enable = true,
	style = true,
	shadowOverlay = false,
	shadow = {
		enable = true,
		increasedSize = 0,
		color = {
			r = 0,
			g = 0,
			b = 0
		},
	},
	widgets = {
		button = {
			enable = true,
			backdrop = {
				enable = true,
				texture = "Asphyxia",
				classColor = false,
				color = {r = 0, g = 0.752, b = 0.980},
				alpha = 1,
				animationType = "FADE",
				animationDuration = 0.2,
				removeBorderEffect = true
			},
			selected = {
				enable = true,
				backdropClassColor = false,
				backdropColor = {r = 0.322, g = 0.608, b = 0.961},
				backdropAlpha = 0.4,
				borderClassColor = false,
				borderColor = {r = 0.145, g = 0.353, b = 0.698},
				borderAlpha = 1
			},
			text = {
				enable = true,
				font = {
					name = E.db.general.font,
					style = "SHADOWOUTLINE"
				},
			},
		},
		tab = {
			enable = true,
			backdrop = {
				enable = true,
				texture = "Asphyxia",
				classColor = false,
				color = {r = 0, g = 0.752, b = 0.980},
				alpha = 1,
				animationType = "FADE",
				animationDuration = 0.2
			},
			selected = {
				enable = true,
				texture = "Asphyxia",
				backdropClassColor = false,
				backdropColor = {r = 0.322, g = 0.608, b = 0.961},
				backdropAlpha = 0.4,
				borderClassColor = false,
				borderColor = {r = 0.145, g = 0.353, b = 0.698},
				borderAlpha = 1
			},
			text = {
				enable = true,
				normalClassColor = false,
				normalColor = {r = 1, g = 0.82, b = 0},
				selectedClassColor = false,
				selectedColor = {r = 1, g = 1, b = 1},
				font = {
					name = E.db.general.font,
					style = "SHADOWOUTLINE"
				}
			}
		},
		checkBox = {
			enable = true,
			texture = "Asphyxia",
			classColor = false,
			color = {r = 0, g = 0.752, b = 0.980, a = 1}
		},
		slider = {
			enable = true,
			texture = "Asphyxia",
			classColor = false,
			color = {r = 0, g = 0.752, b = 0.980, a = 1}
		},
		treeGroupButton = {
			enable = true,
			backdrop = {
				enable = true,
				texture = "Asphyxia",
				classColor = false,
				color = {r = 0, g = 0.752, b = 0.980},
				alpha = 1,
				animationType = "FADE",
				animationDuration = 0.2,
			},
			selected = {
				enable = true,
				texture = "Asphyxia",
				backdropClassColor = false,
				backdropColor = {r = 0.322, g = 0.608, b = 0.961, a = 0.75},
				borderClassColor = false,
				borderColor = {r = 0.145, g = 0.353, b = 0.698, a = 0},
			},
			text = {
				enable = true,
				normalClassColor = false,
				normalColor = {r = 1, g = 0.82, b = 0},
				selectedClassColor = false,
				selectedColor = {r = 1, g = 1, b = 1},
				font = {
					name = E.db.general.font,
					style = "SHADOWOUTLINE"
				}
			}
		},
	},
	blizzard = {
		enable = true,
		addonCompartment = true,
		arena = true,
		arenaRegistrar = true,
		character = true,
		encounterjournal = true,
		gossip = true,
		quest = true,
		questChoice = true,
		spellbook = true,
		talent = true,
		auctionhouse = true,
		friends = true,
		garrison = true,
		orderhall = true,
		contribution = true,
		artifact = true,
		collections = true,
		calendar = true,
		merchant = true,
		worldmap = true,
		pvp = true,
		achievement = true,
		tradeskill = true,
		lfg = true,
		lfguild = true,
		talkinghead = true,
		guild = true,
		objectiveTracker = true,
		addonManager = true,
		mail = true,
		raid = true,
		dressingroom = true,
		timemanager = true,
		blackmarket = true,
		guildcontrol = true,
		macro = true,
		binding = true,
		gbank = true,
		taxi = true,
		help = true,
		loot = true,
		deathRecap = true,
		communities = true,
		channels = true,
		challenges = true,
		azerite = true,
		AzeriteRespec = true,
		IslandQueue = true,
		IslandsPartyPose = true,
		BFAMissions = true,
		minimap = true,
		Scrapping = true,
		trainer = true,
		debug = true,
		inspect = true,
		socket = true,
		itemUpgrade = true,
		trade = true,
		voidstorage = true,
		AlliedRaces = true,
		GMChat = true,
		Archaeology = true,
		AzeriteEssence = true,
		itemInteraction = true,
		animaDiversion = true,
		soulbinds = true,
		covenantSanctum = true,
		covenantPreview = true,
		playerChoice = true,
		chromieTime = true,
		levelUp = true,
		covenantRenown = true,
		guide = true,
		craft = true,
		eventToast = true,
		weeklyRewards = true,
		misc = true,
		tooltip = true,
		bgmap = true,
		bgscore = true,
		barber = true,
		chatBubbles = true,
		expansionLanding = true,
		majorFactions = true,
		blizzardOptions = true,
		editor = true,
		perksProgram = true,
	},

	addonSkins = {
		enable = true,
		ace3 = true,
		ace3DropdownBackdrop = true,
		abp = true,
		xiv = true,
		bui = true,
		bs = true,
		pa = true,
		ls = true,
		dbm = true,
		cl = true,
		cbn = true,
		et = true,
		wa = true,
		waOptions = true,
		tldr = true,
		pf = true,
		au = true,
		imm = true,
		rio = true,
		omniCD = true,
		gil = true,
		bSync = true,
		pawn = true,
		bw = {
			enable = true,
			queueTimer = {
				enable = true,
				smooth = true,
				spark = true,
				colorLeft = { r = 0.32941, g = 0.52157, b = 0.93333, a = 1 },
				colorRight = { r = 0.25882, g = 0.84314, b = 0.86667, a = 1 },
				countDown = {
					name = "Expressway",
					size = 16,
					style = "SHADOWOUTLINE",
					offsetX = 0,
					offsetY = -3
				},
			},
			normalBar = {
				smooth = true,
				spark = true,
				colorOverride = true,
				colorLeft = { r = 0.32941, g = 0.52157, b = 0.93333, a = 1 },
				colorRight = { r = 0.25882, g = 0.84314, b = 0.86667, a = 1 }
			},
			emphasizedBar = {
				smooth = true,
				spark = true,
				colorOverride = true,
				colorLeft = { r = 1, g = 0.23, b = 0.0, a = 1 },
				colorRight = { r = 1, g = 0.48, b = 0.03, a = 1 }
			},
		},
		dt = {
			enable = true,
			gradientName = false,
			gradientBars = true,
		},
	},

	embed = {
		enable = false,
		toggleDirection = 1,
		mouseOver = false,
	},

	actionStatus = {
		name = E.db.general.font,
		size = 15,
		style = "SHADOWOUTLINE"
	},
	rollResult = {
		name = "Expressway",
		size = 13,
		style = "SHADOWOUTLINE"
	},
}
