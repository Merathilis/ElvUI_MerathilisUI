local MER, E, L, V, P, G = unpack(select(2, ...))
local TT = E:GetModule("Tooltip")

--Cache global variables
--Lua functions
local select = select
local format = string.format
--WoW API / Variables
local GetGuildInfo = GetGuildInfo
local GetMouseFocus = GetMouseFocus
local IsControlKeyDown = IsControlKeyDown
local IsAltKeyDown = IsAltKeyDown
local IsForbidden = IsForbidden
local IsShiftKeyDown = IsShiftKeyDown
local UnitClass = UnitClass
local UnitExists = UnitExists
local UnitIsAFK = UnitIsAFK
local UnitIsDND = UnitIsDND
local UnitIsPlayer = UnitIsPlayer
local UnitName = UnitName
local UnitPVPName = UnitPVPName
local UnitLevel = UnitLevel
local UnitRealmRelationship = UnitRealmRelationship
local FOREIGN_SERVER_LABEL = FOREIGN_SERVER_LABEL
local LE_REALM_RELATION_COALESCED = LE_REALM_RELATION_COALESCED
local LE_REALM_RELATION_VIRTUAL = LE_REALM_RELATION_VIRTUAL
local INTERACTIVE_SERVER_LABEL = INTERACTIVE_SERVER_LABEL
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS: CUSTOM_CLASS_COLORS, UIParent, GameTooltipTextLeft1

local AFK_LABEL = " |cffFFFFFF<|r|cffFF0000"..L["AFK"].."|r|cffFFFFFF>|r"
local DND_LABEL = " |cffFFFFFF<|r|cffFFFF00"..L["DND"].."|r|cffFFFFFF>|r"

function MER:GameTooltip_OnTooltipSetUnit(tt)
	if E.private.tooltip.enable ~= true then return end
	if tt:IsForbidden() then return end
	local unit = select(2, tt:GetUnit())
	if((tt:GetOwner() ~= UIParent) and (self.db.visibility and self.db.visibility.unitFrames ~= 'NONE')) then
		local modifier = self.db.visibility.unitFrames

		if(modifier == 'ALL' or not ((modifier == 'SHIFT' and IsShiftKeyDown()) or (modifier == 'CTRL' and IsControlKeyDown()) or (modifier == 'ALT' and IsAltKeyDown()))) then
			tt:Hide()
			return
		end
	end

	if(not unit) then
		local GMF = GetMouseFocus()
		if(GMF and GMF.GetAttribute and GMF:GetAttribute("unit")) then
			unit = GMF:GetAttribute("unit")
		end
		if(not unit or not UnitExists(unit)) then
			return
		end
	end

	self:RemoveTrashLines(tt) --keep an eye on this may be buggy
	local level = UnitLevel(unit)
	local isShiftKeyDown = IsShiftKeyDown()

	local color
	if(UnitIsPlayer(unit)) then
		local localeClass, class = UnitClass(unit)
		local name, realm = UnitName(unit)
		local guildName, guildRankName, _, guildRealm = GetGuildInfo(unit)
		local pvpName = UnitPVPName(unit)
		local relationship = UnitRealmRelationship(unit);
		if not localeClass or not class then return; end
		color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

		if(self.db.playerTitles and pvpName) then
			name = pvpName
		end

		if(realm and realm ~= "") then
			if(isShiftKeyDown) then
				name = name..format("|cff00c0fa%s|r", " - "..realm)
			elseif(relationship == LE_REALM_RELATION_COALESCED) then
				name = name..format("|cff00c0fa%s|r", FOREIGN_SERVER_LABEL)
			elseif(relationship == LE_REALM_RELATION_VIRTUAL) then
				name = name..format("|cff00c0fa%s|r", INTERACTIVE_SERVER_LABEL)
			end
		end

		if(UnitIsAFK(unit)) then
			name = name..AFK_LABEL
		elseif(UnitIsDND(unit)) then
			name = name..DND_LABEL
		end

		GameTooltipTextLeft1:SetFormattedText("|c%s%s|r", color.colorStr, name)
	end
end
hooksecurefunc(TT, "GameTooltip_OnTooltipSetUnit", MER.GameTooltip_OnTooltipSetUnit)