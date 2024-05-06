local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

I.General = {
	AddOnPath = "Interface\\AddOns\\ElvUI_MerathilisUI\\",
	MediaPath = "Interface\\AddOns\\ElvUI_MerathilisUI\\Media\\",
	ElvUIMediaPath = "Interface\\Addons\\ElvUI\\Core\\Media\\",
}

I.Fonts = {
	Primary = "- Expressway",
	GothamRaid = "- GothamNarrow-Black",
	Runescape = "- Runescape",
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

I.MediaKeys = {
	font = "Fonts",
	texture = "Textures",
	chaticon = "ChatIcons",
	icon = "Icons",
	role = "RoleIcons",
	logo = "Logos",
}

I.MediaPaths = {
	font = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\]],
	texture = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\]],
	chaticon = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\ChatIcons\]],
	icon = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Icons\]],
	role = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\RoleIcons\]],
	logo = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Logos\]],
}

-- Inside Media/Core.lua
I.Media = {
	Fonts = {},
	Textures = {},
	ChatIcons = {},
	Icons = {},
	RoleIcons = {},
	Logos = {},
}

I.ProfileNames = {
	["Default"] = MER.Title,
	["Development"] = MER.Title .. "Dev",
}
