local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[736] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"Bags: Categorized Bags - splitting stacks works again: Shift+click splits like in Blizzard's bags (links in chat only while a chat box is open), the split-off part is put into a free slot right away, and a split item isn't merged back into one slot until the bags close.",
		"Maps: Minimap Buttons - the Great Vault button stops pulsing as soon as the reward is claimed instead of only after opening the vault again.",
		"Bags: Categorized Bags - right-clicking a piece of gear equips it again when you already wear another copy of the same item (a different upgrade level, a second ring or trinket). Right-click now acts on the bag slot itself instead of looking the item up by name, which also makes selling at a merchant and depositing at the bank behave exactly like Blizzard's bags.",
	},
	NEW = {
		"Chat: New Chat Sidebar - a slim icon bar inside (or next to) the left or right chat panel with online friends/guild counters, durability, copy chat, M+ portals, chat channels, settings and a scroll-to-bottom button that lights up while the chat is scrolled up. Its copy button replaces ElvUI's (right-click opens the chat menu), its channel button takes over Blizzard's voice buttons on the chat panel - it lights up while a voice channel is active, turns into a crossed out microphone while you are muted or deafened and toggles the microphone (right-click) or the speakers (middle-click) - and the icons can be reordered with Shift + drag.",
		"Chat: Chat panels can be resized by dragging the grip that shows in their corner while hovering them (new \"Lock Chat Size\" option to hide it).",
		"Chat: The active combat log filter is shown in your class color, the others are dimmed.",
		"Chat: The chat edit box can get a MerathilisUI style: backdrop with stripes and its own opacity, a small bar in the chat type's color instead of a colored border, the channel prefix as a colored badge, a fade-in when it opens and a class colored glow while it is open. ElvUI's edit box position can be set right there too, and the \"inside\" positions leave room for the Chat Sidebar.",
		"Chat: The active chat tab gets an underline in your class color, like the tabs of the MerathilisUI options.",
		"Maps: New Location Panel - shows the current zone in a panel above the Minimap (click opens the World Map, the tooltip lists zone, subzone and PvP status) with your coordinates left and right of the zone text. It replaces ElvUI's Minimap Cluster, which the installer now disables together with its clock, and the old Minimap Coordinates module, which has been removed.",
	},
	IMPROVEMENTS = {
		"Maps: Minimap Buttons - the M+ Portals flyout is now shared with the Chat Sidebar.",
		"Maps: Minimap Buttons - new Addon Compartment button in the Elements bar, it opens Blizzard's addon list and replaces the counter on the Minimap.",
		"Bags: Categorized Bags - the Bank window has its own Sort button, sorting whichever bank it shows (character or Warband) and asking first like Blizzard's bank does.",
		"Bags: Categorized Bags - the Stack button now really stacks (merges partial stacks without re-sorting) instead of sorting again; Shift-click at the bank tops up matching stacks in the bank, and the Bank window got a Stack button that does the same towards your bags.",
		"Options: Option groups on the MerathilisUI pages stand out more clearly - a larger title with a small accent bar in front of it, a slightly lighter box and a small shadow behind it.",
	},
}
