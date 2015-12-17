local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local MERP = E:NewModule('muiPVP', 'AceHook-3.0', 'AceEvent-3.0')

-- Cache global variables
local format = string.format

function MERP:Duels(event, name)
	local cancelled = false
	if event == "DUEL_REQUESTED" and E.db.muiPVP.duels.regular then
		CancelDuel()
		StaticPopup_Hide("DUEL_REQUESTED")
		cancelled = "REGULAR"
	elseif event == "PET_BATTLE_PVP_DUEL_REQUESTED" and E.db.muiPVP.duels.pet then
		C_PetBattles.CancelPVPDuel()
		StaticPopup_Hide("PET_BATTLE_PVP_DUEL_REQUESTED")
		cancelled = "PET"
	end
	if cancelled then
		MER:Print(format(L["MER_DuelCancel_"..cancelled], name))
	end
end

function MERP:Initialize()
	self:RegisterEvent("DUEL_REQUESTED", "Duels")
	self:RegisterEvent("PET_BATTLE_PVP_DUEL_REQUESTED", "Duels")
end

E:RegisterModule(MERP:GetName())
