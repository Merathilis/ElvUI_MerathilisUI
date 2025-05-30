local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

I.Strings = {}

I.Strings.Requirements = {
	[I.Enum.Requirements.MERUI_PROFILE] = "NO_STRING_NEEDED",
	[I.Enum.Requirements.GRADIENT_MODE_ENABLED] = "NO_STRING_NEEDED",
	[I.Enum.Requirements.GRADIENT_MODE_DISABLED] = "Only one theme can be activated at the same time. Please disable gradient mode",
	[I.Enum.Requirements.ELVUI_ACTIONBARS_ENABLED] = "You can't use this module because ElvUI's ActionBars module is currently turned off. Please enable it to unlock this option.",
	[I.Enum.Requirements.ELTRUISM_DISABLED] = "You can't use this module because EltruismUI is enabled. Please disable it to unlock this option.",
}

I.Strings.RequirementsDebug = {
	[I.Enum.Requirements.MERUI_PROFILE] = "No MerathilisUI Profile",
	[I.Enum.Requirements.GRADIENT_MODE_ENABLED] = "GM Disabled",
	[I.Enum.Requirements.GRADIENT_MODE_DISABLED] = "GM Enabled",
}

I.Strings.Colors = {
	[I.Enum.Colors.MER] = "00c0fa", -- #00c0fa
	[I.Enum.Colors.DETAILS] = "f7f552", -- #f7f552
	[I.Enum.Colors.BIGWIGS] = "c94b28", -- #c94b28
	[I.Enum.Colors.OMNICD] = "8634eb", -- #8634eb
	[I.Enum.Colors.WT] = "54e5ff", -- #54e5ff
	[I.Enum.Colors.FCT] = "dd2244", -- #dd2244
	[I.Enum.Colors.AS] = "16C3F2", -- #16C3F2
	[I.Enum.Colors.ELVUI] = "1784d1", -- #1784d1
	[I.Enum.Colors.ERROR] = "ff2735", -- #ff2735
	[I.Enum.Colors.GOOD] = "66bb6a", -- #66bb6a
	[I.Enum.Colors.WARNING] = "ffff00", -- #ffff00
	[I.Enum.Colors.WHITE] = "ffffff", -- #ffffff
	[I.Enum.Colors.GREY] = "B5B5B5", -- #B5B5B5

	[I.Enum.Colors.SILVER] = "a3a3a3", -- #a3a3a3
	[I.Enum.Colors.GOLD] = "cfc517", -- ##cfc517

	[I.Enum.Colors.LEGENDARY] = "ff8000", -- #ff8000
	[I.Enum.Colors.EPIC] = "a335ee", -- #a335ee
	[I.Enum.Colors.RARE] = "0070dd", -- #0070dd
	[I.Enum.Colors.BETA] = "1eff00", -- #1eff00
}

I.Strings.Branding = {
	ColorHex = I.Strings.Colors[I.Enum.Colors.MER],
	ColorRGB = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.MER]),
	ColorRGBA = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.MER] .. "ff"),
}

I.Strings.Classes = {
	"WARRIOR",
	"PALADIN",
	"HUNTER",
	"ROGUE",
	"PRIEST",
	"SHAMAN",
	"MAGE",
	"WARLOCK",
	"DRUID",
	"DEATHKNIGHT",
	"MONK",
	"DEMONHUNTER",
	"EVOKER",
}
