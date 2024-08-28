-- German localization file for deDE
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "deDE")

-- Core
L["Enable"] = "Eingeschaltet"
L[" is loaded. For any issues or suggestions, please visit "] =
	" wurde geladen. Für Fehler oder Vorschläge besuche bitte: "
L["Font"] = "Schriftart"
L["Size"] = "Größe"
L["Width"] = "Breite"
L["Height"] = "Höhe"
L["Alpha"] = "Transparenz"
L["Outline"] = "Kontur"
L["X-Offset"] = "X-Versatz"
L["Y-Offset"] = "Y-Versatz"
L["Icon Size"] = "Symbolgröße"
L["Font Outline"] = "Kontur der Schrift"

-- General Options
L["Plugin for |cffff7d0aElvUI|r by\nMerathilis."] = "Plugin für |cffff7d0aElvUI|r von\nMerathilis."
L["by Merathilis (|cFF00c0faEU-Shattrath|r)"] = "von Merathilis (|cFF00c0faEU-Shattrath|r)"
L[" does not support this game version, please uninstall it and don't ask for support. Thanks!"] =
	" unterstützt nicht diese Spielversion, bitte deinstalliere mein Plugin und frage nicht nach Support. Danke!"
L["AFK"] = "AFK"
L["Enable/Disable the MUI AFK Screen. Disabled if BenikUI is loaded"] =
	"Aktiviert/Deaktiviert den MUI AFK Bildschirm. Wird automatisch deaktiviert, wenn BenikUI geladen wurde."
L["Are you still there? ... Hello?"] = "Bist du noch da? ... Hallo?"
L["Logout Timer"] = "Auslogzeit"
L["SplashScreen"] = "Startbildschirm"
L["Enable/Disable the Splash Screen on Login."] = "Aktiviert/Deaktiviert den Startbildschirm beim Login."
L["Options"] = "Einstellungen"
L["Description"] = "Beschreibung"
L["General"] = "Allgemein"
L["Modules"] = "Module"
L["Media"] = "Medien"
L["MER_DESC"] = [=[|cffffffffMerathilis|r|cffff7d0aUI|r ist eine Erweiterung für ElvUI. Sie ergänzt:

- viele neue Funktionen
- einen transparenten Look
- alle ElvUI Skins wurden überarbeitet
- mein persönliches Layout

|cFF00c0faHinweis:|r |cffff7d0aMerathilisUI|r ist mit den meisten anderen ElvUI Plugins kompatibel.
Wenn du jedoch ein anderes Layout über meines installierst, musst du es manuell anpassen.

|cffff8000Neue Features sind markiert mit einem: |r]=]
L["Enables the stripes/gradient look on the frames"] = true

-- Core Options
L["Login Message"] = "Login Nachricht"
L["Enable/Disable the Login Message in Chat"] = "Aktiviert/Deaktiviert die Login Nachricht im Chat"
L["Log Level"] = "Loglevel"
L["Only display log message that the level is higher than you choose."] =
	"Zeigt nur die Log Nachrichten an über dem Level dass du ausgewählt hast"
L["Set to 2 if you do not understand the meaning of log level."] =
	"Setze auf 2 wenn du keine Ahnung vom Log Level hast. :)"
L["This will overwrite most of the ElvUI Options for the colors, so please keep that in mind."] =
	"Diese Option wird die meisten ElvUI Farboptionen überschreiben, bitte bedenkt das."

-- Bags

-- Chat
L["CHAT_AFK"] = "[AFK]"
L["CHAT_DND"] = "[DND]"
L["BACK"] = "Zurück"
L["|cFF00c0failvl|r: %d"] = "|cFF00c0faGegenstandsstufe|r: %d"
L["|CFF1EFF00%s|r |CFFFF0000Sold.|r"] = "|CFF1EFF00%s|r |CFFFF0000Verkauft.|r"
L["Requires level: %d - %d"] = "Erfordert Stufe: %d - %d"
L["Requires level: %d - %d (%d)"] = "Erfordert Stufe: %d - %d (%d)"
L["(+%.1f Rested)"] = "(+%.1f Erholt)"
L["Unknown"] = "Unbekannt"
L["Chat Item Level"] = "Gegenstandsstufe im Chat"
L["Shows the slot and item level in the chat"] = "Zeigt den Ausrüstungsplatz und die Gegenstandsstufe im Chat an."
L["Expand the chat"] = "Chat erweitern"
L["Chat Menu"] = "Chatmenü"
L["Create a chat button to increase the chat size."] = "Erstellt eine Chattaste um den Chat zu vergrößern."
L["Hide Player Brackets"] = "Verstecke Klammern um den Spielernamen"
L["Removes brackets around the person who posts a chat message."] = "Entfernt die Klammern um den Spielernamen im Chat."
L["Chat Bar"] = "Chatleiste"
L["Shows a ChatBar with different quick buttons."] = "Zeigt eine Chatleiste mit verschiedenen Schnelltasten."
L["Hide Community Chat"] = "Verstecke Community Chat"
L["Adds an overlay to the Community Chat. Useful for streamers."] =
	"Fügt ein Overlay zum Community Chat hinzu. Nützlich für Streamer."
L["Chat Hidden. Click to show"] = "Chat verstecken. Klicken um ihn wieder anzuzeigen"
L["Click to open Emoticon Frame"] = "Öffnet das Fenster mit Emote Symbolen"
L["Emotes"] = true -- no need to translate
L["Damage Meter Filter"] = "Damage Meter Filter"
L["Fade Chat"] = "Chat ausblenden"
L["Auto hide timeout"] = "Autom. Ausblendzeit"
L["Seconds before fading chat panel"] = "Sek. vor dem Ausblenden des Chat Panels"
L["Seperators"] = "Trennlinien"
L["Orientation"] = "Orientierung"
L["Please use Blizzard Communities UI add the channel to your main chat frame first."] =
	"Verwende die Benutzeroberfläche von Blizzard Communities. Füge den Kanal zuerst zu Deinem Hauptchat Frame hinzu."
L["Channel Name"] = "Kanalname"
L["Abbreviation"] = "Abkürzung"
L["Auto Join"] = "Autom. Beitreten"
L["World"] = "Welt"
L["Channels"] = "Kanäle"
L["Block Shadow"] = "Verhindere Schatten"
L["Hide channels not exist."] = "Kanäle ausblenden, die nicht existieren."
L["Say"] = "Sagen"
L["Yell"] = "Schreien"
L["Instance"] = "Instanz"
L["Raid"] = "Schlachtzug"
L["Raid Warning"] = "Schlachtzugswarnung"
L["Guild"] = "Gilde"
L["Officer"] = "Offizier"
L["Only show chat bar when you mouse over it."] =
	"Zeige die Chatleiste nur an, wenn mit der Maus darüber gefahren wird."
L["Button"] = "Tasten"
L["Item Level Links"] = "Gegenstandsstufen Links"
L["Block"] = "Blöcke"
L["Custom Online Message"] = "Benutzerdefinierte Online Nachricht"
L["Chat Link"] = "Chatlink"
L["Add extra information on the link, so that you can get basic information but do not need to click"] =
	"Füge dem Link zusätzliche Informationen hinzu, damit grundlegende Informationen erhalten sind, aber nicht geklickt werden muss."
L["Additional Information"] = "Zusätzliche Information"
L["Level"] = "Level"
L["Translate Item"] = "Übersetze Gegenstand"
L["Translate the name in item links into your language."] = "Übersetze den Namen in Gegenstandlinks in Deiner Sprache."
L["Icon"] = "Symbol"
L["Armor Category"] = "Rüstungs Kategorie"
L["Weapon Category"] = "Waffenkategorie"
L["Filters some messages out of your chat, that some Spam AddOns use."] =
	"Filtert einige Nachrichten von Spam AddOns aus deinem Chat."
L["Display the level of the item on the item link."] = "Zeige die Stufe des Gegenstands auf dem Gegenstandslink an."
L["Numerical Quality Tier"] = "Numerische Qualitätsstufe"
L["%player% has earned the achievement %achievement%!"] = "%player% hat den Erfolg %achievement% errungen!"
L["%players% have earned the achievement %achievement%!"] = "%players% haben den Erfolg %achievement% erreicht!"
L["%players% (%bnet%) has come online."] = "%players% (%bnet%) ist jetzt online."
L["%players% (%bnet%) has gone offline."] = "%players% (%bnet%) ist jetzt offline."
L["BNet Friend Offline"] = "BNet Freund Offline"
L["BNet Friend Online"] = "BNet Freund Online"
L["Show a message when a Battle.net friend's wow character comes online."] =
	"Eine Nachricht anzeigen, wenn der Wow-Charakter eines Battle.net Freundes online geht."
L["Show a message when a Battle.net friend's wow character goes offline."] =
	"Eine Nachricht anzeigen, wenn der Wow-Charakter eines Battle.net Freundes offline geht."
L["Show the class icon before the player name."] = "Klassensymbol vor dem Spielernamen anzeigen."
L["Show the faction icon before the player name."] = "Fraktionssymbol vor dem Spielernamen anzeigen."
L["The message will only be shown in the chat frame (or chat tab) with Blizzard service alert channel on."] =
	"Die Nachricht wird nur im Chatfenster (oder Chat Tab) angezeigt, wenn der Blizzard Service-Benachrichtigungskanal aktiviert ist."
L["This feature only works for message that sent by this module."] =
	"Diese Funktion funktioniert nur für Nachrichten, die von diesem Modul gesendet wurden."
L["Position of the Chat EditBox, if the Actionbar backdrop is disabled, this will be forced to be above chat."] =
	"Die Position vom Texteingabefeld, wenn der Aktionsleistenhintergrund deaktiviert ist, ist die Standardposition über dem Chat."
L["Actionbar 1 (below)"] = "Aktionsleiste 1 (unter)"
L["Actionbar 2 (below)"] = "Aktionsleiste 2 (unter)"
L["Actionbar 3 (below)"] = "Aktionsleiste 3 (unter)"
L["Actionbar 4 (below)"] = "Aktionsleiste 4 (unter)"
L["Actionbar 5 (below)"] = "Aktionsleiste 5 (unter)"
L["Actionbar 6 (above)"] = "Aktionsleiste 6 (oberhalb)"

-- Combat Alert
L["Combat Alert"] = "Kampfalarmierung"
L["Enable/Disable the combat message if you enter/leave the combat."] =
	"Aktiviert/Deaktiviert die Kampf Nachricht, wenn du den Kampf betrittst, oder verlässt."
L["Enter Combat"] = "Beginne Kampf"
L["Leave Combat"] = "Verlasse Kampf"
L["Stay Duration"] = "Anzeigezeit"
L["Custom Text"] = "Benutzerdefinierter Text"
L["Custom Text (Enter)"] = "Benutzerdefinierter Text (Beginn)"
L["Custom Text (Leave)"] = "Benutzerdefinierter Text (Verlassen)"
L["Color"] = "Farbe"

-- Information
L["Information"] = "Informationen"
L["Support & Downloads"] = "Unterstützung & Downloads"
L["Tukui"] = true -- no need to translate
L["Github"] = true -- no need to translate
L["CurseForge"] = true -- no need to translate
L["Coding"] = true -- no need to translate
L["Testing & Inspiration"] = "Tester & Inspiration"
L["Development Version"] = "Entwicklungsversion"
L["Here you can download the latest development version."] =
	"Hier findest du den Download zu meiner Development Version."
L["Donations"] = "Spenden"

-- Modules
L["Here you find the options for all the different |cffffffffMerathilis|r|cffff8000UI|r modules."] =
	"Hier findest du alle Optionen zu den verschiedenen |cffffffffMerathilis|r|cffff8000UI|r Modulen."
L["Are you sure you want to reset %s module?"] = "Bist Du sicher, dass Du das %s Modul zurücksetzen möchtest?"
L["Reset All Modules"] = "Alle Module zurücksetzen"
L["Reset all %s modules."] = "Setze alle %s Module zurück."

-- GameMenu
L["GameMenu"] = "Spielmenü"
L["Enable/Disable the MerathilisUI Style from the Blizzard GameMenu. (e.g. Pepe, Logo, Bars)"] =
	"Aktiviert/Deaktiviert den MerathilisUI Stil aus dem Blizzard Spielmenü. (zB. Pepe, Logo, Leisten)"

-- Extended Vendor
L["Extended Vendor"] = "Erweiterter Händler"
L["Extends the merchant page to show more items."] = "Erweitert die Händlerseite, um mehr Gegenstände anzuzeigen."
L["Number of Pages"] = "Anzahl der Seiten"
L["The number of pages shown in the merchant frame."] = "Die Anzahl der im Händlerfenster angezeigten Seiten."

-- Shadows
L["Shadows"] = "Schatten"
L["Increase Size"] = "Größe"
L["Make shadow thicker."] = "Stärke der Schatten"

