local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[739] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"[Bags]: Using or looting items in combat while the categorized bags are open no longer causes blocked actions; the counts keep updating and the bags rearrange after combat.",
		"[Bags]: Dragging an item onto the + slot of Pinned Items pins it again instead of breaking its category assignment, and Recent Items no longer offers + slots or a manual item order.",
		"[Status Report]: Opens without a MerathilisUI profile as well, detects the Mac client again and lists BugGrabber correctly.",
	},
	NEW = {
		"[Options]: The start page shows the newest changes, rotating tips and a status line next to the logo.",
	},
	IMPROVEMENTS = {
		"[Status Report]: Reworked with a diagnostics section (Lua errors this session, MerathilisUI log, debug channels, debug mode), blocked features with their reason, tips on hover and clickable switches for Lua errors, taint log, log level and CPU profiling. Copy Report creates one text for bug reports with all loaded addons and the log, also available via /muidev status.",
		"[Style]: Turning the MerathilisUI style on or off no longer asks for a reload, it applies right away.",
	},
}
