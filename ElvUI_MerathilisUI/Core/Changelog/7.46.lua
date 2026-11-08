local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[746] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"[Installer]: The combat text font and the time and count fonts of buffs and debuffs now really use GothamNarrow-Black. Before, they used a font name that does not exist and fell back to ElvUI's default font.",
		"[Installer]: Tooltips on cards, buttons and switches no longer show up behind the installer window.",
		"[Installer]: The nameplate layout now sets Expressway on every nameplate font (name, level, power text, castbar, quest icon, auras). Some of them used a font name that does not exist and fell back to ElvUI's default font.",
		"[Bags]: On WoW Forever the bank window now shows all nine bank slots (the base bank and eight bank bags) with the bag's own name and icon. The warband bank views, the warband gold, the deposit button and the tab settings on right-click are gone there, since WoW Forever has no warband bank.",
	},
	NEW = {
		'[Tags]: New [name:MER:gradient:full] tag. It works like [name:MER:gradient], but on WoW Forever it shows the first name and the surname. On Retail it shows the name only. Your own name follows Blizzard\'s "My Surname" option.',
	},
	IMPROVEMENTS = {
		"[Installer]: The count on nameplate quest icons now sits as a small badge in the bottom right corner of the icon. Before, it was next to the icon and covered the next quest icon when a unit belonged to more than one quest.",
		"[Quick Grid]: On WoW Forever a custom slot can keep a lower spell rank. Drag that rank from the spellbook into the slot, and the slot shows its rank in the name. Other spell slots still cast the highest rank you know.",
	},
}
