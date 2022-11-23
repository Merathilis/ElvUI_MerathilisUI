local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Tooltip')

local _G = _G
local gsub, unpack = gsub, unpack

local GetItemIcon = GetItemIcon
local GetSpellTexture = GetSpellTexture
local hooksecurefunc = hooksecurefunc

local TooltipDataProcessor_AddTooltipPostCall = TooltipDataProcessor.AddTooltipPostCall

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
		if text and text ~= "" then
			local newText, count = gsub(text, "|T([^:]-):[%d+:]+|t", "|T%1:14:14:"..newString.."|t")
			if count > 0 then
				line:SetText(newText)
			end
		end
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

function module:InsertFactionFrame(faction)
	if not self.factionFrame then
		local f = self:CreateTexture(nil, "OVERLAY")
		f:SetPoint("TOPRIGHT", 0, -5)
		f:SetBlendMode("ADD")
		f:SetScale(.5)
		f:SetAlpha(.5)
		self.factionFrame = f
	end
	self.factionFrame:SetTexture("Interface\\FriendsFrame\\PlusManz-" .. faction)
	self.factionFrame:Show()
end

function module:OnTooltipCleared()
	if self:IsForbidden() then return end

	if self.factionFrame and self.factionFrame:IsShown() then
		self.factionFrame:Hide()
	end
end

function module:HookTooltipCleared()
	self.tipModified = false
end

function module:HookTooltipMethod()
	self:HookScript("OnTooltipCleared", module.HookTooltipCleared)
end

function module:ReskinRewardIcon()
	self.Icon:SetTexCoord(unpack(E.TexCoords))
end

function module:OnTooltipSetUnit()
	if self:IsForbidden() then return end

	local unit = GetUnit(self)
	if not unit or not UnitExists(unit) then return end

	local IsPlayer = UnitIsPlayer(unit)
	if IsPlayer then
		if E.db.mui.tooltip.factionIcon then
			local faction = UnitFactionGroup(unit)
			if faction and faction ~= "Neutral" then
				module.InsertFactionFrame(self, faction)
			end
		end
	end
end

function module:ReskinTooltipIcons()
	if E.db.mui.tooltip.tooltipIcon ~= true then return end

	GameTooltip:HookScript("OnTooltipCleared", module.OnTooltipCleared)

	if E.Retail then
		TooltipDataProcessor_AddTooltipPostCall(Enum.TooltipDataType.Unit, module.OnTooltipSetUnit)

		TooltipDataProcessor_AddTooltipPostCall(Enum.TooltipDataType.Item, function(self)
			if self == _G.GameTooltip or self == _G.ItemRefTooltip then
				local _, link = self:GetItem()
				if link then
					module.SetupTooltipIcon(self, GetItemIcon(link))
				end
			end
		end)
		TooltipDataProcessor_AddTooltipPostCall(Enum.TooltipDataType.Spell, function(self)
			if self == _G.GameTooltip or self == _G.ItemRefTooltip then
				local _, id = self:GetSpell()
				if id then
					module.SetupTooltipIcon(self, GetSpellTexture(id))
				end
			end
		end)

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
	else

	end

end
