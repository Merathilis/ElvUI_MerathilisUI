-- German localization file for deDE
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("ElvUI", "deDE");
if not L then return; end

-- Core
L[" is loaded."] = " ist geladen."

-- General Options
L["Plugin for |cff1784d1ElvUI|r by\nMerathilis."] = "Plugin für |cff1784d1ElvUI|r von\nMerathilis."
L["by Merathilis (EU-Shattrath)"] = "von Merathilis (EU-Shattrath)"
L["MerathilisUI is an external ElvUI mod. Mostly it changes the look to be more transparency.\n\n|cff00c0faNew Function are marked with:|r"] = "MerathilisUI ist ein externer ElvUI Mod. Es ändert hauptsächlich den Look zu mehr transparenz.\n\n|cff00c0faNeue Funktionen sind gekennzeichnet mit:|r"
L["AFK"] = true
L["Enable/Disable the MUI AFK Screen"] = "Aktiviert/Deaktiviert den MUI AFK Bildschirm"
L["SplashScreen"] = "Startbildschirm"
L["Enable/Disable the Splash Screen on Login."] = "Aktiviert/Deaktiviert den Startbildschirm beim Login."
L["Options"] = "Einstellungen"
L["Combat State"] = "Kampfstatus"
L["Enable/Disable the '+'/'-' combat message if you enter/leave the combat."] = "Aktiviert/Deaktiviert die '+'/'-' Kampf Nachricht wenn du den Kampf betrittst oder verlässt."
L["Show Merchant ItemLevel"] = "Zeige ItemLevel beim Händlern"
L["Display the item level on the MerchantFrame, to change the font you have to set it in ElvUI - Bags - ItemLevel"] = "Zeigt das ItemLevel bei den Händlern an, um die Schriftart zu ändern, musst du sie in ElvUI - Taschen - ItemLevel ändern."

-- LoginMessage
L["Enable/Disable the Login Message in Chat"] = "Aktiviert/Deaktiviert die Login Nachricht im Chat"

-- Chat
L["CHAT_AFK"] = "[AFK]"
L["CHAT_DND"] = "[DND]"
L["has come |cff298F00online|r."] = "ist jetzt |cff298F00online|r."
L["has gone |cffff0000offline|r."] = "ist jetzt |cffff0000offline|r."
L["Unknown"] = "Unbekannt"

-- Information
L["Information"] = true
L["Support & Downloads"] = true
L["Tukui.org"] = true
L["Git Ticket tracker"] = true
L["Curse.com"] = true
L["Coding"] = true
L["Testing & Inspiration"] = "Tester & Inspiration"

-- GameMenu
L["GameMenu"] = "Spielmenü"
L["Enable/Disable the MerathilisUI Style from the Blizzard GameMenu."] = "Aktiviert/Deaktiviert den MerathilisUI Style aus dem Blizzard Spielmenü."

-- FlightMode
L["FlightMode"] = "Flugmodus"
L["Enable/Disable the MerathilisUI FlightMode.\nTo completely disable the FlightMode go into the |cff00c0faBenikUI|r Options."] = "Aktiviert/Deaktiviert den MerathilisUI Flugmodus.\nUm den Flugmodus komplett zu deaktivieren gehe bitte in die |cff00c0faBenikUI|r Optionen."

-- FlightPoint
L["Flight Point"] = "Flugpunkt"
L["Enable/Disable the MerathilisUI Flight Points on the FlightMap."] = "Aktivert/Deaktiviert die MerathilisUI Flugpunkte an der Flugkarte."

-- moveBlizz
L["moveBlizz"] = true
L["Make some Blizzard Frames movable."] = "Erlaubt das Verschieben einiger Blizzardfenster."

-- MasterPlan
L["MasterPlan"] = true
L["Skins the additional Tabs from MasterPlan."] = "Skint die zusätzlichen Tabs von MasterPlan."
L["Misc"] = "Verschiedenes"

