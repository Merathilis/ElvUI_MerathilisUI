-- German localization file for deDE
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "deDE")

-- Core
L[" is loaded. For any issues or suggestions, please visit "] = " wurde geladen. Für Fehler oder Vorschläge besuche bitte: "

-- General Options
L["Plugin for |cffff7d0aElvUI|r by\nMerathilis."] = "Plugin für |cffff7d0aElvUI|r von\nMerathilis."
L["by Merathilis (|cFF00c0faEU-Shattrath|r)"] = "von Merathilis (|cFF00c0faEU-Shattrath|r)"
L["AFK"] = true
L["Enable/Disable the MUI AFK Screen. Disabled if BenikUI is loaded"] = "Aktiviert/Deaktiviert den MUI AFK Bildschirm. Wird automatisch deaktiviert, wenn BenikUI geladen wurde."
L["Are you still there? ... Hello?"] = "Bist du noch da? ... Hallo?"
L["Logout Timer"] = "Auslogzeit"
L["SplashScreen"] = "Startbildschirm"
L["Enable/Disable the Splash Screen on Login."] = "Aktiviert/Deaktiviert den Startbildschirm beim Login."
L["Options"] = "Einstellungen"
L["Desciption"] = "Beschreibung"
L["MER_DESC"] = [=[|cffff7d0aMerathilisUI|r ist eine Erweiterung für ElvUI. Sie ergänzt:

- viele neue Funktionen
- einen transparenten Look
- alle ElvUI Skins wurden überarbeitet
- mein persönliches Layout

|cFF00c0faHinweis:|r |cffff7d0aMerathilisUI|r ist mit den meisten anderen ElvUI Plugins kompatibel.
Wenn du jedoch ein anderes Layout über meines installierst, musst du es manuell anpassen.

|cffff8000Neue Features sind markiert mit einem: |r]=]

-- LoginMessage
L["Enable/Disable the Login Message in Chat"] = "Aktiviert/Deaktiviert die Login Nachricht im Chat"

-- Bags
L["Equipment Manager"] = "Ausrüstungsmanager"
L["Equipment Set Overlay"] = "Ausrüstungsset Anzeige"
L["Show the associated equipment sets for the items in your bags (or bank)."] = "Zeigt verbundene Ausrüstungssets auf Gegenständen in deinen Taschen und in der Bank an."

-- Chat
L["CHAT_AFK"] = "[AFK]"
L["CHAT_DND"] = "[DND]"
L["BACK"] = "Zurück"
L["has come |cff298F00online|r."] = "ist jetzt |cff298F00online|r." -- Guild Message
L["has gone |cffff0000offline|r."] = "ist jetzt |cffff0000offline|r." -- Guild Message
L[" has come |cff298F00online|r."] = " ist jetzt |cff298F00online|r." -- Battle.Net Message
L[" has gone |cffff0000offline|r."] = " ist jetzt |cffff0000offline|r." -- Battle.Net Message
L["|cFF00c0failvl|r: %d"] = "|cFF00c0faItemlevel|r: %d"
L["|CFF1EFF00%s|r |CFFFF0000Sold.|r"] = "|CFF1EFF00%s|r |CFFFF0000Verkauft.|r"
L["Requires level: %d - %d"] = "Erfordert Level: %d - %d"
L["Requires level: %d - %d (%d)"] = "Erfordert Level: %d - %d (%d)"
L["(+%.1f Rested)"] = "(+%.1f Erholt)"
L["Unknown"] = "Unbekannt"
L["Chat Item Level"] = true
L["Shows the slot and item level in the chat"] = "Zeigt den Ausrüstungsplatz und das Item Level im Chat an."
L["Expand the chat"] = "Chat erweitern"
L["Chat Menu"] = "Chat Menu"
L["Create a chat button to increase the chat size."] = "Erstellt eine Chat Taste um den Chat zu erweitern."
L["Hide Player Brackets"] = "Verstecke Spieler Klammern"
L["Removes brackets around the person who posts a chat message."] = "Entfernt die Klammern um die Spielernamen im Chat."
L["Chat Bar"] = "Chatleiste"
L["Shows a ChatBar with different quick buttons."] = "Zeigt eine Chatleiste mit verschiedenen Schnelltasten."
L["Hide Community Chat"] = "Verstecke Community Chat"
L["Adds an overlay to the Community Chat. Useful for streamers."] = "Fügt ein Overlay zum Community Chat hinzu. Nützlich für Streamer."
L["Chat Hidden. Click to show"] = "Chat versteckt. Klicken um anzuzeigen"
L["Click to open Emoticon Frame"] = "Öffnet das Emoteicon Fenster"
L["Emotes"] = true -- no need to translate
L["Damage Meter Filter"] = "Schadensmesser Filter"
L["Fade Chat"] = "Chatausblendung"
L["Auto hide timeout"] = "Auto Ausblendzeit"
L["Seconds before fading chat panel"] = "Sek. vor dem Ausblenden des Chat-Panels"
L["Seperators"] = "Trennlinien"
L["Orientation"] = "Orientierung"
L["Please use Blizzard Communities UI add the channel to your main chat frame first."] = "Verwende die Benutzeroberfläche von Blizzard Communities. Füge den Kanal zuerst zu Deinem Hauptchat Frame hinzu."
L["Channel Name"] = "Kanal Name"
L["Abbreviation"] = "Abkürzung"
L["Auto Join"] = "Auto Beitreten"
L["World"] = "Welt"
L["Channels"] = "Kanäle"
L["Block Shadow"] = "Verhindere Schatten"
L["Hide channels not exist."] = "Kanäle ausblenden die nicht existieren."
L["Say"] = "Sagen"
L["Yell"] = "Schreien"
L["Instance"] = "Instanz"
L["Raid"] = "Schlachtzug"
L["Raid Warning"] = "Schlachtzugs Warnung"
L["Guild"] = "Gilde"
L["Officer"] = "Offizier"
L["Only show chat bar when you mouse over it."] = "Zeige Chat-Leiste nur an, wenn mit der Maus darüber gefahren wird."
L["Button"] = "Tasten"
L["Item Level Links"] = "Gegenstandsstufen Links"

