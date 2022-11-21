local _, ns = ...
local cargBags = ns.cargBags

local MER, F, E, L, V, P, G = unpack(ns)
local module = MER:GetModule('MER_Bags')
local S = MER:GetModule('MER_Skins')
local B = E:GetModule('Bags')

local _G = _G
local strmatch, unpack, ceil = string.match, unpack, math.ceil
local LE_ITEM_QUALITY_POOR, LE_ITEM_QUALITY_RARE = LE_ITEM_QUALITY_POOR, LE_ITEM_QUALITY_RARE
local LE_ITEM_CLASS_QUIVER, LE_ITEM_CLASS_CONTAINER = LE_ITEM_CLASS_QUIVER, LE_ITEM_CLASS_CONTAINER
local GetContainerNumSlots, GetContainerItemInfo, PickupContainerItem = GetContainerNumSlots, GetContainerItemInfo,
	PickupContainerItem
local C_NewItems_IsNewItem, C_NewItems_RemoveNewItem = C_NewItems.IsNewItem, C_NewItems.RemoveNewItem
local IsControlKeyDown, IsAltKeyDown, IsShiftKeyDown, DeleteCursorItem = IsControlKeyDown, IsAltKeyDown, IsShiftKeyDown,
	DeleteCursorItem
local SortBankBags, SortBags, InCombatLockdown, ClearCursor = SortBankBags, SortBags, InCombatLockdown, ClearCursor
local GetContainerItemID, SplitContainerItem = GetContainerItemID, SplitContainerItem
local NUM_BAG_SLOTS = NUM_BAG_SLOTS or 4
local NUM_BANKBAGSLOTS = NUM_BANKBAGSLOTS or 7
local ITEM_STARTS_QUEST = ITEM_STARTS_QUEST

local anchorCache = {}

function module:UpdateBagsAnchor(parent, bags)
	wipe(anchorCache)

	local index = 1
	local perRow = module.db.BagsPerRow
	anchorCache[index] = parent

	for i = 1, #bags do
		local bag = bags[i]
		if bag:GetHeight() > 45 then
			bag:Show()
			index = index + 1

			bag:ClearAllPoints()
			if (index - 1) % perRow == 0 then
				bag:SetPoint("BOTTOMRIGHT", anchorCache[index - perRow], "BOTTOMLEFT", -5, 0)
			else
				bag:SetPoint("BOTTOMLEFT", anchorCache[index - 1], "TOPLEFT", 0, 5)
			end
			anchorCache[index] = bag
		else
			bag:Hide()
		end
	end
end

function module:UpdateBankAnchor(parent, bags)
	wipe(anchorCache)

	local index = 1
	local perRow = module.db.BankPerRow
	anchorCache[index] = parent

	for i = 1, #bags do
		local bag = bags[i]
		if bag:GetHeight() > 45 then
			bag:Show()
			index = index + 1

			bag:ClearAllPoints()
			if index <= perRow then
				bag:SetPoint("BOTTOMLEFT", anchorCache[index - 1], "TOPLEFT", 0, 5)
			elseif index == perRow + 1 then
				bag:SetPoint("TOPLEFT", anchorCache[index - 1], "TOPRIGHT", 5, 0)
			elseif (index - 1) % perRow == 0 then
				bag:SetPoint("TOPLEFT", anchorCache[index - perRow], "TOPRIGHT", 5, 0)
			else
				bag:SetPoint("TOPLEFT", anchorCache[index - 1], "BOTTOMLEFT", 0, -5)
			end
			anchorCache[index] = bag
		else
			bag:Hide()
		end
	end
end

local function highlightFunction(button, match)
	button.searchOverlay:SetShown(not match)
end

local function IsItemMatched(str, text)
	if not str or str == "" then return end
	return strmatch(strlower(str), text)
end

local BagSmartFilter = {
	default = function(item, text)
		text = strlower(text)
		if text == "boe" then
			return item.bindOn == "equip"
		else
			return IsItemMatched(item.subType, text) or IsItemMatched(item.equipLoc, text) or IsItemMatched(item.name, text)
		end
	end,
	_default = "default",
}

function module:CreateInfoFrame()
	local infoFrame = CreateFrame("Button", nil, self)
	infoFrame:SetPoint("TOPLEFT", 10, 0)
	infoFrame:SetSize(140, 32)

	local icon = infoFrame:CreateTexture(nil, "ARTWORK")
	icon:SetSize(20, 20)
	icon:SetPoint("LEFT", 0, -1)
	icon:SetTexture("Interface\\Common\\UI-Searchbox-Icon")
	icon:SetVertexColor(F.r, F.g, F.b)

	local hl = infoFrame:CreateTexture(nil, "HIGHLIGHT")
	hl:SetSize(20, 20)
	hl:SetPoint("LEFT", 0, -1)
	hl:SetTexture("Interface\\Common\\UI-Searchbox-Icon")

	local search = self:SpawnPlugin("SearchBar", infoFrame)
	search.highlightFunction = highlightFunction
	search.isGlobal = true
	search:SetPoint("LEFT", 0, 5)
	search:DisableDrawLayer("BACKGROUND")

	local bg = S:CreateBDFrame(search, .5, true)
	bg:SetPoint("TOPLEFT", -5, -5)
	bg:SetPoint("BOTTOMRIGHT", 5, 5)
	search.textFilters = BagSmartFilter

	infoFrame.title = SEARCH
	F.AddTooltip(infoFrame, "ANCHOR_TOPLEFT", MER.InfoColor .. L["Bag Search Tip"])
end

