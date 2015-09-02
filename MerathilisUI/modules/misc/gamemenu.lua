local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule('MerathilisUI')
local S = E:GetModule('Skins')

-- Button in GameMenuButton Frame
local button = CreateFrame("Button", "ConfigButton", GameMenuFrame, "GameMenuButtonTemplate")
button:Size(GameMenuButtonUIOptions:GetWidth(), GameMenuButtonUIOptions:GetHeight())
button:SetPoint("TOP", GameMenuButtonUIOptions, "BOTTOM", 0 , -1)
button:SetScript("OnClick", function() E:ToggleConfig() HideUIPanel(GameMenuFrame) end)
button:SetText("|cff1784d1MerathilisUI|r")

if E.private.skins.blizzard.enable == true and E.private.skins.blizzard.misc == true then
	S:HandleButton(button)
end

GameMenuFrame:HookScript("OnShow", function()
	GameMenuFrame:Height(GameMenuFrame:GetHeight() + button:GetHeight())
end)

GameMenuButtonKeybindings:ClearAllPoints()
GameMenuButtonKeybindings:Point("TOP", ConfigButton, "BOTTOM", 0, -1)
