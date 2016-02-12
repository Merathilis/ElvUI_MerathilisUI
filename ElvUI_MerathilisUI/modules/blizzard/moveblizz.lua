local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI')
local B = E:NewModule('muiBlizzard', 'AceHook-3.0', 'AceEvent-3.0')

-- Cache global variables
local _G = _G

local EnableMouse = EnableMouse
local SetMovable = SetMovable
local SetClampedToScreen = SetClampedToScreen
local RegisterForDrag = RegisterForDrag
local StartMoving = StartMoving
local StopMovingOrSizing = StopMovingOrSizing

-- Move some Blizzard frames
B.Frames = {
	"AddonList",
	"BankFrame",
	"CharacterFrame",
	"ChatConfigFrame",
	"CinematicFrame",
	"DressUpFrame",
	"FriendsFrame",
	"GameMenuFrame",
	"GossipFrame",
	"GuildInviteFrame",
	"GuildRegistrarFrame",
	"HelpFrame",
	"InterfaceOptionsFrame",
	"ItemTextFrame",
	"LootFrame",
	"MacOptionsFrame",
	"MailFrame",
	"MerchantFrame",
	"MissingLootFrame",
	"OpenMailFrame",
	"PVEFrame",
	"PVPBannerFrame",
	"PVPFrame",
	"PetStableFrame",
	"PetitionFrame",
	"QuestFrame",
	"QuestLogDetailFrame",
	"QuestLogFrame",
	"RaidBrowserFrame",
	"ScrollOfResurrectionSelectionFrame",
	"SpellBookFrame",
	"StackSplitFrame",
	"StaticPopup1",
	"StaticPopup2",
	"TabardFrame",
	"TaxiFrame",
	"TradeFrame",
	"TutorialFrame",
	"VideoOptionsFrame",
}

function B:Addons(event, addon)
	if E.db.muiMisc.moveBlizz == false then return end
	if addon == "Blizzard_TradeSkillUI" then
		_G["TradeSkillFrame"]:EnableMouse(true)
		_G["TradeSkillFrame"]:SetMovable(true)
		_G["TradeSkillFrame"]:SetClampedToScreen(true)
		_G["TradeSkillFrame"]:RegisterForDrag("LeftButton")
		_G["TradeSkillFrame"]:SetScript("OnDragStart", function(self) self:StartMoving() end)
		_G["TradeSkillFrame"]:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		B:UnregisterEvent(event)
	end
end

function B:Initialize()
	if E.db.muiMisc.moveBlizz == false then return end
	for i = 1, #B.Frames do
		if _G[B.Frames[i]] then
			_G[B.Frames[i]]:EnableMouse(true)
			_G[B.Frames[i]]:SetMovable(true)
			_G[B.Frames[i]]:SetClampedToScreen(true)
			_G[B.Frames[i]]:RegisterForDrag("LeftButton")
			_G[B.Frames[i]]:SetScript("OnDragStart", function(self) self:StartMoving() end)
			_G[B.Frames[i]]:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		end
	end
	self:RegisterEvent("ADDON_LOADED", "Addons")
end

E:RegisterModule(B:GetName())
