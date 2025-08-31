local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc
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
	local info = GetGemLink(self.gemID)
	if not info then
		return
	end

	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 3)
	GameTooltip:SetHyperlink(info)
	GameTooltip:Show()
end

function module:Socket_OnClick()
	for bagID = 0, 4 do
		for slotID = 1, C_Container_GetContainerNumSlots(bagID) do
			if C_Container_GetContainerItemID(bagID, slotID) == self.gemID then
				C_Container_PickupContainerItem(bagID, slotID)
				ClickSocketButton(self.socketID)
				ClearCursor()
				return
			end
		end
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

local fiberSockets = { 238044, 238046, 238045, 238042, 238040, 238037, 238039, 238041 }

function module:CreateFiberSockets()
	if module.FiberSockets then
		return
	end

	local locales = { L["Crit"], L["Mastery"], L["Haste"], L["Versa"] }

	local frame = CreateFrame("Frame", "MER_FiberSocket", ItemSocketingFrame)
	frame:SetSize(iconSize * 4, iconSize * 2)
	frame:SetPoint("TOP", _G["ItemSocketingSocket1"], "BOTTOM", 0, -50)
	frame:CreateBackdrop("Transparent")

	for index, gemID in pairs(fiberSockets) do
		local button = S.CreateButton(frame, iconSize, iconSize, true, C_Item_GetItemIconByID(gemID))
		button:SetPoint("TOPLEFT", mod(index - 1, 4) * (iconSize + 5), -(index > 4 and (iconSize + 5) or 0))
		local colors = E.QualityColors[index <= 4 and 4 or 3]
		button.backdrop:SetBackdropBorderColor(colors.r, colors.g, colors.b)
		button.socketID = 1
		button.gemID = gemID
		button:SetScript("OnEnter", module.Socket_OnEnter)
		button:SetScript("OnClick", module.Socket_OnClick)
		button:SetScript("OnLeave", GameTooltip_Hide)

		button.text = button:CreateFontString(nil, "OVERLAY")
		button.text:FontTemplate(nil, 14, "SHADOWOUTLINE")
		button.text:SetText(locales[mod(index - 1, 4) + 1])
		button.text:SetTextColor(1, 0.8, 0)
	end

	module.FiberSockets = frame
end

function module:SetupSingingSockets()
	if not E.db.mui.misc.singingSockets.enable then
		return
	end

	hooksecurefunc("ItemSocketingFrame_LoadUI", function()
		if not ItemSocketingFrame then
			return
		end

		if module.SingingFrames then
			for i = 1, 3 do
				module.SingingFrames[i]:Hide()
			end
		end
		if module.FiberSockets then
			module.FiberSockets:Hide()
		end

		local socketType = GetSocketTypes(1)
		if socketType == "SingingThunder" then
			module:CreateSingingSockets()
			for i = 1, 3 do
				module.SingingFrames[i]:SetShown(not GetExistingSocketInfo(i))
			end
		elseif socketType == "Fiber" then
			module:CreateFiberSockets()
			module.FiberSockets:SetShown(not GetExistingSocketInfo(1))
		end
	end)
end

module:AddCallback("SetupSingingSockets")
