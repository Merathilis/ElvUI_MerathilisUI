local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

function module:LoadmMediaTagProfile()
	E.db["mMT"]["general"]["greeting"] = false
	E.db["mMT"]["nameplate"]["executemarker"]["enable"] = true
	E.db["mMT"]["afk"]["misc"]["enable"] = false
	E.db["mMT"]["afk"]["values"]["enable"] = false
	E.db["mMT"]["afk"]["infoscreen"] = false
	E.db["mMT"]["afk"]["garbage"] = false
	E.db["mMT"]["afk"]["progress"]["enable"] = false
	E.db["mMT"]["afk"]["attributes"]["enable"] = false
	E.db["mMT"]["interruptoncd"]["enable"] = true
	E.db["mMT"]["portraits"]["general"]["enable"] = true
	E.db["mMT"]["portraits"]["general"]["style"] = "c"
	E.db["mMT"]["portraits"]["general"]["mui"] = true
	E.db["mMT"]["portraits"]["colors"]["WARRIOR"]["a"]["b"] = 0.09019608050584793
	E.db["mMT"]["portraits"]["colors"]["WARRIOR"]["a"]["g"] = 0.1372549086809158
	E.db["mMT"]["portraits"]["colors"]["WARRIOR"]["a"]["r"] = 0.4274510145187378
	E.db["mMT"]["portraits"]["colors"]["WARRIOR"]["b"]["b"] = 0.2470588386058807
	E.db["mMT"]["portraits"]["colors"]["WARRIOR"]["b"]["g"] = 0.4313725829124451
	E.db["mMT"]["portraits"]["colors"]["WARRIOR"]["b"]["r"] = 0.5647059082984924
	E.db["mMT"]["portraits"]["player"]["y"] = 16
	E.db["mMT"]["portraits"]["player"]["x"] = 12
	E.db["mMT"]["portraits"]["player"]["texture"] = "drop"
	E.db["mMT"]["portraits"]["player"]["size"] = 82
	E.db["mMT"]["portraits"]["player"]["cast"] = true
	E.db["mMT"]["portraits"]["target"]["y"] = 16
	E.db["mMT"]["portraits"]["target"]["x"] = -12
	E.db["mMT"]["portraits"]["target"]["texture"] = "drop"
	E.db["mMT"]["portraits"]["target"]["size"] = 82
	E.db["mMT"]["portraits"]["target"]["cast"] = true
	E.db["mMT"]["portraits"]["extra"]["rare"] = "c"
	E.db["mMT"]["portraits"]["targettarget"]["enable"] = false
	E.db["mMT"]["portraits"]["targettarget"]["extraEnable"] = false
	E.db["mMT"]["portraits"]["party"]["enable"] = false
	E.db["mMT"]["teleports"]["icon"] = true
	E.db["mMT"]["teleports"]["customicon"] = "TP5"
end

function module:ApplymMediaTagProfile()
	if not E:IsAddOnEnabled("ElvUI_mMediaTag") then
		F.Developer.LogWarning(L["ElvUI_mMediaTag is not enabled. Will not apply profile."])
		return
	end

	module:Wrap("Applying mMediaTag Profile ...", function()
		self:LoadmMediaTagProfile()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			module:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "ElvUI_mMediaTag")
end
