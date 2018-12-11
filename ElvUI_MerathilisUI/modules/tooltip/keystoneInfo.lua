local MER, E, L, V, P, G = unpack(select(2, ...))

if IsAddOnLoaded("KeystoneHelper") then return; end

-- Cache global variables
-- Lua functions
local ipairs, select, tonumber, type = ipairs, select, tonumber, type
local format, strmatch, strsplit = string.format, string.match, string.split
local tinsert, tremove = table.insert, table.remove

-- WoW API / Variables
local C_ChallengeMode = C_ChallengeMode
local C_ChallengeMode_GetAffixInfo = C_ChallengeMode.GetAffixInfo
-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS:

local function GetModifiers(linkType, ...)
	if type(linkType) ~= 'string' then return end
	local modifierOffset = 4
	local instanceID, mythicLevel, notDepleted, _ = ...
	if linkType:find('item') then
		_, _, _, _, _, _, _, _, _, _, _, _, _, instanceID, mythicLevel = ...
		if ... == '138019' then
			modifierOffset = 16
		else
			return
		end
	elseif not linkType:find('keystone') then
		return
	end

	local modifiers = {}
	for i = modifierOffset, select('#', ...) do
		local num = strmatch(select(i, ...) or '', '^(%d+)')
		if num then
			local modifierID = tonumber(num)
			if modifierID then
				tinsert(modifiers, modifierID)
			end
		end
	end

	local numModifiers = #modifiers
	if modifiers[numModifiers] and modifiers[numModifiers] < 2 then
		tremove(modifiers, numModifiers)
	end

	return modifiers, instanceID, mythicLevel
end

local function DecorateTooltip(self, link, _)
	if E.db.mui.tooltip.keystone ~= true then return end

	if not link then
		_, link = self:GetItem()
	end

	if type(link) == 'string' then
		local modifiers, instanceID, mythicLevel = GetModifiers(strsplit(':', link))
		if modifiers then
			for _, modifierID in ipairs(modifiers) do
				local modifierName, modifierDescription = C_ChallengeMode_GetAffixInfo(modifierID)
				if modifierName and modifierDescription then
					self:AddLine(format('|cff00ff00%s|r - %s', modifierName, modifierDescription), 0, 1, 0, true)
				end
			end
			self:Show()
		end
	end
end

hooksecurefunc(ItemRefTooltip, 'SetHyperlink', DecorateTooltip)
--ItemRefTooltip:HookScript('OnTooltipSetItem', DecorateTooltip)
GameTooltip:HookScript('OnTooltipSetItem', DecorateTooltip)
