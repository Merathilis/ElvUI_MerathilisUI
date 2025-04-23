local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Notification")

local GetLogIndexForQuestID = C_QuestLog.GetLogIndexForQuestID
local GetFactionInfoByID = C_Reputation.GetFactionDataByID
local GetQuestLogCompletionText = GetQuestLogCompletionText
local PlaySound = PlaySound

-- Credits: Paragon Reputation
local PARAGON_DATA = {
	--Legion
	[48976] = { -- Argussian Reach
		factionID = 2170,
		cache = 152922,
	},
	[46777] = { -- Armies of Legionfall
		factionID = 2045,
		cache = 152108,
	},
	[48977] = { -- Army of the Light
		factionID = 2165,
		cache = 152923,
	},
	[46745] = { -- Court of Farondis
		factionID = 1900,
		cache = 152102,
	},
	[46747] = { -- Dreamweavers
		factionID = 1883,
		cache = 152103,
	},
	[46743] = { -- Highmountain Tribes
		factionID = 1828,
		cache = 152104,
	},
	[46748] = { -- The Nightfallen
		factionID = 1859,
		cache = 152105,
	},
	[46749] = { -- The Wardens
		factionID = 1894,
		cache = 152107,
	},
	[46746] = { -- Valarjar
		factionID = 1948,
		cache = 152106,
	},

	--Battle for Azeroth
	--Neutral
	[54453] = { --Champions of Azeroth
		factionID = 2164,
		cache = 166298,
	},
	[58096] = { --Rajani
		factionID = 2415,
		cache = 174483,
	},
	[55348] = { --Rustbolt Resistance
		factionID = 2391,
		cache = 170061,
	},
	[54451] = { --Tortollan Seekers
		factionID = 2163,
		cache = 166245,
	},
	[58097] = { --Uldum Accord
		factionID = 2417,
		cache = 174484,
	},

	--Horde
	[54460] = { --Talanji's Expedition
		factionID = 2156,
		cache = 166282,
	},
	[54455] = { --The Honorbound
		factionID = 2157,
		cache = 166299,
	},
	[53982] = { --The Unshackled
		factionID = 2373,
		cache = 169940,
	},
	[54461] = { --Voldunai
		factionID = 2158,
		cache = 166290,
	},
	[54462] = { --Zandalari Empire
		factionID = 2103,
		cache = 166292,
	},

	--Alliance
	[54456] = { --Order of Embers
		factionID = 2161,
		cache = 166297,
	},
	[54458] = { --Proudmoore Admiralty
		factionID = 2160,
		cache = 166295,
	},
	[54457] = { --Storm's Wake
		factionID = 2162,
		cache = 166294,
	},
	[54454] = { --The 7th Legion
		factionID = 2159,
		cache = 166300,
	},
	[55976] = { --Waveblade Ankoan
		factionID = 2400,
		cache = 169939,
	},

	--Shadowlands
	[61100] = { --Court of Harvesters
		factionID = 2413,
		cache = 180648,
	},
	[64012] = { --Death's Advance
		factionID = 2470,
		cache = 186650,
	},
	[64266] = { --The Archivist's Codex
		factionID = 2472,
		cache = 187028,
	},
	[61097] = { --The Ascended
		factionID = 2407,
		cache = 180647,
	},
	[64867] = { --The Enlightened
		factionID = 2478,
		cache = 187780,
	},
	[61095] = { --The Undying Army
		factionID = 2410,
		cache = 180646,
	},
	[61098] = { --The Wild Hunt
		factionID = 2465,
		cache = 180649,
	},
	[64267] = { --Ve'nari
		factionID = 2432,
		cache = 187029,
	},

	--Dragonflight
	[66156] = { -- Dragonscale Expedition
		factionID = 2507,
		cache = 199472,
	},
	[76425] = { -- Dream Wardens
		factionID = 2574,
		cache = 210992,
	},
	[66511] = { -- Iskaara Tuskarr
		factionID = 2511,
		cache = 199473,
	},
	[75290] = { -- Loamm Niffen
		factionID = 2564,
		cache = 204712,
	},
	[65606] = { -- Maruuk Centaur
		factionID = 2503,
		cache = 199474,
	},
	[71023] = { -- Valdrakken Accord
		factionID = 2510,
		cache = 199475,
	},
	--War Within
	[79219] = { -- Council of Dornogal
		factionID = 2590,
		cache = 225239,
	},
	[79218] = { -- Hallowfall Arathi
		factionID = 2570,
		cache = 225246,
	},
	[79220] = { -- The Assembly of the Deep
		factionID = 2594,
		cache = 225245,
	},
	[79196] = { -- The Severed Threads
		factionID = 2600,
		cache = 225247,
	},
	[83739] = { -- The General
		factionID = 2605,
		cache = 226045,
	},
	[83740] = { -- The Vizier
		factionID = 2607,
		cache = 226100,
	},
	[83738] = { -- The Weaver
		factionID = 2601,
		cache = 226103,
	},
	[85805] = { -- The Cartels of Undermine
		factionID = 2653,
		cache = 232463,
	},
	[85471] = { -- Gallagio Loyalty Rewards Club
		factionID = 2685,
		cache = 232463,
	},
	[85806] = { -- Bilgewater Cartel
		factionID = 2673,
		cache = 237132,
	},
	[85807] = { -- Blackwater Cartel
		factionID = 2675,
		cache = 237135,
	},
	[85808] = { -- Darkfuse Solutions
		factionID = 2669,
		cache = 232465,
	},
	[85809] = { -- Steamwheedle Cartel
		factionID = 2677,
		cache = 237134,
	},
	[85810] = { -- Venture Company
		factionID = 2671,
		cache = 237133,
	},
}

function module:QUEST_ACCEPTED(_, arg1)
	module.db = E.db.mui.notification
	if not module.db.enable then
		return
	end

	if module.db.paragon and PARAGON_DATA[arg1] then
		local data = GetFactionInfoByID(PARAGON_DATA[arg1].factionID)
		local text = GetQuestLogCompletionText(GetLogIndexForQuestID(arg1))
		PlaySound(618, "Master") -- QUEST ADDED
		self:DisplayToast(
			data.name,
			text,
			nil,
			"Interface\\Icons\\Achievement_Quests_Completed_08",
			0.08,
			0.92,
			0.08,
			0.92
		)
	end
end
