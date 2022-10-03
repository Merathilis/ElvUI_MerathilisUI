-- Spanish localization file for esMX
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "esMX")

-- Core
L["Enable"] = true
L[" is loaded. For any issues or suggestions, please visit "] = true
L["Font"] = true
L["Size"] = true
L["Width"] = true
L["Height"] = true
L["Alpha"] = true
L["Outline"] = true
L["X-Offset"] = true
L["Y-Offset"] = true
L["Icon Size"] = true
L["Font Outline"] = true

-- General Options
L["Plugin for |cffff7d0aElvUI|r by\nMerathilis."] = true
L["by Merathilis (|cFF00c0faEU-Shattrath|r)"] = true
L["AFK"] = "Away"
L["Enable/Disable the MUI AFK Screen. Disabled if BenikUI is loaded"] = true
L["Are you still there? ... Hello?"] = true
L["Logout Timer"] = true
L["SplashScreen"] = true
L["Enable/Disable the Splash Screen on Login."] = true
L["Options"] = true
L["Description"] = true
L["General"] = true
L["Modules"] = true
L["Media"] = true
L["MER_DESC"] = [=[|cffffffffMerathilis|r|cffff7d0aUI|r is an extension of ElvUI. It adds:

- a lot of new features
- a transparent overall look
- rewrote all existing ElvUI Skins
- my personal Layout

|cFF00c0faNote:|r It is compatible with most of other ElvUI plugins.
But if you install another Layout over mine, you must adjust it manually.

|cffff8000Newest additions are marked with: |r]=]

-- Core Options
L["Login Message"] = true
L["Enable/Disable the Login Message in Chat"] = true
L["Log Level"] = true
L["Only display log message that the level is higher than you choose."] = true
L["Set to 2 if you do not understand the meaning of log level."] = true
L["Open the changelog window."] = true

-- Bags
L["BANK_DESC"] = [=[If you have my Bags enabled the ElvUI Bags will be forced to be disabled! So if you want the ElvUI back, you need to disable my Bags first and then enable the ElvUI Bags again.]=]
L["Item Filter"] = true
L["Junk"] = true
L["Consumable"] = true
L["Ammo"] = true
L["Azerite"] = true
L["Equipments"] = true
L["EquipSets"] = true
L["Legendarys"] = true
L["Collection"] = true
L["Favorite"] = true
L["Goods"] = true
L["Quest"] = true
L["Anima"] = true
L["Relic"] = true
L["Collect Empty Slots"] = true
L["Special Bags Color"] = true
L["|nShow color for special bags:|n- Herb bag|n- Mining bag|n- Gem bag|n- Enchanted mageweave pouch"] = true
L["New Item Glow"] = true
L["Show ItemLevel"] = true
L["Pet Trash Currencies"] = true
L[
	"|nIn patch 9.1, you can buy 3 battle pets by using specific trash items. Keep this enabled, will sort these items into Collection Filter, and won't be sold by auto junk selling."
	] = true
L["ItemLevel Threshold"] = true
L["BagSort Mode"] = true
L[
	"|nIf you have empty slots after bag sort, please disable bags module, and turn off all bags filter in default ui containers."
	] = true
L["Forward"] = true
L["Backwards"] = true
L["Bags per Row"] = true
L["|nIf Bags ItemFilter enabled, change the bags per row for anchoring."] = true
L["Bank bags per Row"] = true
L["|nIf Bags ItemFilter enabled, change the bank bags per row for anchoring."] = true
L["Icon Size"] = true
L["Font Size"] = true
L["Bags Width"] = true
L["Bank Width"] = true
L["Bag Search Tip"] = "|nClick to search your bag items.|nYou can type in item names or item equip locations.|n'boe' for items that bind on equip and 'quest' for quest items.|n|nPress key ESC to clear editbox."
L["Auto Deposit Tip"] = "|nLeft click to deposit reagents, right click to switch auto deposit.|nIf the button border shown, the reagents from your bags would auto deposit once you open your BankFrame."
L["Bag Sort Disabled"] = "BagSort has been disabled in the Options."
L["Sort"] = true
L["FreeSlots"] = "Total free slots"
L["Split Mode Enabled"] = "|nClick to split stacked items in your bags.|nYou can change 'split count' for each click thru the editbox."
L["Quick Split"] = true
L["Favourite Mode"] = true
L["Favourite Mode Enabled"] = "|nYou can now star items.|nIf 'Bags ItemFilter' enabled, the item you starred will add to Preferences filter slots.|nThis is not available to trash."
L["Reset junklist warning"] = "Are you sure to wipe the custom junk list?"
L["Junk Mode Enabled"] = "|nClick to tag item as junk.|nIf 'Autosell Junk' enabled, these items would be sold as well.|nThe list is saved account-wide, and won't be in the export data.|nYou can hold CTRL+ALT and click to wipe the custom junk list."
L["Custom Junk Mode"] = "Custom Junk List"
L["Delete Mode Enabled"] = "|nYou can destroy container item by holding CTRL+ALT. The item can be heirlooms or its quality lower then rare (blue)."
L["Item Delete Mode"] = true
L["Azerite Armor"] = true
L["Equipement Set"] = true
L["Korthia Relic"] = true
L["StupidShiftKey"] = true
L["Equipment Set Overlay"] = true
L["Show the associated equipment sets for the items in your bags (or bank)."] = true

