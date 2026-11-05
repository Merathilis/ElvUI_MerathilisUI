local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[744] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"[Chat]: No more error on login when ElvUI positions the chats before the chat settings of MerathilisUI were loaded.",
		"[General]: A fresh install no longer loses default settings (e.g. the gradient colors) to the database migrations of old versions.",
		"[Misc]: The random hearthstone of the portal menu no longer picks the Draenic Hologem on characters that can't use it.",
		"[Misc]: The portal menu no longer shows the global cooldown on its portals and hearthstones after every cast.",
		"[Tracker]: The Visibility option of the Battle Res tracker is a working dropdown again.",
	},
	NEW = {
		"[General]: WoW Forever support - MerathilisUI now also loads on WoW Forever. Modules that rely on Retail-only features stay off there and their options are hidden: Armory, Spec Bar, Loot Spec Manager, Singing Sockets, Rounded Corners, Enemy Forces, the Great Vault, Call to Arms and Quick Join notifications and the Mythic+ and delve parts of the game menu, minimap buttons and chat sidebar.",
		"[Bags]: Auto Deposit/Withdraw Gold - opening the bank moves gold between the character and the warband bank until the character carries the amount you set. Applies to all characters of the account. Off by default.",
		"[Nameplates]: Color Casting Enemies - enemy NPCs keep a health bar color after their first cast, one for interruptible and one for non-interruptible casts, so casters stay visible for the whole pull. Off by default.",
	},
	IMPROVEMENTS = {
		"[Maps]: The calendar button of the Minimap Buttons bar pulses Blizzard's invite notice while calendar invites are pending, like the Blizzard button it replaces. Clicking it dismisses the notice until the next invite.",
		"[Bags]: The bind search also knows BoA, Soulbound and Warbound, takes item levels (bop=300, boe>=280, wue 290-300) and combines terms with and, or, not and parentheses.",
		"[Misc]: The portal menu has a row for class and race teleports (Dreamwalk, Death Gate, Hall of the Guardian, Zen Pilgrimage, Rootwalking) and the Admiral's Compass, shown while you know or carry them.",
	},
}
