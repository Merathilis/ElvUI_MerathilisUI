local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local C = MER.Utilities.Color

local _G = _G

local norm = format("|cff1eff00%s|r", L["[ABBR] Normal"])
local hero = format("|cff0070dd%s|r", L["[ABBR] Heroic"])
local myth = format("|cffa335ee%s|r", L["[ABBR] Mythic"])
local lfr = format("|cffff8000%s|r", L["[ABBR] Looking for Raid"])

P.core = {
	installed = nil,
	lastLayoutVersion = nil,
}

P.general = {
	splashScreen = true,
	AFK = true,
	fontScale = 0,

	fontOverride = {
		[I.Fonts.Primary] = "DEFAULT",
		[I.Fonts.GothamRaid] = "DEFAULT",
		[I.Fonts.Runescape] = "DEFAULT",
	},

	fontStyleOverride = {
		[I.Fonts.Primary] = "DEFAULT",
		[I.Fonts.GothamRaid] = "DEFAULT",
		[I.Fonts.Runescape] = "DEFAULT",
	},

	fontShadowOverride = {
		[I.Fonts.Primary] = "DEFAULT",
		[I.Fonts.GothamRaid] = "DEFAULT",
		[I.Fonts.Runescape] = "DEFAULT",
	},
}

P.gameMenu = {
	enable = true,
	bgColor = F.Table.HexToRGB("#00000080"),
	showCollections = true,
	showWeeklyDevles = true,
	showMythicKey = true,
	showMythicScore = true,
	mythicHistoryLimit = 4,
}

P.themes = {
	classColorMap = {
		[I.Enum.GradientMode.Color.NORMAL] = { -- RIGHT
			DEATHKNIGHT = F.Table.HexToRGB("#f52652"),
			DEMONHUNTER = F.Table.HexToRGB("#ba00f5"),
			DRUID = F.Table.HexToRGB("#ff7d0a"),
			EVOKER = F.Table.HexToRGB("#44c5aa"),
			HUNTER = F.Table.HexToRGB("#abed4f"),
			MAGE = F.Table.HexToRGB("#33c7fc"),
			MONK = F.Table.HexToRGB("#00ff96"),
			PALADIN = F.Table.HexToRGB("#f58cba"),
			PRIEST = F.Table.HexToRGB("#ffffff"),
			ROGUE = F.Table.HexToRGB("#fff368"),
			SHAMAN = F.Table.HexToRGB("#0a7ded"),
			WARLOCK = F.Table.HexToRGB("#8561ed"),
			WARRIOR = F.Table.HexToRGB("#e0a361"),
		},
		[I.Enum.GradientMode.Color.SHIFT] = { -- LEFT
			DEATHKNIGHT = F.Table.HexToRGB("#ba1c2b"),
			DEMONHUNTER = F.Table.HexToRGB("#b3008a"),
			DRUID = F.Table.HexToRGB("#ff5e0a"),
			EVOKER = F.Table.HexToRGB("#2c7e6c"),
			HUNTER = F.Table.HexToRGB("#99cc54"),
			MAGE = F.Table.HexToRGB("#0599cf"),
			MONK = F.Table.HexToRGB("#05bf73"),
			PALADIN = F.Table.HexToRGB("#d9548f"),
			PRIEST = F.Table.HexToRGB("#d1d1d1"),
			ROGUE = F.Table.HexToRGB("#ffb759"),
			SHAMAN = F.Table.HexToRGB("#0061bf"),
			WARLOCK = F.Table.HexToRGB("#634aad"),
			WARRIOR = F.Table.HexToRGB("#c78c4a"),
		},
	},
}

P.style = {
	enable = true,
}

P.bags = {
	equipOverlay = true,
}

P.merchant = {
	enable = true,
	numberOfPages = 2,
}

P.blizzard = {
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
		hideRealm = false,
		textures = {
			status = "square",
			gameIcon = "PATCH",
		},
		areaColor = {
			r = 1,
			g = 1,
			b = 1,
		},
		nameFont = {
			name = E.db.general.font,
			size = 13,
			style = "SHADOWOUTLINE",
		},
		infoFont = {
			name = E.db.general.font,
			size = 12,
			style = "SHADOWOUTLINE",
		},
	},
}

P.quest = {
	switchButtons = {
		enable = true,
		tooltip = true,
		backdrop = false,
		font = {
			name = E.db.general.font,
			size = 12,
			style = "OUTLINE",
			color = { r = 1, g = 0.82, b = 0 },
		},
		announcement = true,
		turnIn = true,
	},
	turnIn = {
		enable = true,
		mode = "ALL",
		onlyRepeatable = true,
		smartChat = true,
		selectReward = true,
		getBestReward = false,
		darkmoon = true,
		followerAssignees = true,
		pauseModifier = "SHIFT",
		customIgnoreNPCs = {},
	},
}

