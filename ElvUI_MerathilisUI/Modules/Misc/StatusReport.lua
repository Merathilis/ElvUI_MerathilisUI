local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc
local S = E:GetModule("Skins")
local WS = W:GetModule("Skins")

local _G = _G
local date = date
local format = string.format
local ipairs, pairs, next, type = ipairs, pairs, next, type
local tonumber, tostring = tonumber, tostring
local abs, max = math.abs, math.max
local sort, tconcat, tinsert = sort, table.concat, tinsert
local strfind, strlower = strfind, strlower

local CreateFrame = CreateFrame
local GetRealZoneText = GetRealZoneText
local InCombatLockdown = InCombatLockdown
local IsMacClient = IsMacClient
local GetCVar = C_CVar.GetCVar
local GetCVarBool = C_CVar.GetCVarBool
local SetCVar = C_CVar.SetCVar
local GetAddOnInfo = C_AddOns.GetAddOnInfo
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local GetNumAddOns = C_AddOns.GetNumAddOns
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local UNKNOWN = UNKNOWN

local englishClassName = {
	DEATHKNIGHT = "Death Knight",
	DEMONHUNTER = "Demon Hunter",
	DRUID = "Druid",
	EVOKER = "Evoker",
	HUNTER = "Hunter",
	MAGE = "Mage",
	MONK = "Monk",
	PALADIN = "Paladin",
	PRIEST = "Priest",
	ROGUE = "Rogue",
	SHAMAN = "Shaman",
	WARLOCK = "Warlock",
	WARRIOR = "Warrior",
}

-- Addons worth seeing at a glance, the copied report lists every loaded addon
local NOTABLE_ADDONS = { "BigWigs", "DBM-Core", "Details", "OmniCD", "Plater", "BugSack", "DevTool" }

-------------------------------------------------------------------------------
--  Report data
--  The report is a list of sections with { label, value, state } rows. The
--  window and the copyable text are both built from it, so they always match.
-------------------------------------------------------------------------------
local GOOD, WARNING, ERROR = "good", "warning", "error"

local STATE_COLOR = {
	[GOOD] = F.String.Good,
	[WARNING] = F.String.Warning,
	[ERROR] = F.String.Error,
}

-- The copied text has no colors, so problems get a marker instead
local STATE_MARK = {
	[WARNING] = " (!)",
	[ERROR] = " (!!)",
}

local function AddSection(sections, title)
	local section = { title = title, rows = {} }
	tinsert(sections, section)
	return section
end

---Rows can carry a `tip` (shown on hover) and an `onClick` with its `clickHint`
local function AddRow(section, label, value, state)
	local row = { label = label, value = tostring(value), state = state }
	tinsert(section.rows, row)
	return row
end

local function OnOff(value)
	return value and "On" or "Off"
end

local function ToggleCVar(name, value)
	if InCombatLockdown() then
		F.Print(_G.ERR_NOT_IN_COMBAT)
		return
	end

	SetCVar(name, value)
end

local function GetSpecName()
	local _, specID = F.GetPlayerSpec()
	return specID and I.SpecNames[specID] or UNKNOWN
end

local function GetAddOnVersion(name)
	if name == "ElvUI" then
		return E.versionString
	end

	-- Loaded is checked by the caller, but a Details that failed to load has no global
	if name == "Details" then
		local details = _G.Details
		local version = details and details.GetVersionString and details.GetVersionString()
		if version then
			return version
		end
	end

	return F.String.Strip(GetAddOnMetadata(name, "Version")) or UNKNOWN
end

local function GetAddOnTitle(name)
	if name == "Details" then
		return "Details!"
	end

	return F.String.Strip(GetAddOnMetadata(name, "Title")) or name
end

---Unique Lua errors BugGrabber caught this session, and how many of them involve MerathilisUI
---@return number? total nil when BugGrabber isn't loaded
---@return number own
local function GetSessionErrors()
	local grabber = _G.BugGrabber
	if not grabber or not grabber.GetDB or not grabber.GetSessionId then
		return nil, 0
	end

	local session = grabber:GetSessionId()
	local total, own = 0, 0
	for _, err in ipairs(grabber:GetDB()) do
		if err.session == session then
			total = total + 1

			-- Our errors carry the addon folder in the message or the stack
			for _, text in ipairs({ err.message, err.stack }) do
				if type(text) == "string" and strfind(text, MER.AddOnName, 1, true) then
					own = own + 1
					break
				end
			end
		end
	end

	return total, own
