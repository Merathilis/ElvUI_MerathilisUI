local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories
local B = E:GetModule("Bags")
local S = E:GetModule("Skins")
local WS = W:GetModule("Skins")

local _G = _G
local ipairs = ipairs
local tinsert = tinsert
local format = format

local CreateFrame = CreateFrame
local GetMoney = GetMoney
local CloseBankFrame = (C_Bank and C_Bank.CloseBankFrame) or CloseBankFrame
local FetchDepositedMoney = C_Bank and C_Bank.FetchDepositedMoney
local FetchNextPurchasableBankTabData = C_Bank and C_Bank.FetchNextPurchasableBankTabData
local CHARACTER_BANK_TYPE = (Enum.BankType and Enum.BankType.Character) or 0
local WARBAND_BANK_TYPE = (Enum.BankType and Enum.BankType.Account) or 2

local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
local C_Container_GetContainerItemInfo = C_Container.GetContainerItemInfo
local C_Container_SetItemSearch = C_Container.SetItemSearch

-- Published by CategoryFrame.lua (each Modules/Bags/*.lua file loaded via
-- Load_Bags.xml is its own separate Lua chunk - only the shared `module`
-- table crosses that boundary, not file-local `local function`s).
local CreatePoolSet = module.CreatePoolSet
local RenderCategorySections = module.RenderCategorySections
local GetBankTabSlotState = module.GetBankTabSlotState
local CollectItemsByBagFrom = module.CollectItemsByBagFrom
local BuildBagSectionsFrom = module.BuildBagSectionsFrom
local BuildFlatSectionsFrom = module.BuildFlatSectionsFrom
local GetBagIcon = module.GetBagIcon
local GetBagDisplayName = module.GetBagDisplayName
local ShowPurchaseBankTabPrompt = module.ShowPurchaseBankTabPrompt
local SetCategoryIcon = module.SetCategoryIcon
local SetTitleCount = module.SetTitleCount
local SetFillBar = module.SetFillBar
local CountSearchHits = module.CountSearchHits
local SkinScrollBar = module.SkinScrollBar
local VIEW_MODE_ROW_HEIGHT = module.VIEW_MODE_ROW_HEIGHT
local COLLAPSED_SIDEBAR_WIDTH = module.COLLAPSED_SIDEBAR_WIDTH

local BANK_FRAME_NAME = module.BANK_FRAME_NAME
local BANK_SLOT_NAME_PREFIX = "MER_BankCategoriesSlot"
local DIVIDER_HEIGHT = 9

-------------------------------------------------------------------------------
--  Frame construction
-------------------------------------------------------------------------------
-- Small local helper mirroring CategoryFrame.lua's own CreateTitleButton -
-- deliberately a separate, self-contained copy (this frame's title-bar
-- button set is different enough - no sort/stack/vendor-grays/bag-bar - that
-- sharing one parameterized builder would need more branching than it saves).
local function CreateTitleButton(f, name, texture, tooltipText, onClick)
	local btn = CreateFrame("Button", BANK_FRAME_NAME .. name, f)
	btn:Size(20)
	pcall(btn.SetTemplate, btn)
	pcall(btn.StyleButton, btn, nil, true)
	if btn.hover then
		local cc = E.myClassColor
		btn.hover:SetColorTexture(cc.r, cc.g, cc.b, 0.3)
	end

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

-- The mode-selector rows - genuinely fixed at the top of the sidebar, above
-- the scrollable list (mirrors the bag frame's own ALL/CATEGORY/BAG
-- switcher rows). "All ... Tabs" groups content by physical tab (one header
-- per tab, see BuildBankSections); "OneBank"/"OneWarband" is the flat,
-- ungrouped counterpart (one continuous list, no per-tab headers) - same
-- relationship as the bag frame's own MultiBag/"All Items" pair. Labels stay
-- untranslated, matching the reference addon's own OneBag/MultiBag naming
-- already used elsewhere in this file.
local function BuildBankModeDefs()
	local defs = {}

	if #module.BankBagIDs > 0 then
		tinsert(defs, { kind = "mode", bankViewMode = "BANK_ALL", label = L["All Bank Tabs"] })
		tinsert(defs, { kind = "mode", bankViewMode = "ONEBANK", label = L["OneBank"] })
	end
	if #module.WarbandBagIDs > 0 then
		tinsert(defs, { kind = "mode", bankViewMode = "WARBAND_ALL", label = L["All Warband Tabs"] })
		tinsert(defs, { kind = "mode", bankViewMode = "ONEWARBAND", label = L["OneWarband"] })
	end

	return defs
end

-- One row def per possible physical tab slot (always the full 6/5-long list
-- regardless of purchase status - GetBankTabSlotState resolves purchased/
-- purchasable/locked per index at refresh time), plus a divider ahead of
-- each tab block. Unlike the mode rows above, these render *inside* the
-- scrollable sidebar list together with the category rows - a fixed block
-- big enough to hold every possible tab left almost no room for the
-- category list itself, which is what made bank categories hard/impossible
-- to click (the scrollable viewport was only a sliver).
local function BuildBankTabDefs()
	local defs = {}

	if #module.BankBagIDs > 0 then
		for i = 1, #module.BankBagIDs do
			tinsert(defs, { kind = "tab", bagIDList = module.BankBagIDs, bankType = CHARACTER_BANK_TYPE, index = i })
		end
	end

	if #module.WarbandBagIDs > 0 then
		-- Only between the two tab blocks - the first block already sits
		-- right under the fixed separator below the Pinned Items row.
		if #defs > 0 then
			tinsert(defs, { kind = "divider" })
		end
		for i = 1, #module.WarbandBagIDs do
			tinsert(defs, { kind = "tab", bagIDList = module.WarbandBagIDs, bankType = WARBAND_BANK_TYPE, index = i })
		end
	end

	return defs
end

local function BankTabRow_OnClick(self, mouseButton)
	local def = self.rowDef
	if not def then
		return
	end

	if def.kind == "mode" then
		module.bankViewMode = def.bankViewMode
		module.bankTabFilter = nil
		module:RefreshBankCategoryFrame()
		return
	end

	if def.kind ~= "tab" then
		return
	end

	local state, value = GetBankTabSlotState(def.bagIDList, def.bankType, def.index)

	if mouseButton == "RightButton" then
		if state == "purchased" then
			B:BankTabs_ShowSettings(value)
		end
		return
	end

	if state == "purchased" then
		module.bankTabFilter = (module.bankTabFilter == value) and nil or value
		module.bankViewMode = (def.bankType == WARBAND_BANK_TYPE) and "WARBAND_ALL" or "BANK_ALL"
		module:RefreshBankCategoryFrame()
	elseif state == "purchasable" then
		ShowPurchaseBankTabPrompt(value)
	end
end

local function BankTabRow_OnEnter(self)
	if GameTooltip:IsForbidden() then
		return
	end

	local def = self.rowDef
	if not def or def.kind ~= "tab" then
		return
	end

	local state, value = GetBankTabSlotState(def.bagIDList, def.bankType, def.index)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")

	if state == "purchased" then
		local numSlots = C_Container_GetContainerNumSlots(value)
		local freeSlots = C_Container.GetContainerNumFreeSlots and C_Container.GetContainerNumFreeSlots(value)
			or numSlots
		GameTooltip:AddLine(format("%s (%d/%d)", GetBagDisplayName(value), numSlots - freeSlots, numSlots), 1, 1, 1)
		GameTooltip:AddLine(
			module.bankTabFilter == value and L["Click to clear the filter"] or L["Click to filter by this tab"],
			0.6,
			0.6,
			0.6
		)
		if _G.BANK_TAB_TOOLTIP_CLICK_INSTRUCTION then
			GameTooltip:AddLine(_G.BANK_TAB_TOOLTIP_CLICK_INSTRUCTION, 0.6, 0.6, 0.6)
		end
	elseif state == "purchasable" then
		GameTooltip:AddLine(L["Purchase Bank Tab"], 1, 1, 1)
		local tabData = FetchNextPurchasableBankTabData and FetchNextPurchasableBankTabData(value)
		if tabData then
			GameTooltip:AddDoubleLine(L["Cost"], E:FormatMoney(tabData.tabCost, "SMART"), 1, 1, 1, 1, 1, 1)
		end
		GameTooltip:AddLine(L["Click to purchase"], 0.6, 0.6, 0.6)
	else
		GameTooltip:AddLine(L["Locked"], 1, 1, 1)
		GameTooltip:AddLine(L["Purchase the previous tab first."], 0.6, 0.6, 0.6)
	end

	GameTooltip:Show()
end

-- Shared button chrome for both the fixed mode rows and the scrollable tab
-- rows (icon/text/selected-highlight bar) - only the parent and position
-- differ between the two call sites.
local function CreateBankSidebarRowButton(parent)
	local row = CreateFrame("Button", nil, parent)
	row:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	row:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]], "ADD")

	row.selectedTex = row:CreateTexture(nil, "BACKGROUND")
	row.selectedTex:SetAllPoints()
	local cc = E.myClassColor
	row.selectedTex:SetColorTexture(cc.r, cc.g, cc.b, 0.25)

	row.selectedBar = row:CreateTexture(nil, "BORDER")
	row.selectedBar:Point("TOPLEFT", 0, 0)
	row.selectedBar:Point("BOTTOMLEFT", 0, 0)
	row.selectedBar:Width(2)
	row.selectedBar:SetColorTexture(cc.r, cc.g, cc.b, 1)

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
	row.count:SetTextColor(0.6, 0.6, 0.6)
	row.count:Point("RIGHT", -4, 0)

	row:SetScript("OnClick", BankTabRow_OnClick)
	row:SetScript("OnEnter", BankTabRow_OnEnter)
	row:SetScript("OnLeave", GameTooltip_Hide)

	return row
end

function module:ConstructBankFrame()
	if module.bankFrame then
		return module.bankFrame
	end

	local db = module.db

	local f = CreateFrame("Button", BANK_FRAME_NAME, E.UIParent)
	f:SetFrameStrata("HIGH")
	f:SetClampedToScreen(true)
	f:Size(db.bankWidth, db.bankHeight)
	f:Point("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 4, 48)
	pcall(f.SetTemplate, f, "Transparent")
	WS:CreateShadow(f)
	f:Hide()
	f:SetScript("OnShow", function(self)
		module:FadeInFrame(self)
	end)
	f:SetScript("OnHide", function()
		module:OnBankFrameHidden()
	end)
	module.bankFrame = f

	E:CreateMover(
		f,
		"MER_BankCategoriesMover",
		MER.Title .. L["Bank"],
		nil,
		nil,
		nil,
		"ALL,SOLO,MERATHILISUI",
		nil,
		"mui,modules,bags,categorizedBags"
	)

	f.titleBar = CreateFrame("Frame", nil, f)
	f.titleBar:Point("TOPLEFT")
	f.titleBar:Point("TOPRIGHT")
	f.titleBar:Height(30)
	pcall(f.titleBar.SetTemplate, f.titleBar, "Transparent")
	f.titleBar:SetFrameLevel(f:GetFrameLevel())

	f.closeButton = CreateFrame("Button", BANK_FRAME_NAME .. "CloseButton", f, "UIPanelCloseButton")
	f.closeButton:Point("TOPRIGHT", 2, 2)
	f.closeButton:SetScript("OnClick", function()
		module:HideBankFrame()
	end)
	pcall(S.HandleCloseButton, S, f.closeButton)

	f.titleText = f:CreateFontString(nil, "OVERLAY")
	f.titleText:FontTemplate(nil, 14)
	f.titleText:Point("TOPLEFT", 10, -10)

	f.titleCountText = f:CreateFontString(nil, "OVERLAY")
	f.titleCountText:FontTemplate(nil, 10)
	f.titleCountText:Point("LEFT", f.titleText, "RIGHT", 6, 0)

	f.helpButton = CreateTitleButton(f, "HelpButton", E.Media.Textures.Help, function()
		GameTooltip:AddLine(L["Bank / Warband Bank (while open)"], 1, 0.82, 0)
		GameTooltip:AddDoubleLine(L["Left Click:"], L["Pick up / move item"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Right Click:"], L["Deposit / withdraw item"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Shift + Right Click:"], L["Split Stack"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Ctrl + Right Click:"], L["Move to Bank Tab / Bag"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Middle Click:"], L["Pin / unpin item"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Shift + Middle Click:"], L["Assign to Category"], 1, 1, 1)
	end)
	f.helpButton:Point("TOPRIGHT", f, "TOPRIGHT", -40, -8)

	f.searchBox = CreateFrame("EditBox", BANK_FRAME_NAME .. "SearchBox", f, "SearchBoxTemplate")
	f.searchBox:Point("TOPRIGHT", f.helpButton, "TOPLEFT", -6, 0)
	f.searchBox:Size(180, 20)
	f.searchBox:HookScript("OnTextChanged", function(self)
		-- Shared with the bag frame's own search box - see the note on
		-- module.searchText in CategoryFrame.lua's OnFrameHidden.
		module.searchText = self:GetText() or ""
		module:RefreshBankCategoryFrame()
	end)
	pcall(S.HandleEditBox, S, f.searchBox)

	-- Sidebar
	f.sidebar = CreateFrame("Frame", nil, f)
	f.sidebar:Point("TOPLEFT", f, "TOPLEFT", 8, -34)
	f.sidebar:Point("BOTTOMLEFT", f, "BOTTOMLEFT", 8, 60)
	f.sidebar:Width(db.bankSidebarCollapsed and COLLAPSED_SIDEBAR_WIDTH or db.bankSidebarWidth)
	pcall(f.sidebar.SetTemplate, f.sidebar, "Transparent")
	module.AddSidebarEdge(f.sidebar)

	f.sidebarHeaderText = f.sidebar:CreateFontString(nil, "OVERLAY")
	f.sidebarHeaderText:FontTemplate()
	f.sidebarHeaderText:Point("TOPLEFT", 4, -4)
	f.sidebarHeaderText:SetText(L["Categories"])

	f.collapseButton = CreateFrame("Button", BANK_FRAME_NAME .. "CollapseButton", f.sidebar)
	f.collapseButton:Point("TOPRIGHT", -2, -4)
	pcall(S.HandleNextPrevButton, S, f.collapseButton, "left", nil, nil, nil, nil, 14)
	f.collapseButton:SetScript("OnClick", function()
		db.bankSidebarCollapsed = not db.bankSidebarCollapsed
		module:RefreshBankCategoryFrame()
	end)
	f.collapseButton:SetScript("OnEnter", function(self)
		if GameTooltip:IsForbidden() then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(db.bankSidebarCollapsed and L["Expand Sidebar"] or L["Collapse Sidebar"], 1, 1, 1)
		GameTooltip:Show()
	end)
	f.collapseButton:SetScript("OnLeave", GameTooltip_Hide)
	module.AddCollapseButtonHover(f.collapseButton)

	-- Fixed rows: only the two "All ... Tabs" mode-selector rows sit above
	-- the scrollable list (mirrors the bag frame's own ALL/CATEGORY/BAG
	-- switcher). The per-tab rows render *inside* the scrollable sidebar
	-- together with the category rows (see RefreshBankCategoryFrame) -
	-- putting the whole tab block here as a second fixed section left the
	-- category list's own scrollable viewport only a sliver tall (as little
	-- as ~120px with both banks present), which is what made bank category
	-- rows hard or impossible to click near the bottom of that cramped area.
	f.bankModeDefs = BuildBankModeDefs()
	f.bankTabDefs = BuildBankTabDefs()
	f.bankModeRows = {}

	local rowY = -18
	for i, def in ipairs(f.bankModeDefs) do
		local row = CreateBankSidebarRowButton(f.sidebar)
		row:SetHeight(VIEW_MODE_ROW_HEIGHT)
		row:Point("TOPLEFT", f.sidebar, "TOPLEFT", 4, rowY)
		row:Point("TOPRIGHT", f.sidebar, "TOPRIGHT", -4, rowY)
		row.rowDef = def
		f.bankModeRows[i] = { frame = row, def = def }
		rowY = rowY - VIEW_MODE_ROW_HEIGHT
	end

	local fixedBlockHeight = -rowY

	f.pinnedRow = CreateFrame("Button", nil, f.sidebar)
	f.pinnedRow:SetHeight(VIEW_MODE_ROW_HEIGHT)
	f.pinnedRow:Point("TOPLEFT", f.sidebar, "TOPLEFT", 4, -fixedBlockHeight)
	f.pinnedRow:Point("TOPRIGHT", f.sidebar, "TOPRIGHT", -4, -fixedBlockHeight)
	f.pinnedRow:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]], "ADD")

	f.pinnedRow.icon = f.pinnedRow:CreateTexture(nil, "ARTWORK")
	f.pinnedRow.icon:SetSize(16, 16)
	f.pinnedRow.icon:Point("LEFT", 4, 0)

	f.pinnedRow.text = f.pinnedRow:CreateFontString(nil, "OVERLAY")
	f.pinnedRow.text:FontTemplate()
	f.pinnedRow.text:Point("LEFT", f.pinnedRow.icon, "RIGHT", 6, 0)
	f.pinnedRow.text:Point("RIGHT", -26, 0)
	f.pinnedRow.text:SetJustifyH("LEFT")
	f.pinnedRow.text:SetText(module.PinnedCategory.name)

	f.pinnedRow.count = f.pinnedRow:CreateFontString(nil, "OVERLAY")
	f.pinnedRow.count:FontTemplate()
	f.pinnedRow.count:SetTextColor(0.6, 0.6, 0.6)
	f.pinnedRow.count:Point("RIGHT", -4, 0)

	f.pinnedRow:SetScript("OnClick", function()
		module:ScrollToCategory(module.PinnedCategory.key, f, module.bankCategoryOffsets)
	end)
	f.pinnedRow:SetScript("OnEnter", function(self)
		if GameTooltip:IsForbidden() then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(module.PinnedCategory.name, 1, 1, 1)
		local count = self.count:GetText()
		if count and count ~= "" then
			GameTooltip:AddLine(count, 0.6, 0.6, 0.6)
		end
		GameTooltip:Show()
	end)
	f.pinnedRow:SetScript("OnLeave", GameTooltip_Hide)

	f.sidebarSeparator = f.sidebar:CreateTexture(nil, "ARTWORK")
	f.sidebarSeparator:SetColorTexture(1, 1, 1, 0.15)
	f.sidebarSeparator:Height(1)
	f.sidebarSeparator:Point("TOPLEFT", f.pinnedRow, "BOTTOMLEFT", 2, -3)
	f.sidebarSeparator:Point("TOPRIGHT", f.pinnedRow, "BOTTOMRIGHT", -2, -3)

	f.sidebarScroll =
		CreateFrame("ScrollFrame", BANK_FRAME_NAME .. "SidebarScroll", f.sidebar, "UIPanelScrollFrameTemplate")
	f.sidebarScroll:Point("TOPLEFT", 4, -fixedBlockHeight - VIEW_MODE_ROW_HEIGHT - 10)
	f.sidebarScroll:Point("BOTTOMRIGHT", -24, 4)
	SkinScrollBar(f.sidebarScroll.ScrollBar)

	f.sidebarChild = CreateFrame("Frame", nil, f.sidebarScroll)
	f.sidebarChild:Point("TOPLEFT")
	f.sidebarChild:Width(db.bankSidebarWidth - 30)
	f.sidebarChild:Height(1)
	f.sidebarScroll:SetScrollChild(f.sidebarChild)
	module.bankSidebarChild = f.sidebarChild

	-- Main content
	f.mainScroll = CreateFrame("ScrollFrame", BANK_FRAME_NAME .. "MainScroll", f, "UIPanelScrollFrameTemplate")
	f.mainScroll:Point("TOPLEFT", f.sidebar, "TOPRIGHT", 8, 0)
	f.mainScroll:Point("BOTTOMRIGHT", f, "BOTTOMRIGHT", -28, 36)
	SkinScrollBar(f.mainScroll.ScrollBar)

	f.contentChild = CreateFrame("Frame", nil, f.mainScroll)
	f.contentChild:Point("TOPLEFT")
	f.contentChild:Width(1)
	f.contentChild:Height(1)
	f.mainScroll:SetScrollChild(f.contentChild)
	module.bankContentChild = f.contentChild

	-- Shown when a search/tab filter leaves nothing to display - see the bag
	-- frame's own f.emptyText for why this is parented to the scroll frame.
	f.emptyText = f.mainScroll:CreateFontString(nil, "OVERLAY")
	f.emptyText:FontTemplate(nil, 14)
	f.emptyText:SetTextColor(0.6, 0.6, 0.6)
	f.emptyText:Point("CENTER")
	f.emptyText:SetText(L["No items found."])
	f.emptyText:Hide()

	-- Footer: player gold (left) / Warband gold (right), Withdraw/Deposit
	-- buttons for Warband gold transfer, and a center Auto Deposit button
	-- that relabels itself for whichever bank the sidebar is currently
	-- showing.
	f.footer = CreateFrame("Frame", nil, f)
	f.footer:Point("BOTTOMLEFT", 8, 8)
	f.footer:Point("BOTTOMRIGHT", -8, 8)
	f.footer:Height(20)

	module.CreateFillBar(f)

	f.footer.goldText = f.footer:CreateFontString(nil, "OVERLAY")
	f.footer.goldText:FontTemplate()
	f.footer.goldText:Point("LEFT", 4, 0)

	f.footer.goldButton = CreateFrame("Button", nil, f.footer)
	f.footer.goldButton:SetAllPoints(f.footer.goldText)
	f.footer.goldButton:SetScript("OnEnter", function(self)
		module:ShowGoldTooltip(self)
	end)
	f.footer.goldButton:SetScript("OnLeave", GameTooltip_Hide)

	if #module.WarbandBagIDs > 0 then
		f.footer.warbandGoldText = f.footer:CreateFontString(nil, "OVERLAY")
		f.footer.warbandGoldText:FontTemplate()
		f.footer.warbandGoldText:Point("RIGHT", -4, 0)

		f.footer.warbandGoldButton = CreateFrame("Button", nil, f.footer)
		f.footer.warbandGoldButton:SetAllPoints(f.footer.warbandGoldText)
		f.footer.warbandGoldButton:SetScript("OnEnter", function(self)
			if GameTooltip:IsForbidden() then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
			GameTooltip:AddLine(module.TooltipIcon("warbands-icon") .. L["Warband Bank"], 1, 1, 1)
			GameTooltip:Show()
		end)
		f.footer.warbandGoldButton:SetScript("OnLeave", GameTooltip_Hide)

		f.footer.withdrawButton = CreateFrame("Button", BANK_FRAME_NAME .. "WithdrawButton", f.footer, "UIPanelButtonTemplate")
		f.footer.withdrawButton:Size(64, 20)
		f.footer.withdrawButton:SetText(_G.WITHDRAW or L["Withdraw"])
		f.footer.withdrawButton:Point("RIGHT", f.footer.warbandGoldText, "LEFT", -8, 0)
		f.footer.withdrawButton:SetScript("OnClick", function()
			-- Blizzard's own native money-transfer dialogs (same ones ElvUI's
			-- Bank frame uses, B:Container_WithdrawGold) - they own the whole
			-- amount-input UI and the actual C_Bank money-transfer call, no
			-- need to reimplement either ourselves.
			if not StaticPopup_FindVisible("BANK_MONEY_DEPOSIT") then
				StaticPopup_Show("BANK_MONEY_WITHDRAW", nil, nil, { bankType = WARBAND_BANK_TYPE })
			end
		end)
		pcall(S.HandleButton, S, f.footer.withdrawButton)

		f.footer.depositGoldButton =
			CreateFrame("Button", BANK_FRAME_NAME .. "DepositGoldButton", f.footer, "UIPanelButtonTemplate")
		f.footer.depositGoldButton:Size(64, 20)
		f.footer.depositGoldButton:SetText(_G.DEPOSIT or L["Deposit"])
		f.footer.depositGoldButton:Point("RIGHT", f.footer.withdrawButton, "LEFT", -4, 0)
		f.footer.depositGoldButton:SetScript("OnClick", function()
			if not StaticPopup_FindVisible("BANK_MONEY_WITHDRAW") then
				StaticPopup_Show("BANK_MONEY_DEPOSIT", nil, nil, { bankType = WARBAND_BANK_TYPE })
			end
		end)
		pcall(S.HandleButton, S, f.footer.depositGoldButton)
	end

	f.footer.depositButton =
		CreateFrame("Button", BANK_FRAME_NAME .. "DepositButton", f.footer, "UIPanelButtonTemplate")
	f.footer.depositButton:Size(140, 20)
	f.footer.depositButton:Point("CENTER", f.footer, "CENTER", 0, 0)
	f.footer.depositButton:SetScript("OnClick", function()
		module:AutoDepositToBank()
	end)
	pcall(S.HandleButton, S, f.footer.depositButton)

	F.CreateStyle(f)

	f:RegisterEvent("PLAYER_MONEY")
	f:SetScript("OnEvent", function()
		module:UpdateBankFooter()
	end)

	return f
end

-------------------------------------------------------------------------------
--  Footer
-------------------------------------------------------------------------------
function module:UpdateBankFooter()
	local f = module.bankFrame
	if not f then
		return
	end

	module:UpdateGoldTracking()
	f.footer.goldText:SetText(E:FormatMoney(GetMoney(), "SMART"))

	if f.footer.warbandGoldText and FetchDepositedMoney then
		local ok, warbandGold = pcall(FetchDepositedMoney, WARBAND_BANK_TYPE)
		f.footer.warbandGoldText:SetText(ok and warbandGold and E:FormatMoney(warbandGold, "SMART") or "")
	end

	module:UpdateBankDepositButtonLabel()
end

-- Relabels the center "Deposit" button to describe what it's actually about
-- to do, based on whichever tab/bank the sidebar currently has selected.
function module:UpdateBankDepositButtonLabel()
	local f = module.bankFrame
	if not f then
		return
	end

	local isWarbandView = module.bankViewMode == "WARBAND_ALL" or module.bankViewMode == "ONEWARBAND"
	local label = isWarbandView and L["Deposit Warbound Items"] or L["Deposit Reagents"]
	f.footer.depositButton:SetText(label)
end

-------------------------------------------------------------------------------
--  Refresh
-------------------------------------------------------------------------------
local bankPools = CreatePoolSet(
	BANK_SLOT_NAME_PREFIX,
	function()
		return module.bankContentChild
	end,
	function()
		return module.bankSidebarChild
	end,
	function()
		return module.bankFrame
	end,
	function()
		return module.bankCategoryOffsets
	end
)

-- Tab rows/dividers live inside module.bankSidebarChild (the scrollable
-- sidebar list), rendered fresh each refresh right before the category rows
-- (see RefreshBankCategoryFrame) - row/divider COUNT never changes across
-- refreshes (BankBagIDs/WarbandBagIDs are fixed per session), so unlike the
-- category-row pool there's nothing to ever release.
local bankTabRowPool = {}
local bankTabDividerPool = {}

local function AcquireBankTabRow(index)
	local row = bankTabRowPool[index]
	if not row then
		row = CreateBankSidebarRowButton(module.bankSidebarChild)
		bankTabRowPool[index] = row
	end
	row:Show()
	return row
end

local function AcquireBankTabDivider(index)
	local divider = bankTabDividerPool[index]
	if not divider then
		divider = module.bankSidebarChild:CreateTexture(nil, "ARTWORK")
		divider:SetColorTexture(1, 1, 1, 0.15)
		divider:Height(1)
		bankTabDividerPool[index] = divider
	end
	divider:Show()
	return divider
end

local bankItemsByBagScratch = {}
local warbandItemsByBagScratch = {}

-- Only "purchased" tabs get a content section - an unpurchased tab has 0
-- slots and nothing meaningful to group; it's still listed as locked/
-- purchasable in the sidebar's own tab rows.
local function GetPurchasedBagIDs(bagIDList, bankType)
	local purchased = {}
	for i, bagID in ipairs(bagIDList) do
		if GetBankTabSlotState(bagIDList, bankType, i) == "purchased" then
			tinsert(purchased, bagID)
		end
	end
	return purchased
end

-- "All ... Tabs" groups content by physical tab instead of category -
-- classification categories don't map well onto a bank's own organization,
-- tabs do. `true` (alwaysShow) keeps every purchased tab's section visible
-- even when empty, matching the always-listed physical tabs in the
-- reference layout - unlike a category, an empty tab is still a real,
-- addressable place to put things. "OneBank"/"OneWarband" instead flattens
-- the same items into one continuous list, no per-tab headers.
local function BuildBankSections()
	local isWarband = module.bankViewMode == "WARBAND_ALL" or module.bankViewMode == "ONEWARBAND"
	local bagIDList, bankType, scratch
	if isWarband then
		bagIDList, bankType, scratch = module.WarbandBagIDs, WARBAND_BANK_TYPE, warbandItemsByBagScratch
	else
		bagIDList, bankType, scratch = module.BankBagIDs, CHARACTER_BANK_TYPE, bankItemsByBagScratch
	end

	local purchasedBagIDs = GetPurchasedBagIDs(bagIDList, bankType)

	-- Clicking a tab row (module.bankTabFilter) narrows the content down to
	-- just that one tab, same as before, in either mode.
	if module.bankTabFilter then
		local filtered = {}
		for _, bagID in ipairs(purchasedBagIDs) do
			if bagID == module.bankTabFilter then
				tinsert(filtered, bagID)
			end
		end
		purchasedBagIDs = filtered
	end

	local itemsByBag = CollectItemsByBagFrom(purchasedBagIDs, scratch)

	if module.bankViewMode == "ONEBANK" or module.bankViewMode == "ONEWARBAND" then
		return BuildFlatSectionsFrom(purchasedBagIDs, itemsByBag)
	end

	return BuildBagSectionsFrom(purchasedBagIDs, itemsByBag, true, true)
end

-- Used-item count for one bag (an unpurchased tab's bagID just reports 0
-- slots, so summing every def in BankBagIDs/WarbandBagIDs regardless of
-- purchase state is already correct - no separate purchased-only filtering
-- needed).
local function CountBagItems(bagID)
	local numSlots = C_Container_GetContainerNumSlots(bagID)
	local used = 0
	for slotID = 1, numSlots do
		local info = C_Container_GetContainerItemInfo(bagID, slotID)
		if info and info.iconFileID then
			used = used + 1
		end
	end
	return used
end

local function SumBagItems(bagIDList)
	local total = 0
	for _, bagID in ipairs(bagIDList) do
		total = total + CountBagItems(bagID)
	end
	return total
end

function module:RefreshBankCategoryFrame()
	if not module.bankFrame or not module.bankFrame:IsShown() then
		return
	end

	local db = module.db
	local f = module.bankFrame
	module.TrimRecentItems()

	local sections = module.MergeSectionItems(BuildBankSections())

	module.bankCategoryOffsets = {}

	local sidebarWidth = db.bankSidebarCollapsed and COLLAPSED_SIDEBAR_WIDTH or db.bankSidebarWidth
	f.sidebar:Width(sidebarWidth)

	local bankItemCount = SumBagItems(module.BankBagIDs)
	local warbandItemCount = SumBagItems(module.WarbandBagIDs)

	for _, entry in ipairs(f.bankModeRows) do
		local row, def = entry.frame, entry.def
		row.text:SetShown(not db.bankSidebarCollapsed)
		row.text:SetText(def.label)
		row.icon:SetTexture(E.Media.Textures.Backpack)
		row.count:SetShown(not db.bankSidebarCollapsed)
		row.count:SetText(
			(def.bankViewMode == "WARBAND_ALL" or def.bankViewMode == "ONEWARBAND") and warbandItemCount
				or bankItemCount
		)
		local isSelected = module.bankViewMode == def.bankViewMode
		row.selectedTex:SetShown(isSelected)
		row.selectedBar:SetShown(isSelected)
		module.SetSelectedRowTextColor(row, isSelected)
	end

	f.pinnedRow.text:SetShown(not db.bankSidebarCollapsed)
	f.pinnedRow.count:SetShown(not db.bankSidebarCollapsed)
	SetCategoryIcon(f.pinnedRow.icon, module.PinnedCategory)

	module.PositionCollapseButton(f, db.bankSidebarCollapsed)

	local collapseArrowRotation = S.ArrowRotation and S.ArrowRotation[db.bankSidebarCollapsed and "right" or "left"]
	if collapseArrowRotation then
		for _, tex in ipairs({ f.collapseButton:GetNormalTexture(), f.collapseButton:GetPushedTexture() }) do
			if tex then
				tex:SetRotation(collapseArrowRotation)
			end
		end
	end

	f.sidebarHeaderText:SetShown(not db.bankSidebarCollapsed)

	f.sidebarChild:Width(module.GetSidebarChildWidth(sidebarWidth))
	-- Only the right inset moves with the collapsed state - TOPLEFT is fixed
	-- forever after construction (the tab-list block above it never changes
	-- row count), so this must NOT ClearAllPoints() first or it'd drop that
	-- anchor entirely.
	f.sidebarScroll:SetPoint("BOTTOMRIGHT", -module.SIDEBAR_SCROLLBAR_INSET, 4)

	-- Tab rows render into the same scrollable sidebarChild as the category
	-- rows below them (RenderCategorySections continues right after, via
	-- sidebarBaseY) - one shared scrollable viewport instead of a second
	-- fixed block stealing most of the sidebar's height.
	local sidebarChild = module.bankSidebarChild
	local tabRowIndex, tabDividerIndex, tabY = 0, 0, 0

	for _, def in ipairs(f.bankTabDefs) do
		if def.kind == "divider" then
			tabDividerIndex = tabDividerIndex + 1
			local divider = AcquireBankTabDivider(tabDividerIndex)
			divider:ClearAllPoints()
			divider:Point("TOPLEFT", sidebarChild, "TOPLEFT", 4, -(tabY + DIVIDER_HEIGHT / 2))
			divider:Point("TOPRIGHT", sidebarChild, "TOPRIGHT", -4, -(tabY + DIVIDER_HEIGHT / 2))
			tabY = tabY + DIVIDER_HEIGHT
		else
			tabRowIndex = tabRowIndex + 1
			local row = AcquireBankTabRow(tabRowIndex)
			row.rowDef = def
			row:SetHeight(db.sidebarRowHeight)
			row:ClearAllPoints()
			row:Point("TOPLEFT", sidebarChild, "TOPLEFT", 0, -tabY)
			row:Point("TOPRIGHT", sidebarChild, "TOPRIGHT", 0, -tabY)

			local state, value = GetBankTabSlotState(def.bagIDList, def.bankType, def.index)

			if state == "purchased" then
				row.text:SetShown(not db.bankSidebarCollapsed)
				row.text:SetText(GetBagDisplayName(value))
				row.icon:SetTexture(GetBagIcon(value))
				row.icon:SetDesaturated(false)
				row.icon:SetAlpha(1)
				row.count:SetShown(not db.bankSidebarCollapsed)
				row.count:SetText(CountBagItems(value))
				local isSelected = module.bankTabFilter == value
				row.selectedTex:SetShown(isSelected)
				row.selectedBar:SetShown(isSelected)
				module.SetSelectedRowTextColor(row, isSelected)
			elseif state == "purchasable" then
				row.text:SetShown(not db.bankSidebarCollapsed)
				row.text:SetText(L["Purchase Bank Tab"])
				row.icon:SetTexture(133784) -- Interface\ICONS\INV_Misc_Coin_02
				row.icon:SetDesaturated(false)
				row.icon:SetAlpha(1)
				row.count:SetText("")
				row.selectedTex:Hide()
				row.selectedBar:Hide()
				module.SetSelectedRowTextColor(row, false)
			else
				row.text:SetShown(not db.bankSidebarCollapsed)
				row.text:SetText(L["Locked"])
				row.icon:SetTexture(E.Media.Textures.Backpack)
				row.icon:SetDesaturated(true)
				row.icon:SetAlpha(0.4)
				row.count:SetText("")
				row.selectedTex:Hide()
				row.selectedBar:Hide()
				module.SetSelectedRowTextColor(row, false)
			end

			tabY = tabY + db.sidebarRowHeight
		end
	end

	RenderCategorySections({
		contentChild = module.bankContentChild,
		sidebarChild = module.bankSidebarChild,
		pools = bankPools,
		pinnedRow = f.pinnedRow,
		offsets = module.bankCategoryOffsets,
		width = db.bankWidth,
		sidebarWidth = sidebarWidth,
		sidebarBaseY = tabY,
		emptyText = f.emptyText,
		refresh = function()
			module:RefreshBankCategoryFrame()
		end,
	}, sections)

	module.ApplyAutoHeight(f, module.bankContentChild, module.bankSidebarChild, db.bankHeight)

	local isWarbandView = module.bankViewMode == "WARBAND_ALL" or module.bankViewMode == "ONEWARBAND"
	local countBagIDs = isWarbandView and module.WarbandBagIDs or module.BankBagIDs
	local usedSlots = isWarbandView and warbandItemCount or bankItemCount
	local totalSlots = 0
	for _, bagID in ipairs(countBagIDs) do
		totalSlots = totalSlots + C_Container_GetContainerNumSlots(bagID)
	end
	f.titleText:SetText(isWarbandView and L["Warband Bank"] or L["Bank"])
	SetTitleCount(
		f.titleCountText,
		usedSlots,
		totalSlots,
		CountSearchHits(module.bankTabFilter and { module.bankTabFilter } or countBagIDs)
	)
	SetFillBar(f, usedSlots, totalSlots)

	module:UpdateBankFooter()
end

-------------------------------------------------------------------------------
--  Show / hide lifecycle
-------------------------------------------------------------------------------
-- Same combat-lockdown reasoning as the bag frame's ShowCategoryFrame/
-- HideCategoryFrame (secure slot buttons make the whole tree combat-
-- protected for Show()/Hide()).
function module:ShowBankFrame()
	if InCombatLockdown() then
		return
	end

	module:ConstructBankFrame()
	module:ApplyBackgroundOpacity()

	module.bankFrame:Show()
	if module.bankFrame.fadingOut then
		module:FadeInFrame(module.bankFrame)
	end
	module:RegisterBagEventsFor("bank")
	module:RefreshBankCategoryFrame()
end

function module:HideBankFrame()
	if InCombatLockdown() then
		return
	end

	if module.bankFrame and module.bankFrame:IsShown() then
		module:FadeOutHide(module.bankFrame)
	end
end

function module:OnBankFrameHidden()
	module:UnregisterBagEventsFor("bank")

	if not (module.frame and module.frame:IsShown()) then
		C_Container_SetItemSearch("")
	end

	if module.addCategoryFrame and module.addCategoryFrame:IsShown() then
		module.addCategoryFrame:Hide()
	end

	-- Unlike the bag frame's own OnFrameHidden, this frame IS the one
	-- responsible for the live bank server session - always end it here,
	-- covering the close button, Escape, and any other way this frame gets
	-- hidden while a bank interaction might still be open.
	if module.isBankOpen and CloseBankFrame then
		CloseBankFrame()
	end

	if module.bankFrame.NewItemGlow then
		module.bankFrame.NewItemGlow:Stop()
	end
end
