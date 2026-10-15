local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[742] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"[Armory]: The gray background bars of ElvUI's character skin showed up again behind the item level and the stats.",
		"[Bags]: Shift+Right-click on an item with sockets now opens the socketing window, like in Blizzard's and ElvUI's bags.",
		"[NamePlates]: Nameplates that only show a widget (e.g. delve companions like Valeera, objects with a progress bar) no longer show a leftover name, level and health text.",
	},
	NEW = {
		"[Chat]: Own Copy Chat window - opens at the newest lines with everything selected, can be moved and resized, keeps or strips the chat colors and shows raid icons as {star} etc. Used by the sidebar copy button and ElvUI's copy button on each chat.",
		"[NamePlates]: Target Emphasis - while you have a target, the other nameplates fade and get a dark shade over their health bar, and a new target pops up for a moment. ElvUI's border glow on the target can be made wider, fades in and can pulse. The target's nameplate is drawn above the nameplates it overlaps. Casting units can keep their full alpha, everything can be limited to combat.",
	},
	IMPROVEMENTS = {
		"[Chat]: The M+ Portals flyout of the Chat Sidebar has a direction option (automatic, up, down, left, right).",
		"[General]: The Spec Bar, Interrupt Ready, Bloodlust tracker and Movement Alert no longer refresh when a group member changes their specialization, only on your own.",
		"[NamePlates]: The Castbar Shield now sits on the castbar itself instead of half over the castbar icon.",
	},
}
