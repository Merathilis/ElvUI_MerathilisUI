local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

MER.Utilities.Color = {}
local U = MER.Utilities.Color

local abs = abs
local format = format
local strsub = strsub
local tonumber = tonumber
local tostring = tostring
local type = type

local CreateColor = CreateColor

local function isAlmost(a, b)
	if a == nil and b ~= nil or a ~= nil and b == nil then
		return false
	end

	if a == nil and b == nil then
		return true
	end

	return abs(a - b) < 0.1
end

local colors = {
	greyLight = "b5b5b5",
	primary = "00d1b2",
	success = "48c774",
	link = "3273dc",
	info = "209cee",
	danger = "ff3860",
	warning = "ffdd57",
}

function U.CreateColorFromTable(colorTable)
	return CreateColor(colorTable.r, colorTable.g, colorTable.b, colorTable.a)
end

function U.RGBFromTemplate(template)
	return U.HexToRGB(colors[template])
end

function U.ExtractColorFromTable(colorTable, override)
	local r = override and override.r or colorTable.r or 1
	local g = override and override.g or colorTable.g or 1
	local b = override and override.b or colorTable.b or 1
	local a = override and override.a or colorTable.a or 1
	return r, g, b, a
end

function U.IsRGBEqual(c1, c2)
	return isAlmost(c1.r, c2.r) and isAlmost(c1.g, c2.g) and isAlmost(c1.b, c2.b)
end

function U.HexToRGB(hex)
	if strsub(hex, 1, 1) == "#" then
		hex = strsub(hex, 2)
	end
	local rhex, ghex, bhex = strsub(hex, 1, 2), strsub(hex, 3, 4), strsub(hex, 5, 6)
	return tonumber(rhex, 16) / 255, tonumber(ghex, 16) / 255, tonumber(bhex, 16) / 255
end

function U.HexRGB(r, g, b)
	if r then
		if type(r) == "table" then
			if r.r then
				r, g, b = r.r, r.g, r.b
			else
				r, g, b = unpack(r)
			end
		end
		return format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
	end
end

function U.RGBToHex(r, g, b)
	return format("%02x%02x%02x", r * 255, g * 255, b * 255)
end

function U.StringWithHex(text, color)
	return format("|cff%s%s|r", color, text)
end

function U.StringByTemplate(text, template)
	return U.StringWithHex(text, colors[template])
end

function U.StringWithRGB(text, r, g, b)
	if type(text) ~= "string" then
		text = tostring(text)
	end

	if type(r) == "table" then
		r, g, b = r.r, r.g, r.b
	end

	return U.StringWithHex(text, U.RGBToHex(r, g, b))
end
