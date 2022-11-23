local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')
if not IsAddOnLoaded("Auctionator") then return end

local _G = _G
local next = next
local select = select
local unpack = unpack
local tostring = tostring
local strmatch = strmatch
local GetItemInfo = GetItemInfo
local hooksecurefunc = hooksecurefunc
local GameTooltip_ClearMoney = GameTooltip_ClearMoney

local function SkinHeaders(header, x, y)
	header:Point('TOPLEFT', header:GetParent(), 'TOPLEFT', x or -20, y or -3)

	local maxHeaders = header:GetNumChildren()
	for i = 1, maxHeaders do
		local section = select(i, header:GetChildren())
		if section then
			if not section.backdrop then
				section:DisableDrawLayer('BACKGROUND')
				section:CreateBackdrop('Transparent')
				section.backdrop:Point('BOTTOMRIGHT', i < maxHeaders and -5 or 0, -2)
			end
		end
	end
end

local function SkinItem(item)
	if item.Icon and not item.backdrop then
		item.Icon:SetTexCoord(unpack(E.TexCoords))
		item:CreateBackdrop()
		item:StyleButton()
		item.backdrop:SetAllPoints()
		item.EmptySlot:Hide()
		item.IconMask:Hide()
		item.Icon:SetInside(item.backdrop)
		S:HandleIconBorder(item.IconBorder, item.backdrop)
	end
end

local function SetItemInfo(item, info)
	if info then
		SkinItem(item)
	end
end

local function SectionTitle(list)
	for _, classId in ipairs(list.orderedClassIds) do
		local frame = list.frameMap[classId]
		if frame then
			local title = frame.SectionTitle
			if not title.template then
				title:StripTextures()
				title:SetTemplate()
				title:ClearAllPoints()
				title:Point('TOPLEFT', frame)
				title:Point('RIGHT', frame)
			end

			local container = frame.ItemContainer
			if container then
				container:ClearAllPoints()
				container:Point('TOPLEFT', title, 'BOTTOMLEFT', 1, 2)
			end
		end
	end
end

local function SetOutsideText(editbox, backdrop, width, height)
	for _, region in next, { editbox:GetRegions() } do
		if region and region:IsObjectType('FontString') then
			backdrop:SetOutside(region, width, height)
			break
		end
	end
end

local function SkinMoneyInput(editbox, height)
	local backdrop = editbox.backdrop -- reference it before change, so it doesnt try to use InputBox backdrop
	if editbox.labelText == 'Quantity' then
		editbox = editbox.InputBox
		editbox:StripTextures()
	end

	editbox:SetHeight(height)
	SetOutsideText(editbox, backdrop, 6)
end

