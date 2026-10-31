local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories
local S = E:GetModule("Skins")

-------------------------------------------------------------------------------
--  Offline Bank viewer (data from Offline.lua). A character button in the title
--  of the bag and bank window opens a panel over the whole window body, with
--  tabs for that character's bags, bank, equipment and mail, the warband and
--  guild bank, and a search over everyone. The window's own search box filters
--  it too. The panel is opaque and sits above the live content, which keeps
--  running underneath untouched.
--
--  The item buttons are display only and never touch a real slot, so all of
--  this works in combat: hover for tooltips, shift-click links, ctrl-click
--  previews.
-------------------------------------------------------------------------------

local _G = _G
local ipairs, next, pairs, pcall, select, tonumber, type = ipairs, next, pairs, pcall, select, tonumber, type
local ceil, floor, max = math.ceil, math.floor, math.max
local format, sort, strlower, strtrim, tinsert, wipe = format, sort, strlower, strtrim, tinsert, wipe

local C_Timer = C_Timer
local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GameTooltip_Hide = GameTooltip_Hide
local HandleModifiedItemClick = HandleModifiedItemClick
local SecondsToTime = SecondsToTime
local StaticPopup_Show = StaticPopup_Show
local time = time

local C_Item_GetItemInfo = C_Item.GetItemInfo
local C_Item_GetItemInfoInstant = C_Item.GetItemInfoInstant
local C_Item_GetItemQualityColor = C_Item.GetItemQualityColor
local C_Item_RequestLoadItemDataByID = C_Item.RequestLoadItemDataByID

local Offline = module.Offline

local BAR_HEIGHT, FOOTER_HEIGHT, HEADER_HEIGHT = 24, 22, 20
local LEVEL_ABOVE_WINDOW = 60
local REPAINT_DELAY = 0.2
local ALL_REPAINT_DELAY = 0.5 -- a search over everyone can wait for hundreds of items
local ALL_MIN_QUERY = 2
local ALL_MAX_RESULTS = 300
local PET_CAGE_ICON = 134400

local TABS = {
	{ kind = "bags", label = L["Bags"] },
	{ kind = "bank", label = L["Bank"] },
	{ kind = "equip", label = L["Equipped"] },
	{ kind = "mail", label = L["Mail"] },
	{ kind = "warband", label = L["Warband Bank"] },
	{ kind = "guild", label = L["Guild Bank"] },
	{ kind = "all", label = L["All Characters"] },
}
-- Grouped by physical tab like the live bank, the rest by category
local BY_TAB = { bank = true, warband = true, guild = true }

local views = {} -- [window] = view
local panelCount = 0
local Paint

local function ShownKey(v)
	return v.key or Offline.CurrentKey()
end

local function Query()
	return strlower(strtrim(module.searchText or ""))
end

-- How old a save is, "3 days ago" style
local function Age(saved)
	if type(saved) ~= "number" then
		return nil
	end
	local seconds = max(time() - saved, 0)
	if seconds < 60 then
		return L["just now"]
	end
	return format(L["%s ago"], SecondsToTime(seconds, false, false, 1))
end

local function ClassColored(name, class)
	local color = class and E:ClassColor(class)
	return color and format("|cff%02x%02x%02x%s|r", color.r * 255, color.g * 255, color.b * 255, name) or name
end

-------------------------------------------------------------------------------
--  Data
-------------------------------------------------------------------------------
-- The list behind the view, when it was saved and the gold that goes with it
local function Source(v)
	if v.kind == "warband" then
		local warband = Offline.Warband()
		return warband.tabs, warband.time, warband.money
	end

	local c = Offline.Char(ShownKey(v))
	if not c then
		return nil
	end
	if v.kind == "guild" then
		local guild = Offline.Guild(c.guild)
		return guild and guild.tabs, guild and guild.time
	end
	local gold = _G.ElvDB and _G.ElvDB.gold and _G.ElvDB.gold[c.realm] and _G.ElvDB.gold[c.realm][c.name]
	return c[v.kind], c[v.kind .. "Time"], gold
end

-- Item IDs asked for and not answered yet, each repaints the open views when it
-- lands. An ID the game cannot load is given up on, so nothing waits on it.
local requested, failed = {}, {}

