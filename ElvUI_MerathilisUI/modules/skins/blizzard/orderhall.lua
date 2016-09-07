local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI')
local S = E:GetModule('Skins');
local LSM = LibStub('LibSharedMedia-3.0');

-- Cache global variables
-- Lua functions
local _G = _G
local ipairs = ipairs
-- WoW API / Variables
local C_Garrison = C_Garrison
-- GLOBALS: OrderHallCommandBar

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

local function styleOrderhall()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true or E.private.muiSkins.blizzard.orderhall.enable ~= true then return end

	OrderHallCommandBar:ClearAllPoints()
	OrderHallCommandBar:SetPoint("TOPLEFT", E.UIParent, 2, -5)
	OrderHallCommandBar:SetWidth(500)

	if E.private.muiSkins.blizzard.orderhall.zoneText then
		OrderHallCommandBar.AreaName:ClearAllPoints()
		OrderHallCommandBar.AreaName:Point("LEFT", OrderHallCommandBar.CurrencyIcon, "RIGHT", 0,0)
		OrderHallCommandBar.AreaName:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 11, "OUTLINE")
		OrderHallCommandBar.AreaName:SetWordWrap(true)
	else
		OrderHallCommandBar.AreaName:Hide()
	end

	OrderHallCommandBar.Currency:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 12, "OUTLINE")

	OrderHallCommandBar.WorldMapButton:Show()
	OrderHallCommandBar.WorldMapButton:ClearAllPoints()
	OrderHallCommandBar.WorldMapButton:SetPoint("RIGHT", 0, 0)
	OrderHallCommandBar.WorldMapButton:StripTextures()
	OrderHallCommandBar.WorldMapButton:SetTemplate("Transparent")
	S:HandleButton(OrderHallCommandBar.WorldMapButton)

	local mapButton = OrderHallCommandBar.WorldMapButton
	mapButton:Size(20,20)
	mapButton:SetNormalTexture('')
	mapButton:SetPushedTexture('')

	mapButton.Text = mapButton:CreateFontString(nil, "OVERLAY")
	mapButton.Text:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 13, nil)
	mapButton.Text:SetText("M")
	mapButton.Text:SetPoint("CENTER", -1, 0)

	mapButton:HookScript('OnEnter', function() mapButton.Text:SetTextColor(classColor.r, classColor.g, classColor.b) end)
	mapButton:HookScript('OnLeave', function() mapButton.Text:SetTextColor(1, 1, 1) end)

	MER:StyleOutside(OrderHallCommandBar)

	E:CreateMover(OrderHallCommandBar, "OrderhallMover", L["Orderhall"])
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "Blizzard_OrderHallUI" then
		E:Delay(.5, styleOrderhall)
		self:UnregisterEvent("ADDON_LOADED")
	end
end)