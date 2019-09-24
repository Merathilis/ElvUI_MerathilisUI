local MER, E, L, V, P, G = unpack(select(2, ...))
local ER = MER:GetModule("mUIErrors")

-- Cache global variables
-- Lua functions
local pairs = pairs
local tinsert = table.insert
-- WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function Errors()
	E.Options.args.mui.args.modules.args.errors = {
		type = "group",
		name = L["Error Handling"],
		order = 15,
		args = {
			header1 = {
				type = "header",
				name = MER:cOption(L["Error Handling"]),
				order = 1
			},
			description = {
				order = 2,
				type = "group",
				name = MER:cOption(L["Desciption"]),
				guiInline = true,
				args = {
					tukui = {
						order = 1,
						type = "description",
						fontSize = "medium",
						name = L["In the List below, you can disable some annoying error texts, like |cffff7d0a'Not enough rage'|r or |cffff7d0a'Not enough energy'|r."],
					},
				},
			},
			filterErrors = {
				order = 3,
				name = L["Filter Errors"],
				desc = L["Choose specific errors from the list below to hide/ignore."],
				type = "toggle",
				get = function(info) return E.db.mui.general[ info[#info] ] end,
				set = function(info, value) E.db.mui.general[ info[#info] ] = value; ER:UpdateErrorFilters() end
			},
			hideErrorFrame = {
				order = 4,
				name = L["Hide In Combat"],
				desc = L["Hides all errors regardless of filtering while in combat."],
				type = "toggle",
				disabled = function() return not E.db.mui.general.filterErrors end,
				get = function(info) return E.db.mui.general[ info[#info] ] end,
				set = function(info, value) E.db.mui.general[ info[#info] ] = value; ER:UpdateErrorFilters() end
			},
		},
	}

	E.Options.args.mui.args.modules.args.errors.args.filterGroup = {
		order = 5,
		type = "group",
		guiInline = true,
		name = L["Filter"],
		disabled = function() return not E.db.mui.general.filterErrors end,
		args = {},
	}

	local listIndex = 1
	for errorName in pairs(E.db.mui.errorFilters) do
		E.Options.args.mui.args.modules.args.errors.args.filterGroup.args[errorName] = {
			order = listIndex,
			type = "toggle",
			name = errorName,
			width = "full",
			get = function(info) return E.db.mui.errorFilters[errorName]; end,
			set = function(info, value) E.db.mui.errorFilters[errorName] = value; ER:UpdateErrorFilters() end
		}
		listIndex = listIndex + 1
	end
end
tinsert(MER.Config, Errors)
