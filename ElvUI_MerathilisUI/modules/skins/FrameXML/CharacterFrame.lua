local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local unpack = unpack
-- WoW API
local CreateFrame = CreateFrame
local GetInventoryItemTexture = GetInventoryItemTexture
local InCombatLockdown = InCombatLockdown

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: GameTooltip

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function styleCharacter()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or E.private.muiSkins.blizzard.character ~= true then return end

	-- Hide ElvUI Backdrop
	if _G["CharacterModelFrame"].backdrop then
		_G["CharacterModelFrame"].backdrop:Hide()
	end

	_G["CharacterFrame"]:Styling()

	if _G["CharacterModelFrame"] and _G["CharacterModelFrame"].BackgroundTopLeft and _G["CharacterModelFrame"].BackgroundTopLeft:IsShown() then
		_G["CharacterModelFrame"].BackgroundTopLeft:Hide()
		_G["CharacterModelFrame"].BackgroundTopRight:Hide()
		_G["CharacterModelFrame"].BackgroundBotLeft:Hide()
		_G["CharacterModelFrame"].BackgroundBotRight:Hide()
		_G["CharacterModelFrameBackgroundOverlay"]:Hide()
		if _G["CharacterModelFrame"].backdrop then
			_G["CharacterModelFrame"].backdrop:Hide()
		end
	end

	-- Undress Button
	local function UnequipItemInSlot(i)
		if InCombatLockdown() then return end
		local action = EquipmentManager_UnequipItemInSlot(i)
		EquipmentManager_RunAction(action)
	end

	local bu = CreateFrame("Button", nil, _G["PaperDollFrame"], "UIPanelButtonTemplate")
	bu:SetSize(34, 37)
	bu:SetFrameStrata("HIGH")
	bu:SetPoint("RIGHT", _G["PaperDollSidebarTab1"], "LEFT", -4, 0)

	bu:SetNormalTexture("Interface\\ICONS\\SPELL_SHADOW_TWISTEDFAITH")
	bu:GetNormalTexture():SetInside()
	bu:GetNormalTexture():SetTexCoord(0, 1, 0, 1)

	bu:SetPushedTexture("")
	bu:SetDisabledTexture("")

	MER:AddTooltip(bu, "ANCHOR_RIGHT", E:RGBToHex(r, g, b)..L["Undress"])
	bu:SetScript('OnClick', function()
		for i = 1, 17 do
			local texture = GetInventoryItemTexture('player', i)
			if texture then
				UnequipItemInSlot(i)
			end
		end
	end)
end

S:AddCallback("mUICharacter", styleCharacter)