-- Mail
L["Mail"] = "Post"
L["Alternate Character"] = "Alternativer Charakter"
L["Alt List"] = "Liste mit Alts"
L["Delete"] = "Löschen"
L["Favorites"] = "Favoriten"
L["Favorite List"] = "Favoritenliste"
L["Name"] = "Name"
L["Realm"] = "Server"
L["Add"] = "Hinzufügen"
L["Please set the name and realm first."] = "Bitte füge zuerst den Namen und den Server hinzu."
L["Toggle Contacts"] = "Kontakte einblenden"
L["Online Friends"] = "Freunde Online"
L["Add To Favorites"] = "Zu Favoriten hinzufügen"
L["Remove From Favorites"] = "Aus Favoriten entfernen"
L["Remove This Alt"] = "Diesen Twink entfernen"

-- MicroBar
L["Backdrop"] = "Hintergrund"
L["Backdrop Spacing"] = "Hintergrund Abstand"
L["The spacing between the backdrop and the buttons."] = "Der Abstand zwischen dem Hintergrund und den Tasten"
L["Time Width"] = "Zeit Breite"
L["Time Height"] = "Zeit Höhe"
L["The spacing between buttons."] = "Der Abstand zwischen den Tasten."
L["The size of the buttons."] = "Die Größe der Tasten."
L["Slow Mode"] = "Langsamer Modus"
L["Update the additional text every 10 seconds rather than every 1 second such that the used memory will be lower."] =
	"Aktualisiert den zusätzlichen Text jede 10 Sekunden anstatt jede Sekunde, wirkt sich auf den Speicher aus."
L["Display"] = "Anzeige"
L["Fade Time"] = "Ausblendzeit"
L["Tooltip Position"] = "Tooltip Position"
L["Mode"] = "Modus"
L["None"] = "Nichts"
L["Class Color"] = "Klassenfarbe"
L["Custom"] = "Benutzerdefiniert"
L["Additional Text"] = "Zusätzlicher Text"
L["Interval"] = "Intervall"
L["The interval of updating."] = "Aktualisierungsintervall"
L["Home"] = true -- no need to translate
L["Left Button"] = "Linke Taste"
L["Right Button"] = "Rechte Taste"
L["Left Panel"] = "Linkes Panel"
L["Right Panel"] = "Rechtes Panel"
L["Button #%d"] = "Tasten #%d"
L["Pet Journal"] = "Wildtierführer"
L["Show Pet Journal"] = "Zeige Wildtierführer"
L["Random Favorite Pet"] = "Zufälliges Haustier"
L["Screenshot"] = "Bildschirmaufnahme"
L["Screenshot immediately"] = "Direkte Bildschirmaufnahme"
L["Screenshot after 2 secs"] = "Bildschirmaufnahme nach 2 Sek."
L["Toy Box"] = "Spielzeugkiste"
L["Collections"] = "Sammlung"
L["Show Collections"] = "Zeige Sammlung"
L["Random Favorite Mount"] = "Zufälliges Reittier"
L["Decrease the volume"] = "Lautstärke verringern"
L["Increase the volume"] = "Lautstärke erhöhen"
L["Profession"] = "Berufe"
L["Volume"] = "Lautstärke"

-- Misc
L["Misc"] = "Verschiedenes"
L["Artifact Power"] = "Artefaktmacht"
L["has appeared on the MiniMap!"] = "ist auf der Minimap erschienen!"
L["Alt-click, to buy an stack"] = "Alt klicken, um einen Stapel zu kaufen"
L["Announce"] = "Ankündigungen"
L["Skill gains"] = "Skillsteigerungen"
L[" members"] = " Mitglieder"
L["Name Hover"] = "Namen MouseOver"
L["Shows the Unit Name on the mouse."] = "Zeigt den Einheitennamen an der Maus."
L["Double Click to Undress"] = "Doppel klicken um Auszuziehen"
L["Accept Quest"] = "Quest annehmen"
L["Placed Item"] = "Platzierter Gegenstand"
L["Stranger"] = "Fremder"
L["Keystones"] = "Schlüsselsteine"
L["GUILD_MOTD_LABEL2"] = "Gildennachricht des Tages"
L["LFG Member Info"] = "LFG Mitglieder Info"
L["Shows role informations in your tooltip in the lfg frame."] =
	"Zeigt die Rollen der Gruppenmitglieder im Tooltip des LFG Fensters an."
L["MISC_REPUTATION"] = "Ruf"
L["MISC_PARAGON"] = "Paragon"
L["MISC_PARAGON_REPUTATION"] = "Paragon Ruf"
L["MISC_PARAGON_NOTIFY"] = "Maximaler Ruf - Belohnung abholen."
L["Fun Stuff"] = "Lustiges Zeugs"
L["Change the NPC Talk Frame."] = "Ändert das NPC Sprechfenster ab."
L["Press CTRL + C to copy."] = "Drücke STRG + C zum Kopieren."
L["Wowhead Links"] = true -- no need to translate
L["Adds Wowhead links to the Achievement- and WorldMap Frame"] =
	"Fügt Wowhead Links dem Erfolgfenster und der Weltkarte hinzu."
L["Item Alerts"] = "Gegenstandsalarm"
L["Announce in chat when someone placed an usefull item."] =
	"Kündigt im Chat an, wenn jemand einen nützlichen Gegenstand stellt."
L["Miscellaneous"] = "Sonstiges"
L["Guild News Item Level"] = "Gildennachrichten Gegenstandsstufe"
L["Add Item level Infos in Guild News"] = "Fügt den Gildennachrichten die Gegenstandsstufe an."
L["Spell Alert Scale"] = "Zauberwarnung Skalierung"
L["Add Title"] = "Titel hinzufügen"
L["Display an additional title."] = "Zusätzlichen Titel anzeigen."
L["Add LFG group info to tooltip."] = "LFG Gruppeninformationen zum Tooltip hinzufügen."
L["Reskin Icon"] = "Symbole skinnen"
L["Change role icons."] = "Rollensymbole werden durch neue ersetzt"
L["Line"] = "Linie"
L["Alerts"] = "Warnungen"
L["Call to Arms"] = "Ruf zu den Waffen"
L["Feasts"] = "Festmähler"
L["Toys"] = "Spielzeuge"
L["Random Toy"] = "Zufälliges Spielzeug"
L["Text Style"] = "Textstil"
L["COLOR"] = "Farbe"
L["Hide Boss Banner"] = "Verstecke Boss Banner"
L["This will hide the popup, that shows loot, after you kill a boss"] =
	"Dies wird das Popup verbergen, das Beute anzeigt, nachdem Du einen Boss getötet hast."
L["{rt1} %player% cast %spell% -> %target% {rt1}"] = "{rt1} %player% zaubert %spell% -> %target% {rt1}"
L["{rt1} %player% cast %spell%, today's special is Anchovy Pie! {rt1}"] =
	"{rt1} %player% zaubert %spell%, dass heutige Spezial ist Sardellenkuchen! {rt1}"
L["{rt1} %player% is casting %spell%, please assist! {rt1}"] = "{rt1} %player% zaubert %spell%, bitte helfen! {rt1}"
L["{rt1} %player% is handing out %spell%, go and get one! {rt1}"] =
	"{rt1} %player% verteilt %spell%, geh und hole Dir welche! {rt1}"
L["{rt1} %player% opened %spell%! {rt1}"] = "{rt1} %player% öffnet %spell%! {rt1}"
L["{rt1} %player% puts %spell% {rt1}"] = "{rt1} %player% benutzt %spell% {rt1}"
L["{rt1} %player% used %spell% {rt1}"] = "{rt1} %player% benutzt %spell% {rt1}"
L["{rt1} %player% puts down %spell%! {rt1}"] = "{rt1} %player% bereitet ein %spell% zu."
L["Completed"] = "Abgeschlossen"
L["%s has been reseted"] = "%s wurde zurückgesetzt"
L["Cannot reset %s (There are players in your party attempting to zone into an instance.)"] =
	"%s kann nicht zurückgesetzt werden (Es gibt Spieler in Ihrer Gruppe, die versuchen, eine Zone in eine Instanz zu betreten.)"
L["Cannot reset %s (There are players offline in your party.)"] =
	"%s kann nicht zurückgesetzt werden (In Ihrer Gruppe sind Spieler offline.)"
L["Cannot reset %s (There are players still inside the instance.)"] =
	"%s kann nicht zurückgesetzt werden (Es befinden sich noch Spieler in der Instanz.)"
L["Let your teammates know the progress of quests."] = "Lass deine Teamkollegen den Fortschritt der Quests wissen."
L["Disable Blizzard"] = "Deaktiviere Blizzard"
L["Disable Blizzard quest progress message."] = "Deaktiviere Blizzards Questfortschrittsnachricht"
L["Include Details"] = "Details einschließen"
L["Announce every time the progress has been changed."] = "Kündige jedes mal an, wenn der Fortschritt geändert wurde."
L["In Party"] = "In Gruppe"
L["In Instance"] = "In Instanz"
L["In Raid"] = "In Schlachtzug"
L["None"] = "Nichts"
L["Self (Chat Frame)"] = "Selbst (Chatfenster)"
L["Emote"] = true -- no need to translate
L["Party"] = "Gruppe"
L["Yell"] = "Schreien"
L["Say"] = "Sagen"
L["The category of the quest."] = "Die Kategorie der Quest."
L["Suggested Group"] = "Vorgeschlagene Gruppe"
L["If the quest is suggested with multi-players, add the number of players to the message."] =
	"Wenn die Quest für mehrere Spieler vorgeschlagen wird, füge der Nachricht die Anzahl der Spieler hinzu."
L["The level of the quest."] = "Das Level der Quest."
L["Hide Max Level"] = "Verstecke auf Max Level"
L["Hide the level part if the quest level is the max level of this expansion."] =
	"Verstecke den Level-Teil, wenn das Quest-Level das maximale Level dieser Erweiterung ist."
L["Highlight Color"] = "Hervorhebungsfarbe"
L["Add the prefix if the quest is a daily quest."] =
	"Fügt das Präfix hinzu, wenn es sich bei der Quest um eine tägliche Quest handelt."
L["Add the prefix if the quest is a weekly quest."] =
	"Fügt das Präfix hinzu, wenn es sich bei der Quest um eine wöchentliche Quest handelt."
L["Send the use of portals, ritual of summoning, feasts, etc."] =
	"Sende die Verwendung von Portalen, Beschwörungsritualen, Festen usw."
L["Feasts"] = "Feste"
L["Bots"] = true -- no need to translate
L["Toys"] = "Spielzeuge"
L["Portals"] = "Portale"
L["Include Player"] = "Spieler einschließen"
L["Uncheck this box, it will not send message if you cast the spell."] =
	"Deaktiviere dieses Kontrollkästchen, es wird keine Nachricht gesendet, wenn Du den Zauber wirkst."
L["Raid Warning"] = "Schlachtzugswarnung"
L["If you have privilege, it would the message to raid warning(/rw) rather than raid(/r)."] =
	"Wenn Du Privilegien hast, würde es die Nachricht sein, Warnung (/rw) statt Schlachtzug (/r) zu raiden."
L["Text"] = true -- no need to translate
L["Name of the player"] = "Der Name des Spielers"
L["Target name"] = "Zielname"
L["The spell link"] = "Der Zauberlink"
L["Default Text"] = "Standardtext"
L["Reset Instance"] = "Instanz zurücksetzen"
L["Send a message after instance resetting."] = "Sende eine Nachricht nach dem Zurücksetzen der Instanz."
L["Prefix"] = true -- no need to translate
L["Channel"] = "Kanal"
L["Keystone"] = "Schlüsselstein"
L["Announce the new mythic keystone."] = "Kündige Deinen neuen mythischen Schlüsselstein an."
L["Heroism/Bloodlust"] = "Heldentum/Blutlust"
L["Mute"] = "Stummschalten"
L["Disable some annoying sound effects."] = "Deaktiviert einige nervige Soundeffekte"
L["Others"] = "Andere"
L["Dragonriding"] = "Drachenreiten"
L["Mute the sound of dragonriding."] = "Den Sound vom Drachenreiten stummschalten."
L["Jewelcrafting"] = "Juwelenschleifen"
L["Mute the sound of jewelcrafting."] = "Den Sound vom Juwelenschleifen stummschalten."
L["Same Message Interval"] = "Selbe Benachrichtigung Interval"
L["Time interval between sending same messages measured in seconds."] =
	"Zeitintervall zwischen dem Senden einer gleichen Nachricht in Sekunden."
L["Set to 0 to disable."] = "Setze auf 0 zum deaktivieren."
L["Automation"] = "Automatisierung"
L["Automate your game life."] = "Automatisiere dein Spielerlebnis."
L["Auto Hide Bag"] = "Autom. Taschen verstecken"
L["Automatically close bag if player enters combat."] =
	"Tasche automatisch schließen, wenn Du in den Kampf eintrittst."
L["Auto Hide Map"] = "Autom. Weltkarte verstecken"
L["Automatically close world map if player enters combat."] =
	"Schließe die Weltkarte automatisch, wenn du in den Kampf eintrittst."
L["Accept Resurrect"] = "Akzeptiere Wiederbelebung"
L["Accept resurrect from other player automatically when you not in combat."] =
	"Akzeptiere die Wiederbelebung von anderen Spielern automatisch, wenn du nicht im Kampf bist."
L["Accept Combat Resurrect"] = "Akzeptiere Kampfwiederbelebung"
L["Accept resurrect from other player automatically when you in combat."] =
	"Akzeptiere die Wiederbelebung von anderen Spielern automatisch, wenn du im Kampf bist."
