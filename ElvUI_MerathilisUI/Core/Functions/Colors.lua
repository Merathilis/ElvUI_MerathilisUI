local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
F.Color = {}

local _G = _G
local pairs, select = pairs, select
local abs = abs
local min = min

local CreateColor = CreateColor
local UnitClass = UnitClass
local UnitIsPlayer = UnitIsPlayer
local UnitIsTapDenied = UnitIsTapDenied
local UnitReaction = UnitReaction

--[[----------------------------------
--	Color Functions
--]]
----------------------------------
local UnitframeGradients = {
	["WARRIOR"] = { r1 = 0.60, g1 = 0.40, b1 = 0.20, r2 = 0.66, g2 = 0.53, b2 = 0.34 },
	["PALADIN"] = { r1 = 0.9, g1 = 0.47, b1 = 0.64, r2 = 0.96, g2 = 0.65, b2 = 0.83 },
	["HUNTER"] = { r1 = 0.58, g1 = 0.69, b1 = 0.29, r2 = 0.78, g2 = 1, b2 = 0.38 },
	["ROGUE"] = { r1 = 1, g1 = 0.68, b1 = 0, r2 = 1, g2 = 0.83, b2 = 0.25 },
	["PRIEST"] = { r1 = 0.65, g1 = 0.65, b1 = 0.65, r2 = 0.98, g2 = 0.98, b2 = 0.98 },
	["DEATHKNIGHT"] = { r1 = 0.79, g1 = 0.07, b1 = 0.14, r2 = 1, g2 = 0.18, b2 = 0.23 },
	["SHAMAN"] = { r1 = 0, g1 = 0.25, b1 = 0.50, r2 = 0, g2 = 0.43, b2 = 0.87 },
	["MAGE"] = { r1 = 0, g1 = 0.73, b1 = 0.83, r2 = 0.49, g2 = 0.87, b2 = 1 },
	["WARLOCK"] = { r1 = 0.50, g1 = 0.30, b1 = 0.70, r2 = 0.7, g2 = 0.53, b2 = 0.83 },
	["MONK"] = { r1 = 0, g1 = 0.77, b1 = 0.45, r2 = 0.22, g2 = 0.90, b2 = 1 },
	["DRUID"] = { r1 = 1, g1 = 0.23, b1 = 0.0, r2 = 1, g2 = 0.48, b2 = 0.03 },
	["DEMONHUNTER"] = { r1 = 0.36, g1 = 0.13, b1 = 0.57, r2 = 0.74, g2 = 0.19, b2 = 1 },
	["EVOKER"] = { r1 = 0.20, g1 = 0.58, b1 = 0.50, r2 = 0, g2 = 1, b2 = 0.60 },

	["NPCFRIENDLY"] = { r1 = 0.30, g1 = 0.85, b1 = 0.2, r2 = 0.34, g2 = 0.62, b2 = 0.40 },
	["NPCNEUTRAL"] = { r1 = 0.71, g1 = 0.63, b1 = 0.15, r2 = 1, g2 = 0.85, b2 = 0.20 },
	["NPCUNFRIENDLY"] = { r1 = 0.84, g1 = 0.30, b1 = 0, r2 = 0.83, g2 = 0.45, b2 = 0 },
	["NPCHOSTILE"] = { r1 = 1, g1 = 1, b1 = 1, r2 = 1, g2 = 0.090196078431373, b2 = 0 },

	["TAPPED"] = { r1 = 0.6, g1 = 0.6, b1 = 0.60, r2 = 0, g2 = 0, b2 = 0 },

	["GOODTHREAT"] = { r1 = 0.1999995559454, g1 = 0.7098023891449, b1 = 0, r2 = 1, g2 = 0, b2 = 0 },
	["BADTHREAT"] = { r1 = 0.99999779462814, g1 = 0.1764702051878, b1 = 0.1764702051878, r2 = 1, g2 = 0, b2 = 0 },
	["GOODTHREATTRANSITION"] = {
		r1 = 0.99999779462814,
		g1 = 0.85097849369049,
		b1 = 0.1999995559454,
		r2 = 1,
		g2 = 0,
		b2 = 0,
	},
	["BADTHREATTRANSITION"] = {
		r1 = 0.99999779462814,
		g1 = 0.50980281829834,
		b1 = 0.1999995559454,
		r2 = 1,
		g2 = 0,
		b2 = 0,
	},
	["OFFTANK"] = { r1 = 0.95686066150665, g1 = 0.54901838302612, b1 = 0.72941017150879, r2 = 1, g2 = 0, b2 = 0 },
	["OFFTANKBADTHREATTRANSITION"] = {
		r1 = 0.77646887302399,
		g1 = 0.60784178972244,
		b1 = 0.4274500310421,
		r2 = 1,
		g2 = 0,
		b2 = 0,
	},
	["OFFTANKGOODTHREATTRANSITION"] = {
		r1 = 0.37646887302399,
		g1 = 0.90784178972244,
		b1 = 0.9274500310421,
		r2 = 1,
		g2 = 0,
		b2 = 0,
	},

	["MANA"] = { r1 = 0.49, g1 = 0.71, b1 = 1, r2 = 0.29, g2 = 0.26, b2 = 1 },
	["RAGE"] = { r1 = 1, g1 = 0.32, b1 = 0.32, r2 = 1, g2 = 0, b2 = 0.13 },
	["FOCUS"] = { r1 = 1, g1 = 0.50, b1 = 0.25, r2 = 0.71, g2 = 0.22, b2 = 0.07 },
	["ENERGY"] = { r1 = 1, g1 = 0.97, b1 = 0.54, r2 = 1, g2 = 0.70, b2 = 0.07 },
	["RUNIC_POWER"] = { r1 = 0, g1 = 0.82, b1 = 1, r2 = 0, g2 = 0.40, b2 = 1 },
	["LUNAR_POWER"] = { r1 = 0.30, g1 = 0.52, b1 = 0.90, r2 = 0.12, g2 = 0.36, b2 = 0.90 },
	["ALT_POWER"] = { r1 = 0.2, g1 = 0.4, b1 = 0.8, r2 = 0.25, g2 = 0.51, b2 = 1 },
	["MAELSTROM"] = { r1 = 0, g1 = 0.50, b1 = 1, r2 = 0, g2 = 0.11, b2 = 1 },
	["INSANITY"] = { r1 = 0.50, g1 = 0.25, b1 = 1, r2 = 0.70, g2 = 0, b2 = 1 },
	["FURY"] = { r1 = 0.79, g1 = 0.26, b1 = 1, r2 = 1, g2 = 0, b2 = 0.95 },
	["PAIN"] = { r1 = 1, g1 = 0.61, b1 = 0, r2 = 1, g2 = 0.30, b2 = 0 },

	["MERATHILIS"] = { r1 = 0.50, g1 = 0.70, b1 = 1, r2 = 0.67, g2 = 0.95, b2 = 1 },
}

