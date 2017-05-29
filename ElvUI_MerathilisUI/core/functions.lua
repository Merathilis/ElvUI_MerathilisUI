local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local _G = _G
local print, select = print, select
local format = string.format
-- WoW API / Variables
local GetAchievementInfo = GetAchievementInfo
local GetItemInfo = GetItemInfo
local GetSpellInfo = GetSpellInfo
local GetContainerItemID = GetContainerItemID
local GetContainerNumSlots = GetContainerNumSlots

--GLOBALS: NUM_BAG_SLOTS

MER.dummy = function() return end
MER.NewSign = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:14:14|t"
MER.TexCoords = {.08, 0.92, -.04, 0.92}
MER.Title = format("|cffff7d0a%s |r", "MerathilisUI")
MER.Version = GetAddOnMetadata("ElvUI_MerathilisUI", "Version")
MER.ElvUIV = tonumber(E.version)
MER.ElvUIX = tonumber(GetAddOnMetadata("ElvUI_MerathilisUI", "X-ElvVersion"))
MER.BenikUIV = tonumber(GetAddOnMetadata("ElvUI_BenikUI", "Version"))
MER.BenikUIX = tonumber(GetAddOnMetadata("ElvUI_MerathilisUI", "X-BenikUIVersion"))
MER.ClassColor = E.myclass == "PRIEST" and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
MER.InfoColor = "|cff70C0F5"
MER.GreyColor = "|cffB5B5B5"
MER.WoWPatch, MER.WoWBuild, MER.WoWPatchReleaseDate, MER.TocVersion = GetBuildInfo()
MER.WoWBuild = select(2, GetBuildInfo()) MER.WoWBuild = tonumber(MER.WoWBuild)

function MER:MismatchText()
	local text = format(L["MSG_MER_ELV_OUTDATED"], MER.ElvUIV, MER.ElvUIX)
	return text
end

function MER:BenikMismatchText()
	local text = format(L["MSG_MER_BENIK_OUTDATED"], MER.BenikUIV, MER.BenikUIX)
	return text
end

function MER:Print(...)
	print("|cffff7d0a".."mUI:|r", ...)
end

function MER:PrintURL(url)
	return format("|cFF00c0fa[|Hurl:%s|h%s|h]|r", url, url)
end

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

function MER:BagSearch(itemId)
	for container = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(container) do
			if itemId == GetContainerItemID(container, slot) then
				return container, slot
			end
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

-- Personal usage stuff
MER.IsDev = { Merathilis = true, Jazira = true, Asragoth = true, Jahzzy = true }
MER.IsDevRealm = { Shattrath = true, Garrosh = true }

function MER:IsDeveloper()
	return MER.IsDev[E.myname] or false
end

function MER:IsDeveloperRealm()
	return MER.IsDevRealm[E.myrealm] or false
end

-- Inform us of the patch info we play on.
_G["SLASH_WOWVERSION1"], _G["SLASH_WOWVERSION2"] = "/patch", "/version"
SlashCmdList["WOWVERSION"] = function()
	MER:Print("Patch:", MER.WoWPatch..", ".. "Build:", MER.WoWBuild..", ".. "Released", MER.WoWPatchReleaseDate..", ".. "Interface:", MER.TocVersion)
end

MER.colors = {
	class = {},
}

MER["colors"].class = {
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