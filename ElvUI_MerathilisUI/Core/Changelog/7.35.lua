local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[735] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"Bags: Categorized Bags - fixed the Recent Items clear button sometimes not removing the items until the bags were reopened.",
		"Bags: Categorized Bags - the sort spinner now shows on top of the items instead of behind them.",
	},
	NEW = {},
	IMPROVEMENTS = {
		"Bags: Categorized Bags - items now dim while sorting, and hovering a bag in the bag bar dims everything outside that bag, like ElvUI's own bags.",
		"Bags: Categorized Bags - while an item is on the cursor, the empty slots at the end of each category light up to show where it can be dropped to assign it.",
		"Bags: Categorized Bags - pinned items show a pin marker in their normal category too, and newly picked-up items get a NEW badge in addition to the glow (all three toggleable under Effects).",
		"Bags: Categorized Bags - sub-headers now show the expansion logo or equipment set icon, with a slimmer background that fades out to the right (toggleable under Effects).",
		"Bags: Categorized Bags - the sidebar edge got a soft class-colored line and a subtle shadow towards the items.",
		"Bags: Categorized Bags - the gold tooltip now shows class icons for your characters plus icons for the total and the Warband Bank.",
		"Bags: Categorized Bags - \"Assign to Category\" opened from a bank slot now notes that the assignment takes effect once the item is in your bags.",
		"Bags: Categorized Bags - the collapsed sidebar is a bit wider, its collapse arrow sits centered over the icons and its scrollbar stays inside the sidebar instead of hanging over the edge.",
		"Bags: Categorized Bags - right-clicking a category now offers \"Create Group With\" and \"Add to Group\", so category groups are no longer limited to the built-in \"Equipment\" one.",
		"Bags: Categorized Bags - Recent Items now tracks item IDs instead of bag slots, so sorting no longer moves the marks onto other items; the list is capped (default 20, adjustable) and can optionally empty itself when the bags close.",
		"Bags: Categorized Bags - hovering a slot clears its new-item glow and NEW badge, like Blizzard's own bags; the item stays in Recent Items.",
	},
}
