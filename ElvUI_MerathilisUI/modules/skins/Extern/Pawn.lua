local MER, E, L, V, P, G = unpack(select(2, ...))
if not IsAddOnLoaded('AddOnSkins') then return end
local AS = unpack(AddOnSkins)

if not AS:CheckAddOn('Pawn') then return end

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local hooksecurefunc = hooksecurefunc
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS:

function MER:SkinPawn(event, addon)
	if addon == 'Blizzard_ItemSocketingUI' or event == 'PLAYER_ENTERING_WORLD' and IsAddOnLoaded('Blizzard_ItemSocketingUI') then
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
