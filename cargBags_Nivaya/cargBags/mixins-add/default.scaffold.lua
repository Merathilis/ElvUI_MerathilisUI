--[[
LICENSE
	cargBags: An inventory framework addon for World of Warcraft

	Copyright (C) 2010  Constantin "Cargor" Schomburg <xconstruct@gmail.com>

	cargBags is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	cargBags is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with cargBags; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

DESCRIPTION
	Provides a Scaffold that generates a default Blizz' ContainerButton

DEPENDENCIES
	mixins/api-common.lua
]]
local addon, ns = ...
local cargBags = ns.cargBags

local function noop() end

-- ArtifactPower
local ARTIFACT_COLOR = BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_ARTIFACT]

-- Tracking our current knowledge level
local KNOWLEDGE_LEVEL = C_ArtifactUI and C_ArtifactUI.GetArtifactKnowledgeLevel() or 0

-- Get the current client locale
local gameLocale = GetLocale()

local strings = {} -- cache of artifact power fontstrings
local cache = {} -- cache of artifact power values
local rarityCache = {} -- cache of item rarities
local ignored = {} -- items with no artifact power we'll ignore (todo: add item types to this on startup, to reduce scanning delay)

local ancientMana = {
	-- Epic Quality
	[140242] = 200,		-- Astromancer's Compass
	[140239] = 300,		-- Excavated Highborne Artifact
	[141655] = 150,		-- Shimmering Ancient Mana Cluster
	[140245] = 300,		-- The Tidemistress' Enchanted Pearl

	-- Rare Quality
	[140236] = true, 	-- A Mrglrmrl Mlrglr
	[139786] = 50, 		-- Ancient Mana Crystal
	[143734] = 100, 	-- Ancient Mana Crystal Cluster
	[139890] = 100, 	-- Ancient Mana Gem
	[143733] = 50, 		-- Ancient Mana Shards
	[140246] = 100, 	-- Arc of Snow
	[140401] = 75, 		-- Blue Or'ligai Egg
	[140240] = 150, 	-- Enchanted Moonwell Waters
	[140402] = 75, 		-- Green Or'ligai Egg
	[140405] = 75, 		-- Illusion Matrix Crystal
	[140404] = 75, 		-- Intact Guardian Core
	[140403] = 75, 		-- Lylandre's Fel Crystal
	[140248] = 100, 	-- Master Jeweler's Gem
	--[147729] = 100, 	-- Netherchunk -- grants Nethershards, not Ancient Mana
	--[147726] = 500, 	-- Nethercluster -- grants Nethershards, not Ancient Mana
	[140406] = 75,		-- Primed Arcane Charge
	[140399] = 75, 		-- Yellow Or'ligai Egg
	--[139617] = 350, 	-- Ancient Warden Manacles -- grants Artifact Power, not Ancient Mana

	-- Uncommon Quality
	[143735] = 25, 		-- Ancient Mana Shards
	[129098] = 70, 		-- Ancient Mana Stone
	[140243] = 50, 		-- Azurefall Essence
	[137010] = 50, 		-- Half-Full Bottle of Arcwine
	[143748] = 25, 		-- Leyscale Koi
	[140949] = 75, 		-- Onyx Or'ligai Egg
	[140390] = 75, 		-- Red Or'ligai Egg
	[140235] = 50, 		-- Small Jar of Arcwine

	-- Common Quality
	[129036] = 10, 		-- Ancient Mana Fragment
	[139884] = 10, 		-- Ancient Mana Fragments
	[129097] = 30, 		-- Ancient Mana Gem
	[140234] = 50 		-- Selentia's Mana-Infused Brooch
}

local championArmor = {
	-- Up to Item Level 850
	[136412] = 5, 		-- Heavy Armor Set (+5)
	[137207] = 10, 		-- Fortified Armor Set (+10)
	[137208] = 10, 		-- Idestructible Armor Set (+15)

	-- Up to Item Level 900
	[147348] = 5, 		-- Bulky Armor Set (+5)
	[147349] = 10, 		-- Spiked Armor Set (+10)
	[147350] = 15, 		-- Invincible Armor Set (+15)

	-- Added in patch 7.3
	[153005] = 800, 	-- Relinquished Armor Set (Set to 880)
	[151842] = 900, 	-- Krokul Armor Set (Set to 900)
	[151843] = 925, 	-- Mac'Aree Armor Set (Set to 925)
	[151844] = 950  	-- Xenadaa Armor Set (Set to 950)

}

