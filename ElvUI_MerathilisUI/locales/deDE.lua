-- German localization file for deDE
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("ElvUI", "deDE");
if not L then return; end

-- Core
L[" is loaded."] = " ist geladen."

-- General Options
L["Plugin for |cff1784d1ElvUI|r by\nMerathilis."] = "Plugin für |cff1784d1ElvUI|r von\nMerathilis."
L["by Merathilis (EU-Shattrath)"] = "von Merathilis (EU-Shattrath)"
L["MerathilisUI is an external ElvUI mod. Mostly it changes the Look of your UI. It is high recommended that you download |cff00c0faElvUI BenikUI|r to get the whole Style.\n\n|cff00c0faNew Function are marked with:|r"] = "MerathilisUI ist ein externer ElvUI Mod. Es ändert hauptsächlich nur den Look von eurem UI. Um den kompletten Style zu erreichen wird empfohlen |cff00c0faElvUI BenikUI|r herrunter zu laden.\n\n|cff00c0faNeue Funktionen sind gekennzeichnet mit:|r"
L["AFK"] = true
L["Enable/Disable the MUI AFK Screen"] = "Aktiviert/Deaktiviert den MUI AFK Bildschirm"
L["SplashScreen"] = "Startbildschirm"
L["Enable/Disable the Splash Screen on Login."] = "Aktiviert/Deaktiviert den Startbildschirm beim Login."
L["Options"] = "Einstellungen"
L["Combat State"] = "Kampfstatus"
L["Enable/Disable the '+'/'-' combat message if you enter/leave the combat."] = "Aktiviert/Deaktiviert die '+'/'-' Kampf Nachricht wenn du den Kampf betrittst oder verlässt."
L["Hide OrderHallBar"] = "OrderHallBar ausblenden"
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

-- moveBlizz
L["moveBlizz"] = true
L["Make some Blizzard Frames movable."] = "Erlaubt das Verschieben einiger Blizzardfenster."

-- MasterPlan
L["MasterPlan"] = true
L["Skins the additional Tabs from MasterPlan."] = "Skint die zusätzlichen Tabs von MasterPlan."
L["Misc"] = "Verschiedenes"

-- Misc
L["Artifact Power"] = "Artefaktmacht"
L[" spotted!"] = " entdeckt!"
L["Alt-click, to buy an stack"] = "Alt-klicken, um einen Stapel zu kaufen"
L["Mover Transparency"] = "Ankerpunkte Transparenz"
L["Changes the transparency of all the movers."] = "Ändert die Transparenz von allen Ankerpunkten."
L["Announce"] = "Ankündigungen"
L["Combat Status, Skill gains"] = "Kampftext, Skill Steigerungen"
L["Automatically select the quest reward with the highest vendor sell value."] = "Wählt automatisch die Questbelohnung mit dem höchsten Preis aus."

-- TooltipIcon
L["Adds an Icon for Items/Spells/Achievement on the Tooltip."] = "Fügt ein Symbol für Gegenstände/Zauber/Erfolge am Tooltip hinzu."
L["Your Status:"] = "Dein Status:"
L["Your Status: Incomplete"] = "Dein Status: Unvollständig"
L["Your Status: Completed on "] = "Dein Status: Abgeschlossen am "
L["Tooltip Icon"] = "Tooltip Symbol"
L["Pet Icon"] = "Haustier Symbol"
L["Adds an Icon for battle pets on the tooltip."] = "Fügt ein Haustiersymbol zum Tooltip hinzu."
L["Faction Icon"] = "Fraktionssymbol"
L["Adds an Icon for the faction on the tooltip."] = "Fügt ein Symbol für die Fraktion am Tooltip hinzu."
L["Role Icon"] = "Rollensymbol"
L["Adds an role icon on the tooltip."] = "Fügt ein Rollensymbol am Tooltip hinzu."

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

-- Tradeskill Tabs
L["TradeSkill Tabs"] = "Berufsfenster Tabs"
L["Add tabs for professions on the TradeSkill Frame."] = "Fügt Tabs am Berufsfenster hinzu."

-- DataTexts
L["ChatTab_Datatext_Panel"] = "Rechter ChatTab Infotextleisten"
L["Enable/Disable the right chat tab datatext panel."] = "Aktivert/Deaktiviert die rechten ChatTab Infoleisten."

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

