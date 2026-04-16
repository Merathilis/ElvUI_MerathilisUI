local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_EquipManager") ---@class EquipmentManager
local B = E:GetModule("Bags")

--[[
	Credits: Shadow & Light - SLE BagInfo
	https://github.com/Shadow-and-Light/shadow-and-light/blob/dev/ElvUI_SLE/modules/bags/baginfo.lua
--]]

local _G = _G
local ipairs = ipairs
local next = next
local strmatch = strmatch

local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
local C_TooltipInfo_GetBagItem = C_TooltipInfo.GetBagItem

local CUSTOM = CUSTOM
local MATCH_EQUIPMENT_SETS = EQUIPMENT_SETS:gsub("%-", "%%-"):gsub("%%s", "(.-)") --* Part of the workaround

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

function B:UpdateSet(slot)
	slot = slot == "EQUIPMENT_SETS_CHANGED" and self or slot
	if not slot or not slot.itemID then
		return
	end
	-- local isInSet, setName = C_Container.GetContainerItemEquipmentSetInfo(bagID, slotID)(slot.bagID, slot.slotID) --* API is currently broken

	--* Start - Part of the workaround
	local isInSet = false
	local tooltipData = C_TooltipInfo_GetBagItem(slot.BagID, slot.SlotID)

	if slot.isEquipment and tooltipData then
		for _, line in ipairs(tooltipData.lines) do
			if (line and line.leftText) and strmatch(line.leftText, MATCH_EQUIPMENT_SETS) then
				isInSet = true
				break
			end
		end
	end
	--* End - Part of the workaround

	if isInSet then
		slot.equipIcon:SetShown(module.db.enable)
	else
		B:HideSet(slot, true)
	end
end

local function updateSettings(slot)
	local db = E.db.mui.bags.equipmentManager
	if not db then
		return
	end

	slot.equipIcon:Size(db.size)
	slot.equipIcon:ClearAllPoints()
	slot.equipIcon:Point(db.point, db.xOffset, db.yOffset)

	if db.icon == "EQUIPMGR" then
		slot.equipIcon:SetTexture([[Interface\PaperDollInfoFrame\PaperDollSidebarTabs]])
		slot.equipIcon:SetTexCoord(0.01562500, 0.53125000, 0.46875000, 0.60546875)
	elseif db.icon == "CUSTOM" then
		slot.equipIcon:SetTexture(db.customTexture)
		slot.equipIcon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	else
		slot.equipIcon:SetTexture(module.equipmentmanager.iconLocations[db.icon] or db.icon)
		slot.equipIcon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	end

	slot.equipIcon:SetVertexColor(db.color.r, db.color.g, db.color.b, db.color.a)
end

function module:UpdateItemDisplay()
	if not E.private.bags.enable then
		return
	end

	for _, bagFrame in next, B.BagFrames do
		for _, bagID in next, bagFrame.BagIDs do
			for slotID = 1, C_Container_GetContainerNumSlots(bagID) do
				local slot = bagFrame.Bags[bagID][slotID]
				if slot and slot.equipIcon then
					updateSettings(slot)
				end
			end
		end
	end
end

function module:ConstructContainerButton(f, bagID, slotID)
	if not f then
		return
	end

	local slotName = B:GetBagSlotInfo(f, bagID, slotID)
	local slot = _G[slotName]
	module.db = E.db.mui.bags.equipmentManager

	if not slot.equipIcon then
		slot.equipIcon = slot:CreateTexture(nil, "OVERLAY")
		updateSettings(slot)
		slot.equipIcon:Hide()
	end
end
hooksecurefunc(B, "ConstructContainerButton", module.ConstructContainerButton)

function module:UpdateSlot(frame, bagID, slotID)
	local bag = frame.Bags[bagID]
	local slot = bag and bag[slotID]
	if not slot or not slot.equipIcon then
		return
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
hooksecurefunc(B, "UpdateSlot", module.UpdateSlot)

function module:Initialize()
	if not E.private.bags.enable then
		return
	end

	self:UpdateItemDisplay()
end

MER:RegisterModule(module:GetName())
