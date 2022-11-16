local MER, F, E, _, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Misc')

local _G = _G
local pairs = pairs
local twipe = table.wipe
local tinsert = table.insert
local strfind = string.find
local gsub = gsub

local hooksecurefunc = hooksecurefunc
local C_FriendList_GetNumWhoResults = C_FriendList.GetNumWhoResults
local C_FriendList_GetWhoInfo = C_FriendList.GetWhoInfo
local GetGuildInfo = GetGuildInfo
local GetQuestDifficultyColor = GetQuestDifficultyColor
local GetNumGroupMembers = GetNumGroupMembers
local GetRealZoneText = GetRealZoneText
local GetSpecialization = GetSpecialization
local UnitLevel = UnitLevel
local UnitRace = UnitRace
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitSetRole = UnitSetRole
local InCombatLockdown = InCombatLockdown
local StaticPopupSpecial_Hide = StaticPopupSpecial_Hide
local HybridScrollFrame_GetOffset = HybridScrollFrame_GetOffset
local UIDropDownMenu_GetSelectedID = UIDropDownMenu_GetSelectedID
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

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

		module:WowHeadLinks()
		module:AddAlerts()
		module:QuickMenu()
	end

	module:LoadGMOTD()
	module:LoadQuest()
	module:LoadnameHover()
end

module:AddCallback("Misc")
