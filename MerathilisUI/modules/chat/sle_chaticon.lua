local E, L, V, P, G = unpack(ElvUI);
local SLE = ElvUI_SLE[1]

if not IsAddOnLoaded("ElvUI_SLE") then return end

-- Cache global variables
local format = format

local blizzPath = [[|TInterface\ICONS\]]
local toon = blizzPath..[[%s:12:12:0:0:64:64:4:60:4:60|t]]

-- Check the Table (SLE.SpecialChatIcons) and insert it.
if not SLE.SpecialChatIcons["EU"]["Shattrath"] then SLE.SpecialChatIcons["EU"]["Shattrath"] = {} end
if not SLE.SpecialChatIcons["EU"]["Garrosh"] then SLE.SpecialChatIcons["EU"]["Garrosh"] = {} end

SLE.SpecialChatIcons["EU"]["Shattrath"]["Merathilis"] = format(toon, "inv_helmet_challengedruid_d_01")
SLE.SpecialChatIcons["EU"]["Shattrath"]["Damará"] = format(toon, "inv_helmet_plate_challengepaladin_d_01")
SLE.SpecialChatIcons["EU"]["Shattrath"]["Melisendra"] = format(toon, "inv_helm_cloth_challengemage_d_01")
SLE.SpecialChatIcons["EU"]["Garrosh"]["Jahzzy"] = format(toon, "inv_helm_plate_challengedeathknight_d_01")
