local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

I.Strings = {}

I.Strings.Colors = {
	[I.Enum.Colors.MER] = "00c0fa", -- #00c0fa
	[I.Enum.Colors.DETAILS] = "f7f552", -- #f7f552
	[I.Enum.Colors.BIGWIGS] = "c94b28", -- #c94b28
	[I.Enum.Colors.ELVUI] = "1784d1", -- #1784d1
	[I.Enum.Colors.GOOD] = "66bb6a", -- #66bb6a
	[I.Enum.Colors.ERROR] = "ff2735", -- #ff2735
	[I.Enum.Colors.WARNING] = "ffff00", -- #ffff00
	[I.Enum.Colors.EPIC] = "a335ee", -- #a335ee
	[I.Enum.Colors.MUTED] = "888888", -- #888888
}

I.Strings.Branding = {
	ColorHex = I.Strings.Colors[I.Enum.Colors.MER],
	ColorRGB = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.MER]),
	ColorRGBA = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.MER] .. "ff"),
}
