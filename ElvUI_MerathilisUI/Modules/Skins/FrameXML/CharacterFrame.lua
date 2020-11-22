local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, unpack = pairs, unpack
local format = string.format
-- WoW API
local CreateFrame = CreateFrame
local GetInventoryItemTexture = GetInventoryItemTexture
local GetInventoryItemLink = GetInventoryItemLink
local InCombatLockdown = InCombatLockdown
local IsCosmeticItem = IsCosmeticItem
local EquipmentManager_UnequipItemInSlot = EquipmentManager_UnequipItemInSlot
local EquipmentManager_RunAction = EquipmentManager_RunAction
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

local function UnequipItemInSlot(i)
	if InCombatLockdown() then return end
	local action = EquipmentManager_UnequipItemInSlot(i)
	EquipmentManager_RunAction(action)
end

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or E.private.muiSkins.blizzard.character ~= true then return end

	-- Hide ElvUI Backdrop
	local CharacterFrame = _G.CharacterFrame
	local CharacterModelFrame = _G.CharacterModelFrame

	CharacterFrame:Styling()

	if CharacterModelFrame and CharacterModelFrame.BackgroundTopLeft and CharacterModelFrame.BackgroundTopLeft:IsShown() then
		CharacterModelFrame.BackgroundTopLeft:Hide()
		CharacterModelFrame.BackgroundTopRight:Hide()
		CharacterModelFrame.BackgroundBotLeft:Hide()
		CharacterModelFrame.BackgroundBotRight:Hide()
		_G.CharacterModelFrameBackgroundOverlay:Hide()

		if _G.CharacterModelFrame.backdrop then
			_G.CharacterModelFrame.backdrop:Hide()
		end
	end

	-- Undress Button
	if E.db.mui.armory.undressButton then
		local bu = CreateFrame("Button", nil, _G.PaperDollFrame, "UIPanelButtonTemplate")
		bu:SetText(format("|cff70C0F5%s", L["Undress"]))
		bu:SetSize(60, 20)
		bu:SetFrameStrata("HIGH")
		bu:SetPoint("TOPRIGHT", CharacterFrame, "TOPLEFT", 70, -35)

		bu:SetScript("OnClick", function()
			for i = 1, 17 do
				local texture = GetInventoryItemTexture('player', i)
				if texture then
					UnequipItemInSlot(i)
				end
			end
		end)
		S:HandleButton(bu)
	end

	local function UpdateCosmetic(self)
		local itemLink = GetInventoryItemLink("player", self:GetID())
		self.IconOverlay:SetShown(itemLink and IsCosmeticItem(itemLink))
	end

	local slots = {
		"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
		"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
		"SecondaryHand", "Tabard",
	}

	for i = 1, #slots do
		local slot = _G["Character"..slots[i].."Slot"]

		slot.IconOverlay:SetAtlas("CosmeticIconFrame")
		slot.IconOverlay:SetInside()
	end

	hooksecurefunc("PaperDollItemSlotButton_Update", function(button)
		UpdateCosmetic(button)
	end)
end

S:AddCallback("mUICharacter", LoadSkin)
