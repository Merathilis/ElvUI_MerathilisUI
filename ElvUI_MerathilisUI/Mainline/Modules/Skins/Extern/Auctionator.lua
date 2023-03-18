local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')
if not IsAddOnLoaded("Auctionator") then return end

local _G = _G
local hooksecurefunc = hooksecurefunc

-- modified from ElvUI Auction House Skin
local function HandleListIcon(frame)
	if not frame.tableBuilder then
		return
	end

	for i = 1, 22 do
		local row = frame.tableBuilder.rows[i]
		if row then
			for j = 1, 5 do
				local cell = row.cells and row.cells[j]
				if cell and cell.Icon then
					if not cell.__MERSkin then
						S:HandleIcon(cell.Icon)

						if cell.IconBorder then
							cell.IconBorder:Kill()
						end

						cell.__MERSkin = true
					end
				end
			end
		end
	end
end

-- modified from ElvUI Auction House Skin
local function HandleHeaders(frame)
	local maxHeaders = frame.HeaderContainer:GetNumChildren()
	for i, header in next, { frame.HeaderContainer:GetChildren() } do
		if not header.__MERSkin then
			header:DisableDrawLayer("BACKGROUND")

			if not header.backdrop then
				header:CreateBackdrop("Transparent")
			end

			header.__MERSkin = true
		end

		if header.backdrop then
			header.backdrop:Point("BOTTOMRIGHT", i < maxHeaders and -5 or 0, -2)
		end
	end

	HandleListIcon(frame)
end

local function HandleTab(tab)
	S:HandleTab(tab, nil, "Transparent")
	tab.Text:ClearAllPoints()
	tab.Text:SetPoint("CENTER", tab, "CENTER", 0, 0)
	tab.Text.__SetPoint = tab.Text.SetPoint
	tab.Text.SetPoint = E.noop
end

local function reskin(func)
	return function(frame, ...)
		if frame.__MERSkin then
			return
		end

		func(frame, ...)

		frame.__MERSkin = true
	end
end

local function bagClassListing(frame)
	frame.SectionTitle:StripTextures()
	S:HandleButton(frame.SectionTitle)
end

local function bagItemContainer(frame)
	if frame.buttonPool and frame.buttonPool.creatorFunc then
		local func = frame.buttonPool.creatorFunc
		frame.buttonPool.creatorFunc = function(...)
			local button = func(...)

			button.Icon:ClearAllPoints()
			button.Icon:SetSize(frame.iconSize - 4, frame.iconSize - 4)
			button.Icon:SetPoint("CENTER", button, "CENTER", 0, 0)

			button.EmptySlot:SetTexture(nil)
			button.EmptySlot:Hide()

			button:GetHighlightTexture():SetTexture(E.Media.Textures.White8x8)
			button:GetHighlightTexture():SetVertexColor(1, 1, 1, 0.3)

			button:GetPushedTexture():SetTexture(E.Media.Textures.White8x8)
			button:GetPushedTexture():SetVertexColor(1, 1, 0, 0.3)

			S:HandleIcon(button.Icon, true)
			S:HandleIconBorder(button.IconBorder, button.Icon.backdrop)

			return button
		end
	end
end

local function configRadioButtonGroup(frame)
	for _, child in pairs(frame.radioButtons) do
		S:HandleRadioButton(child.RadioButton)
	end
end

local function sellingBagFrame(frame)
	S:HandleScrollBar(frame.ScrollBar)
end

local function configNumericInput(frame)
	S:HandleEditBox(frame.InputBox)
	frame.InputBox:SetTextInsets(0, 0, 0, 0)
end

local function configMoneyInput(frame)
	S:HandleEditBox(frame.MoneyInput.CopperBox)
	S:HandleEditBox(frame.MoneyInput.GoldBox)
	S:HandleEditBox(frame.MoneyInput.SilverBox)

	frame.MoneyInput.CopperBox:SetTextInsets(3, 0, 0, 0)
	frame.MoneyInput.GoldBox:SetTextInsets(3, 0, 0, 0)
	frame.MoneyInput.SilverBox:SetTextInsets(3, 0, 0, 0)

	frame.MoneyInput.CopperBox:SetHeight(24)
	frame.MoneyInput.GoldBox:SetHeight(24)
	frame.MoneyInput.SilverBox:SetHeight(24)

	frame.MoneyInput.CopperBox.Icon:ClearAllPoints()
	frame.MoneyInput.CopperBox.Icon:SetPoint("RIGHT", frame.MoneyInput.CopperBox, "RIGHT", -10, 0)
	frame.MoneyInput.GoldBox.Icon:ClearAllPoints()
	frame.MoneyInput.GoldBox.Icon:SetPoint("RIGHT", frame.MoneyInput.GoldBox, "RIGHT", -10, 0)
	frame.MoneyInput.SilverBox.Icon:ClearAllPoints()
	frame.MoneyInput.SilverBox.Icon:SetPoint("RIGHT", frame.MoneyInput.SilverBox, "RIGHT", -10, 0)
