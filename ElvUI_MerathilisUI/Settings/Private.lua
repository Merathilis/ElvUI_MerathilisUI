local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

-- install_complete (MerathilisUI version) is written by the installer
V.general = {}

V.skins = {
	enable = true,
	shadowOverlay = false,
	addonSkins = {
		enable = true,
		aussyLoot = true,
		bSync = true,
		bugSack = true,
		ls = true,
		cl = true,
		gil = true,
		pawn = true,
		cap = true,
		wim = true,
		wowLua = true,
		klf = true,
		classCodex = true,
		pam = true,
		bw = {
			enable = true,
			normalBar = {
				smooth = true,
				spark = true,
				colorOverride = true,
				colorLeft = { r = 0.32941, g = 0.52157, b = 0.93333, a = 1 },
				colorRight = { r = 0.25882, g = 0.84314, b = 0.86667, a = 1 },
			},
			emphasizedBar = {
				smooth = true,
				spark = true,
				colorOverride = true,
				colorLeft = { r = 1, g = 0.23, b = 0.0, a = 1 },
				colorRight = { r = 1, g = 0.48, b = 0.03, a = 1 },
			},
		},
		dt = {
			enable = true,
			gradientName = true,
			gradientBars = true,
		},
	},
	blizzard = {
		damageMeter = {
			enable = true,
		},
		weeklyRewards = {
			font = {
				size = 10,
				style = "SHADOWOUTLINE",
			},
		},
	},

	embed = {
		enable = false,
		toggleDirection = 1,
		mouseOver = false,
		windows = 1,
		sizes = {
			[1] = { width = 340, height = 144 },
			[2] = { width = 340, height = 144 },
			[3] = { width = 340, height = 144 },
			[4] = { width = 340, height = 144 },
			[5] = { width = 340, height = 144 },
		},
	},
}

-- Quick Grid: the custom deck holds spells, so it is per character
V.quickGrid = {
	custom = {},
}

-- Group Finder: Mythic+ application counts of this character
V.groupFinder = {
	applications = {},
	session = {}, -- kept across a reload or relog within a few minutes
	sessionTime = 0,
}

-- Loadout Manager: gear sets and talent loadouts are per character
V.loadoutManager = {
	-- Off until the user opts in; switching it on is what registers events
	enable = false,
	gearEnabled = true,
	talentEnabled = true,
	announce = true,
	queueInCombat = true,
	specSwap = true, -- re-run swaps when your specialization changes inside an instance
	specWarning = true, -- the "DONT MOVE" panel while talents change

	-- Gear mappings use Blizzard Equipment Manager set names
	instanceSets = {}, -- [instanceID] = equipment set name
	difficultySets = {}, -- ["instanceID:difficultyID"] = equipment set name
	typeDefaults = {}, -- world/party/mplus/... = equipment set name

	-- Talent mappings store { configID = number, name = string, specID = number }
	talentInstanceSets = {},
	talentDifficultySets = {},
	talentTypeDefaults = {},

	-- Spec layer: [specID] = the same six mapping tables as above.
	-- The root tables above are the "All Specs" fallback layer.
	specDefaults = {},
}
