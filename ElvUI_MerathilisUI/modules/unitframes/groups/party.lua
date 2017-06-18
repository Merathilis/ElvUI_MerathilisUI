local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = E:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

--Cache global variables
--Lua functions
--WoW API / Variables

function MUF:Update_PartyFrames(frame, db)
	frame.db = db

	do

	end

	frame:UpdateAllElements("mUI_UpdateAllElements")
end

function MUF:InitParty()
	if not E.db.unitframe.units.party.enable then return end
	-- hooksecurefunc(UF, "Update_PartyFrames", MUF.Update_PartyFrames)
end

