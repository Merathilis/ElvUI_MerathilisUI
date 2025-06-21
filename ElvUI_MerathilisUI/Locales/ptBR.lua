-- Portugese localization file for enUS
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "ptBR", true, true)
if not L then
	return
end

-- Core
L["Enable"] = true
L[" is loaded. For any issues or suggestions join my discord: "] = true
L["Please run through the installation process to set up the plugin.\n\n |cffff7d0aThis step is needed to ensure that all features are configured correctly for your profile. You don't have to apply every step.|r"] =
	true
L["Font"] = true
L["Size"] = true
L["Width"] = true
L["Height"] = true
L["Alpha"] = true
L["Outline"] = true
L["Y-Offset"] = true
L["X-Offset"] = true
L["Y-Offset"] = true
L["Icon Size"] = true
L["Font Outline"] = true

-- General Options
L["Plugin for |cffff7d0aElvUI|r by\nMerathilis."] = true
L["by Merathilis (|cFF00c0faEU-Shattrath|r)"] = true
L[" does not support this game version, please uninstall it and don't ask for support. Thanks!"] = true
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
L["Enables the stripes/gradient look on the frames"] = true

-- Core Options
L["Login Message"] = true
L["Enable/Disable the Login Message in Chat"] = true
L["Log Level"] = true
L["Only display log message that the level is higher than you choose."] = true
L["Set to 2 if you do not understand the meaning of log level."] = true
L["This will overwrite most of the ElvUI Options for the colors, so please keep that in mind."] = true

-- Bags

-- Chat
L["CHAT_AFK"] = "[AFK]"
L["CHAT_DND"] = "[DND]"
L["BACK"] = "Back"
L["has come |cff298F00online|r."] = true -- Guild Message
L["has gone |cffff0000offline|r."] = true -- Guild Message
L[" has come |cff298F00online|r."] = true -- Battle.Net Message
L[" has gone |cffff0000offline|r."] = true -- Battle.Net Message
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
L["Level"] = true
L["Translate Item"] = true
L["Translate the name in item links into your language."] = true
L["Icon"] = true
L["Armor Category"] = true
L["Weapon Category"] = true
L["Filters some messages out of your chat, that some Spam AddOns use."] = true
L["Display the level of the item on the item link."] = true
L["Numerical Quality Tier"] = true
L["%player% has earned the achievement %achievement%!"] = true
L["%players% have earned the achievement %achievement%!"] = true
L["%players% (%bnet%) has come online."] = "%players% (%bnet%) se conectou."
L["%players% (%bnet%) has gone offline."] = "%players% (%bnet%) se desconectou."
L["BNet Friend Offline"] = true
L["BNet Friend Online"] = true
L["Show a message when a Battle.net friend's wow character comes online."] = true
L["Show a message when a Battle.net friend's wow character goes offline."] = true
L["Show the class icon before the player name."] = true
L["Show the faction icon before the player name."] = true
L["The message will only be shown in the chat frame (or chat tab) with Blizzard service alert channel on."] = true
L["This feature only works for message that sent by this module."] = true
L["Position of the Chat EditBox, if the Actionbar backdrop is disabled, this will be forced to be above chat."] = true
L["Actionbar 1 (below)"] = true
L["Actionbar 2 (below)"] = true
L["Actionbar 3 (below)"] = true
L["Actionbar 4 (below)"] = true
L["Actionbar 5 (below)"] = true
L["Actionbar 6 (above)"] = true

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
L["Development Version"] = "Dev. Version"
L["Here you can download the latest development version."] = true
L["Donations"] = true

-- Modules
L["Here you find the options for all the different |cffffffffMerathilis|r|cffff8000UI|r modules."] = true
L["Are you sure you want to reset %s module?"] = true
L["Reset All Modules"] = true
L["Reset all %s modules."] = true