end

local function BuildAddOnSection(sections)
	local section = AddSection(sections, "MerathilisUI")
	AddRow(section, "Version", MER.DisplayVersion, GOOD)
	local elvui = AddRow(section, "ElvUI", E.versionString, E.recievedOutOfDateMessage and WARNING or GOOD)
	if E.recievedOutOfDateMessage then
		elvui.tip = "A newer ElvUI version is available, please update it first."
	end
	AddRow(section, "WindTools", W.Version or UNKNOWN, GOOD)

	local layoutVersion = E.db.mui.core.lastLayoutVersion
	local profile
	if not F.IsMERProfile() then
		profile = AddRow(section, "Profile", "Not installed", ERROR)
		profile.tip = "Most MerathilisUI features need its profile. Install it with /mui install."
	elseif layoutVersion ~= MER.DisplayVersion then
		profile = AddRow(section, "Profile", format("Installed with %s", layoutVersion), WARNING)
		profile.tip = "The profile is from an older version. If something looks off, reinstall it with /mui install."
	else
		AddRow(section, "Profile", layoutVersion, GOOD)
	end

	if profile then
		profile.clickHint = "Start the installer"
		profile.onClick = function()
			E:GetModule("PluginInstaller"):Queue(MER.installTable)
		end
	end

	AddRow(section, "Game", E.Forever and "Forever" or "Retail")
end

local function BuildSettingsSection(sections)
	local section = AddSection(sections, "Settings")

	-- Compared with a tolerance, the saved value can differ in the last digits after a reload
	local uiScale, bestScale = E.global.general.UIScale, E:PixelBestSize()
	if abs(uiScale - bestScale) < 0.001 then
		AddRow(section, "UI Scale", format("%.3f", uiScale), GOOD)
	else
		local row = AddRow(section, "UI Scale", format("%.3f (pixel perfect: %.3f)", uiScale, bestScale), WARNING)
		row.tip = "Borders can look blurry or uneven. Use Auto Scale in ElvUI > General for the pixel perfect value."
	end

	AddRow(section, "Style", OnOff(E.db.mui.style.enable))
	AddRow(section, "Gradient Mode", OnOff(E.db.mui.themes.gradientMode.enable))

	-- Features switched off by ElvUI settings or other addons, the profile has its own row
	local features = {}
	for feature in pairs(I.Requirements) do
		tinsert(features, feature)
	end
	sort(features)

	local blocked = false
	for _, feature in ipairs(features) do
		local requirement = MER:CheckRequirements(I.Requirements[feature], true)
		if requirement ~= true then
			local row = AddRow(section, feature, MER:GetRequirementString(requirement) or "?", WARNING)
			row.tip = "This MerathilisUI feature stays off until the requirement is met."
			blocked = true
		end
	end

	if not blocked then
		AddRow(section, "Requirements", "All met", GOOD)
	end
end

local function BuildSystemSection(sections)
	local section = AddSection(sections, "System")
	AddRow(section, "WoW", format("%s (build %s)", E.wowpatch, E.wowbuild))
	AddRow(section, "Client", format("%s, %s", E.locale, IsMacClient() and "Mac" or "Windows"))
	AddRow(section, "Display", format("%s, %s", E.resolution, E:GetDisplayMode()))
end

local function BuildCharacterSection(sections)
	local section = AddSection(sections, "Character")
	AddRow(
		section,
		"Character",
		format("Level %s %s %s", E.mylevel, E.myrace, englishClassName[E.myclass] or E.myclass)
	)
	AddRow(section, "Specialization", GetSpecName())
	AddRow(section, "Faction", E.myfaction)
	AddRow(section, "Zone", GetRealZoneText() or UNKNOWN)
end

