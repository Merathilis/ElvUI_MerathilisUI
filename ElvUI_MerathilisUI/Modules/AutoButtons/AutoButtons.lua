local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_AutoButtons")
local async = MER.Utilities.Async
local S = MER:GetModule("MER_Skins")
local AB = E:GetModule("ActionBars")

local _G = _G
local ceil = ceil
local format = format
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
local GetItemCooldown = C_Item.GetItemCooldown
local GetItemCount = C_Item.GetItemCount
local GetQuestLogSpecialItemCooldown = GetQuestLogSpecialItemCooldown
local GetQuestLogSpecialItemInfo = GetQuestLogSpecialItemInfo
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsItemInRange = C_Item.IsItemInRange
local IsUsableItem = C_Item.IsUsableItem
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

local GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local NewTicker = C_Timer.NewTicker
local GetItemCraftedQualityByItemInfo = C_TradeSkillUI.GetItemCraftedQualityByItemInfo
local GetItemReagentQualityByItemInfo = C_TradeSkillUI.GetItemReagentQualityByItemInfo

module.bars = {}

local questItemList = {}
local function UpdateQuestItemList()
	wipe(questItemList)
	for questLogIndex = 1, GetNumQuestLogEntries() do
		local link = GetQuestLogSpecialItemInfo(questLogIndex)
		if link then
			local itemID = tonumber(strmatch(link, "|Hitem:(%d+):"))
			local data = { questLogIndex = questLogIndex, itemID = itemID }
			tinsert(questItemList, data)
		end
	end
end

-- Usable Items beeing ignored for some reasons
local forceUsableItems = {
	[193634] = true, -- Burgeoning Seed
	[206448] = true, -- Fyr'alath the Dreamrender
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

do
	local fakeButton = {
		HotKey = {
			text = "",
			SetText = function(self, text)
				self.text = text
			end,
			GetText = function(self)
				return self.text
			end,
		},
	}

	function module:GetBindingKeyWithElvUI(key)
		local keybind = GetBindingKey(key)

		if not keybind or keybind == "" then
			return ""
		end

		fakeButton.HotKey:SetText(keybind)
		AB:FixKeybindText(fakeButton)
		return fakeButton.HotKey:GetText()
	end
end

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
		style = "SHADOWOUTLINE",
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

	button.SetTier = function(self, itemIDOrLink)
		local level = GetItemReagentQualityByItemInfo(itemIDOrLink) or GetItemCraftedQualityByItemInfo(itemIDOrLink)

		if not level or level == 0 then
			self.qualityTier:SetText("")
			self.qualityTier:Hide()
		else
			self.qualityTier:SetText(CreateAtlasMarkup(format("Professions-Icon-Quality-Tier%d-Small", level)))
			self.qualityTier:Show()
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
			button:SetTier(itemData.itemID)

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

			button:SetTier(item:GetItemID())

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
				start, duration, enable = GetItemCooldown(self.itemID)
			end
			CooldownFrame_Set(self.cooldown, start, duration, enable)
			if duration and duration > 0 and enable and enable == 0 then
				self.tex:SetVertexColor(0.4, 0.4, 0.4)
			elseif not InCombatLockdown() and IsItemInRange(self.itemID, "target") == false then
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
			E:UIFrameFadeIn(
				bar,
				barDB.fadeTime * (barDB.alphaMax - alphaCurrent) / (barDB.alphaMax - barDB.alphaMin),
				alphaCurrent,
				barDB.alphaMax
			)
		end

		if barDB.tooltip then
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 2)
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
			E:UIFrameFadeOut(
				bar,
				barDB.fadeTime * (alphaCurrent - barDB.alphaMin) / (barDB.alphaMax - barDB.alphaMin),
				alphaCurrent,
				barDB.alphaMin
			)
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
	E:CreateMover(
		anchor,
		"AutoButtonBar" .. id .. "Mover",
		MER.Title .. L["Auto Button Bar"] .. " " .. id,
		nil,
		nil,
		nil,
		"ALL,MERATHILISUI",
		function()
			return module.db.enable and barDB.enable
		end,
		"mui,modules,autoButtons,bar" .. id
	)

	local bar = CreateFrame("Frame", "AutoButtonBar" .. id, E.UIParent, "SecureHandlerStateTemplate")
	bar.id = id
	bar:ClearAllPoints()
	bar:SetParent(anchor)
	bar:SetPoint("CENTER", anchor, "CENTER", 0, 0)
	bar:Size(150, 40)
	bar:CreateBackdrop("Transparent")
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
			E:UIFrameFadeIn(
				bar,
				barDB.fadeTime * (barDB.alphaMax - alphaCurrent) / (barDB.alphaMax - barDB.alphaMin),
				alphaCurrent,
				barDB.alphaMax
			)
		end
	end)

	bar:SetScript("OnLeave", function(self)
		if not barDB then
			return
		end

		if not barDB.globalFade and barDB.mouseOver and barDB.alphaMax and barDB.alphaMin then
			local alphaCurrent = bar:GetAlpha()
			E:UIFrameFadeOut(
				bar,
				barDB.fadeTime * (alphaCurrent - barDB.alphaMin) / (barDB.alphaMax - barDB.alphaMin),
				alphaCurrent,
				barDB.alphaMin
			)
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

	for _, module in ipairs({ strsplit("[, ]", barDB.include) }) do
		if buttonID <= barDB.numButtons then
			if self.moduleList[module] then
				addButtons(self.moduleList[module])
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
		RegisterStateDriver(bar, "visibility", barDB.visibility)
		bar.register = true
	end

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

	bar.waitGroup.ticker = NewTicker(0.1, function()
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
	local lastUpdateTime = 0
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
				button.bind:SetText(self:GetBindingKeyWithElvUI(bindingName))
			end
		end
	end
end

function module:Initialize()
	module.db = E.db.mui.autoButtons
	if module.db.enable ~= true or self.Initialized then
		return
	end

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
	self:RegisterEvent("PLAYER_ALIVE", "UpdateBars")
	self:RegisterEvent("PLAYER_UNGHOST", "UpdateBars")
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
		self:UnregisterEvent("PLAYER_ALIVE")
		self:UnregisterEvent("PLAYER_UNGHOST")
		self:UnregisterEvent("UPDATE_BINDINGS")
		self:UnregisterEvent("QUEST_WATCH_LIST_CHANGED")
		self:UnregisterEvent("QUEST_LOG_UPDATE")
		self:UnregisterEvent("QUEST_ACCEPTED")
		self:UnregisterEvent("QUEST_TURNED_IN")
	end

	self:UpdateBars()
end

MER:RegisterModule(module:GetName())
