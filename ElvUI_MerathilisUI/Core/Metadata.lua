local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo

-- Mythic+
MER.MythicPlusMapData = {
	-- https://wago.tools/db2/MapChallengeMode
	-- https://wago.tools/db2/GroupFinderActivityGrp
	[378] = { abbr = L["[ABBR] Halls of Atonement"], activityID = 261, timers = { 1152, 1536, 1920 } },
	[391] = { abbr = L["[ABBR] Tazavesh: Streets of Wonder"], activityID = 280, timers = { 1152, 1536, 1920 } },
	[392] = { abbr = L["[ABBR] Tazavesh: So'leah's Gambit"], activityID = 281, timers = { 1080, 1440, 1800 } },
	[499] = { abbr = L["[ABBR] Priory of the Sacred Flame"], activityID = 324, timers = { 1170, 1560, 1950 } },
	[503] = { abbr = L["[ABBR] Ara-Kara, City of Echoes"], activityID = 323, timers = { 1080, 1440, 1800 } },
	[505] = { abbr = L["[ABBR] The Dawnbreaker"], activityID = 326, timers = { 1116, 1488, 1860 } },
	[525] = { abbr = L["[ABBR] Operation: Floodgate"], activityID = 371, timers = { 1188, 1584, 1980 } },
	[542] = { abbr = L["[ABBR] Eco-Dome Al'dani"], activityID = 381, timers = { 1116, 1488, 1860 } },
}

-- Histories (for localization)
-- [247] = { abbr = L["[ABBR] The MOTHERLODE!!"], activityID = 140, timers = { 1188, 1584, 1980 } },
-- [370] = { abbr = L["[ABBR] Operation: Mechagon - Workshop"], activityID = 257, timers = { 1118, 1536, 1920 } },
-- [382] = { abbr = L["[ABBR] Theater of Pain"], activityID = 266, timers = { 1224, 1632, 2040 } },
-- [499] = { abbr = L["[ABBR] Priory of the Sacred Flame"], activityID = 324, timers = { 1170, 1560, 1950 } },
-- [500] = { abbr = L["[ABBR] The Rookery"], activityID = 325, timers = { 1044, 1392, 1740 } },
-- [504] = { abbr = L["[ABBR] Darkflame Cleft"], activityID = 322, timers = { 1116, 1488, 1860 } },
-- [506] = { abbr = L["[ABBR] Cinderbrew Meadery"], activityID = 327, timers = { 1188, 1584, 1980 } },
-- [525] = { abbr = L["[ABBR] Operation: Floodgate"], activityID = 371, timers = { 1188, 1584, 1980 } },
-- [501] = { abbr = L["[ABBR] The Stonevault"], activityID = 328, timers = { 1188, 1584, 1980 } },
-- [502] = { abbr = L["[ABBR] City of Threads"], activityID = 329, timers = { 1260, 1680, 2100 } },
-- [503] = { abbr = L["[ABBR] Ara-Kara, City of Echoes"], activityID = 323, timers = { 1080, 1440, 1800 } },
-- [505] = { abbr = L["[ABBR] The Dawnbreaker"], activityID = 326, timers = { 1116, 1488, 1860 } },

MER.MythicPlusSeasonAchievementData = {
	[20525] = { sortIndex = 1, abbr = L["[ABBR] The War Within Keystone Master: Season One"] },
	[20526] = { sortIndex = 2, abbr = L["[ABBR] The War Within Keystone Hero: Season One"] },
	[41533] = { sortIndex = 3, abbr = L["[ABBR] The War Within Keystone Master: Season Two"] },
	[40952] = { sortIndex = 4, abbr = L["[ABBR] The War Within Keystone Hero: Season Two"] },
	[41973] = { sortIndex = 5, abbr = L["[ABBR] The War Within Keystone Master: Season Three"] },
	[42171] = { sortIndex = 6, abbr = L["[ABBR] The War Within Keystone Hero: Season Three"] },
	[42172] = { sortIndex = 7, abbr = L["[ABBR] The War Within Keystone Legend: Season Three"] },
}

