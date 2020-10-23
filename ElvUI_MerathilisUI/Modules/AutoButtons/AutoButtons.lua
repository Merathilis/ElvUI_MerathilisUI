local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_AutoButtons')

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
local InCombatLockdown = InCombatLockdown
local IsItemInRange = IsItemInRange
local IsUsableItem = IsUsableItem

local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries

local potions = {
	5512, -- Healthstone
	176443,
	118915,
	118911,
	118913,
	118914,
	116925,
	118910,
	118912,
	114124,
	115531,
	127845,
	142117,
	127844,
	127834,
	127835,
	127843,
	127846,
	127836,
	136569,
	144396,
	144397,
	144398,
	152615,
	142326,
	142325,
	152619,
	169451,
	169299,
	152497,
	168498,
	152495,
	168500,
	168489,
	152494,
	168506,
	152561,
	168529,
	163222,
	163223,
	152550,
	152503,
	152557,
	163224,
	152560,
	169300,
	168501,
	168499,
	163225,
	152559,
	163082,
	168502,
	167917,
	167920,
	167918,
	167919,
	184090,
	180771,
	171267,
	171270,
	171351,
	171273,
	171352,
	171350,
	171349,
	171266,
	171272,
	171268,
	176811,
	171271,
	171274,
	171269,
	171275,
	171264,
	171263,
	171370,
	183823,
	180317,
	180318,
}

local flasks = {
	168652,
	168654,
	168651,
	168655,
	152639,
	168653,
	152638,
	152641,
	127848,
	127849,
	127850,
	127847,
	152640,
	127858,
	162518,
	171276,
	171278,
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
	153023,
	109076,
	49040,
	132514,
}

local questItemList = {}
local function UpdateQuestItemList()
	wipe(questItemList)
	for questLogIndex = 1, C_QuestLog_GetNumQuestLogEntries() do
		local link = GetQuestLogSpecialItemInfo(questLogIndex)
		if link then
			local itemID = tonumber(strmatch(link, "|Hitem:(%d+):"))
			local data = {
				questLogIndex = questLogIndex,
				itemID = itemID
			}
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
	[3] = false
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
		if module.db["bar" .. bar.id].mouseOver then
			E:UIFrameFadeIn(bar, 0.2, bar:GetAlpha(), 1)
		end
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, -2)
		GameTooltip:ClearLines()

		if self.slotID then
			GameTooltip:SetInventoryItem("player", self.slotID)
		else
			GameTooltip:SetItemByID(self.itemID)
		end

		GameTooltip:Show()
	end)

	button:SetScript("OnLeave", function(self)
		local bar = self:GetParent()
		if module.db["bar" .. bar.id].mouseOver then
			E:UIFrameFadeOut(bar, 0.2, bar:GetAlpha(), 0)
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

	--[[
	if barDB.inheritGlobalFade == true then
		button:SetParent(E.ActionBars.fadeParent)
	else
		button:SetParent(E.UIParent)
	end
	]]

	button.tex:SetTexCoord(left, right, top, bottom)
end

function module:PLAYER_REGEN_ENABLED()
	for i = 1, 3 do
		if UpdateAfterCombat[i] then
			self:UpdateBar(i)
			UpdateAfterCombat[i] = false
		end
	end
end

function module:UpdateBarTextOnCombat(i)
	for k = 1, 12 do
		local button = self.bars[i].buttons[k]
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

	--[[
	if barDB.inheritGlobalFade == true then
		anchor:SetParent(E.ActionBars.fadeParent)
	else
		anchor:SetParent(E.UIParent)
	end
	]]

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
			E:UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
		end
	end)

	bar:SetScript("OnLeave", function(self)
		if barDB.mouseOver then
			E:UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
		end
	end)

	self.bars[id] = bar
end

