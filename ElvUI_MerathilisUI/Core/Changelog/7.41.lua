local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[741] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"[Bags]: With Merge Duplicate Stacks on, items no longer slip under the wrong expansion or equipment set sub-header next to a merged stack.",
	},
	NEW = {
		"[Bags]: Categorized Bags - new List display: one row per item with sortable columns (name, item level, required level, type, bind type, count, sell price). Click a column header to sort, drag it to move it, right-click it to choose the columns.",
		"[Bags]: Categorized Bags - new Compact display: the categories are packed side by side as blocks, so far less space is wasted on short categories. While an item is on the cursor, the blocks it can be assigned to light up as drop targets.",
		"[Bags]: Categorized Bags - the display (Grid, List or Compact) can be switched for the bag and the bank window separately, from the new title bar button or the options.",
		"[Bags]: Categorized Bags - new Junk Marker (off by default): a Junk category for grey items and anything you mark, a title bar button to mark or unmark items with a click, and Sell Junk sells all of it at a vendor, optionally automatically. Items that can still be refunded are never sold.",
		"[Loadout Manager]: New module (off by default) that equips Equipment Manager gear sets and loads saved talent loadouts on its own when you enter content. Assign them per instance, per instance and difficulty, or per content type (Dungeon, Mythic+, Raid, Timewalking, Delve, Scenario, Arena, Battleground, Open World), for all specs or a single spec. Swaps due in combat wait until it ends, a DONT MOVE warning shows while talents change. /lm opens the options.",
		"[NamePlates]: Neutral Name Only - idle neutral NPCs only show their name, like the old ElvUI style filter. Targeted or in combat with you or your group, they get their full nameplate back. The name uses the gradient name tag.",
		"[UnitFrames]: New Portraits for the player and target frames, on by default: the unit's portrait cut to a shape (Drop, Circle or Square) and framed by a ring in its class or reaction color (or the Gradient Theme colors), with a soft shadow and the spell icon while the unit casts. Boss, elite and rare NPCs are marked with the dragon of the Blizzard target frame (in its own colors, the classification color or the portrait color), a badge or a ring in their classification color. Focus, target of target, pet, party, boss and arena can be turned on in the options. The installer and the presets set the ring to the gradient colors for the Gradient layout and to the class color for the Dark layout, the Minimal preset turns the portraits off. The mMediaTag profile now turns off mMediaTag's own portraits.",
	},
	IMPROVEMENTS = {
		"[VehicleBar]: New option Hide While Skyriding (off by default): the vehicle bar stays hidden while skyriding and ElvUI's action bar 1 shows the skyriding abilities instead.",
		"[Bags]: The options are split into an Equipment Manager and a Categorized Bags tab, so Categorized Bags gets the full window. The Equipment Manager settings are grouped into Position and Icon.",
		"[NamePlates]: The options are split into the tabs Indicators, Highlight, Castbar, Health Bar and Neutral Name Only instead of one long page.",
		"[Options]: More room on every options page: taller rows, more padding inside the option groups and a clear gap between them.",
		"[Options]: The options window now opens at a size that fits your screen instead of a fixed 1024x768. A window you resized yourself keeps its size, Reposition Window switches back to the new default.",
	},
}