local UnitframeCustomGradients = UnitframeGradients
function F:GradientColorUpdate()
	UnitframeCustomGradients = {
		["WARRIOR"] = {
			r1 = E.db.mui.gradient.warriorcolorR1,
			g1 = E.db.mui.gradient.warriorcolorG1,
			b1 = E.db.mui.gradient.warriorcolorB1,
			r2 = E.db.mui.gradient.warriorcolorR2,
			g2 = E.db.mui.gradient.warriorcolorG2,
			b2 = E.db.mui.gradient.warriorcolorB2,
		},
		["PALADIN"] = {
			r1 = E.db.mui.gradient.paladincolorR1,
			g1 = E.db.mui.gradient.paladincolorG1,
			b1 = E.db.mui.gradient.paladincolorB1,
			r2 = E.db.mui.gradient.paladincolorR2,
			g2 = E.db.mui.gradient.paladincolorG2,
			b2 = E.db.mui.gradient.paladincolorB2,
		},
		["HUNTER"] = {
			r1 = E.db.mui.gradient.huntercolorR1,
			g1 = E.db.mui.gradient.huntercolorG1,
			b1 = E.db.mui.gradient.huntercolorB1,
			r2 = E.db.mui.gradient.huntercolorR2,
			g2 = E.db.mui.gradient.huntercolorG2,
			b2 = E.db.mui.gradient.huntercolorB2,
		},
		["ROGUE"] = {
			r1 = E.db.mui.gradient.roguecolorR1,
			g1 = E.db.mui.gradient.roguecolorG1,
			b1 = E.db.mui.gradient.roguecolorB1,
			r2 = E.db.mui.gradient.roguecolorR2,
			g2 = E.db.mui.gradient.roguecolorG2,
			b2 = E.db.mui.gradient.roguecolorB2,
		},
		["PRIEST"] = {
			r1 = E.db.mui.gradient.priestcolorR1,
			g1 = E.db.mui.gradient.priestcolorG1,
			b1 = E.db.mui.gradient.priestcolorB1,
			r2 = E.db.mui.gradient.priestcolorR2,
			g2 = E.db.mui.gradient.priestcolorG2,
			b2 = E.db.mui.gradient.priestcolorB2,
		},
		["DEATHKNIGHT"] = {
			r1 = E.db.mui.gradient.deathknightcolorR1,
			g1 = E.db.mui.gradient.deathknightcolorG1,
			b1 = E.db.mui.gradient.deathknightcolorB1,
			r2 = E.db.mui.gradient.deathknightcolorR2,
			g2 = E.db.mui.gradient.deathknightcolorG2,
			b2 = E.db.mui.gradient.deathknightcolorB2,
		},
		["SHAMAN"] = {
			r1 = E.db.mui.gradient.shamancolorR1,
			g1 = E.db.mui.gradient.shamancolorG1,
			b1 = E.db.mui.gradient.shamancolorB1,
			r2 = E.db.mui.gradient.shamancolorR2,
			g2 = E.db.mui.gradient.shamancolorG2,
			b2 = E.db.mui.gradient.shamancolorB2,
		},
		["MAGE"] = {
			r1 = E.db.mui.gradient.magecolorR1,
			g1 = E.db.mui.gradient.magecolorG1,
			b1 = E.db.mui.gradient.magecolorB1,
			r2 = E.db.mui.gradient.magecolorR2,
			g2 = E.db.mui.gradient.magecolorG2,
			b2 = E.db.mui.gradient.magecolorB2,
		},
		["WARLOCK"] = {
			r1 = E.db.mui.gradient.warlockcolorR1,
			g1 = E.db.mui.gradient.warlockcolorG1,
			b1 = E.db.mui.gradient.warlockcolorB1,
			r2 = E.db.mui.gradient.warlockcolorR2,
			g2 = E.db.mui.gradient.warlockcolorG2,
			b2 = E.db.mui.gradient.warlockcolorB2,
		},
		["MONK"] = {
			r1 = E.db.mui.gradient.monkcolorR1,
			g1 = E.db.mui.gradient.monkcolorG1,
			b1 = E.db.mui.gradient.monkcolorB1,
			r2 = E.db.mui.gradient.monkcolorR2,
			g2 = E.db.mui.gradient.monkcolorG2,
			b2 = E.db.mui.gradient.monkcolorB2,
		},
		["DRUID"] = {
			r1 = E.db.mui.gradient.druidcolorR1,
			g1 = E.db.mui.gradient.druidcolorG1,
			b1 = E.db.mui.gradient.druidcolorB1,
			r2 = E.db.mui.gradient.druidcolorR2,
			g2 = E.db.mui.gradient.druidcolorG2,
			b2 = E.db.mui.gradient.druidcolorB2,
		},
		["DEMONHUNTER"] = {
			r1 = E.db.mui.gradient.demonhuntercolorR1,
			g1 = E.db.mui.gradient.demonhuntercolorG1,
			b1 = E.db.mui.gradient.demonhuntercolorB1,
			r2 = E.db.mui.gradient.demonhuntercolorR2,
			g2 = E.db.mui.gradient.demonhuntercolorG2,
			b2 = E.db.mui.gradient.demonhuntercolorB2,
		},
		["EVOKER"] = {
			r1 = E.db.mui.gradient.evokercolorR1,
			g1 = E.db.mui.gradient.evokercolorG1,
			b1 = E.db.mui.gradient.evokercolorB1,
			r2 = E.db.mui.gradient.evokercolorR2,
			g2 = E.db.mui.gradient.evokercolorG2,
			b2 = E.db.mui.gradient.evokercolorB2,
		},
		["NPCFRIENDLY"] = {
			r1 = E.db.mui.gradient.npcfriendlyR1,
			g1 = E.db.mui.gradient.npcfriendlyG1,
			b1 = E.db.mui.gradient.npcfriendlyB1,
			r2 = E.db.mui.gradient.npcfriendlyR2,
			g2 = E.db.mui.gradient.npcfriendlyG2,
			b2 = E.db.mui.gradient.npcfriendlyB2,
		},
		["NPCNEUTRAL"] = {
			r1 = E.db.mui.gradient.npcneutralR1,
			g1 = E.db.mui.gradient.npcneutralG1,
			b1 = E.db.mui.gradient.npcneutralB1,
			r2 = E.db.mui.gradient.npcneutralR2,
			g2 = E.db.mui.gradient.npcneutralG2,
			b2 = E.db.mui.gradient.npcneutralB2,
		},
		["NPCUNFRIENDLY"] = {
			r1 = E.db.mui.gradient.npcunfriendlyR1,
			g1 = E.db.mui.gradient.npcunfriendlyG1,
			b1 = E.db.mui.gradient.npcunfriendlyB1,
			r2 = E.db.mui.gradient.npcunfriendlyR2,
			g2 = E.db.mui.gradient.npcunfriendlyG2,
			b2 = E.db.mui.gradient.npcunfriendlyB2,
		},
		["NPCHOSTILE"] = {
			r1 = E.db.mui.gradient.npchostileR1,
			g1 = E.db.mui.gradient.npchostileG1,
			b1 = E.db.mui.gradient.npchostileB1,
			r2 = E.db.mui.gradient.npchostileR2,
			g2 = E.db.mui.gradient.npchostileG2,
			b2 = E.db.mui.gradient.npchostileB2,
		},
		["TAPPED"] = {
			r1 = E.db.mui.gradient.tappedR1,
			g1 = E.db.mui.gradient.tappedG1,
			b1 = E.db.mui.gradient.tappedB1,
			r2 = E.db.mui.gradient.tappedR2,
			g2 = E.db.mui.gradient.tappedG2,
			b2 = E.db.mui.gradient.tappedB2,
		},
		["GOODTHREAT"] = {
			r1 = E.db.mui.gradient.goodthreatR1,
			g1 = E.db.mui.gradient.goodthreatG1,
			b1 = E.db.mui.gradient.goodthreatB1,
			r2 = E.db.mui.gradient.goodthreatR2,
			g2 = E.db.mui.gradient.goodthreatG2,
			b2 = E.db.mui.gradient.goodthreatB2,
		},
		["BADTHREAT"] = {
			r1 = E.db.mui.gradient.badthreatR1,
			g1 = E.db.mui.gradient.badthreatG1,
			b1 = E.db.mui.gradient.badthreatB1,
			r2 = E.db.mui.gradient.badthreatR2,
			g2 = E.db.mui.gradient.badthreatG2,
			b2 = E.db.mui.gradient.badthreatB2,
		},
		["GOODTHREATTRANSITION"] = {
			r1 = E.db.mui.gradient.goodthreattransitionR1,
			g1 = E.db.mui.gradient.goodthreattransitionG1,
			b1 = E.db.mui.gradient.goodthreattransitionB1,
			r2 = E.db.mui.gradient.goodthreattransitionR2,
			g2 = E.db.mui.gradient.goodthreattransitionG2,
			b2 = E.db.mui.gradient.goodthreattransitionB2,
		},
		["BADTHREATTRANSITION"] = {
			r1 = E.db.mui.gradient.badthreattransitionR1,
			g1 = E.db.mui.gradient.badthreattransitionG1,
			b1 = E.db.mui.gradient.badthreattransitionB1,
			r2 = E.db.mui.gradient.badthreattransitionR2,
			g2 = E.db.mui.gradient.badthreattransitionG2,
			b2 = E.db.mui.gradient.badthreattransitionB2,
		},
		["OFFTANK"] = {
			r1 = E.db.mui.gradient.offtankR1,
			g1 = E.db.mui.gradient.offtankG1,
			b1 = E.db.mui.gradient.offtankB1,
			r2 = E.db.mui.gradient.offtankR2,
			g2 = E.db.mui.gradient.offtankG2,
			b2 = E.db.mui.gradient.offtankB2,
		},
		["OFFTANKBADTHREATTRANSITION"] = {
			r1 = E.db.mui.gradient.badthreattransitionofftankR1,
			g1 = E.db.mui.gradient.badthreattransitionofftankG1,
			b1 = E.db.mui.gradient.badthreattransitionofftankB1,
			r2 = E.db.mui.gradient.badthreattransitionofftankR2,
			g2 = E.db.mui.gradient.badthreattransitionofftankG2,
			b2 = E.db.mui.gradient.badthreattransitionofftankB2,
		},
		["OFFTANKGOODTHREATTRANSITION"] = {
			r1 = E.db.mui.gradient.goodthreattransitionofftankR1,
			g1 = E.db.mui.gradient.goodthreattransitionofftankG1,
			b1 = E.db.mui.gradient.goodthreattransitionofftankB1,
			r2 = E.db.mui.gradient.goodthreattransitionofftankR2,
			g2 = E.db.mui.gradient.goodthreattransitionofftankG2,
			b2 = E.db.mui.gradient.goodthreattransitionofftankB2,
		},
		["MANA"] = {
			r1 = E.db.mui.gradient.manaR1,
			g1 = E.db.mui.gradient.manaG1,
			b1 = E.db.mui.gradient.manaB1,
			r2 = E.db.mui.gradient.manaR2,
			g2 = E.db.mui.gradient.manaG2,
			b2 = E.db.mui.gradient.manaB2,
		}, --MANA
		["RAGE"] = {
			r1 = E.db.mui.gradient.rageR1,
			g1 = E.db.mui.gradient.rageG1,
			b1 = E.db.mui.gradient.rageB1,
			r2 = E.db.mui.gradient.rageR2,
			g2 = E.db.mui.gradient.rageG2,
			b2 = E.db.mui.gradient.rageB2,
		}, --RAGE
		["FOCUS"] = {
			r1 = E.db.mui.gradient.focusR1,
			g1 = E.db.mui.gradient.focusG1,
			b1 = E.db.mui.gradient.focusB1,
			r2 = E.db.mui.gradient.focusR2,
			g2 = E.db.mui.gradient.focusG2,
			b2 = E.db.mui.gradient.focusB2,
		}, --FOCUS
		["ENERGY"] = {
			r1 = E.db.mui.gradient.energyR1,
			g1 = E.db.mui.gradient.energyG1,
			b1 = E.db.mui.gradient.energyB1,
			r2 = E.db.mui.gradient.energyR2,
			g2 = E.db.mui.gradient.energyG2,
			b2 = E.db.mui.gradient.energyB2,
		}, --ENERGY
		["RUNIC_POWER"] = {
			r1 = E.db.mui.gradient.runicpowerR1,
			g1 = E.db.mui.gradient.runicpowerG1,
			b1 = E.db.mui.gradient.runicpowerB1,
			r2 = E.db.mui.gradient.runicpowerR2,
			g2 = E.db.mui.gradient.runicpowerG2,
			b2 = E.db.mui.gradient.runicpowerB2,
		}, --RUNIC POWER
		["LUNAR_POWER"] = {
			r1 = E.db.mui.gradient.lunarpowerR1,
			g1 = E.db.mui.gradient.lunarpowerG1,
			b1 = E.db.mui.gradient.lunarpowerB1,
			r2 = E.db.mui.gradient.lunarpowerR2,
			g2 = E.db.mui.gradient.lunarpowerG2,
			b2 = E.db.mui.gradient.lunarpowerB2,
		}, --LUNAR POWER
		["ALT_POWER"] = {
			r1 = E.db.mui.gradient.altpowerR1,
			g1 = E.db.mui.gradient.altpowerG1,
			b1 = E.db.mui.gradient.altpowerB1,
			r2 = E.db.mui.gradient.altpowerR2,
			g2 = E.db.mui.gradient.altpowerG2,
			b2 = E.db.mui.gradient.altpowerB2,
		}, --ALTERNATE POWER
		["MAELSTROM"] = {
			r1 = E.db.mui.gradient.maelstromR1,
			g1 = E.db.mui.gradient.maelstromG1,
			b1 = E.db.mui.gradient.maelstromB1,
			r2 = E.db.mui.gradient.maelstromR2,
			g2 = E.db.mui.gradient.maelstromG2,
			b2 = E.db.mui.gradient.maelstromB2,
		}, --MAELSTROM
		["INSANITY"] = {
			r1 = E.db.mui.gradient.insanityR1,
			g1 = E.db.mui.gradient.insanityG1,
			b1 = E.db.mui.gradient.insanityB1,
			r2 = E.db.mui.gradient.insanityR2,
			g2 = E.db.mui.gradient.insanityG2,
			b2 = E.db.mui.gradient.insanityB2,
		}, --INSANITY
		["FURY"] = {
			r1 = E.db.mui.gradient.furyR1,
			g1 = E.db.mui.gradient.furyG1,
			b1 = E.db.mui.gradient.furyB1,
			r2 = E.db.mui.gradient.furyR2,
			g2 = E.db.mui.gradient.furyG2,
			b2 = E.db.mui.gradient.furyB2,
		}, --FURY
		["PAIN"] = {
			r1 = E.db.mui.gradient.painR1,
			g1 = E.db.mui.gradient.painG1,
			b1 = E.db.mui.gradient.painB1,
			r2 = E.db.mui.gradient.painR2,
			g2 = E.db.mui.gradient.painG2,
			b2 = E.db.mui.gradient.painB2,
		}, --PAIN
		["MERATHILIS"] = { r1 = 0.50, g1 = 0.70, b1 = 1, r2 = 0.67, g2 = 0.95, b2 = 1 },
		["BACKDROP"] = {
			r1 = E.db.mui.gradient.backdropR1,
			g1 = E.db.mui.gradient.backdropG1,
			b1 = E.db.mui.gradient.backdropB1,
			r2 = E.db.mui.gradient.backdropR2,
			g2 = E.db.mui.gradient.backdropG2,
			b2 = E.db.mui.gradient.backdropB2,
		}, --backdrop gradient
	}
