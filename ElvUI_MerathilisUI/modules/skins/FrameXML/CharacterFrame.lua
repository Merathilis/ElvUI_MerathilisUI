local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, unpack = pairs, unpack
-- WoW API
local CreateFrame = CreateFrame
local GetInventoryItemTexture = GetInventoryItemTexture
local InCombatLockdown = InCombatLockdown
local EquipmentManager_UnequipItemInSlot = EquipmentManager_UnequipItemInSlot
local EquipmentManager_RunAction = EquipmentManager_RunAction

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: GameTooltip

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function styleCharacter()
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
	local function UnequipItemInSlot(i)
		if InCombatLockdown() then return end
		local action = EquipmentManager_UnequipItemInSlot(i)
		EquipmentManager_RunAction(action)
	end

	if E.db.mui.armory.undressButton then
		local bu = CreateFrame("Button", nil, _G.PaperDollFrame, "UIPanelButtonTemplate")
		bu:SetSize(55, 20)
		bu:SetFrameStrata("HIGH")
		bu:SetPoint("TOPRIGHT", CharacterFrame, "TOPLEFT", 65, -15)

		bu.text = MER:CreateText(bu, "OVERLAY", 12, "OUTLNE")
		bu.text:SetPoint("CENTER")
		bu.text:SetText(L["Undress"])

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
end

S:AddCallback("mUICharacter", styleCharacter)
