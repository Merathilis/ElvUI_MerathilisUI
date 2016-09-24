local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local LSM = LibStub('LibSharedMedia-3.0');

-- Cache global variables
-- Lua functions
local next, pairs, table = next, pairs, table

-- WoW API / Variables
local GameTooltip = GameTooltip
local GetNumGroupMembers = GetNumGroupMembers
local UnitClass = UnitClass
local UnitExists = UnitExists
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitName = UnitName
local UnitInRaid = UnitInRaid
local UnitIsDeadOrGhost = UnitIsDeadOrGhost

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: RAID_CLASS_COLORS

local watches = {}
local frame = CreateFrame('Button', nil, UIParent)

local header = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
header:FontTemplate()
header:SetTextColor(1, 1, 1)
header:SetPoint('TOPLEFT', frame, -3, 0)

local t = frame:CreateFontString('MuiRaidStats_Alive', 'ARTWORK', 'GameFontHighlight')
t:SetPoint('TOPLEFT', header, 'BOTTOMLEFT', 3, -6)

local t2 = frame:CreateFontString('MuiRaidStats_Roles', 'ARTWORK', 'GameFontHighlight')
t2:SetPoint('TOPLEFT', t, 'BOTTOMLEFT', 0, -3)

local name = frame:CreateFontString('MuiRaidStats_GRIDName', 'ARTWORK', 'GameFontHighlight')
name:FontTemplate()
name:SetTextColor(1, 1, 1)
name:SetPoint('TOPLEFT', t2, 'BOTTOMLEFT', 20, -8)

local sort = function(a, b)
	return ((a.color.r + a.color.g + a.color.b)..a.name) < ((b.color.r + b.color.g + b.color.b)..b.name)
end

local result = nil
local last, alive, c_alive, max = 0, 0, 0, 0
local update = function(self, elapsed)
	last = last + elapsed
	if last > 1 then
		last = 0
		result = nil
		alive, max = 0, 0
		local num = GetNumGroupMembers()
		if num > 0 then
			-- total raid
			for i = 1, num do
				local unit = UnitInRaid('player') and ('raid'..i) or ('party'..i)
				if UnitExists(unit) then
					max = max + 1
					if not UnitIsDeadOrGhost(unit) then alive = alive + 1 end
				end
			end
			-- role callback handler
			for name, callback in pairs(watches) do
				local count = 0
				c_alive = 0
				for i = 1, num do
					local unit = UnitInRaid('player') and ('raid'..i) or ('party'..i)
					if UnitExists(unit) and callback(unit) then
						count = count + 1
						if not UnitIsDeadOrGhost(unit) then
							c_alive = c_alive + 1
						end
					end
				end
				if count > 0 then
					result = (result and result..'   ' or '')..name ..': '..count..'/'..c_alive
				end
			end
		end
		if max > 0 then
			if E.db.mui.unitframes.groupinfo then
				header:Show()
				header:SetText(UnitInRaid('player') and ('RAID') or ('PARTY'))
				t:SetFormattedText(alive..'/'..max..L[' alive'])
				t:Show()
				frame:SetWidth(t:GetWidth())
			end
		else
			header:Hide()
			t:Hide()
		end
		if result then
			t2:SetText(result)
			t2:Show()
			frame:SetWidth(t:GetWidth())
		else
			t2:Hide()
		end
	end
end

local enter = function()
	GameTooltip:SetOwner(frame, 'ANCHOR_BOTTOMRIGHT', 50, -15)
	for name, callback in pairs(watches) do
		local matches = {}
		for i = 1, GetNumGroupMembers() do
			local unit = UnitInRaid('player') and ('raid'..i) or ('party'..i)
			if UnitExists(unit) and callback(unit) then
				local _, id = UnitClass(unit)
				table.insert(matches, {name = UnitName(unit), color = RAID_CLASS_COLORS[id], alive = UnitIsDeadOrGhost(unit) and '(Dead)' or ''})
			end
		end

		if next(matches) then
			if GameTooltip:NumLines() > 0 then GameTooltip:AddLine(' ') end
			GameTooltip:AddLine(name..':', 1, 1, 1)
			table.sort(matches, sort)
			for _, v in pairs(matches) do
				GameTooltip:AddDoubleLine(v.name, v.alive, v.color.r, v.color.g, v.color.b, v.color.r, v.color.g, v.color.b)
			end
		end
	end
	GameTooltip:Show()
end

function MER:AddWatch(name, callback)
	watches[name] = callback
end

-- Tank
MER:AddWatch('|TInterface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\Tank.tga:14:14|t', function(unit)
	if UnitGroupRolesAssigned(unit) == 'TANK' then
		return (not UnitIsDeadOrGhost(unit))
	end
end)

-- Healer
MER:AddWatch('|TInterface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\Healer.tga:14:14|t', function(unit)
	if UnitGroupRolesAssigned(unit) == 'HEALER' then
		return (not UnitIsDeadOrGhost(unit))
	end
end)

frame:SetPoint("CENTER", LeftChatPanel, "LEFT", 45, 200)
frame:SetHeight(16)
frame:SetScript('OnUpdate', update)
frame:SetScript('OnEnter', enter)
frame:SetScript('OnLeave', function() GameTooltip:Hide() end)