local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[742] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"[Armory]: The gray background bars of ElvUI's character skin showed up again behind the item level and the stats.",
		"[Bags]: Shift+Right-click on an item with sockets now opens the socketing window, like in Blizzard's and ElvUI's bags.",
		"[Buff Reminder]: An enchanted off-hand no longer hides the reminder for an unenchanted main-hand weapon.",
		"[Buff Reminder]: The food reminder now also finds the feasts (Feast of Knowledge, Silvermoon Parade, Harandar Celebration), Bloodthistle-wrapped Cutlets and all Hearty foods in your bags.",
		"[HoverCast]: A binding whose macro grew past WoW's 255 character limit (e.g. with Smart Rez) lost its own action. The macro is now shortened step by step instead, the action always stays.",
		'[Loadout Manager]: No more false "item(s) missing" messages while the last items of a gear set are still being equipped.',
		"[Loadout Manager]: A talent loadout no longer stays pending when combat starts before its load began, and a loadout that only partly applied is now reported.",
		"[NamePlates]: Nameplates that only show a widget (e.g. delve companions like Valeera, objects with a progress bar) no longer show a leftover name, level and health text.",
	},
	NEW = {
		"[Bags]: Quick Actions - an optional title bar button that highlights the items you can disenchant or pick, a click on one casts the spell on it.",
		"[Bags]: Typing bop, boe or wue into the bag or bank search filters by bind type.",
		"[Bags]: Option to open and close the bags together with the character window.",
		"[Chat]: Own Copy Chat window - opens at the newest lines with everything selected, can be moved and resized, keeps or strips the chat colors and shows raid icons as {star} etc. Used by the sidebar copy button and ElvUI's copy button on each chat.",
		"[HoverCast]: Clear Stuck Spell Targeting (on by default) - a spell still waiting for a target no longer swallows the next press.",
		"[NamePlates]: Target Emphasis - while you have a target, the other nameplates fade and get a dark shade over their health bar, and a new target pops up for a moment. ElvUI's border glow on the target can be made wider, fades in and can pulse. The target's nameplate is drawn above the nameplates it overlaps. Casting units can keep their full alpha, everything can be limited to combat.",
	},
	IMPROVEMENTS = {
		"[Chat]: The M+ Portals flyout of the Chat Sidebar has a direction option (automatic, up, down, left, right).",
		"[General]: The Spec Bar, Interrupt Ready, Bloodlust tracker and Movement Alert no longer refresh when a group member changes their specialization, only on your own.",
		"[Loadout Manager]: Automatic talent swaps now wait while a talent change is being applied or the talent window has unsaved changes, instead of failing or discarding them.",
		"[NamePlates]: The Castbar Shield now sits on the castbar itself instead of half over the castbar icon.",
	},
}
