local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local pairs = pairs
-- WoW API
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS:

local function styleGameTooltip()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.tooltip ~= true then return end

	local StoryTooltip = _G.QuestScrollFrame.StoryTooltip

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
		_G.PetBattlePrimaryUnitTooltip,
		_G.PetBattlePrimaryAbilityTooltip,
		_G.EventTraceTooltip,
		_G.FrameStackTooltip,
		_G.QuestScrollFrame.WarCampaignTooltip,
		_G.QuestScrollFrame.StoryTooltip,
		_G.DatatextTooltip,
		_G.WarCampaignTooltip,
		_G.EmbeddedItemTooltip,
		_G.ReputationParagonTooltip,
		StoryTooltip,
	}

	for _, frame in pairs(tooltips) do
		if frame and not frame.style then
			frame:Styling()
		end
	end
end

S:AddCallback("mUIGameTooltip", styleGameTooltip)
