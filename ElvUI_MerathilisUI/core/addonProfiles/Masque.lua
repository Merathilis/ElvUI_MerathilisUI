local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: MasqueDB, LibStub

local playerName = UnitName("player")
local profileName = playerName.."-mUI"

function MER:LoadMasqueProfile()
	--[[----------------------------------
	--	Masque - Settings | Note: You have to create a seperate profile for each class to use the class color.
	--]]----------------------------------
	MasqueDB.profiles[profileName] = {
		["Groups"] = {
			["ElvUI"] = {
				["Colors"] = {
					["Normal"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
				},
				["SkinID"] = "MerathilisUI",
				["Gloss"] = 0.75,
			},
			["ElvUI_Buffs"] = {
				["Colors"] = {
					["Normal"] = {
						0, -- [1]olor.r, -- [1]
						0, -- [2]olor.g, -- [2]
						0, -- [3]olor.b, -- [3]
						1, -- [4]
					},
				},
				["SkinID"] = "MerathilisUI",
				["Gloss"] = 0.75,
			},
			["ElvUI_Debuffs"] = {
				["Colors"] = {
					["Normal"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
				},
				["SkinID"] = "MerathilisUI",
				["Gloss"] = 0.75,
			},
			["ElvUI_Pet Bar"] = {
				["Gloss"] = 0,
				["SkinID"] = "MerathilisUI",
				["Colors"] = {
					["Normal"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
				},
			},
			["ElvUI_Consolidated Buffs"] = {
				["Gloss"] = 0.75,
				["SkinID"] = "MerathilisUI",
				["Colors"] = {
					["Normal"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
				},
			},
			["Masque"] = {
				["Gloss"] = 0.75,
				["SkinID"] = "MerathilisUI",
				["Colors"] = {
					["Normal"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
				},
			},
			["ElvUI_ActionBars"] = {
				["Gloss"] = 0.75,
				["SkinID"] = "MerathilisUI",
				["Colors"] = {
					["Normal"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
				},
			},
		},
	}

	-- Profile creation
	local db = LibStub("AceDB-3.0"):New(MasqueDB)
	db:SetProfile(profileName)
end
