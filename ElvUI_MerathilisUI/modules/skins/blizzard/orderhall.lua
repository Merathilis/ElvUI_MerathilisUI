local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI")
local S = E:GetModule("Skins");
local LSM = LibStub("LibSharedMedia-3.0");

-- Cache global variables
-- Lua functions
local _G = _G
local ipairs = ipairs
-- WoW API / Variables
-- GLOBALS: OrderHallCommandBar

local isInit = false

local classColor = E.myclass == "PRIEST" and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

local function repositionOrderHallCommandBar()
	if not isInit then
		local isLoaded = true

		if not IsAddOnLoaded("Blizzard_OrderHallUI") then
			isLoaded = LoadAddOn("Blizzard_OrderHallUI")
		end

		if isLoaded then
			OrderHallCommandBar:ClearAllPoints()
			OrderHallCommandBar:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 2, -29)
			OrderHallCommandBar:SetParent(E.UIParent)
		end

		isInit = true

		return true
	end
end

local function styleOrderhall()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true or E.private.muiSkins.blizzard.orderhall ~= true then return end

	OrderHallCommandBar:SetWidth(600)

	OrderHallCommandBar.Currency:Hide()
	OrderHallCommandBar.CurrencyIcon:Hide()
	OrderHallCommandBar.CurrencyHitTest:Hide()

	OrderHallCommandBar.AreaName:ClearAllPoints()
	OrderHallCommandBar.AreaName:Point("LEFT", OrderHallCommandBar.Currency, "RIGHT", 0, 0)

	OrderHallCommandBar.WorldMapButton:Show()
	OrderHallCommandBar.WorldMapButton:ClearAllPoints()
	OrderHallCommandBar.WorldMapButton:SetPoint("RIGHT", 0, 0)
	OrderHallCommandBar.WorldMapButton:StripTextures()
	OrderHallCommandBar.WorldMapButton:SetTemplate("Transparent")
	S:HandleButton(OrderHallCommandBar.WorldMapButton)

	local mapButton = OrderHallCommandBar.WorldMapButton
	mapButton:Size(20,20)
	mapButton:SetNormalTexture("")
	mapButton:SetPushedTexture("")

	mapButton.Text = mapButton:CreateFontString(nil, "OVERLAY")
	mapButton.Text:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 13, nil)
	mapButton.Text:SetText("M")
	mapButton.Text:SetPoint("CENTER", -1, 0)

	mapButton:HookScript("OnEnter", function() mapButton.Text:SetTextColor(classColor.r, classColor.g, classColor.b) end)
	mapButton:HookScript("OnLeave", function() mapButton.Text:SetTextColor(1, 1, 1) end)
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	repositionOrderHallCommandBar()
	styleOrderhall()
end)