-- https://www.wowhead.com/achievements/character-statistics/dungeons-and-raids/the-war-within/
-- var a=""; document.querySelectorAll("tbody.clickable > tr a.listview-cleartext").forEach((h) => a+=h.href.match(/achievement=([0-9]*)/)[1]+',');console.log(a);
-- ID: https://wago.tools/db2/LFGDungeons?filter%5BTypeID%5D=2&filter%5BSubtype%5D=2&page=5
MER.RaidData = {
	[2645] = {
		abbr = L["[ABBR] Nerub-ar Palace"],
		tex = 5779391,
		achievements = {
			{ 40267, 40271, 40275, 40279, 40283, 40287, 40291, 40295 },
			{ 40268, 40272, 40276, 40280, 40284, 40288, 40292, 40296 },
			{ 40269, 40273, 40277, 40281, 40285, 40289, 40293, 40297 },
			{ 40270, 40274, 40278, 40282, 40286, 40290, 40294, 40298 },
		},
	},
	[2779] = {
		abbr = L["[ABBR] Liberation of Undermine"],
		tex = 6422371,
		achievements = {
			{ 41299, 41303, 41307, 41311, 41315, 41319, 41323, 41327 },
			{ 41300, 41304, 41308, 41312, 41316, 41320, 41324, 41328 },
			{ 41301, 41305, 41309, 41313, 41317, 41321, 41325, 41329 },
			{ 41302, 41306, 41310, 41314, 41318, 41322, 41326, 41330 },
		},
	},
	[2805] = {
		abbr = L["[ABBR] Manaforge Omega"],
		tex = 7049159,
		achievements = {
			-- from NDui_Plus
			{ 41633, 41637, 41641, 41645, 41649, 41653, 41657, 41661 },
			{ 41634, 41638, 41642, 41646, 41650, 41654, 41658, 41662 },
			{ 41635, 41639, 41643, 41647, 41651, 41655, 41659, 41663 },
			{ 41636, 41640, 41644, 41648, 41652, 41656, 41660, 41664 },
		},
	},
}

MER.SpecializationInfo = {}

MER.RealRegion = (function()
	local region = GetCurrentRegionName()
	if region == "KR" and MER.ChineseLocale then
		region = "TW" -- Fix taiwan server region issue
	end

	return region
end)()

MER.CurrentRealmID = GetRealmID()
MER.CurrentRealmName = GetRealmName()

function MER:InitializeMetadata()
	for id in pairs(MER.MythicPlusMapData) do
		local name, _, timeLimit, tex = C_ChallengeMode_GetMapUIInfo(id)
		MER.MythicPlusMapData[id].name = name
		MER.MythicPlusMapData[id].tex = tex
		MER.MythicPlusMapData[id].idString = tostring(id)
		MER.MythicPlusMapData[id].timeLimit = timeLimit
		if MER.MythicPlusMapData[id].timers then
			MER.MythicPlusMapData[id].timers[#MER.MythicPlusMapData[id].timers] = timeLimit
		end

		-- debug: print mythic+ map data
		-- E:Delay(3, function()
		-- 	print("MythicPlusMapData", id, name, "Tex:", F.GetTextureString(tex, 16, 16, true))
		-- 	for i, timer in pairs(MER.MythicPlusMapData[id].timers) do
		-- 		local mm = floor(timer / 60)
		-- 		local ss = timer % 60
		-- 		print("  Timer", i, ":", format("%02d:%02d", mm, ss))
		-- 	end
		-- end)
	end

	for id in pairs(MER.MythicPlusSeasonAchievementData) do
		MER.Utilities.Async.WithAchievementID(id, function(data)
			MER.MythicPlusSeasonAchievementData[id].name = data[2]
			MER.MythicPlusSeasonAchievementData[id].tex = data[10]
			MER.MythicPlusSeasonAchievementData[id].idString = tostring(id)
		end)
	end

	for id in pairs(MER.RaidData) do
		local result = { GetLFGDungeonInfo(id) }
		MER.RaidData[id].name = result[1]
		MER.RaidData[id].idString = tostring(id)
	end

	for classID = 1, 13 do
		local class = {}
		for specIndex = 1, 4 do
			local data = { GetSpecializationInfoForClassID(classID, specIndex) }
			if #data > 0 then
				tinsert(class, { specID = data[1], name = data[2], icon = data[4], role = data[5] })
			end
		end

		tinsert(MER.SpecializationInfo, class)
	end

	-- debug: check all achievements
	-- for i, data in ipairs(MER.RaidData[2805].achievements) do
	-- for j, id in ipairs(data) do
	-- MER.Utilities.Async.WithAchievementID(id, function(data)
	-- E:Delay(1.3 * (i - 1) + j * 0.1, print, data[1], data[2])
	-- end)
	-- end
	-- end
end
