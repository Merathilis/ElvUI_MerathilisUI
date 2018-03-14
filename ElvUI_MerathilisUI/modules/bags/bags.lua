local MER, E, L, V, P, G = unpack(select(2, ...))
local MERB = E:NewModule("mUIBags", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")
MERB.modName = L["Bags"]
_Bags = MERB

local cargBags = _cargBags

--Cache global variables
--Lua Variables
local select = select
local format = string.format
--WoW API / Variables
local CreateFrame = CreateFrame
local GetContainerNumFreeSlots = GetContainerNumFreeSlots
local PlaySound = PlaySound
local IsReagentBankUnlocked = IsReagentBankUnlocked
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

MERB.ItemClass = {}

function MERB:Tooltip_Show()
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(self.ttText)
	if self.ttText2 then
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(self.ttText2, self.ttText2desc, 1, 1, 1)
	end
	GameTooltip:Show()
end

function MERB:Tooltip_Hide()
	GameTooltip:Hide()
end

function MERB:OpenBags()
	cargBags.blizzard:Show()
end

function MERB:CloseBags()
	cargBags.blizzard:Hide()
end

local function CheckEquipmentSet(item)
	if not item.bagID or not item.slotID then return false end

	return item.isInSet
end

function MERB:IsConsumableItem(item)
	if item.rarity and item.rarity == 0 then return end

	if item.type then
		if item.type == GetItemClassInfo(0) then
			MERB.ItemClass[item.id] = "Consumables"
			return true
		end
	end
end

function MERB:Info()
	return L["|cffff0000WARNING, EXPERIMENTAL FEATURE|r"]
end

function MERB:Initialize()
	if E.private.bags.enable then return end
	if not E.db.mui.bags.enable then return end

	if E.db.mui.bags.bagWidth > 20 then E.db.mui.bags.bagWidth = 10 end
	if E.db.mui.bags.bankWidth > 20 then E.db.mui.bags.bankWidth = 12 end

	local mUI_ContainerFrame = cargBags:NewImplementation("mUI_ContainerFrame") -- Let the magic begin!
	mUI_ContainerFrame:RegisterBlizzard() -- register the frame for use with BLizzard's ToggleBag()-functions

	-- A highlight function styles the button if they match a certain condition
	local function highlightFunction(button, match)
		button:SetAlpha(match and 1 or 0.1)
	end

	local f = {}
	function mUI_ContainerFrame:OnInit()
		-- The filters control which items go into which container
		local INVERTED = -1 -- with inverted filters (using -1), everything goes into this bag when the filter returns false
		local onlyBags = function(item) return item.bagID >= BACKPACK_CONTAINER and item.bagID <= NUM_BAG_SLOTS and not CheckEquipmentSet(item) and not MERB:IsConsumableItem(item) end
		local onlyBank = function(item) return item.bagID == BANK_CONTAINER or item.bagID >= NUM_BAG_SLOTS+1 and item.bagID <= NUM_BAG_SLOTS + NUM_BANKBAGSLOTS and not CheckEquipmentSet(item) and not MERB:IsConsumableItem(item) end
		local onlyReagent = function(item) return item.bagID == REAGENTBANK_CONTAINER end
		local onlyBagSets = function(item) return CheckEquipmentSet(item) and not (item.bagID == BANK_CONTAINER or item.bagID >= NUM_BAG_SLOTS+1 and item.bagID <= NUM_BAG_SLOTS + NUM_BANKBAGSLOTS) end
		local onlyBagConsumables = function(item) return MERB:IsConsumableItem(item) and not (item.bagID == BANK_CONTAINER or item.bagID >= NUM_BAG_SLOTS+1 and item.bagID <= NUM_BAG_SLOTS + NUM_BANKBAGSLOTS) end
		local onlyBankSets = function(item) return CheckEquipmentSet(item) and not (item.bagID >= BACKPACK_CONTAINER and item.bagID <= NUM_BAG_SLOTS) end
		local onlyBankConsumables = function(item) return MERB:IsConsumableItem(item) and not (item.bagID >= BACKPACK_CONTAINER and item.bagID <= NUM_BAG_SLOTS) end
		-- local onlyRareEpics = function(item) return item.rarity and item.rarity > 3 end
		-- local onlyEpics = function(item) return item.rarity and item.rarity > 3 end
		-- local hideJunk = function(item) return not item.rarity or item.rarity > 0 end
		-- local hideEmpty = function(item) return item.texture ~= nil end

		local MyContainer = mUI_ContainerFrame:GetContainerClass()
		-- Bagpack
		f.main = MyContainer:New("Main", {
			Columns = E.db.mui.bags.bagWidth,
			Bags = "backpack+bags",
			Movable = false,
		})
		f.main:SetFilter(onlyBags, true)
		f.main:SetPoint("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -28, 50) -- bagpack position

		-- Bank frame and bank bags
		f.bank = MyContainer:New("Bank", {
			Columns = E.db.mui.bags.bankWidth,
			Bags = "bankframe+bank",
		})
		f.bank:SetFilter(onlyBank, true) -- Take only items from the bank frame
		f.bank:SetPoint("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 10, 50) -- bank frame position
		f.bank:Hide() -- Hide at the beginning

		-- Reagent frame and bank bags
		f.reagent = MyContainer:New("Reagent", {Columns = E.db.mui.bags.bankWidth, Bags = "bankreagent"})
		f.reagent:SetFilter(onlyReagent, true)
		f.reagent:Hide()
		f.reagent:SetPoint("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 10, 50)

		f.consumables = MyContainer:New("Consumables", {Columns = E.db.mui.bags.bagWidth, Bags = "backpack+bags"})
		f.consumables:SetFilter(onlyBagConsumables, true)
		f.consumables:SetParent(f.main)
		f.consumables:SetPoint("BOTTOMLEFT", f.main, "TOPLEFT", 0, 3)

		f.sets = MyContainer:New("ItemSets", {Columns = E.db.mui.bags.bagWidth, Bags = "backpack+bags"})
		f.sets:SetFilter(onlyBagSets, true)
		f.sets:SetParent(f.main)
		f.sets:SetPoint("BOTTOMLEFT", f.consumables, "TOPLEFT", 0, 3)

		f.bankconsumables = MyContainer:New("BankConsumables", {Columns = E.db.mui.bags.bankWidth, Bags = "backpack+bags"})
		f.bankconsumables:SetFilter(onlyBankConsumables, true)
		f.bankconsumables:SetParent(f.bank)
		f.bankconsumables:SetPoint("BOTTOMLEFT", f.bank,  "TOPLEFT", 0, 3)

		f.banksets = MyContainer:New("BankItemSets", {Columns = E.db.mui.bags.bankWidth, Bags = "bankframe+bank"})
		f.banksets:SetFilter(onlyBankSets, true)
		f.banksets:SetParent(f.bank)
		f.banksets:SetPoint("BOTTOMLEFT", f.bankconsumables, "TOPLEFT", 0, 3)
	end

	-- Bank frame toggling
	function mUI_ContainerFrame:OnBankOpened()
		BankFrame:Show()
		self:GetContainer("Bank"):Show()
	end

	function mUI_ContainerFrame:OnBankClosed()
		BankFrame:Hide()
		self:GetContainer("Bank"):Hide()
		self:GetContainer("Reagent"):Hide()
		ReagentBankFrame:Hide()
		BankFrame.selectedTab = 1
	end

	-- Class: ItemButton appearencence classification
	local MyButton = mUI_ContainerFrame:GetItemButtonClass()
	MyButton:Scaffold("ElvUI_MerathilisUI")
	function MyButton:OnUpdate(item)
		-- color the border based on bag type
		local bagType = select(2, GetContainerNumFreeSlots(self.bagID));
		-- ammo / soulshards
		if(bagType and (bagType > 0 and bagType < 8)) then
			self.Border:SetVertexColor(0.85, 0.85, 0.35, 1);
			-- profession bags
		elseif(bagType and bagType > 4) then
			self.Border:SetVertexColor(0.1, 0.65, 0.1, 1);
			-- normal bags
		else
			self.Border:SetVertexColor(.7, .7, .7, .9);
		end
	end

	-- Class: BagButton is the template for all buttons on the BagBar
	local BagButton = mUI_ContainerFrame:GetClass("BagButton", true, "BagButton")
	-- We color the CheckedTexture golden, not bright yellow
	function BagButton:OnCreate()
		self:GetCheckedTexture():SetVertexColor(0.3, 0.9, 0.9, 0.5)
	end

	-- Class: Container (Serves as a base for all containers/bags)
	-- Fetch our container class that serves as a basis for all our containers/bags

	local UpdateDimensions = function(self)
		local width, height = self:LayoutButtons("grid", self.Settings.Columns, 3, 6, -45)
		--local width, height = self:GetWidth(), self:GetHeight()
		local margin = 60 -- Normal margin space for infobar
		if self.BagBar and self.BagBar:IsShown() then
			margin = margin + 40 -- Bag button space
		end
		self:SetHeight(height + margin)
	end

	local MyContainer = mUI_ContainerFrame:GetContainerClass()
	function MyContainer:OnContentsChanged()
		-- sort our buttons based on the slotID
		self:SortButtons("bagSlot")
		-- Order the buttons in a layout, ("grid", columns, spacing, xOffset, yOffset) or ("circle", radius (optional), xOffset, yOffset)
		local width, height = self:LayoutButtons("grid", self.Settings.Columns, 3, 6, -45)
		self:SetSize(width + 12, height + 12)
		if (self.UpdateDimensions) then self:UpdateDimensions() end -- Update the bag's height
		if self.name == "ItemSets" or self.name == "Consumables" then
			local width, height = self:LayoutButtons("grid", self.Settings.Columns, 3, 6, -25)
			self:SetSize(width + 12, height + 32)
		end

		if self.name == "BankItemSets" or self.name == "BankConsumables" then
			local width, height = self:LayoutButtons("grid", self.Settings.Columns, 3, 6, -25)
			self:SetSize(width + 12, height + 32)
		end

		if mUI_ContainerFrameItemSets:GetHeight()<33 then
			f.sets:Hide()
		else
			f.sets:Show()
		end

		if mUI_ContainerFrameConsumables:GetHeight()<33 then
			f.consumables:Hide()
		else
			f.consumables:Show()
		end

		if mUI_ContainerFrameBankItemSets:GetHeight()<33 then
			f.banksets:Hide()
		else
			f.banksets:Show()
		end

		if mUI_ContainerFrameBankConsumables:GetHeight()<33 then
			f.bankconsumables:Hide()
		else
			f.bankconsumables:Show()
		end
	end

	-- OnCreate is called every time a new container is created
	function MyContainer:OnCreate(name, settings)
		settings = settings or {}
		self.Settings = settings
		self.UpdateDimensions = UpdateDimensions

		self:EnableMouse(true)

		self:CreateBackdrop("Transparent")
		self.backdrop:SetAllPoints()
		self:Styling()
		self:SetBackdropColor(0, 0, 0, 0.9)
		self:SetBackdropBorderColor(0, 0, 0, 0.8)

		self:SetParent(settings.Parent or mUI_ContainerFrame)
		self:SetFrameStrata("HIGH")

		if(settings.Movable) then
			self:SetMovable(true)
			self:RegisterForClicks("LeftButton", "RightButton")
			self:SetScript("OnMouseDown", function()
				self:ClearAllPoints()
				self:StartMoving()
			end)
		end
		self:SetScript("OnMouseUp", self.StopMovingOrSizing)

		settings.Columns = settings.Columns or 10
		if name == "Bank" or name == "Main" then -- don't need all that junk on "other" sections
			--Sort Button
			self.sortButton = CreateFrame("Button", nil, self)
			self.sortButton:Point("TOPLEFT", self, "TOPLEFT", 5, -4)
			self.sortButton:Size(16, 16)
			self.sortButton:SetNormalTexture("Interface\\ICONS\\INV_Pet_Broom")
			self.sortButton:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
			self.sortButton:SetPushedTexture("Interface\\ICONS\\INV_Pet_Broom")
			self.sortButton:GetPushedTexture():SetTexCoord(.08, .92, .08, .92)
			self.sortButton.pushed = true
			self.sortButton:StyleButton(true)
			self.sortButton.ttText = L["Sort"]
			self.sortButton:SetScript("OnEnter", MERB.Tooltip_Show)
			self.sortButton:SetScript("OnLeave", MERB.Tooltip_Hide)
			self.sortButton:SetScript("OnClick", function() MERB:CommandDecorator(MERB.SortBags, self.name == "Bank" and "bank" or "bags")() end)
			MERS:CreateBG(self.sortButton)

			--Bagbar Button
			self.bagsButton = CreateFrame("Button", nil, self)
			self.bagsButton:Point("LEFT", self.sortButton, "RIGHT", 3, 0)
			self.bagsButton:Size(16, 16)
			self.bagsButton:SetNormalTexture("Interface\\Buttons\\Button-Backpack-Up")
			self.bagsButton:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
			self.bagsButton:SetPushedTexture("Interface\\Buttons\\Button-Backpack-Up")
			self.bagsButton:GetPushedTexture():SetTexCoord(.08, .92, .08, .92)
			self.bagsButton.pushed = true
			self.bagsButton:StyleButton(true)
			self.bagsButton.ttText = L["BagBar"]
			self.bagsButton:SetScript("OnEnter", MERB.Tooltip_Show)
			self.bagsButton:SetScript("OnLeave", MERB.Tooltip_Hide)
			self.bagsButton:SetScript("OnClick", function()
				if(self.BagBar:IsShown()) then
					self.BagBar:Hide()
				else
					self.BagBar:Show()
				end
					self:UpdateDimensions()
				end)
			MERS:CreateBG(self.bagsButton)

			local infoFrame = CreateFrame("Button", nil, self)
			infoFrame:Point("TOPLEFT", self, "TOPLEFT", 5, -21)
			infoFrame:Point("TOPRIGHT", self, "TOPRIGHT", -5, -21)
			infoFrame:SetHeight(20)

			-- Plugin: TagDisplay: "Money"
			local tagDisplay = self:SpawnPlugin("TagDisplay", "[money]", infoFrame)
			tagDisplay:SetFont(E["media"].normFont, 12)
			tagDisplay:SetPoint("RIGHT", infoFrame, "RIGHT", 0, 0)

			-- Plugin: TagDisplay: "Bag Space"
			local space = self:SpawnPlugin("TagDisplay", "[space:free/max]", infoFrame)
			space:SetPoint("CENTER", infoFrame)
			space:SetFont(E["media"].normFont, 12)
			space.bags = cargBags:ParseBags("backpack+bags")

			-- Plugin: SearchBar
			local searchText = infoFrame:CreateFontString(nil, "OVERLAY")
			searchText:SetPoint("LEFT", infoFrame, "LEFT", 0, 0)
			searchText:SetFont(E["media"].normFont, 12)
			searchText:SetText(SEARCH) -- our searchbar comes up when we click on infoFrame

			local search = self:SpawnPlugin("SearchBar", infoFrame)
			search.highlightFunction = highlightFunction -- same as above, only for search
			search.isGlobal = true -- This would make the search apply to all containers instead of just this one
			search:ClearAllPoints()
			search:SetPoint("LEFT", infoFrame, 0, 0)
			search:SetPoint("RIGHT", infoFrame, 0, 0)
			search:SetHeight(20)
			self.Search.Left:Hide()
			self.Search.Right:Hide()
			self.Search.Center:Hide()
			S:HandleEditBox(self.Search)

			-- Plugin: BagBar
			local bagBar = self:SpawnPlugin("BagBar", settings.Bags)
			bagBar:SetSize(bagBar:LayoutButtons("grid", 7))
			bagBar.highlightFunction = highlightFunction -- from above, optional, used when hovering over bag buttons
			bagBar.isGlobal = true -- This would make the hover-effect apply to all containers instead of the current one
			bagBar:Hide()
			bagBar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 5, 5)
			self.BagBar = bagBar
			-- creating button for toggling BagBar on and off
			self:UpdateDimensions()

			local closebutton = CreateFrame("Button", nil, self)
			closebutton:SetFrameLevel(30)
			closebutton:SetSize(14, 14)
			MERS:ReskinClose(closebutton)
			closebutton:ClearAllPoints()
			closebutton:SetPoint("TOPRIGHT", -6, -3)

			closebutton:SetScript("OnClick", function(self)
				if mUI_ContainerFrame:AtBank() and self.name == "Bank" then
					CloseBankFrame()
				else
					CloseAllBags()
				end
			end)
		elseif name == "ItemSets" or name == "BankItemSets" then
			local setname = self:CreateFontString(nil,"OVERLAY")
			setname:SetPoint("TOPLEFT", self, "TOPLEFT",5,-5)
			setname:SetFont(E["media"].normFont, 12, "THINOUTLINE")
			setname:SetText(format(EQUIPMENT_SETS,' '))
		elseif name == "Consumables" or name == "BankConsumables" then
			local setname = self:CreateFontString(nil,"OVERLAY")
			setname:SetPoint("TOPLEFT", self, "TOPLEFT",5,-5)
			setname:SetFont(E["media"].normFont, 12, "THINOUTLINE")
			setname:SetText(L["Usable Items"])
		elseif name == "Reagent" then
			local reagentname = self:CreateFontString(nil,"OVERLAY")
			reagentname:SetPoint("TOPLEFT", self, "TOPLEFT",5,-5)
			reagentname:SetFont(E["media"].normFont, 12, "THINOUTLINE")
			reagentname:SetText(REAGENT_BANK)

			local closebutton = CreateFrame("Button", nil, self)
			closebutton:SetFrameLevel(30)
			closebutton:SetSize(14,14)
			MERS:ReskinClose(closebutton)
			closebutton:ClearAllPoints()
			closebutton:SetPoint("TOPRIGHT", -6, -3)

			closebutton:SetScript("OnClick", function(self)
				if mUI_ContainerFrame:AtBank() then
					CloseBankFrame()
				end
			end)

			--Sort Button
			self.sortButton = CreateFrame("Button", nil, self)
			self.sortButton:Point("TOPLEFT", self, "TOPLEFT", 5, -24)
			self.sortButton:Size(16, 16)
			self.sortButton:SetNormalTexture("Interface\\ICONS\\INV_Pet_Broom")
			self.sortButton:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
			self.sortButton:SetPushedTexture("Interface\\ICONS\\INV_Pet_Broom")
			self.sortButton:GetPushedTexture():SetTexCoord(.08, .92, .08, .92)
			self.sortButton.pushed = true
			self.sortButton:StyleButton(true)
			self.sortButton.ttText = L["Sort"]
			self.sortButton:SetScript("OnEnter", MERB.Tooltip_Show)
			self.sortButton:SetScript("OnLeave", MERB.Tooltip_Hide)
			self.sortButton:SetScript("OnClick", SortReagentBankBags)
			MERS:CreateBG(self.sortButton)

			--Deposit Button
			self.depositButton = CreateFrame("Button", nil, self)
			self.depositButton:Point("LEFT", self.sortButton, "RIGHT", 3, 0)
			self.depositButton:Size(16, 16)
			self.depositButton:SetNormalTexture("Interface\\ICONS\\misc_arrowdown")
			self.depositButton:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
			self.depositButton:SetPushedTexture("Interface\\ICONS\\misc_arrowdown")
			self.depositButton:GetPushedTexture():SetTexCoord(.08, .92, .08, .92)
			self.depositButton.pushed = true
			self.depositButton:StyleButton(true)
			self.depositButton.ttText = REAGENTBANK_DEPOSIT
			self.depositButton:SetScript("OnEnter", MERB.Tooltip_Show)
			self.depositButton:SetScript("OnLeave", MERB.Tooltip_Hide)
			self.depositButton:SetScript("OnClick", DepositReagentBank)
			MERS:CreateBG(self.depositButton)

			self.reagentToggle = CreateFrame("Button", nil, self)
			self.reagentToggle:Point("LEFT", self.depositButton, "RIGHT", 3, 0)
			self.reagentToggle:Size(16, 16)
			self.reagentToggle:SetNormalTexture("Interface\\Buttons\\Button-Backpack-Up")
			self.reagentToggle:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
			self.reagentToggle:SetPushedTexture("Interface\\Buttons\\Button-Backpack-Up")
			self.reagentToggle:GetPushedTexture():SetTexCoord(.08, .92, .08, .92)
			self.reagentToggle.pushed = true
			self.reagentToggle:StyleButton(true)
			self.reagentToggle.ttText = BANK
			self.reagentToggle:SetScript("OnEnter", MERB.Tooltip_Show)
			self.reagentToggle:SetScript("OnLeave", MERB.Tooltip_Hide)
			MERS:CreateBG(self.reagentToggle)
			self.reagentToggle:SetScript("OnClick", function()
				PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
				ReagentBankFrame:Hide()
				BankFrame.selectedTab = 1
				f.reagent:Hide()
				f.bank:Show()
			end)

			if not IsReagentBankUnlocked() then
				local buyReagent = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
				buyReagent:SetText(BANKSLOTPURCHASE)
				buyReagent:SetWidth(buyReagent:GetTextWidth() + 20)
				buyReagent:Point("TOPRIGHT", self, "TOPRIGHT", -6, -21)
				buyReagent:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					GameTooltip:AddLine(REAGENT_BANK_HELP, 1, 1, 1, true)
					GameTooltip:Show()
				end)
				buyReagent:SetScript("OnLeave", function()
					GameTooltip:Hide()
				end)
				buyReagent:SetScript("OnClick", function()
					StaticPopup_Show("CONFIRM_BUY_REAGENTBANK_TAB")
				end)
				buyReagent:SetScript("OnEvent", function(self, event)
					if event == "REAGENTBANK_PURCHASED" then
						f.reagent:OnContentsChanged()
					end
					if IsReagentBankUnlocked() then
						buyReagent:UnregisterAllEvents()
						buyReagent:Hide()
					end
				end)
				MERS:Reskin(buyReagent)
				buyReagent:RegisterEvent("REAGENTBANK_PURCHASED")
				buyReagent:RegisterEvent("PLAYER_ENTERING_WORLD")
			end
		end

		if name == "Bank" then
			local bankname = self:CreateFontString(nil,"OVERLAY")
			bankname:SetPoint("TOPLEFT", self, "TOPLEFT",5,-5)
			bankname:SetFont(E["media"].normFont, 12, "THINOUTLINE")
			bankname:SetText(BANK)

			self.sortButton:ClearAllPoints()
			self.sortButton:SetPoint("LEFT", bankname, "RIGHT", 5, 0)

			self.reagentToggle = CreateFrame("Button", nil, self)
			self.reagentToggle:Point("LEFT", self.bagsButton, "RIGHT", 3, 0)
			self.reagentToggle:Size(16, 16)
			self.reagentToggle:SetNormalTexture("Interface\\ICONS\\INV_Enchant_DustArcane")
			self.reagentToggle:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
			self.reagentToggle:SetPushedTexture("Interface\\ICONS\\INV_Enchant_DustArcane")
			self.reagentToggle:GetPushedTexture():SetTexCoord(.08, .92, .08, .92)
			self.reagentToggle.pushed = true
			self.reagentToggle:StyleButton(true)
			self.reagentToggle.ttText = REAGENT_BANK
			self.reagentToggle:SetScript("OnEnter", MERB.Tooltip_Show)
			self.reagentToggle:SetScript("OnLeave", MERB.Tooltip_Hide)
			MERS:CreateBG(self.reagentToggle)
			self.reagentToggle:SetScript("OnClick", function()
				PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
				ReagentBankFrame:Show()
				BankFrame.selectedTab = 2
				f.reagent:Show()
				if not IsReagentBankUnlocked() then
					f.reagent:SetSize(200, 50)
				end
				f.bank:Hide()
			end)
		end
		if name == "Main" or name == "ItemSets" or name == "Consumables" then
			self:HookScript("OnShow", function()
				E:GetModule('Tooltip'):GameTooltip_SetDefaultAnchor(GameTooltip)
			end)
			self:HookScript("OnHide", function()
				E:GetModule('Tooltip'):GameTooltip_SetDefaultAnchor(GameTooltip)
			end)
		end
	end

	self:OpenBags()
	self:CloseBags()
	self:RawHook("OpenBag", "OpenBags", true)
	self:HookScript(TradeFrame, "OnShow", "OpenBags")
	self:HookScript(TradeFrame, "OnHide", "CloseBags")
end

local function InitializeCallback()
	MERB:Initialize()
end

E:RegisterModule(MERB:GetName(), InitializeCallback)