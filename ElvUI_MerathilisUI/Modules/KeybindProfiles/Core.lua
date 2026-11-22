local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_KeybindProfiles") ---@class KeybindProfiles

-- Keybind Profiles: the game keeps key bindings on the server, either one set for the
-- whole account or one per character. This module stores snapshots of them account wide
-- (E.global), so a profile can be put on any character, new characters can get the
-- profile of their class on their first login, and a profile travels between Retail,
-- WoW Forever and other accounts as a text code.
--
-- A profile is { bindings = { [command] = { key1, key2, ... } }, count, class, source,
-- client, saved }. Commands are the actions of the key bindings list (Blizzard's own,
-- ElvUI's action bars and every addon's Bindings.xml) plus CLICK/SPELL/MACRO/ITEM
-- bindings found by trying the common keys, those have no list entry to ask.
-- Applying a profile writes it as character specific bindings by default, so the
-- account set of the other characters stays as it is.

local _G = _G
local format, gsub, ipairs, next, pairs, select, sort, strchar, strsub, strtrim =
	format, gsub, ipairs, next, pairs, select, sort, strchar, strsub, strtrim
local tconcat, tinsert, tostring, type, time = table.concat, tinsert, tostring, type, time

local GetBinding = GetBinding
local GetBindingAction = GetBindingAction
local GetBindingKey = GetBindingKey
local GetCurrentBindingSet = GetCurrentBindingSet
local GetNumBindings = GetNumBindings
local InCombatLockdown = InCombatLockdown
local LoadBindings = LoadBindings
local SaveBindings = SaveBindings
local SetBinding = SetBinding
local GetBindingContextForAction = C_KeyBindings and C_KeyBindings.GetBindingContextForAction

local ACCOUNT_SET = Enum.BindingSet.Account
local CHARACTER_SET = Enum.BindingSet.Character

local PREFIX = "!MUIK1!"
local FORMAT_VERSION = 1
local NAME_MAX_LENGTH = 40

-- "ALL" in classProfiles is the profile for classes without their own
module.ALL_CLASSES = "ALL"

-- Keys tried for bindings that are not in the key bindings list (CLICK, SPELL, MACRO, ITEM).
-- Modifiers in the order the game writes them.
local MODIFIERS = {
	"",
	"SHIFT-",
	"CTRL-",
	"ALT-",
	"CTRL-SHIFT-",
	"ALT-SHIFT-",
	"ALT-CTRL-",
	"ALT-CTRL-SHIFT-",
}

local SCAN_KEYS = {}
do
	for byte = 65, 90 do -- A-Z
		tinsert(SCAN_KEYS, strchar(byte))
	end
	for i = 0, 9 do
		tinsert(SCAN_KEYS, tostring(i))
		tinsert(SCAN_KEYS, "NUMPAD" .. i)
	end
	for i = 1, 12 do
		tinsert(SCAN_KEYS, "F" .. i)
	end
	for i = 1, 31 do
		tinsert(SCAN_KEYS, "BUTTON" .. i)
	end

	local others = {
		"MOUSEWHEELUP",
		"MOUSEWHEELDOWN",
		"NUMPADDECIMAL",
		"NUMPADDIVIDE",
		"NUMPADMULTIPLY",
		"NUMPADMINUS",
		"NUMPADPLUS",
		"ENTER",
		"SPACE",
		"TAB",
		"ESCAPE",
		"BACKSPACE",
		"INSERT",
		"DELETE",
		"HOME",
		"END",
		"PAGEUP",
		"PAGEDOWN",
		"UP",
		"DOWN",
		"LEFT",
		"RIGHT",
		"CAPSLOCK",
		"`",
		"-",
		"=",
		"[",
		"]",
		"\\",
		";",
		"'",
		",",
		".",
		"/",
	}
	for _, key in ipairs(others) do
		tinsert(SCAN_KEYS, key)
	end
end

local function ClientName()
	return E.Forever and "forever" or "retail"
