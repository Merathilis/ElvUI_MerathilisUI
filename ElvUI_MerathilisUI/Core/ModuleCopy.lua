local MER, E, L, V, P, G = unpack(select(2, ...))
local MC = E:GetModule("ModuleCopy")

local function configTable()
	if not E.Options.args.modulecontrol then return end
	E.Options.args.modulecontrol.args.modulecopy.args.mui = {
		order = 11,
		type = "group",
		name = MER.Title,
		-- desc = L["Core |cfffe7b2cElvUI|r options."],
		childGroups = "tab",
		disabled = E.Options.args.profiles.args.copyfrom.disabled,
		args = {
			header = {
				order = 0,
				type = "header",
				name = L["|cffff7d0aMerathilisUI|r Options"],
			},
			-- actionbar = MC:CreateModuleConfigGroup(L["ActionBars"], "actionbar"),
			-- auras = MC:CreateModuleConfigGroup(L["Auras"], "auras"),
			-- bags = MC:CreateModuleConfigGroup(L["Bags"], "bags"),
			-- chat = MC:CreateModuleConfigGroup(L["Chat"], "chat"),
			-- cooldown = MC:CreateModuleConfigGroup(L["Cooldown Text"], "cooldown"),
			-- databars = MC:CreateModuleConfigGroup(L["DataBars"], "databars"),
			-- datatexts = MC:CreateModuleConfigGroup(L["DataTexts"], "datatexts"),
			-- nameplates = MC:CreateModuleConfigGroup(L["NamePlates"], "nameplates"),
			-- tooltip = MC:CreateModuleConfigGroup(L["Tooltip"], "tooltip"),
			-- uniframes = MC:CreateModuleConfigGroup(L["UnitFrames"], "uniframes"),
		},
	}
end

tinsert(MER.Config, configTable)
