local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--WoW API / Variables
-- GLOBALS:

function MER:LoadTouhinProfile()
	--[[----------------------------------
	--	ls_Toasts - Settings
	--]]----------------------------------

	TouhinDB.profiles["MerathilisUI"] = {
		["edgeSize"] = 1,
		["scale"] = 0.9,
		["anchor_y"] = 249.000579833984,
		["bgFile"] = "Melli",
		["showMoney"] = false,
		["font"] = "Merathilis Expressway",
		["anchor_x"] = 57.0003356933594,
		["edgeFile"] = "None",
		["anchor_point"] = "LEFT",
		["qualitySelfThreshold"] = 2,
		["colorBackground"] = false,
		["insets"] = 2,
	}
end
