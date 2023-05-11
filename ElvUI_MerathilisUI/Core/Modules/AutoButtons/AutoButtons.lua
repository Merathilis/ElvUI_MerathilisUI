local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_AutoButtons')
local async = MER.Utilities.Async
local S = MER:GetModule('MER_Skins')
local AB = E:GetModule('ActionBars')

local _G = _G
local ceil = ceil
local format = format
local gsub = gsub
local ipairs = ipairs
local pairs = pairs
local strmatch = strmatch
local strsplit = strsplit
local tinsert = tinsert
local tonumber = tonumber
local unpack = unpack
local wipe = wipe

local CooldownFrame_Set = CooldownFrame_Set
local CreateFrame = CreateFrame
local CreateAtlasMarkup = CreateAtlasMarkup
local GameTooltip = _G.GameTooltip
local GetBindingKey = GetBindingKey
local GetInventoryItemCooldown = GetInventoryItemCooldown
local GetInventoryItemID = GetInventoryItemID
local GetItemCooldown = GetItemCooldown
local GetItemCount = GetItemCount
local GetQuestLogSpecialItemCooldown = GetQuestLogSpecialItemCooldown
local GetQuestLogSpecialItemInfo = GetQuestLogSpecialItemInfo
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsItemInRange = IsItemInRange
local IsUsableItem = IsUsableItem
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

local C_Container_GetItemCooldown = C_Container and C_Container.GetItemCooldown
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog and C_QuestLog.GetNumQuestLogEntries
local C_Timer_NewTicker = C_Timer.NewTicker
local C_TradeSkillUI_GetItemCraftedQualityByItemInfo = C_TradeSkillUI and C_TradeSkillUI.GetItemCraftedQualityByItemInfo
local C_TradeSkillUI_GetItemReagentQualityByItemInfo = C_TradeSkillUI and C_TradeSkillUI.GetItemReagentQualityByItemInfo

module.bars = {}

-- Potion (require level >= 40)
local potions = {
	-- Normal
	5512,
	177278,
	-- Potions
	109217,
	109218,
	109219,
	109220,
	109221,
	109222,
	109226,
	114124,
	115531,
	116925,
	118278,
	118910,
	118911,
	118912,
	118913,
	118914,
	118915,
	122453,
	122454,
	122455,
	122456,
	127834,
	127835,
	127836,
	127843,
	127844,
	127845,
	127846,
	136569,
	142117,
	142325,
	142326,
	144396,
	144397,
	144398,
	152494,
	152495,
	152497,
	152503,
	152550,
	152557,
	152559,
	152560,
	152561,
	152615,
	152619,
	163082,
	163222,
	163223,
	163224,
	163225,
	167917,
	167918,
	167919,
	167920,
	168489,
	168498,
	168499,
	168500,
	168501,
	168502,
	168506,
	168529,
	169299,
	169300,
	169451,
	171263,
	171264,
	171266,
	171267,
	171268,
	171269,
	171270,
	171271,
	171272,
	171273,
	171274,
	171275,
	171349,
	171350,
	171351,
	171352,
	171370,
	176811,
	180317,
	180318,
	180771,
	183823,
	184090,
	187802,
	191351,
	191352,
	191353,
	191360,
	191361,
	191362,
	191363,
	191364,
	191365,
	191366,
	191367,
	191368,
	191369,
	191370,
	191371,
	191372,
	191373,
	191374,
	191375,
	191376,
	191377,
	191378,
	191379,
	191380,
	191381,
	191382,
	191383,
	191384,
	191385,
	191386,
	191387,
	191388,
	191389,
	191393,
	191394,
	191395,
	191396,
	191397,
	191398,
	191399,
	191400,
	191401,
	191905,
	191906,
	191907,
	191912,
	191913,
	191914,
}

if E.Classic then
	tinsert(potions, 13446)
	tinsert(potions, 13444)
end

local potionsDragonflight = {
	-- Normal
	5512,
	--- Dragonflight
	191351,
	191352,
	191353,
	191360,
	191361,
	191362,
	191363,
	191364,
	191365,
	191366,
	191367,
	191368,
	191369,
	191370,
	191371,
	191372,
	191373,
	191374,
	191375,
	191376,
	191377,
	191378,
	191379,
	191380,
	191381,
	191382,
	191383,
	191384,
	191385,
	191386,
	191387,
	191388,
	191389,
	191393,
	191394,
	191395,
	191396,
	191397,
	191398,
	191399,
	191400,
	191401,
	191905,
	191906,
	191907,
	191912,
	191913,
	191914,
}

-- Flasks (require level >= 40)
local flasks = {
	127847,
	127848,
	127849,
	127850,
	127858,
	152638,
	152639,
	152640,
	152641,
	162518,
	168651,
	168652,
	168653,
	168654,
	168655,
	171276,
	171278,
	171280,
	191318,
	191319,
	191320,
	191321,
	191322,
	191323,
	191324,
	191325,
	191326,
	191327,
	191328,
	191329,
	191330,
	191331,
	191332,
	191333,
	191334,
	191335,
	191336,
	191337,
	191338,
	191339,
	191340,
	191341,
	191342,
	191343,
	191344,
	191345,
	191346,
	191347,
	191348,
	191349,
	191350,
	191354,
	191355,
	191356,
	191357,
	191358,
	191359,
	197720,
	197721,
	197722,
}

