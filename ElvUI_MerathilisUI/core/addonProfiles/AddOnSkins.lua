local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
local unpack = unpack
--WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: AddOnSkins, AddOnSkinsDB, LibStub

function MER:LoadAddOnSkinsProfile()
	--[[----------------------------------
	--	AddOnSkins - Settings
	--]]----------------------------------

	-- defaults
	AddOnSkinsDB.profiles["MerathilisUI"] = {
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
		AddOnSkinsDB.profiles["MerathilisUI"]["EmbedSystem"] = true
		AddOnSkinsDB.profiles["MerathilisUI"]["EmbedSystemDual"] = false
		AddOnSkinsDB.profiles["MerathilisUI"]["EmbedBelowTop"] = true
		AddOnSkinsDB.profiles["MerathilisUI"]["EmbedMain"] = "Details"
		AddOnSkinsDB.profiles["MerathilisUI"]["EmbedLeft"] = ""
		AddOnSkinsDB.profiles["MerathilisUI"]["EmbedRight"] = ""
	end
 
	if IsAddOnLoaded("Skada") then
		AddOnSkinsDB.profiles["MerathilisUI"]["EmbedSystem"] = true
		AddOnSkinsDB.profiles["MerathilisUI"]["EmbedSystemDual"] = false
		AddOnSkinsDB.profiles["MerathilisUI"]["EmbedBelowTop"] = true
		AddOnSkinsDB.profiles["MerathilisUI"]["EmbedMain"] = "Skada"
		AddOnSkinsDB.profiles["MerathilisUI"]["EmbedLeft"] = ""
		AddOnSkinsDB.profiles["MerathilisUI"]["EmbedRight"] = ""
	end

	if IsAddOnLoaded("Postal") then
		AddOnSkinsDB.profiles["MerathilisUI"]["Postal"] = false
	end
 
	-- Profile creation
	local AS = unpack(AddOnSkins)
	AS.data:SetProfile("MerathilisUI")
end