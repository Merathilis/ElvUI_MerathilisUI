-- English localization file for enUS
local AceLocale = LibStub:GetLibrary('AceLocale-3.0');
local L = AceLocale:NewLocale('ElvUI', 'enUS');
if not L then return; end

-- Core
L[' is loaded.'] = true

-- General Options
L['Plugin for |cff1784d1ElvUI|r by\nMerathilis.'] = true
L['by Merathilis (EU-Shattrath)'] = true
L['MerathilisUI is an external ElvUI mod. Mostly it changes the Look of your UI. It is high recommended that you download |cff00c0faElvUI BenikUI|r to get the whole Style.\n\nNew Function are marked with:'] = true
L['AFK'] = true
L['Enable/Disable the MUI AFK Screen'] = true
L['SplashScreen'] = true
L['Enable/Disable the Splash Screen on Login.'] = true
L['Options'] = true
-- LoginMessage
L['Enable/Disable the Login Message in Chat'] = true

-- Chat
L['CHAT_AFK'] = "[AFK]"
L['CHAT_DND'] = "[DND]"
L["has come |cff298F00online|r."] = true
L["has gone |cffff0000offline|r."] = true
L["Unknown"] = true

-- Information
L['Information'] = true
L['Support & Downloads'] = true
L['Tukui.org'] = true
L['Git Ticket tracker'] = true
L['Curse.com'] = true
L['Coding'] = true
L['Testing & Inspiration'] = true
L['My other Addon'] = true
L['ElvUI Tooltip Icon'] = true
L['Adds an Icon for Spells, Items and Achievements (only GameTooltip) to the Tooltip.'] = true

-- Minimap blip
L['Minimap Blip'] = true
L['Replaces the default minimap blips with custom textures.'] = true

-- GameMenu
L['GameMenu'] = true
L['Enable/Disable the MerathilisUI Style from the Blizzard GameMenu.'] = true

-- FlightMode
L['FlightMode'] = true
L['Enable/Disable the MerathilisUI FlightMode.\nTo completely disable the FlightMode go into the |cff00c0faBenikUI|r Options.'] = true

-- moveBlizz
L['moveBlizz'] = true
L['Make some Blizzard Frames movable.'] = true

-- MasterPlan
L['MasterPlan'] = true
L['Skins the additional Tabs from MasterPlan.'] = true
L['Misc'] = true

-- TooltipIcon
L['Tooltip Icon'] = true
L['Adds an Icon for Items/Spells/Achievement on the Tooltip'] = true

-- GarrisonAlertFrame
L['Garrison Alert Frame'] = true
L['Hides the Garrison Alert Frame while in combat.'] = true

-- MailInputBox
L['Mail Inputbox Resize'] = true
L['Resize the Mail Inputbox and move the shipping cost to the Bottom'] = true

-- Friend Alert
L['Battle.net Alert'] = true
L['Shows a Chat notification if a Battle.net Friend switch Games or goes offline.'] = true
L["%s stopped playing (%sIn Battle.net)."] = true
L["%s is now playing (%s%s)."] = true

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

-- Reminder
L["Add Group"] = true
L["Attempted to show a reminder icon that does not have any spells. You must add a spell first."] = true
L["Change this if you want the Reminder module to check for weapon enchants, setting this will cause it to ignore any spells listed."] = true
L["Combat"] = true
L["Disable Sound"] = true
L["Don't play the warning sound."] = true
L["Group already exists!"] = true
L["If any spell found inside this list is found the icon will hide as well"] = true
L["Inside BG/Arena"] = true
L["Inside Raid/Party"] = true
L["Instead of hiding the frame when you have the buff, show the frame when you have the buff."] = true
L["Level Requirement"] = true
L["Level requirement for the icon to be able to display. 0 for disabled."] = true
L["Negate Spells"] = true
L["New ID (Negate)"] = true
L["Only run checks during combat."] = true
L["Only run checks inside BG/Arena instances."] = true
L["Only run checks inside raid/party instances."] = true
L["REMINDER_DESC"] = "This module will show warning icons on your screen when you are missing buffs or have buffs when you shouldn't."
L["Remove ID (Negate)"] = true
L["Reverse Check"] = true
L["Set a talent tree to not follow the reverse check."] = true
L["Sound"] = true
L["Sound that will play when you have a warning icon displayed."] = true
L["Spell"] = true
L["Strict Filter"] = true
L["Talent Tree"] = true
L["This ensures you can only see spells that you actually know. You may want to uncheck this option if you are trying to monitor a spell that is not directly clickable out of your spellbook."] = true
L["Tree Exception"] = true
L["Weapon"] = true
L["You can't remove a default group from the list, disabling the group."] = true
L["You must be a certain role for the icon to appear."] = true
L["You must be using a certain talent tree for the icon to show."] = true
L['CD Fade'] = true
L["Cooldown"] = true
L['On Cooldown'] = true
L['Reminders'] = true
L['Remove Group'] = true
L['Select Group'] = true
L['Role'] = true
L['Caster'] = true
L['Any'] = true
L['Personal Buffs'] = true
L['Only check if the buff is coming from you.'] = true
L['Spells'] = true
L['New ID'] = true
L['Remove ID'] = true

-- Unitframes
L["Default"] = true
L["Red Icon"] = true

-- Install
L['Welcome'] = true
L['MerathilisUI Set'] = true
L[' - %s profile created!'] = true
L['Actionbars Set'] = true
L['Addons Set'] = true
L['DataTexts Set'] = true
L['Unitframes Set'] = true
L['Welcome to MerathilisUI |cff00c0faVersion|r %s, for ElvUI %s.'] = true
L["By pressing the Continue button, MerathilisUI will be applied in your current ElvUI installation.\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"] = true
L['Layout'] = true
L['Buttons must be clicked twice'] = true
L['This part of the installation process sets up your chat fonts and colors.'] = true
L['This part of the installation changes the default ElvUI look.'] = true
L["This part of the installation process will fill MerathilisUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"] = true
L['This part of the installation process will reposition your Actionbars and will enable backdrops'] = true
L['This part of the installation process will reposition your Unitframes.'] = true
L['This part of the installation process will apply changes to Skada and ElvUI plugins'] = true
L['Please click the button below to apply the new layout.'] = true
L['Please click the button below to setup your chat windows.'] = true
L['Please click the button below to setup your actionbars.'] = true
L['Please click the button below to setup your datatexts.'] = true
L['Please click the button below to setup your Unitframes.'] = true
L['Please click the button below to setup your addons.'] = true
L['Setup ActionBars'] = true
L['Setup Unitframes'] = true
L['DataTexts'] = true
L['Setup Addons'] = true
L['Finish'] = true
L['Installed'] = true

-- Staticpopup
L["To get the whole MerathilisUI functionality and look it's recommended that you download |cff00c0faElvUI_BenikUI|r!"] = true
L["MSG_MER_ELV_OUTDATED"] = "Your version of ElvUI is older than recommended to use with |cffff7d0aMerathilisUI|r. Your version is |cff00c0fa%.2f|r (recommended is |cff00c0fa%.2f|r). MerathilisUI isn't loaded. Please update your ElvUI."

-- Addons
L["BigWigs"] = true
L["MasterPlan"] = true
L["Shadow & Light"] = true