local artifactPowerData = {
	multiplier = {
		[1] = 1,
		[2] = 1.25,
		[3] = 1.5,
		[4] = 1.9,
		[5] = 2.4,
		[6] = 3,
		[7] = 3.75,
		[8] = 4.75,
		[9] = 6,
		[10] = 7.5,
		[11] = 9.5,
		[12] = 12,
		[13] = 15,
		[14] = 18.75,
		[15] = 23.5,
		[16] = 29.5,
		[17] = 37,
		[18] = 46.5,
		[19] = 58,
		[20] = 73,
		[21] = 91,
		[22] = 114,
		[23] = 143,
		[24] = 179,
		[25] = 224,
		[26] = 250,
		[27] = 1001,
		[28] = 1301,
		[29] = 1701,
		[30] = 2201,
		[31] = 2901,
		[32] = 3801,
		[33] = 4901,
		[34] = 6401,
		[35] = 8301,
		[36] = 10801,
		[37] = 14001,
		[38] = 18201,
		[39] = 23701,
		[40] = 30801,
		[41] = 40001,
		[42] = 160001,
		[43] = 208001,
		[44] = 270401,
		[45] = 351501,
		[46] = 457001,
		[47] = 594001,
		[48] = 772501,
		[49] = 1004001,
		[50] = 1305001,
		[51] = 1696501,
		[52] = 2205501,
		[53] = 2867501,
		[54] = 3727501,
		[55] = 4846001,
		[56] = 6300001,
		[57] = 6300001,
		[58] = 6300001,
		[59] = 6300001,
		[60] = 6300001,
	},
	spells = {
		[179492] = 300, -- Libram of Divinity
		[179958] = 300, -- Artifact Power
		[179959] = 200, -- Artifact Quest Experience - Medium
		[179960] = 200, -- Drawn Power
		[181851] = 300, -- Artifact XP - Large Invasion
		[181852] = 200, -- Artifact XP - Small Invasion
		[181854] = 300, -- Artifact XP - Tomb Completion
		[187511] = 1000, -- XP
		[187536] = 300, -- Artifact Power
		[188542] = 7, -- Shard of Potentiation
		[188543] = 19, -- Crystal of Ensoulment
		[188627] = 19, -- Scroll of Enlightenment
		[188642] = 7, -- Treasured Coin
		[188656] = 79, -- Trembling Phylactery
		[190599] = 100, -- Artifact Power
		[192731] = 150, -- Scroll of Forgotten Knowledge
		[193823] = 250, -- Holy Prayer
		[196374] = 50, -- Artifact Shrine XP Boost
		[196461] = 5, -- Latent Power
		[196493] = 50, -- Channel Magic - Small Artifact XP
		[196499] = 75, -- Channel Magic - Medium Artifact XP
		[196500] = 100, -- Channel Magic - Large Artifact XP
		[199685] = 1000, -- Purified Ashbringer
		[201742] = 100, -- Artifact Power
		[204695] = 1000, -- Purple Hills of Mac'Aree
		[205057] = 1, -- Hidden Power
		[207600] = 300, -- Crystalline Demonic Eye
		[216876] = 10, -- Empowering
		[217024] = 400, -- Empowering
		[217026] = 25, -- Empowering
		[217045] = 75, -- Empowering
		[217055] = 100, -- Empowering
		[217299] = 35, -- Empowering
		[217300] = 35, -- Empowering
		[217301] = 100, -- Empowering
		[217355] = 100, -- Empowering
		[217511] = 50, -- Empowering
		[217512] = 60, -- Empowering
		[217670] = 200, -- Empowering
		[217671] = 400, -- Empowering
		[217689] = 150, -- Empowering
		[220547] = 100, -- Empowering
		[220548] = 235, -- Empowering
		[220549] = 480, -- Empowering
		[220550] = 450, -- Empowering
		[220551] = 530, -- Empowering
		[220553] = 550, -- Empowering
		[220784] = 200, -- Stolen Book of Artifact Lore
		[224139] = 25, -- Light of Elune
		[224544] = 25, -- Light of Elune
		[224583] = 25, -- Light of Elune
		[224585] = 25, -- Light of Elune
		[224593] = 25, -- Light of Elune
		[224595] = 25, -- Light of Elune
		[224608] = 25, -- Light of Elune
		[224610] = 25, -- Light of Elune
		[224633] = 25, -- Light of Elune
		[224635] = 25, -- Light of Elune
		[224641] = 25, -- Light of Elune
		[224643] = 25, -- Light of Elune
		[225897] = 100, -- Empowering
		[227531] = 200, -- Empowering
		[227535] = 300, -- Empowering
		[227886] = 545, -- Empowering
		[227889] = 210, -- Empowering
		[227904] = 35, -- Empowering
		[227905] = 55, -- Empowering
		[227907] = 200, -- Empowering
		[227941] = 150, -- Empowering
		[227942] = 200, -- Empowering
		[227943] = 465, -- Empowering
		[227944] = 520, -- Empowering
		[227945] = 165, -- Empowering
		[227946] = 190, -- Empowering
		[227947] = 210, -- Empowering
		[227948] = 230, -- Empowering
		[227949] = 475, -- Empowering
		[227950] = 515, -- Empowering
		[228067] = 400, -- Empowering
		[228069] = 100, -- Empowering
		[228078] = 500, -- Empowering
		[228079] = 600, -- Empowering
		[228080] = 250, -- Empowering
		[228106] = 490, -- Empowering
		[228107] = 250, -- Empowering
		[228108] = 210, -- Empowering
		[228109] = 170, -- Empowering
		[228110] = 205, -- Empowering
		[228111] = 245, -- Empowering
		[228112] = 160, -- Empowering
		[228130] = 125, -- Empowering
		[228131] = 400, -- Empowering
		[228135] = 250, -- Empowering
		[228220] = 150, -- Empowering
		[228310] = 50, -- Empowering
		[228352] = 500, -- Empowering
		[228422] = 175, -- Empowering
		[228423] = 350, -- Empowering
		[228436] = 170, -- Empowering
		[228437] = 220, -- Empowering
		[228438] = 195, -- Empowering
		[228439] = 185, -- Empowering
		[228440] = 190, -- Empowering
		[228442] = 215, -- Empowering
		[228443] = 180, -- Empowering
		[228444] = 750, -- Empowering
		[228647] = 400, -- Empowering
		[228921] = 500, -- Empowering
		[228955] = 25, -- Empowering
		[228956] = 50, -- Empowering
		[228957] = 35, -- Empowering
		[228959] = 45, -- Empowering
		[228960] = 20, -- Empowering
		[228961] = 25, -- Empowering
		[228962] = 40, -- Empowering
		[228963] = 80, -- Empowering
		[228964] = 150, -- Empowering
		[229746] = 100, -- Empowering
		[229747] = 200, -- Empowering
		[229776] = 1000, -- Empowering
		[229778] = 100, -- Empowering
		[229779] = 300, -- Empowering
		[229780] = 350, -- Empowering
		[229781] = 300, -- Empowering
		[229782] = 500, -- Empowering
		[229783] = 100, -- Empowering
		[229784] = 150, -- Empowering
		[229785] = 800, -- Empowering
		[229786] = 350, -- Empowering
		[229787] = 300, -- Empowering
		[229788] = 600, -- Empowering
		[229789] = 250, -- Empowering
		[229790] = 2000, -- Empowering
		[229791] = 1000, -- Empowering
		[229792] = 4000, -- Empowering
		[229793] = 900, -- Empowering
		[229794] = 1000, -- Empowering
		[229795] = 650, -- Empowering
		[229796] = 450, -- Empowering
		[229798] = 750, -- Empowering
		[229799] = 1200, -- Empowering
		[229803] = 500, -- Empowering
		[229804] = 875, -- Empowering
		[229805] = 1250, -- Empowering
		[229806] = 2500, -- Empowering
		[229807] = 20, -- Empowering
		[229857] = 100, -- Empowering
		[229858] = 100, -- Empowering
		[229859] = 1000, -- Empowering
		[231035] = 100, -- Empowering
		[231041] = 100, -- Empowering
		[231047] = 1000, -- Empowering
		[231048] = 500, -- Empowering
		[231337] = 600, -- Empowering
		[231362] = 200, -- Empowering
		[231453] = 500, -- Empowering
		[231512] = 500, -- Empowering
		[231538] = 250, -- Empowering
		[231543] = 500, -- Empowering
		[231544] = 100, -- Empowering
		[231556] = 500, -- Empowering
		[231581] = 250, -- Empowering
		[231647] = 500, -- Empowering
		[231669] = 500, -- Empowering
		[231709] = 500, -- Empowering
		[231727] = 800, -- Empowering
		[232755] = 90, -- Empowering
		[232832] = 95, -- Empowering
		[232890] = 400, -- Empowering
		[232994] = 100, -- Empowering
		[232995] = 120, -- Empowering
		[232996] = 180, -- Empowering
		[232997] = 800, -- Empowering
		[233030] = 150, -- Empowering
		[233031] = 100, -- Empowering
		[233204] = 500, -- Empowering
		[233209] = 500, -- Empowering
		[233211] = 800, -- Empowering
		[233242] = 300, -- Empowering
		[233243] = 1000, -- Empowering
		[233244] = 250, -- Empowering
		[233245] = 250, -- Empowering
		[233348] = 3000, -- Empowering
		[233816] = 250, -- Empowering
		[234045] = 250, -- Empowering
		[234047] = 400, -- Empowering
		[234048] = 500, -- Empowering
		[234049] = 600, -- Empowering
		[235245] = 175, -- Empowering
		[235246] = 195, -- Empowering
		[235247] = 220, -- Empowering
		[235248] = 240, -- Empowering
		[235256] = 250, -- Empowering
		[235257] = 155, -- Empowering
		[235266] = 500, -- Empowering
		[237344] = 320, -- Empowering
		[237345] = 380, -- Empowering
		[238029] = 85, -- Empowering
		[238030] = 115, -- Empowering
		[238031] = 300, -- Empowering
		[238032] = 400, -- Empowering
		[238033] = 750, -- Empowering
		[238252] = 85, -- Jar of Ashes
		[239094] = 600, -- Empowering
		[239095] = 650, -- Empowering
		[239096] = 270, -- Empowering
		[239097] = 225, -- Empowering
		[239098] = 285, -- Empowering
		[240331] = 200, -- Empowering
		[240332] = 125, -- Empowering
		[240333] = 600, -- Empowering
		[240335] = 240, -- Empowering
		[240337] = 360, -- Empowering
		[240339] = 1600, -- Empowering
		[240483] = 2500, -- Empowering
		[241156] = 175, -- Empowering
		[241157] = 290, -- Empowering
		[241158] = 325, -- Empowering
		[241159] = 465, -- Empowering
		[241160] = 300, -- Empowering
		[241161] = 475, -- Empowering
		[241162] = 540, -- Empowering
		[241163] = 775, -- Empowering
		[241164] = 375, -- Empowering
		[241165] = 600, -- Empowering
		[241166] = 675, -- Empowering
		[241167] = 1000, -- Empowering
		[241471] = 750, -- Empowering
		[241476] = 1000, -- Empowering
		[241752] = 800, -- Empowering
		[241753] = 255, -- Empowering
		[242062] = 500, -- Empowering
		[242116] = 3125, -- Empowering
		[242117] = 2150, -- Empowering
		[242118] = 1925, -- Empowering
		[242119] = 1250, -- Empowering
		[242564] = 1200, -- Empowering
		[242572] = 725, -- Empowering
		[242573] = 1500, -- Empowering
		[242575] = 5000, -- Empowering
		[242884] = 625, -- Empowering
		[242886] = 125, -- Empowering
		[242887] = 100, -- Empowering
		[242890] = 50, -- Empowering
		[242891] = 500, -- Empowering
		[242893] = 250, -- Empowering
		[242911] = 2000, -- Empowering
		[242912] = 400, -- Empowering
		[244814] = 600, -- Empowering
		[246165] = 500, -- Empowering
		[246166] = 525, -- Empowering
		[246167] = 625, -- Empowering
		[246168] = 275, -- Empowering
		[247040] = 750, -- Empowering
		[247075] = 250, -- Empowering
		[247316] = 450, -- Empowering
		[247319] = 125, -- Empowering
		[247631] = 300, -- Empowering
		[247633] = 700, -- Empowering
		[247634] = 1000, -- Empowering
		[248047] = 800, -- Empowering
		[248841] = 20, -- Empowering
		[248842] = 30, -- Empowering
		[248843] = 40, -- Empowering
		[248844] = 50, -- Empowering
		[248845] = 60, -- Empowering
		[248846] = 70, -- Empowering
		[248847] = 80, -- Empowering
		[248848] = 90, -- Empowering
		[248849] = 100, -- Empowering
		[250374] = 550, -- Empowering
		[250375] = 590, -- Empowering
		[250376] = 575, -- Empowering
		[250377] = 625, -- Empowering
		[250378] = 610, -- Empowering
		[250379] = 650, -- Empowering
		[251039] = 3500, -- Empowering
		[252078] = 200, -- Empowering
		[253833] = 400, -- Empowering
		[253834] = 600, -- Empowering
		[253902] = 1200, -- Empowering
		[253931] = 875, -- Empowering
		[254000] = 10000, -- Empowering
		[254387] = 500, -- Empowering
		[254593] = 200, -- Empowering
		[254603] = 570, -- Empowering
		[254608] = 630, -- Empowering
		[254609] = 565, -- Empowering
		[254610] = 635, -- Empowering
		[254656] = 645, -- Empowering
		[254657] = 745, -- Empowering
		[254658] = 550, -- Empowering
		[254659] = 650, -- Empowering
		[254660] = 640, -- Empowering
		[254661] = 560, -- Empowering
		[254662] = 625, -- Empowering
		[254663] = 575, -- Empowering
		[254699] = 50, -- Empowering
		[254761] = 750, -- Empowering
		[255161] = 650, -- Empowering
		[255162] = 550, -- Empowering
		[255163] = 750, -- Empowering
		[255165] = 800, -- Empowering
		[255166] = 600, -- Empowering
		[255167] = 900, -- Empowering
		[255168] = 1000, -- Empowering
		[255169] = 1250, -- Empowering
		[255170] = 1000, -- Empowering
		[255171] = 450, -- Empowering
		[255172] = 600, -- Empowering
		[255173] = 750, -- Empowering
		[255175] = 850, -- Empowering
		[255176] = 600, -- Empowering
		[255177] = 520, -- Empowering
		[255178] = 550, -- Empowering
		[255179] = 535, -- Empowering
		[255180] = 305, -- Empowering
		[255181] = 315, -- Empowering
		[255182] = 330, -- Empowering
		[255183] = 345, -- Empowering
		[255184] = 350, -- Empowering
		[255185] = 555, -- Empowering
		[255186] = 60, -- Empowering
		[255187] = 90, -- Empowering
		[255188] = 75, -- Empowering
	},
	items = {
		[127999] = 10, -- Shard of Potentiation
		[128000] = 25, -- Crystal of Ensoulment
		[128021] = 25, -- Scroll of Enlightenment
		[128022] = 10, -- Treasured Coin
		[128026] = 150, -- Trembling Phylactery
		[130144] = 50, -- Crystallized Fey Darter Egg
		[130149] = 100, -- Carved Smolderhide Figurines
		[130153] = 100, -- Godafoss Essence
		[130159] = 100, -- Ravencrest Shield
		[130160] = 100, -- Vial of Pure Moonrest Water
		[130165] = 75, -- Heathrow Keepsake
		[131728] = 75, -- Urn of Malgalor's Blood
		[131758] = 50, -- Oversized Acorn
		[131778] = 50, -- Woodcarved Rabbit
		[131784] = 50, -- Left Half of a Locket
		[131785] = 50, -- Right Half of a Locket
		[131789] = 75, -- Handmade Mobile
		[132361] = 50, -- Petrified Arkhana
		[132923] = 50, -- Hrydshal Etching
		[134118] = 150, -- Cluster of Potentiation
		[134133] = 150, -- Jewel of Brilliance
		[138726] = 10, -- Shard of Potentiation
	}
}

