local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_EquipManager") ---@class EquipmentManager
local B = E:GetModule("Bags")

--[[
	Credits: Shadow & Light - SLE BagInfo
	https://github.com/Shadow-and-Light/shadow-and-light/blob/dev/ElvUI_SLE/modules/bags/baginfo.lua
--]]

local next = next
local strmatch = strmatch

local hooksecurefunc = hooksecurefunc
local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
local C_TooltipInfo_GetBagItem = C_TooltipInfo.GetBagItem

local CUSTOM = CUSTOM
local MATCH_EQUIPMENT_SETS = EQUIPMENT_SETS:gsub("%-", "%%-"):gsub("%%s", "(.-)")

module.equipmentmanager = {
	icons = {
		EQUIPMGR = "Equipment Manager Icon |TInterface\\PaperDollInfoFrame\\PaperDollSidebarTabs:20:20:0:0:64:256:1:34:120:155|t",
		EQUIPLOCK = "Equipment Lock Icon |TInterface\\AddOns\\ElvUI_MerathilisUI\\Media\\Textures\\lock:14|t",
		NEWICON = "New Feature Icon |TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:14|t",
		CUSTOM = CUSTOM,
	},
	iconLocations = {
		EQUIPLOCK = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\lock]],
		NEWICON = [[Interface\OptionsFrame\UI-OptionsFrame-NewFeatureIcon]],
	},
}

function B:HideSet(slot, keep)
	if not slot or not slot.equipIcon then
		return
	end
	slot.equipIcon:Hide()

	if not keep and E:IsEventRegisteredForObject("EQUIPMENT_SETS_CHANGED", slot) then
		E:UnregisterEventForObject("EQUIPMENT_SETS_CHANGED", slot, B.UpdateSet)
	end
end

---Tooltip scan — GetContainerItemEquipmentSetInfo is still unreliable
local function IsSlotInEquipmentSet(slot)
	local tooltipData = C_TooltipInfo_GetBagItem(slot.BagID, slot.SlotID)
	if not tooltipData or not tooltipData.lines then
		return false
	end

	local lines = tooltipData.lines
	for i = 1, #lines do
		local text = lines[i] and lines[i].leftText
		if text and strmatch(text, MATCH_EQUIPMENT_SETS) then
			return true
		end
	end
	return false
end

function B:UpdateSet(slot)
	slot = slot == "EQUIPMENT_SETS_CHANGED" and self or slot
	if not slot or not slot.itemID then
		return
	end

	-- The tooltip scan is the expensive part, a disabled indicator skips it
	local db = module.db or E.db.mui.bags.equipmentManager
	if db and db.enable and slot.isEquipment and IsSlotInEquipmentSet(slot) then
		slot.equipIcon:Show()
	else
		B:HideSet(slot, true)
	end
end

local function updateSettings(slot)
	local db = module.db or E.db.mui.bags.equipmentManager
	if not db or not slot.equipIcon then
		return
	end

	local icon = slot.equipIcon
	icon:Size(db.size)
	icon:ClearAllPoints()
	icon:Point(db.point, db.xOffset, db.yOffset)

	if db.icon == "EQUIPMGR" then
		icon:SetTexture([[Interface\PaperDollInfoFrame\PaperDollSidebarTabs]])
		icon:SetTexCoord(0.01562500, 0.53125000, 0.46875000, 0.60546875)
	elseif db.icon == "CUSTOM" then
		icon:SetTexture(db.customTexture)
		icon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	else
		icon:SetTexture(module.equipmentmanager.iconLocations[db.icon] or db.icon)
		icon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	end

	local c = db.color
	icon:SetVertexColor(c.r, c.g, c.b, c.a)
end

function module:UpdateSlot(frame, bagID, slotID)
	local bag = frame.Bags[bagID]
	local slot = bag and bag[slotID]
	if not slot then
		return
	end

	local db = module.db
	if not db.enable then
		B:HideSet(slot)
		return
	end

	-- Created on the first update with the indicator enabled
	if not slot.equipIcon then
		slot.equipIcon = slot:CreateTexture(nil, "OVERLAY")
		updateSettings(slot)
		slot.equipIcon:Hide()
	end

	if slot.isEquipment then
		B:UpdateSet(slot)

		if not E:IsEventRegisteredForObject("EQUIPMENT_SETS_CHANGED", slot) then
			E:RegisterEventForObject("EQUIPMENT_SETS_CHANGED", slot, B.UpdateSet)
		end
	else
		B:HideSet(slot)
	end
end

-- Hooked on first enable only; afterwards UpdateSlot checks the setting itself, so a
-- disabled indicator hides its icons and drops the set events on the next slot update
function module:UpdateItemDisplay()
	if not E.private.bags.enable then
		return
	end

	module.db = F.GetDBFromPath("mui.bags.equipmentManager") or E.db.mui.bags.equipmentManager

	local enabled = module.db.enable and true or false
	if enabled and not self.slotHooked then
		self.slotHooked = true
		hooksecurefunc(B, "UpdateSlot", module.UpdateSlot)
	end

	-- Turned on or off: every slot shows or drops its indicator right away
	local toggled = self.slotHooked and enabled ~= self.lastEnabled
	self.lastEnabled = enabled
	if toggled then
		B:UpdateAllBagSlots()
		return
	end

	for _, bagFrame in next, B.BagFrames do
		for _, bagID in next, bagFrame.BagIDs do
			local bag = bagFrame.Bags[bagID]
			if bag then
				for slotID = 1, C_Container_GetContainerNumSlots(bagID) do
					local slot = bag[slotID]
					if slot and slot.equipIcon then
						updateSettings(slot)
					end
				end
			end
		end
	end
end

function module:Initialize()
	self:UpdateItemDisplay()
end

-- module.db points at the old profile's table after a switch, so icon, size,
-- position and the enable toggle would keep using the old settings
function module:ProfileUpdate()
	module.db = F.GetDBFromPath("mui.bags.equipmentManager") or E.db.mui.bags.equipmentManager

	if not E.private.bags.enable then
		return
	end

	self:UpdateItemDisplay()
	if self.slotHooked then
		B:UpdateAllBagSlots()
	end
end

MER:RegisterModule(module:GetName())
