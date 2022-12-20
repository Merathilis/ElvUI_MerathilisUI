local MER, F, E, L, V, P, G = unpack(select(2, ...))

G.core = {
	compatibilityCheck = true,
	cvarAlert = false,
	logLevel = 2,
	loginMsg = true,
	fixLFG = true,
}

G.mail = {
	contacts = {
		alts = {},
		favorites = {},
	}
}

G.bags = {
	CustomJunkList = {}
}
