local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("covenantPreview", "covenantPreview") then
		return
	end

	local frame = _G.CovenantPreviewFrame
	module:CreateBackdropShadow(frame)

	frame.Title:DisableDrawLayer('BACKGROUND')
	frame.Background:SetAlpha(0)
	frame.BorderFrame:SetAlpha(0)
	frame.InfoPanel.Parchment:SetAlpha(0)

	frame.InfoPanel.Name:SetTextColor(1, 1, 1)
	frame.InfoPanel.Location:SetTextColor(1, 1, 1)
	frame.InfoPanel.Description:SetTextColor(1, 1, 1)
	frame.InfoPanel.AbilitiesFrame.AbilitiesLabel:SetTextColor(1, .8, 0)
	frame.InfoPanel.SoulbindsFrame.SoulbindsLabel:SetTextColor(1, .8, 0)
	frame.InfoPanel.CovenantFeatureFrame.Label:SetTextColor(1, .8, 0)
end

S:AddCallbackForAddon('Blizzard_CovenantPreviewUI', LoadSkin)
