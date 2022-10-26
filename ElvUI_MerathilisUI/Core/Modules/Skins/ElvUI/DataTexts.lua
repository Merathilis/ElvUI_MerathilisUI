local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = MER:GetModule('MER_Skins')
local LO = E:GetModule('Layout')
local M = E:GetModule('Minimap')

local _G = _G

local PANEL_HEIGHT = 19;
local SPACING = (E.PixelMode and 1 or 3)

function S:ResizeMinimapPanels()
	_G.MinimapPanel:Point('TOPLEFT', _G.Minimap.backdrop, 'BOTTOMLEFT', 0, -SPACING)
	_G.MinimapPanel:Point('BOTTOMRIGHT', _G.Minimap.backdrop, 'BOTTOMRIGHT', 0, -(SPACING + PANEL_HEIGHT))
end

function S:ElvUI_MinimapPanels()
	if not (E.private.mui.skins.shadow.enable) then
		return
	end

	if E.private.general.minimap.enable then
		self:ResizeMinimapPanels()
	end

	self:CreateShadow(_G.MinimapPanel)
	_G.MinimapPanel:Styling()

	hooksecurefunc(LO, 'ToggleChatPanels', S.ResizeMinimapPanels)
	hooksecurefunc(M, 'UpdateSettings', S.ResizeMinimapPanels)
end

S:AddCallback("ElvUI_MinimapPanels")
