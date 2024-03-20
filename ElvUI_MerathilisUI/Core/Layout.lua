local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Layout')

local _G = _G

local PANEL_HEIGHT = 19
local SPACING = (E.PixelMode and 1 or 3)

local MER_DCHAT = CreateFrame('Frame', 'MERDummyChat', E.UIParent)
local MER_DEB = CreateFrame('Frame', 'MERDummyEditBoxHolder', E.UIParent)

function module:PositionEditBoxHolder(bar, above)
	MER_DEB:ClearAllPoints()

	if above then
		MER_DEB:Point('BOTTOMLEFT', bar.backdrop, 'TOPLEFT', 0, SPACING)
		MER_DEB:Point('TOPRIGHT', bar.backdrop, 'TOPRIGHT', 0, (PANEL_HEIGHT + 6))
	else
		MER_DEB:Point('TOPLEFT', bar.backdrop, 'BOTTOMLEFT', 0, -SPACING)
		MER_DEB:Point('BOTTOMRIGHT', bar.backdrop, 'BOTTOMRIGHT', 0, -(PANEL_HEIGHT + 6))
	end
end

function module:CreateLayout()
	-- dummy frame for chat/threat (left)
	MER_DCHAT:SetFrameStrata('LOW')
	MER_DCHAT:Point('TOPLEFT', LeftChatPanel, 'BOTTOMLEFT', 0, -SPACING)
	MER_DCHAT:Point('BOTTOMRIGHT', LeftChatPanel, 'BOTTOMRIGHT', 0, -PANEL_HEIGHT - SPACING)
end

function module:Initialize()
	self:CreateLayout()
end

MER:RegisterModule(module:GetName())