-- GameMenu
L["Game Menu"] = true
L["Enable/Disable the MerathilisUI Style from the Blizzard Game Menu. (e.g. Pepe, Logo, Bars)"] = true
L["Achievements: "] = true
L["Achievement Points: "] = true
L["Mounts: "] = true
L["Pets: "] = true
L["Toys: "] = true
L["Current Keystone: "] = true
L["M+ Score: "] = true
L["Show Weekly Delves Keys"] = true
L["Mythic+"] = true
L["Show Mythic+ Infos"] = true
L["Show Mythic+ Score"] = true
L["History Limit"] = true
L["Number of Mythic+ dungeons shown in the latest runs."] = true

-- Extended Vendor
L["Extended Vendor"] = true
L["Extends the merchant page to show more items."] = true
L["Number of Pages"] = true
L["The number of pages shown in the merchant frame."] = true

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
L["Remove This Alt"] = true

-- MicroBar
L["Backdrop"] = true
L["Backdrop Spacing"] = true
L["The spacing between the backdrop and the buttons."] = true
L["Time Width"] = true
L["Time Height"] = true
L["The spacing between buttons."] = true
L["The size of the buttons."] = true
L["Slow Mode"] = true
L["Update the additional text every 10 seconds rather than every 1 second such that the used memory will be lower."] =
	true
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
L["Double Click to Undress"] = true
L["Accept Quest"] = true
L["Placed Item"] = true
L["Stranger"] = true
L["Shows a simple frame with Raid Informations."] = true
L["Keystones"] = true
L["GUILD_MOTD_LABEL2"] = "Guild Message of the Day"
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
L["Item Alerts"] = true
L["Announce in chat when someone placed an usefull item."] = true
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
L["Text Style"] = true
L["COLOR"] = true
L["Hide Boss Banner"] = true
L["This will hide the popup, that shows loot, after you kill a boss"] = true
L["{rt1} %player% cast %spell% -> %target% {rt1}"] = true
L["{rt1} %player% cast %spell%, today's special is Anchovy Pie! {rt1}"] = true
L["{rt1} %player% is casting %spell%, please assist! {rt1}"] = true
L["{rt1} %player% is handing out %spell%, go and get one! {rt1}"] = true
L["{rt1} %player% opened %spell%! {rt1}"] = true
L["{rt1} %player% puts %spell% {rt1}"] = true
L["{rt1} %player% used %spell% {rt1}"] = true
L["{rt1} %player% puts down %spell%! {rt1}"] = true
L["Completed"] = true
L["%s has been reseted"] = true
L["Cannot reset %s (There are players in your party attempting to zone into an instance.)"] = true
L["Cannot reset %s (There are players offline in your party.)"] = true
L["Cannot reset %s (There are players still inside the instance.)"] = true
L["Let your teammates know the progress of quests."] = true
L["Disable Blizzard"] = true
L["Disable Blizzard quest progress message."] = true
L["Include Details"] = true
L["Announce every time the progress has been changed."] = true
L["In Party"] = true
L["In Instance"] = true
L["In Raid"] = true
L["None"] = true
L["Self (Chat Frame)"] = true
L["Emote"] = true
L["Party"] = true
L["Yell"] = true
L["Say"] = true
L["The category of the quest."] = true
L["Suggested Group"] = true
L["If the quest is suggested with multi-players, add the number of players to the message."] = true
L["The level of the quest."] = true
L["Hide Max Level"] = true
L["Hide the level part if the quest level is the max level of this expansion."] = true
L["Add the prefix if the quest is a daily quest."] = true
L["Add the prefix if the quest is a weekly quest."] = true
L["Send the use of portals, ritual of summoning, feasts, etc."] = true
L["Feasts"] = true
L["Bots"] = true
L["Toys"] = true
L["Portals"] = true
L["Include Player"] = true
L["Uncheck this box, it will not send message if you cast the spell."] = true
L["Raid Warning"] = true
L["If you have privilege, it would the message to raid warning(/rw) rather than raid(/r)."] = true
L["Text"] = true
L["Name of the player"] = true
L["Target name"] = true
L["The spell link"] = true
L["Default Text"] = true
L["Reset Instance"] = true
L["Send a message after instance resetting."] = true
L["Prefix"] = true
L["Channel"] = true
L["Keystone"] = true
L["Announce the new mythic keystone."] = true
L["Heroism/Bloodlust"] = true
L["Mute"] = true
L["Disable some annoying sound effects."] = true
L["Others"] = true
L["Dragonriding"] = true
L["Mute the sound of dragonriding."] = true
L["Jewelcrafting"] = true
L["Mute the sound of jewelcrafting."] = true
L["Same Message Interval"] = true
L["Time interval between sending same messages measured in seconds."] = true
L["Set to 0 to disable."] = true
L["Automation"] = true
L["Automate your game life."] = true
L["Auto Hide Bag"] = true
L["Automatically close bag if player enters combat."] = true
L["Auto Hide Map"] = true
L["Automatically close world map if player enters combat."] = true
L["Accept Resurrect"] = true
L["Accept resurrect from other player automatically when you not in combat."] = true
L["Accept Combat Resurrect"] = true
L["Accept resurrect from other player automatically when you in combat."] = true
L["Confirm Summon"] = true
L["Confirm summon from other player automatically."] = true
L["Quick Delete"] = true
L["This will add the 'DELETE' text to the Item Delete Dialog."] = true
L["Show all stats on the Character Frame"] = true
L["Block Join Requests"] = true
L["|nIf checked, only popout join requests from friends and guild members."] = true
L["Random Toy Macro"] = true
L["Creates a random toy macro."] = true
L["Spell activation alert frame customizations."] = true
L["Enable/Disable the spell activation alert frame."] = true
L["Opacity"] = true
L["Set the opacity of the spell activation alert frame. (Blizzard CVar)"] = true
L["Set the scale of the spell activation alert frame."] = true
L["Dressing Room"] = true
L["Inspect Frame"] = true
L["Sync Inspect"] = true
L["Toggling this on makes your inspect frame scale have the same value as the character frame scale."] = true
L["Talents"] = true
L["Wardrobe"] = true
L["Auction House"] = true
L["Transmog Frame"] = true
L["Makes the transmogrification frame bigger. Credits to Kayr for code."] = true
L["Add more oUF tags. You can use them on UnitFrames configuration."] = true
L["Already Known"] = true
L["Puts a overlay on already known learnable items on vendors and AH."] = true
L["Crying"] = true
L["Mute crying sounds of all races."] = true
L["It will affect the cry emote sound."] = true
L["It will also affect the crying sound of all female Blood Elves."] = true
L["Class"] = true
L["The class icon of the player's class"] = true
L["Context Menu"] = true
L["Add features to the context menu."] = true
L["Section Title"] = true
L["Add a styled section title to the context menu."] = true
L["Guild Invite"] = true
L["Who"] = true
L["Report Stats"] = true
L["Armory"] = true
L["Set Region"] = true
L["If the game language is different from the primary language in this server, you need to specify which area you play on."] =
	true