-- Name, quality and icon of a saved string, pets and keystones are whole links
local function Info(s, id)
	local name, quality, icon, _
	if s:sub(1, 5) == "item:" then
		name, _, quality, _, _, _, _, _, _, icon = C_Item_GetItemInfo(s)
	else
		name = s:match("%[(.-)%]")
		_, _, quality, _, _, _, _, _, _, icon = C_Item_GetItemInfo(id)
		local species, _, breed = s:match("|Hbattlepet:(%d+):(%d+):(%d+)")
		if species and C_PetJournal then
			local _, petIcon = C_PetJournal.GetPetInfoBySpeciesID(tonumber(species))
			icon, quality = petIcon or icon, tonumber(breed) or quality
		end
	end

	if quality == nil and id and not failed[id] and not requested[id] then
		requested[id] = true
		C_Item_RequestLoadItemDataByID(id)
	end
	return name, quality, icon
end

local function MakeItem(s, count)
	local id = Offline.ItemID(s)
	local name, quality, icon = Info(s, id)
	name = name or ""
	return {
		str = s,
		id = id,
		name = name,
		lower = strlower(name),
		quality = quality or 1,
		icon = icon or (id and select(5, C_Item_GetItemInfoInstant(id))),
		count = count,
	}
end

local function SetCategoryGroup(item, bagID, catIndex)
	local key = module:ClassifyItem(bagID, nil, item.id, item.str, item.quality)
	local entry = key and catIndex[key]
	item.groupOrder = entry and entry.order or 999
	item.groupName = entry and entry.name or L["Miscellaneous"]
end

local function CategoryIndex()
	local catIndex = {}
	for i, cat in ipairs(module:GetCategories()) do
		catIndex[cat.key] = { order = i, name = cat.name }
	end
	return catIndex
end