-- Combat Alert
L["Combat Alert"] = "Kampf Alamierung"
L["Enable/Disable the combat message if you enter/leave the combat."] = "Aktiviert/Deaktiviert die Kampf-Nachricht, wenn du den Kampf betrittst, oder verlässt."
L["Enter Combat"] = "Beginne Kampf"
L["Leave Combat"] = "Verlasse Kampf"
L["Stay Duration"] = "Anzeigezeit"
L["Custom Text"] = "Benutzerdefinierter Text"
L["Custom Text (Enter)"] = "Benutzerdefinierter Text (Beginne)"
L["Custom Text (Leave)"] = "Benutzerdefinierter Text (Verlasse)"
L["Color"] = "Farbe"

-- Information
L["Information"] = "Informationen"
L["Support & Downloads"] = "Unterstützung & Downloads"
L["Tukui.org"] = true
L["Git Ticket tracker"] = true
L["Curse.com"] = true
L["Coding"] = true
L["Testing & Inspiration"] = "Tester & Inspiration"
L["Development Version"] = true
L["Here you can download the latest development version."] = "Hier findest du den Download zu meiner Development Version."

-- Modules
L["Here you find the options for all the different |cffff8000MerathilisUI|r modules.\nPlease use the dropdown to navigate through the modules."] = "Hier findest du alle Optionen zu den verschiedenen |cffff8000MerathilisUI|r Modulen.\nBenutze bitte das Dropdown Menu um durch die verschiedenen Module zu navigieren."

-- GameMenu
L["GameMenu"] = "Spielmenü"
L["Enable/Disable the MerathilisUI Style from the Blizzard GameMenu."] = "Aktiviert/Deaktiviert den MerathilisUI Style aus dem Blizzard Spielmenü."

-- FlightMode
L["FlightMode"] = "Flugmodus"
L["Enhance the |cff00c0faBenikUI|r FlightMode.\nTo completely disable the FlightMode go into the |cff00c0faBenikUI|r Options."] = "Erweitert den |cff00c0faBenikUI|r Flugmodus.\nUm den Flugmodus komplett zu deaktivieren gehe bitte in die |cff00c0faBenikUI|r Optionen."
L["Exit FlightMode"] = "Verlasse FlugModus"
L["Left Click to Request Stop"] = "Links Klick für Haltewunsch"