local function SkinMainFrames()
	local list = _G.AuctionatorShoppingFrame
	local config = _G.AuctionatorConfigFrame
	local selling = _G.AuctionatorSellingFrame
	local cancelling = _G.AuctionatorCancellingFrame
	local recentList = list.ScrollListRecents
	local shoppingList = list.ScrollListShoppingList
	local shopTabs = list.RecentsTabsContainer

	list:StripTextures()
	list.ResultsListing.ScrollArea:SetTemplate('Transparent')

	config:StripTextures()
	config:SetTemplate('Transparent')

	cancelling.ResultsListing.ScrollArea:StripTextures()
	cancelling.ResultsListing.ScrollArea:SetTemplate('Transparent')
	cancelling.ResultsListing.ScrollArea:Point('TOPLEFT', cancelling.ResultsListing.HeaderContainer, 'BOTTOMLEFT', 14, -
		6)
	selling.CurrentPricesListing.ScrollArea:Point('TOPLEFT', selling.CurrentPricesListing.HeaderContainer, 'BOTTOMLEFT',
		14, -4)
	selling.HistoricalPriceListing.ScrollArea:Point('TOPLEFT', selling.HistoricalPriceListing.HeaderContainer,
		'BOTTOMLEFT', 14, -4)
	list.ResultsListing.ScrollArea:Point('TOPLEFT', list.ResultsListing.HeaderContainer, 'BOTTOMLEFT', 15, -4)

	list.ExportCSV:ClearAllPoints()
	list.ExportCSV:Point('TOPRIGHT', list, 'BOTTOMRIGHT', -2, -2)
	list.ListDropdown:ClearAllPoints()
	list.ListDropdown:Point('RIGHT', list.Export, 'LEFT', -20, -2)
	list.ShoppingResultsInset:StripTextures()
	list.OneItemSearch.SearchButton:ClearAllPoints()
	list.OneItemSearch.SearchButton:Point('LEFT', list.OneItemSearchBox, 'RIGHT', 3, 0)
	list.OneItemSearch.ExtendedButton:ClearAllPoints()
	list.OneItemSearch.ExtendedButton:Point('LEFT', list.OneItemSearchButton, 'RIGHT', 2, 0)
	list.Export:ClearAllPoints()
	list.Export:Point('RIGHT', list.Import, 'LEFT', -3, 0)

	recentList.Inset:StripTextures()
	recentList.Inset:Point('TOPLEFT', recentList, 'TOPLEFT', 3, 0)
	shoppingList.Inset:StripTextures()
	shoppingList.Inset:Point('TOPLEFT', shoppingList, 'TOPLEFT', 3, 0)
	cancelling.HistoricalPriceInset:StripTextures()

	selling.HistoricalPriceInset:StripTextures()
	selling.HistoricalPriceInset:SetTemplate('Transparent')
	selling.HistoricalPriceInset:Point('TOPLEFT', selling.HistoricalPriceListing, 'TOPLEFT', -7, -25)
	selling.HistoricalPriceInset:Point('BOTTOMRIGHT', selling.HistoricalPriceListing, 'BOTTOMRIGHT', -2, 0)

	selling.BagInset:StripTextures()
	selling.BagListing.ScrollBox:StripTextures()
	selling.BagListing.ScrollBox:CreateBackdrop('Transparent')
	selling.BagListing.ScrollBox:SetOutside(selling.BagListing)
	selling.BagListing.ScrollBox.backdrop:SetOutside(selling.BagListing)

	S:HandleDropDownBox(list.ListDropdown, 250)

	-- handle sell item icon
	SkinItem(selling.AuctionatorSaleItem.Icon)
	selling.AuctionatorSaleItem.Icon.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))

	-- handle bag item icons
	hooksecurefunc(_G.AuctionatorBagItemMixin, 'SetItemInfo', SetItemInfo)

	-- handle bag item titles
	hooksecurefunc(selling.BagListing, 'Update', SectionTitle)

	for _, button in next, {
		-- Shopping
		_G.AuctionatorShoppingLists_AddItem,
		list.ManualSearch,
		list.ExportCSV,
		list.Rename,
		list.Export,
		list.Import,
		list.AddItem,
		list.SortItems,
		list.OneItemSearch.SearchButton,
		list.OneItemSearch.ExtendedButton,

		--Selling
		selling.SaleItemFrame.MaxButton,
		selling.SaleItemFrame.PostButton,
		selling.SaleItemFrame.SkipButton,

		--Auctionator
		config.OptionsButton,
		config.ScanButton
	} do
		S:HandleButton(button)
	end

	for i, bar in next, {
		_G.AuctionatorSellingFrameScrollBar,
		cancelling.ResultsListing.ScrollArea.ScrollBar,
		list.ResultsListing.ScrollArea.ScrollBar,
		selling.CurrentPricesListing.ScrollArea.ScrollBar,
		selling.HistoricalPriceListing.ScrollArea.ScrollBar,
		selling.ResultsListing.ScrollArea.ScrollBar,
		selling.BagListing.ScrollBar,
		shoppingList.ScrollBar,
		recentList.ScrollBar
	} do
		S:HandleTrimScrollBar(bar)
		bar:ClearAllPoints()

		if bar == recentList.ScrollBar or bar == shoppingList.ScrollBar then
			bar:Point('TOPRIGHT', 2, 0)
			bar:Point('BOTTOMRIGHT', 2, 0)
		else
			local x, y = i == 1 and -7 or 1, i == 1 and -14 or 6
			bar:Point('TOPLEFT', nil, 'TOPRIGHT', -x, y)
			bar:Point('BOTTOMLEFT', nil, 'BOTTOMRIGHT', -x, -y)
		end
	end

	for _, tab in next, {
		selling.PricesTabsContainer.CurrentPricesTab,
		selling.PricesTabsContainer.PriceHistoryTab,
		selling.PricesTabsContainer.RealmHistoryTab,
		selling.PricesTabsContainer.YourHistoryTab,
		shopTabs.ListTab,
		shopTabs.RecentsTab
	} do
		S:HandleTab(tab)

		tab.Text:SetAllPoints(tab)
	end

	do -- cool another bullshit lib :D
		local ref = {
			[_G.AuctionatorShoppingFrame]   = _G.AuctionHouseFrameAuctionsTab,
			[_G.AuctionatorSellingFrame]    = _G.AuctionatorTabs_Shopping,
			[_G.AuctionatorCancellingFrame] = _G.AuctionatorTabs_Selling,
			[_G.AuctionatorConfigFrame]     = _G.AuctionatorTabs_Cancelling
		} -- whack shit reference table >.>

		for _, tab in next, _G.AuctionatorAHTabsContainer.Tabs do
			-- tab:ClearAllPoints()
			-- tab:Point('LEFT', ref[tab.frameRef], 'RIGHT', -5, 0)

			S:HandleTab(tab)
			module:ReskinTab(tab)
		end
	end

	for _, editbox in next, {
		list.OneItemSearch.SearchBox,

		--Selling
		selling.SaleItemFrame.Quantity,
		selling.SaleItemFrame.Price.MoneyInput.GoldBox,
		selling.SaleItemFrame.Price.MoneyInput.SilverBox,
		selling.SaleItemFrame.Price.MoneyInput.CopperBox,

		--Config
		config.DiscordLink,
		config.TechnicalRoadmap,
		config.BugReportLink,

		--Cancelling
		cancelling.SearchFilter
	} do
		S:HandleEditBox(editbox)

		if editbox.iconAtlas or editbox.labelText == 'Quantity' then
			SkinMoneyInput(editbox, 28)
		elseif editbox.InputBox then
			editbox.InputBox:StripTextures()
			editbox.backdrop:SetAllPoints(editbox.InputBox)
		end
	end

	selling.SaleItemFrame.MaxButton:ClearAllPoints()
	selling.SaleItemFrame.MaxButton:Point('LEFT', selling.SaleItemFrame.Quantity.backdrop, 'RIGHT', 5, 0)

	selling.SaleItemFrame.SkipButton:ClearAllPoints()
	selling.SaleItemFrame.SkipButton:Point('TOPLEFT', selling.SaleItemFrame.PostButton, 'TOPRIGHT', 2, 0)

	for _, header in next, {
		{ frame = list.ResultsListing.HeaderContainer, x = -20, y = -1 },
		cancelling.ResultsListing.HeaderContainer,
		selling.CurrentPricesListing.HeaderContainer,
		selling.HistoricalPriceListing.HeaderContainer,
		selling.ResultsListing.HeaderContainer
	} do
		if header.frame then
			SkinHeaders(header.frame, header.x, header.y)
		else
			SkinHeaders(header)
		end
	end

	-- duration radio buttons
	for _, duration in next, selling.AuctionatorSaleItem.Duration.radioButtons do
		if duration.RadioButton then
			S:HandleRadioButton(duration.RadioButton)
		end
	end

	-- undercut butttons, refresh button
	for _, child in next, { cancelling:GetChildren() } do
		if child.StartScanButton then
			S:HandleButton(child.StartScanButton)
		end
		if child.CancelNextButton then
			S:HandleButton(child.CancelNextButton)
		end
		if child.StartScanButton and child.CancelNextButton then
			child.StartScanButton:ClearAllPoints()
			child.StartScanButton:Point('RIGHT', child.CancelNextButton, 'LEFT', -3, 0)

			child.CancelNextButton:ClearAllPoints()
			child.CancelNextButton:Point('TOPRIGHT', cancelling, 'BOTTOMRIGHT', -2, -2)
		end
		if child.iconAtlas == 'UI-RefreshButton' then
			S:HandleButton(child)
			child:Size(24)
		end
	end

	for _, child in next, { selling.AuctionatorSaleItem:GetChildren() } do
		if child.iconAtlas == 'UI-RefreshButton' then
			S:HandleButton(child)
			child:Size(24)
		end
	end

	for _, frame in next, { recentList.ScrollBox, shoppingList.ScrollBox } do
		frame:StripTextures()
		frame:CreateBackdrop('Transparent')
		frame.backdrop:SetInside(frame)
	end
