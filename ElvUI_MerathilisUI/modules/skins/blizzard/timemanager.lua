local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

local function styleTimeManager()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.timemanager ~= true or E.private.muiSkins.blizzard.timemanager ~= true then return end

	MERS:CreateStripes(TimeManagerFrame)
	MERS:CreateGradient(TimeManagerFrame)
	MERS:CreateStripes(TimeManagerStopwatchFrame)
	MERS:CreateGradient(TimeManagerStopwatchFrame)
	MERS:CreateStripes(StopwatchFrame)
	MERS:CreateGradient(StopwatchFrame)
end

S:AddCallbackForAddon("Blizzard_TimeManager", "mUITimeManager", styleTimeManager)