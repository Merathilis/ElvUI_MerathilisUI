local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

--Cache global variables
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: SorhaQuestLogDB, LibStub

function MER:LoadSorhaQuestLogProfile()
	--[[----------------------------------
	--	SorhaQuestLog - Settings
	--]]----------------------------------
	SorhaQuestLogDB = {
		["namespaces"] = {
			["QuestTracker"] = {
				["profiles"] = {
					["MerathilisUI"] = {
						["Colours"] = {
							["StatusBarFillColour"] = {
								["r"] = 1,
								["g"] = 0.490196078431373,
								["b"] = 0.0392156862745098,
							},
							["InfoColour"] = {
								["r"] = 1,
								["g"] = 0.490196078431373,
								["b"] = 0.0392156862745098,
							},
							["HeaderColour"] = {
								["r"] = 1,
								["g"] = 0.490196078431373,
								["b"] = 0.0392156862745098,
							},
						},
						["MinionLocation"] = {
							["Y"] = 122.999961853027,
							["X"] = -135.999313354492,
							["Point"] = "RIGHT",
							["RelativePoint"] = "RIGHT",
						},
						["MinionLocked"] = true,
						["Fonts"] = {
							["HeaderFontLineSpacing"] = 2,
							["QuestFont"] = "Merathilis Roboto-Bold",
							["HeaderFontSize"] = 12,
							["HeaderFont"] = "Merathilis Roboto-Bold",
							["ObjectiveFont"] = "Merathilis Roboto-Bold",
							["ObjectiveFontLineSpacing"] = 5,
							["QuestFontLineSpacing"] = 2,
							["MinionTitleFont"] = "Merathilis Roboto-Bold",
							["MinionTitleFontSize"] = 13,
							["MinionTitleFontLineSpacing"] = 2,
							["MinionTitleFontOutline"] = "OUTLINE",
						},
						["AutoHideTitle"] = true,
						["ShowNumberOfDailyQuests"] = true,
						["ZonesAndQuests"] = {
							["ShowDescWhenNoObjectives"] = true,
						},
					},
				},
			},
			["ScenarioTracker"] = {
				["profiles"] = {
					["MerathilisUI"] = {
						["MinionLocked"] = true,
						["ShowTitle"] = false,
						["Fonts"] = {
							["ScenarioHeaderFontSize"] = 12,
							["ScenarioTaskFont"] = "Merathilis Roboto-Bold",
							["MinionTitleFont"] = "Merathilis Roboto-Bold",
							["MinionTitleFontSize"] = 13,
							["ScenarioObjectiveFont"] = "Merathilis Roboto-Bold",
							["ScenarioHeaderFont"] = "Merathilis Roboto-Bold",
							["MinionTitleFontOutline"] = "OUTLINE",
						},
						["MinionLocation"] = {
							["Y"] = -196.000091552734,
							["X"] = -130.999008178711,
							["Point"] = "TOPRIGHT",
							["RelativePoint"] = "TOPRIGHT",
						},
						["Colours"] = {
							["MinionTitleColour"] = {
								["r"] = 1,
								["g"] = 0.490196078431373,
								["b"] = 0.0392156862745098,
							},
							["StatusBarFillColour"] = {
								["r"] = 1,
								["g"] = 0.490196078431373,
								["b"] = 0.0392156862745098,
							},
							["ScenarioTaskColour"] = {
								["r"] = 1,
								["g"] = 0.490196078431373,
								["b"] = 0.0392156862745098,
							},
						},
					},
				},
			},
			["RemoteQuestsTracker"] = {
				["profiles"] = {
					["MerathilisUI"] = {
						["MinionLocked"] = true,
						["ShowTitle"] = false,
						["Fonts"] = {
							["MinionTitleFontSize"] = 13,
							["MinionTitleFontOutline"] = "OUTLINE",
							["MinionTitleFont"] = "Merathilis Roboto-Bold",
						},
						["MinionLocation"] = {
							["Y"] = 215.000137329102,
							["X"] = -407.999877929688,
							["Point"] = "RIGHT",
							["RelativePoint"] = "RIGHT",
						},
						["Colours"] = {
							["MinionTitleColour"] = {
								["r"] = 1,
								["g"] = 0.490196078431373,
								["b"] = 0.0392156862745098,
							},
						},
					},
				},
			},
			["AchievementTracker"] = {
				["profiles"] = {
					["MerathilisUI"] = {
						["MinionLocked"] = true,
						["ShowTitle"] = false,
						["Fonts"] = {
							["AchievementTitleFont"] = "Merathilis Roboto-Bold",
							["MinionTitleFont"] = "Merathilis Roboto-Bold",
							["MinionTitleFontSize"] = 13,
							["AchievementObjectiveFont"] = "Merathilis Roboto-Bold",
							["MinionTitleFontOutline"] = "OUTLINE",
						},
						["MinionLocation"] = {
							["Y"] = -8.00006008148193,
							["X"] = -381.999053955078,
							["Point"] = "RIGHT",
							["RelativePoint"] = "RIGHT",
						},
						["Colours"] = {
							["MinionTitleColour"] = {
								["r"] = 1,
								["g"] = 0.490196078431373,
								["b"] = 0.0392156862745098,
							},
						},
					},
				},
			},
			["profiles"] = {
				["MerathilisUI"] = {
					["StatusBarTexture"] = "MerathilisBlank",
					["BackgroundTexture"] = "None",
					["BorderTexture"] = "None",
				},
			},
		},
	}

	-- Profile creation
	local db = LibStub("AceDB-3.0"):New(SorhaQuestLogDB, nil, true)
	db:SetProfile("MerathilisUI")
end