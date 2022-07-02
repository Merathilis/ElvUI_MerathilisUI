local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local pairs, select, unpack = pairs, select, unpack

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function UpdateFollowerQuality(self, followerInfo)
	if followerInfo then
		local color = E.QualityColors[followerInfo.quality or 1]
		self.Portrait.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
	end
end

local function UpdateFollowerList(self)
	local followerFrame = self:GetParent()
	local scrollFrame = followerFrame.FollowerList.listScroll
	local buttons = scrollFrame.buttons

	for i = 1, #buttons do
		local button = buttons[i].Follower
		local portrait = button.PortraitFrame

		if not button.restyled then
			button.BG:Hide()
			button.Selection:SetTexture("")
			button.AbilitiesBG:SetTexture("")
			button.bg = module:CreateBDFrame(button, .25)
			module:CreateGradient(button.bg)

			local hl = button:GetHighlightTexture()
			hl:SetColorTexture(r, g, b, .1)
			hl:ClearAllPoints()
			hl:SetInside(button.bg)

			if portrait then
				S:HandleGarrisonPortrait(portrait)
				portrait:ClearAllPoints()
				portrait:SetPoint("TOPLEFT", 4, -1)
				hooksecurefunc(portrait, "SetupPortrait", UpdateFollowerQuality)
			end

			if button.BusyFrame then
				button.BusyFrame:SetInside(button.bg)
			end

			button.restyled = true
		end

		if button.Counters then
			for i = 1, #button.Counters do
				local counter = button.Counters[i]
				if counter and not counter.backdrop then
					S:HandleIcon(counter.Icon, true)
				end
			end
		end

		if button.Selection:IsShown() then
			button.bg:SetBackdropColor(r, g, b, .2)
		else
			button.bg:SetBackdropColor(0, 0, 0, .25)
		end
	end
end

local function ReskinMissionFrame(self)
	self:StripTextures()
	self:Styling()
	module:CreateBackdropShadow(self)
	self.GarrCorners:Hide()
	if self.OverlayElements then self.OverlayElements:SetAlpha(0) end
	if self.ClassHallIcon then self.ClassHallIcon:Hide() end
	if self.TitleScroll then
		self.TitleScroll:StripTextures()
		select(4, self.TitleScroll:GetRegions()):SetTextColor(1, .8, 0)
	end

	for i = 1, 3 do
		local tab = _G[self:GetName().."Tab"..i]
		if tab then
			S:HandleTab(tab)
		end
	end

	if self.MapTab then
		self.MapTab.ScrollContainer.Child.TiledBackground:Hide()
	end

	self.FollowerTab:StripTextures()

	local missionList = self.MissionTab.MissionList
	missionList:StripTextures()

	local FollowerList = self.FollowerList
	FollowerList:StripTextures()
	hooksecurefunc(FollowerList, "UpdateFollowers", UpdateFollowerList)
end

