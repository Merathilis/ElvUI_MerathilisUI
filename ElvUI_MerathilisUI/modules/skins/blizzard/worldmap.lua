local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');

-- Cache global variables
local _G = _G
-- Lua functions
-- WoW API / Variables
-- GLOBALS: hooksecurefunc

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

local function styleworldMap()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.worldmap ~= true or E.private.muiSkins.blizzard.worldMap ~= true then return end

	-- Style WorldMap Tooltip Statusbar
	local bar = _G["WorldMapTaskTooltipStatusBar"].Bar
	if bar then
		bar:StripTextures()
		bar:SetStatusBarTexture(E["media"].MuiFlat)
		bar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
		bar:CreateBackdrop()
		bar.backdrop:Point("TOPLEFT", bar, -1, 1)
		bar.backdrop:Point("TOPLEFT", bar, -1, 1)
	end
	hooksecurefunc("TaskPOI_OnEnter", styleworldMap)
end
hooksecurefunc(S, "Initialize", styleworldMap)

