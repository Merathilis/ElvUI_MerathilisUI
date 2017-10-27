local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleTimeManager()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.timemanager ~= true or E.private.muiSkins.blizzard.timemanager ~= true then return end

	MERS:CreateStripes(_G["TimeManagerFrame"])
	MERS:CreateGradient(_G["TimeManagerFrame"])
	MERS:CreateStripes(_G["TimeManagerStopwatchFrame"])
	MERS:CreateGradient(_G["TimeManagerStopwatchFrame"])
	MERS:CreateStripes(_G["StopwatchFrame"])
	MERS:CreateGradient(_G["StopwatchFrame"])
end

S:AddCallbackForAddon("Blizzard_TimeManager", "mUITimeManager", styleTimeManager)