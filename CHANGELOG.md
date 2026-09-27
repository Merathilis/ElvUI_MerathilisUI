### Changes

-   [Fix]: Movement Alert - fixed a Lua error in combat ("attempt to compare a secret number value") when a tracked spell's cooldown is restricted.
-   [Fix]: ItemLevel/Pet Filter Tab: The item level on the Scrapping Machine and the pet filter tab in the Collections window could fail to appear, because both loaded through the same event handler.
-   [Fix]: Chat Edit Box: The chat type badge text was unreadable on bright chat colors like Whisper or Say, because the dark text kept a black outline.
-   [Fix]: Installer - the color preview of the UnitFrames step stuck to other steps, and the step buttons cut off longer labels. Closing the installer no longer leaves MerathilisUI changes behind for the next plugin installer.
-   [Fix]: Core: Fixed possible Lua errors in combat ("secret value") in color comparisons, color gradients and name abbreviations.
-   [Fix]: Loot Spec Manager/Copy Transmog: The info tooltips are colored again.
-   [Fix]: ElvUI AuraBars: MerathilisUI no longer replaces ElvUI's name abbreviation, so the aura bars abbreviate spell names the ElvUI way again.
-   [New]: UnitFrames/NamePlates: New Faction Indicator - shows the faction crest of players from the opposing faction on the Target, Focus and Arena frames (Target of Target and Focus Target optional) and on the NamePlates. Style, size and position can be set per frame.
-   [New]: Tracker: New module - a Battle Res tracker shows the shared battle res charges of your group and the time until the next charge during Mythic+ keys and raid boss encounters, as an icon or as a compact text line. A Bloodlust tracker shows your Sated lockout, the active lust and optionally when a lust is ready again.
-   [New]: Installer - new Modules step after UnitFrames, pick which MerathilisUI modules you want to use, applied on the reload at the end.
-   [Improvement]: Login Logo: The logo no longer shows up while in combat or in an instance, only after the installer has been completed, and it moves more smoothly.
-   [Improvement]: Information: New buttons for the MerathilisUI website on the options start page and in the Information tab. Support & Downloads now also links the MerathilisUI Discord, the Tukui links have their own section.
-   [Improvement]: Installer - the final step now points to the MerathilisUI website, with a Website button next to Discord.
-   [Improvement]: Core: Removed a lot of unused internal functions and an unused interrupt check that ran on every spec, level and zone change.
