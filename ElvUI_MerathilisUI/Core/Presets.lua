local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local D = E:GetModule("Distributor")
local PF = MER:GetModule("MER_Profiles")

local format, gsub, strmatch, strsplit, strsub, strtrim = format, gsub, strmatch, strsplit, strsub, strtrim
local ipairs, tinsert, tonumber, tostring, type, xpcall = ipairs, tinsert, tonumber, tostring, type, xpcall
local abs, floor, time = math.abs, math.floor, time
local pairs = pairs

local GetPhysicalScreenSize = GetPhysicalScreenSize
local C_UI_Reload = C_UI.Reload

-- Preset codes: "!MUI1!" + Base64(Deflate(CBOR(payload))), the payload is
--   { v = 1, kind = "preset", meta = {...}, profile = {...}, private = {...} }
-- with profile/private as ElvUI exports them (only values that differ from the defaults),
-- or a reference to a preset that ships with the addon:
--   { v = 1, kind = "builtin", key = "healer" }
-- The website decodes the same format to validate uploads, keep both in sync.
local PREFIX = "!MUI1!"
local FORMAT_VERSION = 1

F.Presets = {}

local builtins, builtinOrder = {}, {}

local function ClientName()
	return E.Forever and "forever" or "retail"
end

-- Display versions ("7.40", "7.40-beta-2") compared by their number
local function VersionNumber(version)
	return tonumber(strmatch(tostring(version or ""), "^%d+%.?%d*")) or 0
end

---@class BuiltinPreset
---@field key string
---@field name string
---@field desc string?
---@field base string installer layout it starts from, "gradient" or "dark"
---@field preview string? image path
---@field previewCoords number[]? tex coords of the preview
---@field apply function? writes the preset's own changes on top of the layout
---@field cooldownManagerScale number? icon scale of SkironCooldownManager, for presets with other action bar widths

---Register a preset that ships with the addon
---@param def BuiltinPreset
function F.Presets.Register(def)
	if builtins[def.key] then
		return
	end

	builtins[def.key] = def
	tinsert(builtinOrder, def)
end

---@return table[] builtins in registration order
function F.Presets.GetBuiltins()
	return builtinOrder
end

---@param key string
---@return string code
function F.Presets.GetBuiltinCode(key)
	return F.Presets.Encode({ v = FORMAT_VERSION, kind = "builtin", key = key })
end

---@param payload table
---@return string
function F.Presets.Encode(payload)
	return PREFIX .. F.Profiles.GenerateString(payload)
end

