local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

function module:LoadCappingProfile()
	local profileName = I.ProfileNames.Default

	_G.CappingSettings.profiles[profileName] = {
		["outline"] = "OUTLINE",
		["font"] = "- Expressway",
		["lock"] = true,
		["spacing"] = 1,
		["barTexture"] = "ElvUI Norm1",
		["autoTurnIn"] = false,
		["position"] = {
			"RIGHT",
			"RIGHT",
			-335.9999084472656,
			214.9999237060547,
		},
	}
end

function module:ApplyCappingProfile()
	if not E:IsAddOnEnabled("Capping") then
		F.Developer.LogWarning("Capping is not enabled. Will not apply profile.")
		return
	end

	module:Wrap("Applying Capping Profile ...", function()
		local db = _G.CappingSettings
		local profileName = I.ProfileNames.Default

		self:LoadCappingProfile()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			module:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "Capping")
end
