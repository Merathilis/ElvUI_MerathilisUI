local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[745] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"[Bags]: New bags can now be equipped through the bag bar of the categorized bags. Clicking or dropping an item on a bag slot now works like Blizzard's bag slots: a bag gets equipped or swapped in, an equipped bag can be dragged out, and the bar updates right away.",
		"[HoverCast]: The Dispels binding of warlocks now casts Singe Magic through Command Demon, so it also works with a sacrificed Imp, and the bindings update when the pet changes.",
		"[Skins]: Fixed a Lua error on login with WIM 3.19, which moved its options into Blizzard's Settings panel, and the minimap button menu showing an empty box instead of the conversations.",
	},
	NEW = {
		"[Skins]: New RestedXP Guides skin. The guide window becomes one panel with a header bar and a class colored rule, the current steps in the list are marked in class color, active step cards, Active Items, Active Targets and Level Splits share one card style with borderless title tabs, and timer bars use the class gradient. Works with the legacy and the V2 guide window.",
		"[Armory]: Now also works on WoW Forever's own character frame: background, name header, decorative lines, item quality gradients, enchants and a restyled stats list. Next to each slot it shows the item's main and secondary stat instead of the item level, weapons show their damage per second (new option Item Stats). Upgrade tracks, socket panel, gear set panel and the stat picker stay Retail only.",
	},
	IMPROVEMENTS = {},
}
