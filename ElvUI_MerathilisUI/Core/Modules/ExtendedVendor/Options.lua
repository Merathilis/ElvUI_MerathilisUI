local MER, F, E, L, V, P, G = unpack(select(2, ...))
local EV = MER:GetModule('MER_ExtendedVendor')

local format = string.format
local tinsert = table.insert

local function ExtendedVendorTable()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.merchant = {
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
			return EV.StopRunning
		end,
		args = {
			header = ACH:Header(F.cOption(L["Extended Vendor"], 'orange'), 0),
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
							if EV.StopRunning then
								return format("|cffff0000" .. L["Because of %s, this module will not be loaded."] .. "|r", EV.StopRunning)
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
end

tinsert(MER.Config, ExtendedVendorTable)