local function BuildDiagnosticsSection(sections)
	local section = AddSection(sections, "Diagnostics")

	local total, own = GetSessionErrors()
	local luaErrors
	if not total then
		luaErrors = AddRow(section, "Lua Errors", "BugGrabber not loaded", WARNING)
		luaErrors.tip = "Install BugGrabber and BugSack to collect Lua errors, they are counted here."
	elseif total == 0 then
		luaErrors = AddRow(section, "Lua Errors", "None", GOOD)
	else
		luaErrors = AddRow(
			section,
			"Lua Errors",
			format("%d, %d from %s", total, own, "MerathilisUI"),
			own > 0 and ERROR or WARNING
		)
		luaErrors.tip = "Errors BugGrabber caught this session. Add them to your bug report."
	end

	local openSack = _G.SlashCmdList.BugSack
	if openSack then
		luaErrors.clickHint = "Open BugSack"
		luaErrors.onClick = function()
			openSack("show")
		end
	end

	local errors, warnings = F.Developer.GetLogStats()
	local log = AddRow(
		section,
		"Log",
		format("%d errors, %d warnings", errors, warnings),
		(errors > 0 and ERROR) or (warnings > 0 and WARNING) or GOOD
	)
	log.tip = "MerathilisUI's own log since login, also included in Copy Report."
	log.clickHint = "Open the log"
	log.onClick = F.Developer.ShowLog

	local logLevel = AddRow(section, "Log Level", F.Developer.GetLogLevelName())
	logLevel.tip = "Messages at or above this level are printed to the chat. The log keeps all of them."
	logLevel.clickHint = "Next level (none, error, warning, info, debug)"
	logLevel.onClick = function()
		local level = F.Developer.GetLogLevel() + 1
		F.Developer.SetLogLevel(level > F.Developer.LogLevel.DEBUG and F.Developer.LogLevel.NONE or level)
	end

	local channels = F.Developer.GetActiveChannels()
	local debugChannels = AddRow(section, "Debug Channels", #channels > 0 and tconcat(channels, ", ") or "None")
	debugChannels.tip = "Detailed tracing per module: /muidev debug <module> toggles one, /muidev debug lists them."

	local disabled = _G.ElvDB.MER and _G.ElvDB.MER.DisabledAddOns
	local debugMode
	if disabled and next(disabled) then
		local count = 0
		for _ in pairs(disabled) do
			count = count + 1
		end
		debugMode = AddRow(section, "Debug Mode", format("On, %d AddOns disabled", count), WARNING)
		debugMode.tip = "/muidebug off enables the other AddOns again."
	else
		debugMode = AddRow(section, "Debug Mode", "Off")
		debugMode.tip = "/muidebug on disables all AddOns except ElvUI, MerathilisUI and BugSack to rule out conflicts."
	end

	local scriptErrors = GetCVarBool("scriptErrors")
	local showErrors = AddRow(section, "Show Lua Errors", OnOff(scriptErrors))
	showErrors.tip = "Blizzard's Lua error popup. With BugSack installed, errors are collected there anyway."
	showErrors.clickHint = scriptErrors and "Turn off" or "Turn on"
	showErrors.onClick = function()
		ToggleCVar("scriptErrors", scriptErrors and "0" or "1")
	end

	local taintLevel = tonumber(GetCVar("taintLog")) or 0
	local taintLog = AddRow(section, "Taint Log", taintLevel > 0 and ("Level " .. taintLevel) or "Off")
	taintLog.tip = 'Writes blocked actions ("Interface action failed") to Logs/taint.log in the WoW folder. '
		.. "Level 2 is very verbose, turn it off again when you are done."
	taintLog.clickHint = "Next level (off, 1, 2)"
	taintLog.onClick = function()
		ToggleCVar("taintLog", tostring((taintLevel + 1) % 3))
	end

	-- Profiling slows down every addon, worth knowing when someone reports bad performance
	local profiling = GetCVarBool("scriptProfile")
	local cpuProfiling = AddRow(section, "CPU Profiling", OnOff(profiling), profiling and WARNING or nil)
	cpuProfiling.tip = "Needed to measure addon CPU usage, but slows down every addon. Takes effect after a /reload."
	cpuProfiling.clickHint = profiling and "Turn off" or "Turn on"
	cpuProfiling.onClick = function()
		ToggleCVar("scriptProfile", profiling and "0" or "1")
	end
end

local function BuildAddOnsSection(sections)
	local section = AddSection(sections, "AddOns")

	local loaded = 0
	for i = 1, GetNumAddOns() do
		if IsAddOnLoaded(i) then
			loaded = loaded + 1
		end
	end
	AddRow(section, "Loaded", loaded)

	for _, name in ipairs(NOTABLE_ADDONS) do
		if IsAddOnLoaded(name) then
			AddRow(section, GetAddOnTitle(name), GetAddOnVersion(name), GOOD)
		end
	end
end

local function BuildPluginsSection(sections)
	local plugins = {}
	for _, data in pairs(E.Libs.EP.plugins) do
		if not data.isLib and data.name ~= MER.AddOnName then
			tinsert(plugins, data)
		end
	end

	if not next(plugins) then
		return
	end

	sort(plugins, function(a, b)
		return strlower(F.String.Strip(a.title or a.name) or "") < strlower(F.String.Strip(b.title or b.name) or "")
	end)

	local section = AddSection(sections, "Plugins")
	for _, data in ipairs(plugins) do
		local version = F.String.Strip(data.version) or UNKNOWN
		AddRow(section, data.title or data.name or UNKNOWN, version, (data.old or version == UNKNOWN) and ERROR or GOOD)
	end
end

---@return table left sections of the left column
---@return table right sections of the right column
local function BuildReport()
	local left, right = {}, {}

	BuildAddOnSection(left)
	BuildSettingsSection(left)
	BuildSystemSection(left)
	BuildCharacterSection(left)

	BuildDiagnosticsSection(right)
	BuildAddOnsSection(right)
	BuildPluginsSection(right)

	return left, right
end

-------------------------------------------------------------------------------
--  Copyable text
-------------------------------------------------------------------------------
local function AppendSections(lines, sections)
	for _, section in ipairs(sections) do
		tinsert(lines, "")
		tinsert(lines, "[" .. section.title .. "]")

		for _, row in ipairs(section.rows) do
			local label = F.String.Strip(row.label)
			local value = F.String.Strip(row.value)
			tinsert(lines, format("%s: %s%s", label, value, STATE_MARK[row.state] or ""))
		end
	end
end

---The full report as plain text: status, every loaded addon and the MerathilisUI log
---@return string
function module:StatusReportGetText()
	local left, right = BuildReport()
	local lines = { format("MerathilisUI Status Report - %s", date("%Y-%m-%d %H:%M")) }

	AppendSections(lines, left)
	AppendSections(lines, right)

	local addOns = {}
	for i = 1, GetNumAddOns() do
		if IsAddOnLoaded(i) then
			local name = GetAddOnInfo(i)
			tinsert(addOns, format("%s %s", name, GetAddOnVersion(name)))
		end
	end

	tinsert(lines, "")
	tinsert(lines, format("[Loaded AddOns (%d)]", #addOns))
	tinsert(lines, tconcat(addOns, "\n"))

	tinsert(lines, "")
	tinsert(lines, "[Log]")
	tinsert(lines, F.Developer.GetLogText())

	return tconcat(lines, "\n")
end

-------------------------------------------------------------------------------
--  Window
-------------------------------------------------------------------------------
local COLUMN_WIDTH = 330
local COLUMN_GAP = 30
local PADDING = 20
local CONTENT_TOP = 95
local HEADER_HEIGHT = 30
local ROW_HEIGHT = 18
local ROW_SPACING = 4
local SECTION_SPACING = 10
local BUTTON_AREA = 65

local function CreateDivider(header, gradientToRight)
	local color = I.Strings.Branding.ColorRGBA

	local divider = header:CreateTexture(nil, "ARTWORK")
	divider:SetHeight(2)
	divider:SetTexture(E.media.blankTex)
	divider:SetVertexColor(1, 1, 1, 1)
	F.Color.SetGradientRGB(
		divider,
		"HORIZONTAL",
		color.r,
		color.g,
		color.b,
		gradientToRight and color.a or 0,
		color.r,
		color.g,
		color.b,
		gradientToRight and 0 or color.a
	)

	return divider
end

local function CreateHeader(parent)
	local header = CreateFrame("Frame", nil, parent)
	header:Height(HEADER_HEIGHT)

	local text = header:CreateFontString(nil, "ARTWORK")
	text:FontTemplate(nil, 16, "NONE", true)
	text:SetShadowOffset(1, -2)
	text:Point("CENTER")
	header.Text = text

	local leftDivider = CreateDivider(header, false)
	leftDivider:Point("LEFT", header, "LEFT", 5, 0)
	leftDivider:Point("RIGHT", text, "LEFT", -8, 0)

	local rightDivider = CreateDivider(header, true)
	rightDivider:Point("RIGHT", header, "RIGHT", -5, 0)
	rightDivider:Point("LEFT", text, "RIGHT", 8, 0)

	return header
end

local function Row_OnEnter(self)
	local data = self.data
	local truncated = self.Value:IsTruncated()

	if data.onClick then
		self.Highlight:Show()
	end

	-- Long values (debug channels, requirement reasons) are cut off, the tooltip shows them in full
	if not truncated and not data.tip and not data.onClick then
		return
	end

	local tooltip = _G.GameTooltip
	tooltip:SetOwner(self, "ANCHOR_TOP")
	tooltip:AddLine(F.String.Strip(data.label), 1, 1, 1)
	if truncated then
		tooltip:AddLine(self.Value:GetText(), nil, nil, nil, true)
	end
	if data.tip then
		tooltip:AddLine(data.tip, 0.8, 0.8, 0.8, true)
	end
	if data.onClick then
		tooltip:AddLine(format("Click: %s", data.clickHint or data.label), 0.3, 1, 0.3)
	end
	tooltip:Show()
end

local function Row_OnLeave(self)
	self.Highlight:Hide()
	_G.GameTooltip:Hide()
end

local function Row_OnMouseUp(self, button)
	local onClick = self.data.onClick
	if button ~= "LeftButton" or not onClick or not self:IsMouseOver() then
		return
	end

	onClick()

	-- Show the new state, the row keeps its place so the tooltip can follow it
	module:StatusReportUpdate()
	if self:IsShown() and self:IsMouseOver() then
		Row_OnLeave(self)
		Row_OnEnter(self)
	end
end

local function CreateRow(parent)
	local row = CreateFrame("Frame", nil, parent)
	row:Height(ROW_HEIGHT)

	local label = row:CreateFontString(nil, "ARTWORK")
	label:FontTemplate(nil, 13, "OUTLINE")
	label:Point("LEFT", row, "LEFT", 10, 0)
	label:SetJustifyH("LEFT")
	label:SetTextColor(0.85, 0.85, 0.85)
	row.Label = label

	local value = row:CreateFontString(nil, "ARTWORK")
	value:FontTemplate(nil, 13, "OUTLINE")
	value:Point("RIGHT", row, "RIGHT", -10, 0)
	value:Point("LEFT", label, "RIGHT", 10, 0)
	value:SetJustifyH("RIGHT")
	value:SetWordWrap(false)
	row.Value = value

	-- Marks rows that can be clicked while hovering them
	local highlight = row:CreateTexture(nil, "BACKGROUND")
	highlight:SetAllPoints()
	highlight:SetTexture(E.media.blankTex)
	highlight:SetVertexColor(1, 1, 1, 0.08)
	highlight:Hide()
	row.Highlight = highlight

	row:EnableMouse(true)
	row:SetScript("OnEnter", Row_OnEnter)
	row:SetScript("OnLeave", Row_OnLeave)
	row:SetScript("OnMouseUp", Row_OnMouseUp)

	return row
end

---Lay out the sections in a column, reusing headers and rows from earlier updates
---@return number height
local function RenderColumn(column, sections)
	local headerIndex, rowIndex, offset = 0, 0, 0

	for _, section in ipairs(sections) do
		headerIndex = headerIndex + 1
		local header = column.headers[headerIndex] or CreateHeader(column)
		column.headers[headerIndex] = header
		header:ClearAllPoints()
		header:Point("TOPLEFT", column, "TOPLEFT", 0, -offset)
		header:Point("TOPRIGHT", column, "TOPRIGHT", 0, -offset)
		header.Text:SetText(F.String.ColorFirstLetter(section.title))
		header:Show()
		offset = offset + HEADER_HEIGHT

		for _, data in ipairs(section.rows) do
			rowIndex = rowIndex + 1
			local row = column.rows[rowIndex] or CreateRow(column)
			column.rows[rowIndex] = row
			row:ClearAllPoints()
			row:Point("TOPLEFT", column, "TOPLEFT", 0, -offset)
			row:Point("TOPRIGHT", column, "TOPRIGHT", 0, -offset)
			row.data = data
			row.Label:SetText(data.label)
			row.Value:SetText(STATE_COLOR[data.state] and STATE_COLOR[data.state](data.value) or data.value)
			row:Show()
			offset = offset + ROW_HEIGHT + ROW_SPACING
		end

		offset = offset + SECTION_SPACING
	end

	for i = headerIndex + 1, #column.headers do
		column.headers[i]:Hide()
	end
	for i = rowIndex + 1, #column.rows do
		column.rows[i]:Hide()
	end

	return offset
end

local function CreateColumn(parent, xOffset)
	local column = CreateFrame("Frame", nil, parent)
	column:Point("TOPLEFT", parent, "TOPLEFT", xOffset, -CONTENT_TOP)
	column:Width(COLUMN_WIDTH)
	column.headers = {}
	column.rows = {}

	return column
end

local function CreateButton(parent, text, onClick)
	local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	button:Size(120, 22)
	button:SetText(text)
	button:SetScript("OnClick", onClick)
	S:HandleButton(button)

	return button
end

function module:StatusReportCreate()
	local frame = CreateFrame("Frame", "MER_StatusReport", E.UIParent)
	frame:Point("CENTER", E.UIParent, "CENTER")
	frame:SetFrameStrata("HIGH")
	frame:CreateBackdrop("Transparent")
	WS:CreateBackdropShadow(frame)
	frame:CreateCloseButton()
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:Width(PADDING * 2 + COLUMN_WIDTH * 2 + COLUMN_GAP)
	frame:Hide()
	tinsert(_G.UISpecialFrames, frame:GetName()) -- Hide with ESC

	-- Reopen the options when the report was opened from there, also when closed with ESC
	frame:SetScript("OnHide", function()
		if module.StatusReportToggled then
			module.StatusReportToggled = nil
			E:ToggleOptions()
		end
	end)

	-- Title logo (drag to move frame)
	local titleLogoFrame = CreateFrame("Frame", nil, frame, "TitleDragAreaTemplate")
	titleLogoFrame:Point("CENTER", frame, "TOP")
	titleLogoFrame:Size(240, 80)
	frame.TitleLogoFrame = titleLogoFrame

	local logo = titleLogoFrame:CreateTexture(nil, "ARTWORK")
	logo:Point("CENTER", titleLogoFrame, "TOP", 0, -65)
	logo:SetTexture(I.Media.Logos.Logo)
	logo:Size(128)
	titleLogoFrame.Logo = logo

	frame.LeftColumn = CreateColumn(frame, PADDING)
	frame.RightColumn = CreateColumn(frame, PADDING + COLUMN_WIDTH + COLUMN_GAP)

	-- Buttons
	frame.CopyButton = CreateButton(frame, "Copy Report", function()
		F.Developer.ShowText("Status Report", module:StatusReportGetText())
	end)
	frame.CopyButton:Point("BOTTOM", frame, "BOTTOM", 0, 15)

	frame.LogButton = CreateButton(frame, "Open Log", F.Developer.ShowLog)
	frame.LogButton:Point("RIGHT", frame.CopyButton, "LEFT", -10, 0)

	frame.RefreshButton = CreateButton(frame, "Refresh", function()
		module:StatusReportUpdate()
	end)
	frame.RefreshButton:Point("LEFT", frame.CopyButton, "RIGHT", 10, 0)

	local hint = frame:CreateFontString(nil, "ARTWORK")
	hint:FontTemplate(nil, 12, "OUTLINE")
	hint:Point("BOTTOM", frame.CopyButton, "TOP", 0, 8)
	hint:SetTextColor(0.6, 0.6, 0.6)
	hint:SetText("Hover a row for tips, rows that light up can be clicked to change them.")
	frame.Hint = hint

	return frame
end

function module:StatusReportUpdate()
	local frame = self.StatusReportFrame
	local left, right = BuildReport()

	local height = max(RenderColumn(frame.LeftColumn, left), RenderColumn(frame.RightColumn, right))
	frame.LeftColumn:Height(height)
	frame.RightColumn:Height(height)
	frame:Height(CONTENT_TOP + height + BUTTON_AREA)
end

function module:StatusReportShow()
	if not self.StatusReportFrame then
		self.StatusReportFrame = self:StatusReportCreate()
	end

	if not self.StatusReportFrame:IsShown() then
		self:StatusReportUpdate()
		self.StatusReportFrame:Raise()
		self.StatusReportFrame:Show()
	else
		self.StatusReportFrame:Hide()
	end
end
