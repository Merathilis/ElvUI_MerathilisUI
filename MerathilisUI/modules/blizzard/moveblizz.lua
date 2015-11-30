local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
local _G = _G
local pairs = pairs

local EnableMouse = EnableMouse
local SetMovable = SetMovable
local SetClampedToScreen = SetClampedToScreen
local RegisterForDrag = RegisterForDrag
local StartMoving = StartMoving
local StopMovingOrSizing = StopMovingOrSizing

-- Move some Blizzard frames
local frames = {
	"CharacterFrame", "SpellBookFrame", "PVPFrame", "TaxiFrame", "QuestFrame", "PVEFrame",
	"QuestLogFrame", "QuestLogDetailFrame", "MerchantFrame", "TradeFrame", "MailFrame",
	"FriendsFrame", "CinematicFrame", "TabardFrame", "PVPBannerFrame", "PetStableFrame",
	"GuildRegistrarFrame", "PetitionFrame", "HelpFrame", "GossipFrame", "DressUpFrame",
	"ChatConfigFrame", "RaidBrowserFrame", "InterfaceOptionsFrame", "GameMenuFrame", 
	"VideoOptionsFrame", "GuildInviteFrame", "ItemTextFrame", "BankFrame", "OpenMailFrame", 
	"LootFrame", "StackSplitFrame", "MacOptionsFrame", "TutorialFrame", "StaticPopup1", 
	"StaticPopup2", "MissingLootFrame", "ScrollOfResurrectionSelectionFrame", "AddonList"
}

for i, v in pairs(frames) do
	if _G[v] then
		_G[v]:EnableMouse(true)
		_G[v]:SetMovable(true)
		_G[v]:SetClampedToScreen(true)
		_G[v]:RegisterForDrag("LeftButton")
		_G[v]:SetScript("OnDragStart", function(self) self:StartMoving() end)
		_G[v]:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	end
end
