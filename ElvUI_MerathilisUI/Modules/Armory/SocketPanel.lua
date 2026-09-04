local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Armory") ---@class Armory

local _G = _G
local ipairs, pairs, select, tonumber, type = ipairs, pairs, select, tonumber, type
local strsplit = strsplit
local format = string.format
local tinsert = table.insert
local max = math.max

local C_ItemSocketInfo = C_ItemSocketInfo
local GetNumSockets = C_ItemSocketInfo.GetNumSockets
local ClickSocketButton = C_ItemSocketInfo.ClickSocketButton
local AcceptSockets = C_ItemSocketInfo.AcceptSockets
local CloseSocketInfo = C_ItemSocketInfo.CloseSocketInfo
local SocketInventoryItem = C_ItemSocketInfo.SocketInventoryItem

local C_Item = C_Item
local C_Container = C_Container
local C_EventUtils = C_EventUtils

local GetItemNumSockets = C_Item.GetItemNumSockets
local GetItemGem = C_Item.GetItemGem
local GetItemStats = C_Item.GetItemStats
local GetItemInfoInstant = C_Item.GetItemInfoInstant
local GetItemIconByID = C_Item.GetItemIconByID
local GetItemCount = C_Item.GetItemCount
local RequestLoadItemDataByID = C_Item.RequestLoadItemDataByID
local GetItemInfo = C_Item.GetItemInfo

local GetContainerItemInfo = C_Container.GetContainerItemInfo
local GetContainerItemID = C_Container.GetContainerItemID
local GetContainerItemLink = C_Container.GetContainerItemLink
local GetContainerNumSlots = C_Container.GetContainerNumSlots

local GetInventoryItemLink = GetInventoryItemLink
local ClearCursor = ClearCursor
local CursorHasItem = CursorHasItem
local InCombatLockdown = InCombatLockdown
local HideUIPanel = HideUIPanel

local GEM_CLASS = (Enum and Enum.ItemClass and Enum.ItemClass.Gem) or 3

local EMPTY_SOCKET_TEXTURE = "Interface\\ItemSocketingFrame\\UI-EmptySocket-Prismatic"

local SOCKET_SLOTS = {
	1,
	2,
	3,
	5,
	6,
	7,
	8,
	9,
	10,
	11,
	12,
	13,
	14,
	15,
	16,
	17,
}

local SLOT_BUTTON_NAMES = {
	"Head",
	"Neck",
	"Shoulder",
	"Chest",
	"Waist",
	"Legs",
	"Feet",
	"Wrist",
	"Hands",
	"Finger0",
	"Finger1",
	"Trinket0",
	"Trinket1",
	"Back",
	"MainHand",
	"SecondaryHand",
}

local function GetDB()
	return module.db and module.db.socketPanel
end

local function Scale(value)
	return E:Scale(value)
end

local function CreateSimpleBorder(frame)
	if frame.MERSocketBorder then
		return frame.MERSocketBorder
	end

	local border = {}

	local top = frame:CreateTexture(nil, "OVERLAY")
	top:SetTexture(E.media.blankTex)
	top:SetHeight(1)
	top:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
	top:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)

	local bottom = frame:CreateTexture(nil, "OVERLAY")
	bottom:SetTexture(E.media.blankTex)
	bottom:SetHeight(1)
	bottom:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
	bottom:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)

	local left = frame:CreateTexture(nil, "OVERLAY")
	left:SetTexture(E.media.blankTex)
	left:SetWidth(1)
	left:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
	left:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)

	local right = frame:CreateTexture(nil, "OVERLAY")
	right:SetTexture(E.media.blankTex)
	right:SetWidth(1)
	right:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
	right:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)

	border.TOP = top
	border.BOTTOM = bottom
	border.LEFT = left
	border.RIGHT = right

	frame.MERSocketBorder = border

	return border
end

local function SetBorderColor(frame, r, g, b, a)
	local border = CreateSimpleBorder(frame)

	for _, tex in pairs(border) do
		tex:SetVertexColor(r, g, b, a or 1)
	end
end

local function GetGemStatText(link)
	if not link or not GetItemStats then
		return "Gem"
	end

	local stats = GetItemStats(link)
	if stats then
		local parts
		for key, value in pairs(stats) do
			if type(key) == "string" and type(value) == "number" and value > 0 and key:find("^ITEM_MOD_") then
				local label = _G[key]

				if type(label) == "string" and label ~= "" then
					parts = parts or {}
					tinsert(parts, "+" .. value .. " " .. label)
				end
			end
		end

		if parts and #parts > 0 then
			table.sort(parts)
			return table.concat(parts, " & ")
		end
	end

	if C_Item and GetItemInfo then
		local name = GetItemInfo(link)
		if name then
			return name
		end
	end

	return "Gem"
