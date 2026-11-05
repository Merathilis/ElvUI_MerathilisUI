local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_AddonManager") ---@class AddonManager

-- Addon profiles as text codes: "!MUIA1!" + the same Base64(Deflate(CBOR)) as the
-- preset codes, the payload is { v = 1, kind = "addons", name = "...", addons = { names } }.

local _G = _G
local format, gsub, ipairs, pairs, sort, strsub, strtrim, tinsert, type =
	format, gsub, ipairs, pairs, sort, strsub, strtrim, tinsert, type

local DoesAddOnExist = C_AddOns.DoesAddOnExist

local PREFIX = "!MUIA1!"
local FORMAT_VERSION = 1
local NAME_MAX_LENGTH = 40

---@param name string
---@return string? code
function module:ExportProfile(name)
	local profile = self.db.profiles[name]
	if not profile then
		return
	end

	local addons = {}
	for addon in pairs(profile) do
		tinsert(addons, addon)
	end
	sort(addons)

	return PREFIX .. F.Profiles.GenerateString({ v = FORMAT_VERSION, kind = "addons", name = name, addons = addons })
end

---@param code string
---@return table? data { name, addons }
---@return string? err
local function Decode(code)
	if type(code) ~= "string" then
		return nil, L["This is not an addon profile code."]
	end

	code = gsub(code, "%s", "")
	if strsub(code, 1, #PREFIX) ~= PREFIX then
		return nil, L["This is not an addon profile code."]
	end

	local data = F.Profiles.ExtractString(strsub(code, #PREFIX + 1))
	if type(data) ~= "table" or data.kind ~= "addons" or type(data.v) ~= "number" or type(data.addons) ~= "table" then
		return nil, L["The addon profile code is damaged. Copy it again, completely."]
	end

	if data.v > FORMAT_VERSION then
		return nil, L["This addon profile code needs a newer version of MerathilisUI."]
	end

	local addons = {}
	for _, addon in ipairs(data.addons) do
		if type(addon) == "string" and addon ~= "" then
			addons[addon] = true
		end
	end

	local name = type(data.name) == "string" and strsub(strtrim(data.name), 1, NAME_MAX_LENGTH) or ""
	return { name = name ~= "" and name or L["Imported"], addons = addons }
end

-- "Raid" -> "Raid (2)" when the name is taken
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

	local total, missing = 0, 0
	for addon in pairs(data.addons) do
		total = total + 1
		if not DoesAddOnExist(addon) then
			missing = missing + 1
		end
	end

	local name = FreeName(self.db.profiles, data.name)
	self.db.profiles[name] = data.addons
	self:OnProfilesChanged()

	F.Print(format(L["Addon profile %s imported with %d |4addon:addons;."], F.String.MERATHILISUI(name), total))
	if missing > 0 then
		F.Print(format(L["%d of them are not installed, they are skipped when the profile loads."], missing))
	end

	return true
end

E.PopupDialogs.MER_ADDON_PROFILE_IMPORT = {
	text = L["Paste an addon profile code:"],
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

function module:ShowImportPopup()
	E:StaticPopup_Show("MER_ADDON_PROFILE_IMPORT")
end

---@param name string
function module:ShowExportPopup(name)
	local code = self:ExportProfile(name)
	if code then
		-- MerathilisUI's read-only copy box (Core/Staticpopup.lua)
		E:StaticPopup_Show("MERATHILISUI_EditBox", nil, nil, code)
	end
end