-- FlightPoint
L["Flight Point"] = "Flugpunkt"
L["Enable/Disable the MerathilisUI Flight Points on the FlightMap."] = "Aktivert/Deaktiviert die MerathilisUI Flugpunkte an der Flugkarte."

-- Mail
L["Mail"] = "Post"
L["Alternate Character"] = "Alternative Charakter"
L["Alt List"] = true
L["Delete"] = "Löschen"
L["Favorites"] = "Favoriten"
L["Favorite List"] = "Favoriten Liste"
L["Name"] = "Name"
L["Realm"] = "Server"
L["Add"] = "Hinzufügen"
L["Please set the name and realm first."] = "Bitte füge zuerst den Namen und den Server hinzu."
L["Toggle Contacts"] = "Kontakte einblenden"
L["Online Friends"] = "Freunde Online"

-- MicroBar
L["Backdrop"] = "Hintergrund"
L["Backdrop Spacing"] = "Hintergrund Abstand"
L["The spacing between the backdrop and the buttons."] = "Der Abstand zwischen dem Hintergrund und den Tasten"
L["Time Width"] = "Zeit Breite"
L["Time Height"] = "Zeit Höhe"
L["The spacing between buttons."] = "Der Abstand zwischen den Tasten."
L["The size of the buttons."] = "Die Größe der Tasten."
L["Slow Mode"] = "Langsamer Modus"
L["Update the additional text every 10 seconds rather than every 1 second such that the used memory will be lower."] = "Updated den zusätzlichen Text jede 10 Sekunden anstatt jede Sekunde, wirkt sich auf den Speicher aus."
L["Display"] = "Anzeige"
L["Fade Time"] = "Ausblendzeit"
L["Tooltip Position"] = "Tooltip Position"
L["Mode"] = "Auswahl"
L["None"] = "Nichts"
L["Class Color"] = "Klassenfarbe"
L["Custom"] = "Benutzerdefiniert"
L["Additional Text"] = "Zusätzlicher Text"
L["Interval"] = "Intervall"
L["The interval of updating."] = "Aktualisierungsintervall"
L["Home"] = true
L["Left Button"] = "Linker Button"
L["Right Button"] = "Rechter Button"
L["Left Panel"] = "Linkes Panel"
L["Right Panel"] = "Rechtes Panel"
L["Button #%d"] = "Tasten #%d"
L["Pet Journal"] = "Wildtierführer"
L["Show Pet Journal"] = "Zeige Wildtierführer"
L["Screenshot"] = "Bildschirmaufnahme"
L["Screenshot immediately"] = "Direkte Bildschirmaufnahme"
L["Screenshot after 2 secs"] = "Bildschirmaufnahme nach 2 Sek."
L["Toy Box"] = "Spielzeugkiste"
L["Collections"] = "Sammlung"
L["Show Collections"] = "Zeige Sammlung"


