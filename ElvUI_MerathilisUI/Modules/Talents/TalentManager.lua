local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_TalentManager')
local S = E:GetModule('Skins')

local _G = _G
local format = format
local gsub = gsub
local ipairs = ipairs
local pairs = pairs
local tinsert = tinsert
local tonumber = tonumber
local tremove = tremove
local unpack = unpack

local CooldownFrame_Set = CooldownFrame_Set
local CreateFrame = CreateFrame
local EasyMenu = EasyMenu
local GameTooltip = _G.GameTooltip
local GetItemCooldown = GetItemCooldown
local GetItemCount = GetItemCount
local GetItemIcon = GetItemIcon
local GetPvpTalentInfoByID = GetPvpTalentInfoByID
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetTalentInfo = GetTalentInfo
local GetTalentTierInfo = GetTalentTierInfo
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local IsResting = IsResting
local Item = Item
local Spell = Spell
local LearnPvpTalent = LearnPvpTalent
local LearnTalents = LearnTalents
local UnitLevel = UnitLevel

local AuraUtil_FindAuraByName = AuraUtil.FindAuraByName
local C_SpecializationInfo_GetPvpTalentSlotInfo = C_SpecializationInfo.GetPvpTalentSlotInfo

local ACCEPT = _G.ACCEPT
local CANCEL = _G.CANCEL
local MAX_TALENT_TIERS = _G.MAX_TALENT_TIERS

-- [id] = {minLevel, maxLevel}
local itemList = {
	tome = {
		{141446, 10, 50},
		{141640, 10, 50},
		{143780, 10, 50},
		{143785, 10, 50},
		{153647, 50, 59},
		{173049, 51, 60}
	},
	codex = {
		{141333, 10, 50},
		{141641, 10, 50},
		{153646, 10, 59},
		{173048, 51, 60}
	}
}

do
	local auras = {}
	local buffs = {325012}
	for _, data in pairs(itemList.tome) do
		local item = Item:CreateFromItemID(data[1])
		item:ContinueOnItemLoad(
			function()
				tinsert(auras, item:GetItemName())
			end
		)
	end
	for _, data in pairs(itemList.codex) do
		local item = Item:CreateFromItemID(data[1])
		item:ContinueOnItemLoad(
			function()
				tinsert(auras, item:GetItemName())
			end
		)
	end
	for _, data in pairs(buffs) do
		local spell = Spell:CreateFromSpellID(data)
		spell:ContinueOnSpellLoad(
			function()
				tinsert(auras, spell:GetSpellName())
			end
		)
	end
	function module:IsPlayerCanChangeTalent()
		if IsResting() then
			return true
		end
		for _, aura in pairs(auras) do
			if aura and AuraUtil_FindAuraByName(aura, "player", "HELPFUL") then
				return true
			end
		end
		return false
	end
end

function module:ADDON_LOADED(_, addon)
	if addon == "Blizzard_TalentUI" then
		self:UnregisterEvent("ADDON_LOADED")
		self:BuildFrame()
		self:BuildItemButtons()
	end
end

function module:BuildFrame()
	if not IsAddOnLoaded("Blizzard_TalentUI") then
		self:RegisterEvent("ADDON_LOADED")
		return
	end

	local frame = CreateFrame("Frame", "MER_TalentManager", _G.PlayerTalentFrame)

	if not _G.PlayerTalentFrameTalents:IsShown() then
		frame:Hide()
		if not InCombatLockdown() then
			self.itemButtonsAnchor:Hide()
		end
	end

	self:SecureHook("PlayerTalentFrame_ShowTalentTab", function()
		if not self.db.forceHide then
			frame:Show()
		else
			frame:Hide()
		end
		self:RegisterEvent("BAG_UPDATE_DELAYED", "UpdateItemButtons")
		self:RegisterEvent("PLAYER_LEVEL_UP", "UpdateItemButtons")
		self:RegisterEvent("UNIT_AURA", "UpdateStatus")
		self:RegisterEvent("ZONE_CHANGED", "UpdateStatus")
		self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "UpdateStatus")
		if not InCombatLockdown() then
			self.itemButtonsAnchor:Show()
			self:UpdateStatus(nil, "player")
			self:UpdateItemButtons()
		end
	end)

	self:SecureHook("PlayerTalentFrame_HideTalentTab", function()
		frame:Hide()
		self:UnregisterEvent("BAG_UPDATE_DELAYED")
		self:UnregisterEvent("PLAYER_LEVEL_UP")
		self:UnregisterEvent("UNIT_AURA")
		self:UnregisterEvent("ZONE_CHANGED")
		self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
		if not InCombatLockdown() then
			self.itemButtonsAnchor:Hide()
		end
	end)

	self:SecureHook(_G.PlayerTalentFrame, "Hide", function()
		frame:Hide()
		self:UnregisterEvent("BAG_UPDATE_DELAYED")
		self:UnregisterEvent("PLAYER_LEVEL_UP")
		self:UnregisterEvent("UNIT_AURA")
		self:UnregisterEvent("ZONE_CHANGED")
		self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
		if not InCombatLockdown() then
			self.itemButtonsAnchor:Hide()
		end
	end)

	self.frame = frame
