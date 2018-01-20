local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local getn = getn
local pairs = pairs
-- WoW API
local WorldStateAlwaysUpFrame = _G["WorldStateAlwaysUpFrame"]
-- GLOBALS: hooksecurefunc, NUM_ALWAYS_UP_UI_FRAMES

local function styleMisc()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.misc ~= true then return end

	hooksecurefunc("WorldStateAlwaysUpFrame_AddFrame", function()
		WorldStateAlwaysUpFrame:ClearAllPoints()
		WorldStateAlwaysUpFrame:SetPoint("TOP", E.UIParent, "TOP", 0, -40)
	end)

	_G["GameMenuFrame"]:Styling()

	-- Graveyard button (a bit ugly if you press it)
	_G["GhostFrame"]:StripTextures()
	_G["GhostFrameContentsFrame"]:StripTextures()

	-- tooltips
	local tooltips = {
		_G["GameTooltip"],
		_G["FriendsTooltip"],
		_G["ItemRefTooltip"],
		_G["ItemRefShoppingTooltip1"],
		_G["ItemRefShoppingTooltip2"],
		_G["ItemRefShoppingTooltip3"],
		_G["AutoCompleteBox"],
		_G["ShoppingTooltip1"],
		_G["ShoppingTooltip2"],
		_G["ShoppingTooltip3"],
		_G["FloatingBattlePetTooltip"],
		_G["FloatingPetBattleAbilityTooltip"],
		_G["FloatingGarrisonFollowerAbilityTooltip"],
		_G["WorldMapTooltip"],
		_G["WorldMapCompareTooltip1"],
		_G["WorldMapCompareTooltip2"],
		_G["WorldMapCompareTooltip3"],
		_G["DropDownList1MenuBackdrop"],
		_G["DropDownList2MenuBackdrop"],
		_G["DropDownList3MenuBackdrop"],
		_G["PetBattlePrimaryUnitTooltip"],
		_G["PetBattlePrimaryAbilityTooltip"],
		_G["EventTraceTooltip"],
		_G["FrameStackTooltip"],
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

		--DropDownMenu library support
		"L_DropDownList1Backdrop",
		"L_DropDownList1MenuBackdrop"
	}

	for i = 1, getn(skins) do
		_G[skins[i]]:Styling()
	end

	if TalentMicroButtonAlert then
		TalentMicroButtonAlert:Styling()
	end
end

S:AddCallback("mUIBlizzMisc", styleMisc)