function module:UpdateBar(id)
	if not self.db or not self.db["bar" .. id] then
		return
	end

	local bar = self.bars[id]
	local barDB = self.db["bar" .. id]

	if InCombatLockdown() then
		self:UpdateBarTextOnCombat(id)
		UpdateAfterCombat[id] = true
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	if not self.db.enable or not barDB.enable then
		bar:Hide()
		return
	end

	local buttonID = 1
	for _, module in ipairs {strsplit("[, ]", barDB.include)} do
		if buttonID <= barDB.numButtons then
			if module == "QUEST" then
				for _, data in pairs(questItemList) do
					if not self.db.blackList[data.itemID] then
						self:SetUpButton(bar.buttons[buttonID], data)
						self:UpdateButtonSize(bar.buttons[buttonID], barDB)
						buttonID = buttonID + 1
					end
				end
			elseif module == "POTION" then
				for _, potionID in pairs(potions) do
					local count = GetItemCount(potionID)
					if count and count > 0 and not self.db.blackList[potionID] then
						self:SetUpButton(bar.buttons[buttonID], {itemID = potionID})
						self:UpdateButtonSize(bar.buttons[buttonID], barDB)
						buttonID = buttonID + 1
					end
				end
			elseif module == "FLASK" then
				for _, flaskID in pairs(flasks) do
					local count = GetItemCount(flaskID)
					if count and count > 0 and not self.db.blackList[flaskID] and buttonID <= barDB.numButtons then
						self:SetUpButton(bar.buttons[buttonID], {itemID = flaskID})
						self:UpdateButtonSize(bar.buttons[buttonID], barDB)
						buttonID = buttonID + 1
					end
				end
			elseif module == "BANNER" then
				for _, bannerID in pairs(banners) do
					local count = GetItemCount(bannerID)
					if count and count > 0 and not self.db.blackList[bannerID] and buttonID <= barDB.numButtons then
						self:SetUpButton(bar.buttons[buttonID], {itemID = bannerID})
						bar.buttons[buttonID]:Size(barDB.buttonWidth, barDB.buttonHeight)
						buttonID = buttonID + 1
					end
				end
			elseif module == "UTILITY" then
				for _, utilityID in pairs(utilities) do
					local count = GetItemCount(utilityID)
					if count and count > 0 and not self.db.blackList[utilityID] and buttonID <= barDB.numButtons then
						self:SetUpButton(bar.buttons[buttonID], {itemID = utilityID})
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
				for _, itemID in pairs(self.db.customList) do
					local count = GetItemCount(itemID)
					if count and count > 0 and not self.db.blackList[itemID] and buttonID <= barDB.numButtons then
						self:SetUpButton(bar.buttons[buttonID], {itemID = itemID})
						self:UpdateButtonSize(bar.buttons[buttonID], barDB)
						buttonID = buttonID + 1
					end
				end
			end
		end
	end

	if buttonID == 1 then
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

	bar:Show()

	if barDB.backdrop then
		bar.backdrop:Show()
	else
		bar.backdrop:Hide()
	end

	if barDB.mouseOver then
		bar:SetAlpha(0)
	else
		bar:SetAlpha(1)
	end
end

function module:UpdateBars()
	for i = 1, 3 do
		self:UpdateBar(i)
	end
end

function module:UpdateQuestItem()
	UpdateQuestItemList()
	self:UpdateBars()
end

function module:UpdateEquipment()
	UpdateEquipmentList()
	self:UpdateBars()
end

function module:CreateAll()
	self.bars = {}

	for i = 1, 3 do
		self:CreateBar(i)
	end
end

function module:UpdateBinding()
	if not self.db then
		return
	end

	for i = 1, 3 do
		for j = 1, 12 do
			local button = self.bars[i].buttons[j]
			if button then
				local bindingName = format("CLICK WTExtraItemsBar%dButton%d:LeftButton", i, j)
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
	if module.db.enable ~= true then return end

	MER:RegisterDB(self, "autoButtons")

	self:CreateAll()
	UpdateQuestItemList()
	UpdateEquipmentList()
	self:UpdateBars()
	self:UpdateBinding()

	self:RegisterEvent("UNIT_INVENTORY_CHANGED", "UpdateEquipment")
	self:RegisterEvent("BAG_UPDATE_DELAYED", "UpdateBars")
	self:RegisterEvent("ZONE_CHANGED", "UpdateBars")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "UpdateBars")
	self:RegisterEvent("QUEST_WATCH_LIST_CHANGED", "UpdateQuestItem")
	self:RegisterEvent("QUEST_LOG_UPDATE", "UpdateQuestItem")
	self:RegisterEvent("QUEST_ACCEPTED", "UpdateQuestItem")
	self:RegisterEvent("QUEST_TURNED_IN", "UpdateQuestItem")
	self:RegisterEvent("UPDATE_BINDINGS", "UpdateBinding")

	function module:ForUpdateAll()
		module.db = E.db.mui.autoButtons

		UpdateQuestItemList()
		UpdateEquipmentList()
		self:UpdateBars()
		self:UpdateBinding()
	end

	self:ForUpdateAll()
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
