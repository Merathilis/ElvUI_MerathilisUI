local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[730] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"[Skins]: Fixed the Details Embed Width and Height options doing nothing",
		"[BuffReminder]: Fixed group buff coverage checks failing when aura data was masked as a secret value",
		"[Armory]: Fixed a tonumber error when looking up gem IDs in the Socket Panel",
		"[Skins]: Fixed the WowLua skin never applying due to a wrong addon-load callback name",
		"[Core]: Fixed clicking the changelog chat link doing nothing",
	},
	NEW = {
		"[Skins]: Added a Number of Windows option to the Details Embed system",
		"[Skins]: Added a Class Codex skin",
	},
	IMPROVEMENTS = {
		"[Skins]: Updated the Weekly Rewards skin",
		"[BuffReminder]: Match weapon enchants by key instead of name",
		"[Core]: Removed the unfinished module compatibility-check popup",
		"[Core]: Cleaned up dead and unused code across Skins, Options, and Core modules",
	},
}
