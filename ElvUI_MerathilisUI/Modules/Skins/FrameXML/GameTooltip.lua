local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
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

function module:GameTooltip()
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
		if frame and not frame ~= E.ScanTooltip and not frame.IsEmbedded and not frame:IsForbidden() then
			module:CreateShadow(frame)

			frame.IsEmbedded = true
		end
	end

	module:CreateShadow(_G.FloatingBattlePetTooltip)

	module:SecureHook(TT, "SetStyle", "SetTooltipStyle")
	module:SecureHook(TT, "GameTooltip_SetDefaultAnchor", "TTGameTooltip_SetDefaultAnchor")
	module:SecureHook(_G.QueueStatusFrame, "Update", "CreateShadow")
	module:SecureHook(_G.GameTooltip, "Show", "StyleTooltipsIcons")
end

local function styleIconString(text)
	if not text or not strfind(text, "|T.+|t") then
		return
	end

	text = gsub(text, "|T([^:]+):0|t", function(texture)
		if strfind(texture, "Addons") or texture == "0" then
			return format("|T%s:0|t", texture)
		else
			return format("|T%s:0:0:0:0:64:64:5:59:5:59|t", texture)
		end
	end)

	return text
end

local function styleIconsInLine(line)
	if line then
		local styledText = styleIconString(line:GetText())
		if styledText then
			line:SetText(styledText)
		end
	end
end

function module:StyleTooltipsIcons(tt)
	for i = 2, tt:NumLines() do
		styleIconsInLine(_G[tt:GetName() .. "TextLeft" .. i])
		styleIconsInLine(_G[tt:GetName() .. "TextRight" .. i])
	end
end

module:AddCallback("GameTooltip")
