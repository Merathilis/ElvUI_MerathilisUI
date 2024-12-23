local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local S = MER:GetModule("MER_Skins")
local ES = E:GetModule("Skins")
local LSM = E.LSM

local _G = _G
local ipairs, pairs, pcall, print, select, tonumber, type, unpack =
	ipairs, pairs, pcall, print, select, tonumber, type, unpack
local format, gsub, match = string.format, string.gsub, string.match
local strfind, strmatch, strsplit, strlen, strsub = strfind, strmatch, strsplit, strlen, strsub
local tinsert, tremove, twipe = table.insert, table.remove, table.wipe
local max, min, modf = math.max, math.min, math.modf
local len, utf8sub = string.len, string.utf8sub
local tcontains = tContains

local CreateFrame = CreateFrame
local GenerateFlatClosure = GenerateFlatClosure
local GetContainerItemID = C_Container.GetContainerItemID
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetBuffDataByIndex = C_UnitAuras.GetBuffDataByIndex
local GetInstanceInfo = GetInstanceInfo
local UnitIsGroupAssistant = UnitIsGroupAssistant
local UnitIsGroupLeader = UnitIsGroupLeader
local IsEveryoneAssistant = IsEveryoneAssistant
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local RunNextFrame = RunNextFrame

local GetInventoryItem = C_TooltipInfo.GetInventoryItem
local GetBagItem = C_TooltipInfo.GetBagItem
local GetHyperlink = C_TooltipInfo.GetHyperlink

local backdropr, backdropg, backdropb, backdropa = unpack(E.media.backdropcolor)
local borderr, borderg, borderb, bordera = unpack(E.media.bordercolor)

-- Profile
function F.IsMERProfile()
	local releaseVersion = F.GetDBFromPath("mui.core.lastLayoutVersion")
	return not (not releaseVersion or releaseVersion == 0)
end

function F.GetDBFromPath(path, dbRef)
	local paths = { strsplit(".", path) }
	local length = #paths
	local count = 0
	dbRef = dbRef or E.db

	for _, key in pairs(paths) do
		if (dbRef == nil) or (type(dbRef) ~= "table") then
			break
		end

		if tonumber(key) then
			key = tonumber(key)
			dbRef = dbRef[key]
			count = count + 1
		else
			local idx

			if key:find("%b[]") then
				idx = {}

				for i in gmatch(key, "(%b[])") do
					i = match(i, "%[(.+)%]")
					tinsert(idx, i)
				end

				length = length + #idx
			end

			key = strsplit("[", key)

			if #key > 0 then
				dbRef = dbRef[key]
				count = count + 1
			end

			if idx and (type(dbRef) == "table") then
				for _, idxKey in ipairs(idx) do
					idxKey = tonumber(idxKey) or idxKey
					dbRef = dbRef[idxKey]
					count = count + 1

					if (dbRef == nil) or (type(dbRef) ~= "table") then
						break
					end
				end
			end
		end
	end

	if count == length then
		return dbRef
	end

	return nil
end

function F.UpdateDBFromPath(db, path, key)
	F.GetDBFromPath(path)[key] = F.GetDBFromPath(path, db)[key]
end

function F.UpdateDBFromPathRGB(db, path)
	F.UpdateDBFromPath(db, path, "r")
	F.UpdateDBFromPath(db, path, "g")
	F.UpdateDBFromPath(db, path, "b")
	F.UpdateDBFromPath(db, path, "a")
end

function F.IsSkyriding()
	return E:Delay(0.01, function()
		return ((IsMounted() or GetShapeshiftForm() ~= 0) and HasBonusActionBar())
			or UnitPowerBarID("player") == I.Constants.VIGOR_BAR_ID
	end)
end

function F.CreateStyle(frame, useStripes, useShadow, useGradient)
	if not frame or frame.__MERStyle or frame.MERStyle then
		return
	end

	if frame:GetObjectType() == "Texture" then
		frame = frame:GetParent()
	end

	local holder = frame.MERStyle or CreateFrame("Frame", nil, frame, "BackdropTemplate")
	holder:SetFrameLevel(frame:GetFrameLevel())
	holder:SetFrameStrata(frame:GetFrameStrata())
	holder:SetOutside(frame)
	holder:Show()

	if not useStripes then
		local stripes = holder.MERstripes
			or holder:CreateTexture(holder:GetName() and holder:GetName() .. "Overlay" or nil, "BORDER")
		stripes:ClearAllPoints()
		stripes:Point("TOPLEFT", 1, -1)
		stripes:Point("BOTTOMRIGHT", -1, 1)
		stripes:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\stripes]], true, true)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")

		holder.MERstripes = stripes
	end

	if not useShadow then
		local mshadow = holder.mShadow
			or holder:CreateTexture(holder:GetName() and holder:GetName() .. "Overlay" or nil, "BORDER")
		mshadow:SetInside(holder)
		mshadow:Width(33)
		mshadow:Height(33)
		mshadow:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\Overlay]])
		mshadow:SetVertexColor(1, 1, 1, 0.6)

		holder.mShadow = mshadow
	end

	if not useGradient then
		local tex = holder.MERgradient or holder:CreateTexture(nil, "BORDER")
		tex:SetInside(holder)
		tex:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\gradient.tga]])
		tex:SetVertexColor(0.3, 0.3, 0.3, 0.15)

		holder.MERgradient = tex
	end

	frame.MERStyle = holder
	frame.__MERStyle = 1
end

function F.CreateOverlay(f)
	if f.overlay then
		return
	end

	local overlay = f:CreateTexture("$parentOverlay", "BORDER", f)
	overlay:Point("TOPLEFT", 2, -2)
	overlay:Point("BOTTOMRIGHT", -2, 2)
	overlay:SetTexture(E["media"].blankTex)
	overlay:SetVertexColor(0.1, 0.1, 0.1, 1)
	f.overlay = overlay
