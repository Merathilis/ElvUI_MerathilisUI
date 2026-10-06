local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

G.core = {
	changlogPopup = true,
	loginMsg = true,
	compatibilityCheck = true,
	compatibilityKept = {}, -- [check key] = true, shared features the user keeps on for both
	autoCopyPrivateProfile = {
		enable = false,
		copyFrom = nil,
		initializedCharacters = {},
	},
}

G.mail = {
	templates = {},
	quickAttachRecipients = {},
}

G.developer = {
	logLevel = 2,
	channels = {},
}
