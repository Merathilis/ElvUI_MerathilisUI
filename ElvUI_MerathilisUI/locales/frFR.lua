-- French localization file for frFR.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("ElvUI", "frFR");
if not L then return; end

-- Core
L[" is loaded."] = true

-- General Options
L["Plugin for |cff1784d1ElvUI|r by\nMerathilis."] = true
L["by Merathilis (EU-Shattrath)"] = true
L["MerathilisUI is an external ElvUI mod. Mostly it changes the Look of your UI. It is high recommended that you download |cff00c0faElvUI BenikUI|r to get the whole Style.\n\nNew Function are marked with:"] = true
L["AFK"] = true
L["Enable/Disable the MUI AFK Screen"] = true
L["SplashScreen"] = true
L["Enable/Disable the Splash Screen on Login."] = true
L["Options"] = true
L["Combat State"] = true
L["Enable/Disable the '+'/'-' combat message if you enter/leave the combat."] = true

-- LoginMessage
L["Enable/Disable the Login Message in Chat"] = true

-- Chat
L["CHAT_AFK"] = "[AFK]"
L["CHAT_DND"] = "[DND]"
L["has come |cff298F00online|r."] = true
L["has gone |cffff0000offline|r."] = true
L["Unknown"] = true

-- Information
L["Information"] = true
L["Support & Downloads"] = true
L["Tukui.org"] = true
L["Git Ticket tracker"] = true
L["Curse.com"] = true
L["Coding"] = true
L["Testing & Inspiration"] = true
L["My other Addon"] = true
L["ElvUI Tooltip Icon"] = true
L["Adds an Icon for Spells, Items and Achievements (only GameTooltip) to the Tooltip."] = true

-- GameMenu
L["GameMenu"] = true
L["Enable/Disable the MerathilisUI Style from the Blizzard GameMenu."] = true

-- FlightMode
L["FlightMode"] = true
L["Enable/Disable the MerathilisUI FlightMode.\nTo completely disable the FlightMode go into the |cff00c0faBenikUI|r Options."] = true

-- moveBlizz
L["moveBlizz"] = true
L["Make some Blizzard Frames movable."] = true

-- MasterPlan
L["MasterPlan"] = true
L["Skins the additional Tabs from MasterPlan."] = true
L["Misc"] = true

-- Misc
L["Artifact Power"] = true
L["Vignette"] = true
L["Display a RaidWarning if a Rar/Treasures are spotted on the minimap."] = true
L[" spotted!"] = true
L["Alt-click, to buy an stack"] = true

-- Tooltip
L["Adds an Icon for Items/Spells/Achievement on the Tooltip and show the Achievement Progress."] = true
L["Tooltip"] = true
L["Your Status:"] = true
L["Your Status: Incomplete"] = true
L["Your Status: Completed on "] = true

-- MailInputBox
L["Mail Inputbox Resize"] = true
L["Resize the Mail Inputbox and move the shipping cost to the Bottom"] = true

-- Tradeskill Tabs
L["TradeSkill Tabs"] = true
L["Add tabs for professions on the TradeSkill Frame."] = true

-- DataTexts
L["ChatTab_Datatext_Panel"] = "Right Chat Tab Datatext Panel"
L["Enable/Disable the right chat tab datatext panel."] = true

-- System Datatext
L["(Hold Shift) Memory Usage"] = true
L["Announce Freed"] = true
L["Announce how much memory was freed by the garbage collection."] = true
L["Bandwidth"] = true
L["Display world or home latency on the datatext. Home latency refers to your realm server. World latency refers to the current world server."] = true
L["Download"] = true
L["FPS"] = true
L["Garbage Collect"] = true
L["Garbage Collection Freed"] = true
L["Home"] = true
L["Home Latency:"] = true
L["Latency Type"] = true
L["Left Click:"] = true
L["Loaded Addons:"] = true
L["MS"] = true
L["Max Addons"] = true
L["Maximum number of addons to show in the tooltip."] = true
L["Reload UI"] = true
L["Right Click:"] = true
L["Show FPS"] = true
L["Show FPS on the datatext."] = true
L["Show Latency"] = true
L["Show Memory"] = true
L["Show latency on the datatext."] = true
L["Show total addon memory on the datatext."] = true
L["System Datatext"] = true
L["Total Addons:"] = true
L["Total CPU:"] = true
L["Total Memory:"] = true
L["World"] = true
L["World Latency:"] = true

-- Unitframes
L["Red Icon"] = true
L["Group Info"] = true
L["Shows an extra frame with information about the party/raid."] = true
L[" alive"] = true

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
L["Show the name on location your Heathstone is bound to."] = true
L["Combat Hide"] = true
L["Show/Hide all panels when in combat"] = true