-- Event frame
local knowledgeTracker = CreateFrame("Frame")
knowledgeTracker:RegisterEvent("ARTIFACT_UPDATE")
knowledgeTracker:RegisterEvent("PLAYER_ENTERING_WORLD")
knowledgeTracker:SetScript("OnEvent", function(self, event, ...) 
	if (event == "ADDON_LOADED") then
		local addon = ...
		if (addon ~= "Blizzard_ArtifactUI") then
			return
		end
		self:UnregisterEvent("ADDON_LOADED")
	end

	if (not C_ArtifactUI) then
		return self:RegisterEvent("ADDON_LOADED")
	end

	local knowledgeLevel = C_ArtifactUI.GetArtifactKnowledgeLevel()
	if (knowledgeLevel ~= KNOWLEDGE_LEVEL) then
		KNOWLEDGE_LEVEL = knowledgeLevel

		-- Wipe our cache if the knowledge level changed, 
		-- as this also changes artifact power from items.
		table.wipe(cache)
	end
end)

-- Tooltip used for scanning
local scanner = CreateFrame("GameTooltip", "ArtifactPowerScannerTooltip", WorldFrame, "GameTooltipTemplate")
local scannerName = scanner:GetName()

-- Number abbreviations
-- local shorten = (gameLocale == "zhCN") and function(value)
	-- value = tonumber(value)
	-- if not value then return "" end
	-- if value >= 1e8 then
		-- return ("%.1f亿"):format(value / 1e8):gsub("%.?0+([km])$", "%1")
	-- elseif value >= 1e4 or value <= -1e3 then
		-- return ("%.1f万"):format(value / 1e4):gsub("%.?0+([km])$", "%1")
	-- else
		-- return tostring(math.floor(value))
	-- end
