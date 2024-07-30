local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

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

local function buyIconName(frame)
	S:HandleIcon(frame.Icon, true)
	S:HandleIconBorder(frame.QualityBorder, frame.Icon.backdrop)
end

local function viewGroup(frame)
	if frame.GroupTitle then
		frame.GroupTitle:StripTextures()
		S:HandleButton(frame.GroupTitle, true)
	end
end

local function viewItem(frame)
	if frame.Icon.GetNumPoints and frame.Icon:GetNumPoints() > 0 then
		local pointsCache = {}

		for i = 1, frame.Icon:GetNumPoints() do
			local point, relativeTo, relativePoint, xOfs, yOfs = frame.Icon:GetPoint(i)

			if relativePoint == "TOPLEFT" then
				xOfs = xOfs + 2
				yOfs = yOfs - 2
			elseif relativePoint == "BOTTOMRIGHT" then
				xOfs = xOfs - 2
				yOfs = yOfs + 2
			end

			pointsCache[i] = { point, relativeTo, relativePoint, xOfs, yOfs }
		end

		frame.Icon:ClearAllPoints()

		for i = 1, #pointsCache do
			local pointData = pointsCache[i]
			frame.Icon:SetPoint(pointData[1], pointData[2], pointData[3], pointData[4], pointData[5])
		end
	end

	frame.EmptySlot:SetTexture(nil)
	frame.EmptySlot:Hide()

	frame:GetHighlightTexture():SetTexture(E.Media.Textures.White8x8)
	frame:GetHighlightTexture():SetVertexColor(1, 1, 1, 0.3)

	frame.IconSelectedHighlight:SetTexture(E.Media.Textures.White8x8)
	frame.IconSelectedHighlight:SetVertexColor(1, 1, 1, 0.4)

	frame:GetPushedTexture():SetTexture(E.Media.Textures.White8x8)
	frame:GetPushedTexture():SetVertexColor(1, 1, 0, 0.3)

	S:HandleIcon(frame.Icon, true)
	S:HandleIconBorder(frame.IconBorder, frame.Icon.backdrop)
end

local function configRadioButtonGroup(frame)
	for _, child in pairs(frame.radioButtons) do
		S:HandleRadioButton(child.RadioButton)
	end
end

local function configCheckbox(frame)
	S:HandleCheckBox(frame.CheckBox)
end

local function dropDownInternal(frame)
	S:HandleDropDownBox(frame, frame:GetWidth(), nil, true)
end

local function keyBindingConfig(frame)
	S:HandleButton(frame.Button)
end

local function bagUse(frame)
	frame.View:CreateBackdrop("Transparent")
	S:HandleTrimScrollBar(frame.View.ScrollBar)

	for _, child in pairs({ frame:GetChildren() }) do
		if child ~= frame.View then
			S:HandleButton(child)
		end
	end
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
	S:HandleDropDownBox(frame, frame:GetWidth(), nil, true)
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

	for _, child in pairs({ frame:GetChildren() }) do
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

local function shoppingTabFrame(frame)
	S:HandleButton(frame.NewListButton)
	S:HandleButton(frame.ImportButton)
	S:HandleButton(frame.ExportButton)
	S:HandleButton(frame.ExportCSV)

	frame.ShoppingResultsInset:StripTextures()
end

local function shoppingTabSearchOptions(frame)
	S:HandleEditBox(frame.SearchString)
	S:HandleButton(frame.ResetSearchStringButton)
	S:HandleButton(frame.SearchButton)
	S:HandleButton(frame.MoreButton)
	S:HandleButton(frame.AddToListButton)
end

local function shoppingTabContainer(frame)
	frame.Inset:StripTextures()
	frame.Inset:SetTemplate("Transparent")
	S:HandleTrimScrollBar(frame.ScrollBar)
end

