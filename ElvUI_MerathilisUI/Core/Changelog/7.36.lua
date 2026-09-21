local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[736] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"Bags: Categorized Bags - splitting stacks works again: Shift+click splits like in Blizzard's bags (links in chat only while a chat box is open), the split-off part is put into a free slot right away, and a split item isn't merged back into one slot until the bags close.",
	},
	NEW = {},
	IMPROVEMENTS = {
		"Bags: Categorized Bags - the Bank window has its own Sort button, sorting whichever bank it shows (character or Warband) and asking first like Blizzard's bank does.",
		"Bags: Categorized Bags - the Stack button now really stacks (merges partial stacks without re-sorting) instead of sorting again; Shift-click at the bank tops up matching stacks in the bank, and the Bank window got a Stack button that does the same towards your bags.",
	},
}
