local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

-- Cache global variables
-- Lua functions
local _G = _G
local select, unpack = select, unpack
-- WoW API
local hooksecurefunc = hooksecurefunc
-- GLOBALS:


local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.debug ~= true or E.private.muiSkins.blizzard.debug ~= true then return end

	local EventTraceFrame = _G.EventTrace
	EventTraceFrame:Styling()
	MER:CreateBackdropShadow(EventTraceFrame)

end

S:AddCallbackForAddon("Blizzard_EventTrace", "mUIDebugTools", LoadSkin)