-- Chat
L["CHAT_AFK"] = "[AFK]"
L["CHAT_DND"] = "[DND]"
L["BACK"] = "Indietro"
L["|cFF00c0failvl|r: %d"] = true
L["|CFF1EFF00%s|r |CFFFF0000Sold.|r"] = true
L["Requires level: %d - %d"] = true
L["Requires level: %d - %d (%d)"] = true
L["(+%.1f Rested)"] = true
L["Unknown"] = true
L["Chat Item Level"] = true
L["Shows the slot and item level in the chat"] = true
L["Expand the chat"] = true
L["Chat Menu"] = true
L["Create a chat button to increase the chat size."] = true
L["Hide Player Brackets"] = true
L["Removes brackets around the person who posts a chat message."] = true
L["Hide Chat Side Panel"] = true
L["Removes the Chat SidePanel. |cffFF0000WARNING: If you disable this option you must adjust your Layout.|r"] = true
L["Chat Bar"] = true
L["Shows a ChatBar with different quick buttons."] = true
L["Hide Community Chat"] = true
L["Adds an overlay to the Community Chat. Useful for streamers."] = true
L["Chat Hidden. Click to show"] = true
L["Click to open Emoticon Frame"] = true
L["Emotes"] = true
L["Damage Meter Filter"] = true
L["Fade Chat"] = true
L["Auto hide timeout"] = true
L["Seconds before fading chat panel"] = true
L["Seperators"] = true
L["Orientation"] = true
L["Please use Blizzard Communities UI add the channel to your main chat frame first."] = true
L["Channel Name"] = true
L["Abbreviation"] = true
L["Auto Join"] = true
L["World"] = true
L["Channels"] = true
L["Block Shadow"] = true
L["Hide channels not exist."] = true
L["Only show chat bar when you mouse over it."] = true
L["Button"] = true
L["Item Level Links"] = true
L["Filter"] = true
L["Block"] = true
L["Custom Online Message"] = true
L["Chat Link"] = true
L["Add extra information on the link, so that you can get basic information but do not need to click"] = true
L["Additional Information"] = true
L["Level"] = "Livello"
L["Translate Item"] = true
L["Translate the name in item links into your language."] = true
L["Icon"] = true
L["Armor Category"] = true
L["Weapon Category"] = true
L["Filters some messages out of your chat, that some Spam AddOns use."] = true

-- Combat Alert
L["Combat Alert"] = true
L["Enable/Disable the combat message if you enter/leave the combat."] = true
L["Enter Combat"] = true
L["Leave Combat"] = true
L["Stay Duration"] = true
L["Custom Text"] = true
L["Custom Text (Enter)"] = true
L["Custom Text (Leave)"] = true
L["Color"] = true

-- Information
L["Information"] = true
L["Support & Downloads"] = true
L["Tukui"] = true
L["Github"] = true
L["CurseForge"] = true
L["Coding"] = true
L["Testing & Inspiration"] = true
L["Development Version"] = true
L["Here you can download the latest development version."] = true
L["Donations"] = true

-- Modules
L["Here you find the options for all the different |cffffffffMerathilis|r|cffff8000UI|r modules."] = true
L["Are you sure you want to reset %s module?"] = true
L["Reset All Modules"] = true
L["Reset all %s modules."] = true

-- GameMenu
L["GameMenu"] = true
L["Enable/Disable the MerathilisUI Style from the Blizzard GameMenu. (e.g. Pepe, Logo, Bars)"] = true

-- Extended Vendor
L["Extended Vendor"] = true
L["Extends the merchant page to show more items."] = true
L["Number of Pages"] = true
L["The number of pages shown in the merchant frame."] = true

-- FlightMode
L["FlightMode"] = true
L["Enhance the |cff00c0faBenikUI|r FlightMode.\nTo completely disable the FlightMode go into the |cff00c0faBenikUI|r Options."] = true
L["Exit FlightMode"] = true
L["Left Click to Request Stop"] = true

-- FlightPoint
L["Flight Point"] = true
L["Enable/Disable the MerathilisUI Flight Points on the FlightMap."] = true

-- Shadows
L["Shadows"] = true
L["Increase Size"] = true
L["Make shadow thicker."] = true

-- Mail
L["Mail"] = true
L["Alternate Character"] = true
L["Alt List"] = true
L["Delete"] = true
L["Favorites"] = true
L["Favorite List"] = true
L["Name"] = true
L["Realm"] = true
L["Add"] = true
L["Please set the name and realm first."] = true
L["Toggle Contacts"] = true
L["Online Friends"] = true
L["Add To Favorites"] = true
L["Remove From Favorites"] = true

-- MicroBar
L["Backdrop"] = true
L["Backdrop Spacing"] = true
L["The spacing between the backdrop and the buttons."] = true
L["Time Width"] = true
L["Time Height"] = true
L["The spacing between buttons."] = true
L["The size of the buttons."] = true
L["Slow Mode"] = true
L["Update the additional text every 10 seconds rather than every 1 second such that the used memory will be lower."] = true
L["Display"] = true
L["Fade Time"] = true
L["Tooltip Position"] = true
L["Mode"] = true
L["None"] = true
L["Class Color"] = true
L["Custom"] = true
L["Additional Text"] = true
L["Interval"] = true
L["The interval of updating."] = true
L["Home"] = true
L["Left Button"] = true
L["Right Button"] = true
L["Left Panel"] = true
L["Right Panel"] = true
L["Button #%d"] = true
L["Pet Journal"] = true
L["Show Pet Journal"] = true
L["Random Favorite Pet"] = true
L["Screenshot"] = true
L["Screenshot immediately"] = true
L["Screenshot after 2 secs"] = true
L["Toy Box"] = true
L["Collections"] = true
L["Show Collections"] = true
L["Random Favorite Mount"] = true
L["Decrease the volume"] = true
L["Increase the volume"] = true
L["Profession"] = true
L["Volume"] = true