P.CombatAlert = {
	enable = true,
	font = {
		name = I.Fonts.Primary,
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

P.chat = {
	enable = true,
	chatButton = true,
	hideChat = false,
	editBoxPosition = "ABOVE_CHAT",
	chatText = {
		enable = true,
		abbreviation = "DEFAULT",
		removeBrackets = true,
		roleIconSize = 16,
		roleIconStyle = "LYNUI",
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
		factionIcon = true,
	},
	emote = {
		enable = true,
		size = 16,
		panel = true,
		chatBubbles = true,
	},
	chatLink = {
		enable = true,
		numericalQualityTier = false,
		translateItem = true,
		level = true,
		icon = true,
		armorCategory = true,
		weaponCategory = true,
		compatibile = true,
	},
	chatFade = {
		enable = false,
		minAlpha = 0.33,
		timeout = 8,
		fadeOutTime = 0.65,
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
		tex = "ElvUI Norm1",
		font = {
			name = E.db.general.font,
			size = 12,
			style = "SHADOWOUTLINE",
		},
		color = true,
		channels = {
			["SAY"] = {
				enable = true,
				cmd = "s",
				color = { r = 1, g = 1, b = 1, a = 1 },
				abbr = _G.SAY,
			},
			["YELL"] = {
				enable = true,
				cmd = "y",
				color = { r = 1, g = 0.25, b = 0.25, a = 1 },
				abbr = _G.YELL,
			},
			["EMOTE"] = {
				enable = false,
				cmd = "e",
				color = { r = 1, g = 0.5, b = 0.25, a = 1 },
				abbr = _G.EMOTE,
			},
			["PARTY"] = {
				enable = true,
				cmd = "p",
				color = { r = 0.67, g = 0.67, b = 1, a = 1 },
				abbr = _G.PARTY,
			},
			["INSTANCE"] = {
				enable = true,
				cmd = "i",
				color = { r = 1, g = 0.73, b = 0.2, a = 1 },
				abbr = _G.INSTANCE,
			},
			["RAID"] = {
				enable = true,
				cmd = "raid",
				color = { r = 1, g = 0.5, b = 0, a = 1 },
				abbr = _G.RAID,
			},
			["RAID_WARNING"] = {
				enable = false,
				cmd = "rw",
				color = { r = 1, g = 0.28, b = 0, a = 1 },
				abbr = _G.RAID_WARNING,
			},
			["GUILD"] = {
				enable = true,
				cmd = "g",
				color = { r = 0.25, g = 1, b = 0.25, a = 1 },
				abbr = _G.GUILD,
			},
			["OFFICER"] = {
				enable = false,
				cmd = "o",
				color = { r = 0.25, g = 0.75, b = 0.25, a = 1 },
				abbr = _G.OFFICER,
			},
			world = {
				enable = false,
				config = {},
				color = { r = 0.2, g = 0.6, b = 0.86, a = 1 },
				abbr = L["World"],
			},
			community = {
				enable = false,
				name = "",
				color = { r = 0.72, g = 0.27, b = 0.86, a = 1 },
				abbr = L["Community"],
			},
			emote = {
				enable = false,
				icon = true,
				color = { r = 1, g = 0.33, b = 0.52, a = 1 },
				abbr = L["MER Emote"],
			},
			roll = {
				enable = true,
				icon = true,
				color = { r = 0.56, g = 0.56, b = 0.56, a = 1 },
				abbr = L["Roll"],
			},
		},
	},
}

if MER.ChineseLocale then
	P.chat.chatText.customAbbreviation[L["BigfootWorldChannel"]] = "世"
	P.chat.chatText.customAbbreviation["尋求組隊"] = "世"
	P.chat.chatText.customAbbreviation["組隊頻道"] = "世"

	tinsert(P.chat.chatBar.channels.world.config, {
		region = "TW",
		faction = "Alliance",
		realmID = "ALL",
		name = "組隊頻道",
		autoJoin = true,
	})

	tinsert(P.chat.chatBar.channels.world.config, {
		region = "TW",
		faction = "Horde",
		realmID = "ALL",
		name = "尋求組隊",
		autoJoin = true,
	})

	tinsert(P.chat.chatBar.channels.world.config, {
		region = "TW",
		faction = "ALL",
		realmID = "ALL",
		name = L["BigfootWorldChannel"],
		autoJoin = true,
	})

	tinsert(P.chat.chatBar.channels.world.config, {
		region = "CN",
		faction = "ALL",
		realmID = "ALL",
		name = L["BigfootWorldChannel"],
		autoJoin = true,
	})
end

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
			raid = "RAID",
		},
		tag = {
			enable = true,
			color = C.GetRGBFromTemplate("yellow-300"),
		},
		suggestedGroup = {
			enable = true,
			color = C.GetRGBFromTemplate("rose-500"),
		},
		level = {
			enable = true,
			color = C.GetRGBFromTemplate("emerald-400"),
			hideOnMax = true,
		},
		daily = {
			enable = true,
			color = C.GetRGBFromTemplate("cyan-500"),
		},
		weekly = {
			enable = true,
			color = C.GetRGBFromTemplate("blue-500"),
		},
	},
	resetInstance = {
		enable = true,
		prefix = true,
		channel = {
			party = "PARTY",
			instance = "INSTANCE_CHAT",
			raid = "RAID",
		},
	},
	utility = {
		enable = true,
		channel = {
			solo = "NONE",
			party = "PARTY",
			instance = "INSTANCE_CHAT",
			raid = "RAID",
		},
		spells = {
			["698"] = {
				-- Ritual of Summoning
				enable = true,
				includePlayer = true,
				raidWarning = true,
				text = L["{rt1} %player% is casting %spell%, please assist! {rt1}"],
			},
			["29893"] = {
				-- Create Soulwell
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% is handing out %spell%, go and get one! {rt1}"],
			},
			["54710"] = {
				-- MOLL-E
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% puts %spell% {rt1}"],
			},
			["384911"] = {
				--Atomic Recalibrator
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["%player% used %spell%"],
			},
			["290154"] = {
				-- Ethereal Transmorpher
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["%player% used %spell%"],
			},

			["261602"] = {
				-- Stampwhistle
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% used %spell% {rt1}"],
			},
			["376664"] = {
				-- Ohuna Perch
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["%player% used %spell%"],
			},
			["195782"] = {
				-- Summon Moonfeather Statue
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% used %spell% {rt1}"],
			},
			["190336"] = {
				-- Conjure Refreshment
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% cast %spell%, today's special is Anchovy Pie! {rt1}"],
			},
			feasts = {
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% puts down %spell%! {rt1}"],
			},
			bots = {
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% puts %spell% {rt1}"],
			},
			toys = {
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% puts %spell% {rt1}"],
			},
			portals = {
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["{rt1} %player% opened %spell%! {rt1}"],
			},
		},
	},
	keystone = {
		enable = true,
		text = L["{rt1} My new keystone is %keystone%. {rt1}"],
		channel = {
			party = "PARTY",
		},
		command = true,
	},
}

