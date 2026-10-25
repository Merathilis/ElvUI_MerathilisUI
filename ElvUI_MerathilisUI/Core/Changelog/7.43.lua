local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[743] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"[Armory]: Gems taken from the mailbox now show up in the socket panel right away - the gem list is read fresh on every open and also covers the reagent bag.",
		"[Chat]: The tab underline now has the same thickness on every tab - it was cut to a single pixel on tabs in the dock's scroll area and blurred on others.",
		"[HoverCast]: Pressing a key on the binding page while combat starts no longer triggers a blocked action error.",
	},
	NEW = {
		"[Armory]: Stat Picker - a cog button on the character stats opens an edit mode: click a stat to show or hide it, drag it to change the order. A longer list scrolls inside the stats pane.",
		"[Armory]: Upgrade Track - the first letter of an item's upgrade track (Explorer to Myth) shows in the corner of its icon in the track's color, and the upgrade bar takes that color as well. Both can be turned off under Slot Item Level.",
		"[Buff Reminder]: Missing Buffs From Group - optionally also shows the raid buffs a groupmate provides while you are missing them, as an info icon that clicks go through.",
		"[Buff Reminder]: Talent Reminders - pick a talent and the instances you want it in, and an icon reminds you inside them while it is not chosen. Optionally it also reminds you to remove it again in the current season's other instances or in all of them. Saved per specialization, arenas and battlegrounds included.",
		"[Chat]: Chat Bubbles - ElvUI's chat bubbles get the MerathilisUI style and a shadow on a border that is pixel perfect at any UI scale. The speaker's name can be shown as a class color gradient, positioned freely and also appears on party, raid and instance chat bubbles. Optionally the bubbles are turned off inside instances, where they can't be styled.",
		"[Misc]: Train All - a button at the trainer learns everything available you can afford in one click, new professions excluded.",
		"[Misc]: Queue Timer - a bar below the dungeon and battleground invite counts down the time left to accept, and takes the place of BigWigs' own dungeon timer.",
		"[Movement Alert]: The bars can be attached above or below the player, target or focus unit frame and take over its width.",
		"[Tooltip]: Upgrade Track - the upgrade level line in item tooltips takes the color of the upgrade track (Explorer to Myth), and items that are not fully upgraded show the item level they can still reach.",
		"[UnitFrames]: Ping Icon - pings placed on a unit (attack, warning, on my way, assist) show up on its unitframe, for the player, target, focus, pet, party, raid, tank, assist and arena frames, until ElvUI ships its own version.",
	},
	IMPROVEMENTS = {
		"[Armory]: The item slots no longer fade in row by row when the character frame opens, they show right away.",
		"[Notification]: Rare notifications now play a softer chime instead of the raid warning sound.",
		"[Notification]: New toast design in the style of the options cards - accent strip, the text block sits next to the icon and the height follows the text, a bar shows the time left, and on hover the close button and a click hint appear.",
		"[Skins]: KeystoneLoot skin updated for the reworked addon - the custom item panel and the Mythic+ group notification are skinned now, item icons get a quality colored border instead of a white one, and the side panels have a shadow.",
		"[Theme]: Fewer unit API calls per health update for the gradient health colors.",
		"[Unlock Mode]: Shift+Alt-click picks the anchor points by hand - nine points on the selected mover, then nine on the target, and the two are put on top of each other. Plain Alt-click still takes the sides from where the mover sits.",
		"[Unlock Mode]: The toolbar stands out from the movers - nearly opaque background, a border, glow and top strip in your accent color.",
		"[Unlock Mode]: A filter box in the toolbar shows only the movers whose name contains every typed word.",
		"[Unlock Mode]: Ctrl+mouse wheel over movers lying on top of each other brings the next one to the top and selects it.",
		"[Unlock Mode]: Option pages of modules with a mover have a Show Mover button, which opens the mover mode with just that mover selected.",
	},
}
