local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local ES = E:GetModule("Skins")
local LSM = E.LSM

local _G = _G
local ipairs, pairs, print, select, tonumber, tostring, type, unpack = ipairs, pairs, print, select, tonumber, tostring, type, unpack
local xpcall = xpcall
local format, gmatch, gsub, match = string.format, string.gmatch, string.gsub, string.match
local strfind, strjoin, strmatch, strsplit = strfind, strjoin, strmatch, strsplit
local tinsert, wipe = table.insert, wipe
local abs, ceil, max, min, modf = math.abs, math.ceil, math.max, math.min, math.modf
local len = string.len
local hooksecurefunc = hooksecurefunc

local C_PlayerInfo_GetGlidingInfo = C_PlayerInfo.GetGlidingInfo
local CreateFrame = CreateFrame
local IsInInstance = IsInInstance

local GetInventoryItem = C_TooltipInfo.GetInventoryItem
local GetBagItem = C_TooltipInfo.GetBagItem
local GetHyperlink = C_TooltipInfo.GetHyperlink

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

function F.IsThisASafeSecret(value, hasValue, isBG)
	if hasValue then
		return E:CanAccessValue(value) --new api to check if value is secret
	else
		local _, instanceType = IsInInstance()
		if isBG then
			return instanceType ~= "pvp" and instanceType ~= "arena"
		else
			return instanceType == "none"
		end
	end
end

local STYLE_STRIPES = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\stripes]]
local STYLE_GRADIENT = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\gradient.tga]]

---Attach a MER style overlay (stripes + gradient) to a frame.
---Called as frame:CreateStyle() or F.CreateStyle(frame).
---@param frame Frame|Texture
---@param createStripes boolean|nil  default true — set false to skip/hide stripes
---@param createGradient boolean|nil default true — set false to skip/hide gradient
function F.CreateStyle(frame, createStripes, createGradient)
	if not frame then
		return
	end

	-- Resolve texture → parent frame
	if frame.GetObjectType and frame:GetObjectType() == "Texture" then
		frame = frame:GetParent()
		if not frame then
			return
		end
	end

	-- Defaults: both layers on (matches previous nil-arg behaviour where
	-- inverted "if not useStripes" always created layers)
	if createStripes == nil then
		createStripes = true
	end
	if createGradient == nil then
		createGradient = true
	end

	local holder = frame.MERStyle
	if not holder then
		holder = CreateFrame("Frame", nil, frame, "BackdropTemplate")
		frame.MERStyle = holder
		frame.__MERStyle = true
	end

	holder:OffsetFrameLevel(nil, frame)
	holder:SetFrameStrata(frame:GetFrameStrata())
	holder:SetOutside(frame)
	holder:Show()

	-- Stripes layer
	if createStripes then
		local stripes = holder.MERstripes
		if not stripes then
			stripes = holder:CreateTexture(nil, "BORDER")
			stripes:SetTexture(STYLE_STRIPES, true, true)
			stripes:SetHorizTile(true)
			stripes:SetVertTile(true)
			stripes:SetBlendMode("ADD")
			holder.MERstripes = stripes
		end
		stripes:ClearAllPoints()
		stripes:Point("TOPLEFT", 1, -1)
		stripes:Point("BOTTOMRIGHT", -1, 1)
		stripes:Show()
	elseif holder.MERstripes then
		holder.MERstripes:Hide()
	end

	-- Gradient layer
	if createGradient then
		local tex = holder.MERgradient
		if not tex then
			tex = holder:CreateTexture(nil, "BORDER")
			tex:SetTexture(STYLE_GRADIENT)
			tex:SetVertexColor(0.3, 0.3, 0.3, 0.15)
			holder.MERgradient = tex
		end
		tex:SetInside(holder)
		tex:Show()
	elseif holder.MERgradient then
		holder.MERgradient:Hide()
	end
end

