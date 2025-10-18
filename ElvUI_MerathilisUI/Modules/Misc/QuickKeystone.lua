local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_QuickKeystone") ---@class Misc

local _G = _G

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_Container_GetContainerItemID = C_Container.GetContainerItemID
local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
local C_Container_UseContainerItem = C_Container.UseContainerItem
local C_Item_IsItemKeystoneByID = C_Item.IsItemKeystoneByID

local NUM_BAG_SLOTS = NUM_BAG_SLOTS

function module:PutKeystone()
	for bagIndex = 0, NUM_BAG_SLOTS do
		for slotIndex = 1, C_Container_GetContainerNumSlots(bagIndex) do
			local itemID = C_Container_GetContainerItemID(bagIndex, slotIndex)
			if itemID and C_Item_IsItemKeystoneByID(itemID) then
				C_Container_UseContainerItem(bagIndex, slotIndex)
				return
			end
		end
	end
end

function module:UpdateHook(event, addon)
	if event then
		if addon == "Blizzard_ChallengesUI" then
			self:UnregisterEvent("ADDON_LOADED")
		else
			return
		end
	end

	local frame = _G.ChallengesKeystoneFrame
	if not frame then
		return
	end

	if self.db.enable then
		if not self:IsHooked(frame, "OnShow") then
			self:SecureHookScript(frame, "OnShow", "PutKeystone")
		end
	else
		if self:IsHooked(frame, "OnShow") then
			self:Unhook(frame, "OnShow")
		end
	end
end

function module:ProfileUpdate()
	self.db = E.db.mui.misc.quickKeystone

	if C_AddOns_IsAddOnLoaded("Blizzard_ChallengesUI") then
		self:UpdateHook()
	else
		self:RegisterEvent("ADDON_LOADED", "UpdateHook")
	end
end

module.Initialize = module.ProfileUpdate

MER:RegisterModule(module:GetName())