local function BuildListItems(v, list)
	local items, used, total = {}, 0, 0
	local byTab = BY_TAB[v.kind]
	local catIndex = not byTab and CategoryIndex()
	for pos, t in pairs(list) do
		if t then
			total = total + (t.size or 0)
			local bagID = v.kind == "bags" and pos == #module.BAG_IDS + 1 and module.ReagentContainer or nil
			for slot, s in pairs(t.items) do
				used = used + 1
				local item = MakeItem(s, t.counts[slot] or 1)
				if byTab then
					item.groupOrder = pos
					item.groupName = (t.name and t.name ~= "") and t.name or format(L["Tab %d"], pos)
				else
					SetCategoryGroup(item, bagID, catIndex)
				end
				items[#items + 1] = item
			end
		end
	end
	return items, used, total
end

-- One entry per item ID with the sum of everyone, the tooltip says who owns it
local function BuildAllItems()
	local byID, items = {}, {}
	Offline.EachContainer(function(t)
		for slot, s in pairs(t.items) do
			local id = Offline.ItemID(s)
			if id then
				local item = byID[id]
				if not item then
					item = MakeItem(s, 0)
					byID[id] = item
					items[#items + 1] = item
				end
				item.count = item.count + (t.counts[slot] or 1)
			end
		end
	end)

	local catIndex = CategoryIndex()
	for _, item in ipairs(items) do
		SetCategoryGroup(item, nil, catIndex)
	end
	return items, #items, 0
end

local function SortItems(a, b)
	if a.groupOrder ~= b.groupOrder then
		return a.groupOrder < b.groupOrder
	end
	if a.quality ~= b.quality then
		return a.quality > b.quality
	end
	if a.name ~= b.name then
		return a.name < b.name
	end
	return a.str < b.str
end

-------------------------------------------------------------------------------
--  Item buttons, display only
-------------------------------------------------------------------------------
local function Slot_OnEnter(self)
	local item = self.item
	if not item or GameTooltip:IsForbidden() then
		return
	end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	if not pcall(GameTooltip.SetHyperlink, GameTooltip, item.str) then
		GameTooltip:AddLine(item.name, 1, 1, 1)
	end
	if self.view.kind == "all" and not Offline.CountsEnabled() and item.id then
		Offline.AddCountLines(GameTooltip, item.id)
	end
	GameTooltip:Show()
end

local function Slot_OnClick(self)
	local item = self.item
	if not item then
		return
	end
	-- Items saved as strings get their full link back from the item cache
	local link = item.str:find("|H", 1, true) and item.str or select(2, C_Item_GetItemInfo(item.str))
	if link then
		HandleModifiedItemClick(link)
	end
end

local function AcquireSlot(v, index)
	local slot = v.slots[index]
	if slot then
		return slot
	end

	slot = CreateFrame("Button", nil, v.child)
	-- ignoreUpdates: ElvUI's backdrop sweep would wipe the quality border
	slot:SetTemplate(nil, nil, true)
	slot:StyleButton()
	slot.view = v

	slot.icon = slot:CreateTexture(nil, "ARTWORK")
	slot.icon:SetInside()
	slot.icon:SetTexCoords()

	slot.countText = slot:CreateFontString(nil, "OVERLAY")
	slot.countText:FontTemplate(nil, 11, "OUTLINE")
	slot.countText:Point("BOTTOMRIGHT", -2, 2)

	slot.levelText = slot:CreateFontString(nil, "OVERLAY")
	slot.levelText:FontTemplate(nil, 11, "OUTLINE")
	slot.levelText:Point("TOPLEFT", 2, -2)

	slot:SetScript("OnEnter", Slot_OnEnter)
	slot:SetScript("OnLeave", GameTooltip_Hide)
	slot:SetScript("OnClick", Slot_OnClick)

	v.slots[index] = slot
	return slot
end

local function PaintSlot(slot, item, size)
	slot.item = item
	slot:Size(size)
	slot.icon:SetTexture(item.icon or PET_CAGE_ICON)
	slot.countText:SetText(item.count > 1 and item.count or "")
	local level = module.db.itemLevel.enable and module.GetDisplayItemLevel(item.str, item.quality)
	slot.levelText:SetText(level or "")
	if item.quality > 1 then
		local r, g, b = C_Item_GetItemQualityColor(item.quality)
		slot:SetBackdropBorderColor(r, g, b)
	else
		slot:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end
	slot:Show()
end

local function AcquireHeader(v, index)
	local header = v.headers[index]
	if header then
		return header
	end

	header = CreateFrame("Frame", nil, v.child)
	header:Height(HEADER_HEIGHT)
	header.text = header:CreateFontString(nil, "OVERLAY")
	header.text:FontTemplate(nil, 12)
	header.text:Point("LEFT", 0, 0)
	header.text:SetTextColor(0.8, 0.8, 0.8)
	header.line = header:CreateTexture(nil, "ARTWORK")
	header.line:Height(1)
	header.line:Point("LEFT", header.text, "RIGHT", 6, 0)
	header.line:Point("RIGHT", 0, 0)
	header.line:SetColorTexture(1, 1, 1, 0.15)

	v.headers[index] = header
	return header
end

-------------------------------------------------------------------------------
--  Panel
-------------------------------------------------------------------------------
local function PaintTabs(v)
	local cc = E.myClassColor
	for _, tab in ipairs(v.tabs) do
		local selected = tab.kind == v.kind
		tab.text:SetTextColor(selected and 1 or 0.6, selected and 1 or 0.6, selected and 1 or 0.6)
		tab.line:SetColorTexture(cc.r, cc.g, cc.b, 1)
		tab.line:SetShown(selected)
	end
end

local function SetKind(v, kind)
	v.kind = kind
	v.dirty = true
	v.scroll:SetVerticalScroll(0)
	Paint(v)
end

local function CreateTab(v, def)
	local tab = CreateFrame("Button", nil, v.bar)
	tab:Height(BAR_HEIGHT)
	tab.kind = def.kind

	tab.text = tab:CreateFontString(nil, "OVERLAY")
	tab.text:FontTemplate(nil, 12)
	tab.text:Point("CENTER")
	tab.text:SetText(def.label)
	tab:Width(tab.text:GetStringWidth() + 12)

	tab.line = tab:CreateTexture(nil, "OVERLAY")
	tab.line:Point("BOTTOMLEFT", 4, 0)
	tab.line:Point("BOTTOMRIGHT", -4, 0)
	tab.line:Height(2)

	tab:SetScript("OnClick", function()
		SetKind(v, def.kind)
	end)
	tab:SetScript("OnEnter", function(self)
		if v.kind ~= self.kind then
			self.text:SetTextColor(1, 1, 1)
		end
	end)
	tab:SetScript("OnLeave", function()
		PaintTabs(v)
	end)
	return tab
end

local function Close(v)
	if not v.open then
		return
	end
	v.open, v.key = false, nil
	v.panel:Hide()
	if v.frame == module.bankFrame then
		module:RefreshBankCategoryFrame()
	else
		module:RefreshCategoryFrame()
	end
end

local function BuildPanel(v)
	if v.panel then
		return
	end

	local f = v.frame
	panelCount = panelCount + 1

	local panel = CreateFrame("Frame", nil, f)
	panel:Point("TOPLEFT", f, "TOPLEFT", 1, -31)
	panel:Point("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 1)
	panel:SetFrameLevel(f:GetFrameLevel() + LEVEL_ABOVE_WINDOW)
	panel:EnableMouse(true)
	panel:Hide()
	v.panel = panel

	local background = panel:CreateTexture(nil, "BACKGROUND")
	background:SetAllPoints()
	local r, g, b = unpack(E.media.backdropcolor)
	background:SetColorTexture(r, g, b, 1)

	v.bar = CreateFrame("Frame", nil, panel)
	v.bar:Point("TOPLEFT", 0, 0)
	v.bar:Point("TOPRIGHT", 0, 0)
	v.bar:Height(BAR_HEIGHT)

	local separator = v.bar:CreateTexture(nil, "ARTWORK")
	separator:Height(1)
	separator:Point("BOTTOMLEFT", 0, 0)
	separator:Point("BOTTOMRIGHT", 0, 0)
	separator:SetColorTexture(1, 1, 1, 0.15)

	local previous
	for _, def in ipairs(TABS) do
		local tab = CreateTab(v, def)
		if previous then
			tab:Point("LEFT", previous, "RIGHT", 0, 0)
		else
			tab:Point("LEFT", v.bar, "LEFT", 4, 0)
		end
		tinsert(v.tabs, tab)
		previous = tab
	end

	local back = CreateFrame("Button", nil, v.bar, "UIPanelCloseButton")
	back:Point("RIGHT", 2, 0)
	S:HandleCloseButton(back)
	back:SetScript("OnClick", function()
		Close(v)
	end)
	back:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:AddLine(L["Back to the live view"], 1, 1, 1)
		GameTooltip:Show()
	end)
	back:SetScript("OnLeave", GameTooltip_Hide)

	v.scroll = CreateFrame("ScrollFrame", "MER_OfflineBankScroll" .. panelCount, panel, "UIPanelScrollFrameTemplate")
	v.scroll:Point("TOPLEFT", v.bar, "BOTTOMLEFT", 8, -6)
	v.scroll:Point("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -26, FOOTER_HEIGHT)
	module.SkinScrollBar(v.scroll.ScrollBar)

	v.child = CreateFrame("Frame", nil, v.scroll)
	v.child:Size(1, 1)
	v.scroll:SetScrollChild(v.child)

	v.emptyText = v.scroll:CreateFontString(nil, "OVERLAY")
	v.emptyText:FontTemplate(nil, 13)
	v.emptyText:SetTextColor(0.6, 0.6, 0.6)
	v.emptyText:Point("LEFT", 16, 0)
	v.emptyText:Point("RIGHT", -16, 0)

	v.info = panel:CreateFontString(nil, "OVERLAY")
	v.info:FontTemplate(nil, 11)
	v.info:SetTextColor(0.6, 0.6, 0.6)
	v.info:Point("BOTTOMLEFT", 8, 6)

	v.gold = panel:CreateFontString(nil, "OVERLAY")
	v.gold:FontTemplate(nil, 11)
	v.gold:Point("BOTTOMRIGHT", -8, 6)
end

local function PaintTitle(v, used, total)
	local f = v.frame
	local c = Offline.Char(ShownKey(v))
	local name = ClassColored(c and c.name or E.myname, c and c.class or E.myclass)
	f.titleText:SetText(format(v.isBank and L["%s's Bank"] or L["%s's Inventory"], name))
	if v.kind == "all" then
		f.titleCountText:SetText("")
	elseif used then
		module.SetTitleCount(f.titleCountText, used, total)
	end
end

local function EmptyMessage(v, list, query)
	if v.kind == "all" then
		if #query < ALL_MIN_QUERY then
			return L["Use the search box to look through all characters."]
		end
	elseif not list then
		if v.kind == "warband" then
			return L["The warband bank has not been saved yet. Open it once at a banker."]
		elseif v.kind == "guild" then
			return L["No guild bank saved for this character. Open it once."]
		elseif v.kind == "bags" or v.kind == "equip" then
			return L["Not saved yet. Log in on this character once."]
		end
		return L["Not saved yet. Visit it once on this character."]
	end
	return L["No items found."]
end

local filtered = {}
local function FilterItems(v, query)
	wipe(filtered)
	if v.kind == "all" and #query < ALL_MIN_QUERY then
		return filtered
	end
	for _, item in ipairs(v.items) do
		if query == "" or item.lower:find(query, 1, true) then
			filtered[#filtered + 1] = item
			if v.kind == "all" and #filtered >= ALL_MAX_RESULTS then
				break
			end
		end
	end
	sort(filtered, SortItems)
	return filtered
end

function Paint(v)
	if not (v.open and v.panel) then
		return
	end

	local list, saved, gold = nil, nil, nil
	if v.kind ~= "all" then
		list, saved, gold = Source(v)
	end

	if v.dirty then
		v.dirty = false
		if v.kind == "all" then
			v.items, v.used, v.total = BuildAllItems()
		elseif list then
			v.items, v.used, v.total = BuildListItems(v, list)
		else
			v.items, v.used, v.total = {}, 0, 0
		end
	end

	PaintTabs(v)

	local query = Query()
	local items = FilterItems(v, query)
	local db = module.db
	local size, spacingX, spacingY = db.itemSize, db.itemSpacingH, db.itemSpacingV
	local width = v.scroll:GetWidth()
	local columns = max(floor((width + spacingX) / (size + spacingX)), 1)
	v.child:Width(max(width, 1))

	local y, slotIndex, headerIndex = 0, 0, 0
	local i, n = 1, #items
	while i <= n do
		local group = items[i]
		local first = i
		while i <= n and items[i].groupOrder == group.groupOrder do
			i = i + 1
		end
		local count = i - first

		headerIndex = headerIndex + 1
		local header = AcquireHeader(v, headerIndex)
		header:ClearAllPoints()
		header:Point("TOPLEFT", v.child, "TOPLEFT", 0, y)
		header:Point("TOPRIGHT", v.child, "TOPRIGHT", 0, y)
		header.text:SetText(format("%s |cff999999(%d)|r", group.groupName, count))
		header:Show()
		y = y - HEADER_HEIGHT - 2

		for offset = 0, count - 1 do
			slotIndex = slotIndex + 1
			local slot = AcquireSlot(v, slotIndex)
			slot:ClearAllPoints()
			slot:Point(
				"TOPLEFT",
				v.child,
				"TOPLEFT",
				(offset % columns) * (size + spacingX),
				y - floor(offset / columns) * (size + spacingY)
			)
			PaintSlot(slot, items[first + offset], size)
		end
		y = y - ceil(count / columns) * (size + spacingY) - 8
	end

	for index = slotIndex + 1, #v.slots do
		v.slots[index].item = nil
		v.slots[index]:Hide()
	end
	for index = headerIndex + 1, #v.headers do
		v.headers[index]:Hide()
	end
	v.child:Height(max(-y, 1))

	v.emptyText:SetShown(n == 0)
	if n == 0 then
		v.emptyText:SetText(EmptyMessage(v, list, query))
	end

	local age = Age(saved)
	v.info:SetText(age and format(L["Saved %s"], age) or "")
	v.gold:SetText(type(gold) == "number" and E:FormatMoney(gold, "SMART") or "")
	PaintTitle(v, v.kind ~= "all" and v.used or nil, v.total)
end

local function RepaintSoon(v)
	if v.repaintQueued then
		return
	end
	v.repaintQueued = true
	C_Timer.After(v.kind == "all" and ALL_REPAINT_DELAY or REPAINT_DELAY, function()
		v.repaintQueued = false
		if v.open and v.frame:IsShown() then
			Paint(v)
		end
	end)
end

local function MarkOpenViews()
	for _, v in pairs(views) do
		if v.open then
			v.dirty = true
			RepaintSoon(v)
		end
	end
end

-- Only the IDs a view asked for repaint it
local itemEvents = CreateFrame("Frame")
itemEvents:SetScript("OnEvent", function(_, _, id, success)
	if requested[id] then
		requested[id] = nil
		if not success then
			failed[id] = true
		end
		MarkOpenViews()
	end
end)

local function SyncItemEvents()
	for _, v in pairs(views) do
		if v.open then
			itemEvents:RegisterEvent("GET_ITEM_INFO_RECEIVED")
			return
		end
	end
	itemEvents:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
end

Offline.OnChange(MarkOpenViews)

-- Own character from the bag window: the bank, its bags are already live there
local function Open(v, key)
	BuildPanel(v)
	v.key = key
	v.open = true
	if not v.kind or v.kind == "all" then
		v.kind = (v.isBank or key == Offline.CurrentKey()) and "bank" or "bags"
	end
	v.dirty = true
	v.scroll:SetVerticalScroll(0)
	v.panel:Show()
	SyncItemEvents()
	Paint(v)
end

-------------------------------------------------------------------------------
--  Character picker
-------------------------------------------------------------------------------
_G.StaticPopupDialogs["MER_BAGS_FORGET_CHARACTER"] = {
	text = L["Delete the saved bags and bank of %s? They are saved again the next time you log in on that character."],
	button1 = _G.DELETE,
	button2 = _G.CANCEL,
	OnAccept = function(_, data)
		Offline.Forget(data.key)
		for _, v in pairs(views) do
			if v.key == data.key then
				Close(v)
				SyncItemEvents()
			end
		end
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
}

local function Pick(v, key)
	if v.open and ShownKey(v) == key then
		Close(v)
		SyncItemEvents()
	else
		Open(v, key)
	end
end

local function OpenPicker(v, owner)
	local characters = Offline.Characters()
	local realms = {}
	for _, c in ipairs(characters) do
		realms[c.realm] = true
	end
	local manyRealms = next(realms) ~= nil and next(realms, next(realms)) ~= nil

	GameTooltip_Hide()
	_G.MenuUtil.CreateContextMenu(owner, function(_, root)
		root:CreateTitle(L["Show Character"])
		local realm
		for _, c in ipairs(characters) do
			if manyRealms and c.realm ~= realm then
				realm = c.realm
				root:CreateTitle(realm)
			end
			root:CreateRadio(ClassColored(c.name, c.class), function()
				return v.open and ShownKey(v) == c.key
			end, function()
				Pick(v, c.key)
			end)
		end

		if #characters > 1 then
			root:CreateDivider()
			local delete = root:CreateButton(L["Delete Saved Data"])
			for _, c in ipairs(characters) do
				if Offline.CanForget(c.key) then
					delete:CreateButton(ClassColored(c.name, c.class), function()
						StaticPopup_Show("MER_BAGS_FORGET_CHARACTER", c.name, nil, { key = c.key })
					end)
				end
			end
		end
	end)
end

local function CreatePickerButton(v)
	local f = v.frame
	local button = CreateFrame("Button", nil, f)
	button:Size(20)
	button:SetTemplate()
	button:StyleButton(nil, true)
	if button.hover then
		local cc = E.myClassColor
		button.hover:SetColorTexture(cc.r, cc.g, cc.b, 0.3)
	end

	button.tex = button:CreateTexture(nil, "OVERLAY")
	button.tex:SetInside()
	button.tex:SetAtlas("groupfinder-icon-friend")

	button:SetScript("OnClick", function(self)
		OpenPicker(v, self)
	end)
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:AddLine(L["Show Character"], 1, 1, 1)
		GameTooltip:AddLine(L["Bags, bank and more of your other characters."], 0.6, 0.6, 0.6, true)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", GameTooltip_Hide)

	v.button = button
end

local function GetView(f)
	local v = views[f]
	if v then
		return v
	end

	v = { frame = f, isBank = f == module.bankFrame, slots = {}, headers = {}, tabs = {} }
	views[f] = v

	-- Closing a window goes back to this character
	f:HookScript("OnHide", function()
		if v.open then
			v.open, v.key, v.kind = false, nil, nil
			v.panel:Hide()
			SyncItemEvents()
		end
	end)
	f.searchBox:HookScript("OnTextChanged", function()
		if v.open then
			Paint(v)
		end
	end)
	return v
end

---Runs after every refresh of a window: the live refresh resets the title
function module:OfflineSyncFrame(f)
	if E.Forever or not (views[f] or Offline.Enabled()) then
		return
	end

	local v = GetView(f)
	local on = Offline.Enabled()
	if on and not v.button then
		CreatePickerButton(v)
	end
	if v.button then
		v.button:SetShown(on)
	end

	f.titleText:ClearAllPoints()
	if on then
		v.button:ClearAllPoints()
		v.button:Point("TOPLEFT", f, "TOPLEFT", 6, -5)
		f.titleText:Point("LEFT", v.button, "RIGHT", 6, 0)
	else
		f.titleText:Point("TOPLEFT", 10, -10)
		if v.open then
			Close(v)
			SyncItemEvents()
		end
	end

	if v.open then
		Paint(v)
	end
end