-- end

-- or function(value)
	-- value = tonumber(value)
	-- if not value then return "" end
	-- if value >= 1e9 then
		-- return ("%.1fb"):format(value / 1e9):gsub("%.?0+([kmb])$", "%1")
	-- elseif value >= 1e6 then
		-- return ("%.1fm"):format(value / 1e6):gsub("%.?0+([kmb])$", "%1")
	-- elseif value >= 1e3 or value <= -1e3 then
		-- return ("%.1fk"):format(value / 1e3):gsub("%.?0+([kmb])$", "%1")
	-- else
		-- return tostring(math.floor(value))
	-- end
-- end

local shortValueDec
local function shorten(v)
	shortValueDec = format("%%.%df", 1)
	-- Chinese
	if (gameLocale == "zhCN") then
		if abs(v) >= 1e8 then
			return format(shortValueDec.."Y", v / 1e8)
		elseif abs(v) >= 1e4 then
			return format(shortValueDec.."W", v / 1e4)
		else
			return format("%s", v)
		end
	-- Korean
	elseif (gameLocale == "koKR") then
		if abs(v) >= 1e8 then
			return format(shortValueDec.."억", v / 1e8)
		elseif abs(v) >= 1e4 then
			return format(shortValueDec.."만", v / 1e4)
		elseif abs(v) >= 1e3 then
			return format(shortValueDec.."천", v / 1e3)
		else
			return format("%s", v)
		end
	-- German
	elseif (gameLocale == "deDE") then
		if abs(v) >= 1e9 then
			return format(shortValueDec.."Mrd", v / 1e9)
		elseif abs(v) >= 1e6 then
			return format(shortValueDec.."Mio", v / 1e6)
		elseif abs(v) >= 1e3 then
			return format(shortValueDec.."Tsd", v / 1e3)
		else
			return format("%s", v)
		end
	-- All other languages
	else
		if abs(v) >= 1e9 then
			return format(shortValueDec.."B", v / 1e9)
		elseif abs(v) >= 1e6 then
			return format(shortValueDec.."M", v / 1e6)
		elseif abs(v) >= 1e3 then
			return format(shortValueDec.."K", v / 1e3)
		else
			return format("%s", v)
		end
	end
