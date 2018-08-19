local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins");
local LSM = LibStub("LibSharedMedia-3.0")

-- Cache global variables
-- Lua functions
local _G = _G
local ipairs = ipairs
-- WoW API / Variables
local CreateFrame = CreateFrame

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc

local OrderHall_eframe = CreateFrame("Frame")
OrderHall_eframe:RegisterEvent("ADDON_LOADED")

OrderHall_eframe:SetScript("OnEvent", function(self, event, arg1)
	if E.private.muiSkins == nil then E.private.muiSkins = {} end
	if E.private.muiSkins.blizzard == nil then E.private.muiSkins.blizzard = {} end
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true or E.private.muiSkins.blizzard.orderhall ~= true then return end
	if event == "ADDON_LOADED" and arg1 == "Blizzard_OrderHallUI" then
		OrderHall_eframe:RegisterEvent("DISPLAY_SIZE_CHANGED")
		OrderHall_eframe:RegisterEvent("UI_SCALE_CHANGED")
		OrderHall_eframe:RegisterEvent("GARRISON_FOLLOWER_CATEGORIES_UPDATED")
		OrderHall_eframe:RegisterEvent("GARRISON_FOLLOWER_ADDED")
		OrderHall_eframe:RegisterEvent("GARRISON_FOLLOWER_REMOVED")

		OrderHallCommandBar:HookScript("OnShow", function()
			if not OrderHallCommandBar.styled then
				OrderHallCommandBar:EnableMouse(false)
				OrderHallCommandBar.Background:SetAtlas(nil)
				if OrderHallCommandBar.backdrop then
					OrderHallCommandBar.backdrop:Hide()
				end

				OrderHallCommandBar.ClassIcon:ClearAllPoints()
				OrderHallCommandBar.ClassIcon:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 10, -20)
				OrderHallCommandBar.ClassIcon:SetSize(40, 20)
				OrderHallCommandBar.ClassIcon:SetAlpha(1)
				local bg = MERS:CreateBDFrame(OrderHallCommandBar.ClassIcon, 0)
				MERS:CreateBD(bg, 1)

				OrderHallCommandBar.AreaName:ClearAllPoints()
				OrderHallCommandBar.AreaName:SetPoint("LEFT", OrderHallCommandBar.ClassIcon, "RIGHT", 5, 0)
				OrderHallCommandBar.AreaName:SetFont(E.media.normFont, 14, "OUTLINE")
				OrderHallCommandBar.AreaName:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
				OrderHallCommandBar.AreaName:SetShadowOffset(0, 0)

				OrderHallCommandBar.CurrencyIcon:ClearAllPoints()
				OrderHallCommandBar.CurrencyIcon:SetPoint("LEFT", OrderHallCommandBar.AreaName, "RIGHT", 5, 0)
				OrderHallCommandBar.Currency:ClearAllPoints()
				OrderHallCommandBar.Currency:SetPoint("LEFT", OrderHallCommandBar.CurrencyIcon, "RIGHT", 5, 0)
				OrderHallCommandBar.Currency:SetFont(E.media.normFont, 14, "OUTLINE")
				OrderHallCommandBar.Currency:SetTextColor(1, 1, 1)
				OrderHallCommandBar.Currency:SetShadowOffset(0, 0)

				OrderHallCommandBar.CurrencyHitTest:ClearAllPoints()
				OrderHallCommandBar.CurrencyHitTest:SetAllPoints(OrderHallCommandBar.CurrencyIcon)

				OrderHallCommandBar.WorldMapButton:Hide()

				OrderHallCommandBar.styled = true
			end
		end)
	elseif event ~= "ADDON_LOADED" then
		local index = 1
		C_Timer.After(0.1, function()
			for i, child in ipairs({OrderHallCommandBar:GetChildren()}) do
				if child.Icon and child.Count and child.TroopPortraitCover then
					child:SetPoint("TOPLEFT", OrderHallCommandBar.ClassIcon, "BOTTOMLEFT", -5, -index*25+20)
					child.TroopPortraitCover:Hide()

					child.Icon:SetSize(40, 20)
					local bg = MERS:CreateBDFrame(child.Icon, 0)
					MERS:CreateBD(bg, 1)

					child.Count:SetFont(E.media.normFont, 12, "OUTLINE")
					child.Count:SetTextColor(1, 1, 1)
					child.Count:SetShadowOffset(0, 0)

					index = index + 1
				end
			end
		end)
	end
end)
