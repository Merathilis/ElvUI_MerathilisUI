local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
F.Color = {}

local _G = _G
local pairs = pairs
local type = type

local CreateColor = CreateColor

local C_ClassColor_GetClassColor = C_ClassColor.GetClassColor
local C_StringUtil_WrapString = C_StringUtil.WrapString

--[[----------------------------------
--	Color Functions
--]]
----------------------------------
-- Two-color gradients per class and NPC reaction; MANA and MERATHILIS are fallbacks
local UnitframeGradients = {
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

	["MANA"] = { r1 = 0.49, g1 = 0.71, b1 = 1, r2 = 0.29, g2 = 0.26, b2 = 1 },
	["MERATHILIS"] = { r1 = 0.50, g1 = 0.70, b1 = 1, r2 = 0.67, g2 = 0.95, b2 = 1 },
}

-- Flat colors for names that can't get a gradient (instances, secret names)
local ClassColorReaction = {
	["WARRIOR"] = { r = 0.77646887302399, g = 0.60784178972244, b = 0.4274500310421 },
	["PALADIN"] = { r = 0.95686066150665, g = 0.54901838302612, b = 0.72941017150879 },
	["HUNTER"] = { r = 0.66666519641876, g = 0.82744914293289, b = 0.44705784320831 },
	["ROGUE"] = { r = 0.99999779462814, g = 0.95686066150665, b = 0.40784224867821 },
	["PRIEST"] = { r = 0.99999779462814, g = 0.99999779462814, b = 0.99999779462814 },
	["DEATHKNIGHT"] = { r = 0.76862573623657, g = 0.11764679849148, b = 0.2274504750967 },
	["SHAMAN"] = { r = 0, g = 0.4392147064209, b = 0.86666476726532 },
	["MAGE"] = { r = 0.24705828726292, g = 0.78039044141769, b = 0.92156660556793 },
	["WARLOCK"] = { r = 0.52941060066223, g = 0.53333216905594, b = 0.93333131074905 },
	["MONK"] = { r = 0, g = 0.99999779462814, b = 0.59607714414597 },
	["DRUID"] = { r = 0.99999779462814, g = 0.48627343773842, b = 0.039215601980686 },
	["DEMONHUNTER"] = { r = 0.63921427726746, g = 0.1882348805666, b = 0.78823357820511 },
	["EVOKER"] = { r = 0.19607843137255, g = 0.46666666666667, b = 0.53725490196078 },
	["NPCFRIENDLY"] = { r = 0.2, g = 1, b = 0.2 },
	["NPCNEUTRAL"] = { r = 0.89, g = 0.89, b = 0 },
	["NPCUNFRIENDLY"] = { r = 0.94, g = 0.37, b = 0 },
	["NPCHOSTILE"] = { r = 0.8, g = 0, b = 0 },
}

local classColors = {}
for class, value in pairs(_G.CUSTOM_CLASS_COLORS or _G.RAID_CLASS_COLORS) do
	classColors[class] = { r = value.r, g = value.g, b = value.b }
end
F.r, F.g, F.b = classColors[E.myclass].r, classColors[E.myclass].g, classColors[E.myclass].b

function F.ClassColor(class)
	local color = classColors[class]
	if not color then
		return 1, 1, 1
	end

	return color.r, color.g, color.b
end

---Two gradient colors for a class or NPC reaction key
---@param unitclass string
---@return table minColor, table maxColor
function F.GradientColors(unitclass)
	local color = UnitframeGradients[unitclass] or UnitframeGradients.MERATHILIS
	return { r = color.r1, g = color.g1, b = color.b1, a = 1 }, { r = color.r2, g = color.g2, b = color.b2, a = 1 }
end

-- Different for details because bars are different
function F.GradientColorsDetails(unitclass)
	local color = UnitframeGradients[unitclass] or UnitframeGradients.NPCNEUTRAL
	return { r = color.r1 - 0.2, g = color.g1 - 0.2, b = color.b1 - 0.2, a = 0.9 }, {
		r = color.r2 + 0.2,
		g = color.g2 + 0.2,
		b = color.b2 + 0.2,
		a = 0.9,
	}
end

---Flat color of a class or NPC reaction key, white when unknown
---@param unitclass string?
---@return number r, number g, number b
local function GetFlatColor(unitclass)
	if E:IsSecretValue(unitclass) then
		local classColor = C_ClassColor_GetClassColor(unitclass)
		if classColor then
			return classColor.r, classColor.g, classColor.b
		end
	elseif unitclass and ClassColorReaction[unitclass] then
		local color = ClassColorReaction[unitclass]
		return color.r, color.g, color.b
	end

	return 1, 1, 1
end

function F.GradientName(name, unitclass, isTarget, isUnit)
	if not name then
		return
	end

	if E:IsSecretValue(name) then
		-- name can't be read/concatenated (e.g. anonymized in Mythic+), so fall back to
		-- a flat class/reaction color wrapped around it via the secret-safe string API
		return C_StringUtil_WrapString(name, E:RGBToHex(GetFlatColor(unitclass)), "|r")
	end

	if not F.IsThisASafeSecret() and isUnit then
		return E:RGBToHex(GetFlatColor(unitclass)) .. name
	end

	local color = UnitframeGradients[unitclass] or UnitframeGradients.MANA
	if not isTarget then
		return E:TextGradient(name, color.r2, color.g2, color.b2, color.r1, color.g1, color.b1)
	else
		return E:TextGradient(name, color.r1, color.g1, color.b1, color.r2, color.g2, color.b2)
	end
end

