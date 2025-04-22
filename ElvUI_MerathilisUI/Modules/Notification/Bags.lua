local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Notification")

local _G = _G

local InCombatLockdown = InCombatLockdown
local C_Container_GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots

local shouldAlert = false
local last = 0

local function onUpdate(self, elapsed)
	last = last + elapsed
	if last > 1 then
		self:SetScript("OnUpdate", nil)
		last = 0
		shouldAlert = true
		module:BAG_UPDATE()
	end
end

function module:BAG_UPDATE()
	module.db = E.db.mui.notification
	if not module.db.enable or not module.db.bags or InCombatLockdown() then
		return
	end

	local totalFree = 0
	for i = _G.BACKPACK_CONTAINER, _G.NUM_BAG_SLOTS do
		local freeSlots, bagFamily = C_Container_GetContainerNumFreeSlots(i)
		if bagFamily == 0 then
			totalFree = totalFree + freeSlots
		end
	end

	if totalFree == 0 then
		if shouldAlert then
			self:DisplayToast(
				_G.INVTYPE_BAG,
				_G.TUTORIAL_TITLE58,
				nil,
				"Interface\\ICONS\\INV_Misc_Bag_08",
				0.08,
				0.92,
				0.08,
				0.92
			)
			shouldAlert = false
		else
			self:SetScript("OnUpdate", onUpdate)
		end
	else
		shouldAlert = false
	end
end
