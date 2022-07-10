local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Mail')
local options = MER.options.modules.args

local pairs = pairs

options.mail = {
	type = "group",
	name = L["Mail"],
	get = function(info)
		return E.db.mui.mail[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.mail[info[#info]] = value
		module:ProfileUpdate()
	end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Mail"], 'orange'),
		},
		panels = {
			order = 1,
			type = "group",
			name = F.cOption(L["Mail"], 'orange'),
			guiInline = true,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					width = "full",
				},
				defaultPage = {
					order = 2,
					type = "select",
					name = L["Default Page"],
					values = {
						ALTS = L["Alternate Character"],
						FRIENDS = L["Online Friends"],
						GUILD = L["Guild Members"],
						FAVORITE = L["Favorites"]
					},
				},
			},
		},
	},
}

do
	local selectedKey

	options.mail.args.alts = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Alternate Character"],
		disabled = function() return not E.db.mui.mail.enable end,
		args = {
			listTable = {
				order = 1,
				type = "select",
				name = L["Alt List"],
				get = function()
					return selectedKey
				end,
				set = function(_, value)
					selectedKey = value
				end,
				values = function()
					local result = {}
					for realm, factions in pairs(E.global.mui.mail.contacts.alts) do
						for _, characters in pairs(factions) do
							for name, class in pairs(characters) do
								result[name .. "-" .. realm] = F.CreateClassColorString(name .. "-" .. realm, class)
							end
						end
					end
					return result
				end
			},
			deleteButton = {
				order = 2,
				type = "execute",
				name = L["Delete"],
				func = function()
					if selectedKey then
						for realm, factions in pairs(E.global.mui.mail.contacts.alts) do
							for faction, characters in pairs(factions) do
								for name, class in pairs(characters) do
									if name .. "-" .. realm == selectedKey then
										E.global.mui.mail.contacts.alts[realm][faction][name] = nil
										selectedKey = nil
										return
									end
								end
							end
						end
					end
				end
			}
		}
	}
end

do
	local selectedKey
	local tempName, tempRealm

	options.mail.args.favorite = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Favorites"],
		disabled = function() return not E.db.mui.mail.enable end,
		args = {
			name = {
				order = 1,
				type = "input",
				name = L["Name"],
				get = function()
					return tempName
				end,
				set = function(_, value)
					tempName = value
				end
			},
			realm = {
				order = 2,
				type = "input",
				name = L["Realm"],
				get = function()
					return tempRealm
				end,
				set = function(_, value)
					tempRealm = value
				end
			},
			addButton = {
				order = 3,
				type = "execute",
				name = L["Add"],
				func = function()
					if tempName and tempRealm then
						E.global.mui.mail.contacts.favorites[tempName .. "-" .. tempRealm] = true
						tempName = nil
						tempRealm = nil
					else
						F.Print(L["Please set the name and realm first."])
					end
				end
			},
			spacer = {
				order = 4,
				type = "description",
				name = " ",
				width = "full"
			},
			listTable = {
				order = 5,
				type = "select",
				name = L["Favorite List"],
				get = function()
					return selectedKey
				end,
				set = function(_, value)
					selectedKey = value
				end,
				values = function()
					local result = {}
					for fullName in pairs(E.global.mui.mail.contacts.favorites) do
						result[fullName] = fullName
					end
					return result
				end
			},
			deleteButton = {
				order = 6,
				type = "execute",
				name = L["Delete"],
				func = function()
					if selectedKey then
						E.global.mui.mail.contacts.favorites[selectedKey] = nil
					end
				end
			},
		},
	}
end