function F.AlmostEqual(a, b, epsilon)
	epsilon = epsilon or 0.001

	if type(a) ~= "number" or type(b) ~= "number" or E:IsSecretValue(a) or E:IsSecretValue(b) then
		return false
	end

	return abs(a - b) < epsilon
end

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
local perfectScale = baseScale / F.PixelPerfect()
local perfectMulti = perfectScale

function F.Dpi(value, frac)
	return F.Round(value * perfectMulti, frac)
end

function F.GetFontPath(font)
	font = font or I.General.DefaultFont

	local lsmFont = LSM:Fetch("font", F.FontOverride(font))
	if not lsmFont then
		lsmFont = LSM:Fetch("font", font)
	end -- backup to non-override font
	if not lsmFont then
		lsmFont = LSM:Fetch("font", I.General.DefaultFont)
	end -- backup to normal font if not found
	if not lsmFont then
		lsmFont = E.media.normFont
	end -- backup to elvui font if not found

	return lsmFont
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
	local overrides = F.GetDBFromPath("mui.general.fontOverride")
	local override = overrides and overrides[font]
	return (override and override ~= "DEFAULT") and override or font
end

function F.FontStyleOverride(font, style)
	local overrides = F.GetDBFromPath("mui.general.fontStyleOverride")
	local override = overrides and overrides[font]
	return (override and override ~= "DEFAULT") and override or style
end

function F.GetStyledText(text)
	return E:TextGradient(text, 0.32941, 0.52157, 0.93333, 0.29020, 0.70980, 0.89412, 0.25882, 0.84314, 0.86667)
end

function F.SetFontSize(fs, size)
	fs:SetFont(F.GetFontPath(I.Fonts.Primary), size, "")
end

function F:CreateFS(size, text, color, anchor, x, y)
	local fs = self:CreateFontString(nil, "OVERLAY")
	F.SetFontSize(fs, size)
	fs:SetText(text)
	fs:SetWordWrap(false)
	if color == true then
		fs:SetTextColor(F.r, F.g, F.b)
	elseif color == "system" then
		fs:SetTextColor(1, 0.8, 0)
	elseif color == "info" then
		fs:SetTextColor(0.6, 0.8, 1)
	end
	if anchor and x and y then
		fs:SetPoint(anchor, x, y)
	else
		fs:SetPoint("CENTER", 1, 0)
	end

	return fs
end

function F.Position(anchor1, parent, anchor2, x, y, offset, negative)
	local offsetX = 0

	if offset then
		offsetX = F.CalculateUltrawideOffset()

		if negative then
			offsetX = offsetX * -1
		end
	end

	return format("%s,%s,%s,%d,%d", anchor1, parent, anchor2, F.Dpi(x) + offsetX, F.Dpi(y))
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
	r = E:NotSecretValue(r) and r or 0
	g = E:NotSecretValue(g) and g or 0
	b = E:NotSecretValue(b) and b or 0

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

local function clamp255(x)
	if type(x) ~= "number" or E:IsSecretValue(x) then
		return 255
	end
	if x < 0 then
		return 0
	end
	if x > 1 then
		x = 1
	end
	return math.floor(x * 255 + 0.5)
end

function F.GetTextWithColor(text, color)
	local r = clamp255(color and color.r or 1)
	local g = clamp255(color and color.g or 1)
	local b = clamp255(color and color.b or 1)
	return format("|cFF%02x%02x%02x%s|r", r, g, b, text)
end

function F.CalculateMultiplierColor(multi, r, g, b)
	local h, s, l = F.ConvertToHSL(r, g, b)
	return F.ConvertToRGB(F.ClampToHSL(h, s, l * multi))
end

function F.CalculateMultiplierColorArray(multi, colors)
	local r, g, b

	if colors.r then
		r, g, b = colors.r, colors.g, colors.b
	else
		r, g, b = colors[1], colors[2], colors[3]
	end

	return F.CalculateMultiplierColor(multi, r, g, b)
end

function F.FastColorGradient(perc, r1, g1, b1, r2, g2, b2)
	-- Secret percentages can't be compared, fall back to the start color
	if E:IsSecretValue(perc) then
		return r1, g1, b1
	elseif perc >= 1 then
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

