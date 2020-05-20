local MER, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS')
local LO = E:GetModule("Layout")
local DT = E:GetModule("DataTexts")

--Cache global variables
--Lua functions
local _G = _G
local pairs, print, type = pairs, print, type
local tinsert = table.insert
--WoW API / Variables
local NONE = NONE
-- GLOBALS: LibStub

local function Datatexts()
	E.Options.args.mui.args.modules.args.datatexts = {
		type = "group",
		name = L["DataTexts"],
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(L["DataTexts"]),
			},
			general = {
				order = 2,
				type = "group",
				name = MER:cOption(L["General"]),
				guiInline = true,
				args = {},
			},
			panels = {
				order = 4,
				type = "group",
				name = MER:cOption(L["DataTexts"]),
				guiInline = true,
				args = {},
			},
			threatBar = {
				order = 5,
				type = "group",
				name = MER:cOption(L["Threat"]),
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						get = function(info) return E.db.mui.datatexts.threatBar.enable end,
						set = function(info, value) E.db.mui.datatexts.threatBar.enable = value; MER:GetModule("ThreatBar"):ToggleEnable()end,
						disabled = function() return not E.db.mui.datatexts.rightChatTabDatatextPanel end,
					},
					textSize = {
						order = 2,
						name = L["FONT_SIZE"],
						type = "range",
						min = 6, max = 22, step = 1,
						get = function(info) return E.db.mui.datatexts.threatBar.textSize end,
						set = function(info, value) E.db.mui.datatexts.threatBar.textSize = value; MER:GetModule("ThreatBar"):UpdatePosition() end,
						disabled = function() return not E.db.mui.datatexts.threatBar.enable or not E.db.mui.datatexts.rightChatTabDatatextPanel end,
					},
					textOutline = {
						order = 3,
						name = L["Font Outline"],
						type = "select",
						get = function(info) return E.db.mui.datatexts.threatBar.textOutline end,
						set = function(info, value) E.db.mui.datatexts.threatBar.textOutline = value; MER:GetModule("ThreatBar"):UpdatePosition() end,
						disabled = function() return not E.db.mui.datatexts.threatBar.enable or not E.db.mui.datatexts.rightChatTabDatatextPanel end,
						values = {
							["NONE"] = NONE,
							["OUTLINE"] = "OUTLINE",
							["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
							["THICKOUTLINE"] = "THICKOUTLINE",
						},
					},
				},
			},
		},
	}
end
tinsert(MER.Config, Datatexts)
