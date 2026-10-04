local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Nameplates")
local NP = E:GetModule("NamePlates")

local hooksecurefunc = hooksecurefunc
local pairs = pairs

-- The shield itself lives in Modules/UnitFrames/Elements/CastbarShield.lua

local ENEMY_TYPES = {
	ENEMY_NPC = true,
	ENEMY_PLAYER = true,
}

local function GetDB()
	return E.db.mui.nameplates.castbarShield
end

-- Plates get reused for friendly and hostile units, so this runs per unit
function module:Configure_CastbarShield(nameplate)
	if not nameplate or nameplate == NP.TestFrame or not nameplate.Castbar then
		return
	end

	local db = GetDB()
	MER.CastbarShield:Configure(nameplate.Castbar, GetDB, db.enable and ENEMY_TYPES[nameplate.frameType])
end

function module:UpdateCastbarShield()
	if not NP.Plates then
		return
	end

	for nameplate in pairs(NP.Plates) do
		module:Configure_CastbarShield(nameplate)
	end
end

function module:CastbarShield()
	hooksecurefunc(NP, "Update_Castbar", function(_, nameplate)
		module:Configure_CastbarShield(nameplate)
	end)

	-- Plates that already existed before the hook
	module:UpdateCastbarShield()
end
