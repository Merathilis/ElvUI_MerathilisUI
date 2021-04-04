local MER, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.LSM

-- Cache global variables
-- Lua functions
local _G = _G
local assert, ipairs, pairs, print, select, tonumber, type, unpack = assert, ipairs, pairs, print, select, tonumber, type, unpack
local getmetatable = getmetatable
local find, format, gsub, match, split, strfind = string.find, string.format, string.gsub, string.match, string.split, strfind
local strmatch, strsplit = strmatch, strsplit
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
local C_Covenants_GetCovenantData = C_Covenants.GetCovenantData
local C_Covenants_GetActiveCovenantID = C_Covenants.GetActiveCovenantID
-- GLOBALS: NUM_BAG_SLOTS, hooksecurefunc, MER_NORMAL_QUEST_DISPLAY, MER_TRIVIAL_QUEST_DISPLAY

local backdropr, backdropg, backdropb, backdropa = unpack(E.media.backdropcolor)
local borderr, borderg, borderb, bordera = unpack(E.media.bordercolor)

MER.dummy = function() return end
MER.Title = format("|cffffffff%s|r|cffff7d0a%s|r ", "Merathilis", "UI")
MER.Version = GetAddOnMetadata("ElvUI_MerathilisUI", "Version")
MER.ElvUIV = tonumber(E.version)
MER.ElvUIX = tonumber(GetAddOnMetadata("ElvUI_MerathilisUI", "X-ElvVersion"))
MER.WoWPatch, MER.WoWBuild, MER.WoWPatchReleaseDate, MER.TocVersion = GetBuildInfo()
MER.WoWBuild = select(2, GetBuildInfo()) MER.WoWBuild = tonumber(MER.WoWBuild)

MER_NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
MER_TRIVIAL_QUEST_DISPLAY = TRIVIAL_QUEST_DISPLAY:gsub("000000", "ffffff")

--Info Color RGB: 0, 191/255, 250/255
MER.InfoColor = "|cFF00c0fa"
MER.GreyColor = "|cffB5B5B5"
MER.RedColor = "|cffff2735"
MER.GreenColor = "|cff3a9d36"

MER.LineString = MER.GreyColor.."---------------"

MER.LeftButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t "
MER.RightButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t "
MER.ScrollButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t "

-- Class Color stuff
MER.ClassColors = {}
local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
for class, value in pairs(colors) do
	MER.ClassColors[class] = {}
	MER.ClassColors[class].r = value.r
	MER.ClassColors[class].g = value.g
	MER.ClassColors[class].b = value.b
	MER.ClassColors[class].colorStr = value.colorStr
end
MER.r, MER.g, MER.b = MER.ClassColors[E.myclass].r, MER.ClassColors[E.myclass].g, MER.ClassColors[E.myclass].b

local defaultColor = { r = 1, g = 1, b = 1, a = 1 }
function MER:unpackColor(color)
	if not color then color = defaultColor end

	return color.r, color.g, color.b, color.a
end

function MER:CreateColorString(text, db)
	if not text or not type(text) == "string" then
		return
	end
	if not db or type(db) ~= "table" then
		return
	end
	local hex = db.r and db.g and db.b and E:RGBToHex(db.r, db.g, db.b) or "|cffffffff"

	return hex .. text .. "|r"
end

function MER:CreateClassColorString(text, englishClass)
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
	function MER:RGBToHex(r, g, b)
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

	function MER:HexToRGB(hex)
		return tonumber('0x' .. strsub(hex, 1, 2)) / 255, tonumber('0x' .. strsub(hex, 3, 4)) / 255, tonumber('0x' .. strsub(hex, 5, 6)) / 255
	end
end

function MER:SetFontDB(text, db)
	if not text or not text.GetFont then
		return
	end
	if not db or type(db) ~= "table" then
		return
	end

	text:FontTemplate(LSM:Fetch("font", db.name), db.size, db.style)
end

function MER:SetFontColorDB(text, db)
	if not text or not text.GetFont then
		return
	end
	if not db or type(db) ~= "table" then
		return
	end

	text:SetTextColor(db.r, db.g, db.b, db.a)
end

do
	local template = "|T%s:%d:%d:0:0:64:64:5:59:5:59|t"
	local s = 14
	function MER:GetIconString(icon, size)
		return format(template, icon, size or s, size or s)
	end
end

function MER:SetupProfileCallbacks()
	E.data.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	E.data.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	E.data.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
end

function MER:Print(...)
	print("|cffff7d0a".."mUI:|r", ...)
end

function MER:PrintURL(url)
	return format("|cFF00c0fa[|Hurl:%s|h%s|h]|r", url, url)
end

-- LocPanel
function MER:GetIconFromID(type, id)
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

