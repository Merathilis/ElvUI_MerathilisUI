local MER, E, L, V, P, G = unpack(select(2, ...))
local TM = MER:GetModule('MER_TalentManager')

local _G = _G

local function TalentTable()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.talents = {
		type = "group",
		name = L["Talents"],
		args = {
			talentManager = {
				order = 1,
				type = "group",
				name = MER:cOption(L["Talent Manager"], 'orange'),
				desc = L["Save and learn talents by one-click."],
				guiInline = true,
				get = function(info)
					return E.db.mui.talents.talentManager[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.talents.talentManager[info[#info]] = value
					E:StaticPopup_Show("PRIVATE_RL")
				end,
				args = {
					desc = {
						order = 1,
						type = "group",
						inline = true,
						name = L["Description"],
						args = {
							feature = {
								order = 1,
								type = "description",
								name = L["Save and learn talents by one-click."],
								fontSize = "medium"
							}
						}
					},
					enable = {
						order = 2,
						type = "toggle",
						name = L["Enable"]
					},
					pvpTalent = {
						order = 3,
						type = "toggle",
						name = L["PvP Talents"]
					},
					itemButtons = {
						order = 4,
						type = "toggle",
						name = L["Item Buttons"],
						desc = L["Add tomb and codex buttons."]
					},
					statusIcon = {
						order = 5,
						type = "toggle",
						name = L["Status Icon"],
						desc = L["Add an icon indicates the status of the permission of changing talents."]
					},
					clearSets = {
						order = 6,
						type = "execute",
						name = L["Clear All Sets"],
						func = function()
							E.db.mui.talents.talentManager.sets = {}
							TM:UpdateSetButtons()
						end
					}
				}
			},
		},
	}
end

tinsert(MER.Config, TalentTable)
