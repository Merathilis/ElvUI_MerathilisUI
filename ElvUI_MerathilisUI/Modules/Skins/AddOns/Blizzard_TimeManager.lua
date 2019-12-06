local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
--WoW API / Variables
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.timemanager ~= true or E.private.muiSkins.blizzard.timemanager ~= true then return end

	local TimeManagerFrame = _G.TimeManagerFrame
	TimeManagerFrame:Styling()

	local StopwatchFrame = _G.StopwatchFrame
	StopwatchFrame:Styling()
end

S:AddCallbackForAddon("Blizzard_TimeManager", "mUITimeManager", LoadSkin)