-- Misc
L["Misc"] = "Verschiedenes"
L["Artifact Power"] = "Artefaktmacht"
L["has appeared on the MiniMap!"] = "ist auf der Minimap erschienen!"
L["Alt-click, to buy an stack"] = "Alt-klicken, um einen Stapel zu kaufen"
L["Announce"] = "Ankündigungen"
L["Skill gains"] = "Skill Steigerungen"
L[" members"] = " Mitglieder"
L["Name Hover"] = "Namen MouseOver"
L["Shows the Unit Name on the mouse."] = "Zeigt den Einheitennamen an der Maus."
L["Undress"] = "Ausziehen"
L["Flashing Cursor"] = "Blinkender Mauszeiger"
L["Accept Quest"] = "Quest annehmen"
L["Placed Item"] = "Platzierter Gegenstand"
L["Stranger"] = "Fremder"
L["Keystones"] = "Schlüsselsteine"
L["GUILD_MOTD_LABEL2"] = "Gildennachricht des Tages"
L["LFG Member Info"] = "LFG Mitglieder Info"
L["Shows role informations in your tooltip in the lfg frame."] = "Zeigt Mitglieder Rollen Informationen im Tooltip des LFG Fensters an."
L["MISC_REPUTATION"] = "Ruf"
L["MISC_PARAGON"] = "Paragon"
L["MISC_PARAGON_REPUTATION"] = "Paragon Ruf"
L["MISC_PARAGON_NOTIFY"] = "Maximaler Ruf - Belohnung abholen."
L["Fun Stuff"] = "Lustiges Zeugs"
L["Press CTRL + C to copy."] = "Drücke STRG + C zum Kopieren."
L["Wowhead Links"] = true -- No need to translate
L["Adds Wowhead links to the Achievement- and WorldMap Frame"] = "Fügt Wowhead Links zum/zur Erfolgfenster und Weltkarte hinzu."
L["Codex Buttons"] = "Kodex Tasten"
L["Adds two buttons on your Talent Frame, with Codex or Tome Items"] = "Fügt zwei Tasten zu deinem Talentfenster mit Kodex - oder Foliant Gegenständen hinzu"
L["Highest Quest Reward"] = "Höchste Quest Belohnung"
L["Automatically select the item with the highest reward."] = "Wählt automatisch den Gegenstand mit dem höchsten Wert aus."
L["Item Alerts"] = "Gegenstandsalarm"
L["Announce in chat when someone placed an usefull item."] = "Kündigt im Chat an, wenn jemand einen nützlichen Gegenstand stellt."

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
L["Title Color"] = "Titel Farbe"
L["Change the color of the title in the Tooltip."] = "Ändert die Farbe des Titels im Tooltip."
L["Progress Info"] = "Fortschrittsinfo"
L["Shows raid progress of a character in the tooltip"] = "Zeigt den Schlachtzugsfortschritt für einen Charakter im Tooltip an."
L["Mythic"] = "Mytisch"
L["Heroic"] = "Heroisch"
L["Normal"] = true
L["LFR"] = true
L["Uldir"] = true
L["BattleOfDazaralor"] = "Schlacht um Dazar'alor"
L["CrucibleOfStorms"] = "Tiegel der Stürme"
L["FACTION"] = "Fraktion"
L["HEART_OF_AZEROTH_MISSING_ACTIVE_POWERS"] = "Aktive Azeritboni"
L["Only Icons"] = "Nur Symbole"
L["Use the new style tooltip."] = "Neuen Tooltip-Stil verwenden."
L["Display in English"] = "Nur Englisch verwenden"
L["Show icon"] = "Icon anzeigen"
L["Show the spell icon along with the name."] = "Verderbnis-Effekt-Icon samt Namen anzeigen."

-- Notification
L["Notification"] = "Benachrichtigungen"
L["Display a Toast Frame for different notifications."] = "Zeigt ein Fenster mit verschiedenen Benachrichtigungen."
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
L["No Sounds"] = "Keine Sounds"

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
L["Sound"] = "Geräusch"
L["Play sound when killing blows popup is shown."] = "Spielt einen Sound wenn das Popup angezeigt wird."

-- Actionbars
L["Specialization Bar"] = "Spezialisierungsleiste"
L["EquipSet Bar"] = "Ausrüstungsleiste"
L["Auto Buttons"] = "Auto Tasten"
L["Bind Font Size"] = "Belegungstext Größe"
L["Trinket Buttons"] = "Trinket Tasten"
L["Color by Quality"] = "Färbe nach Qualität"
L["Quest Buttons"] = "Quest Tasten"
L["Blacklist Item"] = "Schwarze Liste Item"
L["Whitelist Item"] = "Weißeliste Item"
L["Add Item ID"] = "Füge Item ID hinzu"
L["Delete Item ID"] = "Entferne Item ID"
L["Custom Glow"] = "Benutzerdefinertes Leuchten"
L["Replaces the default Actionbar glow for procs with an own pixel glow."] = "Ersetzt das standard Aktionleistenleuchten mit einem eigenen Pixel-Leuchten."

