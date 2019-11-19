local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function module:Construct_PetFrame()
	local frame = _G["ElvUF_Pet"]

	self:ArrangePet()
end

function module:ArrangePet()
	local frame = _G["ElvUF_Pet"]

	frame:UpdateAllElements("mUI_UpdateAllElements")
end

function module:InitPet()
	if not E.db.unitframe.units.pet.enable then return end

	self:Construct_PetFrame()
	hooksecurefunc(UF, 'Update_PetFrame', module.ArrangePet)
end
