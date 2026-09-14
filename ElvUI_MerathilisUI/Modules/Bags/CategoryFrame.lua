local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories
local B = E:GetModule("Bags")
local S = E:GetModule("Skins")
local WS = W:GetModule("Skins")

local _G = _G
local ipairs, pairs = ipairs, pairs
local tinsert, wipe = tinsert, wipe
local floor, ceil = math.floor, math.ceil
local format = format
local IsShiftKeyDown = IsShiftKeyDown
local IsModifiedClick = IsModifiedClick
local HandleModifiedItemClick = HandleModifiedItemClick

local CreateFrame = CreateFrame
local GetMoney = GetMoney

local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
local C_Container_GetContainerItemInfo = C_Container.GetContainerItemInfo
local C_Container_GetContainerItemCooldown = C_Container.GetContainerItemCooldown
local C_Container_SetItemSearch = C_Container.SetItemSearch
local C_Container_PickupContainerItem = C_Container.PickupContainerItem
local C_NewItems_IsNewItem = C_NewItems.IsNewItem
local C_NewItems_RemoveNewItem = C_NewItems.RemoveNewItem
local C_Item_GetItemInfoInstant = C_Item.GetItemInfoInstant
local C_Item_GetDetailedItemLevelInfo = C_Item.GetDetailedItemLevelInfo
local C_Item_GetItemInfo = C_Item.GetItemInfo

local BAG_IDS = { 0, 1, 2, 3, 4 }
if module.ReagentContainer and module.ReagentContainer < math.huge then
	tinsert(BAG_IDS, module.ReagentContainer)
end

local FRAME_NAME = "MER_BagCategoriesFrame"
local SLOT_NAME_PREFIX = "MER_BagCategoriesSlot"
local HEADER_PADDING = 6

-- Same restriction ElvUI's own item level display uses: only equippable gear
-- (Armor covers trinkets/rings/necks too) above Common quality.
local ITEMCLASS_ARMOR = Enum.ItemClass.Armor
local ITEMCLASS_WEAPON = Enum.ItemClass.Weapon
local ITEMQUALITY_COMMON = Enum.ItemQuality.Common

local BIND_TEXT = {
	[Enum.ItemBind.OnAcquire or 1] = L["BoP"],
	[Enum.ItemBind.OnEquip or 2] = L["BoE"],
	[Enum.ItemBind.OnUse or 3] = L["BoU"],
	[Enum.ItemBind.ToBnetAccount or 8] = L["BoA"],
}

-- Small inward nudge so slot-overlay text (Count/ItemLevel/BindType) doesn't
-- sit flush against the icon border, keyed by the anchor point it's set to.
local ANCHOR_OFFSETS = {
	TOPLEFT = { 2, -2 },
	TOP = { 0, -2 },
	TOPRIGHT = { -2, -2 },
	LEFT = { 2, 0 },
	CENTER = { 0, 0 },
	RIGHT = { -2, 0 },
	BOTTOMLEFT = { 2, 2 },
	BOTTOM = { 0, 2 },
	BOTTOMRIGHT = { -2, 2 },
}

local function PositionSlotText(fs, point)
	local offset = ANCHOR_OFFSETS[point] or ANCHOR_OFFSETS.BOTTOMRIGHT
	fs:ClearAllPoints()
	fs:Point(point, offset[1], offset[2])
end

local slotPool = {}
local headerPool = {}
local sidebarPool = {}

-- ElvUI's own Container_OnHide -> BagFrameHidden clears every item's "new"
-- flag (NewItemGlowSlotSwitch -> C_NewItems.RemoveNewItem) whenever
-- B.BagFrame hides - which we do on every single open of our own frame, so
-- Recent Items would always come up empty. Snapshot which items are new
-- right before that happens and fall back to it in CollectItems.
local newItemSnapshot = {}

local function SnapshotNewItems()
	wipe(newItemSnapshot)

	for _, bagID in ipairs(BAG_IDS) do
		local numSlots = C_Container_GetContainerNumSlots(bagID)
		for slotID = 1, numSlots do
			if C_NewItems_IsNewItem(bagID, slotID) then
				newItemSnapshot[bagID * 1000 + slotID] = true
			end
		end
	end
end

local function HideElvUIBagFrame()
	if B.BagFrame and B.BagFrame:IsShown() then
		SnapshotNewItems()
		B.BagFrame:Hide()
	end
end

-- Reskins a scrollbar to a thin, track-less thumb: HandleScrollBar's own
-- thumbX narrows the thumb via an inset (same technique as the options-page
-- scrollbar, Options/Widgets/ScrollBar.lua), and the separate track backdrop
-- it creates behind the thumb gets hidden outright instead of just inset.
local function SkinScrollBar(scrollbar)
	local ok = pcall(S.HandleScrollBar, S, scrollbar, nil, 4)
	if ok and scrollbar.backdrop then
		scrollbar.backdrop:Hide()
	end
end

local function SetCategoryIcon(tex, cat)
	if not tex or not cat then
		return
	end

	if cat.isAtlas then
		tex:SetAtlas(cat.icon)
		return
	end

	tex:SetTexture(cat.icon)

	-- Raw item icons (numeric fileID, or an "Interface\Icons\..." path) carry
	-- Blizzard's built-in border in their UVs and need cropping; ElvUI's own
	-- pre-cropped media textures already fill the full UV space.
	local icon = cat.icon
	local isRawItemIcon = type(icon) == "number" or (type(icon) == "string" and icon:find([[Icons\]], 1, true))
	if isRawItemIcon then
		tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	else
		tex:SetTexCoord(0, 1, 0, 1)
	end
