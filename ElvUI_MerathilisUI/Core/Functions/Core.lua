local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local S = MER:GetModule('MER_Skins')
local LSM = E.LSM

local _G = _G
local ipairs, pairs, pcall, print, select, tonumber, type = ipairs, pairs, pcall, print, select, tonumber, type
local format, gsub, match, split, strfind = string.format, string.gsub, string.match, string.split, strfind
local strmatch, strlen, strsub = strmatch, strlen, strsub
local tconcat, tinsert, tremove, twipe = table.concat, table.insert, table.remove, table.wipe
local max, min, modf = math.max, math.min, math.modf

local CreateFrame = CreateFrame
local GetAchievementInfo = GetAchievementInfo
local GetItemInfo = GetItemInfo
local GetSpellInfo = GetSpellInfo
local GetContainerItemID = GetContainerItemID or (C_Container and C_Container.GetContainerItemID)
local GetContainerNumSlots = GetContainerNumSlots or (C_Container and C_Container.GetContainerNumSlots)
local UnitBuff = UnitBuff
local UnitIsGroupAssistant = UnitIsGroupAssistant
local UnitIsGroupLeader = UnitIsGroupLeader
local IsEveryoneAssistant = IsEveryoneAssistant
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid

local C_TooltipInfo_GetInventoryItem = C_TooltipInfo and C_TooltipInfo.GetInventoryItem
local C_TooltipInfo_GetBagItem = C_TooltipInfo and C_TooltipInfo.GetBagItem
local C_TooltipInfo_GetHyperlink = C_TooltipInfo and C_TooltipInfo.GetHyperlink

-- Scaling
function F.PerfectScale(n)
	local m = E.mult
	return (m == 1 or n == 0) and n or (n * m)
end

function F.PixelPerfect()
	local perfectScale = 768 / E.physicalHeight
	if E.physicalHeight == 2160 or E.physicalHeight == 2880 then perfectScale = perfectScale * 2 end
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

function F.SetFontSizeScaled(value, clamp)
	value = E.db.mui and E.db.mui.general and E.db.mui.general.fontScale and (value + E.db.mui.general.fontScale) or
		value
	clamp = (clamp and (E.db.mui and E.db.mui.general and E.db.mui.general.fontScale) and (clamp + E.db.mui.general.fontScale) or clamp) or
		0

	return F.Clamp(F.Clamp(F.Round(value * perfectScale), clamp or 0, 64), 8, 64)
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
	if h < 0 then h = h + 1 end
	if h > 1 then h = h - 1 end

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

	if l > 0 and l < 0.5 then s = colorDelta / (maxColor + minColor) end
	if l >= 0.5 and l < 1 then s = colorDelta / (2 - maxColor - minColor) end

	if colorDelta > 0 then
		if maxColor == r and maxColor ~= g then h = h + (g - b) / colorDelta end
		if maxColor == g and maxColor ~= b then h = h + 2 + (b - r) / colorDelta end
		if maxColor == b and maxColor ~= r then h = h + 4 + (r - g) / colorDelta end
		h = h / 6
	end

	if h < 0 then h = h + 1 end
	if h > 1 then h = h - 1 end

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

function F.cOption(name, color)
	local hex
	if color == 'orange' then
		hex = '|cffff7d0a%s |r'
	elseif color == 'blue' then
		hex = '|cFF00c0fa%s |r'
	elseif color == 'red' then
		hex = '|cFFFF0000%s |r'
	elseif color == 'gradient' then
		hex = E:TextGradient(name, 1, 0.65, 0, 1, 0.65, 0, 1, 1, 1)
	else
		hex = '|cFFFFFFFF%s |r'
	end

	return (hex):format(name)
end