end

local GetArtifactPowerFromItem = function(item)
	local itemID, knowledgeLevel = tonumber(item), 1
	if (not itemID) then
		itemID, knowledgeLevel = item:match("item:(%d+).-(%d*):::|h")
		if (not itemID) then 
			return 
		end
		knowledgeLevel = tonumber(knowledgeLevel) or 1
	end
	if IsArtifactPowerItem(itemID) then
		local _, _, spellID = GetItemSpell(itemID)
		if spellID then 
			return artifactPowerData.multiplier[knowledgeLevel] * (artifactPowerData.spells[spellID] or 0)
		end 
	end 
	if artifactPowerData.items[itemID] then
		return artifactPowerData.multiplier[knowledgeLevel] * artifactPowerData.items[itemID]
	end
end

--[[
local S_UPGRADE_LEVEL = "^" .. gsub(ITEM_UPGRADE_TOOLTIP_FORMAT, "%%d", "(%%d+)")	-- Search pattern
local scantip = CreateFrame("GameTooltip", "ItemUpgradeScanTooltip", nil, "GameTooltipTemplate")
scantip:SetOwner(UIParent, "ANCHOR_NONE")

local function GetItemUpgradeLevel(itemLink)
	scantip:SetOwner(UIParent, "ANCHOR_NONE")
	scantip:SetHyperlink(itemLink)
	for i = 2, scantip:NumLines() do -- Line 1 = name so skip
		local text = _G["ItemUpgradeScanTooltipTextLeft"..i]:GetText()
		if text and text ~= "" then
			local currentUpgradeLevel, maxUpgradeLevel = strmatch(text, S_UPGRADE_LEVEL)
			if currentUpgradeLevel then
				return currentUpgradeLevel, maxUpgradeLevel
			end
		end
	end
	scantip:Hide()
end
]]
local function Round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function ItemColorGradient(perc, ...)
	if perc >= 1 then
		return select(select('#', ...) - 2, ...)
	elseif perc <= 0 then
		return ...
	end

	local num = select('#', ...) / 3
	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

