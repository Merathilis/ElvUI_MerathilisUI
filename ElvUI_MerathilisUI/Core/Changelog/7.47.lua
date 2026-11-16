local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[747] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"[Bags]: The categorized bags close again when combat starts, for example through WindTools' option to hide the bags when entering combat. With the fade effect on, the window started to fade out and then came back.",
		"[Bags]: Right-clicking an item while the merchant's buyback tab is open no longer sells it.",
		"[Bags]: Right-clicking an item that can still be refunded at a merchant now asks before it is returned, like Blizzard's own bags do. Before, it went back without a question.",
		"[Bags]: With the Warband bank in view, a right-click on a bag item now puts it into the Warband bank, and asks first when that would end the item's refund period.",
		"[Bags]: Ctrl or Alt + right-click no longer uses or equips the item. Ctrl + right-click opens the dressing room, like in Blizzard's own bags.",
		"[Bags]: Shift + right-click on a container opens it with auto loot switched around again, instead of doing nothing.",
		"[Bags]: Item cooldowns now show on the bag slots as soon as an item is used with the bags open, also on the other items that share its cooldown, like potions.",
		"[Bags]: On WoW Forever, quivers, ammo pouches and soul, herb or enchanting bags no longer count toward the free slots in the bag window's title.",
		"[Tracker]: The Bloodlust tracker also finds your own Bloodlust, Heroism, Time Warp or Fury of the Aspects when the game reports it only as a spellbook entry, instead of falling back to the faction icon.",
	},
	NEW = {
		"[Bags]: New Items Only option for Recent Items: looting more of a stack you already carry no longer adds it to the list. Gear and items from the mailbox or a trade always appear. Off by default.",
		"[Minimap Buttons]: Show as List option for the addon button panel: one column with each addon's name next to its icon, and the whole row can be hovered and clicked. Off by default.",
	},
	IMPROVEMENTS = {
		"[Locales]: The Korean translation is nearly complete, thanks to haslram.",
	},
}
