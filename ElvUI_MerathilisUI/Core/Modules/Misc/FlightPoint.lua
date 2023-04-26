local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local S = E:GetModule('Skins')

local _G = _G
local next, pairs, table, getmetatable = next, pairs, table, getmetatable
local match = string.match
local strtrim = string.trim

local IsAddOnLoaded = IsAddOnLoaded

-- Credits liquidbase (DuffedUI)
local taxinodeinfos = {}
local firstshow = false
FlightPoints_Config = {}
FlightPoints_Config.notexpanded = {}

function FlightPoints_OnLoad(self)
	self:RegisterEvent("TAXIMAP_OPENED")
	self:RegisterEvent("TAXIMAP_CLOSED")
	self:RegisterEvent("ADDON_LOADED")
	FlightPointsTaxiChoiceContainerScrollBar.Show = function(self)
		FlightPointsTaxiChoiceContainer:SetPoint("BOTTOMRIGHT", FlightPointsTaxiChoice, "BOTTOMRIGHT", -23, 4)
		for _, button in next, _G["FlightPointsTaxiChoiceContainer"].buttons do
			button:SetWidth(228)
		end
		FlightPointsTaxiChoiceContainer.scrollChild:SetWidth(228)
		getmetatable(self).__index.Show(self)
	end

	FlightPointsTaxiChoiceContainerScrollBar.Hide = function (self)
		FlightPointsTaxiChoiceContainer:SetPoint("BOTTOMRIGHT", FlightPointsTaxiChoice, "BOTTOMRIGHT", -4, 4)
		for _, button in next, FlightPointsTaxiChoiceContainer.buttons do
			button:SetWidth(250)
		end
		FlightPointsTaxiChoiceContainer.scrollChild:SetWidth(250)
		getmetatable(self).__index.Hide( self )
	end
	FlightPointsTaxiChoiceContainer.update = FlightPointsTaxiChoiceContainer_Update
end

function FlightPointsTaxiChoiceButton_OnLoad(self)
	local name = self:GetName()
	self.name = _G[name.."Name"]
	self.expandIcon = _G[name.."ExpandIcon"]
	self.highlight = _G[name.."Highlight"]
	self.stripe = _G[name.."Stripe"]
end

function FlightPoints_Show()
	if not FlightPointsTaxiChoiceContainer.buttons then
		HybridScrollFrame_CreateButtons(FlightPointsTaxiChoiceContainer, "FlightPointsButtonTemplate", 1, -2, "TOPLEFT", "TOPLEFT", 0, 0)
	end
	FlightPointsTaxiChoiceContainer_Update()
end

function FlightPoints_GetFlight(index)
	if taxinodeinfos[index] then
		return taxinodeinfos[index].name, taxinodeinfos[index].isheader, taxinodeinfos[index].flightid, taxinodeinfos[index].isexpanded
	else
		return nil
	end
end

function FlightPointsTaxiChoiceContainer_Update()
	if not FlightPointsTaxiChoiceContainer.buttons then return end

	local buttons = FlightPointsTaxiChoiceContainer.buttons
	local button = buttons[1]
	local scrollFrame = FlightPointsTaxiChoiceContainer
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons
	local numButtons = #buttons
	local name, isHeader, flightpathid, isExpanded
	local button, index
	local hidebuttons = false
	local displayedHeight = 0
	for i = 1, numButtons do
		index = offset + i
		name, isHeader, flightpathid, isExpanded = FlightPoints_GetFlight(index)
		button = buttons[i]

		if not name or name == "" then
			button:Hide()
		else
			if isHeader then
				button.categoryLeft:Hide()
				button.categoryRight:Hide()
				button.categoryMiddle:Hide()
				hidebuttons = false
				button.highlight:Hide()
				button.name:FontTemplate(E.media.normFont, 13, "OUTLINE")
				button.name:SetText(name)
				button.name:SetTextColor(unpack(E.media.rgbvaluecolor))
				button.name:SetPoint("LEFT", 11, 0)
			else
				button.categoryLeft:Hide()
				button.categoryRight:Hide()
				button.categoryMiddle:Hide()
				button.highlight:SetTexture(E.media.normTex)
				button.highlight:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
				button.highlight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
				button.name:FontTemplate(E.media.normFont, 11, "OUTLINE")
				button.name:SetText(name)
				button.name:SetPoint("LEFT", 22, 0)
				button.flightpath = flightpathid
			end
			button.isHeader = isHeader
			button.isExpanded = isExpanded
			button.flightpathname = name
			button:Show()
		end
		displayedHeight = displayedHeight + button:GetHeight()
	end

	local totalHeight = #taxinodeinfos * (button:GetHeight())
	HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight)
