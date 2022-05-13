local MER, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.LSM

-- Cache global variables
-- Lua functions
local _G = _G
local assert, ipairs, pairs, pcall, print, select, tonumber, type, unpack = assert, ipairs, pairs, pcall, print, select, tonumber, type, unpack
local min = min
local abs = abs
local getmetatable = getmetatable
local find, format, gsub, match, split, strfind = string.find, string.format, string.gsub, string.match, string.split, strfind
local strmatch, strlen, strsplit, strsub = strmatch, strlen, strsplit, strsub
local tconcat, tinsert, tremove, twipe = table.concat, table.insert, table.remove, table.wipe
-- WoW API / Variables
local CreateFrame = CreateFrame
local EnumerateFrames = EnumerateFrames
local GameTooltip_Hide = GameTooltip_Hide
local GetAchievementInfo = GetAchievementInfo
local GetAddOnMetadata = GetAddOnMetadata
local GetBuildInfo = GetBuildInfo
local GetClassColor = GetClassColor
local GetItemInfo = GetItemInfo
local GetSpellInfo = GetSpellInfo
local GetContainerItemID = GetContainerItemID
local GetContainerItemLink = GetContainerItemLink
local GetContainerNumSlots = GetContainerNumSlots
local PickupContainerItem = PickupContainerItem
local DeleteCursorItem = DeleteCursorItem
local UnitBuff = UnitBuff
local UnitIsGroupAssistant = UnitIsGroupAssistant
local UnitIsGroupLeader = UnitIsGroupLeader
local IsEveryoneAssistant = IsEveryoneAssistant
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local BAG_ITEM_QUALITY_COLORS = BAG_ITEM_QUALITY_COLORS
local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local UIParent = UIParent
local C_Covenants_GetCovenantData = C_Covenants and C_Covenants.GetCovenantData
local C_Covenants_GetActiveCovenantID = C_Covenants and C_Covenants.GetActiveCovenantID
-- GLOBALS: NUM_BAG_SLOTS, hooksecurefunc, MER_NORMAL_QUEST_DISPLAY, MER_TRIVIAL_QUEST_DISPLAY

-- Class Color stuff
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

local defaultColor = { r = 1, g = 1, b = 1, a = 1 }
function F.unpackColor(color)
	if not color then color = defaultColor end

	return color.r, color.g, color.b, color.a
end

function F.CreateColorString(text, db)
	if not text or not type(text) == "string" then
		return
	end
	if not db or type(db) ~= "table" then
		return
	end
	local hex = db.r and db.g and db.b and E:RGBToHex(db.r, db.g, db.b) or "|cffffffff"

	return hex .. text .. "|r"
end

function F.CreateClassColorString(text, englishClass)
	if not text or not type(text) == "string" then
		return
	end
	if not englishClass or type(englishClass) ~= "string" then
		return
	end

	local r, g, b = GetClassColor(englishClass)
	local hex = r and g and b and E:RGBToHex(r, g, b) or "|cffffffff"

	return hex .. text .. "|r"
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
		return
	end
	if not db or type(db) ~= "table" then
		return
	end

	text:FontTemplate(LSM:Fetch("font", db.name), db.size, db.style)
end

function F.SetFontColorDB(text, db)
	if not text or not text.GetFont then
		return
	end
	if not db or type(db) ~= "table" then
		return
	end

	text:SetTextColor(db.r, db.g, db.b, db.a)
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

-- Tooltip scanning stuff. Credits siweia, with permission.
local iLvlDB = {}
local itemLevelString = gsub(_G.ITEM_LEVEL, "%%d", "")
local enchantString = gsub(_G.ENCHANTED_TOOLTIP_LINE, "%%s", "(.+)")
local essenceTextureID = 2975691
local tip = CreateFrame("GameTooltip", "mUI_iLvlTooltip", nil, "GameTooltipTemplate")

