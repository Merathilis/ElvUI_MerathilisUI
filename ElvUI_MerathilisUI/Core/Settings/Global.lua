local MER, F, E, L, V, P, G = unpack(select(2, ...))

G.core = {
	compatibilityCheck = true,
	cvarAlert = false,
	logLevel = 2,
	loginMsg = true,
	fixLFG = false,
}

G.mail = {
	contacts = {
		alts = {},
		favorites = {},
	}
}

G.microBar = {
	covenantCache = {}
}

G.bags = {
	CustomJunkList = {}
}

G.maps = {
	eventTracker = {}
}