L["Confirm Summon"] = "Akzeptiere Beschwörung"
L["Confirm summon from other player automatically."] =
	"Bestätige die Beschwörung von einem anderen Spieler automatisch."
L["Quick Delete"] = "Schnelles Löschen"
L["This will add the 'DELETE' text to the Item Delete Dialog."] =
	"Dadurch wird dem Element löschen Dialogfeld der Text 'LÖSCHEN' hinzugefügt."
L["Missing Stats"] = "Fehlende Statistiken"
L["Show all stats on the Character Frame"] = "Alle Werte im Charakterfenster anzeigen."
L["Block Join Requests"] = "Beitrittsanfragen blockieren"
L["|nIf checked, only popout join requests from friends and guild members."] =
	"|nWenn aktiviert, werden nur Beitrittsanfragen von Freunden und Gildenmitgliedern angezeigt."
L["Random Toy Macro"] = "Zufälliges Spielzeug Makro"
L["Creates a random toy macro."] = "Erzeugt ein zufälliges Spielzeugmakro."
L["Spell activation alert frame customizations."] = "Anpassungen des Warnfensters bei Zauberaktivierung."
L["Enable/Disable the spell activation alert frame."] =
	"Aktivieren/Deaktivieren Sie den Warnfensters bei Zauberaktivierung."
L["Opacity"] = "Deckkraft"
L["Set the opacity of the spell activation alert frame. (Blizzard CVar)"] =
	"Lege die Deckkraft des Warnfensters bei Zauberaktivierung fest. (Blizzard CVar)"
L["Set the scale of the spell activation alert frame."] =
	"Lege den Maßstab des Warnfensters bei Zauberaktivierung fest."
L["Dressing Room"] = "Anprobe"
L["Inspect Frame"] = "Betrachtungsfenster"
L["Sync Inspect"] = "Syncronisiere Betrachtung"
L["Toggling this on makes your inspect frame scale have the same value as the character frame scale."] =
	"Wenn Du diese Option aktivierst, hat der Maßstab Deines Betrachtungsfensters den selben Wert wie der Maßstab des Charakterfensters."
L["Talents"] = "Talente"
L["Wardrobe"] = "Kleiderschrank"
L["Auction House"] = "Auktionshaus"
L["Transmog Frame"] = "Transmogrifikationsfenster"
L["Makes the transmogrification frame bigger. Credits to Kayr for code."] =
	"Macht das Transmogrifikationsfenster größer. Dank an Kayr für den Code."
L["Add more oUF tags. You can use them on UnitFrames configuration."] =
	"Füge weitere oUF-Tags hinzu. Du kannst sie in der Einheitsfenster-Konfiguration verwenden."
L["Already Known"] = "Bereits bekannt"
L["Puts a overlay on already known learnable items on vendors and AH."] =
	"Legt bei Händlern und im Auktionshaus eine Überlagerung auf bereits bekannte erlernbare Gegenstände."
L["Crying"] = "Weinen"
L["Mute crying sounds of all races."] = "Stumme Schreie aller Rassen."
L["It will affect the cry emote sound."] = "Dies wirkt sich auf den Ton des Schrei-Emotes aus."
L["It will also affect the crying sound of all female Blood Elves."] =
	"Es beeinflusst auch das Weinen aller weiblichen Blutelfen."
L["Class"] = "Klasse"
L["The class icon of the player's class"] = "Das Klassensymbol der Spielerklasse"
L["Context Menu"] = "Kontextmenü"
L["Add features to the context menu."] = "Fügt einige features zum Kontextmenü hinzu."
L["Section Title"] = "Abschnitt Titel"
L["Add a styled section title to the context menu."] = "Fügt einen Abschnittstitel zum Kontextmenü hinzu."
L["Guild Invite"] = "Gildeneinladung"
L["Who"] = "Wer"
L["Report Stats"] = "Werte berichten"
L["Armory"] = true
L["Set Region"] = "Region auswählen"
L["If the game language is different from the primary language in this server, you need to specify which area you play on."] =
	"Wenn sich die Spielsprache von der Primärsprache auf diesem Server unterscheidet, mußt Du angeben, in welchem Bereich Du spielst."
L["Auto-detect"] = "Auto Erkennung"
L["Taiwan"] = true
L["Korea"] = true
L["Americas & Oceania"] = true
L["Europe"] = true
L["Server List"] = "Serverliste"

-- Nameplates
L["NamePlates"] = "Namensplaketten"
L["Enhanced NameplateAuras"] = "Erweiterte Namensplaketten Auren"

-- Tooltip
L["Your Status:"] = "Dein Status:"
L["Your Status: Incomplete"] = "Dein Status: Unvollständig"
L["Your Status: Completed on "] = "Dein Status: Abgeschlossen am "
L["Adds an icon for spells and items on your tooltip."] =
	"Fügt ein Symbol für Zauber und Gegenstände am Tooltip hinzu."
L["Adds an Icon for battle pets on the tooltip."] = "Fügt ein Haustiersymbol zum Tooltip hinzu."
L["Adds an Icon for the faction on the tooltip."] = "Fügt ein Symbol für die Fraktion am Tooltip hinzu."
L["Adds information to the tooltip, on which char you earned an achievement."] =
	"Fügt Information am Tooltip hinzu, von welchem Char der Erfolg errungen wurde."
L["Keystone"] = "Schlüsselstein"
L["Adds descriptions for mythic keystone properties to their tooltips."] =
	"Fügt eine Beschreibung für mythische Schlüsselsteineigenschaften dem Tooltip hinzu."
L["Title Color"] = "Titelfarbe"
L["Change the color of the title in the Tooltip."] = "Ändert die Farbe des Titels im Tooltip."
L["FACTION"] = "Fraktion"
L["HEART_OF_AZEROTH_MISSING_ACTIVE_POWERS"] = "Aktive Azeritboni"
L["Only Icons"] = "Nur Symbole"
L["Use the new style tooltip."] = "Neuen Tooltip Stil verwenden."
L["Display in English"] = "Nur Englisch verwenden"
L["Show icon"] = "Symbol anzeigen"
L["Show the spell icon along with the name."] = "Das Zaubersymbol zusammen mit dem Namen anzeigen."
L["Pet Battle"] = "Haustierkampf"
L["Tooltip Icons"] = "Tooltip Symbole"
L["Pet Icon"] = "Haustier Symbol"
L["Pet ID"] = "Haustier ID"
L["Add an icon for indicating the type of the pet."] = "Füge ein Symbol hinzu, um den Typ des Haustiers anzuzeigen."
L["Show battle pet species ID in tooltips."] = "Art-ID des Kampfhaustiers in Tooltips anzeigen."
L["The modifer key to show additional information from %s."] =
	"Die Modifikatortaste zum Anzeigen zusätzlicher Informationen von %s."
L["Display TargetTarget"] = "Ziel vom Ziel anzeigen"
L["Gradient Color"] = "Farbverlauf"
L["Colors the player names in a gradient instead of class color"] =
	"Färbt die Spielernamen in einem Farbverlauf statt in der Klassenfarbe"
L["Health Bar Y-Offset"] = "Gesundheitsbalken Y-Versatz"
L["Change the postion of the health bar."] = "Ändere die Position der Gesundheitsleiste."
L["Health Text Y-Offset"] = "Gesundheitstext Y-Versatz"
L["Change the postion of the health text."] = "Ändere die Position des Gesundheitstextes."
L["Class Icon Style"] = "Klassensymbol Stil"
L["Reference"] = "Referenz"
L["Preview"] = "Vorschau"
L["Template"] = "Vorlage"
L["Please click the button below to read reference."] =
	"Klicke bitte auf die Schaltfläche unten, um die Referenz zu lesen."

-- Notification
L["Notification"] = "Benachrichtigungen"
L["Display a Toast Frame for different notifications."] = "Zeigt ein Fenster mit verschiedenen Benachrichtigungen an."
L["This is an example of a notification."] = "Beispiel Benachrichtigung."
L["Notification Mover"] = "Benachrichtigungs Mover"
L["%s slot needs to repair, current durability is %d."] = "%s braucht eine Reparatur, aktuelle Haltbarkeit ist %d."
L["You have %s pending calendar invite(s)."] = "Du hast %s ausstehende Kalendereinladungen"
L["You have %s pending guild event(s)."] = "Du hast %s ausstehende Gildenereignisse"
L['Event "%s" will end today.'] = 'Ereignis "%s" endet heute.'
L['Event "%s" started today.'] = 'Ereignis "%s" beginnt heute.'
L['Event "%s" is ongoing.'] = 'Ereignis "%s" ist im Gange.'
L['Event "%s" will end tomorrow.'] = 'Ereignis "%s" endet morgen.'
L["Here you can enable/disable the different notification types."] =
	"Hier kannst du die verschiedenen Benachrichtigungstypen aktivieren/deaktivieren."
L["Enable Mail"] = "Aktiviere Post"
L["Enable Vignette"] = "Aktiviere Vignette"
L["If a Rare Mob or a treasure gets spotted on the minimap."] =
	"Zeigt an, wenn ein Rare Mob, oder ein Schatz auf der Minikarte erscheint."
L["Enable Invites"] = "Aktiviere Einladungen"
L["Enable Guild Events"] = "Aktiviere Gildenereignisse"
L["No Sounds"] = "Keine Töne"
L["Show the rank of shards."] = "Zeigt den Rang vom Splitter."
L["Vignette Print"] = "Vignettenlink"
L["Prints a clickable Link with Coords in the Chat."] = "Fügt einen anklickbaren Link mit Koordinaten im Chat hinzu."
L["Quick Join"] = "Schnellbeitritt"
L["Title Font"] = "Titel Schriftart"
L["Text Font"] = "Text Schriftart"
L["Debug Print"] = "Debuggausgabe"
L["Enable this option to get a chat print of the Name and ID from the Vignettes on the Minimap"] =
	"Aktiviere diese Option um eine Chatausgabe vom Namen und ID von den Vignetten auf der Minikarte zu erhalten."

-- DataTexts
L["|cffFFFFFFLeft Click:|r Open Character Frame"] = "|cffFFFFFFLeft Click:|r Öffnet Characterfenster"
L["|cffFFFFFFRight Click:|r Summon Grand Expedition Yak"] = "|cffFFFFFFRechts Klick:|r Beschwört Große Expeditionsyak"

-- DataBars
L["DataBars"] = "Informationsleisten"
L["Add some stylish buttons at the bottom of the DataBars"] =
	"Fügt unten an den Informationsleisten transparente Tasten hinzu"
L["Style DataBars"] = "Informationsleisten Stil"

-- PVP
L["Automatically cancel PvP duel requests."] = "Lehnt automatisch PVP Duelle ab."
L["Automatically cancel pet battles duel requests."] = "Lehnt automatisch Haustierkampf Duelle ab."
L["Announce in chat if duel was rejected."] = "Berichtet im Chat, wenn ein Duell abgelehnt wurde."
L["MER_DuelCancel_REGULAR"] = "Duell Anfrage von %s abgelehnt."
L["MER_DuelCancel_PET"] = "Haustierkampf Duell Anfrage von %s abgelehnt."
L["Show your PvP killing blows as a popup."] = "Zeigt deine PvP Kills als ein Popup an."
L["Sound"] = "Sound"
L["Play sound when killing blows popup is shown."] = "Spielt einen Sound wenn das Popup angezeigt wird."
L["PvP Auto Release"] = "PVP Auto freilassen"
L["Automatically release body when killed inside a battleground."] =
	"Lass den Körper automatisch frei, wenn Du auf einem Schlachtfeld getötet wurdest."
L["Check for rebirth mechanics"] = "Überprüfe die Wiedergeburtsmechanik"
L["Do not release if reincarnation or soulstone is up."] =
	"Nicht freigeben, wenn Reinkarnation oder Seelenstein vorhanden sind."

-- Actionbars
L["Specialization Bar"] = "Spezialisierungsleiste"
L["EquipSet Bar"] = "Ausrüstungsleiste"
L["Auto Buttons"] = "Autom. Tasten"
L["Bind Font Size"] = "Belegungstext Größe"
L["Trinket Buttons"] = "Trinket Tasten"
L["Color by Quality"] = "Färbe nach Qualität"
L["Quest Buttons"] = "Quest Tasten"
L["Blacklist Item"] = "Schwarze Liste Gegenstand"
L["Whitelist Item"] = "Weiße Liste Gegenstand"
L["Add Item ID"] = "Füge Gegenstands ID hinzu"
L["Delete Item ID"] = "Entferne Gegenstands ID"
L["Spell Feedback"] = "Zauber Feedback"
L["Creates a texture to show the recently pressed buttons."] = "Zeigt eine Textur für die zuletzt gedrückten Tasten."
L["Frame Strata"] = "Fensterschicht"
L["Frame Level"] = "Fensterebene"
L["KeyFeedback"] = "Tastenrückmeldung"
L["Mirror"] = "Spiegeln"
L["Mirror Button Size"] = "Spiegeln Tastengröße"
L["Mirror Direction"] = "Spiegelrichtung"
L["LEFT"] = "LINKS"
L["RIGHT"] = "RECHTS"