-- Misc
L["Misc"] = true
L["Artifact Power"] = true
L["has appeared on the MiniMap!"] = true
L["Alt-click, to buy an stack"] = true
L["Announce"] = true
L["Skill gains"] = true
L[" members"] = true
L["Name Hover"] = true
L["Shows the Unit Name on the mouse."] = true
L["Undress"] = true
L["Flashing Cursor"] = true
L["Lights up the cursor to make it easier to see."] = true
L["Accept Quest"] = true
L["Placed Item"] = true
L["Stranger"] = true
L["Keystones"] = true
L["GUILD_MOTD_LABEL2"] = "Messaggio del giorno di gilda"
L["LFG Member Info"] = true
L["Shows role informations in your tooltip in the lfg frame."] = true
L["MISC_REPUTATION"] = "Reputation"
L["MISC_PARAGON"] = "Paragon"
L["MISC_PARAGON_REPUTATION"] = "Paragon Reputation"
L["MISC_PARAGON_NOTIFY"] = "Max Reputation - Receive Reward."
L["Fun Stuff"] = true
L["Change the NPC Talk Frame."] = true
L["Press CTRL + C to copy."] = true
L["Wowhead Links"] = true
L["Adds Wowhead links to the Achievement- and WorldMap Frame"] = true
L["Highest Quest Reward"] = true
L["Automatically select the item with the highest reward."] = true
L["Item Alerts"] = true
L["Announce in chat when someone placed an usefull item."] = true
L["Maw ThreatBar"] = true
L["Replace the Maw Threat Display, with a simple StatusBar"] = true
L["Miscellaneous"] = true
L["Guild News Item Level"] = true
L["Add Item level Infos in Guild News"] = true
L["Spell Alert Scale"] = true
L["Add Title"] = true
L["Display an additional title."] = true
L["Add LFG group info to tooltip."] = true
L["Reskin Icon"] = true
L["Change role icons."] = true
L["Line"] = true
L["Alerts"] = true
L["Call to Arms"] = true
L["Feasts"] = true
L["Toys"] = true
L["Random Toy"] = true
L["Creates a random toy macro."] = true
L["Text Style"] = true
L["COLOR"] = true
L.ANNOUNCE_FP_PRE = "{rt1} %s has prepared a %s. {rt1}"
L.ANNOUNCE_FP_CLICK = "{rt1} %s is casting %s. Click! {rt1}"
L.ANNOUNCE_FP_USE = "{rt1} %s used a %s.{rt1} "
L.ANNOUNCE_FP_CAST = "{rt1} %s is casting %s. {rt1}"
L["Hide Boss Banner"] = true
L["This will hide the popup, that shows loot, after you kill a boss"] = true

-- Nameplates
L["NamePlates"] = true
L["Enhanced NameplateAuras"] = true

-- Tooltip
L["Your Status:"] = true
L["Your Status: Incomplete"] = true
L["Your Status: Completed on "] = true
L["Adds an icon for spells and items on your tooltip."] = true
L["Adds an Icon for battle pets on the tooltip."] = true
L["Adds an Icon for the faction on the tooltip."] = true
L["Adds information to the tooltip, on which char you earned an achievement."] = true
L["Keystone"] = true
L["Adds descriptions for mythic keystone properties to their tooltips."] = true
L["Title Color"] = true
L["Change the color of the title in the Tooltip."] = true
L["FACTION"] = "Fazione"
L["Only Icons"] = true
L["Use the new style tooltip."] = "Use the new style tooltip."
L["Display in English"] = "Display in English"
L["Show icon"] = "Show icon"
L["Show the spell icon along with the name."] = "Show the spell icon along with the name."
L["Domination Rank"] = true
L["Show the rank of shards."] = true
L["Covenant: <Not in Group>"] = true
L["Covenant: <Checking...>"] = true
L["Covenant: <None - Too low>"] = true
L["Covenant"] = true
L["Covenant: "] = true
L["Shows the Players Covenant on the Tooltip."] = true
L["Show not in group"] = true
L["Keep the Covenant Line when not in a group. Showing: <Not in Group>"] = true
L["Kyrian"] = true
L["Venthyr"] = true
L["NightFae"] = true
L["Necrolord"] = true
L["Pet Battle"] = true
L["Tooltip Icons"] = true

-- Notification
L["Notification"] = true
L["Display a Toast Frame for different notifications."] = true
L["This is an example of a notification."] = true
L["Notification Mover"] = true
L["%s slot needs to repair, current durability is %d."] = true
L["You have %s pending calendar invite(s)."] = true
L["You have %s pending guild event(s)."] = true
L["Event \"%s\" will end today."] = true
L["Event \"%s\" started today."] = true
L["Event \"%s\" is ongoing."] = true
L["Event \"%s\" will end tomorrow."] = true
L["Here you can enable/disable the different notification types."] = true
L["Enable Mail"] = true
L["Enable Vignette"] = true
L["If a Rar Mob or a treasure gets spotted on the minimap."] = true
L["Enable Invites"] = true
L["Enable Guild Events"] = true
L["No Sounds"] = true
L["Vignette Print"] = true
L["Prints a clickable Link with Coords in the Chat."] = true
L["Quick Join"] = true
L["Title Font"] = true
L["Text Font"] = true

-- DataTexts
-- DataBars
L["DataBars"] = true
L["Add some stylish buttons at the bottom of the DataBars"] = true
L["Style DataBars"] = true

-- PVP
L["Automatically cancel PvP duel requests."] = true
L["Automatically cancel pet battles duel requests."] = true
L["Announce in chat if duel was rejected."] = true
L["MER_DuelCancel_REGULAR"] = "Duel request from %s rejected."
L["MER_DuelCancel_PET"] = "Pet duel request from %s rejected."
L["Show your PvP killing blows as a popup."] = true
L["Sound"] = true
L["Play sound when killing blows popup is shown."] = true
L["PvP Auto Release"] = true
L["Automatically release body when killed inside a battleground."] = true
L["Check for rebirth mechanics"] = true
L["Do not release if reincarnation or soulstone is up."] = true

-- Actionbars
L["Specialization Bar"] = true
L["EquipSet Bar"] = true
L["Auto Buttons"] = true
L["Bind Font Size"] = true
L["Trinket Buttons"] = true
L["Color by Quality"] = true
L["Quest Buttons"] = true
L["Blacklist Item"] = true
L["Whitelist Item"] = true
L["Add Item ID"] = true
L["Delete Item ID"] = true
L["Spell Feedback"] = true
L["Creates a texture to show the recently pressed buttons."] = true
L["Frame Strata"] = true
L["Frame Level"] = true
L["KeyFeedback"] = true
L["Mirror"] = true
L["Mirror Button Size"] = true
L["Mirror Direction"] = true
L["LEFT"] = true
L["RIGHT"] = true

