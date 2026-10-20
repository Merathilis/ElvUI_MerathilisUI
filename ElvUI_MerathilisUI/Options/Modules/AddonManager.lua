local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

local format, ipairs = format, ipairs

local GetAddOnInfo = C_AddOns.GetAddOnInfo
local GetNumAddOns = C_AddOns.GetNumAddOns
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
	local AM = MER:GetModule("MER_AddonManager")
	local db = E.global.mui.addonManager

	local options = module.options.modules.args
	local selectedProfile

	local function Disabled()
		return not db.enable
	end

	local function NoProfile()
		return not db.enable or not selectedProfile or not db.profiles[selectedProfile]
	end

	options.addonManager = {
		type = "group",
		name = module:AddCategorieIcon(L["Addon Manager"], "addon_manager"),
		args = {
			header = {
				order = 0,
				type = "header",
				name = L["Addon Manager"],
			},
			description = {
				order = 1,
				type = "description",
				name = L["Adds addon profiles, locked addons and a wider search to the game's addon list (Game Menu > AddOns)."]
					.. "\n\n"
					.. format(L["Profiles also load with %s."], F.String.MERATHILISUI("/muiaddons <profile>"))
					.. (
						IsAddOnLoaded("SimpleAddonManager")
							and "\n\n" .. F.String.Warning(
								L["Simple Addon Manager opens its own window from the Game Menu, so these additions only show in the game's own addon list."]
							)
						or ""
					),
				fontSize = "medium",
				width = "full",
			},
			enable = module.ToggleCard({
				order = 2,
				name = L["Enable"],
				desc = L["Gives the addon list a profile panel, a lock per addon, switches and a size grip in the look of these options."],
				image = I.Media.Icons.Categories.addon_manager,
				get = function()
					return db.enable
				end,
				set = function(_, value)
					db.enable = value
					AM:UpdateState()
				end,
			}),
			extendedSearch = module.ToggleCard({
				order = 3,
				name = L["Extended Search"],
				desc = L["The search of the addon list also finds addons by their folder name, author and notes."],
				image = I.Media.Icons.Categories.addon_manager,
				disabled = Disabled,
				get = function()
					return db.extendedSearch
				end,
				set = function(_, value)
					db.extendedSearch = value
					AM:UpdateState()
				end,
			}),
			profiles = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Addon Profiles"],
				disabled = Disabled,
				args = {
					desc = {
						order = 0,
						type = "description",
						name = L["A profile remembers which addons are on. Loading it switches the addons of this character and reloads the UI, locked addons stay on."],
						width = "full",
					},
					profile = {
						order = 1,
						type = "select",
						name = L["Profile"],
						values = function()
							local values = {}
							for _, name in ipairs(AM:GetProfileNames()) do
								values[name] = format("%s (%d)", name, AM:GetProfileSize(name))
							end
							return values
						end,
						get = function()
							return selectedProfile
						end,
						set = function(_, value)
							selectedProfile = value
						end,
					},
					load = {
						order = 2,
						type = "execute",
						name = L["Load"],
						disabled = NoProfile,
						confirm = true,
						confirmText = L["Load this addon profile and reload the UI?"],
						func = function()
							AM:LoadProfile(selectedProfile)
						end,
					},
					overwrite = {
						order = 3,
						type = "execute",
						name = L["Overwrite With Current"],
						disabled = NoProfile,
						func = function()
							AM:SaveProfile(selectedProfile)
						end,
					},
					rename = {
						order = 4,
						type = "execute",
						name = L["Rename"],
						disabled = NoProfile,
						func = function()
							AM:ShowRenameProfilePopup(selectedProfile)
						end,
					},
					delete = {
						order = 5,
						type = "execute",
						name = _G.DELETE,
						disabled = NoProfile,
						func = function()
							AM:ShowDeleteProfilePopup(selectedProfile)
						end,
					},
					save = {
						order = 6,
						type = "execute",
						name = L["Save Current As..."],
						func = function()
							AM:ShowSaveProfilePopup()
						end,
					},
				},
			},
			locked = {
				order = 5,
				type = "group",
				inline = true,
				name = L["Locked Addons"],
				disabled = Disabled,
				args = {
					desc = {
						order = 0,
						type = "description",
						name = L["A locked addon stays on: Disable All, a profile or a click in the list can't turn it off."]
							.. " "
							.. L["The lock in each row of the addon list does the same."],
						width = "full",
					},
					addons = {
						order = 1,
						type = "multiselect",
						dialogControl = "Dropdown",
						name = L["Locked Addons"],
						width = "double",
						values = function()
							local values = {}
							for i = 1, GetNumAddOns() do
								local name, title, _, _, _, security = GetAddOnInfo(i)
								if security ~= "SECURE" then
									values[name] = title ~= "" and title or name
								end
							end
							return values
						end,
						get = function(_, key)
							return AM:IsLocked(key)
						end,
						set = function(_, key, value)
							AM:SetLocked(key, value)
						end,
					},
				},
			},
		},
	}

	F.MarkTabAsNew("addonManager")
end)
