local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI");
local MUF = E:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames");

-- Cache global variables
-- Lua functions
local _G = _G
local tinsert = table.insert
-- WoW API / Variables
local DEFAULT = DEFAULT

local function UnitFramesTable()
	E.Options.args.mui.args.unitframes = {
		order = 15,
		type = "group",
		name = MUF.modName or MUF:GetName(),
		disabled = function() return not E.private.unitframe.enable end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(MUF.modName or MUF:GetName()),
			},
			general = {
				order = 2,
				type = "group",
				name = MER:cOption(L["General"]),
				guiInline = true,
				args = {
					groupinfo = {
						order = 2,
						type = "toggle",
						name = L["Group Info"],
						desc = L["Shows an extra frame with information about the party/raid."],
						get = function(info) return E.db["mui"]["unitframes"][ info[#info] ] end,
						set = function(info, value) E.db["mui"]["unitframes"][ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
				},
			},
			--[[player = {
				order = 2,
				type = "group",
				name = L["Player Frame"],
				guiInline = true,
				args = {
				},
			},--]]
		},
	}
end
tinsert(MER.Config, UnitFramesTable)