end

local ClassColorReaction = {
	["WARRIOR"] = { r1 = 0.77646887302399, g1 = 0.60784178972244, b1 = 0.4274500310421 },
	["PALADIN"] = { r1 = 0.95686066150665, g1 = 0.54901838302612, b1 = 0.72941017150879 },
	["HUNTER"] = { r1 = 0.66666519641876, g1 = 0.82744914293289, b1 = 0.44705784320831 },
	["ROGUE"] = { r1 = 0.99999779462814, g1 = 0.95686066150665, b1 = 0.40784224867821 },
	["PRIEST"] = { r1 = 0.99999779462814, g1 = 0.99999779462814, b1 = 0.99999779462814 },
	["DEATHKNIGHT"] = { r1 = 0.76862573623657, g1 = 0.11764679849148, b1 = 0.2274504750967 },
	["SHAMAN"] = { r1 = 0, g1 = 0.4392147064209, b1 = 0.86666476726532 },
	["MAGE"] = { r1 = 0.24705828726292, g1 = 0.78039044141769, b1 = 0.92156660556793 },
	["WARLOCK"] = { r1 = 0.52941060066223, g1 = 0.53333216905594, b1 = 0.93333131074905 },
	["MONK"] = { r1 = 0, g1 = 0.99999779462814, b1 = 0.59607714414597 },
	["DRUID"] = { r1 = 0.99999779462814, g1 = 0.48627343773842, b1 = 0.039215601980686 },
	["DEMONHUNTER"] = { r1 = 0.63921427726746, g1 = 0.1882348805666, b1 = 0.78823357820511 },
	["EVOKER"] = { r1 = 0.19607843137255, g1 = 0.46666666666667, b1 = 0.53725490196078 },
	["NPCFRIENDLY"] = { r1 = 0.2, g1 = 1, b1 = 0.2 },
	["NPCNEUTRAL"] = { r1 = 0.89, g1 = 0.89, b1 = 0 },
	["NPCUNFRIENDLY"] = { r1 = 0.94, g1 = 0.37, b1 = 0 },
	["NPCHOSTILE"] = { r1 = 0.8, g1 = 0, b1 = 0 },
}

