local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
	-- The runtime is Retail only (talent loadouts, restriction API)
	if E.Forever then
		return
	end

	local LM = MER:GetModule("MER_LoadoutManager")

	local ipairs, pairs, format, tostring, tonumber = ipairs, pairs, format, tostring, tonumber
	local strupper = strupper
	local GetRealZoneText = GetRealZoneText

	local options = module.options.modules.args

	-- The module owns the saved variables, the edit scope and the swap
	-- machinery; this page drives it through the module API. Every label is a
	-- function, so the module's NotifyChange (zone, spec, gear and talent
	-- events while the window is open) keeps the page live.
	local function DB()
		return E.private.mui.loadoutManager
	end

	local function NotEnabled()
		return not DB().enable
	end

	local function Refresh()
		E.Libs.AceConfigRegistry:NotifyChange("ElvUI")
	end

	local PICK_FIRST = L["Pick a gear set or talent loadout under Selected Loadout first."]
	local NOT_IN_INSTANCE = L["Enter a dungeon, raid or other instance first."]
	local NONE = "__none__"

	---------------------------------------------------------------------------
	--  Text helpers
	---------------------------------------------------------------------------
	local function Grey(text)
		return F.String.Muted(tostring(text))
	end

	local function Accent(text)
		return F.String.Color(tostring(text), I.Enum.Colors.MER)
	end

	-- One assignment slot as "gear / talents", or "not set"
	local function PairSummary(gearName, talentStored)
		local talentName = LM:TalentDisplayName(talentStored)
		if not gearName and not talentName then
			return Grey(L["not set"])
		end

		return (gearName and Accent(gearName) or Grey(L["no gear"]))
			.. Grey(" / ")
			.. (talentName and Accent(talentName) or Grey(L["no talents"]))
	end

	-- "Label: value" for the status lines
	local function Line(label, value)
		return label .. ": " .. value
	end

	---------------------------------------------------------------------------
	--  Content types, each specific type next to the one it outranks and Open
	--  World last (it applies on the way out)
	---------------------------------------------------------------------------
	local TYPE_INFO = {}
	for _, info in ipairs(LM.INSTANCE_TYPE_ORDER) do
		TYPE_INFO[info.key] = info
	end

	local TYPE_LAYOUT = { "party", "mplus", "raid", "timewalking", "scenario", "delve", "arena", "pvp", "world" }

	local INSTANCE_KIND = {
		party = L["Dungeon"],
		raid = L["Raid"],
		scenario = L["Scenario"],
		arena = L["Arena"],
		pvp = L["Battleground"],
	}

	---------------------------------------------------------------------------
	--  Scope: "All Specs" plus one entry per specialization
	---------------------------------------------------------------------------
	local ALL_SPECS = "all"

	local function ScopeValues()
		local values = { [ALL_SPECS] = L["All Specs"] }
		for _, spec in ipairs(LM:GetSpecList()) do
			values[tostring(spec.id)] = spec.name
		end

		return values
	end

	local function ScopeSorting()
		local order = { ALL_SPECS }
		for _, spec in ipairs(LM:GetSpecList()) do
			order[#order + 1] = tostring(spec.id)
		end

		return order
	end

	local function ScopeLabel()
		local scope = LM:GetScope()
		return scope and tostring(LM:SpecName(scope)) or L["All Specs"]
	end

	local function HasSelection()
		return LM:GetSelectedSet() ~= nil or LM:GetSelectedTalent() ~= nil
	end

	---------------------------------------------------------------------------
	--  Context readers for the live labels
	---------------------------------------------------------------------------
	local function LocationText()
		local ctx = LM:GetContext()
		if not ctx.inInstance then
			local zone = GetRealZoneText()
			if not zone or zone == "" then
				zone = ctx.name
			end

			return tostring(zone) .. "  " .. Grey(L["open world"])
		end

		local kind = INSTANCE_KIND[ctx.instanceType] or tostring(ctx.instanceType or L["Instance"])
		if ctx.difficultyName and ctx.difficultyName ~= "" then
			kind = kind .. ", " .. ctx.difficultyName
		end

		return tostring(ctx.name) .. "  " .. Grey(kind)
	end

	-- The difficulty a per-difficulty assignment here covers. A running key
	-- reads as Mythic, the difficulty you enter at (the module stores it so).
	local function DifficultyName()
		local ctx = LM:GetContext()
		if not ctx.inInstance or not ctx.difficultyID then
			return L["This Difficulty"]
		end

		return LM:DifficultyName(ctx)
	end

	-- Where a resolved assignment comes from, e.g. "(Raid default, Holy)"
	local function SourceText(level, key, scope)
		local where
		if level == "difficulty" then
			where = format(L["this instance, %s only"], DifficultyName())
		elseif level == "instance" then
			where = L["this instance"]
		elseif level == "type" then
			local info = TYPE_INFO[key]
			where = format(L["%s default"], info and info.label or tostring(key))
		else
			return ""
		end

		return Grey("(" .. where .. ", " .. (scope and tostring(LM:SpecName(scope)) or L["All Specs"]) .. ")")
	end

	-- This instance's assignment slot in the scope being edited, under the
	-- key the module writes for it. Returns inside, gear, talent.
	local function InstanceSlot(perDifficulty)
		local ctx = LM:GetContext()
		if not ctx.inInstance or not ctx.instanceID then
			return false
		end

		local key = LM:AssignmentKey(ctx, perDifficulty)
		if not key then
			return true
		end

		local R = LM:ReadTables()
		if perDifficulty then
			return true, R.difficultySets[key], R.talentDifficultySets[key]
		end

		return true, R.instanceSets[key], R.talentInstanceSets[key]
	end

	-- Saved Instances list: every instance assignment in the scope being
	-- edited, wherever you are. The pick is the page's own state.
	local pickedSaved -- tostring(key) of the picked entry, or nil

	local function PickedSavedEntry()
		if not pickedSaved then
			return nil
		end

		for _, e in ipairs(LM:ListInstanceAssignments()) do
			if tostring(e.key) == pickedSaved then
				return e
			end
		end

		return nil
	end

	local function TypeSlot(key)
		local R = LM:ReadTables()
		return R.typeDefaults[key], R.talentTypeDefaults[key]
	end

	---------------------------------------------------------------------------
	--  Option builders
	---------------------------------------------------------------------------
	local function Label(order, textFn, relWidth)
		return {
			order = order,
			type = "description",
			fontSize = "medium",
			name = textFn,
			width = "relative",
			relWidth = relWidth or 0.5,
		}
	end

	local function Button(order, name, desc, func, disabled)
		return {
			order = order,
			type = "execute",
			name = name,
			desc = desc,
			func = function()
				func()
				Refresh()
			end,
			disabled = disabled,
			width = "relative",
			relWidth = 0.2,
		}
	end

	local function Spacer(order)
		return {
			order = order,
			type = "description",
			name = "",
			width = "full",
		}
	end

	---------------------------------------------------------------------------
	--  This instance's two slots, each with Save and Clear
	---------------------------------------------------------------------------
	local function InstanceArgs(perDiff, order)
		local function Inside()
			return (InstanceSlot(perDiff)) and true or false
		end

		local function Saved()
			local inside, g, t = InstanceSlot(perDiff)
			return inside and (g ~= nil or t ~= nil)
		end

		local function Which()
			return perDiff and format(L["%s only"], DifficultyName()) or L["every difficulty"]
		end

		local key = perDiff and "thisDifficulty" or "anyDifficulty"
		local args = {}

		args[key] = Label(order, function()
			local inside, g, t = InstanceSlot(perDiff)
			if not inside then
				return Line(perDiff and L["This Difficulty"] or L["Any Difficulty"], Grey(L["not in an instance"]))
			end

			return Line(perDiff and format(L["%s Only"], DifficultyName()) or L["Any Difficulty"], PairSummary(g, t))
		end, 0.6)

		args[key .. "Save"] = Button(order + 0.1, L["Save"], function()
			if not Inside() then
				return NOT_IN_INSTANCE
			elseif not HasSelection() then
				return PICK_FIRST
			end

			return format(L["Save the selected loadout for this instance on %s, for %s."], Which(), ScopeLabel())
		end, function()
			LM:AssignCurrent(perDiff)
		end, function()
			return not Inside() or not HasSelection()
		end)

		args[key .. "Clear"] = Button(order + 0.2, L["Clear"], function()
			if not Inside() then
				return NOT_IN_INSTANCE
			elseif not Saved() then
				return format(L["Nothing saved here for %s."], ScopeLabel())
			end

			return format(L["Remove this instance's %s assignment for %s."], Which(), ScopeLabel())
		end, function()
			LM:ClearCurrent(perDiff)
		end, function()
			return not Saved()
		end)

		return args
	end

	---------------------------------------------------------------------------
	--  Content type defaults, each with Save and Clear
	---------------------------------------------------------------------------
	local function TypeArgs()
		local args = {}

		for i, typeKey in ipairs(TYPE_LAYOUT) do
			local info = TYPE_INFO[typeKey]
			local order = i * 10

			local function IsSet()
				local g, t = TypeSlot(typeKey)
				return g ~= nil or t ~= nil
			end

			args[typeKey] = Label(order, function()
				local g, t = TypeSlot(typeKey)
				return Line(info.label, PairSummary(g, t))
			end, 0.6)

			args[typeKey .. "Save"] = Button(order + 1, L["Save"], function()
				if not HasSelection() then
					return PICK_FIRST
				end

				local text = format(L["Save the selected loadout as the %s default for %s."], info.label, ScopeLabel())
				return info.hint and (info.hint .. "\n\n" .. text) or text
			end, function()
				LM:AssignType(typeKey)
			end, function()
				return not HasSelection()
			end)

			args[typeKey .. "Clear"] = Button(order + 2, L["Clear"], function()
				if not IsSet() then
					return format(L["Nothing saved for %s in %s."], info.label, ScopeLabel())
				end

				return format(L["Remove the %s default for %s."], info.label, ScopeLabel())
			end, function()
				LM:ClearType(typeKey)
			end, function()
				return not IsSet()
			end)
		end

		return args
	end

	---------------------------------------------------------------------------
	--  Page
	---------------------------------------------------------------------------
	options.loadoutManager = {
		type = "group",
		name = module:AddCategorieIcon(L["Loadout Manager"], "loadout_manager"),
		args = {
			header = {
				order = 0,
				type = "header",
				name = L["Loadout Manager"],
			},
			enable = module.ToggleCard({
				order = 1,
				name = L["Enable"],
				desc = L["Applies gear sets and talent loadouts automatically per instance type and specialization. While off the module registers no events at all, Check Now and Equip Now still work on demand."],
				image = I.Media.Icons.Categories.loadout_manager,
				get = function()
					return DB().enable
				end,
				set = function(_, value)
					LM:SetEnabled(value)
				end,
			}),
			preview = module.PreviewOption(2, "MERLoadoutManagerPreview", "loadoutManager"),

			-------------------------------------------------------------------
			--  General: what swaps on its own, and how a swap is announced
			-------------------------------------------------------------------
			general = {
				order = 10,
				type = "group",
				guiInline = true,
				name = L["General"],
				args = {
					gearEnabled = {
						order = 1,
						type = "toggle",
						name = L["Auto-Swap Gear Sets"],
						desc = L["Equip the assigned Equipment Manager set when you enter a new context."],
						disabled = NotEnabled,
						get = function()
							return DB().gearEnabled
						end,
						set = function(_, value)
							LM:SetChannelEnabled("gear", value)
						end,
					},
					talentEnabled = {
						order = 2,
						type = "toggle",
						name = L["Auto-Swap Talent Loadouts"],
						desc = L["Load the assigned talent loadout when you enter a new context."],
						disabled = NotEnabled,
						get = function()
							return DB().talentEnabled
						end,
						set = function(_, value)
							LM:SetChannelEnabled("talent", value)
						end,
					},
					queueInCombat = {
						order = 3,
						type = "toggle",
						name = L["Queue In Combat"],
						desc = L["If a swap is needed while you are in combat, hold it and apply it once combat ends."],
						disabled = NotEnabled,
						get = function()
							return DB().queueInCombat
						end,
						set = function(_, value)
							LM:SetQueueInCombat(value)
						end,
					},
					specSwap = {
						order = 4,
						type = "toggle",
						name = L["Re-Swap On Spec Change"],
						desc = L["Changing specialization inside an instance re-runs the swap for the new spec."],
						disabled = NotEnabled,
						get = function()
							return DB().specSwap
						end,
						set = function(_, value)
							DB().specSwap = value
						end,
					},
					specWarning = {
						order = 5,
						type = "toggle",
						name = L["Talent-Change Warning"],
						desc = L["Show the DONT MOVE panel in the middle of the screen while a talent loadout is being applied."],
						get = function()
							return DB().specWarning
						end,
						set = function(_, value)
							LM:SetSpecWarning(value)
						end,
					},
					announce = {
						order = 6,
						type = "toggle",
						name = L["Announce Swaps In Chat"],
						desc = L["Print a chat line whenever gear or talents are applied."],
						get = function()
							return DB().announce
						end,
						set = function(_, value)
							DB().announce = value
						end,
					},
				},
			},

			-------------------------------------------------------------------
			--  Current context: where you are and what applies here (live)
			-------------------------------------------------------------------
			context = {
				order = 20,
				type = "group",
				guiInline = true,
				name = L["Current Context"],
				args = {
					location = Label(1, function()
						return Line(L["Location"], LocationText())
					end, 0.8),
					checkNow = Button(
						2,
						L["Check Now"],
						L["Apply whatever is assigned for where you are standing, even while the Loadout Manager is off."],
						function()
							LM:CheckNow()
						end
					),
					specialization = Label(3, function()
						local specID = LM:GetCurrentSpecID()
						return Line(L["Specialization"], specID and Accent(LM:SpecName(specID)) or Grey(L["unknown"]))
					end, 1),
					gearHere = Label(4, function()
						local gear, level, key, scope = LM:ResolveGear(LM:GetContext())
						if not gear then
							return Line(L["Gear Here"], Grey(L["nothing assigned here"]))
						end

						return Line(L["Gear Here"], Accent(gear) .. "  " .. SourceText(level, key, scope))
					end, 1),
					talentsHere = Label(5, function()
						local talent, level, key, scope = LM:ResolveTalent(LM:GetContext())
						local name = LM:TalentDisplayName(talent)
						if not name then
							return Line(L["Talents Here"], Grey(L["nothing assigned here"]))
						end

						return Line(L["Talents Here"], Accent(name) .. "  " .. SourceText(level, key, scope))
					end, 1),
				},
			},

			-------------------------------------------------------------------
			--  Selected loadout: what the Save buttons assign, and to which layer
			-------------------------------------------------------------------
			selection = {
				order = 30,
				type = "group",
				guiInline = true,
				name = L["Selected Loadout"],
				args = {
					gearSet = {
						order = 1,
						type = "select",
						name = L["Gear Set"],
						desc = L["The Equipment Manager set the Save buttons below assign. No gear set leaves the saved gear as it is, Clear removes both."],
						values = function()
							local values = { [NONE] = Grey(L["No gear set"]) }
							for _, set in ipairs(LM:ListEquipmentSets()) do
								local icon = set.icon and format("|T%s:14:14:0:0:64:64:5:59:5:59|t ", set.icon) or ""
								values[set.name] = icon .. set.name
							end

							return values
						end,
						sorting = function()
							local order = { NONE }
							for _, set in ipairs(LM:ListEquipmentSets()) do
								order[#order + 1] = set.name
							end

							return order
						end,
						get = function()
							return LM:GetSelectedSet() or NONE
						end,
						set = function(_, value)
							LM:SetSelectedSet(value ~= NONE and value or nil)
							Refresh()
						end,
					},
					talentLoadout = {
						order = 2,
						type = "select",
						name = L["Talent Loadout"],
						desc = L["The talent loadout the Save buttons below assign. Only loadouts of your current specialization are listed. No talent loadout leaves the saved talents as they are, Clear removes both."],
						values = function()
							local values = { [NONE] = Grey(L["No talent loadout"]) }
							for _, loadout in ipairs(LM:ListTalentLoadouts()) do
								values[tostring(loadout.configID)] = loadout.name
							end

							return values
						end,
						sorting = function()
							local order = { NONE }
							for _, loadout in ipairs(LM:ListTalentLoadouts()) do
								order[#order + 1] = tostring(loadout.configID)
							end

							return order
						end,
						get = function()
							local selected = LM:GetSelectedTalent()
							return selected and tostring(selected.configID) or NONE
						end,
						set = function(_, value)
							if value == NONE then
								LM:SetSelectedTalent(nil)
							else
								for _, loadout in ipairs(LM:ListTalentLoadouts()) do
									if tostring(loadout.configID) == value then
										LM:SetSelectedTalent(LM:StoreTalentLoadout(loadout))
										break
									end
								end
							end
							Refresh()
						end,
					},
					assignFor = {
						order = 3,
						type = "select",
						name = L["Assign For"],
						desc = L["Which layer the Save buttons below write to and show. All Specs applies to every specialization, a spec overrides it for that spec only."],
						values = ScopeValues,
						sorting = ScopeSorting,
						get = function()
							local scope = LM:GetScope()
							return scope and tostring(scope) or ALL_SPECS
						end,
						set = function(_, value)
							LM:SetScope(value ~= ALL_SPECS and tonumber(value) or nil)
							Refresh()
						end,
					},
					copyFrom = {
						order = 4,
						type = "select",
						name = L["Copy From"],
						desc = L["Copies another layer into the one picked under Assign For, replacing everything it holds."],
						values = function()
							local values = {}
							local current = LM:GetScope()
							if current ~= nil then
								values[ALL_SPECS] = L["All Specs"]
							end
							for _, spec in ipairs(LM:GetSpecList()) do
								if spec.id ~= current then
									values[tostring(spec.id)] = spec.name
								end
							end

							return values
						end,
						get = function()
							return nil
						end,
						confirm = function(_, value)
							local source = value == ALL_SPECS and L["All Specs"] or LM:SpecName(tonumber(value))
							return format(
								L["Replace every %s assignment with a copy of the %s assignments?"],
								ScopeLabel(),
								tostring(source)
							)
						end,
						set = function(_, value)
							LM:CopyScopeFrom(value ~= ALL_SPECS and tonumber(value) or nil)
							Refresh()
						end,
					},
					equipNow = {
						order = 5,
						type = "execute",
						name = L["Equip Now"],
						desc = L["Apply the gear set and talent loadout picked above right now, ignoring the assignments."],
						disabled = function()
							return not HasSelection()
						end,
						func = function()
							LM:EquipSelected()
							Refresh()
						end,
					},
					verify = {
						order = 6,
						type = "execute",
						name = L["Verify Assigned Sets"],
						desc = L["Lists every assignment that points to an Equipment Manager set that no longer exists."],
						func = function()
							LM:Verify()
						end,
					},
				},
			},

			-------------------------------------------------------------------
			--  Instances: this instance's two slots, then every saved instance,
			--  which can be cleared from anywhere
			-------------------------------------------------------------------
			instances = {
				order = 40,
				type = "group",
				guiInline = true,
				name = function()
					return L["Instances"] .. "  -  " .. strupper(ScopeLabel())
				end,
				args = (function()
					local args = InstanceArgs(false, 1)
					for k, v in pairs(InstanceArgs(true, 2)) do
						args[k] = v
					end

					args.spacer = Spacer(3)

					args.savedInstances = {
						order = 4,
						type = "select",
						name = L["Saved Instances"],
						desc = L["Every instance assignment saved for the layer picked under Assign For, wherever you are. Pick one to see what it holds or clear it."],
						width = "relative",
						relWidth = 0.4,
						values = function()
							local values = { [NONE] = Grey(L["Pick an instance"]) }
							for _, e in ipairs(LM:ListInstanceAssignments()) do
								values[tostring(e.key)] = e.label
							end

							return values
						end,
						sorting = function()
							local order = { NONE }
							for _, e in ipairs(LM:ListInstanceAssignments()) do
								order[#order + 1] = tostring(e.key)
							end

							return order
						end,
						get = function()
							return PickedSavedEntry() and pickedSaved or NONE
						end,
						set = function(_, value)
							pickedSaved = value ~= NONE and value or nil
							Refresh()
						end,
					}

					args.savedAssignment = Label(5, function()
						local e = PickedSavedEntry()
						if e then
							return Line(L["Assignment"], PairSummary(e.gear, e.talent))
						end
						if #LM:ListInstanceAssignments() == 0 then
							return Line(L["Assignment"], Grey(format(L["nothing saved for %s"], ScopeLabel())))
						end

						return Line(L["Assignment"], Grey(L["pick a saved instance"]))
					end, 0.4)

					args.savedClear = Button(6, L["Clear"], function()
						local e = PickedSavedEntry()
						if not e then
							return L["Pick a saved instance first."]
						end

						return format(L["Remove %s for %s."], e.label, ScopeLabel())
					end, function()
						local e = PickedSavedEntry()
						pickedSaved = nil
						if e then
							LM:ClearInstanceAssignment(e.key)
						end
					end, function()
						return PickedSavedEntry() == nil
					end)

					return args
				end)(),
			},

			-------------------------------------------------------------------
			--  Content type defaults
			-------------------------------------------------------------------
			types = {
				order = 50,
				type = "group",
				guiInline = true,
				name = function()
					return L["Content Type Defaults"] .. "  -  " .. strupper(ScopeLabel())
				end,
				args = TypeArgs(),
			},

			reset = {
				order = 60,
				type = "execute",
				name = L["Reset"],
				desc = L["Resets every Loadout Manager setting and removes all assignments of this character."],
				confirm = true,
				func = function()
					LM:ResetAll()
					pickedSaved = nil
					Refresh()
				end,
			},
		},
	}

	-- Three toggles per row, six in one row cut their labels off
	for _, option in pairs(options.loadoutManager.args.general.args) do
		option.width = "relative"
		option.relWidth = 0.33
	end

	local selectionArgs = options.loadoutManager.args.selection.args
	module.ActionCard(selectionArgs.equipNow, { icon = I.Media.Icons.Categories.loadout_manager, relWidth = 0.5 })
	module.ActionCard(selectionArgs.verify, { icon = I.Media.Icons.Ok, relWidth = 0.5 })
end)
