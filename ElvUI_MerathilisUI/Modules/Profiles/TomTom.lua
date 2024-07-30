local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

function module:LoadTomTomProfile()
	local profileName = I.ProfileNames.Default

	_G.TomTomDB.profiles[profileName] = {
		["arrow"] = {
			["lock"] = true,
			["position"] = {
				"CENTER",
				nil,
				"CENTER",
				-8.000190734863281,
				-79.99994659423828,
			},
		},
		["mapcoords"] = {
			["cursorenable"] = false,
			["playerenable"] = false,
		},
		["block"] = {
			["enable"] = false,
			["position"] = {
				"CENTER",
				nil,
				"CENTER",
				3.999964237213135,
				242.9998931884766,
			},
		},
		["feeds"] = {
			["arrow"] = true,
			["coords"] = true,
		},
	}
end

function module:ApplyTomTomProfile()
	if not E:IsAddOnEnabled("TomTom") then
		F.Developer.LogWarning("TomTom is not enabled. Will not apply profile.")
		return
	end

	module:Wrap("Applying TomTom Profile ...", function()
		local db = _G.TomTomDB
		local profileName = I.ProfileNames.Default

		self:LoadTomTomProfile()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			module:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "TomTom")
end