L["Auto-detect"] = true
L["Taiwan"] = true
L["Korea"] = true
L["Americas & Oceania"] = true
L["Europe"] = true
L["Server List"] = true
L["Trade Tabs"] = true
L["Enable Tabs on the Profession Frames"] = true
L["Chef's Hat"] = "Chapéu de Mestre-cuca"
L["Group Finder"] = true
L["Equipment Upgrade"] = true
L["Vendor"] = true
L["Class Trainer"] = true
L["Gossip"] = true
L["Class Icon"] = true
L["Deathknight"] = true
L["Evoker"] = true
L["Singing Sockets"] = true
L["Adds a Singing sockets selection tool on the Socketing Frame."] = true
L["Pet Filter Tab"] = true
L["Adds a filter tab to the Pet Journal, which allows you to filter pets by their type."] = true

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
L["FACTION"] = "Faction"
L["Only Icons"] = true
L["Use the new style tooltip."] = "Use the new style tooltip."
L["Display in English"] = "Display in English"
L["Show icon"] = "Show icon"
L["Show the spell icon along with the name."] = "Show the spell icon along with the name."
L["Show the rank of shards."] = true
L["Pet Battle"] = true
L["Tooltip Icons"] = true
L["Pet Icon"] = true
L["Pet ID"] = true
L["Add an icon for indicating the type of the pet."] = true
L["Show battle pet species ID in tooltips."] = true
L["The modifer key to show additional information from %s."] = true
L["Display TargetTarget"] = true
L["Gradient Color"] = true
L["Colors the player names in a gradient instead of class color"] = true
L["Health Bar Y-Offset"] = true
L["Change the postion of the health bar."] = true
L["Health Text Y-Offset"] = true
L["Change the postion of the health text."] = true
L["Class Icon Style"] = true
L["Reference"] = true
L["Preview"] = true
L["Template"] = true
L["Please click the button below to read reference."] = true
L["Spec Icon"] = true
L["Show the icon of the specialization."] = true
L["Race Icon"] = true
L["Show the icon of the player race."] = true
L["Health Bar"] = true
L["Group Info"] = true

