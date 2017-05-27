local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins");
local LSM = LibStub("LibSharedMedia-3.0");

-- Cache global variables
-- Lua functions
local _G = _G
local ipairs = ipairs
-- WoW API / Variables
local C_Timer_After = C_Timer.After
-- GLOBALS: OrderHallCommandBar

local function styleOrderhall()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true or E.private.muiSkins.blizzard.orderhall ~= true then return end

	local b = OrderHallCommandBar
	if E.db.mui.general.HideOrderhallBar then
		b:SetScript("OnShow", b.Hide)
		b:Hide()
	end

	b:SetWidth(b.AreaName:GetStringWidth() + 500)

	b.Background:SetAtlas(nil)
	b.Currency:Hide()
	b.CurrencyIcon:Hide()
	b.CurrencyHitTest:Hide()

	b.AreaName:ClearAllPoints()
	b.AreaName:SetPoint("LEFT", b.Currency, "RIGHT", 0, 0)

	b.WorldMapButton:Show()
	b.WorldMapButton:ClearAllPoints()
	b.WorldMapButton:SetPoint("RIGHT", 0, 0)
	b.WorldMapButton:StripTextures()
	b.WorldMapButton:SetTemplate("Transparent")
	b.WorldMapButton:UnregisterAllEvents()
	S:HandleButton(b.WorldMapButton)

	local mapButton = b.WorldMapButton
	mapButton:Size(20, 20)
	mapButton:SetNormalTexture("")
	mapButton:SetPushedTexture("")

	mapButton.Text = mapButton:CreateFontString(nil, "OVERLAY")
	mapButton.Text:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 13, nil)
	mapButton.Text:SetText("M")
	mapButton.Text:SetPoint("CENTER", -1, 0)

	mapButton:HookScript("OnEnter", function() mapButton.Text:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b) end)
	mapButton:HookScript("OnLeave", function() mapButton.Text:SetTextColor(1, 1, 1) end)

	E:CreateMover(OrderHallCommandBar, "MER_OrderhallMover", L["Orderhall"], nil, nil, "ALL, SOLO")

	local combatAlly = OrderHallMissionFrameMissions.CombatAllyUI
	combatAlly:StripTextures()
	MERS:CreateBD(combatAlly, .25)

	-- Mission Frame
	OrderHallMissionFrameMissions.MaterialFrame:StripTextures()
	OrderHallMissionFrameMissionsListScrollFrame:StripTextures()

	OrderHallMissionFrame.MissionTab.MissionPage:StripTextures()

	OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage:StripTextures()
	MERS:CreateBD(OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage, .25)

	for i, v in ipairs(OrderHallMissionFrame.MissionTab.MissionList.listScroll.buttons) do
		local Button = _G["OrderHallMissionFrameMissionsListScrollFrameButton" .. i]
		if Button and not Button.skinned then
			Button:StripTextures()
			MERS:CreateBD(Button, .25)
			Button.LocBG:Kill() -- not cool
			Button.backdropTexture:Kill() -- not cool

			Button.isSkinned = true
		end
	end

	for i = 1, 2 do
		local tab = _G["OrderHallMissionFrameMissionsTab"..i]

		tab:StripTextures()
		tab:SetHeight(_G["GarrisonMissionFrameMissionsTab" .. i]:GetHeight() - 10)
		S:HandleButton(tab)
	end

	-- Missions
	local Mission = OrderHallMissionFrameMissions
	Mission.CompleteDialog:StripTextures()
	Mission.CompleteDialog:SetTemplate("Transparent")

	local MissionPage = OrderHallMissionFrame.MissionTab.MissionPage
	for i = 1, 10 do
		select(i, MissionPage.RewardsFrame:GetRegions()):Hide()
	end
	MERS:CreateBD(MissionPage.RewardsFrame, .25)
end

local OrderHallFollower = CreateFrame("Frame")
OrderHallFollower:RegisterEvent("ADDON_LOADED")
OrderHallFollower:SetScript("OnEvent", function(self, event, addon)
	if (event == "ADDON_LOADED" and addon == "Blizzard_OrderHallUI") then
		OrderHallFollower:RegisterEvent("DISPLAY_SIZE_CHANGED")
		OrderHallFollower:RegisterEvent("UI_SCALE_CHANGED")
		OrderHallFollower:RegisterEvent("GARRISON_FOLLOWER_CATEGORIES_UPDATED")
		OrderHallFollower:RegisterEvent("GARRISON_FOLLOWER_ADDED")
		OrderHallFollower:RegisterEvent("GARRISON_FOLLOWER_REMOVED")

	elseif event ~= "ADDON_LOADED" then
		local bar = OrderHallCommandBar

		local index = 1
		C_Timer_After(0.3, function() -- Give it a bit more time to collect.
			local last
			for i, child in ipairs({bar:GetChildren()}) do
				if child.Icon and child.Count and child.TroopPortraitCover then
					child:ClearAllPoints()
					child:SetPoint("LEFT", bar.AreaName, "RIGHT", 50 + (index - 1) * 120, 0)
					child:SetWidth(60)

					child.TroopPortraitCover:Hide()
					child.Icon:ClearAllPoints()
					child.Icon:SetPoint("LEFT", child, "LEFT", 0, 0)
					child.Icon:SetSize(32, 16)

					child.Count:ClearAllPoints()
					child.Count:SetPoint("LEFT", child.Icon, "RIGHT", 5, 0)
					child.Count:SetTextColor(.9, .9, .9)
					child.Count:SetShadowOffset(.75, -.75)

					last = child.Count

					index = index + 1
				end
			end
		end)
	end
end)

S:AddCallbackForAddon("Blizzard_OrderHallUI", "mUIOrderHall", styleOrderhall)