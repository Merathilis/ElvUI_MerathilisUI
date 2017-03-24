local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI")

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, select = pairs, select
local strmatch = string.match
-- WoW API / Variables
local GetItemIcon = GetItemIcon
local GetSpellInfo = GetSpellInfo

local function setTooltipIcon(self, icon)
	if E.db.mui.tooltip.tooltipIcon ~= true then return; end

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

-- Add a faction badge
local function InsertFactionFrame(self, faction)
	if not self.factionFrame then
		local f = self:CreateTexture(nil, "OVERLAY")
		f:SetPoint("TOPRIGHT", 0, -5)
		f:SetBlendMode("ADD")
		self.factionFrame = f
	end
	self.factionFrame:SetTexture("Interface\\FriendsFrame\\PlusManz-"..faction)
	self.factionFrame:SetAlpha(.5)
	self.factionFrame:SetSize(35, 35)
end

local roleTex = {
	["HEALER"] = {.066, .222, .133, .445},
	["TANK"] = {.375, .532, .133, .445},
	["DAMAGER"] = {.66, .813, .133, .445},
}

local function InsertRoleFrame(self, role)
	if not self.roleFrame then
		local f = self:CreateTexture(nil, "OVERLAY")
		f:SetPoint("TOPRIGHT", self, "TOPLEFT", -1, -3)
		f:SetSize(20, 20)
		f:SetTexture("Interface\\LFGFrame\\UI-LFG-ICONS-ROLEBACKGROUNDS")
		MER:CreateSD(f, 3, 3)
		self.roleFrame = f
	end
	self.roleFrame:SetTexCoord(unpack(roleTex[role]))
	self.roleFrame:SetAlpha(1)
	self.roleFrame.Shadow:SetAlpha(1)
end

GameTooltip:HookScript("OnTooltipCleared", function(self)
	if self.factionFrame and self.factionFrame:GetAlpha() ~= 0 then
		self.factionFrame:SetAlpha(0)
	end
	if self.roleFrame and self.roleFrame:GetAlpha() ~= 0 then
		self.roleFrame:SetAlpha(0)
		self.roleFrame.Shadow:SetAlpha(0)
	end
end)


local function getUnit(self)
	local _, unit = self and self:GetUnit()
	if(not unit) then
		local mFocus = GetMouseFocus()
		unit = mFocus and (mFocus.unit or (mFocus.GetAttribute and mFocus:GetAttribute("unit"))) or "mouseover"
	end
	return unit
end

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	local unit = getUnit(self)

	if UnitExists(unit) then
		if UnitIsPlayer(unit) then
			if E.db.mui.tooltip.factionIcon then
				local faction = UnitFactionGroup(unit)
				if faction and faction ~= "Neutral" then
					InsertFactionFrame(self, faction)
				end
			end
        
			if E.db.mui.tooltip.roleIcon then
				local role = UnitGroupRolesAssigned(unit)
				if role ~= "NONE" then
					InsertRoleFrame(self, role)
				end
			end
		end
	end
end)


