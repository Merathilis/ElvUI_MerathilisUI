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

local C_ClassColor_GetClassColor = C_ClassColor.GetClassColor

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
	local colorDB = E and E.db and E.db.mui and E.db.mui.gradient

	UnitframeCustomGradients = {
		["WARRIOR"] = {
			r1 = colorDB and colorDB.warriorcolorR1,
			g1 = colorDB and colorDB.warriorcolorG1,
			b1 = colorDB and colorDB.warriorcolorB1,
			r2 = colorDB and colorDB.warriorcolorR2,
			g2 = colorDB and colorDB.warriorcolorG2,
			b2 = colorDB and colorDB.warriorcolorB2,
		},
		["PALADIN"] = {
			r1 = colorDB and colorDB.paladincolorR1,
			g1 = colorDB and colorDB.paladincolorG1,
			b1 = colorDB and colorDB.paladincolorB1,
			r2 = colorDB and colorDB.paladincolorR2,
			g2 = colorDB and colorDB.paladincolorG2,
			b2 = colorDB and colorDB.paladincolorB2,
		},
		["HUNTER"] = {
			r1 = colorDB and colorDB.huntercolorR1,
			g1 = colorDB and colorDB.huntercolorG1,
			b1 = colorDB and colorDB.huntercolorB1,
			r2 = colorDB and colorDB.huntercolorR2,
			g2 = colorDB and colorDB.huntercolorG2,
			b2 = colorDB and colorDB.huntercolorB2,
		},
		["ROGUE"] = {
			r1 = colorDB and colorDB.roguecolorR1,
			g1 = colorDB and colorDB.roguecolorG1,
			b1 = colorDB and colorDB.roguecolorB1,
			r2 = colorDB and colorDB.roguecolorR2,
			g2 = colorDB and colorDB.roguecolorG2,
			b2 = colorDB and colorDB.roguecolorB2,
		},
		["PRIEST"] = {
			r1 = colorDB and colorDB.priestcolorR1,
			g1 = colorDB and colorDB.priestcolorG1,
			b1 = colorDB and colorDB.priestcolorB1,
			r2 = colorDB and colorDB.priestcolorR2,
			g2 = colorDB and colorDB.priestcolorG2,
			b2 = colorDB and colorDB.priestcolorB2,
		},
		["DEATHKNIGHT"] = {
			r1 = colorDB and colorDB.deathknightcolorR1,
			g1 = colorDB and colorDB.deathknightcolorG1,
			b1 = colorDB and colorDB.deathknightcolorB1,
			r2 = colorDB and colorDB.deathknightcolorR2,
			g2 = colorDB and colorDB.deathknightcolorG2,
			b2 = colorDB and colorDB.deathknightcolorB2,
		},
		["SHAMAN"] = {
			r1 = colorDB and colorDB.shamancolorR1,
			g1 = colorDB and colorDB.shamancolorG1,
			b1 = colorDB and colorDB.shamancolorB1,
			r2 = colorDB and colorDB.shamancolorR2,
			g2 = colorDB and colorDB.shamancolorG2,
			b2 = colorDB and colorDB.shamancolorB2,
		},
		["MAGE"] = {
			r1 = colorDB and colorDB.magecolorR1,
			g1 = colorDB and colorDB.magecolorG1,
			b1 = colorDB and colorDB.magecolorB1,
			r2 = colorDB and colorDB.magecolorR2,
			g2 = colorDB and colorDB.magecolorG2,
			b2 = colorDB and colorDB.magecolorB2,
		},
		["WARLOCK"] = {
			r1 = colorDB and colorDB.warlockcolorR1,
			g1 = colorDB and colorDB.warlockcolorG1,
			b1 = colorDB and colorDB.warlockcolorB1,
			r2 = colorDB and colorDB.warlockcolorR2,
			g2 = colorDB and colorDB.warlockcolorG2,
			b2 = colorDB and colorDB.warlockcolorB2,
		},
		["MONK"] = {
			r1 = colorDB and colorDB.monkcolorR1,
			g1 = colorDB and colorDB.monkcolorG1,
			b1 = colorDB and colorDB.monkcolorB1,
			r2 = colorDB and colorDB.monkcolorR2,
			g2 = colorDB and colorDB.monkcolorG2,
			b2 = colorDB and colorDB.monkcolorB2,
		},
		["DRUID"] = {
			r1 = colorDB and colorDB.druidcolorR1,
			g1 = colorDB and colorDB.druidcolorG1,
			b1 = colorDB and colorDB.druidcolorB1,
			r2 = colorDB and colorDB.druidcolorR2,
			g2 = colorDB and colorDB.druidcolorG2,
			b2 = colorDB and colorDB.druidcolorB2,
		},
		["DEMONHUNTER"] = {
			r1 = colorDB and colorDB.demonhuntercolorR1,
			g1 = colorDB and colorDB.demonhuntercolorG1,
			b1 = colorDB and colorDB.demonhuntercolorB1,
			r2 = colorDB and colorDB.demonhuntercolorR2,
			g2 = colorDB and colorDB.demonhuntercolorG2,
			b2 = colorDB and colorDB.demonhuntercolorB2,
		},
		["EVOKER"] = {
			r1 = colorDB and colorDB.evokercolorR1,
			g1 = colorDB and colorDB.evokercolorG1,
			b1 = colorDB and colorDB.evokercolorB1,
			r2 = colorDB and colorDB.evokercolorR2,
			g2 = colorDB and colorDB.evokercolorG2,
			b2 = colorDB and colorDB.evokercolorB2,
		},
		["NPCFRIENDLY"] = {
			r1 = colorDB and colorDB.npcfriendlyR1,
			g1 = colorDB and colorDB.npcfriendlyG1,
			b1 = colorDB and colorDB.npcfriendlyB1,
			r2 = colorDB and colorDB.npcfriendlyR2,
			g2 = colorDB and colorDB.npcfriendlyG2,
			b2 = colorDB and colorDB.npcfriendlyB2,
		},
		["NPCNEUTRAL"] = {
			r1 = colorDB and colorDB.npcneutralR1,
			g1 = colorDB and colorDB.npcneutralG1,
			b1 = colorDB and colorDB.npcneutralB1,
			r2 = colorDB and colorDB.npcneutralR2,
			g2 = colorDB and colorDB.npcneutralG2,
			b2 = colorDB and colorDB.npcneutralB2,
		},
		["NPCUNFRIENDLY"] = {
			r1 = colorDB and colorDB.npcunfriendlyR1,
			g1 = colorDB and colorDB.npcunfriendlyG1,
			b1 = colorDB and colorDB.npcunfriendlyB1,
			r2 = colorDB and colorDB.npcunfriendlyR2,
			g2 = colorDB and colorDB.npcunfriendlyG2,
			b2 = colorDB and colorDB.npcunfriendlyB2,
		},
		["NPCHOSTILE"] = {
			r1 = colorDB and colorDB.npchostileR1,
			g1 = colorDB and colorDB.npchostileG1,
			b1 = colorDB and colorDB.npchostileB1,
			r2 = colorDB and colorDB.npchostileR2,
			g2 = colorDB and colorDB.npchostileG2,
			b2 = colorDB and colorDB.npchostileB2,
		},
		["TAPPED"] = {
			r1 = colorDB and colorDB.tappedR1,
			g1 = colorDB and colorDB.tappedG1,
			b1 = colorDB and colorDB.tappedB1,
			r2 = colorDB and colorDB.tappedR2,
			g2 = colorDB and colorDB.tappedG2,
			b2 = colorDB and colorDB.tappedB2,
		},
		["GOODTHREAT"] = {
			r1 = colorDB and colorDB.goodthreatR1,
			g1 = colorDB and colorDB.goodthreatG1,
			b1 = colorDB and colorDB.goodthreatB1,
			r2 = colorDB and colorDB.goodthreatR2,
			g2 = colorDB and colorDB.goodthreatG2,
			b2 = colorDB and colorDB.goodthreatB2,
		},
		["BADTHREAT"] = {
			r1 = colorDB and colorDB.badthreatR1,
			g1 = colorDB and colorDB.badthreatG1,
			b1 = colorDB and colorDB.badthreatB1,
			r2 = colorDB and colorDB.badthreatR2,
			g2 = colorDB and colorDB.badthreatG2,
			b2 = colorDB and colorDB.badthreatB2,
		},
		["GOODTHREATTRANSITION"] = {
			r1 = colorDB and colorDB.goodthreattransitionR1,
			g1 = colorDB and colorDB.goodthreattransitionG1,
			b1 = colorDB and colorDB.goodthreattransitionB1,
			r2 = colorDB and colorDB.goodthreattransitionR2,
			g2 = colorDB and colorDB.goodthreattransitionG2,
			b2 = colorDB and colorDB.goodthreattransitionB2,
		},
		["BADTHREATTRANSITION"] = {
			r1 = colorDB and colorDB.badthreattransitionR1,
			g1 = colorDB and colorDB.badthreattransitionG1,
			b1 = colorDB and colorDB.badthreattransitionB1,
			r2 = colorDB and colorDB.badthreattransitionR2,
			g2 = colorDB and colorDB.badthreattransitionG2,
			b2 = colorDB and colorDB.badthreattransitionB2,
		},
		["OFFTANK"] = {
			r1 = colorDB and colorDB.offtankR1,
			g1 = colorDB and colorDB.offtankG1,
			b1 = colorDB and colorDB.offtankB1,
			r2 = colorDB and colorDB.offtankR2,
			g2 = colorDB and colorDB.offtankG2,
			b2 = colorDB and colorDB.offtankB2,
		},
		["OFFTANKBADTHREATTRANSITION"] = {
			r1 = colorDB and colorDB.badthreattransitionofftankR1,
			g1 = colorDB and colorDB.badthreattransitionofftankG1,
			b1 = colorDB and colorDB.badthreattransitionofftankB1,
			r2 = colorDB and colorDB.badthreattransitionofftankR2,
			g2 = colorDB and colorDB.badthreattransitionofftankG2,
			b2 = colorDB and colorDB.badthreattransitionofftankB2,
		},
		["OFFTANKGOODTHREATTRANSITION"] = {
			r1 = colorDB and colorDB.goodthreattransitionofftankR1,
			g1 = colorDB and colorDB.goodthreattransitionofftankG1,
			b1 = colorDB and colorDB.goodthreattransitionofftankB1,
			r2 = colorDB and colorDB.goodthreattransitionofftankR2,
			g2 = colorDB and colorDB.goodthreattransitionofftankG2,
			b2 = colorDB and colorDB.goodthreattransitionofftankB2,
		},
		["MANA"] = {
			r1 = colorDB and colorDB.manaR1,
			g1 = colorDB and colorDB.manaG1,
			b1 = colorDB and colorDB.manaB1,
			r2 = colorDB and colorDB.manaR2,
			g2 = colorDB and colorDB.manaG2,
			b2 = colorDB and colorDB.manaB2,
		}, --MANA
		["RAGE"] = {
			r1 = colorDB and colorDB.rageR1,
			g1 = colorDB and colorDB.rageG1,
			b1 = colorDB and colorDB.rageB1,
			r2 = colorDB and colorDB.rageR2,
			g2 = colorDB and colorDB.rageG2,
			b2 = colorDB and colorDB.rageB2,
		}, --RAGE
		["FOCUS"] = {
			r1 = colorDB and colorDB.focusR1,
			g1 = colorDB and colorDB.focusG1,
			b1 = colorDB and colorDB.focusB1,
			r2 = colorDB and colorDB.focusR2,
			g2 = colorDB and colorDB.focusG2,
			b2 = colorDB and colorDB.focusB2,
		}, --FOCUS
		["ENERGY"] = {
			r1 = colorDB and colorDB.energyR1,
			g1 = colorDB and colorDB.energyG1,
			b1 = colorDB and colorDB.energyB1,
			r2 = colorDB and colorDB.energyR2,
			g2 = colorDB and colorDB.energyG2,
			b2 = colorDB and colorDB.energyB2,
		}, --ENERGY
		["RUNIC_POWER"] = {
			r1 = colorDB and colorDB.runicpowerR1,
			g1 = colorDB and colorDB.runicpowerG1,
			b1 = colorDB and colorDB.runicpowerB1,
			r2 = colorDB and colorDB.runicpowerR2,
			g2 = colorDB and colorDB.runicpowerG2,
			b2 = colorDB and colorDB.runicpowerB2,
		}, --RUNIC POWER
		["LUNAR_POWER"] = {
			r1 = colorDB and colorDB.lunarpowerR1,
			g1 = colorDB and colorDB.lunarpowerG1,
			b1 = colorDB and colorDB.lunarpowerB1,
			r2 = colorDB and colorDB.lunarpowerR2,
			g2 = colorDB and colorDB.lunarpowerG2,
			b2 = colorDB and colorDB.lunarpowerB2,
		}, --LUNAR POWER
		["ALT_POWER"] = {
			r1 = colorDB and colorDB.altpowerR1,
			g1 = colorDB and colorDB.altpowerG1,
			b1 = colorDB and colorDB.altpowerB1,
			r2 = colorDB and colorDB.altpowerR2,
			g2 = colorDB and colorDB.altpowerG2,
			b2 = colorDB and colorDB.altpowerB2,
		}, --ALTERNATE POWER
		["MAELSTROM"] = {
			r1 = colorDB and colorDB.maelstromR1,
			g1 = colorDB and colorDB.maelstromG1,
			b1 = colorDB and colorDB.maelstromB1,
			r2 = colorDB and colorDB.maelstromR2,
			g2 = colorDB and colorDB.maelstromG2,
			b2 = colorDB and colorDB.maelstromB2,
		}, --MAELSTROM
		["INSANITY"] = {
			r1 = colorDB and colorDB.insanityR1,
			g1 = colorDB and colorDB.insanityG1,
			b1 = colorDB and colorDB.insanityB1,
			r2 = colorDB and colorDB.insanityR2,
			g2 = colorDB and colorDB.insanityG2,
			b2 = colorDB and colorDB.insanityB2,
		}, --INSANITY
		["FURY"] = {
			r1 = colorDB and colorDB.furyR1,
			g1 = colorDB and colorDB.furyG1,
			b1 = colorDB and colorDB.furyB1,
			r2 = colorDB and colorDB.furyR2,
			g2 = colorDB and colorDB.furyG2,
			b2 = colorDB and colorDB.furyB2,
		}, --FURY
		["PAIN"] = {
			r1 = colorDB and colorDB.painR1,
			g1 = colorDB and colorDB.painG1,
			b1 = colorDB and colorDB.painB1,
			r2 = colorDB and colorDB.painR2,
			g2 = colorDB and colorDB.painG2,
			b2 = colorDB and colorDB.painB2,
		}, --PAIN
		["MERATHILIS"] = { r1 = 0.50, g1 = 0.70, b1 = 1, r2 = 0.67, g2 = 0.95, b2 = 1 },
		["BACKDROP"] = {
			r1 = colorDB and colorDB.backdropR1,
			g1 = colorDB and colorDB.backdropG1,
			b1 = colorDB and colorDB.backdropB1,
			r2 = colorDB and colorDB.backdropR2,
			g2 = colorDB and colorDB.backdropG2,
			b2 = colorDB and colorDB.backdropB2,
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

function F.GetClassColorsRGB(unitclass, tableType)
	if E:NotSecretValue(unitclass) then
		if unitclass and ClassColorReaction[unitclass] then
			return {
				r = ClassColorReaction[unitclass]["r1"],
				g = ClassColorReaction[unitclass]["g1"],
				b = ClassColorReaction[unitclass]["b1"],
			}
		else
			return { r1 = 1, g1 = 0, b1 = 0 }
		end
	else
		local classColor = C_ClassColor_GetClassColor(unitclass)
		if tableType then
			return classColor.r, classColor.g, classColor.b
		else
			if tableType == 1 then
				return { r1 = classColor.r, g1 = classColor.g, b1 = classColor.b }
			elseif tableType == 2 then
				return { r = classColor.r, g = classColor.g, b = classColor.b }, {
					r = classColor.r,
					g = classColor.g,
					b = classColor.b,
				}
			elseif tableType == 3 then
				return { r = classColor.r, g = classColor.g, b = classColor.b }
			end
		end
	end
end

function F.GradientName(name, unitclass, isTarget, isUnit)
	if not name then
		return
	end

	if not F.IsThisASafeSecret() and isUnit then
		local cs = F.GetClassColorsRGB(unitclass, 3)
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

	local color = UnitframeCustomGradients[unitclass] or UnitframeCustomGradients.MANA
	if not isTarget then
		return E:TextGradient(name, color.r2, color.g2, color.b2, color.r1, color.g1, color.b1)
	else
		return E:TextGradient(name, color.r1, color.g1, color.b1, color.r2, color.g2, color.b2)
	end
end

function F.Color.EqualTo(aColor, bColor)
	return F.AlmostEqual(aColor.r, bColor.r)
		and F.AlmostEqual(aColor.g, bColor.g)
		and F.AlmostEqual(aColor.b, bColor.b)
		and F.AlmostEqual(aColor.a, bColor.a)
end

function F.Color.EqualToRGB(aColor, r, g, b)
	return F.AlmostEqual(aColor.r, r) and F.AlmostEqual(aColor.g, g) and F.AlmostEqual(aColor.b, b)
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

	obj:SetGradient(
		orientation,
		CreateColor(minColor.r, minColor.g, minColor.b, minColor.a or 1),
		CreateColor(maxColor.r, maxColor.g, maxColor.b, maxColor.a or 1)
	)
end

function F.Color.SetGradientRGB(obj, orientation, r1, g1, b1, a1, r2, g2, b2, a2)
	if not obj then
		return
	end

	F.Color.SetGradient(obj, orientation, CreateColor(r1, g1, b1, a1), CreateColor(r2, g2, b2, a2))
end

function F.Color.UpdateGradient(obj, perc, minColor, maxColor)
	if not obj then
		return
	end

	if not minColor.r or not minColor.g or not minColor.b then
		return
	end
	if not maxColor.r or not maxColor.g or not maxColor.b then
		return
	end

	if perc >= 1 then
		obj:SetRGBA(maxColor.r, maxColor.g, maxColor.b, 1)
		return
	elseif perc <= 0 then
		obj:SetRGBA(minColor.r, minColor.g, minColor.b, 1)
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
	local b = (progressColor.complete.b - progressColor.start.b) * progress + progressColor.start.b

	-- algorithm to let the color brighter
	local addition = 0.35
	r = min(r + abs(0.5 - progress) * addition, r)
	g = min(g + abs(0.5 - progress) * addition, g)
	b = min(b + abs(0.5 - progress) * addition, b)

	return { r = r, g = g, b = b }
end

do
	local colorCache = {}
	local colorCacheBackground = {}

	function F.Color.GenerateCache()
		local db = E.db.mui.themes.gradientMode
		if not db then
			return
		end

		for _, colorKey in pairs({
			"reactionColorMap",
			"castColorMap",
			"powerColorMap",
			"specialColorMap",
			"classColorMap",
		}) do
			local colorMap = db[colorKey]
			if colorMap then
				for _, colorType in pairs({ I.Enum.GradientMode.Color.NORMAL, I.Enum.GradientMode.Color.SHIFT }) do
					local modS, modL
					if type(db.saturationBoost) == "table" then
						if colorType == I.Enum.GradientMode.Color.NORMAL then
							modS, modL = db.saturationBoost.normalSat, db.saturationBoost.normalLight
						else
							modS, modL = db.saturationBoost.shiftSat, db.saturationBoost.shiftLight
						end
					end

					for colorEntry, colorArray in pairs(colorMap[colorType]) do
						local r1, g1, b1

						if type(db.saturationBoost) == "table" and db.saturationBoost.enable then
							local h, s, l = F.ConvertToHSL(colorArray.r, colorArray.g, colorArray.b)
							r1, g1, b1 = F.ConvertToRGB(F.ClampToHSL(h, s * modS, l * modL))
						else
							r1, g1, b1 = colorArray.r, colorArray.g, colorArray.b
						end

						local r2, g2, b2 = F.CalculateMultiplierColor(db.backgroundMultiplier, r1, g1, b1)

						local tbl1 = F.Table.GetOrCreate(colorCache, colorKey, colorType)
						local tbl2 = F.Table.GetOrCreate(colorCacheBackground, colorKey, colorType)

						if tbl1[colorEntry] then
							tbl1[colorEntry]:SetRGBA(r1, g1, b1, 1)
							tbl2[colorEntry]:SetRGBA(r2, g2, b2, 1)
						else
							tbl1[colorEntry] = CreateColor(r1, g1, b1, 1)
							tbl2[colorEntry] = CreateColor(r2, g2, b2, 1)
						end
					end
				end
			end
		end
	end

	function F.Color.GetMap(colorMap)
		return colorCache[colorMap]
	end

	function F.Color.GetBackgroundMap(colorMap)
		return colorCacheBackground[colorMap]
	end
end

function F.Color.CalculateMultiplier(multi, color)
	local r, g, b = F.CalculateMultiplierColor(multi, color.r, color.g, color.b)
	return CreateColor(r, g, b, 1)
end

function F.Color.CalculateShift(boost, colorArray)
	local db = E.db.mui and E.db.mui.themes and E.db.mui.themes.gradientMode
	local modS, modL = boost and db.shiftSat or 1, boost and db.shiftLight or I.GradientMode.BackupMultiplier
	local h, s, l = F.ConvertToHSL(colorArray.r, colorArray.g, colorArray.b)
	local r, g, b = F.ConvertToRGB(F.ClampToHSL(h, s * modS, l * modL))
	return CreateColor(r, g, b, 1)
end

function F.Color.SlowCalculateShift(colorArray)
	local db = E.db.mui and E.db.mui.themes and E.db.mui.themes.gradientMode
	return F.Color.CalculateShift(db and db.saturationBoost.enabled, colorArray)
end
