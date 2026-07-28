local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local MUF = MER:GetModule("MER_UnitFrames")

local options = module.options.modules.args

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
	name = L["UnitFrames"],
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
	},
}
