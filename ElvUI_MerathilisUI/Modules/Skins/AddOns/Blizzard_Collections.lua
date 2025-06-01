local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_Collections()
	if not module:CheckDB("collections", "collections") then
		return
	end

	local CollectionsJournal = _G.CollectionsJournal
	local PetJournal = _G.PetJournal

	_G.PetJournalLoadoutBorderSlotHeaderText:SetParent(PetJournal)
	_G.PetJournalLoadoutBorderSlotHeaderText:SetPoint("CENTER", _G.PetJournalLoadoutBorderTop, "TOP", 0, 4)

	for i = 1, 3 do
		local bu = PetJournal.Loadout["Pet" .. i]
		if bu and not bu.backdrop then
			bu:CreateBackdrop("Transparent")
		end
	end

	hooksecurefunc("PetJournal_UpdatePetLoadOut", function()
		for i = 1, 3 do
			local bu = PetJournal.Loadout["Pet" .. i]
			bu.backdrop:SetShown(not bu.helpFrame:IsShown())
		end
	end)
end

module:AddCallbackForAddon("Blizzard_Collections")
