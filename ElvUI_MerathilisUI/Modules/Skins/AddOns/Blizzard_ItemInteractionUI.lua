local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
local CreateFrame = CreateFrame
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.ItemInteraction ~= true or E.private.muiSkins.blizzard.ItemInteraction ~= true then return end

	local ItemInteractionFrame = _G.ItemInteractionFrame
	if ItemInteractionFrame.backdrop then
		ItemInteractionFrame.backdrop:Styling()
	end
end

S:AddCallbackForAddon("Blizzard_ItemInteractionUI", "mUIItemInteraction", LoadSkin)