function MER:GetSpell(id)
	local name = GetSpellInfo(id)
	return name
end

function MER:SplitList(list, variable, cleanup)
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
function MER:InspectItemTextures(clean, grabTextures)
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

function MER:InspectItemInfo(text, iLvl, enchantText)
	local itemLevel = strfind(text, itemLevelString) and strmatch(text, "(%d+)%)?$")
	if itemLevel then iLvl = tonumber(itemLevel) end
	local enchant = strmatch(text, enchantString)
	if enchant then enchantText = enchant end

	return iLvl, enchantText
end

function MER:GetItemLevel(link, arg1, arg2, fullScan)
	if fullScan then
		MER:InspectItemTextures(true)
		tip:SetOwner(UIParent, "ANCHOR_NONE")
		tip:SetInventoryItem(arg1, arg2)

		local iLvl, enchantText, gems, essences
		gems, essences = MER:InspectItemTextures(nil, true)

		for i = 1, tip:NumLines() do
			local line = _G[tip:GetName().."TextLeft"..i]
			if line then
				local text = line:GetText() or ""
				iLvl, enchantText = MER:InspectItemInfo(text, iLvl, enchantText)
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
function MER:CheckChat(msg)
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

function MER:CheckPlayerBuff(spell)
	for i = 1, 40 do
		local name, _, _, _, _, _, unitCaster = UnitBuff("player", i)
		if not name then break end
		if name == spell then
			return i, unitCaster
		end
	end
	return nil
end

function MER:BagSearch(itemId)
	for container = 0, _G.NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(container) do
			if itemId == GetContainerItemID(container, slot) then
				return container, slot
			end
		end
	end
end

-- Whiro's code magic
function MER:UpdateRegisteredDBs()
	if (not MER["RegisteredDBs"]) then
		return
	end

	local dbs = MER["RegisteredDBs"]

	for tbl, path in pairs(dbs) do
		self:UpdateRegisteredDB(tbl, path)
	end
end

function MER:OnProfileChanged()
	MER:Hook(E, "UpdateEnd", "UpdateAll")
end

function MER:UpdateAll()
	self:UpdateRegisteredDBs()
	for _, module in ipairs(self:GetRegisteredModules()) do
		local mod = MER:GetModule(module)
		if (mod and mod.ForUpdateAll) then
			mod:ForUpdateAll()
		end
	end
	MER:Unhook(E, "UpdateEnd")
end

function MER:UpdateRegisteredDB(tbl, path)
	local path_parts = {strsplit(".", path)}
	local _db = E.db.mui
	for _, path_part in ipairs(path_parts) do
		_db = _db[path_part]
	end
	tbl.db = _db
end

function MER:RegisterDB(tbl, path)
	if (not MER["RegisteredDBs"]) then
		MER["RegisteredDBs"] = {}
	end
	self:UpdateRegisteredDB(tbl, path)
	MER["RegisteredDBs"][tbl] = path
end

function MER:Reset(group)
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

function MER:MovableButtonSettings(db, key, value, remove, movehere)
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

function MER:CreateMovableButtons(Order, Name, CanRemove, db, key)
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
			MER:MovableButtonSettings(db, key, moveItemTo, nil, moveItemFrom) --add it in the new spot
			moveItemFrom, moveItemTo = nil, nil
		end,
		stateSwitchGetText = function(info, TEXT)
			local text = GetItemInfo(tonumber(TEXT))
			info.userdata.text = text
			return text
		end,
		stateSwitchOnClick = function(info)
			MER:MovableButtonSettings(db, key, moveItemFrom)
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
			MER:MovableButtonSettings(db, key, moveItemFrom, true)
		end
	end

	return config
end

-- GameTooltip
function MER:AddTooltip(self, anchor, text, color)
	if not anchor then return end

	self:SetScript("OnEnter", function()
		_G.GameTooltip:SetOwner(self, anchor)
		_G.GameTooltip:ClearLines()
		if tonumber(text) then
			_G.GameTooltip:SetSpellByID(text)
		else
			local r, g, b = 1, 1, 1
			if color == "class" then
				r, g, b = MER.r, MER.g, MER.b
			elseif color == "system" then
				r, g, b = 1, .8, 0
			end
			_G.GameTooltip:AddLine(text, r, g, b)
		end
		_G.GameTooltip:Show()
	end)
	self:SetScript("OnLeave", GameTooltip_Hide)
end

-- frame text
function MER:CreateText(f, layer, size, outline, text, classcolor, anchor, x, y)
	local text = f:CreateFontString(nil, layer)
	text:FontTemplate(nil, size or 10, outline or "OUTLINE")
	text:SetHeight(text:GetStringHeight()+30)

	if text then
		text:SetText(text)
	else
		text:SetText("")
	end

	if classcolor and type(classcolor) == "boolean" then
		text:SetTextColor(MER.r, MER.g, MER.b)
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
function MER:CleanupHeirlooms()
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
MER:RegisterChatCommand("cleanboa", MER.CleanupHeirlooms)

