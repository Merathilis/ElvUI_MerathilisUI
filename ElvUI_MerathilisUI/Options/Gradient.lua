local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local options = MER.options.gradient.args

options.gradient = {
	order = 1,
	type = "group",
	name = L["Gradient Colors"],
	get = function(info)
		return E.db.mui.gradient[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.gradient[info[#info]] = value; F:GradientColorUpdate()
	end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Gradient Colors"], 'gradient'),
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			width = "full",
		},
		colors = {
			order = 2,
			type = "group",
			name = L["Custom Gradient Colors"],
			disabled = function() return not E.db.mui.gradient.enable end,
			get = function(info)
				return E.db.mui.gradient.customColor[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.gradient.customColor[info[#info]] = value; F:GradientColorUpdate()
			end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = F.cOption(L["Custom Gradient Colors"], 'orange'),
				},
				enableClass = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					width = "full",
				},
				spacer = {
					order = 2,
					type = "description",
					name = "",
				},
				description1 = {
					order = 3,
					type = "description",
					name = L["Death Knight"],
					fontSize = "large"
				},
				deathknightcolor1 = {
					order = 4,
					type = "color",
					name = L["Color 1"],
					disabled = function() return not E.db.mui.gradient.enable or
						not E.db.mui.gradient.customColor.enableClass end,
					get = function()
						local dr = E.db.mui.gradient.customColor.deathknightcolorR1
						local dg = E.db.mui.gradient.customColor.deathknightcolorG1
						local db = E.db.mui.gradient.customColor.deathknightcolorB1
						local tr = P.gradient.customColor.deathknightcolorR1
						local tg = P.gradient.customColor.deathknightcolorG1
						local tb = P.gradient.customColor.deathknightcolorB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.deathknightcolorR1, E.db.mui.gradient.customColor.deathknightcolorG1, E.db.mui.gradient.customColor.deathknightcolorB1 =
						r, g, b; F:GradientColorUpdate()
					end
				},
				deathknightcolor2 = {
					order = 5,
					type = "color",
					name = L["Color 2"],
					disabled = function() return not E.db.mui.gradient.enable or
						not E.db.mui.gradient.customColor.enableClass end,
					get = function()
						local dr = E.db.mui.gradient.customColor.deathknightcolorR2
						local dg = E.db.mui.gradient.customColor.deathknightcolorG2
						local db = E.db.mui.gradient.customColor.deathknightcolorB2
						local tr = P.gradient.customColor.deathknightcolorR2
						local tg = P.gradient.customColor.deathknightcolorG2
						local tb = P.gradient.customColor.deathknightcolorB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.deathknightcolorR2, E.db.mui.gradient.customColor.deathknightcolorG2, E.db.mui.gradient.customColor.deathknightcolorB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description2 = {
					order = 6,
					type = "description",
					name = L["Demon Hunter"],
					fontSize = "large"
				},
				demonhuntercolor1 = {
					order = 7,
					type = "color",
					name = L["Color 1"],
					disabled = function() return not E.db.mui.gradient.enable or
						not E.db.mui.gradient.customColor.enableClass end,
					get = function()
						local dr = E.db.mui.gradient.customColor.demonhuntercolorR1
						local dg = E.db.mui.gradient.customColor.demonhuntercolorG1
						local db = E.db.mui.gradient.customColor.demonhuntercolorB1
						local tr = P.gradient.customColor.demonhuntercolorR1
						local tg = P.gradient.customColor.demonhuntercolorG1
						local tb = P.gradient.customColor.demonhuntercolorB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.demonhuntercolorR1, E.db.mui.gradient.customColor.demonhuntercolorG1, E.db.mui.gradient.customColor.demonhuntercolorB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				demonhuntercolor2 = {
					order = 8,
					type = "color",
					name = L["Color 2"],
					disabled = function() return not E.db.mui.gradient.enable or
						not E.db.mui.gradient.customColor.enableClass end,
					get = function()
						local dr = E.db.mui.gradient.customColor.demonhuntercolorR2
						local dg = E.db.mui.gradient.customColor.demonhuntercolorG2
						local db = E.db.mui.gradient.customColor.demonhuntercolorB2
						local tr = P.gradient.customColor.demonhuntercolorR2
						local tg = P.gradient.customColor.demonhuntercolorG2
						local tb = P.gradient.customColor.demonhuntercolorB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.demonhuntercolorR2, E.db.mui.gradient.customColor.demonhuntercolorG2, E.db.mui.gradient.customColor.demonhuntercolorB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description3 = {
					order = 9,
					type = "description",
					name = L["Druid"],
					fontSize = "large"
				},
				druidcolor1 = {
					order = 10,
					type = "color",
					name = L["Color 1"],
					disabled = function() return not E.db.mui.gradient.enable or
						not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.druidcolorR1
						local dg = E.db.mui.gradient.customColor.druidcolorG1
						local db = E.db.mui.gradient.customColor.druidcolorB1
						local tr = P.gradient.customColor.druidcolorR1
						local tg = P.gradient.customColor.druidcolorG1
						local tb = P.gradient.customColor.druidcolorB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.druidcolorR1, E.db.mui.gradient.customColor.druidcolorG1, E.db.mui.gradient.customColor.druidcolorB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				druidcolor2 = {
					order = 11,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.druidcolorR2
						local dg = E.db.mui.gradient.customColor.druidcolorG2
						local db = E.db.mui.gradient.customColor.druidcolorB2
						local tr = P.gradient.customColor.druidcolorR2
						local tg = P.gradient.customColor.druidcolorG2
						local tb = P.gradient.customColor.druidcolorB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.druidcolorR2, E.db.mui.gradient.customColor.druidcolorG2, E.db.mui.gradient.customColor.druidcolorB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description4 = {
					order = 12,
					type = "description",
					name = L["Evoker"],
					fontSize = "large"
				},
				evokercolor1 = {
					order = 13,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.evokercolorR1
						local dg = E.db.mui.gradient.customColor.evokercolorG1
						local db = E.db.mui.gradient.customColor.evokercolorB1
						local tr = P.gradient.customColor.evokercolorR1
						local tg = P.gradient.customColor.evokercolorG1
						local tb = P.gradient.customColor.evokercolorB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.evokercolorR1, E.db.mui.gradient.customColor.evokercolorG1, E.db.mui.gradient.customColor.evokercolorB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				evokercolor2 = {
					order = 14,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.evokercolorR2
						local dg = E.db.mui.gradient.customColor.evokercolorG2
						local db = E.db.mui.gradient.customColor.evokercolorB2
						local tr = P.gradient.customColor.evokercolorR2
						local tg = P.gradient.customColor.evokercolorG2
						local tb = P.gradient.customColor.evokercolorB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.evokercolorR2, E.db.mui.gradient.customColor.evokercolorG2, E.db.mui.gradient.customColor.evokercolorB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description5 = {
					order = 15,
					type = "description",
					name = L["Hunter"],
					fontSize = "large"
				},
				huntercolor1 = {
					order = 16,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.huntercolorR1
						local dg = E.db.mui.gradient.customColor.huntercolorG1
						local db = E.db.mui.gradient.customColor.huntercolorB1
						local tr = P.gradient.customColor.huntercolorR1
						local tg = P.gradient.customColor.huntercolorG1
						local tb = P.gradient.customColor.huntercolorB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.huntercolorR1, E.db.mui.gradient.customColor.huntercolorG1, E.db.mui.gradient.customColor.huntercolorB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				huntercolor2 = {
					order = 17,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.huntercolorR2
						local dg = E.db.mui.gradient.customColor.huntercolorG2
						local db = E.db.mui.gradient.customColor.huntercolorB2
						local tr = P.gradient.customColor.huntercolorR2
						local tg = P.gradient.customColor.huntercolorG2
						local tb = P.gradient.customColor.huntercolorB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.huntercolorR2, E.db.mui.gradient.customColor.huntercolorG2, E.db.mui.gradient.customColor.huntercolorB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description6 = {
					order = 18,
					type = "description",
					name = L["Mage"],
					fontSize = "large"
				},
				magecolor1 = {
					order = 19,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.magecolorR1
						local dg = E.db.mui.gradient.customColor.magecolorG1
						local db = E.db.mui.gradient.customColor.magecolorB1
						local tr = P.gradient.customColor.magecolorR1
						local tg = P.gradient.customColor.magecolorG1
						local tb = P.gradient.customColor.magecolorB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.magecolorR1, E.db.mui.gradient.customColor.magecolorG1, E.db.mui.gradient.customColor.magecolorB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				magecolor2 = {
					order = 20,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.magecolorR2
						local dg = E.db.mui.gradient.customColor.magecolorG2
						local db = E.db.mui.gradient.customColor.magecolorB2
						local tr = P.gradient.customColor.magecolorR2
						local tg = P.gradient.customColor.magecolorG2
						local tb = P.gradient.customColor.magecolorB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.magecolorR2, E.db.mui.gradient.customColor.magecolorG2, E.db.mui.gradient.customColor.magecolorB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description7 = {
					order = 21,
					type = "description",
					name = L["Monk"],
					fontSize = "large"
				},
				monkcolor1 = {
					order = 22,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.monkcolorR1
						local dg = E.db.mui.gradient.customColor.monkcolorG1
						local db = E.db.mui.gradient.customColor.monkcolorB1
						local tr = P.gradient.customColor.monkcolorR1
						local tg = P.gradient.customColor.monkcolorG1
						local tb = P.gradient.customColor.monkcolorB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.monkcolorR1, E.db.mui.gradient.customColor.monkcolorG1, E.db.mui.gradient.customColor.monkcolorB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				monkcolor2 = {
					order = 23,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.monkcolorR2
						local dg = E.db.mui.gradient.customColor.monkcolorG2
						local db = E.db.mui.gradient.customColor.monkcolorB2
						local tr = P.gradient.customColor.monkcolorR2
						local tg = P.gradient.customColor.monkcolorG2
						local tb = P.gradient.customColor.monkcolorB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.monkcolorR2, E.db.mui.gradient.customColor.monkcolorG2, E.db.mui.gradient.customColor.monkcolorB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description8 = {
					order = 24,
					type = "description",
					name = L["Paladin"],
					fontSize = "large"
				},
				paladincolor1 = {
					order = 25,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.paladincolorR1
						local dg = E.db.mui.gradient.customColor.paladincolorG1
						local db = E.db.mui.gradient.customColor.paladincolorB1
						local tr = P.gradient.customColor.paladincolorR1
						local tg = P.gradient.customColor.paladincolorG1
						local tb = P.gradient.customColor.paladincolorB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.paladincolorR1, E.db.mui.gradient.customColor.paladincolorG1, E.db.mui.gradient.customColor.paladincolorB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				paladincolor2 = {
					order = 26,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.paladincolorR2
						local dg = E.db.mui.gradient.customColor.paladincolorG2
						local db = E.db.mui.gradient.customColor.paladincolorB2
						local tr = P.gradient.customColor.paladincolorR2
						local tg = P.gradient.customColor.paladincolorG2
						local tb = P.gradient.customColor.paladincolorB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.paladincolorR2, E.db.mui.gradient.customColor.paladincolorG2, E.db.mui.gradient.customColor.paladincolorB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description9 = {
					order = 27,
					type = "description",
					name = L["Priest"],
					fontSize = "large"
				},
				priestcolor1 = {
					order = 28,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.priestcolorR1
						local dg = E.db.mui.gradient.customColor.priestcolorG1
						local db = E.db.mui.gradient.customColor.priestcolorB1
						local tr = P.gradient.customColor.priestcolorR1
						local tg = P.gradient.customColor.priestcolorG1
						local tb = P.gradient.customColor.priestcolorB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.priestcolorR1, E.db.mui.gradient.customColor.priestcolorG1, E.db.mui.gradient.customColor.priestcolorB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				priestcolor2 = {
					order = 29,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.priestcolorR2
						local dg = E.db.mui.gradient.customColor.priestcolorG2
						local db = E.db.mui.gradient.customColor.priestcolorB2
						local tr = P.gradient.customColor.priestcolorR2
						local tg = P.gradient.customColor.priestcolorG2
						local tb = P.gradient.customColor.priestcolorB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.priestcolorR2, E.db.mui.gradient.customColor.priestcolorG2, E.db.mui.gradient.customColor.priestcolorB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description10 = {
					order = 30,
					type = "description",
					name = L["Rogue"],
					fontSize = "large"
				},
				roguecolor1 = {
					order = 31,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.roguecolorR1
						local dg = E.db.mui.gradient.customColor.roguecolorG1
						local db = E.db.mui.gradient.customColor.roguecolorB1
						local tr = P.gradient.customColor.roguecolorR1
						local tg = P.gradient.customColor.roguecolorG1
						local tb = P.gradient.customColor.roguecolorB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.roguecolorR1, E.db.mui.gradient.customColor.roguecolorG1, E.db.mui.gradient.customColor.roguecolorB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				roguecolor2 = {
					order = 32,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.roguecolorR2
						local dg = E.db.mui.gradient.customColor.roguecolorG2
						local db = E.db.mui.gradient.customColor.roguecolorB2
						local tr = P.gradient.customColor.roguecolorR2
						local tg = P.gradient.customColor.roguecolorG2
						local tb = P.gradient.customColor.roguecolorB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.roguecolorR2, E.db.mui.gradient.customColor.roguecolorG2, E.db.mui.gradient.customColor.roguecolorB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description11 = {
					order = 33,
					type = "description",
					name = L["Shaman"],
					fontSize = "large"
				},
				shamancolor1 = {
					order = 34,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.shamancolorR1
						local dg = E.db.mui.gradient.customColor.shamancolorG1
						local db = E.db.mui.gradient.customColor.shamancolorB1
						local tr = P.gradient.customColor.shamancolorR1
						local tg = P.gradient.customColor.shamancolorG1
						local tb = P.gradient.customColor.shamancolorB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.shamancolorR1, E.db.mui.gradient.customColor.shamancolorG1, E.db.mui.gradient.customColor.shamancolorB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				shamancolor2 = {
					order = 35,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.shamancolorR2
						local dg = E.db.mui.gradient.customColor.shamancolorG2
						local db = E.db.mui.gradient.customColor.shamancolorB2
						local tr = P.gradient.customColor.shamancolorR2
						local tg = P.gradient.customColor.shamancolorG2
						local tb = P.gradient.customColor.shamancolorB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.shamancolorR2, E.db.mui.gradient.customColor.shamancolorG2, E.db.mui.gradient.customColor.shamancolorB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description12 = {
					order = 36,
					type = "description",
					name = L["Warlock"],
					fontSize = "large"
				},
				warlockcolor1 = {
					order = 37,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.warlockcolorR1
						local dg = E.db.mui.gradient.customColor.warlockcolorG1
						local db = E.db.mui.gradient.customColor.warlockcolorB1
						local tr = P.gradient.customColor.warlockcolorR1
						local tg = P.gradient.customColor.warlockcolorG1
						local tb = P.gradient.customColor.warlockcolorB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.warlockcolorR1, E.db.mui.gradient.customColor.warlockcolorG1, E.db.mui.gradient.customColor.warlockcolorB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				warlockcolor2 = {
					order = 38,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.warlockcolorR2
						local dg = E.db.mui.gradient.customColor.warlockcolorG2
						local db = E.db.mui.gradient.customColor.warlockcolorB2
						local tr = P.gradient.customColor.warlockcolorR2
						local tg = P.gradient.customColor.warlockcolorG2
						local tb = P.gradient.customColor.warlockcolorB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.warlockcolorR2, E.db.mui.gradient.customColor.warlockcolorG2, E.db.mui.gradient.customColor.warlockcolorB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description13 = {
					order = 39,
					type = "description",
					name = L["Warrior"],
					fontSize = "large"
				},
				warriorcolor1 = {
					order = 40,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.warriorcolorR1
						local dg = E.db.mui.gradient.customColor.warriorcolorG1
						local db = E.db.mui.gradient.customColor.warriorcolorB1
						local tr = P.gradient.customColor.warriorcolorR1
						local tg = P.gradient.customColor.warriorcolorG1
						local tb = P.gradient.customColor.warriorcolorB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.warriorcolorR1, E.db.mui.gradient.customColor.warriorcolorG1, E.db.mui.gradient.customColor.warriorcolorB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				warriorcolor2 = {
					order = 41,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.warriorcolorR2
						local dg = E.db.mui.gradient.customColor.warriorcolorG2
						local db = E.db.mui.gradient.customColor.warriorcolorB2
						local tr = P.gradient.customColor.warriorcolorR2
						local tg = P.gradient.customColor.warriorcolorG2
						local tb = P.gradient.customColor.warriorcolorB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.warriorcolorR2, E.db.mui.gradient.customColor.warriorcolorG2, E.db.mui.gradient.customColor.warriorcolorB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				spacer1 = {
					order = 42,
					type = "description",
					name = "",
				},
				spacer2 = {
					order = 43,
					type = "description",
					name = "",
				},
				description14 = {
					order = 44,
					type = "description",
					name = L["Friendly NPC"],
					fontSize = "large"
				},
				npcfriendly1 = {
					order = 45,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.npcfriendlyR1
						local dg = E.db.mui.gradient.customColor.npcfriendlyG1
						local db = E.db.mui.gradient.customColor.npcfriendlyB1
						local tr = P.gradient.customColor.npcfriendlyR1
						local tg = P.gradient.customColor.npcfriendlyG1
						local tb = P.gradient.customColor.npcfriendlyB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.npcfriendlyR1, E.db.mui.gradient.customColor.npcfriendlyG1, E.db.mui.gradient.customColor.npcfriendlyB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				npcfriendly2 = {
					order = 46,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.npcfriendlyR2
						local dg = E.db.mui.gradient.customColor.npcfriendlyG2
						local db = E.db.mui.gradient.customColor.npcfriendlyB2
						local tr = P.gradient.customColor.npcfriendlyR2
						local tg = P.gradient.customColor.npcfriendlyG2
						local tb = P.gradient.customColor.npcfriendlyB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.npcfriendlyR2, E.db.mui.gradient.customColor.npcfriendlyG2, E.db.mui.gradient.customColor.npcfriendlyB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description15 = {
					order = 47,
					type = "description",
					name = L["Neutral NPC"],
					fontSize = "large"
				},
				npcneutral1 = {
					order = 48,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.npcneutralR1
						local dg = E.db.mui.gradient.customColor.npcneutralG1
						local db = E.db.mui.gradient.customColor.npcneutralB1
						local tr = P.gradient.customColor.npcneutralR1
						local tg = P.gradient.customColor.npcneutralG1
						local tb = P.gradient.customColor.npcneutralB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.npcneutralR1, E.db.mui.gradient.customColor.npcneutralG1, E.db.mui.gradient.customColor.npcneutralB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				npcneutral2 = {
					order = 49,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.npcneutralR2
						local dg = E.db.mui.gradient.customColor.npcneutralG2
						local db = E.db.mui.gradient.customColor.npcneutralB2
						local tr = P.gradient.customColor.npcneutralR2
						local tg = P.gradient.customColor.npcneutralG2
						local tb = P.gradient.customColor.npcneutralB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.npcneutralR2, E.db.mui.gradient.customColor.npcneutralG2, E.db.mui.gradient.customColor.npcneutralB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description16 = {
					order = 50,
					type = "description",
					name = L["Unfriendly NPC"],
					fontSize = "large"
				},
				npcunfriendly1 = {
					order = 51,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.npcunfriendlyR1
						local dg = E.db.mui.gradient.customColor.npcunfriendlyG1
						local db = E.db.mui.gradient.customColor.npcunfriendlyB1
						local tr = P.gradient.customColor.npcunfriendlyR1
						local tg = P.gradient.customColor.npcunfriendlyG1
						local tb = P.gradient.customColor.npcunfriendlyB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.npcunfriendlyR1, E.db.mui.gradient.customColor.npcunfriendlyG1, E.db.mui.gradient.customColor.npcunfriendlyB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				npcunfriendly2 = {
					order = 52,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.npcunfriendlyR2
						local dg = E.db.mui.gradient.customColor.npcunfriendlyG2
						local db = E.db.mui.gradient.customColor.npcunfriendlyB2
						local tr = P.gradient.customColor.npcunfriendlyR2
						local tg = P.gradient.customColor.npcunfriendlyG2
						local tb = P.gradient.customColor.npcunfriendlyB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.npcunfriendlyR2, E.db.mui.gradient.customColor.npcunfriendlyG2, E.db.mui.gradient.customColor.npcunfriendlyB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description17 = {
					order = 53,
					type = "description",
					name = L["Hostile NPC"],
					fontSize = "large"
				},
				npchostile1 = {
					order = 54,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.npchostileR1
						local dg = E.db.mui.gradient.customColor.npchostileG1
						local db = E.db.mui.gradient.customColor.npchostileB1
						local tr = P.gradient.customColor.npchostileR1
						local tg = P.gradient.customColor.npchostileG1
						local tb = P.gradient.customColor.npchostileB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.npchostileR1, E.db.mui.gradient.customColor.npchostileG1, E.db.mui.gradient.customColor.npchostileB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				npchostile2 = {
					order = 55,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.npchostileR2
						local dg = E.db.mui.gradient.customColor.npchostileG2
						local db = E.db.mui.gradient.customColor.npchostileB2
						local tr = P.gradient.customColor.npchostileR2
						local tg = P.gradient.customColor.npchostileG2
						local tb = P.gradient.customColor.npchostileB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.npchostileR2, E.db.mui.gradient.customColor.npchostileG2, E.db.mui.gradient.customColor.npchostileB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description18 = {
					order = 56,
					type = "description",
					name = L["Tapped NPC"],
					fontSize = "large"
				},
				tapped1 = {
					order = 57,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.tappedR1
						local dg = E.db.mui.gradient.customColor.tappedG1
						local db = E.db.mui.gradient.customColor.tappedB1
						local tr = P.gradient.customColor.tappedR1
						local tg = P.gradient.customColor.tappedG1
						local tb = P.gradient.customColor.tappedB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.tappedR1, E.db.mui.gradient.customColor.tappedG1, E.db.mui.gradient.customColor.tappedB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				tapped2 = {
					order = 58,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableClass
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.tappedR2
						local dg = E.db.mui.gradient.customColor.tappedG2
						local db = E.db.mui.gradient.customColor.tappedB2
						local tr = P.gradient.customColor.tappedR2
						local tg = P.gradient.customColor.tappedG2
						local tb = P.gradient.customColor.tappedB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.tappedR2, E.db.mui.gradient.customColor.tappedG2, E.db.mui.gradient.customColor.tappedB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
			},
		},
		nameplateColors = {
			order = 2,
			type = "group",
			name = L["Custom Nameplates Colors"],
			disabled = function() return not E.db.mui.gradient.enable or not E.db.nameplates.threat.enable end,
			get = function(info)
				return E.db.mui.gradient.customColor[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.gradient.customColor[info[#info]] = value; F:GradientColorUpdate()
			end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = F.cOption(L["Custom Nameplates Colors"], 'orange'),
				},
				enableNP = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Only used if using threat plates from ElvUI"],
					width = "full",
				},
				goodthreat1 = {
					order = 3,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableNP
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.goodthreatR1
						local dg = E.db.mui.gradient.customColor.goodthreatG1
						local db = E.db.mui.gradient.customColor.goodthreatB1
						local tr = P.gradient.customColor.goodthreatR1
						local tg = P.gradient.customColor.goodthreatG1
						local tb = P.gradient.customColor.goodthreatB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.goodthreatR1, E.db.mui.gradient.customColor.goodthreatG1, E.db.mui.gradient.customColor.goodthreatB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				goodthreat2 = {
					order = 4,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableNP
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.goodthreatR2
						local dg = E.db.mui.gradient.customColor.goodthreatG2
						local db = E.db.mui.gradient.customColor.goodthreatB2
						local tr = P.gradient.customColor.goodthreatR2
						local tg = P.gradient.customColor.goodthreatG2
						local tb = P.gradient.customColor.goodthreatB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.goodthreatR2, E.db.mui.gradient.customColor.goodthreatG2, E.db.mui.gradient.customColor.goodthreatB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description1 = {
					order = 5,
					type = "description",
					name = L["Bad Threat"],
					fontSize = "large"
				},
				badthreat1 = {
					order = 6,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableNP
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.badthreatR1
						local dg = E.db.mui.gradient.customColor.badthreatG1
						local db = E.db.mui.gradient.customColor.badthreatB1
						local tr = P.gradient.customColor.badthreatR1
						local tg = P.gradient.customColor.badthreatG1
						local tb = P.gradient.customColor.badthreatB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.badthreatR1, E.db.mui.gradient.customColor.badthreatG1, E.db.mui.gradient.customColor.badthreatB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				badthreat2 = {
					order = 6,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableNP
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.badthreatR2
						local dg = E.db.mui.gradient.customColor.badthreatG2
						local db = E.db.mui.gradient.customColor.badthreatB2
						local tr = P.gradient.customColor.badthreatR2
						local tg = P.gradient.customColor.badthreatG2
						local tb = P.gradient.customColor.badthreatB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.badthreatR2, E.db.mui.gradient.customColor.badthreatG2, E.db.mui.gradient.customColor.badthreatB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description2 = {
					order = 7,
					type = "description",
					name = L["Good Threat Transition"],
					fontSize = "large"
				},
				goodthreattransition1 = {
					order = 8,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableNP
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.goodthreattransitionR1
						local dg = E.db.mui.gradient.customColor.goodthreattransitionG1
						local db = E.db.mui.gradient.customColor.goodthreattransitionB1
						local tr = P.gradient.customColor.goodthreattransitionR1
						local tg = P.gradient.customColor.goodthreattransitionG1
						local tb = P.gradient.customColor.goodthreattransitionB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.goodthreattransitionR1, E.db.mui.gradient.customColor.goodthreattransitionG1, E.db.mui.gradient.customColor.goodthreattransitionB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				goodthreattransition2 = {
					order = 9,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableNP
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.goodthreattransitionR2
						local dg = E.db.mui.gradient.customColor.goodthreattransitionG2
						local db = E.db.mui.gradient.customColor.goodthreattransitionB2
						local tr = P.gradient.customColor.goodthreattransitionR2
						local tg = P.gradient.customColor.goodthreattransitionG2
						local tb = P.gradient.customColor.goodthreattransitionB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.goodthreattransitionR2, E.db.mui.gradient.customColor.goodthreattransitionG2, E.db.mui.gradient.customColor.goodthreattransitionB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description3 = {
					order = 10,
					type = "description",
					name = L["Bad Threat Transition"],
					fontSize = "large"
				},
				badthreattransition1 = {
					order = 11,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableNP
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.badthreattransitionR1
						local dg = E.db.mui.gradient.customColor.badthreattransitionG1
						local db = E.db.mui.gradient.customColor.badthreattransitionB1
						local tr = P.gradient.customColor.badthreattransitionR1
						local tg = P.gradient.customColor.badthreattransitionG1
						local tb = P.gradient.customColor.badthreattransitionB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.badthreattransitionR1, E.db.mui.gradient.customColor.badthreattransitionG1, E.db.mui.gradient.customColor.badthreattransitionB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				badthreattransition2 = {
					order = 12,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableNP
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.badthreattransitionR2
						local dg = E.db.mui.gradient.customColor.badthreattransitionG2
						local db = E.db.mui.gradient.customColor.badthreattransitionB2
						local tr = P.gradient.customColor.badthreattransitionR2
						local tg = P.gradient.customColor.badthreattransitionG2
						local tb = P.gradient.customColor.badthreattransitionB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.badthreattransitionR2, E.db.mui.gradient.customColor.badthreattransitionG2, E.db.mui.gradient.customColor.badthreattransitionB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description4 = {
					order = 13,
					type = "description",
					name = L["Off Tank"],
					fontSize = "large"
				},
				offtank1 = {
					order = 14,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableNP
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.offtankR1
						local dg = E.db.mui.gradient.customColor.offtankG1
						local db = E.db.mui.gradient.customColor.offtankB1
						local tr = P.gradient.customColor.offtankR1
						local tg = P.gradient.customColor.offtankG1
						local tb = P.gradient.customColor.offtankB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.offtankR1, E.db.mui.gradient.customColor.offtankG1, E.db.mui.gradient.customColor.offtankB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				offtank2 = {
					order = 15,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableNP
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.offtankR2
						local dg = E.db.mui.gradient.customColor.offtankG2
						local db = E.db.mui.gradient.customColor.offtankB2
						local tr = P.gradient.customColor.offtankR2
						local tg = P.gradient.customColor.offtankG2
						local tb = P.gradient.customColor.offtankB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.offtankR2, E.db.mui.gradient.customColor.offtankG2, E.db.mui.gradient.customColor.offtankB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description5 = {
					order = 16,
					type = "description",
					name = L["Off Tank Bad Threat Transition"],
					fontSize = "large"
				},
				badthreattransitionofftank1 = {
					order = 17,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableNP
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.badthreattransitionofftankR1
						local dg = E.db.mui.gradient.customColor.badthreattransitionofftankG1
						local db = E.db.mui.gradient.customColor.badthreattransitionofftankB1
						local tr = P.gradient.customColor.badthreattransitionofftankR1
						local tg = P.gradient.customColor.badthreattransitionofftankG1
						local tb = P.gradient.customColor.badthreattransitionofftankB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.badthreattransitionofftankR1, E.db.mui.gradient.customColor.badthreattransitionofftankG1, E.db.mui.gradient.customColor.badthreattransitionofftankB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				badthreattransitionofftank2 = {
					order = 18,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableNP
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.badthreattransitionofftankR2
						local dg = E.db.mui.gradient.customColor.badthreattransitionofftankG2
						local db = E.db.mui.gradient.customColor.badthreattransitionofftankB2
						local tr = P.gradient.customColor.badthreattransitionofftankR2
						local tg = P.gradient.customColor.badthreattransitionofftankG2
						local tb = P.gradient.customColor.badthreattransitionofftankB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.badthreattransitionofftankR2, E.db.mui.gradient.customColor.badthreattransitionofftankG2, E.db.mui.gradient.customColor.badthreattransitionofftankB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description6 = {
					order = 19,
					type = "description",
					name = L["Off Tank Good Threat Transition"],
					fontSize = "large"
				},
				goodthreattransitionofftank1 = {
					order = 20,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableNP
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.goodthreattransitionofftankR1
						local dg = E.db.mui.gradient.customColor.goodthreattransitionofftankG1
						local db = E.db.mui.gradient.customColor.goodthreattransitionofftankB1
						local tr = P.gradient.customColor.goodthreattransitionofftankR1
						local tg = P.gradient.customColor.goodthreattransitionofftankG1
						local tb = P.gradient.customColor.goodthreattransitionofftankB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.goodthreattransitionofftankR1, E.db.mui.gradient.customColor.goodthreattransitionofftankG1, E.db.mui.gradient.customColor.goodthreattransitionofftankB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				goodthreattransitionofftank2 = {
					order = 22,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enableNP
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.goodthreattransitionofftankR2
						local dg = E.db.mui.gradient.customColor.goodthreattransitionofftankG2
						local db = E.db.mui.gradient.customColor.goodthreattransitionofftankB2
						local tr = P.gradient.customColor.goodthreattransitionofftankR2
						local tg = P.gradient.customColor.goodthreattransitionofftankG2
						local tb = P.gradient.customColor.goodthreattransitionofftankB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.goodthreattransitionofftankR2, E.db.mui.gradient.customColor.goodthreattransitionofftankG2, E.db.mui.gradient.customColor.goodthreattransitionofftankB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
			},
		},
		powerColors = {
			order = 2,
			type = "group",
			name = L["Custom Power Colors"],
			disabled = function() return not E.db.mui.gradient.enable end,
			get = function(info)
				return E.db.mui.gradient.customColor[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.gradient.customColor[info[#info]] = value; F:GradientColorUpdate()
			end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = F.cOption(L["Custom Power Colors"], 'orange'),
				},
				enablePower = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					width = "full",
				},
				description = {
					order = 2,
					type = "description",
					name = _G.MANA,
					fontSize = "large"
				},
				mana1 = {
					order = 3,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.manaR1
						local dg = E.db.mui.gradient.customColor.manaG1
						local db = E.db.mui.gradient.customColor.manaB1
						local tr = P.gradient.customColor.manaR1
						local tg = P.gradient.customColor.manaG1
						local tb = P.gradient.customColor.manaB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.manaR1, E.db.mui.gradient.customColor.manaG1, E.db.mui.gradient.customColor.manaB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				mana2 = {
					order = 4,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.manaR2
						local dg = E.db.mui.gradient.customColor.manaG2
						local db = E.db.mui.gradient.customColor.manaB2
						local tr = P.gradient.customColor.manaR2
						local tg = P.gradient.customColor.manaG2
						local tb = P.gradient.customColor.manaB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.manaR2, E.db.mui.gradient.customColor.manaG2, E.db.mui.gradient.customColor.manaB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description1 = {
					order = 5,
					type = "description",
					name = _G.RAGE,
					fontSize = "large"
				},
				rage1 = {
					order = 6,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.rageR1
						local dg = E.db.mui.gradient.customColor.rageG1
						local db = E.db.mui.gradient.customColor.rageB1
						local tr = P.gradient.customColor.rageR1
						local tg = P.gradient.customColor.rageG1
						local tb = P.gradient.customColor.rageB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.rageR1, E.db.mui.gradient.customColor.rageG1, E.db.mui.gradient.customColor.rageB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				rage2 = {
					order = 7,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.rageR2
						local dg = E.db.mui.gradient.customColor.rageG2
						local db = E.db.mui.gradient.customColor.rageB2
						local tr = P.gradient.customColor.rageR2
						local tg = P.gradient.customColor.rageG2
						local tb = P.gradient.customColor.rageB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.rageR2, E.db.mui.gradient.customColor.rageG2, E.db.mui.gradient.customColor.rageB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description2 = {
					order = 8,
					type = "description",
					name = _G.POWER_TYPE_FOCUS,
					fontSize = "large"
				},
				focus1 = {
					order = 9,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.focusR1
						local dg = E.db.mui.gradient.customColor.focusG1
						local db = E.db.mui.gradient.customColor.focusB1
						local tr = P.gradient.customColor.focusR1
						local tg = P.gradient.customColor.focusG1
						local tb = P.gradient.customColor.focusB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.focusR1, E.db.mui.gradient.customColor.focusG1, E.db.mui.gradient.customColor.focusB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				focus2 = {
					order = 10,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.focusR2
						local dg = E.db.mui.gradient.customColor.focusG2
						local db = E.db.mui.gradient.customColor.focusB2
						local tr = P.gradient.customColor.focusR2
						local tg = P.gradient.customColor.focusG2
						local tb = P.gradient.customColor.focusB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.focusR2, E.db.mui.gradient.customColor.focusG2, E.db.mui.gradient.customColor.focusB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description3 = {
					order = 11,
					type = "description",
					name = _G.ENERGY,
					fontSize = "large"
				},
				energy1 = {
					order = 12,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.energyR1
						local dg = E.db.mui.gradient.customColor.energyG1
						local db = E.db.mui.gradient.customColor.energyB1
						local tr = P.gradient.customColor.energyR1
						local tg = P.gradient.customColor.energyG1
						local tb = P.gradient.customColor.energyB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.energyR1, E.db.mui.gradient.customColor.energyG1, E.db.mui.gradient.customColor.energyB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				energy2 = {
					order = 13,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.energyR2
						local dg = E.db.mui.gradient.customColor.energyG2
						local db = E.db.mui.gradient.customColor.energyB2
						local tr = P.gradient.customColor.energyR2
						local tg = P.gradient.customColor.energyG2
						local tb = P.gradient.customColor.energyB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.energyR2, E.db.mui.gradient.customColor.energyG2, E.db.mui.gradient.customColor.energyB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description4 = {
					order = 14,
					type = "description",
					name = function()
						if not E.Classic then
							return _G.RUNIC_POWER
						else
							return "Runic Power"
						end
					end,
					fontSize = "large"
				},
				runicpower1 = {
					order = 15,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.runicpowerR1
						local dg = E.db.mui.gradient.customColor.runicpowerG1
						local db = E.db.mui.gradient.customColor.runicpowerB1
						local tr = P.gradient.customColor.runicpowerR1
						local tg = P.gradient.customColor.runicpowerG1
						local tb = P.gradient.customColor.runicpowerB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.runicpowerR1, E.db.mui.gradient.customColor.runicpowerG1, E.db.mui.gradient.customColor.runicpowerB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				runicpower2 = {
					order = 16,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.runicpowerR2
						local dg = E.db.mui.gradient.customColor.runicpowerG2
						local db = E.db.mui.gradient.customColor.runicpowerB2
						local tr = P.gradient.customColor.runicpowerR2
						local tg = P.gradient.customColor.runicpowerG2
						local tb = P.gradient.customColor.runicpowerB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.runicpowerR2, E.db.mui.gradient.customColor.runicpowerG2, E.db.mui.gradient.customColor.runicpowerB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description5 = {
					order = 17,
					type = "description",
					name = _G.POWER_TYPE_LUNAR_POWER,
					fontSize = "large"
				},
				lunarpower1 = {
					order = 18,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.lunarpowerR1
						local dg = E.db.mui.gradient.customColor.lunarpowerG1
						local db = E.db.mui.gradient.customColor.lunarpowerB1
						local tr = P.gradient.customColor.lunarpowerR1
						local tg = P.gradient.customColor.lunarpowerG1
						local tb = P.gradient.customColor.lunarpowerB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.lunarpowerR1, E.db.mui.gradient.customColor.lunarpowerG1, E.db.mui.gradient.customColor.lunarpowerB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				lunarpower2 = {
					order = 19,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.lunarpowerR2
						local dg = E.db.mui.gradient.customColor.lunarpowerG2
						local db = E.db.mui.gradient.customColor.lunarpowerB2
						local tr = P.gradient.customColor.lunarpowerR2
						local tg = P.gradient.customColor.lunarpowerG2
						local tb = P.gradient.customColor.lunarpowerB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.lunarpowerR2, E.db.mui.gradient.customColor.lunarpowerG2, E.db.mui.gradient.customColor.lunarpowerB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description6 = {
					order = 20,
					type = "description",
					name = _G.ALTERNATE_RESOURCE_TEXT,
					fontSize = "large"
				},
				altpower1 = {
					order = 21,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.altpowerR1
						local dg = E.db.mui.gradient.customColor.altpowerG1
						local db = E.db.mui.gradient.customColor.altpowerB1
						local tr = P.gradient.customColor.altpowerR1
						local tg = P.gradient.customColor.altpowerG1
						local tb = P.gradient.customColor.altpowerB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.altpowerR1, E.db.mui.gradient.customColor.altpowerG1, E.db.mui.gradient.customColor.altpowerB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				altpower2 = {
					order = 22,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.altpowerR2
						local dg = E.db.mui.gradient.customColor.altpowerG2
						local db = E.db.mui.gradient.customColor.altpowerB2
						local tr = P.gradient.customColor.altpowerR2
						local tg = P.gradient.customColor.altpowerG2
						local tb = P.gradient.customColor.altpowerB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.altpowerR2, E.db.mui.gradient.customColor.altpowerG2, E.db.mui.gradient.customColor.altpowerB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description7 = {
					order = 23,
					type = "description",
					name = _G.POWER_TYPE_MAELSTROM,
					fontSize = "large"
				},
				maelstrom1 = {
					order = 24,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.maelstromR1
						local dg = E.db.mui.gradient.customColor.maelstromG1
						local db = E.db.mui.gradient.customColor.maelstromB1
						local tr = P.gradient.customColor.maelstromR1
						local tg = P.gradient.customColor.maelstromG1
						local tb = P.gradient.customColor.maelstromB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.maelstromR1, E.db.mui.gradient.customColor.maelstromG1, E.db.mui.gradient.customColor.maelstromB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				maelstrom2 = {
					order = 25,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.maelstromR2
						local dg = E.db.mui.gradient.customColor.maelstromG2
						local db = E.db.mui.gradient.customColor.maelstromB2
						local tr = P.gradient.customColor.maelstromR2
						local tg = P.gradient.customColor.maelstromG2
						local tb = P.gradient.customColor.maelstromB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.maelstromR2, E.db.mui.gradient.customColor.maelstromG2, E.db.mui.gradient.customColor.maelstromB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description8 = {
					order = 26,
					type = "description",
					name = _G.INSANITY_POWER,
					fontSize = "large"
				},
				insanity1 = {
					order = 27,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.insanityR1
						local dg = E.db.mui.gradient.customColor.insanityG1
						local db = E.db.mui.gradient.customColor.insanityB1
						local tr = P.gradient.customColor.insanityR1
						local tg = P.gradient.customColor.insanityG1
						local tb = P.gradient.customColor.insanityB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.insanityR1, E.db.mui.gradient.customColor.insanityG1, E.db.mui.gradient.customColor.insanityB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				insanity2 = {
					order = 28,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.insanityR2
						local dg = E.db.mui.gradient.customColor.insanityG2
						local db = E.db.mui.gradient.customColor.insanityB2
						local tr = P.gradient.customColor.insanityR2
						local tg = P.gradient.customColor.insanityG2
						local tb = P.gradient.customColor.insanityB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.insanityR2, E.db.mui.gradient.customColor.insanityG2, E.db.mui.gradient.customColor.insanityB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				description9 = {
					order = 29,
					type = "description",
					name = _G.POWER_TYPE_FURY,
					fontSize = "large"
				},
				fury1 = {
					order = 30,
					type = "color",
					name = L["Color 1"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.furyR1
						local dg = E.db.mui.gradient.customColor.furyG1
						local db = E.db.mui.gradient.customColor.furyB1
						local tr = P.gradient.customColor.furyR1
						local tg = P.gradient.customColor.furyG1
						local tb = P.gradient.customColor.furyB1
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.furyR1, E.db.mui.gradient.customColor.furyG1, E.db.mui.gradient.customColor.furyB1 =
							r, g, b; F:GradientColorUpdate()
					end
				},
				fury2 = {
					order = 31,
					type = "color",
					name = L["Color 2"],
					disabled = function()
						return not E.db.mui.gradient.enable or not E.db.mui.gradient.customColor.enablePower
					end,
					get = function()
						local dr = E.db.mui.gradient.customColor.furyR2
						local dg = E.db.mui.gradient.customColor.furyG2
						local db = E.db.mui.gradient.customColor.furyB2
						local tr = P.gradient.customColor.furyR2
						local tg = P.gradient.customColor.furyG2
						local tb = P.gradient.customColor.furyB2
						return dr, dg, db, 1, tr, tg, tb, 1
					end,
					set = function(_, r, g, b, a)
						E.db.mui.gradient.customColor.furyR2, E.db.mui.gradient.customColor.furyG2, E.db.mui.gradient.customColor.furyB2 =
							r, g, b; F:GradientColorUpdate()
					end
				},
			},
		},
	},
}