---Decode and validate a preset code
---@param code string
---@return table? data
---@return string? err
function F.Presets.Decode(code)
	if type(code) ~= "string" then
		return nil, L["This is not a MerathilisUI preset code."]
	end

	-- Codes copied from a website or chat can carry line breaks and spaces
	code = gsub(code, "%s", "")

	if strsub(code, 1, #PREFIX) ~= PREFIX then
		if strmatch(code, "^!E%d!") then
			return nil, L["This is an ElvUI profile string. Import it in the ElvUI profile options."]
		end

		return nil, L["This is not a MerathilisUI preset code."]
	end

	local data = F.Profiles.ExtractString(strsub(code, #PREFIX + 1))
	if not data or type(data.v) ~= "number" then
		return nil, L["The preset code is damaged. Copy it again, completely."]
	end

	if data.v > FORMAT_VERSION then
		return nil, L["This preset needs a newer version of MerathilisUI."]
	end

	if data.kind == "builtin" then
		local def = builtins[data.key]
		if not def then
			return nil, L["This preset is not included in your version of MerathilisUI. Please update the addon."]
		end

		data.meta = { name = def.name, author = MER.Title, desc = def.desc, client = ClientName() }
	elseif data.kind == "preset" then
		if type(data.profile) ~= "table" or type(data.private) ~= "table" then
			return nil, L["The preset code is damaged. Copy it again, completely."]
		end

		-- The texts end up in profile names and the preview, codes from elsewhere may lack them
		local meta = type(data.meta) == "table" and data.meta or {}
		for _, key in ipairs({ "name", "author", "desc" }) do
			meta[key] = type(meta[key]) == "string" and strtrim(meta[key]) or ""
		end
		meta.name = strsub(meta.name, 1, 64)
		data.meta = meta
	else
		return nil, L["This is not a MerathilisUI preset code."]
	end

	return data
end

---Hints for the import preview, the preset is applied anyway
---@param data table decoded preset
---@return string[]
function F.Presets.GetWarnings(data)
	local warnings = {}
	local meta = data.meta
	if data.kind ~= "preset" then
		return warnings
	end

	if meta.client and meta.client ~= ClientName() then
		tinsert(
			warnings,
			meta.client == "forever" and L["Made for WoW Forever, some settings might not fit Retail."]
				or L["Made for Retail, some settings might not fit WoW Forever."]
		)
	end

	if VersionNumber(meta.mer) > VersionNumber(MER.Version) then
		tinsert(
			warnings,
			format(L["Made with MerathilisUI %s, update the addon to get all of its settings."], meta.mer)
		)
	end

	local width, height = GetPhysicalScreenSize()
	if
		type(meta.width) == "number"
		and type(meta.height) == "number"
		and (abs(meta.width - width) > 100 or abs(meta.height - height) > 100)
	then
		tinsert(
			warnings,
			format(
				L["Made for a %dx%d screen, a few positions might need adjusting at %dx%d."],
				meta.width,
				meta.height,
				width,
				height
			)
		)
	end

	return warnings
end

---Export the active ElvUI profile and the private settings of this character
---@param name string
---@param author string?
---@param desc string?
---@return string? code
function F.Presets.Export(name, author, desc)
	local _, profile = D:GetProfileData("profile", E.data:GetCurrentProfile())
	local _, private = D:GetProfileData("private")
	if type(profile) ~= "table" or type(private) ~= "table" then
		return
	end

	local width, height = GetPhysicalScreenSize()

	return F.Presets.Encode({
		v = FORMAT_VERSION,
		kind = "preset",
		meta = {
			name = strtrim(name or ""),
			author = strtrim(author or ""),
			desc = strtrim(desc or ""),
			client = ClientName(),
			mer = MER.DisplayVersion,
			elvui = tostring(E.version),
			width = width,
			height = height,
			created = time(),
		},
		profile = profile,
		private = private,
	})
end

-- A profile name that does not exist yet: "Name", "Name (2)", ...
local function UniqueName(profiles, name)
	if not profiles[name] then
		return name
	end

	local i = 2
	while profiles[format("%s (%d)", name, i)] do
		i = i + 1
	end

	return format("%s (%d)", name, i)
end

-- Keeps the current private settings as a private profile the player can switch back to
local function BackupPrivate()
	local key = E.charSettings:GetCurrentProfile()
	local _, private = D:GetProfileData("private")
	if not key or type(private) ~= "table" then
		return
	end

	local name = UniqueName(E.charSettings.sv.profiles, format("%s (%s)", key, L["Backup"]))
	E.charSettings.sv.profiles[name] = private

	return name
end

local function SetProfile(name)
	if E.data:IsDualSpecEnabled() then
		E.data:SetDualSpecProfile(name)
	else
		E.data:SetProfile(name)
	end
end

local function GetSubTable(tbl, ...)
	for _, key in ipairs({ ... }) do
		if type(tbl[key]) ~= "table" then
			tbl[key] = {}
		end
		tbl = tbl[key]
	end

	return tbl
end

-- Neither ElvUI's nor our installer should open on the imported profile
local function MarkInstalled(profile, private)
	local core = GetSubTable(profile, "mui", "core")
	core.installed = true
	core.lastLayoutVersion = core.lastLayoutVersion or MER.DisplayVersion

	private.install_complete = E.version
	GetSubTable(private, "mui", "general").install_complete = MER.Version
	if not E.global.mui.changelogRead then
		E.global.mui.changelogRead = MER.Version
	end
end

-- Same way ElvUI imports a profile string (Distributor SetImportedProfile): the data
-- goes straight into the saved variables and the reload loads it
local function ApplyPreset(data)
	local profile = E:FilterTableFromBlacklist(E:CopyTable({}, data.profile), D.blacklistedKeys.profile)
	local private = E:FilterTableFromBlacklist(E:CopyTable({}, data.private), D.blacklistedKeys.private)
	MarkInstalled(profile, private)

	local name = UniqueName(E.data.sv.profiles, data.meta.name ~= "" and data.meta.name or L["Preset"])

	BackupPrivate()
	E.charSettings.sv.profiles[E.charSettings:GetCurrentProfile()] = private
	E.data.sv.profiles[name] = profile
	SetProfile(name)

	C_UI_Reload()
end

-- Mover strings are "point,parent,relativePoint,x,y"
local function MoverPosition(mover)
	local position = E.db.movers[mover]
	if not position then
		return
	end

	local point, parent, relativePoint, x, y = strsplit(",", position)
	x, y = tonumber(x), tonumber(y)
	if x and y then
		return point, parent, relativePoint, x, y
	end
end

---Move a mover by an offset, positive is right and up
---@param mover string
---@param xOffset number
---@param yOffset number
function F.Presets.ShiftMover(mover, xOffset, yOffset)
	local point, parent, relativePoint, x, y = MoverPosition(mover)
	if point then
		E.db.movers[mover] = format("%s,%s,%s,%d,%d", point, parent, relativePoint, x + xOffset, y + yOffset)
	end
end

-- SkironCooldownManager keeps its own profiles, independent of ElvUI's. A scaled preset gets a
-- copy of the current one, so the spells set up there stay; the suffix finds the original again.
local COOLDOWN_MANAGER_SUFFIX = " (Compact)"

local function ScaleRows(tbl, scale)
	for key, value in pairs(tbl) do
		if type(value) == "table" then
			if key == "rowConfig" then
				for _, row in ipairs(value) do
					if type(row) == "table" and type(row.iconWidth) == "number" then
						row.iconWidth = floor(row.iconWidth * scale + 0.5)
						row.iconHeight = type(row.iconHeight) == "number" and floor(row.iconHeight * scale + 0.5)
							or row.iconHeight
					end
				end
			else
				ScaleRows(value, scale)
			end
		end
	end
end

---Scale the icons of SkironCooldownManager for this character, 1 switches back to the unscaled profile
---@param scale number
function F.Presets.ScaleCooldownManager(scale)
	local db = _G.SkironCooldownManagerDB
	if type(db) ~= "table" or type(db.profiles) ~= "table" or type(db.profileKeys) ~= "table" then
		return
	end

	local current = db.profileKeys[E.mynameRealm] or "Default"
	local base = strsub(current, -#COOLDOWN_MANAGER_SUFFIX) == COOLDOWN_MANAGER_SUFFIX
			and strsub(current, 1, -#COOLDOWN_MANAGER_SUFFIX - 1)
		or current
	if not db.profiles[base] then
		return
	end

	if scale == 1 then
		db.profileKeys[E.mynameRealm] = base
		return
	end

	local name = base .. COOLDOWN_MANAGER_SUFFIX
	local profile = E:CopyTable({}, db.profiles[base])
	ScaleRows(profile, scale)

	-- Read at the next login, the presets reload right after
	db.profiles[name] = profile
	db.profileKeys[E.mynameRealm] = name
end

-- A fresh profile with the MerathilisUI layout and the preset's own changes on top,
-- so the shipped presets follow every layout update
local function ApplyBuiltin(def)
	BackupPrivate()
	SetProfile(UniqueName(E.data.sv.profiles, "MerathilisUI " .. def.name))

	-- The modules keep references into the old profile, whose defaults AceDB just removed;
	-- the layout below runs hooks of these modules, so they have to point at the new one first
	MER:UpdateProfiles()

	local ok = xpcall(function()
		MER:ApplyLayoutBase(def.base)

		-- These ElvUI plugins keep their settings in the ElvUI profile, so the new profile
		-- needs their MerathilisUI setup too; both skip themselves when the plugin is missing
		PF:LoadWindToolsProfile()
		PF:LoadmMediaTagProfile()

		if def.apply then
			def.apply()
		end

		F.Presets.ScaleCooldownManager(def.cooldownManagerScale or 1)
	end, geterrorhandler())

	if not ok then
		F.Print(F.String.Error(L["The preset could not be applied completely."]))
		return
	end

	E.db.mui.core.installed = true
	E.private.install_complete = E.version
	E.private.mui.general.install_complete = MER.Version
	if not E.global.mui.changelogRead then
		E.global.mui.changelogRead = MER.Version
	end

	C_UI_Reload()
end

---Apply a decoded preset in a new profile and reload the UI
---@param data table from F.Presets.Decode
function F.Presets.Apply(data)
	if data.kind == "builtin" then
		ApplyBuiltin(builtins[data.key])
	else
		ApplyPreset(data)
	end
end
