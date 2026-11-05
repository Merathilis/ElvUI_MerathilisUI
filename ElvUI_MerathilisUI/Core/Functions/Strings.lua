local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
F.String = {}

local error = error
local floor = math.floor
local max = math.max
local tonumber, tostring, type = tonumber, tostring, type
local char = string.char
local format = string.format
local gmatch = string.gmatch
local gsub = string.gsub
local strmatch = string.match
local strtrim = strtrim
local utf8len, utf8lower, utf8sub, utf8upper = string.utf8len, string.utf8lower, string.utf8sub, string.utf8upper
local concat = table.concat

function F.String.Color(msg, color)
	if type(color) == "string" then
		if #color == 8 then
			return "|c" .. color .. msg .. "|r"
		else
			return "|cff" .. color .. msg .. "|r"
		end
	else
		return "|cff" .. I.Strings.Colors[color] .. msg .. "|r"
	end
end

function F.String.HexToRGB(hex)
	local r, g, b, a = strmatch(hex, "^#?(%x%x)(%x%x)(%x%x)(%x?%x?)$")
	if not r then
		return 0, 0, 0, nil
	end
	return tonumber(r, 16) / 255,
		tonumber(g, 16) / 255,
		tonumber(b, 16) / 255,
		(a ~= "") and (tonumber(a, 16) / 255) or nil
end

function F.String.FastRGB(r, g, b)
	return format("%02x%02x%02x", r * 255, g * 255, b * 255)
end

function F.String.RGB(msg, colors)
	if colors.r then
		return F.String.Color(msg, F.String.FastRGB(colors.r, colors.g, colors.b))
	else
		return F.String.Color(msg, F.String.FastRGB(colors[1], colors[2], colors[3]))
	end
end

---"SOUL_SHARDS" -> "Soul Shards"
function F.String.LowercaseEnum(text)
	if type(text) ~= "string" then
		return text
	end

	text = gsub(gsub(strtrim(text), "_", " "), "(%a)([%w_']*)", function(first, rest)
		return utf8upper(first) .. utf8lower(rest)
	end)

	return text
end

function F.String.ColorFirstLetter(text)
	if type(text) ~= "string" then
		return text
	end

	return F.String.MERATHILISUI(utf8upper(utf8sub(text, 1, 1))) .. "|cfff5feff" .. utf8sub(text, 2) .. "|r"
end

-- Removes |T...|t textures and |A...|a atlases, keeps escaped || pipes
local function StripTexture(text)
	return (
		gsub(text, "(%s?)(|?)|[TA].-|[ta](%s?)", function(w, x, y)
			if x == "" then
				return (w ~= "" and w) or (y ~= "" and y) or ""
			end
		end)
	)
end

---Remove color codes (|cAARRGGBB, |cn<name>: and |r), other escapes stay intact
function F.String.StripColor(text)
	if type(text) ~= "string" then
		return text
	end

	text = gsub(text, "|c%x%x%x%x%x%x%x%x", "")
	text = gsub(text, "|cn[^:|]*:", "")
	text = gsub(text, "|r", "")

	return text
end

---Plain text: removes colors, textures, atlases and hyperlinks ([Item] stays)
function F.String.Strip(text)
	if type(text) ~= "string" then
		return text
	end

	text = gsub(text, "|H.-|h(.-)|h", "%1")
	return F.String.StripColor(StripTexture(text))
end

function F.String.Muted(msg)
	return F.String.Color(msg, I.Enum.Colors.MUTED)
end

