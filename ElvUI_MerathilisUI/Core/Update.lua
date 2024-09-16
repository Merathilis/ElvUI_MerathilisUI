local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local print, tonumber, type = print, tonumber, type
local format = string.format

local isFirstLine = true

local DONE_ICON = format(" |T%s:0|t", [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\Complete.tga]])

local function UpdateMessage(text, from)
	if isFirstLine then
		isFirstLine = false
		F.PrintGradientLine()
		F.Print(L["Update"])
	end

	E:Delay(1, function()
		print(text .. format("(|cff00a8ff%.2f|r -> |cff00a8ff%s|r)...", from, MER.Version) .. DONE_ICON)
	end)
end

function MER:UpdateScripts() -- DB Convert
	local currentVersion = tonumber(MER.Version) -- Installed MerathilisUI Version
	local globalVersion = tonumber(E.global.mui.version or "0") -- Version in ElvUI Global

	local db = E.db.mui
	local private = E.private.mui
	local global = E.global.mui

	-- changelog display
	if globalVersion == 0 or globalVersion ~= currentVersion then
		self.showChangeLog = true
	end

	local profileVersion = tonumber(E.db.mui.version or globalVersion) -- Version in ElvUI Profile
	local privateVersion = tonumber(E.private.mui.version or globalVersion) -- Version in ElvUI Private

	if globalVersion == currentVersion and profileVersion == currentVersion and privateVersion == currentVersion then
		return
	end

	print(globalVersion, profileVersion, privateVersion, currentVersion)

	isFirstLine = true

	if profileVersion and profileVersion <= 6.37 then
		if db and db.blizzard.friendsList then
			db.blizzard.friendsList.client = nil
			db.blizzard.friendsList.factionIcon = nil

			UpdateMessage(L["Friend List"] .. " - " .. L["Update Database"], profileVersion)
		end

		if db.chat.chatBar and db.chat.chatBar.channels and db.chat.chatBar.channels.world then
			db.chat.chatBar.channels.world.enable = false
			db.chat.chatBar.channels.world.autoJoin = nil
			db.chat.chatBar.channels.world.name = nil

			UpdateMessage(L["Chat Bar"] .. " - " .. L["Update Database"], profileVersion)
		end
	end

	if profileVersion and profileVersion <= 6.38 then
		if db and db.maps.eventTracker then
			if db.maps.eventTracker.iskaaranFishingNet then
				db.maps.eventTracker.iskaaranFishingNet.enable = false
				UpdateMessage(L["Event Tracker"] .. ": " .. L["Update Database"], profileVersion)
			end
		end
	end

	if profileVersion and profileVersion < 6.39 then
		if db and db.maps.eventTracker then
			if db.maps.eventTracker.worldSoul then
				db.maps.eventTracker.worldSoul = nil
				UpdateMessage(L["Event Tracker"] .. " - " .. L["Update Database"], profileVersion)
			end
		end
	end

	if globalVersion and globalVersion < 6.39 then
		if global and global.core then
			global.core.fixPlaystyle = nil
			UpdateMessage(L["Core"] .. " - " .. L["Update Database"], globalVersion)
		end
	end

	if profileVersion and profileVersion < 6.41 then
		if db and db.blizzard and db.blizzard.objectiveTracker then
			db.blizzard.objectiveTracker = nil
			UpdateMessage(L["Objective Tracker"] .. " - " .. L["Update Database"], profileVersion)
		end
	end

	if not isFirstLine then
		F.PrintGradientLine()
	end

	E.global.mui.version = MER.Version
	E.db.mui.version = MER.Version
	E.private.mui.version = MER.Version
end
