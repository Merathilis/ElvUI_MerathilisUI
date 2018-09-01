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
end

S:AddCallback("mUIPaperDoll", styleCPaperDollFrame)