local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule('MerathilisUI')
local S = E:GetModule('Skins')

-- Cache global variables
local random = random

local CreateFrame = CreateFrame
local GetScreenWidth, GetScreenHeight = GetScreenWidth, GetScreenHeight
local PlaySound = PlaySound
local UIFrameFadeIn = UIFrameFadeIn

-- Credit for the Class logos: ADDOriN @DevianArt
-- http://addorin.deviantart.com/gallery/43689290/World-of-Warcraft-Class-Logos

local classColor = RAID_CLASS_COLORS[E.myclass]
local logo = "Interface\\AddOns\\MerathilisUI\\media\\textures\\merathilis_logo.tga" -- loads on memory when gamemenu.lua loads and waits to be called. CPU wise it's better than searching for it everytime GameMenu function is called.
local className = E.myclass

local npc = {
	86470, -- Pepe
	16445, -- Terky
	15552, -- Doctor Weavil
	32398, -- King Ping
	82464, -- Elekk Plushie
	72113, -- Carpe Diem
	71163, -- Unborn Val'kir
	91226, -- Graves
	54128, -- Creepy Crate
	28883, -- Frosty
	61324, -- Baby Ape
	23754, -- Murloc Costume
	34694, -- Gurgli
	54438, -- Murkablo
	85009, -- Murkidan
	68267 -- Cinder Kitten
}

