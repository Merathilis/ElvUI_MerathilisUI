local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G

-- WoW API
local CreateFrame = CreateFrame
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleGarrison()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true or E.private.skins.blizzard.garrison ~= true or E.private.muiSkins.blizzard.garrison ~= true then return end

	--[[ AddOns\Blizzard_GarrisonUI.lua ]]

	--[[ AddOns\Blizzard_GarrisonUI.xml ]]
	--[[ Blizzard_GarrisonShipyardUI.xml ]]
	function MERS:GarrisonBonusEffectFrameTemplate(Frame)
		S:CropIcon(Frame.Icon, Frame)
	end

	function MERS:GarrisonBonusAreaTooltipFrameTemplate(Frame)
		MERS:GarrisonBonusEffectFrameTemplate(Frame.BonusEffectFrame)
	end

	--[[ Blizzard_GarrisonLandingPage.xml ]]
	function MERS:GarrisonLandingPageReportMissionRewardTemplate(Frame)
		S:CropIcon(Frame.Icon)

		local bg = CreateFrame("Frame", nil, Frame)
		bg:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
		bg:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)
		Frame._mUIIconBorder = bg

		Frame.IconBorder:Hide()

		--[[ Scale ]]--
		Frame:SetSize(Frame:GetSize())
	end

	function MERS:GarrisonLandingPageReportMissionTemplate(Button)
		Button.BG:Hide()

		MERS:GarrisonLandingPageReportMissionRewardTemplate(Button.Reward1)
		MERS:GarrisonLandingPageReportMissionRewardTemplate(Button.Reward2)
		MERS:GarrisonLandingPageReportMissionRewardTemplate(Button.Reward3)
	end

	function MERS:GarrisonLandingPageTabTemplate(Button)
		Button:SetHeight(28)

		Button.LeftDisabled:SetAlpha(0)
		Button.MiddleDisabled:SetAlpha(0)
		Button.RightDisabled:SetAlpha(0)
		Button.Left:SetAlpha(0)
		Button.Middle:SetAlpha(0)
		Button.Right:SetAlpha(0)
		Button.LeftHighlight:SetAlpha(0)
		Button.RightHighlight:SetAlpha(0)
		Button.MiddleHighlight:SetAlpha(0)

		Button.Text:ClearAllPoints()
		Button.Text:SetPoint("CENTER")

		Button._mUITabResize = true
	end

	function MERS:BaseLandingPageFollowerListTemplate(Frame)
		Frame:GetRegions():Hide()
		Frame.FollowerHeaderBar:Hide()
		Frame.FollowerScrollFrame:Hide()
	end

	--[[ Blizzard_GarrisonCapacitiveDisplay.xml ]]
	function MERS:GarrisonCapacitiveItemButtonTemplate(Frame)
		S:CropIcon(Frame.Icon)

		local iconBG = CreateFrame("Frame", nil, Frame)
		iconBG:SetFrameLevel(Frame:GetFrameLevel() - 1)
		iconBG:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
		iconBG:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)
		Frame._mUIIconBorder = iconBG

		Frame.NameFrame:SetAlpha(0)

		local nameBG = CreateFrame("Frame", nil, Frame)
		nameBG:SetPoint("TOPLEFT", iconBG, "TOPRIGHT", 1, 0)
		nameBG:SetPoint("BOTTOMRIGHT", -3, 1)
		Frame._mUINameBG = nameBG
	end

	function MERSGarrisonCapacitiveWorkOrderTemplate(Frame)
		MERS:GarrisonBonusEffectFrameTemplate(Frame.BonusEffectFrame)
	end

	-- Not templates
	function MERS:GarrisonCapacitiveInputSpinner(Frame)
		Frame.DecrementButton = GarrisonCapacitiveDisplayFrame.DecrementButton
		Frame.DecrementButton:ClearAllPoints()

		Frame.IncrementButton = GarrisonCapacitiveDisplayFrame.IncrementButton
		Frame.IncrementButton:ClearAllPoints()

		MERS:NumericInputSpinnerTemplate(Frame)
	end

	--[[ Blizzard_GarrisonMissionUI.xml ]]
	function MERS:GarrisonFollowerMissionPortraitTemplate(Frame)
		MERS:GarrisonFollowerPortraitTemplate(Frame)
		MERS.GarrisonFollowerPortraitMixin_SetQuality(Frame, 1)
		Frame.Level:Hide()

		Frame.Empty:SetAtlas("Garr_FollowerPortrait_Bg")
		Frame.Empty:SetAllPoints(Frame.Portrait)
		Frame.Empty:SetTexCoord(0.08620689655172, 0.86206896551724, 0.06896551724138, 0.8448275862069)

		Frame.Highlight:SetTexture([[Interface\Buttons\CheckButtonHilight]])
		Frame.Highlight:SetTexCoord(0.0625, 0.9375, 0.0625, 0.9375)
		Frame.Highlight:SetPoint("TOPLEFT", Frame._auroraPortraitBG)
		Frame.Highlight:SetPoint("BOTTOMRIGHT", Frame._auroraLvlBG, "TOPRIGHT")
	end

	function MERS:GarrisonMissionListTabTemplate(Button)
		Button.Left:SetAlpha(0)
		Button.Right:SetAlpha(0)
		Button.Middle:SetAlpha(0)
		Button.SelectedLeft:SetAlpha(0)
		Button.SelectedRight:SetAlpha(0)
		Button.SelectedMid:SetAlpha(0)
	end

	function MERS:GarrisonMissionAbilityLargeCounterTemplate(Frame)
		MERS:GarrisonAbilityLargeCounterTemplate(Frame)
	end

	function MERS:GarrisonFollowerPageAbilityIconButtonTemplate(Button)
		S:CropIcon(Button.Icon)
	end

	function MERS:GarrisonFollowerPageAbilityTemplate(Button)
		MERS:GarrisonFollowerPageAbilityIconButtonTemplate(Button.IconButton, Button)
	end

	function MERS:GarrisonMissionListButtonRewardTemplate(Frame)
		S:CropIcon(Frame.Icon)

		local bg = _G.CreateFrame("Frame", nil, Frame)
		bg:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
		bg:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)
		Frame._mUIIconBorder = bg

		Frame.IconBorder:Hide()

		Frame:SetSize(Frame:GetSize())
	end

	function MERS:GarrisonMissionListButtonNewHighlightTemplate(Frame)
	end

	function MERS:GarrisonMissionListButtonTemplate(Button)
		local bg, l, r, t, b, _, t2, b2, tl, tr, bl, br = Button:GetRegions()
		Button:CreateBackdrop({
			bg = bg,

			l = l,
			r = r,
			t = t,
			b = b,

			tl = tl,
			tr = tr,
			bl = bl,
			br = br,

			borderLayer = "BACKGROUND",
			borderSublevel = -7,
		})
		t2:Hide()
		b2:Hide()

		Button.HighlightT:SetTexture("")
		Button.HighlightB:SetTexture("")
		Button.HighlightTL:SetTexture("")
		Button.HighlightTR:SetTexture("")
		Button.HighlightBL:SetTexture("")
		Button.HighlightBR:SetTexture("")
		Button.Highlight:SetTexture("")

		Button:DisableDrawLayer("HIGHLIGHT")
		MERS:GarrisonMissionListButtonRewardTemplate(Button.Rewards[1])
	end

	function MERS:GarrisonFollowerMissionRewardsFrameTemplate(Frame)
		local bg, l, r, t, b, tl, tr, bl, br = Frame:GetRegions()
		Frame:CreateBackdrop({
			bg = bg,

			l = l,
			r = r,
			t = t,
			b = b,

			tl = tl,
			tr = tr,
			bl = bl,
			br = br,

			borderLayer = "BACKGROUND",
			borderSublevel = -7,
		})
	end

	function MERS:GarrisonMissionPageFollowerTemplate(Frame)
		Frame:GetRegions():Hide()
		local portraitBG = CreateFrame("Frame", nil, Frame)
		portraitBG:SetFrameLevel(Frame:GetFrameLevel())
		portraitBG:SetPoint("TOPLEFT", Frame, -1, 1)
		portraitBG:SetPoint("BOTTOMRIGHT", Frame, 1, -1)

		MERS:GarrisonFollowerMissionPortraitTemplate(Frame.PortraitFrame)
		MERS:GarrisonMissionAbilityLargeCounterTemplate(Frame.Counters[1])
		MERS:GarrisonMissionFollowerDurabilityFrameTemplate(Frame.Durability[1])
	end

	function MERS:GarrisonEnemyPortraitTemplate(Frame)
	end

	function MERS:GarrisonMissionPageEnemyTemplate(Frame)
		MERS:GarrisonEnemyPortraitTemplate(Frame.PortraitFrame)
		MERS:GarrisonMissionEnemyLargeMechanicTemplate(Frame.Mechanics[1])
	end

	function MERS:GarrisonLargeFollowerXPFrameTemplate(Frame)
		MERS:GarrisonFollowerPortraitTemplate(Frame.PortraitFrame)
		MERS:GarrisonFollowerXPBarTemplate(Frame.XP)
		MERS:GarrisonFollowerXPGainTemplate(Frame.XPGain)
		MERS:GarrisonFollowerLevelUpTemplate(Frame.LevelUpFrame)
		MERS:GarrisonMissionFollowerDurabilityFrameTemplate(Frame.DurabilityFrame)
	end

	function MERS:GarrisonMissionPageBaseTemplate(Frame)
		local bg, l, r, t, b, tl, tr, bl, br, tex1 = Frame:GetRegions()
		Frame:CreateBackdrop({
			bg = bg,

			l = l,
			r = r,
			t = t,
			b = b,

			tl = tl,
			tr = tr,
			bl = bl,
			br = br,

			borderLayer = "BACKGROUND",
			borderSublevel = -7,
		})
		tex1:Hide()
	end

	function MERS:GarrisonMissionTopBorderTemplate(Frame)
		local tex1, tex2, tex3 = select(11, Frame:GetRegions())
		tex1:Hide()
		tex2:Hide()
		tex3:Hide()
	end

	function MERS:GarrisonMissionListTemplate(Frame)
		MERS:GarrisonListTemplate(Frame)
		MERS:GarrisonMissionListTabTemplate(Frame.Tab1)
		MERS:GarrisonMissionListTabTemplate(Frame.Tab2)
		MERS:MaterialFrameTemplate(Frame.MaterialFrame)
		Frame.MaterialFrame:SetPoint("BOTTOMRIGHT", Frame, "TOPRIGHT", -9, 9)
		Frame.MaterialFrame:SetPoint("TOPLEFT", Frame, "TOPRIGHT", -307, 34)

		Frame.CompleteDialog:SetPoint("TOPLEFT", Frame:GetParent())
		Frame.CompleteDialog:SetPoint("BOTTOMRIGHT", Frame:GetParent())
		MERS:GarrisonMissionPageBaseTemplate(Frame.CompleteDialog.BorderFrame)
		MERS:GarrisonMissionCompleteDialogTemplate(Frame.CompleteDialog.BorderFrame)
		MERS:GarrisonMissionTopBorderTemplate(Frame.CompleteDialog.BorderFrame)
	end

	function MERS:GarrisonFollowerTabTemplate(Frame)
		MERS:GarrisonMissionBaseFrameTemplate(Frame)

		Frame.HeaderBG:Hide()

		MERS:GarrisonFollowerPortraitTemplate(Frame.PortraitFrame)
		MERS:GarrisonFollowerXPBarTemplate(Frame.XPBar)

		MERS:GarrisonFollowerCombatAllySpellTemplate(Frame.AbilitiesFrame.CombatAllySpell[1])
		MERS:GarrisonFollowerCombatAllySpellTemplate(Frame.AbilitiesFrame.CombatAllySpell[2])
	end

	function MERS:GarrisonFollowerMissionCompleteStageTemplate(Frame)
		MERS:GarrisonMissionStageTemplate(Frame)
		MERS:GarrisonMissionCompleteStageTemplate(Frame)

		MERS:GarrisonLargeFollowerXPFrameTemplate(Frame.FollowersFrame.Follower1)
		MERS:GarrisonLargeFollowerXPFrameTemplate(Frame.FollowersFrame.Follower2)
		MERS:GarrisonLargeFollowerXPFrameTemplate(Frame.FollowersFrame.Follower3)

		local left, right, bottom = Frame.MissionInfo:GetRegions()
		left:Hide()
		right:Hide()
		bottom:Hide()

		local top, tl, tr = select(11, Frame.MissionInfo:GetRegions())
		top:Hide()
		tl:Hide()
		tr:Hide()
	end

	--[[ Blizzard_OrderHallMissionUI.xml ]]
	function MERS:OrderHallMissionListButtonTemplate(Button)
		MERS:GarrisonMissionListButtonTemplate(Button)
	end

	function MERS:OrderHallMissionPageEnemyTemplate(Button)
		MERS:GarrisonMissionPageEnemyTemplate(Button)
	end

	----====####$$$$%%%%$$$$####====----
	--  Blizzard_GarrisonLandingPage  --
	----====####$$$$%%%%$$$$####====----
	local GarrisonLandingPage = _G["GarrisonLandingPage"]
	GarrisonLandingPage:StripTextures()
	GarrisonLandingPage:Styling()

	GarrisonLandingPage.HeaderBar:Hide()

	MERS:GarrisonLandingPageTabTemplate(GarrisonLandingPage.ReportTab)
	MERS:GarrisonLandingPageTabTemplate(GarrisonLandingPage.FollowerTabButton)
	MERS:GarrisonLandingPageTabTemplate(GarrisonLandingPage.FleetTab)

	GarrisonLandingPage.Report.Background:SetDesaturated(true)
	GarrisonLandingPage.Report.Background:SetAlpha(0.5)
	GarrisonLandingPage.Report.List:GetRegions():SetDesaturated(true)
	GarrisonLandingPage.Report.InProgress:GetNormalTexture():SetAlpha(0)
	GarrisonLandingPage.Report.InProgress:SetHighlightTexture("")
	GarrisonLandingPage.Report.Available:GetNormalTexture():SetAlpha(0)
	GarrisonLandingPage.Report.Available:SetHighlightTexture("")

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

	MERS:BaseLandingPageFollowerListTemplate(GarrisonLandingPage.FollowerList)
	local LandingFollowerTab = GarrisonLandingPage.FollowerTab
	MERS:GarrisonFollowerPortraitTemplate(LandingFollowerTab.PortraitFrame)
	MERS:GarrisonFollowerXPBarTemplate(LandingFollowerTab.XPBar)
	MERS:GarrisonMissionFollowerDurabilityFrameTemplate(LandingFollowerTab.DurabilityFrame)

	MERS:BaseLandingPageFollowerListTemplate(GarrisonLandingPage.ShipFollowerList)

	----====####$$$$%%%%%%%%$$$$####====----
	-- Blizzard_GarrisonCapacitiveDisplay --
	----====####$$$$%%%%%%%%$$$$####====----
	local GarrisonCapacitiveDisplayFrame = _G["GarrisonCapacitiveDisplayFrame"]
	MERS:ButtonFrameTemplate(GarrisonCapacitiveDisplayFrame)

	local CapacitiveDisplay = GarrisonCapacitiveDisplayFrame.CapacitiveDisplay
	CapacitiveDisplay.IconBG:Hide()
	MERS:GarrisonFollowerPortraitTemplate(CapacitiveDisplay.ShipmentIconFrame.Follower)
	MERS:GarrisonCapacitiveItemButtonTemplate(CapacitiveDisplay.Reagents[1])

	-- /run GarrisonCapacitiveDisplayFrame.FinishedGlow.FinishedAnim:Play()
	GarrisonCapacitiveDisplayFrame.FinishedGlow:SetClipsChildren(true)
	GarrisonCapacitiveDisplayFrame.FinishedGlow.FinishedFlare:SetPoint("TOPLEFT", 0, 25)

	-- BlizzWTF: This should use NumericInputSpinnerTemplate
	GarrisonCapacitiveDisplayFrame.Count:ClearAllPoints()
	GarrisonCapacitiveDisplayFrame.Count:SetPoint("BOTTOM", -15, 4)
	MERS:GarrisonCapacitiveInputSpinner(GarrisonCapacitiveDisplayFrame.Count)

	----====####$$$%%%%%%%%$$$####====--
	--   Blizzard_GarrisonMissionUI   --
	----====####$$$$%%%%$$$$####====----

	MERS:GarrisonFollowerPortraitTemplate(GarrisonFollowerPlacer)

	----====####$$$$%%%%%%%%$$$$####====-
	--   Blizzard_OrderHallMissionUI   --
	----====####$$$$%%%%%$$$$####====----
	local OrderHallMissionFrame = _G["OrderHallMissionFrame"]
	MERS:GarrisonMissionFrameTemplate(OrderHallMissionFrame)
	MERS:GarrisonUITemplate(OrderHallMissionFrame)

	OrderHallMissionFrame.ClassHallIcon:SetClipsChildren(true)
	OrderHallMissionFrame.ClassHallIcon:SetFrameLevel(OrderHallMissionFrame:GetFrameLevel() + 1)
	OrderHallMissionFrame.ClassHallIcon:SetFrameStrata(OrderHallMissionFrame:GetFrameStrata())
	OrderHallMissionFrame.ClassHallIcon:SetPoint("TOPLEFT")
	OrderHallMissionFrame.ClassHallIcon:SetSize(200, 200)
	local _, className = UnitClass("player")
	OrderHallMissionFrame.ClassHallIcon.Icon:ClearAllPoints()
	OrderHallMissionFrame.ClassHallIcon.Icon:SetPoint("CENTER", OrderHallMissionFrame.ClassHallIcon, "TOPLEFT", 50, -50)
	OrderHallMissionFrame.ClassHallIcon.Icon:SetAtlas("legionmission-landingpage-background-"..className, true)
	OrderHallMissionFrame.ClassHallIcon.Icon:SetDesaturated(true)
	OrderHallMissionFrame.ClassHallIcon.Icon:SetAlpha(0.8)

	OrderHallMissionFrame.Tab1:SetPoint("TOPLEFT", OrderHallMissionFrame, "BOTTOMLEFT", 20, -1)
	OrderHallMissionFrame.Tab2:SetPoint("TOPLEFT", OrderHallMissionFrame.Tab1, "TOPRIGHT", 1, 0)
	OrderHallMissionFrame.Tab3:SetPoint("TOPLEFT", OrderHallMissionFrame.Tab2, "TOPRIGHT", 1, 0)

	------------------
	-- FollowerList --
	------------------
	local OrderHallFollowerList = OrderHallMissionFrame.FollowerList
	MERS:GarrisonListTemplateHeader(OrderHallFollowerList)
	MERS:MaterialFrameTemplate(OrderHallFollowerList.MaterialFrame)
	OrderHallFollowerList.MaterialFrame:SetPoint("TOPLEFT", OrderHallFollowerList, "BOTTOMLEFT", 0, -2)
	OrderHallFollowerList.MaterialFrame:SetPoint("BOTTOMRIGHT", 0, -30)

	------------
	-- MapTab --
	------------
	local OrderHallMapTab = OrderHallMissionFrame.MapTab
	OrderHallMapTab.ScrollContainer:ClearAllPoints()
	OrderHallMapTab.ScrollContainer:SetPoint("TOPLEFT")
	OrderHallMapTab.ScrollContainer:SetPoint("BOTTOMRIGHT")

	----------------
	-- MissionTab --
	----------------
	local OrderHallMissionTab = OrderHallMissionFrame.MissionTab
	MERS:GarrisonMissionListTemplate(OrderHallMissionTab.MissionList)

	local CombatAllyUI = OrderHallMissionTab.MissionList.CombatAllyUI
	CombatAllyUI.Background:Hide()

	local AddFollowerButton = CombatAllyUI.Available.AddFollowerButton
	AddFollowerButton.EmptyPortrait:Hide()
	AddFollowerButton.Plus:SetSize(42, 42)
	AddFollowerButton.Plus:SetPoint("CENTER", 0, 5)
	local portraitBG = CreateFrame("Frame", nil, AddFollowerButton)
	portraitBG:SetFrameLevel(AddFollowerButton:GetFrameLevel())
	portraitBG:SetPoint("TOPLEFT", AddFollowerButton.Plus, -1, 1)
	portraitBG:SetPoint("BOTTOMRIGHT", AddFollowerButton.Plus, 1, -1)
	AddFollowerButton.PortraitHighlight:SetTexture([[Interface\Buttons\CheckButtonHilight-Blue]])
	AddFollowerButton.PortraitHighlight:SetTexCoord(0.234375, 0.765625, 0.234375, 0.765625)
	AddFollowerButton.PortraitHighlight:SetAllPoints(portraitBG)

	MERS:GarrisonFollowerPortraitTemplate(CombatAllyUI.InProgress.PortraitFrame)
	MERS:GarrisonFollowerCombatAllySpellTemplate(CombatAllyUI.InProgress.CombatAllySpell)

	MERS:GarrisonFollowerPortraitTemplate(CombatAllyUI.InProgress.PortraitFrame)
	MERS:GarrisonFollowerCombatAllySpellTemplate(CombatAllyUI.InProgress.CombatAllySpell)

	---------------------
	-- MissionComplete --
	---------------------
	OrderHallMissionFrame.MissionCompleteBackground:SetAllPoints(OrderHallMissionFrame)
	local OrderHallMissionComplete = OrderHallMissionFrame.MissionComplete
	MERS:GarrisonMissionPageBaseTemplate(OrderHallMissionComplete)
	MERS:GarrisonMissionCompleteTemplate(OrderHallMissionComplete)
	MERS:GarrisonFollowerMissionCompleteStageTemplate(OrderHallMissionComplete.Stage)
	MERS:GarrisonFollowerMissionRewardsFrameTemplate(OrderHallMissionComplete.BonusRewards)

	----====####$$$$%%%%%$$$$####====----
	--      Blizzard_BFAMissionUI      --
	----====####$$$$%%%%%$$$$####====----
	local BFAMissionFrame = _G["BFAMissionFrame"]
	MERS:GarrisonMissionFrameTemplate(BFAMissionFrame)
	MERS:GarrisonUITemplate(BFAMissionFrame)
	BFAMissionFrame.CloseButtonBorder:Hide()
	BFAMissionFrame.TitleScroll:Hide()

	------------------
	-- FollowerList --
	------------------
	local BFAFollowerList = BFAMissionFrame.FollowerList
	MERS:GarrisonListTemplateHeader(BFAFollowerList)
	MERS:MaterialFrameTemplate(BFAFollowerList.MaterialFrame)
	BFAFollowerList.MaterialFrame:SetPoint("TOPLEFT", BFAFollowerList, "BOTTOMLEFT", 0, -2)
	BFAFollowerList.MaterialFrame:SetPoint("BOTTOMRIGHT", 0, -30)

	------------
	-- MapTab --
	------------
	local BFAMapTab = BFAMissionFrame.MapTab
	BFAMapTab.ScrollContainer:ClearAllPoints()
	BFAMapTab.ScrollContainer:SetPoint("TOPLEFT")
	BFAMapTab.ScrollContainer:SetPoint("BOTTOMRIGHT")

	----------------
	-- MissionTab --
	----------------
	local BFAMissionTab = BFAMissionFrame.MissionTab
	MERS:GarrisonMissionListTemplate(BFAMissionTab.MissionList)

	-----------------
	-- FollowerTab --
	-----------------
	local BFAFollowerTab = BFAMissionFrame.FollowerTab
	MERS:GarrisonFollowerTabTemplate(BFAFollowerTab)

	---------------------
	-- MissionComplete --
	---------------------
	BFAMissionFrame.MissionCompleteBackground:SetAllPoints(BFAMissionFrame)
	local BFAMissionComplete = BFAMissionFrame.MissionComplete
	MERS:GarrisonMissionPageBaseTemplate(BFAMissionComplete)
	MERS:GarrisonMissionCompleteTemplate(BFAMissionComplete)
	MERS:GarrisonFollowerMissionCompleteStageTemplate(BFAMissionComplete.Stage)
	MERS:GarrisonFollowerMissionRewardsFrameTemplate(BFAMissionComplete.BonusRewards)
end

S:AddCallbackForAddon("Blizzard_GarrisonUI", "mUIGarrison", styleGarrison)