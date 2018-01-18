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
		["tutorial"] = {
			["bookmark_tutorial"] = false,
			["main_help_button"] = 10,
			["DETAILS_INFO_TUTORIAL1"] = true,
			["SWITCH_PANEL_FIRST_OPENED"] = true,
			["alert_frames"] = {
				false, -- [1]
				false, -- [2]
				false, -- [3]
				false, -- [4]
				false, -- [5]
				false, -- [6]
			},
			["unlock_button"] = 0,
			["MEMORY_USAGE_ALERT1"] = true,
			["DETAILS_INFO_TUTORIAL2"] = 2,
			["logons"] = 10,
			["OPTIONS_PANEL_OPENED"] = true,
			["ctrl_click_close_tutorial"] = false,
			["WINDOW_LOCK_UNLOCK1"] = true,
			["version_announce"] = 0,
			["STREAMER_PLUGIN_FIRSTRUN"] = true,
		},
		["realm_sync"] = true,
		["report_where"] = "SAY",
		["item_level_pool"] = {
		},
		["switchSaved"] = {
			["slots"] = 10,
			["table"] = {
				{
					["atributo"] = 1,
					["sub_atributo"] = 1,
				}, -- [1]
				{
					["atributo"] = 2,
					["sub_atributo"] = 1,
				}, -- [2]
				{
					["atributo"] = 1,
					["sub_atributo"] = 6,
				}, -- [3]
				{
					["atributo"] = 4,
					["sub_atributo"] = 5,
				}, -- [4]
				{
				}, -- [5]
				{
				}, -- [6]
				{
				}, -- [7]
				{
				}, -- [8]
				{
				}, -- [9]
				{
				}, -- [10]
			},
		},
		["always_use_profile_exception"] = {
		},
		["got_first_run"] = true,
		["details_auras"] = {
		},
		["always_use_profile"] = true,
		["always_use_profile_name"] = "MerathilisUI",
		["savedStyles"] = {
		},
		["report_pos"] = {
			1, -- [1]
			1, -- [2]
		},
		["latest_report_table"] = {
		},
		["savedTimeCaptures"] = {
		},
		["__profiles"] = {
			["MerathilisUI"] = {
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
				["class_icons_small"] = "Interface\\AddOns\\Details\\images\\classes_small",
				["report_to_who"] = "",
				["overall_flag"] = 13,
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
					["fontsize"] = 11,
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
					["tooltip_max_abilities"] = 5,
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
				["track_item_level"] = true,
				["windows_fade_in"] = {
					"in", -- [1]
					0.2, -- [2]
				},
				["instances_menu_click_to_open"] = false,
				["overall_clear_newchallenge"] = true,
				["time_type"] = 2,
				["instances_disable_bar_highlight"] = false,
				["trash_concatenate"] = false,
				["disable_stretch_from_toolbar"] = false,
				["disable_lock_ungroup_buttons"] = true,
				["memory_ram"] = 64,
				["disable_window_groups"] = false,
				["instances_suppress_trash"] = 0,
				["font_faces"] = {
					["menus"] = "Expressway",
				},
				["segments_amount"] = 12,
				["report_lines"] = 5,
				["skin"] = "WoW Interface",
				["override_spellids"] = true,
				["memory_threshold"] = 3,
				["default_bg_alpha"] = 0.5,
				["use_battleground_server_parser"] = true,
				["clear_ungrouped"] = true,
				["minimum_combat_time"] = 5,
				["animate_scroll"] = false,
				["cloud_capture"] = true,
				["damage_taken_everything"] = false,
				["scroll_speed"] = 2,
				["new_window_size"] = {
					["height"] = 130,
					["width"] = 320,
				},
				["chat_tab_embed"] = {
					["enabled"] = true,
					["tab_name"] = "",
					["single_window"] = false,
					["w1_pos"] = {
						["y"] = 5.30014763215718,
						["x"] = -163.749771900271,
						["point"] = "BOTTOMRIGHT",
						["h"] = 110.000007629395,
						["x_legacy"] = 660.620163157818,
						["pos_table"] = true,
						["w"] = 273.999908447266,
						["y_legacy"] = -480.249790321906,
					},
				},
				["deadlog_events"] = 32,
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
					["WARLOCK"] = {
						0.7421875, -- [1]
						0.98828125, -- [2]
						0.25, -- [3]
						0.5, -- [4]
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
					["ENEMY"] = {
						0, -- [1]
						0.25, -- [2]
						0.75, -- [3]
						1, -- [4]
					},
				},
				["overall_clear_logout"] = false,
				["disable_alldisplays_window"] = false,
				["pvp_as_group"] = true,
				["force_activity_time_pvp"] = true,
				["windows_fade_out"] = {
					"out", -- [1]
					0.2, -- [2]
				},
				["death_tooltip_width"] = 300,
				["clear_graphic"] = true,
				["hotcorner_topleft"] = {
					["hide"] = false,
				},
				["segments_auto_erase"] = 1,
				["options_group_edit"] = true,
				["segments_amount_to_save"] = 5,
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
				["trash_auto_remove"] = true,
				["only_pvp_frags"] = false,
				["disable_stretch_button"] = true,
				["time_type_original"] = 2,
				["default_bg_color"] = 0.0941,
				["numerical_system_symbols"] = "auto",
				["segments_panic_mode"] = false,
				["window_clamp"] = {
					-8, -- [1]
					0, -- [2]
					21, -- [3]
					-14, -- [4]
				},
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
					["instance_button_anchor"] = {
						-27, -- [1]
						1, -- [2]
					},
					["switch_all_roles_in_combat"] = false,
					["switch_tank_in_combat"] = false,
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
						["percent_type"] = 1,
						["fixed_text_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["space"] = {
							["right"] = -2,
							["left"] = 1,
							["between"] = 1,
						},
						["texture_background_class_color"] = false,
						["textL_outline_small_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							1, -- [4]
						},
						["font_face_file"] = "Interface\\Addons\\Details\\fonts\\FORCED SQUARE.ttf",
						["textL_custom_text"] = "{data1}. {data3}{data2}",
						["font_size"] = 10,
						["height"] = 14,
						["texture_file"] = "Interface\\AddOns\\Details\\images\\bar_skyline",
						["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small_alpha",
						["texture_custom_file"] = "Interface\\",
						["texture_background_file"] = "Interface\\AddOns\\Details\\images\\bar_background",
						["textR_bracket"] = "(",
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
						["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
						["texture"] = "Skyline",
						["textR_outline_small"] = true,
						["textL_enable_custom_text"] = false,
						["textR_show_data"] = {
							true, -- [1]
							true, -- [2]
							true, -- [3]
						},
						["texture_background"] = "DGround",
						["alpha"] = 0.8,
						["textL_class_colors"] = false,
						["textR_outline_small_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							1, -- [4]
						},
						["no_icon"] = false,
						["textR_class_colors"] = false,
						["texture_custom"] = "",
						["font_face"] = "FORCED SQUARE",
						["texture_class_colors"] = true,
						["start_after_icon"] = false,
						["fast_ps_update"] = false,
						["textR_separator"] = ",",
						["use_spec_icons"] = true,
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
					["switch_tank"] = false,
					["bars_inverted"] = false,
				},
				["row_fade_out"] = {
					"out", -- [1]
					0.2, -- [2]
				},
				["use_scroll"] = false,
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
					["ENEMY"] = {
						0.94117, -- [1]
						0, -- [2]
						0.0196, -- [3]
						1, -- [4]
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
					["PET"] = {
						0.3, -- [1]
						0.4, -- [2]
						0.5, -- [3]
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
				["overall_clear_newboss"] = true,
				["report_schema"] = 1,
				["total_abbreviation"] = 2,
				["font_sizes"] = {
					["menus"] = 10,
				},
				["disable_reset_button"] = false,
				["data_broker_text"] = "",
				["instances_no_libwindow"] = false,
				["instances_segments_locked"] = true,
				["deadlog_limit"] = 16,
				["instances"] = {
					{
						["__pos"] = {
							["normal"] = {
								["y"] = -480.24986585291,
								["x"] = 660.620163157818,
								["w"] = 273.999908447266,
								["h"] = 110.000007629395,
							},
							["solo"] = {
								["y"] = 2,
								["x"] = 1,
								["w"] = 300,
								["h"] = 200,
							},
						},
						["show_statusbar"] = false,
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
						["__snapV"] = false,
						["__snapH"] = false,
						["bg_r"] = 0.517647058823529,
						["switch_healer_in_combat"] = false,
						["desaturated_menu"] = true,
						["hide_out_of_combat"] = false,
						["__was_opened"] = true,
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
						["stretch_button_side"] = 1,
						["switch_tank"] = false,
						["menu_anchor_down"] = {
							16, -- [1]
							-2, -- [2]
						},
						["micro_displays_locked"] = true,
						["tooltip"] = {
							["n_abilities"] = 3,
							["n_enemies"] = 3,
						},
						["StatusBarSaved"] = {
							["center"] = "DETAILS_STATUSBAR_PLUGIN_PDPS",
							["right"] = "DETAILS_STATUSBAR_PLUGIN_PTIME",
							["options"] = {
								["DETAILS_STATUSBAR_PLUGIN_PDPS"] = {
									["isHidden"] = false,
									["timeType"] = 1,
									["textYMod"] = 3,
									["textFace"] = "Expressway",
									["textXMod"] = 6,
									["textStyle"] = 2,
									["textAlign"] = 0,
									["textSize"] = 14,
									["textColor"] = {
										1, -- [1]
										0.490196078431373, -- [2]
										0.0392156862745098, -- [3]
									},
								},
								["DETAILS_STATUSBAR_PLUGIN_PTIME"] = {
									["isHidden"] = true,
									["textStyle"] = 2,
									["textYMod"] = 1,
									["textXMod"] = 0,
									["textFace"] = "Expressway",
									["timeType"] = 1,
									["textAlign"] = 0,
									["textSize"] = 14,
									["textColor"] = {
										1, -- [1]
										0.490196078431373, -- [2]
										0.0392156862745098, -- [3]
									},
								},
								["DETAILS_STATUSBAR_PLUGIN_CLOCK"] = {
									["isHidden"] = false,
									["textStyle"] = 2,
									["textYMod"] = 4,
									["segmentType"] = 2,
									["textXMod"] = 5,
									["timeType"] = 1,
									["textFace"] = "Expressway",
									["textAlign"] = 1,
									["textSize"] = 14,
									["textColor"] = {
										1, -- [1]
										0.490196078431373, -- [2]
										0.0392156862745098, -- [3]
									},
								},
							},
							["left"] = "DETAILS_STATUSBAR_PLUGIN_CLOCK",
						},
						["micro_displays_side"] = 1,
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
						["hide_in_combat_type"] = 1,
						["row_show_animation"] = {
							["anim"] = "Fade",
							["options"] = {
							},
						},
						["bg_b"] = 0.517647058823529,
						["strata"] = "LOW",
						["grab_on_top"] = false,
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
						["switch_damager"] = false,
						["auto_hide_menu"] = {
							["left"] = false,
							["right"] = false,
						},
						["bg_alpha"] = 0,
						["window_scale"] = 0.990000009536743,
						["bars_grow_direction"] = 1,
						["instance_button_anchor"] = {
							-27, -- [1]
							1, -- [2]
						},
						["statusbar_info"] = {
							["alpha"] = 0,
							["overlay"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
						},
						["hide_icon"] = true,
						["libwindow"] = {
							["y"] = 5.30006596425631,
							["x"] = -163.749892749882,
							["point"] = "BOTTOMRIGHT",
						},
						["backdrop_texture"] = "SA - Daybreak",
						["auto_current"] = true,
						["toolbar_side"] = 1,
						["bg_g"] = 0.517647058823529,
						["skin"] = "ElvUI Style II",
						["hide_in_combat"] = false,
						["posicao"] = {
							["normal"] = {
								["y"] = -480.24986585291,
								["x"] = 660.620163157818,
								["w"] = 273.999908447266,
								["h"] = 110.000007629395,
							},
							["solo"] = {
								["y"] = 2,
								["x"] = 1,
								["w"] = 300,
								["h"] = 200,
							},
						},
						["switch_all_roles_after_wipe"] = false,
						["show_sidebars"] = false,
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
						["switch_damager_in_combat"] = false,
						["bars_sort_direction"] = 1,
						["row_info"] = {
							["textR_outline"] = true,
							["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
							["textL_outline"] = true,
							["textR_outline_small"] = true,
							["textL_outline_small"] = true,
							["percent_type"] = 1,
							["fixed_text_color"] = {
								0.905882352941177, -- [1]
								0.905882352941177, -- [2]
								0.905882352941177, -- [3]
								1, -- [4]
							},
							["space"] = {
								["right_noborder"] = -3,
								["left_noborder"] = 1,
								["right"] = -3,
								["between"] = 1,
								["left"] = 1,
							},
							["texture_background_class_color"] = false,
							["textL_outline_small_color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
								1, -- [4]
							},
							["font_face_file"] = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\fonts\\Expressway.ttf",
							["textL_custom_text"] = "{data1}. {data3}{data2}",
							["models"] = {
								["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
								["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
								["upper_alpha"] = 0.5,
								["lower_enabled"] = false,
								["lower_alpha"] = 0.1,
								["upper_enabled"] = false,
							},
							["texture_custom_file"] = "Interface\\",
							["texture_file"] = "Interface\BUTTONS\WHITE8X8.blp",
							["icon_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
							["use_spec_icons"] = false,
							["font_size"] = 10,
							["textR_bracket"] = "(",
							["textR_enable_custom_text"] = false,
							["backdrop"] = {
								["enabled"] = false,
								["size"] = 5,
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
							["textL_show_number"] = true,
							["textL_enable_custom_text"] = false,
							["texture_custom"] = "",
							["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
							["fixed_texture_background_color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
								0.295484036207199, -- [4]
							},
							["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
							["start_after_icon"] = false,
							["textR_class_colors"] = false,
							["textL_class_colors"] = false,
							["textR_outline_small_color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
								1, -- [4]
							},
							["texture_background"] = "MerathilisBlank",
							["alpha"] = 1,
							["no_icon"] = false,
							["textR_show_data"] = {
								true, -- [1]
								true, -- [2]
								true, -- [3]
							},
							["texture_background_file"] = "Interface\BUTTONS\WHITE8X8.blp",
							["font_face"] = "Expressway",
							["texture_class_colors"] = true,
							["texture"] = "MerathilisFlat",
							["fast_ps_update"] = true,
							["textR_separator"] = ",",
							["height"] = 19,
						},
						["bars_inverted"] = false,
					}, -- [1]
				},
			},
		},
		["latest_news_saw"] = "",
		["custom"] = {
			{
				["source"] = false,
				["author"] = "Details!",
				["desc"] = "Zeigt, wer im Schlachtzug einen Trank benutzt hat.",
				["tooltip"] = "			--init:\n			local player, combat, instance = ...\n\n			--get the debuff container for potion of focus\n			local debuff_uptime_container = player.debuff_uptime and player.debuff_uptime_spells and player.debuff_uptime_spells._ActorTable\n			if (debuff_uptime_container) then\n			    local focus_potion = debuff_uptime_container [188030] --Legion\n			    if (focus_potion) then\n				local name, _, icon = GetSpellInfo (188030) --Legion\n				GameCooltip:AddLine (name, 1) --> can use only 1 focus potion (can't be pre-potion)\n				_detalhes:AddTooltipBackgroundStatusbar()\n				GameCooltip:AddIcon (icon, 1, 1, 14, 14)\n			    end\n			end\n\n			--get the buff container for all the others potions\n			local buff_uptime_container = player.buff_uptime and player.buff_uptime_spells and player.buff_uptime_spells._ActorTable\n			if (buff_uptime_container) then\n			    --potion of the jade serpent\n			    local jade_serpent_potion = buff_uptime_container [188027] --Legion\n			    if (jade_serpent_potion) then\n				local name, _, icon = GetSpellInfo (188027) --Legion\n				GameCooltip:AddLine (name, jade_serpent_potion.activedamt)\n				_detalhes:AddTooltipBackgroundStatusbar()\n				GameCooltip:AddIcon (icon, 1, 1, 14, 14)\n			    end\n			    \n			    --potion of mogu power\n			    local mogu_power_potion = buff_uptime_container [188028] --Legion\n			    if (mogu_power_potion) then\n				local name, _, icon = GetSpellInfo (188028) --Legion\n				GameCooltip:AddLine (name, mogu_power_potion.activedamt)\n				_detalhes:AddTooltipBackgroundStatusbar()\n				GameCooltip:AddIcon (icon, 1, 1, 14, 14)\n			    end\n			    \n			    --mana potion\n			    local mana_potion = buff_uptime_container [188017] --Legion\n			    if (mana_potion) then\n				local name, _, icon = GetSpellInfo (188017) --Legion\n				GameCooltip:AddLine (name, mana_potion.activedamt)\n				_detalhes:AddTooltipBackgroundStatusbar()\n				GameCooltip:AddIcon (icon, 1, 1, 14, 14)\n			    end\n			    \n			    --prolongued power\n			    local prolongued_power = buff_uptime_container [229206] --Legion\n			    if (prolongued_power) then\n				local name, _, icon = GetSpellInfo (229206) --Legion\n				GameCooltip:AddLine (name, prolongued_power.activedamt)\n				_detalhes:AddTooltipBackgroundStatusbar()\n				GameCooltip:AddIcon (icon, 1, 1, 14, 14)\n			    end\n			    \n			    --potion of the mountains\n			    local mountains_potion = buff_uptime_container [188029] --Legion\n			    if (mountains_potion) then\n				local name, _, icon = GetSpellInfo (188029) --Legion\n				GameCooltip:AddLine (name, mountains_potion.activedamt)\n				_detalhes:AddTooltipBackgroundStatusbar()\n				GameCooltip:AddIcon (icon, 1, 1, 14, 14)\n			    end\n			end\n		",
				["icon"] = "Interface\\ICONS\\Trade_Alchemy_PotionD4",
				["name"] = "Benutzte Tränke",
				["spellid"] = false,
				["target"] = false,
				["script"] = "				--init:\n				local combat, instance_container, instance = ...\n				local total, top, amount = 0, 0, 0\n\n				--get the misc actor container\n				local misc_container = combat:GetActorList ( DETAILS_ATTRIBUTE_MISC )\n\n				--do the loop:\n				for _, player in ipairs ( misc_container ) do \n				    \n				    --only player in group\n				    if (player:IsGroupPlayer()) then\n					\n					local found_potion = false\n					\n					--get the spell debuff uptime container\n					local debuff_uptime_container = player.debuff_uptime and player.debuff_uptime_spells and player.debuff_uptime_spells._ActorTable\n					if (debuff_uptime_container) then\n					    --potion of focus (can't use as pre-potion, so, its amount is always 1\n					    local focus_potion = debuff_uptime_container [188030] --Legion\n					    if (focus_potion) then\n						total = total + 1\n						found_potion = true\n						if (top < 1) then\n						    top = 1\n						end\n						--add amount to the player \n						instance_container:AddValue (player, 1)\n					    end\n					end\n					\n					--get the spell buff uptime container\n					local buff_uptime_container = player.buff_uptime and player.buff_uptime_spells and player.buff_uptime_spells._ActorTable\n					if (buff_uptime_container) then\n					    \n					    --potion of the jade serpent\n					    local jade_serpent_potion = buff_uptime_container [188027] --Legion\n					    if (jade_serpent_potion) then\n						local used = jade_serpent_potion.activedamt\n						if (used > 0) then\n						    total = total + used\n						    found_potion = true\n						    if (used > top) then\n							top = used\n						    end\n						    --add amount to the player \n						    instance_container:AddValue (player, used)\n						end\n					    end\n					    \n					    --potion of mogu power\n					    local mogu_power_potion = buff_uptime_container [188028] --Legion\n					    if (mogu_power_potion) then\n						local used = mogu_power_potion.activedamt\n						if (used > 0) then\n						    total = total + used\n						    found_potion = true\n						    if (used > top) then\n							top = used\n						    end\n						    --add amount to the player \n						    instance_container:AddValue (player, used)\n						end\n					    end\n					    \n					    --mana potion\n					    local mana_potion = buff_uptime_container [188017] --Legion\n					    if (mana_potion) then\n						local used = mana_potion.activedamt\n						if (used > 0) then\n						    total = total + used\n						    found_potion = true\n						    if (used > top) then\n							top = used\n						    end\n						    --add amount to the player \n						    instance_container:AddValue (player, used)\n						end\n					    end\n					    \n					    --potion of prolongued power\n					    local prolongued_power = buff_uptime_container [229206] --Legion\n					    if (prolongued_power) then\n						local used = prolongued_power.activedamt\n						if (used > 0) then\n						    total = total + used\n						    found_potion = true\n						    if (used > top) then\n							top = used\n						    end\n						    --add amount to the player \n						    instance_container:AddValue (player, used)\n						end\n					    end\n					    \n					    --potion of the mountains\n					    local mountains_potion = buff_uptime_container [188029] --Legion\n					    if (mountains_potion) then\n						local used = mountains_potion.activedamt\n						if (used > 0) then\n						    total = total + used\n						    found_potion = true\n						    if (used > top) then\n							top = used\n						    end\n						    --add amount to the player \n						    instance_container:AddValue (player, used)\n						end\n					    end\n					end\n					\n					if (found_potion) then\n					    amount = amount + 1\n					end    \n				    end\n				end\n\n				--return:\n				return total, top, amount\n				",
				["attribute"] = false,
				["script_version"] = 3,
			}, -- [1]
			{
				["source"] = false,
				["total_script"] = false,
				["author"] = "Details! Team",
				["percent_script"] = false,
				["desc"] = "Zeigt, wer im Schlachtzug den Gesundheitsstein oder einen Heiltrank benutzt hat.",
				["icon"] = "Interface\\ICONS\\warlock_ healthstone",
				["spellid"] = false,
				["name"] = "Benutzte Heiltränke & Gesundheitssteine",
				["script"] = "			--get the parameters passed\n			local combat, instance_container, instance = ...\n			--declade the values to return\n			local total, top, amount = 0, 0, 0\n			\n			--do the loop\n			local AllHealCharacters = combat:GetActorList (DETAILS_ATTRIBUTE_HEAL)\n			for index, character in ipairs (AllHealCharacters) do\n				local AllSpells = character:GetSpellList()\n				local found = false\n				for spellid, spell in pairs (AllSpells) do\n					if (DETAILS_HEALTH_POTION_LIST [spellid]) then\n						instance_container:AddValue (character, spell.total)\n						total = total + spell.total\n						if (top < spell.total) then\n							top = spell.total\n						end\n						found = true\n					end\n				end\n			\n				if (found) then\n					amount = amount + 1\n				end\n			end\n			--loop end\n			--return the values\n			return total, top, amount\n			",
				["target"] = false,
				["tooltip"] = "			--get the parameters passed\n			local actor, combat, instance = ...\n			\n			--get the cooltip object (we dont use the convencional GameTooltip here)\n			local GameCooltip = GameCooltip\n			local R, G, B, A = 0, 0, 0, 0.75\n			\n			local hs = actor:GetSpell (6262)\n			if (hs) then\n				GameCooltip:AddLine (select (1, GetSpellInfo(6262)),  _detalhes:ToK(hs.total))\n				GameCooltip:AddIcon (select (3, GetSpellInfo (6262)), 1, 1, 16, 16)\n				GameCooltip:AddStatusBar (100, 1, R, G, B, A)\n			end\n			\n			local pot = actor:GetSpell (DETAILS_HEALTH_POTION_ID)\n			if (pot) then\n				GameCooltip:AddLine (select (1, GetSpellInfo(DETAILS_HEALTH_POTION_ID)),  _detalhes:ToK(pot.total))\n				GameCooltip:AddIcon (select (3, GetSpellInfo (DETAILS_HEALTH_POTION_ID)), 1, 1, 16, 16)\n				GameCooltip:AddStatusBar (100, 1, R, G, B, A)\n			end\n			\n			local pot = actor:GetSpell (DETAILS_REJU_POTION_ID)\n			if (pot) then\n				GameCooltip:AddLine (select (1, GetSpellInfo(DETAILS_REJU_POTION_ID)),  _detalhes:ToK(pot.total))\n				GameCooltip:AddIcon (select (3, GetSpellInfo (DETAILS_REJU_POTION_ID)), 1, 1, 16, 16)\n				GameCooltip:AddStatusBar (100, 1, R, G, B, A)\n			end\n\n			--Cooltip code\n			",
				["attribute"] = false,
				["script_version"] = 13,
			}, -- [2]
			{
				["source"] = false,
				["author"] = "Details!",
				["tooltip"] = "				\n			",
				["percent_script"] = "				local value, top, total, combat, instance = ...\n				return string.format (\"%.1f\", value/top*100)\n			",
				["desc"] = "Zeigt für jeden Charakter die Zeit, in der aktiv Schaden verursacht wurde.",
				["icon"] = "Interface\\ICONS\\Achievement_PVP_H_06",
				["spellid"] = false,
				["name"] = "Aktive Schadenzeit",
				["script"] = "				--init:\n				local combat, instance_container, instance = ...\n				local total, amount = 0, 0\n\n				--get the misc actor container\n				local damage_container = combat:GetActorList ( DETAILS_ATTRIBUTE_DAMAGE )\n				\n				--do the loop:\n				for _, player in ipairs ( damage_container ) do \n					if (player.grupo) then\n						local activity = player:Tempo()\n						total = total + activity\n						amount = amount + 1\n						--add amount to the player \n						instance_container:AddValue (player, activity)\n					end\n				end\n				\n				--return:\n				return total, combat:GetCombatTime(), amount\n			",
				["target"] = false,
				["total_script"] = "				local value, top, total, combat, instance = ...\n				local minutos, segundos = math.floor (value/60), math.floor (value%60)\n				return minutos .. \"m \" .. segundos .. \"s\"\n			",
				["attribute"] = false,
				["script_version"] = 1,
			}, -- [3]
			{
				["source"] = false,
				["author"] = "Details!",
				["tooltip"] = "				\n			",
				["percent_script"] = "				local value, top, total, combat, instance = ...\n				return string.format (\"%.1f\", value/top*100)\n			",
				["desc"] = "Zeigt für jeden Charakter die Zeit, in der aktiv Heilung gewirkt wurde.",
				["icon"] = "Interface\\ICONS\\Achievement_PVP_G_06",
				["spellid"] = false,
				["name"] = "Aktive Heilzeit",
				["script"] = "				--init:\n				local combat, instance_container, instance = ...\n				local total, top, amount = 0, 0, 0\n\n				--get the misc actor container\n				local damage_container = combat:GetActorList ( DETAILS_ATTRIBUTE_HEAL )\n				\n				--do the loop:\n				for _, player in ipairs ( damage_container ) do \n					if (player.grupo) then\n						local activity = player:Tempo()\n						total = total + activity\n						amount = amount + 1\n						--add amount to the player \n						instance_container:AddValue (player, activity)\n					end\n				end\n				\n				--return:\n				return total, combat:GetCombatTime(), amount\n			",
				["target"] = false,
				["total_script"] = "				local value, top, total, combat, instance = ...\n				local minutos, segundos = math.floor (value/60), math.floor (value%60)\n				return minutos .. \"m \" .. segundos .. \"s\"\n			",
				["attribute"] = false,
				["script_version"] = 1,
			}, -- [4]
			{
				["source"] = false,
				["author"] = "Details!",
				["desc"] = "Show the crowd control amount for each player.",
				["total_script"] = "				local value, top, total, combat, instance = ...\n				return floor (value)\n			",
				["icon"] = "Interface\\ICONS\\Spell_Frost_FreezingBreath",
				["spellid"] = false,
				["name"] = "Verursachte Massenkontrolle",
				["tooltip"] = "				local actor, combat, instance = ...\n				local spells = {}\n				for spellid, spell in pairs (actor.cc_done_spells._ActorTable) do\n				    tinsert (spells, {spellid, spell.counter})\n				end\n\n				table.sort (spells, _detalhes.Sort2)\n\n				for index, spell in ipairs (spells) do\n				    local name, _, icon = GetSpellInfo (spell [1])\n				    GameCooltip:AddLine (name, spell [2])\n				    _detalhes:AddTooltipBackgroundStatusbar()\n				    GameCooltip:AddIcon (icon, 1, 1, 14, 14)\n				end\n\n				local targets = {}\n				for playername, amount in pairs (actor.cc_done_targets) do\n				    tinsert (targets, {playername, amount})\n				end\n\n				table.sort (targets, _detalhes.Sort2)\n\n				_detalhes:AddTooltipSpellHeaderText (\"Targets\", \"yellow\", #targets)\n				local class, _, _, _, _, r, g, b = _detalhes:GetClass (actor.nome)\n				_detalhes:AddTooltipHeaderStatusbar (1, 1, 1, 0.6)\n\n				for index, target in ipairs (targets) do\n				    GameCooltip:AddLine (target[1], target [2])\n				    _detalhes:AddTooltipBackgroundStatusbar()\n				    \n				    local class, _, _, _, _, r, g, b = _detalhes:GetClass (target [1])\n				    if (class and class ~= \"UNKNOW\") then\n					local texture, l, r, t, b = _detalhes:GetClassIcon (class)\n					GameCooltip:AddIcon (\"Interface\\\\AddOns\\\\Details\\\\images\\\\classes_small_alpha\", 1, 1, 14, 14, l, r, t, b)\n				    else\n					GameCooltip:AddIcon (\"Interface\\\\GossipFrame\\\\IncompleteQuestIcon\", 1, 1, 14, 14)\n				    end\n				    --\n				end\n			",
				["target"] = false,
				["script"] = "				local combat, instance_container, instance = ...\n				local total, top, amount = 0, 0, 0\n\n				local misc_actors = combat:GetActorList (DETAILS_ATTRIBUTE_MISC)\n\n				for index, character in ipairs (misc_actors) do\n					if (character.cc_done and character:IsPlayer()) then\n						local cc_done = floor (character.cc_done)\n						instance_container:AddValue (character, cc_done)\n						total = total + cc_done\n						if (cc_done > top) then\n							top = cc_done\n						end\n						amount = amount + 1\n					end\n				end\n\n				return total, top, amount\n			",
				["attribute"] = false,
				["script_version"] = 9,
			}, -- [5]
			{
				["source"] = false,
				["author"] = "Details!",
				["desc"] = "Show the amount of crowd control received for each player.",
				["total_script"] = "				local value, top, total, combat, instance = ...\n				return floor (value)\n			",
				["icon"] = "Interface\\ICONS\\Spell_Mage_IceNova",
				["spellid"] = false,
				["name"] = "Erhaltene Massenkontrolle",
				["tooltip"] = "				local actor, combat, instance = ...\n				local name = actor:name()\n				local spells, from = {}, {}\n				local misc_actors = combat:GetActorList (DETAILS_ATTRIBUTE_MISC)\n\n				for index, character in ipairs (misc_actors) do\n				    if (character.cc_done and character:IsPlayer()) then\n					local on_actor = character.cc_done_targets [name]\n					if (on_actor) then\n					    tinsert (from, {character:name(), on_actor})\n					    \n					    for spellid, spell in pairs (character.cc_done_spells._ActorTable) do\n						\n						local spell_on_actor = spell.targets [name]\n						if (spell_on_actor) then\n						    local has_spell\n						    for index, spell_table in ipairs (spells) do\n							if (spell_table [1] == spellid) then\n							    spell_table [2] = spell_table [2] + spell_on_actor\n							    has_spell = true\n							end\n						    end\n						    if (not has_spell) then\n							tinsert (spells, {spellid, spell_on_actor}) \n						    end\n						end\n						\n					    end            \n					end\n				    end\n				end\n\n				table.sort (from, _detalhes.Sort2)\n				table.sort (spells, _detalhes.Sort2)\n\n				for index, spell in ipairs (spells) do\n				    local name, _, icon = GetSpellInfo (spell [1])\n				    GameCooltip:AddLine (name, spell [2])\n				    _detalhes:AddTooltipBackgroundStatusbar()\n				    GameCooltip:AddIcon (icon, 1, 1, 14, 14)    \n				end\n\n				_detalhes:AddTooltipSpellHeaderText (\"From\", \"yellow\", #from)\n				_detalhes:AddTooltipHeaderStatusbar (1, 1, 1, 0.6)\n\n				for index, t in ipairs (from) do\n				    GameCooltip:AddLine (t[1], t[2])\n				    _detalhes:AddTooltipBackgroundStatusbar()\n				    \n				    local class, _, _, _, _, r, g, b = _detalhes:GetClass (t [1])\n				    if (class and class ~= \"UNKNOW\") then\n					local texture, l, r, t, b = _detalhes:GetClassIcon (class)\n					GameCooltip:AddIcon (\"Interface\\\\AddOns\\\\Details\\\\images\\\\classes_small_alpha\", 1, 1, 14, 14, l, r, t, b)\n				    else\n					GameCooltip:AddIcon (\"Interface\\\\GossipFrame\\\\IncompleteQuestIcon\", 1, 1, 14, 14)\n				    end     \n				    \n				end\n			",
				["target"] = false,
				["script"] = "				local combat, instance_container, instance = ...\n				local total, top, amt = 0, 0, 0\n\n				local misc_actors = combat:GetActorList (DETAILS_ATTRIBUTE_MISC)\n				DETAILS_CUSTOM_CC_RECEIVED_CACHE = DETAILS_CUSTOM_CC_RECEIVED_CACHE or {}\n				wipe (DETAILS_CUSTOM_CC_RECEIVED_CACHE)\n\n				for index, character in ipairs (misc_actors) do\n				    if (character.cc_done and character:IsPlayer()) then\n					\n					for player_name, amount in pairs (character.cc_done_targets) do\n					    local target = combat (1, player_name) or combat (2, player_name)\n					    if (target and target:IsPlayer()) then\n						instance_container:AddValue (target, amount)\n						total = total + amount\n						if (amount > top) then\n						    top = amount\n						end\n						if (not DETAILS_CUSTOM_CC_RECEIVED_CACHE [player_name]) then\n						    DETAILS_CUSTOM_CC_RECEIVED_CACHE [player_name] = true\n						    amt = amt + 1\n						end\n					    end\n					end\n					\n				    end\n				end\n\n				return total, top, amt\n			",
				["attribute"] = false,
				["script_version"] = 1,
			}, -- [6]
			{
				["source"] = false,
				["author"] = "Details!",
				["percent_script"] = "				local value, top, total, combat, instance = ...\n				local dps = _detalhes:ToK (floor (value) / combat:GetCombatTime())\n				local percent = string.format (\"%.1f\", value/total*100)\n				return dps .. \", \" .. percent\n			",
				["desc"] = "Zeigt deine Zauber im Fenster.",
				["tooltip"] = "			--config:\n			--Background RBG and Alpha:\n			local R, G, B, A = 0, 0, 0, 0.75\n			local R, G, B, A = 0.1960, 0.1960, 0.1960, 0.8697\n\n			--get the parameters passed\n			local spell, combat, instance = ...\n\n			--get the cooltip object (we dont use the convencional GameTooltip here)\n			local GC = GameCooltip\n			GC:SetOption (\"YSpacingMod\", 0)\n\n			local role = UnitGroupRolesAssigned (\"player\")\n\n			if (spell.n_dmg) then\n			    \n			    local spellschool, schooltext = spell.spellschool, \"\"\n			    if (spellschool) then\n				local t = _detalhes.spells_school [spellschool]\n				if (t and t.name) then\n				    schooltext = t.formated\n				end\n			    end\n			    \n			    local total_hits = spell.counter\n			    local combat_time = instance.showing:GetCombatTime()\n			    \n			    local debuff_uptime_total, cast_string = \"\", \"\"\n			    local misc_actor = instance.showing (4, _detalhes.playername)\n			    if (misc_actor) then\n				local debuff_uptime = misc_actor.debuff_uptime_spells and misc_actor.debuff_uptime_spells._ActorTable [spell.id] and misc_actor.debuff_uptime_spells._ActorTable [spell.id].uptime\n				if (debuff_uptime) then\n				    debuff_uptime_total = floor (debuff_uptime / instance.showing:GetCombatTime() * 100)\n				end\n				\n				local spell_cast = misc_actor.spell_cast and misc_actor.spell_cast [spell.id]\n				\n				if (not spell_cast and misc_actor.spell_cast) then\n				    local spellname = GetSpellInfo (spell.id)\n				    for casted_spellid, amount in pairs (misc_actor.spell_cast) do\n					local casted_spellname = GetSpellInfo (casted_spellid)\n					if (casted_spellname == spellname) then\n					    spell_cast = amount .. \" (|cFFFFFF00?|r)\"\n					end\n				    end\n				end\n				if (not spell_cast) then\n				    spell_cast = \"(|cFFFFFF00?|r)\"\n				end\n				cast_string = cast_string .. spell_cast\n			    end\n			    \n			    --Cooltip code\n			    GC:AddLine (\"Casts:\", cast_string or \"?\")\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    if (debuff_uptime_total ~= \"\") then\n				GC:AddLine (\"Uptime:\", (debuff_uptime_total or \"?\") .. \"%\")\n				GC:AddStatusBar (100, 1, R, G, B, A)\n			    end\n			    \n			    GC:AddLine (\"Hits:\", spell.counter)\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    local average = spell.total / total_hits\n			    GC:AddLine (\"Average:\", _detalhes:ToK (average))\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    GC:AddLine (\"E-Dps:\", _detalhes:ToK (spell.total / combat_time))\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    GC:AddLine (\"School:\", schooltext)\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    --GC:AddLine (\" \")\n			    \n			    GC:AddLine (\"Normal Hits: \", spell.n_amt .. \" (\" ..floor ( spell.n_amt/total_hits*100) .. \"%)\")\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    local n_average = spell.n_dmg / spell.n_amt\n			    local T = (combat_time*spell.n_dmg)/spell.total\n			    local P = average/n_average*100\n			    T = P*T/100\n			    \n			    GC:AddLine (\"Average / E-Dps: \",  _detalhes:ToK (n_average) .. \" / \" .. format (\"%.1f\",spell.n_dmg / T ))\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    --GC:AddLine (\" \")\n			    \n			    GC:AddLine (\"Critical Hits: \", spell.c_amt .. \" (\" ..floor ( spell.c_amt/total_hits*100) .. \"%)\")\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    if (spell.c_amt > 0) then\n				local c_average = spell.c_dmg/spell.c_amt\n				local T = (combat_time*spell.c_dmg)/spell.total\n				local P = average/c_average*100\n				T = P*T/100\n				local crit_dps = spell.c_dmg / T\n				\n				GC:AddLine (\"Average / E-Dps: \",  _detalhes:ToK (c_average) .. \" / \" .. _detalhes:comma_value (crit_dps))\n			    else\n				GC:AddLine (\"Average / E-Dps: \",  \"0 / 0\")    \n			    end\n			    \n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    --GC:AddLine (\" \")\n			    \n			    GC:AddLine (\"Multistrike: \", spell.m_amt .. \" (\" ..floor ( spell.m_amt/total_hits*100) .. \"%)\")\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    GC:AddLine (\"On Normal / On Critical:\", spell.m_amt - spell.m_crit .. \"  / \" .. spell.m_crit)\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			elseif (spell.n_curado) then\n			    \n			    local spellschool, schooltext = spell.spellschool, \"\"\n			    if (spellschool) then\n				local t = _detalhes.spells_school [spellschool]\n				if (t and t.name) then\n				    schooltext = t.formated\n				end\n			    end\n			    \n			    local total_hits = spell.counter\n			    local combat_time = instance.showing:GetCombatTime()\n			    \n			    --Cooltip code\n			    GC:AddLine (\"Hits:\", spell.counter)\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    local average = spell.total / total_hits\n			    GC:AddLine (\"Average:\", _detalhes:ToK (average))\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    GC:AddLine (\"E-Hps:\", _detalhes:ToK (spell.total / combat_time))\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    GC:AddLine (\"School:\", schooltext)\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    --GC:AddLine (\" \")\n			    \n			    GC:AddLine (\"Normal Hits: \", spell.n_amt .. \" (\" ..floor ( spell.n_amt/total_hits*100) .. \"%)\")\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    local n_average = spell.n_curado / spell.n_amt\n			    local T = (combat_time*spell.n_curado)/spell.total\n			    local P = average/n_average*100\n			    T = P*T/100\n			    \n			    GC:AddLine (\"Average / E-Dps: \",  _detalhes:ToK (n_average) .. \" / \" .. format (\"%.1f\",spell.n_curado / T ))\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    --GC:AddLine (\" \")\n			    \n			    GC:AddLine (\"Critical Hits: \", spell.c_amt .. \" (\" ..floor ( spell.c_amt/total_hits*100) .. \"%)\")\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    if (spell.c_amt > 0) then\n				local c_average = spell.c_curado/spell.c_amt\n				local T = (combat_time*spell.c_curado)/spell.total\n				local P = average/c_average*100\n				T = P*T/100\n				local crit_dps = spell.c_curado / T\n				\n				GC:AddLine (\"Average / E-Hps: \",  _detalhes:ToK (c_average) .. \" / \" .. _detalhes:comma_value (crit_dps))\n			    else\n				GC:AddLine (\"Average / E-Hps: \",  \"0 / 0\")    \n			    end\n			    \n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    --GC:AddLine (\" \")\n			    \n			    GC:AddLine (\"Multistrike: \", spell.m_amt .. \" (\" ..floor ( spell.m_amt/total_hits*100) .. \"%)\")\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			    \n			    GC:AddLine (\"On Normal / On Critical:\", spell.m_amt - spell.m_crit .. \"  / \" .. spell.m_crit)\n			    GC:AddStatusBar (100, 1, R, G, B, A)\n			end\n			",
				["icon"] = "Interface\\ICONS\\ABILITY_MAGE_ARCANEBARRAGE",
				["name"] = "Meine Zauber",
				["spellid"] = false,
				["target"] = false,
				["script"] = "				--get the parameters passed\n				local combat, instance_container, instance = ...\n				--declade the values to return\n				local total, top, amount = 0, 0, 0\n\n				local player\n				local role = UnitGroupRolesAssigned (\"player\")\n				local pet_attribute\n\n				if (role == \"DAMAGER\") then\n					player = combat (DETAILS_ATTRIBUTE_DAMAGE, _detalhes.playername)\n					pet_attribute = DETAILS_ATTRIBUTE_DAMAGE\n				elseif (role == \"HEALER\") then    \n					player = combat (DETAILS_ATTRIBUTE_HEAL, _detalhes.playername)\n					pet_attribute = DETAILS_ATTRIBUTE_HEAL\n				else\n					player = combat (DETAILS_ATTRIBUTE_DAMAGE, _detalhes.playername)\n					pet_attribute = DETAILS_ATTRIBUTE_DAMAGE\n				end\n\n				--do the loop\n\n				if (player) then\n					local spells = player:GetSpellList()\n					for spellid, spell in pairs (spells) do\n						instance_container:AddValue (spell, spell.total)\n						total = total + spell.total\n						if (top < spell.total) then\n							top = spell.total\n						end\n						amount = amount + 1\n					end\n				    \n					for _, PetName in ipairs (player.pets) do\n						local pet = combat (pet_attribute, PetName)\n						if (pet) then\n							for spellid, spell in pairs (pet:GetSpellList()) do\n								instance_container:AddValue (spell, spell.total, nil, \" (\" .. PetName:gsub ((\" <.*\"), \"\") .. \")\")\n								total = total + spell.total\n								if (top < spell.total) then\n									top = spell.total\n								end\n								amount = amount + 1\n							end\n						end\n					end\n				end\n\n				--return the values\n				return total, top, amount\n			",
				["attribute"] = false,
				["script_version"] = 5,
			}, -- [7]
			{
				["source"] = false,
				["author"] = "Details!",
				["desc"] = "Zeigt den Schaden, der mit Totenkopf markierten Zielen zugefügt wurde",
				["tooltip"] = "				--get the parameters passed\n				local actor, combat, instance = ...\n\n				--get the cooltip object (we dont use the convencional GameTooltip here)\n				local GameCooltip = GameCooltip\n\n				--Cooltip code\n				local format_func = Details:GetCurrentToKFunction()\n\n				--Cooltip code\n				local RaidTargets = actor.raid_targets\n\n				local DamageOnStar = RaidTargets [128]\n				if (DamageOnStar) then\n				    --RAID_TARGET_8 is the built-in localized word for 'Skull'.\n				    GameCooltip:AddLine (RAID_TARGET_8 .. \":\", format_func (_, DamageOnStar))\n				    GameCooltip:AddIcon (\"Interface\\\\TARGETINGFRAME\\\\UI-RaidTargetingIcon_8\", 1, 1, 14, 14)\n				    Details:AddTooltipBackgroundStatusbar()\n				end\n			",
				["icon"] = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_8",
				["name"] = "Schaden auf mit dem Totenschädel markierte Ziele",
				["spellid"] = false,
				["target"] = false,
				["script"] = "				--get the parameters passed\n				local Combat, CustomContainer, Instance = ...\n				--declade the values to return\n				local total, top, amount = 0, 0, 0\n				\n				--raid target flags: \n				-- 128: skull \n				-- 64: cross\n				-- 32: square\n				-- 16: moon\n				-- 8: triangle\n				-- 4: diamond\n				-- 2: circle\n				-- 1: star\n				\n				--do the loop\n				for _, actor in ipairs (Combat:GetActorList (DETAILS_ATTRIBUTE_DAMAGE)) do\n				    if (actor:IsPlayer()) then\n					if (actor.raid_targets [128]) then\n					    CustomContainer:AddValue (actor, actor.raid_targets [128])\n					end        \n				    end\n				end\n\n				--if not managed inside the loop, get the values of total, top and amount\n				total, top = CustomContainer:GetTotalAndHighestValue()\n				amount = CustomContainer:GetNumActors()\n\n				--return the values\n				return total, top, amount\n			",
				["attribute"] = false,
				["script_version"] = 2,
			}, -- [8]
			{
				["source"] = false,
				["author"] = "Details!",
				["desc"] = "Zeigt den Schaden, der anderweitig markierten Zielen zugefügt wurde.",
				["tooltip"] = "				--get the parameters passed\n				local actor, combat, instance = ...\n\n				--get the cooltip object\n				local GameCooltip = GameCooltip\n\n				local format_func = Details:GetCurrentToKFunction()\n\n				--Cooltip code\n				local RaidTargets = actor.raid_targets\n\n				local DamageOnStar = RaidTargets [1]\n				if (DamageOnStar) then\n				    GameCooltip:AddLine (RAID_TARGET_1 .. \":\", format_func (_, DamageOnStar))\n				    GameCooltip:AddIcon (\"Interface\\\\TARGETINGFRAME\\\\UI-RaidTargetingIcon_1\", 1, 1, 14, 14)\n				    Details:AddTooltipBackgroundStatusbar()\n				end\n\n				local DamageOnCircle = RaidTargets [2]\n				if (DamageOnCircle) then\n				    GameCooltip:AddLine (RAID_TARGET_2 .. \":\", format_func (_, DamageOnCircle))\n				    GameCooltip:AddIcon (\"Interface\\\\TARGETINGFRAME\\\\UI-RaidTargetingIcon_2\", 1, 1, 14, 14)\n				    Details:AddTooltipBackgroundStatusbar()\n				end\n\n				local DamageOnDiamond = RaidTargets [4]\n				if (DamageOnDiamond) then\n				    GameCooltip:AddLine (RAID_TARGET_3 .. \":\", format_func (_, DamageOnDiamond))\n				    GameCooltip:AddIcon (\"Interface\\\\TARGETINGFRAME\\\\UI-RaidTargetingIcon_3\", 1, 1, 14, 14)\n				    Details:AddTooltipBackgroundStatusbar()\n				end\n\n				local DamageOnTriangle = RaidTargets [8]\n				if (DamageOnTriangle) then\n				    GameCooltip:AddLine (RAID_TARGET_4 .. \":\", format_func (_, DamageOnTriangle))\n				    GameCooltip:AddIcon (\"Interface\\\\TARGETINGFRAME\\\\UI-RaidTargetingIcon_4\", 1, 1, 14, 14)\n				    Details:AddTooltipBackgroundStatusbar()\n				end\n\n				local DamageOnMoon = RaidTargets [16]\n				if (DamageOnMoon) then\n				    GameCooltip:AddLine (RAID_TARGET_5 .. \":\", format_func (_, DamageOnMoon))\n				    GameCooltip:AddIcon (\"Interface\\\\TARGETINGFRAME\\\\UI-RaidTargetingIcon_5\", 1, 1, 14, 14)\n				    Details:AddTooltipBackgroundStatusbar()\n				end\n\n				local DamageOnSquare = RaidTargets [32]\n				if (DamageOnSquare) then\n				    GameCooltip:AddLine (RAID_TARGET_6 .. \":\", format_func (_, DamageOnSquare))\n				    GameCooltip:AddIcon (\"Interface\\\\TARGETINGFRAME\\\\UI-RaidTargetingIcon_6\", 1, 1, 14, 14)\n				    Details:AddTooltipBackgroundStatusbar()\n				end\n\n				local DamageOnCross = RaidTargets [64]\n				if (DamageOnCross) then\n				    GameCooltip:AddLine (RAID_TARGET_7 .. \":\", format_func (_, DamageOnCross))\n				    GameCooltip:AddIcon (\"Interface\\\\TARGETINGFRAME\\\\UI-RaidTargetingIcon_7\", 1, 1, 14, 14)\n				    Details:AddTooltipBackgroundStatusbar()\n				end\n			",
				["icon"] = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_5",
				["name"] = "Schaden auf anderweitig markierte Ziele",
				["spellid"] = false,
				["target"] = false,
				["script"] = "				--get the parameters passed\n				local Combat, CustomContainer, Instance = ...\n				--declade the values to return\n				local total, top, amount = 0, 0, 0\n\n				--do the loop\n				for _, actor in ipairs (Combat:GetActorList (DETAILS_ATTRIBUTE_DAMAGE)) do\n				    if (actor:IsPlayer()) then\n					local total = (actor.raid_targets [1] or 0) --star\n					total = total + (actor.raid_targets [2] or 0) --circle\n					total = total + (actor.raid_targets [4] or 0) --diamond\n					total = total + (actor.raid_targets [8] or 0) --tiangle\n					total = total + (actor.raid_targets [16] or 0) --moon\n					total = total + (actor.raid_targets [32] or 0) --square\n					total = total + (actor.raid_targets [64] or 0) --cross\n					\n					if (total > 0) then\n					    CustomContainer:AddValue (actor, total)\n					end\n				    end\n				end\n\n				--if not managed inside the loop, get the values of total, top and amount\n				total, top = CustomContainer:GetTotalAndHighestValue()\n				amount = CustomContainer:GetNumActors()\n\n				--return the values\n				return total, top, amount\n			",
				["attribute"] = false,
				["script_version"] = 2,
			}, -- [9]
			{
				["source"] = false,
				["author"] = "Details!",
				["desc"] = "Show overall damage done on the fly.",
				["tooltip"] = "				--get the parameters passed\n				local actor, combat, instance = ...\n\n				--get the cooltip object (we dont use the convencional GameTooltip here)\n				local GameCooltip = GameCooltip2\n\n				--Cooltip code\n				--get the overall combat\n				local OverallCombat = Details:GetCombat (-1)\n				--get the current combat\n				local CurrentCombat = Details:GetCombat (0)\n\n				local AllSpells = {}\n\n				--overall\n				local player = OverallCombat [1]:GetActor (actor.nome)\n				local playerSpells = player:GetSpellList()\n				for spellID, spellTable in pairs (playerSpells) do\n				    AllSpells [spellID] = spellTable.total\n				end\n\n				--current\n				local player = CurrentCombat [1]:GetActor (actor.nome)\n				local playerSpells = player:GetSpellList()\n				for spellID, spellTable in pairs (playerSpells) do\n				    AllSpells [spellID] = (AllSpells [spellID] or 0) + (spellTable.total or 0)\n				end\n\n				local sortedList = {}\n				for spellID, total in pairs (AllSpells) do\n				    tinsert (sortedList, {spellID, total})\n				end\n				table.sort (sortedList, Details.Sort2)\n\n				local format_func = Details:GetCurrentToKFunction()\n\n				--build the tooltip\n				for i, t in ipairs (sortedList) do\n				    local spellID, total = unpack (t)\n				    if (total > 1) then\n					local spellName, _, spellIcon = Details.GetSpellInfo (spellID)\n					\n					GameCooltip:AddLine (spellName, format_func (_, total))\n					Details:AddTooltipBackgroundStatusbar()\n					GameCooltip:AddIcon (spellIcon, 1, 1, 14, 14)\n				    end\n				end\n			",
				["icon"] = "Interface\\ICONS\\Achievement_Quests_Completed_08",
				["name"] = "Dynamic Overall Damage",
				["spellid"] = false,
				["target"] = false,
				["script"] = "				--init:\n				local combat, instance_container, instance = ...\n				local total, top, amount = 0, 0, 0\n\n				--get the overall combat\n				local OverallCombat = Details:GetCombat (-1)\n				--get the current combat\n				local CurrentCombat = Details:GetCombat (0)\n\n				--get the damage actor container for overall\n				local damage_container_overall = combat:GetActorList ( DETAILS_ATTRIBUTE_DAMAGE )\n				--get the damage actor container for current\n				local damage_container_current = combat:GetActorList ( DETAILS_ATTRIBUTE_DAMAGE )\n\n				--do the loop:\n				for _, player in ipairs ( damage_container_overall ) do \n				    --only player in group\n				    if (player:IsGroupPlayer()) then\n					instance_container:AddValue (player, player.total)\n				    end\n				end\n\n				for _, player in ipairs ( damage_container_current ) do \n				    --only player in group\n				    if (player:IsGroupPlayer()) then\n					instance_container:AddValue (player, player.total)\n				    end\n				end\n\n				total, top =  instance_container:GetTotalAndHighestValue()\n				amount =  instance_container:GetNumActors()\n\n				--return:\n				return total, top, amount\n			",
				["attribute"] = false,
				["script_version"] = 1,
			}, -- [10]
		},
		["performance_profiles"] = {
			["Dungeon"] = {
				["enabled"] = false,
				["update_speed"] = 1,
				["miscdata"] = true,
				["aura"] = true,
				["heal"] = true,
				["use_row_animations"] = false,
				["energy"] = false,
				["damage"] = true,
			},
			["RaidFinder"] = {
				["enabled"] = false,
				["update_speed"] = 1,
				["miscdata"] = true,
				["aura"] = true,
				["heal"] = true,
				["use_row_animations"] = false,
				["energy"] = false,
				["damage"] = true,
			},
			["Battleground15"] = {
				["enabled"] = false,
				["update_speed"] = 1,
				["miscdata"] = true,
				["aura"] = true,
				["heal"] = true,
				["use_row_animations"] = false,
				["energy"] = false,
				["damage"] = true,
			},
			["Battleground40"] = {
				["enabled"] = false,
				["update_speed"] = 1,
				["miscdata"] = true,
				["aura"] = true,
				["heal"] = true,
				["use_row_animations"] = false,
				["energy"] = false,
				["damage"] = true,
			},
			["Mythic"] = {
				["enabled"] = false,
				["update_speed"] = 1,
				["miscdata"] = true,
				["aura"] = true,
				["heal"] = true,
				["use_row_animations"] = false,
				["energy"] = false,
				["damage"] = true,
			},
			["Arena"] = {
				["enabled"] = false,
				["update_speed"] = 1,
				["miscdata"] = true,
				["aura"] = true,
				["heal"] = true,
				["use_row_animations"] = false,
				["energy"] = false,
				["damage"] = true,
			},
			["Raid30"] = {
				["enabled"] = false,
				["update_speed"] = 1,
				["miscdata"] = true,
				["aura"] = true,
				["heal"] = true,
				["use_row_animations"] = false,
				["energy"] = false,
				["damage"] = true,
			},
			["Raid15"] = {
				["enabled"] = false,
				["update_speed"] = 1,
				["miscdata"] = true,
				["aura"] = true,
				["heal"] = true,
				["use_row_animations"] = false,
				["energy"] = false,
				["damage"] = true,
			},
		},
		["exit_log"] = {
			"1 - Closing Janela Info.", -- [1]
			"2 - Clearing user place from instances.", -- [2]
			"4 - Reversing switches.", -- [3]
			"6 - Saving Config.", -- [4]
			"7 - Saving Profiles.", -- [5]
			"8 - Saving nicktag cache.", -- [6]
		},
		["spell_school_cache"] = {
		},
		["lastUpdateWarning"] = 0,
		["global_plugin_database"] = {
			["DETAILS_PLUGIN_ENCOUNTER_DETAILS"] = {
				["encounter_timers_bw"] = {
				},
				["encounter_timers_dbm"] = {
				},
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