-- AutoButtons
L["AutoButtons"] = "Auto Tasten"
L["Bar"] = "Leiste"
L["Only show the bar when you mouse over it."] = "Zeige Leiste nur an, wenn mit der Maus darüber gefahren wird."
L["Bar Backdrop"] = "Leistenhintergrund"
L["Show a backdrop of the bar."] = "Zeige einen Hintergrund auf der Leiste."
L["Button Width"] = "Tasten Weite"
L["The width of the buttons."] = "Die Breite der Tasten"
L["Button Height"] = "Tasten Höhe"
L["The height of the buttons."] = "Die Höhe der Tasten"
L["Counter"] = "Zähler"
L["Outline"] = "Umriß"
L["Button Groups"] = "Tasten Gruppen"
L["Key Binding"] = "Tastenbelegung"
L["Custom Items"] = "Benutzerdefinierte Gegenstände"
L["List"] = "Liste"
L["New Item ID"] = "ID des neuen Gegenstands"
L["Auto Button Bar"] = "Auto Tasten Leiste"
L["Quest Items"] = "Questgegenstände"
L["Equipments"] = "Ausrüstungen"
L["Potions"] = "Tränke"
L["Flasks"] = "Fläschchen"
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
L["Slot Gradient"] = "Gegenstand-Farbverlauf"
L["Indicators"] = "Indikatoren"
L["Shows a gradiation texture on the Character Slots."] = "Zeigt einen Farbverlauf auf den Ausrüstungsplätzen"
L["Transmog"] = true -- No need to translate
L["Shows an arrow indictor for currently transmogrified items."] = "Zeigt einen Indikator für den derzeitig transmogrifizierten Gegenstand an."
L["Illusion"] = "Illusionen"
L["Shows an indictor for weapon illusions."] = "Zeigt einen Indikator für die Waffen Illusionen an."

-- Media
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
L["Changes the Heal Prediction texture to the default Blizzard ones."] = "Ändert die 'Eingehende Heilung' Textur zu standard Blizzard"
L["Swing Bar"] = true
L["Creates a weapon Swing Bar"] = "Erstellt eine Waffen Swing Leiste"
L["Main-Hand Color"] = "Haupthand Farbe"
L["Off-Hand Color"] = "Schildhand Farbe"
L["Two-Hand Color"] = "Zweihand Farbe"
L["GCD Bar"] = "GCD Leiste"
L["Creates a Global Cooldown Bar"] = "Erstellt eine Globale Cooldown Leiste"
L["UnitFrame Style"] = "Einheitenfenster Stil"
L["Adds my styling to the Unitframes if you use transparent health."] = "Fügt meinen Stil zu den Einheitenfenstern hinzu, wenn du transparentes Leben benutzt."
L["Change the default role icons."] = "Ändert die Standard Rollensymbole."

