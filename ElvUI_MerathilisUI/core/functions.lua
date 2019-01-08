local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local _G = _G
local assert, pairs, print, select, tonumber, type, unpack = assert, pairs, print, select, tonumber, type, unpack
local getmetatable = getmetatable
local find, format, match, split = string.find, string.format, string.match, string.split
local tconcat = table.concat
-- WoW API / Variables
local CreateFrame = CreateFrame
local GetAchievementInfo = GetAchievementInfo
local GetItemInfo = GetItemInfo
local GetSpellInfo = GetSpellInfo
local GetContainerItemID = GetContainerItemID
local GetContainerItemLink = GetContainerItemLink
local GetContainerNumSlots = GetContainerNumSlots
local PickupContainerItem = PickupContainerItem
local DeleteCursorItem = DeleteCursorItem
local UnitBuff = UnitBuff
local UnitClass = UnitClass
local UnitIsPlayer = UnitIsPlayer
local UnitIsTapDenied = UnitIsTapDenied
local UnitReaction = UnitReaction
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: NUM_BAG_SLOTS, hooksecurefunc, MER_NORMAL_QUEST_DISPLAY, MER_TRIVIAL_QUEST_DISPLAY, FACTION_BAR_COLORS

local backdropr, backdropg, backdropb, backdropa = unpack(E["media"].backdropcolor)
local borderr, borderg, borderb, bordera = unpack(E["media"].bordercolor)

MER.dummy = function() return end
MER.Title = format("|cffff7d0a%s |r", "MerathilisUI")
MER.Version = GetAddOnMetadata("ElvUI_MerathilisUI", "Version")
MER.ElvUIV = tonumber(E.version)
MER.ElvUIX = tonumber(GetAddOnMetadata("ElvUI_MerathilisUI", "X-ElvVersion"))
MER.WoWPatch, MER.WoWBuild, MER.WoWPatchReleaseDate, MER.TocVersion = GetBuildInfo()
MER.WoWBuild = select(2, GetBuildInfo()) MER.WoWBuild = tonumber(MER.WoWBuild)

MER_NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
MER_TRIVIAL_QUEST_DISPLAY = TRIVIAL_QUEST_DISPLAY:gsub("000000", "ffffff")

MER.InfoColor = "|cff70C0F5"
MER.GreyColor = "|cffB5B5B5"

-- Class Color stuff
MER.ClassColor = E.myclass == "PRIEST" and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
MER.ClassColors = {}
local BC = {}

for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	BC[v] = k
end

for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
	BC[v] = k
end

local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
for class in pairs(colors) do
	MER.ClassColors[class] = {}
	MER.ClassColors[class].r = colors[class].r
	MER.ClassColors[class].g = colors[class].g
	MER.ClassColors[class].b = colors[class].b
	MER.ClassColors[class].colorStr = colors[class].colorStr
end
MER.r, MER.g, MER.b = MER.ClassColors[E.myclass].r, MER.ClassColors[E.myclass].g, MER.ClassColors[E.myclass].b

function MER:ClassColor(class)
	local color = MER.ClassColors[class]
	if not color then return 1, 1, 1 end
	return color.r, color.g, color.b
end

function MER:UnitColor(unit)
	local r, g, b = 1, 1, 1
	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		if class then
			r, g, b = MER:ClassColor(class)
		end
	elseif UnitIsTapDenied(unit) then
		r, g, b = .6, .6, .6
	else
		local reaction = UnitReaction(unit, "player")
		if reaction then
			local color = FACTION_BAR_COLORS[reaction]
			r, g, b = color.r, color.g, color.b
		end
	end
	return r, g, b
end

function MER:SetupProfileCallbacks()
	E.data.RegisterCallback(self, "OnProfileChanged", "UpdateAll")
	E.data.RegisterCallback(self, "OnProfileCopied", "UpdateAll")
	E.data.RegisterCallback(self, "OnProfileReset", "UpdateAll")
end

function MER:MismatchText()
	local text = format(L["MSG_MER_ELV_OUTDATED"], MER.ElvUIV, MER.ElvUIX)
	return text
end

function MER:Print(...)
	print("|cffff7d0a".."mUI:|r", ...)
end

