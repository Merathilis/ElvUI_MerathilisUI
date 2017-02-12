local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

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
					["font"] = "Merathilis Roboto-Medium",
				},
				["general"] = {
					["barPosition"] = "TOP",
				},
			},
		},
	}

	-- Profile creation
	local db = LibStub("AceDB-3.0"):New(XIVBarDB, nil, true)
	db:SetProfile("MerathilisUI")
end