-- Media
L["MER_MEDIA_ZONES"] = {
	"Salzgitter",
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
L["Zone Text"] = "Zonen Schriftart"
L["Test"] = true
L["Subzone Text"] = "Subzonen Schriftart"
L["PvP Status Text"] = "PvP Status Schriftart"
L["Misc Texts"] = "Verschiedene Schriftarten"
L["Mail Text"] = "Post Schriftart"
L["Chat Editbox Text"] = "Chat-Eingabefeld Schriftart"
L["Gossip and Quest Frames Text"] = "Begrüßungs- und Questfenster Schriftart"
L["Objective Tracker Header Text"] = "Objective Tracker Kopf Schriftart"
L["Objective Tracker Text"] = "Objective Tracker Schriftart"
L["Banner Big Text"] = true

-- Misc
L["Artifact Power"] = "Artefaktmacht"
L["has appeared on the MiniMap!"] = "ist auf der Minimap erschienen!"
L["Alt-click, to buy an stack"] = "Alt-klicken, um einen Stapel zu kaufen"
L["Mover Transparency"] = "Ankerpunkte Transparenz"
L["Changes the transparency of all the movers."] = "Ändert die Transparenz von allen Ankerpunkten."
L["Announce"] = "Ankündigungen"
L["Combat Status, Skill gains"] = "Kampftext, Skill Steigerungen"
L["Automatically select the quest reward with the highest vendor sell value."] = "Wählt automatisch die Questbelohnung mit dem höchsten Preis aus."
L[" members"] = " Mitglieder"
L["Expand the chat"] = "Chat erweitern"

-- TooltipIcon
L["Your Status:"] = "Dein Status:"
L["Your Status: Incomplete"] = "Dein Status: Unvollständig"
L["Your Status: Completed on "] = "Dein Status: Abgeschlossen am "
L["Adds an Icon for battle pets on the tooltip."] = "Fügt ein Haustiersymbol zum Tooltip hinzu."
L["Adds an Icon for the faction on the tooltip."] = "Fügt ein Symbol für die Fraktion am Tooltip hinzu."
L["Adds information to the tooltip, on which char you earned an achievement."] = "Fügt Information am Tooltip hinzu, von welchem Char der Erfolg erungen wurde."
L["Model"] = true
L["Adds an Model icon on the tooltip."] = "Fügt ein Model am Tooltip hinzu."
L["Adds descriptions for mythic keystone properties to their tooltips."] = "Fügt eine Beschreibung für mythische Schlüsselsteine Eigenschaften am Tooltip hinzu."

-- MailInputBox
L["Mail Inputbox Resize"] = "Post Eingabefeld"
L["Resize the Mail Inputbox and move the shipping cost to the Bottom"] = "Verändert die Größe des Post Eingabefeldes und verschiebt die Versandkosten."

-- Notification
L["Notification"] = "Benachrichtigungen"
L["Display a Toast Frame for different notifications."] = "Zeigt ein Fenster mit verschiedenen Benachrichtigungen."
L["This is an example of a notification."] = "Beispiel Benachrichtigung."
L["Notification Mover"] = true
L["%s slot needs to repair, current durability is %d."] = "%s braucht Reperatur, aktuelle Haltbarkeit ist %d."
L["You have %s pending calendar invite(s)."] = "Du hast %s ausstehende Kalender Einladungen"
L["You have %s pending guild event(s)."] = "Du hast %s ausstehende Gildenereignisse"
L["Event \"%s\" will end today."] = "Ereignis \"%s\" endet heute."
L["Event \"%s\" started today."] = "Ereignis \"%s\" beginnt heute."
L["Event \"%s\" is ongoing."] = "Ereignis \"%s\" ist im Gange."
L["Event \"%s\" will end tomorrow."] = "Ereignis \"%s\" endet morgen."
L["Here you can enable/disable the different notification types."] = "Hier kannst du die verschiedenen Benachrichtigungstypen aktivieren/deaktivieren."
L["Enable Mail"] = "Aktiviere Post"
L["Enable Vignette"] = "Aktiviere Vignette"
L["If a Rar Mob or a treasure gets spotted on the minimap."] = "Wenn ein Rar Mob oder ein Schatz auf der Minikarte erscheint."
L["Enable Invites"] = "Aktiviere Einladungen"
L["Enable Guild Events"] = "Aktiviere Gildenereignisse"
L["Enable Quick Join Notification"] = "Aktiviere Quick Join Notification"

-- Tradeskill Tabs
L["TradeSkill Tabs"] = "Berufsfenster Tabs"
L["Add tabs for professions on the TradeSkill Frame."] = "Fügt Tabs am Berufsfenster hinzu."

-- DataTexts
L["ChatTab_Datatext_Panel"] = "Rechter ChatTab Infotextleisten"
L["Enable/Disable the right chat tab datatext panel."] = "Aktivert/Deaktiviert die rechten ChatTab Infoleisten."

-- DataBars
L["DataBars"] = "Informationsleisten"
L["Add some stylish buttons at the bottom of the DataBars"] = "Fügt unten an den Informationsleisten transparente Tasten hinzu"
L["Style DataBars"] = "Informationsleisten Stil"

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

-- Actionbars
L["Applies transparency in all actionbar backdrops and actionbar buttons."] = "Aktiviert die Transparenz auf alle Aktionsleisten Hintergründe und Tasten."
L["Transparent Backdrops"] = "Transparente Hintergründe"
L["ButtonStyle"] = "Tastenstil"
L["Enable the button style."] = "Aktiviere den Tastenstil."
L["The texture to use."] = "Die zu verwendene Textur."
L["ActionButton Border"] = "Aktionstasten Rand"

-- Unitframes
L["UnitFrames"] = "Einheitenfenster"
L["UnitFrames v1"] = "Einheitenfenster v1"
L["UnitFrames v2"] = "Einheitenfenster v2"
L["Apply shadow under the portrait"] = "Aktiviere den Schatten unter dem Portrait"
L["Apply transparency on the portrait backdrop."] = "Wende Transparenz auf den Portrait Hintergrund an."
L["Change the detached portrait height"] = "Ändert die Höhe des abgetrennten Portrait"
L["Change the detached portrait width"] = "Ändert die Breite des abgetrennten Portrait"
L["Detach Portrait"] = "Abgetrenntes Portrait"
L["Shadow"] = "Schatten"
L["Player Portrait"] = "Spieler Portrait"
L["Target Portrait"] = "Ziel Portrait"
L["Aura Spacing"] = "Auren Abstand"
L["Sets space between individual aura icons."] = "Setzt den Abstand zwischen den individuellen Aurensymbolen."
L["Set Aura Spacing On Following Units"] = "Setzt den Auren Abstand für folgende Einheiten"
L["Assist"] = "Assistent"
L["Boss"] = true;
L["Focus"] = "Fokus"
L["FocusTarget"] = "Fokus-Ziel"
L["Party"] = "Gruppe"
L["Pet"] = "Begleiter"
L["PetTarget"] = "Begleiter-Ziel"
L["Player"] = "Spieler"
L["Raid"] = "Schlachtzug"
L["Raid40"] = "40er Schlachtzug"
L["RaidPet"] = "Schlachtzug Begleiter"
L["Tank"] = true;
L["Target"] = "Ziel"
L["TargetTarget"] = "Ziel des Ziels"
L["TargetTargetTarget"] = "Ziel des Ziels des Ziels"
L["Hide Text"] = "Verstecke Text"
L["Hide From Others"] = "Verstecke von anderen"
L["Threshold"] = "Schwellwert"
L["Duration text will be hidden until it reaches this threshold (in seconds). Set to -1 to always show duration text."] = "Dauertext wird versteckt bis es den Schwellwert erreicht (in Sekunden). Auf -1 setzen um immer den Dauertext anzugzeigen."
L["Position of the duration text on the aura icon."] = "Positon des Dauertext auf dem Aurensymbol."
L["Position of the stack count on the aura icon."] = "Position des Stappel auf dem Aurensymbol."

-- LocationPanel
L["Location Panel"] = true
L["Update Throttle"] = "Aktualisierung drosseln"
L["The frequency of coordinates and zonetext updates. Check will be done more often with lower values."] = "Die Frequenz wie oft die Koordinaten und der Zonentext aktualisiert wird. Je geringer der Wert, desto öfter wird aktualisiert."
L["Full Location"] = "Vollständige Position "
L["Color Type"] = "Farben type"
L["Custom Color"] = "Benutzerdefinerte Farbe"
L["Reaction"] = "Reaktion"
L["Location"] = "Position"
L["Coordinates"] = "Koordinaten"
L["Teleports"] = "Teleport"
L["Portals"] = "Portale"
L["Link Position"] = "Linke Position"
L["Allow pasting of your coordinates in chat editbox via holding shift and clicking on the location name."] = "Erlaubt die Koordinaten im Chat zu verlinken, via Shift+Links klick."
L["Relocation Menu"] = "Menu versetzen"
L["Right click on the location panel will bring up a menu with available options for relocating your character (e.g. Hearthstones, Portals, etc)."] = "Rechts klicke auf das Location Panel um ein Menu zu öffnen um mehrere Portmöglichkeiten zu erhalten (z.B. Ruhestein, Portale, etc.)."
L["Custom Width"] = "Benutzerdefinerte Breite"
L["By default menu's width will be equal to the location panel width. Checking this option will allow you to set own width."] = "Standardmäßig hat das Menu die Breite des LocationPanel. Wenn du diese Option aktivierst, kannst du die Breite ändern."
L["Justify Text"] = "Text ausrichten"
L["Auto Width"] = "Auto Breite"
L["Change width based on the zone name length."] = "Ändert die Breite nach dem Zonen Text."
L["Hearthstone Location"] = "Ruhestein Position"
L["Show the name on location your Heathstone is bound to."] = "Zeige die Position an wo dein Ruhestein liegt."
L["Combat Hide"] = "Im Kampf ausblenden"
L["Show/Hide all panels when in combat"] = "Zeige/Verstecke das Panel während des Kampfes"
L["Hide In Class Hall"] = "Verstecke in der Klassenhalle"

-- Raid Marks
L["Raid Markers"] = "Schlachtzugs-Markierungen"
L["Click to clear the mark."] = "Klicken um die Marker zu löschen."
L["Click to mark the target."] = "Klicken um ein Ziel zu markieren."
L["%sClick to remove all worldmarkers."] = "%sKlicken um alle Weltmarkierungen zu entfernen."
L["%sClick to place a worldmarker."] = "%sKlicken um ein Weltmarker zu setzen."
L["Raid Marker Bar"] = "Schlachtzugs-Markierungs-Leiste"
L["Options for panels providing fast access to raid markers and flares."] = "Option für eine Schlachtzugs-Markierungs-Leiste um schnelleren Zugriff auf Schlachtzugsmarkierung und Weltmarker zu bekommen."
L["Show/Hide raid marks."] = "Zeige/Verstecke Schlachtzugsmarkierung"
L["Reverse"] = "Umkehren"
L["Modifier Key"] = "Modifier Taste"
L["Set the modifier key for placing world markers."] = "Setzt eine modifierungs Taste um eine Weltmarkierung zu setzen."
L["Visibility State"] = "Sichtbarkeit"

-- UIButtons
L["UI Buttons"] = true
L["Show/Hide UI buttons."] = "Aktiviere/Deaktivere die UI Tasten."
L["UI Buttons Style"] = "UI Tasten Stil"
L["Classic"] = "Klassisch"
L["Dropdown"] = true
L["Size"] = true
L["Sets size of buttons"] = "Setzt die größe der Tasten"
L["Button Spacing"] = "Tasten Abstand"
L["The spacing between buttons."] = "Der Abstand zwischen den Tasten."
L["Mouse Over"] = "Mouseover"
L["Show on mouse over."] = "Zeige beim mouseover."
L["Backdrop"] = "Hintergrund"
L["Dropdown Backdrop"] = "Dropdown Hintergrund"
L["Buttons position"] = "Tasten Position"
L["Layout for UI buttons."] = "Layout für die UI Tasten"
L["Anchor Point"] = "Ankerpunkt"
L["What point of dropdown will be attached to the toggle button."] = "Wo der Hintergrund angezeigt wird um die Tasten umzuschalten."
L["Attach To"] = "Anfügen an"
L["What point to anchor dropdown on the toggle button."] = "Wo der Ankerpunkt vom Dropdown angefügt wird."
L["Minimum Roll Value"] = "Minimaler Rollwert"
L["Maximum Roll Value"] = "Maximaler Rollwert"
L["Function"] = "Funktion"
L["Custom roll limits are set incorrectly! Minimum should be smaller then or equial to maximum."] = true
L["Click to toggle config window"] = true
L["Click to toggle MerathilisUI config group"] = true
L["Reload UI"] = true
L["Click to reload your interface"] = true
L["Move UI"] = true
L["Click to unlock moving ElvUI elements"] = true
L["AddOns"] = true
L["AddOns Manager"] = true
L["Click to toggle the AddOn Manager frame."] = true
L["Boss Mod"] = true
L["Click to toggle the Configuration/Option Window from the Bossmod you have enabled."] = true

-- CooldownFlash
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

-- GMOTD
L["Display the Guild Message of the Day in an extra window, if updated."] = "Zeigt die Gildennachricht des Tages in einem extra Fenster an, wenn sie aktuallisiert wird."

-- AFK
L["Jan"] = true
L["Feb"] = true
L["Mar"] = true
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
L["NameplateAuras"] = "Namensplaketten Auren"
L["Visibility"] = "Sichtbarkeit"
L["Set when this aura is visble."] = "Benutze wenn diese Aura sichtbar ist"
L["Clear Spell List"] = "Leere die Zauberliste"
L["Empties the list of specific spells and their configurations."] = "Leert die Liste von speziellen Zaubern und deren Einstellungen."
L["Restore Spell List"] = "Zauberliste wiederherstellen"
L["Restores the default list of specific spells and their configurations."] = "Stellt die Standardliste von speziellen Zaubern und Einstellungen wiederher."
L["Spell Name/ID"] = "Zauber Name/ID"
L["Input a spell name or spell ID."] = "Gib einen Zauber Name oder Zauber ID ein."
L["Spell List"] = "Zauberliste"
L["Remove Spell"] = "Zauber entfernen"
L["Other Auras"] = "Andere Auren"
L["These are the settings for all spells not explicitly specified."] = "Dies sind die Einstellungen für alle Zauber, die nicht explizit angegeben sind."
L["Icon Width"] = "Symbol Breite"
L["Set the width of this spells icon."] = "Setzt die Breite von einem Zaubersymbol."
L["Icon Height"] = "Symbol Höhe"
L["Set the height of this spells icon."] = "Setzt die Höhe von einem Zaubersymbol."
L["Lock Aspect Ratio"] = "Seitenverhältnis sperren"
L["Set if height and width are locked to the same value."] = "Behält das Seitenverhältnis bei."
L["Stack Size"] = "Stappel Größe"
L["Text Size"] = "Text Größe"
L["Size of the stack text."] = "Größe des Stack Texts."
L["Size of the cooldown text."] = "Größe des Cooldown Texts."
L["Specific Auras"] = "Spezifische Auren"
L["Always"] = "Immer"
L["Never"] = "Niemals"
L["Only Mine"] = "Nur eigene"

-- EnhancedFriendsList
L["Info Font"] = "Info Schriftart"
L["Game Icon Pack"] = true
L["Status Icon Pack"] = true
L["Game Icon Preview"] = "Game Icon Vorschau:"
L["Status Icon Preview"] = "Status Icon Vorschau:"

-- ObjectiveTrackerHider
L["Hide during PvP"] = "Verstecke während PvP"
L["Hide the objective tracker during PvP (i.e. Battlegrounds)"] = "Versteckt den Objective Tracker während PvP (z.B. Schlachtfelder)"
L["Hide in arena"] = "Verstecke in Arena"
L["Hide the objective tracker when in the arena"] = "Verstecke den Objective Tracker in Arenen"
L["Hide in dungeon"] = "Verstecke in Dungeon"
L["Hide the objective tracker when in a dungeon"] = "Verstecke den Objective Tracker in Dungeons"
L["Hide in raid"] = "Verstecke in Raid"
L["Hide the objective tracker when in a raid"] = "Verstecke den Objective Tracker in Raids"
L["Collapse during PvP"] = "Zeige während PvP"
L["Collapse the objective tracker during PvP (i.e. Battlegrounds)"] = "Zeigt den Objective Tracker währden PvP (z.B. Schlachtfelder)"
L["Collapse in arena"] = "Zeige in Arena"
L["Collapse the objective tracker when in the arena"] = "Zeigt den Objective Tracker in Arenen"
L["Collapse in dungeon"] = "Zeige in Dungeon"
L["Collapse the objective tracker when in a dungeon"] = "Zeigt den Objective Tracker in Dungeons"
L["Collapse in raid"] = "Zeige in Raid"
L["Collapse the objective tracker during a raid"] = "Zeigt den Objective Tracker in Raids"

-- Install
L["Welcome"] = "Willkommen"
L["|cffff7d0aMerathilisUI|r Installation"] = true
L["MerathilisUI Set"] = "MerathilisUI gesetzt"
L["MerathilisUI didn't find any supported addons for profile creation"] = "MerathilisUI konnte keine unterstütze Profile für Addons finden"
L["MerathilisUI successfully created and applied profile(s) for:"] = "MerathilisUI hat erfolgreich ein Profil erstellt und angewandt für:"
L["Chat Set"] = "Chat eingestellt"
L["ActionBars"] = "Aktionsleisten"
L["ActionBars v1"] = "Aktionsleisten v1"
L["ActionBars v2"] = "Aktionsleisten v2"
L["ActionBars Set"] = "Aktionsleisten gesetzt"
L["DataTexts Set"] = "Infotexte gesetzt"
L["ElvUI AddOns settings applied."] = "ElvUI AddOns eingestellt."
L["AddOnSkins is not enabled, aborting."] = "AddOnSkins ist nicht aktiviert, abgebrochen."
L["AddOnSkins settings applied."] = "AddOnSkins Einstellungen angewandt."
L["BigWigs is not enabled, aborting."] = "BigWigs ist nicht aktiviert, abgebrochen."
L["BigWigs Profile Created"] = "BigWigs Profil erstellt"
L["Skada Profile Created"] = "Skada Profil erstellt"
L["Skada is not enabled, aborting."] = "Skada ist nicht aktiviert, abgebrochen."
L["UnitFrames Set"] = "Einheitenfenster eingestellt"
L["Welcome to MerathilisUI |cff00c0faVersion|r %s, for ElvUI %s."] = "Willkommen zu MerathilisUI |cff00c0faVersion|r %s für ElvUI %s."
L["By pressing the Continue button, MerathilisUI will be applied in your current ElvUI installation.\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"] = "Durch drücken der Weiter-Taste werden die MerathilisUI Änderungen in der vorhandenen ElvUI Installation angewandt.\r|cffff8000 TIP: Es wäre gut, wenn Du die Änderungen in einem neuen Profil erstellst. Nur für den Fall dass Du mit den Änderungen nicht zufrieden bist.|r"
L["Buttons must be clicked twice"] = "Bitte zweimal anklicken"
L["The AddOn 'AddOnSkins' is not enabled. No settings have been changed."] = "Das AddOn 'AddOnSkins' ist nicht aktiviert. Keine Einstellungen wurden verändert."
L["The Addon 'Big Wigs' is not enabled. Profile not created."] = "Das AddOn 'BigWigs' ist nicht aktiviert. Profil wurde nicht erstellt."
L["The AddOn 'ElvUI_BenikUI' is not enabled. No settings have been changed."] = "Das AddOn 'ElvUI_BenikUI' ist nicht aktiviert. Keine Einstellungen wurden verändert."
L["The AddOn 'ElvUI_SLE' is not enabled. No settings have been changed."] = "Das AddOn 'ElvUI_SLE' ist nicht aktiviert. Keine Einstellungen wurden verändert."
L["The Addon 'Skada' is not enabled. Profile not created."] = "Das AddOn 'Skada' ist nicht aktiviert. Profile wurde nicht erstellt."
L["This part of the installation process sets up your chat fonts and colors."] = "Dieser Teil des Installationsprozesses ändert die Chatschrifart und -farbe."
L["This part of the installation changes the default ElvUI look."] = "Dieser Teil der Installation ändert das standard Aussehen von ElvUI."
L["This part of the installation process will fill MerathilisUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"] = "Diese Einstellungen füllt die Infotexte.\r|cffff8000Die Einstellungen der Infotexte von ElvUI wird nicht verändert|r"
L["This part of the installation process will reposition your Actionbars and will enable backdrops"] = "Dieser Teil des Installationsprozesses wird die Aktionsleisten neu positionieren und wird den Hintergrund einschalten"
L["This part of the installation process will reposition your Unitframes."] = "Dieser Teil der Installation positioniert die Einheitenfenster."
L["This part of the installation process will apply changes to ElvUI Plugins"] = "Dieser Abschnitt wird Änderungen an den ElvUI Plugins vornehmen"
L["This step changes a few World of Warcraft default options. These options are tailored to the needs of the author of %s and are not necessary for this edit to function."] = "Dieser Schritt ändert ein paar World of Warcraft Standard-Optionen. Diese Optionen sind zugeschnitten für die Anforderungen des Authors von %s und sind nicht notwendig damit dieses AddOn funktioniert."
L["Please click the button below to apply the new layout."] = "Bitte drücke die Taste unten, um das neue Layout anzuwenden."
L["Please click the button below to setup your chat windows."] = "Bitte klick auf die Taste unten, um das Chatfenster einzustellen."
L["Please click the button below |cff07D400twice|r to setup your actionbars."] = "Bitte drücke |cff07D400doppelt|r auf die Taste unten, um die Aktionsleisten einzustellen."
L["Please click the button below to setup your datatexts."] = "Bitte drücke die Taste unten, um die Infotexte einzustellen."
L["Please click the button below |cff07D400twice|r to setup your Unitframes."] = "Bitte drücke |cff07D400doppelt|r die Taste unten, um die Einheitenfenster einzustellen."
L["Please click the button below to setup the ElvUI AddOns. For other Addon profiles please go in my Options - Skins/AddOns"] = "Bitte drücke die Taste unten, um die ElvUI AddOns einzustellen. Für andere AddOn Profile, gehe bitte in meine Einstellungen - Skins/AddOns"
L["DataTexts"] = "Infotexte"
L["Setup Chat v1"] = "Chat einstellen v1"
L["Setup Chat v2"] = "Chat einstellen v2"
L["Setup Datatexts v1"] = "Infotexte einstellen v1"
L["Setup Datatexts v2"] = "Infotexte einstellen v2"
L["Setup Addons"] = "Addons einstellen"
L["ElvUI AddOns"] = true
L["Finish"] = "Fertig"
L["Installed"] = "Installiert"

-- Staticpopup
L["MSG_MER_ELV_OUTDATED"] = "Deine Version von ElvUI ist älter als die empfohlene Version um |cffff7d0aMerathilisUI|r zu nutzen. Deine Version ist |cff00c0fa%.2f|r (empfohlen ist |cff00c0fa%.2f|r). Bitte aktuallisiere dein ElvUI, um Fehler zu vermeiden!"
L["You have got Location Plus and Shadow & Light both enabled at the same time. Select an addon to disable."] = "Du hast LocationPlus und Shadow & Light zur gleichen Zeit aktiviert. Wähle ein AddOn aus, was du deaktivieren möchtest."
L["MUI_INSTALL_SETTINGS_LAYOUT_SLE"] = [[Hier kannst das Layout für S&L wählen.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_BUI"] = [[Hier kannst das Layout für BenikUI wählen.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_BW"] = [[Hier kannst das Layout für BigWigs wählen.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_DETAILS"] = [[Hier kannst das Layout für Details wählen.]]

-- Skins
L["MER_SKINS_DESC"] = [[Dieser Abschnitt ist dazu gedacht, die vorhandenen ElvUI Skins zu verbessern.

Bitte beachte dass einige Optionen nicht verfügbar sind, wenn der dazugehörige Skin in ElvUI |cff636363deaktiviert|r ist.]]
L["Creates decorative stripes and a gradient on some frames"] = "Fügt dekorative Streifen und einen transparenten Farbverlauf an einigen Fenstern hinzu"
L["MerathilisUI Style"] = "MerathilisUI Stil"

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

-- Errors
L["Info"] = {
	["Errors"] = "Keine Fehler bisher.",
}