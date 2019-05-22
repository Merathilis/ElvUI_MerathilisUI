local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--Lua Variables
--WoW API / Variables

-- GLOBALS:

function MER:LoadFCTProfile()
	ElvFCT = {
		["nameplates"] = {
			["frames"] = {
				["Player"] = {
					["fontSize"] = 16,
				},
				["EnemyNPC"] = {
					["fontSize"] = 20,
					["advanced"] = {
						["ScrollTime"] = 1,
					},
					["textShake"] = true,
					["showDots"] = true,
					["cycleColors"] = false,
				},
				["EnemyPlayer"] = {
					["fontSize"] = 16,
				},
				["FriendlyNPC"] = {
					["fontSize"] = 16,
				},
			},
		},
		["unitframes"] = {
			["frames"] = {
				["Target"] = {
					["fontSize"] = 12,
					["showName"] = false,
					["cycleColors"] = false,
				},
				["Player"] = {
					["fontSize"] = 12,
					["showName"] = false,
				},
				["Boss"] = {
					["enable"] = false,
				},
				["Focus"] = {
					["enable"] = false,
				},
				["FocusTarget"] = {
					["enable"] = false,
				},
			},
		},
	}
end
