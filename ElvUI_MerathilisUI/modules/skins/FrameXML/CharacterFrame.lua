local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local unpack = unpack
-- WoW API
local CreateFrame = CreateFrame
local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemLink = GetContainerItemLink
local PickupInventoryItem = PickupInventoryItem
local PickupContainerItem = PickupContainerItem
-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleCharacter()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or E.private.muiSkins.blizzard.character ~= true then return end

	local CharacterStatsPane = _G["CharacterStatsPane"]

	-- Hide ElvUI Backdrop
	if _G["CharacterModelFrame"].backdrop then
		_G["CharacterModelFrame"].backdrop:Hide()
	end

	_G["CharacterFrame"]:Styling()

	_G["CharacterStatsPane"].ItemLevelCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))
	_G["CharacterStatsPane"].ItemLevelFrame.Value:SetShadowOffset(1, -1)
	_G["CharacterStatsPane"].ItemLevelFrame.Background:Hide()
	_G["CharacterStatsPane"].AttributesCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))
	_G["CharacterStatsPane"].EnhancementsCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))

	local function StatsPane(type)
		CharacterStatsPane[type]:StripTextures()
		CharacterStatsPane[type].backdrop:Hide()
	end

	local function CharacterStatFrameCategoryTemplate(Button)
		local bg = Button.Background
		bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
		bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
		bg:ClearAllPoints()
		bg:SetPoint("CENTER", 0, -5)
		bg:SetSize(210, 30)

		bg:SetVertexColor(MER.ClassColor.r * 0.7, MER.ClassColor.g * 0.7, MER.ClassColor.b * 0.7)
	end

	StatsPane("EnhancementsCategory")
	StatsPane("ItemLevelCategory")
	StatsPane("AttributesCategory")
	CharacterStatFrameCategoryTemplate(CharacterStatsPane.ItemLevelCategory)
	CharacterStatFrameCategoryTemplate(CharacterStatsPane.AttributesCategory)
	CharacterStatFrameCategoryTemplate(CharacterStatsPane.EnhancementsCategory)

	if IsAddOnLoaded("ElvUI_SLE") then
		PaperDollFrame:HookScript("OnShow", function()
			if _G["CharacterStatsPane"].DefenceCategory then
				_G["CharacterStatsPane"].DefenceCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))
				StatsPane("DefenceCategory")
				CharacterStatFrameCategoryTemplate(CharacterStatsPane.DefenceCategory)
			end
			if _G["CharacterStatsPane"].OffenseCategory then
				_G["CharacterStatsPane"].OffenseCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))
				StatsPane("OffenseCategory")
				CharacterStatFrameCategoryTemplate(CharacterStatsPane.OffenseCategory)
			end
		end)
	end

	-- Undress Button
	local E, Z, N, n
	local undress = CreateFrame("Button", MER.Title.."UndressButton", _G["PaperDollFrame"], "UIPanelButtonTemplate")
	undress:SetFrameStrata("HIGH")
	undress:SetSize(80, 20)
	undress:SetPoint("TOPLEFT", _G["CharacterWristSlot"], "BOTTOMLEFT", 0, -5)

	undress.text = MER:CreateText(undress, "OVERLAY", 12, nil)
	undress.text:SetPoint("CENTER")
	undress.text:SetText(L["Undress"])

	undress:SetScript("OnClick", function()
		E = { 16, 17, 1, 3, 5, 6, 7, 8, 9, 10 }
		Z = {}
		n = Z[1] and #Z+1 or 1
		for i = 0, 4 do
			for j = 1, GetContainerNumSlots(i) do
				if not GetContainerItemLink(i,j) and E[n] then
					Z[n]= {i,j}
					PickupInventoryItem(E[n])
					PickupContainerItem(i, j)
					n = n + 1
				end
			end
		end
	end)
	S:HandleButton(undress)
end

S:AddCallback("mUICharacter", styleCharacter)