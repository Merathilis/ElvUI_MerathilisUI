local E, L, V, P, G, _ = unpack(ElvUI);
local UF = E:GetModule('UnitFrames');
local CH = E:GetModule('Chat');

-- Cache local variables
-- GLOBALS: hooksecurefunc
local pairs, select = pairs, select
local twipe = table.wipe
local random = random

local GetNumClasses = GetNumClasses
local GetClassInfo = GetClassInfo
local GetNumSpecializationsForClassID = GetNumSpecializationsForClassID
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID
local GetNumBattlefieldScores = GetNumBattlefieldScores
local GetBattlefieldScore = GetBattlefieldScore
local IsInInstance = IsInInstance
local GetUnitName = GetUnitName
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitIsConnected = UnitIsConnected
local IsAddOnLoaded = IsAddOnLoaded

local rolePaths = {
	TANK = [[Interface\AddOns\MerathilisUI\media\textures\roleIcons\tank.tga]],
	HEALER = [[Interface\AddOns\MerathilisUI\media\textures\roleIcons\healer.tga]],
	DAMAGER = [[Interface\AddOns\MerathilisUI\media\textures\roleIcons\dps.tga]]
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

function UF:UpdateRoleIcon()
	local lfdrole = self.LFDRole
	if not self.db then return; end
	local db = self.db.roleIcon;
	if (not db) or (db and not db.enable) then
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
		local db = UF.db['units'][name]
		for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())
			for j = 1, group:GetNumChildren() do
				local unitbutton = select(j, group:GetChildren())
				if unitbutton.LFDRole and unitbutton.LFDRole.Override then
					unitbutton.LFDRole.Override = UF.UpdateRoleIcon
				end
			end
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)

	if IsAddOnLoaded("ElvUI_SLE") or E.db.muiUnitframes.roleIcons == false then return end
	SetRoleIcons()

	hooksecurefunc(UF, 'Update_PartyFrames', SetRoleIcons)
	hooksecurefunc(UF, 'Update_RaidFrames', SetRoleIcons)
	hooksecurefunc(UF, 'Update_Raid40Frames', SetRoleIcons)
end)
