local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Notification")

local _G = _G
local InCombatLockdown = InCombatLockdown
local C_Container_GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots

local BACKPACK_CONTAINER = _G.BACKPACK_CONTAINER
local NUM_BAG_SLOTS = _G.NUM_BAG_SLOTS

-- Warned once, reset as soon as a slot is free again
local alerted = false

function module:BAG_UPDATE_DELAYED()
	local db = E.db.mui.notification
	if not db or not db.enable or not db.bags or InCombatLockdown() then
		return
	end

	local totalFree = 0
	for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		local freeSlots, bagFamily = C_Container_GetContainerNumFreeSlots(i)
		if bagFamily == 0 then
			totalFree = totalFree + freeSlots
		end
	end

	if totalFree > 0 then
		alerted = false
	elseif not alerted then
		alerted = true
		self:DisplayToast(_G.INVTYPE_BAG, _G.TUTORIAL_TITLE58, nil, "Interface\\ICONS\\INV_Misc_Bag_08")
	end
end
