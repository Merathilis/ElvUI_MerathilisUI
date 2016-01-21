local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local MERAB = E:NewModule('muiActionbars', 'AceHook-3.0', 'AceEvent-3.0')
local AB = E:GetModule('ActionBars');

-- Cache global variables
local pairs = pairs
local InCombatLockdown = InCombatLockdown

-- Change the out of range check to the hotkeys instead of the whole button
local function UpdateButtonConfig(self, bar, buttonName)
	if InCombatLockdown() or not E.private.muiActionbars.oor.enable then return; end

	bar.buttonConfig.outOfRangeColoring = "hotkey"
	for i, button in pairs(bar.buttons) do
		button.keyBoundTarget = bar.buttonConfig.keyBoundTarget
		bar.buttonConfig.keyBoundTarget = format(buttonName.."%d", i)
	end
end
hooksecurefunc(AB, "UpdateButtonConfig", UpdateButtonConfig)

E:RegisterModule(MERAB:GetName())