-- Armory
L["Armory"] = "Rüstung"
L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."] =
	"Aktiviere/deaktiviere den Waffenkammermodus |cffff7d0aMerathilisUI|r."
L["Enchant & Socket Strings"] = "Verzauberungs- und Sockel Strings"
L["Settings for strings displaying enchant and socket info from the items"] =
	"Einstellungen für Strings, die Verzauberungs- und Sockelinformationen der Gegenstände anzeigen"
L["Enable/Disable the Enchant text display"] = "Aktiviere/deaktiviere die Verzauberungs Texte"
L["Missing Enchants"] = "Fehlende Verzauberungen"
L["Missing Sockets"] = "Fehlende Sockel"
L["Short Enchant Text"] = "Kurzer Verzauberungstext"
L["Enchant Font"] = "Verzauberungsschriftart"
L["Item Level"] = "Gegenstandsstufe"
L["Settings for the Item Level next tor your item slot"] =
	"Einstellungen für die Gegenstandsstufe neben Deinem Gegenstandsplatz"
L["Enable/Disable the Item Level text display"] = "Aktiviere/deaktiviere die Texte auf Elementebene"
L["Toggle sockets & azerite traits"] = "Sockel und Azerit-Eigenschaften umschalten"
L["Item Quality Gradient"] = "Gegenstandsqualität Farbverlauf"
L["Settings for the color coming out of your item slot."] =
	"Einstellungen für die Farbe, die aus Deinem Gegenstandsslot kommt."
L["Toggling this on enables the Item Quality bars."] =
	"Wenn Du diese Option aktivierst, werden die Gegenstands Qualitätsleisten aktiviert."
L["Start Alpha"] = "Starttransparenz"
L["End Alpha"] = "Endtranpsparenz"
L["Slot Item Level"] = "Slot Gegenstandsstufe"
L["Bags Item Level"] = "Taschen Gegenstandsstufe"
L["Enabling this will show the maximum possible item level you can achieve with items currently in your bags."] =
	"Wenn Du dies aktivierst, wird die maximal mögliche Gegenstandsstufe angezeigt, die Du mit den Gegenständen, die sich derzeit in Deinen Taschen befinden, erreichen könntest."
L["Format"] = true -- no need to translate
L["Decimal format"] = "Dezimalformat"
L["Move Sockets"] = "Bewege Sockel"
L["Crops and moves sockets above enchant text."] = "Verschiebt die Sockel über den Verzauberungstext"
L["Hide Controls"] = "Verstecke Kamerakontrolle"
L["Hides the camera controls when hovering the character model."] = "Versteckt die Kamera"

-- AutoButtons
L["AutoButtons"] = "Autom. Tasten"
L["Bar"] = "Leiste"
L["Only show the bar when you mouse over it."] = "Zeige die Leiste nur an, wenn mit der Maus darüber gefahren wird."
L["Bar Backdrop"] = "Leistenhintergrund"
L["Show a backdrop of the bar."] = "Zeige einen Hintergrund auf der Leiste."
L["Button Width"] = "Tastenbreite"
L["The width of the buttons."] = "Die Breite der Tasten"
L["Button Height"] = "Tastenhöhe"
L["The height of the buttons."] = "Die Höhe der Tasten"
L["Counter"] = "Zähler"
L["Button Groups"] = "Tastengruppen"
L["Key Binding"] = "Tastenbelegung"
L["Custom Items"] = "Benutzerdefinierte Gegenstände"
L["List"] = "Liste"
L["New Item ID"] = "ID des neuen Gegenstands"
L["Auto Button Bar"] = "Autom. Tastenleiste"
L["Quest Items"] = "Questgegenstände"
L["Equipments"] = "Ausrüstungen"
L["Potions"] = "Tränke"
L["Flasks"] = "Fläschchen"
L["Food"] = "Essen"
L["Crafted by mage"] = "Hergestellt vom Magier"
L["Banners"] = "Banner"
L["Utilities"] = "Werkzeuge"
L["Fade Time"] = "Ausblendzeit"
L["Alpha Min"] = "Transparens Min"
L["Alpha Max"] = "Transparenz Max"
L["Inherit Global Fade"] = "Erben globales Verblassen"
L["Anchor Point"] = "Ankerpunkt"
L["The first button anchors itself to this point on the bar."] =
	"Die erste Taste verankert sich an diesem Punkt auf der Leiste."
L["Dream Seeds"] = "Traum Saat"
L["Reset the button groups of this bar."] = "Setze die Tastengruppen dieser Leiste zurück."

-- Media
L["Zone Text"] = "Gebietstext"
L["Font Size"] = "Schriftgröße"
L["Subzone Text"] = "Unterzonentext"
L["PvP Status Text"] = "PvP Statustext"
L["Misc Texts"] = "Sonstiger Text"
L["Mail Text"] = "Post Text"
L["Chat Editbox Text"] = "Chat Editierboxtext"
L["Gossip and Quest Frames Text"] = "Tratsch und Questfenster Texte"
L["Objective Tracker Header Text"] = "Questverfolgungs Kopfzeilentext"
L["Objective Tracker Text"] = "Questverfolgungs Text"
L["Banner Big Text"] = "Banner Großer Text"
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
L["UnitFrames"] = "Einheitenfenster"
L["Adds a shadow to the debuffs that the debuff color is more visible."] =
	"Fügt einen Schatten zu den Schwächungszaubern hinzu, so dass die Schwächungszauberfarbe besser sichtbar ist."
L["Swing Bar"] = "Schwungleiste"
L["Creates a weapon Swing Bar"] = "Erstellt eine Waffenschwungleiste"
L["Main-Hand Color"] = "Haupthand Farbe"
L["Off-Hand Color"] = "Schildhand Farbe"
L["Two-Hand Color"] = "Zweihand Farbe"
L["Creates a Global Cooldown Bar"] = "Erstellt eine globale Leiste mit Abklingzeiten"
L["UnitFrame Style"] = "Einheitenfenster Stil"
L["Adds my styling to the Unitframes if you use transparent health."] =
	"Fügt meinen Stil zu den Einheitenfenstern hinzu, wenn du transparentes Leben benutzt."
L["Change the default role icons."] = "Ändert die Standard Rollensymbole."
L["Changes the Heal Prediction texture to the default Blizzard ones."] =
	"Ändert die 'Eingehende Heilung' Textur auf Standard Blizzard"
L["Add a glow in the end of health bars to indicate the over absorb."] =
	"Füge am Ende der Gesundheitsbalken ein Leuchten hinzu, um die Überabsorption anzuzeigen."
L["Add the Blizzard over absorb glow and overlay to ElvUI unit frames."] =
	"Füge den ElvUI Einheitenfenstern das Blizzard Überabsorptionsleuchten und die Überlagerung hinzu."
L["Auto Height"] = "Auto Höhe"
L["Blizzard Absorb Overlay"] = "Blizzard Absorptions Overlay"
L["Blizzard Over Absorb Glow"] = "Blizzard Absorptionslesuchten"
L["Blizzard Style"] = "Blizzard Stil"
L["Change the color of the absorb bar."] = "Ändere die Farbe der Absorptionsleiste."
L["Custom Texture"] = "Benutzerdefinierte Textur"
L["Enable the replacing of ElvUI absorb bar textures."] = "Ersetzen von ElvUI Absorptionsleistentexturen aktivieren."
L["Here are some buttons for helping you change the setting of all absorb bars by one-click."] =
	"Hier sind einige Schaltflächen, mit denen Du die Einstellung aller Absorptionsleisten mit einem Klick ändern kannst."
L["Max Overflow"] = "Maximaler Überschuss"
L["Modify the texture of the absorb bar."] = "Ändere die Textur der Absorptionsleiste."
L["Overflow"] = "Überschuss"
L["Set %s to %s"] = "Setze %s auf %s"
L["Set All Absorb Style to %s"] = "Alle Absorptionsstile auf %s setzen"
L["The absorb style %s and %s is highly recommended with %s tweaks."] =
	"Der Absorptionsstil %s und %s wird mit %s Optimierungen dringend empfohlen."
L["The selected texture will override the ElvUI default absorb bar texture."] =
	"Die ausgewählte Textur überschreibt die standardmäßige ElvUI Absorptionsleistentextur."
L["Use the texture from Blizzard Raid Frames."] = "Verwende die Textur von Blizzard Schlachtzugsfenster."
L["Raid Icon"] = "Schlachtzugsymbol"
L["Change the default raid icons."] = "Ändert das Standard Schlachtzugsymbol"
L["Highlight"] = "Leuchten"
L["Adds an own highlight to the Unitframes"] = "Fügt den Einheitsfenstern ein eigenes Leuchten hinzu"
L["Auras"] = "Auren"
L["Adds an shadow around the auras"] = "Fügt Schatten um die Auren hinzu"
L["Power"] = "Kraftleiste"
L["Enable the animated Power Bar"] = "Animierte Kraftleiste aktivieren"
L["Select Model"] = "Wähle Modell"
L["Type the Model ID"] = "Gib die Modell ID an"
L["Role Icons"] = "Rollensymbole"
L["Heal Prediction"] = "Heilungshervorsage"
L["Add an additional overlay to the absorb bar."] = "Füge der Absorptionsleiste eine zusätzliche Überlagerung hinzu."

-- Maps
L["Maps"] = "Karten"
L["World Map"] = "Weltkarte"
L["Duration"] = "Dauer"
L["Fade Out"] = "Ausblenden"
L["Scale"] = "Skalierung"
L["Hide Blizzard"] = "Verstecke Blizzards"
L["Change the shape of ElvUI minimap."] = "Ändern der Form der ElvUI Minikarte."
L["Height Percentage"] = "Höhe Prozent"
L["Percentage of ElvUI minimap size."] = "Prozentsatz der ElvUI Minikartengröße."
L["MiniMap Buttons"] = "Minikartensymbole"
L["Minimap Ping"] = "Minikarten Ping"
L["Add Server Name"] = "Zeige Servernamen"
L["Only In Combat"] = "Nur im Kampf"
L["Fade-In"] = "Einblenden"
L["The time of animation. Set 0 to disable animation."] = "Die Zeit der Animation. Setze auf 0 um sie zu deaktivieren."
L["Blinking Minimap"] = "Blinkende Minikarte"
L["Enable the blinking animation for new mail or pending invites."] =
	"Aktiviert die blinkende Animation für neue Post, oder austehende Kalendereinladungen."
L["Super Tracker"] = "Super Tracker"
L["Description"] = "Beschreibung"
L["Additional features for waypoint."] = "Zusätliche Ergänzungen für Wegpunkte"
L["Auto Track Waypoint"] = "Automatische Wegpunktverfolgung"
L["Auto track the waypoint after setting."] = "Verfolgt Wegpunkte automatisch."
L["Middle Click To Clear"] = "Mittlerer Klick um zu löschen"
L["Middle click the waypoint to clear it."] = "Mittlerer Klick um einen Wegpunkt zu entfernen."
L["No Distance Limitation"] = "Keine Begrenzung für Entfernung"
L["Force to track the target even if it over 1000 yds."] =
	"Zeigt den Wegpunkt noch an, auch wenn er über 1000yds. entfernt ist."
L["Distance Text"] = "Distanztext"
L["Only Number"] = "Nur Nummer"
L["Add Command"] = "Befehl hinzufügen"
L["Add a input box to the world map."] = "Fügt ein Eingabefeld der Weltkarte hinzu."
L["Are you sure to delete the %s command?"] = "Bist du dir sicher %s diesen Befehl zu löschen?"
L["Can not set waypoint on this map."] = "Kann keinen Wegpunkt auf dieser Karte setzen."
L["Command"] = "Befehl"
L["Command Configuration"] = "Befehlkonfiguration"
L["Command List"] = "Befehlsliste"
L["Click to show location"] = "Zum Anzeigen des Standorts klicken"
L["Current Location"] = "Aktueller Standort"
L["Delete Command"] = "Befehl löschen"
L["Delete the selected command."] = "Lösche den ausgewählten Befehl."
L["Echoes"] = true
L["Enable to use the command to set the waypoint."] = "Aktivieren um diesen Befehl zu verwenden um Wegpunkte zu setzen."
L["Go to ..."] = "Gehe zu ..."
L["Input Box"] = "Eingabefeld"
L["New Command"] = "Neuer Befehl"
L["Next Location"] = "Nächster Standort"
L["No Arg"] = "Kein Argument"
L["Radiant Echoes"] = true
L["Smart Waypoint"] = "Intelligenter Wegpunkt"
L["The argument is invalid."] = "Das Argument ist ungültig."
L["The argument is needed."] = "Das Argument wird benötigt."
L["The command to set a waypoint."] = "Der Befehl um einen Wegpunkt zu setzen."
L["The coordinates contain illegal number."] = "Die Koordinaten enthalten verbotene Nummern."
L["Waypoint %s has been set."] = "Wegpunkt %s wurde gesetzt."
L["Waypoint Parse"] = "Wegpunktanalyse"
L["You can paste any text contains coordinates here, and press ENTER to set the waypoint in map."] =
	"Du kannst hier einen beliebigen Text einfügen, der Koordinaten enthält, und die EINGABETASTE drücken, um den Wegpunkt auf der Karte festzulegen."
