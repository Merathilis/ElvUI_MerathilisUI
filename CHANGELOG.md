### Changes

-   [Fix]: AFK: Leaving the AFK screen stops its logout countdown again, before every AFK left a timer running until logout.
-   [Fix]: Bags: Switching to a profile with the categorized bags turned off (or on) applies right away, before the bags stayed as they were until a reload.
-   [Fix]: Bags: The equipment set icon in the bags follows a profile switch right away.
-   [Fix]: Buff Reminder: Turning the Buff Reminder on in the options or by a profile switch works right away, even when it was turned off at login.
-   [Fix]: Cursor: The GCD and cast rings work again after turning the Cursor module off and on or switching profiles, before they stayed empty until a reload.
-   [Fix]: DataTexts: The Durability/Ilevel datatext follows a changed value color right away and updates the item level after a gear change.
-   [Fix]: Item Level: Turning the item level on, also by a profile switch, works without a reload.
-   [Fix]: Loot Spec Manager: Turning it off now really stops the automatic loot spec changes and hides the Encounter Journal button, without a reload. A profile switch uses the settings of the new profile.
-   [Fix]: Mail: Open Selected no longer opens the wrong mails once a mail without text is removed after it was emptied.
-   [Fix]: Raid Info Frame: Turning it on in the options no longer throws Lua errors from the size and spacing options, and turning it on or off, also by a profile switch, works without a reload. Hide In Combat applies right away.
-   [Fix]: Status Report: Opening it no longer throws a Lua error when Details is enabled but not loaded.
-   [Fix]: Trade Tabs: Opening a profession or the trade window in combat no longer causes an "action blocked" message.
-   [Fix]: Wowhead Links: The link popup no longer clashes with other UI packs, and Ctrl+Click on achievements also works when the achievement window was loaded early.
-   [New]: DataTexts: The options of the Durability/Ilevel datatext are back: icons, white text and icon, the repair mount for the right click and colored durability thresholds.
-   [New]: Skins: New skin for Permoks Account Manager: window borders, the category and page buttons and the close button in the MerathilisUI style.
-   [Improvement]: Core: Errors in features that load with a Blizzard addon (e.g. the Auction House or the Encounter Journal) are now reported instead of only being logged at debug level.
