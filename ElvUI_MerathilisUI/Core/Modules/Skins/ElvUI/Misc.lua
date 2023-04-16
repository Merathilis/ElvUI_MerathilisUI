local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

function module:ElvUI_Misc()
	if not module:CheckDB("misc", "misc") then
		return
	end

	local LeftChatDataPanel = _G.LeftChatDataPanel
	if LeftChatDataPanel then
		LeftChatDataPanel:Styling()
	end

	local RightChatDataPanel = _G.RightChatDataPanel
	if RightChatDataPanel then
		RightChatDataPanel:Styling()
	end

	local ElvUI_TopPanel = _G.ElvUI_TopPanel
	if ElvUI_TopPanel then
		ElvUI_TopPanel:Styling()
	end

	local ElvUI_BottomPanel = _G.ElvUI_BottomPanel
	if ElvUI_BottomPanel then
		ElvUI_BottomPanel:Styling()
    end

	local ElvUI_MinimapClusterBackdrop = _G.ElvUI_MinimapClusterBackdrop
	if ElvUI_MinimapClusterBackdrop then
		ElvUI_MinimapClusterBackdrop:SetTemplate('Transparent')
		ElvUI_MinimapClusterBackdrop:Styling()
		module:CreateBackdropShadow(ElvUI_MinimapClusterBackdrop)
	end
end

module:AddCallback("ElvUI_Misc")