L["illegal"] = "Verboten"
L["invalid"] = "Ungültig"
L["Because of %s, this module will not be loaded."] = "Aufgrund von %s wird dieses Modul nicht geladen."
L["This module will help you to reveal and resize maps."] =
	"Dieses Modul hilft Dir, beim Anzeigen und Ändern der Kartengröße."
L["Reveal"] = "Aufdecken"
L["Use Colored Fog"] = "Verwende farbigen Nebel"
L["Remove Fog of War from your world map."] = "Entferne Nebel des Krieges von deiner Weltkarte."
L["Style Fog of War with special color."] = "Style Nebel des Krieges mit einer besonderen Farbe."
L["Resize world map."] = "Größenveränderung der Weltkarte"
L["LFG Queue"] = "LFG Warteschlange"
L["Right click to switch expansion"] = "Rechtsklick um den Content umzuschalten"
L["Add trackers for world events in the bottom of world map."] =
	"Tracker für Weltereignisse unten auf der Weltkarte hinzufügen."
L["Alert"] = "Alarm"
L["Alert Second"] = "Zweiter Alarm"
L["Alert will be triggered when the remaining time is less than the set value."] =
	"Alarm wird ausgelöst, wenn die verbleibende Zeit unter dem eingestellten Wert liegt."
L["Community Feast"] = "Gemeinschaftliches Festmahl"
L["Cooking"] = "Kochen"
L["Dragonbane Keep"] = "Drachenfluchfestung"
L["Duration"] = "Dauer"
L["Event Tracker"] = "Ereignis Tracker"
L["Feast"] = "Festmahl"
L["In Progress"] = "Im Gange"
L["Location"] = "Standort"
L["Siege On Dragonbane Keep"] = "Belagerung der Drachenfluchfestung"
L["Status"] = true -- no need to translate
L["Waiting"] = "Warten"
L["Weekly Reward"] = "Wöchentliche Belohnung"
L["%s will be started in %s!"] = "%s wird starten in %s"
L["Next Event"] = "Nächstes Event"
L["Stop Alert if Completed"] = "Stoppe Alarm wenn komplett"
L["Stop alert when the event is completed in this week."] = "Stoppe Alarm wenn es für diese Woche abgeschlossen ist"
L["Alert Sound"] = "Alarmton"
L["Play sound when the alert is triggered."] = "Ton abspielen, wenn der Alarm ausgelöst wird."
L["Sound File"] = "Tondatei"
L["Only DF Character"] = "Nur Character in Dragonflight"
L["Stop alert when the player have not entered Dragonlands yet."] =
	"Stopt den Alarm, wenn der Spieler noch nicht in Dragonflight angekommen ist."
L["The offset of the frame from the bottom of world map. (Default is -3)"] =
	"Der Versatz vom Frame unter der Weltkarte. (Standard ist -3)"
L["Alert Timeout"] = "Alarm Zeitüberschreitung"
L["All nets can be collected"] = "Alle Netze können eingesammelt werden"
L["Can be collected"] = "Kann gesammelt werden"
L["Can be set"] = "Kann eingestellt werden"
L["Fishing Net"] = "Fischnetz"
L["Fishing Nets"] = "Fischnetze"
L["Iskaaran Fishing Net"] = "Iskaaran Fischnetz"
L["Net #%d"] = "Netz #%d"
L["Net %s can be collected"] = "Netz %s kann eingesammelt werden"
L["No Nets Set"] = "Keine Netze ausgelegt"
L["Custom String"] = "Benutzerdefinierter String"
L["Custom Strings"] = "Benutzerdefinierte Strings"
L["Custom color can be used by adding the following code"] =
	"Benutzerdefinierte Farbe kann benutzt werden wenn du folgenden Code benutzt"
L["Difficulty"] = "Schwierigkeit"
L["M+ Level"] = "M+ Stufe"
L["Number of Players"] = "Anzahl der Spieler"
L["Placeholders"] = "Platzhalter"
L["Use Default"] = "Benutze Standard"
L["Researchers Under Fire"] = "Forscher unter Feuer"
L["Time Rift"] = "Zeitriss"
L["Superbloom"] = "Superblüte"
L["Big Dig"] = "Große Buddeln"
L["The Big Dig"] = "Das große Buddeln"
L["Horizontal Spacing"] = "Horzontaler Abstand"
L["Show a backdrop of the trackers."] = "Zeige einen Hintergrund der Tracker."
L["The Y-Offset of the backdrop."] = "Der Y-Versatz des Hintergrunds."
L["The height of the tracker."] = "Die Höhe der Tracker"
L["The spacing between the backdrop and the trackers."] = "Der Abstand zwischen dem Hintergrund und den Trackern."
L["The spacing between the tracker and the world map."] = "Der Abstand zwischen dem Tracker und der Weltkarte."
L["The spacing between trackers."] = "Der Abstand zwischen Trackern"
L["The width of the tracker."] = "Die Breite der Tracker"
L["Vertical Spacing"] = "Vertikaler Abstand"

-- SMB
L["Minimap Buttons"] = "Minimap Tasten"
L["Add an extra bar to collect minimap buttons."] =
	"Fügt eine zusätzliche Leiste hinzu, um Minikartenschaltflächen zu sammeln."
L["Toggle minimap buttons bar."] = "Minimap Tastenleiste einblenden"
L["Mouse Over"] = "Mouseover"
L["Only show minimap buttons bar when you mouse over it."] =
	"Zeige die Minikartenschaltflächenleiste nur an, wenn mit der Maus darüber gefahren wird."
L["Minimap Buttons Bar"] = "Minimap Tastenleiste"
L["Bar Backdrop"] = "Leistenhintergrund"
L["Show a backdrop of the bar."] = "Zeige einen Hintergrund von der Leiste."
L["Backdrop Spacing"] = "Hintergrund Abstand"
L["The spacing between the backdrop and the buttons."] = "Der Abstand zwischen dem Hintergrund und den Tasten."
L["Inverse Direction"] = "Umgekehrte Richtung"
L["Reverse the direction of adding buttons."] = "Kehre die Richtung des Hinzufügens von Schaltflächen um."
L["Orientation"] = "Orientierung"
L["Arrangement direction of the bar."] = "Arrangierrichtung der Bar."
L["Drag"] = "Ziehen"
L["Horizontal"] = true -- no need to translate
L["Vertical"] = "Vertikal"
L["Buttons"] = "Tasten"
L["Buttons Per Row"] = "Tasten pro Zeile"
L["The amount of buttons to display per row."] = "Die Anzahl der Tasten, die pro Zeile angezeigt werden sollen."
L["Button Size"] = "Tasten Größe"
L["The size of the buttons."] = "Die Größe der Tasten."
L["Button Spacing"] = "Tasten Abstand"
L["The spacing between buttons."] = "Der Abstand zwischen den Tasten."
L["Blizzard Buttons"] = "Blizzard Tasten"
L["Calendar"] = "Kalender"
L["Add calendar button to the bar."] = "Fügt der Leiste die Schaltfläche Kalender hinzu."
L["Garrison"] = "Garnison"
L["Add garrison button to the bar."] = "Fügt der Leiste einer Garnisons Taste hinzu."

-- RaidMarks
L["Raid Markers"] = "Schlachtzugs Markierungen"
L["Raid Markers Bar"] = "Schlachtzugs Markierungsleiste"
L["Raid Utility"] = "Schlachtzugswerkzeug"
L["Left Click to mark the target with this mark."] =
	"Klicke mit der linken Maustaste, um das Ziel mit dieser Markierung zu markieren."
L["Right Click to clear the mark on the target."] = "Rechts Klick um den Wegpunkt zu entfernen."
L["%s + Left Click to place this worldmarker."] = "%s + Linksklick, um diesen Weltmarker zu platzieren."
L["%s + Right Click to clear this worldmarker."] =
	"%s + Klicke mit der rechten Maustaste, um diesen Weltmarker zu löschen."
L["%s + Left Click to mark the target with this mark."] =
	"%s + Klicke mit der linken Maustaste, um das Ziel mit dieser Markierung zu markieren."
L["%s + Right Click to clear the mark on the target."] =
	"%s + Klicke mit der rechten Maustaste, um die Markierung auf dem Ziel zu löschen."
L["Click to clear all marks."] = "Klicke, um alle Markierungen zu löschen."
L["takes 3s"] = "benötigt 3 Sek."
L["%s + Click to remove all worldmarkers."] = "%s + Klicke hier, um alle Weltmarker zu entfernen."
L["Click to remove all worldmarkers."] = "Klicke, um alle Weltmarker zu entfernen."
L["%s + Click to clear all marks."] = "%s + Klicke, um alle Markierungen zu löschen."
L["Left Click to ready check."] = "Linksklick zur Überprüfung."
L["Right click to toggle advanced combat logging."] =
	"Klicke mit der rechten Maustaste, um die erweiterte Kampfprotokollierung umzuschalten."
L["Left Click to start count down."] = "Linksklick, um den Countdown zu starten."
L["Add an extra bar to let you set raid markers efficiently."] =
	"Fügt eine zusätzliche Leiste hinzu, mit der Du Raidmarker schneller setzen kannst."
L["Toggle raid markers bar."] = "Schlachtzugsmarkierungsleiste einblenden"
L["Inverse Mode"] = "Umkehrungs Modus"
L["Swap the functionality of normal click and click with modifier keys."] =
	"Tausche die Funktionalität des normalen Klickens aus und klicke mit den Modifikatortasten."
L["Visibility"] = "Sichtbarkeit"
L["In Party"] = "In Gruppe"
L["Always Display"] = "Immer anzeigen"
L["Mouse Over"] = "Mouseover"
L["Only show raid markers bar when you mouse over it."] =
	"Zeige die Raid-Markierungsleiste nur an, wenn mit der Maus darüber gefahren wird."
L["Tooltip"] = true -- no need to translate
L["Show the tooltip when you mouse over the button."] =
	"Zeige die Raid-Markierungsleiste nur an, wenn mit der Maus darüber gefahren wird."
L["Modifier Key"] = "Modifier Taste"
L["Set the modifier key for placing world markers."] =
	"Unterbreche die Automatisierung, indem Du eine Modifizierertaste drückst."
L["Shift Key"] = "Shift Taste"
L["Ctrl Key"] = "Strg Taste"
L["Alt Key"] = "Alt Taste"
L["Bar Backdrop"] = "Leistenhintergrund"
L["Show a backdrop of the bar."] = "Zeige einen Hintergrund auf der Leiste."
L["Backdrop Spacing"] = "Hintergrund Abstand"
L["The spacing between the backdrop and the buttons."] = "Der Abstand zwischen dem Hintergrund und den Tasten."
L["Orientation"] = "Orientierung"
L["Arrangement direction of the bar."] = "Arrangierrichtung der Bar."
L["Raid Buttons"] = "Schlachtzug Tasten"
L["Ready Check"] = "Bereitschaftscheck"
L["Advanced Combat Logging"] = "Erweiterte Kampfprotokollierung"
L["Left Click to ready check."] = "Linksklick zur Überprüfung."
L["Right click to toggle advanced combat logging."] =
	"Klicke mit der rechten Maustaste, um die erweiterte Kampfprotokollierung umzuschalten."
L["Count Down"] = "Zähler"
L["Count Down Time"] = "Countdown Zeit"
L["Count down time in seconds."] = "Countdown Zeit in Sekunden."
L["Button Size"] = "Tasten Größe"
L["The size of the buttons."] = "Die Größe der Tasten."
L["Button Spacing"] = "Tasten Abstand"
L["The spacing between buttons."] = "Der Abstand zwischen den Tasten."
L["Button Backdrop"] = "Tastenhintergrund"
L["Button Animation"] = "Tastenanimation"

-- Raid Buffs
L["Raid Buff Reminder"] = "Schlachtzugsbufferinnerung"
L["Shows a frame with flask/food/rune."] = "Zeigt ein Fenster mit Fläschchen/Essen/Runen an."
L["Class Specific Buffs"] = "Klassenspezifische Buffs"
L["Shows all the class specific raid buffs."] = "Zeigt alle klassenspezifischen Buffs."
L["Change the alpha level of the icons."] = "Ändert den Alphawert der Symbole"
L["Shows the pixel glow on missing raid buffs."] = "Zeigt ein Leuchten um den fehlenden klassenspezifischen Buff."

-- Reminder
L["Reminder"] = "Erinnerung"
L["Reminds you on self Buffs."] = "Erinnert Dich an eigene Buffs."

-- Cooldowns
L["Cooldowns"] = "Abklingzeiten"
L["Cooldown Flash"] = "Abklingzeiten Aufleuchten"
L["Settings"] = "Einstellungen"
L["Fadein duration"] = "Einblendzeit"
L["Fadeout duration"] = "Ausblendzeit"
L["Duration time"] = "Dauer"
L["Animation size"] = "Animationsgröße"
L["Watch on pet spell"] = "Überwache Begleiterzauber"
L["Transparency"] = "Transparenz"
L["Test"] = true -- no need to translate
L["Sort Upwards"] = "Abwärts sortieren"
L["Sort by Expiration Time"] = "Nach Abklingzeit sortieren"
L["Show Self Cooldown"] = "Zeige eigene Abklingzeiten"
L["Show Icons"] = "Zeige Symbol"
L["Show In Party"] = "Zeige in Gruppe"
L["Show In Raid"] = "Zeige im Schlachtzug"
L["Show In Arena"] = "Zeige in Arenen"
L["Spell Name"] = "Zaubername"
L["Spell List"] = "Zauberliste"