local texturesDB, essencesDB = {}, {}
function F.InspectItemTextures(clean, grabTextures)
	twipe(texturesDB)
	twipe(essencesDB)

	for i = 1, 5 do
		local tex = _G[tip:GetName().."Texture"..i]
		local texture = tex and tex:GetTexture()
		if texture then
			if grabTextures then
				if texture == essenceTextureID then
					local selected = (texturesDB[i-1] ~= essenceTextureID and texturesDB[i-1]) or nil
					essencesDB[i] = {selected, tex:GetAtlas(), texture}
					if selected then texturesDB[i-1] = nil end
				else
					texturesDB[i] = texture
				end
			end

			if clean then tex:SetTexture() end
		end
	end

	return texturesDB, essencesDB
end

function F.InspectItemInfo(text, iLvl, enchantText)
	local itemLevel = strfind(text, itemLevelString) and strmatch(text, "(%d+)%)?$")
	if itemLevel then iLvl = tonumber(itemLevel) end
	local enchant = strmatch(text, enchantString)
	if enchant then enchantText = enchant end

	return iLvl, enchantText
end

function F.GetItemLevel(link, arg1, arg2, fullScan)
	if fullScan then
		F.InspectItemTextures(true)
		tip:SetOwner(UIParent, "ANCHOR_NONE")
		tip:SetInventoryItem(arg1, arg2)

		local iLvl, enchantText, gems, essences
		gems, essences = F.InspectItemTextures(nil, true)

		for i = 1, tip:NumLines() do
			local line = _G[tip:GetName().."TextLeft"..i]
			if line then
				local text = line:GetText() or ""
				iLvl, enchantText = F.InspectItemInfo(text, iLvl, enchantText)
				if enchantText then break end
			end
		end

		return iLvl, enchantText, gems, essences
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

		for i = 2, 5 do
			local line = _G[tip:GetName().."TextLeft"..i]
			if line then
				local text = line:GetText() or ""
				local found = strfind(text, itemLevelString)
				if found then
					local level = strmatch(text, "(%d+)%)?$")
					iLvlDB[link] = tonumber(level)
					break
				end
			end
		end

		return iLvlDB[link]
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
		E:CopyTable(E.db.mui.raidmarkers, P.mui.raidmarkers)
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

-- frame text
function F.CreateText(f, layer, size, outline, text, classcolor, anchor, x, y)
	local text = f:CreateFontString(nil, layer)
	text:FontTemplate(nil, size or 10, outline or "OUTLINE")
	text:SetHeight(text:GetStringHeight()+30)

	if text then
		text:SetText(text)
	else
		text:SetText("")
	end

	if classcolor and type(classcolor) == "boolean" then
		text:SetTextColor(F.r, F.g, F.b)
	elseif classcolor == "system" then
		text:SetTextColor(1, .8, 0)
	elseif classcolor == "white" then
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
_G["SLASH_WOWVERSION1"], _G["SLASH_WOWVERSION2"] = "/patch", "/version"
SlashCmdList["WOWVERSION"] = function()
	MER:Print("Patch:", MER.WoWPatch..", ".. "Build:", MER.WoWBuild..", ".. "Released", MER.WoWPatchReleaseDate..", ".. "Interface:", MER.TocVersion)
end

-- Chat command to remove Heirlooms from the bags
function F.CleanupHeirlooms()
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local name = GetContainerItemLink(bag, slot)
			if name and find(name, "00ccff") then
				MER:Print(L["Removed: "]..name)
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

-- Personal Dev use only
-- We will add more of my names as we go.
MER.IsDev = {
	["Asragoth"] = true,
	["Damará"] = true,
	["Jazira"] = true,
	["Jústice"] = true,
	["Maithilis"] = true,
	["Mattdemôn"] = true,
	["Melisendra"] = true,
	["Merathilis"] = true,
	["Mérathilis"] = true,
	["Merathilîs"] = true,
	["Róhal"] = true,
	["Brítt"] = true,
	["Jahzzy"] = true,
}

-- Don't forget to update realm name(s) if we ever transfer realms.
-- If we forget it could be easly picked up by another player who matches these combinations.
-- End result we piss off people and we do not want to do that. :(
MER.IsDevRealm = {
	["Shattrath"] = true,
	["Garrosh"] = true,

	-- Beta
	["The Maw"] = true,
	["Torghast"] = true,
}

function F.IsDeveloper()
	return MER.IsDev[E.myname] or false
end

function F.IsDeveloperRealm()
	return MER.IsDevRealm[E.myrealm] or false
end

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
