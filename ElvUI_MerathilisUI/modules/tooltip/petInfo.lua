local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI");

-- Cache global variables
-- Lua functions

-- WoW API / Variables
local UnitBattlePetType = UnitBattlePetType
local UnitIsBattlePet = UnitIsBattlePet
local UnitBattlePetSpeciesID = UnitBattlePetSpeciesID
-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: PET_TYPE_SUFFIX, PET, ID, UNKNOWN

local function InsertPetIcon(self, petType)
	if not self.petIcon then
		local f = self:CreateTexture(nil, "OVERLAY")
		f:SetPoint("TOPRIGHT", -5, -5)
		f:SetSize(35, 35)
		f:SetBlendMode("ADD")
		self.petIcon = f
	end
	self.petIcon:SetTexture("Interface\\PetBattles\\PetIcon-"..PET_TYPE_SUFFIX[petType])
	self.petIcon:SetTexCoord(.188, .883, 0, .348)
	self.petIcon:SetAlpha(1)
end

GameTooltip:HookScript("OnTooltipCleared", function(self)
	if self.petIcon and self.petIcon:GetAlpha() ~= 0 then
		self.petIcon:SetAlpha(0)
	end
end)

local function addPetInfo(self)
	local _, unit = self:GetUnit()
	if not unit then return end
	if not UnitIsBattlePet(unit) then return end
	if E.db.mui.tooltip.petIcon ~= true then return end

	-- Pet Species icon
	InsertPetIcon(self, UnitBattlePetType(unit))

	-- Pet ID
	local speciesID = UnitBattlePetSpeciesID(unit)
	self:AddDoubleLine(PET..ID..":", ((MER.InfoColor..speciesID.."|r") or (MER.GreyColor..UNKNOWN.."|r")))
end
GameTooltip:HookScript("OnTooltipSetUnit", addPetInfo)