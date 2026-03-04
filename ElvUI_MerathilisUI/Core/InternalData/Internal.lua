local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

I.General = {
	AddOnPath = "Interface\\AddOns\\ElvUI_MerathilisUI\\",
	MediaPath = "Interface\\AddOns\\ElvUI_MerathilisUI\\Media\\",
	ElvUIMediaPath = "Interface\\Addons\\ElvUI\\Core\\Media\\",

	DefaultFont = "- Expressway",
	DefaultFontSize = 10,
	DefaultFontOutline = "SHADOWOUTLINE",
}

I.Fonts = {
	Primary = "- Expressway",
	GothamRaid = "- GothamNarrow-Black",
	Runescape = "- Runescape",
	Icons = "- Icons",
}

I.Textures = {
	Primary = "ElvUI Norm1",
}

I.FontNames = {
	[I.Fonts.Primary] = "Primary",
	[I.Fonts.GothamRaid] = "Gotham Raid",
	[I.Fonts.Runescape] = "Runescape",
}

I.FontDescription = {
	[I.Fonts.Primary] = "Used in the majority of the UI.",
	[I.Fonts.GothamRaid] = "Used for names in Raid Frames.",
	[I.Fonts.Runescape] = "Used for some WeakAuras",
}

I.FontOrder = {
	I.Fonts.Primary,
	I.Fonts.GothamRaid,
	I.Fonts.RuneScape,
}

I.MaxLevelTable = {
	["Vanilla"] = 60,
	["Cata"] = 85,
	["Mainline"] = 80,
}

I.MediaKeys = {
	font = "Fonts",
	texture = "Textures",
	chaticon = "ChatIcons",
	icon = "Icons",
	button = "Buttons",
	role = "RoleIcons",
	logo = "Logos",
	armory = "Armory",
}

I.MediaPaths = {
	font = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\]],
	texture = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\]],
	chaticon = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\ChatIcons\]],
	icon = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Icons\]],
	button = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Buttons\]],
	role = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\RoleIcons\]],
	logo = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Logos\]],
	armory = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Backgrounds\Armory\]],
}

-- Inside Media/Core.lua
I.Media = {
	Fonts = {},
	Textures = {},
	ChatIcons = {},
	Icons = {},
	Buttons = {},
	RoleIcons = {},
	Logos = {},
	Armory = {},
}

