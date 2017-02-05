local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

function MER:LoadAddOnSkinsProfile()
	--[[----------------------------------
	--	AddOnSkins - Settings
	--]]----------------------------------
	local AS = unpack(AddOnSkins) or nil

	AS.db["EmbedSystem"] = true
	AS.db["EmbedSystemDual"] = false
	AS.db["EmbedBelowTop"] = true
	AS.db["TransparentEmbed"] = true
	AS.db["EmbedMain"] = "Skada"
	AS.db["EmbedLeft"] = ""
	AS.db["EmbedRight"] = ""
	AS.db["RecountBackdrop"] = false
	AS.db["SkadaBackdrop"] = false
	AS.db["DetailsBackdrop"] = false
	AS.db["ParchmentRemover"] = false
	AS.db["WeakAura"] = true
	AS.db["WeakAuraAuraBar"] = false
	AS.db["WeakAuraIconCooldown"] = true
	AS.db["SkinDebug"] = false
	AS.db["LoginMsg"] = false
	AS.db["EmbedSystemMessage"] = false
	AS.db["ElvUISkinModule"] = true
	AS.db["EmbedFrameStrata"] = "2-LOW"
	AS.db["EmbedFrameLevel"] = 2
end