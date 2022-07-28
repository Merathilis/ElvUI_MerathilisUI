-- German localization file for deDE
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "deDE")

-- Core
L["Enable"] = "Eingeschaltet"
L[" is loaded. For any issues or suggestions, please visit "] = " wurde geladen. Für Fehler oder Vorschläge besuche bitte: "
L["Font"] = "Schriftart"
L["Size"] = "Größe"
L["Width"] = "Breite"
L["Height"] = "Höhe"
L["Alpha"] = "Transparenz"

-- General Options
L["Plugin for |cffff7d0aElvUI|r by\nMerathilis."] = "Plugin für |cffff7d0aElvUI|r von\nMerathilis."
L["by Merathilis (|cFF00c0faEU-Shattrath|r)"] = "von Merathilis (|cFF00c0faEU-Shattrath|r)"
L["AFK"] = "AFK"
L["Enable/Disable the MUI AFK Screen. Disabled if BenikUI is loaded"] = "Aktiviert/Deaktiviert den MUI AFK Bildschirm. Wird automatisch deaktiviert, wenn BenikUI geladen wurde."
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

-- Core Options
L["Login Message"] = "Login Nachricht"
L["Enable/Disable the Login Message in Chat"] = "Aktiviert/Deaktiviert die Login Nachricht im Chat"
L["Log Level"] = true
L["Only display log message that the level is higher than you choose."] = "Zeigt nur die Log Nachrichten an über dem Level dass du ausgewählt hast"
L["Set to 2 if you do not understand the meaning of log level."] = "Setze auf 2 wenn du keine Ahnung vom Log Level hast. :)"

-- Bags
L["Equipment Manager"] = "Ausrüstungsmanager"
L["Equipment Set Overlay"] = "Ausrüstungssetanzeige"
L["Show the associated equipment sets for the items in your bags (or bank)."] = "Zeigt verbundene Ausrüstungssets auf Gegenständen in deinen Taschen und in der Bank an."

-- Chat
L["CHAT_AFK"] = "[AFK]"
L["CHAT_DND"] = "[DND]"
L["BACK"] = "Zurück"
L["ERR_FRIEND_ONLINE"] = "ist jetzt |cff298F00online|r."
L["ERR_FRIEND_OFFLINE"] = "ist jetzt |cffff0000offline|r."
L["BN_INLINE_TOAST_FRIEND_ONLINE"] = " ist jetzt |cff298F00online|r."
L["BN_INLINE_TOAST_FRIEND_OFFLINE"] = " ist jetzt |cffff0000offline|r."
L["has come |cff298F00online|r."] = "ist jetzt |cff298F00online|r." -- Guild Message
L["has gone |cffff0000offline|r."] = "ist jetzt |cffff0000offline|r." -- Guild Message
L[" has come |cff298F00online|r."] = " ist jetzt |cff298F00online|r." -- Battle.Net Message
L[" has gone |cffff0000offline|r."] = " ist jetzt |cffff0000offline|r." -- Battle.Net Message
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
L["Adds an overlay to the Community Chat. Useful for streamers."] = "Fügt ein Overlay zum Community Chat hinzu. Nützlich für Streamer."
L["Chat Hidden. Click to show"] = "Chat verstecken. Klicken um ihn wieder anzuzeigen"
L["Click to open Emoticon Frame"] = "Öffnet das Fenster mit Emote Symbolen"
L["Emotes"] = true -- no need to translate
L["Damage Meter Filter"] = "Damage Meter Filter"
L["Fade Chat"] = "Chat ausblenden"
L["Auto hide timeout"] = "Autom. Ausblendzeit"
L["Seconds before fading chat panel"] = "Sek. vor dem Ausblenden des Chat Panels"
L["Seperators"] = "Trennlinien"
L["Orientation"] = "Orientierung"
L["Please use Blizzard Communities UI add the channel to your main chat frame first."] = "Verwende die Benutzeroberfläche von Blizzard Communities. Füge den Kanal zuerst zu Deinem Hauptchat Frame hinzu."
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
L["Only show chat bar when you mouse over it."] = "Zeige die Chatleiste nur an, wenn mit der Maus darüber gefahren wird."
L["Button"] = "Tasten"
L["Item Level Links"] = "Gegenstandsstufen Links"
L["Block"] = "Blöcke"
L["Custom Online Message"] = "Benutzerdefinierte Online Nachricht"
L["Chat Link"] = "Chatlink"
L["Add extra information on the link, so that you can get basic information but do not need to click"] = "Füge dem Link zusätzliche Informationen hinzu, damit grundlegende Informationen erhalten sind, aber nicht geklickt werden muss."
L["Additional Information"] = "Zusätzliche Information"
L["Level"] = "Level"
L["Translate Item"] = "Übersetze Gegenstand"
L["Translate the name in item links into your language."] = "Übersetze den Namen in Gegenstandlinks in Deiner Sprache."
L["Icon"] = "Symbol"
L["Armor Category"] = "Rüstungs Kategorie"
L["Weapon Category"] = "Waffenkategorie"
L["Filters some messages out of your chat, that some Spam AddOns use."] = "Filtert einige Nachrichten von Spam AddOns aus deinem Chat."

-- Combat Alert
L["Combat Alert"] = "Kampfalarmierung"
L["Enable/Disable the combat message if you enter/leave the combat."] = "Aktiviert/Deaktiviert die Kampf Nachricht, wenn du den Kampf betrittst, oder verlässt."
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
L["Tukui"] = true
L["Github"] = true
L["CurseForge"] = true
L["Coding"] = true
L["Testing & Inspiration"] = "Tester & Inspiration"
L["Development Version"] = "Entwicklungsversion"
L["Here you can download the latest development version."] = "Hier findest du den Download zu meiner Development Version."
L["Donations"] = "Spenden"

-- Modules
L["Here you find the options for all the different |cffffffffMerathilis|r|cffff8000UI|r modules."] = "Hier findest du alle Optionen zu den verschiedenen |cffffffffMerathilis|r|cffff8000UI|r Modulen."
L["Are you sure you want to reset %s module?"] = "Bist Du sicher, dass Du das %s Modul zurücksetzen möchtest?"
L["Reset All Modules"] = "Alle Module zurücksetzen"
L["Reset all %s modules."] = "Setze alle %s Module zurück."

-- GameMenu
L["GameMenu"] = "Spielmenü"
L["Enable/Disable the MerathilisUI Style from the Blizzard GameMenu. (e.g. Pepe, Logo, Bars)"] = "Aktiviert/Deaktiviert den MerathilisUI Stil aus dem Blizzard Spielmenü. (zB. Pepe, Logo, Leisten)"

-- Extended Vendor
L["Extended Vendor"] = "Erweiterter Händler"

