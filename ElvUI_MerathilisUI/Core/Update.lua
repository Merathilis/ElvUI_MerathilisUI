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

	isFirstLine = true

	if profileVersion and profileVersion <= 6.60 then
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

	if not isFirstLine then
		F.PrintGradientLine()
	end

	E.global.mui.version = MER.Version
	E.db.mui.version = MER.Version
	E.private.mui.version = MER.Version
end
