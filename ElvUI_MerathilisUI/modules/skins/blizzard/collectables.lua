local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local PlayerHasToy = PlayerHasToy

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc

local function styleCollections()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.collections ~= true or E.private.muiSkins.blizzard.collections ~= true then return end

	_G["CollectionsJournal"]:Styling(true, true)

	_G["CollectionsJournalBg"]:Hide()

	MERS:CreateBD(_G["MountJournal"].MountCount, .25)
	MERS:CreateBD(_G["PetJournal"].PetCount, .25)

	-- Mounts
	local MountDisplay = _G["MountJournal"].MountDisplay
	MountDisplay:StripTextures()

	-- Sets
	local SetsCollectionFrame = _G["WardrobeCollectionFrame"].SetsCollectionFrame
	SetsCollectionFrame:StripTextures()
	SetsCollectionFrame.LeftInset:Hide()
	SetsCollectionFrame.RightInset:Hide()

	local DetailsFrame = SetsCollectionFrame.DetailsFrame
	DetailsFrame.ModelFadeTexture:Hide()
	DetailsFrame.IconRowBackground:Hide()

	local ItemsCollectionFrame = _G["WardrobeCollectionFrame"].ItemsCollectionFrame
	ItemsCollectionFrame:StripTextures()

	local SetsTransmogFrame = _G["WardrobeCollectionFrame"].SetsTransmogFrame
	SetsTransmogFrame:StripTextures()

	_G["WardrobeFrame"]:Styling(true, true)

	_G["WardrobeCollectionFrame"].ItemsTab.backdrop:Hide()
	_G["WardrobeCollectionFrame"].SetsTab.backdrop:Hide()

	-- Pet
	local card = _G["PetJournalPetCard"]
	_G["PetJournalPetCardBG"]:Hide()
	card:SetTemplate("Transparent")

	-- Toys
	local shouldChangeTextColor = true
	local function changeTextColor(toyString)
		if shouldChangeTextColor then
			shouldChangeTextColor = false

			local self = toyString:GetParent()

			if PlayerHasToy(self.itemID) then
				local _, _, quality = GetItemInfo(self.itemID)
				if quality then
					toyString:SetTextColor(GetItemQualityColor(quality))
				else
					toyString:SetTextColor(1, 1, 1)
				end
			else
				toyString:SetTextColor(.5, .5, .5)
			end

			shouldChangeTextColor = true
		end
	end

	local iconsFrame = _G["ToyBox"].iconsFrame
	for i = 1, 18 do
		local button = iconsFrame["spellButton"..i]
		hooksecurefunc(button.name, "SetTextColor", changeTextColor)
	end
end

S:AddCallbackForAddon("Blizzard_Collections", "mUICollections", styleCollections)