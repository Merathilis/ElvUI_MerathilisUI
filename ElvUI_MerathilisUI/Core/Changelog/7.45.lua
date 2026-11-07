local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[745] = {
	RELEASE_DATE = "07.11.2026",
	FIXES = {
		"[ActionBars]: The cooldown swipe now fully covers the icon. On UI scales that are not pixel perfect a thin strip of the icon showed next to the swipe, mostly on the left edge.",
		"[Bags]: New bags can now be equipped through the bag bar of the categorized bags. Clicking or dropping an item on a bag slot now works like Blizzard's bag slots: a bag gets equipped or swapped in, an equipped bag can be dragged out, and the bar updates right away.",
		"[Bags]: Buying a bank or Warband bank tab from the categorized bank works again. The game silently blocked the purchase after confirming, the row now opens Blizzard's own purchase dialog.",
		"[HoverCast]: The Dispels binding of warlocks now casts Singe Magic through Command Demon, so it also works with a sacrificed Imp, and the bindings update when the pet changes.",
		"[Installer]: Finishing the installer without applying any step no longer hides all MerathilisUI options and features.",
		"[Skins]: Fixed a Lua error on login with WIM 3.19, which moved its options into Blizzard's Settings panel, and the minimap button menu showing an empty box instead of the conversations.",
	},
	NEW = {
		"[Bags]: The categorized bags now show WoW Forever's keyring. Keys get their own Keyring category and section, which stays listed in the sidebar even while the keyring is empty, the keyring's slots stay out of the free slot count, and a new keyring button in the bag bar shows or hides it. Dropping a key on that button puts it into the keyring.",
		"[HoverCast]: The binding picker has a new Actions tab, so Target Unit and Context Menu can be added as extra global or spec bindings, for example a second key for the menu. Added global actions can be deleted again.",
		"[Skins]: New RestedXP Guides skin. The guide window becomes one panel with a header bar and a class colored rule, the current steps in the list are marked in class color, active step cards, Active Items, Active Targets and Level Splits share one card style with borderless title tabs, and timer bars use the class gradient. Works with the legacy and the V2 guide window.",
		"[Armory]: Now also works on WoW Forever's own character frame: background, name header, decorative lines, item quality gradients, enchants and a restyled stats list. Next to each slot it shows the item's main and secondary stat instead of the item level, weapons show their damage per second (new option Item Stats). Upgrade tracks, socket panel, gear set panel and the stat picker stay Retail only.",
	},
	IMPROVEMENTS = {
		"[Quick Grid]: New Equipment Sets deck with the first eight sets of your Equipment Manager, the set you wear is marked. Equipment sets can also go into the custom deck by typing their name.",
		"[Quick Grid]: On WoW Forever, spells now cast the highest rank you know instead of the rank they were added with.",
		"[Bags]: The Offline Bank and the item counts in tooltips now also work on WoW Forever, with all nine bank bag slots and the keyring. Characters are told apart by their full name with surname.",
		"[Group Finder]: New region tags after a group's activity show where its leader plays from: the region on US realms, the realm language on EU realms.",
		"[Group Finder]: New filter expression, for example 'healer = 0 and score >= 2500 and hasbl'. Groups that don't match are dimmed in the Premade Groups list.",
		"[Notifications]: Toasts and the Raid Buff Check names now draw Cyrillic, Korean and Chinese letters instead of boxes, also with fonts that lack them.",
	},
}
