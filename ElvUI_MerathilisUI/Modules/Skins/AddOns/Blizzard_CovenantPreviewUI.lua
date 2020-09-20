local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc
local CreateFrame = CreateFrame

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.covenantPreview) or E.private.muiSkins.blizzard.covenantPreview ~= true then return end

	local frame = _G.CovenantPreviewFrame
	frame:Styling()

	frame.Title:DisableDrawLayer('BACKGROUND')
	frame.Background:SetAlpha(0)
	frame.BorderFrame:SetAlpha(0)
	frame.InfoPanel.Parchment:SetAlpha(0)
end

S:AddCallbackForAddon('Blizzard_CovenantPreviewUI', 'muiCovenantPreview', LoadSkin)
