local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")

local _G = _G

function module:BossBanner()
	if E.db.mui.misc.hideBossBanner then
		_G.BossBanner:UnregisterEvent("ENCOUNTER_LOOT_RECEIVED")
	else
		_G.BossBanner:RegisterEvent("ENCOUNTER_LOOT_RECEIVED")
	end
end

module:AddCallback("BossBanner")
module:AddCallbackForUpdate("BossBanner")
