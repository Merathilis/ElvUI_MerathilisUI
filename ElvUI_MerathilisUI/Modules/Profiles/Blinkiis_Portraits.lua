local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles") ---@class Profiles
local Splash = MER:GetModule("MER_SplashScreen") ---@class SplashScreen

function module:LoadBlinkiisPortraitsProfile()
	local profileName = I.ProfileNames.Default or "MerathilisUI"

	_G.BlinkiisPortraitsDB.profiles[profileName] = {
		["targettarget"] = {
			["enable"] = false,
		},
		["boss"] = {
			["cast"] = true,
			["texture"] = "blizz_round",
		},
		["player"] = {
			["point"] = {
				["y"] = 15,
				["x"] = -5,
			},
			["cast"] = true,
			["texture"] = "blizz_round",
		},
		["focus"] = {
			["enable"] = false,
		},
		["target"] = {
			["point"] = {
				["y"] = 15,
				["x"] = 5,
			},
			["cast"] = true,
			["texture"] = "blizz_round",
		},
		["arena"] = {
			["enable"] = false,
		},
		["party"] = {
			["enable"] = false,
		},
		["pet"] = {
			["enable"] = false,
		},
	}
end

function module:ApplyBlinkiisPortraitsProfile()
	if not E:IsAddOnEnabled("Blinkiis_Portraits") then
		WF.Developer.LogWarning("Blinkiis_Portraits is not enabled. Will not apply profile.")
		return
	end

	local profileName = I.ProfileNames.Default or "MerathilisUI"
	local addon = _G.BLINKIISPORTRAITS

	Splash:Wrap("Applying Blinkiis_Portraits Profile ...", function()
		self:LoadBlinkiisPortraitsProfile()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			if addon and addon.db then
				addon.db:SetProfile(profileName)
			end

			Splash:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "Blinkiis_Portraits")
end
