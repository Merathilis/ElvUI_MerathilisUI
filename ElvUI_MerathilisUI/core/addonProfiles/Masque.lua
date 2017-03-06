local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

function MER:LoadMasqueProfile()
	--[[----------------------------------
	--	Masque - Settings | Note: You have to create a seperate profile for each class to use the class color.
	--]]----------------------------------
	MasqueDB = {
		["namespaces"] = {
			["LibDualSpec-1.0"] = {
			},
		},
		["profiles"] = {
			["MerathilisUI"] = {
				["Groups"] = {
					["ElvUI"] = {
						["Colors"] = {
							["Normal"] = {
								MER.Color.r, -- [1]
								MER.Color.g, -- [2]
								MER.Color.b, -- [3]
								1, -- [4]
							},
						},
						["SkinID"] = "MerathilisUI",
						["Gloss"] = 0.6,
					},
					["ElvUI_Buffs"] = {
						["Colors"] = {
							["Normal"] = {
								MER.Color.r, -- [1]
								MER.Color.g, -- [2]
								MER.Color.b, -- [3]
								1, -- [4]
							},
						},
						["SkinID"] = "MerathilisUI",
						["Gloss"] = 0.6,
					},
					["ElvUI_Debuffs"] = {
						["Colors"] = {
							["Normal"] = {
								MER.Color.r, -- [1]
								MER.Color.g, -- [2]
								MER.Color.b, -- [3]
								1, -- [4]
							},
						},
						["SkinID"] = "MerathilisUI",
						["Gloss"] = 0.6,
					},
					["ElvUI_Pet Bar"] = {
						["Gloss"] = 0.6,
						["SkinID"] = "MerathilisUI",
						["Colors"] = {
							["Normal"] = {
								MER.Color.r, -- [1]
								MER.Color.g, -- [2]
								MER.Color.b, -- [3]
								1, -- [4]
							},
						},
					},
					["ElvUI_Consolidated Buffs"] = {
						["Gloss"] = 0.6,
						["SkinID"] = "MerathilisUI",
						["Colors"] = {
							["Normal"] = {
								MER.Color.r, -- [1]
								MER.Color.g, -- [2]
								MER.Color.b, -- [3]
								1, -- [4]
							},
						},
					},
					["Masque"] = {
						["Gloss"] = 0.6,
						["SkinID"] = "MerathilisUI",
						["Colors"] = {
							["Normal"] = {
								MER.Color.r, -- [1]
								MER.Color.g, -- [2]
								MER.Color.b, -- [3]
								1, -- [4]
							},
						},
					},
					["ElvUI_ActionBars"] = {
						["Gloss"] = 0.6,
						["SkinID"] = "MerathilisUI",
						["Colors"] = {
							["Normal"] = {
								MER.Color.r, -- [1]
								MER.Color.g, -- [2]
								MER.Color.b, -- [3]
								1, -- [4]
							},
						},
					},
				},
			},
		},
	}

	-- Profile creation
	local db = LibStub("AceDB-3.0"):New(MasqueDB, nil, true)
	db:SetProfile("MerathilisUI")
end