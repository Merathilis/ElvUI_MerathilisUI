local E, L, V, P, G = unpack(ElvUI);

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, select = pairs, select
local strmatch = string.match
-- WoW API / Variables
local GetItemIcon = GetItemIcon
local GetSpellInfo = GetSpellInfo

local function setTooltipIcon(self, icon)
	if E.db.mui.misc.Tooltip ~= true then return; end

	local title = icon and _G[self:GetName().."TextLeft1"]
	if title then
		title:SetFormattedText("|T%s:20:20:0:0:64:64:5:59:5:59:%d|t %s", icon, 20, title:GetText())
	end
end

local function newTooltipHooker(method, func)
	return function(tooltip)
		local modified = false

		tooltip:HookScript("OnTooltipCleared", function(self, ...)
			modified = false
		end)

		tooltip:HookScript(method, function(self, ...)
			if not modified then
				modified = true
				func(self, ...)
			end
		end)
	end
end

local hookItem = newTooltipHooker("OnTooltipSetItem", function(self, ...)
	local _, link = self:GetItem()
	if link then
		setTooltipIcon(self, GetItemIcon(link))
	end
end)

local hookSpell = newTooltipHooker("OnTooltipSetSpell", function(self, ...)
	local _, _, id = self:GetSpell()
	if id then
		setTooltipIcon(self, select(3, GetSpellInfo(id)))
	end
end)

for _, tooltip in pairs{GameTooltip, ItemRefTooltip, ItemRefShoppingTooltip1, ItemRefShoppingTooltip2, ShoppingTooltip1, ShoppingTooltip2} do
	hookItem(tooltip)
	hookSpell(tooltip)
end

-- WorldQuest Tooltip
hooksecurefunc("EmbeddedItemTooltip_SetItemByQuestReward", function(self)
	if self.Icon then
		self.Icon:SetTexCoord(unpack(E.TexCoords))
		self.IconBorder:Hide()
	end
end)
BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT = "|T%1$s:16:16:0:0:64:64:5:59:5:59|t |cffffffff%2$d|r %3$s"

-- PVPReward Tooltip
hooksecurefunc("EmbeddedItemTooltip_SetItemByID", function(self)
	if self.Icon then
		self.Icon:SetTexCoord(unpack(E.TexCoords))
		self.IconBorder:Hide()
	end
end)
