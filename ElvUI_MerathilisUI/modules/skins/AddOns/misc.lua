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
local IsAddOnLoaded = IsAddOnLoaded
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
	_G.GhostFrame:CreateBackdrop("Transparent")
	_G.GhostFrame.backdrop:Styling()

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

	-- RaiderIO Dropdown
	if IsAddOnLoaded('RaiderIO') then
		_G.RaiderIO_CustomDropDownList:Styling()
		_G.RaiderIO_ProfileTooltip:Styling()
	end

	if _G.CopyChatFrame then
		_G.CopyChatFrame:Styling()
	end

	for i = 1, MAX_STATIC_POPUPS do
		local frame = _G["ElvUI_StaticPopup"..i]
		frame:Styling()
	end

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

	-- DataStore
	if IsAddOnLoaded("DataStore") then
		local frame = _G.DataStoreFrame
		if frame then
			frame:Styling()
		end
	end
end

S:AddCallback("mUIBlizzMisc", styleMisc)