end

function module:SkinAuctionatorOptions()
	for _, frame in next, {
		_G.AuctionatorConfigSellingAllItemsFrame,
		_G.AuctionatorConfigBasicOptionsFrame,
		_G.AuctionatorConfigQuantitiesFrame,
		_G.AuctionatorConfigTooltipsFrame,
		_G.AuctionatorConfigShoppingFrame,
		_G.AuctionatorConfigSellingFrame,
		_G.AuctionatorConfigSellingShortcutsFrame,
		_G.AuctionatorConfigLIFOFrame, -- Selling: Items
		_G.AuctionatorConfigNotLIFOFrame, -- Selling: Gear/Pets
		_G.AuctionatorConfigCancellingFrame,
		_G.AuctionatorConfigProfileFrame,
		_G.AuctionatorConfigAdvancedFrame
	} do
		for i = 1, frame:GetNumChildren() do
			local child = select(i, frame:GetChildren())
			if child.Button then
				S:HandleButton(child.Button)
			elseif child.CheckBox then
				S:HandleCheckBox(child.CheckBox)
			elseif child.DropDown then
				S:HandleDropDownBox(child.DropDown)
			elseif child.InputBox then
				S:HandleEditBox(child.InputBox)
				SetOutsideText(child.InputBox, child.InputBox.backdrop, 6, 6)
			elseif child.MoneyInput then
				for x = 1, child.MoneyInput:GetNumChildren() do
					local box = select(x, child.MoneyInput:GetChildren())
					if box and box.iconAtlas then
						S:HandleEditBox(box)
						SkinMoneyInput(box, 30)
					end
				end
			elseif child.radioButtons then
				for _, duration in next, child.radioButtons do
					if duration.RadioButton then
						S:HandleRadioButton(duration.RadioButton)
					end
				end
			elseif child.Middle then
				local tex = child.Middle:GetTexture()
				if tex == 130828 or strmatch(tex, 'UI%-Panel%-Button') then
					S:HandleButton(child)
				end
			end
		end
	end
