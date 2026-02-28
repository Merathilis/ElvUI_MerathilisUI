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

	if profileVersion < 7.14 then
		if E.db.mui and E.db.mui.gradient then
			E.db.mui.gradient = nil
		end

		UpdateMessage(L["Gradient"] .. ": " .. L["Update Database"], profileVersion)
	end

	if not isFirstLine then
		WF.PrintGradientLine()
	end

	E.global.mui.version = MER.Version
	E.db.mui.version = MER.Version
	E.private.mui.version = MER.Version
end
