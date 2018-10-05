local MER, E, L, V, P, G = unpack(select(2, ...))


local function configTable()
	if not E.Options.args.modulecontrol then return end
	local CP = E:GetModule("CopyProfile")
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
			-- actionbar = CP:CreateModuleConfigGroup(L["ActionBars"], "actionbar"),
			-- auras = CP:CreateModuleConfigGroup(L["Auras"], "auras"),
			-- bags = CP:CreateModuleConfigGroup(L["Bags"], "bags"),
			-- chat = CP:CreateModuleConfigGroup(L["Chat"], "chat"),
			-- cooldown = CP:CreateModuleConfigGroup(L["Cooldown Text"], "cooldown"),
			-- databars = CP:CreateModuleConfigGroup(L["DataBars"], "databars"),
			-- datatexts = CP:CreateModuleConfigGroup(L["DataTexts"], "datatexts"),
			-- nameplates = CP:CreateModuleConfigGroup(L["NamePlates"], "nameplates"),
			-- tooltip = CP:CreateModuleConfigGroup(L["Tooltip"], "tooltip"),
			-- uniframes = CP:CreateModuleConfigGroup(L["UnitFrames"], "uniframes"),
		},
	}
end

tinsert(MER.Config, configTable)