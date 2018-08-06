local MER, E, L, V, P, G = unpack(select(2, ...))
local MM = E:GetModule("mUIMinimap")

local function Minimap()
	E.Options.args.mui.args.minimap = {
		type = "group",
		name = E.NewSign..MINIMAP_LABEL,
		order = 16,
		get = function(info) return E.db.mui.maps.minimap[ info[#info] ] end,
		set = function(info, value) E.db.mui.maps.minimap[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		disabled = function() return not E.private.general.minimap.enable end,
		args = {
			header1 = {
				type = "header",
				name = MER:cOption(MINIMAP_LABEL),
				order = 1,
			},
			general = {
				order = 2,
				type = "group",
				name = MER:cOption(L["General"]),
				guiInline = true,
				args = {
					styleButton = {
						order = 1,
						type = "toggle",
						name = L["Garrison/OrderHall Buttons Style"],
						desc = L["Change the look of the Orderhall/Garrison Button"],
					},
					ping = {
						order = 2,
						type = "toggle",
						name = E.NewSign..L["Minimap Ping"],
						desc = L["Shows the name of the player who pinged on the Minimap."],
					},
				},
			},
			coords = {
				order = 3,
				type = "group",
				name = MER:cOption(L["Coordinates"]),
				guiInline = true,
				get = function(info) return E.db.mui.maps.minimap.coords[ info[#info] ] end,
				set = function(info, value) E.db.mui.maps.minimap.coords[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					position = {
						order = 2,
						type = "select",
						name = L["Position"],
						values = {
							["TOP"] = L["Top"],
							["BOTTOM"] = L["Bottom"],
							["LEFT"] = L["Left"],
							["RIGHT"] = L["Right"],
							["CENTER"] = L["Center"],
						},
					},
				},
			},
			buttonCollector = {
				order = 4,
				type = "group",
				name = MER:cOption(L["MiniMap Buttons"]),
				guiInline = true,
				get = function(info) return E.db.mui.maps.minimap.buttonCollector[ info[#info] ] end,
				set = function(info, value) E.db.mui.maps.minimap.buttonCollector[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					position = {
						order = 2,
						type = "select",
						name = L["Position"],
						values = {
							["TOP"] = L["Top"],
							["BOTTOM"] = L["Bottom"],
						},
					},
				},
			},
		},
	}
end
tinsert(MER.Config, Minimap)