-- Notification
L["Notification"] = true
L["Display a Toast Frame for different notifications."] = true
L["This is an example of a notification."] = true
L["Notification Mover"] = true
L["%s slot needs to repair, current durability is %d."] = true
L["You have %s pending calendar invite(s)."] = true
L["You have %s pending guild event(s)."] = true
L['Event "%s" will end today.'] = true
L['Event "%s" started today.'] = true
L['Event "%s" is ongoing.'] = true
L['Event "%s" will end tomorrow.'] = true
L["Here you can enable/disable the different notification types."] = true
L["Enable Mail"] = true
L["Enable Vignette"] = true
L["If a Rare Mob or a treasure gets spotted on the minimap."] = true
L["Enable Invites"] = true
L["Enable Guild Events"] = true
L["No Sounds"] = true
L["Vignette Print"] = true
L["Prints a clickable Link with Coords in the Chat."] = true
L["Quick Join"] = true
L["Title Font"] = true
L["Text Font"] = true
L["Debug Print"] = true
L["Enable this option to get a chat print of the Name and ID from the Vignettes on the Minimap"] = true

-- DataTexts
L["|cffFFFFFFLeft Click:|r Open Character Frame"] = true
L["|cffFFFFFFRight Click:|r Summon Grand Expedition Yak"] = true

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

-- Armory
L["Armory"] = true
L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."] = true
L["Enchant & Socket Strings"] = true
L["Settings for strings displaying enchant and socket info from the items"] = true
L["Enable/Disable the Enchant text display"] = true
L["Missing Enchants"] = true
L["Missing Sockets"] = true
L["Short Enchant Text"] = true
L["Enchant Font"] = true
L["Item Level"] = true
L["Settings for the Item Level next tor your item slot"] = true
L["Enable/Disable the Item Level text display"] = true
L["Toggle sockets & azerite traits"] = true
L["Item Quality Gradient"] = true
L["Settings for the color coming out of your item slot."] = true
L["Toggling this on enables the Item Quality bars."] = true
L["Start Alpha"] = true
L["End Alpha"] = true
L["Slot Item Level"] = true
L["Bags Item Level"] = true
L["Enabling this will show the maximum possible item level you can achieve with items currently in your bags."] = true
L["Format"] = true
L["Decimal format"] = true
L["Move Sockets"] = true
L["Crops and moves sockets above enchant text."] = true
L["Hide Controls"] = true
L["Hides the camera controls when hovering the character model."] = true
L["Add %d sockets"] = true
L["Add enchant"] = true
L["Attributes"] = true
L["Background"] = true
L["Alpha"] = true
L["Style"] = true
L["Change the Background image."] = true
L["Class Background"] = true
L["Use class specific backgrounds."] = true
L["Hide Controls"] = true
L["Hides the camera controls when hovering the character model."] = true
L["Animation"] = true
L["Animation Multiplier"] = true

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
L["Flasks"] = true
L["Food"] = true
L["Crafted by mage"] = true
L["Banners"] = true
L["Utilities"] = true
L["Custom Items"] = true
L["Fade Time"] = true
L["Alpha Min"] = true
L["Alpha Max"] = true
L["Inherit Global Fade"] = true
L["Anchor Point"] = true
L["The first button anchors itself to this point on the bar."] = true
L["Dream Seeds"] = true
L["Reset the button groups of this bar."] = true
L["Holiday Reward Boxes"] = true

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
L["Custom Texture"] = true
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