local function ToggleWidgetButtons(self)
	module.db.HideWidgets = not module.db.HideWidgets

	local buttons = self.__owner.widgetButtons

	for index, button in pairs(buttons) do
		if index > 2 then
			button:SetShown(not module.db.HideWidgets)
		end
	end

	if module.db.HideWidgets then
		self:SetPoint("RIGHT", buttons[2], "LEFT", -1, 0)
		S:SetupArrow(self.__texture, "left")
		self.tag:Show()
	else
		self:SetPoint("RIGHT", buttons[#buttons], "LEFT", -1, 0)
		S:SetupArrow(self.__texture, "right")
		self.tag:Hide()
	end
	self:Show()
end

function module:CreateCollapseArrow()
	local bu = CreateFrame("Button", nil, self)
	bu:SetSize(20, 20)
	local tex = bu:CreateTexture()
	tex:SetAllPoints()
	S:SetupArrow(tex, "right")
	bu.__texture = tex
	bu:SetScript("OnEnter", F.Texture_OnEnter)
	bu:SetScript("OnLeave", F.Texture_OnLeave)

	local tag = self:SpawnPlugin("TagDisplay", "[money]", self)
	tag:FontTemplate()
	tag:SetPoint("RIGHT", bu, "LEFT", -12, 0)
	bu.tag = tag

	bu.__owner = self
	module.db.HideWidgets = not module.db.HideWidgets -- reset before toggle
	ToggleWidgetButtons(bu)
	bu:SetScript("OnClick", ToggleWidgetButtons)

	self.widgetArrow = bu
end

local function updateBagBar(bar)
	local spacing = 3
	local offset = 5
	local width, height = bar:LayoutButtons("grid", bar.columns, spacing, offset, -offset)
	bar:SetSize(width + offset * 2, height + offset * 2)
end

function module:CreateBagBar(settings, columns)
	local bagBar = self:SpawnPlugin("BagBar", settings.Bags)
	bagBar:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -5)
	bagBar:CreateBackdrop('Transparent')
	bagBar.highlightFunction = highlightFunction
	bagBar.isGlobal = true
	bagBar:Hide()
	bagBar.columns = columns
	bagBar.UpdateAnchor = updateBagBar
	bagBar:UpdateAnchor()

	self.BagBar = bagBar
end

local function CloseOrRestoreBags(self, btn)
	if btn == "RightButton" then
		local bag = self.__owner.main
		local bank = self.__owner.bank
		local reagent = self.__owner.reagent
		bag:ClearAllPoints()
		bag:SetPoint(unpack(bag.__anchor))
		bank:ClearAllPoints()
		bank:SetPoint(unpack(bank.__anchor))
		reagent:ClearAllPoints()
		reagent:SetPoint(unpack(reagent.__anchor))
		PlaySound(SOUNDKIT.IG_MINIMAP_OPEN)
	else
		CloseAllBags()
	end
end

function module:CreateCloseButton(f)
	local bu = S.CreateButton(self, 22, 22, true, "Interface\\RAIDFRAME\\ReadyCheck-NotReady")
	bu:RegisterForClicks("AnyUp")
	bu.__owner = f
	bu:SetScript("OnClick", CloseOrRestoreBags)
	bu.title = CLOSE .. "/" .. RESET
	F.AddTooltip(bu, "ANCHOR_TOP")

	return bu
end

local function ToggleBackpacks(self)
	local parent = self.__owner
	F:TogglePanel(parent.BagBar)
	if parent.BagBar:IsShown() then
		self.backdrop:SetBackdropBorderColor(1, .8, 0)
		PlaySound(SOUNDKIT.IG_BACKPACK_OPEN)
		if parent.keyring and parent.keyring:IsShown() then parent.keyToggle:Click() end
	else
		S.SetBorderColor(self.backdrop)
		PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE)
	end
end

function module:CreateBagToggle()
	local bu = S.CreateButton(self, 22, 22, true, "Interface\\Buttons\\Button-Backpack-Up")
	bu.__owner = self
	bu:SetScript("OnClick", ToggleBackpacks)
	bu.title = BACKPACK_TOOLTIP
	F.AddTooltip(bu, "ANCHOR_TOP")
	self.bagToggle = bu

	return bu
end

function module:CreateKeyToggle()
	local bu = S.CreateButton(self, 22, 22, true, "Interface\\ICONS\\INV_Misc_Key_12")

	bu:SetScript("OnClick", function()
		ToggleFrame(self.keyring)
		if self.keyring:IsShown() then
			bu.backdrop:SetBackdropBorderColor(1, .8, 0)
			PlaySound(SOUNDKIT.KEY_RING_OPEN)
			if self.BagBar and self.BagBar:IsShown() then self.bagToggle:Click() end
		else
			S.SetBorderColor(bu.backdrop)
			PlaySound(SOUNDKIT.KEY_RING_CLOSE)
		end
	end)
	bu.title = KEYRING
	F.AddTooltip(bu, "ANCHOR_TOP")
	self.keyToggle = bu

	return bu
end

function module:CreateSortButton(name)
	local bu = S.CreateButton(self, 22, 22, true, MER.Media.Icons.sort)
	bu:SetScript("OnClick", function()
		if module.db.BagSortMode == 3 then
			UIErrorsFrame:AddMessage(MER.InfoColor .. L["Bag Sort Disabled"])
			return
		end

		if InCombatLockdown() then
			UIErrorsFrame:AddMessage(MER.InfoColor .. ERR_NOT_IN_COMBAT)
			return
		end

		if name == "Bank" then
			SortBankBags()
		else
			SortBags()
		end
	end)
	bu.title = L["Sort"]
	F.AddTooltip(bu, "ANCHOR_TOP")

	return bu
end

function module:GetContainerEmptySlot(bagID, bagGroup)
	if cargBags.BagGroups[bagID] == bagGroup then
		for slotID = 1, GetContainerNumSlots(bagID) do
			if not GetContainerItemID(bagID, slotID) then
				return slotID
			end
		end
	end
end

