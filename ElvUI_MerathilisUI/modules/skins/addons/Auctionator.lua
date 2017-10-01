local MER, E, L, V, P, G = unpack(select(2, ...))
if not IsAddOnLoaded("AddOnSkins") then return end
local AS = unpack(AddOnSkins)

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, select = pairs, select

-- WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded

-- GLOBALS:

function AS:Auctionator(event)
	if addon == 'Blizzard_TradeSkillUI' or IsAddOnLoaded('Blizzard_TradeSkillUI') then 
		TradeSkillFrame:HookScript('OnShow', function() AS:SkinButton(Auctionator_Search, true) end)
		AS:UnregisterSkinEvent('Auctionator', event)
	end
	if event == 'PLAYER_ENTERING_WORLD' then return end
	if event == 'AUCTION_HOUSE_SHOW' then

		local Frames = {
			Atr_BasicOptionsFrame,
			Atr_TooltipsOptionsFrame,
			Atr_UCConfigFrame,
			Atr_StackingOptionsFrame,
			Atr_ScanningOptionsFrame,
			AuctionatorResetsFrame,
			Atr_ShpList_Options_Frame,
			AuctionatorDescriptionFrame,
			Atr_Stacking_List,
			Atr_ShpList_Frame,
			Atr_ListTabsTab1,
			Atr_ListTabsTab2,
			Atr_ListTabsTab3,
			Atr_FullScanResults,
			Atr_Adv_Search_Dialog,
			Atr_FullScanFrame,
			Atr_Error_Frame,
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
			AuctionatorOption_Deftab,
			Atr_tipsShiftDD,
			Atr_deDetailsDD,
			Atr_scanLevelDD,
			Atr_Duration,
			Atr_DropDownSL,
			Atr_ASDD_Class,
			Atr_ASDD_Subclass,
		}

		for _, DropDown in pairs(DropDownBoxes) do
			AS:SkinDropDownBox(DropDown)
		end

		for i = 1, Atr_ShpList_Options_Frame:GetNumChildren() do
			local object = select(i, Atr_ShpList_Options_Frame:GetChildren())
			if object:IsObjectType('Button') then
				AS:SkinButton(object)
			end
		end

		for i = 1, AuctionatorResetsFrame:GetNumChildren() do
			local object = select(i, AuctionatorResetsFrame:GetChildren())
			if object:IsObjectType('Button') then
				AS:SkinButton(object)
			end
		end

		local Buttons = {
			Atr_Search_Button,
			Atr_Back_Button,
			Atr_Buy1_Button,
			Auctionator1Button,
			Atr_CreateAuctionButton,
			Atr_RemFromSListButton,
			Atr_AddToSListButton,
			Atr_SrchSListButton,
			Atr_MngSListsButton,
			Atr_NewSListButton,
			Atr_CheckActiveButton,
			AuctionatorCloseButton,
			Atr_CancelSelectionButton,
			Atr_FullScanStartButton,
			Atr_FullScanDone,
			Atr_CheckActives_Yes_Button,
			Atr_CheckActives_No_Button,
			Atr_Adv_Search_ResetBut,
			Atr_Adv_Search_OKBut,
			Atr_Adv_Search_CancelBut,
			Atr_Buy_Confirm_OKBut,
			Atr_Buy_Confirm_CancelBut,
			Atr_SaveThisList_Button,
			Atr_UCConfigFrame_Reset,
			Atr_StackingOptionsFrame_Edit,
			Atr_StackingOptionsFrame_New,
			Atr_FullScanButton,
		}

		for _, Button in pairs(Buttons) do
 			AS:SkinButton(Button, true)
		end

		local EditBoxes = {
			Atr_Batch_NumAuctions,
			Atr_Batch_Stacksize,
			Atr_Search_Box,
			Atr_AS_Searchtext,
			Atr_AS_Minlevel,
			Atr_AS_Maxlevel,
			Atr_AS_MinItemlevel,
			Atr_AS_MaxItemlevel,
			Atr_Starting_Discount,
			Atr_ScanOpts_MaxHistAge,
		}

		for _, EditBox in pairs(EditBoxes) do
 			AS:SkinEditBox(EditBox)
		end

		AS:SkinCheckBox(AuctionatorOption_Enable_Alt_CB)
		AS:SkinCheckBox(AuctionatorOption_Show_StartingPrice_CB)
		AS:SkinCheckBox(ATR_tipsVendorOpt_CB)
		AS:SkinCheckBox(ATR_tipsAuctionOpt_CB)
		AS:SkinCheckBox(ATR_tipsDisenchantOpt_CB)
		AS:SkinCheckBox(Atr_Adv_Search_Button)
		AS:SkinCheckBox(Atr_Exact_Search_Button)

		AS:SkinFrame(Atr_HeadingsBar, 'Transparent')
		AS:SkinFrame(Atr_Hlist, 'Transparent')
		AS:SkinFrame(Atr_Buy_Confirm_Frame, 'Transparent')
		AS:SkinFrame(Atr_CheckActives_Frame, 'Transparent')
		AS:SkinFrame(Atr_FullScanFrame)

		AS:SkinScrollBar(Atr_Hlist_ScrollFrameScrollBar)

		Atr_FullScanButton:ClearAllPoints()
		Atr_FullScanButton:SetPoint('TOPRIGHT', Auctionator1Button, 'BOTTOMRIGHT', 0, -2)
		Atr_deDetailsDDText:SetJustifyH('RIGHT')

		Atr_HeadingsBar:SetHeight(19)

		Atr_Hlist:SetWidth(196)
		Atr_Hlist:ClearAllPoints()
		Atr_Hlist:SetPoint('TOPLEFT', -195, -75)

		Atr_SrchSListButton:SetWidth(196)
		Atr_MngSListsButton:SetWidth(196)
		Atr_NewSListButton:SetWidth(196)
		Atr_CheckActiveButton:SetWidth(196)

		Atr_ListTabs:SetPoint('BOTTOMRIGHT', Atr_HeadingsBar, 'TOPRIGHT', 8, 1)
		Atr_Back_Button:SetPoint('TOPLEFT', Atr_HeadingsBar, 'TOPLEFT', 0, 19)

		AuctionatorCloseButton:ClearAllPoints()
		AuctionatorCloseButton:SetPoint('BOTTOMRIGHT', Atr_Main_Panel, 'BOTTOMRIGHT', -10, 10)
		Atr_Buy1_Button:SetPoint('RIGHT', AuctionatorCloseButton, 'LEFT', -5, 0)
		Atr_CancelSelectionButton:SetPoint('RIGHT', Atr_Buy1_Button, 'LEFT', -5, 0)

		AS:StripTextures(Atr_SellControls_Tex)
		AS:StyleButton(Atr_SellControls_Tex)
		Atr_SellControls_Tex:SetTemplate('Default', true)

		AS:UnregisterSkinEvent('Auctionator', 'AUCTION_HOUSE_SHOW')

		for i = 1, AuctionFrame.numTabs do
			AS:SkinTab(_G["AuctionFrameTab"..i])
		end
	end
end

AS:RegisterSkin('Auctionator', AS.Auctionator, 'AUCTION_HOUSE_SHOW', 'ADDON_LOADED')