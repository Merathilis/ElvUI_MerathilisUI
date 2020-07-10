local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('mUITooltip')

-- Cache global variables
-- Lua functions
local _G = _G
local gsub, unpack = gsub, unpack
local strmatch = strmatch
-- WoW API / Variables
local GetItemIcon = GetItemIcon
local GetMouseFocus = GetMouseFocus
local GetSpellTexture = GetSpellTexture
local UnitExists = UnitExists
local UnitFactionGroup = UnitFactionGroup
local UnitIsPlayer = UnitIsPlayer
local hooksecurefunc = hooksecurefunc

local newString = "0:0:64:64:5:59:5:59"

function module:SetupTooltipIcon(icon)
	local title = icon and _G[self:GetName().."TextLeft1"]
	if title then
		title:SetFormattedText("|T%s:20:20:"..newString..":%d|t %s", icon, 20, title:GetText())
	end

	for i = 2, self:NumLines() do
		local line = _G[self:GetName().."TextLeft"..i]
		if not line then break end
		local text = line:GetText() or ""
		if strmatch(text, "|T.-:[%d+:]+|t") then
			line:SetText(gsub(text, "|T(.-):[%d+:]+|t", "|T%1:14:14:"..newString.."|t"))
		end
	end
end

function module:HookTooltipCleared()
	if self.factionFrame and self.factionFrame:GetAlpha() ~= 0 then
		self.factionFrame:SetAlpha(0)
	end

	self.tipModified = false
end

function module:HookTooltipSetItem()
	if not self.tipModified then
		local _, link = self:GetItem()
		if link then
			module.SetupTooltipIcon(self, GetItemIcon(link))
		end

		self.tipModified = true
	end
end

function module:HookTooltipSetSpell()
	if not self.tipModified then
		local _, id = self:GetSpell()
		if id then
			module.SetupTooltipIcon(self, GetSpellTexture(id))
		end

		self.tipModified = true
	end
end

local function GetUnit(self)
	local _, unit = self and self:GetUnit()
	if not unit then
		local mFocus = GetMouseFocus()
		unit = mFocus and (mFocus.unit or (mFocus.GetAttribute and mFocus:GetAttribute("unit"))) or "mouseover"
	end
	return unit
end

local function InsertFactionFrame(self, faction)
	if not self.factionFrame then
		local f = self:CreateTexture(nil, "OVERLAY")
		f:SetPoint("TOPRIGHT", 0, -5)
		f:SetSize(35, 35)
		f:SetBlendMode("ADD")
		self.factionFrame = f
	end
	self.factionFrame:SetTexture("Interface\\FriendsFrame\\PlusManz-"..faction)
	self.factionFrame:SetAlpha(.5)
end

function module:HookTooltipSetFaction()
	if not self.tipModified then
		if E.db.mui.tooltip.factionIcon then
			local unit = GetUnit(self)
			if UnitExists(unit) then
				if UnitIsPlayer(unit) then
					local faction = UnitFactionGroup(unit)
					if faction and faction ~= "Neutral" then
						InsertFactionFrame(self, faction)
					end
				end
			end
		end
		self.tipModified = true
	end
end

function module:HookTooltipMethod()
	if _G.GameTooltip:IsForbidden() then return; end

	self:HookScript("OnTooltipSetItem", module.HookTooltipSetItem)
	self:HookScript("OnTooltipSetSpell", module.HookTooltipSetSpell)
	self:HookScript("OnTooltipSetUnit", module.HookTooltipSetFaction)
	self:HookScript("OnTooltipCleared", module.HookTooltipCleared)
end

function module:ReskinRewardIcon()
	self.Icon:SetTexCoord(unpack(E.TexCoords))
end

function module:ReskinTooltipIcons()
	if E.db.mui.tooltip.tooltipIcon ~= true then return end

	module.HookTooltipMethod(_G.GameTooltip)
	module.HookTooltipMethod(_G.ItemRefTooltip)

	hooksecurefunc(_G.GameTooltip, "SetUnitAura", function(self)
		module.SetupTooltipIcon(self)
	end)

	hooksecurefunc(_G.GameTooltip, "SetAzeriteEssence", function(self)
		module.SetupTooltipIcon(self)
	end)
	hooksecurefunc(_G.GameTooltip, "SetAzeriteEssenceSlot", function(self)
		module.SetupTooltipIcon(self)
	end)

	-- Tooltip rewards icon
	module.ReskinRewardIcon(_G.GameTooltip.ItemTooltip)
	module.ReskinRewardIcon(_G.EmbeddedItemTooltip.ItemTooltip)
end