do
	local gradientLine =
		E:TextGradient(
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
	if msgtype == 'error' then
		message = format("%s: %s", MER.Title .. MER.RedColor .. L["Error"] .. "|r", text)
	elseif msgtype == 'warning' then
		message = format("%s: %s", MER.Title .. MER.YellowColor .. L["Warning"] .. "|r", text)
	elseif msgtype == 'info' then
		message = format("%s: %s", MER.Title .. MER.InfoColor .. L["Information"] .. "|r", text)
	end
	print(message)
end

function F.PrintURL(url)
	return format("|cFF00c0fa[|Hurl:%s|h%s|h]|r", url, url)
end

function F.TablePrint(tbl, indent)
	if not indent then indent = 0 end

	local formatting
	for k, v in pairs(tbl) do
		formatting = string.rep("  ", indent) .. k .. ": "
		if type(v) == "table" then
			print(formatting)
			F.TablePrint(v, indent + 1)
		elseif type(v) == "boolean" then
			print(formatting .. tostring(v))
		else
			print(formatting .. v)
		end
	end
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
			if self.color == 'CLASS' then
				r, g, b = F.r, F.g, F.b
			elseif self.color == 'SYSTEM' then
				r, g, b = 1, 0.8, 0
			elseif self.color == 'BLUE' then
				r, g, b = 0.6, 0.8, 1
			elseif self.color == 'RED' then
				r, g, b = 0.9, 0.3, 0.3
			elseif self.color == 'WHITE' then
				r, g, b = 1, 1, 1
			end
			if self.blankLine then
				_G.GameTooltip:AddLine(' ')
			end

			_G.GameTooltip:AddLine(self.text, r, g, b, 1)
		end

		_G.GameTooltip:Show()
	end

	function F:AddTooltip(anchor, text, color, showTips)
		self.anchor = anchor
		self.text = text
		self.color = color
		if showTips then self.title = L["Tips"] end
		self:HookScript('OnEnter', Tooltip_OnEnter)
		self:HookScript('OnLeave', F.HideTooltip)
	end
end

-- Glow Parent
function F:CreateGlowFrame(size)
	local frame = CreateFrame("Frame", nil, self)
	frame:SetPoint("CENTER")
	frame:SetSize(size + 4, size + 4)

	return frame
end

-- LocPanel
function F.GetIconFromID(type, id)
	local path
	if type == "item" then
		path = select(10, GetItemInfo(id))
	elseif type == "spell" then
		path = select(3, GetSpellInfo(id))
	elseif type == "achiev" then
		path = select(10, GetAchievementInfo(id))
	end
	return path or nil
end

function F.GetSpell(id)
	local name = GetSpellInfo(id)
	return name
end

function F.SplitList(list, variable, cleanup)
	if cleanup then twipe(list) end

	for word in variable:gmatch('%S+') do
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
			local data = C_TooltipInfo_GetInventoryItem(arg1, arg2)
			if not data then return end

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
						slotData.gems[num] = format("Interface\\ItemSocketingFrame\\UI-EmptySocket-%s",
							lineData.socketType)
					end
				end
			end

			return slotData
		else
			if iLvlDB[link] then return iLvlDB[link] end

			local data
			if arg1 and type(arg1) == "string" then
				data = C_TooltipInfo_GetInventoryItem(arg1, arg2)
			elseif arg1 and type(arg1) == "number" then
				data = C_TooltipInfo_GetBagItem(arg1, arg2)
			else
				data = C_TooltipInfo_GetHyperlink(link, nil, nil, true)
			end
			if not data then return end

			for i = 2, 5 do
				local lineData = data.lines[i]
				if not lineData then break end
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
			local data = C_TooltipInfo.GetHyperlink(format("unit:Creature-0-0-0-0-%d", npcID))
			local lineData = data and data.lines
			if lineData then
				if DB.isPatch10_1 then
					name = lineData[1] and lineData[1].leftText
				else
					local argVal = lineData[1] and lineData[1].args
					if argVal then
						name = argVal[2] and argVal[2].stringVal
					end
				end
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
		local data = C_TooltipInfo_GetBagItem(bagID, slotID)
		local lineData = data and data.lines
		if not lineData then return end

		for i = #lineData, 1, -1 do
			local line = lineData[i]
			if line.price then return false end
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
	F.HiddenFrame = CreateFrame('Frame')
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
		if not text then text = self:GetText() end
		if not text or text == "" then return end

		local newText, count = gsub(text, "|T([^:]-):[%d+:]+|t", "|T%1:14:14:0:0:64:64:5:59:5:59|t")
		if count > 0 then self:SetFormattedText("%s", newText) end
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
		local name, _, _, _, _, _, unitCaster = UnitBuff("player", i)
		if not name then break end
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
	if not group then print("U wot m8?") end

	if group == "marks" or group == "all" then
		E:CopyTable(E.db.mui.raidmarkers, P.raidmarkers)
		E:ResetMovers(L["Raid Marker Bar"])
	end
	E:UpdateAll()
end

-- Movable Config Buttons
local function MovableButton_Match(s, v)
	local m1, m2, m3, m4 = "^" .. v .. "$", "^" .. v .. ",", "," .. v .. "$", "," .. v .. ","
	return (match(s, m1) and m1) or (match(s, m2) and m2) or (match(s, m3) and m3) or (match(s, m4) and v .. ",")
end

function F.MovableButtonSettings(db, key, value, remove, movehere)
	local str = db[key]
	if not db or not str or not value then return end

	local found = MovableButton_Match(str, E:EscapeString(value))
	if found and movehere then
		local tbl, sv, sm = { split(",", str) }
		for i in ipairs(tbl) do
			if tbl[i] == value then sv = i elseif tbl[i] == movehere then sm = i end
			if sv and sm then break end
		end
		tremove(tbl, sm)
		tinsert(tbl, sv, movehere)

		db[key] = tconcat(tbl, ',')
	elseif found and remove then
		db[key] = gsub(str, found, "")
	elseif not found and not remove then
		db[key] = (str == '' and value) or (str .. "," .. value)
	end
end

function F.CreateMovableButtons(Order, Name, CanRemove, db, key)
	local moveItemFrom, moveItemTo

	local config = {
		order = Order,
		dragdrop = true,
		type = "multiselect",
		name = Name,
		dragOnLeave = function() end, --keep this here
		dragOnEnter = function(info)
			moveItemTo = info.obj.value
		end,
		dragOnMouseDown = function(info)
			moveItemFrom, moveItemTo = info.obj.value, nil
		end,
		dragOnMouseUp = function(info)
			F.MovableButtonSettings(db, key, moveItemTo, nil, moveItemFrom) --add it in the new spot
			moveItemFrom, moveItemTo = nil, nil
		end,
		stateSwitchGetText = function(info, TEXT)
			local text = GetItemInfo(tonumber(TEXT))
			info.userdata.text = text
			return text
		end,
		stateSwitchOnClick = function(info)
			F.MovableButtonSettings(db, key, moveItemFrom)
		end,
		values = function()
			local str = db[key]
			if str == "" then return nil end
			return { split(",", str) }
		end,
		get = function(info, value)
			local str = db[key]
			if str == "" then return nil end
			local tbl = { split(",", str) }
			return tbl[value]
		end,
		set = function(info, value) end,
	}

	if CanRemove then --This allows to remove
		config.dragOnClick = function(info)
			F.MovableButtonSettings(db, key, moveItemFrom, true)
		end
	end

	return config
end

--[[----------------------------------
--	Dropdown Menu
--]]
----------------------------------
do
	F.EasyMenu = CreateFrame('Frame', MER.Title .. 'EasyMenu', E.UIParent, 'UIDropDownMenuTemplate')
end

-- Inform us of the patch info we play on.
MER.WoWPatch, MER.WoWBuild, MER.WoWPatchReleaseDate, MER.TocVersion = GetBuildInfo()
MER.WoWBuild = select(2, GetBuildInfo())
MER.WoWBuild = tonumber(MER.WoWBuild)

_G["SLASH_WOWVERSION1"], _G["SLASH_WOWVERSION2"] = "/patch", "/version"
SlashCmdList["WOWVERSION"] = function()
	print("Patch:", MER.WoWPatch .. ", " .. "Build:", MER.WoWBuild .. ", " .. "Released",
		MER.WoWPatchReleaseDate .. ", " .. "Interface:", MER.TocVersion)
end

-- Icon Style
function F.PixelIcon(self, texture, highlight)
	if not self then return end

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
		self.HL:SetColorTexture(1, 1, 1, .25)
		self.HL:SetAllPoints(self.Icon)
	end
end

-- Role Icons
function F.ReskinRole(self, role)
	if self.background then self.background:SetTexture("") end
	local cover = self.cover or self.Cover
	if cover then cover:SetTexture("") end

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
	if not file then return end

	local width, height, txLeft, txRight, txTop, txBottom = info.width, info.height, info.leftTexCoord,
		info.rightTexCoord, info.topTexCoord, info.bottomTexCoord
	local atlasWidth = width / (txRight - txLeft)
	local atlasHeight = height / (txBottom - txTop)

	return format("|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t", file, (sizeX or 0), (sizeY or 0), atlasWidth, atlasHeight,
		atlasWidth * txLeft, atlasWidth * txRight, atlasHeight * txTop, atlasHeight * txBottom)
end

-- Check Textures
local txframe = CreateFrame('Frame')
local tx = txframe:CreateTexture()

function F:TextureExists(path)
	if not path or path == '' then
		return F.DebugPrint('Path not valid or defined.', 'error')
	end
	tx:SetTexture('?')
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
				self.bg:SetBackdropColor(F.r, F.g, F.b, .25)
			else
				self.__texture:SetVertexColor(0, .6, 1, 1)
			end
		end
	end

	function F:Texture_OnLeave()
		if self.bg then
			self.bg:SetBackdropColor(0, 0, 0, .25)
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
