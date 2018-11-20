local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G

-- WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function styleRaidFrame()
	if E.private.skins.blizzard.enable ~= true then return; end

	local RaidInfoFrame = _G["RaidInfoFrame"]
	if RaidInfoFrame.backdrop then
		RaidInfoFrame.backdrop:Styling()
	end
end

S:AddCallback("mUIQRaidFrame", styleRaidFrame)
