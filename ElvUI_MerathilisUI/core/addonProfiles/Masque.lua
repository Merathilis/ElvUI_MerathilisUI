local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

--Cache global variables
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: MasqueDB, LibStub

local playerName = UnitName("player")
local profileName = playerName.."-mUI"

function MER:LoadMasqueProfile()
	--[[----------------------------------
	--	Masque - Settings 
	--]]----------------------------------
	if (not MasqueDB.profiles[profileName]) then
		MasqueDB.profiles[profileName] = {
			["Groups"] = {
				["ElvUI"] = {
					["Colors"] = {
						["Normal"] = {
							MER.ClassColor.r, -- [1]
							MER.ClassColor.g, -- [2]
							MER.ClassColor.b, -- [3]
							1, -- [4]
						},
					},
					["SkinID"] = "MerathilisUI",
					["Gloss"] = 0.6,
				},
				["ElvUI_Buffs"] = {
					["Colors"] = {
						["Normal"] = {
							MER.ClassColor.r, -- [1]
							MER.ClassColor.g, -- [2]
							MER.ClassColor.b, -- [3]
							1, -- [4]
						},
					},
					["SkinID"] = "MerathilisUI",
					["Gloss"] = 0.6,
				},
				["ElvUI_Debuffs"] = {
					["Colors"] = {
						["Normal"] = {
							MER.ClassColor.r, -- [1]
							MER.ClassColor.g, -- [2]
							MER.ClassColor.b, -- [3]
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
							MER.ClassColor.r, -- [1]
							MER.ClassColor.g, -- [2]
							MER.ClassColor.b, -- [3]
							1, -- [4]
						},
					},
				},
				["ElvUI_Consolidated Buffs"] = {
					["Gloss"] = 0.6,
					["SkinID"] = "MerathilisUI",
					["Colors"] = {
						["Normal"] = {
							MER.ClassColor.r, -- [1]
							MER.ClassColor.g, -- [2]
							MER.ClassColor.b, -- [3]
							1, -- [4]
						},
					},
				},
				["Masque"] = {
					["Gloss"] = 0.6,
					["SkinID"] = "MerathilisUI",
					["Colors"] = {
						["Normal"] = {
							MER.ClassColor.r, -- [1]
							MER.ClassColor.g, -- [2]
							MER.ClassColor.b, -- [3]
							1, -- [4]
						},
					},
				},
				["ElvUI_ActionBars"] = {
					["Gloss"] = 0.6,
					["SkinID"] = "MerathilisUI",
					["Colors"] = {
						["Normal"] = {
							MER.ClassColor.r, -- [1]
							MER.ClassColor.g, -- [2]
							MER.ClassColor.b, -- [3]
							1, -- [4]
						},
					},
				},
			},
		}

		-- Profile creation
		local db = LibStub("AceDB-3.0"):New(MasqueDB, nil, true)
		db:SetProfile(profileName)
	end
end