local colorUpdate = CreateFrame("FRAME")
colorUpdate:RegisterEvent("PLAYER_ENTERING_WORLD")
colorUpdate:RegisterEvent("PLAYER_STARTED_MOVING")
colorUpdate:SetScript("OnEvent", function()
	colorUpdate:UnregisterAllEvents()
	F:GradientColorUpdate()
end)

do
	F.ClassList = {}
	for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_MALE) do
		F.ClassList[v] = k
	end
	for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_FEMALE) do
		F.ClassList[v] = k
	end
end

F.ClassColors = {}
local colors = _G.CUSTOM_CLASS_COLORS or _G.RAID_CLASS_COLORS
for class, value in pairs(colors) do
	F.ClassColors[class] = {}
	F.ClassColors[class].r = value.r
	F.ClassColors[class].g = value.g
	F.ClassColors[class].b = value.b
	F.ClassColors[class].colorStr = value.colorStr
end
F.r, F.g, F.b = F.ClassColors[E.myclass].r, F.ClassColors[E.myclass].g, F.ClassColors[E.myclass].b

function F.ClassColor(class)
	local color = F.ClassColors[class]
	if not color then
		return 1, 1, 1
	end

	return color.r, color.g, color.b
end

function F.UnitColor(unit)
	local r, g, b = 1, 1, 1

	if UnitIsPlayer(unit) then
		local class = select(2, UnitClass(unit))
		if class then
			r, g, b = F.ClassColor(class)
		end
	elseif UnitIsTapDenied(unit) then
		r, g, b = 0.6, 0.6, 0.6
	else
		local reaction = UnitReaction(unit, "player")
		if reaction then
			local color = _G.FACTION_BAR_COLORS[reaction]
			r, g, b = color.r, color.g, color.b
		end
	end

	return r, g, b
