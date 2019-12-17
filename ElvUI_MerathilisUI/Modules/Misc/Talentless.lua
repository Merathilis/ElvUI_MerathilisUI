local MER, E, L, V, P, G = unpack(select(2, ...))
local LCG = LibStub('LibCustomGlow-1.0')
local S = E:GetModule("Skins")

------------------------------
-- Credits: p3lim - Talentless
------------------------------

-- Cache global variables
-- Lua functions
local _G = _G
local next, unpack = next, unpack
local tinsert, tremove = table.insert, table.remove
-- WoW API / Variables
local ActionButton_ShowOverlayGlow = ActionButton_ShowOverlayGlow
local ActionButton_HideOverlayGlow = ActionButton_HideOverlayGlow
local CreateFrame = CreateFrame
local GameTooltip_Hide = GameTooltip_Hide
local GetItemCount = GetItemCount
local GetItemInfo = GetItemInfo
local GetSpecialization = GetSpecialization
local InCombatLockdown = InCombatLockdown
local UnitAura = UnitAura
local UnitLevel = UnitLevel
-- GLOBALS:

local Respec = CreateFrame('Frame', (...), UIParent)
Respec:RegisterEvent('ADDON_LOADED')
Respec:SetScript('OnEvent', function(self, event, ...)
	self[event](self, ...)
end)

function Respec:PLAYER_LEVEL_UP(level)
	if(level == 101) then
		tremove(self.Items[1].items, 1)
	elseif(level == 110) then
		tremove(self.Items[2].items, 1)
		self:UnregisterEvent('PLAYER_LEVEL_UP')
	end

	if(self:IsShown()) then
		self:UpdateItems()
	end
end

function Respec:UNIT_AURA()
	if(self:IsShown()) then
		for _, Button in next, self.Items do
			local itemName = Button.itemName
			if(itemName) then
				local exists, name, duration, expiration, _
				for index = 1, 40 do
					name, _, _, _, duration, expiration = UnitAura('player', index)
					exists = name == itemName
					if(not name or exists) then
						break
					end
				end

				if(exists) then
					if(expiration > 0) then
						Button.Cooldown:SetCooldown(expiration - duration, duration)
					end

					local r, g, b = unpack(E["media"].rgbvaluecolor)
					local color = {r, g, b, 1}
					LCG.PixelGlow_Start(Button, color, nil, 0.3, nil, 1)
				else
					LCG.PixelGlow_Stop(Button)
					Button.Cooldown:SetCooldown(0, 0)
				end
			end
		end
	end
end

function Respec:BAG_UPDATE_DELAYED()
	self:UpdateItems()
end

function Respec.OnShow()
	Respec:RegisterUnitEvent('UNIT_AURA', 'player')
	Respec:RegisterEvent('BAG_UPDATE_DELAYED')

	Respec:UpdateItems()
end

function Respec.OnHide()
	Respec:UnregisterEvent('UNIT_AURA')
	Respec:UnregisterEvent('BAG_UPDATE_DELAYED')
end


local items = {
	{
		141641, -- Codex of the Clear Mind (Pre-Legion)
		141333, -- Codex of the Tranquil Mind (Legion)
		153646, -- Codex of the Quiet Mind (BfA)
	},
	{
		141640, -- Tome of the Clear Mind (Pre-Legion)
		143785, -- Tome of the Tranquil Mind (BoP version)
		141446, -- Tome of the Tranquil Mind (Legion)
		153647, -- Tome of the Quiet Mind (BfA)
	},
}

local function OnEnter(self)
	if(self.itemID) then
		_G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		_G.GameTooltip:SetItemByID(self.itemID)
		_G.GameTooltip:Show()
	end
end

local function OnEvent(self, event)
	if(event == 'PLAYER_REGEN_ENABLED') then
		self:UnregisterEvent(event)
		self:SetAttribute('item', 'item:' .. self.itemID)
	else
		local itemName = GetItemInfo(self.itemID)
		if(itemName) then
			self.itemName = itemName
			self:UnregisterEvent(event)

			Respec:UNIT_AURA()
		end
	end
end

function Respec:CreateItemButtons()
	self.Items = {}

	local playerLevel = UnitLevel('player')
	if(playerLevel > 100) then
		tremove(items[1], 1)

		if(playerLevel > 109) then
			tremove(items[2], 1)
		end
	end

	for index, items in next, items do
		local Button = CreateFrame('Button', '$parentItemButton' .. index, self, 'SecureActionButtonTemplate, ActionBarButtonSpellActivationAlert')
		Button:SetPoint('TOPRIGHT', _G.PlayerTalentFrame, -140 - (40 * (index - 1)), -25)
		Button:SetSize(34, 34)
		Button:SetAttribute('type', 'item')
		Button:SetScript('OnEnter', OnEnter)
		Button:SetScript('OnEvent', OnEvent)
		Button:SetScript('OnLeave', GameTooltip_Hide)
		Button.items = items

		local Icon = Button:CreateTexture('$parentIcon', 'BACKGROUND')
		Icon:SetAllPoints()
		Icon:SetTexture(index == 1 and 1495827 or 134915)

		local Normal = Button:CreateTexture('$parentNormalTexture')
		Normal:SetPoint('CENTER')
		Normal:SetSize(60, 60)
		Normal:SetTexture("")

		Button:SetNormalTexture(Normal)
		Button:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
		Button:GetNormalTexture():SetInside()
		Button:SetPushedTexture("")
		Button:SetHighlightTexture("")

		S:HandleButton(Button)

		local Count = Button:CreateFontString('$parentCount', 'OVERLAY')
		Count:SetPoint('BOTTOMRIGHT', 1, 1)
		Count:FontTemplate()
		Button.Count = Count

		local Cooldown = CreateFrame('Cooldown', '$parentCooldown', Button, 'CooldownFrameTemplate')
		Cooldown:SetAllPoints()
		Button.Cooldown = Cooldown
		E:RegisterCooldown(Cooldown)

		tinsert(self.Items, Button)
	end
end

function Respec:GetAvailableItemInfo(index)
	for _, itemID in next, self.Items[index].items do
		local itemCount = GetItemCount(itemID)
		if(itemCount > 0) then
			return itemID, itemCount
		end
	end

	return self.Items[index].items[1], 0
end

function Respec:UpdateItems()
	for index, Button in next, self.Items do
		local itemID, itemCount = self:GetAvailableItemInfo(index)
		if(Button.itemID ~= itemID) then
			Button.itemID = itemID

			local itemName = GetItemInfo(itemID)
			if(not itemName) then
				Button.itemName = nil
				Button:RegisterEvent('GET_ITEM_INFO_RECEIVED')
			else
				Button.itemName = itemName
			end

			if(InCombatLockdown()) then
				Button:RegisterEvent('PLAYER_REGEN_ENABLED')
			else
				Button:SetAttribute('item', 'item:' .. itemID)
			end
		end

		Button.Count:SetText(itemCount)
	end

	self:UNIT_AURA()
end

function Respec:ADDON_LOADED(addon)
	if(addon == 'Blizzard_TalentUI') then
		if E.db.mui.misc.respec ~= true then return end

		self:SetParent(PlayerTalentFrameTalents)

		_G.PlayerTalentFrame:HookScript('OnShow', self.OnShow)
		_G.PlayerTalentFrame:HookScript('OnHide', self.OnHide)

		self:CreateItemButtons()

		self:UnregisterEvent('ADDON_LOADED')
		self:OnShow()
	end
end