end

function F.CreateBorder(f, i, o)
	if i then
		if f.iborder then
			return
		end
		local border = CreateFrame("Frame", "$parentInnerBorder", f)
		border:Point("TOPLEFT", E.mult, -E.mult)
		border:Point("BOTTOMRIGHT", -E.mult, E.mult)
		border:CreateBackdrop()
		border.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		f.iborder = border
	end

	if o then
		if f.oborder then
			return
		end
		local border = CreateFrame("Frame", "$parentOuterBorder", f)
		border:Point("TOPLEFT", -E.mult, E.mult)
		border:Point("BOTTOMRIGHT", E.mult, -E.mult)
		border:SetFrameLevel(f:GetFrameLevel() + 1)
		border:CreateBackdrop()
		border.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		f.oborder = border
	end
end

function F.CreatePanel(f, t, w, h, a1, p, a2, x, y)
	f:Width(w)
	f:Height(h)
	f:SetFrameLevel(3)
	f:SetFrameStrata("BACKGROUND")
	f:Point(a1, p, a2, x, y)
	f:CreateBackdrop()

	if t == "Transparent" then
		backdropa = 0.45
		F.CreateBorder(f, true, true)
		S:CreateBackdropShadow(f.backdrop)
	elseif t == "Overlay" then
		backdropa = 1
		F.CreateOverlay(f)
		S:CreateBackdropShadow(f.backdrop)
	elseif t == "Invisible" then
		backdropa = 0
		bordera = 0
	else
		backdropa = 1
	end

	f.backdrop:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f.backdrop:SetBackdropBorderColor(borderr, borderg, borderb, bordera)
end

function F.ChooseForGradient(normalValue, gradientValue)
	if E.db.mui.gradient.enable then
		return gradientValue
	end
	return normalValue
end

-- Scaling
function F.PerfectScale(n)
	local m = E.mult
	return (m == 1 or n == 0) and n or (n * m)
end

function F.PixelPerfect()
	local perfectScale = 768 / E.physicalHeight
	if E.physicalHeight == 2160 or E.physicalHeight == 2880 then
		perfectScale = perfectScale * 2
	end
	return perfectScale
end

local baseScale = 768 / 1080
local baseMulti = 0.64 / baseScale
local perfectScale = baseScale / F.PixelPerfect()
local perfectMulti = baseMulti * perfectScale

function F.HiDpi()
	return E.physicalHeight / 1440 >= 1
end

function F.Dpi(value, frac)
	return F.Round(value * perfectMulti, frac)
end

function F.DpiRaw(value)
	return value * perfectMulti
end

function F:Interval(value, minValue, maxValue)
	return max(minValue, min(maxValue, value))
end

function F.SetFontDB(text, db)
	if not text or not text.GetFont then
		F.Developer.LogDebug("Functions.SetFontDB: text not found")
		return
	end

	if not db or type(db) ~= "table" then
		F.Developer.LogDebug("Functions.SetFontDB: db not found")
		return
	end

	local fontName, fontHeight = text:GetFont()

	text:FontTemplate(db.name and LSM:Fetch("font", db.name) or fontName, db.size or fontHeight, db.style or "NONE")
end

function F.SetFontColorDB(text, db)
	if not text or not text.GetFont then
		F.Developer.LogDebug("Functions.SetFontColorDB: text not found")
		return
	end

	if not db or type(db) ~= "table" then
		F.Developer.LogDebug("Functions.SetFontColorWithDB: db not found")
		return
	end

	text:SetTextColor(db.r, db.g, db.b, db.a)
end

function F.SetFontOutline(text, font, size)
	if not text or not text.GetFont then
		F.Developer.LogDebug("Functions.SetFontOutline: text not found")
		return
	end
	local fontName, fontHeight, fontStyle = text:GetFont()

	if size and type(size) == "string" then
		size = fontHeight + tonumber(size)
	end

	if font and not strfind(font, "%.ttf") and not strfind(font, "%.otf") then
		font = LSM:Fetch("font", font)
	end

	text:FontTemplate(font or fontName, size or fontHeight, fontStyle or "SHADOWOUTLINE")
	text:SetShadowColor(0, 0, 0, 0)
	text.SetShadowColor = E.noop
end

function F.FontSize(value)
	value = E.db.mui and E.db.mui.general and E.db.mui.general.fontScale and (value + E.db.mui.general.fontScale)
		or value
	return F.Clamp(value, 8, 64)
end

function F.FontSizeScaled(value, clamp)
	value = E.db.mui and E.db.mui.general and E.db.mui.general.fontScale and (value + E.db.mui.general.fontScale)
		or value
	clamp = (
		clamp
			and (E.db.mui and E.db.mui.general and E.db.mui.general.fontScale)
			and (clamp + E.db.mui.general.fontScale)
		or clamp
	) or 0

	return F.Clamp(F.Clamp(F.Round(value * perfectScale), clamp or 0, 64), 8, 64)
end

function F.FontOverride(font)
	local override = F.GetDBFromPath("mui.general.fontOverride")[font]
	return (override and override ~= "DEFAULT") and override or font
end

function F.FontStyleOverride(font, style)
	local override = F.GetDBFromPath("mui.general.fontStyleOverride")[font]
	return (override and override ~= "DEFAULT") and override or style
end

function F.GetStyledText(text)
	return E:TextGradient(text, 0.32941, 0.52157, 0.93333, 0.29020, 0.70980, 0.89412, 0.25882, 0.84314, 0.86667)
end

function F.Position(anchor1, parent, anchor2, x, y)
	return format("%s,%s,%s,%d,%d", anchor1, parent, anchor2, F.Dpi(x), F.Dpi(y))
end

function F.Clamp(value, s, b)
	return min(max(value, s), b)
end

