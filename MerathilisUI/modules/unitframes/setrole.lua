local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI')

-- Cache global variables
-- GLOBALS: self, player_low, player_role, player_spec, player_spec_name
local _G = _G
local select = select

local GetSpecialization = GetSpecialization
local GetSpecializationRole = GetSpecializationRole
local GetSpecializationInfo = GetSpecializationInfo
local UnitSetRole = UnitSetRole
local UnitLevel = UnitLevel
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded

-- Based on AutoRole by Erfolg
if IsAddOnLoaded("AutoRole") then return; end

local function OnEnable()
	self:SetPlayerInfo()
end

local function SetPlayerInfo()
	if (UnitLevel("player") < 10) then
		player_low = true
	else
		player_low = false
		player_spec = GetSpecialization()
		player_role = GetSpecializationRole(player_spec)
		player_spec_name = player_spec and select(2, GetSpecializationInfo(player_spec))
	end
end

local function SetPlayerRole(event)
	self:SetPlayerInfo()

	if InCombatLockdown() then
		return
	else
		if (player_role ~= nil) then
			UnitSetRole("player", player_role)
		else
			UnitSetRole("player", "NONE")
		end
	end
end

local function DisplayPlayerRole()
	self:SetPlayerInfo()

	if (player_role ~= nil) then
		MER:Print(L["Role set to"], player_role, L["because your specc is"], player_spec_name)
	else
		if player_low then
			MER:Print(L["Cannot set role because you are below level 10."])
		else
			MER:Print(L["Cannot set role because you have no specialization."])
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
	if E.db.muiUnitframes.setRole then
		if event == "PLAYER_ENTERING_WORLD" then
			self:RegisterEvent("GROUP_ROSTER_UPDATE", "SetPlayerRole")
			self:RegisterEvent("PLAYER_REGEN_ENABLED", "SetPlayerRole")
			self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "SetPlayerRole")
			_G["RolePollPopup"]:SetScript("OnShow", function() _G["RolePollPopupAcceptButton"]:Click() end)
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end
end)
