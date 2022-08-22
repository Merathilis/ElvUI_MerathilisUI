local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_ExtendedVendor')
local options = MER.options.modules.args

local format = string.format

options.merchant = {
	type = "group",
	name = L["Extended Vendor"],
	get = function(info)
		return E.db.mui.merchant[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.merchant[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	disabled = function()
		return module.StopRunning
	end,
	hidden = not E.Retail,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Extended Vendor"], 'orange'),
		},
		desc = {
			order = 0,
			type = "group",
			inline = true,
			name = F.cOption(L["Description"], 'orange'),
			args = {
				feature = {
					order = 1,
					type = "description",
					name = function()
						if module.StopRunning then
							return format("|cffff0000" .. L["Because of %s, this module will not be loaded."] .. "|r", module.StopRunning)
						else
							return L["Extends the merchant page to show more items."]
						end
					end,
					fontSize = "medium"
				},
			},
		},
		merchant = {
			order = 1,
			type = "group",
			name = E.NewSign..F.cOption(L["Extended Vendor"], 'orange'),
			guiInline = true,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					width = "full",
				},
				numberOfPages = {
					order = 2,
					type = "range",
					name = L["Number of Pages"],
					desc = L["The number of pages shown in the merchant frame."],
					min = 2, max = 6, step = 1
				},
			},
		},
	},
}
