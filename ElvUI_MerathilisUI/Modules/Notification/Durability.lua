local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Notification")

local _G = _G
local format = format
local floor = math.floor

local GetInventoryItemLink = GetInventoryItemLink
local GetInventoryItemDurability = GetInventoryItemDurability

local showRepair = true

-- slotID, displayName
local Slots = {
	{ 1, _G.INVTYPE_HEAD },
	{ 3, _G.INVTYPE_SHOULDER },
	{ 5, _G.INVTYPE_ROBE },
	{ 6, _G.INVTYPE_WAIST },
	{ 9, _G.INVTYPE_WRIST },
	{ 10, _G.INVTYPE_HAND },
	{ 7, _G.INVTYPE_LEGS },
	{ 8, _G.INVTYPE_FEET },
	{ 16, _G.INVTYPE_WEAPONMAINHAND },
	{ 17, _G.INVTYPE_WEAPONOFFHAND },
	{ 18, _G.INVTYPE_RANGED },
}

local function ResetRepairNotification()
	showRepair = true
end

function module:UPDATE_INVENTORY_DURABILITY()
	local lowestPct, lowestName = 1, nil

	for i = 1, #Slots do
		local slot = Slots[i]
		if GetInventoryItemLink("player", slot[1]) then
			local current, maximum = GetInventoryItemDurability(slot[1])
			if current and maximum and maximum > 0 then
				local pct = current / maximum
				if pct < lowestPct then
					lowestPct = pct
					lowestName = slot[2]
				end
			end
		end
	end

	local value = floor(lowestPct * 100)
	if showRepair and value < 20 and lowestName then
		showRepair = false
		E:Delay(30, ResetRepairNotification)
		self:DisplayToast(
			_G.MINIMAP_TRACKING_REPAIR,
			format(L["%s slot needs to repair, current durability is %d."], lowestName, value)
		)
	end
end
