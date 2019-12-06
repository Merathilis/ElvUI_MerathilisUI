local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("PVP", "AceEvent-3.0")

--Cache global variables
--Lua functions
local _G = _G
local format = string.format
--WoW API / Variables
local CancelDuel = CancelDuel
local CancelPetPVPDuel = C_PetBattles.CancelPVPDuel
local StaticPopup_Hide = StaticPopup_Hide
-- GLOBALS:

-- Credits: Shadow&Light
function module:BlockDuel(event, name)
	local cancelled = false

	if event == "DUEL_REQUESTED" and module.db.duels.regular then
		CancelDuel()
		StaticPopup_Hide("DUEL_REQUESTED")
		cancelled = "REGULAR"
	elseif event == "PET_BATTLE_PVP_DUEL_REQUESTED" and module.db.duels.pet then
		CancelPetPVPDuel()
		StaticPopup_Hide("PET_BATTLE_PVP_DUEL_REQUESTED")
		cancelled = "PET"
	end

	if cancelled then
		MER:Print(format(L["MER_DuelCancel_"..cancelled], name))
	end
end


function module:Initialize()
	module.db = E.db.mui.pvp
	MER:RegisterDB(self, "pvp")

	self:RegisterEvent("DUEL_REQUESTED", "BlockDuel")
	self:RegisterEvent("PET_BATTLE_PVP_DUEL_REQUESTED", "BlockDuel")

	function module:ForUpdateAll()
		module.db = E.db.mui.pvp
	end
end

MER:RegisterModule(module:GetName())
