local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")
local Splash = MER:GetModule("MER_SplashScreen") ---@class SplashScreen

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

if not IsAddOnLoaded("ElvUI_mMediaTag") then
	return
end

function module:LoadmMediaTagProfile()
	local db = E and E.db and E.db.mMediaTag

	if not db then
		return
	end

	db.general.greeting_message = false
	db.important_casts.enable = true
	db.nameplates.target.changeColor = true
	db.nameplates.target.changeTexture = true
	db.nameplates.target.texture = "mMediaTag A4"
	db.phase_icon.enable = true
	db.phase_icon.icon = "updates"
	db.ready_check_icon.enable = true
	db.important_casts.enable = true
	db.important_casts.anchor = "BOTTOM"

	db.portraits.enable = true
	db.portraits.player = {
		cast = true,
		point = {
			point = "RIGHT",
			relativePoint = "LEFT",
			x = -5,
			y = 15,
		},
	}
	db.portraits.target = {
		cast = true,
		point = {
			point = "LEFT",
			relativePoint = "RIGHT",
			x = 5,
			y = 15,
		},
	}
	db.portraits.focus.enable = false
	db.portraits.targettarget.enable = false
	db.portraits.pet.enable = false
	db.portraits.party.enable = false
	db.portraits.boss.enable = false
	db.portraits.arena.enable = false

	db.lfg_invite_info.enable = true
	db.lfg_invite_info.font = F.FontOverride(I.Fonts.Primary)
end

function module:ApplymMediaTagProfile()
	Splash:Wrap("Applying mMediaTag Profile ...", function()
		self:LoadmMediaTagProfile()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			Splash:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "ElvUI_mMediaTag")
end