end

local function GetEmptySocketName(link)
	if not GetItemStats then
		return L["Empty Socket"] or "Empty Socket"
	end

	local stats = GetItemStats(link)
	if not stats then
		return L["Empty Socket"] or "Empty Socket"
	end

	local found
	for key in pairs(stats) do
		if type(key) == "string" and key:find("EMPTY_SOCKET") then
			if found then
				return L["Empty Socket"] or "Empty Socket"
			end

			found = key
		end
	end

	return (found and _G[found]) or L["Empty Socket"] or "Empty Socket"
end

local function GetGemIDFromLink(link, socketIndex)
	if not link then
		return nil
	end

	local itemString = link:match("item:([%-%d:]+)")
	if not itemString then
		return nil
	end

	local gemID = tonumber(select(socketIndex + 2, strsplit(":", itemString)))
	return gemID and gemID > 0 and gemID or nil
end

local function FindBagSlot(itemID)
	if not (C_Container and GetContainerNumSlots and GetContainerItemInfo) then
		return nil
	end

	local maxBag = _G.NUM_BAG_SLOTS or 5

	for bag = 0, maxBag do
		local slots = GetContainerNumSlots(bag) or 0
		for slot = 1, slots do
			local id
			if GetContainerItemID then
				id = GetContainerItemID(bag, slot)
			end

			if not id and GetContainerItemInfo then
				local info = GetContainerItemInfo(bag, slot)
				id = info and info.itemID
			end

			if id == itemID then
				return bag, slot
			end
		end
	end
end

local function IsValidEvent(event)
	return not (C_EventUtils and C_EventUtils.IsEventValid) or C_EventUtils.IsEventValid(event)
end

function module:CreateSocketPanelBorder(frame, r, g, b, a)
	SetBorderColor(frame, r, g, b, a)
end

function module:StopSocketSlotGlow()
	local glow = self.socketSlotGlow

	if not glow then
		self.socketHighlightedSlot = nil
		return
	end

	if glow.anim and glow.anim:IsPlaying() then
		glow.anim:Stop()
	end

	glow:Hide()
	self.socketHighlightedSlot = nil
end

function module:StartSocketSlotGlow(slotID)
	local db = GetDB()

	if not db or not db.showSlotGlow then
		return
	end

	local slotButton
	if not self.socketSlotButtons then
		self.socketSlotButtons = {}
		for _, name in ipairs(SLOT_BUTTON_NAMES) do
			local button = _G["Character" .. name .. "Slot"]
			if button and button.GetID then
				self.socketSlotButtons[button:GetID()] = button
			end
		end
	end

	slotButton = self.socketSlotButtons[slotID]

	if not slotButton then
		return
	end

	local glow = self.socketSlotGlow
	if not glow then
		glow = CreateFrame("Frame", nil, self.frame)

		if glow.SetMouseClickEnabled then
			glow:SetMouseClickEnabled(false)
		end

		local top = glow:CreateTexture(nil, "OVERLAY")
		top:SetTexture(E.media.blankTex)
		top:SetHeight(2)
		top:SetPoint("TOPLEFT")
		top:SetPoint("TOPRIGHT")

		local bottom = glow:CreateTexture(nil, "OVERLAY")
		bottom:SetTexture(E.media.blankTex)
		bottom:SetHeight(2)
		bottom:SetPoint("BOTTOMLEFT")
		bottom:SetPoint("BOTTOMRIGHT")

		local left = glow:CreateTexture(nil, "OVERLAY")
		left:SetTexture(E.media.blankTex)
		left:SetWidth(2)
		left:SetPoint("TOPLEFT")
		left:SetPoint("BOTTOMLEFT")

		local right = glow:CreateTexture(nil, "OVERLAY")
		right:SetTexture(E.media.blankTex)
		right:SetWidth(2)
		right:SetPoint("TOPRIGHT")
		right:SetPoint("BOTTOMRIGHT")

		glow.textures = {
			top,
			bottom,
			left,
			right,
		}

		for _, tex in ipairs(glow.textures) do
			tex:SetVertexColor(1, 0.82, 0, 0)
		end

		local anim = glow:CreateAnimationGroup()
		anim:SetLooping("BOUNCE")

		local alpha = anim:CreateAnimation("Alpha")
		alpha:SetFromAlpha(0.15)
		alpha:SetToAlpha(0.95)
		alpha:SetDuration(0.7)
		alpha:SetSmoothing("IN_OUT")

		glow.anim = anim

		self.socketSlotGlow = glow
	end

	glow:ClearAllPoints()
	glow:SetAllPoints(slotButton)

	glow:SetFrameStrata(slotButton:GetFrameStrata())
	glow:SetFrameLevel(slotButton:GetFrameLevel() + 20)

	-- Keep the highlight above the Blizzard slot graphics.
	for _, tex in ipairs(glow.textures) do
		tex:SetVertexColor(1, 0.82, 0, 0.95)
	end

	glow:Show()

	self.socketHighlightedSlot = slotID

	if not glow.anim:IsPlaying() then
		glow.anim:Play()
	end
