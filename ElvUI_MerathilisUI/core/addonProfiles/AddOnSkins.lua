local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

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

	AddOnSkinsDB["RecountBackdrop"] = false
	AddOnSkinsDB["SkadaBackdrop"] = false
	AddOnSkinsDB["DetailsBackdrop"] = false
	AddOnSkinsDB["ParchmentRemover"] = false
	AddOnSkinsDB["WeakAura"] = true
	AddOnSkinsDB["WeakAuraAuraBar"] = false
	AddOnSkinsDB["WeakAuraIconCooldown"] = true
	AddOnSkinsDB["SkinDebug"] = false
	AddOnSkinsDB["LoginMsg"] = false
	AddOnSkinsDB["EmbedSystemMessage"] = false
	AddOnSkinsDB["ElvUISkinModule"] = true
	AddOnSkinsDB["TransparentEmbed"] = true

	if IsAddOnLoaded("Skada") then
		AddOnSkinsDB["EmbedSystem"] = true
		AddOnSkinsDB["EmbedSystemDual"] = false
		AddOnSkinsDB["EmbedBelowTop"] = true
		AddOnSkinsDB["EmbedMain"] = "Skada"
		AddOnSkinsDB["EmbedLeft"] = ""
		AddOnSkinsDB["EmbedRight"] = ""
		AddOnSkinsDB["EmbedFrameStrata"] = "2-LOW"
		AddOnSkinsDB["EmbedFrameLevel"] = 2
	end

	if IsAddOnLoaded("Details") then
		AddOnSkinsDB["EmbedSystem"] = true
		AddOnSkinsDB["EmbedSystemDual"] = false
		AddOnSkinsDB["EmbedBelowTop"] = true
		AddOnSkinsDB["EmbedMain"] = "Details"
		AddOnSkinsDB["EmbedLeft"] = ""
		AddOnSkinsDB["EmbedRight"] = ""
		AddOnSkinsDB["EmbedFrameStrata"] = "2-LOW"
		AddOnSkinsDB["EmbedFrameLevel"] = 2
	end

	-- Profile creation
	local db = LibStub("AceDB-3.0"):New(AddOnSkinsDB, nil, true)
	db:SetProfile("MerathilisUI")
end