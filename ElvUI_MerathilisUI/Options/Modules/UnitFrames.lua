local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local options = MER.options.modules.args
local LSM = E.Libs.LSM

local format = string.format

local form = {
	SQ = L["Old"] .. " " .. L["Drop"],
	RO = L["Old"] .. " " .. L["Drop round"],
	CI = L["Old"] .. " " .. L["Circle"],
	PI = L["Old"] .. " " .. L["Pad"],
	RA = L["Old"] .. " " .. L["Diamond"],
	QA = L["Old"] .. " " .. L["Square"],
	MO = L["Old"] .. " " .. L["Moon"],
	SQT = L["Old"] .. " " .. L["Drop flipped"],
	ROT = L["Old"] .. " " .. L["Drop round flipped"],
	TH = L["Old"] .. " " .. L["Thin"],
	circle = L["Circle"],
	thincircle = L["Thin Circle"],
	diamond = L["Diamond"],
	thindiamond = L["Thin Diamond"],
	drop = L["Drop round"],
	dropsharp = L["Drop"],
	dropflip = L["Drop round flipped"],
	dropsharpflip = L["Drop flipped"],
	octagon = L["Octagon"],
	pad = L["Pad"],
	pure = L["Pure round"],
	puresharp = L["Pure"],
	shield = L["Shield"],
	square = L["Square"],
	thin = L["Thin"],
}

local style = {
	a = "FLAT",
	b = "SMOOTH",
	c = "METALLIC",
}

local extraStyle = {
	a = L["Style"] .. " A",
	b = L["Style"] .. " B",
	c = L["Style"] .. " C",
	d = L["Style"] .. " D",
	e = L["Style"] .. " E",
}

local ClassIconStyle = {}

local frameStrata = {
	BACKGROUND = "BACKGROUND",
	LOW = "LOW",
	MEDIUM = "MEDIUM",
	HIGH = "HIGH",
	DIALOG = "DIALOG",
	TOOLTIP = "TOOLTIP",
	AUTO = "Auto",
}

function BuildIconStylesTable()
	for iconStyle, value in pairs(MER.ClassIcons.mMT) do
		ClassIconStyle[iconStyle] = value.name
	end

	for iconStyle, value in pairs(MER.ClassIcons.Custom) do
		ClassIconStyle[iconStyle] = value.name
	end
end

local sizeString = ":16:16:0:0:64:64:4:60:4:60"