function module:GetEmptySlot(bagType, bagGroup)
	if bagType == "Bag" then
		for bagID = 0, NUM_BAG_SLOTS do
			local slotID = module:GetContainerEmptySlot(bagID, bagGroup)
			if slotID then
				return bagID, slotID
			end
		end
	elseif bagType == "Bank" then
		local slotID = module:GetContainerEmptySlot(-1, bagGroup)
		if slotID then
			return -1, slotID
		end
		for bagID = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
			local slotID = module:GetContainerEmptySlot(bagID, bagGroup)
			if slotID then
				return bagID, slotID
			end
		end
	end
end

function module:FreeSlotOnDrop()
	local bagID, slotID = module:GetEmptySlot(self.__owner.Settings.BagType, self.__owner.bagGroup)
	if slotID then
		PickupContainerItem(bagID, slotID)
	end
end

local freeSlotContainer = {
	["Bag"] = 0,
	["Bank"] = 0,
	["AmmoItem"] = E.myclass == "WARLOCK" and 1 or E.myclass == "HUNTER" and -1,
	["BankAmmoItem"] = E.myclass == "WARLOCK" and 1 or E.myclass == "HUNTER" and -1,
}

function module:CreateFreeSlots()
	local name = self.name
	local bagGroup = freeSlotContainer[name]
	if not bagGroup then return end
	self.bagGroup = bagGroup

	local slot = CreateFrame("Button", name .. "FreeSlot", self, "BackdropTemplate")
	slot:SetSize(self.iconSize, self.iconSize)
	slot:SetHighlightTexture(E.media.normTex)
	slot:GetHighlightTexture():SetVertexColor(1, 1, 1, .25)
	slot:GetHighlightTexture():SetInside()
	slot:CreateBackdrop("Transparent")
	slot:SetBackdropColor(.3, .3, .3, .3)
	slot:SetScript("OnMouseUp", module.FreeSlotOnDrop)
	slot:SetScript("OnReceiveDrag", module.FreeSlotOnDrop)
	F.AddTooltip(slot, "ANCHOR_RIGHT", L["FreeSlots"])
	slot.__owner = self

	local tag = self:SpawnPlugin("TagDisplay", "[space]", slot)
	tag:FontTemplate(nil, module.db.FontSize + 2, "OUTLINE")
	tag:SetTextColor(.6, .8, 1)
	tag:SetPoint("CENTER", 1, 0)
	tag.__owner = self
	slot.tag = tag

	self.freeSlot = slot

end

local toggleButtons = {}
function module:SelectToggleButton(id)
	for index, button in pairs(toggleButtons) do
		if index ~= id then
			button.__turnOff()
		end
	end
end

local splitEnable
local function saveSplitCount(self)
	local count = self:GetText() or ""
	module.db.SplitCount = tonumber(count) or 1
end

function module:CreateSplitButton()
	local enabledText = MER.InfoColor .. L["Split Mode Enabled"]

	local splitFrame = CreateFrame("Frame", nil, self)
	splitFrame:SetSize(100, 50)
	splitFrame:SetPoint("TOPRIGHT", self, "TOPLEFT", 0, -1)
	splitFrame:CreateBackdrop('Transparent')
	splitFrame.backdrop:Styling()
	S:CreateBackdropShadow(splitFrame)

	splitFrame.Text = splitFrame:CreateFontString(nil, "ARTWORK")
	splitFrame.Text:FontTemplate(nil, 14, "OUTLINE")
	splitFrame.Text:SetText(L["SplitCount"])
	splitFrame.Text:SetTextColor(1, .8, 0)
	splitFrame.Text:SetPoint("TOP", 1, -5)

	splitFrame:Hide()

	local editbox = S.CreateEditBox(splitFrame, 90, 20)
	editbox:SetPoint("BOTTOMLEFT", 5, 5)
	editbox:SetJustifyH("CENTER")
	editbox:SetScript("OnTextChanged", saveSplitCount)

	local bu = S.CreateButton(self, 22, 22, true, "Interface\\HELPFRAME\\ReportLagIcon-AuctionHouse")
	bu.Icon:SetPoint("TOPLEFT", -1, 3)
	bu.Icon:SetPoint("BOTTOMRIGHT", 1, -3)
	bu.__turnOff = function()
		S.SetBorderColor(bu.backdrop)
		bu.text = nil
		splitFrame:Hide()
		splitEnable = nil
	end
	bu:SetScript("OnClick", function(self)
		module:SelectToggleButton(1)
		splitEnable = not splitEnable
		if splitEnable then
			self.backdrop:SetBackdropBorderColor(1, .8, 0)
			self.text = enabledText
			splitFrame:Show()
			editbox:SetText(module.db.SplitCount)
		else
			self.__turnOff()
		end
		self:GetScript("OnEnter")(self)
	end)
	bu:SetScript("OnHide", bu.__turnOff)
	bu.title = L["Quick Split"]
	F.AddTooltip(bu, "ANCHOR_TOP")

	toggleButtons[1] = bu

	return bu
end

local function splitOnClick(self)
	if not splitEnable then return end

	PickupContainerItem(self.bagID, self.slotID)

	local texture, itemCount, locked = GetContainerItemInfo(self.bagID, self.slotID)
	if texture and not locked and itemCount and itemCount > module.db.SplitCount then
		SplitContainerItem(self.bagID, self.slotID, module.db.SplitCount)

		local bagID, slotID = module:GetEmptySlot("Bag")
		if slotID then
			PickupContainerItem(bagID, slotID)
		end
	end
end

local favouriteEnable

local function GetCustomGroupTitle(index)
	return module.db.CustomNames[index] or (PREFERENCES .. " " .. index)
end

