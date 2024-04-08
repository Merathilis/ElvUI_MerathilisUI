local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

function MER:LoadTouhinProfile()
	--[[----------------------------------
	--	Touhin - Settings
	--]]
	----------------------------------

	TouhinDB.profiles[F.Profiles.Default] = {
		["edgeSize"] = 1,
		["scale"] = 0.9,
		["anchor_y"] = 249.000579833984,
		["bgFile"] = "ElvUI Norm1",
		["showMoney"] = false,
		["font"] = I.Fonts.Primary,
		["anchor_x"] = 57.0003356933594,
		["edgeFile"] = "None",
		["anchor_point"] = "LEFT",
		["qualitySelfThreshold"] = 2,
		["colorBackground"] = false,
		["insets"] = 2,
	}
end