local function shoppingTabContainerTabs(frame)
	HandleTab(frame.ListsTab)
	HandleTab(frame.RecentsTab)
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

	local function reskinResetButton(f, anchor, x, y)
		S:HandleButton(f)
		f:Size(20, 20)
		f:ClearAllPoints()
		f:SetPoint("LEFT", anchor, "RIGHT", x, y)
	end

	S:HandleEditBox(frame.SearchContainer.SearchString)
	S:HandleCheckBox(frame.SearchContainer.IsExact)

	reskinResetButton(frame.SearchContainer.ResetSearchStringButton, frame.SearchContainer.SearchString, 3, 0)
	reskinResetButton(frame.FilterKeySelector.ResetButton, frame.FilterKeySelector, 0, 3)
	reskinResetButton(frame.LevelRange.ResetButton, frame.LevelRange.MaxBox, 3, 0)
	reskinResetButton(frame.ItemLevelRange.ResetButton, frame.ItemLevelRange.MaxBox, 3, 0)
	reskinResetButton(frame.PriceRange.ResetButton, frame.PriceRange.MaxBox, 3, 0)
	reskinResetButton(frame.CraftedLevelRange.ResetButton, frame.CraftedLevelRange.MaxBox, 3, 0)
	reskinResetButton(frame.QualityContainer.ResetQualityButton, frame.QualityContainer, 200, 5)
	reskinResetButton(frame.ExpansionContainer.ResetExpansionButton, frame.ExpansionContainer, 200, 5)
	reskinResetButton(frame.TierContainer.ResetTierButton, frame.TierContainer, 200, 5)

	S:HandleButton(frame.Finished)
	S:HandleButton(frame.Cancel)
	S:HandleButton(frame.ResetAllButton)
end

