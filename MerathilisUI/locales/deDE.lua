-- German localization file for deDE
local AceLocale = LibStub:GetLibrary('AceLocale-3.0');
local L = AceLocale:NewLocale('ElvUI', 'deDE');
if not L then return; end

-- Core
	L[' is loaded.'] = " ist geladen."
	
-- General Options
	L['by Merathilis (EU-Shattrath)'] = "von Merathilis (EU-Shattrath)"
	L['MerathilisUI is an external ElvUI mod. Mostly based on |cff00c0faElvUI BenikUI|r. '] = "MerathilisUI ist ein externer ElvUI Mod. Basierend auf |cff00c0faElvUI BenikUI|r."
	L[' Benik, Blazeflack, Azilroka, Elv and all other AddOn Authors who inspired me.'] = " Benik, Blazeflack, Azilroka, Elv und allen anderen AddOn-Autoren die mich inspiriert haben."
	--L['Install'] = true -- translated in ElvUI
	--L['Run the installation process.'] = true -- translated in ElvUI
	--L['General'] = true -- translated in ElvUI
	--L['Login Message'] = true -- translated in ElvUI
-- LoginMessage
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
-- UnitFrames/Hover
	--L['UnitFrames'] = true -- translated in ElvUI
	L['Hover ClassColor'] = "Klassenfarben Effekt"
	L['Adds an Hovereffect for ClassColor to the Raidframes.'] = "Fügt ein MouseOver Klassenfarben Effekt zu dem Schlachtzugsfenster hinzu."
-- RareAlert
	L["Rare spotted!"] = "RarMob in deiner Nähe!"
	L['RareAlert'] = true
	L['Add a Raidwarning and playes a warning sound whenever a RareMob is spotted on the Minimap.'] = "Sobald ein RarMob auf der Minimap gespotted wurde, erscheint eine RaidWarnung und ein WarningSound."
-- GarrisonAlertFrame
	L['Garrison Alert Frame'] = "Garnision Alarm Fenster"
	L['Hides the Garrison Alert Frame while in combat.'] = "Versteckt das Garnision Alarm Fenster während des Kampfes."
-- MailInputBox
	L['Mail Inputbox Resize'] = "Post Eingabefeld"
	L['Resize the Mail Inputbox and move the shipping cost to the Bottom'] = "Verändert die Größe des Post Eingabefeldes und verschiebt die Versandkosten."
-- CalendarNotify
	L['CalendarNotify'] = "Kalendar Benachrichtigung"
	L['Shows pending calendar invites, guild event sign ups'] = "Zeigt anstehende Kalendereinladungen, Gildenereignisse Anmeldungen"
	L["You have %s events scheduled for today. %s Tentative."] = "Du hast %s Termine für Heute. %s Vorläufig."
	L["You have %s pending event invite(s)!"] = "Du hast %s austehende Einladung(en)!"
	L["You have %s pending guild event(s)!"] = "Du hast %s austehende Gildenereignis(se)!"
	L["%s begins in 15 minutes"] = "%s beginnt in 15 Minuten"

-- Install
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
	L['Setup Layout'] = "Layout einstellen"
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
	L['Finished'] = "Fertig"
	L['Installed'] = "Installiert"

-- Staticpopup
	L["To get the whole MerathilisUI Functionality and Look it's recommended that you download |cff00c0faElvUI_BenikUI|r!"] = "Um alle Funktionen und das Aussehen von MerathilisUI zu erlangen, lade dir bitte |cff00c0faElvUI_BenikUI|r herrunter!"
