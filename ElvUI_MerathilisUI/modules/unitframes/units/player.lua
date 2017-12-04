local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = E:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables

-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: hooksecurefunc

function MUF:Construct_PlayerFrame()
	local frame = _G["ElvUF_Player"]

	self:ArrangePlayer()
end

function MUF:ArrangePlayer()
	local frame = _G["ElvUF_Player"]
	local db = E.db["unitframe"]["units"].player

	frame:UpdateAllElements("mUI_UpdateAllElements")
end

function MUF:InitPlayer()
	if not E.db.unitframe.units.player.enable then return end

	self:Construct_PlayerFrame()
end