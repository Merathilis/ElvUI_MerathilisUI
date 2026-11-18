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
		"[Bags]: Merge Duplicate Stacks now also merges stacks of a crafted item that were made by different players.",
		"[Buff Reminder]: The reminders now hide or show right away when you enter or leave a city or inn, instead of waiting for the next buff or zone change.",
		"[Buff Reminder]: On WoW Forever the raid buffs now know every rank: a higher rank no longer counts as missing, and a click casts your highest known rank on the groupmate who lacks it. Divine Spirit was added. The Retail-only consumables are hidden there.",
		"[Tracker]: The Bloodlust tracker also finds your own Bloodlust, Heroism, Time Warp or Fury of the Aspects when the game reports it only as a spellbook entry, instead of falling back to the faction icon.",
	},
	NEW = {
		"[Bags]: New Items Only option for Recent Items: looting more of a stack you already carry no longer adds it to the list. Gear and items from the mailbox or a trade always appear. Off by default.",
		"[Bags]: Right-clicking a category in the bag sidebar now offers Rename, Change Icon and Delete for the built-in categories too. Delete turns a built-in category off, its items move to the next matching category, and the new Categories list in the options turns it on again. Reset brings back the original name and icon.",
		"[Bags]: Right-clicking a view in the bag or bank sidebar (All Items, OneBag, MultiBag, the bank views, Pinned Items or Recent Items) opens a list to pick which of them the sidebar shows. Hiding the open view switches to the one the window opens on.",
		"[Bags]: Anchor to Nearest Corner option: the bag and the bank window each hold the screen corner nearest to them, so a window near the bottom right grows up and to the left when it gets more items, instead of running off the screen. The corner is picked again when you move a window. On by default.",
		"[Buff Reminder]: Class buffs on WoW Forever: Mage armors, Demon Armor, Inner Fire, Shadowform, Lightning Shield, Hunter aspects and Trueshot Aura, Paladin blessings, auras and Righteous Fury, and Thorns. Righteous Fury and Thorns are off by default.",
		"[Loadout Manager]: Now available on WoW Forever. The talent part switches between your Primary and Secondary dual spec, and gear can be assigned per dual spec. Switching dual spec yourself equips the gear assigned for it.",
		"[Minimap Buttons]: Show as List option for the addon button panel: one column with each addon's name next to its icon, and the whole row can be hovered and clicked. Off by default.",
	},
	IMPROVEMENTS = {
		"[Locales]: The Korean translation is nearly complete, thanks to haslram.",
	},
}
