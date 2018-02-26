local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins");
local LSM = LibStub("LibSharedMedia-3.0")

-- Cache global variables
-- Lua functions
local _G = _G
local ipairs, select, unpack = ipairs, select, unpack
-- WoW API / Variables
local CreateFrame = CreateFrame
local C_TimerAfter = C_Timer.After
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc

local function styleOrderhall()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true or E.private.muiSkins.blizzard.orderhall ~= true then return end

	-- CombatAlly MissionFrame
	local combatAlly = _G["OrderHallMissionFrameMissions"].CombatAllyUI
	local portraitFrame = combatAlly.InProgress.PortraitFrame
	local portrait = combatAlly.InProgress.PortraitFrame.Portrait
	local portraitRing = combatAlly.InProgress.PortraitFrame.PortraitRing
	local levelBorder = combatAlly.InProgress.PortraitFrame.LevelBorder
	combatAlly:StripTextures()
	MERS:CreateBD(combatAlly, .25)

	if portrait and not portrait.IsSkinned then
		portraitFrame:CreateBackdrop("Default")
		portraitFrame.backdrop:SetPoint("TOPLEFT", portrait, "TOPLEFT", -1, 1)
		portraitFrame.backdrop:SetPoint("BOTTOMRIGHT", portrait, "BOTTOMRIGHT", 1, -1)
		portrait:ClearAllPoints()
		portrait:SetPoint("TOPLEFT", 1, -1)
		portrait:SetTexCoord(unpack(E.TexCoords))
		portraitRing:Hide()
		levelBorder:SetAlpha(0)

		portrait.IsSkinned = true
	end

	-- Mission Frame
	_G["OrderHallMissionFrame"]:Styling()

	_G["OrderHallMissionFrameMissions"].MaterialFrame:StripTextures()
	_G["OrderHallMissionFrameMissionsListScrollFrame"]:StripTextures()

	_G["OrderHallMissionFrame"].MissionTab.MissionPage:StripTextures()

	-- CombatAlly ZoneSupport Frame
	_G["OrderHallMissionFrame"].MissionTab.ZoneSupportMissionPage:StripTextures()
	MERS:CreateBD(_G["OrderHallMissionFrame"].MissionTab.ZoneSupportMissionPage, .5)
	local combatAlly = _G["OrderHallMissionFrame"].MissionTab.ZoneSupportMissionPage.Follower1
	local portraitFrame = combatAlly.PortraitFrame
	local portrait = portraitFrame.Portrait
	local portraitRing = portraitFrame.PortraitRing
	local portraitRingQuality = portraitFrame.PortraitRingQuality
	local levelBorder = portraitFrame.LevelBorder

	combatAlly:StripTextures()

	if portrait and not portrait.IsSkinned then
		portrait:ClearAllPoints()
		portrait:SetPoint("TOPLEFT", 1, -1)
		portrait:SetTexCoord(unpack(E.TexCoords))
		portraitRing:Hide()
		portraitRingQuality:Hide()
		levelBorder:SetAlpha(0)

		portrait.IsSkinned = true
	end

	for i, v in ipairs(_G["OrderHallMissionFrame"].MissionTab.MissionList.listScroll.buttons) do
		local Button = _G["OrderHallMissionFrameMissionsListScrollFrameButton" .. i]
		if Button and not Button.skinned then
			Button:StripTextures()
			MERS:CreateBD(Button, .25)
			MERS:Reskin(Button, true)
			Button.LocBG:SetAlpha(0)
			Button.backdropTexture:Hide()

			Button.isSkinned = true
		end
	end

	for i = 1, 2 do
		local tab = _G["OrderHallMissionFrameMissionsTab"..i]

		tab:StripTextures()
		tab:SetHeight(_G["GarrisonMissionFrameMissionsTab" .. i]:GetHeight() - 10)
		S:HandleTab(tab)
	end

	-- Missions
	local Mission = _G["OrderHallMissionFrameMissions"]
	Mission.CompleteDialog:StripTextures()
	Mission.CompleteDialog:SetTemplate("Transparent")

	local MissionPage = _G["OrderHallMissionFrame"].MissionTab.MissionPage
	for i = 1, 10 do
		select(i, MissionPage.RewardsFrame:GetRegions()):Hide()
	end
	MERS:CreateBD(MissionPage.RewardsFrame, .25)

	-- Credits Simpy <3
	-- Talent Frame
	local TalentFrame = _G["OrderHallTalentFrame"]
	TalentFrame:StripTextures()
	TalentFrame.LeftInset:StripTextures()
	TalentFrame:SetTemplate("Transparent")
	TalentFrame.CurrencyIcon:SetAtlas("legionmission-icon-currency", false)
	S:HandleCloseButton(TalentFrame.CloseButton)
	S:HandleButton(TalentFrame.BackButton)
	TalentFrame.BackButton:SetFrameLevel(TalentFrame.BackButton:GetFrameLevel()+2)
	TalentFrame.BackButton:Point('BOTTOMRIGHT', TalentFrame, 'BOTTOMRIGHT', -2, 2)

	local TalentInset = _G["ClassHallTalentInset"]
	local TalentClassBG = TalentFrame.Background
	TalentInset:CreateBackdrop("Transparent")
	TalentInset.backdrop:SetFrameLevel(TalentInset.backdrop:GetFrameLevel()+1)
	TalentInset.backdrop:Point('TOPLEFT', TalentClassBG, 'TOPLEFT', E.Border-1, -E.Border+1)
	TalentInset.backdrop:Point('BOTTOMRIGHT', TalentClassBG, 'BOTTOMRIGHT', -E.Border+1, E.Border-1)
	TalentClassBG:SetAtlas("orderhalltalents-background-"..E.myclass)
	TalentClassBG:SetDrawLayer("ARTWORK")
	TalentClassBG:SetAlpha(0.8)

	local function panelBackground(self)
		local tab8 = _G["OrderHallTalentFrame8PanelBackground"];
		if tab8 then
			if TalentFrame.BackButton:IsShown() then tab8:Hide() else tab8:Show() end
		else
			for i = 1, 8 do
				local bg = CreateFrame("Frame", "OrderHallTalentFrame"..i.."PanelBackground", self)
				if i == 1 then
					bg:Point("TOPLEFT", self, "TOPLEFT", E.PixelMode and 6 or 9, -80)
				else
					bg:Point("TOPLEFT", "OrderHallTalentFrame"..(i-1).."PanelBackground", "BOTTOMLEFT", 0, -6)
				end
				bg:SetTemplate("Transparent")
				bg:SetBackdropColor(0, 0, 0, 0.5)
				bg:SetSize(E.PixelMode and 322 or 316, 52)
			end
			tab8 = _G["OrderHallTalentFrame8PanelBackground"];
			if TalentFrame.BackButton:IsShown() then tab8:Hide() else tab8:Show() end
		end
	end

	local function colorBorder(child, backdrop, atlas)
		if child.AlphaIconOverlay:IsShown() then --isBeingResearched or (talentAvailability and not selected)
			local alpha = child.AlphaIconOverlay:GetAlpha()
			if alpha <= 0.5 then --talentAvailability
				backdrop:SetBackdropBorderColor(0.5, 0.5, 0.5) --[border = grey, shadow x2]
				child.darkOverlay:SetColorTexture(0, 0, 0, 0.50)
				child.darkOverlay:Show()
			elseif alpha <= 0.7 then --isBeingResearched
				backdrop:SetBackdropBorderColor(0,1,1) --[border = teal, shadow x1]
				child.darkOverlay:SetColorTexture(0, 0, 0, 0.25)
				child.darkOverlay:Show()
			end
		elseif atlas == "orderhalltalents-spellborder-green" then
			backdrop:SetBackdropBorderColor(0,1,0) --[border = green, no shadow]
			child.darkOverlay:Hide()
		elseif atlas == "orderhalltalents-spellborder-yellow" then
			backdrop:SetBackdropBorderColor(1,1,0) --[border = yellow, no shadow]
			child.darkOverlay:Hide()
		elseif atlas == "orderhalltalents-spellborder" then
			backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
			child.darkOverlay:SetColorTexture(0, 0, 0, 0.75) --[border will be default, shadow x3]
			child.darkOverlay:Show()
		end
	end

	TalentFrame:HookScript("OnShow", function(self)
		panelBackground(self) -- Chromie is the original classAgnostic talent tree
		if self.skinned then return end
		for i=1, self:GetNumChildren() do
			local child = select(i, self:GetChildren())
			if child and child.Icon and not child.backdrop then
				child:StyleButton()
				child:CreateBackdrop()
				child.Border:SetAlpha(0)
				child.Highlight:SetAlpha(0)
				child.AlphaIconOverlay:SetTexture(nil)
				child.Icon:SetTexCoord(unpack(E.TexCoords))
				child.Icon:SetInside(child.backdrop)
				child.hover:SetInside(child.backdrop)
				child.pushed:SetInside(child.backdrop)
				child.backdrop:SetFrameLevel(child.backdrop:GetFrameLevel()+1)

				child.darkOverlay = child:CreateTexture()
				child.darkOverlay:SetAllPoints(child.Icon)
				child.darkOverlay:SetDrawLayer('OVERLAY')
				child.darkOverlay:Hide()

				colorBorder(child, child.backdrop, child.Border:GetAtlas())

				child.TalentDoneAnim:HookScript("OnFinished", function(self)
					child.Border:SetAlpha(0) -- clear the yellow glow border again, after it finishes the animation
				end)
			end
		end
		self.choiceTexturePool:ReleaseAll()
		hooksecurefunc(self, "RefreshAllData", function(frame)
			frame.choiceTexturePool:ReleaseAll()
			for i=1, frame:GetNumChildren() do
				local child = select(i, frame:GetChildren())
				if child and child.Icon and child.backdrop then
					colorBorder(child, child.backdrop, child.Border:GetAtlas())
				end
			end
		end)
		self.skinned = true
	end)
end

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

S:AddCallbackForAddon("Blizzard_OrderHallUI", "mUIOrderHall", styleOrderhall)