local flasksDragonflight = {
	191318,
	191319,
	191320,
	191321,
	191322,
	191323,
	191324,
	191325,
	191326,
	191327,
	191328,
	191329,
	191330,
	191331,
	191332,
	191333,
	191334,
	191335,
	191336,
	191337,
	191338,
	191339,
	191340,
	191341,
	191342,
	191343,
	191344,
	191345,
	191346,
	191347,
	191348,
	191349,
	191350,
	191354,
	191355,
	191356,
	191357,
	191358,
	191359,
	197720,
	197721,
	197722,
}

-- Runes
local runes = {
	160053,
	181468,
	194817,
	194819,
	194820,
	194821,
	194822,
	194823,
	194824,
	194825,
	194826,
	198491,
	198492,
	198493,
	201325
}

-- Runes added in Dragonflight
local runesDragonflight = {
	194817,
	194819,
	194820,
	194821,
	194822,
	194823,
	194824,
	194825,
	194826,
	198491,
	198492,
	198493,
	201325
}

-- Foods (Crafted by cooking)
local food = {
	133557,
	133561,
	133562,
	133563,
	133564,
	133565,
	133566,
	133567,
	133568,
	133569,
	133570,
	133571,
	133572,
	133573,
	133574,
	133575,
	133576,
	133577,
	133578,
	133579,
	133681,
	142334,
	154881,
	154882,
	154883,
	154884,
	154885,
	154886,
	154887,
	154889,
	154891,
	156525,
	156526,
	163781,
	165755,
	166240,
	166343,
	166344,
	166804,
	168310,
	168312,
	168313,
	168314,
	168315,
	169280,
	172040,
	172041,
	172042,
	172043,
	172044,
	172045,
	172046,
	172047,
	172048,
	172049,
	172050,
	172051,
	172061,
	172062,
	172063,
	172068,
	172069,
	184682,
	186704,
	186725,
	186726,
	197758,
	197759,
	197760,
	197761,
	197762,
	197763,
	197766,
	197767,
	197768,
	197769,
	197770,
	197772,
	197774,
	197775,
	197776,
	197777,
	197778,
	197779,
	197780,
	197781,
	197782,
	197783,
	197784,
	197785,
	197786,
	197787,
	197788,
	197789,
	197790,
	197791,
	197792,
	197793,
	197794,
	197795,
}

local foodDragonflight = {
	197758,
	197759,
	197760,
	197761,
	197762,
	197763,
	197766,
	197767,
	197768,
	197769,
	197770,
	197771,
	197772,
	197774,
	197775,
	197776,
	197777,
	197778,
	197779,
	197780,
	197781,
	197782,
	197783,
	197784,
	197785,
	197786,
	197787,
	197788,
	197789,
	197790,
	197791,
	197792,
	197793,
	197794,
	197795,
	204072,
}

local foodDragonflightVendor = {
	194680,
	194681,
	194683,
	194684,
	194685,
	194688,
	194689,
	194690,
	194691,
	194692,
	194693,
	194694,
	194695,
	195455,
	195456,
	195457,
	195459,
	195462,
	195463,
	195466,
	196440,
	196540,
	196582,
	196583,
	196584,
	196585,
	197771,
	197847,
	197848,
	197849,
	197850,
	197851,
	197852,
	197853,
	197854,
	197855,
	197856,
	197857,
	197858,
	198440,
	198441,
	200099,
	200304,
	200305,
	200619,
	200680,
	200681,
	200855,
	200856,
	200871,
	201045,
	201089,
	201327,
	201398,
	201413,
	201415,
	201416,
	201417,
	201419,
	201820,
}

local conjuredManaFood = {
	22044, -- mana gem TBC
	33312, -- mana gem WRATH
	36892, -- healthstone WRATH
	36893, -- healthstone WRATH
	36894, -- healthstone WRATH
	36891, -- healthstone WRATH
	36890, -- healthstone WRATH
	36889, -- healthstone WRATH
	22105, -- healthstone TBC
	22104, -- healthstone TBC
	22103, -- healthstone TBC
	34062,
	43518,
	43523,
	65499,
	65500,
	65515,
	65516,
	65517,
	80610,
	80618,
	113509
}

local banners = {
	63359,
	64400,
	64398,
	64401,
	64399,
	64402,
	18606,
	18607,
}

local utilities = {
	49040,
	109076,
	132514,
	132516,
	191933,
	191939,
	191940,
	191943,
	191944,
	191945,
	191948,
	191949,
	191950,
	193470,
	198160,
	198161,
	198162,
	198163,
	198164,
	198165,
	199414,

	34721, -- First Aid bandage WRATH
	34722, -- First Aid bandage WRATH
}

