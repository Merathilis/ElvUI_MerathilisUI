local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local pairs = pairs

I.General = {
	MediaPath = "Interface\\AddOns\\ElvUI_MerathilisUI\\Media\\",
	DefaultFont = "Expressway",
}

I.Fonts = {
	Primary = "Expressway",
	GothamRaid = "GothamNarrow-Black",
	Runescape = "Runescape",
	Icons = "Icons",
}

I.Textures = {
	Primary = "ElvUI Norm1",
}

I.Colors = {
	-- Shared accent color for MerathilisUI-only option widgets (keep in sync with F.cOption's "teal" hex: #00c0fa)
	Accent = { r = 0x00 / 255, g = 0xc0 / 255, b = 0xfa / 255 },
}

I.MaxLevelTable = {
	["Mainline"] = 90,
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

-- Role icon theme -> media name prefix (<prefix>Tank, <prefix>Healer, <prefix>DPS)
I.Icons = {
	Role = {},
}

for theme, prefix in pairs({
	MERATHILISUI = "White",
	MATERIAL = "Material",
	SUNUI = "SunUI",
	SVUI = "SVUI",
	GLOW = "Glow",
	CUSTOM = "Custom",
	GRAVED = "Graved",
	ElvUI = "ElvUI",
}) do
	I.Icons.Role[theme] = {
		TANK = prefix .. "Tank",
		HEALER = prefix .. "Healer",
		DAMAGER = prefix .. "DPS",
	}
end

I.ProfileNames = {
	["Default"] = MER.Title,
	["Development"] = MER.Title .. "Dev",
}

-- Requirements per feature, checked by MER:HasRequirements (Core/Requirements.lua)
I.Requirements = {
	["GradientMode"] = {},
	["ActionBars"] = {
		I.Enum.Requirements.ELVUI_ACTIONBARS_ENABLED,
	},
	["VehicleBar"] = {
		I.Enum.Requirements.ELVUI_ACTIONBARS_ENABLED,
	},
	["UnitFrames"] = {
		I.Enum.Requirements.ELVUI_UNITFRAMES_ENABLED,
	},
	["NamePlates"] = {
		I.Enum.Requirements.ELVUI_NAMEPLATES_ENABLED,
	},
	["Chat"] = {
		I.Enum.Requirements.ELVUI_CHAT_ENABLED,
	},
	["Minimap"] = {
		I.Enum.Requirements.ELVUI_MINIMAP_ENABLED,
	},
	["AdditionalScaling"] = {
		I.Enum.Requirements.ELTRUISM_DISABLED,
	},
	-- BenikUI replaces ElvUI's AFK screen as well
	["AFK"] = {
		I.Enum.Requirements.BENIKUI_DISABLED,
	},
	["GameMenu"] = {},
	["RaidInfoFrame"] = {},
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

I.Values = {
	positionValues = {
		TOPLEFT = "TOPLEFT",
		LEFT = "LEFT",
		BOTTOMLEFT = "BOTTOMLEFT",
		RIGHT = "RIGHT",
		TOPRIGHT = "TOPRIGHT",
		BOTTOMRIGHT = "BOTTOMRIGHT",
		CENTER = "CENTER",
		TOP = "TOP",
		BOTTOM = "BOTTOM",
	},
}
