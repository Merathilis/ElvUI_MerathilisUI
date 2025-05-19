local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Notification")

local _G = _G

local InCombatLockdown = InCombatLockdown
local C_Container_GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots

local alertBagsFull
local shouldAlertBags = false
local last = 0

local function OnUpdate(self, elapsed)
	last = last + elapsed
	if last > 1 then
		self:SetScript("OnUpdate", nil)
		last = 0
		shouldAlertBags = true
		alertBagsFull(self)
	end
end

alertBagsFull = function(self)
	local totalFree, freeSlots, bagFamily = 0
	for i = _G.BACKPACK_CONTAINER, _G.NUM_BAG_SLOTS do
		freeSlots, bagFamily = C_Container_GetContainerNumFreeSlots(i)
		if bagFamily == 0 then
			totalFree = totalFree + freeSlots
		end
	end

	if totalFree == 0 then
		if shouldAlertBags then
			module:DisplayToast(_G.INVTYPE_BAG, _G.TUTORIAL_TITLE58, nil, "Interface\\ICONS\\INV_Misc_Bag_08")
			shouldAlertBags = false
		else
			self:SetScript("OnUpdate", OnUpdate)
		end
	else
		shouldAlertBags = false
	end
end

function module:AlertFullBags()
	module.db = E.db.mui.notification
	if not module.db.enable or not module.db.bags or InCombatLockdown() then
		return
	end

	local f = CreateFrame("Frame")
	f:RegisterEvent("BAG_UPDATE")
	f:SetScript("OnEvent", function(self, event)
		if event == "BAG_UPDATE" then
			alertBagsFull(self)
		end
	end)
end
