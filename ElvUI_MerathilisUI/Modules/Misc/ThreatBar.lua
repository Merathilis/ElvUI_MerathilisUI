local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("ThreatBar")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
-- GLOBALS:

-- Reposition the DataText ThreatBar
function module:UpdatePosition()
	if E.db.general.threat then
		_G.ElvUI_ThreatBar:SetParent(_G["MER_RightChatTopDT"])
		_G.ElvUI_ThreatBar:SetInside(_G["MER_RightChatTopDT"])

		_G.ElvUI_ThreatBar:SetFrameStrata('HIGH')
	end
end

function module:Initialize()
	module:UpdatePosition()
end

MER:RegisterModule(module:GetName())
