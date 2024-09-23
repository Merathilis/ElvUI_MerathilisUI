local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local options = MER.options.modules.args
local DT = E:GetModule("DataTexts")

local GetMountInfoByID = C_MountJournal.GetMountInfoByID

local function GetRepairMounts()
	local repairMounts = {}

	for _, mountID in ipairs(I.RepairMounts) do
		local name, _, icon, _, isUsable = GetMountInfoByID(mountID)
		local iconStr = icon and F.GetIconString(icon, 14, 14)
		if isUsable then
			repairMounts[mountID] = iconStr .. " " .. name
		end
	end

	return repairMounts
end

options.datatexts = {
	type = "group",
	name = L["DataTexts"],
	get = function(info)
		return E.db.mui.datatexts[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.datatexts[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["DataTexts"], "orange"),
		},
		general = {
			order = 2,
			type = "group",
			name = F.cOption(L["General"], "orange"),
			guiInline = true,
			args = {},
		},
		durabilityIlevel = {
			order = 3,
			type = "group",
			name = L["Durability / ItemLevel"],
			args = {
				icon = {
					order = 1,
					name = L["Show Icons"],
					type = "toggle",
					get = function(info)
						return E.db.mui.datatexts.durabilityIlevel.icon
					end,
					set = function(info, value)
						E.db.mui.datatexts.durabilityIlevel.icon = value
						DT:ForceUpdate_DataText("DurabilityItemLevel")
					end,
				},
				text = {
					order = 2,
					name = L["White Text"],
					type = "toggle",
					get = function(info)
						return E.db.mui.datatexts.durabilityIlevel.text
					end,
					set = function(info, value)
						E.db.mui.datatexts.durabilityIlevel.text = value
						DT:ForceUpdate_DataText("DurabilityItemLevel")
					end,
				},
				repairMount = {
					order = 3,
					name = E.NewSign .. L["Repair Mount"],
					type = "select",
					values = GetRepairMounts,
					sortByValue = true,
					hidden = function()
						return F.Table.IsEmpty(GetRepairMounts())
					end,
					get = function(info)
						return E.db.mui.datatexts.durabilityIlevel.repairMount
					end,
					set = function(info, value)
						E.db.mui.datatexts.durabilityIlevel.repairMount = value
						DT:ForceUpdate_DataText("DurabilityItemLevel")
					end,
				},
			},
		},
	},
}