end

local function SkinExportCheckBox(frame)
	local checkbox = frame and frame.CheckBox
	if checkbox and not frame.isSkinned then -- isSkinned is set by HandleCheckBox
		S:HandleCheckBox(checkbox)

		checkbox:Size(30)

		if checkbox.Label then
			checkbox.Label:ClearAllPoints()
			checkbox.Label:Point('LEFT', checkbox.backdrop, 'RIGHT', 8, 0)
		end
	end
end

local function SkinImportExport()
	local export = _G.AuctionatorExportListFrame
	local import = _G.AuctionatorImportListFrame
	local copy = _G.AuctionatorCopyTextFrame

	copy:StripTextures()
	import:StripTextures()
	export:StripTextures()

	copy:SetTemplate('Transparent')
	import:SetTemplate('Transparent')
	export:SetTemplate('Transparent')

	copy.ScrollFrame:StripTextures()
	import.ScrollFrame:StripTextures()
	export.ScrollFrame:StripTextures()

	S:HandleScrollBar(copy.ScrollFrame.ScrollBar)
	S:HandleScrollBar(import.ScrollFrame.ScrollBar)
	S:HandleScrollBar(export.ScrollFrame.ScrollBar)

	S:HandleButton(export.SelectAll)
	S:HandleButton(export.UnselectAll)
	S:HandleButton(export.Export)
	S:HandleButton(import.Import)
	S:HandleButton(copy.Close)

	S:HandleCloseButton(export.CloseDialog)
	S:HandleCloseButton(import.CloseDialog)

	hooksecurefunc(export, 'AddToPool', function(self)
		SkinExportCheckBox(self.checkBoxPool[#self.checkBoxPool])
	end)

	for _, checkbox in next, export.checkBoxPool do
		SkinExportCheckBox(checkbox)
	end
end

local function SkinTextArea(frame)
	frame.Left:Hide()
	frame.Middle:Hide()
	frame.Right:Hide()

	frame:SetTemplate()
end

local function SkinItemFrame(frame)
	frame:StripTextures()
	frame:SetTemplate('Transparent')

	S:HandleButton(frame.Cancel)
	S:HandleButton(frame.ResetAllButton)
	S:HandleButton(frame.Finished)

	frame.ResetAllButton:Point('TOPLEFT', frame.Cancel, 'TOPRIGHT', 3, 0)

	frame.FilterKeySelector:StripTextures()
	frame.FilterKeySelector:CreateBackdrop()
	frame.FilterKeySelector.backdrop:SetOutside(frame.FilterKeySelector.Text, 5, 5)

	S:HandleNextPrevButton(frame.FilterKeySelector.Button)
	frame.FilterKeySelector.Button:ClearAllPoints()
	frame.FilterKeySelector.Button:Point('LEFT', frame.FilterKeySelector.backdrop, 'RIGHT', -1, 0)
	frame.FilterKeySelector.Button:Size(20)

	S:HandleCheckBox(frame.SearchContainer.IsExact)
	frame.SearchContainer.IsExact:Size(26)

	for _, textarea in next, {
		frame.LevelRange.MaxBox,
		frame.LevelRange.MinBox,
		frame.ItemLevelRange.MaxBox,
		frame.ItemLevelRange.MinBox,
		frame.PriceRange.MaxBox,
		frame.PriceRange.MinBox,
		frame.CraftedLevelRange.MaxBox,
		frame.CraftedLevelRange.MinBox,
		frame.SearchContainer.SearchString
	} do
		SkinTextArea(textarea)
	end

	for _, resetButton in next, {
		frame.LevelRange.ResetButton,
		frame.ItemLevelRange.ResetButton,
		frame.PriceRange.ResetButton,
		frame.CraftedLevelRange.ResetButton,
		frame.FilterKeySelector.ResetButton,
		frame.SearchContainer.ResetSearchStringButton
	} do
		S:HandleBlizzardRegions(resetButton)
		S:HandleCloseButton(resetButton)
		resetButton:SetHitRectInsets(1, 1, 1, 1)
	end
end

function module:SkinAuctionator()
	SkinMainFrames()
	SkinImportExport()

	SkinItemFrame(_G.AuctionatorShoppingItemFrame)
	--SkinItemFrame(_G.AuctionatorAddItemFrame)
	--SkinItemFrame(_G.AuctionatorEditItemFrame)
end

local function LoadSkin()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.au then
		return
	end

	if IsAddOnLoaded('Auctionator') then
		module:SkinAuctionatorOptions()

		hooksecurefunc(_G.AuctionatorSplashScreenMixin, 'OnLoad', module.SkinAuctionator)
	end
end

module:AddCallbackForAddon("Auctionator", LoadSkin)
