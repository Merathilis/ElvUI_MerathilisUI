local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
if not C_AddOns.IsAddOnLoaded("ElvUI_FCT") then
	return
end

local addon = "ElvUI_FCT"
local FCT = E.Libs.AceAddon:GetAddon(addon)

function MER:LoadFCTProfile()
	ElvFCT = {
		["nameplates"] = {
			["enable"] = false,
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
	FCT:Initialize()
end