function MER:PrintURL(url)
	return format("|cFF00c0fa[|Hurl:%s|h%s|h]|r", url, url)
end

local color = { r = 1, g = 1, b = 1, a = 1 }
function MER:unpackColor(color)
	return color.r, color.g, color.b, color.a
end

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

-- Tooltip scanning stuff
local iLvlDB = {}
local itemLevelString = _G["ITEM_LEVEL"]:gsub("%%d", "")
local tip = CreateFrame("GameTooltip", "mUI_iLvlTooltip", nil, "GameTooltipTemplate")

function MER:GetItemLevel(link, arg1, arg2)
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
		local text = _G[tip:GetName().."TextLeft"..i]:GetText() or ""
		local found = text:find(itemLevelString)
		if found then
			local level = text:match("(%d+)%)?$")
			iLvlDB[link] = tonumber(level)
			break
		end
	end
	return iLvlDB[link]
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
	for container = 0, NUM_BAG_SLOTS do
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

function MER:UpdateAll()
	self:UpdateRegisteredDBs();
	for _, mod in pairs(self["RegisteredModules"]) do
		if mod and mod.ForUpdateAll then
			mod:ForUpdateAll();
		end
	end
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
local function MovableButton_Value(value)
	return gsub(value,'([%(%)%.%%%+%-%*%?%[%^%$])','%%%1')
end

local function MovableButton_Match(s,v)
	local m1, m2, m3, m4 = "^"..v.."$", "^"..v..",", ","..v.."$", ","..v..","
	return (match(s, m1) and m1) or (match(s, m2) and m2) or (match(s, m3) and m3) or (match(s, m4) and v..",")
end

function MER:MovableButtonSettings(db, key, value, remove, movehere)
	local str = db[key]
	if not db or not str or not value then return end

	local found = MovableButton_Match(str, MovableButton_Value(value))
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
		GameTooltip:SetOwner(self, anchor)
		GameTooltip:ClearLines()
		if tonumber(text) then
			GameTooltip:SetSpellByID(text)
		else
			local r, g, b = 1, 1, 1
			if color == "class" then
				r, g, b = MER.r, MER.g, MER.b
			elseif color == "system" then
				r, g, b = 1, .8, 0
			end
			GameTooltip:AddLine(text, r, g, b)
		end
		GameTooltip:Show()
	end)
	self:SetScript("OnLeave", GameTooltip_Hide)
end

-- frame text
function MER:CreateText(f, layer, size, outline, text, classcolor, anchor, x, y)
	local text = f:CreateFontString(nil, layer)
	text:FontTemplate(nil, size or 10, outline or "OUTLINE")
	text:SetWordWrap(false)

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
		text:SetPoint(anchor, x, y)
	else
		text:SetPoint("CENTER", 1, 0)
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
	["Merathilis"] = true,
	["Róhal"] = true,
	["Jazira"] = true,
	["Damará"] = true,
	["Merathilîs"] = true,
	["Melisendra"] = true,
	["Mattdemôn"] = true,
}
-- Don't forget to update realm name(s) if we ever transfer realms.
-- If we forget it could be easly picked up by another player who matches these combinations.
-- End result we piss off people and we do not want to do that. :(
MER.IsDevRealm = {
	["Shattrath"] = true,
}

function MER:IsDeveloper()
	return MER.IsDev[E.myname] or false
end

function MER:IsDeveloperRealm()
	return MER.IsDevRealm[E.myrealm] or false
end

function MER:CreateBtn(name, parent, w, h, tt_txt, txt)
	local f, fs, ff = E["media"].normFont, 11, "OUTLINE"
	local b = CreateFrame("Button", name, parent, "SecureActionButtonTemplate")
	b:Width(w)
	b:Height(h)
	b:SetTemplate("Default")
	b:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:AddLine(tt_txt, 1, 1, 1, 1, 1, 1)
		GameTooltip:Show()
	end)

	b:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

	b.text = b:CreateFontString(nil, "OVERLAY")
	b.text:SetFont(f, fs, ff)
	b.text:SetText(txt)
	b.text:SetPoint("CENTER", b, "CENTER", 1, -1)
	b.text:SetJustifyH("CENTER")
	b:SetAttribute("type1", "macro")
