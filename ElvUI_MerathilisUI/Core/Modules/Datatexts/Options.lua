local MER, F, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS')

local _G = _G

local function Datatexts()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.datatexts = {
		type = "group",
		name = L["DataTexts"],
		get = function(info) return E.db.mui.datatexts[ info[#info] ] end,
		set = function(info, value) E.db.mui.datatexts[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = ACH:Header(MER:cOption(L["DataTexts"], 'orange'), 1),
			general = {
				order = 2,
				type = "group",
				name = MER:cOption(L["General"], 'orange'),
				guiInline = true,
				args = {
					RightChatDataText = {
						order = 1,
						type = "toggle",
						name = L["Right Chat DataText"],
					},
				},
			},
		},
	}
end
tinsert(MER.Config, Datatexts)
