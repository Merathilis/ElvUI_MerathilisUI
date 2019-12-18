local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("mUIGameMenu")
local MERS = MER:GetModule("muiSkins")
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

	-- BfA
	139073, -- Poda
	139770, -- Taptaf
	140125, -- Miimii
	141941, -- Baa'l
	143160, -- Brutus
	143507, -- Voidwiggler
	143563, -- Cholerian
	143794, -- Scuttle
	143796, -- Barnaby
}

MER.PEPE = {
	[1] = "1246563", -- Pepe (Halloween)
	[2] = "1131783", -- Knight Pepe
	[3] = "1131795", -- Pirate Pepe
	[4] = "1131797", -- Ninja Pepe
	[5] = "1131798", -- Viking Pepe
	[6] = "1534076", -- Illidan Pepe
	[7] = "1386540", -- Traveller Pepe
	[8] = "1859375", -- Underwater Pepe
	[9] = "1861550", -- Troll Pepe
	[10] = "3011956", -- Mecha-Gnom Pepe
	[11] = "3209343", -- Christmas Pepe (8.3)
}

--[[
    0 = idle
    1 = death
    3 = stop
    4 = fast walk
    5 = run
    8 = take a light hit
    9 = take a medium hit
    10 = take a heavy hit
    11-12 = turning
    13 = backing up
    14 = stunned
    26 = attack stance
    43 = swimming
    55 - roar (non-loop)
    56 - idle
    57 - special attack 1H
    58 - special attack 2H
    60 = chat
    61 = eat
    62 = mine ore
    63 = combine tradeskill
    64 - talk_exclamation
    65 - shrug
    66 = bow
    67 = wave
    68 = cheer
    69 = dance
    70 = laugh
    71 - sleep, lie
    72 - idle
    73 = rude
    74 = roar
    75 = kneel
    76 = kiss
    77 = cry
    78 = chicken
    79 - beg, grovel
    80 = applaud
    81 = shout
    82 = flex
    83 = flirt
    84 = point
    87 - shield bash
    89 - sheathe/unsheathe from back
    90 - sheath/unsheathe from waist
    91 - sitting on a mount
    92 - idle
    93 - idle
    94 - idle
    95 - kick (non-loop)
    96 - sit
    97 = sit
    98 - stop
    99 - sleep, lie
    100 - sleep, lie
    101 = get up
    103 - sitting on mount
    104 - sitting on chair
    105 - nocking bow with arrow
    107 - fishing cast
    109 - attack idle with bow
    110 - attack idle with gun or crossbow
    113 = salute
    114 - kneel
    115 - kneel
    116 - stand from kneeling
    117 - shield bash
    118 - special attack 1H
    119 = crouching run
    120 = crouch
    121 - knockdown
    122 - idle
    123 - crafting (loop)
    124 = channel spell
    125 = channel spell
    126 = spin
    127 - idle
    128 - crafting (non-loop)
    129 - stop
    130 - idle
    131 - drown
    132 - drowned
    133 - fishing
    134 - fishing loop
    135 - swimming loop
    136 - mining, blacksmith crafting
    137 = stunned
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

local function Pepe_Model(self)
	local npc = MER.PEPE
	local mod = random(1, #npc)
	local id = npc[mod]

	self:ClearModel()
	self:SetModel(id)
	self:SetSize(150, 150)
	self:SetCamDistanceScale(1)
	self:SetFacing(6)
	self:SetAlpha(1)
	UIFrameFadeIn(self, 1, self:GetAlpha(), 1)
end

function module:GameMenu()
	-- GameMenu Frame
	if not GameMenuFrame.MUIbottomPanel then
		GameMenuFrame.MUIbottomPanel = CreateFrame("Frame", nil, GameMenuFrame)
		local bottomPanel = GameMenuFrame.MUIbottomPanel
		bottomPanel:SetFrameLevel(0)
		bottomPanel:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -E.Border)
		bottomPanel:SetWidth(GetScreenWidth() + (E.Border*2))
		MERS:CreateBD(bottomPanel, .5)
		bottomPanel:Styling()

		bottomPanel.ignoreFrameTemplates = true
		bottomPanel.ignoreBackdropColors = true
		E["frames"][bottomPanel] = true

		bottomPanel.anim = CreateAnimationGroup(bottomPanel)
		bottomPanel.anim.height = bottomPanel.anim:CreateAnimation("Height")
		bottomPanel.anim.height:SetChange(GetScreenHeight() * (1 / 4))
		bottomPanel.anim.height:SetDuration(0.6)

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

		topPanel.ignoreFrameTemplates = true
		topPanel.ignoreBackdropColors = true
		E["frames"][topPanel] = true

		topPanel.anim = CreateAnimationGroup(topPanel)
		topPanel.anim.height = topPanel.anim:CreateAnimation("Height")
		topPanel.anim.height:SetChange(GetScreenHeight() * (1 / 4))
		topPanel.anim.height:SetDuration(0.6)

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

	if not pepeHolder then
		local pepeHolder = CreateFrame("Frame", nil, GameMenuFrame)
		pepeHolder:SetSize(150, 150)
		pepeHolder:SetPoint("BOTTOM", GameMenuFrame, "TOP", 0, -50)

		pepeModel = CreateFrame("PlayerModel", nil, pepeHolder)
		pepeModel:SetPoint("CENTER", pepeHolder, "CENTER")
		pepeModel:SetScript("OnShow", Pepe_Model)
		pepeModel.isIdle = nil
		pepeModel:Show()
	end
end

function module:Initialize()
	if E.db.mui.general.GameMenu then
		self:GameMenu()
		E:UpdateBorderColors()
	end
end

MER:RegisterModule(module:GetName())
