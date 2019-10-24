local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
local pairs, unpack = pairs, unpack
--WoW API / Variables
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true then return end

	local StackSplitFrame = _G.StackSplitFrame
	StackSplitFrame:Styling()
end

S:AddCallback("mUIStackSplitFrame", LoadSkin)