P.misc = {
	gmotd = true,
	spellActivationAlert = {
		enable = true,
		scale = 0.65,
	},
	funstuff = true,
	wowheadlinks = true,
	respec = true,
	hideBossBanner = false,
	tradeTabs = true,
	alreadyKnown = {
		enable = true,
		mode = "COLOR",
		color = {
			r = 0,
			g = 1,
			b = 0,
		},
	},
	mute = {
		enable = true,
		mount = {
			[63796] = false,
			[229385] = false,
			[229386] = false,
			[339588] = false,
			[312762] = false,
		},
		other = {
			["Crying"] = false,
			["Tortollan"] = false,
			["Smolderheart"] = false,
			["Elegy of the Eternals"] = false,
			["Dragonriding"] = true,
			["Jewelcrafting"] = false,
		},
	},
	blockRequest = false,
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
	automation = {
		enable = false,
		hideBagAfterEnteringCombat = false,
		hideWorldMapAfterEnteringCombat = false,
		acceptResurrect = false,
		acceptCombatResurrect = false,
		confirmSummon = false,
	},
	contextMenu = {
		enable = true,
		sectionTitle = true,
		armory = MER.Locale ~= "zhCN",
		armoryOverride = {},
		guildInvite = true,
		who = true,
		reportStats = false,
	},
	singingSockets = {
		enable = true,
	},
	focuser = {
		enable = false,
	},
	raidInfo = {
		enable = true,
		position = "TOP,ElvUIParent,TOP,0,-70",
		size = 16,
		spacing = 4,
		padding = 6,
		backdropColor = { r = 0, g = 0, b = 0, a = 0.5 },
		hideInCombat = true,
		roleIconStyle = "MERATHILISUI",
	},
	petFilterTab = true,
	screenshot = {
		enable = true,
		printMsg = true,
		hideUI = false,
		achievementEarned = true,
		challengeModeCompleted = true,
		playerLevelUp = false,
		playerDead = false,
		playerStartedMoving = false,
	},
	exitPhaseDiving = {
		enable = true,
		width = 81,
		height = 50,
	},
	lfgList = {
		enable = true,
		icon = {
			enable = true,
			hideDefaultClassCircle = true,
			leader = true,
			reskin = true,
			pack = "SQUARE",
			size = 16,
			border = false,
			alpha = 1,
		},
		line = {
			enable = true,
			tex = "ElvUI Norm1",
			width = 16,
			height = 3,
			offsetX = 0,
			offsetY = -1,
			alpha = 1,
		},
		additionalText = {
			enable = true,
			target = "DESC",
			shortenDescription = true,
			template = "{{score}} {{text}}",
		},
		partyKeystone = {
			enable = true,
			font = {
				name = E.db.general.font,
				size = 12,
				style = "OUTLINE",
			},
		},
		rightPanel = {
			enable = true,
			autoRefresh = true,
			autoJoin = false,
			skipConfirmation = false,
			adjustFontSize = MER.ChineseLocale and 1 or 0,
		},
	},
}

P.nameHover = {
	enable = true,
	fontSize = 7,
	fontOutline = "SHADOWOUTLINE",
	targettarget = false,
	gradient = false,
}

