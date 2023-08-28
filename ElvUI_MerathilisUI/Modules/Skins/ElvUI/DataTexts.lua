local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
local LO = E:GetModule('Layout')
local M = E:GetModule('Minimap')

local _G = _G

local PANEL_HEIGHT = 19
local SPACING = (E.PixelMode and 1 or 3)

function module:ResizeMinimapPanels()
	_G.MinimapPanel:Point('TOPLEFT', _G.Minimap.backdrop, 'BOTTOMLEFT', 0, -SPACING)
	_G.MinimapPanel:Point('BOTTOMRIGHT', _G.Minimap.backdrop, 'BOTTOMRIGHT', 0, -(SPACING + PANEL_HEIGHT))
end

function module:ElvUI_MinimapPanels()
	if not (E.private.mui.skins.shadow.enable) then
		return
	end

	if E.private.general.minimap.enable then
		self:ResizeMinimapPanels()
	end

	if E.db.datatexts.panels.MinimapPanel.backdrop then
		self:CreateShadow(_G.MinimapPanel)
		_G.MinimapPanel:Styling()
	end

	hooksecurefunc(LO, 'ToggleChatPanels', module.ResizeMinimapPanels)
	hooksecurefunc(M, 'UpdateSettings', module.ResizeMinimapPanels)
end

module:AddCallback("ElvUI_MinimapPanels")
