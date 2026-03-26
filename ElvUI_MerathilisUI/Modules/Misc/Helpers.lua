local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc

local format = string.format
local C_SpecializationInfo = C_SpecializationInfo

function module:GetCoordinates(col, row)
	local width = 64
	local height = 64

	local x1 = (col - 1) * width
	local x2 = col * width
	local y1 = (row - 1) * height
	local y2 = row * height

	return format("%d:%d:%d:%d", x1, x2, y1, y2)
end

module.ClassIcons = {
	WARRIOR = module:GetCoordinates(1, 1),
	MAGE = module:GetCoordinates(2, 1),
	ROGUE = module:GetCoordinates(3, 1),
	DRUID = module:GetCoordinates(4, 1),
	EVOKER = module:GetCoordinates(5, 1),
	HUNTER = module:GetCoordinates(1, 2),
	SHAMAN = module:GetCoordinates(2, 2),
	PRIEST = module:GetCoordinates(3, 2),
	WARLOCK = module:GetCoordinates(4, 2),
	PALADIN = module:GetCoordinates(1, 3),
	DEATHKNIGHT = module:GetCoordinates(2, 3),
	MONK = module:GetCoordinates(3, 3),
	DEMONHUNTER = module:GetCoordinates(4, 3),
}

module.SpecIcons = {
	-- Unknown
	[0] = module:GetCoordinates(8, 8),

	[I.Specs.DeathKnight.Blood] = module:GetCoordinates(1, 1),
	[I.Specs.DeathKnight.Frost] = module:GetCoordinates(2, 1),
	[I.Specs.DeathKnight.Unholy] = module:GetCoordinates(3, 1),

	[I.Specs.DemonHunter.Havoc] = module:GetCoordinates(3, 5),
	[I.Specs.DemonHunter.Vengeance] = module:GetCoordinates(4, 5),
	[I.Specs.DemonHunter.Devourer] = module:GetCoordinates(8, 5),

	[I.Specs.Druid.Balance] = module:GetCoordinates(4, 1),
	[I.Specs.Druid.Feral] = module:GetCoordinates(5, 1),
	[I.Specs.Druid.Guardian] = module:GetCoordinates(6, 1),
	[I.Specs.Druid.Restoration] = module:GetCoordinates(7, 1),

	[I.Specs.Evoker.Devastation] = module:GetCoordinates(5, 5),
	[I.Specs.Evoker.Preservation] = module:GetCoordinates(6, 5),
	[I.Specs.Evoker.Augmentation] = module:GetCoordinates(7, 5),

	[I.Specs.Hunter.BeastMastery] = module:GetCoordinates(8, 1),
	[I.Specs.Hunter.Marksmanship] = module:GetCoordinates(1, 2),
	[I.Specs.Hunter.Survival] = module:GetCoordinates(2, 2),

	[I.Specs.Mage.Arcane] = module:GetCoordinates(3, 2),
	[I.Specs.Mage.Fire] = module:GetCoordinates(4, 2),
	[I.Specs.Mage.Frost] = module:GetCoordinates(5, 2),

	[I.Specs.Monk.Brewmaster] = module:GetCoordinates(6, 2),
	[I.Specs.Monk.Mistweaver] = module:GetCoordinates(7, 2),
	[I.Specs.Monk.Windwalker] = module:GetCoordinates(8, 2),

	[I.Specs.Paladin.Holy] = module:GetCoordinates(1, 3),
	[I.Specs.Paladin.Protection] = module:GetCoordinates(2, 3),
	[I.Specs.Paladin.Retribution] = module:GetCoordinates(3, 3),

	[I.Specs.Priest.Discipline] = module:GetCoordinates(4, 3),
	[I.Specs.Priest.Holy] = module:GetCoordinates(5, 3),
	[I.Specs.Priest.Shadow] = module:GetCoordinates(6, 3),

	[I.Specs.Rogue.Assassination] = module:GetCoordinates(7, 3),
	[I.Specs.Rogue.Outlaw] = module:GetCoordinates(8, 3),
	[I.Specs.Rogue.Subtlety] = module:GetCoordinates(1, 4),

	[I.Specs.Shaman.Elemental] = module:GetCoordinates(2, 4),
	[I.Specs.Shaman.Enhancement] = module:GetCoordinates(3, 4),
	[I.Specs.Shaman.Restoration] = module:GetCoordinates(4, 4),

	[I.Specs.Warlock.Affliction] = module:GetCoordinates(5, 4),
	[I.Specs.Warlock.Demonology] = module:GetCoordinates(6, 4),
	[I.Specs.Warlock.Destruction] = module:GetCoordinates(7, 4),

	[I.Specs.Warrior.Arms] = module:GetCoordinates(8, 4),
	[I.Specs.Warrior.Fury] = module:GetCoordinates(1, 5),
	[I.Specs.Warrior.Protection] = module:GetCoordinates(2, 5),
}

-- Blizzard specIconID (texture file ID) -> ToxiUI specID mapping
module.BlizzardToSpecID = {
	-- Death Knight
	[135770] = I.Specs.DeathKnight.Blood,
	[135773] = I.Specs.DeathKnight.Frost,
	[135775] = I.Specs.DeathKnight.Unholy,
	-- Demon Hunter
	[1247264] = I.Specs.DemonHunter.Havoc,
	[1247265] = I.Specs.DemonHunter.Vengeance,
	[7455385] = I.Specs.DemonHunter.Devourer,
	-- Druid
	[136096] = I.Specs.Druid.Balance,
	[132115] = I.Specs.Druid.Feral,
	[132276] = I.Specs.Druid.Guardian,
	[136041] = I.Specs.Druid.Restoration,
	-- Evoker
	[4511811] = I.Specs.Evoker.Devastation,
	[4511812] = I.Specs.Evoker.Preservation,
	[5198700] = I.Specs.Evoker.Augmentation,
	-- Hunter
	[461112] = I.Specs.Hunter.BeastMastery,
	[236179] = I.Specs.Hunter.Marksmanship,
	[461113] = I.Specs.Hunter.Survival,
	-- Mage
	[135932] = I.Specs.Mage.Arcane,
	[135810] = I.Specs.Mage.Fire,
	[135846] = I.Specs.Mage.Frost,
	-- Monk
	[608951] = I.Specs.Monk.Brewmaster,
	[608952] = I.Specs.Monk.Mistweaver,
	[608953] = I.Specs.Monk.Windwalker,
	-- Paladin
	[135920] = I.Specs.Paladin.Holy,
	[236264] = I.Specs.Paladin.Protection,
	[135873] = I.Specs.Paladin.Retribution,
	-- Priest
	[135940] = I.Specs.Priest.Discipline,
	[237542] = I.Specs.Priest.Holy,
	[136207] = I.Specs.Priest.Shadow,
	-- Rogue
	[236270] = I.Specs.Rogue.Assassination,
	[236286] = I.Specs.Rogue.Outlaw,
	[132320] = I.Specs.Rogue.Subtlety,
	-- Shaman
	[136048] = I.Specs.Shaman.Elemental,
	[237581] = I.Specs.Shaman.Enhancement,
	[136052] = I.Specs.Shaman.Restoration,
	-- Warlock
	[136145] = I.Specs.Warlock.Affliction,
	[136172] = I.Specs.Warlock.Demonology,
	[136186] = I.Specs.Warlock.Destruction,
	-- Warrior
	[132355] = I.Specs.Warrior.Arms,
	[132347] = I.Specs.Warrior.Fury,
	[132341] = I.Specs.Warrior.Protection,
}
