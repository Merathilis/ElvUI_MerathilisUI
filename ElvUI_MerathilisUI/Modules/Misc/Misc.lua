local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")

local _G = _G

local hooksecurefunc = hooksecurefunc
local GetNumGroupMembers = GetNumGroupMembers
local GetSpecialization = GetSpecialization
local IsFriend = C_FriendList.IsFriend
local IsGuildMember = IsGuildMember
local UnitLevel = UnitLevel
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitSetRole = UnitSetRole

local GetGameAccountInfoByGUID = C_BattleNet.GetGameAccountInfoByGUID

function module:SetRole()
	local spec = GetSpecialization()
	if UnitLevel("player") >= 10 and not InCombatLockdown() then
		if spec == nil and UnitGroupRolesAssigned("player") ~= "NONE" then
			UnitSetRole("player", "NONE")
		elseif spec ~= nil then
			if GetNumGroupMembers() > 0 then
				if UnitGroupRolesAssigned("player") ~= E:GetPlayerRole() then
					UnitSetRole("player", E:GetPlayerRole())
				end
			end
		end
	end
end

function module:BlockRequest()
	if not E.db.mui.misc.blockRequest then
		return
	end

	local guid = GetNextPendingInviteConfirmation()
	if not guid then
		return
	end

	if not (GetGameAccountInfoByGUID(guid) or IsFriend(guid) or IsGuildMember(guid)) then
		RespondToInviteConfirmation(guid, false)
		StaticPopup_Hide("GROUP_INVITE_CONFIRMATION")
	end
end

function module:Misc()
	self.db = E.db.mui.misc

	E.RegisterCallback(module, "RoleChanged", "SetRole")
	module:RegisterEvent("GROUP_ROSTER_UPDATE", "SetRole")
	module:RegisterEvent("GROUP_INVITE_CONFIRMATION", "BlockRequest")
end

module:AddCallback("Misc")