function F.ClampTo01(value)
	return F.Clamp(value, 0, 1)
end

function F.ClampToHSL(h, s, l)
	return h % 360, F.ClampTo01(s), F.ClampTo01(l)
end

function F.ConvertFromHue(m1, m2, h)
	if h < 0 then
		h = h + 1
	end
	if h > 1 then
		h = h - 1
	end

	if h * 6 < 1 then
		return m1 + (m2 - m1) * h * 6
	elseif h * 2 < 1 then
		return m2
	elseif h * 3 < 2 then
		return m1 + (m2 - m1) * (2 / 3 - h) * 6
	else
		return m1
	end
end

function F.ConvertToRGB(h, s, l)
	h = h / 360

	local m2 = l <= 0.5 and l * (s + 1) or l + s - l * s
	local m1 = l * 2 - m2

	return F.ConvertFromHue(m1, m2, h + 1 / 3), F.ConvertFromHue(m1, m2, h), F.ConvertFromHue(m1, m2, h - 1 / 3)
end

function F.ConvertToHSL(r, g, b)
	r = r or 0
	g = g or 0
	b = b or 0

	local minColor = min(r, g, b)
	local maxColor = max(r, g, b)
	local colorDelta = maxColor - minColor

	local h, s, l = 0, 0, (minColor + maxColor) / 2

	if l > 0 and l < 0.5 then
		s = colorDelta / (maxColor + minColor)
	end
	if l >= 0.5 and l < 1 then
		s = colorDelta / (2 - maxColor - minColor)
	end

	if colorDelta > 0 then
		if maxColor == r and maxColor ~= g then
			h = h + (g - b) / colorDelta
		end
		if maxColor == g and maxColor ~= b then
			h = h + 2 + (b - r) / colorDelta
		end
		if maxColor == b and maxColor ~= r then
			h = h + 4 + (r - g) / colorDelta
		end
		h = h / 6
	end

	if h < 0 then
		h = h + 1
	end
	if h > 1 then
		h = h - 1
	end

	return h * 360, s, l
end

function F.SetVertexColorDB(tex, db)
	if not tex or not tex.GetVertexColor then
		F.Developer.LogDebug("Functions.SetVertexColorDB: No texture to handling")
		return
	end

	if not db or type(db) ~= "table" then
		F.Developer.LogDebug("Functions.SetVertexColorDB: No texture color database")
		return
	end

	tex:SetVertexColor(db.r, db.g, db.b, db.a)
end

function F.SlowColorGradient(perc, ...)
	if perc >= 1 then
		return select(select("#", ...) - 2, ...)
	elseif perc <= 0 then
		return ...
	end

	local num = select("#", ...) / 3
	local segment, relperc = modf(perc * (num - 1))
	local r1, g1, b1, r2, g2, b2 = select((segment * 3) + 1, ...)

	return F.FastColorGradient(relperc, r1, g1, b1, r2, g2, b2)
end

function F.FastColorGradient(perc, r1, g1, b1, r2, g2, b2)
	if perc >= 1 then
		return r2, g2, b2
	elseif perc <= 0 then
		return r1, g1, b1
	end

	return (r2 * perc) + (r1 * (1 - perc)), (g2 * perc) + (g1 * (1 - perc)), (b2 * perc) + (b1 * (1 - perc))
end

function F.Round(n, q)
	q = q or 1

	local int, frac = modf(n / q)
	if n == abs(n) and frac >= 0.5 then
		return (int + 1) * q
	elseif frac <= -0.5 then
		return (int - 1) * q
	end

	return int * q
end

function F.AlmostEqual(a, b)
	if not a or not b then
		return false
	end

	return abs(a - b) <= 0.001
end

function F.cOption(name, color)
	local hex
	if color == "orange" then
		hex = "|cffff7d0a%s |r"
	elseif color == "blue" then
		hex = "|cFF00c0fa%s |r"
	elseif color == "red" then
		hex = "|cFFFF0000%s |r"
	elseif color == "gradient" then
		hex = E:TextGradient(name, 1, 0.65, 0, 1, 0.65, 0, 1, 1, 1)
	else
		hex = "|cFFFFFFFF%s |r"
	end

	return (hex):format(name)
end

do
	local gradientLine = E:TextGradient(
		"----------------------------------",
		0.910,
		0.314,
		0.357,
		0.976,
		0.835,
		0.431,
		0.953,
		0.925,
		0.761,
		0.078,
		0.694,
		0.671
	)

	function F.PrintGradientLine()
		print(gradientLine)
	end
end

function F.Print(text)
	if not text then
		return
	end

	local message = format("%s: %s", MER.Title, text)
	print(message)
end

function F.DebugPrint(text, msgtype)
	if not text then
		return
	end

	local message
	if msgtype == "error" then
		message = format("%s: %s", MER.Title .. F.String.Error(L["Error"]), text)
	elseif msgtype == "warning" then
		message = format("%s: %s", MER.Title .. F.String.Warning(L["Warning"]), text)
	elseif msgtype == "info" then
		message = format("%s: %s", MER.Title .. F.String.MER(L["Information"]), text)
	end
	print(message)
end

function F.PrintURL(url)
	return format("|cFF00c0fa[|Hurl:%s|h%s|h]|r", url, url)
end