end

function module:PaintSocketIcon(button, record)
	local db = GetDB()

	if not db then
		return
	end

	local icon = button.icon
	icon:SetTexture(nil)
	icon:SetColorTexture(0, 0, 0, 0)

	if icon.SetAtlas then
		icon:SetAtlas(nil)
	end

	icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)

	if record.gemLink then
		local texture
		if GetItemInfoInstant then
			texture = select(5, GetItemInfoInstant(record.gemLink))
		end

		if not texture and GetItemIconByID then
			local itemID = GetGemIDFromLink(record.gemLink, 1)

			if itemID then
				texture = GetItemIconByID(itemID)
			end
		end

		icon:SetTexture(texture)
		button:SetAlpha(1)

		local rarity = 2

		if C_Item and GetItemInfo then
			local _, _, quality = GetItemInfo(record.gemLink)
			rarity = quality or rarity
		end

		if rarity >= 3 then
			SetBorderColor(button, 1, 0.82, 0, 1)
		else
			SetBorderColor(button, 0.75, 0.75, 0.75, 1)
		end
	else
		icon:SetTexture(EMPTY_SOCKET_TEXTURE)
		button:SetAlpha(0.85)

		SetBorderColor(button, 1, 1, 1, 0.4)
	end
end

function module:BuildSocketIcon(index)
	local button = self.socketIconPool[index]

	if button then
		return button
	end

	button = CreateFrame("Button", nil, self.socketPanel)
	button:RegisterForClicks("AnyUp")
	button:SetMotionScriptsWhileDisabled(true)

	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetAllPoints()

	local highlight = button:CreateTexture(nil, "HIGHLIGHT")
	highlight:SetAllPoints()
	highlight:SetColorTexture(1, 1, 1, 0.10)

	button:SetScript("OnEnter", function(btn)
		local record = btn.socketRecord

		if not record then
			return
		end

		-- Highlight the actual equipment slot.
		self:StartSocketSlotGlow(record.slot)

		local currentDB = GetDB()

		if currentDB and currentDB.openOnHover and not record.gemLink and not InCombatLockdown() then
			local open = self.socketFlyout and self.socketFlyout:IsShown()

			if not (open and (self.socketActiveIcon == btn or not self.socketFlyoutHover)) then
				self:OpenSocketFlyout(btn, record.slot, record.socketIndex, true)
			end
		end

		if record.gemLink then
			GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
			GameTooltip:SetHyperlink(record.gemLink)
			GameTooltip:Show()
		else
			GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
			GameTooltip:SetText(record.emptyName or (L["Empty Socket"] or "Empty Socket"))

			GameTooltip:AddLine(
				L["Pick a gem from the list to socket it."] or "Pick a gem from the list to socket it.",
				0.7,
				0.7,
				0.7,
				true
			)

			GameTooltip:Show()
		end
	end)

	button:SetScript("OnLeave", function()
		GameTooltip:Hide()

		if not self.socketPending then
			self:StopSocketSlotGlow()
		end

		self:MaybeCloseSocketFlyout()
	end)

	button:SetScript("OnClick", function(btn)
		local record = btn.socketRecord

		if not record or InCombatLockdown() then
			return
		end

		self:StartSocketSlotGlow(record.slot)

		if self.socketActiveIcon == btn and self.socketFlyout and self.socketFlyout:IsShown() then
			if self.socketFlyoutHover then
				self.socketFlyoutHover = false

				if self.socketCatcher then
					self.socketCatcher:Show()
				end
			else
				self:CloseSocketFlyout()
			end

			return
		end

		self:OpenSocketFlyout(btn, record.slot, record.socketIndex, false)
	end)

	self.socketIconPool[index] = button

	return button
end

