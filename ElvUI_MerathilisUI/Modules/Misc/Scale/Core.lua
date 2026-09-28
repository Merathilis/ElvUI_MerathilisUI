local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc

function module:Scale()
	if not (E.db and E.db.mui) then
		F.Developer.LogDebug("Scaling >> Database not found. Scalling is not loaded!")
		return
	end

	if not MER:HasRequirements(I.Requirements.AdditionalScaling) then
		return
	end

	if not E.db.mui.scale or not E.db.mui.scale.enable then
		return
	end

	module.hookedFrames = {}

	module:SetElementScale("characterFrame", "CharacterFrame")
	module:SetElementScale("dressingRoom", "DressUpFrame")
	module:SetElementScale("groupFinder", E.Forever and "LFGParentFrame" or "PVEFrame")
	module:SetElementScale("vendor", "MerchantFrame")
	module:SetElementScale("gossip", "GossipFrame")
	module:SetElementScale("quest", "QuestFrame")
	module:SetElementScale("mailbox", "MailFrame")
	module:SetElementScale("friends", "FriendsFrame")
	module:SetElementScale("equipmentFlyout", "EquipmentFlyoutFrame")

	module:AddCallbackOrScale("Blizzard_InspectUI", self.ScaleInspectUI)
	module:AddCallbackOrScale("Blizzard_PlayerSpells", self.ScaleTalents)
	module:AddCallbackOrScale("Blizzard_AuctionHouseUI", self.ScaleAuctionHouse)
	module:AddCallbackOrScale("Blizzard_Collections", self.ScaleCollections)
	module:AddCallbackOrScale("Blizzard_Professions", self.ScaleProfessions)
	module:AddCallbackOrScale("Blizzard_EncounterJournal", self.ScaleEncounterJournal)
	module:AddCallbackOrScale("Blizzard_Transmog", self.ScaleTransmog)
	module:AddCallbackOrScale("Blizzard_TrainerUI", self.ScaleClassTrainer)
	module:AddCallbackOrScale("Blizzard_ItemUpgradeUI", self.ScaleItemUpgrade)
end

module:AddCallback("Scale")
