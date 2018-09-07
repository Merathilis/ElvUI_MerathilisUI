local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local select = select
--WoW API / Variables

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function styleCPaperDollFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or E.private.muiSkins.blizzard.character ~= true then return end

	local CharacterStatsPane = _G["CharacterStatsPane"]

	CharacterModelFrame:DisableDrawLayer("BACKGROUND")
	CharacterModelFrame:DisableDrawLayer("BORDER")
	CharacterModelFrame:DisableDrawLayer("OVERLAY")

	local slots = {
		"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
		"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
		"SecondaryHand", "Tabard",
	}

	for i = 1, #slots do
		local slot = _G["Character"..slots[i].."Slot"]
		local border = slot.IconBorder

		_G["Character"..slots[i].."SlotFrame"]:Hide()

		slot:SetNormalTexture("")
		slot:SetPushedTexture("")
		slot:GetHighlightTexture():SetColorTexture(r, g, b, .25)
		slot.SetHighlightTexture = MER.dummy
		slot.icon:SetTexCoord(unpack(E.TexCoords))

		border:SetPoint("TOPLEFT", -1, 1)
		border:SetPoint("BOTTOMRIGHT", 1, -1)
		border:SetDrawLayer("BACKGROUND")
		MERS:CreateBDFrame(slot, .25)
	end

	_G["CharacterStatsPane"].ItemLevelCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))
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

		bg:SetVertexColor(r * 0.7, g * 0.7, b * 0.7)
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
end

S:AddCallback("mUIPaperDoll", styleCPaperDollFrame)