local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G

-- WoW API

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleGarrisonTemplates()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true or E.private.skins.blizzard.garrison ~= true or E.private.muiSkins.blizzard.garrison ~= true then return end

	--[[ AddOns\Blizzard_GarrisonTemplates.lua ]]
	function MERS.GarrisonFollowerList_UpdateData(self)
		local followers = self.followers
		local followersList = self.followersList
		local numFollowers = #followersList
		local scrollFrame = self.listScroll
		local offset = _G.HybridScrollFrame_GetOffset(scrollFrame)
		local buttons = scrollFrame.buttons
		local numButtons = #buttons

		for i = 1, numButtons do
			local button = buttons[i]
			local index = offset + i -- adjust index
			if index <= numFollowers and followersList[index] ~= 0 then
				local follower = followers[followersList[index]]

				if follower.isCollected then
					-- adjust text position if we have additional text to show below name
					local nameOffsetY = 0
					if follower.status then
						nameOffsetY = nameOffsetY + 6
					end
					-- show iLevel for max level followers
					if ShouldShowILevelInFollowerList(follower) then
						nameOffsetY = nameOffsetY + 6
						button.Follower.ILevel:SetPoint("TOPLEFT", button.Follower.Name, "BOTTOMLEFT", 0, -2)
						button.Follower.Status:SetPoint("TOPLEFT", button.Follower.ILevel, "BOTTOMLEFT", 0, 0)
					else
						button.Follower.Status:SetPoint("TOPLEFT", button.Follower.Name, "BOTTOMLEFT", 0, -2)
					end

					if button.Follower.DurabilityFrame:IsShown() then
						nameOffsetY = nameOffsetY + 8

						if follower.status then
							button.Follower.DurabilityFrame:SetPoint("TOPLEFT", button.Follower.Status, "BOTTOMLEFT", 0, -4)
						elseif ShouldShowILevelInFollowerList(follower) then
							button.Follower.DurabilityFrame:SetPoint("TOPLEFT", button.Follower.ILevel, "BOTTOMLEFT", 0, -6)
						else
							button.Follower.DurabilityFrame:SetPoint("TOPLEFT", button.Follower.Name, "BOTTOMLEFT", 0, -6)
						end
					end
					button.Follower.Name:SetPoint("LEFT", button.Follower.PortraitFrame, "RIGHT", 10, nameOffsetY)
				end
			end
		end
	end

	function MERS.GarrisonFollowerButton_SetCounterButton(button, followerID, index, info, lastUpdate, followerTypeID)
		local counter = button.Counters[index]
		if not counter._auroraSkinned then
			MERS:GarrisonMissionAbilityCounterTemplate(counter)
			counter.isSkinned = true
		end

		local scale = GarrisonFollowerOptions[followerTypeID].followerListCounterScale
		if scale ~= 1 then
			counter:SetScale(1)
			local size = 20 * scale
			counter:SetSize(size, size)
		end
	end

	function MERS.GarrisonFollowerList_ExpandButtonAbilities(self, button, traitsFirst)
		if not button.isCollected then
			return -1
		end

		local abHeight = 0
		local buttonCount = 0
		for i = 1, #button.info.abilities do
			if traitsFirst == button.info.abilities[i].isTrait and button.info.abilities[i].icon then
				buttonCount = buttonCount + 1

				local Ability = button.Abilities[buttonCount]
				abHeight = abHeight + (Ability:GetHeight())
			end
		end
		for i = 1, #button.info.abilities do
			if traitsFirst ~= button.info.abilities[i].isTrait and button.info.abilities[i].icon then
				buttonCount = buttonCount + 1

				local Ability = button.Abilities[buttonCount]
				abHeight = abHeight + (Ability:GetHeight())
			end
		end

		for i = (#button.info.abilities + 1), #button.Abilities do
			button.Abilities[i]:Hide()
		end
		if abHeight > 0 then
			abHeight = abHeight + 8
			button.AbilitiesBG:Show()
		else
			button.AbilitiesBG:Hide()
		end
		return abHeight
	end

	function MERS.GarrisonFollowerList_ExpandButton(self, button, followerListFrame)
		local abHeight = MERS.GarrisonFollowerList_ExpandButtonAbilities(self, button, false)
		if abHeight == -1 then
			return
		end

		button.UpArrow:Show()
		button.DownArrow:Hide()
	end

	function MERS.GarrisonFollowerButton_AddAbility(self, index, ability, followerType)
		local Ability = self.Abilities[index]
		if not Ability._auroraSkinned then
			MERS.GarrisonFollowerListButtonAbilityTemplate(Ability)
			Ability.IsSkinned = true
		end
	end

	function MERS.GarrisonFollowerList_CollapseButton(self, button)
		button:SetHeight(46)
	end

	--[[ AddOns\Blizzard_GarrisonTemplates.xml ]]
	function MERS:GarrisonUITemplate(Frame)
		Frame:CreateBackdrop({
			bg = Frame.BackgroundTile,

			l = Frame.Left,
			r = Frame.Right,
			t = Frame.Top,
			b = Frame.Bottom,

			tl = Frame.GarrCorners.TopLeftGarrCorner,
			tr = Frame.GarrCorners.TopRightGarrCorner,
			bl = Frame.GarrCorners.BottomLeftGarrCorner,
			br = Frame.GarrCorners.BottomRightGarrCorner,

			borderLayer = "BACKGROUND",
			borderSublevel = -7,
		})
	end

	function MERS:GarrisonMissionBaseFrameTemplate(Frame)
		Frame.BaseFrameBackground:Hide()
		Frame.BaseFrameTop:Hide()
		Frame.BaseFrameBottom:Hide()
		Frame.BaseFrameLeft:Hide()
		Frame.BaseFrameRight:Hide()
		Frame.BaseFrameTopLeft:Hide()
		Frame.BaseFrameTopRight:Hide()
		Frame.BaseFrameBottomLeft:Hide()
		Frame.BaseFrameBottomRight:Hide()

		for i = 10, 17 do
			select(i, Frame:GetRegions()):Hide()
		end
	end

	function MERS:GarrisonListTemplate(Frame)
		MERS:GarrisonMissionBaseFrameTemplate(Frame)

		Frame.listScroll:SetPoint("TOPLEFT", 2, -2)
		Frame.listScroll:SetPoint("BOTTOMRIGHT", -20, 2)
	end

	function MERS:GarrisonListTemplateHeader(Frame)
		MERS:GarrisonListTemplate(Frame)

		Frame.HeaderLeft:Hide()
		Frame.HeaderRight:Hide()
		Frame.HeaderMid:Hide()
	end

	function MERS:GarrisonFollowerButtonTemplate(Frame)
		Frame.BG:Hide()

		Frame.Selection:SetTexCoord(0, 0.99568965517241, 0.01785714285714, 0.96428571428571)
		Frame.Selection:SetAllPoints()

		Frame.XPBar:SetPoint("TOPLEFT", Frame.PortraitFrame, "BOTTOMRIGHT", 0, 6)
		MERS:GarrisonFollowerPortraitTemplate(Frame.PortraitFrame)
		Frame.PortraitFrame:SetPoint("TOPLEFT", -3, 3)
		Frame.Highlight:SetTexCoord(0, 0.99568965517241, 0.01785714285714, 0.96428571428571)
		Frame.Highlight:SetAllPoints()

		--[[ Scale ]]--
		Frame:SetWidth(260)
	end

	function MERS:GarrisonFollowerCombatAllySpellTemplate(Button)
		S:CropIcon(Button.iconTexture, Button)
	end

	function MERS:GarrisonFollowerEquipmentTemplate(Button)
		MERS:GarrisonEquipmentTemplate(Button)
		Button.BG:Hide()
		Button.Border:Hide()
	end

	function MERS:GarrisonAbilityCounterTemplate(Frame)
		if Frame then
			S:CropIcon(Frame.Icon, Frame)
			Frame.Icon:SetSize(20, 20)

			Frame.Border:ClearAllPoints()
			Frame.Border:SetPoint("TOPLEFT", Frame.Icon, -8, 8)
			Frame.Border:SetPoint("BOTTOMRIGHT", Frame.Icon, 8, -8)
		end
	end

	function MERS:GarrisonMissionAbilityCounterTemplate(Frame)
		if Frame then
			MERS:GarrisonAbilityCounterTemplate(Frame)
		end
	end

	function MERS:GarrisonFollowerListButtonAbilityTemplate(Frame)
		if Frame then
			S:CropIcon(Frame.Icon, Frame)
		end
	end

	function MERS:GarrisonMissionFollowerButtonTemplate(Frame)
		MERS:GarrisonFollowerButtonTemplate(Frame)
		Frame.AbilitiesBG:SetAlpha(0)
		Frame.BusyFrame:SetAllPoints()
	end

	function MERS:GarrisonMissionFollowerOrCategoryListButtonTemplate(Frame)
		MERS:GarrisonMissionFollowerButtonTemplate(Frame.Follower)
	end

	function MERS:MaterialFrameTemplate(Frame)
		local bg, label = Frame:GetRegions()
		bg:Hide()
		label:SetPoint("LEFT", 5, 0)
		Frame.Materials:SetPoint("RIGHT", Frame.Icon, "LEFT", -5, 0)

		S:CropIcon(Frame.Icon, Frame)
		Frame.Icon:SetSize(18, 18)
		Frame.Icon:SetPoint("RIGHT", -5, 0)
	end

	function MERS:GarrisonEquipmentTemplate(Button)
		S:CropIcon(Button.Icon, Button)
	end

	-- Blizzard_GarrisonMissionTemplates --
	function MERS:GarrisonMissionCompleteDialogTemplate(Frame)
	end

	function MERS:GarrisonMissionCompleteTemplate(Frame)
	end

	function MERS:GarrisonFollowerXPBarTemplate(StatusBar)
		StatusBar.XPLeft:ClearAllPoints()
		StatusBar.XPRight:ClearAllPoints()
	end

	function MERS:StartMissionButtonTemplate(Button)
		Button.Flash:SetAtlas("GarrMission_FollowerListButton-Select")
		Button.Flash:SetAllPoints()
		Button.Flash:SetTexCoord(0, 0.99568965517241, 0.01785714285714, 0.96428571428571)
	end

	function MERS:GarrisonMissionPageCostFrameTemplate(Button)
		S:CropIcon(Button.CostIcon, Button)
	end

	function MERS:GarrisonMissionPageCloseButtonTemplate(Button)
		S:HandleCloseButton(Button)
		Button:SetSize(22, 22)
	end

	function MERS:GarrisonMissionFrameTemplate(Frame)
		Frame:SetSize(Frame:GetSize())
	end

	-- Blizzard_GarrisonSharedTemplates --
	----====####$$$$%%%%%%$$$$####====----

	--hooksecurefunc(GarrisonFollowerList, "UpdateData", MERS.GarrisonFollowerList_UpdateData)
	hooksecurefunc("GarrisonFollowerButton_SetCounterButton", MERS.GarrisonFollowerButton_SetCounterButton)
	--hooksecurefunc(GarrisonFollowerList, "ExpandButton", MERS.GarrisonFollowerList_ExpandButton)
	hooksecurefunc("GarrisonFollowerButton_AddAbility", MERS.GarrisonFollowerButton_AddAbility)
	--hooksecurefunc(GarrisonFollowerList, "CollapseButton", MERS.GarrisonFollowerList_CollapseButton)
end

S:AddCallbackForAddon("Blizzard_GarrisonTemplates", "mUIGarrisonTemplates", styleGarrisonTemplates)