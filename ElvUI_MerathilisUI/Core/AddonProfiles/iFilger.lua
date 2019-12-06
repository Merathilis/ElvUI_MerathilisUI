local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
local _G = _G
--WoW API / Variables
-- GLOBALS:

function MER:LoadiFilgerProfile()
	--[[----------------------------------
	--	ProjectAzilroka - Settings
	--]]----------------------------------
	local IF = _G.iFilger
	IF.data:SetProfile('MerathilisUI')

	IF.db["FocusDebuffs"]["Enable"] = false
	IF.db["FocusBuffs"]["Enable"] = false
	IF.db["PvPTargetBuffs"]["Enable"] = false
	IF.db["PvPTargetDebuffs"]["Enable"] = false
	IF.db["Enhancements"]["Enable"] = false
	IF.db["RaidDebuffs"]["Enable"] = false
	IF.db["PvPPlayerDebuffs"]["Enable"] = false
	IF.db["Cooldowns"]["Enable"] = false
	IF.db["Buffs"]["Enable"] = true
	IF.db["Buffs"]["Direction"] = "LEFT"
	IF.db["Buffs"]["Spacing"] = 2
	IF.db["Buffs"]["IconSize"] = 32
	IF.db["StackCountFont"] = "Expressway"
	IF.db["StackCountFontFlag"] = "OUTLINE"
	IF.db["CooldownText"]["Font"] = "Expressway"
	IF.db["CooldownText"]["FontFlag"] = "OUTLINE"
end