end

local function Styling(f, useStripes, useGradient, useShadow, shadowOverlayWidth, shadowOverlayHeight, shadowOverlayAlpha)
	assert(f, "doesn't exist!")
	local frameName = f.GetName and f:GetName()
	if f.styling or E.db.mui.general.style ~= true then return end

	local style = CreateFrame("Frame", frameName or nil, f)

	if not(useStripes) then
		local stripes = f:CreateTexture(f:GetName() and f:GetName().."Overlay" or nil, "BORDER", f)
		stripes:ClearAllPoints()
		stripes:SetPoint("TOPLEFT", 1, -1)
		stripes:SetPoint("BOTTOMRIGHT", -1, 1)
		stripes:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\stripes]], true, true)
		stripes:SetSnapToPixelGrid(false)
		stripes:SetTexelSnappingBias(0)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")

		f.stripes = stripes
	end

	if not(useGradient) then
		local gradient = f:CreateTexture(f:GetName() and f:GetName().."Overlay" or nil, "BORDER", f)
		gradient:ClearAllPoints()
		gradient:SetPoint("TOPLEFT", 1, -1)
		gradient:SetPoint("BOTTOMRIGHT", -1, 1)
		gradient:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\gradient.tga]])
		gradient:SetSnapToPixelGrid(false)
		gradient:SetTexelSnappingBias(0)
		gradient:SetVertexColor(.3, .3, .3, .15)

		f.gradient = gradient
	end

	if not(useShadow) then
		local mshadow = f:CreateTexture(f:GetName() and f:GetName().."Overlay" or nil, "BORDER", f)
		mshadow:SetInside(f, 0, 0)
		mshadow:Width(shadowOverlayWidth or 33)
		mshadow:Height(shadowOverlayHeight or 33)
		mshadow:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Overlay]])
		mshadow:SetSnapToPixelGrid(false)
		mshadow:SetTexelSnappingBias(0)
		mshadow:SetVertexColor(1, 1, 1, shadowOverlayAlpha or 0.6)

		f.mshadow = mshadow
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
	overlay:SetPoint("TOPLEFT", 2, -2)
	overlay:SetPoint("BOTTOMRIGHT", -2, 2)
	overlay:SetTexture(E["media"].blankTex)
	overlay:SetVertexColor(0.1, 0.1, 0.1, 1)
	f.overlay = overlay
end

local function CreateBorder(f, i, o)
	if i then
		if f.iborder then return end
		local border = CreateFrame("Frame", "$parentInnerBorder", f)
		border:SetPoint("TOPLEFT", E.mult, -E.mult)
		border:SetPoint("BOTTOMRIGHT", -E.mult, E.mult)
		border:SetBackdrop({
			edgeFile = E["media"].blankTex, edgeSize = E.mult,
			insets = {left = E.mult, right = E.mult, top = E.mult, bottom = E.mult}
		})
		border:SetBackdropBorderColor(unpack(E.media.bordercolor))
		f.iborder = border
	end

	if o then
		if f.oborder then return end
		local border = CreateFrame("Frame", "$parentOuterBorder", f)
		border:SetPoint("TOPLEFT", -E.mult, E.mult)
		border:SetPoint("BOTTOMRIGHT", E.mult, -E.mult)
		border:SetFrameLevel(f:GetFrameLevel() + 1)
		border:SetBackdrop({
			edgeFile = E["media"].blankTex, edgeSize = E.mult,
			insets = {left = E.mult, right = E.mult, top = E.mult, bottom = E.mult}
		})
		border:SetBackdropBorderColor(unpack(E.media.bordercolor))
		f.oborder = border
	end
end

local function CreatePanel(f, t, w, h, a1, p, a2, x, y)
	f:SetWidth(w)
	f:SetHeight(h)
	f:SetFrameLevel(3)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	f:SetBackdrop({
		bgFile = E["media"].blankTex, edgeFile = E["media"].blankTex, edgeSize = E.mult,
		insets = {left = -E.mult, right = -E.mult, top = -E.mult, bottom = -E.mult}
	})

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

	f:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f:SetBackdropBorderColor(borderr, borderg, borderb, bordera)
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
