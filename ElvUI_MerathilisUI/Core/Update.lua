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

	print(text .. format("(|cff00a8ff%.2f|r -> |cff00a8ff%s|r)...", from, MER.Version, DONE_ICON))
end

function MER:ForPreReleaseUser() end

function MER:UpdateScripts() -- DB Convert
	MER:ForPreReleaseUser()

	local currentVersion = tonumber(MER.Version) -- Installed MerathilisUI Version
	local globalVersion = tonumber(E.global.mui.version or "0") -- Version in ElvUI Global

	-- changelog display
	if globalVersion == 0 or globalVersion ~= currentVersion then
		self.showChangeLog = true
	end

	local profileVersion = tonumber(E.db.mui.version or globalVersion) -- Version in ElvUI Profile
	local privateVersion = tonumber(E.private.mui.version or globalVersion) -- Version in ElvUI Private

	if globalVersion == currentVersion and profileVersion == currentVersion and privateVersion == currentVersion then
		return
	end

	isFirstLine = true

	if profileVersion and profileVersion <= 6.37 then
		if E.db.mui then
			if E.db.mui.blizzard.friendsList then
				E.db.mui.blizzard.friendsList.client = nil
				E.db.mui.blizzard.friendsList.factionIcon = nil

				UpdateMessage(L["Friend List"] .. " - " .. L["Update Database"], profileVersion)
			end

			if E.db.mui.chat.chatBar and E.db.mui.chat.chatBar.channels and E.db.mui.chat.chatBar.channels.world then
				E.db.mui.chat.chatBar.channels.world.enable = false
				E.db.mui.chat.chatBar.channels.world.autoJoin = nil
				E.db.mui.chat.chatBar.channels.world.name = nil

				UpdateMessage(L["Chat Bar"] .. " - " .. L["Update Database"], profileVersion)
			end
		end
	end

	if profileVersion and profileVersion <= 6.38 then
		if E.db.mui and E.db.mui.maps.eventTracker then
			if E.db.mui.maps.eventTracker.iskaaranFishingNet then
				E.db.mui.maps.eventTracker.iskaaranFishingNet.enable = false
				UpdateMessage(L["Event Tracker"] .. ": " .. L["Update Database"], profileVersion)
			end
		end
	end

	if globalVersion < 6.39 then
		if E.global.mui and E.global.mui.core then
			E.global.mui.core.fixPlaystyle = nil
			UpdateMessage(L["Core"] .. " - " .. L["Update Database"], globalVersion)
		end
	end

	if not isFirstLine then
		F.PrintGradientLine()
	end

	E.global.mui.version = MER.Version
	E.db.mui.version = MER.Version
	E.private.mui.version = MER.Version
end
