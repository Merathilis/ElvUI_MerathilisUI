local MER, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS')
local LO = E:GetModule("Layout")
local DT = E:GetModule("DataTexts")

--Lua functions
local _G = _G

local function Datatexts()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.datatexts = {
		type = "group",
		name = L["DataTexts"],
		args = {
			name = ACH:Header(MER:cOption(L["DataTexts"], 'orange'), 1),
			--general = {
				--order = 2,
				--type = "group",
				--name = MER:cOption(L["General"], 'orange'),
				--guiInline = true,
				--args = {},
			--},
		},
	}
end
--tinsert(MER.Config, Datatexts)
