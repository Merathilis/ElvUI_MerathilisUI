local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")

function module:Scale()
	if not E.db and not E.db.mui then
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
	module:SetElementScale("groupFinder", "PVEFrame")
	module:SetElementScale("vendor", "MerchantFrame")
	module:SetElementScale("gossip", "GossipFrame")
	module:SetElementScale("quest", "QuestFrame")
	module:SetElementScale("mailbox", "MailFrame")
	module:SetElementScale("friends", "FriendsFrame")

	module:AddCallbackOrScale("Blizzard_InspectUI", self.ScaleInspectUI)
	module:AddCallbackOrScale("Blizzard_PlayerSpells", self.ScaleTalents)
	module:AddCallbackOrScale("Blizzard_AuctionHouseUI", self.ScaleAuctionHouse)
	module:AddCallbackOrScale("Blizzard_Collections", self.ScaleCollections)
	module:AddCallbackOrScale("Blizzard_Collections", self.AdjustTransmogFrame)
	module:AddCallbackOrScale("Blizzard_Professions", self.ScaleProfessions)
end

module:AddCallback("Scale")
