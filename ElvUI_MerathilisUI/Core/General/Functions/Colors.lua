local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)

local _G = _G
local pairs, select, tonumber, unpack = pairs, select, tonumber, unpack
local abs = abs
local min = min
local format = format
local strsub = strsub

local CreateColor = CreateColor
local GetClassColor = GetClassColor
local UnitClass = UnitClass
local UnitIsPlayer = UnitIsPlayer
local UnitIsTapDenied = UnitIsTapDenied
local UnitReaction = UnitReaction

--[[----------------------------------
--	Color Functions
--]] ----------------------------------
F.ClassGradient = {
	["WARRIOR"] = { r1 = 0.60, g1 = 0.40, b1 = 0.20, r2 = 0.66, g2 = 0.53, b2 = 0.34 },
	["PALADIN"] = { r1 = 0.9, g1 = 0.47, b1 = 0.64, r2 = 0.96, g2 = 0.65, b2 = 0.83 },
	["HUNTER"] = { r1 = 0.58, g1 = 0.69, b1 = 0.29, r2 = 0.78, g2 = 1, b2 = 0.38 },
	["ROGUE"] = { r1 = 1, g1 = 0.68, b1 = 0, r2 = 1, g2 = 0.83, b2 = 0.25 },
	["PRIEST"] = { r1 = 0.65, g1 = 0.65, b1 = 0.65, r2 = 0.98, g2 = 0.98, b2 = 0.98 },
	["DEATHKNIGHT"] = { r1 = 0.79, g1 = 0.07, b1 = 0.14, r2 = 1, g2 = 0.18, b2 = 0.23 },
	["SHAMAN"] = { r1 = 0, g1 = 0.25, b1 = 0.50, r2 = 0, g2 = 0.43, b2 = 0.87 },
	["MAGE"] = { r1 = 0, g1 = 0.73, b1 = 0.83, r2 = 0.49, g2 = 0.87, b2 = 1 },
	["WARLOCK"] = { r1 = 0.50, g1 = 0.30, b1 = 0.70, r2 = 0.7, g2 = 0.53, b2 = 0.83 },
	["MONK"] = { r1 = 0, g1 = 0.77, b1 = 0.45, r2 = 0.22, g2 = 0.90, b2 = 1 },
	["DRUID"] = { r1 = 1, g1 = 0.23, b1 = 0.0, r2 = 1, g2 = 0.48, b2 = 0.03 },
	["DEMONHUNTER"] = { r1 = 0.36, g1 = 0.13, b1 = 0.57, r2 = 0.74, g2 = 0.19, b2 = 1 },
	["EVOKER"] = { r1 = 0.20, g1 = 0.58, b1 = 0.50, r2 = 0, g2 = 1, b2 = 0.60 },

	["NPCFRIENDLY"] = { r1 = 0.30, g1 = 0.85, b1 = 0.2, r2 = 0.34, g2 = 0.62, b2 = 0.40 },
	["NPCNEUTRAL"] = { r1 = 0.71, g1 = 0.63, b1 = 0.15, r2 = 1, g2 = 0.85, b2 = 0.20 },
	["NPCUNFRIENDLY"] = { r1 = 0.84, g1 = 0.30, b1 = 0, r2 = 0.83, g2 = 0.45, b2 = 0 },
	["NPCHOSTILE"] = { r1 = 1, g1 = 1, b1 = 1, r2 = 1, g2 = 0.090196078431373, b2 = 0 },

	["TAPPED"] = { r1 = 0.6, g1 = 0.6, b1 = 0.60, r2 = 0, g2 = 0, b2 = 0 },

	["GOODTHREAT"] = { r1 = 0.1999995559454, g1 = 0.7098023891449, b1 = 0, r2 = 1, g2 = 0, b2 = 0 },
	["BADTHREAT"] = { r1 = 0.99999779462814, g1 = 0.1764702051878, b1 = 0.1764702051878, r2 = 1, g2 = 0, b2 = 0 },
	["GOODTHREATTRANSITION"] = { r1 = 0.99999779462814, g1 = 0.85097849369049, b1 = 0.1999995559454, r2 = 1, g2 = 0, b2 = 0 },
	["BADTHREATTRANSITION"] = { r1 = 0.99999779462814, g1 = 0.50980281829834, b1 = 0.1999995559454, r2 = 1, g2 = 0, b2 = 0 },
	["OFFTANK"] = { r1 = 0.95686066150665, g1 = 0.54901838302612, b1 = 0.72941017150879, r2 = 1, g2 = 0, b2 = 0 },
	["OFFTANKBADTHREATTRANSITION"] = { r1 = 0.77646887302399, g1 = 0.60784178972244, b1 = 0.4274500310421, r2 = 1, g2 = 0, b2 = 0 },
	["OFFTANKGOODTHREATTRANSITION"] = { r1 = 0.37646887302399, g1 = 0.90784178972244, b1 = 0.9274500310421, r2 = 1, g2 = 0, b2 = 0 },

	["MANA"] = { r1 = 0.49, g1 = 0.71, b1 = 1, r2 = 0.29, g2 = 0.26, b2 = 1 },
	["RAGE"] = { r1 = 1, g1 = 0.32, b1 = 0.32, r2 = 1, g2 = 0, b2 = 0.13 },
	["FOCUS"] = { r1 = 1, g1 = 0.50, b1 = 0.25, r2 = 0.71, g2 = 0.22, b2 = 0.07 },
	["ENERGY"] = { r1 = 1, g1 = 0.97, b1 = 0.54, r2 = 1, g2 = 0.70, b2 = 0.07 },
	["RUNIC_POWER"] = { r1 = 0, g1 = 0.82, b1 = 1, r2 = 0, g2 = 0.40, b2 = 1 },
	["LUNAR_POWER"] = { r1 = 0.30, g1 = 0.52, b1 = 0.90, r2 = 0.12, g2 = 0.36, b2 = 0.90 },
	["ALT_POWER"] = { r1 = 0.2, g1 = 0.4, b1 = 0.8, r2 = 0.25, g2 = 0.51, b2 = 1 },
	["MAELSTROM"] = { r1 = 0, g1 = 0.50, b1 = 1, r2 = 0, g2 = 0.11, b2 = 1 },
	["INSANITY"] = { r1 = 0.50, g1 = 0.25, b1 = 1, r2 = 0.70, g2 = 0, b2 = 1 },
	["FURY"] = { r1 = 0.79, g1 = 0.26, b1 = 1, r2 = 1, g2 = 0, b2 = 0.95 },
	["PAIN"] = { r1 = 1, g1 = 0.61, b1 = 0, r2 = 1, g2 = 0.30, b2 = 0 },
}