-- Maps
L["Maps"] = true
L["World Map"] = true
L["Duration"] = true
L["Fade Out"] = true
L["Scale"] = true
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
L["Middle Click To Clear"] = true
L["Middle click the waypoint to clear it."] = true
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
L["Right click to switch expansion"] = true
L["Add trackers for world events in the bottom of world map."] = true
L["Alert"] = true
L["Alert Second"] = true
L["Alert will be triggered when the remaining time is less than the set value."] = true
L["Community Feast"] = true
L["Cooking"] = true
L["Dragonbane Keep"] = true
L["Duration"] = true
L["Event Tracker"] = true
L["Feast"] = true
L["In Progress"] = true
L["Location"] = true
L["Siege On Dragonbane Keep"] = true
L["Status"] = true
L["Waiting"] = true
L["Weekly Reward"] = true
L["%s will be started in %s!"] = true
L["Next Event"] = true
L["Stop Alert if Completed"] = true
L["Stop alert when the event is completed in this week."] = true
L["Alert Sound"] = true
L["Play sound when the alert is triggered."] = true
L["Sound File"] = true
L["Only DF Character"] = true
L["Stop alert when the player have not entered Dragonlands yet."] = true
L["The offset of the frame from the bottom of world map. (Default is -3)"] = true
L["Alert Timeout"] = true
L["All nets can be collected"] = true
L["Can be collected"] = true
L["Can be set"] = true
L["Fishing Net"] = true
L["Fishing Nets"] = true
L["Iskaaran Fishing Net"] = true
L["Net #%d"] = true
L["Net %s can be collected"] = true
L["No Nets Set"] = true
L["Custom String"] = true
L["Custom Strings"] = true
L["Custom color can be used by adding the following code"] = true
L["Difficulty"] = true
L["M+ Level"] = true
L["Number of Players"] = true
L["Placeholders"] = true
L["Use Default"] = true
L["Researchers Under Fire"] = "Pesquisadores sob fogo"
L["Time Rift"] = "Fenda Temporal"
L["Superbloom"] = true
L["Big Dig"] = true
L["The Big Dig"] = true
L["Horizontal Spacing"] = true
L["Show a backdrop of the trackers."] = true
L["The Y-Offset of the backdrop."] = true
L["The height of the tracker."] = true
L["The spacing between the backdrop and the trackers."] = true
L["The spacing between the tracker and the world map."] = true
L["The spacing between trackers."] = true
L["The width of the tracker."] = true
L["Vertical Spacing"] = true
L["Click to show location"] = true
L["Current Location"] = true
L["Echoes"] = true
L["Next Location"] = true
L["Radiant Echoes"] = true
L["Performing"] = true
L["Theater Troupe"] = true
L["Nightfall"] = true
L["Running"] = true
L["Khaz Algar Emissary"] = true
L["Professions Weekly"] = true
L["Ringing Deeps"] = true
L["Spreading The Light"] = true
L["Underworld Operative"] = true
L["World Soul"] = true
L["Rectangle Minimap"] = true
L["Expansion Landing Page"] = true
L["Instance Difficulty"] = true
L["Reskin the instance diffculty in text style."] = true
L["Text Align"] = true
L["Hide Blizzard Indicator"] = true
L["Left"] = true
L["Center"] = true
L["Right"] = true
L["Minimap Coords"] = true
L["Add coords to your Minimap."] = true

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
L["floatingCombatTextCombatDamageDirectionalScale_DESC"] =
	"Directional damage numbers movement scale (disable = no directional numbers\r\rDefault: |cff00ff001|r"

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
L["|cffFF0000NOTE:|r This will overwrite the ElvUI Nameplate options for Buff/Debuffs width/height. The CC-Buffs are hardcoded to a size of: 32 x 32"] =
	true

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
L["By pressing the Continue button, MerathilisUI will be applied in your current ElvUI installation.\r\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"] =
	true