local openableItems = {
	54537,
	92794,
	171209,
	171210,
	171211,
	174652,
	178040,
	178078,
	178128,
	178513,
	178965,
	178966,
	178967,
	178968,
	180085,
	180355,
	180378,
	180379,
	180380,
	180386,
	180442,
	180646,
	180647,
	180648,
	180649,
	180875,
	180974,
	180975,
	180976,
	180977,
	180979,
	180980,
	180981,
	180983,
	180984,
	180985,
	180988,
	180989,
	181372,
	181475,
	181476,
	181556,
	181557,
	181732,
	181733,
	181741,
	181767,
	182590,
	182591,
	183699,
	183701,
	183702,
	183703,
	184045,
	184046,
	184047,
	184048,
	184158,
	184395,
	184444,
	184522,
	184589,
	184630,
	184631,
	184632,
	184633,
	184634,
	184635,
	184636,
	184637,
	184638,
	184639,
	184640,
	184641,
	184642,
	184643,
	184644,
	184645,
	184646,
	184647,
	184648,
	184810,
	184811,
	184812,
	184843,
	184868,
	184869,
	185765,
	185832,
	185833,
	185972,
	185990,
	185991,
	185992,
	185993,
	186196,
	186533,
	186650,
	186680,
	186691,
	186694,
	186705,
	186706,
	186707,
	186708,
	187028,
	187029,
	187221,
	187222,
	187254,
	187278,
	187351,
	187354,
	187440,
	187503,
	187543,
	187551,
	187569,
	187570,
	187571,
	187572,
	187573,
	187574,
	187575,
	187576,
	187577,
	187780,
	187781,
	187817,
	189765,
	190178,
	190610,
	191040,
	191041,
	191139,
	192438,
	198863,
	198864,
	198865,
	198866,
	198867,
	198868,
	198869,
	199192,
	199472,
	199473,
	199474,
	199475,
	200069,
	200070,
	200072,
	200073,
	200094,
	200095,
	200468,
	200513,
	200515,
	200516,
	201754,
	201755,
	201756,
	201817,
	201818,
	202079,
	202142,
	202171,
	202172,
	202371,
	202080,
	203217,
	203220,
	203222,
	203224,
	203476,
	203700,
	204359,
	204378,
	204379,
	204380,
	204381,
	204383,
	204712,
	205226,
	205247,
	205248,
	205288,
	205346,
	205347,
	205423,
	205964,
	205965,
	205983,
	206135,
}

local tbcOre = {
	23424,
	23425,
	23426,
	23427,
	2770,
	2771,
	2775,
	2772,
	2776,
	3858,
	7911,
	10620,
	14891,
}

local tbcPotions = {
	33093,
	33092,
	22849,
	22839,
	22838,
	22837,
	22836,
	28962,
	34440,
	22871,
	22828,
	22826,
	22846,
	22844,
	22847,
	22842,
	22841,
	22850,
	22829,
	28100,
	31677,
	22832,
	28101,
}

local tbcElixirs = {
	22848,
	22840,
	22835,
	22834,
	22833,
	32067,
	31679,
	32068,
	28104,
	22831,
	32062,
	22830,
	22825,
	32063,
	22827,
	22824,
	28103,
	28102,
	22823,
}

local tbcFlasks = {
	22866,
	22854,
	22853,
	22851,
	22861,
	33208,
}

local tbcCauldrons = {
	32852,
	32851,
	32850,
	32849,
	32839,
}

local wrathPotions = {
	25539,
	33447,
	33448,
	39327,
	40068,
	40070,
	40073,
	40076,
	40078,
	40081,
	40087,
	40093,
	40097,
	40109,
	40211,
	40212,
	40213,
	40214,
	40215,
	40216,
	40217,
	43569,
	43570,
	40077,
	41166,
	42545,
	22850,
	34440,
	39671,
	40067,
}

local wrathFlasks = {
	40079,
	44939,
	46376,
	46377,
	46379,
	45006,
	45007,
	45008,
	45009,
	46378,
	47499,
	44939,
	32764,
	32765,
	32766,
}

local wrathElixirs = {
	39666,
	40068,
	40070,
	40072,
	40073,
	40076,
	40078,
	40097,
	40109,
	44325,
	44327,
	44328,
	44329,
	44330,
	44331,
	44332,
	8827, -- waterwalking elixir
	8529, -- noggenfogger elixir
}