end

local function configMinMax(frame)
	S:HandleEditBox(frame.MinBox)
	S:HandleEditBox(frame.MaxBox)
end

local function filterKeySelector(frame)
	S:HandleDropDownBox(frame)
end

local function undercutScan(frame)
	for _, child in pairs({ frame:GetChildren() }) do
		if child:GetObjectType() == "Button" then
			S:HandleButton(child)
		end
	end
end

local function saleItem(frame)
	frame.Icon:StripTextures()

	S:HandleIcon(frame.Icon.Icon, true)
	S:HandleIconBorder(frame.Icon.IconBorder, frame.Icon.Icon.backdrop)

	S:HandleButton(frame.MaxButton)
	frame.MaxButton:ClearAllPoints()
	frame.MaxButton:SetPoint("TOPLEFT", frame.Quantity, "TOPRIGHT", 0, 0)
	S:HandleButton(frame.PostButton)
	S:HandleButton(frame.SkipButton)

	for _, child in pairs({frame:GetChildren()}) do
		if child:IsObjectType("Button") and child.Icon then
			S:HandleButton(child)
		end
	end
end

local function bottomTabButtons(frame)
	for _, details in ipairs(_G.Auctionator.Tabs.State.knownTabs) do
		local tabButtonFrameName = "AuctionatorTabs_" .. details.name
		local tabButton = _G[tabButtonFrameName]

		if tabButton and not tabButton.__MERSkin then
			S:HandleTab(tabButton, nil, "Transparent")
			module:ReskinTab(tabButton)
			tabButton.Text:SetWidth(tabButton:GetWidth())
			if details.tabOrder > 1 then
				local pointData = { tabButton:GetPoint(1) }
				pointData[4] = -5
				tabButton:ClearAllPoints()
				tabButton:SetPoint(unpack(pointData))
			end

			tabButton.__MERSkin = true
		end
	end
end

local function scrollListShoppingList(frame)
	frame.Inset:StripTextures()
	frame.Inset:SetTemplate("Transparent")

	S:HandleTrimScrollBar(frame.ScrollBar)
end

local function scrollListRecents(frame)
	frame.Inset:StripTextures()
	frame.Inset:SetTemplate("Transparent")
	S:HandleTrimScrollBar(frame.ScrollBar)
end

local function tabRecentsContainer(frame)
	HandleTab(frame.ListTab)
	HandleTab(frame.RecentsTab)
end

local function sellingTabPricesContainer(frame)
	HandleTab(frame.CurrentPricesTab)
	HandleTab(frame.PriceHistoryTab)
	HandleTab(frame.YourHistoryTab)
end

local function resultsListing(frame)
	frame.ScrollArea:SetTemplate("Transparent")
	S:HandleTrimScrollBar(frame.ScrollArea.ScrollBar)

	HandleHeaders(frame)
	hooksecurefunc(frame, "UpdateTable", HandleHeaders)
end

local function shoppingTab(frame)
	if frame.OneItemSearch then
		S:HandleEditBox(frame.OneItemSearch.SearchBox)
		S:HandleButton(frame.OneItemSearch.SearchButton)
		S:HandleButton(frame.OneItemSearch.ExtendedButton)
	end

	S:HandleDropDownBox(frame.ListDropdown)

	S:HandleButton(frame.AddItem)
	S:HandleButton(frame.ManualSearch)
	S:HandleButton(frame.SortItems)
	S:HandleButton(frame.Import)
	S:HandleButton(frame.Export)
	S:HandleButton(frame.ExportCSV)

	frame.ShoppingResultsInset:StripTextures()
end

local function sellingTab(frame)
	frame.BagInset:StripTextures()
	frame.HistoricalPriceInset:StripTextures()
end

local function cancellingFrame(frame)
	S:HandleEditBox(frame.SearchFilter)

	for _, child in pairs({ frame:GetChildren() }) do
		if child:IsObjectType("Button") and child.Icon then
			S:HandleButton(child)
		end
	end

	frame.HistoricalPriceInset:StripTextures()
	frame.HistoricalPriceInset:SetTemplate("Transparent")
end

local function configTab(frame)
	frame.Bg:SetTexture(nil)
	frame.NineSlice:SetTemplate("Transparent")

	S:HandleButton(frame.OptionsButton)
	S:HandleButton(frame.ScanButton)

	S:HandleEditBox(frame.DiscordLink.InputBox)
	S:HandleEditBox(frame.BugReportLink.InputBox)
