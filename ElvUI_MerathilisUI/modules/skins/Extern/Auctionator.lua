local MER, E, L, V, P, G = unpack(select(2, ...))
if not IsAddOnLoaded("AddOnSkins") then return end
local AS = unpack(AddOnSkins)

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, select = pairs, select

-- WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function AS:Auctionator(event, addon)
	if event == 'PLAYER_ENTERING_WORLD' then return end
	if event == 'AUCTION_HOUSE_SHOW' then
		local Frames = {
			_G["Atr_BasicOptionsFrame"],
			_G["Atr_TooltipsOptionsFrame"],
			_G["Atr_UCConfigFrame"],
			_G["Atr_StackingOptionsFrame"],
			_G["Atr_ScanningOptionsFrame"],
			_G["AuctionatorResetsFrame"],
			_G["Atr_ShpList_Options_Frame"],
			_G["AuctionatorDescriptionFrame"],
			_G["Atr_Stacking_List"],
			_G["Atr_ShpList_Frame"],
			_G["Atr_ListTabsTab1"],
			_G["Atr_ListTabsTab2"],
			_G["Atr_ListTabsTab3"],
			_G["Atr_FullScanResults"],
			_G["Atr_Adv_Search_Dialog"],
			_G["Atr_FullScanFrame"],
			_G["Atr_Error_Frame"],
		}

		for _, Frame in pairs(Frames) do
			AS:SkinFrame(Frame, "Transparent")
		end

		local MoneyEditBoxes = {
			'UC_5000000_MoneyInput',
			'UC_1000000_MoneyInput',
			'UC_200000_MoneyInput',
			'UC_50000_MoneyInput',
			'UC_10000_MoneyInput',
			'UC_2000_MoneyInput',
			'UC_500_MoneyInput',
			'Atr_StackPrice',
			'Atr_StartingPrice',
			'Atr_ItemPrice',
		}

		for _, MoneyEditBox in pairs(MoneyEditBoxes) do
			AS:SkinEditBox(_G[MoneyEditBox..'Gold'])
			AS:SkinEditBox(_G[MoneyEditBox..'Silver'])
			AS:SkinEditBox(_G[MoneyEditBox..'Copper'])
		end

		local DropDownBoxes = {
			_G["AuctionatorOption_Deftab"],
			_G["Atr_tipsShiftDD"],
			_G["Atr_deDetailsDD"],
			_G["Atr_scanLevelDD"],
			_G["Atr_Duration"],
			_G["Atr_DropDownSL"],
			_G["Atr_ASDD_Class"],
			_G["Atr_ASDD_Subclass"],
		}

		for _, DropDown in pairs(DropDownBoxes) do
			AS:SkinDropDownBox(DropDown)
		end

		for i = 1, _G["Atr_ShpList_Options_Frame"]:GetNumChildren() do
			local object = select(i, _G["Atr_ShpList_Options_Frame"]:GetChildren())
			if object:IsObjectType('Button') then
				AS:SkinButton(object)
			end
		end

		for i = 1, _G["AuctionatorResetsFrame"]:GetNumChildren() do
			local object = select(i, _G["AuctionatorResetsFrame"]:GetChildren())
			if object:IsObjectType('Button') then
				AS:SkinButton(object)
			end
		end

		local Buttons = {
			_G["Atr_Search_Button"],
			_G["Atr_Back_Button"],
			_G["Atr_Buy1_Button"],
			_G["Auctionator1Button"],
			_G["Atr_CreateAuctionButton"],
			_G["Atr_RemFromSListButton"],
			_G["Atr_AddToSListButton"],
			_G["Atr_SrchSListButton"],
			_G["Atr_MngSListsButton"],
			_G["Atr_NewSListButton"],
			_G["Atr_CheckActiveButton"],
			_G["AuctionatorCloseButton"],
			_G["Atr_CancelSelectionButton"],
			_G["Atr_FullScanStartButton"],
			_G["Atr_FullScanDone"],
			_G["Atr_CheckActives_Yes_Button"],
			_G["Atr_CheckActives_No_Button"],
			_G["Atr_Adv_Search_ResetBut"],
			_G["Atr_Adv_Search_OKBut"],
			_G["Atr_Adv_Search_CancelBut"],
			_G["Atr_Buy_Confirm_OKBut"],
			_G["Atr_Buy_Confirm_CancelBut"],
			_G["Atr_SaveThisList_Button"],
			_G["Atr_UCConfigFrame_Reset"],
			_G["Atr_StackingOptionsFrame_Edit"],
			_G["Atr_StackingOptionsFrame_New"],
			_G["Atr_FullScanButton"],
		}

		for _, Button in pairs(Buttons) do
 			AS:SkinButton(Button, true)
		end

		local EditBoxes = {
			_G["Atr_Batch_NumAuctions"],
			_G["Atr_Batch_Stacksize"],
			_G["Atr_Search_Box"],
			_G["Atr_AS_Searchtext"],
			_G["Atr_AS_Minlevel"],
			_G["Atr_AS_Maxlevel"],
			_G["Atr_AS_MinItemlevel"],
			_G["Atr_AS_MaxItemlevel"],
			_G["Atr_Starting_Discount"],
			_G["Atr_ScanOpts_MaxHistAge"],
		}

		for _, EditBox in pairs(EditBoxes) do
 			AS:SkinEditBox(EditBox)
		end

		AS:SkinCheckBox(_G["AuctionatorOption_Enable_Alt_CB"])
		AS:SkinCheckBox(_G["AuctionatorOption_Show_StartingPrice_CB"])
		AS:SkinCheckBox(_G["ATR_tipsVendorOpt_CB"])
		AS:SkinCheckBox(_G["ATR_tipsAuctionOpt_CB"])
		AS:SkinCheckBox(_G["ATR_tipsDisenchantOpt_CB"])
		AS:SkinCheckBox(_G["Atr_Adv_Search_Button"])
		AS:SkinCheckBox(_G["Atr_Exact_Search_Button"])

		AS:SkinFrame(_G["Atr_HeadingsBar"], 'Transparent')
		AS:SkinFrame(_G["Atr_Hlist"], 'Transparent')
		AS:SkinFrame(_G["Atr_Buy_Confirm_Frame"], 'Transparent')
		AS:SkinFrame(_G["Atr_CheckActives_Frame"], 'Transparent')
		AS:SkinFrame(_G["Atr_FullScanFrame"])

		AS:SkinScrollBar(_G["Atr_Hlist_ScrollFrameScrollBar"])

		_G["Atr_FullScanButton"]:ClearAllPoints()
		_G["Atr_FullScanButton"]:SetPoint('TOPRIGHT', _G["Auctionator1Button"], 'BOTTOMRIGHT', 0, -2)
		_G["Atr_deDetailsDDText"]:SetJustifyH('RIGHT')

		_G["Atr_HeadingsBar"]:SetHeight(19)

		_G["Atr_Hlist"]:SetWidth(196)
		_G["Atr_Hlist"]:ClearAllPoints()
		_G["Atr_Hlist"]:SetPoint('TOPLEFT', -195, -75)

		_G["Atr_SrchSListButton"]:SetWidth(196)
		_G["Atr_MngSListsButton"]:SetWidth(196)
		_G["Atr_NewSListButton"]:SetWidth(196)
		_G["Atr_CheckActiveButton"]:SetWidth(196)

		_G["Atr_ListTabs"]:SetPoint('BOTTOMRIGHT', _G["Atr_HeadingsBar"], 'TOPRIGHT', 8, 1)
		_G["Atr_Back_Button"]:SetPoint('TOPLEFT', _G["Atr_HeadingsBar"], 'TOPLEFT', 0, 19)

		_G["AuctionatorCloseButton"]:ClearAllPoints()
		_G["AuctionatorCloseButton"]:SetPoint('BOTTOMRIGHT', _G["Atr_Main_Panel"], 'BOTTOMRIGHT', -10, 10)
		_G["Atr_Buy1_Button"]:SetPoint('RIGHT', _G["AuctionatorCloseButton"], 'LEFT', -5, 0)
		_G["Atr_CancelSelectionButton"]:SetPoint('RIGHT', _G["Atr_Buy1_Button"], 'LEFT', -5, 0)

		AS:StripTextures(_G["Atr_SellControls_Tex"])
		AS:StyleButton(_G["Atr_SellControls_Tex"])
		_G["Atr_SellControls_Tex"]:SetTemplate('Default', true)

		AS:UnregisterSkinEvent('Auctionator', 'AUCTION_HOUSE_SHOW')

		for i = 1, _G["AuctionFrame"].numTabs do
			AS:SkinTab(_G["AuctionFrameTab"..i])
		end
	end
end

AS:RegisterSkin('Auctionator', AS.Auctionator, 'AUCTION_HOUSE_SHOW', 'ADDON_LOADED')