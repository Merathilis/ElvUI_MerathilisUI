local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local floor, ipairs, pcall, type = math.floor, ipairs, pcall, type

local CreateFontFamily = CreateFontFamily
local CreateFrame = CreateFrame
local GetLocale = GetLocale

-------------------------------------------------------------------------------
--  Font families for text other players write (names, chat lines).
--
--  Most fonts in the media packs only carry Latin letters, so a Russian,
--  Korean or Chinese name shows as boxes. A font family has one member per
--  alphabet and the engine draws a whole string with the member that fits
--  its letters: Latin text keeps the chosen font, Cyrillic, Korean and Chinese
--  fall back to Blizzard's own faces for those scripts.
--
--  A plain SetFont pins a string's face, a later SetFontObject no longer
--  changes it. So a string that should use a family takes it from its first
--  font write on and every later write goes through F.SetFontFamily again,
--  never through SetFont or FontTemplate.
-------------------------------------------------------------------------------

local ALPHABETS = { "roman", "russian", "korean", "simplifiedchinese", "traditionalchinese" }

-- Blizzard's faces for the scripts the chosen font may lack
local FALLBACK_FILES = {
	russian = "Fonts\\FRIZQT___CYR.TTF",
	korean = "Fonts\\2002.TTF",
	simplifiedchinese = "Fonts\\ARKai_T.ttf",
	traditionalchinese = "Fonts\\bLEI00D.ttf",
}

-- On a client in one of those languages the chosen font is already the
-- client's own font for it, so that member keeps it
local CLIENT_ALPHABET = ({
	ruRU = "russian",
	koKR = "korean",
	zhCN = "simplifiedchinese",
	zhTW = "traditionalchinese",
})[GetLocale()]

-- path -> size -> flags -> shadow -> family, false when it could not be made
local families = {}
local count = 0
local probe

-- A file the client cannot load leaves SetFont returning false
local loads = {}
local function PathLoads(path)
	local hit = loads[path]
	if hit == nil then
		if not probe then
			local holder = CreateFrame("Frame")
			holder:Hide()
			probe = holder:CreateFontString()
		end
		local ok, loaded = pcall(probe.SetFont, probe, path, 12, "")
		hit = ok and loaded ~= false
		loads[path] = hit
	end
	return hit
end

local function SetShadow(object, shadow)
	object:SetShadowColor(0, 0, 0, shadow and 1 or 0)
	object:SetShadowOffset(shadow and 1 or 0, shadow and -1 or 0)
end

local function Build(path, size, flags, shadow)
	if not PathLoads(path) then
		path = E.media.normFont
	end

	local members = {}
	for i, alphabet in ipairs(ALPHABETS) do
		local file = path
		if alphabet ~= "roman" and alphabet ~= CLIENT_ALPHABET then
			file = FALLBACK_FILES[alphabet]
		end
		members[i] = { alphabet = alphabet, file = file, height = size, flags = flags }
	end

	count = count + 1
	local ok, family = pcall(CreateFontFamily, "MER_FontFamily" .. count, members)
	if not (ok and family) then
		return false
	end

	-- A drop shadow only renders from the font object
	SetShadow(family, shadow)
	for _, alphabet in ipairs(ALPHABETS) do
		local member = family.GetFontObjectForAlphabet and family:GetFontObjectForAlphabet(alphabet)
		if member then
			SetShadow(member, shadow)
		end
	end
	return family
end

---The font family for a font file, size, outline and shadow, built once per
---combination. nil when the client has no font families.
---@param path string
---@param size number
---@param flags string|nil "" or nil for no outline
---@param shadow boolean|nil
function F.GetFontFamily(path, size, flags, shadow)
	if type(CreateFontFamily) ~= "function" or type(path) ~= "string" or type(size) ~= "number" or size <= 0 then
		return
	end

	flags = flags or ""
	if flags == "NONE" then
		flags = ""
	end
	shadow = shadow and true or false
	-- Kept per quarter point, a font object is never freed
	size = floor(size * 4 + 0.5) / 4

	local bySize = families[path] or {}
	families[path] = bySize
	local byFlags = bySize[size] or {}
	bySize[size] = byFlags
	local byShadow = byFlags[flags] or {}
	byFlags[flags] = byShadow

	local family = byShadow[shadow]
	if family == nil then
		family = Build(path, size, flags, shadow)
		byShadow[shadow] = family
	end
	return family or nil
end

---Sets a font string's font as a font family, so names and text in Cyrillic,
---Korean or Chinese draw instead of showing boxes. Falls back to a plain
---SetFont where the client has no font families. Keeps the string's color and
---justification.
---@param fs FontString
---@param path string
---@param size number
---@param flags string|nil
---@param shadow boolean|nil without an outline a shadow is what ElvUI's texts use
function F.SetFontFamily(fs, path, size, flags, shadow)
	local family = F.GetFontFamily(path, size, flags, shadow)
	if not family then
		fs:SetFont(path, size, (flags and flags ~= "NONE") and flags or "")
		SetShadow(fs, shadow)
		return
	end

	if fs:GetFontObject() == family then
		return
	end

	local justifyH, justifyV = fs:GetJustifyH(), fs:GetJustifyV()
	local r, g, b, a = fs:GetTextColor()
	fs:SetFontObject(family)
	fs:SetJustifyH(justifyH)
	fs:SetJustifyV(justifyV)
	if not E:IsSecretValue(r) then
		fs:SetTextColor(r, g, b, a)
	end
end

---F.SetFontFamily from a font setting table { name, size, style } with ElvUI's
---font styles (NONE, OUTLINE, SHADOW, SHADOWOUTLINE, ...)
---@param fs FontString
---@param db table
function F.SetFontFamilyWithDB(fs, db)
	local path = E.LSM:Fetch("font", db.name) or E.media.normFont
	local style = db.style or "NONE"
	local shadow = style == "NONE" or style:find("SHADOW") ~= nil
	local flags = style:gsub("SHADOW", "")
	if flags:find("^MONOCHROME.") then
		flags = "MONOCHROME," .. flags:sub(11)
	end
	F.SetFontFamily(fs, path, db.size or 12, flags, shadow)
end