end

local function shoppingItem(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	module:CreateShadow(frame)

	S:HandleEditBox(frame.SearchContainer.SearchString)
	S:HandleButton(frame.SearchContainer.ResetSearchStringButton)
	frame.SearchContainer.ResetSearchStringButton:SetSize(20, 20)
	frame.SearchContainer.ResetSearchStringButton:ClearAllPoints()
	frame.SearchContainer.ResetSearchStringButton:SetPoint("LEFT", frame.SearchContainer.SearchString, "RIGHT", 3, 0)
	S:HandleCheckBox(frame.SearchContainer.IsExact)

	S:HandleButton(frame.FilterKeySelector.ResetButton)
	frame.FilterKeySelector.ResetButton:SetSize(20, 20)
	frame.FilterKeySelector.ResetButton:ClearAllPoints()
	frame.FilterKeySelector.ResetButton:SetPoint("LEFT", frame.FilterKeySelector, "RIGHT", 0, 3)

	S:HandleButton(frame.LevelRange.ResetButton)
	frame.LevelRange.ResetButton:SetSize(20, 20)
	frame.LevelRange.ResetButton:ClearAllPoints()
	frame.LevelRange.ResetButton:SetPoint("LEFT", frame.LevelRange.MaxBox, "RIGHT", 3, 0)

	S:HandleButton(frame.ItemLevelRange.ResetButton)
	frame.ItemLevelRange.ResetButton:SetSize(20, 20)
	frame.ItemLevelRange.ResetButton:ClearAllPoints()
	frame.ItemLevelRange.ResetButton:SetPoint("LEFT", frame.ItemLevelRange.MaxBox, "RIGHT", 3, 0)

	S:HandleButton(frame.PriceRange.ResetButton)
	frame.PriceRange.ResetButton:SetSize(20, 20)
	frame.PriceRange.ResetButton:ClearAllPoints()
	frame.PriceRange.ResetButton:SetPoint("LEFT", frame.PriceRange.MaxBox, "RIGHT", 3, 0)

	S:HandleButton(frame.CraftedLevelRange.ResetButton)
	frame.CraftedLevelRange.ResetButton:SetSize(20, 20)
	frame.CraftedLevelRange.ResetButton:ClearAllPoints()
	frame.CraftedLevelRange.ResetButton:SetPoint("LEFT", frame.CraftedLevelRange.MaxBox, "RIGHT", 3, 0)

	S:HandleDropDownBox(frame.QualityContainer.DropDown.DropDown)
	S:HandleButton(frame.QualityContainer.ResetQualityButton)
	frame.QualityContainer.ResetQualityButton:SetSize(20, 20)
	frame.QualityContainer.ResetQualityButton:ClearAllPoints()
	frame.QualityContainer.ResetQualityButton:SetPoint("LEFT", frame.QualityContainer.DropDown.DropDown, "RIGHT", 0, 3)

	if frame.TierContainer then
		frame.TierContainer:ClearAllPoints()
		frame.TierContainer:SetPoint("TOPLEFT", frame.QualityContainer, "BOTTOMLEFT", 0, -20)
		S:HandleDropDownBox(frame.TierContainer.DropDown.DropDown)
		S:HandleButton(frame.TierContainer.ResetTierButton)
		frame.TierContainer.ResetTierButton:SetSize(20, 20)
		frame.TierContainer.ResetTierButton:ClearAllPoints()
		frame.TierContainer.ResetTierButton:SetPoint("LEFT", frame.TierContainer.DropDown.DropDown, "RIGHT", 0, 3)
	end

	S:HandleButton(frame.Finished)
	S:HandleButton(frame.Cancel)
	S:HandleButton(frame.ResetAllButton)
end

local function exportTextFrame(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	module:CreateShadow(frame)

	S:HandleButton(frame.Close)
	S:HandleScrollBar(frame.ScrollFrame.ScrollBar)
end

local function listExportFrame(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	module:CreateShadow(frame)

	S:HandleButton(frame.SelectAll)
	S:HandleButton(frame.UnselectAll)
	S:HandleButton(frame.Export)
	S:HandleCloseButton(frame.CloseDialog)
	S:HandleScrollBar(frame.ScrollFrame.ScrollBar)
end

local function listImportFrame(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	module:CreateShadow(frame)

	S:HandleButton(frame.Import)
	S:HandleCloseButton(frame.CloseDialog)
	S:HandleScrollBar(frame.ScrollFrame.ScrollBar)
end

local function splashFrame(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	module:CreateShadow(frame)

	S:HandleCloseButton(frame.Close)
	S:HandleCheckBox(frame.HideCheckbox.CheckBox)
	S:HandleScrollBar(frame.ScrollFrame.ScrollBar)
end

local function itemHistoryFrame(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	module:CreateShadow(frame)

	S:HandleButton(frame.Close)
	S:HandleButton(frame.Dock)
end

local function configSellingFrame(frame)
	S:HandleButton(frame.UnhideAll)
end

local function craftingInfoObjectiveTrackerFrame(frame)
	S:HandleButton(frame.SearchButton)
end

local function craftingInfoProfessionsFrame(frame)
	S:HandleButton(frame.SearchButton)
end

function module:Auctionator()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.au then
		return
	end

	module:DisableAddOnSkins("Auctionator", false)

	-- widgets
	hooksecurefunc(_G.AuctionatorConfigHorizontalRadioButtonGroupMixin, "SetupRadioButtons", reskin(configRadioButtonGroup))
	hooksecurefunc(_G.AuctionatorConfigNumericInputMixin, "OnLoad", reskin(configNumericInput))
	hooksecurefunc(_G.AuctionatorBagClassListingMixin, "Init", reskin(bagClassListing))
	hooksecurefunc(_G.AuctionatorBagItemContainerMixin, "OnLoad", reskin(bagItemContainer))
	hooksecurefunc(_G.AuctionatorSellingBagFrameMixin, "OnLoad", reskin(sellingBagFrame))
	hooksecurefunc(_G.AuctionatorConfigMoneyInputMixin, "OnLoad", reskin(configMoneyInput))
	hooksecurefunc(_G.AuctionatorFilterKeySelectorMixin, "OnLoad", reskin(filterKeySelector))
	hooksecurefunc(_G.AuctionatorUndercutScanMixin, "OnLoad", reskin(undercutScan))
	hooksecurefunc(_G.AuctionatorSaleItemMixin, "OnLoad", reskin(saleItem))
	hooksecurefunc(_G.AuctionatorConfigMinMaxMixin, "OnLoad", reskin(configMinMax))
	hooksecurefunc(_G.AuctionatorTabContainerMixin, "OnLoad", reskin(bottomTabButtons))
	hooksecurefunc(_G.AuctionatorScrollListShoppingListMixin, "OnLoad", reskin(scrollListShoppingList))
	hooksecurefunc(_G.AuctionatorScrollListRecentsMixin, "OnLoad", reskin(scrollListRecents))
	hooksecurefunc(_G.AuctionatorShoppingTabRecentsContainerMixin, "OnLoad", reskin(tabRecentsContainer))
	hooksecurefunc(_G.AuctionatorResultsListingMixin, "OnShow", reskin(resultsListing))
	hooksecurefunc(_G.AuctionatorSellingTabPricesContainerMixin, "OnLoad", reskin(sellingTabPricesContainer))

	-- tab frames
	hooksecurefunc(_G.AuctionatorShoppingTabMixin, "OnLoad", reskin(shoppingTab))
	hooksecurefunc(_G.AuctionatorSellingTabMixin, "OnLoad", reskin(sellingTab))
	hooksecurefunc(_G.AuctionatorCancellingFrameMixin, "OnLoad", reskin(cancellingFrame))
	hooksecurefunc(_G.AuctionatorConfigTabMixin, "OnLoad", reskin(configTab))

	-- frames
	hooksecurefunc(_G.AuctionatorConfigSellingFrameMixin, "OnLoad", reskin(configSellingFrame))
	hooksecurefunc(_G.AuctionatorExportTextFrameMixin, "OnLoad", reskin(exportTextFrame))
	hooksecurefunc(_G.AuctionatorListExportFrameMixin, "OnLoad", reskin(listExportFrame))
	hooksecurefunc(_G.AuctionatorListImportFrameMixin, "OnLoad", reskin(listImportFrame))
	hooksecurefunc(_G.AuctionatorItemHistoryFrameMixin, "Init", reskin(itemHistoryFrame))
	hooksecurefunc(_G.AuctionatorCraftingInfoObjectiveTrackerFrameMixin, "OnLoad", reskin(craftingInfoObjectiveTrackerFrame))
	hooksecurefunc(_G.AuctionatorCraftingInfoProfessionsFrameMixin, "OnLoad", reskin(craftingInfoProfessionsFrame))
	hooksecurefunc(_G.AuctionatorShoppingItemMixin, "OnLoad", reskin(shoppingItem))
	hooksecurefunc(_G.AuctionatorSplashScreenMixin, "OnLoad", reskin(splashFrame))
end

module:AddCallbackForAddon("Auctionator")
