local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Tooltip")

local format = format
local type = type

local C_Item_GetDetailedItemLevelInfo = C_Item.GetDetailedItemLevelInfo
local C_Item_GetItemLinkByGUID = C_Item.GetItemLinkByGUID
local C_Item_GetItemUpgradeInfo = C_Item.GetItemUpgradeInfo

-- Blizzard's own "Upgrade Level: %s %d/%d", already localized
local UPGRADE_FORMAT = ITEM_UPGRADE_TOOLTIP_FORMAT_STRING or "%s %d/%d"

---Item link of the tooltip's own item, nil for appended items (e.g. a set bonus
---item below the primary one) and previews with an overridden item level
---@param tooltip GameTooltip
---@return string?
local function GetTooltipItemLink(tooltip)
	local info = tooltip.GetProcessingTooltipInfo and tooltip:GetProcessingTooltipInfo()
	local data = info and info.tooltipData
	if not data or E:IsSecretValue(data) or tooltip:GetPrimaryTooltipData() ~= data then
		return
	end

	-- Upgrade previews (e.g. the item upgrade frame) show a different item level
	-- than the link itself carries
	local override = data.overrideItemLevel
	if E:IsSecretValue(override) or (override and override > 0) then
		return
	end

	local link = data.hyperlink
	local guid = data.guid
	if not E:IsSecretValue(guid) and guid and guid ~= "" then
		link = C_Item_GetItemLinkByGUID(guid) or link
	end

	if not E:IsSecretValue(link) and type(link) == "string" and link ~= "" then
		return link
	end
end

---Replaces Blizzard's upgrade line with the same text in the color of the upgrade
---track, the item level the item can still reach on the right. Returning true
---consumes Blizzard's line, nil keeps it (unknown tracks, secret values)
---@param tooltip GameTooltip
---@return boolean?
local function OnUpgradeLevelLine(tooltip)
	if not E.db.mui.tooltip.upgradeTrack or tooltip:IsForbidden() then
		return
	end

	local link = GetTooltipItemLink(tooltip)
	local upgradeInfo = link and C_Item_GetItemUpgradeInfo(link)
	if not upgradeInfo or E:IsSecretValue(upgradeInfo) then
		return
	end

	local current, maximum = upgradeInfo.currentLevel, upgradeInfo.maxLevel
	local trackName, maxItemLevel = upgradeInfo.trackString, upgradeInfo.maxItemLevel
	if not (current and maximum and trackName and trackName ~= "") then
		return
	end

	local r, g, b = F.GetUpgradeTrackColor(upgradeInfo.trackStringID)
	if not r then
		return
	end

	local text = format(UPGRADE_FORMAT, trackName, current, maximum)
	local itemLevel = C_Item_GetDetailedItemLevelInfo(link)

	if current < maximum and itemLevel and maxItemLevel and maxItemLevel > itemLevel then
		tooltip:AddDoubleLine(text, format(L["Up to %d"], maxItemLevel), r, g, b, 0.8, 0.8, 0.8)
	else
		tooltip:AddLine(text, r, g, b)
	end

	return true
end

-- Registered on first enable only, Blizzard has no way to remove a line call;
-- the callback checks the setting from then on
function module:InitializeUpgradeTrack()
	if self.upgradeTrackHooked or E.Forever or not E.db.mui.tooltip.upgradeTrack then
		return
	end

	local lineTypes = Enum.TooltipDataLineType
	if not (TooltipDataProcessor and lineTypes and lineTypes.ItemUpgradeLevel) then
		return
	end
	self.upgradeTrackHooked = true

	TooltipDataProcessor.AddLinePreCall(lineTypes.ItemUpgradeLevel, OnUpgradeLevelLine)
end