StaticPopupDialogs["MER_RENAMECUSTOMGROUP"] = {
	text = BATTLE_PET_RENAME,
	button1 = OKAY,
	button2 = CANCEL,
	OnAccept = function(self)
		local index = module.selectGroupIndex
		local text = self.editBox:GetText()
		module.db.CustomNames[index] = text ~= "" and text or nil

		module.CustomMenu[index + 2].text = GetCustomGroupTitle(index)
		module.ContainerGroups["Bag"][index].label:SetText(GetCustomGroupTitle(index))
		module.ContainerGroups["Bank"][index].label:SetText(GetCustomGroupTitle(index))
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	whileDead = 1,
	showAlert = 1,
	hasEditBox = 1,
	editBoxWidth = 250,
}

function module:RenameCustomGroup(index)
	module.selectGroupIndex = index
	StaticPopup_Show("MER_RENAMECUSTOMGROUP")
end

function module:MoveItemToCustomBag(index)
	local itemID = module.selectItemID
	if index == 0 then
		if module.db.CustomItems[itemID] then
			module.db.CustomItems[itemID] = nil
		end
	else
		module.db.CustomItems[itemID] = index
	end
	module:UpdateAllBags()
end

function module:IsItemInCustomBag()
	local index = self.arg1
	local itemID = module.selectItemID
	return (index == 0 and not module.db.CustomItems[itemID]) or (module.db.CustomItems[itemID] == index)
end

function module:CreateFavouriteButton()
	local menuList = {
		{ text = "", icon = 134400, isTitle = true, notCheckable = true, tCoordLeft = .08, tCoordRight = .92, tCoordTop = .08,
			tCoordBottom = .92 },
		{ text = NONE, arg1 = 0, func = module.MoveItemToCustomBag, checked = module.IsItemInCustomBag },
	}
	for i = 1, 5 do
		tinsert(menuList, {
			text = GetCustomGroupTitle(i), arg1 = i, func = module.MoveItemToCustomBag, checked = module.IsItemInCustomBag,
			hasArrow = true,
			menuList = { { text = BATTLE_PET_RENAME, arg1 = i, func = module.RenameCustomGroup } }
		})
	end
	module.CustomMenu = menuList

	local enabledText = MER.InfoColor .. L["Favourite Mode Enabled"]

	local bu = S.CreateButton(self, 22, 22, true, "Interface\\Common\\friendship-heart")
	bu.Icon:SetPoint("TOPLEFT", -5, 0)
	bu.Icon:SetPoint("BOTTOMRIGHT", 5, -5)
	bu.__turnOff = function()
		S.SetBorderColor(bu.backdrop)
		bu.text = nil
		favouriteEnable = nil
	end
	bu:SetScript("OnClick", function(self)
		module:SelectToggleButton(2)
		favouriteEnable = not favouriteEnable
		if favouriteEnable then
			self.backdrop:SetBackdropBorderColor(1, .8, 0)
			self.text = enabledText
		else
			self.__turnOff()
		end
		self:GetScript("OnEnter")(self)
	end)
	bu:SetScript("OnHide", bu.__turnOff)
	bu.title = L["Favourite Mode"]
	F.AddTooltip(bu, "ANCHOR_TOP")

	toggleButtons[2] = bu

	return bu
end

local function favouriteOnClick(self)
	if not favouriteEnable then return end

	local texture, _, _, quality, _, _, link, _, _, itemID = GetContainerItemInfo(self.bagID, self.slotID)
	if texture and quality > LE_ITEM_QUALITY_POOR then
		ClearCursor()
		module.selectItemID = itemID
		module.CustomMenu[1].text = link
		module.CustomMenu[1].icon = texture
		EasyMenu(module.CustomMenu, F.EasyMenu, self, 0, 0, "MENU")
	end
end

StaticPopupDialogs["MER_WIPE_JUNK_LIST"] = {
	text = L["Reset junklist warning"],
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		wipe(E.global.mui.bags.CustomJunkList)
	end,
	whileDead = 1,
}

local customJunkEnable
function module:CreateJunkButton()
	local enabledText = MER.InfoColor .. L["Junk Mode Enabled"]

	local bu = S.CreateButton(self, 22, 22, true, "Interface\\BUTTONS\\UI-GroupLoot-Coin-Up")
	bu.Icon:SetPoint("TOPLEFT", E.mult, -3)
	bu.Icon:SetPoint("BOTTOMRIGHT", -E.mult, -3)
	bu.__turnOff = function()
		S.SetBorderColor(bu.backdrop)
		bu.text = nil
		customJunkEnable = nil
	end
	bu:SetScript("OnClick", function(self)
		if IsAltKeyDown() and IsControlKeyDown() then
			StaticPopup_Show("MER_WIPE_JUNK_LIST")
			return
		end

		module:SelectToggleButton(3)
		customJunkEnable = not customJunkEnable
		if customJunkEnable then
			self.backdrop:SetBackdropBorderColor(1, .8, 0)
			self.text = enabledText
		else
			bu.__turnOff()
		end
		module:UpdateAllBags()
		self:GetScript("OnEnter")(self)
	end)
	bu:SetScript("OnHide", bu.__turnOff)
	bu.title = L["Custom Junk Mode"]
	F.AddTooltip(bu, "ANCHOR_TOP")

	toggleButtons[3] = bu

	return bu
end

local function customJunkOnClick(self)
	if not customJunkEnable then return end

	local texture, _, _, _, _, _, _, _, _, itemID = GetContainerItemInfo(self.bagID, self.slotID)
	local price = select(11, GetItemInfo(itemID))
	if texture and price > 0 then
		if E.global.mui.bags.CustomJunkList[itemID] then
			E.global.mui.bags.CustomJunkList[itemID] = nil
		else
			E.global.mui.bags.CustomJunkList[itemID] = true
		end
		ClearCursor()
		module:UpdateAllBags()
	end
end