-- Profession Items
local professionItems = {
	192131,
	192132,
	192443,
	193891,
	193897,
	193898,
	193899,
	193900,
	193901,
	193902,
	193903,
	193904,
	193905,
	193907,
	193909,
	193910,
	193913,
	194039,
	194040,
	194041,
	194042,
	194043,
	194044,
	194045,
	194046,
	194047,
	194054,
	194055,
	194061,
	194062,
	194063,
	194064,
	194078,
	194079,
	194080,
	194081,
	194697,
	194698,
	194699,
	194700,
	194702,
	194703,
	194704,
	194708,
	198156,
	198454,
	198510,
	198518,
	198519,
	198520,
	198521,
	198522,
	198523,
	198524,
	198525,
	198526,
	198527,
	198528,
	198599,
	198606,
	198607,
	198608,
	198609,
	198610,
	198611,
	198612,
	198613,
	198656,
	198658,
	198659,
	198660,
	198662,
	198663,
	198664,
	198667,
	198669,
	198670,
	198675,
	198680,
	198682,
	198683,
	198684,
	198685,
	198686,
	198687,
	198689,
	198690,
	198692,
	198693,
	198694,
	198696,
	198697,
	198699,
	198702,
	198703,
	198704,
	198710,
	198711,
	198712,
	198789,
	198791,
	198798,
	198799,
	198800,
	198836,
	198837,
	198841,
	198963,
	198964,
	198965,
	198966,
	198967,
	198968,
	198969,
	198970,
	198971,
	198972,
	198973,
	198974,
	198975,
	198976,
	198977,
	198978,
	199115,
	199122,
	199128,
	200677,
	200678,
	200972,
	200973,
	200974,
	200975,
	200976,
	200977,
	200978,
	200979,
	200980,
	200981,
	200982,
	201003,
	201004,
	201005,
	201006,
	201007,
	201008,
	201009,
	201010,
	201011,
	201012,
	201013,
	201014,
	201015,
	201016,
	201017,
	201018,
	201019,
	201020,
	201023,
	201268,
	201269,
	201270,
	201271,
	201272,
	201273,
	201274,
	201275,
	201276,
	201277,
	201278,
	201279,
	201280,
	201281,
	201282,
	201283,
	201284,
	201285,
	201286,
	201287,
	201288,
	201289,
	201300,
	201301,
	201356,
	201357,
	201358,
	201359,
	201360,
	201700,
	201705,
	201706,
	201708,
	201709,
	201710,
	201711,
	201712,
	201713,
	201715,
	201716,
	201717,
	202011,
	202014,
	202016,
	203471,
	204222,
	204224,
	204225,
	204226,
	204227,
	204228,
	204229,
	204230,
	204231,
	204232,
	204233,
	204469,
	204470,
	204471,
	204475,
	204480,
	204850,
	204853,
	204855,
	204986,
	204987,
	204988,
	204990,
	204999,
	205001,
	205211,
	205212,
	205213,
	205214,
	205216,
	205219,
	205986,
	205987,
	205988,
	206019,
	206025,
	206030,
	206031,
	206034,
	206035,
}

local questItemList = {}
local function UpdateQuestItemList()
	if not E.Retail then return end
	wipe(questItemList)
	for questLogIndex = 1, C_QuestLog_GetNumQuestLogEntries() do
		local link = GetQuestLogSpecialItemInfo(questLogIndex)
		if link then
			local itemID = tonumber(strmatch(link, "|Hitem:(%d+):"))
			local data = {questLogIndex = questLogIndex, itemID = itemID}
			tinsert(questItemList, data)
		end
	end
end

-- Usable Items beeing ignored for some reasons
local forceUsableItems = {
	[193634] = true -- Burgeoning Seed
}

local equipmentList = {}
local function UpdateEquipmentList()
	wipe(equipmentList)
	for slotID = 1, 18 do
		local itemID = GetInventoryItemID("player", slotID)
		if itemID and (IsUsableItem(itemID) or forceUsableItems[itemID]) then
			tinsert(equipmentList, slotID)
		end
	end
end

local UpdateAfterCombat = {
	[1] = false,
	[2] = false,
	[3] = false,
}

local moduleList = {
	["POTION"] = potions,
	["FLASK"] = flasks,
	["FOOD"] = food,
	["FOODVENDOR"] = foodDragonflightVendor,
	["RUNE"] = runes,
	["RUNEDF"] = runesDragonflight,
	["MAGEFOOD"] = conjuredManaFood,
	["BANNER"] = banners,
	["UTILITY" ] = utilities,
	["OPENABLE"] = openableItems,
	["PROF"] = professionItems,
	["ORETBC"] = tbcOre,
	["POTIONTBC"] = tbcPotions,
	["FLASKSTBC"] = tbcFlasks,
	["CAULDRONTBC"] = tbcCauldrons,
	["ELIXIRTBC"] = tbcElixirs,
	["POTIONSWRATH"] = wrathPotions,
	["FLASKWRATH"] = wrathFlasks,
	["ELIXIRWRATH"] = wrathElixirs,
	["POTIONDF"] = potionsDragonflight,
	["FLASKDF"] = flasksDragonflight,
	["FOODDF"] = foodDragonflight
}