P.armory = {
	enable = true,
	animations = true,
	animationsMult = 3.3333,

	background = {
		enable = false,
		alpha = 0.5,
		style = 2,
		class = true,
		hideControls = true,
	},
	lines = {
		enable = true,
		alpha = 0.85,
		height = 1,
		color = "GRADIENT",
	},
	stats = {
		showAvgItemLevel = false,
		itemLevelFormat = "%.2f",
		itemLevelFont = {
			name = I.Fonts.Primary,
			size = 20,
			style = "SHADOWOUTLINE",
			itemLevelFontColor = "DEFAULT", -- GRADIENT, VALUE, CUSTOM, DEFAULT
			color = {
				r = 1,
				g = 1,
				b = 1,
			},
		},
		headerFont = {
			name = I.Fonts.Primary,
			size = 14,
			style = "SHADOWOUTLINE",
			headerFontColor = "CLASS", -- GRADIENT, CLASS, CUSTOM
			color = {
				r = 1,
				g = 1,
				b = 1,
			},
		},
		labelFont = {
			name = I.Fonts.Primary,
			size = 11,
			style = "SHADOWOUTLINE",
			labelFontColor = "GRADIENT",
			color = {
				r = 1,
				g = 1,
				b = 1,
			},
			abbreviateLabels = true,
		},
		valueFont = {
			name = I.Fonts.Primary,
			size = 11,
			style = "SHADOWOUTLINE",
		},

		alternatingBackgroundEnabled = true, -- Enabled by default
		alternatingBackgroundAlpha = 0.75,

		-- Sets the mode for stats
		-- 0 (Hide), 1 (Smart/Blizzard), 2 (Always Show if not 0), 3 (Always Show)
		mode = {
			-- Attributes Category
			STRENGTH = {
				mode = 1,
			},
			AGILITY = {
				mode = 1,
			},
			INTELLECT = {
				mode = 1,
			},
			STAMINA = {
				mode = 1,
			},
			HEALTH = {
				mode = 0,
			},
			POWER = {
				mode = 0,
			},
			ARMOR = {
				mode = 0,
			},
			STAGGER = {
				mode = 0,
			},
			MANAREGEN = {
				mode = 0,
			},
			ENERGY_REGEN = {
				mode = 0,
			},
			RUNE_REGEN = {
				mode = 0,
			},
			FOCUS_REGEN = {
				mode = 0,
			},
			MOVESPEED = {
				mode = 1,
			},

			-- Enhancements Category
			ATTACK_DAMAGE = {
				mode = 0,
			},
			ATTACK_AP = {
				mode = 0,
			},
			ATTACK_ATTACKSPEED = {
				mode = 0,
			},
			SPELLPOWER = {
				mode = 0,
			},
			CRITCHANCE = {
				mode = 1,
			},
			HASTE = {
				mode = 1,
			},
			MASTERY = {
				mode = 1,
			},
			VERSATILITY = {
				mode = 1,
			},
			LIFESTEAL = {
				mode = 0,
			},
			AVOIDANCE = {
				mode = 0,
			},
			SPEED = {
				mode = 0,
			},
			DODGE = {
				mode = 0,
			},
			PARRY = {
				mode = 0,
			},
			BLOCK = {
				mode = 0,
			},
		},
	},
	pageInfo = {
		itemLevelTextEnabled = true,
		iconsEnabled = true,

		moveSockets = false,

		enchantTextEnabled = true,
		abbreviateEnchantText = true,
		useEnchantClassColor = false,
		missingEnchantText = true,
		missingSocketText = true,

		itemQualityGradientEnabled = true,
		itemQualityGradientWidth = 65,
		itemQualityGradientHeight = 3,
		itemQualityGradientStartAlpha = 1,
		itemQualityGradientEndAlpha = 0,

		iLvLFont = {
			name = I.Fonts.Primary,
			size = 12,
			style = "SHADOWOUTLINE",
		},

		enchantFont = {
			name = I.Fonts.Primary,
			size = 11,
			style = "SHADOWOUTLINE",
		},
	},

	nameText = {
		name = I.Fonts.Primary,
		size = 16,
		style = "SHADOWOUTLINE",
		fontColor = "CLASS", -- CLASS, CUSTOM, GRADIENT
		color = {
			r = 1,
			g = 1,
			b = 1,
		},
		offsetX = 0,
		offsetY = 0,
	},

	titleText = {
		name = I.Fonts.Primary,
		size = 10,
		style = "SHADOWOUTLINE",
		fontColor = "CUSTOM", -- CUSTOM, GRADIENT
		color = {
			r = 1,
			g = 1,
			b = 1,
		},
		offsetX = 5,
		offsetY = -2,
	},

	levelTitleText = {
		name = I.Fonts.Primary,
		size = 14,
		style = "SHADOWOUTLINE",
		fontColor = "CUSTOM", -- CLASS, CUSTOM, GRADIENT
		color = {
			r = 1,
			g = 1,
			b = 1,
		},
		offsetX = 0,
		offsetY = -1,
		short = true,
	},

	levelText = {
		name = I.Fonts.Primary,
		size = 16,
		style = "SHADOWOUTLINE",
		fontColor = "CLASS", -- CLASS, CUSTOM, GRADIENT
		color = {
			r = 1,
			g = 1,
			b = 1,
		},
		offsetX = 0,
		offsetY = -1,
	},

	specIcon = {
		name = I.Fonts.Icons,
		size = 18,
		style = "SHADOWOUTLINE",
		fontColor = "CLASS", -- CLASS, CUSTOM
		color = {
			r = 1,
			g = 1,
			b = 1,
		},
	},

	classText = {
		name = I.Fonts.Primary,
		size = 14,
		style = "SHADOWOUTLINE",
		fontColor = "CLASS", -- CLASS, CUSTOM
		color = {
			r = 1,
			g = 1,
			b = 1,
		},
		offsetX = 0,
		offsetY = -2,
	},

	icons = {
		[0] = F.String.ConvertGlyph(59712), -- Unknown
		[62] = F.String.ConvertGlyph(59660), -- Mage Arcane
		[63] = F.String.ConvertGlyph(59661), -- Mage Fire
		[64] = F.String.ConvertGlyph(59662), -- Mage Frost
		[65] = F.String.ConvertGlyph(59666), -- Paladin Holy
		[66] = F.String.ConvertGlyph(59667), -- Paladin Protection
		[70] = F.String.ConvertGlyph(59668), -- Paladin Retribution
		[71] = F.String.ConvertGlyph(59681), -- Warrior Arms
		[72] = F.String.ConvertGlyph(59682), -- Warrior Fury
		[73] = F.String.ConvertGlyph(59683), -- Warrior Protection
		[102] = F.String.ConvertGlyph(59653), -- Druid Balance
		[103] = F.String.ConvertGlyph(59654), -- Druid Feral
		[104] = F.String.ConvertGlyph(59655), -- Druid Guardian
		[105] = F.String.ConvertGlyph(59656), -- Druid Restoration
		[250] = F.String.ConvertGlyph(59648), -- Death Knight Blood
		[251] = F.String.ConvertGlyph(59649), -- Death Knight Frost
		[252] = F.String.ConvertGlyph(59650), -- Death Knight Unholy
		[253] = F.String.ConvertGlyph(59657), -- Hunter Beast Master
		[254] = F.String.ConvertGlyph(59658), -- Hunter Marksmanship
		[255] = F.String.ConvertGlyph(59659), -- Hunter Survival
		[256] = F.String.ConvertGlyph(59669), -- Priest Discipline
		[257] = F.String.ConvertGlyph(59670), -- Priest Holy
		[258] = F.String.ConvertGlyph(59671), -- Priest Shadow
		[259] = F.String.ConvertGlyph(59672), -- Rogue Assassination
		[260] = F.String.ConvertGlyph(59673), -- Rogue Outlaw
		[261] = F.String.ConvertGlyph(59674), -- Rogue Subtlety
		[262] = F.String.ConvertGlyph(59675), -- Shaman Elemental
		[263] = F.String.ConvertGlyph(59676), -- Shaman Enhancement
		[264] = F.String.ConvertGlyph(59677), -- Shaman Restoration
		[265] = F.String.ConvertGlyph(59678), -- Warlock Affliction
		[266] = F.String.ConvertGlyph(59679), -- Warlock Demonology
		[267] = F.String.ConvertGlyph(59680), -- Warlock Destruction
		[268] = F.String.ConvertGlyph(59663), -- Monk Brewmaster
		[269] = F.String.ConvertGlyph(59665), -- Monk Windwalker
		[270] = F.String.ConvertGlyph(59664), -- Monk Mistweaver
		[577] = F.String.ConvertGlyph(59651), -- Demon Hunter Havoc
		[581] = F.String.ConvertGlyph(59652), -- Demon Hunter Vengeance
		[1467] = F.String.ConvertGlyph(59725), -- Evoker Devastation
		[1468] = F.String.ConvertGlyph(59726), -- Evoker Preservation
		[1473] = F.String.ConvertGlyph(59727), -- Evoker Augmentation
	},
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
	bags = true,
	vignette = {
		enable = true,
		print = true,
		debugPrint = false,
		blacklist = {
			[5485] = true,
			[6149] = true,
		},
	},
	titleFont = {
		name = I.Fonts.Primary,
		size = 12,
		style = "SHADOWOUTLINE",
	},
	textFont = {
		name = I.Fonts.Primary,
		size = 11,
		style = "SHADOWOUTLINE",
	},
}