local function CreateInfoString(button, position)
	local str = button:CreateFontString(nil, "OVERLAY")
	if position == "TOP" then
		str:SetJustifyH("LEFT")
		str:SetPoint("TOPLEFT", button, "TOPLEFT", 1.5, -1.5)
	elseif position == "BOTTOM" then
		str:SetJustifyH("RIGHT")
		str:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1.5, 1.5)
	else
		str:SetJustifyH("CENTER")
		str:SetPoint("CENTER", button, "CENTER", 0, 0)
	end
	if ElvUI then
		str:SetFont(ElvUI[1].media.normFont, 11, "OUTLINE")
	else
		str:SetFont(unpack(ns.options.fonts.itemCount))
	end

	return str
end

local function GetScreenModes()
	local curResIndex = GetCurrentResolution()
	local curRes = curResIndex > 0 and select(curResIndex, GetScreenResolutions()) or nil
	local windowedMode = Display_DisplayModeDropDown:windowedmode()

	local resolution = curRes or (windowedMode and GetCVar("gxWindowedResolution")) or GetCVar("gxFullscreenResolution")

	return resolution
end

local function ItemButton_Scaffold(self)
	self:SetSize(36, 36)
--[[
	local monitorIndex = (tonumber(GetCVar('gxMonitor')) or 0) + 1
	local resolution = select(GetCurrentResolution(monitorIndex), GetScreenResolutions(monitorIndex))
	local bordersize = 768/string.match(resolution, "%d+x(%d+)")/(GetCVar("uiScale")*cBnivCfg.scale)
]]
	local bordersize = 768/string.match(GetScreenModes(), "%d+x(%d+)")/(GetCVar("uiScale")*cBnivCfg.scale)
	local name = self:GetName()

	self.Icon = _G[name.."IconTexture"]
	self.Count = _G[name.."Count"]
	self.Cooldown = _G[name.."Cooldown"]
	self.Quest = _G[name.."IconQuestTexture"]

	self.Border = CreateFrame("Frame", nil, self)
	if ElvUI then
		self.Border:SetPoint("TOPLEFT", self.Icon, 0, 0)
		self.Border:SetPoint("BOTTOMRIGHT", self.Icon, 0, 0)
		self.Border:SetBackdrop({
			edgeFile = "Interface\\Buttons\\WHITE8x8",
			edgeSize = bordersize,
		})
		self.Border:SetBackdropBorderColor(unpack(ElvUI[1].media.bordercolor))
	else
		self.Border:SetPoint("TOPLEFT", self.Icon, 0, 0)
		self.Border:SetPoint("BOTTOMRIGHT", self.Icon, 0, 0)
		self.Border:SetBackdrop({
			edgeFile = "Interface\\Buttons\\WHITE8x8",
			edgeSize = bordersize,
		})
		self.Border:SetBackdropBorderColor(0, 0, 0, 0)
	end

	local questIcon = self:CreateTexture(nil, "OVERLAY")
	questIcon:SetTexture("Interface\\AddOns\\cargBags_Nivaya\\media\\bagQuestIcon.tga")
	questIcon:SetTexCoord(0, 1, 0, 1)
	questIcon:SetInside()
	questIcon:Hide()
	self.questIcon = questIcon

	self.TopString = CreateInfoString(self, "TOP")
	self.BottomString = CreateInfoString(self, "BOTTOM")
	self.CenterString = CreateInfoString(self, "CENTER")
end

--[[!
	Update the button with new item-information
	@param item <table> The itemTable holding information, see Implementation:GetItemInfo()
	@callback OnUpdate(item)
]]
local L = cargBags:GetLocalizedTypes()
local ilvlTypes = {
	[L.ItemClass["Armor"]] = true,
	[L.ItemClass["Weapon"]] = true,
}
local ilvlSubTypes = {
	[GetItemSubClassInfo(3,11)] = true	--Artifact Relic
}

