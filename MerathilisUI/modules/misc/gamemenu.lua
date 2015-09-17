local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule('MerathilisUI')
local S = E:GetModule('Skins')

function MER:GameMenu()
	-- GameMenu Frame
	local button = CreateFrame("Button", "MerConfigButton", GameMenuFrame, "GameMenuButtonTemplate")
	button:Size(GameMenuButtonUIOptions:GetWidth(), GameMenuButtonUIOptions:GetHeight())
	button:SetPoint("TOP", GameMenuButtonUIOptions, "BOTTOM", 0 , -1)
	button:SetScript("OnClick", function() MER:DasOptions() PlaySound("igMainMenuOption") HideUIPanel(GameMenuFrame) end)
	button:SetText("|cffff7d0aMerathilisUI|r")
	
	local bottomPanel = CreateFrame("Frame", nil, GameMenuFrame)
	bottomPanel:SetFrameLevel(0)
	bottomPanel:SetTemplate("Transparent")
	bottomPanel:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -E.Border)
	bottomPanel:SetWidth(GetScreenWidth() + (E.Border*2))
	bottomPanel:SetHeight(GetScreenHeight() * (1 / 4))
	
	local TopPanel = CreateFrame("Frame", nil, GameMenuFrame)
	TopPanel:SetFrameLevel(0)
	TopPanel:SetTemplate("Transparent")
	TopPanel:SetPoint("TOP", E.UIParent, "TOP", 0, E.Border) -- had a small gap
	TopPanel:SetWidth(GetScreenWidth() + (E.Border*2))
	TopPanel:SetHeight(GetScreenHeight() * (1 / 4))
	

	TopPanel.Logo = TopPanel:CreateTexture(nil, 'OVERLAY')
	TopPanel.Logo:SetSize(285, 128)
	TopPanel.Logo:SetPoint("TOP", TopPanel, "TOP", 0, 5)
	TopPanel.Logo:SetTexture("Interface\\AddOns\\MerathilisUI\\media\\textures\\merathilis_logo.tga")

	
	if
	E.private.skins.blizzard.enable == true and E.private.skins.blizzard.misc == true then
		S:HandleButton(button)
	end

	GameMenuFrame:HookScript("OnShow", function()
		GameMenuFrame:Height(GameMenuFrame:GetHeight() + button:GetHeight())
	end)

	GameMenuButtonKeybindings:ClearAllPoints()
	GameMenuButtonKeybindings:Point("TOP", MerConfigButton, "BOTTOM", 0, -1)
end

function MER:LoadGameMenu()
	if E.db.Merathilis.GameMenu then
		self:GameMenu()
	end
end
