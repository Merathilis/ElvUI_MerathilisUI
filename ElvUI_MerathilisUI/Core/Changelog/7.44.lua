local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[744] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"[Compatibility Check]: On WoW Forever, \"Apply\" no longer gets blocked by the game (\"tried to call the protected function C_UI_Reload()\") and reloads the UI again.",
		"[Misc]: The random hearthstone of the portal menu no longer picks the Draenic Hologem on characters that can't use it.",
		"[Misc]: The portal menu no longer shows the global cooldown on its portals and hearthstones after every cast.",
		"[Tracker]: The Visibility option of the Battle Res tracker is a working dropdown again.",
	},
	NEW = {
		"[Bags]: Auto Deposit/Withdraw Gold - opening the bank moves gold between the character and the warband bank until the character carries the amount you set. Applies to all characters of the account. Off by default.",
		"[Nameplates]: Color Casting Enemies - enemy NPCs keep a health bar color after their first cast, one for interruptible and one for non-interruptible casts, so casters stay visible for the whole pull. Off by default.",
	},
	IMPROVEMENTS = {
		"[Maps]: The calendar button of the Minimap Buttons bar pulses Blizzard's invite notice while calendar invites are pending, like the Blizzard button it replaces. Clicking it dismisses the notice until the next invite.",
		"[Bags]: The bind search also knows BoA, Soulbound and Warbound, takes item levels (bop=300, boe>=280, wue 290-300) and combines terms with and, or, not and parentheses.",
		"[Misc]: The portal menu has a row for class and race teleports (Dreamwalk, Death Gate, Hall of the Guardian, Zen Pilgrimage, Rootwalking) and the Admiral's Compass, shown while you know or carry them.",
	},
}