P.databars = {}

P.datatexts = {
	durabilityIlevel = {
		icon = true,
		text = true,
		repairMount = 460,
	},
}

P.actionbars = {
	specBar = {
		enable = true,
		mouseover = false,
		frameStrata = "BACKGROUND",
		frameLevel = 1,
		size = 20,
	},
	keyfeedback = {
		enable = false,
		point = "CENTER",
		x = 0,
		y = 0,
		enableCastLine = true,
		enableCooldown = true,
		enablePushEffect = true,
		enableCast = true,
		enableCastFlash = true,
		lineIconSize = 28,
		mirrorSize = 32,
		lineDirection = "RIGHT",
		forceUseActionHook = true, -- Probably ElvUI needs this
	},
	colorModifier = {
		enable = true,
	},
}

P.autoButtons = {
	enable = true,
	customList = {},
	blackList = {
		[183040] = true,
		[193757] = true,
		[200563] = true,
		[219381] = true,
		[232526] = true,
		[232805] = true,
		[237494] = true,
		[237495] = true,
		[242664] = true,
		[245964] = true,
		[245965] = true,
		[245966] = true,
	},
	bar1 = {
		enable = true,
		mouseOver = false,
		globalFade = false,
		visibility = "[petbattle]hide;show",
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
			name = I.Fonts.Primary,
			size = 12,
			style = "SHADOWOUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1,
			},
		},
		bindFont = {
			name = I.Fonts.Primary,
			size = 12,
			style = "SHADOWOUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1,
			},
		},
		include = "QUEST,BANNER,EQUIP,PROF,HOLIDAY,OPENABLE,DELVE,FISHING",
	},
	bar2 = {
		enable = true,
		mouseOver = false,
		globalFade = false,
		visibility = "[petbattle]hide;show",
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
			name = I.Fonts.Primary,
			size = 12,
			style = "SHADOWOUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1,
			},
		},
		bindFont = {
			name = I.Fonts.Primary,
			size = 12,
			style = "SHADOWOUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1,
			},
		},
		include = "POTIONTWW,FLASKTWW,VANTUSTWW,UTILITY",
	},
	bar3 = {
		enable = true,
		mouseOver = false,
		globalFade = false,
		visibility = "[petbattle]hide;show",
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
			name = I.Fonts.Primary,
			size = 12,
			style = "SHADOWOUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1,
			},
		},
		bindFont = {
			name = I.Fonts.Primary,
			size = 12,
			style = "SHADOWOUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1,
			},
		},
		include = "MAGEFOOD,FOODVENDOR,FOODTWW,RUNETWW,CUSTOM",
	},
	bar4 = {
		enable = false,
		mouseOver = false,
		globalFade = false,
		visibility = "[petbattle]hide;show",
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
			name = I.Fonts.Primary,
			size = 12,
			style = "SHADOWOUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1,
			},
		},
		bindFont = {
			name = I.Fonts.Primary,
			size = 12,
			style = "SHADOWOUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1,
			},
		},
		include = "CUSTOM",
	},
	bar5 = {
		enable = false,
		mouseOver = false,
		globalFade = false,
		visibility = "[petbattle]hide;show",
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
			name = I.Fonts.Primary,
			size = 12,
			style = "SHADOWOUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1,
			},
		},
		bindFont = {
			name = I.Fonts.Primary,
			size = 12,
			style = "SHADOWOUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1,
			},
		},
		include = "CUSTOM",
	},
}

