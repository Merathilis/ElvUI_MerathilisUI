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
	function MERS.GarrisonFollowerMission_RemoveFollowerFromMission(self, frame, updateValues)
		MERS.GarrisonFollowerPortraitMixin_SetQuality(frame.PortraitFrame, 1)
	end

	--[[ AddOns\Blizzard_GarrisonUI.xml ]]
	--[[ Blizzard_GarrisonShipyardUI.xml ]]
	function MERS:GarrisonBonusEffectFrameTemplate(Frame)
		S:CropIcon(Frame.Icon, Frame)
	end

	function MERS:GarrisonBonusAreaTooltipFrameTemplate(Frame)
		MERS:GarrisonBonusEffectFrameTemplate(Frame.BonusEffectFrame)
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
	end

	function MERS:GarrisonMissionPageBaseTemplate(Frame)
	end

	function MERS:GarrisonMissionListTemplate(Frame)
		MERS:GarrisonListTemplate(Frame)
		MERS:GarrisonMissionListTabTemplate(Frame.Tab1)
		MERS:GarrisonMissionListTabTemplate(Frame.Tab2)
		MERS:MaterialFrameTemplate(Frame.MaterialFrame)
		Frame.MaterialFrame:SetPoint("BOTTOMRIGHT", Frame, "TOPRIGHT", -9, 9)
		Frame.MaterialFrame:SetPoint("TOPLEFT", Frame, "TOPRIGHT", -307, 34)

		MERS:GarrisonMissionPageBaseTemplate(Frame.CompleteDialog.BorderFrame)
		MERS:GarrisonMissionCompleteDialogTemplate(Frame.CompleteDialog.BorderFrame)
	end

	function MERS:GarrisonFollowerTabTemplate(Frame)
		_G.hooksecurefunc(Frame.abilitiesPool, "Acquire", MERS.ObjectPoolMixin_Acquire)
		_G.hooksecurefunc(Frame.equipmentPool, "Acquire", MERS.ObjectPoolMixin_Acquire)
		_G.hooksecurefunc(Frame.countersPool, "Acquire", MERS.ObjectPoolMixin_Acquire)

		MERS:GarrisonMissionBaseFrameTemplate(Frame)

		Frame.HeaderBG:Hide()

		MERS:GarrisonFollowerPortraitTemplate(Frame.PortraitFrame)
		MERS:GarrisonFollowerXPBarTemplate(Frame.XPBar)

		MERS:GarrisonFollowerCombatAllySpellTemplate(Frame.AbilitiesFrame.CombatAllySpell[1])
		MERS:GarrisonFollowerCombatAllySpellTemplate(Frame.AbilitiesFrame.CombatAllySpell[2])
	end

	--[[ Blizzard_OrderHallMissionUI.xml ]]
	function MERS:OrderHallMissionListButtonTemplate(Button)
		MERS:GarrisonMissionListButtonTemplate(Button)
	end

	--   Blizzard_GarrisonMissionUI   --
	----====####$$$$%%%%$$$$####====----
	hooksecurefunc(GarrisonFollowerMission, "RemoveFollowerFromMission", MERS.GarrisonFollowerMission_RemoveFollowerFromMission)

	MERS:GarrisonFollowerPortraitTemplate(GarrisonFollowerPlacer)

	--   Blizzard_OrderHallMissionUI   --
	----====####$$$$%%%%%$$$$####====----
	local OrderHallMissionFrame = _G["OrderHallMissionFrame"]
	MERS:GarrisonMissionFrameTemplate(OrderHallMissionFrame)
	MERS:GarrisonUITemplate(OrderHallMissionFrame)

	OrderHallMissionFrame.ClassHallIcon:SetClipsChildren(true)
	OrderHallMissionFrame.ClassHallIcon:SetFrameLevel(OrderHallMissionFrame:GetFrameLevel())
	OrderHallMissionFrame.ClassHallIcon:SetFrameStrata(OrderHallMissionFrame:GetFrameStrata())
	OrderHallMissionFrame.ClassHallIcon:SetPoint("TOPLEFT")
	OrderHallMissionFrame.ClassHallIcon:SetSize(200, 200)
	local _, className = UnitClass("player")
	OrderHallMissionFrame.ClassHallIcon.Icon:ClearAllPoints()
	OrderHallMissionFrame.ClassHallIcon.Icon:SetPoint("CENTER", OrderHallMissionFrame.ClassHallIcon, "TOPLEFT", 50, -50)
	OrderHallMissionFrame.ClassHallIcon.Icon:SetAtlas("legionmission-landingpage-background-"..className, true)
	OrderHallMissionFrame.ClassHallIcon.Icon:SetDesaturated(true)

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
end

S:AddCallbackForAddon("Blizzard_GarrisonUI", "mUIGarrison", styleGarrison)