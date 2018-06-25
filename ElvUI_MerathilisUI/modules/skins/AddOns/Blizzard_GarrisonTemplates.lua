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
		Frame:Styling()
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

	function MERS:GarrisonMissionFollowerDurabilityFrameTemplate(Frame)
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

	function MERS.GarrisonFollowerTabMixin_OnLoad(self)
		--hooksecurefunc(self.abilitiesPool, "Acquire", MERS.ObjectPoolMixin_Acquire)
		--hooksecurefunc(self.equipmentPool, "Acquire", MERS.ObjectPoolMixin_Acquire)
		--hooksecurefunc(self.countersPool, "Acquire", MERS.ObjectPoolMixin_Acquire)
	end

	----====####$$$$%%%%%%%$$$$####====----
	-- Blizzard_GarrisonMissionTemplates --
	----====####$$$$%%%%%%%$$$$####====----

	function MERS.GarrisonMission_RemoveFollowerFromMission(self, frame, updateValues)
		MERS.GarrisonFollowerPortraitMixin_SetQuality(frame.PortraitFrame, 1)
	end

	function MERS.GarrisonMissionFrame_SetItemRewardDetails(frame)
		local _, _, quality = _G.GetItemInfo(frame.itemID)
		MERS.SetItemButtonQuality(frame, quality, frame.itemID)
	end

	function MERS:GarrisonMissionCompleteDialogTemplate(Frame)
		MERS:GarrisonMissionStageTemplate(Frame.Stage)
		local left, right = select(5, Frame.Stage:GetRegions())
		left:Hide()
		right:Hide()
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

	function MERS:GarrisonMissionRewardEffectsTemplate(Frame)
		S:CropIcon(Frame.Icon)

		Frame.IconBorder:Hide()
		local iconBG = CreateFrame("Frame", nil, Frame)
		iconBG:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
		iconBG:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)
		Frame._mUIIconBorder = iconBG

		Frame.BG:SetAlpha(0)
		local nameBG = CreateFrame("Frame", nil, Frame)
		nameBG:SetPoint("TOPLEFT", iconBG, "TOPRIGHT", 1, 0)
		nameBG:SetPoint("BOTTOMRIGHT", -3, -1)
		Frame._mUINameBG = nameBG

		--[[ Scale ]]--
		Frame:SetSize(Frame:GetSize())
	end

	function MERS:GarrisonMissionPageOvermaxRewardTemplate(Frame)
		S:CropIcon(Frame.Icon)

		Frame.IconBorder:Hide()
		local iconBG = _G.CreateFrame("Frame", nil, Frame)
		iconBG:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
		iconBG:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)
		Frame._mUIIconBorder = iconBG

		--[[ Scale ]]--
		Frame:SetSize(Frame:GetSize())
	end

	function MERS:GarrisonMissionPageRewardTemplate(Frame)
	MERS:GarrisonMissionPageOvermaxRewardTemplate(Frame.OvermaxItem)
	MERS:GarrisonMissionRewardEffectsTemplate(Frame.Reward1)
	MERS:GarrisonMissionRewardEffectsTemplate(Frame.Reward2)
	end

	function MERS:GarrisonAbilityLargeCounterTemplate(Frame)
		S:CropIcon(Frame.Icon, Frame)
	end

	function MERS:GarrisonMissionLargeMechanicTemplate(Frame)
		MERS:GarrisonAbilityLargeCounterTemplate(Frame)
	end

	function MERS:GarrisonMissionCheckTemplate(Frame)
	end

	function MERS:GarrisonMissionMechanicTemplate(Frame)
		MERS:GarrisonAbilityCounterTemplate(Frame)
	end

	function MERS:GarrisonMissionEnemyMechanicTemplate(Frame)
		MERS:GarrisonMissionMechanicTemplate(Frame)
		MERS:GarrisonMissionCheckTemplate(Frame)
	end

	function MERS:GarrisonMissionEnemyLargeMechanicTemplate(Frame)
		MERS:GarrisonMissionLargeMechanicTemplate(Frame)
		MERS:GarrisonMissionCheckTemplate(Frame)
	end

	function MERS:GarrisonMissionStageTemplate(Frame)
		Frame.LocBack:SetPoint("TOPLEFT")
		Frame.LocBack:SetPoint("BOTTOMRIGHT")
		select(4, Frame:GetRegions()):Hide()

		local mask1 = Frame:CreateMaskTexture(nil, "ARTWORK")
		mask1:SetTexture([[Interface\Common\icon-shadow]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		mask1:SetPoint("TOPLEFT", Frame.LocBack, -150, 100)
		mask1:SetPoint("BOTTOMRIGHT", Frame.LocBack, 150, -20)
		Frame.LocBack:AddMaskTexture(mask1)
		Frame.LocMid:AddMaskTexture(mask1)
		Frame.LocFore:AddMaskTexture(mask1)
	end

	function MERS:GarrisonMissionPageStageTemplate(Frame)
		MERS:VerticalLayoutFrame(Frame.MissionInfo)
		MERS:GarrisonMissionStageTemplate(Frame)
	end

	function MERS:GarrisonMissionCompleteStageTemplate(Frame)
	end

	function MERS:GarrisonMissionCompleteStageTemplate(Frame)
	end

	function MERS:GarrisonMissionCompleteTemplate(Frame)
		Frame.ButtonFrameLeft:Hide()
		Frame.ButtonFrameRight:Hide()
	end

	function MERS:GarrisonFollowerXPBarTemplate(StatusBar)
		StatusBar.XPLeft:ClearAllPoints()
		StatusBar.XPRight:ClearAllPoints()
	end

	function MERS:GarrisonFollowerXPGainTemplate(Frame)
	end

	function MERS:GarrisonFollowerLevelUpTemplate(Frame)
	end

	-- Blizzard_GarrisonSharedTemplates --
	----====####$$$$%%%%%%$$$$####====----

	--hooksecurefunc(GarrisonFollowerList, "UpdateData", MERS.GarrisonFollowerList_UpdateData)
	hooksecurefunc("GarrisonFollowerButton_SetCounterButton", MERS.GarrisonFollowerButton_SetCounterButton)
	--hooksecurefunc(GarrisonFollowerList, "ExpandButton", MERS.GarrisonFollowerList_ExpandButton)
	hooksecurefunc("GarrisonFollowerButton_AddAbility", MERS.GarrisonFollowerButton_AddAbility)
	--hooksecurefunc(GarrisonFollowerList, "CollapseButton", MERS.GarrisonFollowerList_CollapseButton)
	hooksecurefunc(GarrisonFollowerTabMixin, "OnLoad", MERS.GarrisonFollowerTabMixin_OnLoad)
	hooksecurefunc(GarrisonMission, "RemoveFollowerFromMission", MERS.GarrisonMission_RemoveFollowerFromMission)
end

S:AddCallbackForAddon("Blizzard_GarrisonTemplates", "mUIGarrisonTemplates", styleGarrisonTemplates)