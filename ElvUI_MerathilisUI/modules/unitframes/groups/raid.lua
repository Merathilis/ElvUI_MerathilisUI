local E, L, V, P, G = unpack(ElvUI);
local MUF = E:GetModule('MuiUnits');
local UF = E:GetModule('UnitFrames');

-- GLOBALS: hooksecurefunc

function MUF:Update_RaidFrames(frame, db)
	frame.db = db

	-- Readycheck
	MUF:Configure_ReadyCheckIcon(frame)

	frame:UpdateAllElements("MerathilisUI_UpdateAllElements")
end

function MUF:InitRaid()
	if not E.db.unitframe.units.raid.enable then return end
	hooksecurefunc(UF, 'Update_RaidFrames', MUF.Update_RaidFrames)
end