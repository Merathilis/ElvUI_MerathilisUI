local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local R = E:GetModule('Reminder');
--[[
	Spell Reminder Arguments
	
	General:
		enable - turn the reminder off and on.
		strictFilter - allow the use of spells that are not actually in your spellbook (Spell Procs)
		disableSound - Don't play the warning sound.
		
	Type of Check:
		spellGroup - List of spells in a group, if you have anyone of these spells the icon will hide.
		weaponCheck - Run a weapon enchant check instead of a spell check
		CDSpell - Run checks to see if a spell is on cooldown or not.
		
	Spells only Requirements:
		negateGroup - List of spells in a group, if you have anyone of these spells the icon will immediately hide and stop running the spell check (these should be other peoples spells)
		reverseCheck - only works if you provide a role or a tree, instead of hiding the frame when you have the buff, it shows the frame when you have the buff, doesn't work with weapons
		talentTreeException - if reverseCheck is set you can set a talent tree to follow the reverse check if not set then all trees follow the reverse check, doesn't work with weapons
	
	Cooldown only Requirements:
		OnCooldown - Set to "SHOW or "HIDE".
	
	Requirements: (These work for both spell and weapon checks)
		role - you must be a certain role for it to display (Tank, Melee, Caster)
		tree - you must be active in a specific talent tree for it to display ([1] = true, [2] = true, [3] = true, [4] = true) note: tree order can be viewed from top to bottom when you open your talent pane
		minLevel - the minimum level you must be (most of the time we don't need to use this because it will register the spell learned event if you don't know the spell, but in the case of weapon enchants this is useful)
		personal - aura must come from the player
		
	Additional Checks: (Note we always run a check when gaining/losing an aura)
		instance - check when entering a party/raid instance
		pvp - check when entering a bg/arena
		combat - check when entering combat

	For every group created a new frame is created, it's a lot easier this way.
]]

