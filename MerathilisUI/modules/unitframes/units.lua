local E, L, V, P, G, _ = unpack(ElvUI);
local UFM = E:NewModule('MuiUnits', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
local UF = E:GetModule('UnitFrames');

function UFM:Initialize()
	self:UpdateRaidFrames()
	hooksecurefunc(UF, 'Update_RaidFrames', UFM.UpdateRaidFrames)
end

E:RegisterModule(UFM:GetName())
