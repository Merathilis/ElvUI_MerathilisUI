local MER, E, L, V, P, G = unpack(select(2, ...))

MER.ReminderList = {
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
				[5761] = true, -- Numbing Poison
				[108211] = true, -- Leeching Poison
				[315584] = true, -- Instant Poison
				["defaultIcon"] = 2823,
			},
			["enable"] = true,
			["instance"] = true,
			["pvp"] = true,
			["strictFilter"] = true,
			--["tree"] = 1,
		},
	},

	SHAMAN = {
		["LightningShield"] = {
			["spellGroup"] = {
				[192106] = true, -- Lightning Shield
				[974] = true, -- Earth Shield
				["defaultIcon"] = 192106,
			},
			["enable"] = true,
			["instance"] = true,
			["pvp"] = true,
			["strictFilter"] = true,
			["tree"] = 1, 2
		},
		["WaterShield"] = {
			["spellGroup"] = {
				[52127] = true, -- Water Shield
				["defaultIcon"] = 52127,
			},
			["enable"] = true,
			["instance"] = true,
			["pvp"] = true,
			["strictFilter"] = true,
			["tree"] = 3,
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