end

local defaultColor = { r = 1, g = 1, b = 1, a = 1 }
function F.unpackColor(color)
	if not color then
		color = defaultColor
	end

	return color.r, color.g, color.b, color.a
end

--return the background offset
local function bgfade(isBG)
	if isBG then
		return E.db.mui.gradient.bgfade
	else
		return 0
	end
end

--return the backdrop alpha
local function bgalpha(alpha, isHealth)
	if alpha then
		if isHealth then
			return E.db.mui.gradient.healthalpha
		else
			return E.db.mui.gradient.backdropalpha
		end
	else
		return 1
	end
end

function F.GradientColors(unitclass, invert, alpha, isBG, customalpha, isHealth)
	local color = UnitframeGradients[unitclass] or UnitframeGradients["MERATHILIS"]

	if customalpha then
		if invert then
			return {
				r = F:Interval(color.r2 - bgfade(isBG), 0, 1),
				g = F:Interval(color.g2 - bgfade(isBG), 0, 1),
				b = F:Interval(color.b2 - bgfade(isBG), 0, 1),
				a = customalpha,
			}, {
				r = F:Interval(color.r1 - bgfade(isBG), 0, 1),
				g = F:Interval(color.g1 - bgfade(isBG), 0, 1),
				b = F:Interval(color.b1 - bgfade(isBG), 0, 1),
				a = customalpha,
			}
		else
			return {
				r = F:Interval(color.r1 - bgfade(isBG), 0, 1),
				g = F:Interval(color.g1 - bgfade(isBG), 0, 1),
				b = F:Interval(color.b1 - bgfade(isBG), 0, 1),
				a = customalpha,
			}, {
				r = F:Interval(color.r2 - bgfade(isBG), 0, 1),
				g = F:Interval(color.g2 - bgfade(isBG), 0, 1),
				b = F:Interval(color.b2 - bgfade(isBG), 0, 1),
				a = customalpha,
			}
		end
	else
		if invert then
			return {
				r = F:Interval(color.r2 - bgfade(isBG), 0, 1),
				g = F:Interval(color.g2 - bgfade(isBG), 0, 1),
				b = F:Interval(color.b2 - bgfade(isBG), 0, 1),
				a = bgalpha(alpha, isHealth),
			}, {
				r = F:Interval(color.r1 - bgfade(isBG), 0, 1),
				g = F:Interval(color.g1 - bgfade(isBG), 0, 1),
				b = F:Interval(color.b1 - bgfade(isBG), 0, 1),
				a = bgalpha(alpha, isHealth),
			}
		else
			return {
				r = F:Interval(color.r1 - bgfade(isBG), 0, 1),
				g = F:Interval(color.g1 - bgfade(isBG), 0, 1),
				b = F:Interval(color.b1 - bgfade(isBG), 0, 1),
				a = bgalpha(alpha, isHealth),
			}, {
				r = F:Interval(color.r2 - bgfade(isBG), 0, 1),
				g = F:Interval(color.g2 - bgfade(isBG), 0, 1),
				b = F:Interval(color.b2 - bgfade(isBG), 0, 1),
				a = bgalpha(alpha, isHealth),
			}
		end
	end