function module:ScanSocketGems()
	self.socketGemCache = self.socketGemCache or {}
	self.socketPendingGemLoads = self.socketPendingGemLoads or {}

	wipe(self.socketGemCache)

	if not (C_Container and GetContainerNumSlots and GetItemInfoInstant) then
		self.socketGemDirty = false
		return
	end

	local seen = {}
	local maxBag = _G.NUM_BAG_SLOTS or 5

	for bag = 0, maxBag do
		local slots = GetContainerNumSlots(bag) or 0
		for slot = 1, slots do
			local info = GetContainerItemInfo and GetContainerItemInfo(bag, slot)
			local itemID = info and info.itemID

			if not itemID and GetContainerItemID then
				itemID = GetContainerItemID(bag, slot)
			end

			if itemID and not seen[itemID] then
				local _, _, _, _, texture, classID = GetItemInfoInstant(itemID)
				if classID == GEM_CLASS then
					seen[itemID] = true

					local link = info and info.hyperlink
					if not link and GetContainerItemLink then
						link = GetContainerItemLink(bag, slot)
					end

					if not link then
						self.socketPendingGemLoads[itemID] = true

						if RequestLoadItemDataByID then
							RequestLoadItemDataByID(itemID)
						end
					end

					tinsert(self.socketGemCache, {
						itemID = itemID,
						link = link,
						texture = texture,
					})
				end
			end
		end
	end

	self.socketGemDirty = false
end

function module:RebuildSocketPanel()
	local db = GetDB()

	if not db or not db.enable or not self.socketPanel then
		return
	end

	wipe(self.socketRecords)
	wipe(self.socketRelevantItems)

	if GetItemNumSockets and GetItemGem then
		for _, slotID in ipairs(SOCKET_SLOTS) do
			local link = GetInventoryItemLink("player", slotID)
			if link then
				-- Track every equipped item (not just ones that already report sockets):
				-- a freshly-swapped item's socket count can be unavailable until its data
				-- finishes loading, so we request it and re-scan once ITEM_DATA_LOAD_RESULT
				-- fires for it (see OnSocketEvent) instead of waiting for the next full reopen.
				if GetItemInfoInstant then
					local itemID = GetItemInfoInstant(link)
					if itemID then
						self.socketRelevantItems[itemID] = true

						if not self.socketRequestedItemLoads[itemID] and RequestLoadItemDataByID then
							self.socketRequestedItemLoads[itemID] = true
							RequestLoadItemDataByID(itemID)
						end
					end
				end

				local numSockets = GetItemNumSockets(link) or 0
				if numSockets > 0 then
					local emptyName = GetEmptySocketName(link)

					for socketIndex = 1, numSockets do
						local _, gemLink = GetItemGem(link, socketIndex)
						if not gemLink then
							local gemID = GetGemIDFromLink(link, socketIndex)
							if gemID then
								gemLink = "item:" .. gemID

								if not self.socketRequestedGemLoads[gemID] and RequestLoadItemDataByID then
									self.socketRequestedGemLoads[gemID] = true
									RequestLoadItemDataByID(gemID)
								end
							end
						end

						if gemLink and GetItemInfoInstant then
							local gemID = GetItemInfoInstant(gemLink)

							if gemID then
								self.socketRelevantItems[gemID] = true
							end
						end

						tinsert(self.socketRecords, {
							slot = slotID,
							socketIndex = socketIndex,
							gemLink = gemLink,
							emptyName = emptyName,
						})
					end
				end
			end
		end
	end

	for _, button in ipairs(self.socketIconPool) do
		button:Hide()
		button.socketRecord = nil
	end

	local count = #self.socketRecords

	if count == 0 then
		self.socketPanel:Hide()
		self:StopSocketSlotGlow()
		return
	end

	local iconSize = Scale(db.iconSize)
	local spacing = Scale(db.spacing)

	for index, record in ipairs(self.socketRecords) do
		local button = self:BuildSocketIcon(index)

		button:SetSize(iconSize, iconSize)
		button.socketRecord = record

		self:PaintSocketIcon(button, record)

		button:ClearAllPoints()
		button:SetPoint("LEFT", self.socketPanel, "LEFT", (index - 1) * (iconSize + spacing), 0)
		button:Show()
	end

	self.socketPanel:SetSize(max(iconSize, count * (iconSize + spacing) - spacing), iconSize)
	self.socketPanel:Show()
end