local function ItemButton_Update(self, item)
	if item.texture then
		local tex = item.texture or (cBnivCfg.CompressEmpty and self.bgTex)
		if tex then
			self.Icon:SetTexture(tex)
			self.Icon:SetTexCoord(.08, .92, .08, .92)
		else
			self.Icon:SetColorTexture(1, 1, 1, 0.1)
		end
	else
		if cBnivCfg.CompressEmpty then
			self.Icon:SetTexture(self.bgTex)
			self.Icon:SetTexCoord(.08, .92, .08, .92)
		else
			self.Icon:SetColorTexture(1, 1, 1, 0.1)
		end
	end
	-- Maybe a double check for the border?!
	if item.rarity and item.rarity > 1 then
		local r, g, b = GetItemQualityColor(item.rarity)
		self.Border:SetBackdropBorderColor(r, g, b, 1)
	else
		self.Border:SetBackdropBorderColor(0, 0, 0, 1)
	end

	if(item.count and item.count > 1) then
		self.Count:SetText(item.count >= 1e3 and "*" or item.count)
		self.Count:Show()
	else
		self.Count:Hide()
	end

	self.count = item.count -- Thank you Blizz for not using local variables >.> (BankFrame.lua @ 234 )

	-- Item Cooldown
	if self.Cooldown then
		ElvUI[1]:RegisterCooldown(self.Cooldown)
	end

	-- Durability
	local dCur, dMax = GetContainerItemDurability(item.bagID, item.slotID)
	if dMax and (dMax > 0) and (dCur < dMax) then
		local dPer = (dCur / dMax * 100)
		local r, g, b = ItemColorGradient((dCur/dMax), 1, 0, 0, 1, 1, 0, 0, 1, 0)
		self.TopString:SetText(Round(dPer).."%")
		self.TopString:SetTextColor(r, g, b)
	else
		self.TopString:SetText("")
	end

	-- Item Level
	if item.link then
		if (item.type and (ilvlTypes[item.type] or item.subType and ilvlSubTypes[item.subType])) and item.level > 0 then
			self.BottomString:SetText(item.level)
			self.BottomString:SetTextColor(GetItemQualityColor(item.rarity))
		else
			self.BottomString:SetText("")
		end
	else
		self.BottomString:SetText("")
	end

	-- Junk Icon
	if (self.JunkIcon) then
		if (item.rarity) and (item.rarity == LE_ITEM_QUALITY_POOR and not item.noValue) then
			self.JunkIcon:Show()
		else
			self.JunkIcon:Hide()
		end
	end

	-- Upgrade Icon
	if (self.UpgradeIcon) then
		local itemIsUpgrade = IsContainerItemAnUpgrade(item.bagID, item.slotID)
		if itemIsUpgrade == nil then
			self.UpgradeIcon:SetShown(false)
		else
			self.UpgradeIcon:ClearAllPoints()
			self.UpgradeIcon:SetPoint("TOPLEFT", 1, 0)
			self.UpgradeIcon:SetTexture("Interface\\AddOns\\cargBags_Nivaya\\media\\bagUpgradeIcon.tga")
			self.UpgradeIcon:SetTexCoord(0, 1, 0, 1)
			self.UpgradeIcon:SetSize(24, 24)
			self.UpgradeIcon:SetShown(itemIsUpgrade)
		end
	end

	-- New Item Glow
	if(C_NewItems.IsNewItem(item.bagID, item.slotID)) then
		local _, _, _, quality = GetContainerItemInfo(item.bagID, item.slotID)
		if quality and NEW_ITEM_ATLAS_BY_QUALITY[quality] then
			self.NewItemTexture:SetAtlas(NEW_ITEM_ATLAS_BY_QUALITY[quality])
		else
			self.NewItemTexture:SetAtlas("bags-glow-white")
		end
		self.NewItemTexture:Show()
		if not self.flashAnim:IsPlaying() and not self.newitemglowAnim:IsPlaying() then
			self.flashAnim:Play()
			self.newitemglowAnim:Play()
		end
	end

	-- ArtifactPower
	if item.link then
		local itemID = tonumber(string.match(item.link, "item:(%d+)"))
		local itemHasLegionPower = cache[item.link]

		if (not itemHasLegionPower) then
			if itemID and (not ignored[itemID]) then
				local itemPoints = championArmor[itemID] or ancientMana[itemID]
				if itemPoints then
					cache[item.link] = itemPoints
					itemHasLegionPower = itemPoints

					if championArmor[itemID] then
						local _, _, itemRarity = GetItemInfo(item.link)
						rarityCache[item.link] = itemRarity
					end
				else
					if (IsArtifactPowerItem(itemID)) then
						local artifactPower = GetArtifactPowerFromItem(item.link)
						if (artifactPower) and (artifactPower > 0) then
							-- Cache the item.link, since there can be multiple
							-- instances of the same itemID in your bags.
							cache[item.link] = artifactPower
							itemHasLegionPower = artifactPower
						else
							scanner.owner = self
							scanner:SetOwner(self, "ANCHOR_NONE")
							scanner:SetBagItem(self:GetBag(), self:GetID())

							local line = _G[scannerName.."TextLeft2"]
							if line then
								local msg = line:GetText()
								if msg and string.find(msg, ARTIFACT_POWER) then
									line = _G[scannerName.."TextLeft4"]
									if line then
										msg = line:GetText()
										if msg then
											msg = string.gsub(msg, ",", "")

											local artifactPower = string.match(msg, "(%d+)")
											if artifactPower then
												-- Cache the item.link, since there can be multiple 
												-- instances of the same itemID in your bags. 
												cache[item.link] = artifactPower
												itemHasLegionPower = artifactPower
											end
										end
									end
								else
									-- Don't scan this itemID again this session, it has no AP!
									ignored[itemID] = true
								end
							end
						end
					else
						-- Don't scan this itemID again this session, it has no AP!
						ignored[itemID] = true
					end
				end
			end
		end

		if itemHasLegionPower then
			if (not strings[self]) then
				-- Adding an extra layer to get it above glow and border textures
				local holder = _G[self:GetName().."ExtraInfoFrame"] or CreateFrame("Frame", self:GetName().."ExtraInfoFrame", self)
				holder:SetAllPoints()

				local itemAP = holder:CreateFontString()
				itemAP:SetDrawLayer("ARTWORK")
				itemAP:SetPoint("CENTER", 1, 1)
				itemAP:SetFont(ElvUI[1].media.normFont, 9, "OUTLINE")
				itemAP:SetShadowOffset(1, -1)
				itemAP:SetShadowColor(0, 0, 0, .75)
				itemAP:SetTextColor(ARTIFACT_COLOR.r, ARTIFACT_COLOR.g, ARTIFACT_COLOR.b)

				strings[self] = itemAP
			end

			local itemAP = strings[self]
			itemAP:SetFormattedText("%s", shorten(itemHasLegionPower))

			local itemRarity = rarityCache[item.Link]
			if itemRarity then
				local r, g, b = GetItemQualityColor(itemRarity)
				itemAP:SetTextColor(r, g, b)
			else
				itemAP:SetTextColor(ARTIFACT_COLOR.r, ARTIFACT_COLOR.g, ARTIFACT_COLOR.b)
			end

		else
			if strings[self] then
				strings[self]:SetText("")
			end
		end
	else
		if strings[self] then
			strings[self]:SetText("")
		end
	end

	self:UpdateCooldown(item)
	self:UpdateLock(item)
	self:UpdateQuest(item)

	if(self.OnUpdate) then self:OnUpdate(item) end
