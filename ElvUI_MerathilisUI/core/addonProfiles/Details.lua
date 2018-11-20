local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
local twipe = table.wipe
--WoW API / Variables
local ReloadUI = ReloadUI
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: _detalhes_global, _detalhes

function MER:LoadDetailsProfile()
	--[[----------------------------------
	--	Details - Settings
	--]]----------------------------------
	if _detalhes_global then twipe(_detalhes_global) end
	_detalhes_global = {
	["__profiles"] = {
		["MerathilisUI"] = {
			["show_arena_role_icon"] = false,
			["capture_real"] = {
				["heal"] = true,
				["spellcast"] = true,
				["miscdata"] = true,
				["aura"] = true,
				["energy"] = true,
				["damage"] = true,
			},
			["row_fade_in"] = {
				"in", -- [1]
				0.2, -- [2]
			},
			["player_details_window"] = {
				["scale"] = 1,
				["bar_texture"] = "Skyline",
				["skin"] = "ElvUI",
			},
			["numerical_system"] = 1,
			["use_row_animations"] = true,
			["report_heal_links"] = false,
			["remove_realm_from_name"] = true,
			["minimum_overall_combat_time"] = 10,
			["class_icons_small"] = "Interface\\AddOns\\Details\\images\\classes_small",
			["report_to_who"] = "",
			["overall_flag"] = 16,
			["profile_save_pos"] = true,
			["tooltip"] = {
				["header_statusbar"] = {
					0.3, -- [1]
					0.3, -- [2]
					0.3, -- [3]
					0.8, -- [4]
					false, -- [5]
					false, -- [6]
					"WorldState Score", -- [7]
				},
				["fontcolor_right"] = {
					1, -- [1]
					0.7, -- [2]
					0, -- [3]
					1, -- [4]
				},
				["tooltip_max_targets"] = 2,
				["icon_size"] = {
					["W"] = 16,
					["H"] = 16,
				},
				["tooltip_max_pets"] = 2,
				["anchor_relative"] = "top",
				["abbreviation"] = 2,
				["anchored_to"] = 1,
				["show_amount"] = false,
				["header_text_color"] = {
					1, -- [1]
					0.9176, -- [2]
					0, -- [3]
					1, -- [4]
				},
				["fontsize"] = 11,
				["background"] = {
					0.196, -- [1]
					0.196, -- [2]
					0.196, -- [3]
					0.8, -- [4]
				},
				["submenu_wallpaper"] = true,
				["fontsize_title"] = 10,
				["icon_border_texcoord"] = {
					["B"] = 0.921875,
					["L"] = 0.078125,
					["T"] = 0.078125,
					["R"] = 0.921875,
				},
				["commands"] = {
				},
				["tooltip_max_abilities"] = 6,
				["fontface"] = "Expressway",
				["border_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					0, -- [4]
				},
				["border_texture"] = "Blizzard Tooltip",
				["anchor_offset"] = {
					0, -- [1]
					0, -- [2]
				},
				["fontshadow"] = false,
				["menus_bg_texture"] = "Interface\\SPELLBOOK\\Spellbook-Page-1",
				["border_size"] = 16,
				["maximize_method"] = 1,
				["anchor_screen_pos"] = {
					507.7, -- [1]
					-350.5, -- [2]
				},
				["anchor_point"] = "bottom",
				["menus_bg_coords"] = {
					0.309777336120606, -- [1]
					0.924000015258789, -- [2]
					0.213000011444092, -- [3]
					0.279000015258789, -- [4]
				},
				["fontcolor"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					1, -- [4]
				},
				["menus_bg_color"] = {
					0.8, -- [1]
					0.8, -- [2]
					0.8, -- [3]
					0.2, -- [4]
				},
			},
			["ps_abbreviation"] = 3,
			["world_combat_is_trash"] = false,
			["update_speed"] = 0.300000011920929,
			["bookmark_text_size"] = 11,
			["animation_speed_mintravel"] = 0.45,
			["track_item_level"] = false,
			["windows_fade_in"] = {
				"in", -- [1]
				0.2, -- [2]
			},
			["instances_menu_click_to_open"] = false,
			["overall_clear_newchallenge"] = true,
			["time_type"] = 2,
			["data_cleanup_logout"] = false,
			["instances_disable_bar_highlight"] = false,
			["trash_concatenate"] = false,
			["color_by_arena_team"] = true,
			["animation_speed"] = 33,
			["disable_stretch_from_toolbar"] = false,
			["disable_lock_ungroup_buttons"] = true,
			["memory_ram"] = 64,
			["disable_window_groups"] = false,
			["instances_suppress_trash"] = 0,
			["options_window"] = {
				["scale"] = 1,
			},
			["animation_speed_maxtravel"] = 3,
			["use_battleground_server_parser"] = true,
			["default_bg_alpha"] = 0.5,
			["font_faces"] = {
				["menus"] = "Expressway",
			},
			["clear_ungrouped"] = true,
			["segments_amount"] = 12,
			["animate_scroll"] = false,
			["instances"] = {
				{
					["__snapV"] = false,
					["__pos"] = {
						["normal"] = {
							["y"] = -439.794867395035,
							["x"] = 652.185102372618,
							["w"] = 260.999908447266,
							["h"] = 100.999984741211,
						},
						["solo"] = {
							["y"] = 2,
							["x"] = 1,
							["w"] = 300,
							["h"] = 200,
						},
					},
					["hide_in_combat_type"] = 1,
					["menu_icons_size"] = 0.899999976158142,
					["color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						0, -- [4]
					},
					["menu_anchor"] = {
						17, -- [1]
						2, -- [2]
						["side"] = 2,
					},
					["__snapH"] = false,
					["micro_displays_locked"] = true,
					["bg_r"] = 0.517647058823529,
					["instance_button_anchor"] = {
						-27, -- [1]
						1, -- [2]
					},
					["__was_opened"] = true,
					["hide_out_of_combat"] = false,
					["switch_healer_in_combat"] = false,
					["following"] = {
						["enabled"] = true,
						["bar_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["text_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
					},
					["color_buttons"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						1, -- [4]
					},
					["switch_healer"] = false,
					["skin_custom"] = "",
					["skin"] = "ElvUI Style II",
					["total_bar"] = {
						["enabled"] = false,
						["only_in_group"] = true,
						["icon"] = "Interface\\ICONS\\INV_Sigil_Thorim",
						["color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
					},
					["grab_on_top"] = true,
					["bars_grow_direction"] = 1,
					["tooltip"] = {
						["n_abilities"] = 3,
						["n_enemies"] = 3,
					},
					["StatusBarSaved"] = {
						["center"] = "DETAILS_STATUSBAR_PLUGIN_PDPS",
						["right"] = "DETAILS_STATUSBAR_PLUGIN_PSEGMENT",
						["options"] = {
							["DETAILS_STATUSBAR_PLUGIN_PDPS"] = {
								["isHidden"] = false,
								["textStyle"] = 2,
								["textYMod"] = 1,
								["textFace"] = "Expressway",
								["textXMod"] = 6,
								["timeType"] = 1,
								["textAlign"] = 0,
								["textSize"] = 11,
								["textColor"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
									1, -- [4]
								},
							},
							["DETAILS_STATUSBAR_PLUGIN_PSEGMENT"] = {
								["isHidden"] = true,
								["textStyle"] = 2,
								["textYMod"] = 1,
								["segmentType"] = 2,
								["textFace"] = "Expressway",
								["textXMod"] = 0,
								["textAlign"] = 0,
								["textSize"] = 11,
								["textColor"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
									1, -- [4]
								},
							},
							["DETAILS_STATUSBAR_PLUGIN_CLOCK"] = {
								["isHidden"] = false,
								["timeType"] = 1,
								["textYMod"] = 1,
								["segmentType"] = 2,
								["textXMod"] = 6,
								["textStyle"] = 2,
								["textFace"] = "Expressway",
								["textAlign"] = 3,
								["textSize"] = 11,
								["textColor"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
									1, -- [4]
								},
							},
						},
						["left"] = "DETAILS_STATUSBAR_PLUGIN_CLOCK",
					},
					["show_sidebars"] = false,
					["switch_all_roles_in_combat"] = false,
					["switch_tank_in_combat"] = false,
					["version"] = 3,
					["attribute_text"] = {
						["show_timer"] = {
							true, -- [1]
							true, -- [2]
							true, -- [3]
						},
						["shadow"] = true,
						["side"] = 1,
						["text_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
							0.7, -- [4]
						},
						["custom_text"] = "{name}",
						["text_face"] = "Expressway",
						["anchor"] = {
							-18, -- [1]
							5, -- [2]
						},
						["text_size"] = 9,
						["enable_custom_text"] = false,
						["enabled"] = false,
					},
					["__locked"] = true,
					["menu_alpha"] = {
						["enabled"] = false,
						["onenter"] = 1,
						["iconstoo"] = true,
						["ignorebars"] = false,
						["onleave"] = 1,
					},
					["toolbar_icon_file"] = "Interface\\AddOns\\Details\\images\\toolbar_icons",
					["menu_anchor_down"] = {
						16, -- [1]
						-2, -- [2]
					},
					["statusbar_info"] = {
						["alpha"] = 0,
						["overlay"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
					},
					["strata"] = "LOW",
					["bars_inverted"] = false,
					["__snap"] = {
					},
					["ignore_mass_showhide"] = false,
					["hide_in_combat_alpha"] = 0,
					["plugins_grow_direction"] = 1,
					["menu_icons"] = {
						true, -- [1]
						true, -- [2]
						true, -- [3]
						true, -- [4]
						true, -- [5]
						false, -- [6]
						["space"] = -2,
						["shadow"] = true,
					},
					["libwindow"] = {
						["y"] = 50.2100825759626,
						["x"] = -178.619953928283,
						["point"] = "BOTTOMRIGHT",
						["scale"] = 0.990000009536743,
					},
					["auto_hide_menu"] = {
						["left"] = false,
						["right"] = false,
					},
					["micro_displays_side"] = 1,
					["window_scale"] = 0.990000009536743,
					["switch_all_roles_after_wipe"] = false,
					["switch_tank"] = false,
					["row_info"] = {
						["textR_outline"] = true,
						["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal_alpha",
						["textL_outline"] = true,
						["textR_outline_small"] = false,
						["textR_show_data"] = {
							true, -- [1]
							true, -- [2]
							true, -- [3]
						},
						["percent_type"] = 1,
						["fixed_text_color"] = {
							0.905882352941177, -- [1]
							0.905882352941177, -- [2]
							0.905882352941177, -- [3]
							1, -- [4]
						},
						["space"] = {
							["right_noborder"] = -3,
							["right"] = -3,
							["left_noborder"] = 1,
							["left"] = 1,
							["between"] = 0,
						},
						["texture_background_class_color"] = false,
						["start_after_icon"] = true,
						["font_face_file"] = "Interface\\AddOns\\ElvUI\\media\\fonts\\Expressway.ttf",
						["textL_custom_text"] = "{data1}. {data3}",
						["font_size"] = 12,
						["texture_custom_file"] = "Interface\\",
						["texture_file"] = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\lyn1.tga",
						["use_spec_icons"] = true,
						["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small",
						["icon_grayscale"] = false,
						["models"] = {
							["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
							["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
							["upper_alpha"] = 0.5,
							["lower_enabled"] = false,
							["lower_alpha"] = 0.1,
							["upper_enabled"] = false,
						},
						["textR_bracket"] = "(",
						["texture_custom"] = "",
						["backdrop"] = {
							["enabled"] = false,
							["size"] = 1,
							["color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
								1, -- [4]
							},
							["texture"] = "Details BarBorder 1",
						},
						["fixed_texture_color"] = {
							0.862745098039216, -- [1]
							0.862745098039216, -- [2]
							0.862745098039216, -- [3]
							1, -- [4]
						},
						["textL_show_number"] = false,
						["texture"] = "Lyn1",
						["textR_enable_custom_text"] = true,
						["textR_custom_text"] = "{data1} ({data2})",
						["fixed_texture_background_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							0.295484036207199, -- [4]
						},
						["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
						["textL_outline_small_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							1, -- [4]
						},
						["textL_class_colors"] = false,
						["textR_class_colors"] = false,
						["textR_outline_small_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							1, -- [4]
						},
						["texture_background"] = "MerathilisEmpty",
						["alpha"] = 1,
						["no_icon"] = false,
						["texture_background_file"] = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\Empty.tga",
						["textL_enable_custom_text"] = false,
						["font_face"] = "Expressway",
						["texture_class_colors"] = true,
						["textL_outline_small"] = false,
						["fast_ps_update"] = true,
						["textR_separator"] = ",",
						["height"] = 20,
					},
					["switch_damager_in_combat"] = false,
					["bg_alpha"] = 0,
					["bars_sort_direction"] = 1,
					["auto_current"] = true,
					["toolbar_side"] = 1,
					["bg_g"] = 0.517647058823529,
					["desaturated_menu"] = true,
					["hide_in_combat"] = false,
					["posicao"] = {
						["normal"] = {
							["y"] = -439.794867395035,
							["x"] = 652.185102372618,
							["w"] = 260.999908447266,
							["h"] = 100.999984741211,
						},
						["solo"] = {
							["y"] = 2,
							["x"] = 1,
							["w"] = 300,
							["h"] = 200,
						},
					},
					["show_statusbar"] = false,
					["backdrop_texture"] = "None",
					["wallpaper"] = {
						["enabled"] = false,
						["texture"] = "Interface\\AddOns\\Details\\images\\skins\\elvui",
						["texcoord"] = {
							0.0480000019073486, -- [1]
							0.298000011444092, -- [2]
							0.630999984741211, -- [3]
							0.755999984741211, -- [4]
						},
						["overlay"] = {
							0.999997794628143, -- [1]
							0.999997794628143, -- [2]
							0.999997794628143, -- [3]
							0.799998223781586, -- [4]
						},
						["anchor"] = "all",
						["height"] = 226.000007591173,
						["alpha"] = 0.800000071525574,
						["width"] = 265.999979475717,
					},
					["stretch_button_side"] = 1,
					["row_show_animation"] = {
						["anim"] = "Fade",
						["options"] = {
						},
					},
					["hide_icon"] = true,
					["switch_damager"] = false,
					["bg_b"] = 0.517647058823529,
				}, -- [1]
			},
			["report_lines"] = 5,
			["pvp_as_group"] = true,
			["windows_fade_out"] = {
				"out", -- [1]
				0.2, -- [2]
			},
			["skin"] = "WoW Interface",
			["override_spellids"] = true,
			["death_tooltip_width"] = 350,
			["force_activity_time_pvp"] = true,
			["instances_no_libwindow"] = false,
			["overall_clear_logout"] = false,
			["minimum_combat_time"] = 5,
			["chat_tab_embed"] = {
				["enabled"] = true,
				["y_offset"] = 0,
				["x_offset"] = 0,
				["single_window"] = false,
				["tab_name"] = "",
				["w1_pos"] = {
					["y"] = 5.30014763215718,
					["x"] = -163.749771900271,
					["point"] = "BOTTOMRIGHT",
					["h"] = 110.000007629395,
					["x_legacy"] = 660.620163157818,
					["y_legacy"] = -480.249790321906,
					["w"] = 273.999908447266,
					["pos_table"] = true,
				},
			},
			["cloud_capture"] = true,
			["damage_taken_everything"] = false,
			["scroll_speed"] = 2,
			["new_window_size"] = {
				["height"] = 130,
				["width"] = 320,
			},
			["memory_threshold"] = 3,
			["deadlog_events"] = 32,
			["default_bg_color"] = 0.0941,
			["close_shields"] = false,
			["class_coords"] = {
				["HUNTER"] = {
					0, -- [1]
					0.25, -- [2]
					0.25, -- [3]
					0.5, -- [4]
				},
				["WARRIOR"] = {
					0, -- [1]
					0.25, -- [2]
					0, -- [3]
					0.25, -- [4]
				},
				["ROGUE"] = {
					0.49609375, -- [1]
					0.7421875, -- [2]
					0, -- [3]
					0.25, -- [4]
				},
				["MAGE"] = {
					0.25, -- [1]
					0.49609375, -- [2]
					0, -- [3]
					0.25, -- [4]
				},
				["PET"] = {
					0.25, -- [1]
					0.49609375, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["DRUID"] = {
					0.7421875, -- [1]
					0.98828125, -- [2]
					0, -- [3]
					0.25, -- [4]
				},
				["MONK"] = {
					0.5, -- [1]
					0.73828125, -- [2]
					0.5, -- [3]
					0.75, -- [4]
				},
				["DEATHKNIGHT"] = {
					0.25, -- [1]
					0.5, -- [2]
					0.5, -- [3]
					0.75, -- [4]
				},
				["MONSTER"] = {
					0, -- [1]
					0.25, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["UNKNOW"] = {
					0.5, -- [1]
					0.75, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["PRIEST"] = {
					0.49609375, -- [1]
					0.7421875, -- [2]
					0.25, -- [3]
					0.5, -- [4]
				},
				["SHAMAN"] = {
					0.25, -- [1]
					0.49609375, -- [2]
					0.25, -- [3]
					0.5, -- [4]
				},
				["Alliance"] = {
					0.49609375, -- [1]
					0.7421875, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["ENEMY"] = {
					0, -- [1]
					0.25, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["DEMONHUNTER"] = {
					0.73828126, -- [1]
					1, -- [2]
					0.5, -- [3]
					0.75, -- [4]
				},
				["Horde"] = {
					0.7421875, -- [1]
					0.98828125, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["PALADIN"] = {
					0, -- [1]
					0.25, -- [2]
					0.5, -- [3]
					0.75, -- [4]
				},
				["UNGROUPPLAYER"] = {
					0.5, -- [1]
					0.75, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["WARLOCK"] = {
					0.7421875, -- [1]
					0.98828125, -- [2]
					0.25, -- [3]
					0.5, -- [4]
				},
			},
			["numerical_system_symbols"] = "auto",
			["disable_alldisplays_window"] = false,
			["standard_skin"] = {
				["hide_in_combat_type"] = 1,
				["backdrop_texture"] = "Details Ground",
				["color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					1, -- [4]
				},
				["menu_anchor"] = {
					16, -- [1]
					2, -- [2]
					["side"] = 2,
				},
				["bg_r"] = 0.3294,
				["skin"] = "ElvUI Frame Style",
				["following"] = {
					["bar_color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
					},
					["enabled"] = false,
					["text_color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
					},
				},
				["color_buttons"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					1, -- [4]
				},
				["switch_healer"] = false,
				["micro_displays_locked"] = true,
				["bg_b"] = 0.3294,
				["tooltip"] = {
					["n_abilities"] = 3,
					["n_enemies"] = 3,
				},
				["desaturated_menu"] = false,
				["switch_tank_in_combat"] = false,
				["switch_all_roles_in_combat"] = false,
				["instance_button_anchor"] = {
					-27, -- [1]
					1, -- [2]
				},
				["bg_alpha"] = 0.51,
				["attribute_text"] = {
					["enabled"] = true,
					["shadow"] = true,
					["side"] = 1,
					["text_color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						0.7, -- [4]
					},
					["custom_text"] = "{name}",
					["text_face"] = "FORCED SQUARE",
					["anchor"] = {
						-19, -- [1]
						5, -- [2]
					},
					["show_timer"] = {
						true, -- [1]
						true, -- [2]
						true, -- [3]
					},
					["enable_custom_text"] = false,
					["text_size"] = 12,
				},
				["switch_damager"] = false,
				["menu_alpha"] = {
					["enabled"] = false,
					["onleave"] = 1,
					["ignorebars"] = false,
					["iconstoo"] = true,
					["onenter"] = 1,
				},
				["stretch_button_side"] = 1,
				["statusbar_info"] = {
					["alpha"] = 1,
					["overlay"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
					},
				},
				["switch_healer_in_combat"] = false,
				["strata"] = "LOW",
				["show_statusbar"] = false,
				["micro_displays_side"] = 2,
				["switch_tank"] = false,
				["hide_in_combat_alpha"] = 0,
				["plugins_grow_direction"] = 1,
				["menu_icons"] = {
					true, -- [1]
					true, -- [2]
					true, -- [3]
					true, -- [4]
					true, -- [5]
					false, -- [6]
					["space"] = -2,
					["shadow"] = false,
				},
				["libwindow"] = {
				},
				["auto_hide_menu"] = {
					["left"] = false,
					["right"] = false,
				},
				["window_scale"] = 1,
				["bars_grow_direction"] = 1,
				["row_info"] = {
					["textR_outline"] = false,
					["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
					["textL_outline"] = false,
					["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
					["textL_outline_small"] = true,
					["textL_enable_custom_text"] = false,
					["fixed_text_color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
					},
					["space"] = {
						["right"] = 0,
						["left"] = 1,
						["between"] = 1,
					},
					["texture_background_class_color"] = false,
					["start_after_icon"] = false,
					["font_face_file"] = "Interface\\Addons\\Details\\fonts\\FORCED SQUARE.ttf",
					["textL_custom_text"] = "{data1}. {data3}{data2}",
					["font_size"] = 10,
					["height"] = 14,
					["texture_file"] = "Interface\\AddOns\\Details\\images\\bar_skyline",
					["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small_alpha",
					["texture_custom_file"] = "Interface\\",
					["texture_background_file"] = "Interface\\AddOns\\Details\\images\\bar_background",
					["use_spec_icons"] = true,
					["textR_enable_custom_text"] = false,
					["models"] = {
						["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
						["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
						["upper_alpha"] = 0.5,
						["lower_enabled"] = false,
						["lower_alpha"] = 0.1,
						["upper_enabled"] = false,
					},
					["fixed_texture_color"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
					},
					["textL_show_number"] = true,
					["fixed_texture_background_color"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						0.339636147022247, -- [4]
					},
					["textR_show_data"] = {
						true, -- [1]
						true, -- [2]
						true, -- [3]
					},
					["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
					["texture"] = "Skyline",
					["textR_outline_small"] = true,
					["backdrop"] = {
						["enabled"] = false,
						["texture"] = "Details BarBorder 2",
						["color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							1, -- [4]
						},
						["size"] = 4,
					},
					["percent_type"] = 1,
					["texture_background"] = "DGround",
					["alpha"] = 0.8,
					["textR_class_colors"] = false,
					["textR_outline_small_color"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
					["no_icon"] = false,
					["textL_class_colors"] = false,
					["texture_custom"] = "",
					["font_face"] = "FORCED SQUARE",
					["texture_class_colors"] = true,
					["textL_outline_small_color"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
					["fast_ps_update"] = false,
					["textR_separator"] = ",",
					["textR_bracket"] = "(",
				},
				["switch_damager_in_combat"] = false,
				["grab_on_top"] = false,
				["hide_icon"] = true,
				["row_show_animation"] = {
					["anim"] = "Fade",
					["options"] = {
					},
				},
				["bars_sort_direction"] = 1,
				["auto_current"] = true,
				["toolbar_side"] = 1,
				["bg_g"] = 0.3294,
				["menu_anchor_down"] = {
					16, -- [1]
					-2, -- [2]
				},
				["hide_in_combat"] = false,
				["show_sidebars"] = true,
				["menu_icons_size"] = 0.899999976158142,
				["switch_all_roles_after_wipe"] = false,
				["wallpaper"] = {
					["overlay"] = {
						0.999997794628143, -- [1]
						0.999997794628143, -- [2]
						0.999997794628143, -- [3]
						0.799998223781586, -- [4]
					},
					["width"] = 266.000061035156,
					["texcoord"] = {
						0.0480000019073486, -- [1]
						0.298000011444092, -- [2]
						0.630999984741211, -- [3]
						0.755999984741211, -- [4]
					},
					["enabled"] = true,
					["anchor"] = "all",
					["height"] = 225.999984741211,
					["alpha"] = 0.800000071525574,
					["texture"] = "Interface\\AddOns\\Details\\images\\skins\\elvui",
				},
				["total_bar"] = {
					["enabled"] = false,
					["only_in_group"] = true,
					["icon"] = "Interface\\ICONS\\INV_Sigil_Thorim",
					["color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
					},
				},
				["hide_out_of_combat"] = false,
				["skin_custom"] = "",
				["ignore_mass_showhide"] = false,
				["bars_inverted"] = false,
			},
			["trash_auto_remove"] = true,
			["class_colors"] = {
				["HUNTER"] = {
					0.67, -- [1]
					0.83, -- [2]
					0.45, -- [3]
				},
				["WARRIOR"] = {
					0.78, -- [1]
					0.61, -- [2]
					0.43, -- [3]
				},
				["ROGUE"] = {
					1, -- [1]
					0.96, -- [2]
					0.41, -- [3]
				},
				["MAGE"] = {
					0.41, -- [1]
					0.8, -- [2]
					0.94, -- [3]
				},
				["ARENA_YELLOW"] = {
					0.9, -- [1]
					0.9, -- [2]
					0, -- [3]
				},
				["UNGROUPPLAYER"] = {
					0.4, -- [1]
					0.4, -- [2]
					0.4, -- [3]
				},
				["DRUID"] = {
					1, -- [1]
					0.49, -- [2]
					0.04, -- [3]
				},
				["MONK"] = {
					0, -- [1]
					1, -- [2]
					0.59, -- [3]
				},
				["DEATHKNIGHT"] = {
					0.77, -- [1]
					0.12, -- [2]
					0.23, -- [3]
				},
				["PET"] = {
					0.3, -- [1]
					0.4, -- [2]
					0.5, -- [3]
				},
				["UNKNOW"] = {
					0.2, -- [1]
					0.2, -- [2]
					0.2, -- [3]
				},
				["PRIEST"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
				["ENEMY"] = {
					0.94117, -- [1]
					0, -- [2]
					0.0196, -- [3]
					1, -- [4]
				},
				["SHAMAN"] = {
					0, -- [1]
					0.44, -- [2]
					0.87, -- [3]
				},
				["WARLOCK"] = {
					0.58, -- [1]
					0.51, -- [2]
					0.79, -- [3]
				},
				["DEMONHUNTER"] = {
					0.64, -- [1]
					0.19, -- [2]
					0.79, -- [3]
				},
				["version"] = 1,
				["NEUTRAL"] = {
					1, -- [1]
					1, -- [2]
					0, -- [3]
				},
				["PALADIN"] = {
					0.96, -- [1]
					0.55, -- [2]
					0.73, -- [3]
				},
				["ARENA_GREEN"] = {
					0.1, -- [1]
					0.85, -- [2]
					0.1, -- [3]
				},
			},
			["hotcorner_topleft"] = {
				["hide"] = false,
			},
			["clear_graphic"] = true,
			["total_abbreviation"] = 2,
			["animation_speed_triggertravel"] = 5,
			["options_group_edit"] = true,
			["broadcaster_enabled"] = false,
			["minimap"] = {
				["onclick_what_todo"] = 1,
				["radius"] = 160,
				["text_type"] = 1,
				["minimapPos"] = 220,
				["text_format"] = 3,
				["hide"] = true,
			},
			["instances_amount"] = 1,
			["max_window_size"] = {
				["height"] = 450,
				["width"] = 480,
			},
			["time_type_original"] = 2,
			["only_pvp_frags"] = false,
			["disable_stretch_button"] = true,
			["use_scroll"] = false,
			["segments_amount_to_save"] = 5,
			["segments_auto_erase"] = 1,
			["segments_panic_mode"] = false,
			["window_clamp"] = {
				-8, -- [1]
				0, -- [2]
				21, -- [3]
				-14, -- [4]
			},
			["overall_clear_newboss"] = true,
			["row_fade_out"] = {
				"out", -- [1]
				0.2, -- [2]
			},
			["font_sizes"] = {
				["menus"] = 10,
			},
			["class_specs_coords"] = {
				[62] = {
					0.251953125, -- [1]
					0.375, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[63] = {
					0.375, -- [1]
					0.5, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[250] = {
					0, -- [1]
					0.125, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[251] = {
					0.125, -- [1]
					0.25, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[252] = {
					0.25, -- [1]
					0.375, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[253] = {
					0.875, -- [1]
					1, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[254] = {
					0, -- [1]
					0.125, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[255] = {
					0.125, -- [1]
					0.25, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[66] = {
					0.125, -- [1]
					0.25, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[257] = {
					0.5, -- [1]
					0.625, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[258] = {
					0.6328125, -- [1]
					0.75, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[259] = {
					0.75, -- [1]
					0.875, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[260] = {
					0.875, -- [1]
					1, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[577] = {
					0.25, -- [1]
					0.375, -- [2]
					0.5, -- [3]
					0.625, -- [4]
				},
				[262] = {
					0.125, -- [1]
					0.25, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[581] = {
					0.375, -- [1]
					0.5, -- [2]
					0.5, -- [3]
					0.625, -- [4]
				},
				[264] = {
					0.375, -- [1]
					0.5, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[265] = {
					0.5, -- [1]
					0.625, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[266] = {
					0.625, -- [1]
					0.75, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[267] = {
					0.75, -- [1]
					0.875, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[268] = {
					0.625, -- [1]
					0.75, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[269] = {
					0.875, -- [1]
					1, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[270] = {
					0.75, -- [1]
					0.875, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[70] = {
					0.251953125, -- [1]
					0.375, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[102] = {
					0.375, -- [1]
					0.5, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[71] = {
					0.875, -- [1]
					1, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[103] = {
					0.5, -- [1]
					0.625, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[72] = {
					0, -- [1]
					0.125, -- [2]
					0.5, -- [3]
					0.625, -- [4]
				},
				[104] = {
					0.625, -- [1]
					0.75, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[73] = {
					0.125, -- [1]
					0.25, -- [2]
					0.5, -- [3]
					0.625, -- [4]
				},
				[64] = {
					0.5, -- [1]
					0.625, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[105] = {
					0.75, -- [1]
					0.875, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[65] = {
					0, -- [1]
					0.125, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[256] = {
					0.375, -- [1]
					0.5, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[261] = {
					0, -- [1]
					0.125, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[263] = {
					0.25, -- [1]
					0.375, -- [2]
						0.375, -- [3]
						0.5, -- [4]
					},
				},
				["streamer_config"] = {
					["faster_updates"] = false,
					["quick_detection"] = false,
					["reset_spec_cache"] = false,
					["no_alerts"] = false,
					["use_animation_accel"] = true,
					["disable_mythic_dungeon"] = false,
				},
				["report_schema"] = 1,
				["instances_segments_locked"] = true,
				["all_players_are_group"] = false,
				["disable_reset_button"] = false,
				["data_broker_text"] = "",
				["current_dps_meter"] = {
					["enabled"] = false,
					["font_color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						1, -- [4]
					},
					["arena_enabled"] = true,
					["font_shadow"] = "NONE",
					["font_size"] = 18,
					["mythic_dungeon_enabled"] = true,
					["sample_size"] = 5,
					["font_face"] = "Friz Quadrata TT",
					["frame"] = {
						["show_title"] = false,
						["strata"] = "LOW",
						["backdrop_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							0.2, -- [4]
						},
						["locked"] = false,
						["height"] = 65,
						["width"] = 220,
					},
					["update_interval"] = 0.3,
					["options_frame"] = {
					},
				},
				["event_tracker"] = {
					["enabled"] = false,
					["font_color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						1, -- [4]
					},
					["line_height"] = 16,
					["line_color"] = {
						0.1, -- [1]
						0.1, -- [2]
						0.1, -- [3]
						0.3, -- [4]
					},
					["font_shadow"] = "NONE",
					["font_size"] = 10,
					["font_face"] = "Friz Quadrata TT",
					["frame"] = {
						["show_title"] = true,
						["strata"] = "LOW",
						["backdrop_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							0.2, -- [4]
						},
						["locked"] = false,
						["height"] = 300,
						["width"] = 250,
					},
					["line_texture"] = "Details Serenity",
					["options_frame"] = {
					},
				},
				["deadlog_limit"] = 16,
				["deny_score_messages"] = false,
			},
			["zr"] = {
				["show_arena_role_icon"] = false,
				["capture_real"] = {
					["heal"] = true,
					["spellcast"] = true,
					["miscdata"] = true,
					["aura"] = true,
					["energy"] = true,
					["damage"] = true,
				},
				["row_fade_in"] = {
					"in", -- [1]
					0.2, -- [2]
				},
				["streamer_config"] = {
					["faster_updates"] = false,
					["quick_detection"] = false,
					["reset_spec_cache"] = false,
					["no_alerts"] = false,
					["use_animation_accel"] = true,
					["disable_mythic_dungeon"] = false,
				},
				["all_players_are_group"] = false,
				["use_row_animations"] = true,
				["report_heal_links"] = false,
				["remove_realm_from_name"] = true,
				["minimum_overall_combat_time"] = 10,
				["event_tracker"] = {
					["enabled"] = false,
					["font_color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						1, -- [4]
					},
					["line_height"] = 16,
					["line_color"] = {
						0.1, -- [1]
						0.1, -- [2]
						0.1, -- [3]
						0.3, -- [4]
					},
					["font_shadow"] = "NONE",
					["font_size"] = 10,
					["font_face"] = "Friz Quadrata TT",
					["frame"] = {
						["show_title"] = true,
						["strata"] = "LOW",
						["backdrop_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							0.2, -- [4]
						},
						["locked"] = false,
						["height"] = 300,
						["width"] = 250,
					},
					["line_texture"] = "Details Serenity",
					["options_frame"] = {
					},
				},
				["report_to_who"] = "",
				["class_specs_coords"] = {
					[62] = {
						0.251953125, -- [1]
						0.375, -- [2]
						0.125, -- [3]
						0.25, -- [4]
					},
					[63] = {
						0.375, -- [1]
						0.5, -- [2]
						0.125, -- [3]
						0.25, -- [4]
					},
					[250] = {
						0, -- [1]
						0.125, -- [2]
						0, -- [3]
						0.125, -- [4]
					},
					[251] = {
						0.125, -- [1]
						0.25, -- [2]
						0, -- [3]
						0.125, -- [4]
					},
					[252] = {
						0.25, -- [1]
						0.375, -- [2]
						0, -- [3]
						0.125, -- [4]
					},
					[253] = {
						0.875, -- [1]
						1, -- [2]
						0, -- [3]
						0.125, -- [4]
					},
					[254] = {
						0, -- [1]
						0.125, -- [2]
						0.125, -- [3]
						0.25, -- [4]
					},
					[255] = {
						0.125, -- [1]
						0.25, -- [2]
						0.125, -- [3]
						0.25, -- [4]
					},
					[66] = {
						0.125, -- [1]
						0.25, -- [2]
						0.25, -- [3]
						0.375, -- [4]
					},
					[257] = {
						0.5, -- [1]
						0.625, -- [2]
						0.25, -- [3]
						0.375, -- [4]
					},
					[258] = {
						0.6328125, -- [1]
						0.75, -- [2]
						0.25, -- [3]
						0.375, -- [4]
					},
					[259] = {
						0.75, -- [1]
						0.875, -- [2]
						0.25, -- [3]
						0.375, -- [4]
					},
					[260] = {
						0.875, -- [1]
						1, -- [2]
						0.25, -- [3]
						0.375, -- [4]
					},
					[577] = {
						0.25, -- [1]
						0.375, -- [2]
						0.5, -- [3]
						0.625, -- [4]
					},
					[262] = {
						0.125, -- [1]
						0.25, -- [2]
						0.375, -- [3]
						0.5, -- [4]
					},
					[581] = {
						0.375, -- [1]
						0.5, -- [2]
						0.5, -- [3]
						0.625, -- [4]
					},
					[264] = {
						0.375, -- [1]
						0.5, -- [2]
						0.375, -- [3]
						0.5, -- [4]
					},
					[265] = {
						0.5, -- [1]
						0.625, -- [2]
						0.375, -- [3]
						0.5, -- [4]
					},
					[266] = {
						0.625, -- [1]
						0.75, -- [2]
						0.375, -- [3]
						0.5, -- [4]
					},
					[267] = {
						0.75, -- [1]
						0.875, -- [2]
						0.375, -- [3]
						0.5, -- [4]
					},
					[268] = {
						0.625, -- [1]
						0.75, -- [2]
						0.125, -- [3]
						0.25, -- [4]
					},
					[269] = {
						0.875, -- [1]
						1, -- [2]
						0.125, -- [3]
						0.25, -- [4]
					},
					[270] = {
						0.75, -- [1]
						0.875, -- [2]
						0.125, -- [3]
						0.25, -- [4]
					},
					[70] = {
						0.251953125, -- [1]
						0.375, -- [2]
						0.25, -- [3]
						0.375, -- [4]
					},
					[102] = {
						0.375, -- [1]
						0.5, -- [2]
						0, -- [3]
						0.125, -- [4]
					},
					[71] = {
						0.875, -- [1]
						1, -- [2]
						0.375, -- [3]
						0.5, -- [4]
					},
					[103] = {
						0.5, -- [1]
						0.625, -- [2]
						0, -- [3]
						0.125, -- [4]
					},
					[72] = {
						0, -- [1]
						0.125, -- [2]
						0.5, -- [3]
						0.625, -- [4]
					},
					[104] = {
						0.625, -- [1]
						0.75, -- [2]
						0, -- [3]
						0.125, -- [4]
					},
					[73] = {
						0.125, -- [1]
						0.25, -- [2]
						0.5, -- [3]
						0.625, -- [4]
					},
					[64] = {
						0.5, -- [1]
						0.625, -- [2]
						0.125, -- [3]
						0.25, -- [4]
					},
					[105] = {
						0.75, -- [1]
						0.875, -- [2]
						0, -- [3]
						0.125, -- [4]
					},
					[65] = {
						0, -- [1]
						0.125, -- [2]
						0.25, -- [3]
						0.375, -- [4]
					},
					[256] = {
						0.375, -- [1]
						0.5, -- [2]
						0.25, -- [3]
						0.375, -- [4]
					},
					[261] = {
						0, -- [1]
						0.125, -- [2]
						0.375, -- [3]
						0.5, -- [4]
					},
					[263] = {
						0.25, -- [1]
						0.375, -- [2]
						0.375, -- [3]
						0.5, -- [4]
					},
				},
				["profile_save_pos"] = true,
				["tooltip"] = {
					["header_statusbar"] = {
						0.3, -- [1]
						0.3, -- [2]
						0.3, -- [3]
						0.8, -- [4]
						false, -- [5]
						false, -- [6]
						"WorldState Score", -- [7]
					},
					["fontcolor_right"] = {
						1, -- [1]
						0.7, -- [2]
						0, -- [3]
						1, -- [4]
					},
					["tooltip_max_targets"] = 2,
					["icon_size"] = {
						["W"] = 13,
						["H"] = 13,
					},
					["tooltip_max_pets"] = 2,
					["anchor_relative"] = "top",
					["abbreviation"] = 2,
					["anchored_to"] = 1,
					["show_amount"] = false,
					["header_text_color"] = {
						1, -- [1]
						0.9176, -- [2]
						0, -- [3]
						1, -- [4]
					},
					["fontsize"] = 10,
					["background"] = {
						0.196, -- [1]
						0.196, -- [2]
						0.196, -- [3]
						0.8697, -- [4]
					},
					["submenu_wallpaper"] = true,
					["fontsize_title"] = 10,
					["icon_border_texcoord"] = {
						["B"] = 0.921875,
						["L"] = 0.078125,
						["T"] = 0.078125,
						["R"] = 0.921875,
					},
					["commands"] = {
					},
					["tooltip_max_abilities"] = 6,
					["fontface"] = "Friz Quadrata TT",
					["border_color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						0, -- [4]
					},
					["border_texture"] = "Blizzard Tooltip",
					["anchor_offset"] = {
						0, -- [1]
						0, -- [2]
					},
					["fontshadow"] = false,
					["menus_bg_texture"] = "Interface\\SPELLBOOK\\Spellbook-Page-1",
					["border_size"] = 16,
					["maximize_method"] = 1,
					["anchor_screen_pos"] = {
						507.7, -- [1]
						-350.5, -- [2]
					},
					["anchor_point"] = "bottom",
					["menus_bg_coords"] = {
						0.309777336120606, -- [1]
						0.924000015258789, -- [2]
						0.213000011444092, -- [3]
						0.279000015258789, -- [4]
					},
					["fontcolor"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						1, -- [4]
					},
					["menus_bg_color"] = {
						0.8, -- [1]
						0.8, -- [2]
						0.8, -- [3]
						0.2, -- [4]
					},
				},
				["ps_abbreviation"] = 3,
				["world_combat_is_trash"] = false,
				["update_speed"] = 0.199999988079071,
				["bookmark_text_size"] = 11,
				["animation_speed_mintravel"] = 0.45,
				["track_item_level"] = true,
				["windows_fade_in"] = {
					"in", -- [1]
					0.2, -- [2]
				},
				["instances_menu_click_to_open"] = false,
				["overall_clear_newchallenge"] = true,
				["current_dps_meter"] = {
					["enabled"] = false,
					["font_color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						1, -- [4]
					},
					["arena_enabled"] = true,
					["font_shadow"] = "NONE",
					["font_size"] = 18,
					["mythic_dungeon_enabled"] = true,
					["sample_size"] = 5,
					["font_face"] = "Friz Quadrata TT",
					["frame"] = {
						["show_title"] = false,
						["strata"] = "LOW",
						["backdrop_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							0.2, -- [4]
						},
						["locked"] = false,
						["height"] = 65,
						["width"] = 220,
					},
					["update_interval"] = 0.3,
					["options_frame"] = {
					},
				},
				["data_cleanup_logout"] = false,
				["instances_disable_bar_highlight"] = false,
				["trash_concatenate"] = false,
				["color_by_arena_team"] = true,
				["animation_speed"] = 33,
				["disable_stretch_from_toolbar"] = false,
				["disable_lock_ungroup_buttons"] = false,
				["memory_ram"] = 64,
				["disable_window_groups"] = false,
				["instances_suppress_trash"] = 0,
				["options_window"] = {
					["scale"] = 1,
				},
				["animation_speed_maxtravel"] = 3,
				["instances_segments_locked"] = false,
				["deadlog_limit"] = 16,
				["font_faces"] = {
					["menus"] = "Friz Quadrata TT",
				},
				["instances_no_libwindow"] = false,
				["segments_amount"] = 18,
				["data_broker_text"] = "",
				["instances"] = {
					{
						["bg_b"] = 0.0941176470588235,
						["__pos"] = {
							["normal"] = {
								["y"] = -440.499931335449,
								["x"] = 654.5,
								["w"] = 262.999969482422,
								["h"] = 100.999984741211,
							},
							["solo"] = {
								["y"] = 2,
								["x"] = 1,
								["w"] = 300,
								["h"] = 200,
							},
						},
						["hide_in_combat_type"] = 1,
						["menu_icons_size"] = 0.850000023841858,
						["color"] = {
							0.0705882352941177, -- [1]
							0.0705882352941177, -- [2]
							0.0705882352941177, -- [3]
							0.639196664094925, -- [4]
						},
						["menu_anchor"] = {
							16, -- [1]
							0, -- [2]
							["side"] = 2,
						},
						["show_statusbar"] = false,
						["menu_anchor_down"] = {
							16, -- [1]
							-3, -- [2]
						},
						["bg_r"] = 0.0941176470588235,
						["tooltip"] = {
							["n_abilities"] = 3,
							["n_enemies"] = 3,
						},
						["stretch_button_side"] = 1,
						["hide_out_of_combat"] = false,
						["row_info"] = {
							["textR_outline"] = false,
							["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
							["textL_outline"] = false,
							["textR_outline_small"] = true,
							["textL_outline_small"] = true,
							["textL_enable_custom_text"] = false,
							["fixed_text_color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
							["space"] = {
								["right"] = 0,
								["left"] = 0,
								["between"] = 1,
							},
							["texture_background_class_color"] = false,
							["start_after_icon"] = true,
							["font_face_file"] = "Interface\\Addons\\Details\\fonts\\Accidental Presidency.ttf",
							["textL_custom_text"] = "{data1}. {data3}{data2}",
							["models"] = {
								["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
								["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
								["upper_alpha"] = 0.5,
								["lower_enabled"] = false,
								["lower_alpha"] = 0.1,
								["upper_enabled"] = false,
							},
							["height"] = 21,
							["texture_file"] = "Interface\\AddOns\\BigWigs\\Media\\Textures\\BantoBar",
							["font_size"] = 16,
							["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small",
							["icon_grayscale"] = false,
							["textR_bracket"] = "(",
							["use_spec_icons"] = true,
							["texture_custom"] = "",
							["backdrop"] = {
								["enabled"] = false,
								["size"] = 12,
								["color"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
									1, -- [4]
								},
								["texture"] = "Details BarBorder 2",
							},
							["fixed_texture_color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["textL_show_number"] = true,
							["textL_outline_small_color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
								1, -- [4]
							},
							["fixed_texture_background_color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
								0.150228589773178, -- [4]
							},
							["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
							["texture"] = "BantoBar",
							["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
							["textR_show_data"] = {
								true, -- [1]
								true, -- [2]
								false, -- [3]
							},
							["textR_class_colors"] = false,
							["textL_class_colors"] = false,
							["textR_outline_small_color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
								1, -- [4]
							},
							["texture_background"] = "Details D'ictum (reverse)",
							["alpha"] = 1,
							["no_icon"] = false,
							["textR_enable_custom_text"] = false,
							["percent_type"] = 1,
							["font_face"] = "Accidental Presidency",
							["texture_class_colors"] = true,
							["texture_background_file"] = "Interface\\AddOns\\Details\\images\\bar4_reverse",
							["fast_ps_update"] = false,
							["textR_separator"] = "NONE",
							["texture_custom_file"] = "Interface\\",
						},
						["following"] = {
							["enabled"] = false,
							["bar_color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
							["text_color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
						},
						["color_buttons"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
							1, -- [4]
						},
						["toolbar_icon_file"] = "Interface\\AddOns\\Details\\images\\toolbar_icons",
						["micro_displays_locked"] = true,
						["menu_alpha"] = {
							["enabled"] = false,
							["onenter"] = 1,
							["iconstoo"] = true,
							["ignorebars"] = false,
							["onleave"] = 1,
						},
						["row_show_animation"] = {
							["anim"] = "Fade",
							["options"] = {
							},
						},
						["switch_healer"] = false,
						["ignore_mass_showhide"] = false,
						["__was_opened"] = true,
						["StatusBarSaved"] = {
							["left"] = "DETAILS_STATUSBAR_PLUGIN_CLOCK",
							["right"] = "DETAILS_STATUSBAR_PLUGIN_PSEGMENT",
							["center"] = "DETAILS_STATUSBAR_PLUGIN_PDPS",
							["options"] = {
								["DETAILS_STATUSBAR_PLUGIN_PDPS"] = {
									["isHidden"] = false,
									["textStyle"] = 2,
									["textYMod"] = 1,
									["textFace"] = "Expressway",
									["textXMod"] = 6,
									["timeType"] = 1,
									["textAlign"] = 0,
									["textSize"] = 11,
									["textColor"] = {
										1, -- [1]
										1, -- [2]
										1, -- [3]
										1, -- [4]
									},
								},
								["DETAILS_STATUSBAR_PLUGIN_PSEGMENT"] = {
									["isHidden"] = true,
									["textStyle"] = 2,
									["textYMod"] = 1,
									["segmentType"] = 2,
									["textFace"] = "Expressway",
									["textXMod"] = 0,
									["textAlign"] = 0,
									["textSize"] = 11,
									["textColor"] = {
										1, -- [1]
										1, -- [2]
										1, -- [3]
										1, -- [4]
									},
								},
								["DETAILS_STATUSBAR_PLUGIN_CLOCK"] = {
									["isHidden"] = false,
									["timeType"] = 1,
									["textYMod"] = 1,
									["segmentType"] = 2,
									["textXMod"] = 6,
									["textStyle"] = 2,
									["textFace"] = "Expressway",
									["textAlign"] = 3,
									["textSize"] = 11,
									["textColor"] = {
										1, -- [1]
										1, -- [2]
										1, -- [3]
										1, -- [4]
									},
								},
							},
						},
						["switch_healer_in_combat"] = false,
						["switch_all_roles_in_combat"] = false,
						["instance_button_anchor"] = {
							-27, -- [1]
							1, -- [2]
						},
						["version"] = 3,
						["attribute_text"] = {
							["enabled"] = true,
							["shadow"] = false,
							["side"] = 1,
							["text_size"] = 12,
							["custom_text"] = "{name}",
							["text_face"] = "Accidental Presidency",
							["anchor"] = {
								-18, -- [1]
								3, -- [2]
							},
							["text_color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
								1, -- [4]
							},
							["enable_custom_text"] = false,
							["show_timer"] = {
								true, -- [1]
								true, -- [2]
								true, -- [3]
							},
						},
						["__locked"] = true,
						["__snapH"] = false,
						["desaturated_menu"] = false,
						["show_sidebars"] = false,
						["backdrop_texture"] = "Details Ground",
						["strata"] = "LOW",
						["window_scale"] = 1,
						["__snap"] = {
						},
						["switch_tank"] = false,
						["hide_in_combat_alpha"] = 0,
						["switch_all_roles_after_wipe"] = false,
						["menu_icons"] = {
							true, -- [1]
							true, -- [2]
							true, -- [3]
							true, -- [4]
							true, -- [5]
							false, -- [6]
							["space"] = -2,
							["shadow"] = false,
						},
						["switch_damager"] = false,
						["micro_displays_side"] = 2,
						["libwindow"] = {
							["y"] = 49.0000228881836,
							["x"] = -174,
							["point"] = "BOTTOMRIGHT",
							["scale"] = 1,
						},
						["bars_grow_direction"] = 1,
						["switch_damager_in_combat"] = false,
						["bg_alpha"] = 0.183960914611816,
						["switch_tank_in_combat"] = false,
						["grab_on_top"] = false,
						["hide_icon"] = true,
						["__snapV"] = false,
						["auto_current"] = true,
						["toolbar_side"] = 1,
						["bg_g"] = 0.0941176470588235,
						["plugins_grow_direction"] = 1,
						["hide_in_combat"] = false,
						["posicao"] = {
							["normal"] = {
								["y"] = -440.499931335449,
								["x"] = 654.5,
								["w"] = 262.999969482422,
								["h"] = 100.999984741211,
							},
							["solo"] = {
								["y"] = 2,
								["x"] = 1,
								["w"] = 300,
								["h"] = 200,
							},
						},
						["statusbar_info"] = {
							["alpha"] = 0.3777777777777,
							["overlay"] = {
								0.333333333333333, -- [1]
								0.333333333333333, -- [2]
								0.333333333333333, -- [3]
							},
						},
						["auto_hide_menu"] = {
							["left"] = false,
							["right"] = false,
						},
						["wallpaper"] = {
							["enabled"] = false,
							["texcoord"] = {
								0, -- [1]
								1, -- [2]
								0, -- [3]
								0.7, -- [4]
							},
							["overlay"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
								1, -- [4]
							},
							["anchor"] = "all",
							["height"] = 114.042518615723,
							["alpha"] = 0.5,
							["width"] = 283.000183105469,
						},
						["total_bar"] = {
							["enabled"] = false,
							["only_in_group"] = true,
							["icon"] = "Interface\\ICONS\\INV_Sigil_Thorim",
							["color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
						},
						["skin"] = "Minimalistic",
						["skin_custom"] = "",
						["bars_sort_direction"] = 1,
						["bars_inverted"] = false,
					}, -- [1]
				},
				["report_lines"] = 5,
				["clear_ungrouped"] = true,
				["total_abbreviation"] = 2,
				["skin"] = "WoW Interface",
				["override_spellids"] = true,
				["use_battleground_server_parser"] = false,
				["report_schema"] = 1,
				["new_window_size"] = {
					["height"] = 158,
					["width"] = 310,
				},
				["use_scroll"] = false,
				["minimum_combat_time"] = 5,
				["overall_clear_logout"] = false,
				["cloud_capture"] = true,
				["damage_taken_everything"] = false,
				["scroll_speed"] = 2,
				["font_sizes"] = {
					["menus"] = 10,
				},
				["memory_threshold"] = 3,
				["deadlog_events"] = 32,
				["overall_clear_newboss"] = true,
				["close_shields"] = false,
				["class_coords"] = {
					["HUNTER"] = {
						0, -- [1]
						0.25, -- [2]
						0.25, -- [3]
						0.5, -- [4]
					},
					["WARRIOR"] = {
						0, -- [1]
						0.25, -- [2]
						0, -- [3]
						0.25, -- [4]
					},
					["SHAMAN"] = {
						0.25, -- [1]
						0.49609375, -- [2]
						0.25, -- [3]
						0.5, -- [4]
					},
					["MAGE"] = {
						0.25, -- [1]
						0.49609375, -- [2]
						0, -- [3]
						0.25, -- [4]
					},
					["PET"] = {
						0.25, -- [1]
						0.49609375, -- [2]
						0.75, -- [3]
						1, -- [4]
					},
					["DRUID"] = {
						0.7421875, -- [1]
						0.98828125, -- [2]
						0, -- [3]
						0.25, -- [4]
					},
					["MONK"] = {
						0.5, -- [1]
						0.73828125, -- [2]
						0.5, -- [3]
						0.75, -- [4]
					},
					["DEATHKNIGHT"] = {
						0.25, -- [1]
						0.5, -- [2]
						0.5, -- [3]
						0.75, -- [4]
					},
					["MONSTER"] = {
						0, -- [1]
						0.25, -- [2]
						0.75, -- [3]
						1, -- [4]
					},
					["UNKNOW"] = {
						0.5, -- [1]
						0.75, -- [2]
						0.75, -- [3]
						1, -- [4]
					},
					["PRIEST"] = {
						0.49609375, -- [1]
						0.7421875, -- [2]
						0.25, -- [3]
						0.5, -- [4]
					},
					["ROGUE"] = {
						0.49609375, -- [1]
						0.7421875, -- [2]
						0, -- [3]
						0.25, -- [4]
					},
					["Alliance"] = {
						0.49609375, -- [1]
						0.7421875, -- [2]
						0.75, -- [3]
						1, -- [4]
					},
					["ENEMY"] = {
						0, -- [1]
						0.25, -- [2]
						0.75, -- [3]
						1, -- [4]
					},
					["DEMONHUNTER"] = {
						0.73828126, -- [1]
						1, -- [2]
						0.5, -- [3]
						0.75, -- [4]
					},
					["Horde"] = {
						0.7421875, -- [1]
						0.98828125, -- [2]
						0.75, -- [3]
						1, -- [4]
					},
					["PALADIN"] = {
						0, -- [1]
						0.25, -- [2]
						0.5, -- [3]
						0.75, -- [4]
					},
					["WARLOCK"] = {
						0.7421875, -- [1]
						0.98828125, -- [2]
						0.25, -- [3]
						0.5, -- [4]
					},
					["UNGROUPPLAYER"] = {
						0.5, -- [1]
						0.75, -- [2]
						0.75, -- [3]
						1, -- [4]
					},
				},
				["window_clamp"] = {
					-8, -- [1]
					0, -- [2]
					21, -- [3]
					-14, -- [4]
				},
				["disable_alldisplays_window"] = false,
				["windows_fade_out"] = {
					"out", -- [1]
					0.2, -- [2]
				},
				["standard_skin"] = false,
				["class_colors"] = {
					["HUNTER"] = {
						0.67, -- [1]
						0.83, -- [2]
						0.45, -- [3]
					},
					["WARRIOR"] = {
						0.78, -- [1]
						0.61, -- [2]
						0.43, -- [3]
					},
					["SHAMAN"] = {
						0, -- [1]
						0.44, -- [2]
						0.87, -- [3]
					},
					["MAGE"] = {
						0.41, -- [1]
						0.8, -- [2]
						0.94, -- [3]
					},
					["ARENA_YELLOW"] = {
						1, -- [1]
						1, -- [2]
						0.25, -- [3]
					},
					["UNGROUPPLAYER"] = {
						0.4, -- [1]
						0.4, -- [2]
						0.4, -- [3]
					},
					["DRUID"] = {
						1, -- [1]
						0.49, -- [2]
						0.04, -- [3]
					},
					["MONK"] = {
						0, -- [1]
						1, -- [2]
						0.59, -- [3]
					},
					["DEATHKNIGHT"] = {
						0.77, -- [1]
						0.12, -- [2]
						0.23, -- [3]
					},
					["PALADIN"] = {
						0.96, -- [1]
						0.55, -- [2]
						0.73, -- [3]
					},
					["UNKNOW"] = {
						0.2, -- [1]
						0.2, -- [2]
						0.2, -- [3]
					},
					["PRIEST"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
					},
					["ROGUE"] = {
						1, -- [1]
						0.96, -- [2]
						0.41, -- [3]
					},
					["WARLOCK"] = {
						0.58, -- [1]
						0.51, -- [2]
						0.79, -- [3]
					},
					["ENEMY"] = {
						0.94117, -- [1]
						0, -- [2]
						0.0196, -- [3]
						1, -- [4]
					},
					["DEMONHUNTER"] = {
						0.64, -- [1]
						0.19, -- [2]
						0.79, -- [3]
					},
					["version"] = 1,
					["NEUTRAL"] = {
						1, -- [1]
						1, -- [2]
						0, -- [3]
					},
					["PET"] = {
						0.3, -- [1]
						0.4, -- [2]
						0.5, -- [3]
					},
					["ARENA_GREEN"] = {
						0.4, -- [1]
						1, -- [2]
						0.4, -- [3]
					},
				},
				["segments_auto_erase"] = 1,
				["clear_graphic"] = true,
				["trash_auto_remove"] = true,
				["animation_speed_triggertravel"] = 5,
				["options_group_edit"] = true,
				["segments_amount_to_save"] = 18,
				["minimap"] = {
					["onclick_what_todo"] = 1,
					["radius"] = 160,
					["text_type"] = 1,
					["minimapPos"] = 220,
					["text_format"] = 3,
					["hide"] = false,
				},
				["instances_amount"] = 5,
				["max_window_size"] = {
					["height"] = 450,
					["width"] = 480,
				},
				["deny_score_messages"] = false,
				["only_pvp_frags"] = false,
				["disable_stretch_button"] = false,
				["default_bg_color"] = 0.0941,
				["broadcaster_enabled"] = false,
				["hotcorner_topleft"] = {
					["hide"] = false,
				},
				["segments_panic_mode"] = false,
				["numerical_system_symbols"] = "auto",
				["overall_flag"] = 16,
				["row_fade_out"] = {
					"out", -- [1]
					0.2, -- [2]
				},
				["chat_tab_embed"] = {
					["enabled"] = false,
					["y_offset"] = 0,
					["x_offset"] = 0,
					["tab_name"] = "",
					["single_window"] = false,
				},
				["player_details_window"] = {
					["scale"] = 1,
					["bar_texture"] = "Skyline",
					["skin"] = "ElvUI",
				},
				["numerical_system"] = 1,
				["force_activity_time_pvp"] = true,
				["pvp_as_group"] = true,
				["class_icons_small"] = "Interface\\AddOns\\Details\\images\\classes_small",
				["disable_reset_button"] = false,
				["animate_scroll"] = false,
				["death_tooltip_width"] = 350,
				["time_type"] = 2,
				["default_bg_alpha"] = 0.5,
				["time_type_original"] = 2,
			},
		},
	}
	_detalhes:ApplyProfile('MerathilisUI')
end

E.PopupDialogs["MUI_INSTALL_DETAILS_LAYOUT"] = {
	text = L["MUI_INSTALL_SETTINGS_LAYOUT_DETAILS"],
	OnAccept = function() MER:LoadDetailsProfile(); ReloadUI() end,
	button1 = L["Details Layout"],
}