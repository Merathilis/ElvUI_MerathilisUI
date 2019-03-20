local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--Lua functions

--WoW API / Variables

-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS:

MER.ReminderList = {
	DEATHKNIGHT = {
		["Raise"] = {
			["spellGroup"] = {
				[46584] = true,
				["defaultIcon"] = 46584, -- Raise Dead
			},
			["enable"] = true,
			["instance"] = true,
			["pvp"] = true,
			["strictFilter"] = true,
		},
	},

	MAGE = {
		["Intellect"] = {
			["spellGroup"] = {
				[1459] = true,
				["defaultIcon"] = 1459,  -- Arcane Intellect
			},
			["enable"] = true,
			["instance"] = true,
			["pvp"] = true,
			["strictFilter"] = true,
		},
	},

	PRIEST = {
		["Stamina"] = {
			["spellGroup"] = {
				[21562] = true,
				["defaultIcon"] = 21562, -- Power Word: Fortitude
			},
			["enable"] = true,
			["instance"] = true,
			["pvp"] = true,
			["strictFilter"] = true,
		},
	},

	ROGUE = {
		["Poisons"] = {
			["spellGroup"] = {
				[8679] = true,	 -- Wound Poison
				[2823] = true,	 -- Deadly Poison
				[3408] = true,	 -- Crippling Poison
				[108211] = true, -- Leeching Poison
				["defaultIcon"] = 2823,
			},
			["enable"] = true,
			["instance"] = true,
			["pvp"] = true,
			["strictFilter"] = true,
			["tree"] = 1,
		},
	},

	SHAMAN = {
		["Shield"] = {
			["spellGroup"] = {
				[192106] = true, -- Lightning Shield
				["defaultIcon"] = 192106,
			},
			["enable"] = true,
			["instance"] = true,
			["pvp"] = true,
			["strictFilter"] = true,
			["tree"] = 2,
		},
	},

	WARRIOR = {
		["Stamina"] = {
			["spellGroup"] = {
				[6673] = true, -- Battle Shout
				["defaultIcon"] = 6673,
			},
			["enable"] = true,
			["instance"] = true,
			["pvp"] = true,
			["strictFilter"] = true,
		},
	},
}
