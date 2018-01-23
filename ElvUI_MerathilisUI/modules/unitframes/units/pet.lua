local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = E:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

-- Cache global variables
-- Lua functions
local _G = _G

-- WoW API / Variables

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MUF:Construct_PetFrame()
	local frame = _G["ElvUF_Pet"]

	self:ArrangePet()
end

function MUF:ArrangePet()
	local frame = _G["ElvUF_Pet"]

	frame:UpdateAllElements("mUI_UpdateAllElements")
end

function MUF:InitPet()
	if not E.db.unitframe.units.pet.enable then return end

	self:Construct_PetFrame()
	hooksecurefunc(UF, 'Update_PetFrame', MUF.ArrangePet)
end