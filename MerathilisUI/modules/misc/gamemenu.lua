local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule('MerathilisUI')
local S = E:GetModule('Skins')

local classColor = RAID_CLASS_COLORS[E.myclass]

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
	MER:StyleFrame(bottomPanel)
	bottomPanel:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -E.Border)
	bottomPanel:SetWidth(GetScreenWidth() + (E.Border*2))
	bottomPanel:SetHeight(GetScreenHeight() * (1 / 4))
	
	bottomPanel:SetScript("OnShow", function(self)
		bottomPanel:Run("Alpha", .7, 0, 1)
		bottomPanel:SetSmoothType("Out")
	end)
	
	local topPanel = CreateFrame("Frame", nil, GameMenuFrame)
	topPanel:SetFrameLevel(0)
	topPanel:SetTemplate("Transparent")
	topPanel:SetPoint("TOP", E.UIParent, "TOP", 0, 0)
	topPanel:SetWidth(GetScreenWidth() + (E.Border*2))
	topPanel:SetHeight(GetScreenHeight() * (1 / 4))
	
	topPanel:SetScript("OnShow", function(self)
		topPanel:Run("Alpha", .7, 0, 1)
		topPanel:SetSmoothType("Out")
	end)
	
	topPanel.style = CreateFrame("Frame", nil, GameMenuFrame)
	topPanel.style:SetTemplate("Default", true)
	topPanel.style:SetFrameStrata("BACKGROUND")
	topPanel.style:Point("TOPLEFT", topPanel, "BOTTOMLEFT", 0, 1)
	topPanel.style:Point("BOTTOMRIGHT", topPanel, "BOTTOMRIGHT", 0, (E.PixelMode and -4 or -7))
	
	topPanel.style:SetScript("OnShow", function(self)
		topPanel.style:Run("Alpha", .7, 0, 1)
		topPanel.style:SetSmoothType("Out")
	end)
	
	topPanel.style.color = topPanel.style:CreateTexture(nil, 'OVERLAY')
	topPanel.style.color:SetVertexColor(classColor.r, classColor.g, classColor.b)
	topPanel.style.color:SetInside()
	topPanel.style.color:SetTexture(E['media'].MuiFlat)
	
	topPanel.Logo = topPanel:CreateTexture(nil, 'OVERLAY')
	topPanel.Logo:SetSize(285, 128)
	topPanel.Logo:SetPoint("TOP", topPanel, "TOP", 0, -60)
	topPanel.Logo:SetTexture("Interface\\AddOns\\MerathilisUI\\media\\textures\\merathilis_logo.tga")
	
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