local deleteEnable
function module:CreateDeleteButton()
	local enabledText = MER.InfoColor .. L["Delete Mode Enabled"]

	local bu = S.CreateButton(self, 22, 22, true, "Interface\\Buttons\\UI-GroupLoot-Pass-Up")
	bu.Icon:SetPoint("TOPLEFT", 3, -2)
	bu.Icon:SetPoint("BOTTOMRIGHT", -1, 2)
	bu.__turnOff = function()
		bu.backdrop:SetBackdropBorderColor(0, 0, 0)
		bu.text = nil
		deleteEnable = nil
	end
	bu:SetScript("OnClick", function(self)
		module:SelectToggleButton(4)
		deleteEnable = not deleteEnable
		if deleteEnable then
			self.backdrop:SetBackdropBorderColor(1, .8, 0)
			self.text = enabledText
		else
			bu.__turnOff()
		end
		self:GetScript("OnEnter")(self)
	end)
	bu:SetScript("OnHide", bu.__turnOff)
	bu.title = L["Item Delete Mode"]
	F.AddTooltip(bu, "ANCHOR_TOP")

	toggleButtons[4] = bu

	return bu
end

local function deleteButtonOnClick(self)
	if not deleteEnable then return end

	local texture, _, _, quality = GetContainerItemInfo(self.bagID, self.slotID)
	if IsControlKeyDown() and IsAltKeyDown() and texture and
		(quality < LE_ITEM_QUALITY_RARE or quality == LE_ITEM_QUALITY_HEIRLOOM) then
		PickupContainerItem(self.bagID, self.slotID)
		DeleteCursorItem()
	end
end

function module:ButtonOnClick(btn)
	if btn ~= "LeftButton" then return end
	splitOnClick(self)
	favouriteOnClick(self)
	customJunkOnClick(self)
	deleteButtonOnClick(self)
end

function module:UpdateAllBags()
	if self.Bags and self.Bags:IsShown() then
		self.Bags:BAG_UPDATE()
	end
end

function module:OpenBags()
	OpenAllBags(true)
end

function module:CloseBags()
	CloseAllBags()
end

local questItemCache = {}
function module:IsAcceptableQuestItem(link)
	if not link then return end

	local canAccept = questItemCache[link]
	if not canAccept then
		F.ScanTip:SetOwner(UIParent, "ANCHOR_NONE")
		F.ScanTip:SetHyperlink(link)

		for i = 2, F.ScanTip:NumLines() do
			local line = _G["mUI_ScanTooltipTextLeft" .. i]
			local lineText = line and line:GetText()
			if lineText and strmatch(lineText, ITEM_STARTS_QUEST) then
				canAccept = true
				questItemCache[link] = true
				break
			end
		end
	end

	return canAccept
end

