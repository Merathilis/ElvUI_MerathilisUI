local MER, F, E, L, V, P, G = unpack(select(2, ...))

V.general = {
	install_complete = nil,
}

V.misc = {
	guildNewsItemLevel = true,
}

V.skins = {
	widgets = {
		button = {
			enable = true,
			backdrop = {
				enable = true,
				texture = "RenAscensionL",
				classColor = false,
				color = {r = 0, g = 0.752, b = 0.980},
				alpha = 1,
				animationType = "FADE",
				animationDuration = 0.2,
				removeBorderEffect = true
			},
			text = {
				enable = true,
				font = {
					name = E.db.general.font,
					style = "OUTLINE"
				},
			},
		},
		tab = {
			enable = true,
			backdrop = {
				enable = true,
				texture = "RenAscensionL",
				classColor = false,
				color = {r = 0, g = 0.752, b = 0.980},
				alpha = 1,
				animationType = "FADE",
				animationDuration = 0.2
			},
			selected = {
				enable = true,
				texture = "RenAscensionL",
				backdropClassColor = false,
				backdropColor = {r = 0.322, g = 0.608, b = 0.961, a = 0.4},
				borderClassColor = false,
				borderColor = {r = 0.145, g = 0.353, b = 0.698, a = 1},
			},
			text = {
				enable = true,
				normalClassColor = false,
				normalColor = {r = 1, g = 0.82, b = 0},
				selectedClassColor = false,
				selectedColor = {r = 1, g = 1, b = 1},
				font = {
					name = E.db.general.font,
					style = "OUTLINE"
				},
			},
		},
		checkBox = {
			enable = true,
			texture = "RenAscensionL",
			classColor = false,
			color = {r = 0, g = 0.752, b = 0.980, a = 1}
		},
		slider = {
			enable = true,
			texture = "RenAscensionL",
			classColor = false,
			color = {r = 0, g = 0.752, b = 0.980, a = 1}
		},
		treeGroupButton = {
			enable = true,
			backdrop = {
				enable = true,
				texture = "RenAscensionL",
				classColor = false,
				color = {r = 0, g = 0.752, b = 0.980},
				alpha = 1,
				animationType = "FADE",
				animationDuration = 0.2,
				removeBorderEffect = true
			},
			selected = {
				enable = true,
				texture = "WindTools Glow",
				backdropClassColor = false,
				backdropColor = {r = 0.322, g = 0.608, b = 0.961, a = 0.4},
				borderClassColor = false,
				borderColor = {r = 0.145, g = 0.353, b = 0.698, a = 1},
			},
			text = {
				enable = true,
				font = {
					name = E.db.general.font,
					style = "OUTLINE"
				}
			}
		},
	},
	blizzard = {
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
		ItemInteraction = true,
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
	},

	addonSkins = {
		abp = true,
		bw = true,
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
	},
}
