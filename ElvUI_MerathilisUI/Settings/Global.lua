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

G.addonManager = {
	enable = false,
	extendedSearch = true,
	extendedTooltip = true, -- colored dependencies, optional ones, required by, author
	enableDependencies = true, -- turning an addon on also turns on what it needs
	warnDependents = true, -- turning off an addon others need asks about those
	showVersion = true, -- version behind the title in the list
	-- bisect: state of a running search for a faulty addon, kept between its reloads
	profilePanel = true, -- profile panel next to the addon list is open
	-- width, height: size of the addon list after a resize, unset is Blizzard's size
	-- [addon] = true, false keeps a default lock off
	locked = {
		ElvUI = true,
		ElvUI_Libraries = true,
		ElvUI_Options = true,
		ElvUI_MerathilisUI = true,
	},
	profiles = {}, -- [name] = { [addon] = true }
}

G.mail = {
	templates = {},
	quickAttachRecipients = {},
}

G.mediaPlayer = {
	restoreMusic = false, -- game music was switched off for a track, switch it back on at the next login
}

G.groupFinder = {
	applications = {}, -- Mythic+ application counts of the whole account
}

G.colorPicker = {
	recent = {}, -- last confirmed colors of the options color picker
	favorites = {},
}

G.developer = {
	logLevel = 2,
	channels = {},
}
