local MER, E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")
local NA = E:GetModule("NameplateAuras")

local selectedSpellName
local spellLists
local spellIDs = {}

function deepcopy(object)
	local lookup_table = {}
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		elseif lookup_table[object] then
			return lookup_table[object]
		end
		local new_table = {}
		lookup_table[object] = new_table
		for index, value in pairs(object) do
			new_table[_copy(index)] = _copy(value)
		end
			return setmetatable(new_table, getmetatable(object))
	end
	return _copy(object)
end

local function UpdateSpellGroup()
	if not selectedSpellName or not E.global['nameplate']['spellList'][selectedSpellName] then
		E.Options.args.mui.args.NameplateAuras.args.specificSpells.args.spellGroup = nil
		return
	end

	E.Options.args.mui.args.NameplateAuras.args.specificSpells.args.spellGroup = {
		type = 'group',
		name = selectedSpellName,
		guiInline = true,
		order = -10,
		get = function(info) return E.global["nameplate"]['spellList'][selectedSpellName][ info[#info] ] end,
		set = function(info, value) E.global["nameplate"]['spellList'][selectedSpellName][ info[#info] ] = value; NP:UpdateAllPlates(); UpdateSpellGroup() end,
		hidden = function() return not MER:IsDeveloper() and MER:IsDeveloperRealm() end,
		args = {
			visibility = {
				type = 'select',
				order = 1,
				name = L['Visibility'],
				desc = L['Set when this aura is visble.'],
				values = {[1]="Always",[2]="Never",[3]="Only Mine"},
				get = function(info)
					return E.global['nameplate']['spellList'][selectedSpellName]["visibility"]
				end,
				set = function(info, value)
					E.global['nameplate']['spellList'][selectedSpellName]["visibility"] = value
				end,
			},
			width = {
				type = 'range',
				order = 2,
				name = L['Icon Width'],
				desc = L['Set the width of this spells icon.'],
				min = 10,
				max = 100,
				step = 2,
				get = function(info)
					return E.global['nameplate']['spellList'][selectedSpellName]["width"]
				end,
				set = function(info, value)
					E.global['nameplate']['spellList'][selectedSpellName]["width"] = value
					if E.global['nameplate']['spellList'][selectedSpellName]["lockAspect"] then
						E.global['nameplate']['spellList'][selectedSpellName]["height"] = value
					end
				end,
			},
			height = {
				type = 'range',
				order = 3,
				name = L['Icon Height'],
				desc = L['Set the height of this spells icon.'],
				disabled = function() return E.global['nameplate']['spellList'][selectedSpellName]["lockAspect"] end,
				min = 10,
				max = 100,
				step = 2,
				get = function(info)
					return E.global['nameplate']['spellList'][selectedSpellName]["height"]
				end,
				set = function(info, value)
					E.global['nameplate']['spellList'][selectedSpellName]["height"] = value
				end,
			},
			lockAspect = {
				type = 'toggle',
				order = 4,
				name = L['Lock Aspect Ratio'],
				desc = L['Set if height and width are locked to the same value.'],
				get = function(info)
					return E.global['nameplate']['spellList'][selectedSpellName]["lockAspect"]
				end,
				set = function(info, value)
					E.global['nameplate']['spellList'][selectedSpellName]["lockAspect"] = value
					if value then
						E.global['nameplate']['spellList'][selectedSpellName]["height"] = E.global['nameplate']['spellList'][selectedSpellName]["width"]
					end
				end,
			},
			text = {
				type = 'range',
				order = 7,
				name = L['Text Size'],
				desc = L['Size of the stack text.'],
				min = 6,
				max = 24,
				step = 1,
				get = function(info)
					return E.global['nameplate']['spellList'][selectedSpellName]["text"]
				end,
				set = function(info, value)
					E.global['nameplate']['spellList'][selectedSpellName]["text"] = value
				end,
			},
		},
	}
end

local function NameplateAurasTable()
	E.Options.args.mui.args.NameplateAuras = {
		type = "group",
		name = NA.modName..MER.NewSign,
		order = 16,
		get = function(info) return E.db.mui.NameplateAuras[ info[#info] ] end,
		hidden = function() return not MER:IsDeveloper() and MER:IsDeveloperRealm() end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(NA.modName),
			},
			clearSpellList = {
				order = 2,
				type = "execute",
				name = L["Clear Spell List"],
				desc = L["Empties the list of specific spells and their configurations."],
				func = function()
					E.global["nameplate"]["spellList"] = { }
					UpdateSpellGroup()
				end
			},
			resetSpellList = {
				order = 3,
				type = "execute",
				name = L["Restore Spell List"],
				desc = L["Restores the default list of specific spells and their configurations."],
				func = function()
					E.global["nameplate"]["spellList"] = deepcopy(E.global["nameplate"]["spellListDefault"]["defaultSpellList"])
					UpdateSpellGroup()
				end
			},
			specificSpells = {
				order = 4,
				type = "group",
				name = MER:cOption(L["Specific Auras"]),
				guiInline = true,
				args = {
					addSpell = {
						type = "input",
						order = 1,
						name = L["Spell Name/ID"],
						desc = L["Input a spell name or spell ID."],
						get = function(info) return "" end,
						set = function(info, value) 
							local spellName = ""

							if not tonumber(value) then
								value = tostring(value)
							end

							if not tonumber(value) and strlower(value) == "school lockout" then
								spellName = "School Lockout"
							elseif not GetSpellInfo(value) then
								if #(spellIDs) == 0 then
									for i = 100000, 1, -1 do --Ugly but works
										local name = GetSpellInfo(i)
										if name and not spellIDs[name] then
											spellIDs[name] = i
										end
									end
								end
								if spellIDs[value] then
									spellName = value
								end
							else
								spellName = GetSpellInfo(value)
							end

							if spellName ~= "" then
								if not E.global['nameplate']['spellList'][spellName] then
									E.global['nameplate']['spellList'][spellName] = {
										['visibility'] = E.global['nameplate']['spellListDefault']['visibility'],
										['width'] = E.global['nameplate']['spellListDefault']['width'],
										['height'] = E.global['nameplate']['spellListDefault']['height'],
										['lockAspect'] = E.global['nameplate']['spellListDefault']['lockAspect'],
										['text'] = E.global['nameplate']['spellListDefault']['text'],
										['flashTime'] = E.global['nameplate']['spellListDefault']['flashTime'],
									}
								end
								selectedSpellName = spellName
								UpdateSpellGroup()
							else
								E:Print(L["Not valid spell name or spell ID"])
							end
						end,
					},
					spellList = {
						order = 2,
						type = "select",
						name = L["Spell List"],
						get = function(info) return selectedSpellName end,
						set = function(info, value) selectedSpellName = value; UpdateSpellGroup() end,
						values = function()
							spellLists = {}
							for spell in pairs(E.global['nameplate']['spellList']) do
								local color = "|cffff0000"
								local visibility = E.global['nameplate']['spellList'][spell]['visibility']
								if visibility == 1 then
									color = "|cff00ff00"
								elseif visibility == 3 then
									color = "|cff00ffff"
								end
								spellLists[spell] = color..spell.."|r"
							end
							return spellLists
						end,
					},
					removeSpell = {
						order = 3,
						type = "execute",
						name = L["Remove Spell"],
						func = function()
							if E.global['nameplate']['spellList'][selectedSpellName] then
								E.global['nameplate']['spellList'][selectedSpellName] = nil
								selectedSpellName = ""
								UpdateSpellGroup()
							end
						end
					},
				},
			},
			otherSpells = {
				order = 5,
				type = "group",
				name = MER:cOption(L["Other Auras"]),
				guiInline = true,
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["These are the settings for all spells not explicitly specified."],
					},
					visibility = {
						type = 'select',
						order = 2,
						name = L["Visibility"],
						desc = L["Set when this aura is visble."],
						values = {[1]=L["Always"],[2]=L["Never"],[3]=L["Only Mine"]},
						get = function(info)
							return E.global['nameplate']['spellListDefault']["visibility"]
						end,
						set = function(info, value)
							E.global['nameplate']['spellListDefault']["visibility"] = value
						end,
					},
					width = {
						type = "range",
						order = 3,
						name = L["Icon Width"],
						desc = L["Set the width of this spells icon."],
						min = 10,
						max = 100,
						step = 2,
						get = function(info)
							return E.global['nameplate']['spellListDefault']["width"]
						end,
						set = function(info, value)
							E.global['nameplate']['spellListDefault']["width"] = value
							if E.global['nameplate']['spellListDefault']["lockAspect"] then
								E.global['nameplate']['spellListDefault']["height"] = value
							end
						end,
					},
					height = {
						type = "range",
						order = 4,
						name = L["Icon Height"],
						desc = L["Set the height of this spells icon."],
						disabled = function() return E.global['nameplate']['spellListDefault']["lockAspect"] end,
						min = 10,
						max = 100,
						step = 2,
						get = function(info)
							return E.global['nameplate']['spellListDefault']["height"]
						end,
						set = function(info, value)
							E.global['nameplate']['spellListDefault']["height"] = value
						end,
					},
					lockAspect = {
						type = "toggle",
						order = 5,
						name = L["Lock Aspect Ratio"],
						desc = L["Set if height and width are locked to the same value."],
						get = function(info)
							return E.global['nameplate']['spellListDefault']["lockAspect"]
						end,
						set = function(info, value)
							E.global['nameplate']['spellListDefault']["lockAspect"] = value
							if value then
								E.global['nameplate']['spellListDefault']["height"] = E.global['nameplate']['spellListDefault']["width"]
							end
						end,
					},
					text = {
						type = "range",
						order = 7,
						name = L["Text Size"],
						desc = L["Size of the stack text."],
						min = 6,
						max = 24,
						step = 1,
						get = function(info)
							return E.global['nameplate']['spellListDefault']["text"]
						end,
						set = function(info, value)
							E.global['nameplate']['spellListDefault']["text"] = value
						end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, NameplateAurasTable)