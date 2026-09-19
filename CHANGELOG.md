### Changes

-   [Fix]: Bags: Categorized Bags - fixed a taint error ("tried to call the protected function 'UpgradeItem()'") when upgrading an item at an upgrade NPC.
-   [Fix]: Misc: fixed the Guild MOTD popup not closing on Escape.
-   [Improvement]: Mail/Loot: replaced the deprecated dropdown API in the send-mail template list and the Loot Spec Manager with Blizzard's current menu system, avoiding a known source of taint.
