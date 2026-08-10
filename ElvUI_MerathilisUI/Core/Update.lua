local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local C = W.Utilities.Color

local print, tonumber = print, tonumber
local format = string.format

local isFirstLine = true

local DONE_ICON = format(" |T%s:0|t", [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\Complete.tga]])

local defaults = {
	profile = P.mui or {},
	global = G.mui or {},
	char = V.mui or {},
}

---@param text string
---@param from number
local function UpdateMessage(text, from)
	if isFirstLine then
		isFirstLine = false
		WF.PrintGradientLine()
		F.Print(L["Update"])
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

	if profileVersion < 7.14 then
		if E.db.mui and E.db.mui.gradient then
			E.db.mui.gradient = nil
		end

		UpdateMessage(L["Gradient"] .. ": " .. L["Update Database"], profileVersion)
	end

	if profileVersion < 7.15 then
		if E.db.mui and E.db.mui.cooldownManager then
			E.db.mui.cooldownManager = nil
		end
		UpdateMessage(L["Cooldown Manager"] .. ": " .. L["Update Database"], profileVersion)
	end

	if not isFirstLine then
		WF.PrintGradientLine()
	end

	E.global.mui.version = MER.Version
	E.db.mui.version = MER.Version
	E.private.mui.version = MER.Version
end

function MER:InitializeDatabase()
	local currentProfile = E.data and E.data:GetCurrentProfile() or true
	self.db = MER.Libs.ADB:New("MERData", defaults, currentProfile)

	-- Optional: Per-Character-Daten
	-- self.charDB = MER.Libs.ADB:New("MERDataPerChar", { profile = V.mui or {} }, true)

	self:MigrateFromElvDB()

	self.db.RegisterCallback(self, "OnProfileChanged", "UpdateProfiles")
	self.db.RegisterCallback(self, "OnProfileCopied", "UpdateProfiles")
	self.db.RegisterCallback(self, "OnProfileReset", "UpdateProfiles")
end

function MER:MigrateFromElvDB()
	if self.db.global.muiMigrated then
		return
	end

	local migrated = false

	-------------------------------------------------
	-- 1. Profile-Data (E.db.mui → MER.db.profile)
	-------------------------------------------------
	if E.db and type(E.db.mui) == "table" and next(E.db.mui) then
		E:CopyTable(self.db.profile, E.db.mui)
		migrated = true
	end

	-------------------------------------------------
	-- 2. Global-Data (E.global.mui → MER.db.global)
	-------------------------------------------------
	if E.global and type(E.global.mui) == "table" and next(E.global.mui) then
		E:CopyTable(self.db.global, E.global.mui)
		migrated = true
	end

	-------------------------------------------------
	-- 3. Private / Char-Data (E.private.mui → MER.db.char)
	-------------------------------------------------
	if E.private and type(E.private.mui) == "table" and next(E.private.mui) then
		E:CopyTable(self.db.char, E.private.mui)
		migrated = true
	end

	self.db.global.muiMigrated = true

	if migrated then
		print("|cff00c0faMerathilisUI|r: Old settings from ElvDB are successfully migrated.")
	end
end
