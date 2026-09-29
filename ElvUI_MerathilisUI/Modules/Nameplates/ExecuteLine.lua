local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Nameplates")
local NP = E:GetModule("NamePlates")

local hooksecurefunc = hooksecurefunc
local pairs = pairs

-- The oUF element itself lives in Modules/UnitFrames/Elements/ExecuteLine.lua

local ENEMY_TYPES = {
	ENEMY_NPC = true,
	ENEMY_PLAYER = true,
}

-- Plates get reused for friendly and hostile units, so this runs per plate type
function module:Configure_ExecuteLine(nameplate)
	if not nameplate or nameplate == NP.TestFrame then
		return
	end

	local db = E.db.mui.nameplates.executeLine
	MER.ConfigureExecuteLine(nameplate, db, db.enable and ENEMY_TYPES[nameplate.frameType])
end

function module:UpdateExecuteLines()
	if not NP.Plates then
		return
	end

	for nameplate in pairs(NP.Plates) do
		module:Configure_ExecuteLine(nameplate)
	end
end

function module:ExecuteLine()
	hooksecurefunc(NP, "Update_Health", function(_, nameplate)
		module:Configure_ExecuteLine(nameplate)
	end)

	-- Plates that already existed before the hook
	module:UpdateExecuteLines()
end