local function LoadSkin()
	if not module:CheckDB("garrison", "garrison") then
		return
	end

	local frames = {
		_G.GarrisonCapacitiveDisplayFrame,
		_G.GarrisonMissionFrame,
		_G.GarrisonLandingPage,
		_G.GarrisonBuildingFrame,
		_G.GarrisonShipyardFrame,
		_G.OrderHallMissionFrame,
		_G.OrderHallCommandBar,
		_G.BFAMissionFrame,
		_G.CovenantMissionFrame
	}

	local tabs = {
		_G.GarrisonMissionFrameTab1,
		_G.GarrisonMissionFrameTab2,
		_G.GarrisonLandingPageTab1,
		_G.GarrisonLandingPageTab2,
		_G.GarrisonLandingPageTab3,
		_G.GarrisonShipyardFrameTab1,
		_G.GarrisonShipyardFrameTab2,
		_G.OrderHallMissionFrameTab1,
		_G.OrderHallMissionFrameTab2,
		_G.OrderHallMissionFrameTab3,
		_G.BFAMissionFrameTab1,
		_G.BFAMissionFrameTab2,
		_G.BFAMissionFrameTab3,
		_G.CovenantMissionFrameTab1,
		_G.CovenantMissionFrameTab2
	}

	for _, frame in pairs(frames) do
		if frame then
			module:CreateShadow(frame)
		end
	end

	for _, tab in pairs(tabs) do
		module:ReskinTab(tab)
	end

	-- Building frame
	local GarrisonBuildingFrame = _G.GarrisonBuildingFrame
	GarrisonBuildingFrame:StripTextures()
	if not GarrisonBuildingFrame.backdrop then
		GarrisonBuildingFrame:CreateBackdrop('Transparent')
	end
	GarrisonBuildingFrame.backdrop:Styling()

	-- Building level tooltip
	local BuildingLevelTooltip = GarrisonBuildingFrame.BuildingLevelTooltip
	BuildingLevelTooltip:Styling()

	-- [[ Capacitive display frame ]]
	local GarrisonCapacitiveDisplayFrame = _G.GarrisonCapacitiveDisplayFrame
	GarrisonCapacitiveDisplayFrame:Styling()

	-- [[ Landing page ]]
	local GarrisonLandingPage = _G.GarrisonLandingPage

	for i = 1, 10 do
		select(i, GarrisonLandingPage:GetRegions()):Hide() -- Parchment
	end

	GarrisonLandingPage:Styling()
	module:CreateBackdropShadow(GarrisonLandingPage)

	local followerList = GarrisonLandingPage.FollowerList
	followerList:StripTextures()
	hooksecurefunc(GarrisonLandingPageFollowerList, "UpdateFollowers", UpdateFollowerList)

	-- Report
	local Report = GarrisonLandingPage.Report
	local scrollFrame = Report.List.listScroll

	local buttons = scrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		button.BG:Hide()

		local bg = CreateFrame("Frame", nil, button, 'BackdropTemplate')
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
		bg:SetFrameLevel(button:GetFrameLevel() - 1)

		module:CreateBD(bg, .25)
		module:CreateGradient(bg)
	end

	for _, tab in pairs({Report.InProgress, Report.Available}) do
		tab:SetHighlightTexture("")
		tab.Text:ClearAllPoints()
		tab.Text:SetPoint("CENTER")

		local bg = CreateFrame("Frame", nil, tab, 'BackdropTemplate')
		bg:SetFrameLevel(tab:GetFrameLevel() - 1)
		bg:CreateBackdrop('Transparent')
		module:CreateGradient(bg.backdrop)

		local selectedTex = bg:CreateTexture(nil, "BACKGROUND")
		selectedTex:SetAllPoints()
		selectedTex:SetColorTexture(r, g, b, .2)
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

	local FollowerList = GarrisonLandingPage.FollowerList

	FollowerList:GetRegions():Hide()
	select(2, FollowerList:GetRegions()):Hide()

	-- Ship follower list
	local FollowerList = GarrisonLandingPage.ShipFollowerList

	FollowerList:GetRegions():Hide()
	select(2, FollowerList:GetRegions()):Hide()

	-- [[ Mission UI ]]
	local GarrisonMissionFrame = _G.GarrisonMissionFrame
	if GarrisonMissionFrame.backdrop then GarrisonMissionFrame.backdrop:Hide() end
	GarrisonMissionFrame:Styling()

	hooksecurefunc("GarrisonMissonListTab_SetSelected", function(tab, isSelected)
		if isSelected then
			tab.backdrop:SetBackdropColor(r, g, b, .2)
		else
			tab.backdrop:SetBackdropColor(0, 0, 0, .25)
		end
	end)

	-- [[ Monuments ]]
	local GarrisonMonumentFrame = _G.GarrisonMonumentFrame

	GarrisonMonumentFrame.Background:Hide()
	module:CreateBD(GarrisonMonumentFrame)
	GarrisonMonumentFrame:Styling()

	-- [[ Shipyard ]]
	local GarrisonShipyardFrame = _G.GarrisonShipyardFrame
	if GarrisonShipyardFrame.backdrop then GarrisonShipyardFrame.backdrop:Hide() end
	module:CreateBD(GarrisonShipyardFrame, .25)
	GarrisonShipyardFrame:Styling()

	local shipyardTab = GarrisonShipyardFrame.FollowerTab
	shipyardTab:DisableDrawLayer("BORDER")

	local shipyardMission = GarrisonShipyardFrame.MissionTab.MissionPage
	shipyardMission:StripTextures()

	local smbg = module:CreateBDFrame(shipyardMission.Stage)
	smbg:SetPoint("TOPLEFT", 4, 1)
	smbg:SetPoint("BOTTOMRIGHT", -4, -1)

	for i = 1, 10 do
		select(i, shipyardMission.RewardsFrame:GetRegions()):Hide()
	end
	module:CreateBD(shipyardMission.RewardsFrame, .25)

	GarrisonShipyardFrame.MissionCompleteBackground:GetRegions():Hide()
	GarrisonShipyardFrame.MissionTab.MissionList.CompleteDialog:GetRegions():Hide()

	-- [[ Orderhall UI]]

	local OrderHallMissionFrame = _G.OrderHallMissionFrame
	if OrderHallMissionFrame.backdrop then OrderHallMissionFrame.backdrop:Hide() end
	module:CreateBD(OrderHallMissionFrame, .25)
	OrderHallMissionFrame:Styling()

	 --Missions
	local Mission = _G.OrderHallMissionFrameMissions
	Mission.CompleteDialog:StripTextures()
	Mission.CompleteDialog:CreateBackdrop("Transparent")

	local MissionPage = _G.OrderHallMissionFrame.MissionTab.MissionPage
	for i = 1, 10 do
		select(i, MissionPage.RewardsFrame:GetRegions()):Hide()
	end
	module:CreateBD(MissionPage.RewardsFrame, .25)

	-- [[ BFA Mission UI]]
	local BFAMissionFrame = _G.BFAMissionFrame
	BFAMissionFrame:Styling()

	-- [[ Shadowlands Missions ]]
	local CovenantMissionFrame = _G.CovenantMissionFrame
	ReskinMissionFrame(CovenantMissionFrame)

	_G.CovenantMissionFrameMissions.RaisedFrameEdges:SetAlpha(0)

	hooksecurefunc(CovenantMissionFrame, "SetupTabs", function(self)
		self.MapTab:SetShown(not self.Tab2:IsShown())
	end)

	_G.CombatLog:DisableDrawLayer("BACKGROUND")
	_G.CombatLog.ElevatedFrame:SetAlpha(0)
	_G.CombatLog.CombatLogMessageFrame:StripTextures()
	module:CreateBDFrame(_G.CombatLog.CombatLogMessageFrame, .25)

	local bg = module:CreateBDFrame(CovenantMissionFrame.FollowerTab, .25)
	bg:SetPoint("TOPLEFT", 3, 2)
	bg:SetPoint("BOTTOMRIGHT", -3, -10)
	CovenantMissionFrame.FollowerTab.RaisedFrameEdges:SetAlpha(0)
	CovenantMissionFrame.FollowerTab.HealFollowerFrame.ButtonFrame:SetAlpha(0)
	_G.CovenantMissionFrameFollowers.ElevatedFrame:SetAlpha(0)
	_G.CovenantMissionFrameFollowersListScrollFrameScrollBar:DisableDrawLayer("BACKGROUND")
	_G.CovenantMissionFrameFollowersListScrollFrameScrollBar:CreateBackdrop('Transparent')
	module:CreateGradient(_G.CovenantMissionFrameFollowersListScrollFrameScrollBar.backdrop)
end

S:AddCallbackForAddon("Blizzard_GarrisonUI", LoadSkin)