local function exportTextFrame(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	module:CreateShadow(frame)

	S:HandleButton(frame.Close)
	S:HandleTrimScrollBar(frame.ScrollBar)
end

local function listExportFrame(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	module:CreateShadow(frame)

	S:HandleButton(frame.SelectAll)
	S:HandleButton(frame.UnselectAll)
	S:HandleButton(frame.Export)
	S:HandleCloseButton(frame.CloseDialog)
	S:HandleTrimScrollBar(frame.ScrollBar)
end

local function listImportFrame(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	module:CreateShadow(frame)

	S:HandleButton(frame.Import)
	S:HandleCloseButton(frame.CloseDialog)
	S:HandleTrimScrollBar(frame.ScrollBar)
end

local function splashFrame(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	module:CreateShadow(frame)

	S:HandleCloseButton(frame.Close)
	S:HandleCheckBox(frame.HideCheckbox.CheckBox)
	S:HandleTrimScrollBar(frame.ScrollBar)
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

local function buyCommodity(frame)
	S:HandleButton(frame.BackButton)
	frame:StripTextures()

	local container = frame.DetailsContainer
	if not container then
		return
	end

	S:HandleButton(container.BuyButton)
	S:HandleEditBox(container.Quantity)
	container.Quantity:SetTextInsets(0, 0, 0, 0)

	for _, child in pairs({ frame:GetChildren() }) do
		if child:IsObjectType("Button") and child.iconAtlas and child.iconAtlas == "UI-RefreshButton" then
			S:HandleButton(child)
			break
		end
	end
end

local function tryPostHook(...)
	local frame, method, hookFunc = ...
	if frame and method and _G[frame] and _G[frame][method] then
		hooksecurefunc(_G[frame], method, function(frame, ...)
			if not frame.__MERSkin then
				hookFunc(frame, ...)
				frame.__MERSkin = true
			end
		end)
	else
		module:Log("debug", "Failed to hook: " .. tostring(frame) .. " " .. tostring(method))
	end
end

function module:Auctionator()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.au then
		return
	end

	module:DisableAddOnSkins("Auctionator", false)

	-- widgets
	tryPostHook("AuctionatorBuyIconNameTemplateMixin", "SetItem", buyIconName)
	tryPostHook("AuctionatorGroupsViewGroupMixin", "SetName", viewGroup)
	tryPostHook("AuctionatorGroupsViewItemMixin", "SetItemInfo", viewItem)
	tryPostHook("AuctionatorConfigCheckboxMixin", "OnLoad", configCheckbox)
	tryPostHook("AuctionatorConfigHorizontalRadioButtonGroupMixin", "SetupRadioButtons", configRadioButtonGroup)
	tryPostHook("AuctionatorConfigMinMaxMixin", "OnLoad", configMinMax)
	tryPostHook("AuctionatorConfigMoneyInputMixin", "OnLoad", configMoneyInput)
	tryPostHook("AuctionatorConfigNumericInputMixin", "OnLoad", configNumericInput)
	tryPostHook("AuctionatorConfigRadioButtonGroupMixin", "SetupRadioButtons", configRadioButtonGroup)
	tryPostHook("AuctionatorDropDownInternalMixin", "Initialize", dropDownInternal)
	tryPostHook("AuctionatorFilterKeySelectorMixin", "OnLoad", filterKeySelector)
	tryPostHook("AuctionatorKeyBindingConfigMixin", "OnLoad", keyBindingConfig)
	tryPostHook("AuctionatorResultsListingMixin", "OnShow", resultsListing)
	tryPostHook("AuctionatorSaleItemMixin", "OnLoad", saleItem)
	tryPostHook("AuctionatorShoppingTabFrameMixin", "OnLoad", shoppingTabFrame)
	tryPostHook("AuctionatorShoppingTabSearchOptionsMixin", "OnLoad", shoppingTabSearchOptions)
	tryPostHook("AuctionatorShoppingTabListsContainerMixin", "OnLoad", shoppingTabContainer)
	tryPostHook("AuctionatorShoppingTabRecentsContainerMixin", "OnLoad", shoppingTabContainer)
	tryPostHook("AuctionatorShoppingTabContainerTabsMixin", "OnLoad", shoppingTabContainerTabs)
	tryPostHook("AuctionatorBagUseMixin", "OnLoad", bagUse)
	tryPostHook("AuctionatorSellingTabPricesContainerMixin", "OnLoad", sellingTabPricesContainer)
	tryPostHook("AuctionatorTabContainerMixin", "OnLoad", bottomTabButtons)
	tryPostHook("AuctionatorUndercutScanMixin", "OnLoad", undercutScan)

	-- tab frames
	tryPostHook("AuctionatorCancellingFrameMixin", "OnLoad", cancellingFrame)
	tryPostHook("AuctionatorConfigTabMixin", "OnLoad", configTab)
	tryPostHook("AuctionatorSellingTabMixin", "OnLoad", sellingTab)

	-- frames
	tryPostHook("AuctionatorConfigSellingFrameMixin", "OnLoad", configSellingFrame)
	tryPostHook("AuctionatorExportTextFrameMixin", "OnLoad", exportTextFrame)
	tryPostHook("AuctionatorListExportFrameMixin", "OnLoad", listExportFrame)
	tryPostHook("AuctionatorListImportFrameMixin", "OnLoad", listImportFrame)
	tryPostHook("AuctionatorItemHistoryFrameMixin", "Init", itemHistoryFrame)
	tryPostHook("AuctionatorCraftingInfoObjectiveTrackerFrameMixin", "OnLoad", craftingInfoObjectiveTrackerFrame)
	tryPostHook("AuctionatorCraftingInfoProfessionsFrameMixin", "OnLoad", craftingInfoProfessionsFrame)
	tryPostHook("AuctionatorShoppingItemMixin", "OnLoad", shoppingItem)
	tryPostHook("AuctionatorSplashScreenMixin", "OnLoad", splashFrame)
	tryPostHook("AuctionatorBuyCommodityFrameTemplateMixin", "OnLoad", buyCommodity)
end

module:AddCallbackForAddon("Auctionator")
