local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_Collections()
	if not module:CheckDB("collections", "collections") then
		return
	end

	local CollectionsJournal = _G.CollectionsJournal
end

module:AddCallbackForAddon("Blizzard_Collections")