function module:CloseSocketSession()
	self:StopSocketSlotGlow()

	if CloseSocketInfo then
		CloseSocketInfo()
	end

	local frame = _G.ItemSocketingFrame
	if frame and frame:IsShown() and not InCombatLockdown() and HideUIPanel then
		HideUIPanel(frame)
	end
end

function module:SocketGemIntoItem(targetSlot, socketIndex, gemItemID)
	if InCombatLockdown() or (CursorHasItem and CursorHasItem()) then
		return
	end

	if not SocketInventoryItem then
		return
	end

	if _G.ItemSocketingFrame and _G.ItemSocketingFrame:IsShown() then
		if self.socketOurSession then
			self:CloseSocketSession()
		end

		return
	end

	self.socketPending = {
		slot = targetSlot,
		socketIndex = socketIndex,
		gemItemID = gemItemID,
		acted = false,
	}

	self.socketOurSession = true

	-- Keep the target equipment item highlighted while the
	-- socketing operation is active.
	self:StartSocketSlotGlow(targetSlot)

	SocketInventoryItem(targetSlot)

	self:CloseSocketFlyout()
end

function module:HandleSocketInfoUpdate()
	local pending = self.socketPending

	if not pending then
		return
	end

	if pending.acted then
		local retries = pending.retries or 0
		if retries < 3 and AcceptSockets then
			pending.retries = retries + 1
			AcceptSockets()
		end
		return
	end

	local socketCount = GetNumSockets and GetNumSockets()
	if not socketCount or pending.socketIndex > socketCount then
		return
	end

	pending.acted = true

	local bag, slot = FindBagSlot(pending.gemItemID)
	if not bag then
		self.socketPending = nil
		self:CloseSocketSession()
		return
	end

	if C_Container and C_Container.PickupContainerItem then
		C_Container.PickupContainerItem(bag, slot)
	end

	if ClickSocketButton then
		ClickSocketButton(pending.socketIndex)
	end

	if ClearCursor then
		ClearCursor()
	end

	if AcceptSockets then
		AcceptSockets()
	end
end

function module:BuildSocketFlyout()
	if self.socketFlyout then
		return
	end

	local db = GetDB()

	self.socketCatcher = CreateFrame("Button", nil, E.UIParent)
	self.socketCatcher:SetAllPoints(E.UIParent)
	self.socketCatcher:SetFrameStrata("FULLSCREEN")
	self.socketCatcher:EnableMouse(true)
	self.socketCatcher:RegisterForClicks("AnyUp")
	self.socketCatcher:Hide()

	self.socketCatcher:SetScript("OnClick", function()
		self:CloseSocketFlyout()
	end)

	local flyout = CreateFrame("Frame", "MER_ArmorySocketFlyout", E.UIParent)
	flyout:SetFrameStrata("FULLSCREEN_DIALOG")
	flyout:SetWidth(Scale(db.flyoutWidth))
	flyout:SetHeight(Scale(db.rowHeight + 8))
	flyout:Hide()
	flyout:EnableMouse(true)
	flyout:EnableMouseWheel(true)

	flyout:SetScript("OnLeave", function()
		self:MaybeCloseSocketFlyout()
	end)

	flyout:SetScript("OnMouseWheel", function(_, delta)
		if not self.socketGemCache or #self.socketGemCache <= db.maxRows then
			return
		end

		self.socketFlyoutScroll = self.socketFlyoutScroll - delta

		self:PopulateSocketFlyout()
	end)

	flyout:EnableKeyboard(true)
	flyout:SetPropagateKeyboardInput(true)

	flyout:SetScript("OnKeyDown", function(frame, key)
		if InCombatLockdown() then
			return
		end

		if key == "ESCAPE" then
			frame:SetPropagateKeyboardInput(false)
			self:CloseSocketFlyout()
		else
			frame:SetPropagateKeyboardInput(true)
		end
	end)

	local bg = flyout:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	bg:SetTexture(E.media.blankTex)
	bg:SetVertexColor(0.06, 0.06, 0.06, 0.95)

	CreateSimpleBorder(flyout)
	SetBorderColor(flyout, 0.2, 0.2, 0.2, 1)

	self.socketFlyout = flyout
	self.socketGemRows = {}
end