-- LocationPanel
L["Location Panel"] = true
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
L["Relocation Menu"] = "Menu versetzen"
L["Right click on the location panel will bring up a menu with available options for relocating your character (e.g. Hearthstones, Portals, etc)."] = "Rechtsklicke auf das Location Panel um ein Menu zu öffnen und um mehrere Portmöglichkeiten zu erhalten (z.B. Ruhestein, Portale, etc.)."
L["Custom Width"] = "Benutzerdefinerte Breite"
L["By default menu's width will be equal to the location panel width. Checking this option will allow you to set own width."] = "Standardmäßig hat das Menu die Breite des Location Panel. Wenn du diese Option aktivierst, kannst du die Breite ändern."
L["Justify Text"] = "Text ausrichten"
L["Auto Width"] = "Auto Breite"
L["Change width based on the zone name length."] = "Ändert die Breite nach dem Zonen Text."
L["Hearthstone Location"] = "Ruhestein Position"
L["Show the name on location your Hearthstone is bound to."] = "Zeige die Position an, wo dein Ruhestein liegt."
L["Combat Hide"] = "Im Kampf ausblenden"
L["Show/Hide all panels when in combat"] = "Zeige/Verstecke das Panel während des Kampfes"
L["Hide In Class Hall"] = "Verstecke in der Klassenhalle"
L["Hearthstone Location"] = "Ruhestein Position"
L["Hearthstone Toys Order"] = "Ruhestein Spielzeug Reihenfolge"
L["Show hearthstones"] = "Zeige Ruhestein"
L["Show hearthstone type items in the list."] = "Zeigt Ruhestein Items in der Liste"
L["Show Toys"] = "Zeige Spielzeuge"
L["Show toys in the list. This option will affect all other display options as well."] = "Zeigt Spielzeuge in der Liste an. Diese Option wirkt sich auf alle anderen Anzeigeoptionen aus."
L["Show spells"] = "Zeige Zauber"
L["Show relocation spells in the list."] = "Zeigt Teleport Zauber in der Liste."
L["Show engineer gadgets"] = "Zeige Ingenieur Spielerein."
L["Show items used only by engineers when the profession is learned."] = "Zeigt Gegenstände, die nur von Ingenieuren genutzt werden können, sowie wenn der Beruf erlernt wurde, an."
L["Ignore missing info"] = "Ignoriere fehlende Informationen"
L["MER_LOCPANEL_IGNOREMISSINGINFO"] = [[Due to how client functions some item info may become unavailable for a period of time. This mostly happens to toys info.
When called the menu will wait for all information being available before showing up. This may resul in menu opening after some concidarable amount of time, depends on how fast the server will answer info requests.
By enabling this option you'll make the menu ignore items with missing info, resulting in them not showing up in the list.]]
L["Info for some items is not available yet. Please try again later"] = "Informationen für einige Gegenstände sind zur Zeit nicht verfügbar. Bitte später noch einmal versuchen"
L["Update canceled."] = "Update abgebrochen."
L["Item info is not available. Waiting for it. This can take some time. Menu will be opened automatically when all info becomes available. Calling menu again during the update will cancel it."] = "Gegenstandsinformation ist nicht verfügbar. Dieses kann ein bisschen dauern um die Informationen zu sammeln. Das Menü wird automatisch geöffnet, wenn alle Informationen gesammelt wurden. Erneutes Aufrufen des Menüs während des Updates, wird den Vorgang abbrechen."
L["Update complete. Opening menu."] = "Update komplett. Menü wird geöffnet."
L["Hide Coordinates"] = "Verstecke Koordinaten"

-- Maps
L["MiniMap Buttons"] = "Minikartensymbole"
L["Minimap Ping"] = "Minikarten Ping"
L["Add Server Name"] = "Zeige Servernamen"
L["Only In Combat"] = "Nur im Kampf"
L["Fade-In"] = "Einblenden"
L["The time of animation. Set 0 to disable animation."] = "Die Zeit der Animation. Setze auf 0 um sie zu deaktivieren."
L["Blinking Minimap"] = "Blinkende Minikarte"
L["Enable the blinking animation for new mail or pending invites."] = "Aktiviert die blinkende Animation für Neue Post, oder austehende Kalendereinladungen."

-- SMB
L["Button Settings"] = "Tasten Einstellungen"

-- Raid Marks
L["Raid Markers"] = "Schlachtzugs-Markierungen"
L["Click to clear the mark."] = "Klicken um die Marker zu löschen."
L["Click to mark the target."] = "Klicken um ein Ziel zu markieren."
L["%sClick to remove all worldmarkers."] = "%sKlicken um alle Weltmarkierungen zu entfernen."
L["%sClick to place a worldmarker."] = "%sKlicken um einen Weltmarker zu setzen."
L["Raid Marker Bar"] = "Schlachtzugs-Markierungs-Leiste"
L["Options for panels providing fast access to raid markers and flares."] = "Option für eine Schlachtzugs-Markierungs-Leiste. Mit dieser hast Du schnelleren Zugriff auf Schlachtzugsmarkierungen und Weltmarker."
L["Show/Hide raid marks."] = "Zeige/Verstecke Schlachtzugsmarkierungen"
L["Reverse"] = "Umkehren"
L["Modifier Key"] = "Modifier Taste"
L["Set the modifier key for placing world markers."] = "Legt eine Modifierungstaste fest, um eine Weltmarkierung zu setzen."
L["Visibility State"] = "Sichtbarkeit"

-- Raid Buffs
L["Raid Buff Reminder"] = "Schlachtzug Buff Erinnerung"
L["Shows a frame with flask/food/rune."] = "Zeigt ein Fenster mit Fläschchen/Essen/Runen an."
L["Class Specific Buffs"] = "Klassenspezifische Buffs"
L["Shows all the class specific raid buffs."] = "Zeigt alle Klassenspezifischen Buffs."
L["Change the alpha level of the icons."] = "Ändert das Alpha Level der Symbole"
L["Shows the pixel glow on missing raid buffs."] = "Zeigt ein Leuchten um den fehlenden Klassenspezifischen Buff."

-- Raid Manager
L["Raid Manager"] = true
L["This will disable the ElvUI Raid Control and replace it with my own."] = "Dieser Menüpunkt deaktiviert die ElvUI Schlachtzugssteuerung und ersetzt sie mit meiner eigenen."
L["Open Raid Manager"] = "Öffnet den Raid Manager"
L["Pull Timer Count"] = "Pulltimer Zähler"
L["Change the Pulltimer for DBM or BigWigs"] = "Ändert den Pulltimer für DBM, oder BigWigs"
L["Only accept values format with '', e.g.: '5', '8', '10' etc."] = "Aktzeptiert nur Zahlenformate mit '', z.B. '5', '8', '10' etc."

-- Reminder
L["Reminder"] = "Erinnerung"
L["Reminds you on self Buffs."] = "Erinnert dich an eigene Buffs."

-- Cooldowns
L["CooldownFlash"] = true
L["Settings"] = "Einstellungen"
L["Fadein duration"] = "Einblendzeit"
L["Fadeout duration"] = "Ausblendzeit"
L["Duration time"] = "Dauer"
L["Animation size"] = "Animationsgröße"
L["Display spell name"] = "Zeige Zaubernamen"
L["Watch on pet spell"] = "Überwache Begleiter Zauber"
L["Transparency"] = "Transparenz"
L["Test"] = true
L["Sort Upwards"] = "Abwärts sortieren"
L["Sort by Expiration Time"] = "Nach Abklingzeit sortieren"
L["Show Self Cooldown"] = "Zeige eigene Abklingzeiten"
L["Show Icons"] = "Zeige Symbol"
L["Show In Party"] = "Zeige in Gruppe"
L["Show In Raid"] = "Zeige im Raid"
L["Show In Arena"] = "Zeige in Arenen"

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
L["Castbar Shield"] = "Zauberleisten Schild"
L["Show a shield icon on the castbar for non interruptible spells."] = "Zeigt ein Schildsymbol auf der Zauberleiste an, wenn ein Zauber nicht unterbrochen werden kann."
L["|cffFF0000NOTE:|r This will overwrite the ElvUI Nameplate options for Buff/Debuffs width/height. The CC-Buffs are hardcoded to a size of: 32 x 32"] = "|cffFF0000Hinweis:|r Dieser Menüpunkt wird die ElvUI Namensplaketten Optionen Höhe/Breite für die Stärkungs-/Schwächungszauber überschreiben. Die CC-Buffs sind hartkodiert und haben eine Größe von: 32 x 32 Pixel."

-- Install
L["Welcome"] = "Willkommen"
L["|cffff7d0aMerathilisUI|r Installation"] = true
L["MerathilisUI Set"] = "MerathilisUI gesetzt"
L["MerathilisUI didn't find any supported addons for profile creation"] = "MerathilisUI konnte keine Addonprofile finden, die unterstützt werden."
L["MerathilisUI successfully created and applied profile(s) for:"] = "MerathilisUI hat erfolgreich ein Profil erstellt und angewandt für:"
L["Tank/ DPS Layout"] = true -- No need to translate
L["Heal Layout"] = "Heiler Layout"
L["Chat Set"] = "Chat eingestellt"
L["ActionBars"] = "Aktionsleisten"
L["ActionBars Set"] = "Aktionsleisten gesetzt"
L["DataTexts Set"] = "Infotexte gesetzt"
L["Profile Set"] = "Profil gesetzt"
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
L["This step changes a few World of Warcraft default options. These options are tailored to the needs of the author of %s and are not necessary for this edit to function."] = "Dieser Schritt ändert ein paar World of Warcraft Standard-Optionen. Diese Optionen sind zugeschnitten für die Anforderungen des Authors von %s und sind nicht notwendig damit dieses AddOn funktioniert."
L["Please click the button below to apply the new layout."] = "Bitte drücke die Taste unten, um das neue Layout anzuwenden."
L["Please click the button below to setup your chat windows."] = "Bitte drücke auf die Taste unten, um das Chatfenster einzustellen."
L["Please click the button below to setup your actionbars."] = "Bitte drücke auf die Taste unten, um die Aktionsleisten einzustellen."
L["Please click the button below to setup your datatexts."] = "Bitte drücke die Taste unten, um die Infotexte einzustellen."
L["Please click the button below to setup your Unitframes."] = "Bitte drücke die Taste unten, um die Einheitenfenster einzustellen."
L["Please click the button below to setup the ElvUI AddOns. For other Addon profiles please go in my Options - Skins/AddOns"] = "Bitte drücke die Taste unten, um die ElvUI AddOns einzustellen. Weitere AddOns Profile findest Du in meinen Einstellungen unter - Skins/AddOns."
L["DataTexts"] = "Infotexte"
L["Setup Datatexts"] = "Infotexte einstellen"
L["Setup Addons"] = "Addons einstellen"
L["ElvUI AddOns"] = true
L["Finish"] = "Fertig"
L["Installed"] = "Installiert"

-- Staticpopup
L["MSG_MER_ELV_OUTDATED"] = "Deine Version von ElvUI ist älter als die empfohlene Version um |cffff7d0aMerathilisUI|r zu nutzen. Deine Version ist |cff00c0fa%.2f|r (empfohlen ist |cff00c0fa%.2f|r). Bitte aktualisiere dein ElvUI um Fehler zu vermeiden!"
L["You have got Location Plus and Shadow & Light both enabled at the same time. Select an addon to disable."] = "Du hast LocationPlus und Shadow & Light zur gleichen Zeit aktiviert. Wähle ein AddOn aus, was du deaktivieren möchtest."
L["MUI_INSTALL_SETTINGS_LAYOUT_SLE"] = [[Hier kannst das Layout für S&L wählen.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_BUI"] = [[Hier kannst das Layout für BenikUI wählen.]]
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
L["Creates decorative stripes and a gradient on some frames"] = "Fügt dekorative Streifen und einen transparenten Farbverlauf an einigen Fenstern hinzu"
L["MerathilisUI Style"] = "MerathilisUI Stil"
L["MerathilisUI Shadows"] = "MerathilisUI Schatten"
L["Undress Button"] = "Ausziehen Taste"
L["Subpages"] = "Unterseiten"
L["Subpages are blocks of 10 items. This option set how many of subpages will be shown on a single page."] = "Unterseiten sind Blöcke von 10 Gegenständen pro Seite. Diese Option legt die Anzahl der Unterseiten fest, die angezeigt werden."
L["Enable/Disable"] = "Aktiviere/Deaktiviere"
L["decor."] = "Dekor"

-- Panels
L["Top Left Panel"] = "Leiste oben links"
L["Top Left Extra Panel"] = "Extra Leiste oben links"
L["Top Right Panel"] = "Leiste oben rechts"
L["Top Right Extra Panel"] = "Extra Leiste oben rechts"
L["Bottom Left Panel"] = "Leiste unten links"
L["Bottom Left Extra Panel"] = "Extra Leiste unten links"
L["Bottom Right Panel"] = "Leiste unten rechts"
L["Bottom Right Extra Panel"] = "Extra Leiste unten rechts"

-- Profiles
L["MER_PROFILE_DESC"] = [[Dieser Abschnitt erstellt Profile für einige AddOns.

|cffff0000ACHTUNG:|r Vorhandene Profile werden überschrieben/gelöscht. Wenn du meine Profile nicht anweden möchtest, bitte drücke nicht die unteren Tasten.]]

-- Addons
L["Skins/AddOns"] = true
L["Profiles"] = "Profile"
L["BigWigs"] = true
L["MasterPlan"] = true
L["Shadow & Light"] = true
L["This will create and apply profile for "] = "Dieses wird ein Profil erstellen und anwenden für "

-- Changelog
L["Changelog"] = true

-- Compatibility
L["has |cffff2020disabled|r "] = "deaktiviert "
L[" from "] = " von "
L[" due to incompatiblities."] = " wegen inkompatibilität."
L[" due to incompatiblities with: "] = " wegen inkompatibilität mit: "
L["You got |cff00c0faElvUI_Windtools|r and |cffff7d0aMerathilisUI|r both enabled at the same time. Please select an addon to disable."] = "Du hast |cff00c0faElvUI_Windtools|r und |cffff7d0aMerathilisUI|r zur selben Zeit aktiviert. Bitte wähle ein AddOn zum Deaktivieren aus."
L["You got |cff9482c9ElvUI_LivvenUI|r and |cffff7d0aMerathilisUI|r both enabled at the same time. Please select an addon to disable."] = "Du hast |cff9482c9ElvUI_LivvenUI|r und |cffff7d0aMerathilisUI|r zur selben Zeit aktiviert. Bitte wähle ein AddOn zum Deaktivieren aus."
