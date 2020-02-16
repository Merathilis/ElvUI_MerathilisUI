local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiUnits")
local UF = E.UnitFrames
local COMP = MER:GetModule("mUICompatibility")

--Cache global variables
--Lua Variables
local pairs, select = pairs, select
local random = math.random
--WoW API / Variables
local CreateFrame = CreateFrame
local GetBattlefieldScore = GetBattlefieldScore
local GetClassInfo = GetClassInfo
local GetNumClasses = GetNumClasses
local GetNumBattlefieldScores = GetNumBattlefieldScores
local GetNumSpecializationsForClassID = GetNumSpecializationsForClassID
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID
local GetUnitName = GetUnitName
local IsInInstance = IsInInstance
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitIsConnected = UnitIsConnected
-- GLOBALS:

local rolePaths = {
	TANK = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Tank.tga]],
	HEALER = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Healer.tga]],
	DAMAGER = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Dps.tga]]
}

local specNameToRole = {}
for i = 1, GetNumClasses() do
	local _, class, classID = GetClassInfo(i)
	specNameToRole[class] = {}
	for j = 1, GetNumSpecializationsForClassID(classID) do
		local _, spec, _, _, _, role = GetSpecializationInfoForClassID(classID, j)
		specNameToRole[class][spec] = role
	end
end

local function GetBattleFieldIndexFromUnitName(name)
	local nameFromIndex
	for index = 1, GetNumBattlefieldScores() do
		nameFromIndex = GetBattlefieldScore(index)
		if nameFromIndex == name then
			return index
		end
	end
	return nil
end

function module:UpdateRoleIcon()
	local lfdrole = self.GroupRoleIndicator
	if not self.db then return; end
	local db = self.db.roleIcon;
	if(not db) or (db and not db.enable) then
		lfdrole:Hide()
		return
	end

	local isInstance, instanceType = IsInInstance()
	local role
	if isInstance and instanceType == "pvp" then
		local name = GetUnitName(self.unit, true)
		local index = GetBattleFieldIndexFromUnitName(name)
		if index then
		local _, _, _, _, _, _, _, _, classToken, _, _, _, _, _, _, talentSpec = GetBattlefieldScore(index)
			if classToken and talentSpec then
				role = specNameToRole[classToken][talentSpec]
			else
				role = UnitGroupRolesAssigned(self.unit) --Fallback
			end
		else
			role = UnitGroupRolesAssigned(self.unit) --Fallback
		end
	else
		role = UnitGroupRolesAssigned(self.unit)
		if self.isForced and role == 'NONE' then
		local rnd = random(1, 3)
			role = rnd == 1 and "TANK" or (rnd == 2 and "HEALER" or (rnd == 3 and "DAMAGER"))
		end
	end
	if (self.isForced or UnitIsConnected(self.unit)) and ((role == "DAMAGER" and db.damager) or (role == "HEALER" and db.healer) or (role == "TANK" and db.tank)) then
		lfdrole:SetTexture(rolePaths[role])
		lfdrole:Show()
	else
		lfdrole:Hide()
	end
end

local function SetRoleIcons()
	for _, header in pairs(UF.headers) do
		local name = header.groupName

		for i = 1, header:GetNumChildren() do
			local group = select(i, header:GetChildren())
			for j = 1, group:GetNumChildren() do
				local unitbutton = select(j, group:GetChildren())
				if unitbutton.GroupRoleIndicator and unitbutton.GroupRoleIndicator.Override then
					unitbutton.GroupRoleIndicator.Override = module.UpdateRoleIcon
					unitbutton:UnregisterEvent("UNIT_CONNECTION")
					unitbutton:RegisterEvent("UNIT_CONNECTION", module.UpdateRoleIcon)
				end
			end
		end
	end
	UF:UpdateAllHeaders()
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)

	if COMP.SLE or E.db.mui.unitframes.roleIcons ~= true then return end
	SetRoleIcons()
end)
