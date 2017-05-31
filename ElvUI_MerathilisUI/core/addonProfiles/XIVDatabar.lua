local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--WoW API / Variables
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: XIVBarDB, LibStub

function MER:LoadXIVDatabarProfile()
	--[[----------------------------------
	--	XIV_Databar - Settings
	--]]----------------------------------
	XIVBarDB = {
		["profiles"] = {
			["MerathilisUI"] = {
				["modules"] = {
					["tradeskill"] = {
						["barCC"] = true,
					},
					["talent"] = {
						["barCC"] = true,
					},
					["currency"] = {
						["xpBarCC"] = true,
						["currencyTwo"] = "1220",
						["currencyOne"] = "1273",
					},
					["clock"] = {
						["timeFormat"] = "twoFour",
					},
				},
				["text"] = {
					["flags"] = 2,
					["fontSize"] = 10,
					["font"] = "Merathilis Roboto-Bold",
				},
				["general"] = {
					["moduleSpacing"] = 25,
				},
				["color"] = {
					["barColor"] = {
						["a"] = 0,
						["r"] = 0.952941176470588,
						["g"] = 0.968627450980392,
						["b"] = 1,
					},
				},
			},
		},
	}
end