do
	F.ClassList = {}
	for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_MALE) do
		F.ClassList[v] = k
	end
	for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_FEMALE) do
		F.ClassList[v] = k
	end
end

F.ClassColors = {}
local colors = _G.CUSTOM_CLASS_COLORS or _G.RAID_CLASS_COLORS
for class, value in pairs(colors) do
	F.ClassColors[class] = {}
	F.ClassColors[class].r = value.r
	F.ClassColors[class].g = value.g
	F.ClassColors[class].b = value.b
	F.ClassColors[class].colorStr = value.colorStr
end
F.r, F.g, F.b = F.ClassColors[E.myclass].r, F.ClassColors[E.myclass].g, F.ClassColors[E.myclass].b

function F.ClassColor(class)
	local color = F.ClassColors[class]
	if not color then
		return 1, 1, 1
	end

	return color.r, color.g, color.b
end

function F.UnitColor(unit)
	local r, g, b = 1, 1, 1
	if UnitIsPlayer(unit) then
		local class = select(2, UnitClass(unit))
		if class then
			r, g, b = F.ClassColor(class)
		end
	elseif UnitIsTapDenied(unit) then
		r, g, b = .6, .6, .6
	else
		local reaction = UnitReaction(unit, "player")
		if reaction then
			local color = _G.FACTION_BAR_COLORS[reaction]
			r, g, b = color.r, color.g, color.b
		end
	end

	return r, g, b
end

local defaultColor = { r = 1, g = 1, b = 1, a = 1 }
function F.unpackColor(color)
	if not color then color = defaultColor end

	return color.r, color.g, color.b, color.a
end

function F.CreateColorString(text, db)
	if not text or not type(text) == "string" then
		F.Developer.LogDebug("Functions.CreateColorString: text not found")
		return
	end

	if not db or type(db) ~= "table" then
		F.Developer.LogDebug("Functions.CreateColorString: db not found")
		return
	end
	local hex = db.r and db.g and db.b and E:RGBToHex(db.r, db.g, db.b) or "|cffffffff"

	return hex .. text .. "|r"
end

function F.CreateClassColorString(text, englishClass)
	if not text or not type(text) == "string" then
		F.Developer.LogDebug("Functions.CreateClassColorString: text not found")
		return
	end
	if not englishClass or type(englishClass) ~= "string" then
		F.Developer.LogDebug("Functions.CreateClassColorString: class not found")
		return
	end

	local r, g, b = GetClassColor(englishClass)
	local hex = r and g and b and E:RGBToHex(r, g, b) or "|cffffffff"

	return hex .. text .. "|r"
