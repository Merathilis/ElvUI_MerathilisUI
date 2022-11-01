local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
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

local function ReskinFollowerButton(button)
	if not button.IsSkinned then
		button.BG:Hide()
		button.Selection:SetTexture()
		button.AbilitiesBG:SetTexture()
		button:CreateBackdrop('Transparent')

		local hl = button:GetHighlightTexture()
		hl:SetColorTexture(r, g, b, .1)
		hl:ClearAllPoints()
		hl:SetInside(button.bg)

		local portrait = button.PortraitFrame
		if portrait then
			S:HandleGarrisonPortrait(portrait)
			portrait:ClearAllPoints()
			portrait:SetPoint("TOPLEFT", 4, -1)
			hooksecurefunc(portrait, "SetupPortrait", UpdateFollowerQuality)
		end

		if button.BusyFrame then
			button.BusyFrame:SetInside(button.bg)
		end

		button.styled = true
	end

	if button.Counters then
		for i = 1, #button.Counters do
			local counter = button.Counters[i]
			if counter and not counter.Icon.backdrop then
				S:HandleIcon(counter.Icon, true)
			end
		end
	end

	if button.Selection:IsShown() then
		button.backdrop:SetBackdropColor(r, g, b, .2)
	else
		button.backdrop:SetBackdropColor(0, 0, 0, .25)
	end
end