function F.Color.EqualToRGB(aColor, r, g, b)
	return F.AlmostEqual(aColor.r, r) and F.AlmostEqual(aColor.g, g) and F.AlmostEqual(aColor.b, b)
end

-- SetGradient copies the values right away, so two shared colors serve every call. It runs on
-- each health/power update of the gradient theme, a new color per call would be garbage.
local gradientMin, gradientMax = CreateColor(0, 0, 0, 1), CreateColor(0, 0, 0, 1)

function F.Color.SetGradient(obj, orientation, minColor, maxColor)
	if not obj then
		return
	end

	if not minColor.r or not minColor.g or not minColor.b then
		return
	end
	if not maxColor.r or not maxColor.g or not maxColor.b then
		return
	end

	gradientMin:SetRGBA(minColor.r, minColor.g, minColor.b, minColor.a or 1)
	gradientMax:SetRGBA(maxColor.r, maxColor.g, maxColor.b, maxColor.a or 1)
	obj:SetGradient(orientation, gradientMin, gradientMax)
end

function F.Color.SetGradientRGB(obj, orientation, r1, g1, b1, a1, r2, g2, b2, a2)
	if not obj or not r1 or not g1 or not b1 or not r2 or not g2 or not b2 then
		return
	end

	gradientMin:SetRGBA(r1, g1, b1, a1 or 1)
	gradientMax:SetRGBA(r2, g2, b2, a2 or 1)
	obj:SetGradient(orientation, gradientMin, gradientMax)
end

function F.Color.UpdateGradient(obj, perc, minColor, maxColor)
	if not obj then
		return
	end

	if not minColor.r or not minColor.g or not minColor.b then
		return
	end
	if not maxColor.r or not maxColor.g or not maxColor.b then
		return
	end

	if perc >= 1 then
		obj:SetRGBA(maxColor.r, maxColor.g, maxColor.b, 1)
		return
	elseif perc <= 0 then
		obj:SetRGBA(minColor.r, minColor.g, minColor.b, 1)
		return
	end

	obj:SetRGBA(
		(maxColor.r * perc) + (minColor.r * (1 - perc)),
		(maxColor.g * perc) + (minColor.g * (1 - perc)),
		(maxColor.b * perc) + (minColor.b * (1 - perc)),
		1
	)
end

do
	local colorCache = {}
	local colorCacheBackground = {}

	function F.Color.GenerateCache()
		local db = E.db.mui.themes.gradientMode
		if not db then
			return
		end

		for _, colorKey in pairs({
			"reactionColorMap",
			"castColorMap",
			"powerColorMap",
			"specialColorMap",
			"classColorMap",
		}) do
			local colorMap = db[colorKey]
			if colorMap then
				for _, colorType in pairs({ I.Enum.GradientMode.Color.NORMAL, I.Enum.GradientMode.Color.SHIFT }) do
					local modS, modL
					if type(db.saturationBoost) == "table" then
						if colorType == I.Enum.GradientMode.Color.NORMAL then
							modS, modL = db.saturationBoost.normalSat, db.saturationBoost.normalLight
						else
							modS, modL = db.saturationBoost.shiftSat, db.saturationBoost.shiftLight
						end
					end

					for colorEntry, colorArray in pairs(colorMap[colorType]) do
						local r1, g1, b1

						if type(db.saturationBoost) == "table" and db.saturationBoost.enable then
							local h, s, l = F.ConvertToHSL(colorArray.r, colorArray.g, colorArray.b)
							r1, g1, b1 = F.ConvertToRGB(F.ClampToHSL(h, s * modS, l * modL))
						else
							r1, g1, b1 = colorArray.r, colorArray.g, colorArray.b
						end

						local r2, g2, b2 = F.CalculateMultiplierColor(db.backgroundMultiplier, r1, g1, b1)

						local tbl1 = F.Table.GetOrCreate(colorCache, colorKey, colorType)
						local tbl2 = F.Table.GetOrCreate(colorCacheBackground, colorKey, colorType)

						if tbl1[colorEntry] then
							tbl1[colorEntry]:SetRGBA(r1, g1, b1, 1)
							tbl2[colorEntry]:SetRGBA(r2, g2, b2, 1)
						else
							tbl1[colorEntry] = CreateColor(r1, g1, b1, 1)
							tbl2[colorEntry] = CreateColor(r2, g2, b2, 1)
						end
					end
				end
			end
		end
	end

	function F.Color.GetMap(colorMap)
		return colorCache[colorMap]
	end

	function F.Color.GetBackgroundMap(colorMap)
		return colorCacheBackground[colorMap]
	end
end

---@param out table? color to write into instead of creating a new one
function F.Color.CalculateMultiplier(multi, color, out)
	local r, g, b = F.CalculateMultiplierColor(multi, color.r, color.g, color.b)
	if out then
		out:SetRGBA(r, g, b, 1)
		return out
	end
	return CreateColor(r, g, b, 1)
end

---Shifted (darker) variant of a color for the gradient theme
---@param boost table? gradientMode.saturationBoost settings
---@param colorArray table
---@param out table? color to write into instead of creating a new one
function F.Color.CalculateShift(boost, colorArray, out)
	local modS, modL = 1, I.GradientMode.BackupMultiplier
	if type(boost) == "table" and boost.enable then
		modS, modL = boost.shiftSat, boost.shiftLight
	end

	local h, s, l = F.ConvertToHSL(colorArray.r, colorArray.g, colorArray.b)
	local r, g, b = F.ConvertToRGB(F.ClampToHSL(h, s * modS, l * modL))
	if out then
		out:SetRGBA(r, g, b, 1)
		return out
	end
	return CreateColor(r, g, b, 1)
end