do
	-- Tooltip Stuff
	function F:HideTooltip()
		_G.GameTooltip:Hide()
	end

	local function Tooltip_OnEnter(self)
		_G.GameTooltip:SetOwner(self, self.anchor, 0, 4)
		_G.GameTooltip:ClearLines()

		if self.title then
			_G.GameTooltip:AddLine(self.title)
		end

		local r, g, b

		if tonumber(self.text) then
			_G.GameTooltip:SetSpellByID(self.text)
		elseif self.text then
			if self.color == "CLASS" then
				r, g, b = F.r, F.g, F.b
			elseif self.color == "SYSTEM" then
				r, g, b = 1, 0.8, 0
			elseif self.color == "BLUE" then
				r, g, b = 0.6, 0.8, 1
			elseif self.color == "RED" then
				r, g, b = 0.9, 0.3, 0.3
			elseif self.color == "WHITE" then
				r, g, b = 1, 1, 1
			end
			if self.blankLine then
				_G.GameTooltip:AddLine(" ")
			end

			_G.GameTooltip:AddLine(self.text, r, g, b, 1)
		end

		_G.GameTooltip:Show()
	end

	function F:AddTooltip(anchor, text, color, showTips)
		self.anchor = anchor
		self.text = text
		self.color = color
		if showTips then
			self.title = L["Tips"]
		end
		self:HookScript("OnEnter", Tooltip_OnEnter)
		self:HookScript("OnLeave", F.HideTooltip)
	end
end

-- Glow Parent
function F:CreateGlowFrame(size)
	local frame = CreateFrame("Frame", nil, self)
	frame:SetPoint("CENTER")
	frame:SetSize(size + 4, size + 4)

	return frame
end

function F.SplitList(list, variable, cleanup)
	if cleanup then
		twipe(list)
	end

	for word in variable:gmatch("%S+") do
		list[word] = true
	end
end

F.iLvlClassIDs = {
	[Enum.ItemClass.Gem] = Enum.ItemGemSubclass.Artifactrelic,
	[Enum.ItemClass.Armor] = 0,
	[Enum.ItemClass.Weapon] = 0,
}

do -- Tooltip scanning stuff. Credits siweia, with permission.
	local iLvlDB = {}
	local itemLevelString = "^" .. gsub(ITEM_LEVEL, "%%d", "")
	local RETRIEVING_ITEM_INFO = RETRIEVING_ITEM_INFO
	local enchantString = gsub(ENCHANTED_TOOLTIP_LINE, "%%s", "(.+)")
	local isUnknownString = {
		[TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN] = true,
		[TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN] = true,
	}

	local tip = CreateFrame("GameTooltip", "mUI_ScanTooltip", nil, "GameTooltipTemplate")
	F.ScanTip = tip

	local slotData = { gems = {}, gemsColor = {} }
	function F.GetItemLevel(link, arg1, arg2, fullScan)
		if fullScan then
			local data = GetInventoryItem(arg1, arg2)
			if not data then
				return
			end

			wipe(slotData.gems)
			wipe(slotData.gemsColor)
			slotData.iLvl = nil
			slotData.enchantText = nil

			local isHoA = data.id == 158075
			local num = 0
			for i = 2, #data.lines do
				local lineData = data.lines[i]
				if not slotData.iLvl then
					local text = lineData.leftText
					local found = text and strfind(text, itemLevelString)
					if found then
						local level = strmatch(text, "(%d+)%)?$")
						slotData.iLvl = tonumber(level) or 0
					end
				elseif isHoA then
					if lineData.essenceIcon then
						num = num + 1
						slotData.gems[num] = lineData.essenceIcon
						slotData.gemsColor[num] = lineData.leftColor
					end
				else
					if lineData.enchantID then
						slotData.enchantText = strmatch(lineData.leftText, enchantString)
					elseif lineData.gemIcon then
						num = num + 1
						slotData.gems[num] = lineData.gemIcon
					elseif lineData.socketType then
						num = num + 1
						slotData.gems[num] =
							format("Interface\\ItemSocketingFrame\\UI-EmptySocket-%s", lineData.socketType)
					end
				end
			end

			return slotData
		else
			if iLvlDB[link] then
				return iLvlDB[link]
			end

			local data
			if arg1 and type(arg1) == "string" then
				data = GetInventoryItem(arg1, arg2)
			elseif arg1 and type(arg1) == "number" then
				data = GetBagItem(arg1, arg2)
			else
				data = GetHyperlink(link, nil, nil, true)
			end
			if not data then
				return
			end

			for i = 2, 5 do
				local lineData = data.lines[i]
				if not lineData then
					break
				end
				local text = lineData.leftText
				local found = text and strfind(text, itemLevelString)
				if found then
					local level = strmatch(text, "(%d+)%)?$")
					iLvlDB[link] = tonumber(level)
					break
				end
			end
			return iLvlDB[link]
		end
	end

	local pendingNPCs, nameCache, callbacks = {}, {}, {}
	local loadingStr = "..."
	local pendingFrame = CreateFrame("Frame")
	pendingFrame:Hide()
	pendingFrame:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed > 1 then
			if next(pendingNPCs) then
				for npcID, count in pairs(pendingNPCs) do
					if count > 2 then
						nameCache[npcID] = UNKNOWN
						if callbacks[npcID] then
							callbacks[npcID](UNKNOWN)
						end
						pendingNPCs[npcID] = nil
					else
						local name = F.GetNPCName(npcID, callbacks[npcID])
						if name and name ~= loadingStr then
							pendingNPCs[npcID] = nil
						else
							pendingNPCs[npcID] = pendingNPCs[npcID] + 1
						end
					end
				end
			else
				self:Hide()
			end

			self.elapsed = 0
		end
	end)

	function F.GetNPCName(npcID, callback)
		local name = nameCache[npcID]
		if not name then
			name = loadingStr
			local data = GetHyperlink(format("unit:Creature-0-0-0-0-%d", npcID))
			local lineData = data and data.lines
			if lineData then
				name = lineData[1] and lineData[1].leftText
			end
			if name == loadingStr then
				if not pendingNPCs[npcID] then
					pendingNPCs[npcID] = 1
					pendingFrame:Show()
				end
			else
				nameCache[npcID] = name
			end
		end
		if callback then
			callback(name)
			callbacks[npcID] = callback
		end

		return name
	end

	function F.IsUnknownTransmog(bagID, slotID)
		local data = GetBagItem(bagID, slotID)
		local lineData = data and data.lines
		if not lineData then
			return
		end

		for i = #lineData, 1, -1 do
			local line = lineData[i]
			if line.price then
				return false
			end
			return line.leftText and isUnknownString[line.leftText]
		end
	end

	local pattern = gsub(ITEM_LEVEL, "%%d", "(%%d+)")
	function F.GetRealItemLevelByLink(link)
		E.ScanTooltip:SetOwner(_G.UIParent, "ANCHOR_NONE")
		E.ScanTooltip:ClearLines()
		E.ScanTooltip:SetHyperlink(link)

		for i = 2, 5 do
			local leftText = _G[E.ScanTooltip:GetName() .. "TextLeft" .. i]
			if leftText then
				local text = leftText:GetText() or ""
				local level = strmatch(text, pattern)
				if level then
					return level
				end
			end
		end
	end