function MER:GameMenu()
	-- GameMenu Frame
	if not button then -- a check so that all the stuff is not created again when MER:GameMenu() is called, because the user might use Esc several times
		local button = CreateFrame("Button", "MerConfigButton", GameMenuFrame, "GameMenuButtonTemplate")
		button:Size(GameMenuButtonUIOptions:GetWidth(), GameMenuButtonUIOptions:GetHeight())
		button:SetPoint("TOP", GameMenuButtonUIOptions, "BOTTOM", 0 , -1)
		button:SetScript("OnClick", function() MER:DasOptions() PlaySound("igMainMenuOption") HideUIPanel(GameMenuFrame) end)
		button:SetText("|cffff7d0aMerathilisUI|r")
		
		if E.private.skins.blizzard.enable == true and E.private.skins.blizzard.misc == true then
			S:HandleButton(button)
		end
		
		GameMenuFrame:HookScript("OnShow", function()
			GameMenuFrame:Height(GameMenuFrame:GetHeight() + button:GetHeight())
		end)
	end
	
	if not bottomPanel then
		local bottomPanel = CreateFrame("Frame", nil, GameMenuFrame)
		bottomPanel:SetFrameLevel(0)
		bottomPanel:SetTemplate("Transparent")
		MER:StyleFrame(bottomPanel)
		bottomPanel:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -E.Border)
		bottomPanel:SetWidth(GetScreenWidth() + (E.Border*2))
		
		bottomPanel.anim = CreateAnimationGroup(bottomPanel)
		bottomPanel.anim.height = bottomPanel.anim:CreateAnimation("Height")
		bottomPanel.anim.height:SetChange(GetScreenHeight() * (1 / 4))
		bottomPanel.anim.height:SetDuration(1.4)
		bottomPanel.anim.height:SetSmoothing("Bounce")
		
		bottomPanel:SetScript("OnShow", function(self)
			self:SetHeight(0)
			self.anim.height:Play()
		end)
		
		bottomPanel.Logo = bottomPanel:CreateTexture(nil, 'ARTWORK')
		bottomPanel.Logo:SetSize(285, 128)
		bottomPanel.Logo:SetPoint("TOP", bottomPanel, "TOP", 0, -60)
		bottomPanel.Logo:SetTexture(logo)
	end
	
	if not topPanel then
		local topPanel = CreateFrame("Frame", nil, GameMenuFrame)
		topPanel:SetFrameLevel(0)
		topPanel:SetTemplate("Transparent")
		topPanel:SetPoint("TOP", E.UIParent, "TOP", 0, 0)
		topPanel:SetWidth(GetScreenWidth() + (E.Border*2))
		
		topPanel.style = CreateFrame("Frame", nil, GameMenuFrame)
		topPanel.style:SetTemplate("Default", true)
		topPanel.style:SetFrameStrata("BACKGROUND")
		topPanel.style:SetInside()
		topPanel.style:Point("TOPLEFT", topPanel, "BOTTOMLEFT", 0, 1)
		topPanel.style:Point("BOTTOMRIGHT", topPanel, "BOTTOMRIGHT", 0, (E.PixelMode and -4 or -7))
		
		topPanel.anim = CreateAnimationGroup(topPanel)
		topPanel.anim.height = topPanel.anim:CreateAnimation("Height")
		topPanel.anim.height:SetChange(GetScreenHeight() * (1 / 4))
		topPanel.anim.height:SetDuration(1.4)
		topPanel.anim.height:SetSmoothing("Bounce")
		
		topPanel:SetScript("OnShow", function(self)
			self:SetHeight(0)
			self.anim.height:Play()
		end)
		
		topPanel.style.color = topPanel.style:CreateTexture(nil, 'ARTWORK')
		topPanel.style.color:SetVertexColor(classColor.r, classColor.g, classColor.b)
		topPanel.style.color:SetInside()
		topPanel.style.color:SetTexture(E['media'].MuiFlat)
		
		topPanel.factionLogo = topPanel:CreateTexture(nil, 'ARTWORK')
		topPanel.factionLogo:SetPoint("CENTER", topPanel, "CENTER", 0, 0)
		topPanel.factionLogo:SetSize(250, 250)
		topPanel.factionLogo:SetTexture('Interface\\AddOns\\MerathilisUI\\media\\textures\\classIcons\\CLASS-'..className)
	end
	
	-- Use this frame to control the position of the model - taken from ElvUI
	if not modelHolder then
		local modelHolder = CreateFrame("Frame", nil, GameMenuFrame)
		modelHolder:SetSize(150, 150)
		modelHolder:SetPoint("LEFT", E.UIParent, "LEFT", 400, -10)
		
		playerModel = CreateFrame("PlayerModel", nil, modelHolder)
		playerModel:SetPoint("CENTER", modelHolder, "CENTER")
		playerModel:ClearModel()
		playerModel:SetUnit("player")
		playerModel:SetScript("OnShow", function(self)
			self:SetAlpha(0.5)
			UIFrameFadeIn(self, 1, self:GetAlpha(), 1)
		end)
		playerModel.isIdle = nil
		playerModel:SetSize(GetScreenWidth() * 2, GetScreenHeight() * 2) --YES, double screen size. This prevents clipping of models.
		playerModel:SetCamDistanceScale(4.8)
		playerModel:SetFacing(6.5)
		playerModel:Show()
	end
	
	if not npcHolder then
		local npcHolder = CreateFrame("Frame", nil, GameMenuFrame)
		npcHolder:SetSize(150, 150)
		npcHolder:SetPoint("RIGHT", E.UIParent, "RIGHT", -400, -10)
		
		npcModel = CreateFrame("PlayerModel", nil, npcHolder)
		npcModel:SetPoint("CENTER", npcHolder, "CENTER")
		npcModel:ClearModel()
		npcModel:SetScript("OnShow", function(self)
			local id = npc[random( #npc )]
			self:SetCreature(id)
			self:SetAlpha(0.5)
			UIFrameFadeIn(self, 1, self:GetAlpha(), 1)
		end)
		npcModel.isIdle = nil
		npcModel:SetSize(256, 256)
		npcModel:SetCamDistanceScale(1)
		npcModel:SetFacing(6)
		npcModel:Show()
	end
	
	GameMenuButtonKeybindings:ClearAllPoints()
	GameMenuButtonKeybindings:Point("TOP", MerConfigButton, "BOTTOM", 0, -1)
end

function MER:LoadGameMenu()
	if E.db.muiGeneral.GameMenu then
		self:GameMenu()
	end
end
