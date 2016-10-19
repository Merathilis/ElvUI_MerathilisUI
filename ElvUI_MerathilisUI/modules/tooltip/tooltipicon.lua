local E, L, V, P, G = unpack(ElvUI);

-- Cache global variables
-- Lua functions
local _G = _G
local select, type = select, type
local strmatch = string.match
-- WoW API / Variables
local CreateFrame = CreateFrame
local GetAchievementInfo = GetAchievementInfo
local GetItemIcon = GetItemIcon
local GetSpellInfo = GetSpellInfo

local function AddIcon(self, icon)
	if E.db.mui.misc.Tooltip ~= true then return; end

	if icon then
		local title = _G[self:GetName() .. "TextLeft1"]
		if title and not title:GetText():find("|T" .. icon) then
			title:SetFormattedText("|T%s:20:20:0:0:64:64:5:59:5:59:%d|t %s", icon, 20, title:GetText())
		end
	end
end

-- Icon for Items
local function hookItem(tip)
	tip:HookScript("OnTooltipSetItem", function(self)

		local link = self:GetItem()
		local icon = link and GetItemIcon(link)
		AddIcon(self, icon)
	end)
end
hookItem(GameTooltip)
hookItem(ItemRefTooltip)
hookItem(ShoppingTooltip1)
hookItem(ShoppingTooltip2)

-- Icon for Spells
local function hookSpell(tip)
	tip:HookScript("OnTooltipSetSpell", function(self)

		local _, _, id = self:GetSpell()
		if id then
			AddIcon(self, select(3, GetSpellInfo(id)))
		end
	end)
end
hookSpell(GameTooltip)
hookSpell(ItemRefTooltip)

-- Icon for Achievements (only GameTooltip)
hooksecurefunc(GameTooltip, "SetHyperlink", function(self, link)
	if type(link) ~= "string" then return end
	local linkType, id = strmatch(link, "^([^:]+):(%d+)")
	if linkType == "achievement" then
		local _, _, _, _, _, _, _, _, _, icon, _, _, _, _ = GetAchievementInfo(id)
		AddIcon(self, icon)
	end
end)

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" then
		AddIcon()
		f:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)
