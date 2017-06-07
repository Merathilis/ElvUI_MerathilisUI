local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions

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
end

S:AddCallbackForAddon("Blizzard_Collections", "mUICollections", styleCollections)