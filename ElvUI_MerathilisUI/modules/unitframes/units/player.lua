local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function module:Update_PlayerFrame(frame)
	local db = E.db.mui.unitframes.units.player.swing

	if not frame.Swing then module:Construct_Swing(frame) end

	if db.enable then
		if not frame:IsElementEnabled('Swing') then
			frame:EnableElement('Swing')
		end
	else
		if frame:IsElementEnabled('Swing') then
			frame:DisableElement('Swing')
		end
	end
end

function module:InitPlayer()
	if not E.db.unitframe.units.player.enable then return end

	hooksecurefunc(UF, "Update_PlayerFrame", module.Update_PlayerFrame)
end