end

function F.GradientColorsCustom(unitclass, invert, alpha, isBG, customalpha, isHealth)
	local color = UnitframeCustomGradients[unitclass] or UnitframeCustomGradients["MERATHILIS"]
	if not color then
		return
	end

	if customalpha then
		if invert then
			return {
				r = F:Interval(color.r2 - bgfade(isBG), 0, 1),
				g = F:Interval(color.g2 - bgfade(isBG), 0, 1),
				b = F:Interval(color.b2 - bgfade(isBG), 0, 1),
				a = customalpha,
			}, {
				r = F:Interval(color.r1 - bgfade(isBG), 0, 1),
				g = F:Interval(color.g1 - bgfade(isBG), 0, 1),
				b = F:Interval(color.b1 - bgfade(isBG), 0, 1),
				a = customalpha,
			}
		else
			return {
				r = F:Interval(color.r1 - bgfade(isBG), 0, 1),
				g = F:Interval(color.g1 - bgfade(isBG), 0, 1),
				b = F:Interval(color.b1 - bgfade(isBG), 0, 1),
				a = customalpha,
			}, {
				r = F:Interval(color.r2 - bgfade(isBG), 0, 1),
				g = F:Interval(color.g2 - bgfade(isBG), 0, 1),
				b = F:Interval(color.b2 - bgfade(isBG), 0, 1),
				a = customalpha,
			}
		end
	else
		if invert then
			return {
				r = F:Interval(color.r2 - bgfade(isBG), 0, 1),
				g = F:Interval(color.g2 - bgfade(isBG), 0, 1),
				b = F:Interval(color.b2 - bgfade(isBG), 0, 1),
				a = bgalpha(alpha, isHealth),
			}, {
				r = F:Interval(color.r1 - bgfade(isBG), 0, 1),
				g = F:Interval(color.g1 - bgfade(isBG), 0, 1),
				b = F:Interval(color.b1 - bgfade(isBG), 0, 1),
				a = bgalpha(alpha, isHealth),
			}
		else
			return {
				r = F:Interval(color.r1 - bgfade(isBG), 0, 1),
				g = F:Interval(color.g1 - bgfade(isBG), 0, 1),
				b = F:Interval(color.b1 - bgfade(isBG), 0, 1),
				a = bgalpha(alpha, isHealth),
			}, {
				r = F:Interval(color.r2 - bgfade(isBG), 0, 1),
				g = F:Interval(color.g2 - bgfade(isBG), 0, 1),
				b = F:Interval(color.b2 - bgfade(isBG), 0, 1),
				a = bgalpha(alpha, isHealth),
			}
		end
	end
