local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[738] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"[AFK]: Leaving the AFK screen stops its logout countdown again, before every AFK left a timer running until logout.",
		"[Bags]: Switching to a profile with the categorized bags turned off (or on) applies right away, before the bags stayed as they were until a reload.",
		"[Bags]: The equipment set icon in the bags follows a profile switch right away.",
		"[Buff Reminder]: Turning the Buff Reminder on in the options or by a profile switch works right away, even when it was turned off at login.",
		"[Cursor]: The GCD and cast rings work again after turning the Cursor module off and on or switching profiles, before they stayed empty until a reload.",
		"[DataTexts]: The Durability/Ilevel datatext follows a changed value color right away and updates the item level after a gear change.",
		"[Item Level]: Turning the item level on, also by a profile switch, works without a reload.",
		"[Loot Spec Manager]: Turning it off now really stops the automatic loot spec changes and hides the Encounter Journal button, without a reload. A profile switch uses the settings of the new profile.",
		"[Mail]: Open Selected no longer opens the wrong mails once a mail without text is removed after it was emptied.",
		'[Name Hover]: Hovering a quest mob no longer throws a Lua error ("secret value") when its tooltip lines are restricted, e.g. in Mythic+.',
		"[Name Hover]: The Mythic+ forces text no longer gets cut off with the Number or Both format.",
		"[Raid Info Frame]: Turning it on in the options no longer throws Lua errors from the size and spacing options, and turning it on or off, also by a profile switch, works without a reload. Hide In Combat applies right away.",
		"[Status Report]: Opening it no longer throws a Lua error when Details is enabled but not loaded.",
		'[Trade Tabs]: Opening a profession or the trade window in combat no longer causes an "action blocked" message.',
		"[Wowhead Links]: The link popup no longer clashes with other UI packs, and Ctrl+Click on achievements also works when the achievement window was loaded early.",
	},
	NEW = {
		"[DataTexts]: The options of the Durability/Ilevel datatext are back: icons, white text and icon, the repair mount for the right click and colored durability thresholds.",
		"[NamePlates]: Animated target arrows next to your target's nameplate (slide in, bounce or both, in class color by default). They replace the arrows of ElvUI's target indicator while enabled.",
		"[NamePlates]: The mouseover highlight on the health bar can be restyled with a texture, class or custom color and a short fade in.",
		"[NamePlates]: Execute Line: a line on the health bar of hostile nameplates at a health percent of your choice (20% by default), so you see when a unit gets into your execute range. Comes with a soft glow, small markers and a tinted execute range, each can be turned off, plus an optional pulse. Off by default.",
		"[NamePlates]: Interrupt Ready on the castbars of hostile nameplates: while your interrupt is on cooldown the bar gets its own color, and the part of the cast after your interrupt is ready again is marked with a second color and a thin line.",
		"[Skins]: New skin for Permoks Account Manager: window borders, the category and page buttons and the close button in the MerathilisUI style.",
		"[UnitFrames]: Execute Line on the health bar of the target, focus, boss and arena frames, the same line as on the nameplates, also off by default.",
		"[UnitFrames]: Interrupt Ready on the castbars of the target, focus, boss and arena frames, the same indicator as on the nameplates.",
	},
	IMPROVEMENTS = {
		"[Core]: Errors in features that load with a Blizzard addon (e.g. the Auction House or the Encounter Journal) are now reported instead of only being logged at debug level.",
		"[Theme]: The castbar colors now include Interrupt on Cooldown and Interrupt Ready Soon, used by the new Interrupt Ready indicator and following the gradient mode.",
	},
}