end

--[[!
	Updates the buttons cooldown with new item-information
	@param item <table> The itemTable holding information, see Implementation:GetItemInfo()
	@callback OnUpdateCooldown(item)
]]
local function ItemButton_UpdateCooldown(self, item)
	if(item.cdEnable == 1 and item.cdStart and item.cdStart > 0) then
		self.Cooldown:SetCooldown(item.cdStart, item.cdFinish)
		self.Cooldown:Show()
	else
		self.Cooldown:Hide()
	end

	if(self.OnUpdateCooldown) then self:OnUpdateCooldown(item) end
end

--[[!
	Updates the buttons lock with new item-information
	@param item <table> The itemTable holding information, see Implementation:GetItemInfo()
	@callback OnUpdateLock(item)
]]
local function ItemButton_UpdateLock(self, item)
	self.Icon:SetDesaturated(item.locked)

	if(self.OnUpdateLock) then self:OnUpdateLock(item) end
end

--[[!
	Updates the buttons quest texture with new item information
	@param item <table> The itemTable holding information, see Implementation:GetItemInfo()
	@callback OnUpdateQuest(item)
]]
local function ItemButton_UpdateQuest(self, item)
	if item.questID or item.isQuestItem then
		self.Border:SetBackdropBorderColor(1, 0.3, 0.3, 1)
	elseif item.rarity and item.rarity > 1 then
		local r, g, b = GetItemQualityColor(item.rarity)
		self.Border:SetBackdropBorderColor(r, g, b, 1)
	else
		self.Border:SetBackdropBorderColor(0, 0, 0, 1)
	end

	-- Quest Icons
	local isQuestItem, questId, isActiveQuest = GetContainerItemQuestInfo(item.bagID, item.slotID)
	if questId and not isActiveQuest then
		self.questIcon:Show()
	else
		self.questIcon:Hide()
	end

	if(self.OnUpdateQuest) then self:OnUpdateQuest(item) end
end

cargBags:RegisterScaffold("Default", function(self)
	self.glowTex = "Interface\\Buttons\\UI-ActionButton-Border" --! @property glowTex <string> The textures used for the glow
	self.glowAlpha = 0.8 --! @property glowAlpha <number> The alpha of the glow texture
	self.glowBlend = "ADD" --! @property glowBlend <string> The blendMode of the glow texture
	self.glowCoords = { 14/64, 50/64, 14/64, 50/64 } --! @property glowCoords <table> Indexed table of texCoords for the glow texture
	self.bgTex = nil --! @property bgTex <string> Texture used as a background if no item is in the slot

	self.CreateFrame = ItemButton_CreateFrame
	self.Scaffold = ItemButton_Scaffold

	self.Update = ItemButton_Update
	self.UpdateCooldown = ItemButton_UpdateCooldown
	self.UpdateLock = ItemButton_UpdateLock
	self.UpdateQuest = ItemButton_UpdateQuest

	self.OnEnter = ItemButton_OnEnter
	self.OnLeave = ItemButton_OnLeave
end)