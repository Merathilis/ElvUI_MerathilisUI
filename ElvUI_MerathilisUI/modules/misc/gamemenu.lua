local MER, E, L, V, P, G = unpack(select(2, ...))
local MERG = E:NewModule("mUIGameMenu")
local MERS = E:GetModule("muiSkins");
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local random = random
-- WoW API / Variables
local GameMenuFrame = _G["GameMenuFrame"]
local CreateFrame = CreateFrame
local CreateAnimationGroup = CreateAnimationGroup
local GetScreenWidth, GetScreenHeight = GetScreenWidth, GetScreenHeight
local UIFrameFadeIn = UIFrameFadeIn
local IsAddOnLoaded = IsAddOnLoaded

-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: button, modelHolder, playerModel, npcHolder, npcModel, LibStub

-- Credit for the Class logos: ADDOriN @DevianArt
-- http://addorin.deviantart.com/gallery/43689290/World-of-Warcraft-Class-Logos

local logo = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\mUI1.tga"

local npc = {
	86470, -- Pepe
	16445, -- Terky
	15552, -- Doctor Weavil
	32398, -- King Ping
	82464, -- Elekk Plushie
	71163, -- Unborn Val"kir
	91226, -- Graves
	54128, -- Creepy Crate
	28883, -- Frosty
	61324, -- Baby Ape
	23754, -- Murloc Costume
	34694, -- Gurgli
	54438, -- Murkablo
	85009, -- Murkidan
	68267, -- Cinder Kitten
	51601, -- Moonkin Hatchling
	85283, -- Brightpaw
	103159, -- Baby Winston
}

function MERG:GameMenu()
	-- GameMenu Frame
	if not GameMenuFrame.MUIbottomPanel then
		GameMenuFrame.MUIbottomPanel = CreateFrame("Frame", nil, GameMenuFrame)
		local bottomPanel = GameMenuFrame.MUIbottomPanel
		bottomPanel:SetFrameLevel(0)
		bottomPanel:SetTemplate("Transparent")
		if IsAddOnLoaded("ElvUI_BenikUI") then
			MERS:StyleOutside(bottomPanel)
		end
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

		bottomPanel.Logo = bottomPanel:CreateTexture(nil, "ARTWORK")
		bottomPanel.Logo:SetSize(150, 150)
		bottomPanel.Logo:SetPoint("CENTER", bottomPanel, "CENTER", 0, 0)
		bottomPanel.Logo:SetTexture(logo)
	end

	if not GameMenuFrame.MUItopPanel then
		GameMenuFrame.MUItopPanel = CreateFrame("Frame", nil, GameMenuFrame)
		local topPanel = GameMenuFrame.MUItopPanel
		topPanel:SetFrameLevel(0)
		topPanel:SetTemplate("Transparent")
		topPanel:SetPoint("TOP", E.UIParent, "TOP", 0, 0)
		topPanel:SetWidth(GetScreenWidth() + (E.Border*2))

		topPanel.anim = CreateAnimationGroup(topPanel)
		topPanel.anim.height = topPanel.anim:CreateAnimation("Height")
		topPanel.anim.height:SetChange(GetScreenHeight() * (1 / 4))
		topPanel.anim.height:SetDuration(1.4)
		topPanel.anim.height:SetSmoothing("Bounce")

		topPanel:SetScript("OnShow", function(self)
			self:SetHeight(0)
			self.anim.height:Play()
		end)

		topPanel.factionLogo = topPanel:CreateTexture(nil, "ARTWORK")
		topPanel.factionLogo:SetPoint("CENTER", topPanel, "CENTER", 0, 0)
		topPanel.factionLogo:SetSize(256, 250)
		topPanel.factionLogo:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\classIcons\\CLASS-"..E.myclass)
	end

	-- Use this frame to control the position of the model - taken from ElvUI
	if not modelHolder then
		local modelHolder = CreateFrame("Frame", nil, GameMenuFrame)
		modelHolder:SetSize(150, 150)
		modelHolder:SetPoint("RIGHT", GameMenuFrame, "LEFT", -300, 0)
		modelHolder:SetScript("OnShow", function(self)
			self:ClearAllPoints()
			self:SetPoint("RIGHT", GameMenuFrame, "LEFT", -300, 0)
		end)

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
		npcHolder:SetPoint("LEFT", GameMenuFrame, "RIGHT", 300, 0)
		npcHolder:SetScript("OnShow", function(self)
			self:ClearAllPoints()
			self:SetPoint("LEFT", GameMenuFrame, "RIGHT", 300, 0)
		end)

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
end

function MERG:Initialize()
	if E.db.mui.general.GameMenu then
		self:GameMenu()
	end
end

local function InitializeCallback()
	MERG:Initialize()
end

E:RegisterModule(MERG:GetName(), InitializeCallback)