local function ReskinFollowerButtons(self)
	for i = 1, self.ScrollTarget:GetNumChildren() do
		local child = select(i, self.ScrollTarget:GetChildren())
		ReskinFollowerButton(child.Follower)
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
	hooksecurefunc(FollowerList.ScrollBox, "Update", ReskinFollowerButtons)
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
	-- hooksecurefunc(GarrisonLandingPageFollowerList, "UpdateFolloShowFollowers", UpdateFollowerList)

	-- Report
	local Report = GarrisonLandingPage.Report
	local scrollFrame = Report.List.listScroll

	--[[
	local buttons = scrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		button.BG:Hide()

		local bg = CreateFrame("Frame", nil, button, 'BackdropTemplate')
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
		bg:SetFrameLevel(button:GetFrameLevel() - 1)

		bg:CreateBackdrop('Transparent')
		module:CreateGradient(bg)
	end]]

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
	FollowerList = GarrisonLandingPage.ShipFollowerList

	FollowerList:GetRegions():Hide()
	select(2, FollowerList:GetRegions()):Hide()

	-- [[ Mission UI ]]
	local GarrisonMissionFrame = _G.GarrisonMissionFrame
	if GarrisonMissionFrame.backdrop then GarrisonMissionFrame.backdrop:Hide() end
	GarrisonMissionFrame:Styling()

	-- [[ Monuments ]]
	local GarrisonMonumentFrame = _G.GarrisonMonumentFrame

	GarrisonMonumentFrame.Background:Hide()
	GarrisonMonumentFrame:CreateBackdrop('Transparent')
	GarrisonMonumentFrame:Styling()

	-- [[ Shipyard ]]
	local GarrisonShipyardFrame = _G.GarrisonShipyardFrame
	if GarrisonShipyardFrame.backdrop then GarrisonShipyardFrame.backdrop:Hide() end
	GarrisonShipyardFrame:CreateBackdrop('Transparent')
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
	shipyardMission.RewardsFrame:CreateBackdrop('Transparent')

	GarrisonShipyardFrame.MissionCompleteBackground:GetRegions():Hide()
	GarrisonShipyardFrame.MissionTab.MissionList.CompleteDialog:GetRegions():Hide()

	-- [[ Orderhall UI]]

	local OrderHallMissionFrame = _G.OrderHallMissionFrame
	if OrderHallMissionFrame.backdrop then OrderHallMissionFrame.backdrop:Hide() end
	OrderHallMissionFrame:CreateBackdrop('Transparent')
	OrderHallMissionFrame:Styling()

	--Missions
	local Mission = _G.OrderHallMissionFrameMissions
	Mission.CompleteDialog:StripTextures()
	Mission.CompleteDialog:CreateBackdrop("Transparent")

	local MissionPage = _G.OrderHallMissionFrame.MissionTab.MissionPage
	for i = 1, 10 do
		select(i, MissionPage.RewardsFrame:GetRegions()):Hide()
	end
	MissionPage.RewardsFrame:CreateBackdrop('Transparent')

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

	-- AddOn Support
	local function reskinWidgetFont(font, r, g, b)
		if font and font.SetTextColor then
			font:SetTextColor(r, g, b)
		end
	end

	-- VenturePlan, 4.30 and higher
	if IsAddOnLoaded("VenturePlan") then
		local ANIMA_TEXTURE = 3528288
		local ANIMA_SPELLID = {[347555] = 3, [345706] = 5, [336327] = 35, [336456] = 250}
		local function GetAnimaMultiplier(itemID)
			local _, spellID = GetItemSpell(itemID)
			return ANIMA_SPELLID[spellID]
		end
		local function SetAnimaActualCount(self, text)
			local mult = GetAnimaMultiplier(self.__owner.itemID)
			if mult then
				if text == "" then text = 1 end
				text = text * mult
				self:SetFormattedText("%s", text)
				self.__owner.Icon:SetTexture(ANIMA_TEXTURE)
			end
		end
		local function AdjustFollowerList(self)
			if self.isSetting then return end
			self.isSetting = true

			local numFollowers = #C_Garrison.GetFollowers(123)
			self:SetHeight(135 + 60*ceil(numFollowers/5)) -- 5 follower per row, support up to 35 followers in the future

			self.isSetting = nil
		end

		local ReplacedRoleTex = {
			["adventures-tank"] = "Soulbinds_Tree_Conduit_Icon_Protect",
			["adventures-healer"] = "ui_adv_health",
			["adventures-dps"] = "ui_adv_atk",
			["adventures-dps-ranged"] = "Soulbinds_Tree_Conduit_Icon_Utility",
		}
		local function replaceFollowerRole(roleIcon, atlas)
			local newAtlas = ReplacedRoleTex[atlas]
			if newAtlas then
				roleIcon:SetAtlas(newAtlas)
			end
		end

		local function updateSelectedBorder(portrait, show)
			if show then
				portrait.__owner.bg:SetBackdropBorderColor(.6, 0, 0)
			else
				portrait.__owner.bg:SetBackdropBorderColor(0, 0, 0)
			end
		end

		local function updateActiveGlow(border, show)
			border.__shadow:SetShown(show)
		end

		local abilityIndex1, abilityIndex2
		local function GetAbilitiesIndex(frame)
			if not abilityIndex1 then
				for i = 1, frame:GetNumRegions() do
					local region = select(i, frame:GetRegions())
					if region then
						local width, height = region:GetSize()
						if E:Round(width) == 17 and E:Round(height) == 17 then
							if abilityIndex1 then
								abilityIndex2 = i
							else
								abilityIndex1 = i
							end
						end
					end
				end
			end
			return abilityIndex1, abilityIndex2
		end

		local function reskinFollowerAbility(frame, index, first)
			local ability = select(index, frame:GetRegions())
			ability:SetMask(nil)
			ability:SetSize(14, 14)
			S:HandleIcon(ability, true)
			ability.backdrop:SetFrameLevel(4)
			tinsert(frame.__abilities, ability)
			select(2, ability:GetPoint()):SetAlpha(0)
			ability:SetPoint("CENTER", frame, "LEFT", 11, first and 15 or 0)
		end

		local function updateVisibleAbilities(self)
			local showHealth = self.__owner.__health:IsShown()
			for _, ability in pairs(self.__owner.__abilities) do
				ability:SetDesaturated(not showHealth)
				ability.backdrop:SetShown(ability:IsShown())
			end
			self.__owner.__role:SetDesaturated(not showHealth)
		end

		local function fixAnchorForModVP(self, _, x, y)
			if x == 5 and y == -18 then
				self:SetPoint("CENTER", self.__owner, 1, 0)
			end
		end

		local VPFollowers, VPTroops, VPBooks, numButtons = {}, {}, {}, 0
		function _G.VPEX_OnUIObjectCreated(otype, widget, peek)
			if widget:IsObjectType("Frame") then
				if otype == "MissionButton" then
					S:HandleButton(peek("ViewButton"))
					S:HandleButton(peek("DoomRunButton"))
					S:HandleButton(peek("TentativeClear"))
					if peek("GroupHints") then
						S:HandleButton(peek("GroupHints"))
					end
					reskinWidgetFont(peek("Description"), 1, 1, 1)
					reskinWidgetFont(peek("enemyHP"), 1, 1, 1)
					reskinWidgetFont(peek("enemyATK"), 1, 1, 1)
					reskinWidgetFont(peek("animaCost"), .6, .8, 1)
					reskinWidgetFont(peek("duration"), 1, .8, 0)
					reskinWidgetFont(widget.CDTDisplay:GetFontString(), 1, .8, 0)
				elseif otype == "CopyBoxUI" then
					S:HandleButton(widget.ResetButton)
					S:HandleCloseButton(widget.CloseButton2)
					reskinWidgetFont(widget.Intro, 1, 1, 1)
					S:HandleEditBox(widget.FirstInputBox)
					reskinWidgetFont(widget.FirstInputBoxLabel, 1, .8, 0)
					S:HandleEditBox(widget.SecondInputBox)
					reskinWidgetFont(widget.SecondInputBoxLabel, 1, .8, 0)
					reskinWidgetFont(widget.VersionText, 1, 1, 1)
				elseif otype == "MissionList" then
					widget:StripTextures()
					local background = widget:GetChildren()
					background:StripTextures()
					module:CreateBDFrame(background, .25)
				elseif otype == "MissionPage" then
					widget:StripTextures()
					S:HandleButton(peek("UnButton"))
					S:HandleButton(peek("StartButton"))
					peek("StartButton"):SetText("|T"..MER.Media.Textures.arrowUp..":16|t")
				elseif otype == "ILButton" then
					widget:DisableDrawLayer("BACKGROUND")
					local bg = module:CreateBDFrame(widget, .25)
					bg:SetPoint("TOPLEFT", -3, 1)
					bg:SetPoint("BOTTOMRIGHT", 2, -2)
					module:CreateBDFrame(widget.Icon, .25)
				elseif otype == "IconButton" then
					S:HandleIcon(widget.Icon)
					widget:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
					widget:SetPushedTexture(nil)
					widget:SetSize(46, 46)
					tinsert(VPBooks, widget)
				elseif otype == "AdventurerRoster" then
					widget:StripTextures()
					module:CreateBDFrame(widget, .25)
					hooksecurefunc(widget, "SetHeight", AdjustFollowerList)
					S:HandleButton(peek("HealAllButton"))

					for i, troop in pairs(VPTroops) do
						troop:ClearAllPoints()
						troop:SetPoint("TOPLEFT", (i-1)*60+5, -35)
					end
					for i, follower in pairs(VPFollowers) do
						follower:ClearAllPoints()
						follower:SetPoint("TOPLEFT", ((i-1)%5)*60+5, -floor((i-1)/5)*60-130)
					end
					for i, book in pairs(VPBooks) do
						book:ClearAllPoints()
						book:SetPoint("BOTTOMLEFT", 24, -46 + i*50)
					end
				elseif otype == "AdventurerListButton" then
					widget.bg = module:CreateBDFrame(peek("Portrait"), 1)
					peek("Hi"):SetColorTexture(1, 1, 1, .25)
					peek("Hi"):SetInside(widget.bg)
					peek("PortraitR"):Hide()
					peek("PortraitT"):SetTexture(nil)
					peek("PortraitT").__owner = widget
					hooksecurefunc(peek("PortraitT"), "SetShown", updateSelectedBorder)

					numButtons = numButtons + 1
					if numButtons > 2 then
						peek("UsedBorder"):SetTexture(nil)
						peek("UsedBorder").__shadow = module:CreateSD(peek("Portrait"), 5, true)
						peek("UsedBorder").__shadow:SetBackdropBorderColor(peek("UsedBorder"):GetVertexColor())
						hooksecurefunc(peek("UsedBorder"), "SetShown", updateActiveGlow)
						tinsert(VPFollowers, widget)
					else
						tinsert(VPTroops, widget)
					end

					peek("HealthBG"):ClearAllPoints()
					peek("HealthBG"):SetPoint("TOPLEFT", peek("Portrait"), "BOTTOMLEFT", 0, 10)
					peek("HealthBG"):SetPoint("BOTTOMRIGHT", peek("Portrait"), "BOTTOMRIGHT")
					local line = widget:CreateTexture(nil, "ARTWORK")
					line:SetColorTexture(0, 0, 0)
					line:SetSize(peek("HealthBG"):GetWidth(), E.mult)
					line:SetPoint("BOTTOM", peek("HealthBG"), "TOP")

					peek("Health"):SetHeight(10)
					peek("HealthFrameR"):Hide()
					peek("TextLabel"):SetFontObject("Game12Font")
					peek("TextLabel"):ClearAllPoints()
					peek("TextLabel"):SetPoint("CENTER", peek("HealthBG"), 1, 0)
					peek("TextLabel").__owner = peek("HealthBG")
					hooksecurefunc(peek("TextLabel"), "SetPoint", fixAnchorForModVP)

					peek("Favorite"):ClearAllPoints()
					peek("Favorite"):SetPoint("TOPLEFT", -2, 2)
					peek("Favorite"):SetSize(30, 30)
					peek("Blip"):SetSize(18, 20)
					peek("Blip"):SetPoint("BOTTOMRIGHT", -8, 12)
					peek("RoleB"):Hide()
					peek("Role"):ClearAllPoints()
					peek("Role"):SetPoint("CENTER", widget.bg, "TOPRIGHT", -2, -2)
					hooksecurefunc(peek("Role"), "SetAtlas", replaceFollowerRole)

					local frame = peek("Health"):GetParent()
					if frame then
						frame.__abilities = {}
						frame.__health = peek("Health")
						frame.__role = peek("Role")
						local index1, index2 = GetAbilitiesIndex(frame)
						reskinFollowerAbility(frame, index1, true)
						reskinFollowerAbility(frame, index2)
						peek("HealthBG").__owner = frame
						hooksecurefunc(peek("HealthBG"), "SetGradient", updateVisibleAbilities)
					end
				elseif otype == "ProgressBar" then
					widget:StripTextures()
					module:CreateBDFrame(widget, 1)
				elseif otype == "MissionToast" then
					if not widget.backdrop then
						widget:CreateBackdrop('Tramsparent')
					end
					module:CreateGradient(widget.backdrop)
					if widget.Background then widget.Background:Hide() end
					if widget.Detail then widget.Detail:SetFontObject("Game13Font") end
				elseif otype == "RewardFrame" then
					widget.Quantity.__owner = widget
					hooksecurefunc(widget.Quantity, "SetText", SetAnimaActualCount)
				elseif otype == "MiniHealthBar" then
					local _, r1, r2 = widget:GetRegions()
					r1:Hide()
					r2:Hide()
				end
			end
		end
	end
end

S:AddCallbackForAddon("Blizzard_GarrisonUI", LoadSkin)
