local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
local unpack = unpack
--WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: AddOnSkins, AddOnSkinsDB, LibStub

local playerName = UnitName("player")
local profileName = playerName.."-mUI"

function MER:LoadAddOnSkinsProfile()
	--[[----------------------------------
	--	AddOnSkins - Settings
	--]]----------------------------------

	-- defaults
	AddOnSkinsDB.profiles[profileName] = {
		['EmbedOoC'] = false,
		['EmbedOoCDelay'] = 10,
		['EmbedCoolLine'] = false,
		['EmbedSexyCooldown'] = false,
		['TransparentEmbed'] = false,
		['EmbedIsHidden'] = false,
		['EmbedFrameStrata'] = '2-LOW',
		['EmbedFrameLevel'] = 10,
	-- Misc
		['RecountBackdrop'] = false,
		['SkadaBackdrop'] = false,
		['OmenBackdrop'] = false,
		['DetailsBackdrop'] = false,
		['MiscFixes'] = true,
		['DBMSkinHalf'] = false,
		['DBMFont'] = 'Arial Narrow',
		['DBMFontSize'] = 12,
		['DBMFontFlag'] = 'OUTLINE',
		['DBMRadarTrans'] = false,
		['WeakAuraAuraBar'] = false,
		['WeakAuraIconCooldown'] = false,
		['SkinTemplate'] = 'Transparent',
		['HideChatFrame'] = 'NONE',
		['Parchment'] = false,
		['ParchmentRemover'] = false,
		['SkinDebug'] = false,
		['LoginMsg'] = false,
		['EmbedSystemMessage'] = false,
		['ElvUISkinModule'] = true,
		['ThinBorder'] = false,
	}

	-- embeded settings
	if IsAddOnLoaded("Details") then
		AddOnSkinsDB.profiles[profileName]["EmbedSystem"] = true
		AddOnSkinsDB.profiles[profileName]["EmbedSystemDual"] = false
		AddOnSkinsDB.profiles[profileName]["EmbedBelowTop"] = true
		AddOnSkinsDB.profiles[profileName]["EmbedMain"] = "Details"
		AddOnSkinsDB.profiles[profileName]["EmbedLeft"] = ""
		AddOnSkinsDB.profiles[profileName]["EmbedRight"] = ""
	end
 
	if IsAddOnLoaded("Skada") then
		AddOnSkinsDB.profiles[profileName]["EmbedSystem"] = true
		AddOnSkinsDB.profiles[profileName]["EmbedSystemDual"] = false
		AddOnSkinsDB.profiles[profileName]["EmbedBelowTop"] = true
		AddOnSkinsDB.profiles[profileName]["EmbedMain"] = "Skada"
		AddOnSkinsDB.profiles[profileName]["EmbedLeft"] = ""
		AddOnSkinsDB.profiles[profileName]["EmbedRight"] = ""
	end
 
	-- Profile creation
	local db = LibStub("AceDB-3.0"):New(AddOnSkinsDB)
	db:SetProfile(profileName)
end