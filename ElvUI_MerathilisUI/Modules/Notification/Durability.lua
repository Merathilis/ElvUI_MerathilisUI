local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Notification

local _G = _G
local format = string.format
local floor = math.floor
local tsort = table.sort

local GetInventoryItemLink = GetInventoryItemLink
local GetInventoryItemDurability = GetInventoryItemDurability

local showRepair = true
local Slots = {
	[1] = { 1, _G.INVTYPE_HEAD, 1000 },
	[2] = { 3, _G.INVTYPE_SHOULDER, 1000 },
	[3] = { 5, _G.INVTYPE_ROBE, 1000 },
	[4] = { 6, _G.INVTYPE_WAIST, 1000 },
	[5] = { 9, _G.INVTYPE_WRIST, 1000 },
	[6] = { 10, _G.INVTYPE_HAND, 1000 },
	[7] = { 7, _G.INVTYPE_LEGS, 1000 },
	[8] = { 8, _G.INVTYPE_FEET, 1000 },
	[9] = { 16, _G.INVTYPE_WEAPONMAINHAND, 1000 },
	[10] = { 17, _G.INVTYPE_WEAPONOFFHAND, 1000 },
	[11] = { 18, _G.INVTYPE_RANGED, 1000 },
}

local function ResetRepairNotification()
	showRepair = true
end

function module:UPDATE_INVENTORY_DURABILITY()
	local current, max

	for i = 1, 11 do
		if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
			current, max = GetInventoryItemDurability(Slots[i][1])
			if current then
				Slots[i][3] = current / max
			end
		end
	end
	tsort(Slots, function(a, b)
		return a[3] < b[3]
	end)

	local value = floor(Slots[1][3] * 100)
	if showRepair and value < 20 then
		showRepair = false
		E:Delay(30, ResetRepairNotification)
		self:DisplayToast(
			_G.MINIMAP_TRACKING_REPAIR,
			format(L["%s slot needs to repair, current durability is %d."], Slots[1][2], value)
		)
	end
end
