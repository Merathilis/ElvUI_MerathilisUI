local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Tooltip")
local TT = E:GetModule("Tooltip")

local format = format
local gmatch = gmatch
local gsub = gsub
local strmatch = strmatch
local strtrim = strtrim

local InCombatLockdown = InCombatLockdown
local IsControlKeyDown = IsControlKeyDown
local IsShiftKeyDown = IsShiftKeyDown
local UnitIsPlayer = UnitIsPlayer

local GameTooltip = GameTooltip
local TooltipDataProcessor = _G.TooltipDataProcessor

local C_MountJournal_GetMountInfoByID = C_MountJournal.GetMountInfoByID
local C_UnitAuras_GetAuraDataByIndex = C_UnitAuras.GetAuraDataByIndex

---Mount of the unit, read from its buffs through ElvUI's spell to mount map
---@param unit UnitToken
---@return number?
local function GetUnitMountID(unit)
	local index = 1
	local aura = C_UnitAuras_GetAuraDataByIndex(unit, index, "HELPFUL")
	while aura and E:NotSecretValue(aura) do
		-- Single spells can be flagged as always secret, the mount can still come after them
		local spellID = aura.spellId
		local mountID = E:NotSecretValue(spellID) and E.MountIDs[spellID]
		if mountID then
			return mountID
		end

		index = index + 1
		aura = C_UnitAuras_GetAuraDataByIndex(unit, index, "HELPFUL")
	end
end

-- The journal text is split by |n into "|cFFFFD200Label:|r Text" lines or plain sentences,
-- sometimes with blank lines in between
local function AddSourceLines(tt, source)
	local text = gsub(source, "|n", "\n")
	for line in gmatch(text, "[^\n]+") do
		line = strtrim(line)

		local label, value = strmatch(line, "^(.-|r)%s*(.+)$")
		if label then
			tt:AddDoubleLine(label, value, nil, nil, nil, 1, 1, 1)
		elseif line ~= "" then
			tt:AddLine(line, 1, 1, 1, true)
		end
	end
end

local function OnTooltipSetUnit(tt)
	if tt ~= GameTooltip or tt:IsForbidden() or not E.db.mui.tooltip.mountSource then
		return
	end

	-- Aura data is secret during these and the journal refuses secret IDs, so there is nothing to show
	if InCombatLockdown() or E:IsRestrictedAuras() then
		return
	end

	local unit = TT:GetUnitToken(tt)
	if not unit or unit == "player" or not UnitIsPlayer(unit) then
		return
	end

	local mountID = GetUnitMountID(unit)
	if not mountID then
		return
	end

	local name, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal_GetMountInfoByID(mountID)
	if not name then
		return
	end

	-- ElvUI's post call already ran: it adds the mount line unless Shift is held, the source with Ctrl
	local elvuiLine = E.private.tooltip.enable and E.db.tooltip.showMount and not IsShiftKeyDown()
	if not elvuiLine then
		tt:AddDoubleLine(format("%s:", _G.MOUNT), name, nil, nil, nil, 1, 1, 1)
	end

	local source = E.MountText[mountID]
	if source and not (elvuiLine and IsControlKeyDown()) then
		AddSourceLines(tt, source)
	end

	if E.db.mui.tooltip.mountCollected then
		if isCollected then
			tt:AddLine(_G.COLLECTED, 0.2, 1, 0.2)
		else
			tt:AddLine(_G.NOT_COLLECTED, 1, 0.3, 0.3)
		end
	end
end

-- Registered on first enable only, the post call checks the setting from then on
function module:InitializeMountSource()
	if self.mountSourceHooked or not E.db.mui.tooltip.mountSource then
		return
	end

	if not (TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall) then
		return
	end

	self.mountSourceHooked = true
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, OnTooltipSetUnit)
end