I.Icons = {
	["Role"] = {
		["MERATHILISUI"] = {
			["default"] = {
				TANK = "LynUITank",
				HEALER = "LynUIHealer",
				DAMAGER = "LynUIDPS",
			},
			["raid1"] = {
				TANK = "WhiteTank",
				HEALER = "WhiteHealer",
				DAMAGER = "WhiteDPS",
			},
			["raid2"] = {
				TANK = "WhiteTank",
				HEALER = "WhiteHealer",
				DAMAGER = "WhiteDPS",
			},
			["raid3"] = {
				TANK = "WhiteTank",
				HEALER = "WhiteHealer",
				DAMAGER = "WhiteDPS",
			},
		},
		["MATERIAL"] = {
			["default"] = {
				TANK = "MaterialTank",
				HEALER = "MaterialHealer",
				DAMAGER = "MaterialDPS",
			},
			["raid1"] = {
				TANK = "MaterialTank",
				HEALER = "MaterialHealer",
				DAMAGER = "MaterialDPS",
			},
			["raid2"] = {
				TANK = "MaterialTank",
				HEALER = "MaterialHealer",
				DAMAGER = "MaterialDPS",
			},
			["raid3"] = {
				TANK = "MaterialTank",
				HEALER = "MaterialHealer",
				DAMAGER = "MaterialDPS",
			},
		},
		["SUNUI"] = {
			["default"] = {
				TANK = "SunUITank",
				HEALER = "SunUIHealer",
				DAMAGER = "SunUIDPS",
			},
			["raid1"] = {
				TANK = "SunUITank",
				HEALER = "SunUIHealer",
				DAMAGER = "SunUIDPS",
			},
			["raid2"] = {
				TANK = "SunUITank",
				HEALER = "SunUIHealer",
				DAMAGER = "SunUIDPS",
			},
			["raid3"] = {
				TANK = "SunUITank",
				HEALER = "SunUIHealer",
				DAMAGER = "SunUIDPS",
			},
		},
		["SVUI"] = {
			["default"] = {
				TANK = "SVUITank",
				HEALER = "SVUIHealer",
				DAMAGER = "SVUIDPS",
			},
			["raid1"] = {
				TANK = "SVUITank",
				HEALER = "SVUIHealer",
				DAMAGER = "SVUIDPS",
			},
			["raid2"] = {
				TANK = "SVUITank",
				HEALER = "SVUIHealer",
				DAMAGER = "SVUIDPS",
			},
			["raid3"] = {
				TANK = "SVUITank",
				HEALER = "SVUIHealer",
				DAMAGER = "SVUIDPS",
			},
		},
		["GLOW"] = {
			["default"] = {
				TANK = "GlowTank",
				HEALER = "GlowHealer",
				DAMAGER = "GlowDPS",
			},
			["raid1"] = {
				TANK = "GlowTank",
				HEALER = "GlowHealer",
				DAMAGER = "GlowDPS",
			},
			["raid2"] = {
				TANK = "GlowTank",
				HEALER = "GlowHealer",
				DAMAGER = "GlowDPS",
			},
			["raid3"] = {
				TANK = "GlowTank",
				HEALER = "GlowHealer",
				DAMAGER = "GlowDPS",
			},
		},
		["CUSTOM"] = {
			["default"] = {
				TANK = "CustomTank",
				HEALER = "CustomHealer",
				DAMAGER = "CustomDPS",
			},
			["raid1"] = {
				TANK = "CustomTank",
				HEALER = "CustomHealer",
				DAMAGER = "CustomDPS",
			},
			["raid2"] = {
				TANK = "CustomTank",
				HEALER = "CustomHealer",
				DAMAGER = "CustomDPS",
			},
			["raid3"] = {
				TANK = "CustomTank",
				HEALER = "CustomHealer",
				DAMAGER = "CustomDPS",
			},
		},
		["GRAVED"] = {
			["default"] = {
				TANK = "GravedTank",
				HEALER = "GravedHealer",
				DAMAGER = "GravedDPS",
			},
			["raid1"] = {
				TANK = "GravedTank",
				HEALER = "GravedHealer",
				DAMAGER = "GravedDPS",
			},
			["raid2"] = {
				TANK = "GravedTank",
				HEALER = "GravedHealer",
				DAMAGER = "GravedDPS",
			},
			["raid3"] = {
				TANK = "GravedTank",
				HEALER = "GravedHealer",
				DAMAGER = "GravedDPS",
			},
		},
		["ElvUI"] = {
			["default"] = {
				TANK = "ElvUITank",
				HEALER = "ElvUIHealer",
				DAMAGER = "ElvUIDPS",
			},
			["raid1"] = {
				TANK = "ElvUITank",
				HEALER = "ElvUIHealer",
				DAMAGER = "ElvUIDPS",
			},
			["raid2"] = {
				TANK = "ElvUITank",
				HEALER = "ElvUIHealer",
				DAMAGER = "ElvUIDPS",
			},
			["raid3"] = {
				TANK = "ElvUITank",
				HEALER = "ElvUIHealer",
				DAMAGER = "ElvUIDPS",
			},
		},
	},
}

I.ProfileNames = {
	["Default"] = MER.Title,
	["Development"] = MER.Title .. "Dev",
}

I.Requirements = {
	["GradientMode"] = {
		I.Enum.Requirements.DARK_MODE_DISABLED,
		I.Enum.Requirements.ELVUI_NOT_SKINNED,
	},
	["VehicleBar"] = {
		I.Enum.Requirements.ELVUI_ACTIONBARS_ENABLED,
	},
	["AdditionalScaling"] = {
		I.Enum.Requirements.ELTRUISM_DISABLED,
	},
	["GameMenu"] = {},
	["RaidInfoFrame"] = {},
}