-- Fixes the issue when the dialog to release spirit does not come up.
function MER:FixRelease()
	RetrieveCorpse()
	RepopMe()
end
MER:RegisterChatCommand("release", MER.FixRelease)
MER:RegisterChatCommand("repop", MER.FixRelease)

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

function MER:IsDeveloper()
	return MER.IsDev[E.myname] or false
end

function MER:IsDeveloperRealm()
	return MER.IsDevRealm[E.myrealm] or false
end

-- Covenant Crest: Credits BenikUI
function MER:GetConvCrest()
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
function MER:PixelIcon(self, texture, highlight)
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
function MER:GetRoleTexCoord(role)
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

function MER:ReskinRole(self, role)
	if self.background then self.background:SetTexture("") end
	local cover = self.cover or self.Cover
	if cover then cover:SetTexture("") end
	local texture = self.GetNormalTexture and self:GetNormalTexture() or self.texture or self.Texture or (self.SetTexture and self)
	if texture then
		texture:SetTexture(E.media.roleIcons)
		texture:SetTexCoord(MER:GetRoleTexCoord(role))
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

function MER:SplitString(delimiter, subject)
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

function MER:CreateGradientFrame(frame, w, h, o, r, g, b, a1, a2)
	assert(frame, "doesn't exist!")

	frame:Size(w, h)
	frame:SetFrameStrata("BACKGROUND")

	local gf = frame:CreateTexture(nil, "BACKGROUND")
	gf:SetAllPoints()
	gf:SetTexture(E.media.blankTex)
	gf:SetGradientAlpha(o, r, g, b, a1, r, g, b, a2)
end

function MER:UpdateStyling()
	if E.db.mui.general.style then
		for style in pairs(MER["styling"]) do
			if style.stripes then style.stripes:Show() end
			if style.gradient then style.gradient:Show() end
			if style.mshadow then style.mshadow:Show() end
		end
	else
		for style in pairs(MER["styling"]) do
			if style.stripes then style.stripes:Hide() end
			if style.gradient then style.gradient:Hide() end
			if style.mshadow then style.mshadow:Hide() end
		end
	end
end

function MER:CreateShadow(frame, size, force)
	if not (E.db.mui.general.shadow and E.db.mui.general.shadow.enable) and not force then return end

	if not frame or frame.MERShadow or frame.shadow then return end

	if frame:GetObjectType() == "Texture" then
		frame = frame:GetParent()
	end

	size = size or 3
	size = size + E.db.mui.general.shadow.increasedSize or 0

	local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	shadow:SetFrameStrata(frame:GetFrameStrata())
	shadow:SetFrameLevel(frame:GetFrameLevel() or 1)
	shadow:SetOutside(frame, size, size)
	shadow:SetBackdrop({edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = size + 1})
	shadow:SetBackdropColor(0, 0, 0, 0)
	shadow:SetBackdropBorderColor(0, 0, 0, 0.618)

	frame.shadow = shadow
	frame.MERShadow = true
end

function MER:CreateBackdropShadow(frame, defaultTemplate)
	if not frame or frame.MERShadow then return end

	if frame.backdrop then
		if not defaultTemplate then
			frame.backdrop:SetTemplate("Transparent")
		end
		self:CreateShadow(frame.backdrop)
		frame.MERShadow = true
	elseif frame.CreateBackdrop and not self:IsHooked(frame, "CreateBackdrop") then
		self:SecureHook(frame, "CreateBackdrop", function()
			if self:IsHooked(frame, "CreateBackdrop") then
				self:Unhook(frame, "CreateBackdrop")
			end
			if frame.backdrop then
				if not defaultTemplate then
					frame.backdrop:SetTemplate("Transparent")
				end
				self:CreateShadow(frame.backdrop)
				frame.MERShadow = true
			end
		end)
	end
end

function MER:CreateShadowModule(frame)
	if not frame then return end

	MER:CreateShadow(frame)
end

