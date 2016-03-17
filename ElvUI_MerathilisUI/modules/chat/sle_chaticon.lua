local E, L, V, P, G = unpack(ElvUI);
if not IsAddOnLoaded("ElvUI_SLE") then return; end
local SLE
if ElvUI_SLE then SLE = ElvUI_SLE[1] else SLE = E:GetModule("SLE") end

-- Cache global variables
local format = format

local blizzPath = [[|TInterface\ICONS\]]
local toon = blizzPath..[[%s:12:12:0:0:64:64:4:60:4:60|t]]

-- Check the Table (SLE.SpecialChatIcons) and insert it.
if not SLE.SpecialChatIcons["EU"]["Shattrath"] then SLE.SpecialChatIcons["EU"]["Shattrath"] = {} end
if not SLE.SpecialChatIcons["EU"]["Garrosh"] then SLE.SpecialChatIcons["EU"]["Garrosh"] = {} end

-- EU-Shattrath
SLE.SpecialChatIcons["EU"]["Shattrath"]["Asragoth"] = format(toon, "inv_cloth_challengewarlock_d_01helm")
SLE.SpecialChatIcons["EU"]["Shattrath"]["Brítt"] = format(toon, "inv_helm_plate_challengewarrior_d_01")
SLE.SpecialChatIcons["EU"]["Shattrath"]["Damará"] = format(toon, "inv_helmet_plate_challengepaladin_d_01")
SLE.SpecialChatIcons["EU"]["Shattrath"]["Jazira"] = format(toon, "inv_helmet_cloth_challengepriest_d_01")
SLE.SpecialChatIcons["EU"]["Shattrath"]["Jústice"] = format(toon, "inv_helmet_leather_challengerogue_d_01")
SLE.SpecialChatIcons["EU"]["Shattrath"]["Merathilis"] = format(toon, "inv_helmet_challengedruid_d_01")
SLE.SpecialChatIcons["EU"]["Shattrath"]["Merathilîs"] = format(toon, "inv_helmet_mail_challengeshaman_d_01")
SLE.SpecialChatIcons["EU"]["Shattrath"]["Melisendra"] = format(toon, "inv_helm_cloth_challengemage_d_01")
SLE.SpecialChatIcons["EU"]["Shattrath"]["Róhal"] = format(toon, "inv_helmet_mail_challengehunter_d_01")

-- EU-Garrosh
SLE.SpecialChatIcons["EU"]["Garrosh"]["Jahzzy"] = format(toon, "inv_helm_plate_challengedeathknight_d_01")
