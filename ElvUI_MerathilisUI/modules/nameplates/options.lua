local MER, E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")
local NA = MER:GetModule("NameplateAuras")
local COMP = MER:GetModule("mUICompatibility")

--Cache global variables
local pairs, select, tonumber, tostring, type = pairs, select, tonumber, tostring, type
local setmetatable = setmetatable
local getmetatable = getmetatable
local format = string.format
--WoW API / Variables
local GetSpellInfo = GetSpellInfo
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: deepcopy

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
	if not selectedSpellID or not E.global['nameplate']['spellList'][selectedSpellID] then
		E.Options.args.mui.args.modules.args.NameplateAuras.args.specificSpells.args.spellGroup = nil
		return
	end

	local name, _, icon = GetSpellInfo(selectedSpellID)
	local formatStr = [[%s |T%s:16:16:0:0:64:64:4:60:4:60|t]]
	E.Options.args.mui.args.modules.args.NameplateAuras.args.specificSpells.args.spellGroup = {
		type = 'group',
		name = MER:cOption(formatStr:format(name, icon)),
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
				disabled = function() return not E.db.mui.NameplateAuras.enable end,
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
				disabled = function() return not E.db.mui.NameplateAuras.enable end,
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
				disabled = function() return not E.db.mui.NameplateAuras.enable end,
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
				disabled = function() return not E.db.mui.NameplateAuras.enable end,
			},
		},
	}
end

local function NameplateAurasTable()
	E.Options.args.mui.args.modules.args.NameplateAuras = {
		type = "group",
		name = NA.modName,
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
				end,
				disabled = function() return not E.db.mui.NameplateAuras.enable end,
			},
			resetSpellList = {
				order = 3,
				type = "execute",
				name = L["Restore Spell List"],
				desc = L["Restores the default list of specific spells and their configurations."],
				func = function()
					E.global["nameplate"]["spellList"] = deepcopy(E.global["nameplate"]["spellListDefault"]["defaultSpellList"])
					UpdateSpellGroup()
				end,
				disabled = function() return not E.db.mui.NameplateAuras.enable end,
			},
			spacer = {
				order = 4,
				type = "description",
				name = "",
			},
			enable = {
				order = 5,
				type = "toggle",
				name = L["Enable"],
				set = function(info, value)  E.db.mui.NameplateAuras[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				disabled = COMP.CUI,
			},
			specificSpells = {
				order = 6,
				type = "group",
				name = MER:cOption(L["Specific Auras"]),
				guiInline = true,
				disabled = function() return not E.db.mui.NameplateAuras.enable end,
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
								MER:Print(L["Not valid spell name or spell ID"])
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
						disabled = function() return not E.db.mui.NameplateAuras.enable end,
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
						end,
						disabled = function() return not E.db.mui.NameplateAuras.enable end,
					},
				},
			},
			otherSpells = {
				order = 7,
				type = "group",
				name = MER:cOption(L["Other Auras"]),
				guiInline = true,
				disabled = function() return not E.db.mui.NameplateAuras.enable end,
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
						disabled = function() return not E.db.mui.NameplateAuras.enable end,
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
						disabled = function() return not E.db.mui.NameplateAuras.enable end,
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
						disabled = function() return not E.db.mui.NameplateAuras.enable end,
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
						disabled = function() return not E.db.mui.NameplateAuras.enable end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, NameplateAurasTable)