-- FlightMode
L["FlightMode"] = "Flugmodus"
L["Enhance the |cff00c0faBenikUI|r FlightMode.\nTo completely disable the FlightMode go into the |cff00c0faBenikUI|r Options."] = "Erweitert den |cff00c0faBenikUI|r Flugmodus.\nUm den Flugmodus komplett zu deaktivieren gehe bitte in die |cff00c0faBenikUI|r Optionen."
L["Exit FlightMode"] = "Verlasse Flugmodus"
L["Left Click to Request Stop"] = "Linksklick um zu landen"

-- FlightPoint
L["Flight Point"] = "Flugpunkt"
L["Enable/Disable the MerathilisUI Flight Points on the FlightMap."] = "Aktivert/Deaktiviert die MerathilisUI Flugpunkte auf der Flugkarte."

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

-- MicroBar
L["Backdrop"] = "Hintergrund"
L["Backdrop Spacing"] = "Hintergrund Abstand"
L["The spacing between the backdrop and the buttons."] = "Der Abstand zwischen dem Hintergrund und den Tasten"
L["Time Width"] = "Zeit Breite"
L["Time Height"] = "Zeit Höhe"
L["The spacing between buttons."] = "Der Abstand zwischen den Tasten."
L["The size of the buttons."] = "Die Größe der Tasten."
L["Slow Mode"] = "Langsamer Modus"
L["Update the additional text every 10 seconds rather than every 1 second such that the used memory will be lower."] = "Aktualisiert den zusätzlichen Text jede 10 Sekunden anstatt jede Sekunde, wirkt sich auf den Speicher aus."
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
L["Home"] = true
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
L["Undress"] = "Ausziehen"
L["Flashing Cursor"] = "Blinkender Mauszeiger"
L["Lights up the cursor to make it easier to see."] = "Läßt den Cursor aufleuchten um ihn besser zu erkennen."
L["Accept Quest"] = "Quest annehmen"
L["Placed Item"] = "Platzierter Gegenstand"
L["Stranger"] = "Fremder"
L["Keystones"] = "Schlüsselsteine"
L["GUILD_MOTD_LABEL2"] = "Gildennachricht des Tages"
L["LFG Member Info"] = "LFG Mitglieder Info"
L["Shows role informations in your tooltip in the lfg frame."] = "Zeigt die Rollen der Gruppenmitglieder im Tooltip des LFG Fensters an."
L["MISC_REPUTATION"] = "Ruf"
L["MISC_PARAGON"] = "Paragon"
L["MISC_PARAGON_REPUTATION"] = "Paragon Ruf"
L["MISC_PARAGON_NOTIFY"] = "Maximaler Ruf - Belohnung abholen."
L["Fun Stuff"] = "Lustiges Zeugs"
L["Change the NPC Talk Frame."] = "Ändert das NPC Sprechfenster ab."
L["Press CTRL + C to copy."] = "Drücke STRG + C zum Kopieren."
L["Wowhead Links"] = true
L["Adds Wowhead links to the Achievement- and WorldMap Frame"] = "Fügt Wowhead Links dem Erfolgfenster und der Weltkarte hinzu."
L["Highest Quest Reward"] = "Höchste Questbelohnung"
L["Automatically select the item with the highest reward."] = "Wählt automatisch den Gegenstand mit dem höchsten Wert aus."
L["Item Alerts"] = "Gegenstandsalarm"
L["Announce in chat when someone placed an usefull item."] = "Kündigt im Chat an, wenn jemand einen nützlichen Gegenstand stellt."
L["Maw ThreatBar"] = "Schlund Bedrohungleiste"
L["Replace the Maw Threat Display, with a simple StatusBar"] = "Ersetzt die Schlundbedrohungsanzeige mit einer einfachen Statusleiste."
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
L["Creates a random toy macro."] = "Erzeugt ein zufälliges Spielzeugmakro."
L["Text Style"] = "Textstil"
L["COLOR"] = "Farbe"
L.ANNOUNCE_FP_PRE = "{rt1} %s bereitet ein %s vor. {rt1}"
L.ANNOUNCE_FP_CLICK = "{rt1} %s zaubert ein %s. Klick! {rt1}"
L.ANNOUNCE_FP_USE = "{rt1} %s benutzte %s. {rt1}"
L.ANNOUNCE_FP_CAST = "{rt1} %s zaubert ein %s. {rt1}"
L["Hide Boss Banner"] = "Verstecke Boss Banner"
L["This will hide the popup, that shows loot, after you kill a boss"] = "Dies wird das Popup verbergen, das Beute anzeigt, nachdem Du einen Boss getötet hast."

-- Nameplates
L["NamePlates"] = "Namensplaketten"
L["Enhanced NameplateAuras"] = "Erweiterte Namensplaketten Auren"

-- Tooltip
L["Your Status:"] = "Dein Status:"
L["Your Status: Incomplete"] = "Dein Status: Unvollständig"
L["Your Status: Completed on "] = "Dein Status: Abgeschlossen am "
L["Adds an icon for spells and items on your tooltip."] = "Fügt ein Symbol für Zauber und Gegenstände am Tooltip hinzu."
L["Adds an Icon for battle pets on the tooltip."] = "Fügt ein Haustiersymbol zum Tooltip hinzu."
L["Adds an Icon for the faction on the tooltip."] = "Fügt ein Symbol für die Fraktion am Tooltip hinzu."
L["Adds information to the tooltip, on which char you earned an achievement."] = "Fügt Information am Tooltip hinzu, von welchem Char der Erfolg errungen wurde."
L["Keystone"] = "Schlüsselstein"
L["Adds descriptions for mythic keystone properties to their tooltips."] = "Fügt eine Beschreibung für mythische Schlüsselsteineigenschaften dem Tooltip hinzu."
L["Title Color"] = "Titelfarbe"
L["Change the color of the title in the Tooltip."] = "Ändert die Farbe des Titels im Tooltip."
L["Progress Info"] = "Fortschrittsinfo"
L["Shows raid progress of a character in the tooltip"] = "Zeigt den Schlachtzugsfortschritt für einen Charakter im Tooltip an."
L["Mythic"] = "Mythisch"
L["Heroic"] = "Heroisch"
L["Normal"] = true
L["LFR"] = true
L["Uldir"] = true
L["Battle Of Dazaralor"] = "Schlacht um Dazar'alor"
L["Crucible Of Storms"] = "Tiegel der Stürme"
L["Eternal Palace"] = "Der Ewige Palast"
L["Ny'alotha"] = "Ny'alotha"
L["Castle Nathria"] = "Schloss Nathria"
L["Sanctum of Domination"] = "Sanktum der Herrschaft"
L["Sepulcher of the First Ones"] = "Mausoleum der Ersten"
L["FACTION"] = "Fraktion"
L["HEART_OF_AZEROTH_MISSING_ACTIVE_POWERS"] = "Aktive Azeritboni"
L["Only Icons"] = "Nur Symbole"
L["Use the new style tooltip."] = "Neuen Tooltip Stil verwenden."
L["Display in English"] = "Nur Englisch verwenden"
L["Show icon"] = "Symbol anzeigen"
L["Show the spell icon along with the name."] = "Das Zaubersymbol zusammen mit dem Namen anzeigen."
L["Covenant: <Not in Group>"] = "Pakt: <Nicht in Gruppe>"
L["Covenant: <Checking...>"] = "Pakt: <überprüfe>"
L["Covenant: <None - Too low>"] = "Pakt: <Nichts - Nicht berechtigt>"
L["Covenant"] = "Pakt"
L["Covenant: "] = "Pakt: "
L["Shows the Players Covenant on the Tooltip."] = "Zeigt den Pakt vom Spieler am Tooltip an."
L["Show not in group"] = "Zeige nicht in Gruppe"
L["Keep the Covenant Line when not in a group. Showing: <Not in Group>"] = "Zeigt die Pakt-Linie an wenn nicht in Gruppe. Zeigt an: <Nicht in Gruppe>"
L["Kyrian"] = "Kyrianer"
L["Venthyr"] = true
L["NightFae"] = "Nachtfae"
L["Necrolord"] = "Nekrolords"

