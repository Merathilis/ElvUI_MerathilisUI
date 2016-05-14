local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI')
local B = E:NewModule('muiBlizzard', 'AceHook-3.0', 'AceEvent-3.0')

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local EnableMouse = EnableMouse
local SetMovable = SetMovable
local SetClampedToScreen = SetClampedToScreen
local RegisterForDrag = RegisterForDrag
local StartMoving = StartMoving
local StopMovingOrSizing = StopMovingOrSizing

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: TradeSkillFrame

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
	"TimeManagerFrame",
	"TradeFrame",
	"TutorialFrame",
	"VideoOptionsFrame"
}

B.AddonsList = {
	["Blizzard_AchievementUI"] = {"AchievementFrame", "AchievementFrameHeader"},
	["Blizzard_ArchaeologyUI"] = {"ArchaeologyFrame"},
	["Blizzard_AuctionUI"] = {"AuctionFrame"},
	["Blizzard_BarberShopUI"] = {"BarberShopFrame"},
	["Blizzard_BindingUI"] = {"KeyBindingFrame"},
	["Blizzard_Calendar"] = {"CalendarCreateEventFrame", "CalendarFrame", "CalendarViewEventFrame", "CalendarViewHolidayFrame"},
	["Blizzard_ChallengesUI"] = {"ChallengesLeaderboardFrame"},
	["Blizzard_Collections"] = {"CollectionsJournal"},
	["Blizzard_EncounterJournal"] = {"EncounterJournal"},
	["Blizzard_GarrisonUI"] = {"GarrisonLandingPage", "GarrisonMissionFrame", "GarrisonCapacitiveDisplayFrame", "GarrisonBuildingFrame", "GarrisonRecruiterFrame", "GarrisonRecruitSelectFrame", "GarrisonShipyardFrame"},
	["Blizzard_GMChatUI"] = {"GMChatStatusFrame"},
	["Blizzard_GMSurveyUI"] = {"GMSurveyFrame"},
	["Blizzard_GuildBankUI"] = {"GuildBankFrame"},
	["Blizzard_GuildControlUI"] = {"GuildControlUI"},
	["Blizzard_GuildUI"] = {"GuildFrame", "GuildLogFrame"},
	["Blizzard_InspectUI"] = {"InspectFrame"},
	["Blizzard_ItemAlterationUI"] = {"TransmogrifyFrame"},
	["Blizzard_ItemSocketingUI"] = {"ItemSocketingFrame"},
	["Blizzard_ItemUpgradeUI"] = {"ItemUpgradeFrame"},
	["Blizzard_LookingForGuildUI"] = {"LookingForGuildFrame"},
	["Blizzard_MacroUI"] = {"MacroFrame"},
	["Blizzard_QuestChoice"] = {"QuestChoiceFrame"},
	["Blizzard_TalentUI"] = {"PlayerTalentFrame"},
	["Blizzard_TradeSkillUI"] = {"TradeSkillFrame"},
	["Blizzard_TrainerUI"] = {"ClassTrainerFrame"},
	["Blizzard_VoidStorageUI"] = {"VoidStorageFrame"}
}

function B:MakeMovable(frame)
	if frame then
		frame:EnableMouse(true)
		frame:SetMovable(true)
		frame:SetClampedToScreen(true)
		frame:RegisterForDrag("LeftButton")
		frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
		frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		if frame.TitleMouseover then B:MakeMovable(frame.TitleMouseover) end
	end
end

function B:Addons(event, addon)
	local frame
	addon = B.AddonsList[addon]
	if not addon then return end
	if type(addon) == "table" then
		for i = 1, #addon do
			frame = _G[addon[i]]
			B:MakeMovable(frame)
		end
	else
		frame = _G[addon]
		B:MakeMovable(frame)
	end
	B.addonCount = B.addonCount + 1
	if B.addonCount == #B.AddonsList then B:UnregisterEvent(event) end
end

function B:Initialize()
	if E.db.mui.misc.moveBlizz ~= true then return; end
	B.addonCount = 0
	for i = 1, #B.Frames do
		local frame = _G[B.Frames[i]]
		if frame then B:MakeMovable(frame) end
	end
	self:RegisterEvent("ADDON_LOADED", "Addons")
end

E:RegisterModule(B:GetName())
