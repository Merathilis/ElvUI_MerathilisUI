local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

function MER:LoadMasqueProfile()
	local classColor = E.myclass == "PRIEST" and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
	--[[----------------------------------
	--	Masque - Settings
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
								classColor.r, -- [1]
								classColor.g, -- [2]
								classColor.b, -- [3]
								1, -- [4]
							},
						},
						["SkinID"] = "MerathilisUI",
						["Gloss"] = 0.6,
					},
					["ElvUI_Buffs"] = {
						["Colors"] = {
							["Normal"] = {
								classColor.r, -- [1]
								classColor.g, -- [2]
								classColor.b, -- [3]
								1, -- [4]
							},
						},
						["SkinID"] = "MerathilisUI",
						["Gloss"] = 0.6,
					},
					["ElvUI_Debuffs"] = {
						["Colors"] = {
							["Normal"] = {
								classColor.r, -- [1]
								classColor.g, -- [2]
								classColor.b, -- [3]
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
								classColor.r, -- [1]
								classColor.g, -- [2]
								classColor.b, -- [3]
								1, -- [4]
							},
						},
					},
					["ElvUI_Consolidated Buffs"] = {
						["Gloss"] = 0.6,
						["SkinID"] = "MerathilisUI",
						["Colors"] = {
							["Normal"] = {
								classColor.r, -- [1]
								classColor.g, -- [2]
								classColor.b, -- [3]
								1, -- [4]
							},
						},
					},
					["Masque"] = {
						["Gloss"] = 0.6,
						["SkinID"] = "MerathilisUI",
						["Colors"] = {
							["Normal"] = {
								classColor.r, -- [1]
								classColor.g, -- [2]
								classColor.b, -- [3]
								1, -- [4]
							},
						},
					},
					["ElvUI_ActionBars"] = {
						["Gloss"] = 0.6,
						["SkinID"] = "MerathilisUI",
						["Colors"] = {
							["Normal"] = {
								classColor.r, -- [1]
								classColor.g, -- [2]
								classColor.b, -- [3]
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