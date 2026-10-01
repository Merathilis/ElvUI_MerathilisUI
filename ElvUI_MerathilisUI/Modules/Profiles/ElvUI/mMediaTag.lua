local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")
local Splash = MER:GetModule("MER_SplashScreen") ---@class SplashScreen

function module:LoadmMediaTagProfile()
	local db = E.db.mMediaTag

	if not db then
		return
	end

	db.general.greeting_message = false
	db.important_casts.enable = true
	db.important_casts.anchor = "BOTTOM"
	db.nameplates.target.changeColor = true
	db.nameplates.target.changeTexture = true
	db.nameplates.target.texture = "mMediaTag A4"
	db.phase_icon.enable = true
	db.phase_icon.icon = "updates"
	db.ready_check_icon.enable = true

	-- Single fields only, replacing the unit tables would drop mMediaTag's other settings
	db.portraits.enable = true
	db.portraits.player.cast = true
	db.portraits.player.point.point = "RIGHT"
	db.portraits.player.point.relativePoint = "LEFT"
	db.portraits.player.point.x = -5
	db.portraits.player.point.y = 15
	db.portraits.target.cast = true
	db.portraits.target.point.point = "LEFT"
	db.portraits.target.point.relativePoint = "RIGHT"
	db.portraits.target.point.x = 5
	db.portraits.target.point.y = 15
	db.portraits.focus.enable = false
	db.portraits.targettarget.enable = false
	db.portraits.pet.enable = false
	db.portraits.party.enable = false
	db.portraits.boss.enable = false
	db.portraits.arena.enable = false

	db.lfg_invite_info.enable = true
	db.lfg_invite_info.text.font = F.FontOverride(I.Fonts.Primary)
end

function module:ApplymMediaTagProfile()
	if not E:IsAddOnEnabled("ElvUI_mMediaTag") then
		F.Developer.LogWarning("mMediaTag is not enabled. Will not apply profile.")
		return
	end

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
