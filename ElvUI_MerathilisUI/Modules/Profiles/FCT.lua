local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded

if not IsAddOnLoaded("ElvUI_FCT") then
	return
end

local addon = "ElvUI_FCT"
local FCT = E.Libs.AceAddon:GetAddon(addon)

function module:LoadFCTProfile()
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

function module:ApplyFCTProfile()
	module:Wrap("Applying FCT Profile ...", function()
		-- Apply Fonts
		self:LoadFCTProfile()

		FCT:UpdateUnitFrames()
		FCT:UpdateNamePlates()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			module:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "ElvUI_FCT")
end