end

local function ContextFor(command)
	return GetBindingContextForAction and GetBindingContextForAction(command) or nil
end

local function RefreshOptions()
	E.Libs.AceConfigRegistry:NotifyChange("ElvUI")
end

local function AddKey(keys, key)
	for _, known in ipairs(keys) do
		if known == key then
			return false
		end
	end

	tinsert(keys, key)
	return true
end

---@return table? keys every key of GetBindingKey, nil when there is none
---@return number count
local function PackKeys(...)
	local keys, count
	for i = 1, select("#", ...) do
		local key = select(i, ...)
		if key and key ~= "" then
			keys = keys or {}
			if AddKey(keys, key) then
				count = (count or 0) + 1
			end
		end
	end

	return keys, count or 0
end

---@return table bindings [command] = { keys }
---@return number count bound keys
local function CollectBindings()
	local bindings, listed, count = {}, {}, 0

	for index = 1, GetNumBindings() do
		local command = GetBinding(index)
		if command and command ~= "" then
			listed[command] = true

			local keys, added = PackKeys(GetBindingKey(command, nil, ContextFor(command)))
			if keys then
				count = count + added
				bindings[command] = keys
			end
		end
	end

	for _, modifier in ipairs(MODIFIERS) do
		for _, base in ipairs(SCAN_KEYS) do
			local key = modifier .. base
			local command = GetBindingAction(key)
			if command and command ~= "" and not listed[command] then
				local keys = bindings[command]
				if not keys then
					keys = {}
					bindings[command] = keys
				end
				if AddKey(keys, key) then
					count = count + 1
				end
			end
		end
	end

	return bindings, count
end

-- Unbinds every key of the snapshot, then binds the keys of the profile
---@param current table
---@param bindings table
---@return number applied
---@return number skipped
local function WriteBindings(current, bindings)
	for command, keys in pairs(current) do
		local context = ContextFor(command)
		for _, key in ipairs(keys) do
			SetBinding(key, nil, context)
		end
	end

	local applied, skipped = 0, 0
	for command, keys in pairs(bindings) do
		local context = ContextFor(command)
		for _, key in ipairs(keys) do
			if SetBinding(key, command, context) then
				applied = applied + 1
			else
				skipped = skipped + 1
			end
		end
	end

	return applied, skipped
end

--[[----------------------------------
--	Combat queue
--]]
----------------------------------
-- Bindings can't change in combat, the last request waits for its end
function module:RunOutOfCombat(func)
	if not InCombatLockdown() then
		func()
		return
	end

	self.pending = func
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	F.Print(L["Key bindings can't change in combat, the keybind profile is applied when combat ends."])
end

function module:PLAYER_REGEN_ENABLED()
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")

	local func = self.pending
	self.pending = nil
	if func then
		func()
	end
end

--[[----------------------------------
--	Profiles
--]]
----------------------------------
---@return string[] names sorted profile names
function module:GetProfileNames()
	local names = {}
	for name in pairs(self.db.profiles) do
		tinsert(names, name)
	end
	sort(names)

	return names
end

---Stores the key bindings of the current character
---@param name string
function module:SaveProfile(name)
	local bindings, count = CollectBindings()

	self.db.profiles[name] = {
		bindings = bindings,
		count = count,
		class = E.myclass,
		source = E.myname .. " - " .. E.myrealm,
		client = ClientName(),
		saved = time(),
	}

	RefreshOptions()
	F.Print(
		format(L["Keybind profile %s saved with %d |4key binding:key bindings;."], F.String.MERATHILISUI(name), count)
	)
end

