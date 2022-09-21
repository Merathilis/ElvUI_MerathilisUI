local MER, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.LSM

local _G = _G
local ipairs, pairs, pcall, print, select, tonumber, type, unpack = ipairs, pairs, pcall, print, select, tonumber, type, unpack
local min = min
local abs = abs
local find, format, gsub, match, split, strfind = string.find, string.format, string.gsub, string.match, string.split, strfind
local strmatch, strlen, strsub = strmatch, strlen, strsub
local tconcat, tinsert, tremove, twipe = table.concat, table.insert, table.remove, table.wipe

local CreateFrame = CreateFrame
local GetAchievementInfo = GetAchievementInfo
local GetClassColor = GetClassColor
local GetItemInfo = GetItemInfo
local GetSpellInfo = GetSpellInfo
local GetContainerItemID = GetContainerItemID
local GetContainerItemLink = GetContainerItemLink
local GetContainerNumSlots = GetContainerNumSlots
local GetSpellDescription = GetSpellDescription
local PickupContainerItem = PickupContainerItem
local DeleteCursorItem = DeleteCursorItem
local UnitBuff = UnitBuff
local UnitClass = UnitClass
local UnitIsGroupAssistant = UnitIsGroupAssistant
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitIsPlayer = UnitIsPlayer
local UnitIsTapDenied = UnitIsTapDenied
local UnitReaction = UnitReaction
local IsEveryoneAssistant = IsEveryoneAssistant
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid

local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local UIParent = UIParent
local C_Covenants_GetCovenantData = C_Covenants and C_Covenants.GetCovenantData
local C_Covenants_GetActiveCovenantID = C_Covenants and C_Covenants.GetActiveCovenantID

--[[----------------------------------
--	Color Functions
--]]----------------------------------
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

	["NPCFRIENDLY"] = { r1 = 0.30, g1 = 0.85, b1 = 0.2, r2 = 0.34, g2 = 0.62, b2 = 0.40 },
	["NPCNEUTRAL"] = { r1 = 0.71, g1 = 0.63, b1 = 0.15, r2 = 1, g2 = 0.85, b2 = 0.20 },
	["NPCUNFRIENDLY"] = { r1 = 0.84, g1 = 0.30, b1 = 0, r2 = 0.83, g2 = 0.45, b2 = 0 },
	["NPCHOSTILE"] = { r1 = 0.31, g1 = 0.06, b1 = 0.07, r2 = 1, g2 = 0.15, b2 = 0.15 },

	["TAPPED"] = { r1 = 0.6, g1 = 0.6, b1 = 0.60, r2 = 0, g2 = 0, b2 = 0 },

	["GOODTHREAT"] = { r1 = 0.1999995559454, g1 = 0.7098023891449, b1 = 0, r2 = 1, g2 = 0, b2 = 0 },
	["BADTHREAT"] = { r1 = 0.99999779462814, g1 = 0.1764702051878, b1 = 0.1764702051878, r2 = 1, g2 = 0, b2 = 0 },
	["GOODTHREATTRANSITION"] = { r1 = 0.99999779462814, g1 = 0.85097849369049, b1 = 0.1999995559454, r2 = 1, g2 = 0, b2 = 0 },
	["BADTHREATTRANSITION"] = { r1 = 0.99999779462814, g1 = 0.50980281829834, b1 = 0.1999995559454, r2 = 1, g2 = 0, b2 = 0 },
	["OFFTANK"] = { r1 = 0.95686066150665, g1 = 0.54901838302612, b1 = 0.72941017150879, r2 = 1, g2 = 0, b2 = 0 },
	["OFFTANKBADTHREATTRANSITION"] = { r1 = 0.77646887302399, g1 = 0.60784178972244, b1 = 0.4274500310421, r2 = 1, g2 = 0, b2 = 0 },
	["OFFTANKGOODTHREATTRANSITION"] = { r1 = 0.37646887302399, g1 = 0.90784178972244, b1 = 0.9274500310421, r2 = 1, g2 = 0, b2 = 0 }
}