end

-------------------------------------------------------------------------------
--  Item slot buttons
-------------------------------------------------------------------------------
-- Right-click "use" needs real secure type/item attributes on a
-- SecureActionButtonTemplate button to avoid ADDON_ACTION_FORBIDDEN (see
-- UpdateSlotVisual); a plain overlay on top to carry Left/Middle separately
-- didn't work (an unregistered click type doesn't fall through to the frame
-- below, it's just swallowed), so everything lives on one button. PreClick
-- handles our own Left/Middle logic; RightButton falls through untouched to
-- the button's native OnClick, which dispatches the secure type/item
-- attributes (needs the RightButtonDown click phase registered too, see
-- CreateSlotButton).
local function Slot_OnClick(self, mouseButton)
	if mouseButton == "LeftButton" then
		if IsModifiedClick() then
			HandleModifiedItemClick(self.itemLink)
		elseif self.BagID and self.SlotID then
			C_Container_PickupContainerItem(self.BagID, self.SlotID)
		end
	elseif mouseButton == "MiddleButton" then
		if IsShiftKeyDown() then
			module:OpenAssignMenu(self)
		else
			module:TogglePinned(self.itemID)
			module:RefreshCategoryFrame()
		end
	end
end

local function Slot_OnDrag(self)
	if self.BagID and self.SlotID then
		C_Container_PickupContainerItem(self.BagID, self.SlotID)
	end
end

local function Slot_OnEnter(self)
	if module.frame then
		module.frame:SetFrameLevel(module.frame:GetFrameLevel())
	end

	if self.BagID and self.SlotID and not GameTooltip:IsForbidden() then
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetBagItem(self.BagID, self.SlotID)
		GameTooltip:Show()
	end
end

local function Slot_OnLeave()
	if not GameTooltip:IsForbidden() then
		GameTooltip:Hide()
	end
end

local function CreateSlotButton(index)
	local btn = CreateFrame(
		"ItemButton",
		SLOT_NAME_PREFIX .. index,
		module.contentChild,
		"ContainerFrameItemButtonTemplate,SecureActionButtonTemplate"
	)

	local ok = pcall(btn.SetTemplate, btn, nil, true)
	if not ok then
		pcall(btn.SetTemplate, btn)
	end

	-- Blizzard's native button chrome (the slot-frame art behind the icon);
	-- we draw our own flat border via SetTemplate instead, same as ElvUI.
	btn:SetNormalTexture(E.ClearTexture)

	-- Blizzard's own native border square; we draw quality color via
	-- SetTemplate/SetItemButtonQuality ourselves, same as ElvUI's own bags.
	if btn.IconBorder then
		btn.IconBorder:SetAlpha(0)
	end

	-- Inset the icon so it doesn't cover our own border, and crop it the
	-- way ElvUI's own bags do instead of Blizzard's default icon framing.
	if btn.icon then
		btn.icon:SetInside()
		btn.icon:SetTexCoords()
	end

	-- Defaults to shown until something hides it; we filter non-matching
	-- items out of the list entirely instead of dimming them in place.
	if btn.searchOverlay then
		btn.searchOverlay:Hide()
	end

	btn.itemLevel = btn:CreateFontString(nil, "OVERLAY")
	btn.bindType = btn:CreateFontString(nil, "OVERLAY")

	if btn.BattlepayItemTexture then
		btn.BattlepayItemTexture:Hide()
	end

	-- The mixin resolves bag/slot from a one-frame-per-bag hierarchy we don't
	-- have (all pooled buttons share one parent), so its own OnUpdate and
	-- event handling end up working from wrong data; strip those. OnEnter/
	-- OnLeave get fully replaced (not hooked) since the mixin's own tooltip
	-- logic fights ours the same way. OnClick is left untouched (native) so
	-- its secure type/item dispatch keeps working; PreClick adds our own
	-- Left/Middle handling alongside it without disturbing RightButton.
	btn:SetScript("OnUpdate", nil)
	btn:UnregisterAllEvents()
	btn:SetScript("OnMouseDown", nil)
	btn:SetScript("OnMouseUp", nil)

	-- RightButtonDown too: the secure type/item dispatch needs the down-click
	-- phase registered, not just Up.
	btn:RegisterForClicks("AnyUp", "RightButtonDown")
	btn:SetScript("PreClick", Slot_OnClick)

	btn:RegisterForDrag("LeftButton")
	btn:SetScript("OnDragStart", Slot_OnDrag)
	btn:SetScript("OnReceiveDrag", Slot_OnDrag)

	btn:SetScript("OnEnter", Slot_OnEnter)
	btn:SetScript("OnLeave", Slot_OnLeave)
	btn.UpdateTooltip = Slot_OnEnter

	return btn
end

local function AcquireSlot(index)
	local btn = slotPool[index]
	if not btn then
		btn = CreateSlotButton(index)
		slotPool[index] = btn
	end

	btn:Show()
	return btn
end