---Number as string with a fixed amount of decimals (default 0)
function F.RoundNumber(number, decimals)
	if not number then
		return "0"
	end

	return format("%." .. (decimals or 0) .. "f", number)
end

function F.cOption(name, color)
	local hex
	if color == "orange" then
		hex = "|cffff7d0a%s |r"
	elseif color == "blue" then
		hex = "|cFF00c0fa%s |r"
	elseif color == "red" then
		hex = "|cFFFF0000%s |r"
	elseif color == "teal" then
		hex = "|cFF00c0fa%s |r"
	elseif color == "gradient" then
		hex = E:TextGradient(name, 1, 0.65, 0, 1, 0.65, 0, 1, 1, 1)
	else
		hex = "|cFFFFFFFF%s |r"
	end

	return (hex):format(name)
end

function F.mColorDatatext()
	local nhc, hc, myth, mythp, other, title, tip =
		E.db.mui.datatexts.datatextcolors.colornhc.hex,
		E.db.mui.datatexts.datatextcolors.colorhc.hex,
		E.db.mui.datatexts.datatextcolors.colormyth.hex,
		E.db.mui.datatexts.datatextcolors.colormythplus.hex,
		E.db.mui.datatexts.datatextcolors.colorother.hex,
		E.db.mui.datatexts.datatextcolors.colortitle.hex,
		E.db.mui.datatexts.datatextcolors.colortip.hex
	return nhc, hc, myth, mythp, other, title, tip
end

---Print message with MerathilisUI title prefix
---@param ... string|number Message parts to print
function F.Print(...)
	local count = select("#", ...)
	local parts = { ... }
	for i = 1, count do
		parts[i] = tostring(parts[i])
	end

	print(format("%s: %s", MER.Title, strjoin(" ", unpack(parts, 1, count))))
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
		message = format("%s: %s", MER.Title .. F.String.MERATHILISUI(L["Information"]), text)
	else
		message = format("%s: %s", MER.Title, text)
	end
	print(message)
end

do
	-- Tooltip Stuff
	local function HideTooltip()
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
			elseif self.color == "BLUE" or self.color == "info" then
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
		self:HookScript("OnLeave", HideTooltip)
	end

	function F:CreateGear(name)
		local bu = CreateFrame("Button", name, self)
		bu:SetSize(24, 24)
		bu.Icon = bu:CreateTexture(nil, "ARTWORK")
		bu.Icon:SetAllPoints()
		bu.Icon:SetTexture(MER.GearTex)
		bu.Icon:SetTexCoord(0, 0.5, 0, 0.5)
		bu:SetHighlightTexture(MER.GearTex)
		bu:GetHighlightTexture():SetTexCoord(0, 0.5, 0, 0.5)

		return bu
	end

	function F:CreateHelpInfo(tooltip)
		local bu = CreateFrame("Button", nil, self)
		bu:SetSize(40, 40)
		bu.Icon = bu:CreateTexture(nil, "ARTWORK")
		bu.Icon:SetAllPoints()
		bu.Icon:SetTexture(616343)
		bu:SetHighlightTexture(616343)
		if tooltip then
			F.AddTooltip(bu, "ANCHOR_BOTTOMLEFT", tooltip, "info", true)
		end

		return bu
	end
end