options.unitframes = {
	type = "group",
	name = E.NewSign .. L["UnitFrames"],
	childGroups = "tab",
	get = function(info)
		return E.db.mui.unitframes[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.unitframes[info[#info]] = value
	end,
	disabled = function()
		return not E.private.unitframe.enable
	end,
	args = {
		name = {
			order = 1,
			type = "header",
			name = F.cOption(L["UnitFrames"], "orange"),
		},
		general = {
			order = 2,
			type = "group",
			name = L["General"],
			args = {
				style = {
					order = 1,
					type = "toggle",
					name = L["UnitFrame Style"],
					desc = L["Adds my styling to the Unitframes if you use transparent health."],
				},
				raidIcons = {
					order = 2,
					type = "toggle",
					name = L["Raid Icon"],
					desc = L["Change the default raid icons."],
				},
				highlight = {
					order = 4,
					type = "toggle",
					name = L["Highlight"],
					desc = L["Adds an own highlight to the Unitframes"],
				},
				auras = {
					order = 5,
					type = "toggle",
					name = L["Auras"],
					desc = L["Adds an shadow around the auras"],
				},
				spacer = {
					order = 10,
					type = "description",
					name = "",
				},
				power = {
					order = 11,
					type = "group",
					name = F.cOption(L["Power"], "orange"),
					guiInline = true,
					get = function(info)
						return E.db.mui.unitframes.power[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.unitframes.power[info[#info]] = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					args = {
						texture = {
							order = 1,
							type = "select",
							name = L["Power"],
							desc = L["Power statusbar texture."],
							dialogControl = "LSM30_Statusbar",
							values = LSM:HashTable("statusbar"),
							-- function() return not E.db.mui.unitframes.power.enable end,
							get = function(info)
								return E.db.mui.unitframes.power[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.unitframes.power[info[#info]] = value
								module:ChangePowerBarTexture()
							end,
						},
					},
				},
				castbar = {
					order = 12,
					type = "group",
					name = F.cOption(L["Castbar"], "orange"),
					guiInline = true,
					get = function(info)
						return E.db.mui.unitframes.castbar[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.unitframes.castbar[info[#info]] = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
						},
						texture = {
							order = 2,
							type = "select",
							name = L["Texture"],
							dialogControl = "LSM30_Statusbar",
							values = LSM:HashTable("statusbar"),
							disabled = function()
								return not E.db.mui.unitframes.castbar.enable
							end,
						},
						spacer = {
							order = 3,
							type = "description",
							name = " ",
						},
						spark = {
							order = 10,
							type = "group",
							name = F.cOption(L["Spark"], "orange"),
							guiInline = true,
							get = function(info)
								return E.db.mui.unitframes.castbar.spark[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.unitframes.castbar.spark[info[#info]] = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
							disabled = function()
								return not E.db.mui.unitframes.castbar.enable
							end,
							args = {
								enable = {
									order = 1,
									type = "toggle",
									name = L["Enable"],
								},
								texture = {
									order = 2,
									type = "select",
									name = L["Spark Texture"],
									dialogControl = "LSM30_Statusbar",
									values = LSM:HashTable("statusbar"),
								},
								color = {
									order = 3,
									type = "color",
									name = _G.COLOR,
									hasAlpha = false,
									disabled = function()
										return not E.db.mui.unitframes.castbar.enable
											or not E.db.mui.unitframes.castbar.spark.enable
									end,
									get = function(info)
										local t = E.db.mui.unitframes.castbar.spark[info[#info]]
										local d = P.unitframes.castbar.spark[info[#info]]
										return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
									set = function(info, r, g, b, a)
										local t = E.db.mui.unitframes.castbar.spark[info[#info]]
										t.r, t.g, t.b, t.a = r, g, b, a
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
								width = {
									order = 4,
									type = "range",
									name = L["Size"],
									min = 2,
									max = 10,
									step = 1,
									disabled = function()
										return not E.db.mui.unitframes.castbar.enable
											or not E.db.mui.unitframes.castbar.spark.enable
									end,
								},
							},
						},
					},
				},
			},
		},
		individualUnits = {
			order = 3,
			type = "group",
			name = L["Individual Units"],
			args = {
				player = {
					order = 1,
					type = "group",
					name = L["Player"],
					args = {
						restingIndicator = {
							order = 1,
							type = "group",
							name = F.cOption(L["Resting Indicator"], "orange"),
							guiInline = true,
							get = function(info)
								return E.db.mui.unitframes.restingIndicator[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.unitframes.restingIndicator[info[#info]] = value
								E:StaticPopup_Show("PRIVATE_RL")
							end,
							disabled = function()
								return not E.db.unitframe.units.player.enable
									or not E.db.unitframe.units.player.RestIcon.enable
							end,
							args = {
								enable = {
									order = 1,
									type = "toggle",
									name = L["Enable"],
								},
								customClassColor = {
									order = 2,
									type = "toggle",
									name = L["Custom Gradient Color"],
								},
							},
						},
					},
				},
			},
		},
		groupUnits = {
			order = 4,
			type = "group",
			name = L["Group Units"],
			args = {
				party = {
					order = 1,
					type = "group",
					name = L["Party"],
					args = {},
				},
			},
		},
		portraits = {
			order = 5,
			type = "group",
			name = E.NewSign .. L["Portraits"],
			disabled = function()
				return not E.private.unitframe.enable
			end,
			args = {
				header = {
					order = 1,
					type = "header",
					name = F.cOption(L["Portraits"], "orange"),
				},
				credits = {
					order = 2,
					type = "group",
					name = F.cOption(L["Credits"], "orange"),
					guiInline = true,
					args = {
						blinkii = {
							order = 1,
							type = "description",
							name = "|CFF3650D5m|r|CFF4148C3M|r|CFF4743B6T -|r |CFF6559F1m|r|CFF7A4DEFM|r|CFF8845ECe|r|CFFA037E9d|r|CFFA435E8i|r|CFFB32DE6a|r|CFFBC26E5T|r|CFFCB1EE3a|r|CFFDD14E0g|r |CFFFF006C&|r |CFFFF4C00T|r|CFFFF7300o|r|CFFFF9300o|r|CFFFFA800l|r|CFFFFC900s|r",
						},
					},
				},
				enable = {
					order = 3,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable Portraits"],
					width = "full",
					get = function()
						return E.db.mui.portraits.general.enable
					end,
					set = function(_, value)
						E.db.mui.portraits.general.enable = value
						module:Portraits()
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				spacer = {
					order = 4,
					type = "description",
					name = " ",
				},
				header_general = {
					order = 5,
					type = "group",
					name = L["General"],
					args = {
						class_icons = {
							order = 1,
							type = "group",
							inline = true,
							name = L["Class Icons"],
							args = {
								classicons = {
									order = 1,
									type = "toggle",
									name = L["Use Class Icons"],
									get = function()
										return E.db.mui.portraits.general.classicons
									end,
									set = function(_, value)
										E.db.mui.portraits.general.classicons = value
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
								-- classiconstyle = {
								-- order = 2,
								-- type = "select",
								-- name = L["Class Icons Style"],
								-- disabled = function()
								-- return not E.db.mui.portraits.general.classicons
								-- end,
								-- get = function()
								-- return E.db.mui.portraits.general.classiconstyle
								-- end,
								-- set = function(_, value)
								-- E.db.mui.portraits.general.classiconstyle = value
								-- module:Portraits(true)
								-- E:StaticPopup_Show("CONFIG_RL")
								-- end,
								-- values = ClassIconStyle,
								-- },
							},
						},
						gradient = {
							order = 2,
							type = "group",
							inline = true,
							name = L["Gradient"],
							args = {
								toggle_gradient = {
									order = 1,
									type = "toggle",
									name = L["Gradient"],
									get = function()
										return E.db.mui.portraits.general.gradient
									end,
									set = function(_, value)
										E.db.mui.portraits.general.gradient = value
										module:Portraits()
									end,
								},
								select_gradient = {
									order = 2,
									type = "select",
									name = L["Gradient Orientation"],
									disabled = function()
										return not E.db.mui.portraits.general.gradient
									end,
									get = function()
										return E.db.mui.portraits.general.ori
									end,
									set = function(_, value)
										E.db.mui.portraits.general.ori = value
										module:Portraits()
									end,
									values = {
										HORIZONTAL = "HORIZONTAL",
										VERTICAL = "VERTICAL",
									},
								},
								spacer_texture1 = {
									order = 3,
									type = "description",
									name = "\n\n",
								},
							},
						},
						misc = {
							order = 3,
							type = "group",
							inline = true,
							name = L["Misc"],
							args = {
								trilinear = {
									order = 1,
									type = "toggle",
									name = L["Trilinear Filtering"],
									get = function()
										return E.db.mui.portraits.general.trilinear
									end,
									set = function(_, value)
										E.db.mui.portraits.general.trilinear = value
										module:Portraits()
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
								desaturation = {
									order = 2,
									type = "toggle",
									name = L["Dead desaturation"],
									get = function()
										return E.db.mui.portraits.general.desaturation
									end,
									set = function(_, value)
										E.db.mui.portraits.general.desaturation = value
										module:Portraits()
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
							},
						},
					},
				},
				header_style = {
					order = 6,
					type = "group",
					name = L["Textures & Styles"],
					args = {
						header_portrait_texture = {
							order = 1,
							type = "group",
							name = L["Portrait Texture"],
							inline = true,
							args = {
								desc_note = {
									order = 1,
									type = "description",
									name = L["This works only with the mMT Textures for Portraits."],
								},
								select_style = {
									order = 2,
									type = "select",
									name = L["Texture Style"],
									get = function()
										return E.db.mui.portraits.general.style
									end,
									set = function(_, value)
										E.db.mui.portraits.general.style = value
										module:Portraits()
									end,
									values = style,
								},
								toggle_corner = {
									order = 3,
									type = "toggle",
									name = L["Enable Corner"],
									get = function()
										return E.db.mui.portraits.general.corner
									end,
									set = function(_, value)
										E.db.mui.portraits.general.corner = value
										module:Portraits()
									end,
								},
							},
						},
						header_rare_texture = {
							order = 2,
							type = "group",
							name = L["Extra Texture Style"],
							inline = true,
							args = {
								desc_note = {
									order = 1,
									type = "description",
									name = L["Info! These styles are only available for the new textures."],
								},
								desc_note2 = {
									order = 2,
									type = "description",
									name = L["This works only with the mMT Textures for Portraits."],
								},
								desc_space = {
									order = 3,
									type = "description",
									name = "\n\n",
								},
								select_style_rare = {
									order = 4,
									type = "select",
									name = L["Rare Texture Style"],
									get = function()
										return E.db.mui.portraits.extra.rare
									end,
									set = function(_, value)
										E.db.mui.portraits.extra.rare = value
										module:Portraits()
									end,
									values = extraStyle,
								},
								select_style_elite = {
									order = 5,
									type = "select",
									name = L["Elite/ Rare Elite Texture Style"],
									get = function()
										return E.db.mui.portraits.extra.elite
									end,
									set = function(_, value)
										E.db.mui.portraits.extra.elite = value
										module:Portraits()
									end,
									values = extraStyle,
								},
								select_style_boss = {
									order = 6,
									type = "select",
									name = L["Boss Texture Style"],
									get = function()
										return E.db.mui.portraits.extra.boss
									end,
									set = function(_, value)
										E.db.mui.portraits.extra.boss = value
										module:Portraits()
									end,
									values = extraStyle,
								},
								toggle_color = {
									order = 7,
									type = "toggle",
									name = L["Use Texture Color"],
									get = function()
										return E.db.mui.portraits.general.usetexturecolor
									end,
									set = function(_, value)
										E.db.mui.portraits.general.usetexturecolor = value
										module:Portraits()
									end,
								},
							},
						},
						header_bgtexture = {
							order = 4,
							type = "group",
							name = L["Background Texture"],
							inline = true,
							args = {
								select_texture = {
									order = 3,
									type = "select",
									name = L["Background Texture"],
									get = function()
										return E.db.mui.portraits.general.bgstyle
									end,
									set = function(_, value)
										E.db.mui.portraits.general.bgstyle = value
										module:Portraits()
									end,
									values = {
										[1] = L["Style"] .. " 1",
										[2] = L["Style"] .. " 2",
										[3] = L["Style"] .. " 3",
										[4] = L["Style"] .. " 4",
										[5] = L["Style"] .. " 5",
									},
								},
							},
						},
						custom = {
							order = 5,
							type = "group",
							name = L["Custom Portrait Textures"],
							inline = true,
							args = {
								toggle_enable = {
									order = 1,
									type = "toggle",
									name = L["Enable Custom Textures"],
									get = function()
										return E.db.mui.portraits.custom.enable
									end,
									set = function(_, value)
										E.db.mui.portraits.custom.enable = value
										module:Portraits()
									end,
								},
								spacer_texture1 = {
									order = 2,
									type = "description",
									name = "\n\n",
								},
								desc_important = {
									order = 3,
									type = "description",
									name = L["Info! To achieve an optimal result with the portraits, a texture should be set for the texture, border and mask.\nThe mask is always required and no portrait will be visible without it.\n\n"],
								},
								desc_note1 = {
									order = 4,
									type = "description",
									name = L["If your texture or the cutout for the portrait is not symmetrical in the middle, you need a 2nd mask texture, which must be exactly mirror-inverted. Use the 2nd mask texture for this."],
								},
								main = {
									order = 5,
									type = "group",
									name = L["Main Textures"],
									inline = true,
									args = {
										texture = {
											order = 1,
											desc = L["This is the main texture for the portraits."],
											name = function()
												if
													E.db.mui.portraits.custom.texture
													and (E.db.mui.portraits.custom.texture ~= "")
												then
													return L["Texture"]
														.. "  > "
														.. E:TextureString(
															E.db.mui.portraits.custom.texture,
															sizeString
														)
												else
													return L["Texture"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mui.portraits.custom.enable
											end,
											get = function()
												return E.db.mui.portraits.custom.texture
											end,
											set = function(_, value)
												E.db.mui.portraits.custom.texture = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
										mask = {
											order = 2,
											desc = L["This is the Mask texture for the portraits. This texture is used to cut out the portrait of the Unit."],
											name = function()
												if
													E.db.mui.portraits.custom.mask
													and (E.db.mui.portraits.custom.mask ~= "")
												then
													return L["Mask"]
														.. "  > "
														.. E:TextureString(E.db.mui.portraits.custom.mask, sizeString)
												else
													return L["Mask"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mui.portraits.custom.enable
											end,
											get = function()
												return E.db.mui.portraits.custom.mask
											end,
											set = function(_, value)
												E.db.mui.portraits.custom.mask = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
									},
								},
								desc_note2 = {
									order = 6,
									type = "description",
									name = L["Optional textures, these textures are not mandatory, but improve the appearance of the portraits."],
								},
								spacer_texture2 = {
									order = 7,
									type = "description",
									name = "\n\n",
								},
								optional = {
									order = 8,
									type = "group",
									name = L["Optional Textures"],
									inline = true,
									args = {
										border = {
											order = 1,
											desc = L["This is the Border texture for the portraits."],
											name = function()
												if
													E.db.mui.portraits.custom.border
													and (E.db.mui.portraits.custom.border ~= "")
												then
													return L["Border"]
														.. "  > "
														.. E:TextureString(E.db.mui.portraits.custom.border, sizeString)
												else
													return L["Border"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mui.portraits.custom.enable
											end,
											get = function()
												return E.db.mui.portraits.custom.border
											end,
											set = function(_, value)
												E.db.mui.portraits.custom.border = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
										shadow = {
											order = 2,
											desc = L["This is the shadow texture for the portraits."],
											name = function()
												if
													E.db.mui.portraits.custom.shadow
													and (E.db.mui.portraits.custom.shadow ~= "")
												then
													return L["Shadow"]
														.. "  > "
														.. E:TextureString(E.db.mui.portraits.custom.shadow, sizeString)
												else
													return L["Shadow"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mui.portraits.custom.enable
											end,
											get = function()
												return E.db.mui.portraits.custom.shadow
											end,
											set = function(_, value)
												E.db.mui.portraits.custom.shadow = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
										inner = {
											order = 3,
											desc = L["This is the inner shadow texture for the portraits."],
											name = function()
												if
													E.db.mui.portraits.custom.inner
													and (E.db.mui.portraits.custom.inner ~= "")
												then
													return L["Inner Shadow"]
														.. "  > "
														.. E:TextureString(E.db.mui.portraits.custom.inner, sizeString)
												else
													return L["Inner Shadow"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mui.portraits.custom.enable
											end,
											get = function()
												return E.db.mui.portraits.custom.inner
											end,
											set = function(_, value)
												E.db.mui.portraits.custom.inner = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
									},
								},
								rare = {
									order = 9,
									type = "group",
									name = L["Rare Textures"],
									inline = true,
									args = {
										rare = {
											order = 1,
											desc = L["This is the Rare texture for the portraits."],
											name = function()
												if
													E.db.mui.portraits.custom.extra
													and (E.db.mui.portraits.custom.extra ~= "")
												then
													return L["Rare"]
														.. "  > "
														.. E:TextureString(E.db.mui.portraits.custom.extra, sizeString)
												else
													return L["Rare"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mui.portraits.custom.enable
											end,
											get = function()
												return E.db.mui.portraits.custom.extra
											end,
											set = function(_, value)
												E.db.mui.portraits.custom.extra = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
										rare_border = {
											order = 2,
											desc = L["This is the Border texture for the Rare texture."],
											name = function()
												if
													E.db.mui.portraits.custom.extraborder
													and (E.db.mui.portraits.custom.extraborder ~= "")
												then
													return L["Rare - Border"]
														.. "  > "
														.. E:TextureString(
															E.db.mui.portraits.custom.extraborder,
															sizeString
														)
												else
													return L["Rare - Border"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mui.portraits.custom.enable
											end,
											get = function()
												return E.db.mui.portraits.custom.extraborder
											end,
											set = function(info, value)
												E.db.mui.portraits.custom.extraborder = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
										rare_shadow = {
											order = 3,
											desc = L["This is the shadow texture for the Rare texture."],
											name = function()
												if
													E.db.mui.portraits.custom.extrashadow
													and (E.db.mui.portraits.custom.extrashadow ~= "")
												then
													return L["Rare - Shadow"]
														.. "  > "
														.. E:TextureString(
															E.db.mui.portraits.custom.extrashadow,
															sizeString
														)
												else
													return L["Rare - Shadow"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mui.portraits.custom.enable
											end,
											get = function()
												return E.db.mui.portraits.custom.extrashadow
											end,
											set = function(_, value)
												E.db.mui.portraits.custom.extrashadow = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
									},
								},
								elite = {
									order = 10,
									type = "group",
									name = L["Elite Textures"],
									inline = true,
									args = {
										elite = {
											order = 1,
											desc = L["This is the Elite texture for the portraits."],
											name = function()
												if
													E.db.mui.portraits.custom.elite
													and (E.db.mui.portraits.custom.elite ~= "")
												then
													return L["Elite"]
														.. "  > "
														.. E:TextureString(E.db.mui.portraits.custom.elite, sizeString)
												else
													return L["Elite"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mui.portraits.custom.enable
											end,
											get = function()
												return E.db.mui.portraits.custom.elite
											end,
											set = function(_, value)
												E.db.mui.portraits.custom.elite = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
										elite_border = {
											order = 2,
											desc = L["This is the Border texture for the Elite texture."],
											name = function()
												if
													E.db.mui.portraits.custom.eliteborder
													and (E.db.mui.portraits.custom.eliteborder ~= "")
												then
													return L["Elite - Border"]
														.. "  > "
														.. E:TextureString(
															E.db.mui.portraits.custom.eliteborder,
															sizeString
														)
												else
													return L["Elite - Border"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mui.portraits.custom.enable
											end,
											get = function()
												return E.db.mui.portraits.custom.eliteborder
											end,
											set = function(_, value)
												E.db.mui.portraits.custom.eliteborder = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
										elite_shadow = {
											order = 3,
											desc = L["This is the shadow texture for the Elite texture."],
											name = function()
												if
													E.db.mui.portraits.custom.eliteshadow
													and (E.db.mui.portraits.custom.eliteshadow ~= "")
												then
													return L["Elite - Shadow"]
														.. "  > "
														.. E:TextureString(
															E.db.mui.portraits.custom.eliteshadow,
															sizeString
														)
												else
													return L["Elite - Shadow"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mui.portraits.custom.enable
											end,
											get = function()
												return E.db.mui.portraits.custom.eliteshadow
											end,
											set = function(_, value)
												E.db.mui.portraits.custom.eliteshadow = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
									},
								},
								boss = {
									order = 12,
									type = "group",
									name = L["Boss Textures"],
									inline = true,
									args = {
										rare = {
											order = 1,
											desc = L["This is the Boss texture for the portraits."],
											name = function()
												if
													E.db.mui.portraits.custom.boss
													and (E.db.mui.portraits.custom.boss ~= "")
												then
													return L["Boss"]
														.. "  > "
														.. E:TextureString(E.db.mui.portraits.custom.boss, sizeString)
												else
													return L["Boss"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mui.portraits.custom.enable
											end,
											get = function()
												return E.db.mui.portraits.custom.boss
											end,
											set = function(_, value)
												E.db.mui.portraits.custom.boss = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
										boss_border = {
											order = 2,
											desc = L["This is the Border texture for the Boss texture."],
											name = function()
												if
													E.db.mui.portraits.custom.bossborder
													and (E.db.mui.portraits.custom.bossborder ~= "")
												then
													return L["Boss - Border"]
														.. "  > "
														.. E:TextureString(
															E.db.mui.portraits.custom.bossborder,
															sizeString
														)
												else
													return L["Boss - Border"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mui.portraits.custom.enable
											end,
											get = function()
												return E.db.mui.portraits.custom.bossborder
											end,
											set = function(_, value)
												E.db.mui.portraits.custom.bossborder = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
										boss_shadow = {
											order = 3,
											desc = L["This is the shadow texture for the Boss texture."],
											name = function()
												if
													E.db.mui.portraits.custom.bossshadow
													and (E.db.mui.portraits.custom.bossshadow ~= "")
												then
													return L["Boss - Shadow"]
														.. "  > "
														.. E:TextureString(
															E.db.mui.portraits.custom.bossshadow,
															sizeString
														)
												else
													return L["Boss - Shadow"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mui.portraits.custom.enable
											end,
											get = function()
												return E.db.mui.portraits.custom.bossshadow
											end,
											set = function(_, value)
												E.db.mui.portraits.custom.bossshadow = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
									},
								},
								mask_b = {
									order = 13,
									type = "group",
									name = L["Second Mask Texture"],
									inline = true,
									args = {
										maskb = {
											order = 1,
											desc = L["This is the mirrored Mask texture for the portraits. This texture is used to cut out the portrait of the Unit."],
											name = function()
												if
													E.db.mui.portraits.custom.maskb
													and (E.db.mui.portraits.custom.maskb ~= "")
												then
													return L["Mirrored Mask"]
														.. "  > "
														.. E:TextureString(E.db.mui.portraits.custom.maskb, sizeString)
												elseif
													E.db.mui.portraits.custom.mask
													and (E.db.mui.portraits.custom.mask ~= "")
												then
													return L["Mirrored Mask"]
														.. "  > "
														.. E:TextureString(E.db.mui.portraits.custom.mask, sizeString)
												else
													return L["Mirrored Mask"] .. "  > " .. L["No Texture found"]
												end
											end,
											type = "input",
											width = "smal",
											disabled = function()
												return not E.db.mui.portraits.custom.enable
											end,
											get = function(_)
												return E.db.mui.portraits.custom.maskb
											end,
											set = function(_, value)
												E.db.mui.portraits.custom.maskb = value
												E:StaticPopup_Show("CONFIG_RL")
											end,
										},
									},
								},
							},
						},
					},
				},
				header_offset = {
					order = 7,
					type = "group",
					name = L["Portrait Offset/ Zoom"],
					args = {
						zoom = {
							order = 1,
							name = L["Zoom"],
							type = "range",
							min = 0,
							max = 5,
							step = 0.001,
							get = function()
								return E.db.mui.portraits.zoom
							end,
							set = function(_, value)
								E.db.mui.portraits.zoom = value
								module:Portraits()
							end,
						},
					},
				},
				header_player = {
					order = 8,
					type = "group",
					name = L["Player"],
					args = {
						toggle_enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							desc = L["Enable Player Portraits"],
							get = function()
								return E.db.mui.portraits.player.enable
							end,
							set = function(_, value)
								E.db.mui.portraits.player.enable = value
								module:Portraits()
							end,
						},
						general = {
							order = 2,
							type = "group",
							inline = true,
							name = L["General"],
							args = {
								select_style = {
									order = 1,
									type = "select",
									name = L["Texture Form"],
									get = function()
										return E.db.mui.portraits.player.texture
									end,
									set = function(_, value)
										E.db.mui.portraits.player.texture = value
										module:Portraits()
									end,
									values = form,
								},
								range_size = {
									order = 2,
									name = L["Size"],
									type = "range",
									min = 16,
									max = 512,
									step = 1,
									softMin = 16,
									softMax = 512,
									get = function()
										return E.db.mui.portraits.player.size
									end,
									set = function(_, value)
										E.db.mui.portraits.player.size = value
										module:Portraits()
									end,
								},
								toggle_cast = {
									order = 3,
									type = "toggle",
									name = L["Cast Icon"],
									desc = L["Enable Cast Icons"],
									get = function()
										return E.db.mui.portraits.player.cast
									end,
									set = function(_, value)
										E.db.mui.portraits.player.cast = value
										module:Portraits(true)
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
							},
						},
						anchor = {
							order = 3,
							type = "group",
							inline = true,
							name = L["Anchor"],
							args = {
								select_anchor = {
									order = 1,
									type = "select",
									name = L["Anchor Point"],
									get = function()
										return E.db.mui.portraits.player.relativePoint
									end,
									set = function(_, value)
										E.db.mui.portraits.player.relativePoint = value
										if value == "LEFT" then
											E.db.mui.portraits.player.point = "RIGHT"
											E.db.mui.portraits.player.mirror = false
										elseif value == "RIGHT" then
											E.db.mui.portraits.player.point = "LEFT"
											E.db.mui.portraits.player.mirror = true
										else
											E.db.mui.portraits.player.point = value
											E.db.mui.portraits.player.mirror = false
										end
										module:Portraits()
									end,
									values = {
										LEFT = "LEFT",
										RIGHT = "RIGHT",
										CENTER = "CENTER",
									},
								},
								range_ofsX = {
									order = 2,
									name = L["X offset"],
									type = "range",
									min = -256,
									max = 256,
									step = 1,
									softMin = -256,
									softMax = 256,
									get = function()
										return E.db.mui.portraits.player.x
									end,
									set = function(_, value)
										E.db.mui.portraits.player.x = value
										module:Portraits()
									end,
								},
								range_ofsY = {
									order = 3,
									name = L["Y offset"],
									type = "range",
									min = -256,
									max = 256,
									step = 1,
									softMin = -256,
									softMax = 256,
									get = function()
										return E.db.mui.portraits.player.y
									end,
									set = function(_, value)
										E.db.mui.portraits.player.y = value
										module:Portraits()
									end,
								},
							},
						},
						level = {
							order = 4,
							type = "group",
							inline = true,
							name = L["Frame Level"],
							args = {
								select_strata = {
									order = 1,
									type = "select",
									name = L["Frame Strata"],
									get = function()
										return E.db.mui.portraits.player.strata
									end,
									set = function(_, value)
										E.db.mui.portraits.player.strata = value
										module:Portraits()
									end,
									values = frameStrata,
								},
								range_level = {
									order = 2,
									name = L["Frame Level"],
									type = "range",
									min = 0,
									max = 1000,
									step = 1,
									softMin = 0,
									softMax = 1000,
									get = function()
										return E.db.mui.portraits.player.level
									end,
									set = function(_, value)
										E.db.mui.portraits.player.level = value
										module:Portraits()
									end,
								},
							},
						},
					},
				},
				header_target = {
					order = 9,
					type = "group",
					name = L["Target"],
					args = {
						toggle_enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							desc = L["Enable Target Portraits"],
							get = function()
								return E.db.mui.portraits.target.enable
							end,
							set = function(_, value)
								E.db.mui.portraits.target.enable = value
								module:Portraits()
							end,
						},
						general = {
							order = 2,
							type = "group",
							inline = true,
							name = L["General"],
							args = {
								select_style = {
									order = 1,
									type = "select",
									name = L["Texture Form"],
									get = function()
										return E.db.mui.portraits.target.texture
									end,
									set = function(_, value)
										E.db.mui.portraits.target.texture = value
										module:Portraits()
									end,
									values = form,
								},
								range_size = {
									order = 2,
									name = L["Size"],
									type = "range",
									min = 16,
									max = 512,
									step = 1,
									softMin = 16,
									softMax = 512,
									get = function()
										return E.db.mui.portraits.target.size
									end,
									set = function(_, value)
										E.db.mui.portraits.target.size = value
										module:Portraits()
									end,
								},
								toggle_extra = {
									order = 3,
									type = "toggle",
									name = L["Enable Rare/Elite Border"],
									get = function()
										return E.db.mui.portraits.target.extraEnable
									end,
									set = function(_, value)
										E.db.mui.portraits.target.extraEnable = value
										module:Portraits()
									end,
								},
								toggle_cast = {
									order = 4,
									type = "toggle",
									name = L["Cast Icon"],
									desc = L["Enable Cast Icons"],
									get = function()
										return E.db.mui.portraits.target.cast
									end,
									set = function(_, value)
										E.db.mui.portraits.target.cast = value
										module:Portraits(true)
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
							},
						},
						anchor = {
							order = 3,
							type = "group",
							inline = true,
							name = L["Anchor"],
							args = {
								select_anchor = {
									order = 1,
									type = "select",
									name = L["Anchor Point"],
									get = function()
										return E.db.mui.portraits.target.relativePoint
									end,
									set = function(_, value)
										E.db.mui.portraits.target.relativePoint = value
										if value == "LEFT" then
											E.db.mui.portraits.target.point = "RIGHT"
											E.db.mui.portraits.target.mirror = false
										elseif value == "RIGHT" then
											E.db.mui.portraits.target.point = "LEFT"
											E.db.mui.portraits.target.mirror = true
										else
											E.db.mui.portraits.target.point = value
											E.db.mui.portraits.target.mirror = false
										end
										module:Portraits()
									end,
									values = {
										LEFT = "LEFT",
										RIGHT = "RIGHT",
										CENTER = "CENTER",
									},
								},
								range_ofsX = {
									order = 2,
									name = L["X offset"],
									type = "range",
									min = -256,
									max = 256,
									step = 1,
									softMin = -256,
									softMax = 256,
									get = function()
										return E.db.mui.portraits.target.x
									end,
									set = function(_, value)
										E.db.mui.portraits.target.x = value
										module:Portraits()
									end,
								},
								range_ofsY = {
									order = 3,
									name = L["Y offset"],
									type = "range",
									min = -256,
									max = 256,
									step = 1,
									softMin = -256,
									softMax = 256,
									get = function()
										return E.db.mui.portraits.target.y
									end,
									set = function(_, value)
										E.db.mui.portraits.target.y = value
										module:Portraits()
									end,
								},
							},
						},
						level = {
							order = 4,
							type = "group",
							inline = true,
							name = L["Frame Level"],
							args = {
								select_strata = {
									order = 9,
									type = "select",
									name = L["Frame Strata"],
									get = function()
										return E.db.mui.portraits.target.strata
									end,
									set = function(_, value)
										E.db.mui.portraits.target.strata = value
										module:Portraits()
									end,
									values = frameStrata,
								},
								range_level = {
									order = 10,
									name = L["Frame Level"],
									type = "range",
									min = 0,
									max = 1000,
									step = 1,
									softMin = 0,
									softMax = 1000,
									get = function()
										return E.db.mui.portraits.target.level
									end,
									set = function(_, value)
										E.db.mui.portraits.target.level = value
										module:Portraits()
									end,
								},
							},
						},
					},
				},
				header_pet = {
					order = 10,
					type = "group",
					name = L["Pet"],
					args = {
						toggle_enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							desc = L["Enable Pet Portraits"],
							get = function()
								return E.db.mui.portraits.pet.enable
							end,
							set = function(_, value)
								E.db.mui.portraits.pet.enable = value
								module:Portraits()
							end,
						},
						general = {
							order = 2,
							type = "group",
							inline = true,
							name = L["General"],
							args = {
								select_style = {
									order = 1,
									type = "select",
									name = L["Texture Form"],
									get = function()
										return E.db.mui.portraits.pet.texture
									end,
									set = function(_, value)
										E.db.mui.portraits.pet.texture = value
										module:Portraits()
									end,
									values = form,
								},
								range_size = {
									order = 2,
									name = L["Size"],
									type = "range",
									min = 16,
									max = 512,
									step = 1,
									softMin = 16,
									softMax = 512,
									get = function()
										return E.db.mui.portraits.pet.size
									end,
									set = function(_, value)
										E.db.mui.portraits.pet.size = value
										module:Portraits()
									end,
								},
							},
						},
						anchor = {
							order = 3,
							type = "group",
							inline = true,
							name = L["Anchor"],
							args = {
								select_anchor = {
									order = 1,
									type = "select",
									name = L["Anchor Point"],
									get = function()
										return E.db.mui.portraits.pet.relativePoint
									end,
									set = function(_, value)
										E.db.mui.portraits.pet.relativePoint = value
										if value == "LEFT" then
											E.db.mui.portraits.pet.point = "RIGHT"
											E.db.mui.portraits.pet.mirror = false
										elseif value == "RIGHT" then
											E.db.mui.portraits.pet.point = "LEFT"
											E.db.mui.portraits.pet.mirror = true
										else
											E.db.mui.portraits.pet.point = value
											E.db.mui.portraits.pet.mirror = false
										end
										module:Portraits()
									end,
									values = {
										LEFT = "LEFT",
										RIGHT = "RIGHT",
										CENTER = "CENTER",
									},
								},
								range_ofsX = {
									order = 2,
									name = L["X offset"],
									type = "range",
									min = -256,
									max = 256,
									step = 1,
									softMin = -256,
									softMax = 256,
									get = function()
										return E.db.mui.portraits.pet.x
									end,
									set = function(_, value)
										E.db.mui.portraits.pet.x = value
										module:Portraits()
									end,
								},
								range_ofsY = {
									order = 3,
									name = L["Y offset"],
									type = "range",
									min = -256,
									max = 256,
									step = 1,
									softMin = -256,
									softMax = 256,
									get = function()
										return E.db.mui.portraits.pet.y
									end,
									set = function(_, value)
										E.db.mui.portraits.pet.y = value
										module:Portraits()
									end,
								},
							},
						},
						level = {
							order = 4,
							type = "group",
							inline = true,
							name = L["Frame Level"],
							args = {
								select_strata = {
									order = 1,
									type = "select",
									name = L["Frame Strata"],
									get = function()
										return E.db.mui.portraits.pet.strata
									end,
									set = function(_, value)
										E.db.mui.portraits.pet.strata = value
										module:Portraits()
									end,
									values = frameStrata,
								},
								range_level = {
									order = 2,
									name = L["Frame Level"],
									type = "range",
									min = 0,
									max = 1000,
									step = 1,
									softMin = 0,
									softMax = 1000,
									get = function()
										return E.db.mui.portraits.pet.level
									end,
									set = function(_, value)
										E.db.mui.portraits.pet.level = value
										module:Portraits()
									end,
								},
							},
						},
					},
				},
				header_shadow = {
					order = 11,
					type = "group",
					name = L["Shadow"],
					args = {
						shadow = {
							order = 0,
							type = "group",
							inline = true,
							name = L["Shadow"],
							args = {
								toggle_shadow = {
									order = 1,
									type = "toggle",
									name = L["Shadow"],
									desc = L["Enable Shadow"],
									get = function()
										return E.db.mui.portraits.shadow.enable
									end,
									set = function(_, value)
										E.db.mui.portraits.shadow.enable = value
										module:Portraits()
									end,
								},
								color_shadow = {
									type = "color",
									order = 2,
									name = L["Shadow Color"],
									hasAlpha = true,
									get = function()
										local t = E.db.mui.portraits.shadow.color
										return t.r, t.g, t.b, t.a
									end,
									set = function(_, r, g, b, a)
										local t = E.db.mui.portraits.shadow.color
										t.r, t.g, t.b, t.a = r, g, b, a
										module:Portraits()
									end,
								},
							},
						},
						innershadow = {
							order = 3,
							type = "group",
							inline = true,
							name = L["Inner Shadow"],
							args = {
								toggle_inner = {
									order = 4,
									type = "toggle",
									name = L["Inner Shadow"],
									desc = L["Enable Inner Shadow"],
									get = function()
										return E.db.mui.portraits.shadow.inner
									end,
									set = function(_, value)
										E.db.mui.portraits.shadow.inner = value
										module:Portraits()
									end,
								},
								color_inner = {
									type = "color",
									order = 5,
									name = L["Inner Shadow Color"],
									hasAlpha = true,
									get = function()
										local t = E.db.mui.portraits.shadow.innerColor
										return t.r, t.g, t.b, t.a
									end,
									set = function(_, r, g, b, a)
										local t = E.db.mui.portraits.shadow.innerColor
										t.r, t.g, t.b, t.a = r, g, b, a
										module:Portraits()
									end,
								},
							},
						},
					},
				},
				header_colors = {
					order = 12,
					type = "group",
					name = L["Colors"],
					args = {
						settings = {
							order = 1,
							type = "group",
							inline = true,
							name = L["Settings"],
							args = {
								execute_apply = {
									order = 1,
									type = "execute",
									name = L["Apply"],
									func = function()
										module:Portraits()
									end,
								},
								toggle_default = {
									order = 2,
									type = "toggle",
									name = L["Use only Default Color"],
									desc = L["Uses for every Unit the Default Color."],
									get = function()
										return E.db.mui.portraits.general.default
									end,
									set = function(_, value)
										E.db.mui.portraits.general.default = value
										module:Portraits()
									end,
								},
								toggle_reaction = {
									order = 3,
									type = "toggle",
									name = L["Force reaction color"],
									desc = L["Forces reaction color for all Units."],
									get = function()
										return E.db.mui.portraits.general.reaction
									end,
									set = function(_, value)
										E.db.mui.portraits.general.reaction = value
										module:Portraits()
									end,
								},
							},
						},
						general_colors = {
							order = 2,
							type = "group",
							name = L["General"],
							args = {
								default = {
									order = 1,
									type = "group",
									inline = true,
									name = L["Deafault"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.default.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.default.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.default.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.default.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
							},
						},
						class_colors = {
							order = 3,
							type = "group",
							name = L["Class"],
							args = {
								DEATHKNIGHT = {
									order = 3,
									type = "group",
									inline = true,
									name = L["DEATHKNIGHT"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.DEATHKNIGHT.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.DEATHKNIGHT.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.DEATHKNIGHT.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.DEATHKNIGHT.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
								DEMONHUNTER = {
									order = 4,
									type = "group",
									inline = true,
									name = L["DEMONHUNTER"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.DEMONHUNTER.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.DEMONHUNTER.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.DEMONHUNTER.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.DEMONHUNTER.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
								DRUID = {
									order = 5,
									type = "group",
									inline = true,
									name = L["DRUID"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.DRUID.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.DRUID.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.DRUID.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.DRUID.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
								EVOKER = {
									order = 6,
									type = "group",
									inline = true,
									name = L["EVOKER"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.EVOKER.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.EVOKER.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.EVOKER.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.EVOKER.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
								HUNTER = {
									order = 7,
									type = "group",
									inline = true,
									name = L["HUNTER"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.HUNTER.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.HUNTER.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.HUNTER.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.HUNTER.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
								MAGE = {
									order = 8,
									type = "group",
									inline = true,
									name = L["MAGE"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.MAGE.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.MAGE.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.MAGE.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.MAGE.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
								MONK = {
									order = 9,
									type = "group",
									inline = true,
									name = L["MONK"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.MONK.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.MONK.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.MONK.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.MONK.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
								PALADIN = {
									order = 10,
									type = "group",
									inline = true,
									name = L["PALADIN"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.PALADIN.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.PALADIN.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.PALADIN.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.PALADIN.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
								PRIEST = {
									order = 11,
									type = "group",
									inline = true,
									name = L["PRIEST"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.PRIEST.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.PRIEST.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.PRIEST.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.PRIEST.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
								ROGUE = {
									order = 12,
									type = "group",
									inline = true,
									name = L["ROGUE"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.ROGUE.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.ROGUE.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.ROGUE.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.ROGUE.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
								SHAMAN = {
									order = 13,
									type = "group",
									inline = true,
									name = L["SHAMAN"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.SHAMAN.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.SHAMAN.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.SHAMAN.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.SHAMAN.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
								WARLOCK = {
									order = 14,
									type = "group",
									inline = true,
									name = L["WARLOCK"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.WARLOCK.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.WARLOCK.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.WARLOCK.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.WARLOCK.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
								WARRIOR = {
									order = 15,
									type = "group",
									inline = true,
									name = L["WARRIOR"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.WARRIOR.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.WARRIOR.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.WARRIOR.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.WARRIOR.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
							},
						},
						clasification_colors = {
							order = 4,
							type = "group",
							name = L["Clasification"],
							args = {
								rare = {
									order = 17,
									type = "group",
									inline = true,
									name = L["RARE"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.rare.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.rare.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.rare.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.rare.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
								rareelite = {
									order = 18,
									type = "group",
									inline = true,
									name = L["RARE ELITE"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.rareelite.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.rareelite.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.rareelite.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.rareelite.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
								elite = {
									order = 19,
									type = "group",
									inline = true,
									name = L["ELITE"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.elite.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.elite.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.elite.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.elite.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
								boss = {
									order = 20,
									type = "group",
									inline = true,
									name = L["Boss"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.boss.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.boss.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.boss.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.boss.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
							},
						},
						reaction_colors = {
							order = 5,
							type = "group",
							name = L["Reaction"],
							args = {
								enemy = {
									order = 21,
									type = "group",
									inline = true,
									name = L["ENEMY"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.enemy.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.enemy.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.enemy.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.enemy.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
								neutral = {
									order = 22,
									type = "group",
									inline = true,
									name = L["NEUTRAL"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.neutral.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.neutral.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.neutral.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.neutral.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
								friendly = {
									order = 23,
									type = "group",
									inline = true,
									name = L["FRIENDLY"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.friendly.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.friendly.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.friendly.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.friendly.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
							},
						},
						death_colors = {
							order = 6,
							type = "group",
							name = L["Death"],
							args = {
								toggle_death = {
									order = 1,
									type = "toggle",
									name = L["Enable"],
									desc = L["Enable Death color"],
									get = function()
										return E.db.mui.portraits.general.deathcolor
									end,
									set = function(_, value)
										E.db.mui.portraits.general.deathcolor = value
										module:Portraits()
									end,
								},
								dead_color = {
									order = 2,
									type = "group",
									inline = true,
									name = L["Death"],
									args = {
										color_a = {
											type = "color",
											order = 1,
											name = "A",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.death.a
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.death.a
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_b = {
											type = "color",
											order = 2,
											name = "B",
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.death.b
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.death.b
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
							},
						},
						border_colors = {
							order = 7,
							type = "group",
							name = L["Border"],
							args = {
								toggle_border = {
									order = 1,
									type = "toggle",
									name = L["Border"],
									desc = L["Enable Borders"],
									get = function()
										return E.db.mui.portraits.shadow.border
									end,
									set = function(_, value)
										E.db.mui.portraits.shadow.border = value
										module:Portraits()
									end,
								},
								default_color = {
									order = 2,
									type = "group",
									inline = true,
									name = L["Default"],
									args = {
										color_default = {
											type = "color",
											order = 2,
											name = L["Default"],
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.border.default
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.border.default
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
								classification_color = {
									order = 3,
									type = "group",
									inline = true,
									name = L["Classification"],
									args = {
										color_rare = {
											type = "color",
											order = 1,
											name = L["Rare"],
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.border.rare
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.border.rare
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_elite = {
											type = "color",
											order = 2,
											name = L["Elite"],
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.border.elite
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.border.elite
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_rareelite = {
											type = "color",
											order = 3,
											name = L["Rare Elite"],
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.border.rareelite
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.border.rareelite
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
										color_boss = {
											type = "color",
											order = 4,
											name = L["Boss"],
											hasAlpha = true,
											get = function()
												local t = E.db.mui.portraits.colors.border.boss
												return t.r, t.g, t.b, t.a
											end,
											set = function(_, r, g, b, a)
												local t = E.db.mui.portraits.colors.border.boss
												t.r, t.g, t.b, t.a = r, g, b, a
											end,
										},
									},
								},
							},
						},
						background_colors = {
							order = 8,
							type = "group",
							name = L["Background"],
							args = {
								color_background = {
									type = "color",
									order = 11,
									name = L["Background color for Icons"],
									hasAlpha = true,
									get = function()
										local t = E.db.mui.portraits.shadow.background
										return t.r, t.g, t.b, t.a
									end,
									set = function(_, r, g, b, a)
										local t = E.db.mui.portraits.shadow.background
										t.r, t.g, t.b, t.a = r, g, b, a
										module:Portraits()
									end,
								},
								toggle_classbg = {
									order = 12,
									type = "toggle",
									name = L["Class colored Background"],
									desc = L["Enable Class colored Background"],
									get = function()
										return E.db.mui.portraits.shadow.classBG
									end,
									set = function(_, value)
										E.db.mui.portraits.shadow.classBG = value
										module:Portraits()
									end,
								},
								range_bgColorShift = {
									order = 14,
									name = L["Background color shift"],
									type = "range",
									min = 0,
									max = 1,
									step = 0.01,
									softMin = 0,
									softMax = 1,
									get = function()
										return E.db.mui.portraits.shadow.bgColorShift
									end,
									set = function(_, value)
										E.db.mui.portraits.shadow.bgColorShift = value
										module:Portraits()
									end,
								},
							},
						},
					},
				},
			},
		},
	},
}
