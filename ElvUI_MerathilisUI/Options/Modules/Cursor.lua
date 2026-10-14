local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
	local Cursor = MER:GetModule("MER_Cursor")

	local options = module.options.modules.args

	local function ModuleDisabled()
		return not E.db.mui.cursor.enable
	end

	-- Own disabled replaces the group's, so every child repeats the module state
	local function SectionDisabled(section)
		return function()
			return ModuleDisabled() or not E.db.mui.cursor[section].enable
		end
	end

	---Group for one part of the cursor (ring, trail, gcd, castCircle) that reads and writes its own table
	local function SectionGroup(order, name, section, args)
		return {
			order = order,
			type = "group",
			guiInline = true,
			name = name,
			disabled = ModuleDisabled,
			get = function(info)
				return E.db.mui.cursor[section][info[#info]]
			end,
			set = function(info, value)
				E.db.mui.cursor[section][info[#info]] = value
				Cursor:SettingsApply()
			end,
			args = args,
		}
	end

	local function EnableArg()
		return {
			order = 1,
			type = "toggle",
			name = L["Enable"],
		}
	end

	local function RadiusArg(order, section, min, max)
		return {
			order = order,
			type = "range",
			name = L["Radius"],
			min = min,
			max = max,
			step = 1,
			disabled = SectionDisabled(section),
		}
	end

	local function AlphaArg(order, section)
		return {
			order = order,
			type = "range",
			name = L["Alpha"],
			min = 0.1,
			max = 1,
			step = 0.05,
			isPercent = true,
			disabled = SectionDisabled(section),
		}
	end

	local function AttachedArg(order, section)
		return {
			order = order,
			type = "toggle",
			name = L["Attach to Cursor"],
			disabled = SectionDisabled(section),
		}
	end

	---Instance/combat filters and the color, shared by all rings
	local function AddCommonArgs(args, order, section)
		local disabled = SectionDisabled(section)

		args.spacerCommon = {
			order = order,
			type = "description",
			name = "",
		}
		args.instanceOnly = {
			order = order + 1,
			type = "toggle",
			name = L["Only In Instances"],
			disabled = disabled,
		}
		args.combatOnly = {
			order = order + 2,
			type = "toggle",
			name = L["Only In Combat"],
			disabled = disabled,
		}
		args.useClassColor = {
			order = order + 3,
			type = "toggle",
			name = L["Use Class Color"],
			disabled = disabled,
		}
		args.color = {
			order = order + 4,
			type = "color",
			name = L["Custom Color"],
			hasAlpha = false,
			disabled = function()
				return disabled() or E.db.mui.cursor[section].useClassColor
			end,
			get = function()
				local db = E.db.mui.cursor[section].color
				local default = P.cursor[section].color
				return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
			end,
			set = function(_, r, g, b)
				local db = E.db.mui.cursor[section].color
				db.r, db.g, db.b = r, g, b
				Cursor:SettingsApply()
			end,
		}

		return args
	end

	options.cursor = {
		type = "group",
		name = module:AddCategorieIcon(L["Cursor"], "cursor"),
		args = {
			header = {
				order = 0,
				type = "header",
				name = L["Cursor"],
			},
			enable = module.ToggleCard({
				order = 2,
				name = L["Enable"],
				desc = L["Show a colored ring around your mouse cursor, with an optional trail, GCD ring and cast-time ring."],
				image = I.Media.Icons.Categories.cursor,
				get = function()
					return E.db.mui.cursor.enable
				end,
				-- The module builds and tears down its frames on a database update
				set = function(_, value)
					E.db.mui.cursor.enable = value
					Cursor:DatabaseUpdate()
				end,
			}),
			preview = module.PreviewOption(2.5, "MERCursorPreview", "cursor"),
			spacer = {
				order = 3,
				type = "description",
				name = "",
			},
			ring = SectionGroup(
				4,
				L["Cursor Ring"],
				"ring",
				AddCommonArgs({
					enable = EnableArg(),
					radius = RadiusArg(2, "ring", 6, 40),
					alpha = AlphaArg(3, "ring"),
					reticle = {
						order = 4,
						type = "toggle",
						name = L["Show Center Dot"],
						disabled = SectionDisabled("ring"),
					},
					onlyWhenHidden = {
						order = 5,
						type = "toggle",
						name = L["Only While Steering Camera"],
						desc = L["Only show the ring while you're holding a mouse button to turn or move the camera (the hardware cursor is hidden)."],
						disabled = SectionDisabled("ring"),
					},
				}, 6, "ring")
			),
			trail = SectionGroup(5, L["Cursor Trail"], "trail", {
				enable = EnableArg(),
			}),
			gcd = SectionGroup(
				6,
				L["GCD Ring"],
				"gcd",
				AddCommonArgs({
					enable = EnableArg(),
					attached = AttachedArg(2, "gcd"),
					radius = RadiusArg(3, "gcd", 10, 60),
					alpha = AlphaArg(4, "gcd"),
				}, 5, "gcd")
			),
			castCircle = SectionGroup(
				7,
				L["Cast Ring"],
				"castCircle",
				AddCommonArgs({
					enable = EnableArg(),
					attached = AttachedArg(2, "castCircle"),
					radius = RadiusArg(3, "castCircle", 10, 60),
					alpha = AlphaArg(4, "castCircle"),
					sparkEnable = {
						order = 5,
						type = "toggle",
						name = L["Show Spark"],
						disabled = SectionDisabled("castCircle"),
					},
				}, 6, "castCircle")
			),
		},
	}
end)