F.ClassColors = {}
local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
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
		return  1, 1, 1
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
			return F.ClassGradient[unitclass].r2, F.ClassGradient[unitclass].g2, F.ClassGradient[unitclass].b2, 1, F.ClassGradient[unitclass].r1, F.ClassGradient[unitclass].g1, F.ClassGradient[unitclass].b1, 1
		else
			return F.ClassGradient[unitclass].r2, F.ClassGradient[unitclass].g2, F.ClassGradient[unitclass].b2, F.ClassGradient[unitclass].r1, F.ClassGradient[unitclass].g1, F.ClassGradient[unitclass].b1
		end
	else
		if alpha then
			return F.ClassGradient[unitclass].r1, F.ClassGradient[unitclass].g1, F.ClassGradient[unitclass].b1, 1, F.ClassGradient[unitclass].r2, F.ClassGradient[unitclass].g2, F.ClassGradient[unitclass].b2, 1
		else
			return F.ClassGradient[unitclass].r1, F.ClassGradient[unitclass].g1, F.ClassGradient[unitclass].b1, F.ClassGradient[unitclass].r2, F.ClassGradient[unitclass].g2, F.ClassGradient[unitclass].b2
		end
	end
end

function F.GradientName(name, unitclass)
	local text = E:TextGradient(name, F.ClassGradient[unitclass].r2, F.ClassGradient[unitclass].g2, F.ClassGradient[unitclass].b2, F.ClassGradient[unitclass].r1, F.ClassGradient[unitclass].g1, F.ClassGradient[unitclass].b1)

	return text
end

do
	function F.RGBToHex(r, g, b)
		if r then
			if type(r) == 'table' then
				if r.r then
					r, g, b = r.r, r.g, r.b
				else
					r, g, b = unpack(r)
				end
			end
			return format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)
		end
	end

	function F.HexToRGB(hex)
		return tonumber('0x' .. strsub(hex, 1, 2)) / 255, tonumber('0x' .. strsub(hex, 3, 4)) / 255, tonumber('0x' .. strsub(hex, 5, 6)) / 255
	end
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

	text:FontTemplate(LSM:Fetch("font", db.name), db.size, db.style)
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

	text:FontTemplate(font or fontName, size or fontHeight, fontStyle or "OUTLINE")
	text:SetShadowColor(0, 0, 0, 0)
	text.SetShadowColor = E.noop
end

do
	local color = {
		start = { r = 1.000, g = 0.647, b = 0.008 },
		complete = { r = 0.180, g = 0.835, b = 0.451 }
	}

	function F.GetProgressColor(progress)
		local r = (color.complete.r - color.start.r) * progress + color.start.r
		local g = (color.complete.g - color.start.g) * progress + color.start.g
		local b = (color.complete.r - color.start.b) * progress + color.start.b

		-- algorithm to let the color brighter
		local addition = 0.35
		r = min(r + abs(0.5 - progress) * addition, r)
		g = min(g + abs(0.5 - progress) * addition, g)
		b = min(b + abs(0.5 - progress) * addition, b)

		return {r = r, g = g, b = b}
	end
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

function F.cOption(name, color)
	local hex
	if color == 'orange' then
		hex = '|cffff7d0a%s |r'
	elseif color == 'blue' then
		hex = '|cFF00c0fa%s |r'
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
		message = format("%s: %s", MER.Title..MER.RedColor..L["Error"].."|r", text)
	elseif msgtype == 'warning' then
		message = format("%s: %s", MER.Title..MER.YellowColor..L["Warning"].."|r", text)
	elseif msgtype == 'info' then
		message = format("%s: %s", MER.Title..MER.InfoColor..L["Information"].."|r", text)
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
			F.TablePrint(v, indent+1)
		elseif type(v) == "boolean" then
			print(formatting .. tostring(v))
		else
			print(formatting .. v)
		end
	end
end

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
		end
		if self.blankLine then
			_G.GameTooltip:AddLine(' ')
		end

		_G.GameTooltip:AddLine(self.text, r, g, b, 1)
	end

	_G.GameTooltip:Show()
end

function F:AddTooltip(anchor, text, color, blankLine)
	self.anchor = anchor
	self.text = text
	self.color = color
	self.blankLine = blankLine
	self:HookScript('OnEnter', Tooltip_OnEnter)
	self:HookScript('OnLeave', F.HideTooltip)
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