-- AutoButtons
L["AutoButtons"] = true
L["Bar"] = true
L["Only show the bar when you mouse over it."] = true
L["Bar Backdrop"] = true
L["Show a backdrop of the bar."] = true
L["Button Width"] = true
L["The width of the buttons."] = true
L["Button Height"] = true
L["The height of the buttons."] = true
L["Counter"] = true
L["Button Groups"] = true
L["Key Binding"] = true
L["Custom Items"] = true
L["List"] = true
L["New Item ID"] = true
L["Auto Button Bar"] = true
L["Quest Items"] = true
L["Equipments"] = true
L["Potions"] = true
L["Food"] = true
L["Crafted by mage"] = true
L["Flasks"] = true
L["Banners"] = true
L["Utilities"] = true
L["Custom Items"] = true
L["Fade Time"] = true
L["Alpha Min"] = true
L["Alpha Max"] = true
L["Inherit Global Fade"] = true
L["Anchor Point"] = true
L["The first button anchors itself to this point on the bar."] = true

-- Armory
L["Armory"] = true
L["ARMORY_DESC"] = [=[The |cffff7d0aArmory Mode|r only works with the ElvUI 'Display Character Info'. You may need to reload your UI:

ElvUI - General - BlizzUI Improvements - Display Character Infos.]=]
L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."] = true
L["Durability"] = true
L["Enable/Disable the display of durability information on the character window."] = true
L["Damaged Only"] = true
L["Only show durability information for items that are damaged."] = true
L["Itemlevel"] = true
L["Enable/Disable the display of item levels on the character window."] = true
L["Level"] = "Livello"
L["Full Item Level"] = true
L["Show both equipped and average item levels."] = true
L["Item Level Coloring"] = true
L["Color code item levels values. Equipped will be gradient, average - selected color."] = true
L["Color of Average"] = true
L["Sets the color of average item level."] = true
L["Only Relevant Stats"] = true
L["Show only those primary stats relevant to your spec."] = true
L["Item Level"] = true
L["Categories"] = true
L["Slot Gradient"] = true
L["Shows a gradiation texture on the Character Slots."] = true
L["Indicators"] = true
L["Transmog"] = true
L["Shows an arrow indictor for currently transmogrified items."] = true
L["Illusion"] = true
L["Shows an indictor for weapon illusions."] = true
L["Empty Socket"] = true
L["Not Enchanted"] = true
L["Warnings"] = true
L["Shows an indicator for missing sockets and enchants."] = true
L["Expanded Size"] = true
L["This will increase the Character Frame size a bit."] = true
L["Armor Set"] = true
L["Colors Set Items in a different color."] = true
L["Armor Set Gradient Texture Color"] = true
L["Full Item Level"] = true
L["Show both equipped and average item levels."] = true
L["Item Level Coloring"] = true
L["Color code item levels values. Equipped will be gradient, average - selected color."] = true
L["Color of Average"] = true
L["Sets the color of average item level."] = true
L["Warning Gradient Texture Color"] = true
L["Class Color Gradient"] = true

-- Media
L["Zone Text"] = true
L["Font Size"] = true
L["Subzone Text"] = true
L["PvP Status Text"] = true
L["Misc Texts"] = true
L["Mail Text"] = true
L["Chat Editbox Text"] = true
L["Gossip and Quest Frames Text"] = true
L["Objective Tracker Header Text"] = true
L["Objective Tracker Text"] = true
L["Banner Big Text"] = true
L["MER_MEDIA_ZONES"] = {
	"Washington",
	"Moscow",
	"Moon Base",
	"Goblin Spa Resort",
	"Illuminaty Headquaters",
	"Elv's Closet",
	"BlizzCon",
}
L["MER_MEDIA_PVP"] = {
	"(Horde Territory)",
	"(Alliance Territory)",
	"(Contested Territory)",
	"(Russian Territory)",
	"(Aliens Territory)",
	"(Cats Territory)",
	"(Japanese Territory)",
	"(EA Territory)",
}
L["MER_MEDIA_SUBZONES"] = {
	"Administration",
	"Hellhole",
	"Alley of Bullshit",
	"Dr. Pepper Storage",
	"Vodka Storage",
	"Last National Bank",
}
L["MER_MEDIA_PVPARENA"] = {
	"(PvP)",
	"No Smoking!",
	"Only 5% Taxes",
	"Free For All",
	"Self destruction is in process",
}

-- Unitframes
L["UnitFrames"] = true
L["Adds a shadow to the debuffs that the debuff color is more visible."] = true
L["Swing Bar"] = true
L["Creates a weapon Swing Bar"] = true
L["Main-Hand Color"] = true
L["Off-Hand Color"] = true
L["Two-Hand Color"] = true
L["GCD Bar"] = true
L["Creates a Global Cooldown Bar"] = true
L["UnitFrame Style"] = true
L["Adds my styling to the Unitframes if you use transparent health."] = true
L["Change the default role icons."] = true
L["Changes the Heal Prediction texture to the default Blizzard ones."] = true
L["Add a glow in the end of health bars to indicate the over absorb."] = true
L["Add the Blizzard over absorb glow and overlay to ElvUI unit frames."] = true
L["Auto Height"] = true
L["Blizzard Absorb Overlay"] = true
L["Blizzard Over Absorb Glow"] = true
L["Blizzard Style"] = true
L["Change the color of the absorb bar."] = true
L["Custom Texture"] = "Benutzerdefinierte Textur"
L["Enable the replacing of ElvUI absorb bar textures."] = true
L["Here are some buttons for helping you change the setting of all absorb bars by one-click."] = true
L["Max Overflow"] = true
L["Modify the texture of the absorb bar."] = true
L["Overflow"] = true
L["Set %s to %s"] = true
L["Set All Absorb Style to %s"] = true
L["The absorb style %s and %s is highly recommended with %s tweaks."] = true
L["The selected texture will override the ElvUI default absorb bar texture."] = true
L["Use the texture from Blizzard Raid Frames."] = true
L["Raid Icon"] = true
L["Change the default raid icons."] = true
L["Highlight"] = true
L["Adds an own highlight to the Unitframes"] = true
L["Auras"] = true
L["Adds an shadow around the auras"] = true
L["Power"] = true
L["Enable the animated Power Bar"] = true
L["Select Model"] = true
L["Type the Model ID"] = true
L["Role Icons"] = true
L["Heal Prediction"] = true
L["Add an additional overlay to the absorb bar."] = true

