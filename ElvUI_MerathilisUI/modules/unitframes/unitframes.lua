local E, L, V, P, G = unpack(ElvUI);
local MUF = E:NewModule('MuiUnits', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
local UF = E:GetModule('UnitFrames');

function MUF:Initialize()
	if E.private.unitframe.enable ~= true then return end
	
	self:InitPlayer()
end

E:RegisterModule(MUF:GetName())