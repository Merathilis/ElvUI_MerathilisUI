local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local format = string.format

local GetInventoryItemTexture = GetInventoryItemTexture

local InCombatLockdown = InCombatLockdown
local EquipmentManager_UnequipItemInSlot = EquipmentManager_UnequipItemInSlot
local EquipmentManager_RunAction = EquipmentManager_RunAction

local function UnequipItemInSlot(i)
	if InCombatLockdown() then return end
	local action = EquipmentManager_UnequipItemInSlot(i)
	EquipmentManager_RunAction(action)
end

local function LoadSkin()
	if not module:CheckDB("character", "character") then
		return
	end

	-- Hide ElvUI Backdrop
	local CharacterFrame = _G.CharacterFrame
	local CharacterModelFrame = _G.CharacterModelFrame

	CharacterFrame:Styling()
	MER:CreateShadow(CharacterFrame)
	MER:CreateShadow(_G.GearManagerDialogPopup)
	MER:CreateShadow(_G.EquipmentFlyoutFrameButtons)

	for i = 1, 4 do
		module:ReskinTab(_G["CharacterFrameTab" .. i])
	end

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
		local bu = F.Widgets.New("Button", _G.PaperDollFrame, format("|cff70C0F5%s", L["Undress"]), 60, 20,
		function()
			for i = 1, 17 do
				local texture = GetInventoryItemTexture('player', i)
				if texture then
					UnequipItemInSlot(i)
				end
			end
		end)

		bu:SetPoint("TOPRIGHT", CharacterFrame, "TOPLEFT", 70, -35)
		bu:SetFrameStrata("HIGH")
	end
end

S:AddCallback("CharacterFrame", LoadSkin)
