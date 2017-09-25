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

local countIcons -- frame containing the totals by role
local updateIcons
local roleIcons = setmetatable({}, { __index = function(t,i)
	local parent = _G["RaidGroupButton"..i]
	local icon = CreateFrame("Frame", nil, parent)
	icon:SetSize(14, 14)
	icon:SetPoint("RIGHT", parent.subframes.level, "LEFT", 2, 0)
	RaiseFrameLevel(icon)

	local texture = icon:CreateTexture(nil, "ARTWORK")
	texture:SetAllPoints()
	texture:SetTexture(337497) --"Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES"
	icon.texture = texture

	icon:Hide()

	t[i] = icon
	return icon
end })

local count = {}
function updateIcons()
	if not IsInRaid() then
		countIcons:Hide()
		return
	end

	twipe(count)
	for i = 1, GetNumGroupMembers() do
		local button = _G["RaidGroupButton"..i]
		if button and button.subframes then -- make sure the raid button is set up
			local icon = roleIcons[i]
			local role = UnitGroupRolesAssigned("raid"..i)
			if role and role ~= "NONE" then
				icon.texture:SetTexCoord(GetTexCoordsForRoleSmallCircle(role))
				icon:Show()
				count[role] = (count[role] or 0) + 1
			else
				icon:Hide()
			end
		end
	end
	for role, icon in next, countIcons.icons do
		icon.count:SetText(count[role] or 0)
	end
	countIcons:Show()
end

local createCountIcons
local roster = {}
for i=1,NUM_RAID_GROUPS do roster[i] = {} end
local function sortColoredNames(a, b) return a:sub(11) < b:sub(11) end
local function onEnter(self)
	local role = self.role
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
	GameTooltip:SetText(_G["INLINE_" .. role .. "_ICON"] .. _G[role])
	for i = 1, GetNumGroupMembers() do
		local name, _, group, _, _, class, _, _, _, _, _, groupRole = GetRaidRosterInfo(i)
		if name and groupRole == role then
			local color = MER.colors.class[class]
			local coloredName = ("|cff%02x%02x%02x%s"):format(color.r * 255, color.g * 255, color.b * 255, name:gsub("%-.+", "*"))
			tinsert(roster[group], coloredName)
		end
	end
	for group, list in ipairs(roster) do
		tsort(list, sortColoredNames)
		for _, name in ipairs(list) do
			GameTooltip:AddLine(("[%d] %s"):format(group, name), 1, 1, 1)
		end
		twipe(list)
	end
	GameTooltip:Show()
end

function createCountIcons()
	countIcons = CreateFrame("Frame", "oRA3RaidFrameRoleIcons", RaidFrame)
	countIcons:SetPoint("TOPLEFT", 51, 8)
	countIcons:SetSize(30, 30)

	countIcons.icons = {}
	for i, role in ipairs({"TANK", "HEALER", "DAMAGER"}) do
		local frame = CreateFrame("Frame", nil, countIcons)
		frame:SetPoint("LEFT", 30 * (i - 1) - 2 * (i - 1), 0)
		frame:SetSize(30, 30)

		local texture = frame:CreateTexture(nil, "OVERLAY")
		texture:SetTexture(337499) --Interface\\LFGFrame\\UI-LFG-ICON-ROLES
		texture:SetTexCoord(GetTexCoordsForRole(role))
		texture:SetAllPoints()
		frame.texture = texture

		local count = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		count:SetPoint("BOTTOMRIGHT", -2, 2)
		count:SetText(0)
		frame.count = count

		frame.role = role
		frame:SetScript("OnEnter", onEnter)
		frame:SetScript("OnLeave", GameTooltip_Hide)

		countIcons.icons[role] = frame
	end
end

local function styleRaid()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.raid ~= true or E.private.muiSkins.blizzard.raid ~= true then return end

	createCountIcons()
	if RaidFrame:IsShown() then
		updateIcons()
	end

	hooksecurefunc("RaidGroupFrame_Update", updateIcons)
end

S:AddCallbackForAddon("Blizzard_RaidUI", "mUIRaidUI", styleRaid)