P.vehicleBar = {
	enable = false,
	hideElvUIBars = true,
	buttonWidth = 34,
	animations = true,
	animationsMult = 1,

	position = "BOTTOM,ElvUIParent,BOTTOM,0,140",

	vigorBar = {
		enable = true,
		thrillColor = { r = 0, g = 0.792, b = 1 },
		texture = "ElvUI Norm1",
	},
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
	normalColor = "DEFAULT",
	hoverColor = "CLASS",
	animation = {
		duration = 0.2,
		ease = "quadratic",
		easeInvert = false,
	},
	customNormalColor = { r = 1, g = 1, b = 1 },
	customHoverColor = { r = 0, g = 0.659, b = 1 },
	notification = true,
	visibility = "[petbattle][combat] hide; show",
	tooltipsAnchor = "ANCHOR_BOTTOM",
	friends = {
		showAllFriends = false,
		countSubAccounts = true,
	},
	time = {
		localTime = true,
		twentyFour = true,
		flash = true,
		interval = 10,
		alwaysSystemInfo = false,
		avoidReloadInCombat = true,
		font = {
			name = E.db.general.font,
			size = 25,
			style = "SHADOWOUTLINE",
		},
	},
	home = {
		left = "6948",
		right = "140192",
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
			style = "SHADOWOUTLINE",
		},
	},
	left = {
		[1] = "CHARACTER",
		[2] = "SPELLBOOK",
		[3] = "TALENTS",
		[4] = "FRIENDS",
		[5] = "GUILD",
		[6] = "GROUP_FINDER",
		[7] = "SCREENSHOT",
	},
	right = {
		[1] = "HOME",
		[2] = "ACHIEVEMENTS",
		[3] = "MISSION_REPORTS",
		[4] = "ENCOUNTER_JOURNAL",
		[5] = "TOY_BOX",
		[6] = "PET_JOURNAL",
		[7] = "BAGS",
	},
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
	backdropalpha = 1,
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
			color = { r = 0, g = 0.75, b = 0.98, a = 1 },
		},
	},
	swing = {
		enable = false,
		mcolor = { r = 0.8, g = 0.8, b = 0.8 },
		tcolor = { r = 0.65, g = 0.63, b = 0.35 },
		ocolor = { r = 0, g = 0.5, b = 1 },
	},
	counterBar = {
		enable = true,
	},
	style = true,
	raidIcons = true,
	roleIcons = {
		enable = true,
		roleIconStyle = "LYNUI",
	},
	highlight = true,
	auras = true,
	offlineIndicator = {
		enable = true,
		size = 36,
		anchorPoint = "RIGHT",
		xOffset = 20,
		yOffset = 0,
		texture = "MATERIAL",
		custom = "",
	},
	deathIndicator = {
		enable = true,
		size = 36,
		anchorPoint = "CENTER",
		xOffset = 0,
		yOffset = 0,
		texture = "MATERIAL",
		custom = "",
	},
	restingIndicator = {
		enable = true,
		customClassColor = false,
	},
}

