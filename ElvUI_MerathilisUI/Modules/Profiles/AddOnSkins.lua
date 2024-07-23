local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

local unpack = unpack

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

function module:LoadAddOnSkinsProfile()
	local AS = unpack(AddOnSkins)
	local profileName = I.ProfileNames.Default

	AS.data:SetProfile(profileName)

	AS.db["EmbedOoC"] = false
	AS.db["EmbedOoCDelay"] = 10
	AS.db["EmbedCoolLine"] = false
	AS.db["EmbedSexyCooldown"] = false
	AS.db["TransparentEmbed"] = false
	AS.db["EmbedIsHidden"] = false
	AS.db["EmbedFrameStrata"] = "3-MEDIUM"
	AS.db["EmbedFrameLevel"] = 50
	AS.db["RecountBackdrop"] = false
	AS.db["SkadaBackdrop"] = false
	AS.db["OmenBackdrop"] = false
	AS.db["DetailsBackdrop"] = false
	AS.db["MiscFixes"] = true
	AS.db["DBMSkinHalf"] = false
	AS.db["DBMFont"] = I.Fonts.Primary
	AS.db["DBMFontSize"] = 12
	AS.db["DBMFontFlag"] = "OUTLINE"
	AS.db["DBMRadarTrans"] = false
	AS.db["WeakAuraAuraBar"] = false
	AS.db["WeakAuraIconCooldown"] = false
	AS.db["SkinTemplate"] = "MerathilisUI"
	AS.db["HideChatFrame"] = "NONE"
	AS.db["Parchment"] = false
	AS.db["ParchmentRemover"] = false
	AS.db["SkinDebug"] = true
	AS.db["LoginMsg"] = false
	AS.db["EmbedSystemMessage"] = false
	AS.db["ElvUISkinModule"] = true
	AS.db["ThinBorder"] = false
	AS.db["BackgroundTexture"] = "ElvUI Norm1"
	AS.db["StatusBarTexture"] = "ElvUI Norm1"
	AS.db["Clique"] = false
	AS.db["GlobalIgnoreList"] = false
	AS.db["Pawn"] = false
	AS.db["BagSync"] = false

	-- embeded settings
	if IsAddOnLoaded("Details") then
		AS.db["EmbedSystem"] = false
		AS.db["EmbedSystemDual"] = false
		AS.db["EmbedBelowTop"] = false
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

	if IsAddOnLoaded("BugSack") then
		AS.db["BugSack"] = false
	end
end

function module:ApplyAddOnSkinsProfile()
	module:Wrap("Applying AddOnSkins Profile ...", function()
		-- Apply Fonts
		self:LoadAddOnSkinsProfile()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			module:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "AddOnSkins")
end
