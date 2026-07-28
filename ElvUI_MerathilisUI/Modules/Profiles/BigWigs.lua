local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles") ---@class Profiles
local Splash = MER:GetModule("MER_SplashScreen") ---@class SplashScreen

-- Runs after successful profile import
local function CallbackFunction(accepted)
	if not accepted then
		return
	end

	-- Handle minimap icon
	local LDBI = LibStub("LibDBIcon-1.0")
	BigWigsIconDB.hide = true
	LDBI:Hide("BigWigs")
end

function module:LoadBigWigsProfile()
	if not E:IsAddOnEnabled("BigWigs") then
		F.DebugPrint(L["BigWigs is not installed or enabled."], "error")
		return
	end

	-- Profile names
	local ProfileName = "MerathilisUI"

	-- Profile string
	local ProfileString =
		"BW2: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"

	-- Profile import
	-- API.RegisterProfile(addonName, profileString, optionalCustomProfileName, optionalCallbackFunction)
	BigWigsAPI.RegisterProfile(MER.Title, ProfileString, ProfileName, CallbackFunction)

	-- No chat print here
	-- BigWigs will print a message with all important information after the import
end

function module:ApplyBigWigsProfile()
	Splash:Wrap("Applying BigWigs Profile ...", function()
		-- Apply Fonts
		self:LoadBigWigsProfile()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			Splash:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "BigWigs")
end
