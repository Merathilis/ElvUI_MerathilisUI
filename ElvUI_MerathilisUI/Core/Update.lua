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

	local updated = false
	if profileVersion and profileVersion <= 6.34 then
		if E.private.mui.skins then
			for _, widget in pairs({
				"button",
				"tab",
				"treeGroupButton",
			}) do
				if E.private.mui.skins.widgets[widget] and E.private.mui.skins.widgets[widget].backdrop then
					E.private.mui.skins.widgets[widget].backdrop.alpha = nil
					E.private.mui.skins.widgets[widget].backdrop.animationType = nil
					E.private.mui.skins.widgets[widget].backdrop.animationDuration = nil
				end
			end
			UpdateMessage(L["Skins"] .. " - " .. L["Widgets"] .. ": " .. L["Update Database"], privateVersion)
		end

		updated = true
	end

	if not isFirstLine then
		F.PrintGradientLine()
	end

	E.global.mui.version = MER.Version
	E.db.mui.version = MER.Version
	E.private.mui.version = MER.Version
end
