local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule('RectangelMinimap')
local MM = E:GetModule('Minimap')

-- Credits Shadow&Light

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

local BAR_HEIGHT = 22

function module:SkinMiniMap()
-- local function SkinMiniMap()
	_G.Minimap:SetMaskTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\rectangle')
	_G.Minimap:Size(E.MinimapSize, E.MinimapSize)
	_G.Minimap:SetHitRectInsets(0, 0, (E.MinimapSize/6.1)*E.mult, (E.MinimapSize/6.1)*E.mult)
	_G.Minimap:SetClampRectInsets(0, 0, 0, 0)

	module:UpdateMoverSize()

	--*Relocated Minimap to MMHolder
	_G.Minimap:ClearAllPoints()
	--_G.Minimap:Point("TOPRIGHT", _G.MMHolder, "TOPRIGHT", -E.Border, E.Border)

	--*Below sets mover to same size of minimap, I didn't do this on purpose due to people moving the minimap in an area not good
	_G.Minimap:Point("TOPRIGHT", _G.MMHolder, "TOPRIGHT", -E.Border, (E.MinimapSize/6.1)+E.Border)

	if _G.Minimap.location then
		module:UpdateLocationText()
	end

	_G.MinimapPanel:ClearAllPoints()
	_G.MinimapPanel:Point('TOPLEFT', _G.Minimap, 'BOTTOMLEFT', -1, (E.MinimapSize/6.1)-1)
	_G.MinimapPanel:Point('BOTTOMRIGHT', _G.Minimap, 'BOTTOMRIGHT', 1, ((E.MinimapSize/6.1)-BAR_HEIGHT)-1)

	if _G.Minimap.backdrop then
		_G.Minimap.backdrop:SetOutside(_G.Minimap, 1, -(E.MinimapSize/6.1)+1)
	end
end

function module:UpdateMoverSize()
	if E.db.datatexts.panels.MinimapPanel.enable then
		_G.MMHolder:Height((_G.Minimap:GetHeight() + (_G.MinimapPanel and (_G.MinimapPanel:GetHeight() + E.Border) or 24)) + E.Spacing*3-((E.MinimapSize/6.1)))
	else
		_G.MMHolder:Height((_G.Minimap:GetHeight() + E.Border + E.Spacing*3)-(E.MinimapSize/6.1))
	end
end

function module:UpdateOwnSettings()
	if not E.db.mui.maps.minimap.rectangle then return end

	-- Probably bad idea
	if not E.db.movers then
		E.db.movers = {}
	end

	E.db["general"]["minimap"]["size"] = 214
	E.db["general"]["minimap"]["icons"]["classHall"]["yOffset"] = -60
	E.db["general"]["minimap"]["icons"]["mail"]["yOffset"] = 30

	E.db["movers"]["MinimapMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-2,11"

	E.global["datatexts"]["customPanels"]["MER_RightChatTop"]["numPoints"] = 2
	E.global["datatexts"]["customPanels"]["MER_RightChatTop"]["width"] = 235
	E.db["datatexts"]["panels"]["MER_RightChatTop"] = {
		[1] = "Durability",
		[2] = "Gold",
		["enable"] = true,
	}

	E.db["chat"]["panelWidthRight"] = 235
	E.db["movers"]["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-219,47"

	E.db["mui"]["maps"]["minimap"]["ping"]["yOffset"] = -60
end

function module:UpdateLocationText()
	_G.Minimap.location:ClearAllPoints()
	_G.Minimap.location:Point('TOP', _G.Minimap, 'TOP', 0, -22)
end

function module:Initialize()
	if not E.private.general.minimap.enable or not E.db.mui.maps.minimap.rectangle then return end

	module:SkinMiniMap()
	module:UpdateOwnSettings()
	hooksecurefunc(MM, "UpdateSettings", module.UpdateMoverSize)
end

MER:RegisterModule(module:GetName())