G['reminder']['filters'] = {
	DEATHKNIGHT = {
		["Horn of Winter"] = {	-- Horn of Winter group
			["spellGroup"] = {
				[57330] = true,	-- Horn of Winter
			},
			["negateGroup"] = {
				[6673] = true,	-- Battle Shout
				[19506] = true,	-- Trueshot Aura
			},
			["combat"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
		["Blood Presence"] = {	-- Blood Presence group
			["spellGroup"] = {
				[48263] = true,	-- Blood Presence
			},
			["role"] = "Tank",
			["instance"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
	},
	DRUID = {
		["Mark of the Wild"] = {	-- Mark of the Wild group
			["spellGroup"] = {
				[1126] = true,	-- Mark of the Wild
			},
			["negateGroup"] = {
				[20217] = true,	-- Blessing of Kings
				[115921] = true,	-- Legacy of the Emperor
				[116781] = true, -- Legacy of the White Tiger
				[90363] = true,	-- Embrace of the Shale Spider
				[159988] = true, -- Bark of the Wild (Dog)
				[160017] = true, -- Blessing of Kongs (Gorilla)
				[160077] = true, -- Strength of the Earth (Worm)
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
	},
	HUNTER = {
		["Aspect of the Pack"] = {	-- Aspect of the Pack group
			["spellGroup"] = {
				[13159] = true, -- Aspect of the Pack
			},
			["personal"] = true,
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
			["strictFilter"] = true,
			["reverseCheck"] = true,
		},
		["Aspect of the Cheetah"] = { -- Aspect of the Cheetah group
			["spellGroup"] = {
				[5118] = true, -- Aspect of the Pack
			},
			["personal"] = true,
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
			["strictFilter"] = true,
			["reverseCheck"] = true,
		},
	},
	MAGE = {
		["Brilliance"] = {	-- Brilliance group
			["spellGroup"] = {
				[1459] = true,	-- Arcane Brilliance
				[61316] = true,	-- Dalaran Brilliance
			},
			["negateGroup"] = {
				[126309] = true,	-- Still Water (Water Strider)
				[128433] = true,	-- Serpent's Cunning (Serpent)
				[90364] = true,	-- Qiraji Fortitude (Silithid)
				[109773] = true,	-- Dark Intent
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
	},
	MONK = {
		["Legacy of the Emperor"] = {	-- Legacy of the Emperor group
			["spellGroup"] = {
				[115921] = true,	-- Legacy of the Emperor
			},
			["negateGroup"] = {
				[1126] = true,	-- Mark of the Wild
				[20217] = true,	-- Blessing of Kings
				[90363] = true,	-- Embrace of the Shale Spider
				[160017] = true, -- Blessing of Kongs (Gorilla)
				[90363] = true, -- Embrace of the Shale Spider
				[160077] = true, -- Strength of the Earth (Worm)
				[116781] = true, -- Legacy of the White Tiger
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
		["Legacy of the White Tiger"] = {	-- Legacy of the White Tiger group
			["spellGroup"] = {
				[116781] = true,	-- Legacy of the White Tiger
			},
			["negateGroup"] = {
				[1126] = true,	-- Mark of the Wild
				[20217] = true,	-- Blessing of Kings
				[90363] = true,	-- Embrace of the Shale Spider
				[160017] = true, -- Blessing of Kongs (Gorilla)
				[90363] = true, -- Embrace of the Shale Spider
				[160077] = true, -- Strength of the Earth (Worm)
				[115921] = true, -- Legacy of the Emperor
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
	},
	PALADIN = {
		["Righteous Fury"] = {	-- Righteous Fury group
			["spellGroup"] = {
				[25780] = true,	-- Righteous Fury
			},
			["role"] = "Tank",
			["instance"] = true,
			["reverseCheck"] = true,
			["negate_reversecheck"] = 1,	-- Holy paladins use RF sometimes
			["enable"] = true,
			["strictFilter"] = true,
		},
		["Blessing of Kings"] = {	-- Blessing of Kings group
			["spellGroup"] = {
				[20217] = true,	-- Blessing of Kings
			},
			["negateGroup"] = {
				[1126] = true,	-- Mark of the Wild
				[90363] = true,	-- Embrace of the Shale Spider
				[160017] = true, -- Blessing of Kongs (Gorilla)
				[90363] = true, -- Embrace of the Shale Spider
				[160077] = true, -- Strength of the Earth (Worm)
				[116781] = true, -- Legacy of the White Tiger
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
		["Blessing of Might"] = {	-- Blessing of Might group
			["spellGroup"] = {
				[19740] = true,	-- Blessing of Might
			},
			["negateGroup"] = {
				[155522] = true,	-- Power of the Grave
				[24907] = true,	-- Moonkin Aura
				[93435] = true,	-- Roar of Courage (Cat)
				[160039] = true,	-- Keen Senses (Hydra)
				[160073] = true,	-- Plainswalking (Tallstrider)
				[128997] = true,	-- Spirit Beast Blessing
				[116956] = true,	-- Grace of Air
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
	},
	PRIEST = {
		["Power Word: Fortitude"] = {	-- Power Word: Fortitude group
			["spellGroup"] = {
				[21562] = true,	-- Power Word: Fortitude
			},
			["negateGroup"] = {
				[90364] = true,	-- Qiraji Fortitude (Silithid)
				[160003] = true,	--- Savage Vigor (Rylak)
				[160014] = true,	-- Sturdiness (Goat)
				[166928] = true,	-- Blood Pact
				[469] = true,	-- Commanding Shout
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
	},
	ROGUE = {
		["Lethal Poisons"] = {	-- Lethal Poisons group
			["spellGroup"] = {
				[2823] = true,	-- Deadly Poison
				[8679] = true,	-- Wound Poison
				[157584] = true, -- Instant Poison
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
		["Non-Lethal Poisons"] = {	--  Non-Lethal Poisons group
			["spellGroup"] = {
				[3408] = true,	-- Crippling Poison
				[108211] = true,	-- Leeching Poison
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
	},
	SHAMAN = {
		["Shields"] = {	-- Shields group
			["spellGroup"] = {
				[52127] = true,	-- Water Shield
				[324] = true,	-- Lightning Shield
				[974] = true,	-- Earth Shield
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
	},
	WARLOCK = {
		["Dark Intent"] = {	-- Dark Intent group
			["spellGroup"] = {
				[109773] = true,	-- Dark Intent
			},
			["negateGroup"] = {
				[1459] = true,	-- Arcane Brilliance
				[61316] = true,	-- Dalaran Brilliance
				[126309] = true, -- Still Water (Water Strider)
				[128433] = true, -- Serpent's Cunning (Serpent)
				[90364] = true, -- Qiraji Fortitude (Silithid)
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
	},
	WARRIOR = {
		["Commanding Shout"] = {	-- Commanding Shout group
			["spellGroup"] = {
				[469] = true,	-- Commanding Shout
			},
			["negateGroup"] = {
				[90364] = true,	-- Qiraji Fortitude
				[21562] = true,	-- Power Word: Fortitude
				[160003] = true, -- Savage Vigor (Rylak)
				[160014] = true, -- Sturdiness (Goat)
				[166928] = true, -- Blood Pact
			},
			["combat"] = true,
			["role"] = "Tank",
			["enable"] = true,
			["strictFilter"] = true,
		},
		["Battle Shout"] = {	-- Battle Shout group
			["spellGroup"] = {
				[6673] = true,	-- Battle Shout
			},
			["negateGroup"] = {
				[57330] = true,	-- Horn of Winter
				[19506] = true,	-- Trueshot Aura
				[469] = true,	-- Commanding Shout
			},
			["combat"] = true,
			["role"] = "Melee",
			["enable"] = true,
			["strictFilter"] = true,
		},
	},
}