end

--[[----------------------------------
--	Skin Functions
--]]
----------------------------------
do
	function F:ResetTabAnchor(size, outline)
		local text = self.Text or (self.GetName and _G[self:GetName() .. "Text"])
		if text then
			text:SetPoint("CENTER", self)
		end
	end

	hooksecurefunc("PanelTemplates_SelectTab", F.ResetTabAnchor)
	hooksecurefunc("PanelTemplates_DeselectTab", F.ResetTabAnchor)

	-- Kill regions
	F.HiddenFrame = CreateFrame("Frame")
	F.HiddenFrame:Hide()

	function F:HideObject()
		if self.UnregisterAllEvents then
			self:UnregisterAllEvents()
			self:SetParent(F.HiddenFrame)
		else
			self.Show = self.Hide
		end
		self:Hide()
	end

	function F:ReplaceIconString(text)
		if not text then
			text = self:GetText()
		end
		if not text or text == "" then
			return
		end

		local newText, count = gsub(text, "|T([^:]-):[%d+:]+|t", "|T%1:14:14:0:0:64:64:5:59:5:59|t")
		if count > 0 then
			self:SetFormattedText("%s", newText)
		end
	end
end

-- Check Chat channels
function F.CheckChat(msg)
	if IsInGroup(_G.LE_PARTY_CATEGORY_INSTANCE) then
		return "INSTANCE_CHAT"
	elseif IsInRaid(_G.LE_PARTY_CATEGORY_HOME) then
		if msg and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant()) then
			return "RAID_WARNING"
		else
			return "RAID"
		end
	elseif IsInGroup(_G.LE_PARTY_CATEGORY_HOME) then
		return "PARTY"
	end

	return "SAY"
end

function F.CheckPlayerBuff(spell)
	for i = 1, 40 do
		local name, _, _, _, _, _, unitCaster = GetBuffDataByIndex("player", i)
		if not name then
			break
		end
		if name == spell then
			return i, unitCaster
		end
	end
	return nil
end

function F.BagSearch(itemId)
	for container = 0, _G.NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(container) do
			if itemId == GetContainerItemID(container, slot) then
				return container, slot
			end
		end
	end
end

function F.Reset(group)
	if not group then
		print("U wot m8?")
	end

	if group == "marks" or group == "all" then
		E:CopyTable(E.db.mui.raidmarkers, P.raidmarkers)
		E:ResetMovers(L["Raid Marker Bar"])
	end
	E:UpdateAll()
end

-- Inform us of the patch info we play on.
MER.WoWPatch, MER.WoWBuild, MER.WoWPatchReleaseDate, MER.TocVersion = GetBuildInfo()
MER.WoWBuild = select(2, GetBuildInfo())
MER.WoWBuild = tonumber(MER.WoWBuild)

_G["SLASH_WOWVERSION1"], _G["SLASH_WOWVERSION2"] = "/patch", "/version"
SlashCmdList["WOWVERSION"] = function()
	print(
		"Patch:",
		MER.WoWPatch .. ", " .. "Build:",
		MER.WoWBuild .. ", " .. "Released",
		MER.WoWPatchReleaseDate .. ", " .. "Interface:",
		MER.TocVersion
	)
end

-- Icon Style
function F.PixelIcon(self, texture, highlight)
	if not self then
		return
	end

	self.bg = S:CreateBDFrame(self)
	self.bg:SetAllPoints()

	self.Icon = self:CreateTexture(nil, "ARTWORK")
	self.Icon:Point("TOPLEFT", E.mult, -E.mult)
	self.Icon:Point("BOTTOMRIGHT", -E.mult, E.mult)
	self.Icon:SetTexCoord(unpack(E.TexCoords))

	if texture then
		local atlas = strmatch(texture, "Atlas:(.+)$")
		if atlas then
			self.Icon:SetAtlas(atlas)
		else
			self.Icon:SetTexture(texture)
		end
	end
	if highlight and type(highlight) == "boolean" then
		self:EnableMouse(true)
		self.HL = self:CreateTexture(nil, "HIGHLIGHT")
		self.HL:SetColorTexture(1, 1, 1, 0.25)
		self.HL:SetAllPoints(self.Icon)
	end
end

-- Role Icons
function F.ReskinRole(self, role)
	if self.background then
		self.background:SetTexture("")
	end
	local cover = self.cover or self.Cover
	if cover then
		cover:SetTexture("")
	end

	local checkButton = self.checkButton or self.CheckButton or self.CheckBox
	if checkButton then
		checkButton:SetFrameLevel(self:GetFrameLevel() + 2)
		checkButton:Point("BOTTOMLEFT", -2, -2)
	end

	local shortageBorder = self.shortageBorder
	if shortageBorder then
		shortageBorder:SetTexture("")
		local icon = self.incentiveIcon
		icon:Point("BOTTOMRIGHT")
		icon:Size(14, 14)
		icon.texture:SetSize(14, 14)
		icon.border:SetTexture("")
	end
