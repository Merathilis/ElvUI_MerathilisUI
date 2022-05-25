local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E.Skins

local _G = _G
local format = string.format

local CreateFrame = CreateFrame
local GetInventoryItemTexture = GetInventoryItemTexture

local InCombatLockdown = InCombatLockdown
local EquipmentManager_UnequipItemInSlot = EquipmentManager_UnequipItemInSlot
local EquipmentManager_RunAction = EquipmentManager_RunAction

local function UnequipItemInSlot(i)
	if InCombatLockdown() then return end
	local action = EquipmentManager_UnequipItemInSlot(i)
	EquipmentManager_RunAction(action)
end

function module:CharacterFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or not E.private.mui.skins.blizzard.character then return end

	-- Hide ElvUI Backdrop
	local CharacterFrame = _G.CharacterFrame
	local CharacterModelFrame = _G.CharacterModelFrame

	CharacterFrame:Styling()
	MER:CreateShadow(CharacterFrame)

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
end

module:AddCallback("CharacterFrame")
