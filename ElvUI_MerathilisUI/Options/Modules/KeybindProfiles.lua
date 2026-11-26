local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

local _G = _G
local date, format, ipairs, pairs = date, format, ipairs, pairs

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
	local KP = MER:GetModule("MER_KeybindProfiles")
	local db = E.global.mui.keybindProfiles

	local options = module.options.modules.args
	local selectedProfile

	local function Disabled()
		return not db.enable
	end

	local function NoProfile()
		return not db.enable or not selectedProfile or not db.profiles[selectedProfile]
	end

	local function ProfileValues(withNone)
		local values = withNone and { [""] = _G.NONE } or {}
		for _, name in ipairs(KP:GetProfileNames()) do
			values[name] = name
		end
		return values
	end

	local function ClassName(class)
		local name = class and _G.LOCALIZED_CLASS_NAMES_MALE[class]
		return name and F.String.Class(name, class) or nil
	end

	local function ProfileInfo()
		local profile = selectedProfile and db.profiles[selectedProfile]
		if not profile then
			return L["Save the key bindings of this character as a profile, then put it on other characters with Apply."]
		end

		local lines = {
			format(L["%d |4key binding:key bindings;"], profile.count or 0),
		}
		if profile.source then
			local class = ClassName(profile.class)
			lines[#lines + 1] = format(L["From: %s"], profile.source .. (class and " (" .. class .. ")" or ""))
		end
		if profile.client then
			lines[#lines + 1] = format(L["Game: %s"], profile.client == "forever" and "WoW Forever" or "Retail")
		end
		if profile.saved then
			lines[#lines + 1] = format(L["Saved: %s"], date("%Y-%m-%d %H:%M", profile.saved))
		end

		return table.concat(lines, "\n")
	end

	options.keybindProfiles = {
		type = "group",
		name = module:AddCategorieIcon(L["Keybind Profiles"], "keybind_profiles"),
		args = {
			header = {
				order = 0,
				type = "header",
				name = L["Keybind Profiles"],
			},
			description = {
				order = 1,
				type = "description",
				name = L["The game keeps your key bindings on its server, one set for the account or one per character. Keybind profiles store them for all your characters, so a new character gets its key bindings with one click or on its own at the first login, and a code takes them to WoW Forever, Retail or another account."]
					.. "\n\n"
					.. format(L["Profiles also apply with %s."], F.String.MERATHILISUI("/muikeys <profile>")),
				fontSize = "medium",
				width = "full",
			},
			enable = module.ToggleCard({
				order = 2,
				name = L["Enable"],
				desc = L["Saves, applies and shares key binding profiles across all characters of this account."],
				image = I.Media.Icons.Categories.keybind_profiles,
				get = function()
					return db.enable
				end,
				set = function(_, value)
					-- Auto Apply runs at login, nothing else needs a start
					db.enable = value
				end,
			}),
			profiles = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Profiles"],
				disabled = Disabled,
				args = {
					profile = {
						order = 1,
						type = "select",
						name = L["Profile"],
						values = function()
							return ProfileValues(false)
						end,
						get = function()
							return selectedProfile
						end,
						set = function(_, value)
							selectedProfile = value
						end,
					},
					applyAs = {
						order = 2,
						type = "select",
						name = L["Apply As"],
						desc = L["Character Specific: the profile becomes the key bindings of this character only, the account set stays for the others.\nCurrent Set: the profile goes into the set this character uses now, which is the set of the whole account unless character specific key bindings are on."],
						values = {
							CHARACTER = L["Character Specific"],
							CURRENT = L["Current Set"],
						},
						get = function()
							return db.applyAs
						end,
						set = function(_, value)
							db.applyAs = value
						end,
					},
					info = {
						order = 3,
						type = "description",
						name = ProfileInfo,
						width = "full",
					},
					apply = {
						order = 4,
						type = "execute",
						name = L["Apply"],
						disabled = NoProfile,
						confirm = true,
						confirmText = L["Replace the key bindings of this character with this profile? Undo brings the old ones back."],
						func = function()
							KP:ApplyProfile(selectedProfile)
						end,
					},
					overwrite = {
						order = 5,
						type = "execute",
						name = L["Overwrite With Current"],
						disabled = NoProfile,
						confirm = true,
						confirmText = L["Overwrite this profile with the key bindings of this character?"],
						func = function()
							KP:SaveProfile(selectedProfile)
						end,
					},
					save = {
						order = 6,
						type = "execute",
						name = L["Save Current As..."],
						func = function()
							KP:ShowSaveProfilePopup()
						end,
					},
					rename = {
						order = 7,
						type = "execute",
						name = L["Rename"],
						disabled = NoProfile,
						func = function()
							KP:ShowRenameProfilePopup(selectedProfile)
						end,
					},
					delete = {
						order = 8,
						type = "execute",
						name = _G.DELETE,
						disabled = NoProfile,
						func = function()
							KP:ShowDeleteProfilePopup(selectedProfile)
						end,
					},
					export = {
						order = 9,
						type = "execute",
						name = L["Export"],
						disabled = NoProfile,
						func = function()
							KP:ShowExportPopup(selectedProfile)
						end,
					},
					import = {
						order = 10,
						type = "execute",
						name = L["Import"],
						func = function()
							KP:ShowImportPopup()
						end,
					},
					undo = {
						order = 11,
						type = "execute",
						name = L["Undo Last Apply"],
						desc = L["Brings back the key bindings this character had before the last profile was applied."],
						disabled = function()
							return not db.enable or not KP:HasBackup()
						end,
						func = function()
							KP:Undo()
						end,
					},
				},
			},
			autoApply = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Auto Apply"],
				disabled = Disabled,
				args = (function()
					local args = {
						desc = {
							order = 0,
							type = "description",
							name = L["A character that never got a keybind profile gets the one of its class at its next login, once. It becomes the character specific key bindings of that character, later changes stay."],
							width = "full",
						},
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							get = function()
								return db.autoApply
							end,
							set = function(_, value)
								db.autoApply = value
							end,
						},
						askBeforeApply = {
							order = 2,
							type = "toggle",
							name = L["Ask First"],
							desc = L["A Yes / No popup before the profile is applied. No leaves this character alone for good."],
							disabled = function()
								return not db.enable or not db.autoApply
							end,
							get = function()
								return db.askBeforeApply
							end,
							set = function(_, value)
								db.askBeforeApply = value
							end,
						},
						skipCharacterSpecific = {
							order = 3,
							type = "toggle",
							name = L["Skip Set Up Characters"],
							desc = L["Characters that already have character specific key bindings keep them."],
							disabled = function()
								return not db.enable or not db.autoApply
							end,
							get = function()
								return db.skipCharacterSpecific
							end,
							set = function(_, value)
								db.skipCharacterSpecific = value
							end,
						},
						spacer = {
							order = 4,
							type = "description",
							name = "",
							width = "full",
						},
					}

					local function ClassOption(order, class, name)
						return {
							order = order,
							type = "select",
							name = name,
							disabled = function()
								return not db.enable or not db.autoApply
							end,
							values = function()
								return ProfileValues(true)
							end,
							get = function()
								return db.classProfiles[class] or ""
							end,
							set = function(_, value)
								db.classProfiles[class] = value ~= "" and value or nil
							end,
						}
					end

					args[KP.ALL_CLASSES] = ClassOption(5, KP.ALL_CLASSES, L["All Other Classes"])

					local classes = _G.CLASS_SORT_ORDER
					if not classes then
						classes = {}
						for class in pairs(_G.LOCALIZED_CLASS_NAMES_MALE) do
							classes[#classes + 1] = class
						end
						table.sort(classes)
					end

					for index, class in ipairs(classes) do
						local name = ClassName(class)
						if name then
							args[class] = ClassOption(5 + index, class, name)
						end
					end

					return args
				end)(),
			},
		},
	}
end)