do -- Tooltip scanning stuff. Credits siweia, with permission.
	local iLvlDB = {}
	local itemLevelString = "^"..gsub(ITEM_LEVEL, "%%d", "")
	local RETRIEVING_ITEM_INFO = RETRIEVING_ITEM_INFO

	local tip = CreateFrame("GameTooltip", "mUI_ScanTooltip", nil, "GameTooltipTemplate")
	F.ScanTip = tip

	function F:InspectItemTextures()
		if not tip.gems then
			tip.gems = {}
		else
			wipe(tip.gems)
		end

		for i = 1, 5 do
			local tex = _G["mUI_ScanTooltipTexture"..i]
			local texture = tex and tex:IsShown() and tex:GetTexture()
			if texture then
				tip.gems[i] = texture
			end
		end

		return tip.gems
	end

	function F.GetItemLevel(link, arg1, arg2, fullScan)
		if fullScan then
			tip:SetOwner(UIParent, "ANCHOR_NONE")
			tip:SetInventoryItem(arg1, arg2)

			if not tip.slotInfo then tip.slotInfo = {} else wipe(tip.slotInfo) end

			local slotInfo = tip.slotInfo
			slotInfo.gems = F:InspectItemTextures()

			return slotInfo
		else
			if iLvlDB[link] then return iLvlDB[link] end

			tip:SetOwner(UIParent, "ANCHOR_NONE")
			if arg1 and type(arg1) == "string" then
				tip:SetInventoryItem(arg1, arg2)
			elseif arg1 and type(arg1) == "number" then
				tip:SetBagItem(arg1, arg2)
			else
				tip:SetHyperlink(link)
			end

			local firstLine = _G.mUI_ScanTooltipTextLeft1:GetText()
			if firstLine == RETRIEVING_ITEM_INFO then
				return "tooSoon"
			end

			for i = 2, 5 do
				local line = _G["mUI_ScanTooltipTextLeft"..i]
				if not line then break end

				local text = line:GetText()
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
--]]----------------------------------
do
	function F:ResetTabAnchor(size, outline)
		local text = self.Text or (self.GetName and _G[self:GetName().."Text"])
		if text then
			text:SetPoint("CENTER", self)
		end
	end
	hooksecurefunc("PanelTemplates_SelectTab", F.ResetTabAnchor)
	hooksecurefunc("PanelTemplates_DeselectTab", F.ResetTabAnchor)
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
local function MovableButton_Match(s,v)
	local m1, m2, m3, m4 = "^"..v.."$", "^"..v..",", ","..v.."$", ","..v..","
	return (match(s, m1) and m1) or (match(s, m2) and m2) or (match(s, m3) and m3) or (match(s, m4) and v..",")
end

function F.MovableButtonSettings(db, key, value, remove, movehere)
	local str = db[key]
	if not db or not str or not value then return end

	local found = MovableButton_Match(str, E:EscapeString(value))
	if found and movehere then
		local tbl, sv, sm = {split(",", str)}
		for i in ipairs(tbl) do
			if tbl[i] == value then sv = i elseif tbl[i] == movehere then sm = i end
			if sv and sm then break end
		end
		tremove(tbl, sm)
		tinsert(tbl, sv, movehere)

		db[key] = tconcat(tbl,',')

	elseif found and remove then
		db[key] = gsub(str, found, "")
	elseif not found and not remove then
		db[key] = (str == '' and value) or (str..","..value)
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
			return {split(",",str)}
		end,
		get = function(info, value)
			local str = db[key]
			if str == "" then return nil end
			local tbl = {split(",",str)}
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
--]]----------------------------------
do
	F.EasyMenu = CreateFrame('Frame', MER.Title .. 'EasyMenu', E.UIParent, 'UIDropDownMenuTemplate')
end

--[[----------------------------------
--	Text Functions
--]]----------------------------------
function F.CreateText(f, layer, size, outline, text, color, anchor, x, y)
	text = f:CreateFontString(nil, layer)
	text:FontTemplate(nil, size or 10, outline or "OUTLINE")
	text:SetHeight(text:GetStringHeight()+30)

	if text then
		text:SetText(text)
	else
		text:SetText("")
	end

	if color and type(color) == "boolean" then
		text:SetTextColor(F.r, F.g, F.b)
	elseif color == "system" then
		text:SetTextColor(1, .8, 0)
	elseif color == "info" then
		text:SetTextColor(0, .75, .98)
	elseif color == "red" then
		text:SetTextColor(1, 0, 0)
	elseif color == "white" then
		text:SetTextColor(1, 1, 1)
	end

	if (anchor and x and y) then
		text:Point(anchor, x, y)
	else
		text:Point("CENTER", 1, 0)
	end

	return text
end

-- Inform us of the patch info we play on.
MER.WoWPatch, MER.WoWBuild, MER.WoWPatchReleaseDate, MER.TocVersion = GetBuildInfo()
MER.WoWBuild = select(2, GetBuildInfo()) MER.WoWBuild = tonumber(MER.WoWBuild)