end

-- Atlas info
function F.GetTextureStrByAtlas(info, sizeX, sizeY)
	local file = info and info.file
	if not file then
		return
	end

	local width, height, txLeft, txRight, txTop, txBottom =
		info.width, info.height, info.leftTexCoord, info.rightTexCoord, info.topTexCoord, info.bottomTexCoord
	local atlasWidth = width / (txRight - txLeft)
	local atlasHeight = height / (txBottom - txTop)

	return format(
		"|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t",
		file,
		(sizeX or 0),
		(sizeY or 0),
		atlasWidth,
		atlasHeight,
		atlasWidth * txLeft,
		atlasWidth * txRight,
		atlasHeight * txTop,
		atlasHeight * txBottom
	)
end

function F.AddMedia(mediaType, mediaFile, lsmName, lsmType, lsmMask)
	local path = I.MediaPaths[mediaType]
	if path then
		local key = gsub(mediaFile, "%.%w-$", "")
		local file = path .. mediaFile

		local pathKey = I.MediaKeys[mediaType]
		if pathKey then
			I.Media[pathKey][key] = file
		else
			F.Developer.LogDebug("Could not find path key for", mediaType, mediaFile, lsmName, lsmType, lsmMask)
		end

		if lsmName then
			local nameKey = (lsmName == true and key) or lsmName
			local mediaKey = lsmType or mediaType
			LSM:Register(mediaKey, nameKey, file, lsmMask)
		end
	else
		F.Developer.LogDebug("Could not find media path for", mediaType, mediaFile, lsmName, lsmType, lsmMask)
	end
end

do
	local cuttedIconTemplate = "|T%s:%d:%d:0:0:64:64:5:59:5:59|t"
	local cuttedIconAspectRatioTemplate = "|T%s:%d:%d:0:0:64:64:%d:%d:%d:%d|t"
	local textureTemplate = "|T%s:%d:%d|t"
	local aspectRatioTemplate = "|T%s:0:aspectRatio|t"
	local s = 14

	function F.GetIconString(icon, height, width, aspectRatio)
		if aspectRatio and height and height > 0 and width and width > 0 then
			local proportionality = height / width
			local offset = ceil((54 - 54 * proportionality) / 2)
			if proportionality > 1 then
				return format(cuttedIconAspectRatioTemplate, icon, height, width, 5 + offset, 59 - offset, 5, 59)
			elseif proportionality < 1 then
				return format(cuttedIconAspectRatioTemplate, icon, height, width, 5, 59, 5 + offset, 59 - offset)
			end
		end

		width = width or height
		return format(cuttedIconTemplate, icon, height or s, width or s)
	end

	function F.GetTextureString(texture, height, width, aspectRatio)
		if aspectRatio then
			return format(aspectRatioTemplate, texture)
		else
			width = width or height
			return format(textureTemplate, texture, height or s, width or s)
		end
	end
end

local MediaPath = "Interface/Addons/ElvUI_MerathilisUI/Media/"

do
	local texTable = {
		texWidth = 2048,
		texHeight = 1024,
		tipWidth = 512,
		tipHeight = 170,
		languages = {
			enUS = 0,
		},
		type = {
			button = { 0, 0 },
			checkBox = { 512, 0 },
			tab = { 1024, 0 },
			treeGroupButton = { 1536, 0 },
			slider = { 0, 180 },
		},
	}

	function F.GetWidgetTips(widgetType)
		if not texTable.type[widgetType] then
			return
		end
		local offsetY = texTable.languages[E.global.general.locale] or texTable.languages["enUS"]
		if not offsetY then
			return
		end

		local xStart = texTable.type[widgetType][1]
		local yStart = texTable.type[widgetType][2] + offsetY
		local xEnd = xStart + texTable.tipWidth
		local yEnd = yStart + texTable.tipHeight

		return {
			xStart / texTable.texWidth,
			xEnd / texTable.texWidth,
			yStart / texTable.texHeight,
			yEnd / texTable.texHeight,
		}
	end

	function F.GetWidgetTipsString(widgetType)
		if not texTable.type[widgetType] then
			return
		end
		local offsetY = texTable.languages[E.global.general.locale] or texTable.languages["enUS"]
		if not offsetY then
			return
		end

		local xStart = texTable.type[widgetType][1]
		local yStart = texTable.type[widgetType][2] + offsetY
		local xEnd = xStart + texTable.tipWidth
		local yEnd = yStart + texTable.tipHeight

		return format(
			"|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d:255:255:255|t",
			I.Media.Textures.WidgetsTips,
			ceil(texTable.tipHeight * 0.4),
			ceil(texTable.tipWidth * 0.4),
			texTable.texWidth,
			texTable.texHeight,
			xStart,
			xEnd,
			yStart,
			yEnd
		)
	end
end

function F.GetClassIconStyleList()
	return { "flat", "flatborder", "flatborder2", "round", "square", "warcraftflat" }
end

function F.GetClassIconWithStyle(class, style)
	if not class or not F.In(strupper(class), _G.CLASS_SORT_ORDER) then
		return
	end

	if not style or not F.In(style, F.GetClassIconStyleList()) then
		return
	end

	return MediaPath .. "Icons/ClassIcon/" .. strlower(class) .. "_" .. style .. ".tga"
end

function F.GetClassIconStringWithStyle(class, style, width, height)
	local path = F.GetClassIconWithStyle(class, style)
	if not path then
		return
	end

	if not width and not height then
		return format("|T%s:0|t", path)
	end

	if not height then
		height = width
	end

	return format("|T%s:%d:%d:0:0:64:64:0:64:0:64|t", path, height, width)
end

-- Check Textures
local txframe = CreateFrame("Frame")
local tx = txframe:CreateTexture()