end

function FlightPointsTaxiChoiceButton_OnClick(self, button, down)
	if self.isHeader then
		FlightPoints_CreateFlyPathTable()
		FlightPointsTaxiChoiceContainer_Update()
	else
		TakeTaxiNode(self.flightpath)
	end
end

function FlightPoints_TakeFlyPath(self)
	TakeTaxiNode(self.value)
end

local function pairsByKeys(t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0
	local iter = function ()
		i = i + 1
		if a[i] == nil then return nil else return a[i], t[a[i]] end
	end
	return iter
end

function FlightPoints_CreateFlyPathTable()
	local tmptaxinode={}
	taxinodeinfos = {}
	for i = 1, NumTaxiNodes() do
		if TaxiNodeGetType(i) == "REACHABLE" then
			local match1, match2 = match(TaxiNodeName(i), "^(.*),(.*)")
			if match2 == nil then
				match1 = TaxiNodeName(i)
				match2 = TaxiNodeName(i)
			end
			match1 = strtrim(match1)
			match2 = strtrim(match2)
			if not taxinodeinfos[match2] then taxinodeinfos[match2] = {} end
			taxinodeinfos[match2][match1] = i
		end
	end
	local runs = 1

	for key, val in pairsByKeys(taxinodeinfos) do
		tmptaxinode[runs] = {}
		tmptaxinode[runs].name = key
		tmptaxinode[runs].isheader = true
		tmptaxinode[runs].flightid = 0
		tmptaxinode[runs].isexpanded = true
		runs = runs + 1
		for key2, val2 in pairsByKeys(val) do
			tmptaxinode[runs] = {}
			tmptaxinode[runs].name = key2
			tmptaxinode[runs].isheader = false
			tmptaxinode[runs].flightid = val2
			tmptaxinode[runs].isexpanded = true
			runs = runs + 1
		end
	end
	taxinodeinfos = tmptaxinode
	firstshow = false
end

function FlightPoints_OnEvent(self, event, ...)
	local db = E.db.mui or {}

	if not (db and db.general) or type(db.general) ~= 'table' then
		db.general = {}
	end

	if not db.general.FlightPoint or IsAddOnLoaded("WorldFlightMap") then
		return
	end

	if event == "TAXIMAP_OPENED" then
		firstshow = true
		FlightPoints_CreateFlyPathTable()

		FlightPointsTaxiChoice:SetWidth(250)
		FlightPointsTaxiChoice:ClearAllPoints()

		if E.Retail then
			if _G["TaxiFrame"]:IsShown() then
				FlightPointsTaxiChoice:SetHeight(_G["TaxiFrame"]:GetHeight() - 24)
				FlightPointsTaxiChoice:SetPoint("TOPLEFT", _G["TaxiFrame"], "BOTTOMRIGHT", 0, _G["TaxiFrame"]:GetHeight() - 22)
			elseif _G["FlightMapFrame"]:IsShown() then
				FlightPointsTaxiChoice:SetHeight(_G["FlightMapFrame"]:GetHeight())
				FlightPointsTaxiChoice:SetPoint("TOPLEFT", _G["FlightMapFrame"], "BOTTOMRIGHT", 0, _G["FlightMapFrame"]:GetHeight())
			end
		elseif E.Classic then
			if _G["TaxiFrame"]:IsShown() then
				FlightPointsTaxiChoice:SetHeight(_G["TaxiFrame"]:GetHeight() - 50)
				FlightPointsTaxiChoice:SetPoint("TOPLEFT", _G["TaxiFrame"], "BOTTOMRIGHT", -22, _G["TaxiFrame"]:GetHeight())
			end
		end
		FlightPointsTaxiChoice:Show()
		FlightPointsTaxiChoice:StripTextures()
		FlightPointsTaxiChoice:CreateBackdrop("Transparent")
		S:HandleCloseButton(FlightPointsTaxiChoice.CloseButton)
		S:HandleScrollBar(FlightPointsTaxiChoiceContainerScrollBar)
		FlightPointsTaxiChoice.backdrop:Styling()
	elseif event == "TAXIMAP_CLOSED" then
		FlightPointsTaxiChoice:Hide()
		taxinodeinfos = {}
	end
end