function module:CreateButton(name, barDB)
	local button = CreateFrame("Button", name, E.UIParent, "SecureActionButtonTemplate")
	button:Size(barDB.buttonWidth, barDB.buttonHeight)
	button:SetTemplate()
	button:SetClampedToScreen(true)
	button:SetAttribute("type", "item")
	button:EnableMouse(false)
	button:RegisterForClicks(MER.UseKeyDown and "AnyDown" or "AnyUp")

	local tex = button:CreateTexture(nil, "OVERLAY", nil)
	tex:Point("TOPLEFT", button, "TOPLEFT", 1, -1)
	tex:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
	tex:SetTexCoord(unpack(E.TexCoords))

	local qualityTier = button:CreateFontString(nil, "OVERLAY")
	qualityTier:SetTextColor(1, 1, 1, 1)
	qualityTier:SetPoint("TOPLEFT", button, "TOPLEFT")
	qualityTier:SetJustifyH("CENTER")
	F.SetFontDB(qualityTier, {
		size = barDB.qualityTier.size,
		name = E.db.general.font,
		style = "OUTLINE"
	})

	local count = button:CreateFontString(nil, "OVERLAY")
	count:SetTextColor(1, 1, 1, 1)
	count:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT")
	count:SetJustifyH("CENTER")
	F.SetFontDB(count, barDB.countFont)

	local bind = button:CreateFontString(nil, "OVERLAY")
	bind:SetTextColor(0.6, 0.6, 0.6)
	bind:Point("TOPRIGHT", button, "TOPRIGHT")
	bind:SetJustifyH("CENTER")
	F.SetFontDB(bind, barDB.bindFont)

	local cooldown = CreateFrame("Cooldown", name .. "Cooldown", button, "CooldownFrameTemplate")
	E:RegisterCooldown(cooldown)

	button.tex = tex
	button.qualityTier = qualityTier
	button.count = count
	button.bind = bind
	button.cooldown = cooldown

	if E.Retail then
		button.SetTier = function(self, itemIDOrLink)
			local level = C_TradeSkillUI_GetItemReagentQualityByItemInfo(itemIDOrLink) or C_TradeSkillUI_GetItemCraftedQualityByItemInfo(itemIDOrLink)

			if not level or level == 0 then
				self.qualityTier:SetText("")
				self.qualityTier:Hide()
			else
				self.qualityTier:SetText(CreateAtlasMarkup(format("Professions-Icon-Quality-Tier%d-Small", level)))
				self.qualityTier:Show()
			end
		end
	end

	button:StyleButton()

	S:CreateShadowModule(button)
	S:BindShadowColorWithBorder(button.MERshadow, button)

	return button
end

function module:SetUpButton(button, itemData, slotID, waitGroup)
	button.itemName = nil
	button.itemID = nil
	button.spellName = nil
	button.slotID = nil
	button.countText = nil

	if itemData then
		button.itemID = itemData.itemID
		button.countText = GetItemCount(itemData.itemID, nil, true)
		button.questLogIndex = itemData.questLogIndex
		button:SetBackdropBorderColor(0, 0, 0)

		waitGroup.count = waitGroup.count + 1
		async.WithItemID(itemData.itemID, function(item)
			button.itemName = item:GetItemName()
			button.tex:SetTexture(item:GetItemIcon())
			if E.Retail then
				button:SetTier(itemData.itemID)
			end

			E:Delay(0.1, function()
				-- delay for quality tier fetching and text changing
				waitGroup.count = waitGroup.count - 1
			end)
		end)
	elseif slotID then
		button.slotID = slotID

		waitGroup.count = waitGroup.count + 1
		async.WithItemSlotID(slotID, function(item)
			button.itemName = item:GetItemName()
			button.tex:SetTexture(item:GetItemIcon())

			local color = item:GetItemQualityColor()
			if color then
				button:SetBackdropBorderColor(color.r, color.g, color.b)
			end

			if E.Retail then
				button:SetTier(item:GetItemID())
			end

			E:Delay(0.1, function()
				-- delay for quality tier fetching and text changing
				waitGroup.count = waitGroup.count - 1
			end)
		end)
	end

	if button.countText and button.countText > 1 then
		button.count:SetText(button.countText)
	else
		button.count:SetText()
	end

	local OnUpdateFunction

	if button.itemID then
		OnUpdateFunction = function(self)
			local start, duration, enable
			if self.questLogIndex and self.questLogIndex > 0 then
				start, duration, enable = GetQuestLogSpecialItemCooldown(self.questLogIndex)
				else
				if E.Retail then
					start, duration, enable = GetItemCooldown(self.itemID)
				elseif E.Wrath then
					start, duration, enable = C_Container_GetItemCooldown(self.itemID)
				end
			end
			CooldownFrame_Set(self.cooldown, start, duration, enable)
			if (duration and duration > 0 and enable and enable == 0) then
				self.tex:SetVertexColor(0.4, 0.4, 0.4)
			elseif IsItemInRange(self.itemID, "target") == false then
				self.tex:SetVertexColor(1, 0, 0)
			else
				self.tex:SetVertexColor(1, 1, 1)
			end
		end
	elseif button.slotID then
		OnUpdateFunction = function(self)
			local start, duration, enable = GetInventoryItemCooldown("player", self.slotID)
			CooldownFrame_Set(self.cooldown, start, duration, enable)
		end
	end

	button:SetScript("OnUpdate", OnUpdateFunction)

	button:SetScript("OnEnter", function(self)
		local bar = self:GetParent()
		local barDB = module.db["bar" .. bar.id]
		if not bar or not barDB then
			return
		end

		if barDB.globalFade then
			if AB.fadeParent and not AB.fadeParent.mouseLock then
				E:UIFrameFadeIn(AB.fadeParent, 0.2, AB.fadeParent:GetAlpha(), 1)
			end
		elseif barDB.mouseOver then
			local alphaCurrent = bar:GetAlpha()
			E:UIFrameFadeIn(bar, barDB.fadeTime * (barDB.alphaMax - alphaCurrent) / (barDB.alphaMax - barDB.alphaMin), alphaCurrent, barDB.alphaMax)
		end

		if barDB.tooltip then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, -2)
			GameTooltip:ClearLines()

			if self.slotID then
				GameTooltip:SetInventoryItem("player", self.slotID)
			else
				GameTooltip:SetItemByID(self.itemID)
			end

			GameTooltip:Show()
		end
	end)

	button:SetScript("OnLeave", function(self)
		local bar = self:GetParent()
		local barDB = module.db["bar" .. bar.id]
		if not bar or not barDB then
			return
		end

		if barDB.globalFade then
			if AB.fadeParent and not AB.fadeParent.mouseLock then
				E:UIFrameFadeOut(AB.fadeParent, 0.2, AB.fadeParent:GetAlpha(), 1 - AB.db.globalFadeAlpha)
			end
		elseif barDB.mouseOver then
			local alphaCurrent = bar:GetAlpha()
			E:UIFrameFadeOut(bar, barDB.fadeTime * (alphaCurrent - barDB.alphaMin) / (barDB.alphaMax - barDB.alphaMin), alphaCurrent, barDB.alphaMin)
		end

		GameTooltip:Hide()
	end)

	if not InCombatLockdown() then
		button:EnableMouse(true)
		button:Show()
		button:SetAttribute("type", "macro")

		local macroText
		if button.slotID then
			macroText = "/use " .. button.slotID
		elseif button.itemName then
			macroText = "/use item:" .. button.itemID
			if button.itemID == 172347 then
				macroText = macroText .. "\n/use 5"
			end
		end

		if macroText then
			button:SetAttribute("macrotext", macroText)
		end
	end