---Puts a profile on the current character. The bindings it had before are kept for Undo.
---@param name string
---@param asCharacter boolean? write character specific bindings, default from the settings
---@return boolean found
function module:ApplyProfile(name, asCharacter)
	local profile = self.db.profiles[name]
	if not profile then
		F.Print(format(L["There is no keybind profile called %s."], F.String.MERATHILISUI(name)))
		return false
	end

	if asCharacter == nil then
		asCharacter = self.db.applyAs == "CHARACTER"
	end

	self:RunOutOfCombat(function()
		local current = CollectBindings()
		E.private.mui.keybindProfiles.backup = { bindings = current, set = GetCurrentBindingSet() }

		-- Switch to character bindings the way the game's own checkbox does it,
		-- the character set starts as a copy of the account set
		if asCharacter and GetCurrentBindingSet() ~= CHARACTER_SET then
			SaveBindings(ACCOUNT_SET)
			LoadBindings(CHARACTER_SET)
			current = CollectBindings()
		end

		local applied, skipped = WriteBindings(current, profile.bindings)
		SaveBindings(asCharacter and CHARACTER_SET or GetCurrentBindingSet())

		RefreshOptions()
		F.Print(
			format(
				L["Keybind profile %s applied, %d |4key binding:key bindings; set."],
				F.String.MERATHILISUI(name),
				applied
			)
		)
		if skipped > 0 then
			F.Print(
				format(
					L["%d of them were skipped, their action does not exist here (an addon that is not loaded or another game version)."],
					skipped
				)
			)
		end
	end)

	return true
end

---@return boolean
function module:HasBackup()
	return E.private.mui.keybindProfiles.backup ~= nil
end

---Restores the key bindings from before the last applied profile
function module:Undo()
	local backup = E.private.mui.keybindProfiles.backup
	if not backup then
		return
	end

	self:RunOutOfCombat(function()
		if backup.set == ACCOUNT_SET and GetCurrentBindingSet() == CHARACTER_SET then
			-- The character used the account set before: go back to it, like the game's
			-- checkbox does, which drops the character specific bindings again
			LoadBindings(ACCOUNT_SET)
			SaveBindings(ACCOUNT_SET)
		else
			WriteBindings(CollectBindings(), backup.bindings)
			SaveBindings(GetCurrentBindingSet())
		end

		E.private.mui.keybindProfiles.backup = nil
		RefreshOptions()
		F.Print(L["Your key bindings from before the keybind profile are back."])
	end)
end

---@param oldName string
---@param newName string?
local function RenameReferences(oldName, newName)
	for class, name in pairs(module.db.classProfiles) do
		if name == oldName then
			module.db.classProfiles[class] = newName
		end
	end
end

---@param oldName string
---@param newName string
function module:RenameProfile(oldName, newName)
	local profiles = self.db.profiles
	if not profiles[oldName] or oldName == newName then
		return
	end

	profiles[newName] = profiles[oldName]
	profiles[oldName] = nil
	RenameReferences(oldName, newName)
	RefreshOptions()
end

---@param name string
function module:DeleteProfile(name)
	self.db.profiles[name] = nil
	RenameReferences(name, nil)
	RefreshOptions()
end

--[[----------------------------------
--	Export / Import
--	"!MUIK1!" + the same Base64(Deflate(CBOR)) as the preset codes, the payload is
--	{ v = 1, kind = "keybinds", name, client, bindings = { [command] = { keys } } }
--]]
----------------------------------
---@param name string
---@return string? code
function module:ExportProfile(name)
	local profile = self.db.profiles[name]
	if not profile then
		return
	end

	return PREFIX
		.. F.Profiles.GenerateString({
			v = FORMAT_VERSION,
			kind = "keybinds",
			name = name,
			client = profile.client,
			class = profile.class,
			bindings = profile.bindings,
		})
end

