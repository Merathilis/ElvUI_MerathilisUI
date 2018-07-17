local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local select = select
--WoW API / Variables

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS:

local function styleCPaperDollFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or E.private.muiSkins.blizzard.character ~= true then return end

	--[[ FrameXML\AzeritePaperDollItemOverlay.lua ]]

	--[[ FrameXML\AzeritePaperDollItemOverlay.xml ]]
	function MERS.PaperDollAzeriteItemOverlayTemplate(Frame)
		Frame.RankFrame.Label:SetPoint("CENTER", Frame.RankFrame.Texture, 0, 0)
	end

	--[[ FrameXML\PaperDollFrame.xml ]]
	function MERS.PaperDollItemSlotButtonTemplate(Button)
		MERS.PaperDollAzeriteItemOverlayTemplate(Button)
		_G[Button:GetName().."Frame"]:Hide()
	end

	function MERS.PaperDollItemSlotButtonLeftTemplate(Button)
		MERS.PaperDollItemSlotButtonTemplate(Button)
	end

	function MERS.PaperDollItemSlotButtonRightTemplate(Button)
		MERS.PaperDollItemSlotButtonTemplate(Button)
	end

	function MERS.PaperDollItemSlotButtonBottomTemplate(Button)
		MERS.PaperDollItemSlotButtonTemplate(Button)
	end

	local EquipmentSlots = {
		"CharacterHeadSlot", "CharacterNeckSlot", "CharacterShoulderSlot", "CharacterBackSlot", "CharacterChestSlot", "CharacterShirtSlot", "CharacterTabardSlot", "CharacterWristSlot",
		"CharacterHandsSlot", "CharacterWaistSlot", "CharacterLegsSlot", "CharacterFeetSlot", "CharacterFinger0Slot", "CharacterFinger1Slot", "CharacterTrinket0Slot", "CharacterTrinket1Slot"
	}

	local WeaponSlots = {
		"CharacterMainHandSlot", "CharacterSecondaryHandSlot"
	}

	local prevSlot
	for i = 1, #EquipmentSlots do
		local button = _G[EquipmentSlots[i]]

		button.IsLeftSide = i <= 8

		if i % 8 == 1 then
			if button.IsLeftSide then
				button:SetPoint("TOPLEFT", CharacterFrameInset, 4, -11)
			else
				button:SetPoint("TOPRIGHT", CharacterFrameInset, -4, -11)
			end
		else
			button:SetPoint("TOPLEFT", prevSlot, "BOTTOMLEFT", 0, -6)
		end

		if button.IsLeftSide then
			MERS.PaperDollItemSlotButtonLeftTemplate(button)
		elseif button.IsLeftSide == false then
			MERS.PaperDollItemSlotButtonRightTemplate(button)
		end

		prevSlot = button
	end

	for i = 1, #WeaponSlots do
		local button = _G[WeaponSlots[i]]

		if i == 1 then
		-- main hand
			button:SetPoint("BOTTOMLEFT", 130, 8)
		end

		MERS.PaperDollItemSlotButtonBottomTemplate(button)
		select(13, button:GetRegions()):Hide()
	end
end


S:AddCallback("mUIPaperDoll", styleCPaperDollFrame)