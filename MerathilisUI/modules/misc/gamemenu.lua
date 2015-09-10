local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule('MerathilisUI')
local S = E:GetModule('Skins')

function MER:CreateGameMenuButton()
	-- Button in GameMenuButton Frame
	local button = CreateFrame("Button", "MerConfigButton", GameMenuFrame, "GameMenuButtonTemplate")
	button:Size(GameMenuButtonUIOptions:GetWidth(), GameMenuButtonUIOptions:GetHeight())
	button:SetPoint("TOP", GameMenuButtonUIOptions, "BOTTOM", 0 , -1)
	button:SetScript("OnClick", function() MER:DasOptions() HideUIPanel(GameMenuFrame) end)
	button:SetText("|cffff7d0aMerathilisUI|r")

	if E.private.skins.blizzard.enable == true and E.private.skins.blizzard.misc == true then
		S:HandleButton(button)
	end

	GameMenuFrame:HookScript("OnShow", function()
		GameMenuFrame:Height(GameMenuFrame:GetHeight() + button:GetHeight())
	end)

	GameMenuButtonKeybindings:ClearAllPoints()
	GameMenuButtonKeybindings:Point("TOP", MerConfigButton, "BOTTOM", 0, -1)
end

function MER:LoadGameMenuButton()
	if E.db.Merathilis.GameMenuButton then
		self:CreateGameMenuButton()
	end
end
