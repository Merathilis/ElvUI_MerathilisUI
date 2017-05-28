local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: SkadaDB, LibStub

function MER:LoadSkadaProfile()
	--[[----------------------------------
	--	Skada - Settings
	--]]----------------------------------
	SkadaDB = {
		["namespaces"] = {
			["LibDualSpec-1.0"] = {
			},
		},
		["profiles"] = {
			["MerathilisUI"] = {
				["modeclicks"] = {
					["DPS"] = 1,
				},
				["windows"] = {
					{
						["barheight"] = 15,
						["barslocked"] = true,
						["y"] = 6.00006103515625,
						["x"] = 1482.00003051758,
						["title"] = {
							["font"] = "Merathilis Tukui",
							["fontsize"] = 14,
							["borderthickness"] = 0,
							["height"] = 18,
							["fontflags"] = "OUTLINE",
							["texture"] = "MerathilisFlat",
						},
						["barfontflags"] = "OUTLINE",
						["point"] = "TOPRIGHT",
						["barfontsize"] = 10,
						["mode"] = "Schaden",
						["spark"] = false,
						["bartexture"] = "MerathilisFlat",
						["barwidth"] = 271.999969482422,
						["barspacing"] = 1,
						["smoothing"] = true,
						["buttons"] = {
							["stop"] = false,
						},
						["barfont"] = "Merathilis Roboto-Black",
						["background"] = {
							["strata"] = "LOW",
							["height"] = 107,
							["bordertexture"] = "None",
							["texture"] = "None",
						},
					}, -- [1]
					["titleset"] = true,
					["barheight"] = 16,
					["barbgcolor"] = {
						["a"] = 0,
						["r"] = 0.301960784313726,
						["g"] = 0.301960784313726,
						["b"] = 0.301960784313726,
					},
					["barcolor"] = {
						["a"] = 0,
						["g"] = 0.301960784313726,
						["r"] = 0.301960784313726,
					},
					["barfontsize"] = 10,
					["classicons"] = true,
					["barslocked"] = true,
					["roleicons"] = false,
					["background"] = {
						["strata"] = "LOW",
						["borderthickness"] = 0,
						["height"] = 146,
						["color"] = {
							["a"] = 0.2,
							["b"] = 0.5,
							["g"] = 0,
							["r"] = 0,
						},
						["bordertexture"] = "None",
						["margin"] = 0,
						["texture"] = "Solid",
					},
					["spark"] = false,
					["bartexture"] = "MerathilisBlank",
					["barwidth"] = 165.999954223633,
					["barspacing"] = 2,
					["point"] = "TOPRIGHT",
					["y"] = 23.0000915527344,
					["barfont"] = "Merathilis Roboto-Bold",
					["name"] = "DPS",
					["title"] = {
						["textcolor"] = {
							["b"] = 0.0392156862745098,
							["g"] = 0.490196078431373,
							["r"] = 1,
						},
						["borderthickness"] = 0,
						["font"] = "Merathilis Tukui",
						["color"] = {
							["a"] = 0,
							["b"] = 0.301960784313726,
							["g"] = 0.101960784313725,
							["r"] = 0.101960784313725,
						},
						["fontsize"] = 14,
						["fontflags"] = "OUTLINE",
						["texture"] = "MerathilisBlank",
					},
					["mode"] = "Schaden",
					["enabletitle"] = false,
					["barfontflags"] = "OUTLINE",
					["x"] = 1739.00001525879,
				},
				["columns"] = {
					["Schaden_Damage"] = true,
					["Schaden_Percent"] = false,
				},
				["versions"] = {
					["1.6.3"] = true,
					["1.6.4"] = true,
					["1.6.7"] = true,
				},
			},
		},
	}

	-- Profile creation
	local db = LibStub("AceDB-3.0"):New(SkadaDB, nil, true)
	db:SetProfile("MerathilisUI")
end