local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local S = E:GetModule("Skins")
local WS = W:GetModule("Skins")

local _G = _G
local date = date
local format = format
local gsub = gsub
local ipairs, pairs, next = ipairs, pairs, next
local loadstring = loadstring
local print = print
local select = select
local sort = sort
local strlower = strlower
local strmatch = strmatch
local strupper = strupper
local tconcat = table.concat
local tinsert, tremove = tinsert, tremove
local tonumber, tostring, type = tonumber, tostring, type
local wipe = wipe

local CreateFrame = CreateFrame
local GetLocale = GetLocale
local issecretvalue = issecretvalue

F.Developer = {}

MER.IsDev = {
	["Asragoth"] = true,
	["Anonia"] = true,
	["Damará"] = true,
	["Jazira"] = true,
	["Jústice"] = true,
	["Maithilis"] = true,
	["Mattdemôn"] = true,
	["Melisendra"] = true,
	["Merathilis"] = true,
	["Mérathilis"] = true,
	["Merathilîs"] = true,
	["Róhal"] = true,
	["Rohala"] = true,
	["Ronan"] = true,
	["Brítt"] = true,
	["Brìtt"] = true,
	["Jahzzy"] = true,
	["Dâmara"] = true,
	["Meravoker"] = true,
}

-- Don't forget to update realm name(s) if we ever transfer realms.
-- If we forget it could be easly picked up by another player who matches these combinations.
-- End result we piss off people and we do not want to do that. :(
MER.IsDevRealm = {
	-- Live
	["Shattrath"] = true,
	["Garrosh"] = true,

	-- Beta
	["Turnips Delight"] = true,

	-- PTR
	["Broxigar"] = true,
}

---@return boolean
function F.IsDeveloper()
	return (MER.IsDev[E.myname] and MER.IsDevRealm[E.myrealm]) and true or false
end

-------------------------------------------------------------------------------
--  Settings
--  Log level and debug channels live in E.global.mui.developer (account wide),
--  so a toggled channel survives reloads while reproducing a bug.
-------------------------------------------------------------------------------
local LOG_LEVEL = {
	NONE = 0,
	ERROR = 1,
	WARNING = 2,
	INFO = 3,
	DEBUG = 4,
}
F.Developer.LogLevel = LOG_LEVEL

local LEVEL_NAMES = { "error", "warning", "info", "debug" }
local LEVEL_TAGS = {
	[LOG_LEVEL.ERROR] = "|cffff2457[ERROR]|r",
	[LOG_LEVEL.WARNING] = "|cfffdc600[WARNING]|r",
	[LOG_LEVEL.INFO] = "|cff00a4f3[INFO]|r",
	[LOG_LEVEL.DEBUG] = "|cff00d3bc[DEBUG]|r",
}

local function GetConfig()
	local config = E.global and E.global.mui and E.global.mui.developer
	if config and not config.channels then
		config.channels = {}
	end

	return config
end

---@return number
function F.Developer.GetLogLevel()
	local config = GetConfig()
	return config and config.logLevel or LOG_LEVEL.WARNING
end

-------------------------------------------------------------------------------
--  Log buffer
--  Every log line (printed or not) and every active debug channel line is kept
--  in a ring buffer. `/muidev log` opens it in a copy window so the whole
--  session can be pasted into a bug report in one go.
-------------------------------------------------------------------------------
local BUFFER_SIZE = 500
local buffer = {}

local function ToText(value)
	if issecretvalue and issecretvalue(value) then
		return "<secret>"
	end

	return tostring(value)
end

---Join all arguments with spaces; nil, tables and secret values are safe
local function JoinArgs(...)
	local count = select("#", ...)
	if count == 1 then
		return ToText(...)
	end

	local parts = {}
	for i = 1, count do
		parts[i] = ToText(select(i, ...))
	end

	return tconcat(parts, " ")
end

local function Record(tag, message)
	if #buffer >= BUFFER_SIZE then
		tremove(buffer, 1)
	end

	tinsert(buffer, format("%s %s %s", date("%H:%M:%S"), tag, message))
end

local function Emit(level, message)
	Record(LEVEL_TAGS[level], message)

	if F.Developer.GetLogLevel() >= level then
		print(format("%s%s %s", MER.Title, LEVEL_TAGS[level], message))
	end
end

---Error with MerathilisUI branding, routed through the Lua error handler (BugSack)
---@param ... any Message parts
function F.Developer.ThrowError(...)
	local message = JoinArgs(...)
	Record(LEVEL_TAGS[LOG_LEVEL.ERROR], message)
	_G.geterrorhandler()(format("%s|cffff2457[ERROR]|r\n%s", MER.Title, message))
end

---@param ... any Message parts
function F.Developer.LogWarning(...)
	Emit(LOG_LEVEL.WARNING, JoinArgs(...))
end

---@param ... any Message parts
function F.Developer.LogInfo(...)
	Emit(LOG_LEVEL.INFO, JoinArgs(...))
end

---@param ... any Message parts
function F.Developer.LogDebug(...)
	Emit(LOG_LEVEL.DEBUG, JoinArgs(...))
end

-------------------------------------------------------------------------------
--  Debug channels
--  Targeted, opt-in tracing for a single feature, independent of the log level:
--      F.Developer.Debug("Bags", "sorted", count, "items")
--      /muidev debug Bags
--  Channel names are case insensitive. Arguments are only formatted when the
--  channel is active, so calls can stay in hot paths.
-------------------------------------------------------------------------------
local knownChannels = {}

---@param channel string
---@return boolean
function F.Developer.IsDebugging(channel)
	local config = GetConfig()
	if not config or not next(config.channels) then
		return false
	end

	return config.channels.all or config.channels[strlower(channel)] or false
end

---@param channel string Channel name, e.g. the module or feature name
---@param ... any Message parts
function F.Developer.Debug(channel, ...)
	knownChannels[strlower(channel)] = channel

	if not F.Developer.IsDebugging(channel) then
		return
	end

	local message = JoinArgs(...)
	Record("[" .. channel .. "]", message)
	print(format("%s|cff00d3bc[%s]|r %s", MER.Title, channel, message))
end

---@param channel string
---@param state boolean? Explicit state, toggles when nil
---@return boolean enabled
function F.Developer.SetDebugChannel(channel, state)
	local config = GetConfig()
	if not config then
		return false
	end

	local key = strlower(channel)
	if state == nil then
		state = not config.channels[key]
	end

	config.channels[key] = state or nil
	F.Event.TriggerEvent("MER.DebugChannelChanged", key, state)

	return state
end

-------------------------------------------------------------------------------
--  Inspection
-------------------------------------------------------------------------------

---Pretty print any value (tables are printed recursively)
---@param object any
function F.Developer.Print(object)
	WF.Developer.Print(object)
end

---Inspect a value with DevTool when loaded, otherwise pretty print it
---@param object any
---@param name string?
function F.Developer.Dump(object, name)
	if _G.DevTool and _G.DevTool.AddData then
		_G.DevTool:AddData(object, name or "MER")
	else
		if name then
			F.Print(name .. ":")
		end
		F.Developer.Print(object)
	end
end

---Inject `module:Log(level, ...)` and `module:Debug(...)` into a module.
---`module:Debug` uses the module name without the "MER_" prefix as channel.
---@param module table|string Module object or module name
function F.Developer.InjectLogger(module)
	if type(module) == "string" then
		module = MER:GetModule(module, true)
	end

	if type(module) ~= "table" then
		F.Developer.ThrowError("InjectLogger: invalid module")
		return
	end

	local channel = gsub(module.name or "Unknown", "^MER_", "")
	local prefix = format("|cffffbf00%s|r", channel)
	knownChannels[strlower(channel)] = channel

	if not module.Log then
		function module:Log(level, ...)
			level = type(level) == "string" and strlower(level)
			if level == "info" then
				F.Developer.LogInfo(prefix, ...)
			elseif level == "warning" then
				F.Developer.LogWarning(prefix, ...)
			elseif level == "debug" then
				F.Developer.LogDebug(prefix, ...)
			elseif level == "error" then
				F.Developer.ThrowError(prefix, ...)
			else
				F.Developer.ThrowError("Logger level should be error, warning, info or debug")
			end
		end
	end

	if not module.Debug then
		function module:Debug(...)
			F.Developer.Debug(channel, ...)
		end
	end
end

-------------------------------------------------------------------------------
--  Delayed messages (printed once the UI is fully loaded)
-------------------------------------------------------------------------------
do
	local messages = {}

	function F.Developer.PrintDelayedMessages()
		for _, msg in ipairs(messages) do
			F.Print(msg)
		end

		wipe(messages)
	end

	function F.Developer.AddDelayedMessage(str)
		tinsert(messages, str)
	end
end

-------------------------------------------------------------------------------
--  Log window
-------------------------------------------------------------------------------
local logFrame

local function GetEnvironmentHeader()
	local lines = {
		format(
			"MerathilisUI %s | ElvUI %s | WindTools %s",
			MER.DisplayVersion or "?",
			E.version or "?",
			W and W.Version or "?"
		),
		format(
			"WoW %s (%s) %s | %s | %s",
			E.wowpatch or "?",
			E.wowbuild or "?",
			E.Forever and "Forever" or "Retail",
			GetLocale(),
			E.myclass or "?"
		),
		format("Log level: %s", LEVEL_NAMES[F.Developer.GetLogLevel()] or "none"),
	}

	local config = GetConfig()
	if config and next(config.channels) then
		local channels = {}
		for channel in pairs(config.channels) do
			tinsert(channels, channel)
		end
		sort(channels)
		tinsert(lines, "Debug channels: " .. tconcat(channels, ", "))
	end

	return tconcat(lines, "\n")
end

local function CreateLogFrame()
	local frame = CreateFrame("Frame", "MER_DeveloperLogFrame", E.UIParent)
	frame:SetSize(700, 450)
	frame:SetPoint("CENTER")
	frame:SetFrameStrata("DIALOG")
	frame:SetTemplate("Transparent")
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	frame:SetClampedToScreen(true)
	WS:CreateShadow(frame)
	tinsert(_G.UISpecialFrames, frame:GetName())

	frame.Header = frame:CreateFontString(nil, "OVERLAY")
	frame.Header:FontTemplate(nil, 14, "OUTLINE")
	frame.Header:SetPoint("TOP", 0, -8)
	frame.Header:SetText(MER.Title .. "Log")

	local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame)
	S:HandleCloseButton(close)

	local scrollArea = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", 10, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", -28, 10)
	S:HandleScrollBar(scrollArea.ScrollBar)

	local editBox = CreateFrame("EditBox", nil, scrollArea)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(0)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(true)
	editBox:FontTemplate(nil, 12, "NONE")
	editBox:SetWidth(frame:GetWidth() - 38)
	editBox:SetScript("OnEscapePressed", function()
		frame:Hide()
	end)
	-- Read-only: restore the log text if something was typed into it
	editBox:SetScript("OnTextChanged", function(self, userInput)
		if userInput then
			self:SetText(frame.text)
			self:HighlightText()
		end
	end)
	scrollArea:SetScrollChild(editBox)
	frame.EditBox = editBox

	return frame
