local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_AutoButtons')
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
local GetItemIcon = GetItemIcon
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local GetQuestLogSpecialItemCooldown = GetQuestLogSpecialItemCooldown
local GetQuestLogSpecialItemInfo = GetQuestLogSpecialItemInfo
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsItemInRange = IsItemInRange
local IsUsableItem = IsUsableItem
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntrie

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
	183823,
	184090,
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
}

-- Foods added in Shadowlands (Crafted by cooking)
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

-- Food sold by a vendor (Shadowlands)
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
	171209, --Blood bag
	171210, --a bag of natural gifts
	171211, --Pan Hill's Wallet
	174652, --a bag of forgotten heirlooms
	178040, --Condensed Hades
	178078, --Rebirth Spirit Treasure Chest
	178128, --A bag full of glittering treasures
	178513, -- Anniversary gift
	178965, --Small gardener's bag
	178966, --The gardener's bag
	178967, --Large gardener's bag
	178968, -- Weekly gardener's bag
	180085, --Kirian Souvenir
	180355, --Gorgeous Holy Box
	180378, --Master Blacksmith's Box
	180379, --Exquisite textile carpet
	180380, --fine netting
	180386, -- Herbalist Pouch
	180442, --a bag of sin stones
	180646, --Undead Legion Supplies
	180647, --Promoted supplies
	180648, --Reaper Tingwei Supplies
	180649, --Supplies for Wilderness Hunters
	180875, -- Cargo Cargo
	180974, --Apprentice's bag
	180975, --The bag of the cook
	180976, --Expert's bag
	180977, --Soul Keeper's Bag
	180979, --Expert's large bag
	180980, --A large bag of a skilled craftsman
	180981, --The apprentice's large bag
	180983, --A bag full of experts
	180984, --A bag full of skilled workers
	180985, --The apprentice's full bag
	180988, --The bag overflowing by the cooked workers
	180989, --The apprentice's overflowing bag
	181372, --A gift for the promoted
	181475, --The Woodland Watcher's Reward
	181476, --A gift to the hunter in the wilderness
	181556, --Ting Wei's gift
	181557, --Ting Wei's gift
	181732, --A gift from a careerist
	181733, --A gift from the conscientious
	181741, --A gift of a model
	181767, --small wallet
	182590, --Climbing a coin purse
	182591, --Vine-covered Ruby
	183699, ---selected materials
	183701, -- Purification ritual materials
	183702, --Natural light
	183703, --Bone Artisan Backpack
	184045, --The military tax of Tingwei the Harvester
	184046, --Undead Legion Weapon Case
	184047, --Promoted Weapon Case
	184048, --Wild Hunter Weapon Bag
	184158, --Slimy necromancer roe
	184395, --Death adventurer's storage box
	184444, --Road to Promotion Supply
	184522, --Cooperating Dim Cloth Bag
	184589, --Potion bag
	184630, --Adventurer's Cloth Box
	184631, --Adventurer Enchanting Box
	184632, --Warrior Fish Box
	184633, --Warrior Meat Box
	184634, --Adventurer's Herbal Box
	184635, --Adventurer's Ore Box
	184636, --Adventurer's Leather Box
	184637, --Hero Meat Box
	184638, --Hero Fish Box
	184639, --Warrior Cloth Box
	184640, --Warrior Leather Box
	184641, --Warrior Ore Box
	184642, --Warrior Herbal Box
	184643, --Warrior Enchant Box
	184644, -- Hero Cloth Box
	184645, --Hero Leather Box
	184646, --Heroic Ore Box
	184647, --Hero Herbal Box
	184648, --Hero Enchanting Box
	184810, -- looted supplies
	184811, --Artemide's gift
	184812, --Apollon's Gift
	184843, --Recovered supplies
	184868, --Nasaya Treasure Chest
	184869, --Nasaya Treasure Chest
	185765, -- a batch of heavy and hardened animal skins
	185832, --a batch of Erechium ore
	185833, --a batch of matte silk cloth
	185972, --The tormentor's treasure chest
	185990, --Reaper's War Chest
	185991, -- Wilderness Hunter War Chest
	185992, --Undead Legion War Treasure Chest
	185993, --Promoted War Treasure Chest
	186196, --Death Vanguard War Treasure Box
	187029, --Venari's mysterious gift
	187221, --Soul Ash Cache
	187222, --Stygic Singularity
	187254, --Arrangement of Anima
	187278, --The Deep Oath Treasure Chest Passed Through
	187354, --Abandoned Intermediary Backpack
	187440, --Feather-Stuffed Helm
	187543, --Death Vanguard War Treasure Box
	187551, --Small Cosia Supply Box
	187569, --Intermediary Cloth Potential Particles
	187570, --Intermediary leather potential particles
	187571, --Intermediary Ore Potential Particles
	187572, --Intermediary Herbal Potential Particles
	187573, --Intermediary Enchanting Potential Particles
	187574, --The intermediary's overflowing food barrel
	187575, --Cosia Fishing Box
	187576, --Cosia Leather Box
	187577, --Cosia Meat Box
	187817, --Korthite Crystal Geode
}

