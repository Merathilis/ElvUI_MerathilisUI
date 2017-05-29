local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions

--WoW API / Variables

local function styleCollections()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.collections ~= true or E.private.muiSkins.blizzard.collections ~= true then return end

	if not CollectionsJournal.stripes then
		MERS:CreateStripes(CollectionsJournal)
	end

	CollectionsJournalBg:Hide()

	MERS:CreateBD(MountJournal.MountCount, .25)
	MERS:CreateBD(PetJournal.PetCount, .25)
	MERS:CreateBD(MountJournal.MountDisplay.ModelScene, .25)

	-- Sets
	local SetsCollectionFrame = WardrobeCollectionFrame.SetsCollectionFrame
	SetsCollectionFrame.LeftInset:Hide()
	SetsCollectionFrame.RightInset:Hide()

	local DetailsFrame = SetsCollectionFrame.DetailsFrame
	DetailsFrame.ModelFadeTexture:Hide()
	DetailsFrame.IconRowBackground:Hide()
end

S:AddCallbackForAddon("Blizzard_Collections", "mUICollections", styleCollections)