L["Buttons must be clicked twice"] = true
L["Importance: |cffff0000Very High|r"] = true
L["The AddOn 'AddOnSkins' is not enabled. No settings have been changed."] = true
L["The Addon 'Big Wigs' is not enabled. Profile not created."] = true
L["The AddOn 'ElvUI_BenikUI' is not enabled. No settings have been changed."] = true
L["The AddOn 'ElvUI_SLE' is not enabled. No settings have been changed."] = true
L["The Addon 'Skada' is not enabled. Profile not created."] = true
L["This part of the installation process sets up your chat fonts and colors."] = true
L["This part of the installation changes the default ElvUI look."] = true
L["This part of the installation process will fill MerathilisUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"] =
	true
L["This part of the installation process will reposition your Actionbars and will enable backdrops"] = true
L["This part of the installation process will change your NamePlates."] = true
L["This part of the installation process will reposition your Unitframes."] = true
L["This part of the installation process will apply changes to ElvUI Plugins"] = true
L["This step changes a few World of Warcraft default options. These options are tailored to the needs of the author of %s and are not necessary for this edit to function."] =
	true
L["Please click the button below to apply the new layout."] = true
L["Please click the button below to setup your chat windows."] = true
L["Please click the button below to setup your actionbars."] = true
L["Please click the button below to setup your datatexts."] = true
L["Please click the button below to setup your NamePlates."] = true
L["Please click the button below to setup your Unitframes."] = true
L["Please click the button below to setup the ElvUI AddOns. For other Addon profiles please go in my Options - Skins/AddOns"] =
	true
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
L["MSG_MER_ELV_OUTDATED"] =
	"Your version of ElvUI is older than recommended to use with |cffff7d0aMerathilisUI|r. Your version is |cff00c0fa%.2f|r (recommended is |cff00c0fa%.2f|r). Please update your ElvUI to avoid errors."
L["MSG_MER_ELV_MISMATCH"] =
	"Your ElvUI version is higher than expected. Please update MerathilisUI or you might run into issues or |cffFF0000having it already|r."