-- CVars
L["\n\nDefault: |cff00ff001|r"] = "\n\nStandard: |cff00ff001|r"
L["\n\nDefault: |cffff00000|r"] = "\n\nStandard: |cffff00000|r"
L["alwaysCompareItems"] = "Immer Tooltips vergleichen"
L["alwaysCompareItems_DESC"] = "Zeigen Sie immer Tooltips zum Vergleichen von Elementen an\r\rStandard: |cffff00000|r"
L["breakUpLargeNumbers"] = "Große Zahlen umbrechen"
L["breakUpLargeNumbers_DESC"] = "Schaltet die Verwendung von Kommas in großer Zahlen um\r\rStandard: |cff00ff001|r"
L["scriptErrors"] = "Scriptfehler"
L["enableWoWMouse"] = "aktiviereWoWMouse"
L["trackQuestSorting"] = "Verfolge Questsortierung"
L["trackQuestSorting_DESC"] = "Neue Verfolgungsaufgaben werden am Zielverfolgungsort aufgelistet \r\r Standard: Oben"
L["autoLootDefault"] = "Autom. Looten"
L["autoDismountFlying"] = "Autom. Absitzen"
L["removeChatDelay"] = "Entferne Fensterverzögerung"
L["screenshotQuality"] = "Screenshot Qualität"
L["screenshotQuality_DESC"] = "Einstellung für die Qualität des Screenshots\r\rStandard: |cff00ff003|r"
L["showTutorials"] = "Zeige Tutorials"
L["WorldTextScale"] = "Welt Textgröße"
L["WorldTextScale_DESC"] = "Größe der Welt Schadenszahlen, Ehrfarungsgewinn, Artefaktgewinn, etc \r\r Standard: 1.0"
L["floatingCombatTextCombatDamageDirectionalScale"] = true
L["floatingCombatTextCombatDamageDirectionalScale_DESC"] =
	"Richtung der Schadenszahlen Bewegungsskalierung (deaktiviert = keine Richtungsnummern\r\rStandard: |cff00ff001|r"

-- GMOTD
L["Display the Guild Message of the Day in an extra window, if updated."] =
	"Zeigt die Gildennachricht des Tages in einem extra Fenster an, sofern sie aktualisiert wurde."

-- AFK
L["Jan"] = true
L["Feb"] = true
L["Mar"] = "Mrz"
L["Apr"] = true
L["May"] = "Mai"
L["Jun"] = true
L["Jul"] = true
L["Aug"] = true
L["Sep"] = true
L["Oct"] = "Okt"
L["Nov"] = true
L["Dec"] = "Dez"

L["Sun"] = "So"
L["Mon"] = "Mo"
L["Tue"] = "Di"
L["Wed"] = "Mi"
L["Thu"] = "Do"
L["Fri"] = "Fr"
L["Sat"] = "Sa"

-- Nameplates
L["Castbar Shield"] = "Zauberleiste Schild"
L["Show a shield icon on the castbar for non interruptible spells."] =
	"Zeigt ein Schildsymbol auf der Zauberleiste an, wenn ein Zauber nicht unterbrochen werden kann."
L["|cffFF0000NOTE:|r This will overwrite the ElvUI Nameplate options for Buff/Debuffs width/height. The CC-Buffs are hardcoded to a size of: 32 x 32"] =
	"|cffFF0000Hinweis:|r Dieser Menüpunkt wird die ElvUI Namensplakettenoptionen Höhe/Breite für die Stärkungs-/Schwächungszauber überschreiben. Die CC-Buffs sind hartkodiert und haben eine Größe von: 32 x 32 Pixel."

-- Install
L["Welcome"] = "Willkommen"
L["|cffff7d0aMerathilisUI|r Installation"] = true -- no need to translate
L["MerathilisUI Set"] = "MerathilisUI gesetzt"
L["MerathilisUI didn't find any supported addons for profile creation"] =
	"MerathilisUI konnte keine Addonprofile finden, die unterstützt werden."
L["MerathilisUI successfully created and applied profile(s) for:"] =
	"MerathilisUI hat erfolgreich ein Profil erstellt und angewandt für:"
L["Chat Set"] = "Chat eingestellt"
L["ActionBars"] = "Aktionsleisten"
L["ActionBars Set"] = "Aktionsleisten eingestellt"
L["DataTexts Set"] = "Infotexte eingestellt"
L["Profile Set"] = "Profil eingestellt"
L["ElvUI AddOns settings applied."] = "ElvUI AddOns eingestellt."
L["AddOnSkins is not enabled, aborting."] = "AddOnSkins ist nicht aktiviert, abgebrochen."
L["AddOnSkins settings applied."] = "AddOnSkins Einstellungen angewandt."
L["BigWigs is not enabled, aborting."] = "BigWigs ist nicht aktiviert, abgebrochen."
L["BigWigs Profile Created"] = "BigWigs Profil erstellt"
L["Skada Profile Created"] = "Skada Profil erstellt"
L["Skada is not enabled, aborting."] = "Skada ist nicht aktiviert, abgebrochen."
L["UnitFrames Set"] = "Einheitenfenster eingestellt"
L["Welcome to MerathilisUI |cff00c0faVersion|r %s, for ElvUI %s."] =
	"Willkommen zu MerathilisUI |cff00c0faVersion|r %s für ElvUI %s."
L["By pressing the Continue button, MerathilisUI will be applied in your current ElvUI installation.\r\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"] =
	"Durch drücken der Weiter-Taste werden die MerathilisUI Änderungen in der vorhandenen ElvUI Installation angewandt.\r\r|cffff8000 TIPP: Es wäre gut, wenn Du die Änderungen in einem neuen Profil erstellst. Nur für den Fall, dass Du mit den Änderungen nicht zufrieden bist.|r"
L["Buttons must be clicked twice"] = "Bitte zweimal anklicken"
L["Importance: |cffff0000Very High|r"] = "Bedeutung: |cffff0000Sehr Hoch|r"
L["The AddOn 'AddOnSkins' is not enabled. No settings have been changed."] =
	"Das AddOn 'AddOnSkins' ist nicht aktiviert. Keine Einstellungen wurden verändert."
L["The Addon 'Big Wigs' is not enabled. Profile not created."] =
	"Das AddOn 'BigWigs' ist nicht aktiviert. Profil wurde nicht erstellt."
L["The AddOn 'ElvUI_BenikUI' is not enabled. No settings have been changed."] =
	"Das AddOn 'ElvUI_BenikUI' ist nicht aktiviert. Keine Einstellungen wurden verändert."
L["The AddOn 'ElvUI_SLE' is not enabled. No settings have been changed."] =
	"Das AddOn 'ElvUI_SLE' ist nicht aktiviert. Keine Einstellungen wurden verändert."
L["The Addon 'Skada' is not enabled. Profile not created."] =
	"Das AddOn 'Skada' ist nicht aktiviert. Profile wurde nicht erstellt."
L["This part of the installation process sets up your chat fonts and colors."] =
	"Dieser Teil des Installationsprozesses ändert die Chatschriftart und -farbe."
L["This part of the installation changes the default ElvUI look."] =
	"Dieser Teil der Installation ändert das standard Aussehen von ElvUI."
L["This part of the installation process will fill MerathilisUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"] =
	"Diese Einstellungen füllt die Infotexte.\r|cffff8000Die Einstellungen der Infotexte von ElvUI wird nicht verändert.|r"
L["This part of the installation process will reposition your Actionbars and will enable backdrops"] =
	"Dieser Teil des Installationsprozesses wird die Aktionsleisten neu positionieren und wird den Hintergrund einschalten."
L["This part of the installation process will change your NamePlates."] =
	"Dieser Teil der Installation ändert die Namensplaketten."
L["This part of the installation process will reposition your Unitframes."] =
	"Dieser Teil der Installation positioniert die Einheitenfenster."
L["This part of the installation process will apply changes to ElvUI Plugins"] =
	"Dieser Abschnitt wird Änderungen an den ElvUI Plugins vornehmen."
L["This step changes a few World of Warcraft default options. These options are tailored to the needs of the author of %s and are not necessary for this edit to function."] =
	"Dieser Schritt ändert ein paar World of Warcraft Standardoptionen. Diese Optionen sind zugeschnitten für die Anforderungen des Authors von %s und sind nicht notwendig damit dieses AddOn funktioniert."
L["Please click the button below to apply the new layout."] =
	"Bitte drücke die Taste unten, um das neue Layout anzuwenden."
L["Please click the button below to setup your chat windows."] =
	"Bitte drücke auf die Taste unten, um das Chatfenster einzustellen."
L["Please click the button below to setup your actionbars."] =
	"Bitte drücke auf die Taste unten, um die Aktionsleisten einzustellen."
L["Please click the button below to setup your datatexts."] =
	"Bitte drücke die Taste unten, um die Infotexte einzustellen."
L["Please click the button below to setup your NamePlates."] =
	"Bitte drücke die Taste unten, um die Namensplaketten einzustellen."
L["Please click the button below to setup your Unitframes."] =
	"Bitte drücke die Taste unten, um die Einheitenfenster einzustellen."
L["Please click the button below to setup the ElvUI AddOns. For other Addon profiles please go in my Options - Skins/AddOns"] =
	"Bitte drücke die Taste unten, um die ElvUI AddOns einzustellen. Weitere AddOns Profile findest Du in meinen Einstellungen unter - Skins/AddOns."
L["DataTexts"] = "Infotexte"
L["General Layout"] = "Allgemeines Layout"
L["Setup ActionBars"] = "Aktionsleisten einstellen"
L["Setup NamePlates"] = "Namensplaketten einstellen"
L["Setup UnitFrames"] = "Einheitenfenster einstellen"
L["Setup Datatexts"] = "Infotexte einstellen"
L["Setup Addons"] = "Addons einstellen"
L["ElvUI AddOns"] = true -- no need to translate
L["Finish"] = "Fertig"
L["Installed"] = "Installiert"

-- Staticpopup
L["MSG_MER_ELV_OUTDATED"] =
	"Deine Version von ElvUI ist älter als die empfohlene Version um |cffff7d0aMerathilisUI|r zu nutzen. Deine Version ist |cff00c0fa%.2f|r (empfohlen ist |cff00c0fa%.2f|r). Bitte aktualisiere dein ElvUI um Fehler zu vermeiden!"
L["MSG_MER_ELV_MISMATCH"] =
	"Deine ElvUI Version ist höher als erwartet. Bitte aktualisiere MerathilisUI oder du rennst womöglich in Fehler oder |cffFF0000hast sie schon|r."
L["You have got Location Plus and Shadow & Light both enabled at the same time. Select an addon to disable."] =
	"Du hast LocationPlus und Shadow & Light zur gleichen Zeit aktiviert. Wähle ein AddOn aus, was du deaktivieren möchtest."
