local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_AutoButtons')
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
local Item = Item
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

local C_QuestLog_GetNumQuestLogEntries = C_QuestLog and C_QuestLog.GetNumQuestLogEntries

module.bars = {}

-- Potion (require level >= 40)
local potions = {
	114124,
	115531,
	116925,
	118910,
	118911,
	118912,
	118913,
	118914,
	118915,
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
}

if E.Classic then
	tinsert(potions, 13446)
	tinsert(potions, 13444)
end

-- Potion added in Shadowlands (require level >= 50)
local potionsShadowlands = {
	5512,
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
	177278,
	176811,
	180317, -- Spiritual Healing Potion
	183823,
	184090,
	187802,
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
}

-- Flasks added in Shadowlands (require level >= 50)
local flasksShadowlands = {
	171276,
	171278,
	171280,

	181468, -- Veiled Augment Rune
	190384, -- Eternal Augment Rune
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
	42996,
	34750,
	44953,
	34757,
	43001,
	34755,
	43490,
	42993,
	34768,
	34756,
	43005,
	34763,
	34759,
	43480,
	34749,
	34761,
	34751,
	42994,
	34752,
	34766,
	34764,
	34765,
	34747,
	34758,
	34754,
	34748,
	43488,
	34769,
	42995,
	43492,
	34762,
	34760,
	43478,
	43015,
	34767,
	43000,
	43268,
	42998,
	43004,
	42997,
	42999,
	42942,
	45279,
	6657,
}

local foodShadowlands = {
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
	172060,
	172061,
	172062,
	172063,
	172068,
	172069,
	184682,
}

local foodShadowlandsVendor = {
	173759,
	173760,
	173761,
	173762,
	173859,
	174281,
	174282,
	174283,
	174284,
	174285,
	177040,
	178216,
	178217,
	178222,
	178223,
	178224,
	178225,
	178226,
	178227,
	178228,
	178247,
	178252,
	178534,
	178535,
	178536,
	178537,
	178538,
	178539,
	178541,
	178542,
	178545,
	178546,
	178547,
	178548,
	178549,
	178550,
	178552,
	178900,
	179011,
	179012,
	179013,
	179014,
	179015,
	179016,
	179017,
	179018,
	179019,
	179020,
	179021,
	179022,
	179023,
	179025,
	179026,
	179166,
	179267,
	179268,
	179269,
	179270,
	179271,
	179272,
	179273,
	179274,
	179275,
	179281,
	179283,
	179992,
	179993,
	180430,
	184201,
	184202,
	184281,
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
	153023,
	171285,
	171286,
	171436,
	171437,
	171438,
	171439,
	172346,
	172347,
	172233,
	34721, -- First Aid bandage WRATH
	34722, -- First Aid bandage WRATH
}

local torghastItems = {
	168035, -- Mawrat Harness
	168207, -- Plundered Anima Cell
	170499, -- Maw Seeker Harness
	170540, -- Ravenous Anima Cell
	174464, -- Spectral Bridle
	176331, -- Obscuring Essence Potion
	176409, -- Rejuvenating Siphoned Essence
	176443, -- Fleeting Frenzy Potion
	184662, -- Requisitioned Anima Cell
	185946, --Long Tail Dynarats
	185947, --Draught of Leeching Strikes
	185950, --Draught of Temporal Rush
	186043, --Torghast Portal Manipulator
	186614, --Soul Jar
	186615, --Mirror of the Conjured Twin
	186636, --Cage of Mawrats
	186678, --Mawforged Weapons Cache
	186679, --Scroll of Domination
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
	186650,
	186691,
	186694,
	186680,
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
	190178,
	190610,
	191040,
	191041,
	191139,
	192438,
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
	40079,
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

local equipmentList = {}
local function UpdateEquipmentList()
	wipe(equipmentList)
	for slotID = 1, 18 do
		local itemID = GetInventoryItemID("player", slotID)
		if itemID and IsUsableItem(itemID) then
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
	["POTIONSL"] = potionsShadowlands,
	["FLASK"] = flasks,
	["FLASKSL"] = flasksShadowlands,
	["TORGHAST"] = torghastItems,
	["FOOD"] = food,
	["FOODSL"] = foodShadowlands,
	["FOODVENDOR"] = foodShadowlandsVendor,
	["MAGEFOOD"] = conjuredManaFood,
	["BANNER"] = banners,
	["UTILITY" ] = utilities,
	["OPENABLE"] = openableItems,
	["ORETBC"] = tbcOre,
	["POTIONTBC"] = tbcPotions,
	["FLASKSTBC"] = tbcFlasks,
	["CAULDRONTBC"] = tbcCauldrons,
	["ELIXIRTBC"] = tbcElixirs,
	["POTIONSWRATH"] = wrathPotions,
	["FLASKWRATH"] = wrathFlasks,
	["ELIXIRWRATH"] = wrathElixirs,
}