end

function module:CreateItemButton(parent, itemID, width, height)
	local button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate, BackdropTemplate")
	button:Size(width, height or width)
	button:SetTemplate("Default")
	button:SetClampedToScreen(true)
	button:SetAttribute("type", "item")
	button:SetAttribute("item", "item:" .. itemID)
	button.itemID = itemID
	button:EnableMouse(true)
	button:RegisterForClicks("AnyUp")

	local tex = button:CreateTexture(nil, "OVERLAY", nil)
	tex:Point("TOPLEFT", button, "TOPLEFT", 1, -1)
	tex:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
	tex:SetTexCoord(unpack(E.TexCoords))
	tex:SetTexture(GetItemIcon(itemID))

	local count = button:CreateFontString(nil, "OVERLAY")
	count:SetTextColor(1, 1, 1, 1)
	count:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
	count:SetJustifyH("RIGHT")
	count:FontTemplate()

	local cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
	E:RegisterCooldown(cooldown)

	button.tex = tex
	button.count = count
	button.cooldown = button.cooldown

	button:StyleButton()

	button:SetScript("OnEnter", function(self)
		if self.SetBackdropBorderColor then
			self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
		end
		GameTooltip:SetOwner(button, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:SetItemByID(itemID)
		GameTooltip:Show()
	end)

	button:SetScript("OnLeave", function(self)
		if self.SetBackdropBorderColor then
			self:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
		GameTooltip:Hide()
	end)

	button:SetScript("OnUpdate", function()
		local start, duration, enable = GetItemCooldown(itemID)
		CooldownFrame_Set(cooldown, start, duration, enable)
	end)

	return button
end

function module:BuildItemButtons()
	if not self.db or self.itemButtonsAnchor then
		return
	end

	local frame = CreateFrame("Frame", nil, _G.PlayerTalentFrame)
	frame:Size(500, 40)
	frame:Point("TOPLEFT", 0, -31)
	self.itemButtonsAnchor = frame

	if self.db.statusIcon then
		local status = frame:CreateTexture(nil, "ARTWORK")
		status:SetTexture(MER.Media.Textures.exchange)
		status:Size(32, 32)
		status:Point("LEFT", 20, 0)
		frame.status = status
	end

	if self.db.itemButtons then
		self.itemButtons = {
			tome = {},
			codex = {}
		}

		for _, data in ipairs(itemList.tome) do
			local button = self:CreateItemButton(frame, data[1], 36)
			if button then
				button.min = data[2]
				button.max = data[3]
				tinsert(self.itemButtons.tome, button)
			end
		end

		for _, data in ipairs(itemList.codex) do
			local button = self:CreateItemButton(frame, data[1], 36)
			if button then
				button.min = data[2]
				button.max = data[3]
				tinsert(self.itemButtons.codex, button)
			end
		end
	end

	self:UpdateItemButtons()
end

function module:UpdateStatus(event, unit)
	if InCombatLockdown() then
		return
	end

	if event == "UNIT_AURA" and not unit == "player" then
		return
	end

	if self.db.statusIcon and self.itemButtonsAnchor.status then
		if self:IsPlayerCanChangeTalent() then
			self.itemButtonsAnchor.status:SetVertexColor(unpack(E.media.rgbvaluecolor))
			self.itemButtonsAnchor.status:SetAlpha(1)
		else
			self.itemButtonsAnchor.status:SetVertexColor(1, 1, 1)
			self.itemButtonsAnchor.status:SetAlpha(0.3)
		end
	end
end

function module:UpdateItemButtons()
	local frame = _G.PlayerTalentFrameTalents
	if not frame or not frame:IsShown() then
		return
	end

	if not self.itemButtons then
		return
	end

	if self.db and self.db.itemButtons then
		-- Update layout
		local lastButton
		for _, button in pairs(self.itemButtons.tome) do
			local level = UnitLevel("player")
			local allow = level and level >= button.min and level <= button.max
			local count = allow and GetItemCount(button.itemID, nil, true)
			if count and count > 0 then
				button.count:SetText(count)
				button:ClearAllPoints()
				if lastButton then
					button:Point("LEFT", lastButton, "RIGHT", 3, 0)
				else
					button:Point("LEFT", 79, 0)
				end
				lastButton = button
				button:Show()
			else
				button:Hide()
			end
		end

		for _, button in pairs(self.itemButtons.codex) do
			local level = UnitLevel("player")
			local allow = level and level >= button.min and level <= button.max
			local count = allow and GetItemCount(button.itemID, nil, true)
			if count and count > 0 then
				button.count:SetText(count)
				button:ClearAllPoints()
				if lastButton then
					button:Point("LEFT", lastButton, "RIGHT", 13, 0)
				else
					button:Point("LEFT", 79, 0)
				end
				lastButton = button
				button:Show()
			else
				button:Hide()
			end
		end
		self.itemButtonsAnchor:Show()
	else
		self.itemButtonsAnchor:Hide()
	end
end

function module:Initialize()
	self.db = E.db.mui.talents.talentManager
	if not self.db.enable then
		return
	end

	self:BuildFrame()
end

MER:RegisterModule(module:GetName())