local function Styling(f, useStripes, useGradient, useShadow, shadowOverlayWidth, shadowOverlayHeight, shadowOverlayAlpha)
	assert(f, "doesn't exist!")

	if f:GetObjectType() == "Texture" then
		f = f:GetParent()
	end

	local frameName = f.GetName and f:GetName()
	if f.styling then return end

	local style = CreateFrame("Frame", frameName or nil, f)

	if not(useStripes) then
		local stripes = f:CreateTexture(f:GetName() and f:GetName().."Overlay" or nil, "BORDER", f)
		stripes:ClearAllPoints()
		stripes:Point("TOPLEFT", 1, -1)
		stripes:Point("BOTTOMRIGHT", -1, 1)
		stripes:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\stripes]], true, true)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")

		style.stripes = stripes

		if not E.db.mui.general.style then stripes:Hide() end
	end

	if not(useGradient) then
		local gradient = f:CreateTexture(f:GetName() and f:GetName().."Overlay" or nil, "BORDER", f)
		gradient:ClearAllPoints()
		gradient:Point("TOPLEFT", 1, -1)
		gradient:Point("BOTTOMRIGHT", -1, 1)
		gradient:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\gradient]])
		gradient:SetVertexColor(.3, .3, .3, .15)

		style.gradient = gradient

		if not E.db.mui.general.style then gradient:Hide() end
	end

	if not(useShadow) then
		local mshadow = f:CreateTexture(f:GetName() and f:GetName().."Overlay" or nil, "BORDER", f)
		mshadow:SetInside(f, 0, 0)
		mshadow:Width(shadowOverlayWidth or 33)
		mshadow:Height(shadowOverlayHeight or 33)
		mshadow:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Overlay]])
		mshadow:SetVertexColor(1, 1, 1, shadowOverlayAlpha or 0.6)

		style.mshadow = mshadow

		if not E.db.mui.general.style then mshadow:Hide() end
	end

	style:SetFrameLevel(f:GetFrameLevel() + 1)
	f.styling = style

	MER["styling"][style] = true
end

local BlizzardFrameRegions = {
	'Inset',
	'inset',
	'LeftInset',
	'RightInset',
	'NineSlice',
	'BorderFrame',
	'bottomInset',
	'BottomInset',
	'bgLeft',
	'bgRight',
}

local function StripFrame(Frame, Kill, Alpha)
	local FrameName = Frame:GetName()
	for _, Blizzard in pairs(BlizzardFrameRegions) do
		local BlizzFrame = Frame[Blizzard] or FrameName and _G[FrameName..Blizzard]
		if BlizzFrame then
			StripFrame(BlizzFrame, Kill, Alpha)
		end
	end
	if Frame.GetNumRegions then
		for i = 1, Frame:GetNumRegions() do
			local Region = select(i, Frame:GetRegions())
			if Region and Region:IsObjectType('Texture') then
				if Kill then
					Region:Hide()
					Region.Show = MER.dummy
				elseif Alpha then
					Region:SetAlpha(0)
				else
					Region:SetTexture(nil)
				end
			end
		end
	end
end

local function CreateOverlay(f)
	if f.overlay then return end

	local overlay = f:CreateTexture("$parentOverlay", "BORDER", f)
	overlay:Point("TOPLEFT", 2, -2)
	overlay:Point("BOTTOMRIGHT", -2, 2)
	overlay:SetTexture(E["media"].blankTex)
	overlay:SetVertexColor(0.1, 0.1, 0.1, 1)
	f.overlay = overlay
end

local function CreateBorder(f, i, o)
	if i then
		if f.iborder then return end
		local border = CreateFrame("Frame", "$parentInnerBorder", f)
		border:Point("TOPLEFT", E.mult, -E.mult)
		border:Point("BOTTOMRIGHT", -E.mult, E.mult)
		border:CreateBackdrop()
		border.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		f.iborder = border
	end

	if o then
		if f.oborder then return end
		local border = CreateFrame("Frame", "$parentOuterBorder", f)
		border:Point("TOPLEFT", -E.mult, E.mult)
		border:Point("BOTTOMRIGHT", E.mult, -E.mult)
		border:SetFrameLevel(f:GetFrameLevel() + 1)
		border:CreateBackdrop()
		border.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		f.oborder = border
	end
end

local function CreatePanel(f, t, w, h, a1, p, a2, x, y)
	f:Width(w)
	f:Height(h)
	f:SetFrameLevel(3)
	f:SetFrameStrata("BACKGROUND")
	f:Point(a1, p, a2, x, y)
	f:CreateBackdrop()

	if t == "Transparent" then
		backdropa = 0.45
		f:CreateBorder(true, true)
	elseif t == "Overlay" then
		backdropa = 1
		f:CreateOverlay()
	elseif t == "Invisible" then
		backdropa = 0
		bordera = 0
	else
		backdropa = 1
	end

	f.backdrop:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f.backdrop:SetBackdropBorderColor(borderr, borderg, borderb, bordera)
end

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.Styling then mt.Styling = Styling end
	if not object.StripFrame then mt.StripFrame = StripFrame end
	if not object.CreateOverlay then mt.CreateOverlay = CreateOverlay end
	if not object.CreateBorder then mt.CreateBorder = CreateBorder end
	if not object.CreatePanel then mt.CreatePanel = CreatePanel end
end

local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()
while object do
	if not object:IsForbidden() and not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end