-- Notification
L["Notification"] = "Benachrichtigungen"
L["Display a Toast Frame for different notifications."] = "Zeigt ein Fenster mit verschiedenen Benachrichtigungen an."
L["This is an example of a notification."] = "Beispiel Benachrichtigung."
L["Notification Mover"] = "Benachrichtigungs Mover"
L["%s slot needs to repair, current durability is %d."] = "%s braucht eine Reparatur, aktuelle Haltbarkeit ist %d."
L["You have %s pending calendar invite(s)."] = "Du hast %s ausstehende Kalendereinladungen"
L["You have %s pending guild event(s)."] = "Du hast %s ausstehende Gildenereignisse"
L["Event \"%s\" will end today."] = "Ereignis \"%s\" endet heute."
L["Event \"%s\" started today."] = "Ereignis \"%s\" beginnt heute."
L["Event \"%s\" is ongoing."] = "Ereignis \"%s\" ist im Gange."
L["Event \"%s\" will end tomorrow."] = "Ereignis \"%s\" endet morgen."
L["Here you can enable/disable the different notification types."] = "Hier kannst du die verschiedenen Benachrichtigungstypen aktivieren/deaktivieren."
L["Enable Mail"] = "Aktiviere Post"
L["Enable Vignette"] = "Aktiviere Vignette"
L["If a Rare Mob or a treasure gets spotted on the minimap."] = "Zeigt an, wenn ein Rare Mob, oder ein Schatz auf der Minikarte erscheint."
L["Enable Invites"] = "Aktiviere Einladungen"
L["Enable Guild Events"] = "Aktiviere Gildenereignisse"
L["No Sounds"] = "Keine Töne"
L["Domination Rank"] = "Splitter der Herrschaft Rang"
L["Show the rank of shards."] = "Zeigt den Rang vom Splitter."
L["Vignette Print"] = "Vignettenlink"
L["Prints a clickable Link with Coords in the Chat."] = "Fügt einen anklickbaren Link mit Koordinaten im Chat hinzu."
L["Quick Join"] = "Schnellbeitritt"
L["Title Font"] = "Titel Schriftart"
L["Text Font"] = "Text Schriftart"

-- DataTexts
-- DataBars
L["DataBars"] = "Informationsleisten"
L["Add some stylish buttons at the bottom of the DataBars"] = "Fügt unten an den Informationsleisten transparente Tasten hinzu"
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
L["Automatically release body when killed inside a battleground."] = "Lass den Körper automatisch frei, wenn Du auf einem Schlachtfeld getötet wurdest."
L["Check for rebirth mechanics"] = "Überprüfe die Wiedergeburtsmechanik"
L["Do not release if reincarnation or soulstone is up."] = "Nicht freigeben, wenn Reinkarnation oder Seelenstein vorhanden sind."

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
L["Outline"] = "Outline"
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
L["Alpha Min"] = true -- No need to translate
L["Alpha Max"] = true -- No need to translate

-- Armory
L["Armory"] = "Arsenal"
L["ARMORY_DESC"] = [=[Der |cffff7d0aArmory Mode|r funktioniert nur mit den 'ElvUI Charakter Informationen'. Es könnte sein, dass du dein UI neuladen musst:

ElvUI - Allgemeine - Blizzard Verbesserungen - Zeige Charakterinformationen.]=]

L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."] = "|cffff7d0aMerathilisUI|r Arsenal aktivieren/deaktivieren"
L["Durability"] = "Haltbarkeit"
L["Enable/Disable the display of durability information on the character window."] = "Haltbarkeit im Charakterfenster anzeigen/verbergen"
L["Damaged Only"] = "Nur beschädigt"
L["Only show durability information for items that are damaged."] = "Haltbarkeit nur bei beschädigten Gegenständen anzeigen"
L["Itemlevel"] = "Gegenstandsstufe"
L["Enable/Disable the display of item levels on the character window."] = "Gegenstandsstufen im Charakterfenster anzeigen/verbergen"
L["Level"] = "Stufe"
L["Full Item Level"] = "Vollständige Gegenstandsstufe"
L["Show both equipped and average item levels."] = "Ausgerüstete und durchschnittliche Gegenstandsstufe anzeigen"
L["Item Level Coloring"] = "Gegenstandsstufe färben"
L["Color code item levels values. Equipped will be gradient, average - selected color."] = "Färbt die Gegenstandsstufe ein. Ausgerüstete Stufe wird kombiniert, Maximalstufe entspricht der ausgewählten Farbe"
L["Color of Average"] = "Durchschnittsfarbe"
L["Sets the color of average item level."] = "Setzt die Farbe der durchschnittlichen Gegenstandsstufe"
L["Only Relevant Stats"] = "Nur relevante Attribute"
L["Show only those primary stats relevant to your spec."] = "Nur die relevanten, primären Attribute deiner Spezialisierung anzeigen"
L["Item Level"] = "Gegenstandsstufe"
L["Categories"] = "Kategorien"
L["Slot Gradient"] = "Ausrüstungsplatz Farbverlauf"
L["Indicators"] = "Indikatoren"
L["Shows a gradiation texture on the Character Slots."] = "Zeigt einen Farbverlauf auf den Ausrüstungsplätzen"
L["Transmog"] = true
L["Shows an arrow indictor for currently transmogrified items."] = "Zeigt einen Indikator für den derzeitig transmogrifizierten Gegenstand an."
L["Illusion"] = "Illusionen"
L["Shows an indictor for weapon illusions."] = "Zeigt einen Indikator für die Waffenillusionen an."
L["Empty Socket"] = "Leerer Sockel"
L["Not Enchanted"] = "Nicht verzaubert"
L["Warnings"] = "Warnungen"
L["Shows an indicator for missing sockets and enchants."] = "Zeigt einen Indikator für fehlende Sockel und Verzauberungen an."
L["Expanded Size"] = "Erweiterte Größe"
L["This will increase the Character Frame size a bit."] = "Dieses wird das Charakterfenster etwas vergrößern."
L["Armor Set"] = "Rüstungsset"
L["Colors Set Items in a different color."] = "Färbt Elemente in einer anderen Farbe ein."
L["Armor Set Gradient Texture Color"] = "Rüstungssettextur Verlaufsfarbe"
L["Full Item Level"] = "Volle Gegenstandsstufe"
L["Show both equipped and average item levels."] = "Zeige sowohl ausgerüstete als auch durchschnittliche Gegenstandsstufen."
L["Item Level Coloring"] = "Gegenstandsstufen Färbung"
L["Color code item levels values. Equipped will be gradient, average - selected color."] = "Werte der Farbcode Gegenstandsebenen. Ausgestattet mit Farbverlauf, Durchschnitt - ausgewählte Farbe."
L["Color of Average"] = "Durchschnittsfarbe"
L["Sets the color of average item level."] = "Legt die Farbe der durchschnittlichen Gegenstandsstufe fest."
L["Warning Gradient Texture Color"] = "Warnung Verlaufsfarbe"
L["Class Color Gradient"] = "Klassenfarbenverlauf"