L["MUI_INSTALL_SETTINGS_LAYOUT_SLE"] = [[Hier kannst das Layout für S&L wählen.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_BW"] = [[Hier kannst das Layout für BigWigs wählen.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_DBM"] = [[Hier kannst das Layout für Deadly Boss Mods wählen.]]
L["MER_INSTALL_SETTINGS_LAYOUT_DETAILS"] = [[Hier kannst das Layout für Details wählen.]]
L["Name for the new profile"] = "Name für das neue Profil"
L["Are you sure you want to override the current profile?"] =
	"Bist du sicher, dass du dein aktuelles Profil überschreiben  möchtest?"

-- Skins
L["MER_SKINS_DESC"] = [[Dieser Abschnitt ist dazu gedacht, die vorhandenen ElvUI Skins zu verbessern.

Bitte beachte, dass einige Optionen nicht verfügbar sind, wenn der dazugehörige Skin in ElvUI |cff636363deaktiviert|r ist.]]
L["MER_ADDONSKINS_DESC"] = [[Diese Abschnitt ist dazu gedacht, um das Aussehen von externen AddOns zu modifizieren.

Bitte beachte, dass einige Optionen |cff636363deaktiviert|r sind, wenn das AddOn nicht geladen wurde.]]
L["MerathilisUI Style"] = "MerathilisUI Stil"
L["Creates decorative stripes and a gradient on some frames"] =
	"Fügt dekorative Streifen und einen transparenten Farbverlauf an einigen Fenstern hinzu"
L["Screen Shadow Overlay"] = "Bildschirmschatten Overlay"
L["Enables/Disables a shadow overlay to darken the screen."] =
	"Aktiviert/Deaktiviert ein Schattenoverlay um den Bildschirm abzudunkeln."
L["Undress Button"] = "Ausziehen Taste"
L["Subpages"] = "Unterseiten"
L["Subpages are blocks of 10 items. This option set how many of subpages will be shown on a single page."] =
	"Unterseiten sind Blöcke von 10 Gegenständen pro Seite. Diese Option legt die Anzahl der Unterseiten fest, die angezeigt werden."
L["Enable/Disable"] = "Aktiviere/Deaktiviere"
L["decor."] = "Dekor"
L["MerathilisUI Button Style"] = "MerathilisUI Tastenstil"
L["Creates decorative stripes on Ingame Buttons (only active with MUI Style)"] =
	"Fügt dekorative Streifen den Ingame-Buttons hinzu. (Nur aktiv mit MerathilisUI Stil)"
L["Additional Backdrop"] = "Zusätzlicher Hintergrund"
L["Remove Border Effect"] = "Entferne Randeffekt"
L["Animation Type"] = "Animationstyp"
L["The type of animation activated when a button is hovered."] =
	"Der Animationstyp, der aktiviert wird, wenn man sich darüber bewegt."
L["Animation Duration"] = "Animationsdauer"
L["The duration of the animation in seconds."] = "Die Dauer der Animation in Sekunden."
L["Backdrop Class Color"] = "Hintergrund Klassenfarbe"
L["Border Class Color"] = "Rahmen Klassenfarbe"
L["Border Color"] = "Rahmen Farbe"
L["Normal Class Color"] = "Normale Klassenfarbe"
L["Selected Backdrop & Border"] = "Ausgewählter Hintergrund & Rahmen"
L["Selected Class Color"] = "Ausgewählte Klassenfarbe"
L["Selected Color"] = "Ausgewählte Farbe"
L["Tab"] = true -- no need to translate
L["Tree Group Button"] = "Baumstrukturtaste"
L["Shadow Color"] = "Schattenfarbe"
L["These skins will affect all widgets handled by ElvUI Skins."] =
	"Diese Skins wirken sich auf alle Widgets aus, die von ElvUI Skins verwaltet werden."
L["Texture"] = "Textur"
L["Backdrop Color"] = "Hintergrundfarbe"
L["Check Box"] = "Auswahlfeld"
L["Slider"] = "Schieberegler"
L["Backdrop Alpha"] = "Hintergrund Transparenz"
L["Enable All"] = "Aktiviere Alles"
L["Disable All"] = "Deaktiviere Alles"
L["Spellbook"] = "Zauberbuch"
L["Character Frame"] = "Charakterfenster"
L["Gossip Frame"] = "Tratschfenster"
L["Quest Frames"] = "Questfenster"
L["TALENTS"] = "Talente"
L["AUCTIONS"] = "Auktionen"
L["FRIENDS"] = "Freunde"
L["GUILD"] = "Gilde"
L["Mail Frame"] = "Mailfenster"
L["WORLD_MAP"] = "Weltkarte"
L["Guild Control Frame"] = "Gildenkontrollfenster"
L["MACROS"] = "Makros"
L["GUILD_BANK"] = "Gildenbank"
L["FLIGHT_MAP"] = "Flugkarte"
L["Help Frame"] = "Hilfefenster"
L["Loot Frames"] = "Beutefenster"
L["CHANNELS"] = "Kanäle"
L["Raid Frame"] = "Raidfenster"
L["Craft"] = "Handwerk"
L["Event Toast Manager"] = "Eventmitteilungs Manager"
L["Quest Choice"] = "Questauswahl"
L["Orderhall"] = "Ordenshalle"
L["Contribution"] = "Beitragsfenster"
L["Calendar Frame"] = "Kalenderfenster"
L["Merchant Frame"] = "Handelsfenster"
L["PvP Frames"] = "PvP Fenster"
L["LF Guild Frame"] = "LF Gildenfenster"
L["TalkingHead"] = "Sprechender Kopf"
L["Minimap"] = "Minikarte"
L["Trainer Frame"] = "Lehrerfenster"
L["Socket Frame"] = "Sockel Fenster"
L["Item Upgrade"] = "Gegenstandsaufwertung"
L["Trade"] = "Handeln"
L["Allied Races"] = "Verbündete Völker"
L["Archaeology Frame"] = "Archäologiefenster"
L["Azerite Essence"] = "Azerite Essenz"
L["Item Interaction"] = "Gegenstandsinteraktion"
L["Anima Diversion"] = "Anima Umleitung"
L["Soulbinds"] = "Seelenbindung"
L["Covenant Sanctum"] = "Paktsanktum"
L["Covenant Preview"] = "Pakt Vorschau"
L["Covenant Renown"] = "Pakt Ruhm"
L["Player Choice"] = "Spielerwahl"
L["Chromie Time"] = "Chromiezeit"
L["LevelUp Display"] = "LevelUp Anzeige"
L["Guide Frame"] = "Guidefenster"
L["Weekly Rewards"] = "Wöchentliche Belohnung"
L["Misc"] = "Sonstiges"
L["%s is not loaded."] = "%s is nicht geladen."
L["BigWigs Bars"] = "BigWigs Leisten"
L["BigWigs Skin"] = true -- no need to translate
L["Color Override"] = "Farbüberschreibung"
L["Emphasized Bar"] = "Hervorgehobene Leisten"
L["Gradient color of the left part of the bar."] = "Farbverlauf des linken Bereiches der Leiste."
L["Gradient color of the right part of the bar."] = "Farbverlauf des rechten Bereiches der Leiste."
L["How to change BigWigs bar style:"] = "Wie man den BigWigs Stil ändert:"
L["Left Color"] = "Linke Farbe"
L["Normal Bar"] = "Normale Leiste"
L["Open BigWigs Options UI with /bw > Bars > Style."] = "Öffne BigWigs Option mit /bw -> Leiste -> Stil."
L["Override the bar color."] = "Überschreibt die Leistenfarbe"
L["Right Color"] = "Rechte Farbe"
L["Show spark on the bar."] = "Zeigt einen Funken auf der Leiste"
L["Smooth"] = "Flüssig"
L["Smooth the bar animation with ElvUI."] = "Flüssige Animation der Leiste mit ElvUI"
L["Spark"] = "Funke"
L["The options below are only for BigWigs %s bar style."] =
	"Die Einstellungen unten sind nur für BigWigs %s Leisten Stil."
L["You need to manually set the bar style to %s in BigWigs first."] = "Du musst zuerst den BigWigs Stile zu %s setzen."
L["The options below is only for the Details look, NOT the Embeded."] =
	"Die nachfolgende Option ist nur für das Aussehen von Details, NICHT die Einbettung."
L["Action Status"] = "Aktionsstatus"
L["Roll Result"] = "Würfelergebnis"
L["It only works when you enable the skin (%s)."] = "Es funktioniert nur, wenn Sie das Skin aktivieren (%s)."
L["Loot"] = "Beute"
L["Embed Settings"] = "Einbettungseinstellungen"
L["With this option you can embed your Details into an own Panel."] =
	"Mit dieser Option kannst Du Dein Details in ein eigenes Panel einbetten."
L["Reset Settings"] = "Zurücksetzen"
L["Toggle Direction"] = "Richtung umschalten"
L["TOP"] = "OBEN"
L["BOTTOM"] = "UNTEN"
L["Advanced Skin Settings"] = "Erweiterte Skin Einstellungen"
L["Queue Timer"] = "Warteschlangen Timer"
L["Gradient Bars"] = "Farbverlaufsleisten"
L["Open Details"] = "Öffne Details"
L["Ease"] = "Übergang"
L["Generally, enabling this option makes the value increase faster in the first half of the animation."] =
	"Im Allgemeinen führt das Aktivieren dieser Option dazu, dass der Wert in der ersten Hälfte der Animation schneller ansteigt."
L["Invert Ease"] = "Übergang umkehren"
L["The easing function used for colorize the button."] =
	"Die Übergangs Funktion, die zum Einfärben der Schaltfläche verwendet wird."
L["UI Widget"] = true -- no need to translate

-- Panels
L["Panels"] = "Leisten"
L["Top Panel"] = "Obere Leiste"
L["Bottom Panel"] = "Untere Leiste"
L["Style Panels"] = "Stilleisten"
L["Top Left Panel"] = "Leiste oben links"
L["Top Left Extra Panel"] = "Extra Leiste oben links"
L["Top Right Panel"] = "Leiste oben rechts"
L["Top Right Extra Panel"] = "Extra Leiste oben rechts"
L["Bottom Left Panel"] = "Leiste unten links"
L["Bottom Left Extra Panel"] = "Extra Leiste unten links"
L["Bottom Right Panel"] = "Leiste unten rechts"
L["Bottom Right Extra Panel"] = "Extra Leiste unten rechts"

-- Objective Tracker
L["Objective Tracker"] = "Questverfolgung"
L["1. Customize the font of Objective Tracker."] = "1. Passe die Schriftart von der Questverfolgung an."
L["2. Add colorful progress text to the quest."] = "2. Füge der Quest einen farblichen Fortschrittstext hinzu."
L["Progress"] = "Fortschritt"
L["No Dash"] = "Kein Strich"
L["Colorful Progress"] = "Farblicher Fortschritt"
L["Percentage"] = "Prozent"
L["Add percentage text after quest text."] = "Füge prozentualen Text nach Questtext hinzu."
L["Colorful Percentage"] = "Farblicher Prozentsatz"
L["Make the additional percentage text be colored."] = "Lasse den zusätzlichen prozentualen Text farbig werden."
L["Cosmetic Bar"] = "Kosmetische Leiste"
L["Border"] = "Rand"
L["Border Alpha"] = "Rahmen Transparenz"
L["Width Mode"] = "Breitenmodus"
L["'Absolute' mode means the width of the bar is fixed."] =
	"Der Modus 'Absolut' bedeutet, dass die Breite des Balkens festgelegt ist."
L["'Dynamic' mode will also add the width of header text."] =
	"Der Modus 'Dynamisch' fügt auch die Breite des Kopfzeilentexts hinzu."
L["'Absolute' mode means the height of the bar is fixed."] =
	"Der Modus 'Absolut' bedeutet, dass die Höhe des Balkens fest ist."
L["'Dynamic' mode will also add the height of header text."] =
	"Der Modus 'Dynamisch' fügt auch die Höhe des Kopfzeilentexts hinzu."
L["Absolute"] = "Absolut"
L["Dyanamic"] = "Dynamisch"
L["Color Mode"] = "Farbmodus"
L["Gradient"] = "Verlauf"
L["Class Color"] = "Klassenfarbe"
L["Normal Color"] = "Normale Farbe"
L["Gradient Color 1"] = "Verlaufsfarbe 1"
L["Gradient Color 2"] = "Verlaufsfarbe 2"
L["Presets"] = "Vorlagen"
L["Preset %d"] = "Vorlage %d"
L["Here are some example presets, just try them!"] = "Hier sind einige Beispiel Vorlagen, probiere sie einfach aus!"
L["Default"] = "Standard"
L["Header"] = "Kopfzeile"
L["Short Header"] = "Kurze Kopfzeile"
L["Use short name instead. e.g. Torghast, Tower of the Damned to Torghast."] =
	"Verwende stattdessen einen Kurznamen. Zum Beispiel Torghast, Turm der Verdammten nach Torghast."
L["Title Color"] = "Titel Farbe"
L["Change the color of quest titles."] = "Ändere die Farbe der Questtitel."
L["Use Class Color"] = "Verwende Klassenfarbe"
L["Highlight Color"] = "Hervorhebungsfarbe"
L["Title"] = "Titel"
L["Bottom Right Offset X"] = "Versatz unten Rechts X"
L["Bottom Right Offset Y"] = "Versatz unten Rechts Y"
L["Top Left Offset X"] = "Versatz oben links X"
L["Top Left Offset Y"] = "Versatz oben links Y"
L["Transparent"] = "Transparent"
L["Style"] = "Stil"
L["Height Mode"] = "Höhenmodus"
L["Menu Title"] = "Menütitel"
L["it shows when objective tracker is collapsed."] = "Wird angezeigt, wenn der Ziel Tracker zusammengeklappt ist."

-- Quest
L["Switch Buttons"] = "Wechsel Tasten"
L["Add a bar that contains buttons to enable/disable modules quickly."] =
	"Das Hinzufügen einer Leiste enthält Schaltflächen zum schnellen Aktivieren / Deaktivieren von Modulen."
L["Hide With Objective Tracker"] = "Verstecke mit Questtracker"
L["Bar Backdrop"] = "Leistenhintergrund"
L["Announcement"] = "Ankündigungen"
L["Quest"] = true
L["Turn In"] = "Annehmen"
L["Make quest acceptance and completion automatically."] = "Quest automatisch annehmen und abschließen."
L["Mode"] = "Auswahl"
L["Only Accept"] = "Nur Angenommene"
L["Only Complete"] = "Nur Abgeschlossene"
L["Pause On Press"] = "Pause beim drücken"
L["Pause the automation by pressing a modifier key."] =
	"Unterbreche die Automatisierung, indem Du eine Modifizierertaste drückst."
L["Reward"] = "Belohnung"
L["Select Reward"] = "Wähle Belohnung"
L["If there are multiple items in the reward list, it will select the reward with the highest sell price."] =
	"Wenn die Belohnungsliste mehrere Artikel enthält, wird die Belohnung mit dem höchsten Verkaufspreis ausgewählt."
L["Get Best Reward"] = "Beste Belohnung erhalten"
L["Complete the quest with the most valuable reward."] = "Schließe die Quest mit der wertvollsten Belohnung ab."
L["Smart Chat"] = "Intelligenter Chat"
L["Chat with NPCs smartly. It will automatically select the best option for you."] =
	"Chatte intelligent mit NPCs. Es wird automatisch die beste Option für Dich auswählen."
L["Dark Moon"] = "Dunkelmond"
L["Accept the teleportation from Darkmoon Faire Mystic Mage automatically."] =
	"Akzeptiere die automatische Teleportation von Mystische Magierin des Dunkelmond-Jahrmarkts."
L["Follower Assignees"] = "Begleiter Assignees"
L["Open the window of follower recruit automatically."] = "Öffne das Fenster zum Begleiter rekrutieren automatisch."
L["Ignored NPCs"] = "Ingnoriere NPC`s"
L["If you add the NPC into the list, all automation will do not work for it."] =
	"Wenn du den NPC zur Liste hinzufügen, funktioniert die gesamte Automatisierung nicht."
L["Ignore List"] = "Ingnoriere Liste"
L["Add Target"] = "Ziel hinzufügen"
L["Make sure you select the NPC as your target."] = "Stelle sicher, dass du den NPC als Ziel auswählst."
L["Delete"] = "Löschen"
L["Delete the selected NPC."] = "Lösche den ausgewählten NPC."

-- Filter
L["Filter"] = true -- no need to translate
L["Unblock the profanity filter."] = "Entsperre den Obszönitätsfilter."
L["Profanity Filter"] = "Obszönitätsfilter"
L["Enable this option will unblock the setting of profanity filter. [CN Server]"] =
	"Wenn Du diese Option aktivierst, wird die Einstellung des Profanitätsfilters aufgehoben. [CN Server]"

-- Friends List
L["Friends List"] = "Freundesliste"
L["Add additional information to the friend frame."] = "Fügt der Freundesliste zusätzliche Informationen hinzu."
L["Modify the texture of status and make name colorful."] =
	"Ändere die Textur des Status und mache den Namen farblich."
L["Enhanced Texture"] = "Verbesserte Textur"
L["Game Icons"] = "Spielsymbole"
L["Default"] = "Standard"
L["Modern"] = true -- no need to translate
L["Status Icon Pack"] = "Status Symbolpack"
L["Diablo 3"] = true -- no need to translate
L["Square"] = "Quadrat"
L["Faction Icon"] = "Fraktions Symbol"
L["Use faction icon instead of WoW icon."] = "Verwende das Fraktionssymbol anstelle des WoW-Symbols."
L["Name"] = true -- no need to translate
L["Level"] = "Stufe"
L["Hide Max Level"] = "Verstecke auf Max Level"
L["Use Note As Name"] = "Notiz als Namen"
L["Replace the Real ID or the character name of friends with your notes."] =
	"Ersetze die Real ID oder den Charakternamen von Freunden durch Deine Notizen."
L["Use Game Color"] = "Verwende Spielfarbe"
L["Change the color of the name to the in-playing game style."] = "Ändere die Farbe des Namens in dem Spielstil."
L["Use Class Color"] = "Verwende Klassenfarbe"
L["Font Setting"] = "Schrifteinstellungen"

-- Advanced Settings
L["Advanced Settings"] = "Erweiterte Einstellungen"
L["Blizzard Fixes"] = "Blizzard Fixe"
L["The message will be shown in chat when you login."] = "Die Nachricht wird im Chat angezeigt, wenn Du Dich anmeldest."
L["CVar Alert"] = "CVar Alarm"
L["It will alert you to reload UI when you change the CVar %s."] =
	"Du wirst darauf hingewiesen, dass die Benutzeroberfläche neu geladen werden muss, wenn Du die CVar %s änderst."
L["Fix LFG Frame error"] = "LFG-Fester Fehler beheben"
L["Fix a PlayerStyle lua error that can happen on the LFG Frame."] =
	"Behebt einen PlayerStyle Lua-Fehler, der im LFG-Fenster auftreten kann."
L["This section will help reset specfic settings back to default."] =
	"Dieser Abschnitt hilft dabei, bestimmte Einstellungen auf die Standardeinstellungen zurückzusetzen."

-- Gradient colors
L["Custom Gradient Colors"] = "Benutzerdefinierte Farbverläufe"
L["Custom Nameplates Colors"] = "Benutzerdefinierte Namensschilder Farben"
L["Only used if using threat plates from ElvUI"] =
	"Wird nur verwendet, wenn Bedrohungsplatten von ElvUI verwendet werden"
L["Custom Unitframes Colors"] = "Benutzerdefinierte Einheitsfenster Farben"
L["Custom Power Colors"] = "Benutzerdefinierte Kraft Farben"
L["Runic Power"] = "Runenkraft"

--Vehicle Bar
L["VehicleBar"] = "Fahrzeugleiste"
L["Change the Vehicle Bar's Button width. The height will scale accordingly in a 4:3 aspect ratio."] =
	"Ändere die Schaltflächenbreite der Fahrzeugleiste. Die Höhe wird entsprechend im Seitenverhältnis 4:3 skaliert."
L["Thrill Color"] = "Nervenkitzel Farbe"
L["The color for vigor bar's speed text when you are regaining vigor."] =
	"Farbe für den Geschwindigkeitstext der Flugeiste, wenn Du Elan zurückgewinnst."
L["Animations"] = "Animationen"
L["Animation Speed"] = "Animations Geschwindigkeit"
L["Skyriding Bar"] = "Flugleiste"

-- Delete Item
L["Delete Item"] = "Lösche Item"
L["This module provides several easy-to-use methods of deleting items."] =
	"Dieses Modul bietet verschiedene benutzerfreundliche Methoden zum Löschen von Elementen."
L["Use Delete Key"] = "Verwende Löschtaste"
L["Allow you to use Delete Key for confirming deleting."] =
	"Ermöglicht die Verwendung der Entf-Taste zum Bestätigen des Löschens."
L["Fill In"] = "Füllen"
L["Disable"] = "Deaktivieren"
L["Fill by click"] = "Mit Klick einfügen"
L["Auto Fill"] = "Auto Einfügen"
L["Press the |cffffd200Delete|r key as confirmation."] = "Drücke zur Bestätigung die Taste |cffffd200Entfernen|r."
L["Click to confirm"] = "Klicke zur Bestätigung"

-- Profiles
L["MER_PROFILE_DESC"] = [[Dieser Abschnitt erstellt Profile für einige AddOns.

|cffff0000ACHTUNG:|r Vorhandene Profile werden überschrieben/gelöscht. Wenn du meine Profile nicht anweden möchtest, bitte drücke nicht die unteren Tasten.]]

-- Addons
L["Skins/AddOns"] = true -- no need to translate
L["Profiles"] = "Profile"
L["BigWigs"] = true -- no need to translate
L["MasterPlan"] = true -- no need to translate
L["Shadow & Light"] = "|cff9482c9Shadow & Light|r"
L["This will create and apply profile for "] = "Dieses wird ein Profil erstellen und anwenden für "

-- Changelog
L["Changelog"] = "Änderungen"

-- Compatibility
L["Compatibility Check"] = "Kompatibilitätsprüfung"
L["Help you to enable/disable the modules for a better experience with other plugins."] =
	"Hilf beim Aktivieren / Deaktivieren der Module, um eine bessere Erfahrung mit anderen Plugins zu erzielen."
L["There are many modules from different addons or ElvUI plugins, but several of them are almost the same functionality."] =
	"Es gibt viele Module von verschiedenen Addons oder ElvUI-Plugins, aber einige davon haben fast die gleiche Funktionalität."
L["Have a good time with %s!"] = "Viel Spaß mit %s!"
L["Choose the module you would like to |cff00ff00use|r"] =
	"Wähle das Modul aus, das Du |cff00ff00verwenden|r möchtest."
L["If you find the %s module conflicts with another addon, alert me via Discord."] =
	"Wenn Du feststellst, dass das %s Modul mit einem anderen Addon in Konflikt steht, benachrichtige mich über Discord."
L["You can disable/enable compatibility check via the option in the bottom of [MerathilisUI]-[Information]."] =
	"Du kannst die Kompatibilitätsprüfung über die Option unten in [MerathilisUI]-[Informationen] deaktivieren/aktivieren."
L["Complete"] = "Komplett"

-- Profiles
L[" Apply"] = "Anwenden"
L[" Reset"] = "Zurücksetzen"
L["This group allows to update all fonts used in the "] =
	"Diese Gruppe ermöglicht die Aktualisierung aller Schriftarten in "
L["WARNING: Some fonts might still not look ideal! The results will not be ideal, but it should help you customize the fonts :)\n"] =
	"ACHTUNG: Einige Schriftarten sehen möglicherweise trotzdem nicht optimal aus! Die Ergebnisse werden nicht optimal sein, aber es sollte Dir helfen, die Schriftarten anzupassen :)\n"
L["Applies all |cffffffffMerathilis|r|cffff7d0aUI|r font settings."] =
	"Wendet alle |cffffffffMerathilis|r|cffff7d0aUI|r Schriftart Einstellungen an."
L["Resets all |cffffffffMerathilis|r|cffff7d0aUI|r font settings."] =
	"Setzt alle |cffffffffMerathilis|r|cffff7d0aUI|r Schriftart Einstellungen zurück."

-- Debug
L["Usage"] = "Verwendungszweck"
L["Enable debug mode"] = "Debug Modus aktivieren"
L["Disable all other addons except ElvUI Core, ElvUI %s and BugSack."] =
	"Deaktiviere alle anderen Addons außer ElvUI Core, ElvUI %s und BugSack."
L["Disable debug mode"] = "Debug Modus deaktivieren"
L["Reenable the addons that disabled by debug mode."] =
	"Aktiviere die Addons, die durch den Debug Modus deaktiviert wurden."
L["Debug Enviroment"] = "Debug Umgebung"
L["You can use |cff00ff00/muidebug off|r command to exit debug mode."] =
	"Du kannst den Befehl |cff00ff00/muidebug off|r verwenden, um den Debug Modus zu verlassen."
L["After you stop debuging, %s will reenable the addons automatically."] =
	"Nachdem Du das Debuggen beendet hast, wird %s die Addons automatisch aktivieren."
L["Before you submit a bug, please enable debug mode with %s and test it one more time."] =
	"Bevor Du einen Fehler meldest, aktiviere bitte den Debug Modus mit dem %s Befehl und teste es noch einmal."
L["Error"] = "Fehler"
L["Warning"] = "Warnung"

-- Abbreviate
L["[ABBR] Algeth'ar Academy"] = "AA"
L["[ABBR] Announcement"] = "ANN"
L["[ABBR] Back"] = "Rücken"
L["[ABBR] Challenge Level 1"] = "CL1"
L["[ABBR] Chest"] = "Brust"
L["[ABBR] Community"] = "C"
L["[ABBR] Court of Stars"] = "CoS"
L["[ABBR] Delves"] = "Delves"
L["[ABBR] Dragonflight Keystone Hero: Season One"] = "Keystone Hero S1"
L["[ABBR] Dragonflight Keystone Master: Season One"] = "Keystone Master S1"
L["[ABBR] Emote"] = "E"
L["[ABBR] Event Scenario"] = "EScen"
L["[ABBR] Feet"] = "Füße"
L["[ABBR] Finger"] = "Finger"
L["[ABBR] Follower"] = "Follower"
L["[ABBR] Guild"] = "G"
L["[ABBR] Halls of Valor"] = "HoV"
L["[ABBR] Hands"] = "Hände"
L["[ABBR] Head"] = "Kopf"
L["[ABBR] Held In Off-hand"] = "Schildhand"
L["[ABBR] Heroic"] = "H"
L["[ABBR] Instance"] = "I"
L["[ABBR] Instance Leader"] = "IL"
L["[ABBR] Legs"] = "Beine"
L["[ABBR] Looking for Raid"] = "LFR"
L["[ABBR] Mythic"] = "M"
L["[ABBR] Mythic Keystone"] = "M+"
L["[ABBR] Neck"] = "Hals"
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
L["[ABBR] Shoulders"] = "Schultern"
L["[ABBR] Story"] = "Story"
L["[ABBR] Teeming Island"] = "Teeming"
L["[ABBR] Temple of the Jade Serpent"] = "TotJS"
L["[ABBR] The Azure Vault"] = "AV"
L["[ABBR] The Nokhud Offensive"] = "NO"
L["[ABBR] Timewalking"] = "TW"
L["[ABBR] Torghast"] = "Torghast"
L["[ABBR] Trinket"] = "Schmuckstück"
L["[ABBR] Turn In"] = "TURNIN"
L["[ABBR] Vault of the Incarnates"] = "VotI"
L["[ABBR] Visions of N'Zoth"] = "Visions"
L["[ABBR] Waist"] = "Gürtel"
L["[ABBR] Warfronts"] = "WF"
L["[ABBR] Whisper"] = "Flüstern"
L["[ABBR] Wind Emote"] = "WE"
L["[ABBR] World"] = "W"
L["[ABBR] World Boss"] = "WB"
L["[ABBR] Wrist"] = "Handgelenk"
L["[ABBR] Yell"] = "S"
