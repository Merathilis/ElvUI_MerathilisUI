local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local select = select
-- WoW API

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function styleDebugTools()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.debug ~= true or E.private.muiSkins.blizzard.debug ~= true then return end

	local EventTraceFrame = _G["EventTraceFrame"]
	EventTraceFrame:Styling()

	-- Table Attribute Display
	local function reskinTableAttribute(frame)
		frame:Styling()
	end

	reskinTableAttribute(TableAttributeDisplay)

	hooksecurefunc(TableInspectorMixin, "InspectTable", function(self)
		reskinTableAttribute(self)
	end)
end

S:AddCallbackForAddon("Blizzard_DebugTools", "mUIDebugTools", styleDebugTools)