end

function F.Developer.ShowLog()
	logFrame = logFrame or CreateLogFrame()

	local lines = { GetEnvironmentHeader(), "" }
	for i, line in ipairs(buffer) do
		lines[i + 2] = F.String.Strip(line)
	end
	if #buffer == 0 then
		tinsert(lines, "(empty)")
	end

	logFrame.text = tconcat(lines, "\n")
	logFrame:Show()
	logFrame.EditBox:SetText(logFrame.text)
	logFrame.EditBox:HighlightText()
	logFrame.EditBox:SetFocus()
end

-------------------------------------------------------------------------------
--  Slash command: /muidev
-------------------------------------------------------------------------------
local function PrintUsage()
	WF.PrintGradientLine()
	F.Print("/muidev")
	print("log                  open the log window (copy & paste it)")
	print("clear                clear the log")
	print("level [0-4|name]     show/set log level: none, error, warning, info, debug")
	print("debug [channel|all]  toggle a debug channel, list channels without argument")
	print("dump <expression>    inspect a value, e.g. /muidev dump E.db.mui.bags")
	WF.PrintGradientLine()
end

local function PrintChannels()
	local config = GetConfig()
	local names = {}
	for key, name in pairs(knownChannels) do
		local active = config and (config.channels.all or config.channels[key])
		tinsert(names, active and ("|cff00ff00" .. name .. "|r") or name)
	end
	sort(names)

	F.Print("Debug channels (green = active):", #names > 0 and tconcat(names, ", ") or "none")
	if config and config.channels.all then
		F.Print("Channel |cff00ff00all|r is active")
	end
end

local commands = {}

function commands.log()
	F.Developer.ShowLog()
end

function commands.clear()
	wipe(buffer)
	F.Print("Log cleared")
end

function commands.level(arg)
	local config = GetConfig()
	if arg and config then
		local level = tonumber(arg) or LOG_LEVEL[strupper(arg)]
		if not level or level < LOG_LEVEL.NONE or level > LOG_LEVEL.DEBUG then
			F.Print("Invalid log level:", arg)
			return
		end
		config.logLevel = level
	end

	local level = F.Developer.GetLogLevel()
	F.Print(format("Log level: %d (%s)", level, LEVEL_NAMES[level] or "none"))
end

function commands.debug(arg)
	if not arg then
		PrintChannels()
		return
	end

	local enabled = F.Developer.SetDebugChannel(arg)
	F.Print(format("Debug channel |cffffbf00%s|r %s", arg, enabled and "|cff00ff00on|r" or "|cffff2457off|r"))
end

function commands.dump(arg)
	if not arg then
		PrintUsage()
		return
	end

	local func, err = loadstring("return " .. arg)
	if not func then
		F.Print("|cffff2457" .. err .. "|r")
		return
	end

	local ok, result = pcall(func)
	if not ok then
		F.Print("|cffff2457" .. tostring(result) .. "|r")
		return
	end

	F.Developer.Dump(result, arg)
end

function F.Developer.HandleCommand(msg)
	local command, arg = strmatch(msg or "", "^%s*(%S*)%s*(.-)%s*$")
	local handler = commands[strlower(command or "")]

	if handler then
		handler(arg ~= "" and arg or nil)
	else
		PrintUsage()
	end
end