end

-- Different for details because bars are different
function F.GradientColorsDetails(unitclass)
	local color = UnitframeGradients[unitclass] or UnitframeGradients["NPCNEUTRAL"]
	return { r = color.r1 - 0.2, g = color.g1 - 0.2, b = color.b1 - 0.2, a = 0.9 }, {
		r = color.r2 + 0.2,
		g = color.g2 + 0.2,
		b = color.b2 + 0.2,
		a = 0.9,
	}
end

function F.GradientColorsDetailsCustom(unitclass)
	local color = UnitframeCustomGradients[unitclass] or UnitframeCustomGradients["NPCNEUTRAL"]
	return { r = color.r1, g = color.g1, b = color.b1, a = 0.9 }, {
		r = color.r2,
		g = color.g2,
		b = color.b2,
		a = 0.9,
	}
end

function F.GetClassColorsRGB(unitclass)
	if unitclass then
		return {
			r = ClassColorReaction[unitclass]["r1"],
			g = ClassColorReaction[unitclass]["g1"],
			b = ClassColorReaction[unitclass]["b1"],
		}
	else
		return { r1 = 1, g1 = 0, b1 = 0 } --debug red
	end
end

function F.GradientName(name, unitclass, isTarget, isUnit)
	if not name then
		return
	end

	if F.CheckInstanceSecret() and isUnit then
		local cs = F.GetClassColorsRGB(unitclass)
		return E:RGBToHex(cs.r, cs.g, cs.b) .. name
	else
		local color = UnitframeGradients[unitclass] or UnitframeGradients.MANA
		if not isTarget then
			return E:TextGradient(name, color.r2, color.g2, color.b2, color.r1, color.g1, color.b1)
		else
			return E:TextGradient(name, color.r1, color.g1, color.b1, color.r2, color.g2, color.b2)
		end
	end