I.RepairMounts = {
	2237, -- Grizzly Hills Packmaster
	460, -- Grand Expedition Yak
	284, -- Traveler's Tundra Mammoth (Horde)
	280, -- Traveler's Tundra Mammoth (Alliance)
	1039, -- Mighty Caravan Brutosaur
}

I.GradientMode = {
	["BackupMultiplier"] = 0.65,

	["Textures"] = {
		["Left"] = "- MER Mid",
		["Right"] = "- MER Right",
		["Mid"] = "- MER Mid",
	},

	["Layouts"] = {
		[I.Enum.Layouts.HORIZONTAL] = {
			["Left"] = {
				["player"] = true,
				["pet"] = true,
				["tank"] = true,
				["tanktarget"] = true,
				["assist"] = true,
				["assisttarget"] = true,
			},

			["Right"] = {
				["target"] = true,
				["targettarget"] = true,
				["arena"] = true,
				["boss"] = true,
				["focus"] = true,
			},
		},

		[I.Enum.Layouts.VERTICAL] = {
			["Left"] = {
				["player"] = true,
				["pet"] = true,
				["party"] = true,
				["raid1"] = true,
				["raid2"] = true,
				["raid3"] = true,
				["tank"] = true,
				["tanktarget"] = true,
				["assist"] = true,
				["assisttarget"] = true,
			},

			["Right"] = {
				["target"] = true,
				["targettarget"] = true,
				["arena"] = true,
				["boss"] = true,
				["focus"] = true,
			},
		},
	},
}

I.InterruptSpellMap = {
	{ id = 1766, conditions = { class = "ROGUE", level = 6 } }, -- Rogue, Kick
	{ id = 2139, conditions = { class = "MAGE", level = 7 } }, -- Mage, Counterspell
	{ id = 6552, conditions = { class = "WARRIOR", level = 7 } }, -- Warr, Pummel
	{ id = 15487, conditions = { specIds = { 258 } } }, -- Shadow Priest, Silence i kill u
	{ id = 19647, conditions = { specIds = { 265, 267 }, level = 29 } }, -- Aff&Destro Lock, Spell Lock
	{ id = 31935, conditions = { specIds = { 66 } } }, -- Prot Paladin, Avenger's Shield
	{ id = 47528, conditions = { class = "DEATHKNIGHT" } }, -- DK, Mind Freeze
	{ id = 57994, conditions = { class = "SHAMAN" } }, -- Sha, Wind Shear
	{ id = 78675, conditions = { specIds = { 102 } } }, -- Balance Druid, Solar Beeeeeam
	{ id = 89766, conditions = { specIds = { 266 }, level = 29 } }, -- Demo Lock, Axe Toss
	{ id = 96231, conditions = { class = "PALADIN" } }, -- Paladin, Rebuke
	{ id = 106839, conditions = { class = "DRUID" } }, -- Druid, Skull Bash
	{ id = 116705, conditions = { class = "MONK" } }, -- Monk, Spear Hand Strike
	{ id = 147362, conditions = { specIds = { 253, 254 } } }, -- BM/MM Hunter-Counter Shot
	{ id = 183752, conditions = { class = "DEMONHUNTER", level = 20 } }, -- DH, Disrupt
	{ id = 187707, conditions = { specIds = { 255 } } }, -- SV-lol Hunter Muzzle
	{ id = 351338, conditions = { class = "EVOKER" } }, -- Evoker Quell
}

--[[
  Data for which class or spec has which interrupt spell. This is currently only used in Mists and Vanilla,
  as the interrupt logic iirc doesn't work properly in Mists and The API doesn't allow us to do it in the same way in Vanilla
]]

I.InterruptSpellMap_Empty = {}
