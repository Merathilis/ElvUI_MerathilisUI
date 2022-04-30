local MER, F, E, L, V, P, G = unpack(select(2, ...))
local MAB = MER:GetModule('MER_Actionbars')
local VB = MER:GetModule('MER_VehicleBar')

local unpack = unpack
local CopyTable = CopyTable
local tinsert = table.insert

local textAnchors = { BOTTOMRIGHT = 'BOTTOMRIGHT', BOTTOMLEFT = 'BOTTOMLEFT', TOPRIGHT = 'TOPRIGHT', TOPLEFT = 'TOPLEFT', BOTTOM = 'BOTTOM', TOP = 'TOP' }
local getTextColor = function(info) local t = E.db.mui.actionbars[info[#info-3]][info[#info]] local d = P.mui.actionbars[info[#info-3]][info[#info]] return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a end
local setTextColor = function(info, r, g, b, a) local t = E.db.mui.actionbars[info[#info-3]][info[#info]] t.r, t.g, t.b, t.a = r, g, b, a VB:UpdateButtonSettings() end

local function ActionBarTable()
	local ACH = E.Libs.ACH
	local C = unpack(E.OptionsUI)

	local SharedBarOptions = {
		enable = ACH:Toggle(L["Enable"], nil, 0),
		generalOptions = ACH:MultiSelect('', nil, 3, { backdrop = L["Backdrop"], mouseover = L["Mouseover"], clickThrough = L["Click Through"] }, nil, nil, nil, nil, function() return not E.db.mui.actionbars.vehicle.enable end),
		buttonGroup = ACH:Group(L["Button Settings"], nil, 4, nil, nil, nil, function() return not E.db.mui.actionbars.vehicle.enable end),
		backdropGroup = ACH:Group(L["Backdrop Settings"], nil, 5, nil, nil, nil, function() return not E.db.mui.actionbars.vehicle.enable end),
		barGroup = ACH:Group(L["Bar Settings"], nil, 6, nil, nil, nil, function() return not E.db.mui.actionbars.vehicle.enable end),
	}

	E.Options.args.mui.args.modules.args.actionbars = {
		type = "group",
		name = L["ActionBars"],
		get = function(info) return E.db.mui.actionbars[ info[#info] ] end,
		set = function(info, value) E.db.mui.actionbars[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = ACH:Header(MER:cOption(L["ActionBars"], 'orange'), 1),
			general = {
				order = 2,
				type = "group",
				name = MER:cOption(L["General"], 'orange'),
				guiInline = true,
				args = { },
			},
			specBar = {
				order = 3,
				type = "group",
				name = MER:cOption(L["Specialization Bar"], 'orange'),
				guiInline = true,
				disabled = function() return not E.private.actionbar.enable end,
				hidden = not E.Retail,
				get = function(info) return E.db.mui.actionbars.specBar[ info[#info] ] end,
				set = function(info, value) E.db.mui.actionbars.specBar[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						disabled = function() return not E.private.actionbar.enable end,
					},
					mouseover = {
						order = 2,
						type = "toggle",
						name = L["Mouseover"],
						disabled = function() return not E.private.actionbar.enable end,
					},
					size = {
						order = 3,
						type = "range",
						name = L["Button Size"],
						min = 20, max = 60, step = 1,
						disabled = function() return not E.private.actionbar.enable end,
					},
				},
			},
			equipBar = {
				order = 4,
				type = "group",
				name = MER:cOption(L["EquipSet Bar"], 'orange'),
				guiInline = true,
				disabled = function() return not E.private.actionbar.enable end,
				hidden = not E.Retail,
				get = function(info) return E.db.mui.actionbars.equipBar[ info[#info] ] end,
				set = function(info, value) E.db.mui.actionbars.equipBar[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						disabled = function() return not E.private.actionbar.enable end,
					},
					mouseover = {
						order = 2,
						type = "toggle",
						name = L["Mouseover"],
						disabled = function() return not E.private.actionbar.enable end,
					},
					size = {
						order = 3,
						type = "range",
						name = L["Button Size"],
						min = 20, max = 60, step = 1,
						disabled = function() return not E.private.actionbar.enable end,
					},
				},
			},
		},
	}

	SharedBarOptions.buttonGroup.inline = true
	SharedBarOptions.buttonGroup.args.buttonsPerRow = ACH:Range(L["Buttons Per Row"], L["The amount of buttons to display per row."], 2, { min = 1, max = 7, step = 1 })
	SharedBarOptions.buttonGroup.args.buttonSpacing = ACH:Range(L["Button Spacing"], L["The spacing between buttons."], 3, { min = -3, max = 20, step = 1 })
	SharedBarOptions.buttonGroup.args.buttonSize = ACH:Range('', nil, 4, { softMin = 14, softMax = 64, min = 12, max = 128, step = 1 })
	SharedBarOptions.buttonGroup.args.buttonHeight = ACH:Range(L["Button Height"], L["The height of the action buttons."], 5, { softMin = 14, softMax = 64, min = 12, max = 128, step = 1 })

	SharedBarOptions.barGroup.inline = true
	SharedBarOptions.barGroup.args.point = ACH:Select(L["Anchor Point"], L["The first button anchors itself to this point on the bar."], 1, { TOPLEFT = 'TOPLEFT', TOPRIGHT = 'TOPRIGHT', BOTTOMLEFT = 'BOTTOMLEFT', BOTTOMRIGHT = 'BOTTOMRIGHT' })
	SharedBarOptions.barGroup.args.alpha = ACH:Range(L["Alpha"], nil, 2, { min = 0, max = 1, step = 0.01, isPercent = true })

	SharedBarOptions.barGroup.args.strataAndLevel = ACH:Group(L["Strata and Level"], nil, 30)
	SharedBarOptions.barGroup.args.strataAndLevel.args.frameStrata = ACH:Select(L["Frame Strata"], nil, 3, { BACKGROUND = 'BACKGROUND', LOW = 'LOW', MEDIUM = 'MEDIUM', HIGH = 'HIGH' })
	SharedBarOptions.barGroup.args.strataAndLevel.args.frameLevel = ACH:Range(L["Frame Level"], nil, 4, { min = 1, max = 256, step = 1 })

	SharedBarOptions.barGroup.args.hotkeyTextGroup = ACH:Group(L["Keybind Text"], nil, 40, nil, function(info) return E.db.mui.actionbars.vehicle[info[#info]] end, function(info, value) E.db.mui.actionbars.vehicle[info[#info]] = value; VB:UpdateButtonSettings() end)
	SharedBarOptions.barGroup.args.hotkeyTextGroup.inline = true
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.hotkeytext = ACH:Toggle(L["Enable"], L["Display bind names on action buttons."], 0, nil, nil, nil, nil, nil, nil, false)
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.useHotkeyColor = ACH:Toggle(L["Custom Color"], nil, 1)
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.hotkeyColor = ACH:Color('', nil, 2, nil, nil, getTextColor, setTextColor, function() return not E.db.mui.actionbars.vehicle.enable or not E.db.mui.actionbars.vehicle.hotkeytext end, function() return not E.db.mui.actionbars.vehicle.useHotkeyColor end)
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.spacer1 = ACH:Spacer(3, 'full')
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.hotkeyTextPosition = ACH:Select(L["Position"], nil, 4, textAnchors, nil, nil, nil, nil, function() return not E.db.mui.actionbars.vehicle.enable or (E.Masque and E.private.actionbar.masque.actionbars) end)
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.hotkeyTextXOffset = ACH:Range(L["X-Offset"], nil, 5, { min = -24, max = 24, step = 1 }, nil, nil, nil, function() return not E.db.mui.actionbars.vehicle.enable or (E.Masque and E.private.actionbar.masque.actionbars) end)
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.hotkeyTextYOffset = ACH:Range(L["Y-Offset"], nil, 6, { min = -24, max = 24, step = 1 }, nil, nil, nil, function() return not E.db.mui.actionbars.vehicle.enable or (E.Masque and E.private.actionbar.masque.actionbars) end)
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.spacer2 = ACH:Spacer(7, 'full')
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.hotkeyFont = ACH:SharedMediaFont(L["Font"], nil, 8)
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.hotkeyFontOutline = ACH:FontFlags(L["Font Outline"], nil, 9)
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.hotkeyFontSize = ACH:Range(L["Font Size"], nil, 10, C.Values.FontSize)

	SharedBarOptions.backdropGroup.inline = true
	SharedBarOptions.backdropGroup.args.backdropSpacing = ACH:Range(L["Backdrop Spacing"], L["The spacing between the backdrop and the buttons."], 1, { min = 0, max = 10, step = 1 })
	SharedBarOptions.backdropGroup.args.heightMult = ACH:Range(L["Height Multiplier"], L["Multiply the backdrops height or width by this value. This is usefull if you wish to have more than one bar behind a backdrop."], 2, { min = 1, max = 5, step = 1 })
	SharedBarOptions.backdropGroup.args.widthMult = ACH:Range(L["Width Multiplier"], L["Multiply the backdrops height or width by this value. This is usefull if you wish to have more than one bar behind a backdrop."], 2, { min = 1, max = 5, step = 1 })

	local ActionBar = E.Options.args.mui.args.modules.args.actionbars

	local vehicle = ACH:Group(MER:cOption(L["Vehicle Bar"], 'orange'), nil, 5, 'group', function(info) return E.db.mui.actionbars.vehicle[info[#info]] end, function(info, value) E.db.mui.actionbars.vehicle[info[#info]] = value; VB:PositionAndSizeBar() end)
	ActionBar.args.vehicle = vehicle

	vehicle.guiInline = true
	vehicle.args = CopyTable(SharedBarOptions)
	vehicle.args.enable.set = function(info, value) E.db.mui.actionbars.vehicle[info[#info]] = value; VB:PositionAndSizeBar() end

	vehicle.args.generalOptions.get = function(_, key) return E.db.mui.actionbars.vehicle[key] end
	vehicle.args.generalOptions.set = function(_, key, value) E.db.mui.actionbars.vehicle[key] = value VB:UpdateButtonSettings() end
	vehicle.args.generalOptions.values.showGrid = L["Show Empty Buttons"]
	vehicle.args.generalOptions.values.keepSizeRatio = L["Keep Size Ratio"]

	vehicle.args.buttonGroup.args.buttonSize.name = function() return E.db.mui.actionbars.vehicle.keepSizeRatio and L["Button Size"] or L["Button Width"] end
	vehicle.args.buttonGroup.args.buttonSize.desc = function() return E.db.mui.actionbars.vehicle.keepSizeRatio and L["The size of the action buttons."] or L["The width of the action buttons."] end
	vehicle.args.buttonGroup.args.buttonHeight.hidden = function() return E.db.mui.actionbars.vehicle.keepSizeRatio end

	vehicle.args.backdropGroup.hidden = function() return not E.db.mui.actionbars.vehicle.backdrop end
end
tinsert(MER.Config, ActionBarTable)
