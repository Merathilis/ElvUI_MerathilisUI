local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule('MER_SpellAlert', 'AceEvent-3.0')

local _G = _G
local GetCVar = GetCVar

function module:UpdatePosition()
	_G.SpellActivationOverlayFrame:SetScale(E.db.mui.misc.spellAlert or 1)

	_G.SpellActivationOverlayFrame:SetFrameStrata('MEDIUM')
	_G.SpellActivationOverlayFrame:SetFrameLevel(1)
end

function module:UpdateAppearance()
	_G.SpellActivationOverlayFrame:SetAlpha(GetCVar('spellActivationOverlayOpacity'))
end

function module:Resize()
	_G.SpellActivationOverlayFrame:SetScale(E.db.mui.misc.spellAlert or 1)
end

function module:PLAYER_LOGIN()
	if not E.Retail then return end

	module:UpdatePosition()
	module:UpdateAppearance()
	module:Resize()
end

function module:Initialize()
	self:RegisterEvent('PLAYER_LOGIN')
end

MER:RegisterModule(module:GetName())