P.nameplates = {
	castbarShield = true,
	gradient = true,
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
			customColor = { r = 1, g = 1, b = 1 },
			font = {
				name = E.db.general.font,
				size = 12,
				style = "SHADOWOUTLINE",
			},
		},
		coords = {
			enable = true,
			mouseOver = false,
			xOffset = 0,
			yOffset = 65,
			format = "%.0f",

			font = {
				name = E.db.general.font,
				size = 12,
				style = "SHADOWOUTLINE",
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
			style = "SHADOWOUTLINE",
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
			["LFR"] = lfr,
			["Mythic Keystone"] = C.StringByTemplate(L["[ABBR] Mythic Keystone"], "rose-500") .. "%mplus%",
			["40-player"] = "40",
			["Normal Scenario"] = format("%s %s", norm, L["[ABBR] Scenario"]),
			["Heroic Scenario"] = format("%s %s", hero, L["[ABBR] Scenario"]),
			["Mythic Scenario"] = format("%s %s", myth, L["[ABBR] Scenario"]),
			["Normal Raid"] = "%numPlayers% " .. norm,
			["Heroic Raid"] = "%numPlayers% " .. hero,
			["Mythic Raid"] = "%numPlayers% " .. myth,
			["LFR Raid"] = "%numPlayers% " .. lfr,
			["Event Scenario"] = L["[ABBR] Event Scenario"],
			["Mythic Party"] = "5" .. myth,
			["Timewalking"] = L["[ABBR] Timewalking"],
			["World PvP Scenario"] = format("|cffFFFF00%s |r", "PvP"),
			["PvEvP Scenario"] = "PvEvP",
			["Timewalking Raid"] = L["[ABBR] Timewalking"],
			["PvP Heroic"] = format("|cffFFFF00%s |r", "PvP"),
			["Warfronts Normal"] = L["[ABBR] Warfronts"],
			["Warfronts Heroic"] = format("|cffff7d0aH|r%s", L["[ABBR] Warfronts"]),
			["Normal Scaling Party"] = L["[ABBR] Normal Scaling Party"],
			["Visions of N'Zoth"] = L["[ABBR] Visions of N'Zoth"],
			["Teeming Island"] = L["[ABBR] Teeming Island"],
			["Torghast"] = L["[ABBR] Torghast"],
			["Path of Ascension: Courage"] = L["[ABBR] Path of Ascension"],
			["Path of Ascension: Loyalty"] = L["[ABBR] Path of Ascension"],
			["Path of Ascension: Wisdom"] = L["[ABBR] Path of Ascension"],
			["Path of Ascension: Humility"] = L["[ABBR] Path of Ascension"],
			["World Boss"] = L["[ABBR] World Boss"],
			["Challenge Level 1"] = L["[ABBR] Challenge Level 1"],
			["Follower"] = L["[ABBR] Follower"],
			["Delves"] = L["[ABBR] Delves"],
			["Quest"] = L["[ABBR] Quest"],
			["Story"] = L["[ABBR] Story"],
			["Lorewalking"] = L["[ABBR] Lorewalking"],
		},
	},
	rectangleMinimap = {
		enable = true,
		heightPercentage = 0.8,
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
			color = { r = 1, g = 1, b = 1 },
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
			color = { r = 0, g = 0, b = 0, a = 0.50 },
		},
		scale = {
			enable = true,
			size = 1.24,
		},
	},
	eventTracker = {
		enable = true,
		style = {
			backdrop = true,
			backdropYOffset = 3,
			backdropSpacing = 6,
			trackerWidth = 240,
			trackerHeight = 30,
			trackerHorizontalSpacing = 10,
			trackerVerticalSpacing = 2,
		},
		font = {
			name = E.db.general.font,
			scale = 1,
			outline = "OUTLINE",
		},
		professionsWeeklyTWW = {
			enable = true,
			desaturate = true,
		},
		weeklyTWW = {
			enable = true,
			desaturate = true,
		},
		ecologicalSuccession = {
			enable = true,
			desaturate = true,
		},
		nightFall = {
			enable = true,
			desaturate = true,
			alert = true,
			sound = true,
			soundFile = "OnePlus Surprise",
			second = 600,
			stopAlertIfCompleted = true,
		},
		theaterTroupe = {
			enable = true,
			desaturate = true,
			alert = true,
			sound = true,
			soundFile = "OnePlus Surprise",
			second = 600,
			stopAlertIfCompleted = true,
		},
		ringingDeeps = {
			enable = true,
			desaturate = true,
		},
		spreadingTheLight = {
			enable = true,
			desaturate = true,
		},
		underworldOperative = {
			enable = true,
			desaturate = true,
		},
		radiantEchoes = {
			enable = false,
			desaturate = false,
			alert = false,
			sound = true,
			soundFile = "OnePlus Surprise",
			second = 600,
			stopAlertIfCompleted = true,
			stopAlertIfPlayerNotEnteredDragonlands = true,
		},
		communityFeast = {
			enable = false,
			desaturate = false,
			alert = false,
			sound = false,
			soundFile = "OnePlus Surprise",
			second = 600,
			stopAlertIfCompleted = true,
			stopAlertIfPlayerNotEnteredDragonlands = true,
		},
		siegeOnDragonbaneKeep = {
			enable = false,
			desaturate = false,
			alert = false,
			sound = false,
			soundFile = "OnePlus Surprise",
			second = 600,
			stopAlertIfCompleted = true,
			stopAlertIfPlayerNotEnteredDragonlands = true,
		},
		researchersUnderFire = {
			enable = false,
			desaturate = false,
			alert = false,
			sound = false,
			soundFile = "OnePlus Surprise",
			second = 600,
			stopAlertIfCompleted = true,
			stopAlertIfPlayerNotEnteredDragonlands = true,
		},
		timeRiftThaldraszus = {
			enable = false,
			desaturate = false,
			alert = false,
			sound = false,
			soundFile = "OnePlus Surprise",
			second = 600,
			stopAlertIfCompleted = false,
			stopAlertIfPlayerNotEnteredDragonlands = true,
		},
		superBloom = {
			enable = false,
			desaturate = false,
			alert = false,
			sound = false,
			soundFile = "OnePlus Surprise",
			second = 600,
			stopAlertIfCompleted = true,
			stopAlertIfPlayerNotEnteredDragonlands = true,
		},
		bigDig = {
			enable = false,
			desaturate = false,
			alert = false,
			sound = true,
			soundFile = "OnePlus Surprise",
			second = 600,
			stopAlertIfCompleted = false,
			stopAlertIfPlayerNotEnteredDragonlands = true,
		},
		iskaaranFishingNet = {
			enable = false,
			alert = false,
			sound = true,
			soundFile = "OnePlus Surprise",
			disableAlertAfterHours = 48,
		},
	},
}