function module:BuildSocketGemRow(index)
	local row = self.socketGemRows[index]

	if row then
		return row
	end

	local db = GetDB()

	row = CreateFrame("Button", nil, self.socketFlyout)
	row:SetHeight(Scale(db.rowHeight))

	row.icon = row:CreateTexture(nil, "ARTWORK")
	row.icon:SetSize(Scale(db.rowHeight - 2), Scale(db.rowHeight - 2))
	row.icon:SetPoint("LEFT", 2, 0)

	row.label = row:CreateFontString(nil, "OVERLAY")
	row.label:SetPoint("LEFT", row.icon, "RIGHT", Scale(5), 0)
	row.label:SetJustifyH("LEFT")

	row.count = row:CreateFontString(nil, "OVERLAY")
	row.count:SetPoint("RIGHT", -Scale(6), 0)
	row.count:SetJustifyH("RIGHT")
	row.count:SetTextColor(0.7, 0.7, 0.7)

	local highlight = row:CreateTexture(nil, "HIGHLIGHT")
	highlight:SetAllPoints()
	highlight:SetColorTexture(1, 1, 1, 0.08)

	row:SetScript("OnEnter", function(selfRow)
		if not selfRow.gemLink then
			return
		end

		GameTooltip:SetOwner(selfRow, "ANCHOR_RIGHT")

		GameTooltip:SetHyperlink(selfRow.gemLink)
		GameTooltip:Show()
	end)

	row:SetScript("OnLeave", function()
		GameTooltip:Hide()
		self:MaybeCloseSocketFlyout()
	end)

	row:SetScript("OnClick", function(selfRow)
		if selfRow.gemItemID and self.socketFlyout then
			self:SocketGemIntoItem(self.socketFlyout.targetSlot, self.socketFlyout.targetSocketIndex, selfRow.gemItemID)
		end
	end)

	self.socketGemRows[index] = row

	return row
end

function module:SetSocketRowFont(row)
	local db = GetDB()

	if not db then
		return
	end

	WF.SetFontWithDB(row.label, db.font)
	WF.SetFontWithDB(row.count, db.font)
end

function module:PopulateSocketFlyout()
	local db = GetDB()

	if not db or not self.socketFlyout then
		return
	end

	if self.socketGemDirty then
		self:ScanSocketGems()
	end

	for _, row in ipairs(self.socketGemRows) do
		row:Hide()
		row.gemItemID = nil
		row.gemLink = nil
	end

	local count = self.socketGemCache and #self.socketGemCache or 0
	local visible = count

	if visible > db.maxRows then
		visible = db.maxRows
	end

	local shown = visible > 0 and visible or 1
	local maxScroll = math.max(0, count - visible)

	self.socketFlyoutScroll = math.min(maxScroll, math.max(0, self.socketFlyoutScroll or 0))

	if count == 0 then
		local row = self:BuildSocketGemRow(1)

		self:SetSocketRowFont(row)

		row.icon:SetTexture(nil)

		row.label:SetText(L["No gems in bags."] or "No gems in bags.")
		row.label:SetTextColor(0.5, 0.5, 0.5)

		row.count:SetText("")

		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", 4, -4)
		row:SetPoint("TOPRIGHT", -4, -4)
		row:Show()
	else
		for visualIndex = 1, visible do
			local gem = self.socketGemCache[self.socketFlyoutScroll + visualIndex]

			local row = self:BuildSocketGemRow(visualIndex)

			self:SetSocketRowFont(row)

			row.icon:SetTexture(gem.texture)

			row.label:SetTextColor(1, 1, 1)
			row.label:SetText(gem.link and GetGemStatText(gem.link) or (L["Loading..."] or "Loading..."))

			row.count:SetText(format("%dx", (GetItemCount and GetItemCount(gem.itemID)) or 1))

			row.gemItemID = gem.itemID
			row.gemLink = gem.link

			row:ClearAllPoints()
			row:SetPoint("TOPLEFT", 4, -4 - (visualIndex - 1) * Scale(db.rowHeight))
			row:SetPoint("TOPRIGHT", -4, -4 - (visualIndex - 1) * Scale(db.rowHeight))
			row:Show()
		end
	end

	self.socketFlyout:SetHeight(Scale(8 + shown * db.rowHeight))
	self.socketFlyout:SetWidth(Scale(db.flyoutWidth))
end

