local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiUnits")
local UF = E:GetModule('UnitFrames')
local COMP = MER:GetModule("mUICompatibility")

--Cache global variables
--Lua Variables
local pairs, select = pairs, select
local random = math.random
--WoW API / Variables
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitIsConnected = UnitIsConnected
-- GLOBALS:

local rolePaths = {
	TANK = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Tank.tga]],
	HEALER = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Healer.tga]],
	DAMAGER = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Dps.tga]]
}

function module:UpdateRoleIcon()
	local lfdrole = self.GroupRoleIndicator
	if not self.db then return; end
	local db = self.db.roleIcon

	if (not db) or (db and not db.enable) then
		lfdrole:Hide()
		return
	end

	local role = UnitGroupRolesAssigned(self.unit)
	if self.isForced and role == 'NONE' then
		local rnd = random(1, 3)
		role = rnd == 1 and "TANK" or (rnd == 2 and "HEALER" or (rnd == 3 and "DAMAGER"))
	end

	if (self.isForced or UnitIsConnected(self.unit)) and ((role == "DAMAGER" and db.damager) or (role == "HEALER" and db.healer) or (role == "TANK" and db.tank)) then
		lfdrole:SetTexture(rolePaths[role])
		lfdrole:Show()
	else
		lfdrole:Hide()
	end
end

function module:SetRoleIcons()
	for _, header in pairs(UF.headers) do
		local name = header.groupName
		local db = UF.db["units"][name]

		for i = 1, header:GetNumChildren() do
			local group = select(i, header:GetChildren())
			for j = 1, group:GetNumChildren() do
				local unitbutton = select(j, group:GetChildren())
				if unitbutton.GroupRoleIndicator and unitbutton.GroupRoleIndicator.Override and not unitbutton.GroupRoleIndicator.MERRoleSetup then
					unitbutton.GroupRoleIndicator.Override = module.UpdateRoleIcon
					unitbutton:UnregisterEvent("UNIT_CONNECTION")
					unitbutton:RegisterEvent("UNIT_CONNECTION", module.UpdateRoleIcon)
					unitbutton.GroupRoleIndicator.MERRoleSetup = true
				end
			end
		end
	end
	UF:UpdateAllHeaders()
end
