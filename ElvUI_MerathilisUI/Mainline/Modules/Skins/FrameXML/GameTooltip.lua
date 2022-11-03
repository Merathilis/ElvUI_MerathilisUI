local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local TT = E:GetModule("Tooltip")
local S = E:GetModule('Skins')

local _G = _G
local pairs = pairs

function module:SetTooltipStyle(_, tt)
	if tt and tt ~= E.ScanTooltip and not tt.IsEmbedded and not tt:IsForbidden() then
		if tt.widgetContainer then
			if tt.TopOverlay then
				tt.TopOverlay:StripTextures()
			end
			if tt.BottomOverlay then
				tt.BottomOverlay:StripTextures()
			end
			if tt.NineSlice then
				module:StripEdgeTextures(tt.NineSlice)
			end
			tt:SetTemplate("Transparent")
		end
		module:CreateShadow(tt)
	end
end

function module:TTGameTooltip_SetDefaultAnchor(_, tt)
	if (tt.StatusBar) then
		module:CreateBackdropShadow(tt.StatusBar)
	end

	if _G.GameTooltipStatusBar then
		module:CreateShadow(_G.GameTooltipStatusBar, 6)
	end
end

local function LoadSkin()
	if not module:CheckDB("tooltip", "tooltip") then
		return
	end

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
		_G.DatatextTooltip,
		_G.WarCampaignTooltip,
		_G.EmbeddedItemTooltip,
		_G.ReputationParagonTooltip,
		_G.ElvUISpellBookTooltip,
		_G.QuestScrollFrame.StoryTooltip,
		_G.QuestScrollFrame.CampaignTooltip,
		_G.QuestScrollFrame.WarCampaignTooltip,
		_G.DataTextTooltip,
		_G.BattlePetTooltip,
		_G.SettingsTooltip,
	}

	for _, frame in pairs(tooltips) do
		if frame and not frame.__MERSkin then
			frame:Styling()
			module:CreateShadow(frame)
			frame.__MERSkin = true
		end
	end

	module:SecureHook(TT, "SetStyle", "SetTooltipStyle")
	module:SecureHook(TT, "GameTooltip_SetDefaultAnchor", "TTGameTooltip_SetDefaultAnchor")
end

module:AddCallback("GameTooltip", LoadSkin)
