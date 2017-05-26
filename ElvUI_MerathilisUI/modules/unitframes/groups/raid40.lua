local E, L, V, P, G = unpack(ElvUI);
local MUF = E:GetModule("muiUnits");
local UF = E:GetModule("UnitFrames");

--Cache global variables
--Lua functions
--WoW API / Variables

function MUF:Update_Raid40Frames(frame, db)
	frame.db = db

	do

	end

	frame:UpdateAllElements("MerathilisUI_UpdateAllElements")
end

function MUF:InitRaid40()
	if not E.db.unitframe.units.raid40.enable then return end
	-- hooksecurefunc(UF, "Update_Raid40Frames", MUF.Update_Raid40Frames)
end
