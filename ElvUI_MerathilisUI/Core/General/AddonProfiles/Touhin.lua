local MER, F, E, L, V, P, G = unpack(select(2, ...))

function MER:LoadTouhinProfile()
	--[[----------------------------------
	--	Touhin - Settings
	--]]----------------------------------

	TouhinDB.profiles[F.Profiles.Default] = {
		["edgeSize"] = 1,
		["scale"] = 0.9,
		["anchor_y"] = 249.000579833984,
		["bgFile"] = "MER_NormTex",
		["showMoney"] = false,
		["font"] = "Expressway",
		["anchor_x"] = 57.0003356933594,
		["edgeFile"] = "None",
		["anchor_point"] = "LEFT",
		["qualitySelfThreshold"] = 2,
		["colorBackground"] = false,
		["insets"] = 2,
	}
end