---@param code string
---@return table? data
---@return string? err
local function Decode(code)
	if type(code) ~= "string" then
		return nil, L["This is not a keybind profile code."]
	end

	code = gsub(code, "%s", "")
	if strsub(code, 1, #PREFIX) ~= PREFIX then
		return nil, L["This is not a keybind profile code."]
	end

	local data = F.Profiles.ExtractString(strsub(code, #PREFIX + 1))
	if
		type(data) ~= "table"
		or data.kind ~= "keybinds"
		or type(data.v) ~= "number"
		or type(data.bindings) ~= "table"
	then
		return nil, L["The keybind profile code is damaged. Copy it again, completely."]
	end

	if data.v > FORMAT_VERSION then
		return nil, L["This keybind profile code needs a newer version of MerathilisUI."]
	end

	-- Only strings make it in
	local bindings, count = {}, 0
	for command, keys in pairs(data.bindings) do
		if type(command) == "string" and command ~= "" and type(keys) == "table" then
			local clean = {}
			for _, key in ipairs(keys) do
				if type(key) == "string" and key ~= "" and AddKey(clean, key) then
					count = count + 1
				end
			end
			if next(clean) then
				bindings[command] = clean
			end
		end
	end

	local name = type(data.name) == "string" and strsub(strtrim(data.name), 1, NAME_MAX_LENGTH) or ""
	return {
		name = name ~= "" and name or L["Imported"],
		bindings = bindings,
		count = count,
		class = type(data.class) == "string" and data.class or nil,
		client = type(data.client) == "string" and data.client or nil,
	}
end

-- "Healer" -> "Healer (2)" when the name is taken
local function FreeName(profiles, name)
	if not profiles[name] then
		return name
	end

	local i = 2
	while profiles[format("%s (%d)", name, i)] do
		i = i + 1
	end

	return format("%s (%d)", name, i)
end

---@param code string
---@return boolean imported
function module:ImportProfile(code)
	local data, err = Decode(code)
	if not data then
		F.Print(err)
		return false
	end

	local name = FreeName(self.db.profiles, data.name)
	self.db.profiles[name] = {
		bindings = data.bindings,
		count = data.count,
		class = data.class,
		source = L["Imported"],
		client = data.client,
		saved = time(),
	}

	RefreshOptions()
	F.Print(
		format(
			L["Keybind profile %s imported with %d |4key binding:key bindings;."],
			F.String.MERATHILISUI(name),
			data.count
		)
	)

	return true
end

--[[----------------------------------
--	Popups
--]]
----------------------------------
-- Save As (no data.rename) or Rename (data.rename = old name)
local function AcceptProfileName(popup)
	local data = popup.data or {}
	local name = strtrim(popup.editBox:GetText() or "")
	if name == "" then
		return
	end

	if module.db.profiles[name] and name ~= data.rename then
		F.Print(format(L["There already is a keybind profile called %s."], F.String.MERATHILISUI(name)))
		return
	end

	if data.rename then
		module:RenameProfile(data.rename, name)
	else
		module:SaveProfile(name)
	end
end

E.PopupDialogs.MER_KEYBIND_PROFILE_NAME = {
	text = L["Name of the keybind profile:"],
	button1 = _G.ACCEPT,
	button2 = _G.CANCEL,
	hasEditBox = 1,
	maxLetters = NAME_MAX_LENGTH,
	OnShow = function(self, data)
		self.editBox:SetText(data and data.rename or "")
		self.editBox:HighlightText()
		self.editBox:SetFocus()
	end,
	OnAccept = AcceptProfileName,
	EditBoxOnEnterPressed = function(self)
		local popup = self:GetParent()
		AcceptProfileName(popup)
		popup:Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	preferredIndex = 3,
}

E.PopupDialogs.MER_KEYBIND_PROFILE_DELETE = {
	text = L["Delete the keybind profile %s?"],
	button1 = _G.DELETE,
	button2 = _G.CANCEL,
	OnAccept = function(_, name)
		module:DeleteProfile(name)
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	preferredIndex = 3,
}

E.PopupDialogs.MER_KEYBIND_PROFILE_IMPORT = {
	text = L["Paste a keybind profile code:"],
	button1 = L["Import"],
	button2 = _G.CANCEL,
	hasEditBox = 1,
	maxLetters = 0,
	editBoxWidth = 280,
	OnShow = function(self)
		self.editBox:SetText("")
		self.editBox:SetFocus()
	end,
	OnAccept = function(self)
		module:ImportProfile(self.editBox:GetText())
	end,
	EditBoxOnEnterPressed = function(self)
		local popup = self:GetParent()
		module:ImportProfile(popup.editBox:GetText())
		popup:Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	preferredIndex = 3,
}

-- Auto Apply: Yes applies, No leaves this character alone for good
E.PopupDialogs.MER_KEYBIND_PROFILE_AUTO = {
	text = L["Put the keybind profile %s on this character? It becomes the character specific key bindings of this character, other characters keep theirs."],
	button1 = _G.YES,
	button2 = _G.NO,
	OnAccept = function(_, name)
		E.private.mui.keybindProfiles.handled = true
		module:ApplyProfile(name, true)
	end,
	OnCancel = function()
		E.private.mui.keybindProfiles.handled = true
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	preferredIndex = 3,
}

function module:ShowSaveProfilePopup()
	E:StaticPopup_Show("MER_KEYBIND_PROFILE_NAME", nil, nil, {})
end

---@param name string
function module:ShowRenameProfilePopup(name)
	E:StaticPopup_Show("MER_KEYBIND_PROFILE_NAME", nil, nil, { rename = name })
end

---@param name string
function module:ShowDeleteProfilePopup(name)
	E:StaticPopup_Show("MER_KEYBIND_PROFILE_DELETE", name, nil, name)
end

function module:ShowImportPopup()
	E:StaticPopup_Show("MER_KEYBIND_PROFILE_IMPORT")
end

---@param name string
function module:ShowExportPopup(name)
	local code = self:ExportProfile(name)
	if code then
		-- MerathilisUI's read-only copy box (Core/Staticpopup.lua)
		E:StaticPopup_Show("MERATHILISUI_EditBox", nil, nil, code)
	end
end

--[[----------------------------------
--	Auto Apply
--]]
----------------------------------
---@return string? name profile for the class of this character
function module:GetClassProfile()
	local classProfiles = self.db.classProfiles
	local name = classProfiles[E.myclass] or classProfiles[module.ALL_CLASSES]
	if name and self.db.profiles[name] then
		return name
	end
end

-- Once per character: a character that never got a profile gets the one of its class.
-- Without a profile for the class nothing is marked, so assigning one later still
-- reaches the character on its next login.
function module:CheckAutoApply()
	local charDB = E.private.mui.keybindProfiles
	if not self.db.enable or not self.db.autoApply or charDB.handled then
		return
	end

	if self.db.skipCharacterSpecific and GetCurrentBindingSet() == CHARACTER_SET then
		charDB.handled = true
		return
	end

	local name = self:GetClassProfile()
	if not name then
		return
	end

	if self.db.askBeforeApply then
		E:StaticPopup_Show("MER_KEYBIND_PROFILE_AUTO", F.String.MERATHILISUI(name), nil, name)
	else
		charDB.handled = true
		self:ApplyProfile(name, true)
	end
end

function module:Initialize()
	self.db = E.global.mui.keybindProfiles
	if not self.db.enable then
		return
	end

	F.Event.RegisterOnceCallback("MER.InitializedSafe", function()
		-- Bindings are loaded at login, the delay keeps the popup clear of the login burst
		E:Delay(2, function()
			self:CheckAutoApply()
		end)
	end)
end

MER:AddCommand("KEYBINDPROFILES", { "/muikeys" }, function(msg)
	if not module.db.enable then
		F.Print(L["Keybind Profiles are off, turn them on in the options under Modules."])
		return
	end

	local name = strtrim(msg or "")
	if name ~= "" then
		module:ApplyProfile(name)
		return
	end

	local names = module:GetProfileNames()
	F.Print(L["Usage: /muikeys <profile> puts a keybind profile on this character."])
	F.Print(L["Keybind Profiles"] .. ": " .. (next(names) and tconcat(names, ", ") or L["No profiles yet"]))
end)

MER:RegisterModule(module:GetName())