-- Media
L["Zone Text"] = "Gebietstext"
L["Font Size"] = "Schriftgröße"
L["Subzone Text"] = "Unterzonentext"
L["PvP Status Text"] = "PvP Statustext"
L["Misc Texts"] = "Sonstiger Text"
L["Mail Text"] = "Post Text"
L["Chat Editbox Text"] = true
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
L["Adds a shadow to the debuffs that the debuff color is more visible."] = "Fügt einen Schatten zu den Schwächungszaubern hinzu, so dass die Schwächungszauberfarbe besser sichtbar ist."
L["Swing Bar"] = "Schwungleiste"
L["Creates a weapon Swing Bar"] = "Erstellt eine Waffenschwungleiste"
L["Main-Hand Color"] = "Haupthand Farbe"
L["Off-Hand Color"] = "Schildhand Farbe"
L["Two-Hand Color"] = "Zweihand Farbe"
L["GCD Bar"] = "GCD Leiste"
L["Creates a Global Cooldown Bar"] = "Erstellt eine globale Leiste mit Abklingzeiten"
L["UnitFrame Style"] = "Einheitenfenster Stil"
L["Adds my styling to the Unitframes if you use transparent health."] = "Fügt meinen Stil zu den Einheitenfenstern hinzu, wenn du transparentes Leben benutzt."
L["Change the default role icons."] = "Ändert die Standard Rollensymbole."
L["Changes the Heal Prediction texture to the default Blizzard ones."] = "Ändert die 'Eingehende Heilung' Textur auf Standard Blizzard"
L["Add a glow in the end of health bars to indicate the over absorb."] = "Füge am Ende der Gesundheitsbalken ein Leuchten hinzu, um die Überabsorption anzuzeigen."
L["Add the Blizzard over absorb glow and overlay to ElvUI unit frames."] = "Füge den ElvUI Einheitenfenstern das Blizzard Überabsorptionsleuchten und die Überlagerung hinzu."
L["Auto Height"] = "Auto Höhe"
L["Blizzard Absorb Overlay"] = "Blizzard Absorptions Overlay"
L["Blizzard Over Absorb Glow"] = "Blizzard Absorptionslesuchten"
L["Blizzard Style"] = "Blizzard Stil"
L["Change the color of the absorb bar."] = "Ändere die Farbe der Absorptionsleiste."
L["Custom Texture"] = "Benutzerdefinierte Textur"
L["Enable the replacing of ElvUI absorb bar textures."] = "Ersetzen von ElvUI Absorptionsleistentexturen aktivieren."
L["Here are some buttons for helping you change the setting of all absorb bars by one-click."] = "Hier sind einige Schaltflächen, mit denen Du die Einstellung aller Absorptionsleisten mit einem Klick ändern kannst."
L["Max Overflow"] = "Maximaler Überschuss"
L["Modify the texture of the absorb bar."] = "Ändere die Textur der Absorptionsleiste."
L["Overflow"] = "Überschuss"
L["Set %s to %s"] = "Setze %s auf %s"
L["Set All Absorb Style to %s"] = "Alle Absorptionsstile auf %s setzen"
L["The absorb style %s and %s is highly recommended with %s tweaks."] = "Der Absorptionsstil %s und %s wird mit %s Optimierungen dringend empfohlen."
L["The selected texture will override the ElvUI default absorb bar texture."] = "Die ausgewählte Textur überschreibt die standardmäßige ElvUI Absorptionsleistentextur."
L["Use the texture from Blizzard Raid Frames."] = "Verwende die Textur von Blizzard Schlachtzugsfenster."

