local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Notification")

local _G = _G
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local C_Container_GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots

local BACKPACK_CONTAINER = _G.BACKPACK_CONTAINER
local NUM_BAG_SLOTS = _G.NUM_BAG_SLOTS

local shouldAlertBags = false
local last = 0
local bagWatcher

local function alertBagsFull(self)
	local totalFree = 0
	for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		local freeSlots, bagFamily = C_Container_GetContainerNumFreeSlots(i)
		if bagFamily == 0 then
			totalFree = totalFree + freeSlots
		end
	end

	if totalFree == 0 then
		if shouldAlertBags then
			module:DisplayToast(_G.INVTYPE_BAG, _G.TUTORIAL_TITLE58, nil, "Interface\\ICONS\\INV_Misc_Bag_08")
			shouldAlertBags = false
		else
			self:SetScript("OnUpdate", function(frame, elapsed)
				last = last + elapsed
				if last > 1 then
					frame:SetScript("OnUpdate", nil)
					last = 0
					shouldAlertBags = true
					alertBagsFull(frame)
				end
			end)
		end
	else
		shouldAlertBags = false
	end
end

function module:AlertFullBags()
	local db = E.db.mui.notification
	if not db or not db.enable or not db.bags or InCombatLockdown() then
		return
	end

	if bagWatcher then
		return
	end

	bagWatcher = CreateFrame("Frame")
	bagWatcher:RegisterEvent("BAG_UPDATE")
	bagWatcher:SetScript("OnEvent", function(self)
		alertBagsFull(self)
	end)
end
