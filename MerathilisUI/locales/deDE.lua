-- German localization file for deDE
local AceLocale = LibStub:GetLibrary('AceLocale-3.0');
local L = AceLocale:NewLocale('ElvUI', 'deDE');
if not L then return; end

-- Core
L[' is loaded.'] = " ist geladen."

-- General Options
L['by Merathilis (EU-Shattrath)'] = "von Merathilis (EU-Shattrath)"
L['MerathilisUI is an external ElvUI mod. Mostly it changes the Look of your UI. It is high recommended that you download |cff00c0faElvUI BenikUI|r to get the whole Style.'] = "MerathilisUI ist ein externer ElvUI Mod. Es ändert hauptsächlich nur den Look von eurem UI. Um den kompletten Style zu erreichen wird empfohlen |cff00c0faElvUI BenikUI|r herrunter zu laden."
L[' Benik, Blazeflack, Azilroka, Elv and all other AddOn Authors who inspired me.'] = " Benik, Blazeflack, Azilroka, Elv und allen anderen AddOn-Autoren die mich inspiriert haben."
--L['Install'] = true -- translated in ElvUI
--L['Run the installation process.'] = true -- translated in ElvUI
--L['General'] = true -- translated in ElvUI
--L['Bags'] = true -- translated in ElvUI
L['Enable/Disable the forcing of the Bag/Bank Frame position.'] = "Aktiviert/Deaktiviert das Erzwingen der Taschen/Bank Position"
L['CHAT_AFK'] = "[AFK]"
L['CHAT_DND'] = "[DND]"
L['WATCH_WOWHEAD_LINK'] = "Wowhead Link"
-- LoginMessage
--L['Login Message'] = true -- translated in ElvUI
L['Enable/Disable the Login Message in Chat'] = "Aktiviert/Deaktiviert die Login Nachricht im Chat"
-- GameMenu
L['GameMenu'] = "Spielmenü"
L['Enable/Disable the MerathilisUI Style from the Blizzard GameMenu.'] = "Aktiviert/Deaktiviert den MerathilisUI Style aus dem Blizzard Spielmenü."
-- MasterPlan
L['MasterPlan'] = true
L['Skins the additional Tabs from MasterPlan.'] = "Skint die zusätzlichen Tabs von MasterPlan."

L['Misc'] = "Verschiedenes"
-- Screenshot
L['Screenshot'] = "Bildschirmfoto"
L['Takes an automatic Screenshot on Achievement earned.'] = "Macht ein automatisches Bildschirmfoto, wenn ein Erfolg erreicht wird."
-- TooltipIcon
L['Tooltip Icon'] = true
L['Adds an Icon for Items/Spells/Achievement on the Tooltip'] = "Fügt ein Symbol für Gegenstände/Zauber/Erfolge am Tooltip hinzu"
-- GarrisonAlertFrame
L['Garrison Alert Frame'] = "Garnision Alarm Fenster"
L['Hides the Garrison Alert Frame while in combat.'] = "Versteckt das Garnision Alarm Fenster während des Kampfes."
-- MailInputBox
L['Mail Inputbox Resize'] = "Post Eingabefeld"
L['Resize the Mail Inputbox and move the shipping cost to the Bottom'] = "Verändert die Größe des Post Eingabefeldes und verschiebt die Versandkosten."
-- Decline Duel
L['INFO_DUEL'] = "Duellanfrage Ignoriert von "
L['INFO_PET_DUEL'] = "Haustier Duellanfrage Ignoriert von "
L['No Duel'] = "Kein Duel"
-- Quest
L['Quest'] = true
L['Skins the Questtracker to fit the MerathilisUI Sytle'] = "Passt den Questtracker vom Aussehen für MerathilisUI an"
-- QuickArmoryLink
L['ARMORYQUICKLINK'] = "Armory QuickLink"
L['AQLCOLORLABEL'] = "|CFFCC33FFArmory QuickLink|r: "
L['REALMERROR'] = "Couldn't find realm list!"
L['SERVERERROR'] = "Couldn't find server!"
L['NOTSUPPORTEDLIST'] = " is not a supported Realm List."
L['LANGUAGE'] = "de"
-- Friend Alert
L['Battle.net Alert'] = "Battle.net Alarm"
L['Shows a Chat notification if a Battle.net Friend switch Games or goes offline.'] = "Zeigt eine Chatbenachrichtigung wenn ein Battle.net Freund ein Spiel wechselt oder offline geht."
L["%s stopped playing (%sIn Battle.net)."] = "%s spielt nicht mehr (%sIn Battle.net)."
L["%s is now playing (%s%s)."] = "%s spielt jetzt (%s%s)"

-- Install
L['Welcome'] = "Willkommen"
L['MerathilisUI Set'] = "MerathilisUI gesetzt"
L[' - %s profile created!'] = " - %s Profil erstellt!"
L['Addons Set'] = "Addons gesetzt"
L['DataTexts Set'] = "Infotexte gesetzt"
L['Welcome to MerathilisUI |cff00c0faVersion|r %s, for ElvUI %s.'] = "Willkommen zu MerathilisUI |cff00c0faVersion|r %s für ElvUI %s."
L["By pressing the Continue button, MerathilisUI will be applied in your current ElvUI installation.\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"] = "Durch drücken der Weiter-Taste werden die MerathilisUI Änderungen in der vorhandenen ElvUI Installation angewand.\r|cffff8000 TIP: Es wäre gut, wenn Du die Änderungen in einem neuen Profil erstellst. Nur für den Fall dass Du mit den Änderungen nicht zufrieden bist.|r"
--L['Please press the continue button to go onto the next step.'] = true -- translated in ElvUI
L['Layout'] = true
L['This part of the installation changes the default ElvUI look.'] = "Dieser Teil der Installation ändert das standard Aussehen von ElvUI."
L['Please click the button below to apply the new layout.'] = "Bitte drücke unten die Taste unten, um das neue Layout anzuwenden."
--L['Importance: |cff07D400High|r'] = true -- translated in ElvUI
L['DPS Layout'] = "DPS Layout"
L['Heal Layout'] = "Heiler Layout"
L['DataTexts'] = "Infotexte"
L["This part of the installation process will fill MerathilisUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"] = "Diese Einstellungen füllt die Infotexte.\r|cffff8000Die Einstellungen der Infotexte von ElvUI wird nicht verändert|r"
L['Please click the button below to setup your datatexts.'] = "Bitte drücke die Taste unten, um die Infotexte einzustellen."
--L['Importance: |cffD3CF00Medium|r'] = true -- translated in ElvUI
L['This part of the installation process will apply changes to the addons like Skada, BigWigs and ElvUI plugins'] = "Dieser Abschnitt wird Änderungen an den Addons, wie Skada, BigWigs und ElvUI Plugins"
L['Please click the button below to setup your addons.'] = "Bitte drücke die Taste unten, um die Addons einzustellen."
--L['Importance: |cffD3CF00Medium|r'] = true -- translated in ElvUI
L['Setup Addons'] = "Addons einstellen"
--L['Installation Complete'] = true -- translated in ElvUI
--L['You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org.'] = true -- translated in ElvUI
--L['Please click the button below so you can setup variables and ReloadUI.'] = true -- translated in ElvUI
L['Finish'] = "Fertig"
L['Installed'] = "Installiert"

-- Staticpopup
L["To get the whole MerathilisUI functionality and look it's recommended that you download |cff00c0faElvUI_BenikUI|r!"] = "Um alle Funktionen und das Aussehen von MerathilisUI zu erlangen, lade dir bitte |cff00c0faElvUI_BenikUI|r herrunter!"