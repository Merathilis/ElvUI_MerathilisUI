### Changes

-   [Fix]: Bags: Categorized Bags - fixed a taint error ("tried to call the protected function 'UpgradeItem()'") when upgrading an item at an upgrade NPC.
-   [Fix]: Misc: fixed the Guild MOTD popup not closing on Escape.
-   [Fix]: Armory: fixed the character sheet tainting Blizzard's paperdoll code, which could cause "Interface action failed because of an AddOn" when opening the character frame in combat.
-   [Improvement]: Mail/Loot: replaced the deprecated dropdown API in the send-mail template list and the Loot Spec Manager with Blizzard's current menu system, avoiding a known source of taint.
-   [Improvement]: General: removed leftover code paths for Classic clients, since MerathilisUI is Retail only.