end

function module:UpdateButtonSize(button, barDB)
	button:Size(barDB.buttonWidth, barDB.buttonHeight)
	local left, right, top, bottom = unpack(E.TexCoords)

	if barDB.buttonWidth > barDB.buttonHeight then
		local offset = (bottom - top) * (1 - barDB.buttonHeight / barDB.buttonWidth) / 2
		top = top + offset
		bottom = bottom - offset
	elseif barDB.buttonWidth < barDB.buttonHeight then
		local offset = (right - left) * (1 - barDB.buttonWidth / barDB.buttonHeight) / 2
		left = left + offset
		right = right - offset
	end

	button.tex:SetTexCoord(left, right, top, bottom)
end

function module:PLAYER_REGEN_ENABLED()
	for i = 1, 5 do
		if UpdateAfterCombat[i] then
			self:UpdateBar(i)
			UpdateAfterCombat[i] = false
		end
	end
end

function module:UpdateBarTextOnCombat(i)
	for k = 1, 12 do
		local button = module.bars[i].buttons[k]
		if button.itemID and button:IsShown() then
			button.countText = GetItemCount(button.itemID, nil, true)
			if button.countText and button.countText > 1 then
				button.count:SetText(button.countText)
			else
				button.count:SetText()
			end
		end
	end
end

function module:CreateBar(id)
	if not self.db or not self.db["bar" .. id] then
		return
	end

	local barDB = self.db["bar" .. id]
	local anchor = CreateFrame("Frame", "AutoButtonBar" .. id .. "Anchor", E.UIParent)
	anchor:SetClampedToScreen(true)
	anchor:Point("BOTTOMLEFT", _G.RightChatPanel or _G.LeftChatPanel, "TOPLEFT", 0, (id - 1) * 45)
	anchor:Size(150, 40)
	E:CreateMover(anchor, 'AutoButtonBar' .. id .. 'Mover', L['Auto Button Bar'] .. ' ' .. id, nil, nil, nil, 'ALL,MERATHILISUI', function() return module.db.enable and barDB.enable end, 'mui,modules,autoButtons,bar'..id)

	local bar = CreateFrame("Frame", "AutoButtonBar" .. id, E.UIParent, "SecureHandlerStateTemplate")
	bar.id = id
	bar:ClearAllPoints()
	bar:SetParent(anchor)
	bar:SetPoint("CENTER", anchor, "CENTER", 0, 0)
	bar:Size(150, 40)
	bar:CreateBackdrop("Transparent")
	bar.backdrop:Styling()
	bar:SetFrameStrata("LOW")

	bar.buttons = {}
	for i = 1, 12 do
		bar.buttons[i] = self:CreateButton(bar:GetName() .. "Button" .. i, barDB)
		bar.buttons[i]:SetParent(bar)
		if i == 1 then
			bar.buttons[i]:Point("LEFT", bar, "LEFT", 5, 0)
		else
			bar.buttons[i]:Point("LEFT", bar.buttons[i - 1], "RIGHT", 5, 0)
		end
	end

	bar:SetScript("OnEnter", function(self)
		if not barDB then
			return
		end

		if not barDB.globalFade and barDB.mouseOver and barDB.alphaMax and barDB.alphaMin then
			local alphaCurrent = bar:GetAlpha()
			E:UIFrameFadeIn(bar, barDB.fadeTime * (barDB.alphaMax - alphaCurrent) / (barDB.alphaMax - barDB.alphaMin), alphaCurrent, barDB.alphaMax)
		end
	end)

	bar:SetScript("OnLeave", function(self)
		if not barDB then
			return
		end

		if not barDB.globalFade and barDB.mouseOver and barDB.alphaMax and barDB.alphaMin then
			local alphaCurrent = bar:GetAlpha()
			E:UIFrameFadeOut(bar, barDB.fadeTime * (alphaCurrent - barDB.alphaMin) / (barDB.alphaMax - barDB.alphaMin), alphaCurrent, barDB.alphaMin)
		end
	end)

	module.bars[id] = bar
