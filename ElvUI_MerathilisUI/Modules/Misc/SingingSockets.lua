local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")
local S = MER:GetModule("MER_Skins")

local ClearCursor = ClearCursor
local ClickSocketButton = ClickSocketButton
local GetSocketTypes = GetSocketTypes
local GetExistingSocketInfo = GetExistingSocketInfo

local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
local C_Container_GetContainerItemID = C_Container.GetContainerItemID
local C_Container_PickupContainerItem = C_Container.PickupContainerItem
local C_Item_GetItemIconByID = C_Item.GetItemIconByID
local C_Item_GetItemInfo = C_Item.GetItemInfo

local iconSize = 36
local gemsInfo = {
	[1] = { 228638, 228634, 228642, 228648 },
	[2] = { 228647, 228639, 228644, 228636 },
	[3] = { 228640, 228646, 228643, 228635 },
}

local gemCache = {}
local function GetGemLink(gemID)
	local info = gemCache[gemID]
	if not info then
		info = select(2, C_Item_GetItemInfo(gemID))
		gemCache[gemID] = info
	end
	return info
end

function module:Socket_OnEnter()
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 3)
	GameTooltip:SetHyperlink(GetGemLink(self.gemID))
	GameTooltip:Show()
end

function module:Socket_OnClick()
	local BAG_ID, SLOT_ID
	for bagID = 0, 4 do
		for slotID = 1, C_Container_GetContainerNumSlots(bagID) do
			local itemID = C_Container_GetContainerItemID(bagID, slotID)
			if itemID == self.gemID then
				BAG_ID = bagID
				SLOT_ID = slotID
			end
		end
	end
	if BAG_ID and SLOT_ID then
		C_Container_PickupContainerItem(BAG_ID, SLOT_ID)
		ClickSocketButton(self.socketID)
		ClearCursor()
	end
end

function module:CreateSingingSockets()
	if module.SingingFrames then
		return
	end

	module.SingingFrames = {}

	for i = 1, 3 do
		local frame = CreateFrame("Frame", "MER_SingingSocket" .. i, ItemSocketingFrame)
		frame:SetSize(iconSize * 2, iconSize * 2)
		frame:SetPoint("TOP", _G["ItemSocketingSocket" .. i], "BOTTOM", 0, -40)
		frame:CreateBackdrop("Transparent")
		module.SingingFrames[i] = frame

		local index = 0
		for _, gemID in next, gemsInfo[i] do
			local button = S.CreateButton(frame, iconSize, iconSize, true, C_Item_GetItemIconByID(gemID))
			button:SetPoint("TOPLEFT", mod(index, 2) * iconSize, -(index > 1 and iconSize or 0))
			index = index + 1
			button.socketID = i
			button.gemID = gemID
			button:SetScript("OnEnter", module.Socket_OnEnter)
			button:SetScript("OnClick", module.Socket_OnClick)
			button:SetScript("OnLeave", GameTooltip_Hide)
		end
	end
end
function module:SetupSingingSockets()
	if not E.db.mui.misc.singingSockets.enable then
		return
	end

	hooksecurefunc("ItemSocketingFrame_LoadUI", function()
		if not ItemSocketingFrame then
			return
		end

		module:CreateSingingSockets()

		if module.SingingFrames then
			local isSingingSocket = GetSocketTypes(1) == "SingingThunder"
			for i = 1, 3 do
				module.SingingFrames[i]:SetShown(isSingingSocket and not GetExistingSocketInfo(i))
			end
		end
	end)
end

module:AddCallback("SetupSingingSockets")