function F:TextureExists(path)
	if not path or path == "" then
		return F.DebugPrint("Path not valid or defined.", "error")
	end
	tx:SetTexture("?")
	tx:SetTexture(path)

	return (tx:GetTexture())
end

-- GUID to npcID
function F.GetNPCID(guid)
	local id = tonumber(strmatch((guid or ""), "%-(%d-)%-%x-$"))
	return id
end

function F.SplitString(delimiter, subject)
	if not subject or subject == "" then
		return {}
	end

	local length = strlen(delimiter)
	local results = {}

	local i = 0
	local j = 0

	while true do
		j = strfind(subject, delimiter, i + length)
		if strlen(subject) == i then
			break
		end

		if j == nil then
			tinsert(results, strsub(subject, i))
			break
		end

		tinsert(results, strsub(subject, i, j - 1))
		i = j + length
	end

	return unpack(results)
end

do
	local shortenReplace = function(t)
		return t:utf8sub(1, 1) .. ". "
	end

	function F:ShortenString(text, length, cut, firstname)
		if text and len(text) > length then
			if cut then
				text = E:ShortenString(text, length)
			else
				if firstname then
					local first, last = text:match("^(%a*)(.*)$")
					if first and last then
						text = first .. " " .. last:gsub("(%S+)", shortenReplace)
					else
						text = text:gsub("(%S+) ", shortenReplace)
					end
				else
					text = text:gsub("(%S+) ", shortenReplace)
				end
			end
		end
		return text
	end
end

function F.SetCallback(callback, target, times, ...)
	times = times or 0
	if times >= 10 then
		return
	end

	if times < 10 then
		local result = { pcall(target, ...) }
		if result and result[1] == true then
			tremove(result, 1)
			if callback(unpack(result)) then
				return
			end
		end
	end

	E:Delay(0.1, F.SetCallback, callback, target, times + 1, ...)
end

do
	-- Handle close button
	function F:Texture_OnEnter()
		if self:IsEnabled() then
			if self.bg then
				self.bg:SetBackdropColor(F.r, F.g, F.b, 0.25)
			else
				self.__texture:SetVertexColor(0, 0.6, 1, 1)
			end
		end
	end

	function F:Texture_OnLeave()
		if self.bg then
			self.bg:SetBackdropColor(0, 0, 0, 0.25)
		else
			self.__texture:SetVertexColor(1, 1, 1, 1)
		end
	end
end

function F:TogglePanel(frame)
	if frame:IsShown() then
		frame:Hide()
	else
		frame:Show()
	end
end

function F.Enum(tbl)
	local length = #tbl
	for i = 1, length do
		local v = tbl[i]
		tbl[v] = i
	end

	return tbl
end

function F.In(val, tbl)
	if not val or not tbl or type(tbl) ~= "table" then
		return false
	end

	for _, v in pairs(tbl) do
		if v == val then
			return true
		end
	end

	return false
end

function F.IsNaN(val)
	return tostring(val) == tostring(0 / 0)
end

function F.Or(val, default)
	if not val or F.IsNaN(val) then
		return default
	end
	return val
end

do
	local protected_call = {}

	function protected_call._error_handler(err)
		F.Developer.LogInfo(err)
	end

	function protected_call._handle_result(success, ...)
		if success then
			return ...
		end
	end

	local do_pcall
	if not select(
		2,
		xpcall(function(a)
			return a
		end, error, true)
	) then
		do_pcall = function(func, ...)
			local args = { ... }
			return protected_call._handle_result(xpcall(function()
				return func(unpack(args))
			end, protected_call._error_handler))
		end
	else
		do_pcall = function(func, ...)
			return protected_call._handle_result(xpcall(func, protected_call._error_handler, ...))
		end
	end

	function protected_call.call(func, ...)
		return do_pcall(func, ...)
	end

	local pcall_mt = {}
	function pcall_mt:__call(...)
		return do_pcall(...)
	end

	F.ProtectedCall = setmetatable(protected_call, pcall_mt)
end

do
	local eventManagerFrame, eventManagerTable, eventManagerDelayed = CreateFrame("Frame"), {}, {}

	eventManagerFrame:SetScript("OnUpdate", function()
		for _, func in ipairs(eventManagerDelayed) do
			F.ProtectedCall(unpack(func))
		end
		eventManagerDelayed = {}
	end)

	function F.EventManagerDelayed(func, ...)
		tinsert(eventManagerDelayed, { func, ... })
	end

	eventManagerFrame:SetScript("OnEvent", function(_, event, ...)
		local namespaces = eventManagerTable[event]
		if namespaces then
			for _, funcs in pairs(namespaces) do
				for _, func in ipairs(funcs) do
					func(event, ...)
				end
			end
		end
	end)

	function F.EventManagerRegister(namespace, event, func)
		local namespaces = eventManagerTable[event]

		if not namespaces then
			eventManagerTable[event] = {}
			namespaces = eventManagerTable[event]
			pcall(eventManagerFrame.RegisterEvent, eventManagerFrame, event)
		end

		local funcs = namespaces[namespace]

		if not funcs then
			namespaces[namespace] = { func }
		elseif not tcontains(funcs, func) then
			tinsert(funcs, func)
		end
	end

	function F.EventManagerUnregisterAll(namespace)
		for event in pairs(eventManagerTable) do
			local namespaces = eventManagerTable[event]
			local funcs = namespaces and namespaces[namespace]
			if funcs ~= nil then
				F.EventManagerUnregister(namespace, event)
			end
		end
	end

	function F.EventManagerUnregister(namespace, event, func)
		local namespaces = eventManagerTable[event]
		local funcs = namespaces and namespaces[namespace]

		if funcs then
			for index, fnc in ipairs(funcs) do
				if not func or (func == fnc) then
					tremove(funcs, index)
					break
				end
			end

			if #funcs == 0 then
				namespaces[namespace] = nil
			end

			if not next(funcs) then
				eventManagerFrame:UnregisterEvent(event)
				eventManagerTable[event] = nil
			end
		end
	end
