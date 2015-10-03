local E, L, V, P, G, _ = unpack(ElvUI);
local UFM = E:NewModule('MuiUnits', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
local UF = E:GetModule('UnitFrames');
local LSM = LibStub("LibSharedMedia-3.0");
UF.LSM = LSM

function UFM:Initialize()
	self:InitRaid()
end

E:RegisterModule(UFM:GetName())
