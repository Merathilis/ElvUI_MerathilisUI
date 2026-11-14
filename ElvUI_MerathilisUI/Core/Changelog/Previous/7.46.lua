local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[746] = {
	RELEASE_DATE = "14.11.2026",
	FIXES = {
		"[Installer]: The combat text font and the time and count fonts of buffs and debuffs now really use GothamNarrow-Black. Before, they used a font name that does not exist and fell back to ElvUI's default font.",
		"[Installer]: Tooltips on cards, buttons and switches no longer show up behind the installer window.",
		"[Installer]: The nameplate layout now sets Expressway on every nameplate font (name, level, power text, castbar, quest icon, auras). Some of them used a font name that does not exist and fell back to ElvUI's default font.",
		"[Bags]: On WoW Forever the bank window now shows all nine bank slots (the base bank and eight bank bags) with the bag's own name and icon. The warband bank views, the warband gold, the deposit button and the tab settings on right-click are gone there, since WoW Forever has no warband bank.",
		"[Bags]: The categorized bags now stay completely off while ElvUI's bags are disabled, for example when another bag addon is used. Before, opening the bank still opened our bag and bank windows next to the other addon.",
		"[Bags]: On WoW Forever bank bags can be equipped and replaced again: drop a bag on a bank bag row in the sidebar (or click the row with the bag on the cursor) to put it into that slot, drag the row to take the bag out. Before, a new bag could only be put inside the bag already equipped.",
		"[Bags]: The offline bank now saves your bank at every banker. Some bankers open the bank in a different way and were missed before.",
		"[Bags]: Right-clicking an item while the auction house is open puts it into the sell tab again, like Blizzard's own bags do. Before, the item was used or equipped instead.",
		"[HoverCast]: A macro binding now picks up the macro's new text right away when you edit, rename or delete the macro. Before, the old text kept firing until the next reload or group change.",
		'[HoverCast]: When an account macro and a character macro share a name, the binding now uses the one you picked. Character macros are marked with "(C)" in the binding list.',
		'[HoverCast]: On WoW Forever the Dispels binding now casts one dispel per class (Priest: Dispel Magic, Druid: Remove Curse, Shaman: Cure Poison) and no longer shows "Spell is not ready yet" on every press. Bind the other dispels as normal spell bindings.',
		"[HoverCast]: On WoW Forever a Druid's Dynamic Rez now casts Revive out of combat and keeps Rebirth for combat.",
		"[HoverCast]: Shift, Ctrl or Alt + click on a unit frame works again when left-click is bound to Target or right-click to Menu. Before, a modified click without its own binding did nothing.",
		"[HoverCast]: A modified click on a party target or party pet frame now targets that unit, or opens its menu, instead of the party member. In a vehicle it now targets the vehicle like a plain click does.",
		"[Minimap Buttons]: A second click on the Tracking button or the Addons button now closes its menu. Before, the menu closed and opened again right away.",
	},
	NEW = {
		"[Group Finder]: New option Group Notes (on by default). The note of a group now shows in its row in the Premade Groups list, after the play style. Blizzard only shows it in the tooltip.",
		"[Skins]: New skin for QIM (Quick Instant Messenger). It builds on QIM's Flat appearance, so pick Flat in QIM's options under Appearance. Windows, menus, buttons and input boxes then use the MerathilisUI look, and QIM's color theme no longer matters. The message bubbles keep the colors you set in QIM.",
		"[Minimap Buttons]: New option Other Characters' Hearthstones (off by default). The tooltip of the hearthstone button in the M+ Portals flyout lists your other characters, where each one is bound and when its hearthstone is ready again. A character shows up once it was logged in with the option on.",
		'[Tags]: New [name:MER:gradient:full] tag. It works like [name:MER:gradient], but on WoW Forever it shows the first name and the surname. On Retail it shows the name only. Your own name follows Blizzard\'s "My Surname" option.',
		"[Unlock Mode]: New option Auto Hide Toolbar (off by default). The toolbar fades out until the cursor reaches its place. It stays hidden while you drag a mover or while a mover is under the cursor, so movers below it can be reached.",
	},
	IMPROVEMENTS = {
		"[Installer]: The nameplate layout now shows friendly players as a name only, without the health bar, and the name is class colored.",
		"[Installer]: The count on nameplate quest icons now sits as a small badge in the bottom right corner of the icon. Before, it was next to the icon and covered the next quest icon when a unit belonged to more than one quest.",
		"[Quick Grid]: On WoW Forever a custom slot can keep a lower spell rank. Drag that rank from the spellbook into the slot, and the slot shows its rank in the name. Other spell slots still cast the highest rank you know.",
	},
}