P.media = {}

P.panels = {
	colorType = "CLASS",
	customColor = { r = 1, g = 1, b = 1 },
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
	buttonsPerRow = 9,
	buttonSize = 24,
	backdrop = true,
	backdropSpacing = 2,
	spacing = 2,
	inverseDirection = false,
	orientation = "HORIZONTAL",
	expansionLandingPage = false,
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
	inverse = false,
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
	titleIcon = {
		enable = true,
		width = 18,
		height = 18,
	},
	factionIcon = true,
	petIcon = true,
	petId = true,
	specIcon = true,
	raceIcon = true,
	gradientName = false,
	healthBar = {
		barYOffset = -3,
		textYOffset = 0,
	},
	forceItemLevel = false,
}

P.item = {
	delete = {
		enable = true,
		delKey = true,
		fillIn = "CLICK",
	},
}

P.itemLevel = {
	enable = true,
	flyout = {
		enable = true,
		useBagsFontSetting = false,
		qualityColor = true,
		font = {
			name = I.Fonts.Primary,
			size = 11,
			style = "SHADOWOUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1,
			},
		},
	},
	scrappingMachine = {
		enable = true,
		useBagsFontSetting = false,
		qualityColor = true,
		font = {
			name = I.Fonts.Primary,
			size = 13,
			style = "SHADOWOUTLINE",
			xOffset = 0,
			yOffset = 0,
			color = {
				r = 1,
				g = 1,
				b = 1,
			},
		},
	},
	merchantFrame = {
		enable = true,
	},
	guildNews = {
		enable = true,
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
	petOverlay = { 1, 1, 1, 1 },
	ignoredSpells = {},
	invertIgnored = false,
	enablePet = false,
	x = UIParent:GetWidth() * UIParent:GetEffectiveScale() / 2,
	y = UIParent:GetHeight() * UIParent:GetEffectiveScale() / 2,
	tts = false,
	ttsvoice = nil,
	ttsvolume = 100,
}

P.elvUIIcons = {
	roleIcons = {
		enable = true,
		theme = "MERATHILISUI", -- MERATHILISUI, MATERIAL, SUNUI, SVUI, GLOW, CUSTOM, GRAVED, ElvUI
	},
}

P.scale = {
	enable = false,

	characterFrame = {
		scale = 1,
	},

	dressingRoom = {
		scale = 1,
	},

	syncInspect = {
		enable = false,
	},

	inspectFrame = {
		scale = 1,
	},

	groupFinder = {
		scale = 1,
	},

	wardrobe = {
		scale = 1,
	},

	collections = {
		scale = 1,
	},

	talents = {
		scale = 1,
	},

	profession = {
		scale = 1,
	},

	auctionHouse = {
		scale = 1,
	},

	transmog = {
		enable = false,
	},

	itemUpgrade = {
		scale = 1,
	},

	equipmentFlyout = {
		scale = 2,
	},

	vendor = {
		scale = 1,
	},

	gossip = {
		scale = 1,
	},

	quest = {
		scale = 1,
	},

	mailbox = {
		scale = 1,
	},

	classTrainer = {
		scale = 1,
	},

	friends = {
		scale = 1,
	},
}
