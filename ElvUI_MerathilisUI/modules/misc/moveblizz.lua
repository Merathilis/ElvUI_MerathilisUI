local E, L, V, P, G = unpack(ElvUI)
local mod = E:NewModule("mUImoveBlizz", "AceHook-3.0", "AceEvent-3.0")
mod.modName = L["moveBlizz"]

-- Cache global variables
-- Lua functions
local _G = _G
local type = type
-- WoW API / Variables

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: TradeSkillFrame

-- Move some Blizzard frames
mod.Frames = {
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
	"VideoOptionsFrame",
	"WorldMapFrame"
}

mod.AddonsList = {
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

function mod:MakeMovable(frame)
	if frame then
		frame:EnableMouse(true)
		frame:SetMovable(true)
		frame:SetClampedToScreen(true)
		frame:RegisterForDrag("LeftButton")
		frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
		frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		if frame.TitleMouseover then mod:MakeMovable(frame.TitleMouseover) end
	end
end

function mod:Addons(event, addon)
	local frame
	addon = mod.AddonsList[addon]
	if not addon then return end
	if type(addon) == "table" then
		for i = 1, #addon do
			frame = _G[addon[i]]
			mod:MakeMovable(frame)
		end
	else
		frame = _G[addon]
		mod:MakeMovable(frame)
	end
	mod.addonCount = mod.addonCount + 1
	if mod.addonCount == #mod.AddonsList then mod:UnregisterEvent(event) end
end

function mod:Initialize()
	if E.db.mui.misc.moveBlizz ~= true then return; end
	mod.addonCount = 0
	for i = 1, #mod.Frames do
		local frame = _G[mod.Frames[i]]
		if frame then mod:MakeMovable(frame) end
	end
	self:RegisterEvent("ADDON_LOADED", "Addons")
end

local function InitializeCallback()
	mod:Initialize()
end

E:RegisterModule(mod:GetName(), InitializeCallback)