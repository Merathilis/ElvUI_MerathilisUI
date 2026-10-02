local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[739] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"[Bags]: Using or looting items in combat while the categorized bags are open no longer causes blocked actions; the counts keep updating and the bags rearrange after combat.",
		"[Bags]: Dragging an item onto the + slot of Pinned Items pins it again instead of breaking its category assignment, and Recent Items no longer offers + slots or a manual item order.",
		"[Status Report]: Opens without a MerathilisUI profile as well, detects the Mac client again and lists BugGrabber correctly.",
		"[Status Report]: The pixel perfect UI scale no longer shows up as a warning because of rounding, and the scale values are shortened to three decimals.",
	},
	NEW = {
		"[HoverCast]: New click-casting module (Modules > HoverCast) as a replacement for Clique: global and per-spec bindings for spells, macros and items on the ElvUI unit frames, optional mouseover casting on nameplates and units in the world, presets for dispels, externals, trinkets and a dynamic resurrect, Quickbind, out-of-combat and content (Solo/Party/Raid/PvP) filters and Friendly/Enemy splits on one key.",
		"[Minimap Buttons]: New Addon Buttons button on the main bar: it collects the minimap buttons of your addons (LibDBIcon and others) into a grid with its own size, row and ignore settings. Stays off while the WindTools or ProjectAzilroka collector is enabled, the options offer a switch to turn off the WindTools one.",
		"[Options]: The start page shows the newest changes, rotating tips and a status line next to the logo.",
	},
	IMPROVEMENTS = {
		"[Game Menu]: The Show Clock and Fade In Content options apply without a reload.",
		"[Game Menu]: The Mythic+ options are no longer marked as work in progress.",
		"[Installer]: Reworked with a new look, a check mark for every applied step and fewer pages: the whole layout is one step with a Gradient or Dark preview, all AddOn profiles share one page and the last page sums up what was applied. Import Existing takes over the MerathilisUI profile and settings of another character, Skip no longer marks the profile as installed.",
		"[Minimap Buttons]: The Tracking button is enabled by default.",
		"[Options]: Cursor, DataTexts, Loot Roll, Movement Alert and Tracker have their own category icons.",
		"[Status Report]: Reworked with a diagnostics section (Lua errors this session, MerathilisUI log, debug channels, debug mode), blocked features with their reason, tips on hover and clickable switches for Lua errors, taint log, log level and CPU profiling. Copy Report creates one text for bug reports with all loaded addons and the log, also available via /muidev status.",
		"[Style]: Turning the MerathilisUI style on or off no longer asks for a reload, it applies right away.",
	},
}