_G["SLASH_WOWVERSION1"], _G["SLASH_WOWVERSION2"] = "/patch", "/version"
SlashCmdList["WOWVERSION"] = function()
	print("Patch:", MER.WoWPatch..", ".. "Build:", MER.WoWBuild..", ".. "Released", MER.WoWPatchReleaseDate..", ".. "Interface:", MER.TocVersion)
end

-- Chat command to remove Heirlooms from the bags
function F.CleanupHeirlooms()
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local name = GetContainerItemLink(bag, slot)
			if name and find(name, "00ccff") then
				F.Print(L["Removed: "]..name)
				PickupContainerItem(bag, slot)
				DeleteCursorItem()
			end
		end
	end
end
MER:RegisterChatCommand("cleanboa", F.CleanupHeirlooms)

-- Fixes the issue when the dialog to release spirit does not come up.
function F.FixRelease()
	RetrieveCorpse()
	RepopMe()
end
MER:RegisterChatCommand("release", F.FixRelease)
MER:RegisterChatCommand("repop", F.FixRelease)

-- Covenant Crest: Credits BenikUI
function F.GetConvCrest()
	if not E.Retail then return end

	local covenantData = C_Covenants_GetCovenantData(C_Covenants_GetActiveCovenantID())
	local kit = covenantData and covenantData.textureKit or nil

	-- vertical position
	local vky = kit == "Kyrian" and 0
	local vve = kit == "Venthyr" and 18
	local vni = kit == "NightFae" and 16
	local vne = kit == "Necrolord" and 20

	local vert = vky or vve or vni or vne

	-- Height
	local hky = kit == "Kyrian" and 150
	local hve = kit == "Venthyr" and 120
	local hni = kit == "NightFae" and 134
	local hne = kit == "Necrolord" and 120

	local hei = hky or hve or hni or hne

	return kit, vert, hei
end

-- Icon Style
function F.PixelIcon(self, texture, highlight)
	if not self then return end

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
function F.GetRoleTexCoord(role)
	if role == "TANK" then
		return .32/9.03, 2.04/9.03, 2.65/9.03, 4.3/9.03
	elseif role == "DPS" or role == "DAMAGER" then
		return 2.68/9.03, 4.4/9.03, 2.65/9.03, 4.34/9.03
	elseif role == "HEALER" then
		return 2.68/9.03, 4.4/9.03, .28/9.03, 1.98/9.03
	elseif role == "LEADER" then
		return .32/9.03, 2.04/9.03, .28/9.03, 1.98/9.03
	elseif role == "READY" then
		return 5.1/9.03, 6.76/9.03, .28/9.03, 1.98/9.03
	elseif role == "PENDING" then
		return 5.1/9.03, 6.76/9.03, 2.65/9.03, 4.34/9.03
	elseif role == "REFUSE" then
		return 2.68/9.03, 4.4/9.03, 5.02/9.03, 6.7/9.03
	end
end

function F.ReskinRole(self, role)
	if self.background then self.background:SetTexture("") end
	local cover = self.cover or self.Cover
	if cover then cover:SetTexture("") end
	local texture = self.GetNormalTexture and self:GetNormalTexture() or self.texture or self.Texture or (self.SetTexture and self)
	if texture then
		texture:SetTexture(E.media.roleIcons)
		texture:SetTexCoord(F.GetRoleTexCoord(role))
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
	if not file then return end

	local width, height, txLeft, txRight, txTop, txBottom = info.width, info.height, info.leftTexCoord, info.rightTexCoord, info.topTexCoord, info.bottomTexCoord
	local atlasWidth = width / (txRight-txLeft)
	local atlasHeight = height / (txBottom-txTop)

	return format("|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t", file, (sizeX or 0), (sizeY or 0), atlasWidth, atlasHeight, atlasWidth*txLeft, atlasWidth*txRight, atlasHeight*txTop, atlasHeight*txBottom)
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
		local result = {pcall(target, ...)}
		if result and result[1] == true then
			tremove(result, 1)
			if callback(unpack(result)) then
				return
			end
		end
	end

	E:Delay(0.1, F.SetCallback, callback, target, times+1, ...)
end

do
	-- Handle close button
	function F:Texture_OnEnter()
		if self:IsEnabled() then
			if self.bg then
				self.bg:SetBackdropColor(cr, cg, cb, .25)
			else
				self.__texture:SetVertexColor(0, .6, 1)
			end
		end
	end

	function F:Texture_OnLeave()
		if self.bg then
			self.bg:SetBackdropColor(0, 0, 0, .25)
		else
			self.__texture:SetVertexColor(1, 1, 1)
		end
	end
end