-- LocationPanel
L["Location Panel"] = "Standort Panel"
L["Update Throttle"] = "Aktualisierung drosseln"
L["The frequency of coordinates and zonetext updates. Check will be done more often with lower values."] = "Die Frequenz wie oft die Koordinaten und der Zonentext aktualisiert wird. Je geringer der Wert, desto öfter wird aktualisiert."
L["Full Location"] = "Vollständige Position "
L["Color Type"] = "Farbentyp"
L["Custom Color"] = "Benutzerdefinerte Farbe"
L["Reaction"] = "Reaktion"
L["Location"] = "Position"
L["Coordinates"] = "Koordinaten"
L["Teleports"] = "Teleport"
L["Portals"] = "Portale"
L["Link Position"] = "Linke Position"
L["Allow pasting of your coordinates in chat editbox via holding shift and clicking on the location name."] = "Erlaubt die Koordinaten im Chat zu verlinken, via Shift + Linksklick."
L["Relocation Menu"] = "Menü versetzen"
L["Right click on the location panel will bring up a menu with available options for relocating your character (e.g. Hearthstones, Portals, etc)."] = "Rechtsklicke auf das Location Panel um ein Menü zu öffnen und um mehrere Auswahlmöglichkeiten zu erhalten (z.B. Ruhestein, Portale, etc.)."
L["Custom Width"] = "Benutzerdefinerte Breite"
L["By default menu's width will be equal to the location panel width. Checking this option will allow you to set own width."] = "Standardmäßig hat das Menü die Breite des Location Panel. Wenn du diese Option aktivierst, kannst du die Breite ändern."
L["Justify Text"] = "Text ausrichten"
L["Auto Width"] = "Autom. Breite"
L["Change width based on the zone name length."] = "Ändert die Breite nach dem Zonentext."
L["Hearthstone Location"] = "Ruhestein Position"
L["Show the name on location your Hearthstone is bound to."] = "Zeige die Position an wo Dein Ruhestein liegt."
L["Combat Hide"] = "Im Kampf ausblenden"
L["Show/Hide all panels when in combat"] = "Zeige/Verstecke alle Panels während des Kampfes"
L["Hide In Class Hall"] = "In der Klassenhalle ausblenden"
L["Hearthstone Toys Order"] = "Ruhestein, Spielzeuge Reihenfolge"
L["Show hearthstones"] = "Zeige Ruhestein"
L["Show hearthstone type items in the list."] = "Zeigt Ruhesteingegenstände in der Liste"
L["Show Toys"] = "Zeige Spielzeuge"
L["Show toys in the list. This option will affect all other display options as well."] = "Zeigt Spielzeuge in der Liste an. Diese Option wirkt sich auf alle anderen Anzeigeoptionen aus."
L["Show spells"] = "Zeige Zauber"
L["Show relocation spells in the list."] = "Zeigt Teleportzauber in der Liste an."
L["Show engineer gadgets"] = "Zeige Ingenieursspielereien."
L["Show items used only by engineers when the profession is learned."] = "Zeigt Gegenstände, die nur von Ingenieuren genutzt werden können, sowie wenn der Beruf erlernt wurde, an."
L["Ignore missing info"] = "Ignoriere fehlende Informationen"
L["MER_LOCPANEL_IGNOREMISSINGINFO"] = [[Due to how client functions some item info may become unavailable for a period of time. This mostly happens to toys info.
When called the menu will wait for all information being available before showing up. This may resul in menu opening after some concidarable amount of time, depends on how fast the server will answer info requests.
By enabling this option you'll make the menu ignore items with missing info, resulting in them not showing up in the list.]]
L["Info for some items is not available yet. Please try again later"] = "Informationen für einige Gegenstände sind zur Zeit nicht verfügbar. Bitte später noch einmal versuchen"
L["Update canceled."] = "Aktualisierung abgebrochen."
L["Item info is not available. Waiting for it. This can take some time. Menu will be opened automatically when all info becomes available. Calling menu again during the update will cancel it."] = "Gegenstandsinformation ist nicht verfügbar. Dieses kann ein bisschen dauern um die Informationen zu sammeln. Das Menü wird automatisch geöffnet, wenn alle Informationen gesammelt wurden. Erneutes Aufrufen des Menüs während der Aktualisierung, wird den Vorgang abbrechen."
L["Update complete. Opening menu."] = "Aktualisierung komplett. Menü wird geöffnet."
L["Hide Coordinates"] = "Verstecke Koordinaten"
L["Dungeon Teleports"] = "Instanzteleports"

-- Maps
L["MiniMap Buttons"] = "Minikartensymbole"
L["Minimap Ping"] = "Minikarten Ping"
L["Add Server Name"] = "Zeige Servernamen"
L["Only In Combat"] = "Nur im Kampf"
L["Fade-In"] = "Einblenden"
L["The time of animation. Set 0 to disable animation."] = "Die Zeit der Animation. Setze auf 0 um sie zu deaktivieren."
L["Blinking Minimap"] = "Blinkende Minikarte"
L["Enable the blinking animation for new mail or pending invites."] = "Aktiviert die blinkende Animation für neue Post, oder austehende Kalendereinladungen."
L["Super Tracker"] = "Super Tracker"
L["Description"] = "Beschreibung"
L["Additional features for waypoint."] = "Zusätliche Ergänzungen für Wegpunkte"
L["Auto Track Waypoint"] = "Automatische Wegpunktverfolgung"
L["Auto track the waypoint after setting."] = "Verfolgt Wegpunkte automatisch."
L["Right Click To Clear"] = "Rechts Klick um zu löschen"
L["Right click the waypoint to clear it."] = "Rechts Klick um einen Wegpunkt zu entfernen."
L["No Distance Limitation"] = "Keine Begrenzung für Entfernung"
L["Force to track the target even if it over 1000 yds."] = "Zeigt den Wegpunkt noch an, auch wenn er über 1000yds. entfernt ist."
L["Distance Text"] = "Distanztext"
L["Only Number"] = "Nur Nummer"
L["Add Command"] = "Befehl hinzufügen"
L["Add a input box to the world map."] = "Fügt ein Eingabefeld der Weltkarte hinzu."
L["Are you sure to delete the %s command?"] = "Bist du dir sicher %s diesen Befehl zu löschen?"
L["Can not set waypoint on this map."] = "Kann keinen Wegpunkt auf dieser Karte setzen."
L["Command"] = "Befehl"
L["Command Configuration"] = "Befehlkonfiguration"
L["Command List"] = "Befehlsliste"
L["Delete Command"] = "Befehl löschen"
L["Delete the selected command."] = "Lösche den ausgewählten Befehl."
L["Enable to use the command to set the waypoint."] = "Aktivieren um diesen Befehl zu verwenden um Wegpunkte zu setzen."
L["Go to ..."] = "Gehe zu ..."
L["Input Box"] = "Eingabefeld"
L["New Command"] = "Neuer Befehl"
L["No Arg"] = "Kein Argument"
L["Smart Waypoint"] = "Intelligenter Wegpunkt"
L["The argument is invalid."] = "Das Argument ist ungültig."
L["The argument is needed."] = "Das Argument wird benötigt."
L["The command to set a waypoint."] = "Der Befehl um einen Wegpunkt zu setzen."
L["The coordinates contain illegal number."] = "Die Koordinaten enthalten verbotene Nummern."
L["Waypoint %s has been set."] = "Wegpunkt %s wurde gesetzt."
L["Waypoint Parse"] = "wegpunktanalyse"
L["You can paste any text contains coordinates here, and press ENTER to set the waypoint in map."] = "Du kannst hier einen beliebigen Text einfügen, der Koordinaten enthält, und die EINGABETASTE drücken, um den Wegpunkt auf der Karte festzulegen."
L["illegal"] = "Verboten"
L["invalid"] = "Ungültig"
L["Because of %s, this module will not be loaded."] = "Aufgrund von %s wird dieses Modul nicht geladen."
L["This module will help you to reveal and resize maps."] = "Dieses Modul hilft Dir, beim Anzeigen und Ändern der Kartengröße."
L["Reveal"] = "Aufdecken"
L["Use Colored Fog"] = "Verwende farbigen Nebel"
L["Remove Fog of War from your world map."] = "Entferne Nebel des Krieges von deiner Weltkarte."
L["Style Fog of War with special color."] = "Style Nebel des Krieges mit einer besonderen Farbe."

-- SMB
L["Minimap Buttons"] = "Minimap Tasten"
L["Add an extra bar to collect minimap buttons."] = "Fügt eine zusätzliche Leiste hinzu, um Minikartenschaltflächen zu sammeln."
L["Toggle minimap buttons bar."] = "Minimap Tastenleiste einblenden"
L["Mouse Over"] = "Mouseover"
L["Only show minimap buttons bar when you mouse over it."] = "Zeige die Minikartenschaltflächenleiste nur an, wenn mit der Maus darüber gefahren wird."
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
L["Horizontal"] = true
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
L["Left Click to mark the target with this mark."] = "Klicke mit der linken Maustaste, um das Ziel mit dieser Markierung zu markieren."
L["Right Click to clear the mark on the target."] = "Rechts Klick um den Wegpunkt zu entfernen."
L["%s + Left Click to place this worldmarker."] = "%s + Linksklick, um diesen Weltmarker zu platzieren."
L["%s + Right Click to clear this worldmarker."] = "%s + Klicke mit der rechten Maustaste, um diesen Weltmarker zu löschen."
L["%s + Left Click to mark the target with this mark."] = "%s + Klicke mit der linken Maustaste, um das Ziel mit dieser Markierung zu markieren."
L["%s + Right Click to clear the mark on the target."] = "%s + Klicke mit der rechten Maustaste, um die Markierung auf dem Ziel zu löschen."
L["Click to clear all marks."] = "Klicke, um alle Markierungen zu löschen."
L["takes 3s"] = "benötigt 3 Sek."
L["%s + Click to remove all worldmarkers."] = "%s + Klicke hier, um alle Weltmarker zu entfernen."
L["Click to remove all worldmarkers."] = "Klicke, um alle Weltmarker zu entfernen."
L["%s + Click to clear all marks."] = "%s + Klicke, um alle Markierungen zu löschen."
L["Left Click to ready check."] = "Linksklick zur Überprüfung."
L["Right click to toggle advanced combat logging."] = "Klicke mit der rechten Maustaste, um die erweiterte Kampfprotokollierung umzuschalten."
L["Left Click to start count down."] = "Linksklick, um den Countdown zu starten."
L["Add an extra bar to let you set raid markers efficiently."] = "Fügt eine zusätzliche Leiste hinzu, mit der Du Raidmarker schneller setzen kannst."
L["Toggle raid markers bar."] = "Schlachtzugsmarkierungsleiste einblenden"
L["Inverse Mode"] = "Umkehrungs Modus"
L["Swap the functionality of normal click and click with modifier keys."] = "Tausche die Funktionalität des normalen Klickens aus und klicke mit den Modifikatortasten."
L["Visibility"] = "Sichtbarkeit"
L["In Party"] = "In Gruppe"
L["Always Display"] = "Immer anzeigen"
L["Mouse Over"] = "Mouseover"
L["Only show raid markers bar when you mouse over it."] = "Zeige die Raid-Markierungsleiste nur an, wenn mit der Maus darüber gefahren wird."
L["Tooltip"] = true
L["Show the tooltip when you mouse over the button."] = "Zeige die Raid-Markierungsleiste nur an, wenn mit der Maus darüber gefahren wird."
L["Modifier Key"] = "Modifier Taste"
L["Set the modifier key for placing world markers."] = "Unterbreche die Automatisierung, indem Du eine Modifizierertaste drückst."
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
L["Right click to toggle advanced combat logging."] = "Klicke mit der rechten Maustaste, um die erweiterte Kampfprotokollierung umzuschalten."
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

-- Raid Manager
L["Raid Manager"] = "Schlachtzugsmanager"
L["This will disable the ElvUI Raid Control and replace it with my own."] = "Dieser Menüpunkt deaktiviert die ElvUI Schlachtzugssteuerung und ersetzt sie mit meiner eigenen."
L["Open Raid Manager"] = "Öffnet den Raidmanager"
L["Pull Timer Count"] = "Pulltimer Zähler"
L["Change the Pulltimer for DBM or BigWigs"] = "Ändert den Pulltimer für DBM, oder BigWigs"
L["Only accept values format with '', e.g.: '5', '8', '10' etc."] = "Akzeptiert nur Zahlenformate mit '', z.B. '5', '8', '10' etc."

-- Reminder
L["Reminder"] = "Erinnerung"
L["Reminds you on self Buffs."] = "Erinnert Dich an eigene Buffs."

-- Cooldowns
L["CooldownFlash"] = "Abklingzeiten Blinken"
L["Settings"] = "Einstellungen"
L["Fadein duration"] = "Einblendzeit"
L["Fadeout duration"] = "Ausblendzeit"
L["Duration time"] = "Dauer"
L["Animation size"] = "Animationsgröße"
L["Watch on pet spell"] = "Überwache Begleiterzauber"
L["Transparency"] = "Transparenz"
L["Test"] = true
L["Sort Upwards"] = "Abwärts sortieren"
L["Sort by Expiration Time"] = "Nach Abklingzeit sortieren"
L["Show Self Cooldown"] = "Zeige eigene Abklingzeiten"
L["Show Icons"] = "Zeige Symbol"
L["Show In Party"] = "Zeige in Gruppe"
L["Show In Raid"] = "Zeige im Schlachtzug"
L["Show In Arena"] = "Zeige in Arenen"

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
L["floatingCombatTextCombatDamageDirectionalScale_DESC"] = "Directional damage numbers movement scale (deaktiviert = keine Richtungsnummern\r\rStandard: |cff00ff001|r"

-- GMOTD
L["Display the Guild Message of the Day in an extra window, if updated."] = "Zeigt die Gildennachricht des Tages in einem extra Fenster an, sofern sie aktualisiert wurde."

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
L["Show a shield icon on the castbar for non interruptible spells."] = "Zeigt ein Schildsymbol auf der Zauberleiste an, wenn ein Zauber nicht unterbrochen werden kann."
L["|cffFF0000NOTE:|r This will overwrite the ElvUI Nameplate options for Buff/Debuffs width/height. The CC-Buffs are hardcoded to a size of: 32 x 32"] = "|cffFF0000Hinweis:|r Dieser Menüpunkt wird die ElvUI Namensplakettenoptionen Höhe/Breite für die Stärkungs-/Schwächungszauber überschreiben. Die CC-Buffs sind hartkodiert und haben eine Größe von: 32 x 32 Pixel."

-- Install
L["Welcome"] = "Willkommen"
L["|cffff7d0aMerathilisUI|r Installation"] = true
L["MerathilisUI Set"] = "MerathilisUI gesetzt"
L["MerathilisUI didn't find any supported addons for profile creation"] = "MerathilisUI konnte keine Addonprofile finden, die unterstützt werden."
L["MerathilisUI successfully created and applied profile(s) for:"] = "MerathilisUI hat erfolgreich ein Profil erstellt und angewandt für:"
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
L["Welcome to MerathilisUI |cff00c0faVersion|r %s, for ElvUI %s."] = "Willkommen zu MerathilisUI |cff00c0faVersion|r %s für ElvUI %s."
L["By pressing the Continue button, MerathilisUI will be applied in your current ElvUI installation.\r\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"] = "Durch drücken der Weiter-Taste werden die MerathilisUI Änderungen in der vorhandenen ElvUI Installation angewandt.\r\r|cffff8000 TIPP: Es wäre gut, wenn Du die Änderungen in einem neuen Profil erstellst. Nur für den Fall, dass Du mit den Änderungen nicht zufrieden bist.|r"
L["Buttons must be clicked twice"] = "Bitte zweimal anklicken"
L["Importance: |cffff0000Very High|r"] = "Bedeutung: |cffff0000Sehr Hoch|r"
L["The AddOn 'AddOnSkins' is not enabled. No settings have been changed."] = "Das AddOn 'AddOnSkins' ist nicht aktiviert. Keine Einstellungen wurden verändert."
L["The Addon 'Big Wigs' is not enabled. Profile not created."] = "Das AddOn 'BigWigs' ist nicht aktiviert. Profil wurde nicht erstellt."
L["The AddOn 'ElvUI_BenikUI' is not enabled. No settings have been changed."] = "Das AddOn 'ElvUI_BenikUI' ist nicht aktiviert. Keine Einstellungen wurden verändert."
L["The AddOn 'ElvUI_SLE' is not enabled. No settings have been changed."] = "Das AddOn 'ElvUI_SLE' ist nicht aktiviert. Keine Einstellungen wurden verändert."
L["The Addon 'Skada' is not enabled. Profile not created."] = "Das AddOn 'Skada' ist nicht aktiviert. Profile wurde nicht erstellt."
L["This part of the installation process sets up your chat fonts and colors."] = "Dieser Teil des Installationsprozesses ändert die Chatschriftart und -farbe."
L["This part of the installation changes the default ElvUI look."] = "Dieser Teil der Installation ändert das standard Aussehen von ElvUI."
L["This part of the installation process will fill MerathilisUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"] = "Diese Einstellungen füllt die Infotexte.\r|cffff8000Die Einstellungen der Infotexte von ElvUI wird nicht verändert.|r"
L["This part of the installation process will reposition your Actionbars and will enable backdrops"] = "Dieser Teil des Installationsprozesses wird die Aktionsleisten neu positionieren und wird den Hintergrund einschalten."
L["This part of the installation process will reposition your Unitframes."] = "Dieser Teil der Installation positioniert die Einheitenfenster."
L["This part of the installation process will apply changes to ElvUI Plugins"] = "Dieser Abschnitt wird Änderungen an den ElvUI Plugins vornehmen."
L["This step changes a few World of Warcraft default options. These options are tailored to the needs of the author of %s and are not necessary for this edit to function."] = "Dieser Schritt ändert ein paar World of Warcraft Standardoptionen. Diese Optionen sind zugeschnitten für die Anforderungen des Authors von %s und sind nicht notwendig damit dieses AddOn funktioniert."
L["Please click the button below to apply the new layout."] = "Bitte drücke die Taste unten, um das neue Layout anzuwenden."
L["Please click the button below to setup your chat windows."] = "Bitte drücke auf die Taste unten, um das Chatfenster einzustellen."
L["Please click the button below to setup your actionbars."] = "Bitte drücke auf die Taste unten, um die Aktionsleisten einzustellen."
L["Please click the button below to setup your datatexts."] = "Bitte drücke die Taste unten, um die Infotexte einzustellen."
L["Please click the button below to setup your Unitframes."] = "Bitte drücke die Taste unten, um die Einheitenfenster einzustellen."
L["Please click the button below to setup the ElvUI AddOns. For other Addon profiles please go in my Options - Skins/AddOns"] = "Bitte drücke die Taste unten, um die ElvUI AddOns einzustellen. Weitere AddOns Profile findest Du in meinen Einstellungen unter - Skins/AddOns."
L["DataTexts"] = "Infotexte"
L["General Layout"] = "Allgemeines Layout"
L["Setup ActionBars"] = "Aktionsleisten einstellen"
L["Setup UnitFrames"] = "Einheitenfenster einstellen"
L["Setup Datatexts"] = "Infotexte einstellen"
L["Setup Addons"] = "Addons einstellen"
L["ElvUI AddOns"] = true
L["Finish"] = "Fertig"
L["Installed"] = "Installiert"

-- Staticpopup
L["MSG_MER_ELV_OUTDATED"] = "Deine Version von ElvUI ist älter als die empfohlene Version um |cffff7d0aMerathilisUI|r zu nutzen. Deine Version ist |cff00c0fa%.2f|r (empfohlen ist |cff00c0fa%.2f|r). Bitte aktualisiere dein ElvUI um Fehler zu vermeiden!"
L["You have got Location Plus and Shadow & Light both enabled at the same time. Select an addon to disable."] = "Du hast LocationPlus und Shadow & Light zur gleichen Zeit aktiviert. Wähle ein AddOn aus, was du deaktivieren möchtest."
L["MUI_INSTALL_SETTINGS_LAYOUT_SLE"] = [[Hier kannst das Layout für S&L wählen.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_BW"] = [[Hier kannst das Layout für BigWigs wählen.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_DBM"] = [[Hier kannst das Layout für Deadly Boss Mods wählen.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_DETAILS"] = [[Hier kannst das Layout für Details wählen.]]
L["Name for the new profile"] = "Name für das neue Profil"
L["Are you sure you want to override the current profile?"] = "Bist du sicher, dass du dein aktuelles Profil überschreiben  möchtest?"

-- Skins
L["MER_SKINS_DESC"] = [[Dieser Abschnitt ist dazu gedacht, die vorhandenen ElvUI Skins zu verbessern.

Bitte beachte, dass einige Optionen nicht verfügbar sind, wenn der dazugehörige Skin in ElvUI |cff636363deaktiviert|r ist.]]
L["MER_ADDONSKINS_DESC"] = [[Diese Abschnitt ist dazu gedacht, um das Aussehen von externen AddOns zu modifizieren.

Bitte beachte, dass einige Optionen |cff636363deaktiviert|r sind, wenn das AddOn nicht geladen wurde.]]
L["MerathilisUI Style"] = "MerathilisUI Stil"
L["Creates decorative stripes and a gradient on some frames"] = "Fügt dekorative Streifen und einen transparenten Farbverlauf an einigen Fenstern hinzu"
L["MerathilisUI Shadows"] = "MerathilisUI Schatten"
L["Enables/Disables a shadow overlay to darken the screen."] = "Aktiviert/Deaktiviert ein Schattenoverlay um den Bildschirm abzudunkeln."
L["Undress Button"] = "Ausziehen Taste"
L["Subpages"] = "Unterseiten"
L["Subpages are blocks of 10 items. This option set how many of subpages will be shown on a single page."] = "Unterseiten sind Blöcke von 10 Gegenständen pro Seite. Diese Option legt die Anzahl der Unterseiten fest, die angezeigt werden."
L["Enable/Disable"] = "Aktiviere/Deaktiviere"
L["decor."] = "Dekor"
L["MerathilisUI Button Style"] = "MerathilisUI Tastenstil"
L["Creates decorative stripes on Ingame Buttons (only active with MUI Style)"] = "Fügt dekorative Streifen den Ingame-Buttons hinzu. (Nur aktiv mit MerathilisUI Stil)"
L["Additional Backdrop"] = "Zusätzlicher Hintergrund"
L["Remove Border Effect"] = "Entferne Randeffekt"
L["Animation Type"] = "Animationstyp"
L["The type of animation activated when a button is hovered."] = "Der Animationstyp, der aktiviert wird, wenn man sich darüber bewegt."
L["Animation Duration"] = "Animationsdauer"
L["The duration of the animation in seconds."] = "Die Dauer der Animation in Sekunden."
L["Backdrop Class Color"] = "Hintergrund Klassenfarbe"
L["Border Class Color"] = "Rahmen Klassenfarbe"
L["Border Color"] = "Rahmen Farbe"
L["Normal Class Color"] = "Normale Klassenfarbe"
L["Selected Backdrop & Border"] = "Ausgewählter Hintergrund & Rahmen"
L["Selected Class Color"] = "Ausgewählte Klassenfarbe"
L["Selected Color"] = "Ausgewählte Farbe"
L["Tab"] = true
L["Tree Group Button"] = "Baumstrukturtaste" --Wie kacke dass klingt
L["Shadow Color"] = "Schattenfarbe"

-- Panels
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
L["Border Alpha"] = "Rand Transparenz"
L["Width Mode"] = "Breitenmodus"
L["'Absolute' mode means the width of the bar is fixed."] = "Der Modus 'Absolut' bedeutet, dass die Breite des Balkens festgelegt ist."
L["'Dynamic' mode will also add the width of header text."] = "Der Modus 'Dynamisch' fügt auch die Breite des Kopfzeilentexts hinzu."
L["'Absolute' mode means the height of the bar is fixed."] = "Der Modus 'Absolut' bedeutet, dass die Höhe des Balkens fest ist."
L["'Dynamic' mode will also add the height of header text."] = "Der Modus 'Dynamisch' fügt auch die Höhe des Kopfzeilentexts hinzu."
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
L["Use short name instead. e.g. Torghast, Tower of the Damned to Torghast."] = "Verwende stattdessen einen Kurznamen. Zum Beispiel Torghast, Turm der Verdammten nach Torghast."
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

-- Filter
L["Filter"] = true
L["Unblock the profanity filter."] = "Entsperre den Obszönitätsfilter."
L["Profanity Filter"] = "Obszönitätsfilter"
L["Enable this option will unblock the setting of profanity filter. [CN Server]"] = "Wenn Du diese Option aktivierst, wird die Einstellung des Profanitätsfilters aufgehoben. [CN Server]"

-- Friends List
L["Friends List"] = "Freundesliste"
L["Add additional information to the friend frame."] = "Fügt der Freundesliste zusätzliche Informationen hinzu."
L["Modify the texture of status and make name colorful."] = "Ändere die Textur des Status und mache den Namen farblich."
L["Enhanced Texture"] = "Verbesserte Textur"
L["Game Icons"] = "Spielsymbole"
L["Default"] = "Standard"
L["Modern"] = true
L["Status Icon Pack"] = "Status Symbolpack"
L["Diablo 3"] = true
L["Square"] = "Quadrat"
L["Faction Icon"] = "Fraktions Symbol"
L["Use faction icon instead of WoW icon."] = "Verwende das Fraktionssymbol anstelle des WoW-Symbols."
L["Name"] = true
L["Level"] = "Stufe"
L["Hide Max Level"] = "Verstecke auf Max Level"
L["Use Note As Name"] = "Notiz als Namen"
L["Replace the Real ID or the character name of friends with your notes."] = "Ersetze die Real ID oder den Charakternamen von Freunden durch Deine Notizen."
L["Use Game Color"] = "Verwende Spielfarbe"
L["Change the color of the name to the in-playing game style."] = "Ändere die Farbe des Namens in dem Spielstil."
L["Use Class Color"] = "Verwende Klassenfarbe"
L["Font Setting"] = "Schrifteinstellungen"

-- Talents
L["Talents"] = "Talente"
L["This feature improves the Talent Window by:\n\nAdding an Extra Button to swap between specializations.\nAdding an Extra Button to use and track duration for Codices and Tomes."] = "Diese Funktion verbessert das Talentfenster um:\n\nEine zusätzliche Taste um schnell zwischen den Spezialisierungen zu wechseln.\nZusätzliche Tasten für Kodexe um schnell die Talente zu wechseln."

-- Profiles
L["MER_PROFILE_DESC"] = [[Dieser Abschnitt erstellt Profile für einige AddOns.

|cffff0000ACHTUNG:|r Vorhandene Profile werden überschrieben/gelöscht. Wenn du meine Profile nicht anweden möchtest, bitte drücke nicht die unteren Tasten.]]

-- Addons
L["Skins/AddOns"] = true
L["Profiles"] = "Profile"
L["BigWigs"] = true
L["MasterPlan"] = true
L["Shadow & Light"] = "|cff9482c9Shadow & Light|r"
L["This will create and apply profile for "] = "Dieses wird ein Profil erstellen und anwenden für "

-- Changelog
L["Changelog"] = "Änderungen"

-- Compatibility
L["Compatibility Check"] = "Kompatibilitätsprüfung"
L["Help you to enable/disable the modules for a better experience with other plugins."] = "Hilf beim Aktivieren / Deaktivieren der Module, um eine bessere Erfahrung mit anderen Plugins zu erzielen."
L["There are many modules from different addons or ElvUI plugins, but several of them are almost the same functionality."] = "Es gibt viele Module von verschiedenen Addons oder ElvUI-Plugins, aber einige davon haben fast die gleiche Funktionalität."
L["Have a good time with %s!"] = "Viel Spaß mit %s!"
L["Choose the module you would like to |cff00ff00use|r"] = "Wähle das Modul aus, das Du |cff00ff00verwenden|r möchtest."
L["If you find the %s module conflicts with another addon, alert me via Discord."] = "Wenn Du feststellst, dass das %s Modul mit einem anderen Addon in Konflikt steht, benachrichtige mich über Discord."
L["You can disable/enable compatibility check via the option in the bottom of [MerathilisUI]-[Information]."] = "Du kannst die Kompatibilitätsprüfung über die Option unten in [MerathilisUI]-[Informationen] deaktivieren/aktivieren."
L["Complete"] = "Komplett"

-- Debug
L["Usage"] = "Verwendungszweck"
L["Enable debug mode"] = "Debug Modus aktivieren"
L["Disable all other addons except ElvUI Core, ElvUI %s and BugSack."] = "Deaktiviere alle anderen Addons außer ElvUI Core, ElvUI %s und BugSack."
L["Disable debug mode"] = "Debug Modus deaktivieren"
L["Reenable the addons that disabled by debug mode."] = "Aktiviere die Addons, die durch den Debug Modus deaktiviert wurden."
L["Debug Enviroment"] = "Debug Umgebung"
L["You can use |cff00ff00/muidebug off|r command to exit debug mode."] = "Du kannst den Befehl |cff00ff00/muidebug off|r verwenden, um den Debug Modus zu verlassen."
L["After you stop debuging, %s will reenable the addons automatically."] = "Nachdem Du das Debuggen beendet hast, wird %s die Addons automatisch aktivieren."
L["Before you submit a bug, please enable debug mode with %s and test it one more time."] = "Bevor Du einen Fehler meldest, aktiviere bitte den Debug Modus mit dem %s Befehl und teste es noch einmal."
L["Error"] = "Fehler"
L["Warning"] = "Warnung"
