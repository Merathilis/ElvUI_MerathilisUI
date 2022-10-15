local MER, F, E, L, V, P, G = unpack(select(2, ...))
local CF = MER:GetModule('MER_Cooldown')
local options = MER.options.modules.args

options.cooldowns = {
	type = "group",
	name = L["Cooldowns"],
	args = {
		cooldownFlash = {
			order = 1,
			type = "group",
			name = " ",
			guiInline = true,
			get = function(info) return E.db.mui.cooldownFlash[ info[#info] ] end,
			set = function(info, value) E.db.mui.cooldownFlash[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
			args = {
				header = {
					order = 1,
					type = "header",
					name = F.cOption(L["Cooldown Flash"], 'orange'),
				},
				credits = {
					order = 2,
					type = "group",
					name = F.cOption(L["Credits"], 'orange'),
					guiInline = true,
					args = {
						tukui = {
							order = 1,
							type = "description",
							name = "Doom_CooldownPulse - by Woffle of Dark Iron[US]"
						},
					},
				},
				enable = {
					order = 3,
					type = "toggle",
					name = L["Enable"],
					desc = CF.modName,
					get = function() return E.db.mui.cooldownFlash.enable ~= false or false end,
					set = function(info, v) E.db.mui.cooldownFlash.enable = v if v then CF:EnableCooldownFlash() else CF:DisableCooldownFlash() end end,
				},
				iconSize = {
					order = 4,
					name = L["Icon Size"],
					type = "range",
					min = 30, max = 125, step = 1,
					set = function(info, value) E.db.mui.cooldownFlash[ info[#info] ] = value; CF.DCP:SetSize(value, value) end,
					hidden = function() return not E.db.mui.cooldownFlash.enable end,
				},
				fadeInTime = {
					order = 5,
					name = L["Fadein duration"],
					type = "range",
					min = 0.3, max = 2.5, step = 0.1,
					hidden = function() return not E.db.mui.cooldownFlash.enable end,
				},
				fadeOutTime = {
					order = 6,
					name = L["Fadeout duration"],
					type = "range",
					min = 0.3, max = 2.5, step = 0.1,
					hidden = function() return not E.db.mui.cooldownFlash.enable end,
				},
				maxAlpha = {
					order = 7,
					name = L["Transparency"],
					type = "range",
					min = 0.25, max = 1, step = 0.05,
					isPercent = true,
					hidden = function() return not E.db.mui.cooldownFlash.enable end,
				},
				holdTime = {
					order = 8,
					name = L["Duration time"],
					type = "range",
					min = 0.3, max = 2.5, step = 0.1,
					hidden = function() return not E.db.mui.cooldownFlash.enable end,
				},
				animScale = {
					order = 9,
					name = L["Animation size"],
					type = "range",
					min = 0.5, max = 2, step = 0.1,
					hidden = function() return not E.db.mui.cooldownFlash.enable end,
				},
				enablePet = {
					order = 10,
					name = L["Watch on pet spell"],
					type = "toggle",
					get = function(info) return E.db.mui.cooldownFlash[ info[#info] ] end,
					set = function(info, value) E.db.mui.cooldownFlash[ info[#info] ] = value; if value then CF.DCP:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") else CF.DCP:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED") end end,
					hidden = function() return not E.db.mui.cooldownFlash.enable end,
				},
				test = {
					order = 11,
					name = L["Test"],
					type = "execute",
					func = function() CF:TestMode() end,
					hidden = function() return not E.db.mui.cooldownFlash.enable end,
				},
			},
		},
	},
}

do
	local selectedKey
	local tempName

	options.cooldowns.args.cooldownFlash.args.ignoredSpells = {
		order = 99,
		type = "group",
		inline = true,
		name = L["Blacklist"],
		disabled = function() return not E.db.mui.cooldownFlash.enable end,
		args = {
			name = {
				order = 1,
				type = "input",
				name = L["Spell Name"],
				get = function()
					return tempName
				end,
				set = function(_, value)
					tempName = value
				end
			},
			addButton = {
				order = 3,
				type = "execute",
				name = L["Add"],
				func = function()
					if tempName then
						E.db.mui.cooldownFlash.ignoredSpells[tempName] = true
						tempName = nil
					else
						F.Print(L["Please set the name first."])
					end
				end
			},
			spacer = {
				order = 4,
				type = "description",
				name = " ",
				width = "full"
			},
			listTable = {
				order = 5,
				type = "select",
				name = L["Spell List"],
				get = function()
					return selectedKey
				end,
				set = function(_, value)
					selectedKey = value
				end,
				values = function()
					local result = {}
					for fullID in pairs(E.db.mui.cooldownFlash.ignoredSpells) do
						result[fullID] = fullID
					end
					return result
				end
			},
			deleteButton = {
				order = 6,
				type = "execute",
				name = L["Delete"],
				func = function()
					if selectedKey then
						E.db.mui.cooldownFlash.ignoredSpells[selectedKey] = nil
					end
				end
			},
		},
	}
end