end

function module:UpdateBar(id)
	if not self.db or not self.db["bar" .. id] then
		return
	end

	local bar = module.bars[id]
	local barDB = self.db["bar" .. id]

	if bar.waitGroup and bar.waitGroup.ticker then
		bar.waitGroup.ticker:Cancel()
	end

	bar.waitGroup = { count = 0 }

	if InCombatLockdown() then
		self:UpdateBarTextOnCombat(id)
		UpdateAfterCombat[id] = true
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	if not self.db.enable or not barDB.enable then
		if bar.register then
			UnregisterStateDriver(bar, "visibility")
			bar.register = false
		end
		bar:Hide()
		return
	end

	local buttonID = 1
	local function addButtons(list)
		for _, itemID in pairs(list) do
			local count = GetItemCount(itemID)
			if count and count > 0 and not self.db.blackList[itemID] and buttonID <= barDB.numButtons then
				self:SetUpButton(bar.buttons[buttonID], { itemID = itemID }, nil, bar.waitGroup)
				self:UpdateButtonSize(bar.buttons[buttonID], barDB)
				buttonID = buttonID + 1
			end
		end
	end

	for _, module in ipairs{strsplit("[, ]", barDB.include)} do
		if buttonID <= barDB.numButtons then
			if moduleList[module] then
				addButtons(moduleList[module])
			elseif module == "QUEST" then
				for _, data in pairs(questItemList) do
					if not self.db.blackList[data.itemID] then
						self:SetUpButton(bar.buttons[buttonID], data, nil, bar.waitGroup)
						self:UpdateButtonSize(bar.buttons[buttonID], barDB)
						buttonID = buttonID + 1
					end
				end
			elseif module == "EQUIP" then
				for _, slotID in pairs(equipmentList) do
					local itemID = GetInventoryItemID("player", slotID)
					if itemID and not self.db.blackList[itemID] and buttonID <= barDB.numButtons then
						self:SetUpButton(bar.buttons[buttonID], nil, slotID, bar.waitGroup)
						self:UpdateButtonSize(bar.buttons[buttonID], barDB)
						buttonID = buttonID + 1
					end
				end
			elseif module == "CUSTOM" then
				addButtons(self.db.customList)
			end
		end
	end

	if buttonID == 1 then
		if bar.register then
			UnregisterStateDriver(bar, "visibility")
			bar.register = false
		end
		bar:Hide()
		return
	end

	if buttonID <= 12 then
		for hideButtonID = buttonID, 12 do
			bar.buttons[hideButtonID]:Hide()
		end
	end

	local numRows = ceil((buttonID - 1) / barDB.buttonsPerRow)
	local numCols = buttonID > barDB.buttonsPerRow and barDB.buttonsPerRow or (buttonID - 1)
	local newBarWidth = 2 * barDB.backdropSpacing + numCols * barDB.buttonWidth + (numCols - 1) * barDB.spacing
	local newBarHeight = 2 * barDB.backdropSpacing + numRows * barDB.buttonHeight + (numRows - 1) * barDB.spacing
	bar:Size(newBarWidth, newBarHeight)

	local numMoverRows = ceil(barDB.numButtons / barDB.buttonsPerRow)
	local numMoverCols = barDB.buttonsPerRow
	local newMoverWidth = 2 * barDB.backdropSpacing + numMoverCols * barDB.buttonWidth + (numMoverCols - 1) -- * barDB.spacing
	local newMoverHeight = 2 * barDB.backdropSpacing + numMoverRows * barDB.buttonHeight + (numMoverRows - 1) -- * barDB.spacing
	bar:GetParent():Size(newMoverWidth, newMoverHeight)

	bar:ClearAllPoints()
	bar:Point(barDB.anchor)

	for i = 1, buttonID - 1 do
		local anchor = barDB.anchor
		local button = bar.buttons[i]

		button:ClearAllPoints()

		if i == 1 then
			if anchor == "TOPLEFT" then
				button:Point(anchor, bar, anchor, barDB.backdropSpacing, -barDB.backdropSpacing)
			elseif anchor == "TOPRIGHT" then
				button:Point(anchor, bar, anchor, -barDB.backdropSpacing, -barDB.backdropSpacing)
			elseif anchor == "BOTTOMLEFT" then
				button:Point(anchor, bar, anchor, barDB.backdropSpacing, barDB.backdropSpacing)
			elseif anchor == "BOTTOMRIGHT" then
				button:Point(anchor, bar, anchor, -barDB.backdropSpacing, barDB.backdropSpacing)
			end
		elseif i <= barDB.buttonsPerRow then
			local nearest = bar.buttons[i - 1]
			if anchor == "TOPLEFT" or anchor == "BOTTOMLEFT" then
				button:Point("LEFT", nearest, "RIGHT", barDB.spacing, 0)
			else
				button:Point("RIGHT", nearest, "LEFT", -barDB.spacing, 0)
			end
		else
			local nearest = bar.buttons[i - barDB.buttonsPerRow]
			if anchor == "TOPLEFT" or anchor == "TOPRIGHT" then
				button:Point("TOP", nearest, "BOTTOM", 0, -barDB.spacing)
			else
				button:Point("BOTTOM", nearest, "TOP", 0, barDB.spacing)
			end
		end

		F.SetFontDB(button.count, barDB.countFont)
		F.SetFontDB(button.bind, barDB.bindFont)

		F.SetFontColorDB(button.count, barDB.countFont.color)
		F.SetFontColorDB(button.bind, barDB.bindFont.color)

		button.count:ClearAllPoints()
		button.count:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", barDB.countFont.xOffset, barDB.countFont.yOffset)

		button.bind:ClearAllPoints()
		button.bind:Point("TOPRIGHT", button, "TOPRIGHT", barDB.bindFont.xOffset, barDB.bindFont.yOffset)
	end

	if not bar.register then
		RegisterStateDriver(bar, "visibility", "[petbattle]hide;show")
		bar.register = true
	end
	bar:Show()

	if barDB.backdrop then
		bar.backdrop:Show()
	else
		bar.backdrop:Hide()
	end

	local function updateAlpha()
		bar.alphaMin = barDB.alphaMin
		bar.alphaMax = barDB.alphaMax

		if barDB.globalFade then
			bar:SetAlpha(1)
			bar:GetParent():SetParent(AB.fadeParent)
		else
			if barDB.mouseOver then
				bar:SetAlpha(barDB.alphaMin)
			else
				bar:SetAlpha(barDB.alphaMax)
			end

			bar:GetParent():SetParent(E.UIParent)
		end

		if bar.waitGroup.ticker then
			bar.waitGroup.ticker:Cancel()
		end

		bar.waitGroup = nil
	end

	bar.waitGroup.ticker = C_Timer_NewTicker(0.1, function()
		if not bar.waitGroup or bar.waitGroup.count == 0 then
			updateAlpha()
		end
	end)
