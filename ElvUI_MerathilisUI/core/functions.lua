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
MER.ClassColor = E.myclass == "PRIEST" and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
MER.InfoColor = "|cff70C0F5"
MER.GreyColor = "|cffB5B5B5"
MER.WoWPatch, MER.WoWBuild, MER.WoWPatchReleaseDate, MER.TocVersion = GetBuildInfo()
MER.WoWBuild = select(2, GetBuildInfo()) MER.WoWBuild = tonumber(MER.WoWBuild)

MER_NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
MER_TRIVIAL_QUEST_DISPLAY = TRIVIAL_QUEST_DISPLAY:gsub("000000", "ffffff")

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

MER.colors = {
	class = {},
}

MER.colors.class = {
	["DEATHKNIGHT"]	= { 0.77,	0.12,	0.23 },
	["DEMONHUNTER"]	= { 0.64,	0.19,	0.79 },
	["DRUID"]		= { 1,		0.49,	0.04 },
	["HUNTER"]		= { 0.58,	0.86,	0.49 },
	["MAGE"]		= { 0.2,	0.76,	1 },
	["MONK"]		= { 0,		1,		0.59 },
	["PALADIN"]		= { 0.96,	0.55,	0.73 },
	["PRIEST"]		= { 0.99,	0.99,	0.99 },
	["ROGUE"]		= { 1,		0.96,	0.41 },
	["SHAMAN"]		= { 0,		0.44,	0.87 },
	["WARLOCK"]		= { 0.6,	0.47,	0.85 },
	["WARRIOR"]		= { 0.9,	0.65,	0.45 },
}

for class, color in pairs(MER.colors.class) do
	MER.colors.class[class] = { r = color[1], g = color[2], b = color[3] }
end

-- Personal Dev use only
-- We will add more of my names as we go.
MER.IsDev = {
	["Merathilis"] = true,
	["Róhal"] = true,
	["Jazira"] = true,
	["Damará"] = true,
	["Merathilîs"] = true,
	["Melisendra"] = true
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

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.Styling then mt.Styling = Styling end
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