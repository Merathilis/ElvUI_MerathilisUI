local E, L, V, P, G = unpack(ElvUI);
local MUF = E:GetModule("muiUnits");
local UF = E:GetModule("UnitFrames");

--Cache global variables
--Lua functions
--WoW API / Variables

function MUF:Update_RaidFrames(frame, db)
	frame.db = db

	do

	end

	frame:UpdateAllElements("MerathilisUI_UpdateAllElements")
end

function MUF:InitRaid()
	if not E.db.unitframe.units.raid.enable then return end
	-- hooksecurefunc(UF, "Update_RaidFrames", MUF.Update_RaidFrames)
end
