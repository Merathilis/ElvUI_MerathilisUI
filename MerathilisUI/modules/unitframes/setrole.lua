local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI')

-- Cache global variables
-- GLOBALS: spec
local GetNumGroupMembers = GetNumGroupMembers
local GetSpecialization = GetSpecialization
local GetSpecializationRole = GetSpecializationRole
local InCombatLockdown = InCombatLockdown
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitLevel = UnitLevel
local UnitSetRole = UnitSetRole

local function setRole()
	local spec = GetSpecialization()
	if UnitLevel("player") >= 10 and not InCombatLockdown() then
		if spec == nil then
			UnitSetRole("player", "No Role")
		elseif spec ~= nil then
			if GetNumGroupMembers() > 0 then
				local role = GetSpecializationRole(spec)
				if UnitGroupRolesAssigned("player") ~= role then
					UnitSetRole("player", role)
				end
			end
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
	if E.db.muiUnitframes.setRole then
		if event == "PLAYER_ENTERING_WORLD" then
			self:RegisterEvent("PLAYER_TALENT_UPDATE", setRole)
			self:RegisterEvent("GROUP_ROSTER_UPDATE", setRole)
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end
end)

RolePollPopup:UnregisterEvent("ROLE_POLL_BEGIN")
