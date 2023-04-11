local MER, F, E, _, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_Misc')

local _G = _G

local hooksecurefunc = hooksecurefunc
local GetNumGroupMembers = GetNumGroupMembers
local GetSpecialization = GetSpecialization
local IsGuildMember = IsGuildMember
local UnitLevel = UnitLevel
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitSetRole = UnitSetRole

local C_BattleNet_GetGameAccountInfoByGUID = C_BattleNet.GetGameAccountInfoByGUID
local C_FriendList_IsFriend = C_FriendList.IsFriend

function module:SetRole()
	if not E.Retail then return end

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
	if not E.db.mui.misc.blockRequest then return end

	local guid = GetNextPendingInviteConfirmation()
	if not guid then return end

	if not (C_BattleNet.GetGameAccountInfoByGUID(guid) or C_FriendList.IsFriend(guid) or IsGuildMember(guid)) then
		RespondToInviteConfirmation(guid, false)
		StaticPopup_Hide("GROUP_INVITE_CONFIRMATION")
	end
end

function module:Misc()
	self.db = E.db.mui.misc

	-- Quick delete
	local deleteDialog = StaticPopupDialogs["DELETE_GOOD_ITEM"]
	if deleteDialog.OnShow then
		hooksecurefunc(deleteDialog, "OnShow", function(self)
			if E.db.mui.misc.quickDelete then
				self.editBox:SetText(_G.DELETE_ITEM_CONFIRM_STRING)
			end
		end)
	end

	if E.Retail then
		E.RegisterCallback(module, "RoleChanged", "SetRole")
		module:RegisterEvent("GROUP_ROSTER_UPDATE", "SetRole")
		module:RegisterEvent("GROUP_INVITE_CONFIRMATION", "BlockRequest")

		module:WowHeadLinks()
		module:QuickMenu()
	end

	module:LoadGMOTD()
	module:LoadQuest()
	module:LoadnameHover()
end

module:AddCallback("Misc")
