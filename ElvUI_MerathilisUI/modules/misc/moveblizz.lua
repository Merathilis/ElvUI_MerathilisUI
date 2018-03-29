local MER, E, L, V, P, G = unpack(select(2, ...))
local MB = E:NewModule("mUImoveBlizz", "AceHook-3.0", "AceEvent-3.0")
MB.modName = L["moveBlizz"]

-- Cache global variables
-- Lua functions
local _G = _G
local type = type
-- WoW API / Variables

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

-- Move some Blizzard frames
MB.Frames = {
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
	"MailFrame",
	"MerchantFrame",
	"OpenMailFrame",
	"PVEFrame",
	"PetStableFrame",
	"PetitionFrame",
	"QuestFrame",
	"QuestLogPopupDetailFrame",
	"RaidBrowserFrame",
	"RaidInfoFrame",
	"RaidParentFrame",
	"ReadyCheckFrame",
	"ReportCheatingDialog",
	"RolePollPopup",
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
	"VideoOptionsFrame",
	"WorldMapFrame",
	"WorldStateAlwaysUpFrame",
	"WorldStateScoreFrame",
}

MB.AddonsList = {
	["Blizzard_AchievementUI"] = {"AchievementFrame", "AchievementFrameHeader"},
	["Blizzard_ArchaeologyUI"] = {"ArchaeologyFrame"},
	["Blizzard_ArtifactUI"] = {"ArtifactRelicForgeFrame"},
	["Blizzard_AuctionUI"] = {"AuctionFrame"},
	["Blizzard_BarberShopUI"] = {"BarberShopFrame"},
	["Blizzard_BindingUI"] = {"KeyBindingFrame"},
	["Blizzard_Calendar"] = {"CalendarCreateEventFrame", "CalendarFrame", "CalendarViewEventFrame", "CalendarViewHolidayFrame"},
	["Blizzard_ChallengesUI"] = {"ChallengesKeystoneFrame"},
	["Blizzard_Collections"] = {"CollectionsJournal", "WardrobeFrame"},
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
	["Blizzard_VoidStorageUI"] = {"VoidStorageFrame"},
	["Blizzard_OrderHallUI"] = {"OrderHallTalentFrame"},
}

function MB:MakeMovable(frame)
	if not frame then
		MER:Print("Frame doesn't exist: "..MB.Frames[i])
		return
	end

	if frame then
		frame:EnableMouse(true)
		frame:SetMovable(true)
		frame:SetClampedToScreen(true)
		frame:RegisterForDrag("LeftButton")
		frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
		frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		if frame.TitleMouseover then
			MB:MakeMovable(frame.TitleMouseover)
		end
	end
end

function MB:Addons(event, addon)
	local frame
	addon = MB.AddonsList[addon]
	if not addon then return end
	if type(addon) == "table" then
		for i = 1, #addon do
			frame = _G[addon[i]]
			MB:MakeMovable(frame)
		end
	else
		frame = _G[addon]
		MB:MakeMovable(frame)
	end
	MB.addonCount = MB.addonCount + 1
	if MB.addonCount == #MB.AddonsList then
		MB:UnregisterEvent(event)
	end
end

function MB:Initialize()
	if E.db.mui.misc.moveBlizz ~= true then return; end
	MB.addonCount = 0
	for i = 1, #MB.Frames do
		local frame = _G[MB.Frames[i]]
		if frame then
			MB:MakeMovable(frame)
		end
	end
	self:RegisterEvent("ADDON_LOADED", "Addons")
end

local function InitializeCallback()
	MB:Initialize()
end

E:RegisterModule(MB:GetName(), InitializeCallback)