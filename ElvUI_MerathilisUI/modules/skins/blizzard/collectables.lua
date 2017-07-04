local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G

--WoW API / Variables

local function styleCollections()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.collections ~= true or E.private.muiSkins.blizzard.collections ~= true then return end

	MERS:CreateGradient(CollectionsJournal)
	if not CollectionsJournal.stripes then
		MERS:CreateStripes(CollectionsJournal)
	end

	CollectionsJournalBg:Hide()

	MERS:CreateBD(MountJournal.MountCount, .25)
	MERS:CreateBD(PetJournal.PetCount, .25)

	-- Mounts
	local MountDisplay = MountJournal.MountDisplay
	MountDisplay:StripTextures()

	-- Sets
	local SetsCollectionFrame = WardrobeCollectionFrame.SetsCollectionFrame
	SetsCollectionFrame:StripTextures()
	SetsCollectionFrame.LeftInset:Hide()
	SetsCollectionFrame.RightInset:Hide()

	local DetailsFrame = SetsCollectionFrame.DetailsFrame
	DetailsFrame.ModelFadeTexture:Hide()
	DetailsFrame.IconRowBackground:Hide()

	local ItemsCollectionFrame = WardrobeCollectionFrame.ItemsCollectionFrame
	ItemsCollectionFrame:StripTextures()

	local SetsTransmogFrame = WardrobeCollectionFrame.SetsTransmogFrame
	SetsTransmogFrame:StripTextures()

	MERS:CreateGradient(WardrobeFrame)
	if not WardrobeFrame.stripes then
		MERS:CreateStripes(WardrobeFrame)
	end

	WardrobeCollectionFrame.ItemsTab.backdrop:Hide()
	WardrobeCollectionFrame.SetsTab.backdrop:Hide()

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

	local iconsFrame = ToyBox.iconsFrame
	for i = 1, 18 do
		local button = iconsFrame["spellButton"..i]
		hooksecurefunc(button.name, "SetTextColor", changeTextColor)
	end
end

S:AddCallbackForAddon("Blizzard_Collections", "mUICollections", styleCollections)