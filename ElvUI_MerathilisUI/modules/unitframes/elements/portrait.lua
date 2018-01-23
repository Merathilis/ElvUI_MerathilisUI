local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = E:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

--Cache global variables
local _G = _G
local pairs, select = pairs, select
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MUF:Configure_Portrait(frame, isPlayer)
	local portrait = frame.Portrait
	local db = frame.db

end