end

function F.GradientColors(unitclass, invert, alpha)
	if invert then
		if alpha then
			return F.ClassGradient[unitclass].r2, F.ClassGradient[unitclass].g2, F.ClassGradient[unitclass].b2, 1,
				F.ClassGradient[unitclass].r1, F.ClassGradient[unitclass].g1, F.ClassGradient[unitclass].b1, 1
		else
			return F.ClassGradient[unitclass].r2, F.ClassGradient[unitclass].g2, F.ClassGradient[unitclass].b2,
				F.ClassGradient[unitclass].r1, F.ClassGradient[unitclass].g1, F.ClassGradient[unitclass].b1
		end
	else
		if alpha then
			return F.ClassGradient[unitclass].r1, F.ClassGradient[unitclass].g1, F.ClassGradient[unitclass].b1, 1,
				F.ClassGradient[unitclass].r2, F.ClassGradient[unitclass].g2, F.ClassGradient[unitclass].b2, 1
		else
			return F.ClassGradient[unitclass].r1, F.ClassGradient[unitclass].g1, F.ClassGradient[unitclass].b1,
				F.ClassGradient[unitclass].r2, F.ClassGradient[unitclass].g2, F.ClassGradient[unitclass].b2
		end
	end
end

function F.GradientName(name, unitclass, isTarget)
	if not name then
		return
	end

	local color = F.ClassGradient[unitclass] or F.ClassGradient.MANA

	if not isTarget then
		return E:TextGradient(name, color.r2, color.g2, color.b2, color.r1, color.g1, color.b1)
	else
		return E:TextGradient(name, color.r1, color.g1, color.b1, color.r2, color.g2, color.b2)
	end
end

local colors = {
	greyLight = "b5b5b5",
	primary = "00d1b2",
	success = "48c774",
	link = "3273dc",
	info = "209cee",
	danger = "ff3860",
	warning = "ffdd57"
}

function F.CreateColorFromTable(colorTable)
	return CreateColor(colorTable.r, colorTable.g, colorTable.b, colorTable.a)
end

function F.RGBFromTemplate(template)
	return F.HexToRGB(colors[template])
end

function F.ExtractColorFromTable(colorTable, override)
	local r = override and override.r or colorTable.r or 1
	local g = override and override.g or colorTable.g or 1
	local b = override and override.b or colorTable.b or 1
	local a = override and override.a or colorTable.a or 1

	return r, g, b, a
end

function F.IsRGBEqual(color1, color2)
	return color1.r == color2.r and color1.g == color2.g and color1.b == color2.b
end

function F.HexToRGB(hex)
	local rhex, ghex, bhex = strsub(hex, 1, 2), strsub(hex, 3, 4), strsub(hex, 5, 6)
	return tonumber(rhex, 16) / 255, tonumber(ghex, 16) / 255, tonumber(bhex, 16) / 255
end

function F.RGBToHex(r, g, b)
	if r then
		if type(r) == "table" then
			if r.r then
				r, g, b = r.r, r.g, r.b
			else
				r, g, b = unpack(r)
			end
		end
		return format("%02x%02x%02x", r * 255, g * 255, b * 255)
	end
end

function F.StringWithHex(text, color)
	return format("|cff%s%s|r", color, text)
end

function F.StringByTemplate(text, template)
	return F.StringWithHex(text, colors[template])
end

function F.StringWithRGB(text, r, g, b)
	if type(text) ~= "string" then
		text = tostring(text)
	end

	if type(r) == "table" then
		r, g, b = r.r, r.g, r.b
	end

	return F.StringWithHex(text, F.RGBToHex(r, g, b))
end

local progressColor = {
	start = { r = 1.000, g = 0.647, b = 0.008 },
	complete = { r = 0.180, g = 0.835, b = 0.451 }
}

function F.GetProgressColor(progress)
	local r = (progressColor.complete.r - progressColor.start.r) * progress + progressColor.start.r
	local g = (progressColor.complete.g - progressColor.start.g) * progress + progressColor.start.g
	local b = (progressColor.complete.r - progressColor.start.b) * progress + progressColor.start.b

	-- algorithm to let the color brighter
	local addition = 0.35
	r = min(r + abs(0.5 - progress) * addition, r)
	g = min(g + abs(0.5 - progress) * addition, g)
	b = min(b + abs(0.5 - progress) * addition, b)

	return { r = r, g = g, b = b }
end
