local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule('MerathilisUI')

--Cache global variables
local unpack = unpack
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: AddOnSkins, AddOnSkinsDB, LibStub

function MER:LoadAddOnSkinsProfile()
	--[[----------------------------------
	--	AddOnSkins - Settings
	--]]----------------------------------
	local AS = unpack(AddOnSkins) or nil
	if AddOnSkinsDB["profiles"]["MerathilisUI"] == nil then AddOnSkinsDB["profiles"]["MerathilisUI"] = {} end

	-- defaults
	AddOnSkinsDB["profiles"]["MerathilisUI"] = {
		["EmbedSystem"] = false,
		["EmbedSystemDual"] = false,
		["RecountBackdrop"] = false,
		["Blizzard_WorldStateCaptureBar"] = false,
		["Blizzard_AbilityButton"] = false,
		["Blizzard_Transmogrify"] = false,
		["ParchmentRemover"] = true,
		["Blizzard_TradeSkill"] = false,
		["Blizzard_Options"] = false,
		["MiscellaneousFixes"] = true,
		["Blizzard_MacroUI"] = false,
		["PremadeGroupsFilter"] = true,
		["Blizzard_AddonManager"] = false,
		["Blizzard_BarberShop"] = false,
		["Blizzard_Inspect"] = false,
		["Blizzard_ExtraActionButton"] = false,
		["Blizzard_WorldMap"] = false,
		["Blizzard_Mail"] = false,
		["Blizzard_Spellbook"] = false,
		["Blizzard_Garrison"] = false,
		["Blizzard_Gossip"] = false,
		["Blizzard_VoidStorage"] = false,
		["Blizzard_DebugTools"] = false,
		["Blizzard_TimeManager"] = false,
		["Blizzard_TradeWindow"] = false,
		["Blizzard_Taxi"] = false,
		["Blizzard_Bags"] = false,
		["Blizzard_LootFrames"] = false,
		["Blizzard_BlackMarket"] = false,
		["Blizzard_PvE"] = false,
		["Blizzard_PVPUI"] = false,
		["Blizzard_Calendar"] = false,
		["Blizzard_ArchaeologyUI"] = false,
		["Blizzard_Friends"] = false,
		["Blizzard_DressUpFrame"] = false,
		["Blizzard_CharacterFrame"] = false,
		["Blizzard_Collections"] = false,
		["Blizzard_RaidUI"] = false,
		["Blizzard_ChallengesUI"] = false,
		["Blizzard_Quest"] = false,
		["Blizzard_ItemSocketing"] = false,
		["Blizzard_Trainer"] = false,
		["Blizzard_Merchant"] = false,
		["Blizzard_Others"] = false,
		["Blizzard_EncounterJournal"] = false,
		["Blizzard_Talent"] = false,
		["Blizzard_Guild"] = false,
		["Blizzard_DeathRecap"] = false,
		["Blizzard_AchievementUI"] = false,
		["Blizzard_StackSplit"] = false,
		["Blizzard_AuctionHouse"] = false,
		["Blizzard_ChatBubbles"] = false,
		["WeakAuras"] = false, -- seems to be ignored >.>
		["WeakAuraAuraBar"] = false,
	}

	-- embeded settings
	if IsAddOnLoaded("Details") then
		AddOnSkinsDB["profiles"]["MerathilisUI"] = {
			["LoginMsg"] = false,
			["EmbedSystemMessage"] = false,
			["ElvUISkinModule"] = true,
			["EmbedSystem"] = true,
			["EmbedSystemDual"] = false,
			["EmbedBelowTop"] = true,
			["EmbedMain"] = "Details",
			["EmbedLeft"] = "",
			["EmbedRight"] = "",
			["EmbedFrameStrata"] = "2-LOW",
			["EmbedFrameLevel"] = 2,
			["TransparentEmbed"] = true,
			["DetailsBackdrop"] = false,
		}
	end

	if IsAddOnLoaded("Skada") then
		AddOnSkinsDB["profiles"]["MerathilisUI"] = {
			["LoginMsg"] = false,
			["EmbedSystemMessage"] = false,
			["ElvUISkinModule"] = true,
			["EmbedSystem"] = true,
			["EmbedSystemDual"] = false,
			["EmbedBelowTop"] = true,
			["EmbedMain"] = "Skada",
			["EmbedLeft"] = "",
			["EmbedRight"] = "",
			["EmbedFrameStrata"] = "2-LOW",
			["EmbedFrameLevel"] = 2,
			["SkadaBackdrop"] = false
		}
	end

	-- Profile creation
	local db = LibStub("AceDB-3.0"):New(AddOnSkinsDB, nil, true)
	db:SetProfile("MerathilisUI")
end