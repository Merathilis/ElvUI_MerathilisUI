local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Layout")

local _G = _G

local PANEL_HEIGHT = 19
local SPACING = (E.PixelMode and 1 or 3)

local MER_DCHAT = CreateFrame("Frame", "MERDummyChat", E.UIParent)

function module:CreateLayout()
	-- dummy frame for chat/threat (left)
	MER_DCHAT:SetFrameStrata("LOW")
	MER_DCHAT:Point("TOPLEFT", _G.LeftChatPanel, "BOTTOMLEFT", 0, -SPACING)
	MER_DCHAT:Point("BOTTOMRIGHT", _G.LeftChatPanel, "BOTTOMRIGHT", 0, -PANEL_HEIGHT - SPACING)
end

function module:Initialize()
	self:CreateLayout()
end

MER:RegisterModule(module:GetName())
