local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_NamePlates')
local NP = E:GetModule('NamePlates')

--Cache global variables
--Lua functions
--WoW API / Variables
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function module:Initialize()
	if E.private.nameplates.enable ~= true then return end

	-- Castbar Shield
	if E.db.mui.nameplates.castbarShield then
		hooksecurefunc(NP, "Castbar_CheckInterrupt", module.Castbar_CheckInterrupt)
	end
end

MER:RegisterModule(module:GetName())
