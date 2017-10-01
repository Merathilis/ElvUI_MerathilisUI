local MER, E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")
local NA = E:GetModule("NameplateAuras")

local selectedSpellID
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
	if not selectedSpellID or not E.global['nameplate']['spellList'][selectedSpellID]  then
		E.Options.args.mui.args.NameplateAuras.args.specificSpells.args.spellGroup = nil
		return
	end

	E.Options.args.mui.args.NameplateAuras.args.specificSpells.args.spellGroup = {
		type = 'group',
		name = GetSpellInfo(selectedSpellID),
		guiInline = true,
		order = -10,
		get = function(info) return E.global["nameplate"]['spellList'][selectedSpellID][ info[#info] ] end,
		set = function(info, value) E.global["nameplate"]['spellList'][selectedSpellID][ info[#info] ] = value; NP:UpdateAllPlates(); UpdateSpellGroup() end,
		args = {
			visibility = {
				type = 'select',
				order = 1,
				name = L['Visibility'],
				desc = L['Set when this aura is visble.'],
				values = {[1]=L["Always"],[2]=L["Never"],[3]=L["Only Mine"]},
				get = function(info)
					return E.global['nameplate']['spellList'][selectedSpellID]["visibility"]
				end,
				set = function(info, value)
					E.global['nameplate']['spellList'][selectedSpellID]["visibility"] = value
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
					return E.global['nameplate']['spellList'][selectedSpellID]["width"]
				end,
				set = function(info, value)
					E.global['nameplate']['spellList'][selectedSpellID]["width"] = value
					if E.global['nameplate']['spellList'][selectedSpellID]["lockAspect"] then
						E.global['nameplate']['spellList'][selectedSpellID]["height"] = value
					end
				end,
			},
			height = {
				type = 'range',
				order = 3,
				name = L['Icon Height'],
				desc = L['Set the height of this spells icon.'],
				disabled = function() return E.global['nameplate']['spellList'][selectedSpellID]["lockAspect"] end,
				min = 10,
				max = 100,
				step = 2,
				get = function(info)
					return E.global['nameplate']['spellList'][selectedSpellID]["height"]
				end,
				set = function(info, value)
					E.global['nameplate']['spellList'][selectedSpellID]["height"] = value
				end,
			},
			lockAspect = {
				type = 'toggle',
				order = 4,
				name = L['Lock Aspect Ratio'],
				desc = L['Set if height and width are locked to the same value.'],
				get = function(info)
					return E.global['nameplate']['spellList'][selectedSpellID]["lockAspect"]
				end,
				set = function(info, value)
					E.global['nameplate']['spellList'][selectedSpellID]["lockAspect"] = value
					if value then
						E.global['nameplate']['spellList'][selectedSpellID]["height"] = E.global['nameplate']['spellList'][selectedSpellID]["width"]
					end
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
							if not tonumber(value) then
								value = tostring(value)
							end

							local spellID = select(7, GetSpellInfo(tonumber(value) or value));
							if spellID then
								if not E.global['nameplate']['spellList'][spellID] then
									E.global['nameplate']['spellList'][spellID] = {
										['visibility'] = E.global['nameplate']['spellListDefault']['visibility'],
										['width'] = E.global['nameplate']['spellListDefault']['width'],
										['height'] = E.global['nameplate']['spellListDefault']['height'],
										['lockAspect'] = E.global['nameplate']['spellListDefault']['lockAspect'],
										['stackSize'] = E.global['nameplate']['spellListDefault']['stackSize'],
										['text'] = E.global['nameplate']['spellListDefault']['text'],
										['flashTime'] = E.global['nameplate']['spellListDefault']['flashTime'],
									}
								end
								selectedSpellID = spellID
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
						get = function(info) return selectedSpellID end,
						set = function(info, value) selectedSpellID = tonumber(value:match("%[(%d+)]$")); UpdateSpellGroup() end,
						values = function()
							local spellLists = {}
							for spell in pairs(E.global['nameplate']['spellList']) do
								local spellName = select(1, GetSpellInfo(spell));
								local color = "|cffff0000"
								local visibility = E.global['nameplate']['spellList'][spell]['visibility']
								if visibility == 1 then
									color = "|cff00ff00"
								elseif visibility == 3 then
									color = "|cff00ffff"
								end
								spellLists[format("%s [%i]", spellName, spell)] = color..spellName.."|r"
							end
							return spellLists
						end,
					},
					removeSpell = {
						order = 3,
						type = "execute",
						name = L["Remove Spell"],
						func = function()
							if E.global['nameplate']['spellList'][selectedSpellID] then
								E.global['nameplate']['spellList'][selectedSpellID] = nil
								selectedSpellID = ""
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
				},
			},
		},
	}
end
tinsert(MER.Config, NameplateAurasTable)