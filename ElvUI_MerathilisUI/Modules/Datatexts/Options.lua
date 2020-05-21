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
		},
	}
end
tinsert(MER.Config, Datatexts)
