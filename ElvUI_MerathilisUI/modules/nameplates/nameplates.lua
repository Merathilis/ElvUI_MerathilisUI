local MER, E, L, V, P, G = unpack(select(2, ...))
local MNP = MER:NewModule('mUINamePlates', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
local NP = E:GetModule('NamePlates')

--Cache global variables
--Lua functions
--WoW API / Variables
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function MNP:Initialize()
	if E.private.nameplates.enable ~= true then return end

	--Castbar Target
	if E.db.mui.nameplates.castbarTarget then
		hooksecurefunc(NP, "Castbar_PostCastStart", MNP.CastbarPostCastStart)
	end
end

local function InitializeCallback()
	MNP:Initialize()
end

MER:RegisterModule(MNP:GetName(), InitializeCallback)