---Attach a Blizzard-style pulsing "NEW" badge (as seen on the Game Menu's Options button) to
---call out new features. Anchors like a plain `:SetPoint()` call - defaults to CENTER-ing on
---self's own TOPRIGHT corner when the anchor args are omitted.
---@param a1 string|nil the badge's own anchor point (default "CENTER")
---@param relativeTo Frame|nil frame/region to anchor to (default self)
---@param a2 string|nil relativeTo's anchor point (default "TOPRIGHT")
---@param x number|nil x offset (default 0)
---@param y number|nil y offset (default 0)
---@param scale number|nil badge scale, matches Blizzard's own Game Menu usage (default 0.8)
---@param noAnimate boolean|nil set true to skip the pulsing glow animation
---@return Frame badge
function F:CreateNewFeatureBadge(a1, relativeTo, a2, x, y, scale, noAnimate)
	local shadowColor = _G.NEW_FEATURE_SHADOW_COLOR
	local text = _G.NEW_CAPS or _G.NEW or "NEW"
	scale = scale or 0.8

	-- `badge` is the anchor frame callers position/reposition via SetPoint -
	-- it stays unscaled (sized directly to the final on-screen size) so its
	-- own x/y offsets always mean real screen pixels, matching whatever a
	-- caller measured with GetStringWidth() etc. All the actual visuals live
	-- on `content`, a child scaled down to the requested size instead -
	-- scaling `badge` itself would otherwise scale the offsets passed to its
	-- own SetPoint too, throwing off any caller doing its own math on top.
	local badge = CreateFrame("Frame", nil, self)
	badge:SetSize(40 * scale, 20 * scale)
	badge:SetPoint(a1 or "CENTER", relativeTo or self, a2 or "TOPRIGHT", x or 0, y or 0)
	badge:SetFrameLevel(self:GetFrameLevel() + 5)

	local content = CreateFrame("Frame", nil, badge)
	content:SetSize(40, 20)
	content:SetScale(scale)
	content:SetPoint("CENTER")

	local shadow = content:CreateFontString(nil, "OVERLAY", "GameFontNormal_NoShadow")
	shadow:SetPoint("CENTER", 0.5, -0.5)
	shadow:SetText(text)
	if shadowColor then
		shadow:SetTextColor(shadowColor:GetRGBA())
	else
		shadow:SetTextColor(0, 0, 0, 1)
	end

	local label = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	label:SetPoint("CENTER")
	label:SetText(text)
	if shadowColor then
		label:SetShadowColor(shadowColor:GetRGBA())
	end
	label:SetShadowOffset(1, -1)

	local glow = content:CreateTexture(nil, "OVERLAY")
	glow:SetAtlas("collections-newglow", true)
	glow:SetPoint("TOPLEFT", label, "TOPLEFT", -20, 10)
	glow:SetPoint("BOTTOMRIGHT", label, "BOTTOMRIGHT", 20, -10)

	if not noAnimate then
		local anim = glow:CreateAnimationGroup()
		anim:SetLooping("REPEAT")

		local fadeOut = anim:CreateAnimation("Alpha")
		fadeOut:SetFromAlpha(1)
		fadeOut:SetToAlpha(0.5)
		fadeOut:SetDuration(1)
		fadeOut:SetOrder(1)

		local fadeIn = anim:CreateAnimation("Alpha")
		fadeIn:SetFromAlpha(0.5)
		fadeIn:SetToAlpha(1)
		fadeIn:SetDuration(1)
		fadeIn:SetOrder(2)

		badge:SetScript("OnShow", function()
			anim:Play()
		end)
		badge:SetScript("OnHide", function()
			anim:Stop()
		end)
		anim:Play()

		badge.Anim = anim
	end

	badge.Glow = glow
	badge.Label = label
	badge.Shadow = shadow

	return badge
end

---Show or hide a lazily-created F.CreateNewFeatureBadge cached on `holder[cacheKey]` - the
---common "create once, then just toggle" bookkeeping shared by every place that shows one
---(Options/Widgets/TabGroup.lua's tabs, Options/Widgets/SectionHeader.lua's headers), so
---each of those only has to supply its own shouldShow check and anchor.
---@param holder table frame/widget table to cache the badge on
---@param cacheKey string field name to cache the badge under (e.g. "merNewBadge")
---@param shouldShow boolean|nil whether the badge should currently be shown
---@param createBadge fun():Frame called once, lazily, the first time it's needed
---@return Frame|nil badge the cached badge, if `shouldShow` (nil otherwise)
function F.SyncNewFeatureBadge(holder, cacheKey, shouldShow, createBadge)
	if shouldShow then
		local badge = holder[cacheKey]
		if not badge then
			badge = createBadge()
			holder[cacheKey] = badge
		end
		badge:Show()
		return badge
	elseif holder[cacheKey] then
		holder[cacheKey]:Hide()
	end
end

-- Marker prepended to a `type = "header"` option's `name` text to flag it
-- for a pulsing NEW badge once rendered by Options/Widgets/SectionHeader.lua
-- - the text is the only thing that reliably reaches the widget
-- AceConfigDialog builds for a header, unlike a stable per-instance key.
-- AceConfigRegistry also strictly validates option tables against a fixed
-- key whitelist, so this couldn't be a plain extra field on the option
-- either way. Control chars, not real text, so it can't collide with real
-- header names and needs no pattern-escaping for plain string:find/gsub.
--
-- NOT used for tabs (Options/Widgets/TabGroup.lua) even though `name` reaches
-- those too - confirmed live (2026-09-10) to cause two real bugs there: a
-- tab's `name` also doubles as AceConfigDialog's alphabetical sort key, so
-- the marker (sorting before any real letter) silently reordered the tab
-- strip; and AceConfigDialog rebuilds a tab group's buttons more than once
-- per page load, so by the second rebuild the marker was already stripped
-- from the *previous* pass and got read back as "not new", flipping the
-- badge off again. Tabs use the identity-based F.MarkTabAsNew/
-- F.NewFeatureTabs below instead, which never touches `name` at all.
F.NewFeatureMarker = "\002MER_NEW\002"

---Prefix a header option's `name` with the marker Options/Widgets/
---SectionHeader.lua looks for and strips back out, turning it into a pulsing
---NEW badge next to the header text. Remove the wrapping again once that
---section isn't new anymore. Headers only - see F.MarkTabAsNew for tabs.
---@param text string
---@return string
function F.NewFeatureText(text)
	return F.NewFeatureMarker .. (text or "")
end

-- MerathilisUI's own equivalent of ElvUI's E.NewSign: a plain, static inline
-- text snippet, not a real widget, so it can be concatenated into literally
-- any string - a `description`/`desc`/tooltip, not just a header or tab name
-- (those go through F.NewFeatureText/F.MarkTabAsNew instead, which need an
-- actual widget to attach a real animated F.CreateNewFeatureBadge to). No
-- animation - leading with the same "collections-newglow" atlas F.
-- CreateNewFeatureBadge uses was tried first, but that atlas is built for
-- additive blending on a real Frame ("ADD" blend); plain inline `|A:...|a`
-- markup has no blend-mode control, so it just rendered as an ugly solid
-- blob instead of a glow. E.NewSign's own small icon renders fine inline at
-- this size (it's what E.NewSign already is), so keep that for the
-- Blizzard-ish look and add our own NEW text next to it - drop-in
-- replacement for `E.NewSign .. text`.
F.NewSign = E.NewSign .. format("|cffffd200%s|r ", _G.NEW_CAPS or _G.NEW or "NEW")

-- Marker appended to the *end* of a `type = "description"` option's `name`
-- text to flag it for a real pulsing "NEW" badge (F.CreateNewFeatureBadge -
-- the same one used on tabs), picked up by Options/Widgets/
-- NewFeatureLabel.lua's "MERNewFeatureLabel" dialogControl. Distinct from
-- F.NewFeatureMarker (which SectionHeader.lua strips from the *start* of a
-- header's name) because a Label's text can be long and word-wrapped, so the
-- badge has to be anchored after the last rendered line rather than the
-- start - NewFeatureLabel measures that line's width instead of assuming it.
F.NewFeatureTrailingMarker = "\002MER_NEW_END\002"

---Suffix a `type = "description"` option's `name` with the marker
---Options/Widgets/NewFeatureLabel.lua looks for and strips back out, turning
---it into a pulsing NEW badge right after the text. Also requires
---`dialogControl = "MERNewFeatureLabel"` on the same option. Remove both
---again once that text isn't new anymore.
---@param text string
---@return string
function F.NewFeatureTrailingText(text)
	return (text or "") .. F.NewFeatureTrailingMarker
end

-- Tabs marked "new" via F.MarkTabAsNew, read by Options/Widgets/TabGroup.lua
-- to show a pulsing NEW badge. Kept as a side table keyed by the option's
-- args-table key (tab.value) rather than embedding a marker in `name` like
-- F.NewFeatureText does for headers - see the comment on F.NewFeatureMarker
-- above for why that approach doesn't work for tabs specifically.
F.NewFeatureTabs = {}

---Mark an option-tree tab (a `type = "group"` entry that renders as a tab,
---keyed by its args table key, e.g. "buffReminder") as "new" so it gets a
---pulsing NEW badge (Options/Widgets/TabGroup.lua). Call this next to the
---option's own definition; remove the call again once it isn't new anymore.
---@param key string
function F.MarkTabAsNew(key)
	F.NewFeatureTabs[key] = true
end

do -- Tooltip scanning stuff. Credits siweia, with permission.
	local iLvlDB = {}
	local itemLevelString = "^" .. gsub(ITEM_LEVEL, "%%d", "")
	local enchantString = gsub(ENCHANTED_TOOLTIP_LINE, "%%s", "(.+)")

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
end

--[[----------------------------------
--	Skin Functions
--]]
----------------------------------
do
	-- Keep tab labels centered when Blizzard (de)selects a tab
	local function ResetTabAnchor(tab)
		local text = tab.Text or (tab.GetName and _G[tab:GetName() .. "Text"])
		if text then
			text:SetPoint("CENTER", tab)
		end
	end

	hooksecurefunc("PanelTemplates_SelectTab", ResetTabAnchor)
	hooksecurefunc("PanelTemplates_DeselectTab", ResetTabAnchor)
end

-- Inform us of the patch info we play on.
MER.WoWPatch, MER.WoWBuild, MER.WoWPatchReleaseDate, MER.TocVersion = GetBuildInfo()
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

	self:CreateBackdrop()
	self.backdrop:SetAllPoints()

	self.Icon = self:CreateTexture(nil, "ARTWORK")
	self.Icon:Point("TOPLEFT", E.mult, -E.mult)
	self.Icon:Point("BOTTOMRIGHT", -E.mult, E.mult)
	self.Icon:SetTexCoords()

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

function F.Icon(icon, x, y)
	if icon then
		return format("|T%s:%s:%s:0:0:64:64:4:60:4:60|t", icon, x or 16, y or 16)
	end
end

function F:SetBorderColor()
	self:SetBackdropBorderColor(0, 0, 0, 1)
end

function F:CreateCheckBox()
	local cb = CreateFrame("CheckButton", nil, self, "InterfaceOptionsBaseCheckButtonTemplate")
	cb:SetScript("OnClick", nil)
	ES:HandleCheckBox(cb)

	cb.Type = "CheckBox"
	return cb
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

function F.GetMedia(mediaPath, mediaName)
	local mediaFile = mediaPath[mediaName] or mediaName
	return mediaFile
end

function F.AddMedia(mediaType, mediaFile, lsmName, lsmType, lsmMask)
	local path = I.MediaPaths[mediaType]
	if path then
		local key = gsub(mediaFile, "%.%w-$", "")
		local file = path .. mediaFile

		local pathKey = I.MediaKeys[mediaType]
		if pathKey then
			local mediaTable = I.Media[pathKey]

			local subFolder, fileName = key:match("^(.-)/([^/]+)$")
			if subFolder and fileName then
				for folder in subFolder:gmatch("[^/]+") do
					mediaTable[folder] = mediaTable[folder] or {}
					mediaTable = mediaTable[folder]
				end
				mediaTable[fileName] = file
			else
				mediaTable[key] = file
			end
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

function F:Texture_OnEnter()
	if self:IsEnabled() then
		if self.backdrop then
			self.backdrop:SetBackdropColor(F.r, F.g, F.b, 0.25)
		else
			self.__texture:SetVertexColor(0, 0.6, 1, 1)
		end
	end
end

function F:Texture_OnLeave()
	if self.backdrop then
		self.backdrop:SetBackdropColor(0, 0, 0, 0.25)
	else
		self.__texture:SetVertexColor(1, 1, 1, 1)
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

do
	local function HandleResult(success, ...)
		if success then
			return ...
		end
	end

	---Call func(...) and report errors through the error handler instead of aborting the caller
	function F.ProtectedCall(func, ...)
		return HandleResult(xpcall(func, F.Developer.ThrowError, ...))
	end
end

do
	local eventManagerDelayed = {}
	local flushPending = false

	local function flushDelayed()
		flushPending = false
		for _, func in ipairs(eventManagerDelayed) do
			F.ProtectedCall(unpack(func))
		end
		eventManagerDelayed = {}
	end

	function F.EventManagerDelayed(func, ...)
		tinsert(eventManagerDelayed, { func, ... })
		if not flushPending then
			flushPending = true
			E:Delay(0, flushDelayed)
		end
	end
end

---Move frame by offset while preserving all anchor points
---@param frame Frame The frame to move
---@param x number X offset to apply
---@param y number Y offset to apply
function F.Move(frame, x, y)
	if not frame or not frame.ClearAllPoints then
		return
	end

	---@type table[] Store all current anchor points
	local positionData = {}

	for i = 1, frame:GetNumPoints() do
		local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(i)
		positionData[i] = { point, relativeTo, relativePoint, xOfs, yOfs }
	end

	frame:ClearAllPoints()

	for _, data in pairs(positionData) do
		local point, relativeTo, relativePoint, xOfs, yOfs = unpack(data)
		F.CallMethod(frame, "SetPoint", point, relativeTo, relativePoint, xOfs + x, yOfs + y)
	end
end

---Safely calls a method on a frame object, with fallback support for internal method variants.
---This function first attempts to call an internal version of the method (prefixed with "__"),
---and if that doesn't exist, falls back to calling the standard method name.
---@param frame any The frame object that contains the method to be called
---@param methodKey string The name of the method to call (without any prefixes)
---@param ... any Variable arguments that will be passed to the called method
function F.CallMethod(frame, methodKey, ...)
	local internalMethodKey = "__" .. methodKey
	if frame[internalMethodKey] then
		return frame[internalMethodKey](frame, ...)
	end

	return frame[methodKey](frame, ...)
end

function F.IsSkyriding()
	-- Use GetGlidingInfo to check if player is in a Dragonriding zone on an applicable mount
	local _, canGlide = C_PlayerInfo_GetGlidingInfo()
	return canGlide == true
end

function F:SecureHook(object, method, handler)
	if not handler then
		method, handler, object = object, method, nil
	end

	if object and type(object) == "string" then
		object = _G[object]
	end

	if object then
		if object[method] then
			hooksecurefunc(object, method, handler)
		else
			F.Developer.ThrowError(format("Attempting to hook a non existing function %s", method))
		end
	else
		if _G[method] then
			hooksecurefunc(method, handler)
		else
			F.Developer.ThrowError(format("Attempting to hook a non existing function %s", method))
		end
	end
end

function F.IsUltrawide()
	--HQ Resolution
	if E.physicalWidth >= 3440 and (E.physicalHeight == 1440 or E.physicalHeight == 1600) then
		return 2560
	end --DQHD, DQHD+, WQHD & WQHD+

	--Low resolution
	if E.physicalWidth >= 2560 and (E.physicalHeight == 1080 or E.physicalHeight == 1200) then
		return 1920
	end --WFHD, DFHD & WUXGA
end

function F.CalculateUltrawideOffset()
	if F.IsUltrawide() then
		return ((E.physicalWidth - F.IsUltrawide()) / 2) * F.PixelPerfect()
	else
		return 0
	end
end
