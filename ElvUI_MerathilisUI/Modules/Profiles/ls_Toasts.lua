local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

function module:LoadLSProfile()
	local profileName = I.ProfileNames.Default

	LS_TOASTS_GLOBAL_CONFIG.profiles[profileName] = {
		["anchors"] = {
			[1] = {
				["point"] = {
					p = "TOP",
					rP = "TOP",
					["x"] = 0,
					["y"] = -210,
				},
				["scale"] = 1.2,
			},
		},
		["font"] = {
			["name"] = I.Fonts.Primary,
			["size"] = 11,
		},
		["colors"] = {
			["enabled"] = true,
			["threshold"] = 2,
			["border"] = false,
		},
		["skin"] = "MerathilisUI",
		["types"] = {
			["garrison_6_0"] = {
				["enabled"] = true,
				["dnd"] = true,
				["sfx"] = true,
			},
			["loot_currency"] = {
				["enabled"] = true,
				["dnd"] = false,
				["sfx"] = true,
			},
			["instance"] = {
				["enabled"] = true,
				["dnd"] = false,
				["sfx"] = true,
			},
			["world"] = {
				["enabled"] = true,
				["dnd"] = false,
				["sfx"] = true,
			},
			["loot_special"] = {
				["enabled"] = true,
				["ilvl"] = true,
				["sfx"] = true,
				["threshold"] = 1,
				["dnd"] = false,
			},
			["achievement"] = {
				["enabled"] = true,
				["dnd"] = false,
			},
			["loot_gold"] = {
				["threshold"] = 1,
				["enabled"] = false,
				["dnd"] = false,
				["sfx"] = true,
			},
			["loot_common"] = {
				["threshold"] = 1,
				["ilvl"] = true,
				["sfx"] = true,
				["dnd"] = false,
				["quest"] = false,
				["enabled"] = true,
			},
			["recipe"] = {
				["enabled"] = true,
				["dnd"] = false,
				["sfx"] = true,
			},
			["collection"] = {
				["enabled"] = true,
				["sfx"] = true,
				["dnd"] = false,
				["left_click"] = false,
			},
			["archaeology"] = {
				["enabled"] = true,
				["dnd"] = false,
				["sfx"] = true,
			},
			["garrison_7_0"] = {
				["enabled"] = true,
				["dnd"] = true,
				["sfx"] = true,
			},
			["transmog"] = {
				["enabled"] = true,
				["sfx"] = true,
				["dnd"] = false,
				["left_click"] = false,
			},
		},
	}
end

function module:ApplyLSProfile()
	module:Wrap("Applying ls Profile ...", function()
		-- Apply Fonts
		self:LoadLSProfile()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			module:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "ls_Toasts")
end
