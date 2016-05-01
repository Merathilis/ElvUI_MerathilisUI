local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
-- Lua functions
local print = print
local format = string.format

local blizzPath = [[|TInterface\ICONS\]]
local toon = blizzPath..[[%s:12:12:0:0:64:64:4:60:4:60|t]]
local classTable = {
	deathknight = blizzPath..[[ClassIcon_DeathKnight:16:16|t ]],
	-- demonhunter = blizzPath..[[ClassIcon_DemonHunter:16:16|t ]],
	druid = blizzPath..[[ClassIcon_Druid:16:16|t ]],
	hunter = blizzPath..[[ClassIcon_Hunter:16:16|t ]],
	mage = blizzPath..[[ClassIcon_Mage:16:16|t ]],
	monk = blizzPath..[[ClassIcon_Monk:16:16|t ]],
	paladin = blizzPath..[[ClassIcon_Paladin:16:16|t ]],
	priest = blizzPath..[[ClassIcon_Priest:16:16|t ]],
	rogue = blizzPath..[[ClassIcon_Rogue:16:16|t ]],
	shaman = blizzPath..[[ClassIcon_Shaman:16:16|t ]],
	warlock = blizzPath..[[ClassIcon_Warlock:16:16|t ]],
	warrior = blizzPath..[[ClassIcon_Warrior:16:16|t ]],
}
MER.rolePaths = {
	["ElvUI"] = {
		TANK = [[Interface\AddOns\ElvUI\media\textures\tank]],
		HEALER = [[Interface\AddOns\ElvUI\media\textures\healer]],
		DAMAGER = [[Interface\AddOns\ElvUI\media\textures\dps]]
	},
	["SupervillainUI"] = {
		TANK = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\role\svui-tank]],
		HEALER = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\role\svui-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\role\svui-dps]]
	},
	["Blizzard"] = {
		TANK = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\role\blizz-tank]],
		HEALER = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\role\blizz-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\role\blizz-dps]]
	},
}
MER.NewSign = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:14:14|t"
MER.SpecialChatIcons = {
	["EU"] = {
		["Shattrath"] = {
			["Asragoth"] = format(toon, "inv_cloth_challengewarlock_d_01helm"),
			["Brítt"] = format(toon, "inv_helm_plate_challengewarrior_d_01"),
			["Damará"] = format(toon, "inv_helmet_plate_challengepaladin_d_01"),
			["Jazira"] = format(toon, "inv_helmet_cloth_challengepriest_d_01"),
			["Jústice"] = format(toon, "inv_helmet_leather_challengerogue_d_01"),
			["Merathilis"] = format(toon, "inv_helmet_challengedruid_d_01"),
			["Merathilîs"] = format(toon, "inv_helmet_mail_challengeshaman_d_01"),
			["Melisendra"] = format(toon, "inv_helm_cloth_challengemage_d_01"),
			["Róhal"] = format(toon, "inv_helmet_mail_challengehunter_d_01"),
		},
		["Garrosh"] = {
			["Jahzzy"] = format(toon, "inv_helm_plate_challengedeathknight_d_01"),
		},
	},
	["US"] = {},
	["CN"] = {},
	["KR"] = {},
	["TW"] = {},
}

function MER:MismatchText()
	local text = format(L["MSG_MER_ELV_OUTDATED"], MER.ElvUIV, MER.ElvUIX)
	return text
end

function MER:Print(msg)
	print(E["media"].hexvaluecolor..'MUI:|r', msg)
end

function MER:PrintURL(url)
	return format("|cFF00c0fa[|Hurl:%s|h%s|h]|r", url, url)
end

local color = { r = 1, g = 1, b = 1, a = 1 }
function MER:unpackColor(color)
	return color.r, color.g, color.b, color.a
end

-- Trying to determine the region player is in, not entirely reliable cause based on a client not an actual region id
local GetCurrentRegion = GetCurrentRegion
function MER:GetRegion()
	local rid = GetCurrentRegion()
	local region = {
		[1] = "US",
		[2] = "KR",
		[3] = "EU",
		[4] = "TW",
		[5] = "CN",
	}
	MER.region = region[rid]
	if not MER.region then 
		MER.region = format(L["An error happened. Your region is unknown. Realm: %s. RID: %s. Please report your realm name and the region you are playing in to |cffff7d0aMerathilisUI|r."], E.myrealm, rid)
		MER:Print(MER.region)
		MER.region = ""
	end
end

-- Search in a table like {"arg1", "arg2", "arg3"}
function MER:SimpleTable(table, item)
	for i = 1, #table do
		if table[i] == item then  
			return true 
		end
	end

	return false
end
