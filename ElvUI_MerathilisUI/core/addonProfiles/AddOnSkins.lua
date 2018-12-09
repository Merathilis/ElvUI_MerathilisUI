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
	local AS = unpack(AddOnSkins)

	AS.data:SetProfile("MerathilisUI")

	AS.db['EmbedOoC'] = false
	AS.db['EmbedOoCDelay'] = 10
	AS.db['EmbedCoolLine'] = false
	AS.db['EmbedSexyCooldown'] = false
	AS.db['TransparentEmbed'] = false
	AS.db['EmbedIsHidden'] = false
	AS.db['EmbedFrameStrata'] = '2-LOW'
	AS.db['EmbedFrameLevel'] = 10
	AS.db['RecountBackdrop'] = false
	AS.db['SkadaBackdrop'] = false
	AS.db['OmenBackdrop'] = false
	AS.db['DetailsBackdrop'] = false
	AS.db['MiscFixes'] = true
	AS.db['DBMSkinHalf'] = false
	AS.db['DBMFont'] = 'Expressway'
	AS.db['DBMFontSize'] = 12
	AS.db['DBMFontFlag'] = 'OUTLINE'
	AS.db['DBMRadarTrans'] = false
	AS.db['WeakAuraAuraBar'] = false
	AS.db['WeakAuraIconCooldown'] = false
	AS.db['SkinTemplate'] = 'Transparent'
	AS.db['HideChatFrame'] = 'NONE'
	AS.db['Parchment'] = false
	AS.db['ParchmentRemover'] = false
	AS.db['SkinDebug'] = false
	AS.db['LoginMsg'] = false
	AS.db['EmbedSystemMessage'] = false
	AS.db['ElvUISkinModule'] = true
	AS.db['ThinBorder'] = false
	AS.db['BackgroundTexture'] = 'Duffed'
	AS.db['StatusBarTexture'] = 'Duffed'

	-- embeded settings
	if IsAddOnLoaded("Details") then
		AS.db["EmbedSystem"] = true
		AS.db["EmbedSystemDual"] = false
		AS.db["EmbedBelowTop"] = true
		AS.db["EmbedMain"] = "Details"
		AS.db["EmbedLeft"] = ""
		AS.db["EmbedRight"] = ""
	end

	if IsAddOnLoaded("Skada") then
		AS.db["EmbedSystem"] = true
		AS.db["EmbedSystemDual"] = false
		AS.db["EmbedBelowTop"] = true
		AS.db["EmbedMain"] = "Skada"
		AS.db["EmbedLeft"] = ""
		AS.db["EmbedRight"] = ""
	end

	if IsAddOnLoaded("Postal") then
		AS.db["Postal"] = false
	end
end
