local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

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

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.character) or E.private.muiSkins.blizzard.character ~= true then return end

	-- Hide ElvUI Backdrop
	local CharacterFrame = _G.CharacterFrame

	CharacterFrame.backdrop:Styling()
	MER:CreateBackdropShadow(CharacterFrame)
end

S:AddCallback("mUICharacter", LoadSkin)
