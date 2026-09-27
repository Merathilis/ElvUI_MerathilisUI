local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local C = W.Utilities.Color

local print, tonumber = print, tonumber
local format = string.format

local isFirstLine = true

local DONE_ICON = format(" |T%s:0|t", [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\Complete.tga]])

---@param text string
---@param from number
local function UpdateMessage(text, from)
	-- Everything is printed after a delay (chat is ready then), header and footer too so the order holds
	if isFirstLine then
		isFirstLine = false
		E:Delay(1, WF.PrintGradientLine)
		E:Delay(1, F.Print, L["Update"])
	end

	local versionText = format(
		"(%s -> %s)...",
		C.StringByTemplate(format("%.2f", from), "neutral-300"),
		C.StringByTemplate(MER.Version, "emerald-400")
	)

	E:Delay(1, print, text, versionText, DONE_ICON)
end

---Remove E.db.mui[key] and report whether there was anything to remove
---@param key string
---@return boolean removed
local function RemoveProfileKey(key)
	if E.db.mui and E.db.mui[key] ~= nil then
		E.db.mui[key] = nil
		return true
	end

	return false
end

local function StampVersions()
	E.global.mui.version = MER.Version
	E.db.mui.version = MER.Version
	E.private.mui.version = MER.Version
end

function MER:UpdateScripts()
	local currentVersion = tonumber(MER.Version) or 0 -- Installed MerathilisUI Version
	local globalVersion = tonumber(E.global.mui.version) or 0 -- Version in ElvUI Global

	-- from old updater
	if globalVersion == 0 then
		globalVersion = tonumber(E.global.mui.Version) or 0
		E.global.mui.Version = nil
	end

	-- Fresh install: nothing to migrate, just remember the version
	if globalVersion == 0 then
		StampVersions()
		return
	end

	local profileVersion = tonumber(E.db.mui.version) or globalVersion -- Version in ElvUI Profile
	local privateVersion = tonumber(E.private.mui.version) or globalVersion -- Version in ElvUI Private

	if globalVersion == currentVersion and profileVersion == currentVersion and privateVersion == currentVersion then
		return
	end

	isFirstLine = true

	-- Only report a migration when it actually changed something in this profile
	if profileVersion < 7.14 and RemoveProfileKey("gradient") then
		UpdateMessage(L["Gradient"] .. ": " .. L["Update Database"], profileVersion)
	end

	if profileVersion < 7.15 and RemoveProfileKey("cooldownManager") then
		UpdateMessage(L["Cooldown Manager"] .. ": " .. L["Update Database"], profileVersion)
	end

	-- Minimap Coordinates were merged into the Location Panel
	if profileVersion < 7.36 and RemoveProfileKey("miniMapCoords") then
		UpdateMessage(L["Location Panel"] .. ": " .. L["Update Database"], profileVersion)
	end

	if profileVersion < 7.37 then
		-- Removed settings: legacy gradient colors, resting indicator custom gradient,
		-- the old Cooldown Manager and Raid Buffs modules and two unused tables
		RemoveProfileKey("gradient")
		RemoveProfileKey("cooldownManager")
		RemoveProfileKey("raidBuffs")
		RemoveProfileKey("colors")
		RemoveProfileKey("media")

		local restingIndicator = E.db.mui.unitframes and E.db.mui.unitframes.restingIndicator
		if restingIndicator then
			restingIndicator.customClassColor = nil
		end
	end

	if not isFirstLine then
		E:Delay(1, WF.PrintGradientLine)
	end

	StampVersions()
end
