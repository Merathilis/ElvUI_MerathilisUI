local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

--Cache global variables
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: SkadaDB, LibStub

function MER:LoadSkadaProfile()
	--[[----------------------------------
	--	Skada - Settings
	--]]----------------------------------
	SkadaDB["profiles"]["MerathilisUI"] = {
		["windows"] = {
			{
				["titleset"] = true,
				["barheight"] = 16,
				["classicons"] = true,
				["roleicons"] = false,
				["barslocked"] = true,
				["background"] = {
					["borderthickness"] = 0,
					["height"] = 146,
					["bordertexture"] = "None",
					["margin"] = 0,
					["texture"] = "Solid",
					["strata"] = "LOW",
					["color"] = {
						["a"] = 0.2,
						["b"] = 0.5,
						["g"] = 0,
						["r"] = 0,
					},
				},
				["y"] = 23.0000915527344,
				["barfont"] = "Merathilis Roboto-Bold",
				["name"] = "DPS",
				["barfontflags"] = "OUTLINE",
				["point"] = "TOPRIGHT",
				["barbgcolor"] = {
					["a"] = 0,
					["r"] = 0.301960784313726,
					["g"] = 0.301960784313726,
					["b"] = 0.301960784313726,
				},
				["mode"] = "Schaden",
				["enabletitle"] = false,
				["spark"] = false,
				["bartexture"] = "Lyn1",
				["barwidth"] = 165.999954223633,
				["barspacing"] = 2,
				["barcolor"] = {
					["a"] = 0,
					["g"] = 0.301960784313726,
					["r"] = 0.301960784313726,
				},
				["barfontsize"] = 10,
				["title"] = {
					["textcolor"] = {
						["b"] = 0.0392156862745098,
						["g"] = 0.490196078431373,
						["r"] = 1,
					},
					["color"] = {
						["a"] = 0,
						["b"] = 0.301960784313726,
						["g"] = 0.101960784313725,
						["r"] = 0.101960784313725,
					},
					["font"] = "Merathilis Tukui",
					["borderthickness"] = 0,
					["fontsize"] = 14,
					["fontflags"] = "OUTLINE",
					["texture"] = "MerathilisFlat",
				},
				["x"] = 1739.00001525879,
			}, -- [1]
		},
		["icon"] = {
			["hide"] = true,
		},
		["columns"] = {
			["Heilung_Percent"] = false,
			["Schaden_Damage"] = true,
			["Schaden_DPS"] = true,
			["Schaden_Percent"] = true,
		},
	}

	-- Profile creation
	local db = LibStub("AceDB-3.0"):New(SkadaDB, nil, true)
	db:SetProfile("MerathilisUI")
end