local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local getn = getn
local next, pairs, select = next, pairs, select
local tinsert = table.insert
-- WoW API
local hooksecurefunc = hooksecurefunc
local WorldStateAlwaysUpFrame = _G["WorldStateAlwaysUpFrame"]
-- GLOBALS: hooksecurefunc, NUM_ALWAYS_UP_UI_FRAMES

local MAX_STATIC_POPUPS = 4

local function styleMisc()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.misc ~= true then return end

	local GameMenuFrame = _G.GameMenuFrame
	GameMenuFrame:Styling()

	-- GameMenu Header Color
	for i = 1, GameMenuFrame:GetNumRegions() do
		local Region = select(i, GameMenuFrame:GetRegions())
		if Region.IsObjectType and Region:IsObjectType('FontString') then
			Region:SetTextColor(1, 1, 1)
		end
	end

	-- Graveyard button (a bit ugly if you press it)
	_G.GhostFrame:StripTextures()
	_G.GhostFrameContentsFrame:StripTextures()

	-- tooltips
	local tooltips = {
		_G.GameTooltip,
		_G.FriendsTooltip,
		_G.ItemRefTooltip,
		_G.ItemRefShoppingTooltip1,
		_G.ItemRefShoppingTooltip2,
		_G.ItemRefShoppingTooltip3,
		_G.AutoCompleteBox,
		_G.ShoppingTooltip1,
		_G.ShoppingTooltip2,
		_G.ShoppingTooltip3,
		_G.FloatingBattlePetTooltip,
		_G.FloatingPetBattleAbilityTooltip,
		_G.FloatingGarrisonFollowerTooltip,
		_G.FloatingGarrisonFollowerAbilityTooltip,
		_G.WorldMapTooltip,
		_G.WorldMapCompareTooltip1,
		_G.WorldMapCompareTooltip2,
		_G.WorldMapCompareTooltip3,
		_G.DropDownList1MenuBackdrop,
		_G.DropDownList2MenuBackdrop,
		_G.DropDownList3MenuBackdrop,
		_G.PetBattlePrimaryUnitTooltip,
		_G.PetBattlePrimaryAbilityTooltip,
		_G.EventTraceTooltip,
		_G.FrameStackTooltip,
		_G.QuestScrollFrame.WarCampaignTooltip,
		_G.QuestScrollFrame.StoryTooltip,
		_G.DatatextTooltip,
	}

	for _, frame in pairs(tooltips) do
		if frame and not frame.style then
			frame:Styling()
		end
	end

	local skins = {
		"StaticPopup1",
		"StaticPopup2",
		"StaticPopup3",
		"StaticPopup4",
		"CopyChatFrame",
		"InterfaceOptionsFrame",
		"VideoOptionsFrame",
		"AudioOptionsFrame",
		"AutoCompleteBox",
		"ReadyCheckFrame",
		"StackSplitFrame",
		"QueueStatusFrame",
		"LFDReadyCheckPopup",
		"DropDownList1Backdrop",
		"DropDownList1MenuBackdrop",
	}

	for i = 1, getn(skins) do
		_G[skins[i]]:Styling()
	end

	for i = 1, MAX_STATIC_POPUPS do
		local frame = _G["ElvUI_StaticPopup"..i]
		frame:Styling()
	end

	--DropDownMenu library support
	if _G.LibStub("LibUIDropDownMenu", true) then
		_G.L_DropDownList1Backdrop:Styling()
		_G.L_DropDownList1MenuBackdrop:Styling()
		hooksecurefunc("L_UIDropDownMenu_CreateFrames", function()
			if not _G["L_DropDownList".._G.L_UIDROPDOWNMENU_MAXLEVELS.."Backdrop"].template then
				_G["L_DropDownList".._G.L_UIDROPDOWNMENU_MAXLEVELS.."Backdrop"]:Styling()
				_G["L_DropDownList".._G.L_UIDROPDOWNMENU_MAXLEVELS.."MenuBackdrop"]:Styling()
			end
		end)
	end

	-- QueueStatusFrame
	local function SkinEntry(entry)
		for _, roleButton in next, {entry.HealersFound, entry.TanksFound, entry.DamagersFound} do
			roleButton.Texture:SetTexture(E["media"].roleIcons)
			roleButton.Cover:SetTexture(E["media"].roleIcons)

			local left = roleButton:CreateTexture(nil, "OVERLAY")
			left:SetWidth(1)
			left:SetTexture(E["media"].normTex)
			left:SetVertexColor(0, 0, 0)
			left:SetPoint("TOPLEFT", 5, -3)
			left:SetPoint("BOTTOMLEFT", 5, 6)

			local right = roleButton:CreateTexture(nil, "OVERLAY")
			right:SetWidth(1)
			right:SetTexture(E["media"].normTex)
			right:SetVertexColor(0, 0, 0)
			right:SetPoint("TOPRIGHT", -4, -3)
			right:SetPoint("BOTTOMRIGHT", -4, 6)

			local top = roleButton:CreateTexture(nil, "OVERLAY")
			top:SetHeight(1)
			top:SetTexture(E["media"].normTex)
			top:SetVertexColor(0, 0, 0)
			top:SetPoint("TOPLEFT", 5, -3)
			top:SetPoint("TOPRIGHT", -4, -3)

			local bottom = roleButton:CreateTexture(nil, "OVERLAY")
			bottom:SetHeight(1)
			bottom:SetTexture(E["media"].normTex)
			bottom:SetVertexColor(0, 0, 0)
			bottom:SetPoint("BOTTOMLEFT", 5, 6)
			bottom:SetPoint("BOTTOMRIGHT", -4, 6)
		end

		for i = 1, _G.LFD_NUM_ROLES do
			local roleIcon = entry["RoleIcon"..i]

			roleIcon:SetTexture(E["media"].roleIcons)

			entry["RoleIconBorders"..i] = {}
			local borders = entry["RoleIconBorders"..i]

			local left = entry:CreateTexture(nil, "OVERLAY")
			left:SetWidth(1)
			left:SetTexture(E["media"].normTex)
			left:SetVertexColor(0, 0, 0)
			left:SetPoint("TOPLEFT", roleIcon, 2, -2)
			left:SetPoint("BOTTOMLEFT", roleIcon, 2, 3)
			tinsert(borders, left)

			local right = entry:CreateTexture(nil, "OVERLAY")
			right:SetWidth(1)
			right:SetTexture(E["media"].normTex)
			right:SetVertexColor(0, 0, 0)
			right:SetPoint("TOPRIGHT", roleIcon, -2, -2)
			right:SetPoint("BOTTOMRIGHT", roleIcon, -2, 3)
			tinsert(borders, right)

			local top = entry:CreateTexture(nil, "OVERLAY")
			top:SetHeight(1)
			top:SetTexture(E["media"].normTex)
			top:SetVertexColor(0, 0, 0)
			top:SetPoint("TOPLEFT", roleIcon, 2, -2)
			top:SetPoint("TOPRIGHT", roleIcon, -2, -2)
			tinsert(borders, top)

			local bottom = entry:CreateTexture(nil, "OVERLAY")
			bottom:SetHeight(1)
			bottom:SetTexture(E["media"].normTex)
			bottom:SetVertexColor(0, 0, 0)
			bottom:SetPoint("BOTTOMLEFT", roleIcon, 2, 3)
			bottom:SetPoint("BOTTOMRIGHT", roleIcon, -2, 3)
			tinsert(borders, bottom)
		end

		entry.IsSkinned = true
	end

	for i = 1, 9 do
		select(i, _G.QueueStatusFrame:GetRegions()):Hide()
	end

	hooksecurefunc("QueueStatusEntry_SetFullDisplay", function(entry)
		if not entry.IsSkinned then
			SkinEntry(entry)
		end

		for i = 1, _G.LFD_NUM_ROLES do
			local shown = entry["RoleIcon"..i]:IsShown()

			for _, border in next, entry["RoleIconBorders"..i] do
				border:SetShown(shown)
			end
		end
	end)

	local TalentMicroButtonAlert = _G.TalentMicroButtonAlert
	if TalentMicroButtonAlert then
		TalentMicroButtonAlert:Styling()
	end

	-- What's New
	_G.SplashFrame:Styling()

	-- Chat Config
	_G.ChatConfigFrame:Styling()

	-- ElvUI Stuff
	_G.LeftMiniPanel:Styling()
	_G.RightMiniPanel:Styling()
	_G.ElvUI_TopPanel:Styling()
	_G.ElvUI_BottomPanel:Styling()

	-- Mirror Timers
	_G.MirrorTimer1StatusBar.backdrop:Styling()
	_G.MirrorTimer2StatusBar.backdrop:Styling()
	_G.MirrorTimer3StatusBar.backdrop:Styling()
end

S:AddCallback("mUIBlizzMisc", styleMisc)