L["You have got Location Plus and Shadow & Light both enabled at the same time. Select an addon to disable."] = true
L["MUI_INSTALL_SETTINGS_LAYOUT_SLE"] = [[Here you can choose the layout for S&L.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_BW"] = [[Here you can choose the layout for BigWigs.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_DBM"] = [[Here you can choose the layout for Deadly Boss Mods.]]
L["MER_INSTALL_SETTINGS_LAYOUT_DETAILS"] = [[Here you can choose the layout for Details.]]
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
L["%s is not loaded."] = true
L["BigWigs Bars"] = true
L["BigWigs Skin"] = true
L["Color Override"] = true
L["Emphasized Bar"] = true
L["Gradient color of the left part of the bar."] = true
L["Gradient color of the right part of the bar."] = true
L["How to change BigWigs bar style:"] = true
L["Left Color"] = true
L["Normal Bar"] = true
L["Open BigWigs Options UI with /bw > Bars > Style."] = true
L["Override the bar color."] = true
L["Right Color"] = true
L["Show spark on the bar."] = true
L["Smooth"] = true
L["Smooth the bar animation with ElvUI."] = true
L["Spark"] = true
L["The options below are only for BigWigs %s bar style."] = true
L["You need to manually set the bar style to %s in BigWigs first."] = true
L["The options below is only for the Details look, NOT the Embeded."] = true
L["Action Status"] = true
L["Roll Result"] = true
L["It only works when you enable the skin (%s)."] = true
L["Loot"] = true
L["Embed Settings"] = true
L["With this option you can embed your Details into an own Panel."] = true
L["Reset Settings"] = true
L["Toggle Direction"] = true
L["TOP"] = true
L["BOTTOM"] = true
L["Advanced Skin Settings"] = true
L["Queue Timer"] = true
L["Gradient Bars"] = true
L["Open Details"] = true
L["Ease"] = true
L["Generally, enabling this option makes the value increase faster in the first half of the animation."] = true
L["Invert Ease"] = true
L["The easing function used for colorize the button."] = true
L["UI Widget"] = true

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
L["Menu Title"] = true
L["it shows when objective tracker is collapsed."] = true

-- Quest
L["Switch Buttons"] = true
L["Add a bar that contains buttons to enable/disable modules quickly."] = true
L["Hide With Objective Tracker"] = true
L["Bar Backdrop"] = true
L["Announcement"] = true
L["Quest"] = true
L["Turn In"] = true
L["Make quest acceptance and completion automatically."] = true
L["Mode"] = true
L["Only Accept"] = true
L["Only Complete"] = true
L["Pause On Press"] = true
L["Pause the automation by pressing a modifier key."] = true
L["Reward"] = true
L["Select Reward"] = true
L["If there are multiple items in the reward list, it will select the reward with the highest sell price."] = true
L["Get Best Reward"] = true
L["Complete the quest with the most valuable reward."] = true
L["Smart Chat"] = true
L["Chat with NPCs smartly. It will automatically select the best option for you."] = true
L["Dark Moon"] = true
L["Accept the teleportation from Darkmoon Faire Mystic Mage automatically."] = true
L["Follower Assignees"] = true
L["Open the window of follower recruit automatically."] = true
L["Ignored NPCs"] = true
L["If you add the NPC into the list, all automation will do not work for it."] = true
L["Ignore List"] = true
L["Add Target"] = true
L["Make sure you select the NPC as your target."] = true
L["Delete"] = true
L["Delete the selected NPC."] = true

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
L["Level"] = true
L["Hide Max Level"] = true
L["Use Note As Name"] = true
L["Replace the Real ID or the character name of friends with your notes."] = true
L["Use Game Color"] = true
L["Change the color of the name to the in-playing game style."] = true
L["Use Class Color"] = true
L["Font Setting"] = true
L["Hide Realm"] = true
L["Hide the realm name of friends."] = true

-- Vehicle Bar
L["VehicleBar"] = true
L["Change the Vehicle Bar's Button width. The height will scale accordingly in a 4:3 aspect ratio."] = true
L["Thrill Color"] = true
L["The color for vigor bar's speed text when you are regaining vigor."] = true
L["Animations"] = true
L["Animation Speed"] = true
L["Skyriding Bar"] = true

-- Delete Item
L["Delete Item"] = true
L["This module provides several easy-to-use methods of deleting items."] = true
L["Use Delete Key"] = true
L["Allow you to use Delete Key for confirming deleting."] = true
L["Fill In"] = true
L["Disable"] = true
L["Fill by click"] = true
L["Auto Fill"] = true
L["Press the |cffffd200Delete|r key as confirmation."] = true
L["Click to confirm"] = true

-- Raid Info Frame
L["Raid Info Frame"] = true
L[" provides a Raid Info Frame that shows a list of players per role in your raid."] = true
L["Enable the Raid Info Frame."] = true
L["Temporarily shows the frame even outside of a raid for easier customization."] = true
L["Customization"] = true
L["Set the size of the text and icons."] = true
L["Padding"] = true
L["Set the outside padding of the frame."] = true
L["Set the spacing between the icons."] = true
L["Set the backdrop color of the frame."] = true
L["Change the look of the icons"] = true
L["Displays the current count of Tanks, Healers, and DPS in your raid group."] = true
L["|cffFFFFFFLeft Click:|r Toggle Raid Frame"] = true
L["|cffFFFFFFRight Click:|r Toggle Settings"] = true

-- Profiles
L["MER_PROFILE_DESC"] = [[This section creates Profiles for some AddOns.

|cffff0000WARNING:|r It will overwrite/delete existing Profiles. If you don't want to apply my Profiles please don't press the Buttons below.]]
L[" Apply"] = true
L[" Reset"] = true
L["This group allows to update all fonts used in the "] = true
L["WARNING: Some fonts might still not look ideal! The results will not be ideal, but it should help you customize the fonts :)\n"] =
	true
L["Applies all |cffffffffMerathilis|r|cffff7d0aUI|r font settings."] = true
L["Resets all |cffffffffMerathilis|r|cffff7d0aUI|r font settings."] = true

-- Advanced Settings
L["Advanced Settings"] = true
L["Blizzard Fixes"] = true
L["The message will be shown in chat when you login."] = true
L["CVar Alert"] = true
L["It will alert you to reload UI when you change the CVar %s."] = true
L["Fix LFG Frame error"] = true
L["Fix a PlayerStyle lua error that can happen on the LFG Frame."] = true
L["This section will help reset specfic settings back to default."] = true

-- Gradient colors
L["Custom Gradient Colors"] = true
L["Custom Nameplates Colors"] = true
L["Only used if using threat plates from ElvUI"] = true
L["Custom Unitframes Colors"] = true
L["Custom Power Colors"] = true
L["Runic Power"] = true

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
L["There are many modules from different addons or ElvUI plugins, but several of them are almost the same functionality."] =
	true
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

-- Abbreviate
L["[ABBR] Algeth'ar Academy"] = "AA"
L["[ABBR] Announcement"] = "ANN"
L["[ABBR] Back"] = "Back"
L["[ABBR] Challenge Level 1"] = "CL1"
L["[ABBR] Chest"] = "Chest"
L["[ABBR] Community"] = "C"
L["[ABBR] Court of Stars"] = "CoS"
L["[ABBR] Delves"] = "Delves"
L["[ABBR] Dragonflight Keystone Hero: Season One"] = "Keystone Hero S1"
L["[ABBR] Dragonflight Keystone Master: Season One"] = "Keystone Master S1"
L["[ABBR] Emote"] = "E"
L["[ABBR] Event Scenario"] = "EScen"
L["[ABBR] Feet"] = "Feet"
L["[ABBR] Finger"] = "Finger"
L["[ABBR] Follower"] = "Follower"
L["[ABBR] Guild"] = "G"
L["[ABBR] Halls of Valor"] = "HoV"
L["[ABBR] Hands"] = "Hands"
L["[ABBR] Head"] = "Head"
L["[ABBR] Held In Off-hand"] = "Off-hand"
L["[ABBR] Heroic"] = "H"
L["[ABBR] Instance"] = "I"
L["[ABBR] Instance Leader"] = "IL"
L["[ABBR] Legs"] = "Legs"
L["[ABBR] Looking for Raid"] = "LFR"
L["[ABBR] Mythic"] = "M"
L["[ABBR] Mythic Keystone"] = "M+"
L["[ABBR] Neck"] = "Neck"
L["[ABBR] Normal"] = "N"
L["[ABBR] Normal Scaling Party"] = "NSP"
L["[ABBR] Officer"] = "O"
L["[ABBR] Party"] = "P"
L["[ABBR] Party Leader"] = "PL"
L["[ABBR] Path of Ascension"] = "PoA"
L["[ABBR] Quest"] = "Quest"
L["[ABBR] Raid"] = "R"
L["[ABBR] Raid Finder"] = "RF"
L["[ABBR] Raid Leader"] = "RL"
L["[ABBR] Raid Warning"] = "RW"
L["[ABBR] Roll"] = "RL"
L["[ABBR] Ruby Life Pools"] = "RLP"
L["[ABBR] Say"] = "S"
L["[ABBR] Scenario"] = "Scen"
L["[ABBR] Shadowmoon Burial Grounds"] = "SBG"
L["[ABBR] Shoulders"] = "Shoulders"
L["[ABBR] Story"] = "Story"
L["[ABBR] Lorewalking"] = "LW"
L["[ABBR] Teeming Island"] = "Teeming"
L["[ABBR] Temple of the Jade Serpent"] = "TotJS"
L["[ABBR] The Azure Vault"] = "AV"
L["[ABBR] The Nokhud Offensive"] = "NO"
L["[ABBR] Timewalking"] = "TW"
L["[ABBR] Torghast"] = "Torghast"
L["[ABBR] Trinket"] = "Trinket"
L["[ABBR] Turn In"] = "TURNIN"
L["[ABBR] Vault of the Incarnates"] = "VotI"
L["[ABBR] Visions of N'Zoth"] = "Visions"
L["[ABBR] Waist"] = "Waist"
L["[ABBR] Warfronts"] = "WF"
L["[ABBR] Whisper"] = "Whispers"
L["[ABBR] Wind Emote"] = "WE"
L["[ABBR] World"] = "W"
L["[ABBR] World Boss"] = "WB"
L["[ABBR] Wrist"] = "Wrist"
L["[ABBR] Yell"] = "Y"