---Abbreviate a name to initials plus its last word, e.g. "Lightweave Embroidery" -> "L. Embroidery"
function F.String.Abbreviate(text)
	if type(text) ~= "string" or E:IsSecretValue(text) or text == "" then
		return text
	end

	if strmatch(text, "^Rune") then
		-- DK runes: "Rune of the Fallen Crusader" -> "Fallen Crusader"
		text = gsub(gsub(text, ".* the ", ""), ".* of ", "")
	else
		-- Drop everything from " of " / " the " on
		text = gsub(gsub(text, " of (.*)", ""), " the (.*)", "")
	end

	local lastWord = strmatch(text, ".+%s(.+)$")
	if not lastWord then
		return text
	end

	-- Every word before the last one: capitalized words become "X. ",
	-- words containing digits keep only their digits ("+10" -> "10 "), the rest is dropped
	local letters = {}
	for word in gmatch(text, ".-%s") do
		word = gsub(word, "^[%s%p]*", "")

		if strmatch(word, "%d") then
			letters[#letters + 1] = gsub(word, "%D+", "") .. " "
		else
			local firstLetter = utf8sub(word, 1, 1)
			if firstLetter ~= utf8lower(firstLetter) then
				letters[#letters + 1] = firstLetter .. ". "
			end
		end
	end

	return concat(letters) .. lastWord
end

function F.String.FastGradient(text, r1, g1, b1, r2, g2, b2)
	local parts = {}
	local len = utf8len(text)
	local steps = max(len - 1, 1)
	local idx = 0
	local fastRGB = F.String.FastRGB
	local fastColorGradient = F.FastColorGradient

	for i = 1, len do
		local x = utf8sub(text, i, i)
		if strmatch(x, "%s") then
			parts[#parts + 1] = x
			idx = idx + 1
		else
			local relperc = idx / steps

			if not r2 then
				parts[#parts + 1] = "|cff" .. fastRGB(r1, g1, b1) .. x .. "|r"
			else
				local r, g, b = fastColorGradient(relperc, r1, g1, b1, r2, g2, b2)
				parts[#parts + 1] = "|cff" .. fastRGB(r, g, b) .. x .. "|r"
				idx = idx + 1
			end
		end
	end

	return concat(parts)
end

function F.String.FastGradientHex(text, h1, h2)
	local r2, g2, b2
	local r1, g1, b1 = F.String.HexToRGB(h1)

	if h2 then
		r2, g2, b2 = F.String.HexToRGB(h2)
	else
		local h, s, l = F.ConvertToHSL(r1, g1, b1)
		r1, g1, b1 = F.ConvertToRGB(F.ClampToHSL(h, s * 0.95, l * 1.2))
		r2, g2, b2 = F.ConvertToRGB(F.ClampToHSL(h, s * 1.35, l * 0.85))
	end

	return F.String.FastGradient(text, r1, g1, b1, r2, g2, b2)
end

function F.String.FastColorGradientHex(percentage, h1, h2)
	local r1, g1, b1 = F.String.HexToRGB(h1)
	local r2, g2, b2 = F.String.HexToRGB(h2)

	return F.FastColorGradient(percentage, r1, g1, b1, r2, g2, b2)
end

function F.String.GradientClass(text, class, reverse)
	if not text or text == "" then
		return
	end

	local unitClass = class or E.myclass

	if E.db and E.db.mui and E.db.mui.themes and E.db.mui.themes.gradientMode.classColorMap then
		local colorMap = E.db.mui.themes.gradientMode.classColorMap

		-- check if class is an actual valid class that we have gradients for, if not, fallback to player's class
		if not colorMap[1][unitClass] then
			unitClass = E.myclass
		end

		local left = colorMap[1][unitClass] -- Left (player UF)
		local right = colorMap[2][unitClass] -- Right (player UF)

		if left and left.r and right and right.r then
			if not reverse then
				return F.String.FastGradient(text, left.r, left.g, left.b, right.r, right.g, right.b)
			else
				return F.String.FastGradient(text, right.r, right.g, right.b, left.r, left.g, left.b)
			end
		else
			return text
		end
	else
		return text
	end
end

function F.String.Class(msg, class)
	local finalClass = class or E.myclass

	-- Classes that don't exist on the current client (e.g. Monk on Forever) have no color
	local color = E:ClassColor(finalClass, true)
	if not color then
		return msg
	end

	return F.String.Color(msg, F.String.FastRGB(color.r, color.g, color.b))
end

function F.String.MERATHILISUI(msg)
	return F.String.Color(msg, I.Enum.Colors.MER)
end

function F.String.Details(msg)
	if not msg or msg == "" then
		return F.String.Color(L["Details"], I.Enum.Colors.DETAILS)
	end

	return F.String.Color(msg, I.Enum.Colors.DETAILS)
end

function F.String.BigWigs(msg)
	if not msg or msg == "" then
		return F.String.Color(L["BigWigs"], I.Enum.Colors.BIGWIGS)
	end

	return F.String.Color(msg, I.Enum.Colors.BIGWIGS)
end

function F.String.ElvUI(msg)
	if not msg or msg == "" then
		return F.String.Color(L["ElvUI"], I.Enum.Colors.ELVUI)
	end

	return F.String.Color(msg, I.Enum.Colors.ELVUI)
end

function F.String.ElvUIValue(msg)
	return F.String.RGB(msg, E.media.rgbvaluecolor)
end

function F.String.Error(msg)
	return F.String.Color(msg, I.Enum.Colors.ERROR)
end

function F.String.Good(msg)
	return F.String.Color(msg, I.Enum.Colors.GOOD)
end

function F.String.Warning(msg)
	return F.String.Color(msg, I.Enum.Colors.WARNING)
end

function F.String.Epic(msg)
	return F.String.Color(msg, I.Enum.Colors.EPIC)
end

-- Credits to WunderUI
function F.String.ConvertGlyph(unicode)
	if unicode <= 0x7F then
		return char(unicode)
	end
	if unicode <= 0x7FF then
		return char(0xC0 + floor(unicode / 0x40), 0x80 + (unicode % 0x40))
	end
	if unicode <= 0xFFFF then
		return char(0xE0 + floor(unicode / 0x1000), 0x80 + (floor(unicode / 0x40) % 0x40), 0x80 + (unicode % 0x40))
	end
	error(L["Could not convert unicode "] .. tostring(unicode))
end
