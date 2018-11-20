local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local _G = _G
local assert, pairs, print, select = assert, pairs, print, select
local getmetatable = getmetatable
local find, format = string.find, string.format
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
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: NUM_BAG_SLOTS, hooksecurefunc, MER_NORMAL_QUEST_DISPLAY, MER_TRIVIAL_QUEST_DISPLAY

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
local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
for class in pairs(colors) do
	MER.ClassColors[class] = {}
	MER.ClassColors[class].r = colors[class].r
	MER.ClassColors[class].g = colors[class].g
	MER.ClassColors[class].b = colors[class].b
	MER.ClassColors[class].colorStr = colors[class].colorStr
end
MER.r, MER.g, MER.b = MER.ClassColors[E.myclass].r, MER.ClassColors[E.myclass].g, MER.ClassColors[E.myclass].b

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

function MER:CreateText(f, layer, fontsize, flag, justifyh)
	local text = f:CreateFontString(nil, layer)
	text:SetFont(E.media.normFont, fontsize, flag)
	text:SetJustifyH(justifyh or "CENTER")
	return text
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
function MER:CreateFS(f, size, text, classcolor, anchor, x, y)
	local fs = f:CreateFontString(nil, "OVERLAY")
	fs:FontTemplate(nil, nil, 'OUTLINE')
	fs:SetText(text)
	fs:SetWordWrap(false)
	if classcolor and type(classcolor) == "boolean" then
		fs:SetTextColor(MER.r, MER.g, MER.b)
	elseif classcolor == "system" then
		fs:SetTextColor(1, .8, 0)
	end
	if (anchor and x and y) then
		fs:SetPoint(anchor, x, y)
	else
		fs:SetPoint("CENTER", 1, 0)
	end
	return fs
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

local BC = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	BC[v] = k
end

for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
	BC[v] = k
end

function MER:GetClassColorString(class)
	local color = MER.colors.class[BC[class] or class]
	return E:RGBToHex(color.r, color.g, color.b)
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
		gradient:SetVertexColor(.3, .3, .3, .15)

		f.gradient = gradient
	end

	if not(useShadow) then
		local mshadow = f:CreateTexture(f:GetName() and f:GetName().."Overlay" or nil, "BORDER", f)
		mshadow:SetInside(f, 0, 0)
		mshadow:Width(shadowOverlayWidth or 33)
		mshadow:Height(shadowOverlayHeight or 33)
		mshadow:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Overlay]])
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

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.Styling then mt.Styling = Styling end
	if not object.StripFrame then mt.StripFrame = StripFrame end
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
