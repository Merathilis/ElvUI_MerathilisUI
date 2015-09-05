local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

StaticPopupDialogs["merathilis"] = {
	text = L[".:: Welcome to |cff1784d1MerathilisUI|r v"]..MER.Version..L[" ::.\nPress OK if you want to apply my settings."],
	button1 = L['OK'],
	button2 = L['No thanks'],
	-- Use the folling line when done with your settings
	OnAccept = function() E.db.Merathilis.installed = true; SetupUI(); PlaySoundFile([[Sound\Interface\LevelUp.ogg]]) end, -- we set the default value to true, so it won't popup again and then run the Setup function plus I added the lvl sound :P
	
	-- Following line is for testing purposes. Doesn't set the option to true, so the message will pop everytime
	--OnAccept = function() SetupUI(); PlaySoundFile([[Sound\Interface\LevelUp.ogg]]) end, -- we set the default value to true, so it won't popup again and then run the Setup function plus I added the lvl sound :P
	
	OnCancel = function() end, -- do nothing
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
	preferredIndex = 3,
}
