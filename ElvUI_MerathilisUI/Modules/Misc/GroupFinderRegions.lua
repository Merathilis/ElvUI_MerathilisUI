local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_GroupFinder")

if E.Forever then
	return
end

local ipairs, pairs, type = ipairs, pairs, type
local gsub, lower = string.gsub, string.lower

local GetCurrentRegion = GetCurrentRegion

-------------------------------------------------------------------------------
--  Where a group's leader plays from, read from the realm name.
--  US: North America, Oceanic, Latin America or Brazil. EU: the realm's
--  language. Other regions show no tag. Realm lists from EllesmereUI.
-------------------------------------------------------------------------------

-- Realm key: spaces, dashes, quotes, dots and brackets out, ASCII lowercased.
-- Byte ranges only, accents and Cyrillic stay as they are.
local function Key(realm)
	return (gsub(gsub(realm, "[ \t%-'%(%)%.]", ""), "[A-Z]", lower))
end

-- Per region: the tags (key, label, tag, color), the realms off the default and
-- the default for every other realm. Accents and Cyrillic are byte escapes.
local SETS = {
	[1] = {
		list = {
			{ key = "na", label = L["North America"], tag = "NA", r = 1, g = 0.35, b = 0.35 },
			{ key = "oce", label = L["Oceanic"], tag = "OCE", r = 0.35, g = 0.65, b = 1 },
			{ key = "la", label = L["Latin America"], tag = "MEX", r = 1, g = 0.5, b = 0.82 },
			{ key = "br", label = L["Brazil"], tag = "BRA", r = 0.35, g = 0.9, b = 0.45 },
		},
		realms = {
			oce = {
				"amanthul",
				"barthilas",
				"caelestrasz",
				"dathremar",
				"dreadmaul",
				"frostmourne",
				"gundrak",
				"jubeithos",
				"khazgoroth",
				"nagrand",
				"saurfang",
				"thaurissan",
			},
			br = { "azralon", "gallywix", "goldrinn", "nemesis", "tolbarad" },
			la = { "drakkari", "quelthalas", "ragnaros" },
		},
		default = "na",
	},
	[3] = {
		list = {
			{ key = "en", label = L["English"], tag = "EN", r = 0.35, g = 0.65, b = 1 },
			{ key = "de", label = L["German"], tag = "DE", r = 1, g = 0.82, b = 0.2 },
			{ key = "fr", label = L["French"], tag = "FR", r = 0.6, g = 0.6, b = 1 },
			{ key = "es", label = L["Spanish"], tag = "ES", r = 1, g = 0.55, b = 0.25 },
			{ key = "it", label = L["Italian"], tag = "IT", r = 0.35, g = 0.9, b = 0.45 },
			{ key = "pt", label = L["Portuguese"], tag = "PT", r = 0.3, g = 0.85, b = 0.75 },
			{ key = "ru", label = L["Russian"], tag = "RU", r = 1, g = 0.35, b = 0.35 },
		},
		language = true, -- filter titled language, short names in two columns
		-- eu realms by language, english is everything else. accents and cyrillic
		-- are byte escapes (the repo keeps lua files ascii)
		realms = {
			de = {
				"aegwynn",
				"alexstrasza",
				"alleria",
				"amanthul",
				"ambossar",
				"anetheron",
				"antonidas",
				"anubarak",
				"area52",
				"arthas",
				"arygos",
				"azshara",
				"baelgun",
				"blackhand",
				"blackmoore",
				"blackrock",
				"blutkessel",
				"dalvengyr",
				"daskonsortium",
				"dassyndikat",
				"derabyssischerat",
				"dermithrilorden",
				"derratvondalaran",
				"destromath",
				"dethecus",
				"diealdor",
				"diearguswacht",
				"dieewigewacht",
				"dienachtwache",
				"diesilbernehand",
				"dietodeskrallen",
				"dunmorogh",
				"durotan",
				"echsenkessel",
				"eredar",
				"festungderst\195\188rme",
				"forscherliga",
				"frostmourne",
				"frostwolf",
				"garrosh",
				"gilneas",
				"gorgonnash",
				"guldan",
				"kargath",
				"kelthuzad",
				"khazgoroth",
				"kiljaeden",
				"kragjin",
				"kultderverdammten",
				"lordaeron",
				"lothar",
				"madmortem",
				"malfurion",
				"malganis",
				"malorne",
				"malygos",
				"mannoroth",
				"mugthol",
				"nathrezim",
				"nazjatar",
				"nefarian",
				"nerathor",
				"nethersturm",
				"norgannon",
				"nozdormu",
				"onyxia",
				"perenolde",
				"proudmoore",
				"rajaxx",
				"rexxar",
				"senjin",
				"shattrath",
				"taerar",
				"teldrassil",
				"terrordar",
				"theradras",
				"thrall",
				"tichondrius",
				"tirion",
				"todeswache",
				"ulduar",
				"ungoro",
				"veklor",
				"wrathbringer",
				"ysera",
				"zirkeldescenarius",
				"zuluhed",
			},
			fr = {
				"arakarahm",
				"arathi",
				"archimonde",
				"chants\195\169ternels",
				"cho\226\128\153gall",
				"confr\195\169rieduthorium",
				"conseildesombres",
				"cultedelarivenoire",
				"dalaran",
				"drekthar",
				"eitrigg",
				"eldrethalas",
				"elune",
				"garona",
				"hyjal",
				"illidan",
				"kaelthas",
				"khazmodan",
				"kirintor",
				"krasus",
				"lacroisade\195\169carlate",
				"lesclairvoyants",
				"lessentinelles",
				"mar\195\169cagedezangar",
				"medivh",
				"naxxramas",
				"ner\226\128\153zhul",
				"rashgarroth",
				"sargeras",
				"sinstralis",
				"suramar",
				"templenoir",
				"throkferoth",
				"uldaman",
				"varimathras",
				"voljin",
				"ysondre",
			},
			es = {
				"colinaspardas",
				"cthun",
				"dunmodr",
				"exodar",
				"loserrantes",
				"minahonda",
				"sanguino",
				"shendralar",
				"tyrande",
				"uldum",
				"zuljin",
			},
			it = {
				"nemesis",
				"pozzodelleternit\195\160",
			},
			pt = {
				"aggraportugu\195\170s",
			},
			ru = {
				"\208\144\208\183\209\131\209\128\208\181\208\179\208\190\209\129",
				"\208\145\208\190\209\128\208\181\208\185\209\129\208\186\208\176\209\143\209\130\209\131\208\189\208\180\209\128\208\176",
				"\208\146\208\181\209\135\208\189\208\176\209\143\208\159\208\181\209\129\208\189\209\143",
				"\208\147\208\176\208\187\208\176\208\186\209\128\208\190\208\189\208\180",
				"\208\147\208\190\208\187\208\180\209\128\208\184\208\189\208\189",
				"\208\147\208\190\209\128\208\180\209\131\208\189\208\189\208\184",
				"\208\147\209\128\208\190\208\188",
				"\208\148\209\128\208\176\208\186\208\190\208\189\208\190\208\188\208\190\209\128",
				"\208\154\208\190\209\128\208\190\208\187\209\140\208\187\208\184\209\135",
				"\208\159\208\184\209\128\208\176\209\130\209\129\208\186\208\176\209\143\208\145\209\131\209\133\209\130\208\176",
				"\208\159\208\190\208\180\208\183\208\181\208\188\209\140\208\181",
				"\208\160\208\176\208\183\209\131\208\178\208\184\208\185",
				"\208\160\208\181\208\178\209\131\209\137\208\184\208\185\209\132\209\140\208\190\209\128\208\180",
				"\208\161\208\178\208\181\208\182\208\181\208\178\208\176\209\130\208\181\208\187\209\140\208\148\209\131\209\136",
				"\208\161\208\181\208\180\208\190\208\179\209\128\208\184\208\178",
				"\208\161\209\130\209\128\208\176\208\182\208\161\208\188\208\181\209\128\209\130\208\184",
				"\208\162\208\181\209\128\208\188\208\190\209\136\209\130\208\181\208\191\209\129\208\181\208\187\209\140",
				"\208\162\208\186\208\176\209\135\208\161\208\188\208\181\209\128\209\130\208\184",
				"\208\167\208\181\209\128\208\189\209\139\208\185\208\168\209\128\208\176\208\188",
				"\208\175\209\129\208\181\208\189\208\181\208\178\209\139\208\185\208\187\208\181\209\129",
			},
		},
		default = "en",
	},
}

local set, byKey, realmOf
local function Set()
	if set == nil then
		set = SETS[GetCurrentRegion and GetCurrentRegion() or 1] or false
		if set then
			byKey, realmOf = {}, {}
			for _, data in ipairs(set.list) do
				byKey[data.key] = data
			end
			for key, realms in pairs(set.realms) do
				for _, realm in ipairs(realms) do
					realmOf[realm] = key
				end
			end
		end
	end
	return set or nil
end

local cache = {}

---Tag data { key, label, tag, r, g, b } of a realm, nil in regions without tags
---@param realm string
function module:RegionOfRealm(realm)
	local s = Set()
	if not s or type(realm) ~= "string" or realm == "" then
		return nil
	end

	local key = cache[realm]
	if not key then
		key = realmOf[Key(realm)] or s.default
		cache[realm] = key
	end
	return byKey[key]
end

---The region's tags in order, nil in regions without tags
function module:RegionList()
	local s = Set()
	return s and s.list
end