end

function F.ProcessMovers(dbRef)
	-- Disable screen restrictions
	E:SetMoversClampedToScreen(false)

	-- Enable all movers
	for name in pairs(E.DisabledMovers) do
		local disable = E.DisabledMovers[name].shouldDisable
		local shouldDisable = (disable and disable()) or false

		if not shouldDisable and not E.CreatedMovers[name] then
			local holder = E.DisabledMovers[name]
			if not holder then
				F.Developer.LogDebug("holder doesnt exist", name or "nil")
			end

			E.CreatedMovers[name] = {}
			for x, y in pairs(holder) do
				E.CreatedMovers[name][x] = y
			end

			E.DisabledMovers[name] = nil
		else
			F.Developer.LogDebug("could not enable mover", name or "nil")
		end
	end

	local relativeMovers = {}
	local globalMovers = {}

	for name, points in pairs(dbRef.movers) do
		local _, relativeTo = strsplit(",", points)
		if relativeTo then
			relativeTo = relativeTo:gsub("Mover", "")

			if relativeTo ~= "ElvUIParent" and relativeTo ~= "UIParent" then
				if not relativeMovers[relativeTo] then
					relativeMovers[relativeTo] = {}
				end
				tinsert(relativeMovers[relativeTo], { name, points })
			else
				tinsert(globalMovers, { name, points })
			end
		end
	end

	local function processMover(info)
		local name, points = unpack(info)
		local cleanName = name:gsub("Mover", "")

		local holder = E.CreatedMovers[name]
		local mover = holder and holder.mover

		if mover and mover:GetCenter() then
			local point1, relativeTo1, relativePoint1, xOffset1, yOffset1 = strsplit(",", points)

			-- Set To DB Points
			mover:ClearAllPoints()
			mover:SetPoint(point1, relativeTo1, relativePoint1, xOffset1, yOffset1)

			-- Set ElvUI Converted Point
			local xOffsetConverted, yOffsetConverted, pointConverted = E:CalculateMoverPoints(mover)
			mover:ClearAllPoints()
			mover:SetPoint(pointConverted, _G.UIParent, pointConverted, xOffsetConverted, yOffsetConverted)

			-- Read resulting point, save it to our db
			local point3, _, relativePoint3, xOffset3, yOffset3 = mover:GetPoint()
			dbRef.movers[name] = format(
				"%s,ElvUIParent,%s,%d,%d",
				point3,
				relativePoint3,
				xOffset3 and E:Round(xOffset3) or 0,
				yOffset3 and E:Round(yOffset3) or 0
			)

			-- Process other movers that are relative to us
			if relativeMovers[cleanName] and #relativeMovers[cleanName] > 0 then
				for i, relativeInfo in ipairs(relativeMovers[cleanName]) do
					if relativeInfo then
						relativeMovers[cleanName][i] = nil
						processMover(relativeInfo)
					end
				end
			end
		else
			F.Developer.LogDebug(F.String.Error("Could not find holder"), name)
		end
	end

	for _, info in ipairs(globalMovers) do
		processMover(info)
	end

	for parent, infos in pairs(relativeMovers) do
		for _, info in ipairs(infos) do
			if info then
				F.Developer.LogDebug(
					F.String.Error("Parent was never processed resulted in dangling child"),
					parent,
					info[1]
				)
			end
		end
	end
end

function F.DelvesEventFix(original, func)
	local isWaiting = false

	return function(...)
		local difficulty = select(3, GetInstanceInfo())
		if not difficulty or difficulty ~= 208 then
			return original(...)
		end

		if isWaiting then
			return
		end

		local f = GenerateFlatClosure(original, ...)

		RunNextFrame(function()
			if not isWaiting then
				isWaiting = true
				E:Delay(3, function()
					f()
					isWaiting = false
				end)
			end
		end)
	end
end

function F.WaitFor(condition, callback, interval, leftTimes)
	leftTimes = (leftTimes or 10) - 1
	interval = interval or 0.1
	if condition() then
		callback()
		return
	end
	if leftTimes and leftTimes <= 0 then
		return
	end
	E:Delay(interval, F.WaitFor, condition, callback, interval, leftTimes)
end

function F.MoveFrameWithOffset(frame, x, y)
	if not frame or not frame.ClearAllPoints then
		return
	end

	local pointsData = {}

	for i = 1, frame:GetNumPoints() do
		local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(i)
		pointsData[i] = { point, relativeTo, relativePoint, xOfs, yOfs }
	end

	frame:ClearAllPoints()

	for _, data in pairs(pointsData) do
		local point, relativeTo, relativePoint, xOfs, yOfs = unpack(data)
		frame:SetPoint(point, relativeTo, relativePoint, xOfs + x, yOfs + y)
	end
end

function F:ReskinNavBar(bar)
	if bar.navBarStyled then
		return
	end

	local homeButton = bar.homeButton
	local overflowButton = bar.overflowButton

	bar:GetRegions():Hide()
	bar:DisableDrawLayer("BORDER")
	bar.overlay:Hide()

	if homeButton then
		homeButton:GetRegions():Hide()
		ES:HandleButton(homeButton)
	end

	if overflowButton then
		ES:HandleButton(overflowButton, true)

		local tex = overflowButton:CreateTexture(nil, "ARTWORK")
		tex:Size(14)
		tex:Point("CENTER")
		tex:SetTexture(E.Media.Textures.ArrowUp)
		-- tex:SetRotation(S.ArrowRotation.down)

		overflowButton:HookScript("OnEnter", F.Texture_OnEnter)
		overflowButton:HookScript("OnLeave", F.Texture_OnLeave)
	end

	bar.navBarStyled = true
end
