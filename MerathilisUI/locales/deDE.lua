-- German localization file for deDE
local AceLocale = LibStub:GetLibrary('AceLocale-3.0');
local L = AceLocale:NewLocale('ElvUI', 'deDE');
if not L then return; end

-- Core
L[' is loaded.'] = " ist geladen."

-- General Options
L['by Merathilis (EU-Shattrath)'] = "von Merathilis (EU-Shattrath)"
L['MerathilisUI is an external ElvUI mod. Mostly it changes the Look of your UI. It is high recommended that you download |cff00c0faElvUI BenikUI|r to get the whole Style.'] = "MerathilisUI ist ein externer ElvUI Mod. Es ändert hauptsächlich nur den Look von eurem UI. Um den kompletten Style zu erreichen wird empfohlen |cff00c0faElvUI BenikUI|r herrunter zu laden."
L[' Benik, Blazeflack, Darth Predator, Azilroka, Rockxana, Elv and all other AddOn Authors who inspired me.'] = " Benik, Blazeflack, Darth Predator, Azilroka, Rockxana, Elv und allen anderen AddOn-Autoren die mich inspiriert haben."
--L['Install'] = true -- translated in ElvUI
--L['Run the installation process.'] = true -- translated in ElvUI
--L['General'] = true -- translated in ElvUI
--L['Bags'] = true -- translated in ElvUI
L['AFK'] = true
L['Enable/Disable the MUI AFK Screen'] = "Aktiviert/Deaktiviert den MUI AFK Bildschirm"
L['SplashScreen'] = "Startbildschirm"
L['Enable/Disable the Splash Screen on Login.'] = "Aktiviert/Deaktiviert den Startbildschirm beim Login."
L['Enable/Disable the forcing of the Bag/Bank Frame position.'] = "Aktiviert/Deaktiviert das Erzwingen der Taschen/Bank Position"
L['Options'] = "Einstellungen"
L['CHAT_AFK'] = "[AFK]"
L['CHAT_DND'] = "[DND]"
L['WATCH_WOWHEAD_LINK'] = "Wowhead Link"
L['MISC_SCROLL'] = "Rolle"
L['Enchant on Scroll'] = "Verzauberung auf Rolle"
L['Place a button in the Enchant Trade Window, allow you to automatically place a enchant on a scroll.'] = "Platziert einen Knopf in das Verzauberungsfenster, welches dir erlaubt automatisch eine Verzauberung auf eine Rolle zu wirken."
--L['Role Icon'] = true -- translated in ElvUI
L['Replaces the default role icons with SVUI ones.'] = "Ersetzt die Standard Rollen Symbole mit denen von SVUI."
-- LoginMessage
--L['Login Message'] = true -- translated in ElvUI
L['Enable/Disable the Login Message in Chat'] = "Aktiviert/Deaktiviert die Login Nachricht im Chat"
-- ActionBars
L["Out of Range"] = "Außer Reichweite"
L["Change the Out of Range Check to be on the Hotkey instead of the Button."] = "Ändert den außer Reichweite Check auf den Tastaturbelegungstext anstatt auf den Knopf."
-- GameMenu
L['GameMenu'] = "Spielmenü"
L['Enable/Disable the MerathilisUI Style from the Blizzard GameMenu.'] = "Aktiviert/Deaktiviert den MerathilisUI Style aus dem Blizzard Spielmenü."
-- moveBlizz
L['moveBlizz'] = true
L['Make some Blizzard Frames movable.'] = "Erlaubt das Verschieben einiger Blizzardfenster."
-- MasterPlan
L['MasterPlan'] = true
L['Skins the additional Tabs from MasterPlan.'] = "Skint die zusätzlichen Tabs von MasterPlan."
L['Misc'] = "Verschiedenes"
-- TooltipIcon
L['Tooltip Icon'] = true
L['Adds an Icon for Items/Spells/Achievement on the Tooltip'] = "Fügt ein Symbol für Gegenstände/Zauber/Erfolge am Tooltip hinzu"
-- GarrisonAlertFrame
L['Garrison Alert Frame'] = "Garnision Alarm Fenster"
L['Hides the Garrison Alert Frame while in combat.'] = "Versteckt das Garnision Alarm Fenster während des Kampfes."
-- MailInputBox
L['Mail Inputbox Resize'] = "Post Eingabefeld"
L['Resize the Mail Inputbox and move the shipping cost to the Bottom'] = "Verändert die Größe des Post Eingabefeldes und verschiebt die Versandkosten."
-- PvP
L["MER_DuelCancel_REGULAR"] = "Duel Anfrage von %s abgelehnt."
L["MER_DuelCancel_PET"] = "Haustierkampf Duel von %s abgelehnt."
L["Automatically cancel PvP duel requests."] = "Lehnt automatisch Duel Anfragen ab."
L["Automatically cancel pet battles duel requests."] = "Lehnt automatisch Haustierkampf Duel Anfragen ab."
L["Announce"] = "Ankündigung"
L["Announce in chat if duel was rejected."] = "Kündigt im Chat an, wenn ein Duel abgelehnt wurde."
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
-- System Datatext
L["(Hold Shift) Memory Usage"] = "(Halte Shift) Speichernutzung"
L["Announce Freed"] = "Freigegeben ankündigen "
L["Announce how much memory was freed by the garbage collection."] = "Kündige an, wieviel Spreicher bei der Bereinigung freigegeben wurde."
L["Bandwidth"] = "Bandbreite"
L["Display world or home latency on the datatext. Home latency refers to your realm server. World latency refers to the current world server."] = "Zeige die Welt- oder Heimlatenz im Infotext. Heimlatenz bezieht sich auf die Realm Server. Weltlatenz bezieht sich auf die Welt Server."
L["Download"] = ""
L["FPS"] = true
L["Garbage Collect"] = "Müll aufräumen"
L["Garbage Collection Freed"] = "Müll gesäubert"
L["Home"] = "Heim"
L["Home Latency:"] = "Heimlatenz:"
L["Latency Type"] = "Latenztyp"
L["Left Click:"] = "Links Klick:"
L["Loaded Addons:"] = "Geladene Addons:"
L["MS"] = true
L["Max Addons"] = true
L["Maximum number of addons to show in the tooltip."] = "Maximale Addons die im Tooltip angezeigt werden."
L["Reload UI"] = "UI neuladen"
L["Right Click:"] = "Rechts Klick:"
L["Show FPS"] = "Zeige FPS"
L["Show FPS on the datatext."] = "Zeige FPS auf dem Infotext."
L["Show Latency"] = "Zeige Latenz"
L["Show Memory"] = "Zeige Speicher"
L["Show latency on the datatext."] = "Zeige Latenz auf dem Infotext."
L["Show total addon memory on the datatext."] = "Zeige Addonspeichernutzung auf dem Infotext."
L["System Datatext"] = "System Infotext"
L["Total Addons:"] = "Gesamte Addons:"
L["Total CPU:"] = "Gesamte CPU:"
L["Total Memory:"] = "Gesamter Speicher:"
L["World"] = "Welt"
L["World Latency:"] = "Weltlatenz"
-- Loot
L["Loot Icon"] = "Beute Symbol"
L["Showes icons of items looted/created near respective messages in chat. Does not affect usual messages."] = "Zeigt ein Symbol von einem Gegenstand, dass erbeutet/hergestellt wurde neben der Nachricht im Chat. Beeinflusst nicht die normalen Chatnachrichten."
L["Channels"] = "Kanäle"
L["Private channels"] = "Private Kanäle"
L["Incoming"] = "Eingehend"
L["Outgoing"] = "Ausgehend"
-- Reminder
L["Add Group"] = "Gruppe hinzufügen"
L["Attempted to show a reminder icon that does not have any spells. You must add a spell first."] = "Versuch ein Errinerungs-Symbol anzuzeigen das noch keine Zauber hat. Du musst zuerst einen Zauber hinzufügen."
L["Change this if you want the Reminder module to check for weapon enchants, setting this will cause it to ignore any spells listed."] = "Ändere das wenn du willst das das Errinnerungs Modul deine Waffenverzauberungen prüft, das einstellen dieser Option wird dazu führen das Zauber Listen ignoriert werden."
L["Combat"] = "Kampf"
L["Disable Sound"] = "Deaktiviere Sound"
L["Don't play the warning sound."] = "Spiele nicht den Warnungs Sound."
L["Group already exists!"] = "Gruppe existiert bereits!"
L["If any spell found inside this list is found the icon will hide as well"] = "Wird ein Zauber innerhalb der Liste gefunden wird das Symbol ebenfalls versteckt"
L["Inside BG/Arena"] = "Innerhalb Schlachtfeld/Arena"
L["Inside Raid/Party"] = "Innerhalb Schlachtzug/Gruppe"
L["Instead of hiding the frame when you have the buff, show the frame when you have the buff."] = "Anstatt das Fenster zu verstecken wenn du den Stärkungszauber hast, zeige das Fenster wenn du den Stärkungszauber hast."
L["Level Requirement"] = "Level Vorraussetzung"
L["Level requirement for the icon to be able to display. 0 for disabled."] = "Level Vorraussetzung um das Symbol anzuzeigen. 0 für deaktivieren."
L["Negate Spells"] = "Negiere Zauber"
L["New ID (Negate)"] = "Neue ID (Negieren)"
L["Only run checks during combat."] = "Nur kontrollieren während des Kampfes."
L["Only run checks inside BG/Arena instances."] = "Nur kontrollieren während man innerhalb eines Schlachtfeldes/Arena ist."
L["Only run checks inside raid/party instances."] = "Nur kontrollieren während man innerhalb eines Schlachtzuges/Instanz ist."
L["REMINDER_DESC"] = "Dieses Modul wird dir Warnungs Symbole auf deinem Bildschirm anzeigen wenn dir Stärkungszauber fehlen oder du Stärkungszauber hast die du nicht haben solltest."
L["Remove ID (Negate)"] = "Entferne ID (Negieren)"
L["Reverse Check"] = "Umkehrungs Prüfung"
L["Set a talent tree to not follow the reverse check."] = "Wähle einen Talentbaum der nicht von der Umkehrungs Prüfung betroffen ist."
L["Sound"] = "Sound"
L["Sound that will play when you have a warning icon displayed."] = "Der Sound der abgespielt wird wenn ein Warnungs Symbol erscheint."
L["Spell"] = "Zauber"
L["Strict Filter"] = "Strenger Filter"
L["Talent Tree"] = "Talent Baum"
L["This ensures you can only see spells that you actually know. You may want to uncheck this option if you are trying to monitor a spell that is not directly clickable out of your spellbook."] = "Dadurch wird sichergestellt das du nur Zauber angezeigt werden die du auch wirklich besitzt. Du kannst diese Option deaktivieren um zu versuchen Zauber zu überwachen die nicht direkt im Zauberbuch anklickbar sind."
L["Tree Exception"] = "Baum Ausnahme"
L["Weapon"] = "Waffe"
L["You can't remove a default group from the list, disabling the group."] = "Du kannst keine standart Gruppe von der Liste entfernen, deaktiviere die Gruppe."
L["You must be a certain role for the icon to appear."] = "Du musst eine bestimmte Rolle auswählen damit das Symbol angezeigt wird."
L["You must be using a certain talent tree for the icon to show."] = "Du musst einen bestimmten Talentbaum auswählen damit das Symbol angezeigt wird."
L['CD Fade'] = "CD Verblassen"
L["Cooldown"] = "Cooldown"
L['On Cooldown'] = "Auf Cooldown"
L['Reminders'] = "Erinnerungen"
L['Remove Group'] = "Entferne Gruppe"
L['Select Group'] = "Wähle Gruppe"
L['Role'] = "Rolle"
L['Caster'] = "Fernkampf"
L['Any'] = "Jeder"
L['Personal Buffs'] = "Persönliche Stärkungszauber"
L['Only check if the buff is coming from you.'] = "Nur prüfen wenn der Stärkungszauber von dir kommt."
L['Spells'] = 'Zauber'
L['New ID'] = "Neue ID"
L['Remove ID'] = "Entferne ID"

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
L['This part of the installation process will apply changes to the addons like Skada, xCT+ and ElvUI plugins'] = "Dieser Abschnitt wird Änderungen an den Addons vornehmen, wie Skada, xCT+ und ElvUI Plugins"
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
L["MSG_MER_ELV_OUTDATED"] = "Deine Version von ElvUI ist älter wie die empfohlene Version um |cffff7d0aMerathilisUI|r zu nutzen. Deine Version ist |cff00c0fa%.2f|r (empfohlen ist |cff00c0fa%.2f|r). MerathilisUI ist nicht geladen! Bitte aktuallisiere dein ElvUI."
