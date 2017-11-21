local MER, E, L, V, P, G = unpack(select(2, ...))
local MERG = E:NewModule("mUIGameMenu")
local MERS = E:GetModule("muiSkins")
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

MER.NPCS = {
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
	123650, -- Shadow
	126579, -- Ghost Shark
	85463, -- Gorefu
	119408, -- "Captain" Klutz
	127956, -- Amalgam of Destruction
	85682, -- Blingtron 4999b
	72285, -- Chi-Chi, Hatchling of Chi-Ji
	67332, -- Darkmoon Eye
	71693, -- Rascal-Bot
	66499, -- Bishibosh
}

--[[
4    - walk
5    - run
26   - attack stance
40   - falling loop
52   - casting loop
55   - roar pose (paused)
60   - chat normal
64   - chat exclaimation
65   - chat shrug
69   - dance
74   - roar
111  - attack ready
119  - stealth walk
120  - stealth standing loop
125  - spell2
138  - craft loop
141  - kneel loop
203  - cannibalize
225  - cower loop
]]--
local Sequences = {26, 52, 69, 111, 225}

local function Player_Model(self)
	local key = random(1,5)
	local emote = Sequences[key]

	self:ClearModel()
	self:SetUnit("player")
	self:SetFacing(6.5)
	self:SetPortraitZoom(0.05)
	self:SetCamDistanceScale(4.8)
	self:SetAlpha(1)
	self:SetAnimation(emote)
	UIFrameFadeIn(self, 1, self:GetAlpha(), 1)
end

local function NPC_Model(self)
	local npc = MER.NPCS
	local mod = random(1, #npc)
	local id = npc[mod]
	local key = random(1,5)
	local emote = Sequences[key]

	self:ClearModel()
	self:SetCreature(id)
	self:SetCamDistanceScale(1)
	self:SetFacing(6)
	self:SetAlpha(1)
	self:SetAnimation(emote)
	UIFrameFadeIn(self, 1, self:GetAlpha(), 1)
end

function MERG:GameMenu()
	-- GameMenu Frame
	if not GameMenuFrame.MUIbottomPanel then
		GameMenuFrame.MUIbottomPanel = CreateFrame("Frame", nil, GameMenuFrame)
		local bottomPanel = GameMenuFrame.MUIbottomPanel
		bottomPanel:SetFrameLevel(0)
		bottomPanel:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -E.Border)
		bottomPanel:SetWidth(GetScreenWidth() + (E.Border*2))
		MERS:CreateBD(bottomPanel, .5)
		bottomPanel:Styling()

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
		topPanel:SetPoint("TOP", E.UIParent, "TOP", 0, 0)
		topPanel:SetWidth(GetScreenWidth() + (E.Border*2))
		MERS:CreateBD(topPanel, .5)
		topPanel:Styling()

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

		playerModel = CreateFrame("PlayerModel", nil, modelHolder)
		playerModel:SetPoint("CENTER", modelHolder, "CENTER")
		playerModel:SetScript("OnShow", Player_Model)
		playerModel.isIdle = nil
		playerModel:SetSize(GetScreenWidth() * 2, GetScreenHeight() * 2) --YES, double screen size. This prevents clipping of models.
		playerModel:Show()
	end

	if not npcHolder then
		local npcHolder = CreateFrame("Frame", nil, GameMenuFrame)
		npcHolder:SetSize(150, 150)
		npcHolder:SetPoint("LEFT", GameMenuFrame, "RIGHT", 300, 0)

		npcModel = CreateFrame("PlayerModel", nil, npcHolder)
		npcModel:SetPoint("CENTER", npcHolder, "CENTER")
		npcModel:SetScript("OnShow", NPC_Model)
		npcModel.isIdle = nil
		npcModel:SetSize(256, 256)
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