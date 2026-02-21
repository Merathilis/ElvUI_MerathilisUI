local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local C = W.Utilities.Color

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
	showRandomPets = true,
}

P.datatexts = {
	durabilityIlevel = {
		mount = 460,
		icon = true,
		whiteText = true,
		whiteIcon = true,
		colored = {
			enable = false,
			a = { value = 50, color = { r = 0.93, g = 0.61, b = 0.02, hex = "|cffed9c07" } },
			b = { value = 20, color = { r = 1, g = 0.011, b = 0.24, hex = "|cffff033e" } },
		},
	},
	datatextcolors = {
		colorhc = {
			b = 0.86,
			g = 0.43,
			hex = "|cff0070dd",
			r = 0,
		},
		colormyth = {
			b = 0.93,
			g = 0.20,
			hex = "|cffa334ee",
			r = 0.63,
		},
		colormythplus = {
			b = 0.24,
			hex = "|cffff033e",
			g = 0.011,
			r = 1,
		},
		colornhc = {
			b = 0,
			g = 1,
			hex = "|cff1eff00",
			r = 0.11,
		},
		colorother = {
			b = 1,
			g = 1,
			hex = "|cffffffff",
			r = 1,
		},
		colortitle = {
			b = 0,
			g = 0.78,
			hex = "|cffffc800",
			r = 1,
		},
		colortip = {
			b = 0.58,
			g = 0.58,
			hex = "|cff969696",
			r = 0.58,
		},
	},
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

P.colors = {
	styleAlpha = 1,
}

P.misc = {
	gmotd = true,
	funstuff = true,
	wowheadlinks = true,
	respec = true,
	tradeTabs = true,
	blockRequest = false,
	singingSockets = {
		enable = true,
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
	copyMog = {
		enable = true,
		ShowHideVisual = true,
		ShowIllusion = true,
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

		[I.Specs.DeathKnight.Blood] = F.String.ConvertGlyph(59648),
		[I.Specs.DeathKnight.Frost] = F.String.ConvertGlyph(59649),
		[I.Specs.DeathKnight.Unholy] = F.String.ConvertGlyph(59650),

		[I.Specs.DemonHunter.Havoc] = F.String.ConvertGlyph(59651),
		[I.Specs.DemonHunter.Vengeance] = F.String.ConvertGlyph(59652),
		[I.Specs.DemonHunter.Devourer] = F.String.ConvertGlyph(59651),

		[I.Specs.Druid.Balance] = F.String.ConvertGlyph(59653),
		[I.Specs.Druid.Feral] = F.String.ConvertGlyph(59654),
		[I.Specs.Druid.Guardian] = F.String.ConvertGlyph(59655),
		[I.Specs.Druid.Restoration] = F.String.ConvertGlyph(59656),

		[I.Specs.Evoker.Devastation] = F.String.ConvertGlyph(59725),
		[I.Specs.Evoker.Preservation] = F.String.ConvertGlyph(59726),
		[I.Specs.Evoker.Augmentation] = F.String.ConvertGlyph(59727),

		[I.Specs.Hunter.BeastMastery] = F.String.ConvertGlyph(59657),
		[I.Specs.Hunter.Marksmanship] = F.String.ConvertGlyph(59658),
		[I.Specs.Hunter.Survival] = F.String.ConvertGlyph(59659),

		[I.Specs.Mage.Arcane] = F.String.ConvertGlyph(59660),
		[I.Specs.Mage.Fire] = F.String.ConvertGlyph(59661),
		[I.Specs.Mage.Frost] = F.String.ConvertGlyph(59662),

		[I.Specs.Monk.Brewmaster] = F.String.ConvertGlyph(59663),
		[I.Specs.Monk.Mistweaver] = F.String.ConvertGlyph(59664),
		[I.Specs.Monk.Windwalker] = F.String.ConvertGlyph(59665),

		[I.Specs.Paladin.Holy] = F.String.ConvertGlyph(59666),
		[I.Specs.Paladin.Protection] = F.String.ConvertGlyph(59667),
		[I.Specs.Paladin.Retribution] = F.String.ConvertGlyph(59668),

		[I.Specs.Priest.Discipline] = F.String.ConvertGlyph(59669),
		[I.Specs.Priest.Holy] = F.String.ConvertGlyph(59670),
		[I.Specs.Priest.Shadow] = F.String.ConvertGlyph(59671),

		[I.Specs.Rogue.Assassination] = F.String.ConvertGlyph(59672),
		[I.Specs.Rogue.Outlaw] = F.String.ConvertGlyph(59673),
		[I.Specs.Rogue.Subtlety] = F.String.ConvertGlyph(59674),

		[I.Specs.Shaman.Elemental] = F.String.ConvertGlyph(59675),
		[I.Specs.Shaman.Enhancement] = F.String.ConvertGlyph(59676),
		[I.Specs.Shaman.Restoration] = F.String.ConvertGlyph(59677),

		[I.Specs.Warlock.Affliction] = F.String.ConvertGlyph(59678),
		[I.Specs.Warlock.Demonology] = F.String.ConvertGlyph(59679),
		[I.Specs.Warlock.Destruction] = F.String.ConvertGlyph(59680),

		[I.Specs.Warrior.Arms] = F.String.ConvertGlyph(59681),
		[I.Specs.Warrior.Fury] = F.String.ConvertGlyph(59682),
		[I.Specs.Warrior.Protection] = F.String.ConvertGlyph(59683),
	},
}

P.tooltip = {
	achievement = true,
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

P.actionbars = {
	specBar = {
		enable = true,
		mouseover = false,
		frameStrata = "BACKGROUND",
		frameLevel = 1,
		size = 20,
	},
	colorModifier = {
		enable = true,
	},
}

P.cooldownManager = {
	enable = true,
	fading = false,

	dynamicBarsWidth = false,
	dynamicCastbarWidth = false,

	-- Anchoring
	anchors = {
		essential = {
			enable = false,
			yOffset = -4,
		},
		utility = {
			enable = false,
			yOffset = -4,
		},
		buff = {
			enable = false,
			yOffset = 20,
		},
		buffBar = {
			enable = false,
			yOffset = 80,
		},
	},

	-- Centering
	centering = {
		essential = false,
		utility = false,
		buff = false,
	},

	-- Keybind
	keybinds = {
		essential = {
			enable = false,
			labelFont = I.Fonts.Primary,
			labelFontSize = 16,
			labelFontOutline = "OUTLINE",
			labelFontShadow = false,
			anchor = "TOPRIGHT",
			xOffset = -2,
			yOffset = -2,
		},
		utility = {
			enable = false,
			labelFont = I.Fonts.Primary,
			labelFontSize = 12,
			labelFontOutline = "OUTLINE",
			labelFontShadow = false,
			anchor = "TOPRIGHT",
			xOffset = -1,
			yOffset = -1,
		},
	},
}

P.vehicleBar = {
	enable = false,
	hideElvUIBars = true,
	buttonWidth = 34,
	animations = true,
	animationsMult = 1,

	showKeybinds = true,
	showMacro = true,

	position = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 90),

	vigorBar = {
		enable = true,
		height = 10,
		normalTexture = E.db.unitframe.statusbar,
		darkTexture = E.db.unitframe.statusbar,
		useCustomColor = false,
		customColorLeft = { r = 0.208, g = 0.424, b = 1 },
		customColorRight = { r = 0, g = 0.835, b = 1 },
		thrillColor = F.Table.HexToRGB("#00caff"),
		showSpeedText = true,
		speedTextFont = I.Fonts.Primary,
		speedTextFontSize = 20,
		speedTextOffsetY = -5,
		speedTextUpdateRate = 0.1,
	},
}

P.miniMapCoords = {
	enable = true,
	xOffset = 0,
	yOffset = 70,
	format = "%.0f",
	mouseOver = false,

	font = {
		name = E.db.general.font,
		size = 14,
		style = "SHADOWOUTLINE",
		color = {
			r = 1,
			g = 1,
			b = 1,
		},
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

P.portraits = {
	custom = {
		border = "",
		boss = "",
		bossborder = "",
		bossshadow = "",
		elite = "",
		eliteborder = "",
		eliteshadow = "",
		enable = false,
		extra = "",
		extraborder = "",
		extrashadow = "",
		inner = "",
		mask = "",
		maskb = "",
		shadow = "",
		texture = "",
	},
	extra = {
		rare = "a",
		elite = "a",
		boss = "a",
	},
	player = {
		flipe = false,
		cast = true,
		enable = true,
		texture = "drop",
		mirror = false,
		size = 80,
		point = "RIGHT",
		relativePoint = "LEFT",
		x = 12,
		y = 15,
		strata = "AUTO",
		level = 20,
	},
	target = {
		flipe = false,
		cast = true,
		enable = true,
		texture = "drop",
		extraEnable = true,
		mirror = true,
		size = 80,
		point = "LEFT",
		relativePoint = "RIGHT",
		x = -12,
		y = 15,
		strata = "AUTO",
		level = 20,
	},
	pet = {
		flipe = false,
		enable = false,
		texture = "drop",
		mirror = false,
		size = 90,
		point = "RIGHT",
		relativePoint = "LEFT",
		x = 0,
		y = 0,
		strata = "AUTO",
		level = 20,
	},
	general = {
		enable = false,
		desaturation = true,
		bgstyle = 1,
		classicons = false,
		classiconstyle = "BLIZZARD",
		corner = true,
		default = false,
		gradient = true,
		ori = "HORIZONTAL",
		reaction = false,
		style = "a",
		trilinear = true,
		usetexturecolor = false,
		deathcolor = false,
	},
	zoom = 0,
	shadow = {
		enable = true,
		inner = true,
		border = true,
		classBG = true,
		bgColorShift = 0.25,
		color = { r = 0.094, g = 0.094, b = 0.094, a = 0.6 },
		innerColor = { r = 0.094, g = 0.094, b = 0.094, a = 0.75 },
		background = { r = 0, g = 0, b = 0, a = 1 },
	},
	colors = {
		border = {
			default = { r = 0, g = 0, b = 0, a = 1 },
			rare = { r = 1, g = 1, b = 1, a = 1 },
			elite = { r = 1, g = 1, b = 1, a = 1 },
			rareelite = { r = 1, g = 1, b = 1, a = 1 },
			boss = { r = 1, g = 0, b = 0, a = 1 },
		},
		death = {
			a = { r = 0.89, g = 0.61, b = 0.29, a = 1 },
			b = { r = 0.89, g = 0.42, b = 0.16, a = 1 },
		},
		default = {
			a = { r = 0.89, g = 0.61, b = 0.29, a = 1 },
			b = { r = 0.89, g = 0.42, b = 0.16, a = 1 },
		},
		DEATHKNIGHT = {
			a = { r = 0.81, g = 0.17, b = 0.17, a = 1 },
			b = { r = 0.96, g = 0.14, b = 0.31, a = 1 },
		},
		DEMONHUNTER = {
			a = { r = 0.70, g = 0, b = 0.54, a = 1 },
			b = { r = 0.72, g = 0, b = 0.96, a = 1 },
		},
		DRUID = {
			a = { r = 1.00, g = 0.36, b = 0.04, a = 1 },
			b = { r = 1, g = 0.50, b = 0.03, a = 1 },
		},
		EVOKER = {
			a = { r = 0.20, g = 0.58, b = 0.50, a = 1 },
			b = { r = 0.2, g = 1, b = 0.97, a = 1 },
		},
		HUNTER = {
			a = { r = 0.6, g = 0.8, b = 0.32, a = 1 },
			b = { r = 0.67, g = 0.92, b = 0.3, a = 1 },
		},
		MAGE = {
			a = { r = 0, g = 0.60, b = 0.81, a = 1 },
			b = { r = 0.2, g = 0.78, b = 0.98, a = 1 },
		},
		MONK = {
			a = { r = 0, g = 0.78, b = 0.53, a = 1 },
			b = { r = 0, g = 1, b = 0.52, a = 1 },
		},
		PALADIN = {
			a = { r = 1, g = 0.25, b = 0.65, a = 1 },
			b = { r = 0.96, g = 0.52, b = 0.84, a = 1 },
		},
		PRIEST = {
			a = { r = 0.74, g = 0.74, b = 0.74, a = 1 },
			b = { r = 1, g = 1, b = 1, a = 1 },
		},
		ROGUE = {
			a = { r = 1, g = 0.74, b = 0.23, a = 1 },
			b = { r = 1, g = 0.92, b = 0.25, a = 1 },
		},
		SHAMAN = {
			a = { r = 0.00, g = 0.38, b = 0.92, a = 1 },
			b = { r = 0.03, g = 0.5, b = 0.92, a = 1 },
		},
		WARLOCK = {
			a = { r = 0.38, g = 0.28, b = 0.67, a = 1 },
			b = { r = 0.52, g = 0.38, b = 0.92, a = 1 },
		},
		WARRIOR = {
			a = { r = 0.78, g = 0.54, b = 0.28, a = 1 },
			b = { r = 0.87, g = 0.63, b = 0.38, a = 1 },
		},
		rare = {
			a = { r = 0, g = 0.46, b = 1, a = 1 },
			b = { r = 0, g = 0.27, b = 0.59, a = 1 },
		},
		rareelite = {
			a = { r = 0.63, g = 0, b = 1, a = 1 },
			b = { r = 0.44, g = 0, b = 0.70, a = 1 },
		},
		elite = {
			a = { r = 1, g = 0, b = 0.90, a = 1 },
			b = { r = 0.62, g = 0, b = 0.36, a = 1 },
		},
		boss = {
			a = { r = 0.78, g = 0.12, b = 0.12, a = 1 },
			b = { r = 0.85, g = 0.25, b = 0.25, a = 1 },
		},
		enemy = {
			a = { r = 0.78, g = 0.12, b = 0.12, a = 1 },
			b = { r = 0.85, g = 0.25, b = 0.25, a = 1 },
		},
		neutral = {
			a = { r = 1.00, g = 0.70, b = 0, a = 1 },
			b = { r = 0.77, g = 0.45, b = 0, a = 1 },
		},
		friendly = {
			a = { r = 0.17, g = 0.75, b = 0, a = 1 },
			b = { r = 0, g = 1, b = 0.22, a = 1 },
		},
	},
}

P.unitframes = {
	style = true,
	raidIcons = true,
	highlight = true,
	auras = true,
	restingIndicator = {
		enable = true,
		customClassColor = false,
	},
}

P.nameplates = {
	gradient = true,
}

P.colorModifiers = {
	enable = true,
}

P.nameHover = {
	enable = true,

	guildName = false,
	guildRank = false,
	race = false,
	status = true,
	faction = false,
	level = true,
	classification = true,

	mainTextSize = 14,
	mainTextOutline = "SHADOWOUTLINE",
	statusTextSize = 11,
	statusTextOutline = "SHADOWOUTLINE",
	headerTextSize = 11,
	headerTextOutline = "SHADOWOUTLINE",
	guildTextSize = 11,
	guildTextOutline = "SHADOWOUTLINE",
	subTextSize = 11,
	subTextOutline = "SHADOWOUTLINE",

	targettarget = false,
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

	encounterjournal = {
		scale = 1,
	},
}
