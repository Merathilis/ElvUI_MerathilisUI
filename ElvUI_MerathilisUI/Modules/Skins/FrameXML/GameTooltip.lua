local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local TT = E:GetModule("Tooltip")

local _G = _G

function module:SetTooltipStyle(_, tt)
	if tt and tt ~= E.ScanTooltip and not tt.IsEmbedded and not tt:IsForbidden() then
		if tt.NineSlice then
			self:CreateShadow(tt.NineSlice)
		end

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
	end
end

function module:GameTooltip()
	if not module:CheckDB("tooltip", "tooltip") then
		return
	end

	local tooltips = {
		E.ConfigTooltip,
		E.SpellBookTooltip,
		_G.AceConfigDialogTooltip,
		_G.AceGUITooltip,
		_G.BattlePetTooltip,
		_G.DataTextTooltip,
		_G.ElvUIConfigTooltip,
		_G.ElvUISpellBookTooltip,
		_G.EmbeddedItemTooltip,
		_G.FloatingBattlePetTooltip,
		_G.FloatingPetBattleAbilityTooltip,
		_G.FriendsTooltip,
		_G.GameSmallHeaderTooltip,
		_G.GameTooltip,
		_G.ItemRefShoppingTooltip1,
		_G.ItemRefShoppingTooltip2,
		_G.ItemRefTooltip,
		_G.LibDBIconTooltip,
		_G.PetBattlePrimaryAbilityTooltip,
		_G.PetBattlePrimaryUnitTooltip,
		_G.QuestScrollFrame.CampaignTooltip,
		_G.QuestScrollFrame.StoryTooltip,
		_G.QuickKeybindTooltip,
		_G.ReputationParagonTooltip,
		_G.SettingsTooltip,
		_G.ShoppingTooltip1,
		_G.ShoppingTooltip2,
		_G.WarCampaignTooltip,
	}

	for _, tt in pairs(tooltips) do
		if tt and tt ~= E.ScanTooltip and not tt.IsEmbedded and not tt:IsForbidden() then
			module:CreateShadow(tt.NineSlice)
		end
	end

	module:CreateBackdropShadow(_G.GameTooltipStatusBar)

	module:SecureHook(TT, "SetStyle", "SetTooltipStyle")
	module:SecureHook(TT, "GameTooltip_SetDefaultAnchor", function(_, tt)
		if tt.StatusBar and tt.StatusBar.backdrop then
			self:CreateBackdropShadow(tt.StatusBar)
		end
	end)
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
