local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local print, tonumber, type = print, tonumber, type
local format = string.format

local isFirstLine = true

-- local DONE_ICON = format(" |T%s:0|t", MER.Media.Icons.accept)

local function UpdateMessage(text, from)
	if isFirstLine then
		isFirstLine = false
		F.PrintGradientLine()
		F.Print(L["Update"])
	end

	print(text .. format("(|cff00a8ff%.2f|r -> |cff00a8ff%s|r)...", from, MER.Version)) --DONE_ICON)
end

function MER:ForPreReleaseUser() end

function MER:UpdateScripts() -- DB Convert
	MER:ForPreReleaseUser()

	local currentVersion = tonumber(MER.Version) -- Installed MerathilisUI Version
	local globalVersion = tonumber(E.global.mui.version or "0") -- Version in ElvUI Global
	local profileVersion = tonumber(E.db.mui.version or globalVersion) -- Version in ElvUI Profile
	local privateVersion = tonumber(E.private.mui.version or globalVersion) -- Version in ElvUI Private

	-- changelog display
	if globalVersion == 0 or globalVersion ~= currentVersion then
		self.showChangeLog = true
	end

	if globalVersion == currentVersion and profileVersion == currentVersion and privateVersion == currentVersion then
		return
	end

	isFirstLine = true

	local updated = false
	if profileVersion and profileVersion <= 6.01 then
		-- if E.db.mui.notification and E.db.mui.notification.vignette and type(E.db.mui.notification.vignette) ~= 'table' then
		-- E.db.mui.notification.vignette = {}
		-- E.db.mui.notification.rarePrint = nil
		-- end
		if E.db.unitframe.units.player.customTexts.Resting ~= nil then
			E.db.unitframe.units.player.customTexts.Resting = nil
		end

		UpdateMessage(L["UnitFrame"] .. " - " .. L["Updated Custom Text"], profileVersion)

		updated = true
	end

	if not isFirstLine then
		F.PrintGradientLine()
	end

	E.global.mui.version = MER.Version
	E.db.mui.version = MER.Version
	E.private.mui.version = MER.Version
end
