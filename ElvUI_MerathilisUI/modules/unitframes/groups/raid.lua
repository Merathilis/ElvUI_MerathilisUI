local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = MER:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

--Cache global variables
--Lua functions
--WoW API / Variables

function MUF:Update_RaidFrames(frame, db)
	frame.db = db

	do

	end

	frame:UpdateAllElements("mUI_UpdateAllElements")
end

function MUF:InitRaid()
	if not E.db.unitframe.units.raid.enable then return end
	-- hooksecurefunc(UF, "Update_RaidFrames", MUF.Update_RaidFrames)
end