function module:OpenSocketFlyout(iconButton, targetSlot, targetSocketIndex, hoverMode)
	self:BuildSocketFlyout()
	self:CloseSocketFlyout()

	self.socketFlyoutHover = hoverMode == true
	self.socketFlyout.targetSlot = targetSlot
	self.socketFlyout.targetSocketIndex = targetSocketIndex
	self.socketActiveIcon = iconButton
	self.socketFlyoutScroll = 0

	-- Highlight the corresponding equipment item
	-- as soon as the flyout opens.
	self:StartSocketSlotGlow(targetSlot)

	self:PopulateSocketFlyout()

	self.socketFlyout:ClearAllPoints()

	local height = self.socketFlyout:GetHeight()
	local bottom = iconButton:GetBottom() or 0

	if bottom - height - Scale(6) < 0 then
		self.socketFlyout:SetPoint("BOTTOMLEFT", iconButton, "TOPLEFT", 0, Scale(4))
	else
		self.socketFlyout:SetPoint("TOPLEFT", iconButton, "BOTTOMLEFT", 0, -Scale(4))
	end

	self.socketFlyout:SetPropagateKeyboardInput(true)

	if not self.socketFlyoutHover then
		self.socketCatcher:Show()
	end

	self.socketFlyout:Show()

	if self.socketEvents then
		self.socketEvents:RegisterEvent("PLAYER_REGEN_DISABLED")
	end
end

function module:CloseSocketFlyout()
	if self.socketFlyout then
		self.socketFlyout:Hide()
	end

	if self.socketCatcher then
		self.socketCatcher:Hide()
	end

	self.socketActiveIcon = nil
	self.socketFlyoutHover = false

	if self.socketEvents then
		self.socketEvents:UnregisterEvent("PLAYER_REGEN_DISABLED")
	end

	-- Do not remove the item highlight here if an actual
	-- socketing operation is currently active.
	if not self.socketPending then
		self:StopSocketSlotGlow()
	end
end

function module:RefreshSocketGemCache()
	self.socketGemDirty = true

	self:ScanSocketGems()

	if self.socketFlyout and self.socketFlyout:IsShown() then
		self:PopulateSocketFlyout()
	end
end

function module:MaybeCloseSocketFlyout()
	if not self.socketFlyoutHover or not self.socketFlyout or not self.socketFlyout:IsShown() then
		return
	end

	if self.socketFlyout:IsMouseOver(Scale(8), -Scale(8), -Scale(8), Scale(8)) then
		return
	end

	if self.socketActiveIcon and self.socketActiveIcon:IsMouseOver() then
		return
	end

	self:CloseSocketFlyout()
end

function module:OnSocketEvent(_, event, arg1, arg2)
	if event == "PLAYER_EQUIPMENT_CHANGED" then
		self:RebuildSocketPanel()
	elseif event == "SOCKET_INFO_UPDATE" then
		self:HandleSocketInfoUpdate()
	elseif event == "SOCKET_INFO_ACCEPT" or event == "SOCKET_INFO_CLOSE" then
		local ours = self.socketPending ~= nil

		self.socketPending = nil

		if event == "SOCKET_INFO_CLOSE" then
			self.socketOurSession = false
		end

		-- The socket operation is finished.
		self:StopSocketSlotGlow()

		self.socketGemDirty = true
		self:RebuildSocketPanel()

		if event == "SOCKET_INFO_ACCEPT" and ours then
			self:CloseSocketSession()
		end
	elseif event == "BAG_UPDATE_DELAYED" then
		self:RefreshSocketGemCache()
	elseif event == "ITEM_DATA_LOAD_RESULT" then
		local itemID = arg1
		local success = arg2

		if itemID and self.socketPendingGemLoads and self.socketPendingGemLoads[itemID] then
			self.socketPendingGemLoads[itemID] = nil

			if success ~= false then
				self.socketGemDirty = true

				self:ScanSocketGems()

				if self.socketFlyout and self.socketFlyout:IsShown() then
					self:PopulateSocketFlyout()
				end
			end
		end

		if self.socketPanel and self.socketPanel:IsShown() then
			if not itemID or self.socketRelevantItems[itemID] then
				self:RebuildSocketPanel()
			end
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		self.socketPending = nil
		self.socketOurSession = false

		self:StopSocketSlotGlow()
		self:CloseSocketFlyout()
	end
end

function module:BuildSocketPanel()
	if self.socketPanel then
		return
	end

	local db = GetDB()

	if not db then
		return
	end

	self.socketPanel = CreateFrame("Frame", "MER_ArmorySocketPanel", _G.CharacterStatsPane)
	self.socketPanel:SetPoint("BOTTOMRIGHT", _G.CharacterStatsPane, "BOTTOMRIGHT", Scale(db.anchorX), Scale(db.anchorY))
	self.socketPanel:SetSize(Scale(db.iconSize), Scale(db.iconSize))
	self.socketPanel:SetFrameLevel(55)
	self.socketPanel:Hide()

	self.socketIconPool = {}
	self.socketRecords = {}
	self.socketGemCache = {}
	self.socketGemDirty = true
	self.socketRelevantItems = {}
	self.socketPendingGemLoads = {}
	self.socketRequestedGemLoads = {}
	self.socketRequestedItemLoads = {}

	self.socketEvents = CreateFrame("Frame")

	self.socketEvents:SetScript("OnEvent", function(frame, event, arg1, arg2)
		self:OnSocketEvent(frame, event, arg1, arg2)
	end)
