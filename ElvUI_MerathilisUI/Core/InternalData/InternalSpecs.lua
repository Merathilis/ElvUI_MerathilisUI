local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local gsub = gsub
local pairs = pairs

-- Spec IDs organized by class
I.Specs = {
	DeathKnight = {
		Blood = 250,
		Frost = 251,
		Unholy = 252,
	},
	DemonHunter = {
		Havoc = 577,
		Vengeance = 581,
		Devourer = 1480,
	},
	Druid = {
		Balance = 102,
		Feral = 103,
		Guardian = 104,
		Restoration = 105,
	},
	Evoker = {
		Devastation = 1467,
		Preservation = 1468,
		Augmentation = 1473,
	},
	Hunter = {
		BeastMastery = 253,
		Marksmanship = 254,
		Survival = 255,
	},
	Mage = {
		Arcane = 62,
		Fire = 63,
		Frost = 64,
	},
	Monk = {
		Brewmaster = 268,
		Mistweaver = 270,
		Windwalker = 269,
	},
	Paladin = {
		Holy = 65,
		Protection = 66,
		Retribution = 70,
	},
	Priest = {
		Discipline = 256,
		Holy = 257,
		Shadow = 258,
	},
	Rogue = {
		Assassination = 259,
		Outlaw = 260,
		Subtlety = 261,
	},
	Shaman = {
		Elemental = 262,
		Enhancement = 263,
		Restoration = 264,
	},
	Warlock = {
		Affliction = 265,
		Demonology = 266,
		Destruction = 267,
	},
	Warrior = {
		Arms = 71,
		Fury = 72,
		Protection = 73,
	},
}

-- Spec ID to English name, e.g. [253] = "Beast Mastery"
I.SpecNames = {}

for _, specs in pairs(I.Specs) do
	for name, specID in pairs(specs) do
		I.SpecNames[specID] = gsub(name, "(%l)(%u)", "%1 %2")
	end
end
