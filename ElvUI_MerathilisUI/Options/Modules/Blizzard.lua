local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local options = MER.options.modules.args
local CM = MER:GetModule("MER_CooldownManager")

options.blizzard = {
	type = "group",
	name = E.NewSign .. L["Blizzard"],
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Blizzard"], "orange"),
		},
		cooldownManager = {
			order = 1,
			type = "group",
			name = E.NewSign .. F.cOption(L["Cooldown Manager"], "orange"),
			args = {
				header = {
					order = 0,
					type = "header",
					name = F.cOption(L["Cooldown Manager"], "orange"),
				},
				credits = {
					order = 1,
					type = "group",
					name = F.cOption(L["Credits"], "orange"),
					guiInline = true,
					args = {
						toxiui = {
							order = 1,
							type = "description",
							name = "|cff1784d1ElvUI|r |cffffffffToxi|r|cff18a8ffUI|r",
						},
					},
				},
				enable = {
					order = 2,
					type = "toggle",
					name = L["Enable"],
					width = "full",
					get = function(_)
						return E.db.mui.cooldownManager.enable
					end,
					set = function(_, value)
						E.db.mui.cooldownManager.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				fading = {
					order = 3,
					type = "toggle",
					name = L["Fading"],
					desc = L["Enabling this makes the Cooldown Manager bars fade with the Player UnitFrame."],
					hidden = function()
						return not E.db.mui.cooldownManager.enable
					end,
					get = function(_)
						return E.db.mui.cooldownManager.fading
					end,
					set = function(_, value)
						E.db.mui.cooldownManager.fading = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				spacer = {
					order = 4,
					type = "description",
					name = " ",
				},
				dynamicGroup = {
					order = 5,
					type = "group",
					name = L["Dynamic Bars"],
					inline = true,
					hidden = function()
						return not E.db.mui.cooldownManager.enable
					end,
					args = {
						dynamicBarsWidth = {
							order = 1,
							type = "toggle",
							name = L["Dynamic Bars Width"],
							desc = L["Enabling this syncs the detached power/class bar width with the Cooldown Manager."],
							get = function(_)
								return E.db.mui.cooldownManager.dynamicBarsWidth
							end,
							set = function(_, value)
								local cmDB = E.db.mui.cooldownManager
								local playerDB = E.db.unitframe.units.player
								if value and playerDB then
									cmDB._savedBarsWidth = {
										power = playerDB.power and playerDB.power.detachedWidth,
										classbar = playerDB.classbar and playerDB.classbar.detachedWidth,
									}
								elseif not value and playerDB then
									local saved = cmDB._savedBarsWidth
									if saved then
										if playerDB.power and saved.power then
											playerDB.power.detachedWidth = saved.power
										end
										if playerDB.classbar and saved.classbar then
											playerDB.classbar.detachedWidth = saved.classbar
										end
									end
									cmDB._savedBarsWidth = nil
								end
								cmDB.dynamicBarsWidth = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						dynamicCastbarWidth = {
							order = 2,
							type = "toggle",
							name = L["Castbar"],
							desc = L["Enabling this syncs the player castbar width with the Cooldown Manager."],
							get = function(_)
								return E.db.mui.cooldownManager.dynamicCastbarWidth
							end,
							set = function(_, value)
								local cmDB = E.db.mui.cooldownManager
								local playerDB = E.db.unitframe.units.player
								if value and playerDB and playerDB.castbar then
									cmDB._savedCastbarWidth = playerDB.castbar.width
								elseif not value and playerDB and playerDB.castbar then
									if cmDB._savedCastbarWidth then
										playerDB.castbar.width = cmDB._savedCastbarWidth
									end
									cmDB._savedCastbarWidth = nil
								end
								cmDB.dynamicCastbarWidth = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						minDynamicWidth = {
							order = 3,
							type = "range",
							name = L["Minimum Width"],
							desc = L["Minimum width applied when syncing. Prevents bars from becoming too narrow when few cooldowns are shown."],
							min = 200,
							max = 600,
							step = 1,
							disabled = function()
								local cmDB = E.db.mui.cooldownManager
								return not E.db.mui.cooldownManager.enable
									or (not cmDB.dynamicBarsWidth and not cmDB.dynamicCastbarWidth)
							end,
							get = function(_)
								return E.db.mui.cooldownManager.minDynamicWidth
							end,
							set = function(_, value)
								E.db.mui.cooldownManager.minDynamicWidth = value
								CM:OnDynamicWidthChanged()
							end,
						},
					},
				},
				spacer1 = {
					order = 6,
					type = "description",
					name = " ",
				},
				anchorGroup = {
					order = 7,
					type = "group",
					name = L["Anchoring"],
					desc = "Anchor Cooldown Manager frames to "
						.. F.String.MERATHILISUI("ElvUI")
						.. " unit frame elements for automatic positioning.\n\n",
					inline = true,
					hidden = function()
						return not E.db.mui.cooldownManager.enable
					end,
					args = {
						anchorEssentialEnabled = {
							order = 1,
							type = "toggle",
							name = L["Essential to Power Bar"],
							desc = L["Anchor the Essential Cooldown Viewer to the bottom of ElvUI's detached Power Bar."],
							disabled = function()
								return not E.db.unitframe.units.player.power.enable
							end,
							get = function(_)
								return E.db.mui.cooldownManager.anchors.essential.enable
							end,
							set = function(_, value)
								E.db.mui.cooldownManager.anchors.essential.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						anchorEssentialYOffset = {
							order = 2,
							type = "range",
							name = L["Y Offset"],
							desc = L["Vertical offset for the Essential Cooldown Viewer anchor."],
							min = -50,
							max = 50,
							step = 1,
							disabled = function()
								return not E.db.mui.cooldownManager.anchors.essential.enable
									or not E.db.unitframe.units.player.power.enable
							end,
							get = function(_)
								return E.db.mui.cooldownManager.anchors.essential.yOffset
							end,
							set = function(_, value)
								E.db.mui.cooldownManager.anchors.essential.yOffset = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						spacer = {
							order = 3,
							type = "description",
							name = " ",
						},
						anchorUtilityEnabled = {
							order = 4,
							type = "toggle",
							name = L["Utility to Essential"],
							get = function(_)
								return E.db.mui.cooldownManager.anchors.utility.enable
							end,
							set = function(_, value)
								E.db.mui.cooldownManager.anchors.utility.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						anchorUtilityYOffset = {
							order = 5,
							type = "range",
							name = L["Y Offset"],
							desc = L["Vertical offset for the Utility Cooldown Viewer anchor."],
							min = -50,
							max = 50,
							step = 1,
							disabled = function()
								return not E.db.mui.cooldownManager.anchors.utility.enable
							end,
							get = function(_)
								return E.db.mui.cooldownManager.anchors.utility.yOffset
							end,
							set = function(_, value)
								E.db.mui.cooldownManager.anchors.utility.yOffset = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						spacer1 = {
							order = 6,
							type = "description",
							name = " ",
						},
						anchorBuffBarEnabled = {
							order = 7,
							type = "toggle",
							name = L["Buff Bar to Health Bar"],
							desc = L["Anchor the Buff Bar Viewer to the top of ElvUI's Health Bar."],
							get = function(_)
								return E.db.mui.cooldownManager.anchors.buffBar.enable
							end,
							set = function(_, value)
								E.db.mui.cooldownManager.anchors.buffBar.enable = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						anchorBuffBarYOffset = {
							order = 8,
							type = "range",
							name = L["Y Offset"],
							desc = L["Vertical offset for the Buff Bar Viewer anchor."],
							min = 0,
							max = 200,
							step = 1,
							disabled = function()
								return not E.db.mui.cooldownManager.anchors.buffBar.enable
							end,
							get = function(_)
								return E.db.mui.cooldownManager.anchors.buffBar.yOffset
							end,
							set = function(_, value)
								E.db.mui.cooldownManager.anchors.buffBar.yOffset = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
				spacer2 = {
					order = 8,
					type = "description",
					name = " ",
				},
				centerGroup = {
					order = 9,
					type = "group",
					name = L["Centering"],
					desc = L["Center Cooldown Manager icons within each viewer frame instead of the default left-aligned layout.\n\n"],
					inline = true,
					hidden = function()
						return not E.db.mui.cooldownManager.enable
					end,
					args = {
						centerEssential = {
							order = 1,
							type = "toggle",
							name = L["Essential"],
							desc = L["Center icons in the Essential Cooldown Viewer."],
							get = function(_)
								return E.db.mui.cooldownManager.centering.essential
							end,
							set = function(_, value)
								E.db.mui.cooldownManager.centering.essential = value
								F.Event.TriggerEvent("MER_CooldownManager.DatabaseUpdate")
							end,
						},
						centerUtility = {
							order = 2,
							type = "toggle",
							name = L["Utility"],
							desc = L["Center icons in the Utility Cooldown Viewer."],
							get = function(_)
								return E.db.mui.cooldownManager.centering.utility
							end,
							set = function(_, value)
								E.db.mui.cooldownManager.centering.utility = value
								F.Event.TriggerEvent("MER_CooldownManager.DatabaseUpdate")
							end,
						},
						centerBuff = {
							order = 3,
							type = "toggle",
							name = L["Buff Icons"],
							desc = L["Center icons in the Buff Icon Cooldown Viewer."],
						},
					},
				},
			},
		},
	},
}
