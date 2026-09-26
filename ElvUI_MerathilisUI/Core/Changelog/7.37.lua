local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[737] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		'[Movement Alert]: Fixed a Lua error in combat ("attempt to compare a secret number value") when a tracked spell\'s cooldown is restricted.',
		"[ItemLevel/Pet Filter Tab]: The item level on the Scrapping Machine and the pet filter tab in the Collections window could fail to appear, because both loaded through the same event handler.",
	},
	NEW = {
		"[UnitFrames/NamePlates]: New Faction Indicator - shows the faction crest of players from the opposing faction on the Target, Focus and Arena frames (Target of Target and Focus Target optional) and on the NamePlates. Style, size and position can be set per frame.",
	},
	IMPROVEMENTS = {
		"[Login Logo]: The logo no longer shows up while in combat or in an instance, only after the installer has been completed, and it moves more smoothly.",
	},
}
