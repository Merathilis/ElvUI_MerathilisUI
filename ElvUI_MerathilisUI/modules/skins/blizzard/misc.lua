local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
-- WoW API
local WorldStateAlwaysUpFrame = WorldStateAlwaysUpFrame
-- GLOBALS: hooksecurefunc, NUM_ALWAYS_UP_UI_FRAMES

local function styleMisc()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.misc ~= true then return end

	hooksecurefunc("WorldStateAlwaysUpFrame_AddFrame", function()
		WorldStateAlwaysUpFrame:ClearAllPoints()
		WorldStateAlwaysUpFrame:SetPoint("TOP", E.UIParent, "TOP", 0, -40)
	end)

	MERS:CreateGradient(GameMenuFrame)
	if not GameMenuFrame.stripes then
		MERS:CreateStripes(GameMenuFrame)
	end

	MERS:CreateGradient(BNToastFrame)
	if not BNToastFrame.stripes then
		MERS:CreateStripes(BNToastFrame)
	end

	-- Graveyard button (a bit ugly if you press it)
	GhostFrame:StripTextures()
	GhostFrameContentsFrame:StripTextures()

	-- tooltips
	local tooltips = {
		GameTooltip,
		FriendsTooltip,
		ItemRefTooltip,
		ItemRefShoppingTooltip1,
		ItemRefShoppingTooltip2,
		ItemRefShoppingTooltip3,
		AutoCompleteBox,
		ShoppingTooltip1,
		ShoppingTooltip2,
		ShoppingTooltip3,
		FloatingBattlePetTooltip,
		FloatingPetBattleAbilityTooltip,
		FloatingGarrisonFollowerAbilityTooltip,
		WorldMapTooltip,
		WorldMapCompareTooltip1,
		WorldMapCompareTooltip2,
		WorldMapCompareTooltip3,
		DropDownList1MenuBackdrop,
		DropDownList2MenuBackdrop,
		DropDownList3MenuBackdrop,
	}

	for _, frame in pairs(tooltips) do
		if frame and not frame.style then
			MERS:CreateGradient(frame)
		end
	end
end

S:AddCallback("mUIBlizzMisc", styleMisc)