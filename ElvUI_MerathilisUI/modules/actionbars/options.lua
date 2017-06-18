local MER, E, L, V, P, G = unpack(select(2, ...))
local MAB = E:GetModule("mUIActionbars")

local tinsert = table.insert

local function abTable()
	E.Options.args.mui.args.actionbars = {
		order = 7,
		type = "group",
		name = L["ActionBars"],
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(L["ActionBars"]),
			},
			transparent = {
				order = 2,
				type = "toggle",
				name = L["Transparent Backdrops"],
				desc = L["Applies transparency in all actionbar backdrops and actionbar buttons."],
				disabled = function() return not E.private.actionbar.enable end,
				get = function(info) return E.db.mui.actionbars[ info[#info] ] end,
				set = function(info, value) E.db.mui.actionbars[ info[#info] ] = value; MAB:TransparentBackdrops() end,
			},
		},
	}
end
tinsert(MER.Config, abTable)