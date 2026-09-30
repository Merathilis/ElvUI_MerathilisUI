local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles") ---@class Profiles
local Splash = MER:GetModule("MER_SplashScreen") ---@class SplashScreen

function module:LoadCappingProfile()
	local db = _G.CappingFrame and _G.CappingFrame.db
	if not db then
		return
	end

	-- Capping reloads the UI itself when its profile changes
	self:ApplyAceDBProfile(db, I.ProfileNames.Default, {
		["outline"] = "OUTLINE",
		["font"] = "MER_Expressway",
		["lock"] = true,
		["spacing"] = 2,
		["barTexture"] = "ElvUI Norm1",
		["autoTurnIn"] = false,
		["position"] = {
			"RIGHT",
			"RIGHT",
			-335,
			215,
		},
		["colorBarBackground"] = {
			nil,
			nil,
			nil,
			0.35,
		},
	})
end

function module:ApplyCappingProfile()
	if not E:IsAddOnEnabled("Capping") then
		F.Developer.LogWarning("Capping is not enabled. Will not apply profile.")
		return
	end

	Splash:Wrap("Applying Capping Profile ...", function()
		self:LoadCappingProfile()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			Splash:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "Capping")
end