end

function module:UpdateBars()
	for i = 1, 5 do
		self:UpdateBar(i)
	end
end

do
	local lastUpdateTime =  0
	function module:UNIT_INVENTORY_CHANGED()
		local now = GetTime()
		if now - lastUpdateTime < 0.25 then
			return
		end
		lastUpdateTime = now
		UpdateQuestItemList()
		UpdateEquipmentList()

		self:UpdateBars()
	end
end

function module:UpdateQuestItem()
	UpdateQuestItemList()
	self:UpdateBars()
end

do
	local IsUpdating = false
	function module:ITEM_LOCKED()
		if IsUpdating then
			return
		end

		IsUpdating = true
		E:Delay(1, function()
			UpdateEquipmentList()
			self:UpdateBars()
			IsUpdating = false
		end)
	end
end

function module:CreateAll()
	for i = 1, 5 do
		self:CreateBar(i)
		S:CreateShadowModule(self.bars[i].backdrop)
	end
end

function module:UpdateBinding()
	if not self.db then
		return
	end

	for i = 1, 5 do
		for j = 1, 12 do
			local button = module.bars[i].buttons[j]
			if button then
				local bindingName = format("CLICK AutoButtonBar%dButton%d:LeftButton", i, j)
				local bindingText = GetBindingKey(bindingName) or ""
				bindingText = gsub(bindingText, "ALT--", "A")
				bindingText = gsub(bindingText, "CTRL--", "C")
				bindingText = gsub(bindingText, "SHIFT--", "S")

				button.bind:SetText(bindingText)
			end
		end
	end
end

function module:Initialize()
	module.db = E.db.mui.autoButtons
	if module.db.enable ~= true or self.Initialized then return end

	self:CreateAll()
	UpdateQuestItemList()
	UpdateEquipmentList()
	self:UpdateBars()
	self:UpdateBinding()

	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	self:RegisterEvent("ITEM_LOCKED")
	self:RegisterEvent("BAG_UPDATE_DELAYED", "UpdateBars")
	self:RegisterEvent("ZONE_CHANGED", "UpdateBars")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "UpdateBars")

	if E.Retail then
		self:RegisterEvent("QUEST_WATCH_LIST_CHANGED", "UpdateQuestItem")
		self:RegisterEvent("QUEST_LOG_UPDATE", "UpdateQuestItem")
		self:RegisterEvent("QUEST_ACCEPTED", "UpdateQuestItem")
		self:RegisterEvent("QUEST_TURNED_IN", "UpdateQuestItem")
		self:RegisterEvent("UPDATE_BINDINGS", "UpdateBinding")
	end

	self.Initialized = true
end

function module:ProfileUpdate()
	self:Initialize()

	if self.db.enable then
		UpdateQuestItemList()
		UpdateEquipmentList()
	elseif self.Initialized then
		self:UnregisterEvent("UNIT_INVENTORY_CHANGED")
		self:UnregisterEvent("BAG_UPDATE_DELAYED")
		self:UnregisterEvent("ZONE_CHANGED")
		self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
		self:UnregisterEvent("UPDATE_BINDINGS")

		if E.Retail then
			self:UnregisterEvent("QUEST_WATCH_LIST_CHANGED")
			self:UnregisterEvent("QUEST_LOG_UPDATE")
			self:UnregisterEvent("QUEST_ACCEPTED")
			self:UnregisterEvent("QUEST_TURNED_IN")
		end
	end

	self:UpdateBars()
end

MER:RegisterModule(module:GetName())
