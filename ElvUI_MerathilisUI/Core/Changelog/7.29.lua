local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[729] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"[Armory]: Fixed a dead option in the Socket Panel",
		"[Theme]: Fixed the Target of Target frame showing the wrong (non-class) color in instanced content",
		"[Armory]: Fixed the Socket Panel not updating until the character frame was closed and reopened after a gear swap",
		"[Armory]: Fixed disabled Titles buttons staying disabled after being recycled by the scroll box",
	},
	NEW = {
		"[Armory]: Added a search box and an Earned/Unearned filter to the Titles panel on the Character Frame",
		"[Armory]: Added a quick Socket Panel to the Character Frame",
		"[Armory]: Added a custom Equipment Manager panel to the Character Frame, replacing Blizzard's native one",
		"[BuffReminder]: Added a new module that reminds you of missing raid buffs, self auras and consumables (flasks, food, weapon enchants, poisons, rites, imbues) with clickable icons, appear sounds and a movable anchor",
	},
	IMPROVEMENTS = {
		"[Skins]: Styled the DamageMeter background",
		"[Armory]: Adjusted some Socket Panel defaults",
		"[Armory]: Small position update for the Watermark on the Character Frame",
		"[Theme]: Some more secret protections",
		"[Armory]: Matched the Equipment Manager's \"Gear Sets\" header style to the Stats panel category headers",
	},
}
