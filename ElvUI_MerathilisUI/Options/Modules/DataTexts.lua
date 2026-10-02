local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local DT = E:GetModule("DataTexts")

local GetMountInfoByID = C_MountJournal.GetMountInfoByID

local options = module.options.modules.args

-- Mounts with a repair vendor, offered for the right click on the datatext
local REPAIR_MOUNTS = {
	2237, -- Grizzly Hills Packmaster
	460, -- Grand Expedition Yak
	284, -- Traveler's Tundra Mammoth (Horde)
	280, -- Traveler's Tundra Mammoth (Alliance)
	1039, -- Mighty Caravan Brutosaur
}

local function DB()
	return E.db.mui.datatexts.durabilityIlevel
end

local function Refresh()
	DT:ForceUpdate_DataText("DurabilityIlevel")
end

-- Only mounts this character has collected and can use
local function GetRepairMounts()
	local values = { [0] = L["None"] }

	for _, mountID in ipairs(REPAIR_MOUNTS) do
		local name, _, icon, _, _, _, _, _, _, shouldHideOnChar, isCollected = GetMountInfoByID(mountID)
		if name and isCollected and not shouldHideOnChar then
			values[mountID] = F.GetIconString(icon, 14, 14) .. " " .. name
		end
	end

	return values
end

local function ColoredDisabled()
	return not DB().colored.enable
end

local function ThresholdColor(key)
	return {
		get = function()
			local c = DB().colored[key].color
			local d = P.datatexts.durabilityIlevel.colored[key].color
			return c.r, c.g, c.b, nil, d.r, d.g, d.b
		end,
		set = function(_, r, g, b)
			local c = DB().colored[key].color
			c.r, c.g, c.b = r, g, b
			-- The datatext colors its text through the hex string
			c.hex = E:RGBToHex(r, g, b)
			Refresh()
		end,
	}
end

local warningColor = ThresholdColor("a")
local criticalColor = ThresholdColor("b")

options.datatexts = {
	type = "group",
	name = module:AddCategorieIcon(L["DataTexts"], "datatexts"),
	get = function(info)
		return DB()[info[#info]]
	end,
	set = function(info, value)
		DB()[info[#info]] = value
		Refresh()
	end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = L["DataTexts"],
		},
		desc = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Description"],
			args = {
				feature = {
					order = 1,
					type = "description",
					name = L["Settings for the MerathilisUI datatexts. Add them to a panel in ElvUI's DataTexts options."],
					fontSize = "medium",
				},
			},
		},
		durabilityIlevel = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Durability/ Ilevel"],
			args = {
				icon = {
					order = 1,
					type = "toggle",
					name = L["Show Icons"],
				},
				whiteText = {
					order = 2,
					type = "toggle",
					name = L["White Text"],
					desc = L["Shows the values in white instead of ElvUI's value color."],
				},
				whiteIcon = {
					order = 3,
					type = "toggle",
					name = L["White Icon"],
					desc = L["Keeps the durability icon white instead of coloring it like the durability."],
					disabled = function()
						return not DB().icon
					end,
				},
				mount = {
					order = 4,
					type = "select",
					name = L["Repair Mount"],
					desc = L["Summoned with a right click on the datatext."],
					values = GetRepairMounts,
					get = function()
						return tonumber(DB().mount) or 0
					end,
				},
				colored = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Colored Durability"],
					get = function(info)
						return DB().colored[info[#info]]
					end,
					set = function(info, value)
						DB().colored[info[#info]] = value
						Refresh()
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							desc = L["Colors the durability below the thresholds. Turned off, it only turns orange below 15%."],
							width = "full",
						},
						warning = {
							order = 2,
							type = "range",
							name = L["Warning"],
							min = 1,
							max = 100,
							step = 1,
							disabled = ColoredDisabled,
							get = function()
								return DB().colored.a.value
							end,
							set = function(_, value)
								DB().colored.a.value = value
								Refresh()
							end,
						},
						warningColor = {
							order = 3,
							type = "color",
							name = L["Warning Color"],
							hasAlpha = false,
							disabled = ColoredDisabled,
							get = warningColor.get,
							set = warningColor.set,
						},
						spacer = {
							order = 4,
							type = "description",
							name = "",
							width = "full",
						},
						critical = {
							order = 5,
							type = "range",
							name = L["Critical"],
							min = 1,
							max = 100,
							step = 1,
							disabled = ColoredDisabled,
							get = function()
								return DB().colored.b.value
							end,
							set = function(_, value)
								DB().colored.b.value = value
								Refresh()
							end,
						},
						criticalColor = {
							order = 6,
							type = "color",
							name = L["Critical Color"],
							hasAlpha = false,
							disabled = ColoredDisabled,
							get = criticalColor.get,
							set = criticalColor.set,
						},
					},
				},
			},
		},
	},
}