--Raid Marks
L["Raid Markers"] = true
L["Click to clear the mark."] = true
L["Click to mark the target."] = true
L["%sClick to remove all worldmarkers."] = true
L["%sClick to place a worldmarker."] = true
L["Raid Marker Bar"] = true
L["Options for panels providing fast access to raid markers and flares."] = true
L["Show/Hide raid marks."] = true
L["Reverse"] = true
L["Modifier Key"] = true
L["Set the modifier key for placing world markers."] = true
L["Visibility State"] = true

-- GMOTD
L["Display the Guild Message of the Day in an extra window, if updated."] = true

-- Install
L["Welcome"] = true
L["|cffff7d0aMerathilisUI|r Installation"] = true
L["MerathilisUI Set"] = true
L["MerathilisUI didn't find any supported addons for profile creation"] = true
L["MerathilisUI successfully created and applied profile(s) for:"] = true
L["Chat Set"] = true
L["ActionBars Set"] = true
L["DataTexts Set"] = true
L["ElvUI AddOns settings applied."] = true
L["AddOnSkins is not enabled, aborting."] = true
L["AddOnSkins settings applied."] = true
L["BigWigs is not enabled, aborting."] = true
L["BigWigs Profile Created"] = true
L["Skada Profile Created"] = true
L["Skada is not enabled, aborting."] = true
L["UnitFrames Set"] = true
L["Welcome to MerathilisUI |cff00c0faVersion|r %s, for ElvUI %s."] = true
L["By pressing the Continue button, MerathilisUI will be applied in your current ElvUI installation.\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"] = true
L["Buttons must be clicked twice"] = true
L["The AddOn 'AddOnSkins' is not enabled. No settings have been changed."] = true
L["The Addon 'Big Wigs' is not enabled. Profile not created."] = true
L["The AddOn 'ElvUI_BenikUI' is not enabled. No settings have been changed."] = true
L["The AddOn 'ElvUI_SLE' is not enabled. No settings have been changed."] = true
L["The Addon 'Skada' is not enabled. Profile not created."] = true
L["This part of the installation process sets up your chat fonts and colors."] = true
L["This part of the installation changes the default ElvUI look."] = true
L["This part of the installation process will fill MerathilisUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"] = true
L["This part of the installation process will reposition your Actionbars and will enable backdrops"] = true
L["This part of the installation process will reposition your Unitframes."] = true
L["This part of the installation process will apply changes to the addons like Skada and ElvUI plugins"] = true
L["This step changes a few World of Warcraft default options. These options are tailored to the needs of the author of %s and are not necessary for this edit to function."] = true
L["Please click the button below to apply the new layout."] = true
L["Please click the button below to setup your chat windows."] = true
L["Please click the button below |cff07D400twice|r to setup your actionbars."] = true
L["Please click the button below to setup your datatexts."] = true
L["Please click the button below |cff07D400twice|r to setup your Unitframes."] = true
L["Please click the button below to setup your addons."] = true
L["DataTexts"] = true
L["Setup Datatexts"] = true
L["Setup Addons"] = true
L["Finish"] = true
L["Installed"] = true

-- Staticpopup
L["To get the whole MerathilisUI functionality and look it's recommended that you download |cff00c0faElvUI_BenikUI|r!"] = true
L["MSG_MER_ELV_OUTDATED"] = "Your version of ElvUI is older than recommended to use with |cffff7d0aMerathilisUI|r. Your version is |cff00c0fa%.2f|r (recommended is |cff00c0fa%.2f|r). MerathilisUI isn't loaded. Please update your ElvUI."
L["You have got Location Plus and Shadow & Light both enabled at the same time. Select an addon to disable."] = true

-- Skins
L["MER_SKINS_DESC"] = [[This section is designed to enhance skins existing in ElvUI.

Please note that some of these options will not be available if corresponding skin is |cff636363disabled|r in main ElvUI skins section.]]
L["Create a transparent backdrop around the header."] = true

-- Addons
L["Skins/AddOns"] = true
L["Profiles"] = true
L["BigWigs"] = true
L["MasterPlan"] = true
L["Shadow & Light"] = true
L["This will create and apply profile for "] = true

-- Changelog
L["Changelog"] = true

-- Errors
L["Info"] = {
	["Errors"] = "Pas encore d'erreur.",
}

-- Developer
L["AddOn Presets"] = true
L["Choose an AddOn Presets, where selected AddOns gets loaded."] = true
L["Choose a Preset!"] = true
L["Choose this Preset?"] = true
L["Default"] = true
L["ElvUI Only"] = true
L["Instance"] = true