function module:Initialize()
	module.db = E.db.mui.bags
	if not module.db.Enable then
		return
	end

	-- Force Disable ElvUI Bags for now but enable vendor greys
	E.private.bags.enable = false

	-- Settings
	local iconSize = module.db.IconSize
	local showNewItem = module.db.ShowNewItem
	local hasPawn = IsAddOnLoaded("Pawn")

	-- Init
	local Backpack = cargBags:NewImplementation("MER_Backpack")
	Backpack:RegisterBlizzard()
	Backpack:HookScript("OnShow", function() PlaySound(SOUNDKIT.IG_BACKPACK_OPEN) end)
	Backpack:HookScript("OnHide", function() PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE) end)

	module.Bags = Backpack
	cargBags.BagGroups = {}
	cargBags.BagGroups[0] = 0 -- backpack
	cargBags.BagGroups[-1] = 0 -- bank

	local f = {}
	local filters = module:GetFilters()
	local MyContainer = Backpack:GetContainerClass()
	module.ContainerGroups = { ["Bag"] = {}, ["Bank"] = {} }

	local function AddNewContainer(bagType, index, name, filter)
		local newContainer = MyContainer:New(name, { BagType = bagType, Index = index })
		newContainer:SetFilter(filter, true)
		module.ContainerGroups[bagType][index] = newContainer
	end

	function Backpack:OnInit()
		AddNewContainer("Bag", 13, "Junk", filters.bagsJunk)
		for i = 1, 5 do
			AddNewContainer("Bag", i, "BagCustom" .. i, filters["bagCustom" .. i])
		end
		AddNewContainer("Bag", 6, "AmmoItem", filters.bagAmmo)
		AddNewContainer("Bag", 8, "EquipSet", filters.bagEquipSet)
		AddNewContainer("Bag", 7, "Equipment", filters.bagEquipment)
		AddNewContainer("Bag", 9, "BagCollection", filters.bagCollection)
		AddNewContainer("Bag", 11, "Consumable", filters.bagConsumable)
		AddNewContainer("Bag", 10, "BagGoods", filters.bagGoods)
		AddNewContainer("Bag", 12, "BagQuest", filters.bagQuest)

		f.main = MyContainer:New("Bag", { Bags = "bags", BagType = "Bag" })
		f.main.__anchor = { "BOTTOMRIGHT", -4, 50 }
		f.main:SetPoint(unpack(f.main.__anchor))
		f.main:SetFilter(filters.onlyBags, true)
		E:CreateMover(f.main, "MER_BagMover", L["Bags"], nil, nil, nil, "ALL,SOLO,MERATHILISUI", nil, 'mui,modules,bags')

		local keyring = MyContainer:New("Keyring", { BagType = "Bag", Parent = f.main })
		keyring:SetFilter(filters.onlyKeyring, true)
		keyring:SetPoint("TOPRIGHT", f.main, "BOTTOMRIGHT", 0, -5)
		keyring:Hide()
		f.main.keyring = keyring

		for i = 1, 5 do
			AddNewContainer("Bank", i, "BankCustom" .. i, filters["bankCustom" .. i])
		end
		AddNewContainer("Bank", 6, "BankAmmoItem", filters.bankAmmo)
		AddNewContainer("Bank", 8, "BankEquipSet", filters.bankEquipSet)
		AddNewContainer("Bank", 9, "BankLegendary", filters.bankLegendary)
		AddNewContainer("Bank", 7, "BankEquipment", filters.bankEquipment)
		AddNewContainer("Bank", 10, "BankCollection", filters.bankCollection)
		AddNewContainer("Bank", 12, "BankConsumable", filters.bankConsumable)
		AddNewContainer("Bank", 11, "BankGoods", filters.bankGoods)
		AddNewContainer("Bank", 13, "BankQuest", filters.bankQuest)

		f.bank = MyContainer:New("Bank", { Bags = "bank", BagType = "Bank" })
		f.bank.__anchor = { "BOTTOMLEFT", 4, 47 }
		f.bank:SetPoint(unpack(f.bank.__anchor))
		f.bank:SetFilter(filters.onlyBank, true)
		f.bank:Hide()
		E:CreateMover(f.bank, "MER_BankMover", L["Bank"], nil, nil, nil, "ALL,SOLO,MERATHILISUI", nil, 'mui,modules,bags')
	end

	local initBagType
	function Backpack:OnBankOpened()
		BankFrame:Show()
		self:GetContainer("Bank"):Show()

		if not initBagType then
			module:UpdateAllBags() -- Initialize bagType
			module:UpdateBagSize()
			initBagType = true
		end
	end

	function Backpack:OnBankClosed()
		self:GetContainer("Bank"):Hide()
	end

	local MyButton = Backpack:GetItemButtonClass()
	MyButton:Scaffold("Default")

	function MyButton:OnCreate()
		self:SetNormalTexture("")
		self:SetPushedTexture(E.media.normTex)
		self:SetHighlightTexture(E.media.glossTex)
		self:GetHighlightTexture():SetVertexColor(1, 1, 1, .25)
		self:GetHighlightTexture():SetInside()
		self:SetSize(iconSize, iconSize)

		self.Icon:SetInside()
		self.Icon:SetTexCoord(unpack(E.TexCoords))
		self.Count:SetPoint("BOTTOMRIGHT", -1, 2)
		self.Count:FontTemplate(nil, module.db.FontSize)
		self.Cooldown:SetInside()

		self:CreateBackdrop('Transparent')
		self:SetBackdropColor(.3, .3, .3, .3)
		S:CreateGradient(self.backdrop)

		local parentFrame = CreateFrame("Frame", nil, self)
		parentFrame:SetAllPoints()
		parentFrame:SetFrameLevel(5)

		self.Favourite = parentFrame:CreateTexture(nil, "ARTWORK")
		self.Favourite:SetAtlas("collections-icon-favorites")
		self.Favourite:SetSize(30, 30)
		self.Favourite:SetPoint("TOPLEFT", -12, 9)

		self.Quest = self:CreateFontString(nil, "ARTWORK")
		self.Quest:FontTemplate(nil, module.db.FontSize, "OUTLINE")
		self.Quest:SetText("!")
		self.Quest:SetTextColor(1, .8, 0)
		self.Quest:SetPoint("LEFT", 3, 0)

		self.iLvl = self:CreateFontString(nil, "ARTWORK")
		self.iLvl:FontTemplate(nil, module.db.FontSize, "OUTLINE")
		self.iLvl:SetText("")
		self.iLvl:SetPoint("BOTTOMLEFT", 1, 2)

		local flash = self:CreateTexture(nil, "ARTWORK")
		flash:SetTexture('Interface\\Cooldown\\star4')
		flash:SetPoint('TOPLEFT', -15, 15)
		flash:SetPoint('BOTTOMRIGHT', 15, -15)
		flash:SetBlendMode('ADD')
		flash:SetAlpha(0)
		local anim = flash:CreateAnimationGroup()
		anim:SetLooping('REPEAT')
		anim.rota = anim:CreateAnimation('Rotation')
		anim.rota:SetDuration(1)
		anim.rota:SetDegrees(-90)
		anim.fader = anim:CreateAnimation('Alpha')
		anim.fader:SetFromAlpha(0)
		anim.fader:SetToAlpha(0.5)
		anim.fader:SetDuration(0.5)
		anim.fader:SetSmoothing('OUT')
		anim.fader2 = anim:CreateAnimation('Alpha')
		anim.fader2:SetStartDelay(0.5)
		anim.fader2:SetFromAlpha(0.5)
		anim.fader2:SetToAlpha(0)
		anim.fader2:SetDuration(1.2)
		anim.fader2:SetSmoothing('OUT')
		self:HookScript('OnHide', function()
			if anim:IsPlaying() then
				anim:Stop()
			end
		end)
		self.anim = anim
		self.ShowNewItems = showNewItem

		self:HookScript("OnClick", module.ButtonOnClick)
	end

	function MyButton:ItemOnEnter()
		if self.ShowNewItems then
			if self.anim:IsPlaying() then
				self.anim:Stop()
			end
		end
	end

	local bagGroupColor = {
		[-1] = { .67, .83, .45, .25 },
		[0] = { .3, .3, .3, .3 },
		[1] = { .53, .53, .93, .25 },
		[2] = { 0, .5, 0, .25 },
		[3] = { .8, 0, .8, .25 },
		[4] = { 1, .8, 0, .25 },
		[5] = { 0, .8, .8, .25 },
		[6] = { .5, .4, 0, .25 },
		[7] = { .8, .5, .5, .25 },
		[8] = { .8, .8, .8, .25 },
		[9] = { .4, .6, 1, .25 },
		[10] = { .8, 0, 0, .25 },
	}

	local function isItemNeedsLevel(item)
		return item.link and item.quality > 1 and module:IsItemHasLevel(item)
	end

	local function UpdatePawnArrow(self, item)
		if not hasPawn then return end
		if not PawnIsContainerItemAnUpgrade then return end
		if self.UpgradeIcon then
			self.UpgradeIcon:SetShown(PawnIsContainerItemAnUpgrade(item.bagID, item.slotID))
		end
	end

	function MyButton:OnUpdate(item)
		if self.JunkIcon then
			if (MerchantFrame:IsShown() or customJunkEnable) and
				(item.quality == LE_ITEM_QUALITY_POOR or E.global.mui.bags.CustomJunkList[item.id]) and item.hasPrice then
				self.JunkIcon:Show()
			else
				self.JunkIcon:Hide()
			end
		end

		if module.db.CustomItems[item.id] and not module.db.ItemFilter then
			self.Favourite:Show()
		else
			self.Favourite:Hide()
		end

		self.iLvl:SetText("")
		if module.db.BagsiLvl and isItemNeedsLevel(item) then
			local level = item.level -- ilvl for keystone and battlepet
			if level and level > module.db.iLvlToShow then
				local color = E.QualityColors[item.quality]
				self.iLvl:SetText(level)
				self.iLvl:SetTextColor(color.r, color.g, color.b)
			end
		end

		if self.ShowNewItems then
			if C_NewItems_IsNewItem(item.bagID, item.slotID) then
				self.anim:Play()
			else
				if self.anim:IsPlaying() then
					self.anim:Stop()
				end
			end
		end

		if module.db.SpecialBagsColor then
			local bagType = module.BagsType[item.bagID]
			local color = bagGroupColor[bagType] or bagGroupColor[0]
			self:SetBackdropColor(unpack(color))
		else
			self:SetBackdropColor(.3, .3, .3, .3)
		end

		-- Hide empty tooltip
		if GameTooltip:GetOwner() == self then
			if item.texture then
				self:UpdateTooltip()
			else
				GameTooltip:Hide()
			end
		end

		-- Support Pawn
		UpdatePawnArrow(self, item)
	end

	function MyButton:OnUpdateQuest(item)
		if item.isQuestItem then
			self.backdrop:SetBackdropBorderColor(.8, .8, 0)
		elseif item.quality and item.quality > -1 then
			local color = E.QualityColors[item.quality]
			self.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			self.backdrop:SetBackdropBorderColor(0, 0, 0)
		end

		self.Quest:SetShown(item.isQuestItem and module:IsAcceptableQuestItem(item.link))
	end

	function module:UpdateAllAnchors()
		module:UpdateBagsAnchor(f.main, module.ContainerGroups["Bag"])
		module:UpdateBankAnchor(f.bank, module.ContainerGroups["Bank"])
	end

	function module:GetContainerColumns(bagType)
		if bagType == "Bag" then
			return module.db.BagsWidth
		elseif bagType == "Bank" then
			return module.db.BankWidth
		end
	end

	function MyContainer:OnContentsChanged(gridOnly)
		self:SortButtons("bagSlot")

		local columns = module:GetContainerColumns(self.Settings.BagType)
		local offset = 38
		local spacing = module.db.IconSpacing or 3
		local xOffset = 5
		local yOffset = -offset + xOffset
		local _, height = self:LayoutButtons("grid", columns, spacing, xOffset, yOffset)
		local width = columns * (iconSize + spacing) - spacing
		if self.freeSlot then
			if module.db.GatherEmpty then
				local numSlots = #self.buttons + 1
				local row = ceil(numSlots / columns)
				local col = numSlots % columns
				if col == 0 then col = columns end
				local xPos = (col - 1) * (iconSize + spacing)
				local yPos = -1 * (row - 1) * (iconSize + spacing)

				self.freeSlot:ClearAllPoints()
				self.freeSlot:SetPoint("TOPLEFT", self, "TOPLEFT", xPos + xOffset, yPos + yOffset)
				self.freeSlot:Show()

				if height < 0 then
					height = iconSize
				elseif col == 1 then
					height = height + iconSize + spacing
				end
			else
				self.freeSlot:Hide()
			end
		end
		self:SetSize(width + xOffset * 2, height + offset)

		if not gridOnly then
			module:UpdateAllAnchors()
		end
	end

	local function SetFrameMovable(f, v)
		f:SetMovable(true)
		f:SetUserPlaced(true)
		f:RegisterForClicks("LeftButtonDown", "LeftButtonUp", "RightButtonDown", "RightButtonUp")
		if v then
			f:SetScript("OnMouseDown", function()
				f:ClearAllPoints()
				f:StartMoving()
			end)
			f:SetScript("OnMouseUp", f.StopMovingOrSizing)
		else
			f:SetScript("OnMouseDown", nil)
			f:SetScript("OnMouseUp", nil)
		end
	end

	function MyContainer:OnCreate(name, settings)
		self.Settings = settings
		self:SetFrameStrata("HIGH")
		self:SetClampedToScreen(true)
		self:CreateBackdrop('Transparent')
		self.backdrop:Styling()
		S:CreateBackdropShadow(self)

		self.iconSize = iconSize
		module.CreateFreeSlots(self)

		local label
		if strmatch(name, "AmmoItem$") then
			label = E.myclass == "HUNTER" and INVTYPE_AMMO or SOUL_SHARDS
		elseif strmatch(name, "Equipment$") then
			label = BAG_FILTER_EQUIPMENT
		elseif strmatch(name, "EquipSet$") then
			label = L["Equipment Set"]
		elseif name == "BankLegendary" then
			label = LOOT_JOURNAL_LEGENDARIES
		elseif strmatch(name, "Consumable$") then
			label = BAG_FILTER_CONSUMABLES
		elseif name == "Junk" then
			label = BAG_FILTER_JUNK
		elseif strmatch(name, "Collection") then
			label = COLLECTIONS
		elseif name == "Keyring" then
			label = KEYRING
		elseif strmatch(name, "Goods") then
			label = AUCTION_CATEGORY_TRADE_GOODS
		elseif strmatch(name, "Quest") then
			label = QUESTS_LABEL
		elseif strmatch(name, "Custom%d") then
			label = GetCustomGroupTitle(settings.Index)
		end
		if label then
			self.label = self:CreateFontString(nil, "ARTWORK")
			self.label:FontTemplate(nil, 13, "OUTLINE")
			self.label:SetText(label)
			self.label:SetPoint("TOPLEFT", 5, -8)
			self.label:SetTextColor(F.r, F.g, F.b)
			self.label:SetShadowOffset(-2, 2)
			return
		end

		module.CreateInfoFrame(self)

		local buttons = {}
		buttons[1] = module.CreateCloseButton(self, f)
		if name == "Bag" then
			module.CreateBagBar(self, settings, NUM_BAG_SLOTS)
			SetFrameMovable(self, true)
			buttons[2] = module.CreateSortButton(self, name)
			buttons[3] = module.CreateBagToggle(self)
			buttons[4] = module.CreateKeyToggle(self)
			buttons[5] = module.CreateSplitButton(self)
			buttons[6] = module.CreateFavouriteButton(self)
			buttons[7] = module.CreateJunkButton(self)
			buttons[8] = module.CreateDeleteButton(self)
		elseif name == "Bank" then
			module.CreateBagBar(self, settings, NUM_BANKBAGSLOTS)
			SetFrameMovable(self, true)
			buttons[2] = module.CreateBagToggle(self)
			buttons[3] = module.CreateSortButton(self, name)
		end

		for i = 1, #buttons do
			local bu = buttons[i]
			if not bu then break end
			if i == 1 then
				bu:SetPoint("TOPRIGHT", -5, -5)
			else
				bu:SetPoint("RIGHT", buttons[i - 1], "LEFT", -3, 0)
			end
		end
		self.widgetButtons = buttons

		if name == "Bag" then module.CreateCollapseArrow(self) end
	end

	local function updateBagSize(button)
		button:SetSize(iconSize, iconSize)
		button.Count:FontTemplate(nil, module.db.FontSize)
		button.iLvl:FontTemplate(nil, module.db.FontSize)
	end

	function module:UpdateBagSize()
		iconSize = module.db.IconSize
		for _, container in pairs(Backpack.contByName) do
			container:ApplyToButtons(updateBagSize)
			if container.freeSlot then
				container.freeSlot:SetSize(iconSize, iconSize)
				container.freeSlot.tag:FontTemplate(nil, module.db.FontSize + 2)
			end
			if container.BagBar then
				for _, bagButton in pairs(container.BagBar.buttons) do
					bagButton:SetSize(iconSize, iconSize)
				end
				container.BagBar:UpdateAnchor()
			end
			container:OnContentsChanged(true)
		end
	end

	local BagButton = Backpack:GetClass("BagButton", true, "BagButton")
	function BagButton:OnCreate()
		self:SetNormalTexture(MER.Media.Textures.emptyTex)
		self:SetPushedTexture(MER.Media.Textures.emptyTex)
		self:SetHighlightTexture(MER.Media.Textures.emptyTex)

		self:SetSize(iconSize, iconSize)
		self:CreateBackdrop('Transparent')
		self.Icon:SetInside()
		self.Icon:SetTexCoord(unpack(E.TexCoords))
	end

	function BagButton:OnUpdate()
		local id = GetInventoryItemID("player", (self.GetInventorySlot and self:GetInventorySlot()) or self.invID)
		if not id then return end
		local _, _, quality, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(id)
		if not quality or quality == 1 then quality = 0 end
		local color = E.QualityColors[quality]
		if not self.hidden and not self.notBought then
			self.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			self.backdrop:SetBackdropBorderColor(0, 0, 0)
		end

		if classID == LE_ITEM_CLASS_CONTAINER then
			cargBags.BagGroups[self.bagID] = subClassID or 0
		elseif classID == LE_ITEM_CLASS_QUIVER then
			cargBags.BagGroups[self.bagID] = -1
		else
			cargBags.BagGroups[self.bagID] = 0
		end
	end

	-- Sort order
	SetSortBagsRightToLeft(module.db.BagSortMode == 1)
	SetInsertItemsLeftToRight(false)

	-- Init
	ToggleAllBags()
	ToggleAllBags()
	module.initComplete = true

	MER:RegisterEvent("TRADE_SHOW", module.OpenBags)
	-- MER:RegisterEvent("TRADE_CLOSED", module.CloseBags)
	MER:RegisterEvent("AUCTION_HOUSE_SHOW", module.OpenBags)
	MER:RegisterEvent("AUCTION_HOUSE_CLOSED", module.CloseBags)

	-- Fixes
	BankFrame.GetRight = function() return f.bank:GetRight() end
	BankFrameItemButton_Update = E.noop

	-- Shift key alert
	local function onUpdate(self, elapsed)
		if IsShiftKeyDown() then
			self.elapsed = (self.elapsed or 0) + elapsed
			if self.elapsed > 5 then
				UIErrorsFrame:AddMessage(MER.InfoColor .. L["StupidShiftKey"])
				self.elapsed = 0
			end
		end
	end

	local shiftUpdater = CreateFrame("Frame", nil, f.main)
	shiftUpdater:SetScript("OnUpdate", onUpdate)

	_G.BankFrame:SetScale(0.0001)
	_G.BankFrame:SetAlpha(0)
	_G.BankFrame:SetScript('OnShow', nil)
	_G.BankFrame:ClearAllPoints()
	_G.BankFrame:Point('TOPLEFT')
end

MER:RegisterModule(module:GetName())