local function ReleaseSlotsFrom(startIndex)
	for i = startIndex, #slotPool do
		slotPool[i]:Hide()
	end
end

local function UpdateSlotCooldown(btn, bagID, slotID)
	local cd = btn.Cooldown
	if not cd then
		return
	end

	local start, duration, enabled = C_Container_GetContainerItemCooldown(bagID, slotID)
	if duration and duration > 0 and enabled == 1 then
		cd:SetCooldown(start, duration)
	else
		cd:Hide()
	end
end

local function UpdateSlotVisual(btn, entry)
	btn.BagID = entry.bagID
	btn.SlotID = entry.slotID
	btn:SetID(entry.slotID)
	btn.itemID = entry.itemID
	btn.itemLink = entry.itemLink

	SetItemButtonTexture(btn, entry.icon)
	SetItemButtonCount(btn, entry.count)
	SetItemButtonDesaturated(btn, entry.isLocked)

	local countFont = module.db.itemCountFont
	if btn.Count then
		btn.Count:FontTemplate(countFont.name, countFont.size, countFont.style)
		PositionSlotText(btn.Count, countFont.position)
	end

	-- Right-click "use/equip" via the secure type/item attributes instead of
	-- calling UseContainerItem from Lua (protected, throws
	-- ADDON_ACTION_FORBIDDEN). SetAttribute itself is combat-protected on
	-- secure frames, so skip refreshing it mid-combat; the previous item's
	-- attributes simply stay in place until the next safe refresh.
	if not InCombatLockdown() then
		btn:SetAttribute("type", "item")
		btn:SetAttribute("item", entry.itemLink)
	end

	-- Blizzard's SetItemButtonQuality paints Blizzard's own (hidden) IconBorder;
	-- we draw the quality color on our own ElvUI-templated backdrop instead,
	-- same as ElvUI's own bags (B:UpdateSlotColors).
	local r, g, b = E:GetItemQualityColor(entry.quality)
	btn:SetBackdropBorderColor(r, g, b)
	if E.ForceBorderColor then
		E:ForceBorderColor(btn, r, g, b)
	end

	local levelFont = module.db.itemLevel.font
	btn.itemLevel:FontTemplate(levelFont.name, levelFont.size, levelFont.style)
	PositionSlotText(btn.itemLevel, levelFont.position)
	if entry.itemLevel then
		btn.itemLevel:SetText(entry.itemLevel)
		btn.itemLevel:SetTextColor(r, g, b)
	else
		btn.itemLevel:SetText("")
	end

	local infoFont = module.db.itemInfo.font
	btn.bindType:FontTemplate(infoFont.name, infoFont.size, infoFont.style)
	PositionSlotText(btn.bindType, infoFont.position)
	if entry.bindText then
		btn.bindType:SetText(entry.bindText)
		btn.bindType:SetTextColor(r, g, b)
	else
		btn.bindType:SetText("")
	end

	-- Blizzard's own highlighting for Scrap, Rune Carving, Upgrade Items, etc.
	-- (ContainerFrameItemButtonMixin); never gets called on its own since this
	-- button isn't part of Blizzard's tracked container frames.
	if btn.UpdateItemContextMatching then
		btn:UpdateItemContextMatching()
	end

	UpdateSlotCooldown(btn, entry.bagID, entry.slotID)
end

-------------------------------------------------------------------------------
--  Category headers
-------------------------------------------------------------------------------
local function CreateHeader(index)
	local header = CreateFrame("Frame", nil, module.contentChild)
	header:SetHeight(22)

	header.icon = header:CreateTexture(nil, "ARTWORK")
	header.icon:SetSize(16, 16)
	header.icon:Point("LEFT", 2, 0)

	header.text = header:CreateFontString(nil, "OVERLAY")
	header.text:FontTemplate()
	header.text:Point("LEFT", header.icon, "RIGHT", 6, 0)

	header.clearButton = CreateFrame("Button", nil, header)
	header.clearButton:Size(14)
	header.clearButton:Point("RIGHT", -2, 0)
	pcall(header.clearButton.SetTemplate, header.clearButton)
	header.clearButton.tex = header.clearButton:CreateTexture(nil, "OVERLAY")
	header.clearButton.tex:SetAllPoints()
	header.clearButton.tex:SetTexture(E.Media.Textures.Close)
	header.clearButton:Hide()

	headerPool[index] = header
	return header
end

local function AcquireHeader(index)
	local header = headerPool[index]
	if not header then
		header = CreateHeader(index)
	end

	header:Show()
	return header
end

local function ReleaseHeadersFrom(startIndex)
	for i = startIndex, #headerPool do
		headerPool[i]:Hide()
	end
end

-------------------------------------------------------------------------------
--  Sidebar rows
-------------------------------------------------------------------------------
local function Sidebar_OnClick(self, mouseButton)
	if mouseButton == "LeftButton" then
		module:ScrollToCategory(self.catKey)
	elseif mouseButton == "RightButton" and self.isUser then
		module:OpenCategoryContextMenu(self)
	end
end

