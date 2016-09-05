local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local MUF = E:GetModule('MuiUnits');
local UF = E:GetModule('UnitFrames');
local TC = E:GetModule('TargetClass');

-- Cache global variables
-- Lua functions
local _G = _G
local tinsert = table.insert
-- WoW API / Variables
local DEFAULT = DEFAULT

local function UnitFramesTable()
	E.Options.args.mui.args.unitframes = {
		order = 15,
		type = 'group',
		name = L['UnitFrames'],
		childGroups = 'tab',
		disabled = function() return not E.private.unitframe.enable end,
		args = {
			name = {
				order = 1,
				type = 'header',
				name = MER:cOption(L['UnitFrames']),
			},
			player = {
				order = 2,
				type = "group",
				name = L["Player Frame"],
				args = {
					rested = {
						order = 1,
						type = "group",
						name = L["Rest Icon"],
						guiInline = true,
						get = function(info) return E.db['mui']['unitframes']['unit']['player']['rested'][ info[#info] ] end,
						set = function(info, value) E.db['mui']['unitframes']['unit']['player']['rested'][ info[#info] ] = value; UF:Configure_RestingIndicator(_G["ElvUF_Player"]); E:StaticPopup_Show("PRIVATE_RL") end,
						args = {
							xoffset = { order = 1, type = 'range', name = L["X-Offset"], min = -300, max = 300, step = 1 },
							yoffset = { order = 2, type = 'range', name = L["Y-Offset"], min = -150, max = 150, step = 1 },
							size = { order = 3, type = 'range', name = L["Size"], min = 10, max = 60, step = 1 },
							texture = {
								order = 5,
								type = "select",
								name = L["Texture"],
								values = {
									["DEFAULT"] = DEFAULT,
									["SVUI"] = "Supervillian UI",
								},
							},
						},
					},
				},
			},
			target = {
				order = 3,
				type = "group",
				name = L["Target Frame"],
				args = {
					classIcon = {
						order = 1,
						type = "group",
						name = L["Target Class Icon"],
						guiInline = true,
						get = function(info) return E.db['mui']['unitframes']['unit']['target']['classicon'][ info[#info] ] end,
						set = function(info, value) E.db['mui']['unitframes']['unit']['target']['classicon'][ info[#info] ] = value; TC:ToggleSettings() end,
						args = {
							enable = {
								type = 'toggle',
								order = 1,
								name = L["Enable"],
								desc = L["Show class icon for units."],
							},
							size = {
								order = 4,
								type = 'range',
								name = L["Size"],
								desc = L["Size of the indicator icon."],
								min = 12, max = 30, step = 1,
							},
							xOffset = {
								order = 5,
								type = 'range',
								name = L["xOffset"],
								min = -100, max = 100, step = 1,
							},
							yOffset = {
								order = 6,
								type = 'range',
								name = L["yOffset"],
								min = -80, max = 40, step = 1,
							},
						},
					},
				},
			},
		},
	}
end
tinsert(MER.Config, UnitFramesTable)