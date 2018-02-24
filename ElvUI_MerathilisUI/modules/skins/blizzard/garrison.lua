local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local select, pairs = select, pairs
-- WoW API
local CreateFrame = CreateFrame
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, GARRISON_NUM_BUILDING_SIZES,  HybridScrollFrame_GetOffset, GarrisonMissionFrameFollowers
-- GLOBALS: GarrisonShipyardFrameFollowers, GarrisonBuildingFrameFollowers, GarrisonRecruitSelectFrame, GarrisonLandingPageFollowerList
-- GLOBALS: GarrisonLandingPageShipFollowerList

local function styleGarrison()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true or E.private.skins.blizzard.garrison ~= true or E.private.muiSkins.blizzard.garrison ~= true then return end

	-- Landing page
	local GarrisonLandingPage = _G["GarrisonLandingPage"]
	for i = 1, 10 do
		select(i, GarrisonLandingPage:GetRegions()):Hide()
	end

	GarrisonLandingPage:Styling()
	_G["GarrisonMissionFrame"]:Styling()
	_G["GarrisonShipyardFrame"]:Styling()

	-- Report
	local Report = GarrisonLandingPage.Report
	Report.List:GetRegions():Hide()

	local scrollFrame = Report.List.listScroll
	local buttons = scrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]

		button.BG:Hide()

		local bg = CreateFrame("Frame", nil, button)
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
		bg:SetFrameLevel(button:GetFrameLevel() - 1)

		MERS:CreateBD(bg, .25)
	end

	for _, tab in pairs({Report.InProgress, Report.Available}) do
		tab:SetHighlightTexture("")

		tab.Text:ClearAllPoints()
		tab.Text:SetPoint("CENTER")

		local bg = CreateFrame("Frame", nil, tab)
		bg:SetFrameLevel(tab:GetFrameLevel() - 1)
		MERS:CreateBD(bg, .25)

		local selectedTex = bg:CreateTexture(nil, "BACKGROUND")
		selectedTex:SetAllPoints()
		selectedTex:SetColorTexture(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .2)
		selectedTex:Hide()
		tab.selectedTex = selectedTex

		if tab == Report.InProgress then
			bg:SetPoint("TOPLEFT", 5, 0)
			bg:SetPoint("BOTTOMRIGHT")
		else
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", -7, 0)
		end
	end

	hooksecurefunc("GarrisonLandingPageReport_SetTab", function(self)
		local unselectedTab = Report.unselectedTab

		unselectedTab:SetHeight(36)

		unselectedTab:SetNormalTexture("")
		unselectedTab.selectedTex:Hide()
		self:SetNormalTexture("")
		self.selectedTex:Show()
	end)

	-- Follower list
	local FollowerList = GarrisonLandingPage.FollowerList
	FollowerList:GetRegions():Hide()
	select(2, FollowerList:GetRegions()):Hide()

	-- LandingPage Follower Tab
	local FollowerTab = GarrisonLandingPage.FollowerTab

	-- Ship Follower list
	local FollowerList = GarrisonLandingPage.ShipFollowerList
	select(2, FollowerList:GetRegions()):Hide()
	FollowerList:GetRegions():Hide()

	-- Recruitment frame
	local selectFrame = _G["GarrisonRecruitSelectFrame"]
	selectFrame.GarrCorners:Hide()

	-- Ship Follower tab
	local FollowerTab = GarrisonLandingPage.ShipFollowerTab
	for i = 1, 2 do
		local trait = FollowerTab.Traits[i]

		trait.Border:Hide()

		local equipment = FollowerTab.EquipmentFrame.Equipment[i]

		equipment.BG:Hide()
		equipment.Border:Hide()
	end

	-- Building frame
	local GarrisonBuildingFrame = _G["GarrisonBuildingFrame"]
	for i = 1, 14 do
		select(i, GarrisonBuildingFrame:GetRegions()):Hide()
	end
	GarrisonBuildingFrame.GarrCorners:Hide()
	GarrisonBuildingFrame.TitleText:Show()

	GarrisonBuildingFrame:Styling()

	-- Tutorial button
	local MainHelpButton = GarrisonBuildingFrame.MainHelpButton
	MainHelpButton.Ring:Hide()
	MainHelpButton:SetPoint("TOPLEFT", GarrisonBuildingFrame, "TOPLEFT", -12, 12)

	-- Building list
	local BuildingList = GarrisonBuildingFrame.BuildingList
	BuildingList:DisableDrawLayer("BORDER")
	BuildingList.MaterialFrame:GetRegions():Hide()

	for i = 1, GARRISON_NUM_BUILDING_SIZES do
		local tab = BuildingList["Tab"..i]

		tab:GetNormalTexture():SetAlpha(0)

		local bg = CreateFrame("Frame", nil, tab)
		bg:SetPoint("TOPLEFT", 6, -7)
		bg:SetPoint("BOTTOMRIGHT", -6, 7)
		bg:SetFrameLevel(tab:GetFrameLevel()-1)
		MERS:CreateBD(bg, .25)
		tab.bg = bg

		local hl = tab:GetHighlightTexture()
		hl:SetColorTexture(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .1)
		hl:ClearAllPoints()
		hl:SetPoint("TOPLEFT", bg, 1, -1)
		hl:SetPoint("BOTTOMRIGHT", bg, -1, 1)
	end

	hooksecurefunc("GarrisonBuildingList_SelectTab", function(tab)
		local list = GarrisonBuildingFrame.BuildingList

		for i = 1, GARRISON_NUM_BUILDING_SIZES do
			local otherTab = list["Tab"..i]
			if i ~= tab:GetID() then
				otherTab.bg:SetBackdropColor(0, 0, 0, .25)
			end
		end
		tab.bg:SetBackdropColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .2)

		for _, button in pairs(list.Buttons) do
			if not button.styled then
				button.BG:Hide()

				local bg = CreateFrame("Frame", nil, button)
				bg:SetPoint("TOPLEFT", 44, -5)
				bg:SetPoint("BOTTOMRIGHT", 0, 6)
				bg:SetFrameLevel(button:GetFrameLevel()-1)
				MERS:CreateBD(bg, .25)

				button.SelectedBG:SetColorTexture(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .2)
				button.SelectedBG:ClearAllPoints()
				button.SelectedBG:SetPoint("TOPLEFT", bg, 1, -1)
				button.SelectedBG:SetPoint("BOTTOMRIGHT", bg, -1, 1)

				local hl = button:GetHighlightTexture()
				hl:SetColorTexture(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .1)
				hl:ClearAllPoints()
				hl:SetPoint("TOPLEFT", bg, 1, -1)
				hl:SetPoint("BOTTOMRIGHT", bg, -1, 1)

				button.styled = true
			end
		end
	end)

	-- Info box
	local InfoBox = GarrisonBuildingFrame.InfoBox
	local TownHallBox = GarrisonBuildingFrame.TownHallBox
	for i = 1, 25 do
		select(i, InfoBox:GetRegions()):Hide()
		select(i, TownHallBox:GetRegions()):Hide()
	end
	MERS:CreateBD(InfoBox, .25)
	MERS:CreateBD(TownHallBox, .25)

	local FollowerPortrait = InfoBox.FollowerPortrait
	FollowerPortrait:SetPoint("BOTTOMLEFT", 230, 10)
	FollowerPortrait.RemoveFollowerButton:ClearAllPoints()
	FollowerPortrait.RemoveFollowerButton:SetPoint("TOPRIGHT", 4, 4)

	-- Follower list
	local FollowerList = GarrisonBuildingFrame.FollowerList
	FollowerList:DisableDrawLayer("BACKGROUND")
	FollowerList:DisableDrawLayer("BORDER")

	-- Follower Recruitment Frame
	_G["GarrisonCapacitiveDisplayFrame"].backdrop:Styling()

	-- [[ Shipyard UI ]]
	local MissionTab = _G["GarrisonShipyardFrame"].MissionTab

	-- Ship Follower tab
	local FollowerTab = _G["GarrisonShipyardFrame"].FollowerTab
	for i = 1, 22 do
		select(i, FollowerTab:GetRegions()):Hide()
	end

	for i = 1, 2 do
		local trait = FollowerTab.Traits[i]
		trait.Border:Hide()

		local equipment = FollowerTab.EquipmentFrame.Equipment[i]
		equipment.BG:Hide()
		equipment.Border:Hide()
	end

	-- Mission page
	local MissionPage = MissionTab.MissionPage
	for i = 1, 15 do
		select(i, MissionPage:GetRegions()):Hide()
	end
	for i = 18, 20 do
		select(i, MissionPage:GetRegions()):Hide()
	end
	for i = 4, 8 do
		select(i, MissionPage.Stage:GetRegions()):Hide()
	end

	local bg = CreateFrame("Frame", nil, MissionPage.Stage)
	bg:SetPoint("TOPLEFT", 4, 1)
	bg:SetPoint("BOTTOMRIGHT", -4, -1)
	bg:SetFrameLevel(MissionPage.Stage:GetFrameLevel() - 1)
	MERS:CreateBD(bg)

	local overlay = MissionPage.Stage:CreateTexture()
	overlay:SetDrawLayer("ARTWORK", 3)
	overlay:SetAllPoints(bg)
	overlay:SetColorTexture(0, 0, 0, .5)

	local iconbg = select(16, MissionPage:GetRegions())
	iconbg:ClearAllPoints()
	iconbg:SetPoint("TOPLEFT", 3, -1)

	for i = 1, 10 do
		select(i, MissionPage.RewardsFrame:GetRegions()):Hide()
	end
	MERS:CreateBD(MissionPage.RewardsFrame, .25)

	for i = 1, 2 do
		local reward = MissionPage.RewardsFrame.Rewards[i]
		local icon = reward.Icon

		reward.BG:Hide()

		icon:SetDrawLayer("BORDER", 1)

		reward.ItemBurst:SetDrawLayer("BORDER", 2)

		MERS:CreateBD(reward, .15)
	end

	-- Shared templates
	local function onUpdateData(self)
		local followerFrame = self:GetParent()
		local followerScrollFrame = followerFrame.FollowerList.listScroll
		local buttons = followerScrollFrame.buttons

		for i = 1, #buttons do
			local button = buttons[i].Follower
			local portrait = button.PortraitFrame
			local name = button.Name

			if not button.restyled then
				name:SetWordWrap(false)
				button.BG:Hide()
				button.Selection:SetTexture("")
				button.AbilitiesBG:SetTexture("")

				MERS:CreateBD(button, .25)

				button.BusyFrame:SetAllPoints()

				local hl = button:GetHighlightTexture()
				hl:SetColorTexture(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .1)
				hl:ClearAllPoints()
				hl:SetPoint("TOPLEFT", 1, -1)
				hl:SetPoint("BOTTOMRIGHT", -1, 1)

				if portrait then
					MERS:ReskinGarrisonPortrait(portrait)
					portrait:ClearAllPoints()
					portrait:SetPoint("TOPLEFT")
				end

				button.restyled = true
			end

			if button.Selection:IsShown() then
				button:SetBackdropColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .2)
			else
				button:SetBackdropColor(0, 0, 0, .25)
			end

			if portrait then
				if portrait.PortraitRingQuality:IsShown() then
					portrait:SetBackdropBorderColor(portrait.PortraitRingQuality:GetVertexColor())
				else
					portrait:SetBackdropBorderColor(0, 0, 0)
				end
			end
		end
	end
	hooksecurefunc(_G.GarrisonMissionFrameFollowers, "UpdateData", onUpdateData)
	hooksecurefunc(_G.GarrisonLandingPageFollowerList, "UpdateData", onUpdateData)
end

S:AddCallbackForAddon("Blizzard_GarrisonUI", "mUIGarrison", styleGarrison)