local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local C = W.Utilities.Color ---@type ColorUtility

local print, tonumber, type = print, tonumber, type
local format = string.format

local isFirstLine = true

local DONE_ICON = format(" |T%s:0|t", [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\Complete.tga]])

---@param text string
---@param from number
local function UpdateMessage(text, from)
	if isFirstLine then
		isFirstLine = false
		WF.PrintGradientLine()
		WF.Print(L["Update"])
	end

	local versionText = format(
		"(%s -> %s)...",
		C.StringByTemplate(format("%.2f", from), "neutral-300"),
		C.StringByTemplate(MER.Version, "emerald-400")
	)

	E:Delay(1, print, text, versionText, DONE_ICON)
end

function MER:UpdateScripts()
	local currentVersion = tonumber(MER.Version) or 0 -- Installed MerathilisUI Version
	local globalVersion = tonumber(E.global.mui.version) or 0 -- Version in ElvUI Global

	local db = E.db.mui
	local private = E.private.mui
	local global = E.global.mui

	-- from old updater
	if globalVersion == 0 then
		globalVersion = tonumber(E.global.mui.Version) or 0
		E.global.mui.Version = nil
	end

	-- changelog display
	if globalVersion == 0 or globalVersion ~= currentVersion then
		self.showChangeLog = true
	end

	local profileVersion = tonumber(E.db.mui.version) or globalVersion -- Version in ElvUI Profile
	local privateVersion = tonumber(E.private.mui.version) or globalVersion -- Version in ElvUI Private

	if globalVersion == currentVersion and profileVersion == currentVersion and privateVersion == currentVersion then
		return
	end

	isFirstLine = true

	if profileVersion <= 6.60 then
		if db and db.armory and db.armory.specIcon and db.armory.specIcon.name then
			if db.armory.specIcon.name ~= I.Fonts.Icons then
				db.armory.specIcon.name = I.Fonts.Icons
				UpdateMessage(L["Armory"] .. " - " .. L["Update Database"], profileVersion)
			end
		end
	end

	if privateVersion < 6.71 or profileVersion < 6.71 then
		if E.db.mui and E.db.mui.tooltip then
			local tdb = E.db.mui.tooltip
			if tdb.yOffsetOfHealthBar ~= nil and tdb.healthBar.barYOffset then
				tdb.healthBar.barYOffset = tdb.yOffsetOfHealthBar
				tdb.yOffsetOfHealthBar = nil
			end

			if tdb.yOffsetOfHealthText ~= nil and tdb.healthBar.textYOffset then
				tdb.healthBar.textYOffset = tdb.yOffsetOfHealthText
				tdb.yOffsetOfHealthText = nil
			end

			if tdb.icon ~= nil then
				tdb.titleIcon.enable = tdb.icon
				tdb.icon = nil
			end
		end

		UpdateMessage(L["Tooltip"] .. " - " .. L["Clear History"], privateVersion)
	end

	if privateVersion < 6.72 then
		if E.private.mui and E.private.mui.skins and E.private.mui.skins.rollResult then
			E.private.mui.skins.rollResult = nil
			UpdateMessage(L["Skins"] .. ": " .. L["Database cleanup"], privateVersion)
		end
	end

	if profileVersion < 6.72 then
		if
			E.db.mui
			and E.db.mui.maps
			and E.db.mui.maps.eventTracker
			and E.db.mui.maps.eventTracker.khazAlgarEmissary
		then
			E.db.mui.maps.eventTracker.khazAlgarEmissary = nil
			UpdateMessage(L["Event Tracker"] .. ": " .. L["Database cleanup"], profileVersion)
		end
	end

	if globalVersion < 6.72 then
		if global.core and global.core.logLevel then
			global.developer.logLevel = global.core.logLevel
			global.core.logLevel = nil
			UpdateMessage(L["Advanced"] .. ": " .. L["Developer"], globalVersion)
		end
	end

	if privateVersion < 6.79 or profileVersion < 6.79 or globalVersion < 6.79 then
		if global then
			if global.mail then
				global.mail = nil
				UpdateMessage(L["Global: Mail"] .. ": " .. L["Database cleanup"], globalVersion)
			end
			if global.bags then
				global.bags = nil
				UpdateMessage(L["Global: Bags"] .. ": " .. L["Database cleanup"], globalVersion)
			end
			if global.maps then
				global.maps = nil
				UpdateMessage(L["Global: Maps"] .. ": " .. L["Database cleanup"], globalVersion)
			end
			if global.misc then
				global.misc = nil
				UpdateMessage(L["Global: Misc"] .. ": " .. L["Database cleanup"], globalVersion)
			end
			if global.advancedOptions then
				global.advancedOptions = nil
				UpdateMessage(L["Global: Advanced"] .. ": " .. L["Database cleanup"], globalVersion)
			end
			if global.developer then
				global.developer = nil
				UpdateMessage(L["Global:Developer"] .. ": " .. L["Database cleanup"], globalVersion)
			end
		end

		if private then
			if private.misc then
				private.misc = nil
				UpdateMessage(L["Private: Advanced"] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.quest then
				private.quest = nil
				UpdateMessage(L["Private: Quest"] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.skins then
				if private.skins.shadow then
					private.skins.shadow = nil
					UpdateMessage(L["Private: Skins - Shadow"] .. ": " .. L["Database cleanup"], privateVersion)
				end
			end
			if private.skins.widgets then
				private.skins.widgets = nil
				UpdateMessage(L["Private: Skins - Widgets"] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.skins.blizzard then
				private.skins.blizzard = nil
				UpdateMessage(L["Private: Skins - Blizzard"] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.skins.libraries then
				private.skins.libraries = nil
				UpdateMessage(L["Private: Skins - Libraries"] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.skins.addonSkins.btwQ then
				private.skins.addonSkins.btwQ = nil
				UpdateMessage(L["Private: Skins - BtwQuest"] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.skins.addonSkins.bui then
				private.skins.addonSkins.bui = nil
				UpdateMessage(L["Private: Skins - BenikUI"] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.skins.addonSkins.weakAuras then
				private.skins.addonSkins.weakAuras = nil
				UpdateMessage(L["Private: Skins - WeakAuras"] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.skins.addonSkins.weakAurasOptions then
				private.skins.addonSkins.weakAurasOptions = nil
				UpdateMessage(L["Private: Skins - WeakAuras Options"] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.skins.addonSkins.imm then
				private.skins.addonSkins.imm = nil
				UpdateMessage(L["Private: Skins - Immersion"] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.skins.addonSkins.rio then
				private.skins.addonSkins.rio = nil
				UpdateMessage(L["Private: Skins - RaiderIO"] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.skins.addonSkins.mdt then
				private.skins.addonSkins.mdt = nil
				UpdateMessage(
					L["Private: Skins - Method Dungeon Tool"] .. ": " .. L["Database cleanup"],
					privateVersion
				)
			end
			if private.skins.addonSkins.tom then
				private.skins.addonSkins.tom = nil
				UpdateMessage(L["Private: Skins - TomTom"] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.skins.addonSkins.rematch then
				private.skins.addonSkins.rematch = nil
				UpdateMessage(L["Private: Skins - Rematch"] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.skins.addonSkins.simc then
				private.skins.addonSkins.simc = nil
				UpdateMessage(L["Private: Skins - SimulationCraft"] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.skins.addonSkins.aio then
				private.skins.addonSkins.aio = nil
				UpdateMessage(
					L["Private: Skins - AdvancedInterfaceOptions"] .. ": " .. L["Database cleanup"],
					privateVersion
				)
			end
			if private.skins.addonSkins.whisperPop then
				private.skins.addonSkins.whisperPop = nil
				UpdateMessage(L["Private: Skins - WhisperPop "] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.skins.addonSkins.plumber then
				private.skins.addonSkins.plumber = nil
				UpdateMessage(L["Private: Skins - Plumber"] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.skins.addonSkins.legionRemixHelper then
				private.skins.addonSkins.legionRemixHelper = nil
				UpdateMessage(L["Private: Skins - LegionRemixHelper"] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.skins.uiErrors then
				private.skins.uiErrors = nil
				UpdateMessage(L["Private: Skins - UIErrors"] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.mui.skins.ime then
				private.skins.ime = nil
				UpdateMessage(L["Private: Skins - UIErrors"] .. ": " .. L["Database cleanup"], privateVersion)
			end
			if private.skins.cooldownViewer then
				private.skins.cooldownViewer = nil
				UpdateMessage(L["Private: Skins - Cooldown Viewer"] .. ": " .. L["Database cleanup"], privateVersion)
			end
		end
		if db then
			if db.merchant then
				db.merchant = nil
				UpdateMessage(L["Profile: Extended Vendor Frame"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.blizzard then
				db.blizzard = nil
				UpdateMessage(L["Profile: Blizzard"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.quest then
				db.quest = nil
				UpdateMessage(L["Profile: Quest"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.chat then
				db.chat = nil
				UpdateMessage(L["Profile: Chat"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.mail then
				db.mail = nil
				UpdateMessage(L["Profile: Mail"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.announcement then
				db.announcement = nil
				UpdateMessage(L["Profile: Announcement"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.misc.spellActivationAlert then
				db.misc.spellActivationAlert = nil
				UpdateMessage(L["Profile: Spell Activation Alert"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.misc.hideBossBanner then
				db.misc.hideBossBanner = nil
				UpdateMessage(L["Profile: Hide Boss Banner"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.misc.alreadyKnown then
				db.misc.alreadyKnown = nil
				UpdateMessage(L["Profile: Already Known"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.misc.mute then
				db.misc.mute = nil
				UpdateMessage(L["Profile: Mute"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.misc.randomToy then
				db.misc.randomToy = nil
				UpdateMessage(L["Profile: Random Toy"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.misc.automation then
				db.misc.automation = nil
				UpdateMessage(L["Profile: Automation"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.misc.contextMenu then
				db.misc.contextMenu = nil
				UpdateMessage(L["Profile: Context Menu"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.misc.focuser then
				db.misc.focuser = nil
				UpdateMessage(L["Profile: Focuser"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.misc.exitPhaseDiving then
				db.misc.exitPhaseDiving = nil
				UpdateMessage(L["Profile: Exit Phase Diving"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.misc.achievementTracker then
				db.achievementTracker = nil
				UpdateMessage(L["Profile: Achievement Tracker"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.misc.quickKeystone then
				db.misc.quickKeystone = nil
				UpdateMessage(L["Profile: Quick Keystone"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.datatexts and db.datatexts.durabilityIlevel then
				db.datatexts.durabilityIlevel = nil
				UpdateMessage(L["Profile: Durability Datatext"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.autoButtons then
				db.autoButtons = nil
				UpdateMessage(L["Profile: Auto Buttons"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.microBar then
				db.microBar = nil
				UpdateMessage(L["Profile: Micro Bar"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.unitframes.healhealPrediction then
				db.unitframes.healhealPrediction = nil
				UpdateMessage(
					L["Profile: Unitframes - Heal Prediction"] .. ": " .. L["Database cleanup"],
					profileVersion
				)
			end
			if db.unitframes.roleIcons then
				db.unitframes.roleIcons = nil
				UpdateMessage(L["Profile: Unitframes - Role Icons"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.maps.minimap.ping then
				db.maps.minimap.ping = nil
				UpdateMessage(L["Profile: Minimap - Ping"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.maps.minimap.coords then
				db.maps.minimap.coords = nil
				UpdateMessage(L["Profile: Minimap - Coords"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.maps.instanceDifficulty then
				db.maps.instanceDifficulty = nil
				UpdateMessage(L["Profile: Maps - Instance Difficulty"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.maps.rectangleMinimap then
				db.maps.rectangleMinimap = nil
				UpdateMessage(L["Profile: Maps - Rectangle Minimap"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.maps.superTracker then
				db.maps.superTracker = nil
				UpdateMessage(L["Profile: Maps - Super Tracker"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.maps.worldMap then
				db.maps.worldMap = nil
				UpdateMessage(L["Profile: Maps - World Map"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.maps.eventTracker then
				db.maps.eventTracker = nil
				UpdateMessage(L["Profile: Maps - Event Tracker"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.smb then
				db.smb = nil
				UpdateMessage(L["Profile: Minimap Button Bar"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.raidmarkers then
				db.raidmarkers = nil
				UpdateMessage(L["Profile: Raid Markers"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.tooltip.modifier then
				db.tooltip.modifier = nil
				UpdateMessage(L["Profile: Tooltip - Modifier"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.tooltip.titleIcon then
				db.tooltip.titleIcon = nil
				UpdateMessage(L["Profile: Tooltip - Title Icon"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.tooltip.factionIcon then
				db.tooltip.factionIcon = nil
				UpdateMessage(L["Profile: Tooltip - Faction Icon"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.tooltip.petIcon then
				db.tooltip.petIcon = nil
				UpdateMessage(L["Profile: Tooltip - Pet Icon"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.tooltip.specIcon then
				db.tooltip.specIcon = nil
				UpdateMessage(L["Profile: Tooltip - Spec Icon"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.tooltip.raceIcon then
				db.tooltip.raceIcon = nil
				UpdateMessage(L["Profile: Tooltip - Race Icon"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.tooltip.healthBar then
				db.tooltip.healthBar = nil
				UpdateMessage(L["Profile: Tooltip - Health Bar"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.tooltip.forceItemLevel then
				db.tooltip.forceItemLevel = nil
				UpdateMessage(L["Profile: Tooltip - Force Item Level"] .. ": " .. L["Database cleanup"], profileVersion)
			end
			if db.item then
				db.item = nil
				UpdateMessage(L["Profile: Item"] .. ": " .. L["Database cleanup"], profileVersion)
			end
		end
	end

	if not isFirstLine then
		WF.PrintGradientLine()
	end

	E.global.mui.version = MER.Version
	E.db.mui.version = MER.Version
	E.private.mui.version = MER.Version
end
