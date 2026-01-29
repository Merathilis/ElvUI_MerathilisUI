local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local CF = MER:GetModule("MER_Cooldown")
local options = MER.options.modules.args

options.cooldowns = {
	type = "group",
	name = L["Cooldowns"],
	args = {},
}