function module:CreateButton(name, barDB)
	local button = CreateFrame("Button", name, E.UIParent, "SecureActionButtonTemplate, BackdropTemplate")
	button:Size(barDB.buttonWidth, barDB.buttonHeight)
	button:SetTemplate()
	button:SetClampedToScreen(true)
	button:SetAttribute("type", "item")
	button:EnableMouse(false)
	button:RegisterForClicks("AnyUp")

	local tex = button:CreateTexture(nil, "OVERLAY", nil)
	tex:Point("TOPLEFT", button, "TOPLEFT", 1, -1)
	tex:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
	tex:SetTexCoord(unpack(E.TexCoords))

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
	button.count = count
	button.bind = bind
	button.cooldown = cooldown

	button:StyleButton()

	return button
end

function module:SetUpButton(button, questItemData, slotID)
	button.itemName = nil
	button.itemID = nil
	button.spellName = nil
	button.slotID = nil
	button.countText = nil

	if questItemData then
		button.itemID = questItemData.itemID
		button.countText = GetItemCount(questItemData.itemID, nil, true)
		button.questLogIndex = questItemData.questLogIndex
		button:SetBackdropBorderColor(0, 0, 0)

		local item = Item:CreateFromItemID(questItemData.itemID)
		item:ContinueOnItemLoad(function()
			button.itemName = item:GetItemName()
			button.tex:SetTexture(item:GetItemIcon())
		end)
	elseif slotID then
		button.slotID = slotID
		local item = Item:CreateFromEquipmentSlot(slotID)
		item:ContinueOnItemLoad(function()
			if button.slotID == slotID then
				button.itemName = item:GetItemName()
				button.tex:SetTexture(item:GetItemIcon())

				local color = item:GetItemQualityColor()
				if color then
					button:SetBackdropBorderColor(color.r, color.g, color.b)
				end
			end
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
				start, duration, enable = GetItemCooldown(self.itemID)
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
			E:UIFrameFadeIn(bar, barDB.fadeTime or 0.3 * (barDB.alphaMax - alphaCurrent) / (barDB.alphaMax - barDB.alphaMin), alphaCurrent, barDB.alphaMax)
		end
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, -2)
		GameTooltip:ClearLines()

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
			E:UIFrameFadeOut(bar, barDB.fadeTime or 0.3 * (alphaCurrent - barDB.alphaMin) / (barDB.alphaMax - barDB.alphaMin), alphaCurrent, barDB.alphaMin)
		end
		GameTooltip:Hide()
	end)

	if not InCombatLockdown() then
		button:EnableMouse(true)
		button:Show()
		if button.slotID then
			button:SetAttribute("type", "macro")
			button:SetAttribute("macrotext", "/use " .. button.slotID)
		elseif button.itemName then
			if button.itemID == 172347 then
				-- Heavy Desolate Armor Kit
				button:SetAttribute("type", "macro")
				button:SetAttribute("macrotext", "/use " .. button.itemName .. "\n/use 5")
			else
				button:SetAttribute("type", "item")
				button:SetAttribute("item", button.itemName)
			end
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
		if barDB.mouseOver then
			local alphaCurrent = bar:GetAlpha()
			E:UIFrameFadeIn(bar, barDB.fadeTime or 0.3 * (barDB.alphaMax - alphaCurrent) / (barDB.alphaMax - barDB.alphaMin), alphaCurrent, barDB.alphaMax)
		end
	end)

	bar:SetScript("OnLeave", function(self)
		if barDB.mouseOver then
			local alphaCurrent = bar:GetAlpha()
			E:UIFrameFadeOut(bar, barDB.fadeTime or 0.3 * (alphaCurrent - barDB.alphaMin) / (barDB.alphaMax - barDB.alphaMin), alphaCurrent, barDB.alphaMin)
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
	local function AddButtons(list)
		for _, itemID in pairs(list) do
			local count = GetItemCount(itemID)
			if count and count > 0 and not self.db.blackList[itemID] and buttonID <= barDB.numButtons then
				self:SetUpButton(bar.buttons[buttonID], {itemID = itemID})
				self:UpdateButtonSize(bar.buttons[buttonID], barDB)
				buttonID = buttonID + 1
			end
		end
	end

	for _, module in ipairs{strsplit("[, ]", barDB.include)} do
		if buttonID <= barDB.numButtons then
			if moduleList[module] then
				AddButtons(moduleList[module])
			elseif module == "QUEST" then
				for _, data in pairs(questItemList) do
					if not self.db.blackList[data.itemID] then
						self:SetUpButton(bar.buttons[buttonID], data)
						self:UpdateButtonSize(bar.buttons[buttonID], barDB)
						buttonID = buttonID + 1
					end
				end
			elseif module == "EQUIP" then
				for _, slotID in pairs(equipmentList) do
					local itemID = GetInventoryItemID("player", slotID)
					if itemID and not self.db.blackList[itemID] and buttonID <= barDB.numButtons then
						self:SetUpButton(bar.buttons[buttonID], nil, slotID)
						self:UpdateButtonSize(bar.buttons[buttonID], barDB)
						buttonID = buttonID + 1
					end
				end
			elseif module == "CUSTOM" then
				AddButtons(self.db.customList)
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

	bar.alphaMin = barDB.alphaMin or 0
	bar.alphaMax = barDB.alphaMax or 1
	bar.fadeTime = barDB.fadeTime or 0.3

	if barDB.globalFade then
		barDB.alphaMin = 1
		barDB.alphaMax = 1

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