end

function F.GradientNameCustom(name, unitclass, isTarget)
	if not name then
		return
	end

	local color = customgradientsColor[unitclass] or customgradientsColor.MANA
	if not isTarget then
		return E:TextGradient(name, color.r2, color.g2, color.b2, color.r1, color.g1, color.b1)
	else
		return E:TextGradient(name, color.r1, color.g1, color.b1, color.r2, color.g2, color.b2)
	end
end

function F.Color.SetGradient(obj, orientation, minColor, maxColor)
	if not obj then
		return
	end

	if not minColor.r or not minColor.g or not minColor.b then
		return
	end
	if not maxColor.r or not maxColor.g or not maxColor.b then
		return
	end

	obj:SetGradient(orientation, minColor, maxColor)
end

function F.Color.SetGradientRGB(obj, orientation, r1, g1, b1, a1, r2, g2, b2, a2)
	F.Color.SetGradient(obj, orientation, CreateColor(r1, g1, b1, a1), CreateColor(r2, g2, b2, a2))
end

function F.Color.UpdateGradient(obj, perc, minColor, maxColor)
	if not minColor.r or not minColor.g or not minColor.b then
		return
	end
	if not maxColor.r or not maxColor.g or not maxColor.b then
		return
	end

	if perc >= 1 then
		local r, g, b = maxColor:GetRGBA()
		obj:SetRGBA(r, g, b, 1)
		return
	elseif perc <= 0 then
		local r, g, b = minColor:GetRGBA()
		obj:SetRGBA(r, g, b, 1)
		return
	end

	obj:SetRGBA(
		(maxColor.r * perc) + (minColor.r * (1 - perc)),
		(maxColor.g * perc) + (minColor.g * (1 - perc)),
		(maxColor.b * perc) + (minColor.b * (1 - perc)),
		1
	)
end

function F.HexRGB(r, g, b)
	if r then
		if type(r) == "table" then
			if r.r then
				r, g, b = r.r, r.g, r.b
			else
				r, g, b = unpack(r)
			end
		end
		return format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
	end
end

local progressColor = {
	start = { r = 1.000, g = 0.647, b = 0.008 },
	complete = { r = 0.180, g = 0.835, b = 0.451 },
}

---Get color based on progress value (0.0 to 1.0)
---@param progress number Progress value between 0 and 1
---@return RGB color Color table with r, g, b values
function F.GetProgressColor(progress)
	local r = (progressColor.complete.r - progressColor.start.r) * progress + progressColor.start.r
	local g = (progressColor.complete.g - progressColor.start.g) * progress + progressColor.start.g
	local b = (progressColor.complete.r - progressColor.start.b) * progress + progressColor.start.b

	-- algorithm to let the color brighter
	local addition = 0.35
	r = min(r + abs(0.5 - progress) * addition, r)
	g = min(g + abs(0.5 - progress) * addition, g)
	b = min(b + abs(0.5 - progress) * addition, b)

	return { r = r, g = g, b = b }
end