local function CreateSidebarRow(index)
	local row = CreateFrame("Button", nil, module.sidebarChild)
	row:SetHeight(24)
	row:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	row:SetScript("OnClick", Sidebar_OnClick)
	row:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]], "ADD")

	-- Alternating-row background, same technique/look as the Armory panel's
	-- alternating stat rows (Core.lua:UpdateCharacterStat): a class-colored
	-- horizontal gradient fading from transparent to a low alpha.
	row.gradient = row:CreateTexture(nil, "BACKGROUND")
	row.gradient:SetAllPoints()
	row.gradient:SetTexture(E.media.blankTex)
	local cc = E.myClassColor
	F.Color.SetGradientRGB(row.gradient, "HORIZONTAL", cc.r, cc.g, cc.b, 0, cc.r, cc.g, cc.b, 0.32)

	row.icon = row:CreateTexture(nil, "ARTWORK")
	row.icon:SetSize(16, 16)
	row.icon:Point("LEFT", 4, 0)

	row.text = row:CreateFontString(nil, "OVERLAY")
	row.text:FontTemplate()
	row.text:Point("LEFT", row.icon, "RIGHT", 6, 0)
	row.text:Point("RIGHT", -26, 0)
	row.text:SetJustifyH("LEFT")

	row.count = row:CreateFontString(nil, "OVERLAY")
	row.count:FontTemplate()
	row.count:Point("RIGHT", -4, 0)

	sidebarPool[index] = row
	return row
end

local function AcquireSidebarRow(index)
	local row = sidebarPool[index]
	if not row then
		row = CreateSidebarRow(index)
	end

	row:Show()
	return row
end

local function ReleaseSidebarRowsFrom(startIndex)
	for i = startIndex, #sidebarPool do
		sidebarPool[i]:Hide()
	end
end

