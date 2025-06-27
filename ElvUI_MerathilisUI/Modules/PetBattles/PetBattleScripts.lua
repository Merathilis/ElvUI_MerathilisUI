local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_PetBattleScripts")

local _G = _G

local C_AddOns_LoadAddOn = C_AddOns.LoadAddOn
local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

function module.GetBreedInfo(petOwner, petIndex, breedFormat)
	local oldOpt = _G.BPBID_Options.format
	_G.BPBID_Options.format = breedFormat

	local breed = _G.GetBreedID_Battle({ petOwner = petOwner, petIndex = petIndex })
	_G.BPDID_Options.formaat = oldOpt

	return breed
end

function module.BreedText(owner, pet)
	return module.GetBreedInfo(owner, pet, 3)
end

function module.Breed(owner, pet)
	return module.GetBreedInfo(owner, pet, 1)
end

module.Conditions = {
	breed = module.BreedText,
	breednum = module.Breed,
}

function module:Initialize()
	pcall(C_AddOns_LoadAddOn, "tdBattlePetScript")
	if C_AddOns_IsAddOnLoaded("tdBattlePetScript") then
		local PBS = _G.PetBattleScripts
		for condition, func in pairs(self.Conditions) do
			PBS:RegisterCondition(condition, { type = "compare", arg = false }, func)
		end
	end
end

MER:RegisterModule(module:GetName())