end

function module:RegisterSocketEvents()
	if self.socketShownEvents or not self.socketEvents then
		return
	end

	self.socketShownEvents = true

	for _, event in ipairs({
		"PLAYER_EQUIPMENT_CHANGED",
		"SOCKET_INFO_UPDATE",
		"SOCKET_INFO_ACCEPT",
		"SOCKET_INFO_CLOSE",
		"BAG_UPDATE_DELAYED",
		"ITEM_DATA_LOAD_RESULT",
	}) do
		if IsValidEvent(event) then
			pcall(self.socketEvents.RegisterEvent, self.socketEvents, event)
		end
	end
end

function module:UnregisterSocketEvents()
	if not (self.socketShownEvents and self.socketEvents) then
		return
	end

	self.socketShownEvents = false

	for _, event in ipairs({
		"PLAYER_EQUIPMENT_CHANGED",
		"SOCKET_INFO_UPDATE",
		"SOCKET_INFO_ACCEPT",
		"SOCKET_INFO_CLOSE",
		"BAG_UPDATE_DELAYED",
		"ITEM_DATA_LOAD_RESULT",
	}) do
		pcall(self.socketEvents.UnregisterEvent, self.socketEvents, event)
	end

	self.socketEvents:UnregisterEvent("PLAYER_REGEN_DISABLED")
end

function module:SocketPanelOnShow()
	local db = GetDB()

	if not db or not db.enable or not self.frame:IsShown() then
		if self.socketPanel then
			self.socketPanel:Hide()
		end

		return
	end

	self:BuildSocketPanel()

	if not self.socketPanel then
		return
	end

	self.socketPanel:ClearAllPoints()
	self.socketPanel:SetPoint("BOTTOMRIGHT", _G.CharacterStatsPane, "BOTTOMRIGHT", Scale(db.anchorX), Scale(db.anchorY))
	self:RegisterSocketEvents()
	self.socketGemDirty = true

	wipe(self.socketRequestedGemLoads)
	wipe(self.socketPendingGemLoads)

	self:ScanSocketGems()
	self:RebuildSocketPanel()
end

function module:SocketPanelOnHide()
	self:StopSocketSlotGlow()
	self:CloseSocketFlyout()

	if self.socketOurSession then
		self.socketOurSession = false
		self.socketPending = nil

		self:CloseSocketSession()
	else
		self.socketPending = nil
	end

	self:UnregisterSocketEvents()

	if self.socketPanel then
		self.socketPanel:Hide()
	end
end

function module:EnableSocketPanel()
	local db = GetDB()

	if not db then
		return
	end

	self:BuildSocketPanel()

	if self.frame:IsShown() then
		self:SocketPanelOnShow()
	end
end

function module:DisableSocketPanel()
	self:SocketPanelOnHide()
end

function module:UpdateSocketPanel()
	local db = GetDB()

	if not db or not db.enable or not self.frame or not self.frame:IsShown() then
		self:SocketPanelOnHide()
		return
	end

	self:BuildSocketPanel()

	if not self.socketPanel then
		return
	end

	self.socketPanel:ClearAllPoints()
	self.socketPanel:SetPoint("BOTTOMRIGHT", _G.CharacterStatsPane, "BOTTOMRIGHT", Scale(db.anchorX), Scale(db.anchorY))

	-- This is the only reliable place that reaches every "character frame is now
	-- showing the socket panel" case (EnableSocketPanel only covers the addon-load
	-- edge case). Without this, PLAYER_EQUIPMENT_CHANGED etc. never get registered
	-- and the panel only ever reflects reality again after a full frame close/reopen.
	self:RegisterSocketEvents()

	self:RebuildSocketPanel()

	if self.socketFlyout and self.socketFlyout:IsShown() then
		self:PopulateSocketFlyout()
	end

	-- Re-apply the highlight after a panel rebuild.
	if self.socketFlyout and self.socketFlyout:IsShown() and self.socketFlyout.targetSlot then
		self:StartSocketSlotGlow(self.socketFlyout.targetSlot)
	elseif self.socketPending and self.socketPending.slot then
		self:StartSocketSlotGlow(self.socketPending.slot)
	end
end
