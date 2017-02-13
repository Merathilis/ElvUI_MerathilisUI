local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

function MER:LoadAddOnSkinsProfile()
	--[[----------------------------------
	--	AddOnSkins - Settings
	--]]----------------------------------
	local AS = unpack(AddOnSkins) or nil
	if AddOnSkinsDB["profiles"]["MerathilisUI"] == nil then AddOnSkinsDB["profiles"]["MerathilisUI"] = {} end

	AddOnSkinsDB["EmbedSystem"] = true
	AddOnSkinsDB["EmbedSystemDual"] = false
	AddOnSkinsDB["EmbedBelowTop"] = true
	AddOnSkinsDB["TransparentEmbed"] = true
	AddOnSkinsDB["EmbedMain"] = "Skada"
	AddOnSkinsDB["EmbedLeft"] = ""
	AddOnSkinsDB["EmbedRight"] = ""
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
	AddOnSkinsDB["EmbedFrameStrata"] = "2-LOW"
	AddOnSkinsDB["EmbedFrameLevel"] = 2

	-- Profile creation
	local db = LibStub("AceDB-3.0"):New(AddOnSkinsDB, nil, true)
	db:SetProfile("MerathilisUI")
end