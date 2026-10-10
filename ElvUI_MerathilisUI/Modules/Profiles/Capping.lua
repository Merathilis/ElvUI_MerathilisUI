local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles") ---@class Profiles
local Splash = MER:GetModule("MER_SplashScreen") ---@class SplashScreen

function module:LoadCappingProfile()
	local db = _G.CappingFrame and _G.CappingFrame.db
	if not db then
		return
	end

	local name = I.ProfileNames.Default
	local data = {
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
	}

	-- Capping calls ReloadUI() on every profile change, which is blocked here (no click
	-- behind it), so its AceDB callbacks must not fire: the profile goes straight into
	-- the saved variables and takes effect with the reload ApplyCappingProfile asks for
	if db:GetCurrentProfile() == name then
		E:CopyTable(db.profile, data)
	else
		db.sv.profiles = db.sv.profiles or {}
		db.sv.profiles[name] = data
		db.sv.profileKeys = db.sv.profileKeys or {}
		db.sv.profileKeys[db.keys.char] = name
	end
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

			-- Capping reads its profile only at login, the popup's button is the click a reload needs
			E:StaticPopup_Show("CONFIG_RL")
		end, true)
	end, true, "Capping")
end
