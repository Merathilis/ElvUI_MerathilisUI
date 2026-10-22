local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[743] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"[Armory]: Gems taken from the mailbox now show up in the socket panel right away - the gem list is read fresh on every open and also covers the reagent bag.",
		"[Chat]: The tab underline now has the same thickness on every tab - it was cut to a single pixel on tabs in the dock's scroll area and blurred on others.",
	},
	NEW = {
		"[Movement Alert]: The bars can be attached above or below the player, target or focus unit frame and take over its width.",
		"[Misc]: Train All - a button at the trainer learns everything available you can afford in one click, new professions excluded.",
		"[Misc]: Queue Timer - a bar below the dungeon and battleground invite counts down the time left to accept, and takes the place of BigWigs' own dungeon timer.",
		"[Armory]: Stat Picker - a cog button on the character stats opens an edit mode: click a stat to show or hide it, drag it to change the order.",
		"[UnitFrames]: Ping Icon - pings placed on a unit (attack, warning, on my way, assist) show up on its unitframe, for the player, target, focus, pet, party, raid, tank, assist and arena frames, until ElvUI ships its own version.",
	},
	IMPROVEMENTS = {
		"[Notification]: Rare notifications now play a softer chime instead of the raid warning sound.",
		"[Notification]: New toast design in the style of the options cards - accent strip, the text block sits next to the icon and the height follows the text, a bar shows the time left, and on hover the close button and a click hint appear.",
	},
}
