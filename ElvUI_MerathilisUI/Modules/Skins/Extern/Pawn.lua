local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local AS = unpack(AddOnSkins)

local hooksecurefunc = hooksecurefunc
local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

if not AS:CheckAddOn('Pawn') then return end
if not C_AddOns_IsAddOnLoaded('AddOnSkins') then return end

function MER:SkinPawn(event, addon)
	if addon == 'Blizzard_ItemSocketingUI' or event == 'PLAYER_ENTERING_WORLD' and C_AddOns_IsAddOnLoaded('Blizzard_ItemSocketingUI') then
		AS:Delay(0.1, function()
			hooksecurefunc(ItemSocketingDescription, "SetSocketedItem", function()
				if (PawnSocketingTooltip and not PawnSocketingTooltip.stripped) then
					PawnSocketingTooltip:StripTextures()
					PawnSocketingTooltip:Styling()
					PawnSocketingTooltip.stripped = true
				end
			end)
		end)
	end
end

AS:RegisterSkin("Pawn", MER.SkinPawn, 2, "ADDON_LOADED")
