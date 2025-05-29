local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

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
	role = "RoleIcons",
	logo = "Logos",
	armory = "Armory",
}

I.MediaPaths = {
	font = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\]],
	texture = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\]],
	chaticon = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\ChatIcons\]],
	icon = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Icons\]],
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
}

I.RepairMounts = {
	2237, -- Grizzly Hills Packmaster
	460, -- Grand Expedition Yak
	284, -- Traveler's Tundra Mammoth (Horde)
	280, -- Traveler's Tundra Mammoth (Alliance)
	1039, -- Mighty Caravan Brutosaur
}