local questItemList = {}
local function UpdateQuestItemList()
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
}

function module:CreateButton(name, barDB)
	local button = CreateFrame("Button", name, E.UIParent, "SecureActionButtonTemplate, BackdropTemplate")
	button:Size(barDB.buttonWidth, barDB.buttonHeight)
	button:SetTemplate("Default")
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
	MER:SetFontDB(count, barDB.countFont)

	local bind = button:CreateFontString(nil, "OVERLAY")
	bind:SetTextColor(0.6, 0.6, 0.6)
	bind:Point("TOPRIGHT", button, "TOPRIGHT")
	bind:SetJustifyH("CENTER")
	MER:SetFontDB(bind, barDB.bindFont)

	local cooldown = CreateFrame("Cooldown", name .. "Cooldown", button, "CooldownFrameTemplate")
	E:RegisterCooldown(cooldown)

	button.tex = tex
	button.count = count
	button.bind = bind
	button.cooldown = cooldown

	button:StyleButton()

	MER:CreateShadowModule(button)

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
		button.itemName = GetItemInfo(questItemData.itemID)
		button.countText = GetItemCount(questItemData.itemID, nil, true)
		button.tex:SetTexture(GetItemIcon(questItemData.itemID))
		button.questLogIndex = questItemData.questLogIndex

		button:SetBackdropBorderColor(0, 0, 0)
	elseif slotID then
		local itemID = GetInventoryItemID("player", slotID)
		local name, _, rarity = GetItemInfo(itemID)

		button.slotID = slotID
		button.itemName = GetItemInfo(itemID)
		button.tex:SetTexture(GetItemIcon(itemID))

		if rarity and rarity > 1 then
			local r, g, b = GetItemQualityColor(rarity)
			button:SetBackdropBorderColor(r, g, b)
		end
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
			button:SetAttribute("type", "item")
			button:SetAttribute("item", button.itemName)
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
	E:CreateMover(anchor, 'AutoButtonBar' .. id .. 'Mover', L['Auto Button Bar'] .. ' ' .. id, nil, nil, nil, 'ALL,MERATHILISUI',function() return module.db.enable and barDB.enable end, 'mui,modules,autoButtons,bar'..id)

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
	local newBarWidth = barDB.backdropSpacing + numCols * barDB.buttonWidth + (numCols - 1) * barDB.spacing
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

		MER:SetFontDB(button.count, barDB.countFont)
		MER:SetFontDB(button.bind, barDB.bindFont)

		MER:SetFontColorDB(button.count, barDB.countFont.color)
		MER:SetFontColorDB(button.bind, barDB.bindFont.color)

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
		MER:CreateShadowModule(self.bars[i].backdrop)
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

	MER:RegisterDB(self, "autoButtons")

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
	self:RegisterEvent("QUEST_WATCH_LIST_CHANGED", "UpdateQuestItem")
	self:RegisterEvent("QUEST_LOG_UPDATE", "UpdateQuestItem")
	self:RegisterEvent("QUEST_ACCEPTED", "UpdateQuestItem")
	self:RegisterEvent("QUEST_TURNED_IN", "UpdateQuestItem")
	self:RegisterEvent("UPDATE_BINDINGS", "UpdateBinding")

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
		self:UnregisterEvent("QUEST_WATCH_LIST_CHANGED")
		self:UnregisterEvent("QUEST_LOG_UPDATE")
		self:UnregisterEvent("QUEST_ACCEPTED")
		self:UnregisterEvent("QUEST_TURNED_IN")
		self:UnregisterEvent("UPDATE_BINDINGS")
	end

	self:UpdateBars()
end

MER:RegisterModule(module:GetName())
