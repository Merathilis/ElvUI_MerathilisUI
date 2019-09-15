local MER, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')

--Lua functions
local _G = _G
local select = select
local format, gsub = string.format, string.gsub
local floor, modf = math.floor, math.modf
local tsort = table.sort
--WoW API / Variables
local CreateFrame = CreateFrame
local GetAverageItemLevel = GetAverageItemLevel
local GetInventoryItemTexture = GetInventoryItemTexture
local GetInventoryItemDurability = GetInventoryItemDurability
local GetInventoryItemLink = GetInventoryItemLink
local GetMoneyString = GetMoneyString
local GetItemLevelColor = GetItemLevelColor
local InCombatLockdown = InCombatLockdown
local ToggleCharacter = ToggleCharacter
local UIParent = UIParent
local DURABILITY = DURABILITY
local NONE = NONE
local REPAIR_COST = REPAIR_COST
local HEADER_COLON = HEADER_COLON

local repairCostString = gsub(REPAIR_COST, HEADER_COLON, ":")

local localSlots = {
	[1] = {1, INVTYPE_HEAD, 1000},
	[2] = {3, INVTYPE_SHOULDER, 1000},
	[3] = {5, INVTYPE_CHEST, 1000},
	[4] = {6, INVTYPE_WAIST, 1000},
	[5] = {9, INVTYPE_WRIST, 1000},
	[6] = {10, INVTYPE_HAND, 1000},
	[7] = {7, INVTYPE_LEGS, 1000},
	[8] = {8, INVTYPE_FEET, 1000},
	[9] = {16, INVTYPE_WEAPONMAINHAND, 1000},
	[10] = {17, INVTYPE_WEAPONOFFHAND, 1000}
}

local function sortSlots(a, b)
	if a and b then
		return (a[3] == b[3] and a[1] < b[1]) or (a[3] < b[3])
	end
end

local function getItemDurability()
	local numSlots = 0
	for i = 1, 10 do
		localSlots[i][3] = 1000
		local index = localSlots[i][1]
		if GetInventoryItemLink("player", index) then
			local current, max = GetInventoryItemDurability(index)
			if current then
				localSlots[i][3] = current/max
				numSlots = numSlots + 1
			end
		end
	end
	tsort(localSlots, sortSlots)

	return numSlots
end

local function gradientColor(perc)
	perc = perc > 1 and 1 or perc < 0 and 0 or perc -- Stay between 0-1
	local seg, relperc = modf(perc*2)
	local r1, g1, b1, r2, g2, b2 = select(seg*3+1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0) -- R -> Y -> G
	local r, g, b = r1+(r2-r1)*relperc, g1+(g2-g1)*relperc, b1+(b2-b1)*relperc
	return format("|cff%02x%02x%02x", r*255, g*255, b*255), r, g, b
end

local tip = CreateFrame("GameTooltip", "muiDurabilityTooltip")
tip:SetOwner(UIParent, "ANCHOR_NONE")

local function OnEvent(self)
	local numSlots = getItemDurability()
	if numSlots > 0 then
		self.text:SetText(format(gsub(L["Dura."]..": ".."[color]%d|r%%", "%[color%]", (gradientColor(floor(localSlots[1][3]*100)/100))), floor(localSlots[1][3]*100)))
	else
		self.text:SetText(L["Dura."]..": "..NONE)
	end
end

local function Click()
	if InCombatLockdown() then _G.UIErrorsFrame:AddMessage(E.InfoColor.._G.ERR_NOT_IN_COMBAT) return end
	ToggleCharacter("PaperDollFrame")
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	DT.tooltip:ClearLines()
	DT.tooltip:AddLine(DURABILITY, 0, 191/255, 250/255)
	DT.tooltip:AddLine(" ")

	local totalCost = 0
	for i = 1, 10 do
		if localSlots[i][3] ~= 1000 then
			local slot = localSlots[i][1]
			local green = localSlots[i][3]*2
			local red = 1 - green
			local slotIcon = "|T"..GetInventoryItemTexture("player", slot)..":13:15:0:0:50:50:4:46:4:46|t " or ""
			DT.tooltip:AddDoubleLine(slotIcon..localSlots[i][2], floor(localSlots[i][3]*100).."%", 1, 1, 1, red+1, green,0)

			totalCost = totalCost + select(3, tip:SetInventoryItem("player", slot))
		end
	end

	if totalCost > 0 then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(repairCostString, GetMoneyString(totalCost), .6, .8, 1, 1, 1, 1)
	end
	DT.tooltip:Show()
end

DT:RegisterDatatext('MUI Durability', {'PLAYER_ENTERING_WORLD', "UPDATE_INVENTORY_DURABILITY", "MERCHANT_SHOW"}, OnEvent, nil, Click, OnEnter, nil, DURABILITY)