-- Unitframes
L["Red Icon"] = "Rotes Symbol"
L["Group Info"] = "Gruppeninfo"
L["Shows an extra frame with information about the party/raid."] = "Zeigt ein extra Fenster mit Informationen über die/den Gruppe/Raid an."
L[" alive"] = " am Leben"

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

-- Install
L["Welcome"] = "Willkommen"
L["|cffff7d0aMerathilisUI|r Installation"] = true
L["MerathilisUI Set"] = "MerathilisUI gesetzt"
L["MerathilisUI didn't find any supported addons for profile creation"] = "MerathilisUI konnte keine unterstütze Profile für Addons finden"
L["MerathilisUI successfully created and applied profile(s) for:"] = "MerathilisUI hat erfolgreich ein Profil erstellt und angewandt für:"
L["Chat Set"] = "Chat eingestellt"
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
L["This part of the installation process will apply changes to the addons like Skada and ElvUI plugins"] = "Dieser Abschnitt wird Änderungen an den Addons vornehmen, wie Skada und ElvUI Plugins"
L["This step changes a few World of Warcraft default options. These options are tailored to the needs of the author of %s and are not necessary for this edit to function."] = "Dieser Schritt ändert ein paar World of Warcraft Standard-Optionen. Diese Optionen sind zugeschnitten für die Anforderungen des Authors von %s und sind nicht notwendig damit dieses AddOn funktioniert."
L["Please click the button below to apply the new layout."] = "Bitte drücke die Taste unten, um das neue Layout anzuwenden."
L["Please click the button below to setup your chat windows."] = "Bitte klick auf die Taste unten, um das Chatfenster einzustellen."
L["Please click the button below |cff07D400twice|r to setup your actionbars."] = "Bitte drücke |cff07D400doppelt|r auf die Taste unten, um die Aktionsleisten einzustellen."
L["Please click the button below to setup your datatexts."] = "Bitte drücke die Taste unten, um die Infotexte einzustellen."
L["Please click the button below |cff07D400twice|r to setup your Unitframes."] = "Bitte drücke |cff07D400doppelt|r die Taste unten, um die Einheitenfenster einzustellen."
L["Please click the button below to setup your addons."] = "Bitte drücke die Taste unten, um die Addons einzustellen."
L["DataTexts"] = "Infotexte"
L["Setup Datatexts"] = "Infotexte einstellen"
L["Setup Addons"] = "Addons einstellen"
L["Finish"] = "Fertig"
L["Installed"] = "Installiert"

-- Staticpopup
L["To get the whole MerathilisUI functionality and look it's recommended that you download |cff00c0faElvUI_BenikUI|r!"] = "Um alle Funktionen und das Aussehen von MerathilisUI zu erlangen, lade dir bitte |cff00c0faElvUI_BenikUI|r herrunter!"
L["MSG_MER_ELV_OUTDATED"] = "Deine Version von ElvUI ist älter wie die empfohlene Version um |cffff7d0aMerathilisUI|r zu nutzen. Deine Version ist |cff00c0fa%.2f|r (empfohlen ist |cff00c0fa%.2f|r). MerathilisUI ist nicht geladen! Bitte aktuallisiere dein ElvUI."
L["You have got Location Plus and Shadow & Light both enabled at the same time. Select an addon to disable."] = "Du hast LocationPlus und Shadow & Light zur gleichen Zeit aktiviert. Wähle ein AddOn aus, was du deaktivieren möchtest."

-- Skins
L["MER_SKINS_DESC"] = [[Dieser Abschnitt ist dazu gedacht, die vorhandenen ElvUI Skins zu verbessern.

Bitte beachte dass einige Optionen nicht verfügbar sind, wenn der dazugehörige Skin in ElvUI |cff636363deaktiviert|r ist.]]
L["Create a transparent backdrop around the header."] = "Fügt einen transparenten Hintergrund um die Kopfzeile."

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

-- Developer
L["AddOn Presets"] = "AddOn Voreinstellungen"
L["Choose an AddOn Presets, where selected AddOns gets loaded."] = "Wähle eine Addon Voreinstellung wo ausgewählte AddOns geladen werden."
L["Choose a preset!"] = "Wähle eine Voreinstellung!"
L["Choose this preset?"] = "Diese Voreinstellung auswählen?"
L["Default"] = "Standard"
L["ElvUI only"] = "Nur ElvUI"
L["Instance"] = "Instanz"