-- LocationPanel
L["Location Panel"] = true
L["Update Throttle"] = true
L["The frequency of coordinates and zonetext updates. Check will be done more often with lower values."] = true
L["Full Location"] = true
L["Color Type"] = true
L["Custom Color"] = true
L["Reaction"] = true
L["Location"] = true
L["Coordinates"] = true
L["Teleports"] = true
L["Portals"] = true
L["Link Position"] = true
L["Allow pasting of your coordinates in chat editbox via holding shift and clicking on the location name."] = true
L["Relocation Menu"] = true
L["Right click on the location panel will bring up a menu with available options for relocating your character (e.g. Hearthstones, Portals, etc)."] = true
L["Custom Width"] = true
L["By default menu's width will be equal to the location panel width. Checking this option will allow you to set own width."] = true
L["Justify Text"] = true
L["Auto Width"] = true
L["Change width based on the zone name length."] = true
L["Hearthstone Location"] = true
L["Show the name on location your Hearthstone is bound to."] = true
L["Combat Hide"] = true
L["Show/Hide all panels when in combat"] = true
L["Hide In Class Hall"] = true
L["Hearthstone Location"] = true
L["Hearthstone Toys Order"] = true
L["Show hearthstones"] = true
L["Show hearthstone type items in the list."] = true
L["Show Toys"] = true
L["Show toys in the list. This option will affect all other display options as well."] = true
L["Show spells"] = true
L["Show relocation spells in the list."] = true
L["Show engineer gadgets"] = true
L["Show items used only by engineers when the profession is learned."] = true
L["Ignore missing info"] = true
L["MER_LOCPANEL_IGNOREMISSINGINFO"] = [[Due to how client functions some item info may become unavailable for a period of time. This mostly happens to toys info.
When called the menu will wait for all information being available before showing up. This may resul in menu opening after some concidarable amount of time, depends on how fast the server will answer info requests.
By enabling this option you'll make the menu ignore items with missing info, resulting in them not showing up in the list.]]
L["Info for some items is not available yet. Please try again later"] = true
L["Update canceled."] = true
L["Item info is not available. Waiting for it. This can take some time. Menu will be opened automatically when all info becomes available. Calling menu again during the update will cancel it."] = true
L["Update complete. Opening menu."] = true
L["Hide Coordinates"] = true
L["Dungeon Teleports"] = true
L["Hide In Combat"] = true

-- Maps
L["Maps"] = true
L["World Map"] = true
L["Instance Difficulty"] = true
L["Duration"] = true
L["Fade Out"] = true
L["Scale"] = true
L["Reskin the instance diffculty in text style."] = true
L["Hide Blizzard"] = true
L["Change the shape of ElvUI minimap."] = true
L["Height Percentage"] = true
L["Percentage of ElvUI minimap size."] = true
L["MiniMap Buttons"] = true
L["Minimap Ping"] = true
L["Add Server Name"] = true
L["Only In Combat"] = true
L["Fade-In"] = true
L["The time of animation. Set 0 to disable animation."] = true
L["Blinking Minimap"] = true
L["Enable the blinking animation for new mail or pending invites."] = true
L["Super Tracker"] = true
L["Description"] = true
L["Additional features for waypoint."] = true
L["Auto Track Waypoint"] = true
L["Auto track the waypoint after setting."] = true
L["Right Click To Clear"] = true
L["Right click the waypoint to clear it."] = true
L["No Distance Limitation"] = true
L["Force to track the target even if it over 1000 yds."] = true
L["Distance Text"] = true
L["Only Number"] = true
L["Add Command"] = true
L["Add a input box to the world map."] = true
L["Are you sure to delete the %s command?"] = true
L["Can not set waypoint on this map."] = true
L["Command"] = true
L["Command Configuration"] = true
L["Command List"] = true
L["Delete Command"] = true
L["Delete the selected command."] = true
L["Enable to use the command to set the waypoint."] = true
L["Go to ..."] = true
L["Input Box"] = true
L["New Command"] = true
L["No Arg"] = true
L["Smart Waypoint"] = true
L["The argument is invalid."] = true
L["The argument is needed."] = true
L["The command to set a waypoint."] = true
L["The coordinates contain illegal number."] = true
L["Waypoint %s has been set."] = true
L["Waypoint Parse"] = true
L["You can paste any text contains coordinates here, and press ENTER to set the waypoint in map."] = true
L["illegal"] = true
L["invalid"] = true
L["Because of %s, this module will not be loaded."] = true
L["This module will help you to reveal and resize maps."] = true
L["Reveal"] = true
L["Use Colored Fog"] = true
L["Remove Fog of War from your world map."] = true
L["Style Fog of War with special color."] = true
L["Resize world map."] = true
L["LFG Queue"] = true

-- SMB
L["Minimap Buttons"] = true
L["Add an extra bar to collect minimap buttons."] = true
L["Toggle minimap buttons bar."] = true
L["Mouse Over"] = true
L["Only show minimap buttons bar when you mouse over it."] = true
L["Minimap Buttons Bar"] = true
L["Bar Backdrop"] = true
L["Show a backdrop of the bar."] = true
L["Backdrop Spacing"] = true
L["The spacing between the backdrop and the buttons."] = true
L["Inverse Direction"] = true
L["Reverse the direction of adding buttons."] = true
L["Orientation"] = true
L["Arrangement direction of the bar."] = true
L["Drag"] = true
L["Horizontal"] = true
L["Vertical"] = true
L["Buttons"] = true
L["Buttons Per Row"] = true
L["The amount of buttons to display per row."] = true
L["Button Size"] = true
L["The size of the buttons."] = true
L["Button Spacing"] = true
L["The spacing between buttons."] = true
L["Blizzard Buttons"] = true
L["Calendar"] = true
L["Add calendar button to the bar."] = true
L["Garrison"] = true
L["Add garrison button to the bar."] = true

-- Raid Marks
L["Raid Markers"] = true
L["Raid Markers Bar"] = true
L["Raid Utility"] = true
L["Left Click to mark the target with this mark."] = true
L["Right Click to clear the mark on the target."] = true
L["%s + Left Click to place this worldmarker."] = true
L["%s + Right Click to clear this worldmarker."] = true
L["%s + Left Click to mark the target with this mark."] = true
L["%s + Right Click to clear the mark on the target."] = true
L["Click to clear all marks."] = true
L["takes 3s"] = true
L["%s + Click to remove all worldmarkers."] = true
L["Click to remove all worldmarkers."] = true
L["%s + Click to clear all marks."] = true
L["Left Click to ready check."] = true
L["Right click to toggle advanced combat logging."] = true
L["Left Click to start count down."] = true
L["Add an extra bar to let you set raid markers efficiently."] = true
L["Toggle raid markers bar."] = true
L["Inverse Mode"] = true
L["Swap the functionality of normal click and click with modifier keys."] = true
L["Visibility"] = true
L["In Party"] = true
L["Always Display"] = true
L["Mouse Over"] = true
L["Only show raid markers bar when you mouse over it."] = true
L["Tooltip"] = true
L["Show the tooltip when you mouse over the button."] = true
L["Modifier Key"] = true
L["Set the modifier key for placing world markers."] = true
L["Shift Key"] = true
L["Ctrl Key"] = true
L["Alt Key"] = true
L["Bar Backdrop"] = true
L["Show a backdrop of the bar."] = true
L["Backdrop Spacing"] = true
L["The spacing between the backdrop and the buttons."] = true
L["Orientation"] = true
L["Arrangement direction of the bar."] = true
L["Raid Buttons"] = true
L["Ready Check"] = true
L["Advanced Combat Logging"] = true
L["Left Click to ready check."] = true
L["Right click to toggle advanced combat logging."] = true
L["Count Down"] = true
L["Count Down Time"] = true
L["Count down time in seconds."] = true
L["Button Size"] = true
L["The size of the buttons."] = true
L["Button Spacing"] = true
L["The spacing between buttons."] = true
L["Button Backdrop"] = true
L["Button Animation"] = true

-- Raid Buffs
L["Raid Buff Reminder"] = true
L["Shows a frame with flask/food/rune."] = true
L["Class Specific Buffs"] = true
L["Shows all the class specific raid buffs."] = true
L["Change the alpha level of the icons."] = true
L["Shows the pixel glow on missing raidbuffs."] = true

-- Raid Manager
L["Raid Manager"] = true
L["This will disable the ElvUI Raid Control and replace it with my own."] = true
L["Open Raid Manager"] = true
L["Pull Timer Count"] = true
L["Change the Pulltimer for DBM or BigWigs"] = true
L["Only accept values format with '', e.g.: '5', '8', '10' etc."] = true

-- Reminder
L["Reminder"] = true
L["Reminds you on self Buffs."] = true

-- Cooldowns
L["Cooldowns"] = true
L["Cooldown Flash"] = true
L["Settings"] = true
L["Fadein duration"] = true
L["Fadeout duration"] = true
L["Duration time"] = true
L["Animation size"] = true
L["Watch on pet spell"] = true
L["Transparency"] = true
L["Test"] = true
L["Sort Upwards"] = true
L["Sort by Expiration Time"] = true
L["Show Self Cooldown"] = true
L["Show Icons"] = true
L["Show In Party"] = true
L["Show In Raid"] = true
L["Show In Arena"] = true
L["Spell Name"] = true
L["Spell List"] = true

-- CVars
L["\n\nDefault: |cff00ff001|r"] = true
L["\n\nDefault: |cffff00000|r"] = true
L["alwaysCompareItems"] = true
L["alwaysCompareItems_DESC"] = "Always show item comparsion tooltips\r\rDefault: |cffff00000|r"
L["breakUpLargeNumbers"] = true
L["breakUpLargeNumbers_DESC"] = "Toggles using commas in large numbers\r\rDefault: |cff00ff001|r"
L["scriptErrors"] = true
L["enableWoWMouse"] = true
L["trackQuestSorting"] = true
L["trackQuestSorting_DESC"] = "New tracking tasks will be listed at target tracking location \r\r default: top"
L["autoLootDefault"] = true
L["autoDismountFlying"] = true
L["removeChatDelay"] = true
L["screenshotQuality"] = true
L["screenshotQuality_DESC"] = "Screenshot Quality\r\rDefault: |cff00ff003|r"
L["showTutorials"] = true
L["WorldTextScale"] = true
L["WorldTextScale_DESC"] = "The scale of in-world damge numbers, xp gain, artifact gain, etc \r\r default: 1.0"
L["floatingCombatTextCombatDamageDirectionalScale"] = true
L["floatingCombatTextCombatDamageDirectionalScale_DESC"] = "Directional damage numbers movement scale (disable = no directional numbers\r\rDefault: |cff00ff001|r"

-- GMOTD
L["Display the Guild Message of the Day in an extra window, if updated."] = true

-- AFK
L["Jan"] = true
L["Feb"] = true
L["Mar"] = true
L["Apr"] = true
L["May"] = true
L["Jun"] = true
L["Jul"] = true
L["Aug"] = true
L["Sep"] = true
L["Oct"] = true
L["Nov"] = true
L["Dec"] = true

L["Sun"] = true
L["Mon"] = true
L["Tue"] = true
L["Wed"] = true
L["Thu"] = true
L["Fri"] = true
L["Sat"] = true

-- Nameplates
L["Castbar Shield"] = true
L["Show a shield icon on the castbar for non interruptible spells."] = true
L["|cffFF0000NOTE:|r This will overwrite the ElvUI Nameplate options for Buff/Debuffs width/height. The CC-Buffs are hardcoded to a size of: 32 x 32"] = true

-- Install
L["Welcome"] = true
L["|cffff7d0aMerathilisUI|r Installation"] = true
L["MerathilisUI Set"] = true
L["MerathilisUI didn't find any supported addons for profile creation"] = true
L["MerathilisUI successfully created and applied profile(s) for:"] = true
L["Chat Set"] = true
L["ActionBars"] = true
L["ActionBars Set"] = true
L["DataTexts Set"] = true
L["Profile Set"] = true
L["ElvUI AddOns settings applied."] = true
L["AddOnSkins is not enabled, aborting."] = true
L["AddOnSkins settings applied."] = true
L["BigWigs is not enabled, aborting."] = true
L["BigWigs Profile Created"] = true
L["Skada Profile Created"] = true
L["Skada is not enabled, aborting."] = true
L["UnitFrames Set"] = true
L["Welcome to MerathilisUI |cff00c0faVersion|r %s, for ElvUI %s."] = true
L["By pressing the Continue button, MerathilisUI will be applied in your current ElvUI installation.\r\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"] = true
L["Buttons must be clicked twice"] = true
L["Importance: |cffff0000Very High|r"] = true
L["The AddOn 'AddOnSkins' is not enabled. No settings have been changed."] = true
L["The Addon 'Big Wigs' is not enabled. Profile not created."] = true
L["The AddOn 'ElvUI_BenikUI' is not enabled. No settings have been changed."] = true
L["The AddOn 'ElvUI_SLE' is not enabled. No settings have been changed."] = true
L["The Addon 'Skada' is not enabled. Profile not created."] = true
L["This part of the installation process sets up your chat fonts and colors."] = true
L["This part of the installation changes the default ElvUI look."] = true
L["This part of the installation process will fill MerathilisUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"] = true
L["This part of the installation process will reposition your Actionbars and will enable backdrops"] = true
L["This part of the installation process will change your NamePlates."] = true
L["This part of the installation process will reposition your Unitframes."] = true
L["This part of the installation process will apply changes to ElvUI Plugins"] = true
L["This step changes a few World of Warcraft default options. These options are tailored to the needs of the author of %s and are not necessary for this edit to function."] = true
L["Please click the button below to apply the new layout."] = true
L["Please click the button below to setup your chat windows."] = true
L["Please click the button below to setup your actionbars."] = true
L["Please click the button below to setup your datatexts."] = true
L["Please click the button below to setup your NamePlates."] = true
L["Please click the button below to setup your Unitframes."] = true
L["Please click the button below to setup the ElvUI AddOns. For other Addon profiles please go in my Options - Skins/AddOns"] = true
L["DataTexts"] = true
L["General Layout"] = true
L["Setup ActionBars"] = true
L["Setup NamePlates"] = true
L["Setup UnitFrames"] = true
L["Setup Datatexts"] = true
L["Setup Addons"] = true
L["ElvUI AddOns"] = true
L["Finish"] = true
L["Installed"] = true

-- Staticpopup
L["MSG_MER_ELV_OUTDATED"] = "Your version of ElvUI is older than recommended to use with |cffff7d0aMerathilisUI|r. Your version is |cff00c0fa%.2f|r (recommended is |cff00c0fa%.2f|r). MerathilisUI isn't loaded. Please update your ElvUI."
L["You have got Location Plus and Shadow & Light both enabled at the same time. Select an addon to disable."] = true
L["MUI_INSTALL_SETTINGS_LAYOUT_SLE"] = [[Here you can choose the layout for S&L.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_BW"] = [[Here you can choose the layout for BigWigs.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_DBM"] = [[Here you can choose the layout for Deadly Boss Mods.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_DETAILS"] = [[Here you can choose the layout for Details.]]
L["Name for the new profile"] = true
L["Are you sure you want to override the current profile?"] = true

-- Skins
L["MER_SKINS_DESC"] = [[This section is designed to enhance skins existing in ElvUI.

Please note that some of these options will not be available if corresponding skin is |cff636363disabled|r in main ElvUI skins section.]]
L["MER_ADDONSKINS_DESC"] = [[This section is designed to modify some external addons appearance.

Please note that some of these options will be |cff636363disabled|r if the addon is not loaded in the addon control panel.]]
L["MerathilisUI Style"] = true
L["Creates decorative stripes and a gradient on some frames"] = true
L["Screen Shadow Overlay"] = true
L["Enables/Disables a shadow overlay to darken the screen."] = true
L["Undress Button"] = true
L["Subpages"] = true
L["Subpages are blocks of 10 items. This option set how many of subpages will be shown on a single page."] = true
L["Enable/Disable"] = true
L["decor."] = true
L["MerathilisUI Button Style"] = true
L["Creates decorative stripes on Ingame Buttons (only active with MUI Style)"] = true
L["Additional Backdrop"] = true
L["Remove Border Effect"] = true
L["Animation Type"] = true
L["The type of animation activated when a button is hovered."] = true
L["Animation Duration"] = true
L["The duration of the animation in seconds."] = true
L["Backdrop Class Color"] = true
L["Border Class Color"] = true
L["Border Color"] = true
L["Normal Class Color"] = true
L["Selected Backdrop & Border"] = true
L["Selected Class Color"] = true
L["Selected Color"] = true
L["Tab"] = true
L["Tree Group Button"] = true
L["Shadow Color"] = true
L["These skins will affect all widgets handled by ElvUI Skins."] = true
L["Texture"] = true
L["Backdrop Color"] = true
L["Check Box"] = true
L["Slider"] = true
L["Backdrop Alpha"] = true
L["Enable All"] = true
L["Disable All"] = true
L["Spellbook"] = true
L["Character Frame"] = true
L["Gossip Frame"] = true
L["Quest Frames"] = true
L["TALENTS"] = true
L["AUCTIONS"] = true
L["FRIENDS"] = true
L["GUILD"] = true
L["Mail Frame"] = true
L["WORLD_MAP"] = true
L["Guild Control Frame"] = true
L["MACROS"] = true
L["GUILD_BANK"] = true
L["FLIGHT_MAP"] = true
L["Help Frame"] = true
L["Loot Frames"] = true
L["CHANNELS"] = true
L["Raid Frame"] = true
L["Craft"] = true
L["Event Toast Manager"] = true
L["Quest Choice"] = true
L["Orderhall"] = true
L["Contribution"] = true
L["Calendar Frame"] = true
L["Merchant Frame"] = true
L["PvP Frames"] = true
L["LF Guild Frame"] = true
L["TalkingHead"] = true
L["Minimap"] = true
L["Trainer Frame"] = true
L["Socket Frame"] = true
L["Item Upgrade"] = true
L["Trade"] = true
L["Allied Races"] = true
L["Archaeology Frame"] = true
L["Azerite Essence"] = true
L["Item Interaction"] = true
L["Anima Diversion"] = true
L["Soulbinds"] = true
L["Covenant Sanctum"] = true
L["Covenant Preview"] = true
L["Covenant Renown"] = true
L["Player Choice"] = true
L["Chromie Time"] = true
L["LevelUp Display"] = true
L["Guide Frame"] = true
L["Weekly Rewards"] = true
L["Misc"] = true

-- Panels
L["Panels"] = true
L["Top Panel"] = true
L["Bottom Panel"] = true
L["Style Panels"] = true
L["Top Left Panel"] = true
L["Top Left Extra Panel"] = true
L["Top Right Panel"] = true
L["Top Right Extra Panel"] = true
L["Bottom Left Panel"] = true
L["Bottom Left Extra Panel"] = true
L["Bottom Right Panel"] = true
L["Bottom Right Extra Panel"] = true

-- Objective Tracker
L["Objective Tracker"] = true
L["1. Customize the font of Objective Tracker."] = true
L["2. Add colorful progress text to the quest."] = true
L["Progress"] = true
L["No Dash"] = true
L["Colorful Progress"] = true
L["Percentage"] = true
L["Add percentage text after quest text."] = true
L["Colorful Percentage"] = true
L["Make the additional percentage text be colored."] = true
L["Cosmetic Bar"] = true
L["Border"] = true
L["Border Alpha"] = true
L["Width Mode"] = true
L["'Absolute' mode means the width of the bar is fixed."] = true
L["'Dynamic' mode will also add the width of header text."] = true
L["'Absolute' mode means the height of the bar is fixed."] = true
L["'Dynamic' mode will also add the height of header text."] = true
L["Absolute"] = true
L["Dyanamic"] = true
L["Color Mode"] = true
L["Gradient"] = true
L["Class Color"] = true
L["Normal Color"] = true
L["Gradient Color 1"] = true
L["Gradient Color 2"] = true
L["Presets"] = true
L["Preset %d"] = true
L["Here are some example presets, just try them!"] = true
L["Default"] = true
L["Header"] = true
L["Short Header"] = true
L["Use short name instead. e.g. Torghast, Tower of the Damned to Torghast."] = true
L["Title Color"] = true
L["Change the color of quest titles."] = true
L["Use Class Color"] = true
L["Highlight Color"] = true
L["Title"] = true
L["Bottom Right Offset X"] = true
L["Bottom Right Offset Y"] = true
L["Top Left Offset X"] = true
L["Top Left Offset Y"] = true
L["Transparent"] = true
L["Style"] = true
L["Height Mode"] = true

-- Filter
L["Filter"] = true
L["Unblock the profanity filter."] = true
L["Profanity Filter"] = true
L["Enable this option will unblock the setting of profanity filter. [CN Server]"] = true

-- Friends List
L["Friends List"] = true
L["Add additional information to the friend frame."] = true
L["Modify the texture of status and make name colorful."] = true
L["Enhanced Texture"] = true
L["Game Icons"] = true
L["Default"] = true
L["Modern"] = true
L["Status Icon Pack"] = true
L["Diablo 3"] = true
L["Square"] = true
L["Faction Icon"] = true
L["Use faction icon instead of WoW icon."] = true
L["Name"] = true
L["Level"] = "Livello"
L["Hide Max Level"] = true
L["Use Note As Name"] = true
L["Replace the Real ID or the character name of friends with your notes."] = true
L["Use Game Color"] = true
L["Change the color of the name to the in-playing game style."] = true
L["Use Class Color"] = true
L["Font Setting"] = true

-- Talents
L["Talents"] = true
L["This feature improves the Talent Window by:\n\n Adding an Extra Button to swap between specializations.\n Adding an Extra Button to use and track duration for Codices and Tomes."] = true

-- Profiles
L["MER_PROFILE_DESC"] = [[This section creates Profiles for some AddOns.

|cffff0000WARNING:|r It will overwrite/delete existing Profiles. If you don't want to apply my Profiles please don't press the Buttons below.]]

-- Addons
L["Skins/AddOns"] = true
L["Profiles"] = true
L["BigWigs"] = true
L["MasterPlan"] = true
L["Shadow & Light"] = "|cff9482c9Shadow & Light|r"
L["This will create and apply profile for "] = true

-- Changelog
L["Changelog"] = true

-- Compatibility
L["Compatibility Check"] = true
L["Help you to enable/disable the modules for a better experience with other plugins."] = true
L["There are many modules from different addons or ElvUI plugins, but several of them are almost the same functionality."] = true
L["Have a good time with %s!"] = true
L["Choose the module you would like to |cff00ff00use|r"] = true
L["If you find the %s module conflicts with another addon, alert me via Discord."] = true
L["You can disable/enable compatibility check via the option in the bottom of [MerathilisUI]-[Information]."] = true
L["Complete"] = true

-- Debug
L["Usage"] = true
L["Enable debug mode"] = true
L["Disable all other addons except ElvUI Core, ElvUI %s and BugSack."] = true
L["Disable debug mode"] = true
L["Reenable the addons that disabled by debug mode."] = true
L["Debug Enviroment"] = true
L["You can use |cff00ff00/muidebug off|r command to exit debug mode."] = true
L["After you stop debuging, %s will reenable the addons automatically."] = true
L["Before you submit a bug, please enable debug mode with %s and test it one more time."] = true
L["Error"] = true
L["Warning"] = true
