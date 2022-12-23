local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Misc')

local MountSE = {

}

local OtherSE = {
	["Smolderheart"] = {
		-- Smolderheart
		-- https://www.wowhead.com/item=180873/smolderheart
		2066602, -- sound/spells/fx_fire_magic_loop_smoldering_a_01.ogg
		2066603, -- sound/spells/fx_fire_magic_loop_smoldering_a_02.ogg
		2066604, -- sound/spells/fx_fire_magic_loop_smoldering_b_01.ogg
		2066605 -- sound/spells/fx_fire_magic_loop_smoldering_b_02.ogg
	},
	["Elegy of the Eternals"] = {
		-- Smolderheart
		-- https://www.wowhead.com/item=188270/elegy-of-the-eternals
		539295 -- sound/character/bloodelf/bloodelffemalecry01.ogg
	},
	["Dragonriding"] = {
		-- from https://wago.io/SDhHuZh3f
		540108,
		540119,
		540182,
		540188,
		540197,
		540211,
		540213,
		540218,
		540221,
		540243,
		547436,
		547714,
		547715,
		547716,
		597932,
		597968,
		597986,
		597989,
		597998,
		598004,
		598010,
		598016,
		598028,
		803545,
		803547,
		803549,
		803551,
		1489050,
		1489051,
		1489052,
		1489053,
		1563054,
		1563055,
		1563058,
		3014246,
		3014247,
		4337227,
		4543973,
		4543977,
		4543979,
		4550997,
		4550999,
		4551001,
		4551003,
		4551005,
		4551007,
		4551009,
		4551011,
		4551013,
		4551015,
		4551017,
		4627086,
		4627088,
		4627090,
		4627092,
		4633292,
		4633294,
		4633296,
		4633298,
		4633300,
		4633302,
		4633304,
		4633306,
		4633308,
		4633310,
		4633312,
		4633314,
		4633338,
		4633340,
		4633342,
		4633344,
		4633346,
		4633348,
		4633350,
		4633354,
		4633356,
		4633370,
		4633372,
		4633374,
		4633376,
		4633378,
		4633382,
		4633392,
		4634009,
		4634011,
		4634013,
		4634015,
		4634017,
		4634019,
		4634021,
		4634908,
		4634910,
		4634912,
		4634914,
		4634916,
		4634924,
		4634926,
		4634928,
		4634930,
		4634932,
		4634942,
		4634944,
		4634946,
		4663454,
		4663456,
		4663458,
		4663460,
		4663462,
		4663464,
		4663466,
		4674593,
		4674595,
		4674599,
		12694571,
		12694572,
		12694573,
		1321216,
		1321217,
		1321218,
		1321219,
		1321220,
		1467222,
	},
	["Jewelcrafting"] = {
		569325
	},
}


function module:Mute()
	for mountID, soundIDs in pairs(MountSE) do
		if E.db.mui.misc.mute.enable and E.db.mui.misc.mute.mount[mountID] then
			for _, soundID in pairs(soundIDs) do
				MuteSoundFile(soundID)
			end
		else
			for _, soundID in pairs(soundIDs) do
				UnmuteSoundFile(soundID)
			end
		end
	end

	for cat, soundIDs in pairs(OtherSE) do
		if E.db.mui.misc.mute.enable and E.db.mui.misc.mute.other[cat] then
			for _, soundID in pairs(soundIDs) do
				MuteSoundFile(soundID)
			end
		else
			for _, soundID in pairs(soundIDs) do
				UnmuteSoundFile(soundID)
			end
		end
	end
end

module:AddCallback("Mute")
