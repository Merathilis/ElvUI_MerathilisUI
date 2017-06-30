local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = E:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

-- Cache global variables
-- Lua functions
local _G = _G
local tinsert = table.insert
-- WoW API / Variables
local DEFAULT = DEFAULT

local function UnitFramesTable()
	E.Options.args.mui.args.unitframes = {
		order = 15,
		type = "group",
		name = MUF.modName,
		childGroups = "tab",
		disabled = function() return not E.private.unitframe.enable end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(MUF.modName),
			},
			general = {
				order = 2,
				type = "group",
				name = MER:cOption(L["General"]),
				guiInline = true,
				args = {
				},
			},
			player = {
				order = 10,
				type = "group",
				name = L["Player Frame"],
				args = {
					portrait = {
						order = 1,
						type = "execute",
						name = L["Player Portrait"],
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "unitframe", "player", "portrait") end,
					},
				},
			},
			target = {
				order = 11,
				type = "group",
				name = L["Target Frame"],
				args = {
					portrait = {
						order = 1,
						type = "execute",
						name = L["Target Portrait"],
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "unitframe", "target", "portrait") end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, UnitFramesTable)

local strataValues = {
	BACKGROUND = "BACKGROUND",
	LOW = "LOW",
	MEDIUM = "MEDIUM",
	HIGH = "HIGH",
	DIALOG = "DIALOG",
	TOOLTIP = "TOOLTIP",
}

local function ufPlayerTable()
	E.Options.args.unitframe.args.player.args.portrait.args.mui = {
		order = 10,
		type = "group",
		name = MER.Title,
		guiInline = true,
		get = function(info) return E.db.mui.unitframes.player[ info[#info] ] end,
		set = function(info, value) E.db.mui.unitframes.player[ info[#info] ] = value; MUF:ArrangePlayer(); end,
		hidden = function() return IsAddOnLoaded("ElvUI_BenikUI") end,
		args = {
			detachPortrait = {
				order = 1,
				type = "toggle",
				name = L["Detach Portrait"],
				set = function(info, value)
					E.db.mui.unitframes.player[ info[#info] ] = value;
					if value == true then
						E.Options.args.unitframe.args.player.args.portrait.args.width.min = 0
						E.db.unitframe.units.player.portrait.width = 0
						E.db.unitframe.units.player.orientation = "LEFT"
					else
						E.Options.args.unitframe.args.player.args.portrait.args.width.min = 15
						E.db.unitframe.units.player.portrait.width = 45
					end
					UF:CreateAndUpdateUF("player")
				end,
				disabled = function() return E.db.unitframe.units.player.portrait.overlay end,
			},
			portraitTransparent = {
				order = 2,
				type = "toggle",
				name = L["Transparent"],
				desc = L["Apply transparency on the portrait backdrop."],
				disabled = function() return E.db.unitframe.units.player.portrait.overlay end,
			},
			portraitShadow = {
				order = 3,
				type = 'toggle',
				name = L["Shadow"],
				desc = L["Apply shadow under the portrait"],
				disabled = function() return not E.db.mui.unitframes.player.detachPortrait end,
			},
			portraitWidth = {
				order = 4,
				type = 'range',
				name = L["Width"],
				desc = L["Change the detached portrait width"],
				disabled = function() return not E.db.mui.unitframes.player.detachPortrait end,
				min = 10, max = 500, step = 1,
			},
			portraitHeight = {
				order = 5,
				type = "range",
				name = L["Height"],
				desc = L["Change the detached portrait height"],
				disabled = function() return not E.db.mui.unitframes.player.detachPortrait end,
				min = 10, max = 250, step = 1,
			},
			portraitFrameStrata = {
				order = 6,
				type = "select",
				name = L["Frame Strata"],
				disabled = function() return not E.db.mui.unitframes.player.detachPortrait end,
				values = strataValues,
			},
		},
	}
end
tinsert(MER.Config, ufPlayerTable)

local function ufTargetTable()
	E.Options.args.unitframe.args.target.args.portrait.args.mui = {
		order = 10,
		type = "group",
		name = MER.Title,
		guiInline = true,
		get = function(info) return E.db.mui.unitframes.target[ info[#info] ] end,
		set = function(info, value) E.db.mui.unitframes.target[ info[#info] ] = value; MUF:ArrangeTarget(); end,
		hidden = function() return IsAddOnLoaded("ElvUI_BenikUI") end,
		args = {
			detachPortrait = {
				order = 1,
				type = "toggle",
				name = L["Detach Portrait"],
				set = function(info, value)
					E.db.mui.unitframes.target[ info[#info] ] = value;
					if value == true then
						E.Options.args.unitframe.args.target.args.portrait.args.width.min = 0
						E.db.unitframe.units.target.portrait.width = 0
						E.db.unitframe.units.target.orientation = "RIGHT"
					else
						E.Options.args.unitframe.args.target.args.portrait.args.width.min = 15
						E.db.unitframe.units.target.portrait.width = 45
					end
					UF:CreateAndUpdateUF("target")
				end,
				disabled = function() return E.db.unitframe.units.target.portrait.overlay end,
			},
			portraitTransparent = {
				order = 2,
				type = "toggle",
				name = L["Transparent"],
				desc = L["Makes the portrait backdrop transparent"],
				disabled = function() return E.db.unitframe.units.target.portrait.overlay end,
			},
			portraitShadow = {
				order = 3,
				type = "toggle",
				name = L["Shadow"],
				desc = L["Add shadow under the portrait"],
				disabled = function() return not E.db.mui.unitframes.target.detachPortrait end,
			},
			getPlayerPortraitSize = {
				order = 4,
				type = "toggle",
				name = L["Player Size"],
				desc = L["Copy Player portrait width and height"],
				disabled = function() return not E.db.mui.unitframes.target.detachPortrait end,
			},
			portraitWidth = {
				order = 5,
				type = "range",
				name = L["Width"],
				desc = L["Change the detached portrait width"],
				disabled = function() return E.db.mui.unitframes.target.getPlayerPortraitSize or not E.db.mui.unitframes.target.detachPortrait end,
				min = 10, max = 500, step = 1,
			},
			portraitHeight = {
				order = 6,
				type = "range",
				name = L["Height"],
				desc = L["Change the detached portrait height"],
				disabled = function() return E.db.mui.unitframes.target.getPlayerPortraitSize or not E.db.mui.unitframes.target.detachPortrait end,
				min = 10, max = 250, step = 1,
			},
			portraitFrameStrata = {
				order = 7,
				type = "select",
				name = L["Frame Strata"],
				disabled = function() return not E.db.mui.unitframes.target.detachPortrait end,
				values = strataValues,
			},
		},
	}
end
tinsert(MER.Config, ufTargetTable)