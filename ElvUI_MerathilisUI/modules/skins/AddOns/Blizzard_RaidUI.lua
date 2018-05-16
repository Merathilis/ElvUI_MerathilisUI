local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

--Cache global variables
--Lua functions
local _G = _G
local ipairs, next = ipairs, next
local tinsert, tsort, twipe = table.insert, table.sort, table.wipe

--WoW API / Variables
local CreateFrame = CreateFrame
local GetNumGroupMembers = GetNumGroupMembers
local GetTexCoordsForRole = GetTexCoordsForRole
local GetRaidRosterInfo = GetRaidRosterInfo
local IsInRaid = IsInRaid
local UnitGroupRolesAssigned = UnitGroupRolesAssigned

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, GameTooltip, GameTooltip_Hide, RaidFrame, RaiseFrameLevel, GetTexCoordsForRoleSmallCircle


local function styleRaid()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.raid ~= true or E.private.muiSkins.blizzard.raid ~= true then return end

	createCountIcons()
	if RaidFrame:IsShown() then
		updateIcons()
	end

	hooksecurefunc("RaidGroupFrame_Update", updateIcons)
end

S:AddCallbackForAddon("Blizzard_RaidUI", "mUIRaidUI", styleRaid)