-------------------------------------------------------------------------------
--  Frame construction
-------------------------------------------------------------------------------
function module:ConstructFrame()
	if module.frame then
		return module.frame
	end

	local db = module.db

	local f = CreateFrame("Button", FRAME_NAME, E.UIParent)
	f:SetFrameStrata("HIGH")
	f:SetClampedToScreen(true)
	f:Size(db.width, db.height)
	f:Point("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -4, 48)
	pcall(f.SetTemplate, f, "Transparent")
	WS:CreateShadow(f)
	f:Hide()
	f:SetScript("OnHide", function()
		module:OnFrameHidden()
	end)
	module.frame = f

	E:CreateMover(
		f,
		"MER_BagCategoriesMover",
		MER.Title .. L["Categorized Bags"],
		nil,
		nil,
		nil,
		"ALL,SOLO,MERATHILISUI",
		nil,
		"mui,modules,bags,categorizedBags"
	)

	f.closeButton = CreateFrame("Button", FRAME_NAME .. "CloseButton", f, "UIPanelCloseButton")
	f.closeButton:Point("TOPRIGHT", 2, 2)
	f.closeButton:SetScript("OnClick", function()
		module:HideCategoryFrame()
	end)
	pcall(S.HandleCloseButton, S, f.closeButton)

	-- Small ElvUI-style icon buttons (same textures/skinning as ElvUI's own
	-- bag frame title row). Anchored TOP-to-TOP directly off `f` and each
	-- other (not off the close button, which sits in its own corner at a
	-- different size/height) so this whole row shares one exact y with the
	-- search box below.
	local function CreateTitleButton(name, texture, tooltipText, onClick)
		local btn = CreateFrame("Button", FRAME_NAME .. name, f)
		btn:Size(20)
		pcall(btn.SetTemplate, btn)
		pcall(btn.StyleButton, btn, nil, true)

		btn.tex = btn:CreateTexture(nil, "OVERLAY")
		btn.tex:SetInside()
		btn.tex:SetTexture(texture)

		if onClick then
			btn:SetScript("OnClick", onClick)
		end

		btn:SetScript("OnEnter", function(self)
			if GameTooltip:IsForbidden() then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			if type(tooltipText) == "function" then
				tooltipText()
			else
				GameTooltip:AddLine(tooltipText, 1, 1, 1)
			end
			GameTooltip:Show()
		end)
		btn:SetScript("OnLeave", GameTooltip_Hide)

		return btn
	end

	-- Blizzard's SortBags() already merges partial stacks as part of sorting;
	-- we don't have ElvUI's own separate animated Stack/Compress algorithm,
	-- so both buttons call the same native sort for now.
	f.sortButton = CreateTitleButton("SortButton", E.Media.Textures.PetBroom, L["Sort Bags"], function()
		C_Container.SortBags()
	end)
	f.sortButton:Point("TOPRIGHT", f, "TOPRIGHT", -40, -8)

	f.stackButton = CreateTitleButton("StackButton", E.Media.Textures.Planks, L["Stack Items In Bags"], function()
		C_Container.SortBags()
	end)
	f.stackButton:Point("TOPRIGHT", f.sortButton, "TOPLEFT", -2, 0)

	f.helpButton = CreateTitleButton("HelpButton", E.Media.Textures.Help, function()
		GameTooltip:AddDoubleLine(L["Left Click:"], L["Pick up / move item"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Right Click:"], L["Use / equip item"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Middle Click:"], L["Pin / unpin item"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Shift + Middle Click:"], L["Assign to Category"], 1, 1, 1)
	end)
	f.helpButton:Point("TOPRIGHT", f.stackButton, "TOPLEFT", -2, 0)

	f.searchBox = CreateFrame("EditBox", FRAME_NAME .. "SearchBox", f, "SearchBoxTemplate")
	f.searchBox:Point("TOPLEFT", 10, -8)
	f.searchBox:Point("TOPRIGHT", f.helpButton, "TOPLEFT", -6, 0)
	f.searchBox:Height(20)
	f.searchBox:HookScript("OnTextChanged", function(self)
		module.searchText = self:GetText() or ""
		module:RefreshCategoryFrame()
	end)
	pcall(S.HandleEditBox, S, f.searchBox)

	-- Sidebar
	f.sidebar = CreateFrame("Frame", nil, f)
	f.sidebar:Point("TOPLEFT", f, "TOPLEFT", 8, -34)
	f.sidebar:Point("BOTTOMLEFT", f, "BOTTOMLEFT", 8, 60)
	f.sidebar:Width(db.sidebarWidth)
	pcall(f.sidebar.SetTemplate, f.sidebar, "Transparent")

	f.sidebarScroll = CreateFrame("ScrollFrame", FRAME_NAME .. "SidebarScroll", f.sidebar, "UIPanelScrollFrameTemplate")
	f.sidebarScroll:Point("TOPLEFT", 4, -4)
	f.sidebarScroll:Point("BOTTOMRIGHT", -24, 4)
	SkinScrollBar(f.sidebarScroll.ScrollBar)

	f.sidebarChild = CreateFrame("Frame", nil, f.sidebarScroll)
	f.sidebarChild:Point("TOPLEFT")
	f.sidebarChild:Width(db.sidebarWidth - 30)
	f.sidebarChild:Height(1)
	f.sidebarScroll:SetScrollChild(f.sidebarChild)
	module.sidebarChild = f.sidebarChild

	f.addCategoryButton = CreateFrame("Button", FRAME_NAME .. "AddCategory", f.sidebar, "UIPanelButtonTemplate")
	f.addCategoryButton:Point("TOP", f.sidebar, "BOTTOM", 0, -2)
	f.addCategoryButton:Size(db.sidebarWidth, 20)
	f.addCategoryButton:SetText(L["Add Category"])
	f.addCategoryButton:SetScript("OnClick", function()
		module:PromptAddCategory()
	end)
	pcall(S.HandleButton, S, f.addCategoryButton)

	-- Main content
	f.mainScroll = CreateFrame("ScrollFrame", FRAME_NAME .. "MainScroll", f, "UIPanelScrollFrameTemplate")
	f.mainScroll:Point("TOPLEFT", f.sidebar, "TOPRIGHT", 8, 0)
	f.mainScroll:Point("BOTTOMRIGHT", f, "BOTTOMRIGHT", -28, 36)
	SkinScrollBar(f.mainScroll.ScrollBar)

	f.contentChild = CreateFrame("Frame", nil, f.mainScroll)
	f.contentChild:Point("TOPLEFT")
	f.contentChild:Width(1)
	f.contentChild:Height(1)
	f.mainScroll:SetScrollChild(f.contentChild)
	module.contentChild = f.contentChild

	-- Footer
	f.footer = CreateFrame("Frame", nil, f)
	f.footer:Point("BOTTOMLEFT", 8, 8)
	f.footer:Point("BOTTOMRIGHT", -8, 8)
	f.footer:Height(20)

	f.footer.goldText = f.footer:CreateFontString(nil, "OVERLAY")
	f.footer.goldText:FontTemplate()
	f.footer.goldText:Point("LEFT", 4, 0)

	-- Manually apply Style
	F.CreateStyle(f)

	f:RegisterEvent("PLAYER_MONEY")
	f:SetScript("OnEvent", function(_, event)
		if event == "PLAYER_MONEY" then
			module:UpdateFooter()
		end
	end)

	return f
end

function module:UpdateFooter()
	local f = module.frame
	if not f then
		return
	end

	f.footer.goldText:SetText(E:FormatMoney(GetMoney(), "SMART"))
end

-------------------------------------------------------------------------------
--  Data collection + render
-------------------------------------------------------------------------------
local categoryItemsScratch = {}

-- Same restriction ElvUI's own item level display uses: only equippable gear
-- (Armor covers trinkets/rings/necks too) above Common quality, and only
-- items that don't have a level yet resolved (avoids the extra tooltip-scan
-- work GetDetailedItemLevelInfo does for everything else in the bags).
local function GetDisplayItemLevel(itemLink, quality)
	if not itemLink or not quality or quality <= ITEMQUALITY_COMMON then
		return nil
	end

	local _, _, _, _, _, classID = C_Item_GetItemInfoInstant(itemLink)
	if classID ~= ITEMCLASS_ARMOR and classID ~= ITEMCLASS_WEAPON then
		return nil
	end

	local iLvl = C_Item_GetDetailedItemLevelInfo(itemLink)
	return iLvl and iLvl > 0 and iLvl or nil
end

-- Only informative for items that aren't bound yet (BoP items are already
-- bound the instant they're looted, so there's nothing left to show).
local function GetBindText(itemLink, isBound)
	if not itemLink or isBound then
		return nil
	end

	local _, _, _, _, _, _, _, _, _, _, _, _, _, bindType = C_Item_GetItemInfo(itemLink)
	return bindType and BIND_TEXT[bindType]
end

local function CollectItems()
	for k in pairs(categoryItemsScratch) do
		wipe(categoryItemsScratch[k])
	end

	local searching = module.searchText and module.searchText ~= ""
	C_Container_SetItemSearch(searching and module.searchText or "")

	for _, bagID in ipairs(BAG_IDS) do
		local numSlots = C_Container_GetContainerNumSlots(bagID)

		for slotID = 1, numSlots do
			local info = C_Container_GetContainerItemInfo(bagID, slotID)

			if info and info.iconFileID and not (searching and info.isFiltered) then
				local key =
					module:ClassifyItem(bagID, slotID, info.itemID, info.hyperlink, info.quality, info.hasNoValue)
				if key then
					categoryItemsScratch[key] = categoryItemsScratch[key] or {}

					tinsert(categoryItemsScratch[key], {
						bagID = bagID,
						slotID = slotID,
						itemID = info.itemID,
						itemLink = info.hyperlink,
						icon = info.iconFileID,
						count = info.stackCount,
						quality = info.quality,
						isLocked = info.isLocked,
						isNew = C_NewItems_IsNewItem(bagID, slotID) or newItemSnapshot[bagID * 1000 + slotID] or false,
						itemLevel = module.db.itemLevel.enable and GetDisplayItemLevel(info.hyperlink, info.quality)
							or nil,
						bindText = module.db.itemInfo.enable and GetBindText(info.hyperlink, info.isBound) or nil,
					})
				end
			end
		end
	end

	return categoryItemsScratch
end

local function BuildSections()
	local db = module.db
	local itemsByCategory = CollectItems()
	local categories = module:GetCategories()
	local sections = {}

	if db.showPinned then
		local pinned = {}
		for _, cat in ipairs(categories) do
			for _, entry in ipairs(itemsByCategory[cat.key] or {}) do
				if module:IsItemPinned(entry.itemID) then
					tinsert(pinned, entry)
				end
			end
		end

		if #pinned > 0 or not db.hideEmptyCategories then
			tinsert(sections, {
				key = module.PinnedCategory.key,
				name = module.PinnedCategory.name,
				icon = module.PinnedCategory.icon,
				isAtlas = true,
				items = pinned,
			})
		end
	end

	if db.showRecent then
		local recent = {}
		for _, cat in ipairs(categories) do
			for _, entry in ipairs(itemsByCategory[cat.key] or {}) do
				if entry.isNew then
					tinsert(recent, entry)
				end
			end
		end

		if #recent > 0 or not db.hideEmptyCategories then
			tinsert(sections, {
				key = module.RecentCategory.key,
				name = module.RecentCategory.name,
				icon = module.RecentCategory.icon,
				isAtlas = true,
				items = recent,
				showClear = #recent > 0,
			})
		end
	end

	for _, cat in ipairs(categories) do
		local items = itemsByCategory[cat.key] or {}
		if #items > 0 or not db.hideEmptyCategories or cat.isUser then
			tinsert(sections, { key = cat.key, name = cat.name, icon = cat.icon, isAtlas = cat.isAtlas, items = items })
		end
	end

	return sections
end

function module:ScrollToCategory(key)
	local offset = module.categoryOffsets and module.categoryOffsets[key]
	if offset and module.frame then
		module.frame.mainScroll:SetVerticalScroll(offset)
	end
end

function module:RefreshCategoryFrame()
	if not module.frame or not module.frame:IsShown() then
		return
	end

	local db = module.db
	local sections = BuildSections()

	module.categoryOffsets = {}

	local contentWidth = db.width - db.sidebarWidth - 44
	local columns = floor((contentWidth + db.itemSpacingH) / (db.itemSize + db.itemSpacingH))
	if columns < 1 then
		columns = 1
	end

	module.contentChild:Width(contentWidth)

	local slotIndex, headerIndex, sidebarIndex = 0, 0, 0
	local y = 0

	for _, section in ipairs(sections) do
		module.categoryOffsets[section.key] = y

		headerIndex = headerIndex + 1
		local header = AcquireHeader(headerIndex)
		header:SetHeight(db.headerHeight)
		header:ClearAllPoints()
		header:Point("TOPLEFT", module.contentChild, "TOPLEFT", 0, -y)
		header:Point("TOPRIGHT", module.contentChild, "TOPRIGHT", 0, -y)
		header.text:SetText(format("%s (%d)", section.name, #section.items))
		SetCategoryIcon(header.icon, section)

		if section.showClear then
			header.clearButton:Show()
			header.clearButton:SetScript("OnClick", function()
				for _, entry in ipairs(section.items) do
					C_NewItems_RemoveNewItem(entry.bagID, entry.slotID)
				end
				module:RefreshCategoryFrame()
			end)
		else
			header.clearButton:Hide()
		end

		y = y + header:GetHeight() + HEADER_PADDING

		sidebarIndex = sidebarIndex + 1
		local row = AcquireSidebarRow(sidebarIndex)
		row:SetHeight(db.sidebarRowHeight)
		row:ClearAllPoints()
		row:Point("TOPLEFT", module.sidebarChild, "TOPLEFT", 0, -(sidebarIndex - 1) * db.sidebarRowHeight)
		row:Point("TOPRIGHT", module.sidebarChild, "TOPRIGHT", 0, -(sidebarIndex - 1) * db.sidebarRowHeight)
		row.catKey = section.key
		row.isUser = section.key:find("^USER_") and true or false
		row.text:SetText(section.name)
		row.count:SetText(#section.items)
		SetCategoryIcon(row.icon, section)
		row.gradient:SetShown(db.alternatingRowBackground and sidebarIndex % 2 == 0)

		if #section.items > 0 then
			local col = 0
			local rowStartY = y

			for _, entry in ipairs(section.items) do
				slotIndex = slotIndex + 1
				local btn = AcquireSlot(slotIndex)
				UpdateSlotVisual(btn, entry)

				btn:ClearAllPoints()
				btn:Size(db.itemSize)
				btn:Point("TOPLEFT", module.contentChild, "TOPLEFT", col * (db.itemSize + db.itemSpacingH), -rowStartY)

				col = col + 1
				if col >= columns then
					col = 0
					rowStartY = rowStartY + db.itemSize + db.itemSpacingV
				end
			end

			local rows = ceil(#section.items / columns)
			y = y + rows * (db.itemSize + db.itemSpacingV)
		end

		y = y + db.sectionSpacing
	end

	ReleaseSlotsFrom(slotIndex + 1)
	ReleaseHeadersFrom(headerIndex + 1)
	ReleaseSidebarRowsFrom(sidebarIndex + 1)

	module.sidebarChild:Height(math.max(1, sidebarIndex * db.sidebarRowHeight))
	module.contentChild:Height(math.max(1, y))

	module:UpdateFooter()
end

-------------------------------------------------------------------------------
--  Add / rename / delete categories
-------------------------------------------------------------------------------
_G.StaticPopupDialogs = _G.StaticPopupDialogs or {}

_G.StaticPopupDialogs["MER_BAGCATEGORIES_ADD"] = {
	text = L["Enter a name for the new category:"],
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = true,
	maxLetters = 30,
	OnAccept = function(self)
		local name = self.EditBox and self.EditBox:GetText()
		module:AddUserCategory(name)
		module:RefreshCategoryFrame()
	end,
	EditBoxOnEnterPressed = function(self)
		local parent = self:GetParent()
		module:AddUserCategory(parent.EditBox:GetText())
		module:RefreshCategoryFrame()
		parent:Hide()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

-- Lets a plain spell/item/currency/achievement ID resolve to that thing's
-- icon (same lookup order as Modules/Misc/IconSearch.lua), so users can set a
-- category icon without knowing a raw texture fileID; anything else is taken
-- as a literal texture path/fileID.
local function ResolveIconInput(input)
	if not input or input == "" then
		return nil
	end

	local id = tonumber(input)
	if not id then
		return input
	end

	local spell = C_Spell.GetSpellTexture(id)
	if spell then
		return spell
	end

	local item = C_Item.GetItemIconByID(id)
	if item then
		return item
	end

	local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(id)
	if currencyInfo and currencyInfo.iconFileID then
		return currencyInfo.iconFileID
	end

	local achievementIcon = select(10, GetAchievementInfo(id))
	if achievementIcon then
		return achievementIcon
	end

	return id
end

_G.StaticPopupDialogs["MER_BAGCATEGORIES_ICON"] = {
	text = L["Enter a spell/item/currency ID, or a texture path/ID, for the category icon:"],
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = true,
	maxLetters = 256,
	OnShow = function(self, data)
		if data and data.key then
			local cat = module:FindCategory(data.key)
			if cat and self.EditBox then
				self.EditBox:SetText(tostring(cat.icon or ""))
			end
		end
	end,
	OnAccept = function(self, data)
		if data and data.key and self.EditBox then
			local icon = ResolveIconInput(self.EditBox:GetText())
			if icon then
				module:SetUserCategoryIcon(data.key, icon)
				module:RefreshCategoryFrame()
			end
		end
	end,
	EditBoxOnEnterPressed = function(self)
		local parent = self:GetParent()
		if parent.data and parent.data.key then
			local icon = ResolveIconInput(parent.EditBox:GetText())
			if icon then
				module:SetUserCategoryIcon(parent.data.key, icon)
				module:RefreshCategoryFrame()
			end
		end
		parent:Hide()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

_G.StaticPopupDialogs["MER_BAGCATEGORIES_RENAME"] = {
	text = L["Enter a new name:"],
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = true,
	maxLetters = 30,
	OnShow = function(self, data)
		if data and data.key then
			local cat = module:FindCategory(data.key)
			if cat and self.EditBox then
				self.EditBox:SetText(cat.name)
			end
		end
	end,
	OnAccept = function(self, data)
		if data and data.key then
			module:RenameCategory(data.key, self.EditBox and self.EditBox:GetText())
			module:RefreshCategoryFrame()
		end
	end,
	EditBoxOnEnterPressed = function(self)
		local parent = self:GetParent()
		if parent.data and parent.data.key then
			module:RenameCategory(parent.data.key, parent.EditBox:GetText())
			module:RefreshCategoryFrame()
		end
		parent:Hide()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

function module:PromptAddCategory()
	StaticPopup_Show("MER_BAGCATEGORIES_ADD")
end

function module:OpenCategoryContextMenu(row)
	if not _G.MenuUtil or not _G.MenuUtil.CreateContextMenu then
		return
	end

	local key = row.catKey
	_G.MenuUtil.CreateContextMenu(row, function(_, rootDescription)
		rootDescription:CreateButton(L["Rename"], function()
			StaticPopup_Show("MER_BAGCATEGORIES_RENAME", nil, nil, { key = key })
		end)

		rootDescription:CreateButton(L["Change Icon"], function()
			StaticPopup_Show("MER_BAGCATEGORIES_ICON", nil, nil, { key = key })
		end)

		rootDescription:CreateButton(L["Delete"], function()
			module:RemoveUserCategory(key)
			module:RefreshCategoryFrame()
		end)
	end)
end

function module:OpenAssignMenu(slot)
	if not _G.MenuUtil or not _G.MenuUtil.CreateContextMenu then
		return
	end
	if not slot.itemID then
		return
	end

	local itemID = slot.itemID
	_G.MenuUtil.CreateContextMenu(slot, function(_, rootDescription)
		rootDescription:CreateTitle(L["Assign to Category"])

		for _, cat in ipairs(module:GetCategories()) do
			if not cat.isReagentBag then
				rootDescription:CreateButton(cat.name, function()
					module:AssignItemToCategory(itemID, cat.key)
					module:RefreshCategoryFrame()
				end)
			end
		end

		local db = module.db
		if db.itemAssignments and db.itemAssignments[itemID] then
			rootDescription:CreateButton(L["Clear Assignment"], function()
				module:ClearItemAssignment(itemID)
				module:RefreshCategoryFrame()
			end)
		end
	end)
end

-------------------------------------------------------------------------------
--  Show / hide / toggle + bag toggle hooks
-------------------------------------------------------------------------------
-- Our slot buttons are SecureActionButtonTemplate (needed for right-click
-- "use" without ADDON_ACTION_FORBIDDEN, see UpdateSlotVisual), which makes
-- Show()/Hide() on any frame containing them combat-protected too - calling
-- either from insecure code throws ADDON_ACTION_BLOCKED. Guarded here so
-- every caller (hooks, the close button, the mover) is covered; whatever
-- shown/hidden state we're in when combat starts just stays frozen.
function module:ShowCategoryFrame()
	if InCombatLockdown() then
		return
	end

	module:ConstructFrame()
	HideElvUIBagFrame()

	module.frame:Show()
	module:RegisterBagEvents()
	module:RefreshCategoryFrame()
	PlaySound(SOUNDKIT.IG_BACKPACK_OPEN or 862)
end

function module:HideCategoryFrame()
	if InCombatLockdown() then
		return
	end

	if module.frame and module.frame:IsShown() then
		module.frame:Hide()
	end
end

function module:OnFrameHidden()
	module:UnregisterBagEvents()
	C_Container_SetItemSearch("")

	for i = 1, NUM_BAG_FRAMES or 4 do
		CloseBag(i)
	end
	CloseBackpack()

	PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE or 863)
end

function module:ToggleCategoryFrame()
	if module.frame and module.frame:IsShown() then
		module:HideCategoryFrame()
	else
		module:ShowCategoryFrame()
	end
end

-- Combat-guarded here too (see ShowCategoryFrame): without it we'd still
-- hide B.BagFrame below and then no-op on our own frame, leaving no bag
-- frame visible at all until combat ends.
function module:ToggleAllBags()
	if InCombatLockdown() then
		return
	end

	HideElvUIBagFrame()
	module:ToggleCategoryFrame()
end

function module:ToggleBackpack()
	module:ToggleAllBags()
end

function module:OpenAllBags(frame)
	-- Only take over if ElvUI's own auto-toggle logic actually decided to open
	-- (it already ran by the time this hook fires); this keeps its per-context
	-- (mail/vendor) auto-open settings authoritative instead of duplicating them.
	if InCombatLockdown() or not frame or not (B.BagFrame and B.BagFrame:IsShown()) then
		return
	end

	HideElvUIBagFrame()
	module:ShowCategoryFrame()
end

function module:CloseAllBags()
	if InCombatLockdown() then
		return
	end

	module:HideCategoryFrame()
end

local eventFrame = CreateFrame("Frame")
local BAG_REFRESH_EVENTS = { "BAG_UPDATE", "BAG_UPDATE_DELAYED", "ITEM_LOCK_CHANGED" }

eventFrame:SetScript("OnEvent", function()
	module:RefreshCategoryFrame()
end)

function module:RegisterBagEvents()
	for _, event in ipairs(BAG_REFRESH_EVENTS) do
		eventFrame:RegisterEvent(event)
	end
end

function module:UnregisterBagEvents()
	eventFrame:UnregisterAllEvents()
end

-------------------------------------------------------------------------------
--  Lifecycle
-------------------------------------------------------------------------------
function module:Initialize()
	local db = F.GetDBFromPath("mui.bags.categorizedBags") or E.db.mui.bags.categorizedBags
	module.db = db

	if not db.enable then
		return
	end

	module.searchText = ""

	module:SecureHook("ToggleAllBags")
	module:SecureHook("ToggleBackpack")
	module:SecureHook("OpenAllBags")
	module:SecureHook("CloseAllBags")
end

function module:ProfileUpdate()
	local db = F.GetDBFromPath("mui.bags.categorizedBags") or E.db.mui.bags.categorizedBags
	module.db = db
	module:InvalidateCategoryCache()

	if module.frame and module.frame:IsShown() then
		module:RefreshCategoryFrame()
	end
end

MER:RegisterModule(module:GetName())
